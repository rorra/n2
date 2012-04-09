require 'aws'

class SitemapWorker

  @queue = :sitemaps

  def self.perform()
    app_settings_file = "#{Rails.root}/config/application_settings.yml"
    site_url = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file(app_settings_file)[Rails.env])['base_site_url']
    SitemapGenerator::Sitemap.default_host = site_url
    SitemapGenerator::Sitemap.verbose = false
    SitemapGenerator::Sitemap.create
    self.upload_sitemaps_to_s3
    SitemapGenerator::Sitemap.ping_search_engines  
  end

  def self.upload_sitemaps_to_s3
    if File.exist?(File.join(Rails.root, "config", "s3.yml"))
      # Load credentials
      s3_options = YAML.load_file(File.join(Rails.root, "config", "s3.yml"))[Rails.env].symbolize_keys
      bucket = s3_options[:bucket]
      s3_options.delete(:bucket)

      # Establish S3 connection
      #AWS::S3::Base.establish_connection!(s3_options)
      s3 = AWS::S3.new(:access_key_id => s3_options[:access_key_id], :secret_access_key => s3_options[:secret_access_key])

      s3.buckets.create(bucket) unless s3.buckets[bucket.to_sym].exists?
      s3_bucket = s3.buckets[bucket.to_sym]

      ["sitemap1.xml.gz", "sitemap_index.xml.gz"].each do |file_name|
        path = "/sitemaps/#{file_name}"
        file = File.new(File.join(Rails.root, "public", "system", "sitemaps", file_name))

        obj = s3_bucket.objects[path]
        obj.write(file.read, :acl => :public_read)

        puts "Saved #{file_name} to S3"
      end
    end
  end

end
