
#
# Base Newscloud Sweeper; extend from this
#
class NewscloudSweeper < ActionController::Caching::Sweeper
  def expire(item = nil) end
  def expire_all(item = nil) end
  def self.expire(item = nil) end
  def self.expire_all(item = nil) end

  def self.expire_class klass, namespace = nil
    namespace ||= '*'
    key = "#{klass.name.downcase}:view_object_namespace_deps:#{namespace}"
    keys = Newscloud::Redcloud.redis.keys(key)

    #return Newscloud::Redcloud.redis.sunion(*(Newscloud::Redcloud.redis.keys(key))).map {|vo_name| vo_name.split(/:/).inject(nil) {|m,id| m.nil? ? id.classify.constantize : m.find(id) } }
    if keys.any?
      Newscloud::Redcloud.redis.sunion(*(keys)).each do |key_name|
        if key_name =~ /^view_object:([0-9]+)$/
          view_object = ViewObject.find_by_id($1)
          view_object.uncache_deps if view_object
        end
      end
    end
  end

  def self.expire_new_item_widgets
    [Vote, PfeedItem, ItemAction, ItemScore].each do |klass|
      self.expire_class(klass)
    end
  end

  def self.expire_instance item
    keys = Newscloud::Redcloud.redis.keys(item.model_deps_key)
    if keys.any?
      Newscloud::Redcloud.redis.sunion(item.model_deps_key).each do |key_name|
        if key_name =~ /^view_object:([0-9]+)$/
          view_object = ViewObject.find_by_id($1)
          view_object.uncache_deps if view_object
        end
      end
    end

    # TODO:: stop this
    self.expire_new_item_widgets
    return self.expire_class(item.class)
  end
end
