# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = APP_CONFIG['base_site_url']
#SitemapGenerator::Sitemap.sitemaps_path = 'system/sitemaps'
SitemapGenerator::Sitemap.public_path = File.join(Rails.root, "public", "system", "sitemaps").to_s

if Metadata::Setting.find_setting('yahoo_app_id').present?
  SitemapGenerator::Sitemap.yahoo_app_id = Metadata::Setting.find_setting('yahoo_app_id').value
end

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host


  add root_path(:format => 'html'), :priority => 0.8, :changefreq => 'daily'
  add stories_path(:format => 'html'), :priority => 0.7, :changefreq => 'daily'
  add newswires_path(:format => 'html'), :priority => 0.5, :changefreq => 'daily'
  add articles_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add users_path(:format => 'html'), :priority => 0.4, :changefreq => 'daily'
  add events_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add forums_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add questions_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add ideas_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add resources_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add galleries_path(:format => 'html'), :priority => 0.6, :changefreq => 'daily'
  add idea_boards_path(:format => 'html'), :priority => 0.5, :changefreq => 'daily'
  add resource_sections_path(:format => 'html'), :priority => 0.5, :changefreq => 'daily'
  add prediction_groups_path(:format => 'html'), :priority => 0.5, :changefreq => 'daily'
  add classifieds_path(:format => 'html'), :priority => 0.7, :changefreq => 'daily'
  add cards_path(:format => 'html'), :priority => 0.5, :changefreq => 'daily'
  
  Content.active.all.each do |a|
    add story_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.6
  end

  Idea.active.all.each do |a|
    add idea_path(a, :format => 'html'), :lastmod => a.updated_at
  end

  IdeaBoard.active.all.each do |a|
    add idea_board_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.4
  end

  Event.active.all.each do |a|
    add event_path(a, :format => 'html'), :lastmod => a.updated_at
  end

  Resource.all.each do |a|
    add resource_path(a, :format => 'html'), :lastmod => a.updated_at
  end

  ResourceSection.active.all.each do |a|
    add resource_section_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.4
  end

  Question.all.each do |a|
    add question_path(a, :format => 'html'), :lastmod => a.updated_at
  end

  Forum.all.each do |a|
    add forum_path(a, :format => 'html'), :lastmod => a.updated_at
  end

  PredictionGroup.active.all.each do |a|
    add prediction_group_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.4
  end

  PredictionQuestion.active.all.each do |a|
    add prediction_question_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.4
  end
  
  Classified.active.all.each do |a|
    add classified_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.4
  end

  Article.published.all.each do |a|
    add article_path(a, :format => 'html'), :lastmod => a.updated_at, :priority => 0.4
  end

  Feed.active.all.each do |f|
    add feed_newswire_path(f, :format => 'html'), :lastmod => f.updated_at, :priority => 0.4
  end

  Gallery.all.each do |g|
    add gallery_path(g, :format => 'html'), :lastmod => g.updated_at, :priority => 0.4
  end

  # Static pages
  add faq_path(:format => 'html'), :priority => 0.2, :changefreq => 'monthly'
  add about_path(:format => 'html'), :priority => 0.2, :changefreq => 'monthly'
  add terms_path(:format => 'html'), :priority => 0.2, :changefreq => 'monthly'
  add contact_us_path(:format => 'html'), :priority => 0.2, :changefreq => 'monthly'
end

# Including Sitemaps from Rails Engines.
#
# These Sitemaps should be almost identical to a regular Sitemap file except
# they needn't define their own SitemapGenerator::Sitemap.default_host since
# they will undoubtedly share the host name of the application they belong to.
#
# As an example, say we have a Rails Engine in vendor/plugins/cadability_client
# We can include its Sitemap here as follows:
#
# file = File.join(Rails.root, 'vendor/plugins/cadability_client/config/sitemap.rb')
# eval(open(file).read, binding, file)


# Unfortunately, this does not work here.
# The actual sitemap creation happens after this file, so you're not
# guaranteed to have a file to upload, and you're guaranteed to not
# be uploading the latest version of the sitemap.
=begin
if File.exist?(File.join(Rails.root, "config", "s3.yml"))
  require 'aws/s3'
  
  # Load credentials
  s3_options = YAML.load_file(File.join(Rails.root, "config", "s3.yml"))[Rails.env].symbolize_keys
  bucket = s3_options[:bucket]
  s3_options.delete(:bucket)
  
  # Establish S3 connection
  AWS::S3::Base.establish_connection!(s3_options)
  
  ["sitemap1.xml.gz", "sitemap_index.xml.gz"].each do |file_name|
    path = "/sitemaps/#{file_name}"
    file = File.new(File.join(Rails.root, "public", "system", "sitemaps", file_name))
    begin
      AWS::S3::S3Object.store(path, file, bucket, :access => :public_read)
      
    rescue AWS::S3::NoSuchBucket => e
      AWS::S3::Bucket.create(bucket)
      retry
    rescue AWS::S3::ResponseError => e
      raise
    end
    puts "Saved #{file_name} to S3"
  end
end
=end
