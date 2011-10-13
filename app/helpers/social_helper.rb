module SocialHelper

  def add_this item
    render :partial => "shared/add_this", :locals => { :cache_id => item.cache_id }
  end
  
end
