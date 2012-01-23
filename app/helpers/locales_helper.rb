module LocalesHelper

  def generic_posted_by item, user = nil, date = nil
    user ||= item.item_user
    posted_by item, :user => user
  end

  def stories_posted_by item, user = nil, format = nil
    user ||= item.item_user
    posted_by item, :user => user, :date => true, :format => nil
  end

  def user_posted_item item, user = nil
    user ||= item.item_user
    I18n.translate('user_posted_item', :fb_name => local_linked_profile_name(user, :only_path => false, :format => 'html'), :title => link_to(item.item_title, polymorphic_url(item.item_link,:only_path => false) ), :date => timeago(item.created_at)).html_safe
  end

end
