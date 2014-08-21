require 'active_record'
require 'active_record/time_scope.rb'

ActiveRecord::Base.send :include, ActiveRecord::TimeScope

