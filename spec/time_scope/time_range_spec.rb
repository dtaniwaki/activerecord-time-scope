require 'spec_helper'

RSpec.describe ActiveRecord::TimeScope::TimeRangeProxy do
  klass = create_tmp_model foo: :datetime, bar: :datetime do
    create_time_range_scope :wow, :foo, :bar
  end

  describe "::wow_before" do
    subject { klass.__send__("wow_before", time) }
    let(:time) { DateTime.now }
    context "foo & bar < time" do
      let!(:model) { klass.create! foo: time - 2.days, bar: time - 1.days }
      it { is_expected.to eq [model] }
    end
    context "time < foo & bar" do
      let!(:model) { klass.create! foo: time + 1.days, bar: time + 2.days }
      it { is_expected.to eq [] }
    end
    context "foo < time < bar" do
      let!(:model) { klass.create! foo: time - 1.days, bar: time + 1.days }
      it { is_expected.to eq [] }
    end
  end
  describe "::wow_after" do
    subject { klass.__send__("wow_after", time) }
    let(:time) { DateTime.now }
    context "foo & bar < time" do
      let!(:model) { klass.create! foo: time - 2.days, bar: time - 1.days }
      it { is_expected.to eq [] }
    end
    context "time < foo & bar" do
      let!(:model) { klass.create! foo: time + 1.days, bar: time + 2.days }
      it { is_expected.to eq [model] }
    end
    context "foo < time < bar" do
      let!(:model) { klass.create! foo: time - 1.days, bar: time + 1.days }
      it { is_expected.to eq [] }
    end
  end
  describe "::wow_within" do
    subject { klass.__send__("wow_within", time - 2.days, time + 2.days) }
    let(:time) { DateTime.now }
    context "time - 2.days < foo & bar < time + 2.days" do
      let!(:model) { klass.create! foo: time - 1.days, bar: time + 1.days }
      it { is_expected.to eq [model] }
    end
    context "time - 2.days < foo < time + 2.days < bar" do
      let!(:model) { klass.create! foo: time + 1.days, bar: time + 3.days }
      it { is_expected.to eq [] }
    end
    context "foo < time - 2.days < bar < time + 2.days" do
      let!(:model) { klass.create! foo: time - 3.days, bar: time - 1.days }
      it { is_expected.to eq [] }
    end
    context "foo < time - 2.days < time + 2.days < bar" do
      let!(:model) { klass.create! foo: time - 3.days, bar: time + 3.days }
      it { is_expected.to eq [] }
    end
    context "time - 2.days < time + 2.days < foo & bar" do
      let!(:model) { klass.create! foo: time + 3.days, bar: time + 4.days }
      it { is_expected.to eq [] }
    end
    context "foo & bar < time - 2.days < time + 2.days" do
      let!(:model) { klass.create! foo: time - 4.days, bar: time - 3.days }
      it { is_expected.to eq [] }
    end
  end
end
