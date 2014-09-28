require 'spec_helper'

RSpec.describe ActiveRecord::TimeScope::TimeProxy do
  let(:time) { DateTime.now }
  let(:klass) do
    create_tmp_model foo: :datetime, bar_on: :date do
      create_time_scope :foo, :foo
      create_time_scope :bar, :bar
    end
  end

  describe "::foo_before" do
    subject { klass.foo_before(time) }
    # .=...
    # ..!..
    context "foo < time" do
      let!(:model) { klass.create! foo: time + 1.days }
      it { is_expected.to eq [] }
    end
    # ...=.
    # ..!..
    context "time < foo" do
      let!(:model) { klass.create! foo: time - 1.days }
      it { is_expected.to eq [model] }
    end
    # ..=..
    # ..!..
    context "time = foo" do
      let!(:model) { klass.create! foo: time }
      it { is_expected.to eq [] }
    end
  end
  describe "::foo_after" do
    subject { klass.foo_after(time) }
    # .=...
    # ..!..
    context "foo < time" do
      let!(:model) { klass.create! foo: time + 1.days }
      it { is_expected.to eq [model] }
    end
    # ...=.
    # ..!..
    context "time < foo" do
      let!(:model) { klass.create! foo: time - 1.days }
      it { is_expected.to eq [] }
    end
    # ..=..
    # ..!..
    context "time = foo" do
      let!(:model) { klass.create! foo: time }
      it { is_expected.to eq [] }
    end
  end
  describe "::foo_within" do
    subject { klass.foo_within(time - 2.days, time + 2.days) }
    let(:time) { DateTime.now }
    # .=...
    # ..!!.
    context "foo < time1 < time2" do
      let!(:model) { klass.create! foo: time - 3.days }
      it { is_expected.to eq [] }
    end
    # .=...
    # .!!..
    context "foo = time1 < time2" do
      let!(:model) { klass.create! foo: time - 3.days }
      it { is_expected.to eq [] }
    end
    # ..=..
    # .!.!.
    context "time1 < foo < time2" do
      let!(:model) { klass.create! foo: time }
      it { is_expected.to eq [model] }
    end
    # ...=.
    # ..!!.
    context "time1 < time2 = foo" do
      let!(:model) { klass.create! foo: time + 3.days }
      it { is_expected.to eq [] }
    end
    # ...=.
    # .!!..
    context "-2 days < +2 days < foo" do
      let!(:model) { klass.create! foo: time + 3.days }
      it { is_expected.to eq [] }
    end
  end
end
