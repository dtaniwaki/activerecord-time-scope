require_relative 'scope_proxy'

module ActiveRecord
  module TimeScope
    class TimeProxy < ScopeProxy
      def initialize(model, column_name)
        @model = model
        @column_name = column_name
      end

      def before(time, opts = {})
        operator = opts[:include_equal].to_s != '' ? '=<' : '<'
        @model.where("#{@column_name} #{operator} ?", time)
      end

      def after(time, opts = {})
        operator = opts[:include_equal].to_s != '' ? '=<' : '<'
        @model.where("? #{operator} #{@column_name}", time)
      end

      def within(from, to, from_opts = {}, to_opts = {})
        from_operator = from_opts[:include_equal].to_s != '' ? '=<' : '<'
        to_operator = to_opts[:include_equal].to_s != '' ? '=<' : '<'
        @model.where("? #{from_operator} #{@column_name} AND #{@column_name} #{to_operator} ?", from, to)
      end
    end
  end
end
