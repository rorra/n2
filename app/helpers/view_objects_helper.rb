module ViewObjectsHelper

  def action_links item
    links = []
    item.action_links.each do |link_lambda|
      links << self.instance_exec(item, &link_lambda)
    end
=begin
    if item.is_a? Newswire
      links << publish_newswire(item)
      links << read_newswire(item)
    end
    if item.respond_to? :comments
    	links << comment_link(item)
    end
=end
    links.join("&nbsp; | &nbsp;").html_safe
  end
  
  def item_text item
    if item.is_a? Article
      raw item.preamble.present? ? item.preamble : item.item_description
    else
      item.item_description
    end
  end

  def item_model_link item
    link_to item.model_index_name, send(item.model_index_url_name)
  end

  def posted_by item, opts = {}
    include_date = opts[:date] || opts[:full] || false
    include_topic = opts[:topic] || opts[:full] || false
    format = opts[:format] || nil
    include_via = opts[:source_text]
    user = opts[:user] || item.item_user

    locale = []
    interpolation_args = {}

    if item.respond_to?(:twitter_item?) and item.twitter_item?
      locale << 'tweeted'
    elsif item.is_a? Article or (item.is_a? Content and item.is_article?)
      locale << 'written'
    end

    locale << 'by'
    if format
      interpolation_args[:name] = local_linked_profile_name(user, :format => format)
    else
      interpolation_args[:name] = local_linked_profile_name(user)
    end

    if include_topic
    	locale << 'in_topic'
    	interpolation_args[:topic] = item_model_link(item)
    end

    if include_date
    	locale << 'ago'
    	interpolation_args[:date] = timeago(item.created_at)
    end

    if include_via
      locale << 'via'
    	interpolation_args[:source] = include_via
    	interpolation_args[:date] = timeago(item.created_at)
    end

    # TODO:: add this in?
    # opts[:vt] ? opts[:vt].t(...) : I18n.translate(...)
    I18n.translate("generic.posted.#{locale.join('_')}", interpolation_args).html_safe
  end
  def posted_by_with_date(item) posted_by(item, :date => true) end
  def posted_by_via(item, source_text) posted_by(item, :source_text => source_text) end
  def posted_by_with_topic(item) posted_by(item, :topic => true) end
  def posted_by_with_date_and_topic(item) posted_by(item, :date => true, :topic => true) end

  def comment_link item
    [
      content_tag(:span, item.comments_count, :class => "count"),
      link_to(I18n.translate("generic.action_links.comments_title"), item)
    ].join(' ').html_safe
  end

  def answer_link item
    if item.answers_count > 0
      answer_string = item.answers_count == 1 ? "answer" : "answers"
      [
        content_tag(:span, item.answers_count, :class => "count"),
        link_to(I18n.translate('answers_count', :answer_string => answer_string), item)
      ].join(' ').html_safe
    else 
      link_to(I18n.translate('answer_question'), item)
    end
  end

  def vote_link item
    # Add wrapper span tag for vote link ajax purposes
    content_tag(:span,
      [
        link_to('Like', like_item_path(item.class.name.foreign_key.to_sym => item), :class => "voteUp"),
        content_tag(:span, item.votes_tally, :class => "count")
      ].join(' ').html_safe)
  end

  def tally_link item
    # Add wrapper span tag for vote link ajax purposes
    count = ItemAction.tally_for_item item
    content_tag(:span,
                [
                 content_tag(:span, count, :class => "count"),
                 link_to('Points', item)
                ].join(' ').html_safe)
  end

  def post_something klass_name, css_class = "float-right"
    klass = klass_name.constantize
    link_to(I18n.translate("generic.post.#{klass_name.underscore}".to_sym, :default => "generic.post_something".to_sym), send(klass.model_new_url_name), :class => "button-panel-bar #{css_class}")
  end

  def publish_newswire item
    link_to(I18n.translate('post_newswire', :site_title => get_setting('site_title').try(:value) ), new_story_path(:newswire_id => item, :only_path => false) )
  end
  
  def read_newswire item
    link_to(I18n.translate('read_newswire'), item.url, :target => "_cts")
  end

  def newswire_via item
    I18n.translate('generic.action_links.via', :name => item.feed.title)
  end

  def gallery_name view_object
    if view_object.setting.kommands.any? and view_object.setting.kommands.first[:method_name].present?
    	"#{view_object.setting.kommands.first[:method_name].titleize} Gallery"
    else
    	"Media gallery"
    end
  end
end
