require_relative 'scope_proxy'

module ActiveRecord
  module TimeScope
    class TimeRangeProxy < ScopeProxy
      def initialize(model, column_name1, column_name2)
        @model = model
        @column_name1 = column_name1
        @column_name2 = column_name2
      end

      def before(time, opts = {})
        operator = opts[:include_equal].to_s != '' ? '<=' : '<'
        @model.where("#{@column_name1} #{operator} ? AND #{@column_name2} #{operator} ?", time, time)
      end

      def after(time, opts = {})
        operator = opts[:include_equal].to_s != '' ? '<=' : '<'
        @model.where("? #{operator} #{@column_name1} AND ? #{operator} #{@column_name2}", time, time)
      end

      def within(from, to, from_opts = {}, to_opts = {})
        from_operator = from_opts[:include_equal].to_s != '' ? '<=' : '<'
        to_operator = to_opts[:include_equal].to_s != '' ? '<=' : '<'
        @model.where("? #{from_operator} #{@column_name1} AND #{@column_name2} #{to_operator} ?", from, to)
      end

      def at(dt, opts = {})
        operator = opts[:include_equal].to_s != '' ? '<=' : '<'
        @model.where("#{@column_name1} #{operator} ? AND ? #{operator} #{@column_name2}", dt, dt)
      end
      alias_method :on, :at
    end
  end
end
