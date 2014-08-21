require 'spec_helper'

RSpec.describe "time_range_spec" do
  klass = create_tmp_model "TestClass", "test_classes", foo_at: :datetime, bar_on: :date, xxx_time: :datetime, yyy_date: :date, zzz: :date do
    create_time_scope :www, :zzz
  end

  describe "::create_time_scope" do
    subject { klass }
    it do
      is_expected.to respond_to :www_before
      is_expected.to respond_to :www_after
      is_expected.to respond_to :www_within
    end
  end
  describe "::inherited" do
    subject { klass }
    it do
      %w(foo bar xxx yyy).each do |verb|
        is_expected.to respond_to "#{verb}_before"
        is_expected.to respond_to "#{verb}_after"
        is_expected.to respond_to "#{verb}_within"
      end
    end
  end
  describe "::foo_before" do
    subject { klass.foo_before(time) }
    let(:time) { DateTime.now }
    context "foo < time" do
      let!(:model) { klass.create! foo_at: time + 1.days }
      it { is_expected.to eq [] }
    end
    context "time < foo" do
      let!(:model) { klass.create! foo_at: time - 1.days }
      it { is_expected.to eq [model] }
    end
  end
  describe "::foo_after" do
    subject { klass.foo_after(time) }
    let(:time) { DateTime.now }
    context "foo < time" do
      let!(:model) { klass.create! foo_at: time + 1.days }
      it { is_expected.to eq [model] }
    end
    context "time < foo" do
      let!(:model) { klass.create! foo_at: time - 1.days }
      it { is_expected.to eq [] }
    end
  end
  describe "::foo_within" do
    subject { klass.foo_within(time - 2.days, time + 2.days) }
    let(:time) { DateTime.now }
    context "foo < -2 days < +2 days" do
      let!(:model) { klass.create! foo_at: time - 3.days }
      it { is_expected.to eq [] }
    end
    context "-2 days < foo < +2 days" do
      let!(:model) { klass.create! foo_at: time }
      it { is_expected.to eq [model] }
    end
    context "-2 days < +2 days < foo" do
      let!(:model) { klass.create! foo_at: time + 3.days }
      it { is_expected.to eq [] }
    end
  end
end
