class SitemapWorker
  @queue = :sitemaps

  def self.perform()
    SitemapGenerator::Sitemap.verbose = false
    SitemapGenerator::Sitemap.create
    SitemapGenerator::Sitemap.ping_search_engines  
  end

end
