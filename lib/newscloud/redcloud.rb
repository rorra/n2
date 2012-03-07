module Newscloud
  module Redcloud

    def self.create(server = nil, namespace = nil)
      server ||= APP_CONFIG['redis']
      namespace ||= APP_CONFIG['namespace'] || 'newscloud'
      host, port, db = server.split(':')
      redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
      Redis::Namespace.new(namespace.to_sym, :redis => redis)
    end

    def self.expire_sets(sets)
      sets.each do |set|
        keys = self.redis.smembers(set)
        keys.each do |key|
          view_object = ViewObject.find_by_redis_key key
          if view_object
            view_object.expire
          else
            self.redis.del(set)
          end
        end
      end
    end

    def self.expire_views()
      ["views/*", "view-tree*"].map do |wkeys|
        self.redis.keys(wkeys).map do |key|
          self.redis.del(key)
        end.size
      end
    end

    def self.expire_locales()
      I18n::Backend::Locale.all.map(&:code).map do |locale|
        self.redis.keys("#{locale}:*").map do |translation|
          self.redis.del(translation)
        end.size
      end
    end

    def self.redis
      @redis ||= self.create
    end

  end
end
