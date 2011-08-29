require 'cgi'

module StoriesHelper

  def story_source_link(story)
    return link_to(URI.parse(story.url).host.gsub("www.",""), story.url)
  end
  
  def source_link(story)
    link_to story.source.name, "http://#{story.source.url}"
  end

  def stories_posted_by_via story
    posted_by_via story, (story.source.present? ? source_link(story) : story_source_link(story))
  end

  def sanitize_title text
    sanitize CGI.unescapeHTML(text), :tags => %w(&amp;)
  end
end
