module Newscloud
  module Redcloud

    def self.create(server = nil, namespace = nil)
      server ||= APP_CONFIG['redis']
      namespace ||= APP_CONFIG['namespace'] || 'newscloud'
      host, port, db = server.split(':')
      redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
      @redis = Redis::Namespace.new(namespace.to_sym, :redis => redis)
    end

    def self.expire_sets(sets)
      sets.each do |set|
        keys = $redis.smembers(set)
        keys.each do |key|
          view_object = ViewObject.find_by_redis_key key
          if view_object
            view_object.expire
          else
            $redis.del(set)
          end
        end
      end
    end

  end
end
