# Methods added to this helper will be available to all templates in the application.
module AdminHelper

  def gen_index_page(collection, model, fields, options = {})
    config = options[:config] || OpenStruct.new

    set_model_vars model

    html = []
    html << "<br /><h1>#{@model_list_name} List</h1"
    html << "<br />"

    html << "<h2>#{gen_new_link model}</h2>" if !config.actions || config.actions.include?(:new)
    if config.index_links and config.index_links.any?
      config.index_links.each do |lambda_link|
        html << "<h2>" + self.instance_exec(&lambda_link) + "</h2>"
      end
    end

    html << gen_table(collection, model, fields, options)
    html.join.html_safe
  end

  def gen_show_page(item, fields, options = {})
    set_model_vars item.class

    html = []
    html << "<h1>#{@model_name} Details</h1>"
    html << "<hr />"
    fields.each do |field|
      html << "<p>#{field.to_s.titleize}: #{field_value(item, field, options[:associations])}</p>"
    end
    html << "<br />"
    html << "<p>Actions: #{admin_links(item, options)}</p>"
    html << "<br />"

    html.join.html_safe
  end

  def gen_new_link model
    set_model_vars model
    unless model.name == 'Topic'
      link_to "New #{@model_name}", new_polymorphic_path([:admin, model])
    end
  end

  def gen_table(collection, model, fields, options = {})
    set_model_vars model

    html = []
    model_list_name = @model_list_name
    model_id = @model_id

    if collection.empty?
      html << "<p>No items found</p>"
    else
      html << will_paginate(collection) if options[:paginate]

      unless @search.nil?
        # This is the filtering for the table
        html << search_form_for(@search, :url => [:search, :admin, @model_id], :html => {:method => :post, :id => 'form_filter'}) do |f|
          setup_search_form(f)
          output = "<fieldset>"
          output << f.grouping_fields do |g|
            render_search_grouping_fields(g, [])
          end
          output << button_to_add_fields('Add Condition Group', f, :grouping)
          output << "</fieldset>"
          output << f.submit
          output.html_safe
        end
      end

      html << "<table id='#{model_id}-table' class='admin-table'>"
      html << "<thead>"
      html << "<tr>"
      fields.each { |field| html << "<th>#{@search.nil? ? field.to_s.titleize : (sort_link(@search, field) rescue field.to_s.titleize)}</th>" }
      html << "<th>Actions</th>"
      html << "</tr>"
      html << "</thead>"
      html << "<tbody>"
      collection.each do |item|
        class_name = (item.moderatable? and item.blocked?) ? 'admin-blocked' : ''
        html << "<tr class='#{class_name} #{cycle('odd', 'even')}'>"
        fields.each do |field|
          html << "<td>#{field_value(item, field, options[:associations])}</td>"
        end
        html << "<td>#{admin_links(item, options)}</td>"
        html << "</tr>"
      end
      html << "</tbody>"
      html << "</table>"
      html << will_paginate(collection) if options[:paginate]
    end

    html.join.html_safe
  end

  def admin_links(item, options)
    config = options[:config] || OpenStruct.new

    links = []
    links << link_to_unless_current('View', [:admin, item]) { link_to "Back", url_for(send("admin_#{item.class.name.tableize.gsub(/\//, '_')}_url")) } if !config.actions || config.actions.include?(:show)
    links << link_to('Edit', edit_polymorphic_path([:admin, item])) if !config.actions || config.actions.include?(:edit)

    if item.moderatable?
      links << link_to(item.blocked? ? 'UnBlock' : 'Block', admin_block_path(item.class.name.foreign_key.to_sym => item))
      if item.class.name != 'RelatedItem' and item.class.name != 'IdeaBoard' and item.class.name != 'ResourceSection'
        #links << link_to(item.featured? ? 'UnFeature' : 'Feature', admin_feature_path(item.class.name.foreign_key.to_sym => item))
        #links << link_to('Flag', admin_flag_item_path(item.class.name.foreign_key.to_sym => item))
      end
    end
    if item.class.name == 'User'
      links << link_to('FB Profile', "http://www.facebook.com/profile.php?id=#{item.fb_user_id}", :target => "_fb")
    end

    if item.class.name == 'PredictionGroup'
      links << link_to('Approve', approve_admin_prediction_group_path(item)) unless item.is_approved?
    end

    if item.class.name == 'PredictionQuestion'
      links << link_to('Approve', approve_admin_prediction_question_path(item)) unless item.is_approved?
    end

    if item.class.name == 'PredictionResult'
      links << link_to('Accept', accept_admin_prediction_result_path(item)) unless item.is_accepted?
    end

    if item.class.name == 'DashboardMessage'
      links << link_to('Send', send_global_admin_dashboard_message_path(item)) unless item.sent?
      links << link_to('Clear', clear_global_admin_dashboard_message_path(item)) if item.sent?
    end

    if item.class.name == 'TweetStream'
      links << link_to('Fetch New Tweets', fetch_new_tweets_admin_tweet_stream_path(item))
    end

    if item.class.name == 'Feed'
      #links << link_to('Destroy', [:admin, item], :confirm => 'Are you sure?', :method => :delete)
      links << link_to('Fetch New items', fetch_new_admin_feed_path(item))
    end

    if item.class.name == 'Flag'
      links << link_to(item.flaggable.blocked? ? 'UnBlock' : 'Block', admin_block_path(item.flaggable.class.name.foreign_key.to_sym => item.flaggable, :back_path => url_for([:admin, item])))
    end

    links.join ' | '
  end

  def set_model_vars model
    @model_list_name ||= model.name.tableize.titleize
    @model_name ||= model.name.titleize
    @model_id ||= model.name.tableize.dasherize
  end

  def association_exists?(field, associations)
    [:belongs_to, :has_one].each do |association|
      if associations[association].present?
        associations[association].each do |name, field_name|
          return name if field_name == field
        end
      end
    end
    return false
  end

  def field_value(item, field, associations = nil)
    return item.send(field).to_s unless associations.present?
    association = association_exists?(field, associations)
    if association and item.send(association).present?
      "#{link_to h(item.send(association).to_s), [:admin, item.send(association)]}"
    else
      item.send(field).to_s
    end
  end



  def setup_search_form(builder)
    fields = builder.grouping_fields builder.object.new_grouping, :object_name => 'new_object_name', :child_index => 'new_grouping' do |f|
      render_search_grouping_fields(f)
    end

    content_for :document_ready, %Q{
    var search = new Search({grouping: '#{escape_javascript(fields)}'});
    $('button.add_fields').live('click', function() {
      search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
      return false;
    });
    $('button.remove_fields').live('click', function() {
      search.remove_fields(this);
      return false;
    });
    $('button.nest_fields').live('click', function() {
      search.nest_fields(this, $(this).data('fieldType'));
      return false;
    });
  }.html_safe
  end

  def render_grouping_fields(f)
    output = ''
    f.grouping_fields do |g|
      g.condition_fields do |c|
        c.attribute_fields do |a|
          output << a.attribute_select
          output << f.predicate_select
          a.value_fields do |v|
            output << f.text_field(:value)
          end
        end
      end
    end
    output
  end

  def render_search_grouping_fields(f, associations = [])
    output = "<fieldset class='fields' data-object-name='#{ f.object_name }'>"
    output << "<legend>Match #{ f.combinator_select } conditions #{ button_to_remove_fields('remove', f) }</legend>"

    output << f.condition_fields do |c|
      render_search_condition_fields(c, associations)
    end
    output << button_to_add_fields('Add Condition', f, :condition)

    f.grouping_fields.each do |g|
      output << render_search_grouping_fields(g, conditions)
    end
    output << button_to_nest_fields("Add Condition Group", :grouping)

    output << "</fieldset>"
    output.html_safe
  end

  def render_search_condition_fields(f, associations = [])
    output = "<fieldset class='fields condition' data-object-name='#{ f.object_name }'>"
    output << "<legend>Condition #{ button_to_remove_fields 'remove', f }</legend>"
    output << f.attribute_fields do |a|
      render_search_attribute_fields(a, associations)
    end
    output += f.predicate_select
    output << f.value_fields do |v|
      render_search_value_fields(v)
    end
    output << button_to_add_fields('Add Value', f, :value)
    output << '</fieldset>'
    output.html_safe
  end

  def render_search_attribute_fields(f, associations = [])
    f.attribute_select :associations => associations
  end

  def render_search_value_fields(f)
    "<span class='fields value' data-object-name='#{f.object_name}'>#{f.text_field :value}</span>".html_safe
  end


  def button_to_remove_fields(name, f)
    content_tag :button, name, :class => 'remove_fields'
  end

  def button_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    fields = f.send("#{type}_fields", new_object, :child_index => "new_#{type}") do |builder|
      m = self.method("render_search_#{type.to_s}_fields")
      m.call builder
    end

    content_tag :button, name, :class => 'add_fields', 'data-field-type' => type, 'data-content' => "#{fields}"
  end

  def button_to_nest_fields(name, type)
    content_tag :button, name, :class => 'nest_fields', 'data-field-type' => type
  end


end
