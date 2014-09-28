require 'spec_helper'

RSpec.describe ActiveRecord::TimeScope do
  describe "::create_time_scopes" do
    subject {
      create_tmp_model foo_at: :datetime, bar_on: :date, xxx_time: :datetime, yyy_date: :date, zzz: :date do
        create_time_scopes
      end
    }
    it do
      %w(foo bar xxx yyy).each do |key|
        is_expected.to respond_to "#{key}_before"
        is_expected.to respond_to "#{key}_after"
        is_expected.to respond_to "#{key}_within"
      end
      %w(zzz).each do |key|
        is_expected.not_to respond_to "#{key}_before"
        is_expected.not_to respond_to "#{key}_after"
        is_expected.not_to respond_to "#{key}_within"
      end
    end
  end
  describe "::create_time_scope" do
    subject {
      create_tmp_model zzz: :date do
        create_time_scope :www, :zzz
      end
    }
    it do
      is_expected.to respond_to :www_before
      is_expected.to respond_to :www_after
      is_expected.to respond_to :www_within
      is_expected.not_to respond_to :zzz_before
      is_expected.not_to respond_to :zzz_after
      is_expected.not_to respond_to :zzz_within
    end
  end
  describe "::create_time_range_scope" do
    subject {
      create_tmp_model aaa: :date, bbb: :date do
        create_time_range_scope :xxx, :aaa, :bbb
      end
    }
    it do
      is_expected.to respond_to :xxx_before
      is_expected.to respond_to :xxx_after
      is_expected.to respond_to :xxx_within
      is_expected.not_to respond_to :aaa_before
      is_expected.not_to respond_to :aaa_after
      is_expected.not_to respond_to :aaa_within
      is_expected.not_to respond_to :bbb_before
      is_expected.not_to respond_to :bbb_after
      is_expected.not_to respond_to :bbb_within
    end
  end
end
