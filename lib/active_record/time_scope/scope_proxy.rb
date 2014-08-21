module ActiveRecord
  module TimeScope
    class ScopeProxy
      def new(*args)
        @proxies ||= {}
        @proxies[args] ||= super(*args)
      end
    end
  end
end
