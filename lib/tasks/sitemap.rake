require 'aws'

class Rake::Task
  def replace &block
    @actions.clear
    prerequisites.clear
    enhance &block
  end
end

namespace 'sitemap' do
  desc 'Upload the sitemap files to S3 (using your configuration in config/s3.yml)'
  task :upload_to_s3 => :environment do
    if File.exist?(File.join(Rails.root, "config", "s3.yml"))

      # Load credentials
      s3_options = YAML.load_file(File.join(Rails.root, "config", "s3.yml"))[Rails.env].symbolize_keys
      bucket_name = s3_options[:bucket]
      s3_options.delete(:bucket)

      # Establish S3 connection
      AWS.config(s3_options)

      Dir.entries(File.join(Rails.root, "public", "system", "sitemaps")).each do |file_name|
        next if ['.', '..'].include? file_name
        path = "sitemaps/#{file_name}"
        file = File.join(Rails.root, "public", "system", "sitemaps", file_name)

        begin
          s3 = AWS::S3.new
          bucket = s3.buckets.create(bucket_name)


          object = bucket.objects[path]
          object.write(:file => file)
        rescue Exception => e
          raise
        end
        puts "Saved #{file_name} to S3"
      end
    end
  end
end

Rake::Task["sitemap:create"].enhance do
  Rake::Task["sitemap:upload_to_s3"].invoke
end

Rake::Task[:'sitemap:refresh'].replace do
  if File.exist?(File.join(Rails.root, "config", "s3.yml"))
    s3_options = YAML.load_file(File.join(Rails.root, "config", "s3.yml"))[Rails.env].symbolize_keys
    bucket_name = s3_options[:bucket]
    SitemapGenerator::Sitemap.ping_search_engines(:sitemap_index_url => "https://#{bucket_name}.s3.amazonaws.com/sitemaps/sitemap_index.xml.gz")
  else
    SitemapGenerator::Sitemap.ping_search_engines
  end
end
