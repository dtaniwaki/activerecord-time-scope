require 'spec_helper'

RSpec.describe "time_range_spec" do
  klass = create_tmp_model "Test2Class", "test2_classes", foo_at: :datetime, bar_at: :datetime do
    create_time_range_scope :wow, :foo_at, :bar_at
  end

  describe "::wow_before" do
    subject { klass.__send__("wow_before", time) }
    let(:time) { DateTime.now }
    context "foo & bar < time" do
      let!(:model) { klass.create! foo_at: time - 2.days, bar_at: time - 1.days }
      it { is_expected.to eq [model] }
    end
    context "time < foo & bar" do
      let!(:model) { klass.create! foo_at: time + 1.days, bar_at: time + 2.days }
      it { is_expected.to eq [] }
    end
    context "foo < time < bar" do
      let!(:model) { klass.create! foo_at: time - 1.days, bar_at: time + 1.days }
      it { is_expected.to eq [] }
    end
  end
  describe "::wow_after" do
    subject { klass.__send__("wow_after", time) }
    let(:time) { DateTime.now }
    context "foo & bar < time" do
      let!(:model) { klass.create! foo_at: time - 2.days, bar_at: time - 1.days }
      it { is_expected.to eq [] }
    end
    context "time < foo & bar" do
      let!(:model) { klass.create! foo_at: time + 1.days, bar_at: time + 2.days }
      it { is_expected.to eq [model] }
    end
    context "foo < time < bar" do
      let!(:model) { klass.create! foo_at: time - 1.days, bar_at: time + 1.days }
      it { is_expected.to eq [] }
    end
  end
  describe "::wow_within" do
    subject { klass.__send__("wow_within", time - 2.days, time + 2.days) }
    let(:time) { DateTime.now }
    context "time - 2.days < foo & bar < time + 2.days" do
      let!(:model) { klass.create! foo_at: time - 1.days, bar_at: time + 1.days }
      it { is_expected.to eq [model] }
    end
    context "time - 2.days < foo < time + 2.days < bar" do
      let!(:model) { klass.create! foo_at: time + 1.days, bar_at: time + 3.days }
      it { is_expected.to eq [] }
    end
    context "foo < time - 2.days < bar < time + 2.days" do
      let!(:model) { klass.create! foo_at: time - 3.days, bar_at: time - 1.days }
      it { is_expected.to eq [] }
    end
    context "foo < time - 2.days < time + 2.days < bar" do
      let!(:model) { klass.create! foo_at: time - 3.days, bar_at: time + 3.days }
      it { is_expected.to eq [] }
    end
    context "time - 2.days < time + 2.days < foo & bar" do
      let!(:model) { klass.create! foo_at: time + 3.days, bar_at: time + 4.days }
      it { is_expected.to eq [] }
    end
    context "foo & bar < time - 2.days < time + 2.days" do
      let!(:model) { klass.create! foo_at: time - 4.days, bar_at: time - 3.days }
      it { is_expected.to eq [] }
    end
  end
end
