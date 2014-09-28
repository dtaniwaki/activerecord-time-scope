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
    shared_examples "before" do
      before do
        klass.create! foo: time + 100.days
      end
      let(:options) { {} }
      let(:a) { false }
      let(:b) { false }
      let(:c) { false }
      subject { klass.foo_before(time, options) == [model] }
      # .=...
      # ..!..
      context "foo < time" do
        let!(:model) { klass.create! foo: time + 1.days }
        it { is_expected.to be a }
      end
      # ...=.
      # ..!..
      context "time < foo" do
        let!(:model) { klass.create! foo: time - 1.days }
        it { is_expected.to be b }
      end
      # ..=..
      # ..!..
      context "time = foo" do
        let!(:model) { klass.create! foo: time }
        it { is_expected.to be c }
      end
    end
    it_behaves_like "before" do
      let(:b) { true }
    end
    context "with include_equal option" do
      it_behaves_like "before" do
        let(:options) { {include_equal: true} }
        let(:b) { true }
        let(:c) { true }
      end
    end
  end
  describe "::foo_after" do
    shared_examples "after" do
      before do
        klass.create! foo: time - 100.days
      end
      let(:options) { {} }
      let(:a) { false }
      let(:b) { false }
      let(:c) { false }
      subject { klass.foo_after(time, options) == [model] }
      # A
      # .=...
      # ..!..
      context "foo < time" do
        let!(:model) { klass.create! foo: time + 1.days }
        it { is_expected.to be a }
      end
      # B
      # ...=.
      # ..!..
      context "time < foo" do
        let!(:model) { klass.create! foo: time - 1.days }
        it { is_expected.to be b }
      end
      # C
      # ..=..
      # ..!..
      context "time = foo" do
        let!(:model) { klass.create! foo: time }
        it { is_expected.to be c }
      end
    end
    it_behaves_like "after" do
      let(:a) { true }
    end
    context "with include_equal option" do
      it_behaves_like "after" do
        let(:options) { {include_equal: true} }
        let(:a) { true }
        let(:c) { true }
      end
    end
  end
  describe "::foo_within" do
    shared_examples "within" do
      before do
        klass.create! foo: time - 100.days
      end
      let(:from_options) { {} }
      let(:to_options) { {} }
      let(:a) { false }
      let(:b) { false }
      let(:c) { false }
      let(:d) { false }
      let(:e) { false }
      subject { klass.foo_within(time - 2.days, time + 2.days, from_options, to_options) == [model] }
      # A
      # .=...
      # ..!!.
      context "foo < time1 < time2" do
        let!(:model) { klass.create! foo: time - 3.days }
        it { is_expected.to be a }
      end
      # B
      # .=...
      # .!!..
      context "foo = time1 < time2" do
        let!(:model) { klass.create! foo: time - 2.days }
        it { is_expected.to be b }
      end
      # C
      # ..=..
      # .!.!.
      context "time1 < foo < time2" do
        let!(:model) { klass.create! foo: time }
        it { is_expected.to be c }
      end
      # D
      # ...=.
      # ..!!.
      context "time1 < time2 = foo" do
        let!(:model) { klass.create! foo: time + 2.days }
        it { is_expected.to be d }
      end
      # E
      # ...=.
      # .!!..
      context "time1 < time2 < foo" do
        let!(:model) { klass.create! foo: time + 3.days }
        it { is_expected.to be e }
      end
    end
    it_behaves_like "within" do
      let(:c) { true }
    end
    context "with include_equal option" do
      it_behaves_like "within" do
        let(:from_options) { {include_equal: true} }
        let(:b) { true }
        let(:c) { true }
      end
      it_behaves_like "within" do
        let(:to_options) { {include_equal: true} }
        let(:c) { true }
        let(:d) { true }
      end
      it_behaves_like "within" do
        let(:from_options) { {include_equal: true} }
        let(:to_options) { {include_equal: true} }
        let(:b) { true }
        let(:c) { true }
        let(:d) { true }
      end
    end
  end
end
