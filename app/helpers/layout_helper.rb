module LayoutHelper

  def item_meta_tags item = nil
    item ||= get_current_meta_item
    return nil unless item

    metas = [
             ["og:title", item.item_title],
             ["og:type", "article"],
             ["og:url", base_url(polymorphic_path(item.item_link))],
             ["og:image", external_thumb_image(item)],
             ["og:site_name", get_setting_value('site_title')],
             ["og:description", item.item_description]
            ]
    
    if APP_CONFIG['omniauth']['providers'] and APP_CONFIG['omniauth']['providers']['facebook']
      metas << ["fb:app_id", APP_CONFIG['omniauth']['providers']['facebook']['key']]
    end
    metas.map {|m| meta_tag(*m) }.join("\n").html_safe
  end

  def meta_tag tag, content
    content_tag(:meta, nil, :property => tag, :content => content)
  end
  
end
