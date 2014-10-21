require 'active_record/time_scope/time_proxy'
require 'active_record/time_scope/time_range_proxy'

module ActiveRecord
  module TimeScope
    TIME_POSTFIX_REGEXP = /_(at|on|time|date)$/

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def create_time_scopes
        return unless table_exists?
        column_names.each do |cn|
          verb = cn.sub TIME_POSTFIX_REGEXP, ''
          next if verb == cn
          create_time_scope verb, cn
        end
      end

      def create_time_scope(verb, name)
        model = self
        name = "#{table_name}.#{name}"
        scope "#{verb}_before", ->(time, opts = {}){ TimeProxy.new(model, name).before(time, opts) }
        scope "#{verb}_after", ->(time, opts = {}){ TimeProxy.new(model, name).after(time, opts) }
        scope "#{verb}_within", ->(from, to, from_opts = {}, to_opts = {}){ TimeProxy.new(model, name).within(from, to, from_opts, to_opts) }
      end

      def create_time_range_scope(verb, from_name, to_name)
        model = self
        from_name = "#{table_name}.#{from_name}"
        to_name = "#{table_name}.#{to_name}"
        model.scope "#{verb}_before", ->(time, opts = {}){ TimeRangeProxy.new(model, from_name, to_name).before(time, opts) }
        scope "#{verb}_after", ->(time, opts = {}){ TimeRangeProxy.new(model, from_name, to_name).after(time, opts) }
        scope "#{verb}_within", ->(from, to, from_opts = {}, to_opts = {}){ TimeRangeProxy.new(model, from_name, to_name).within(from, to, from_opts, to_opts) }
      end
    end
  end
end
