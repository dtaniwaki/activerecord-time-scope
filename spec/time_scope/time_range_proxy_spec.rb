require 'spec_helper'

RSpec.describe ActiveRecord::TimeScope::TimeRangeProxy do
  let(:time) { DateTime.now }
  let(:klass) do
    create_tmp_model foo: :datetime, bar: :datetime do
      create_time_range_scope :wow, :foo, :bar
    end
  end

  describe "::wow_before" do
    shared_examples "before" do
      before do
        klass.create! foo: time + 100.days, bar: time + 100.days
      end
      let(:options) { {} }
      let(:a) { false }
      let(:b) { false }
      let(:c) { false }
      let(:d) { false }
      let(:e) { false }
      subject { klass.wow_before(time, options) == [model] }
      # A
      # .=====.
      # ......!
      context "foo < bar < time" do
        let!(:model) { klass.create! foo: time - 2.days, bar: time - 1.days }
        it { is_expected.to be a }
      end
      # B
      # .=====.
      # .....!.
      context "foo < bar = time" do
        let!(:model) { klass.create! foo: time - 2.days, bar: time }
        it { is_expected.to be b }
      end
      # C
      # .=====.
      # !......
      context "time < foo < bar" do
        let!(:model) { klass.create! foo: time + 1.days, bar: time + 2.days }
        it { is_expected.to be c }
      end
      # D
      # .=====.
      # .!.....
      context "time = foo < bar" do
        let!(:model) { klass.create! foo: time, bar: time + 2.days }
        it { is_expected.to be d }
      end
      # E
      # .=====.
      # ...!...
      context "foo < time < bar" do
        let!(:model) { klass.create! foo: time - 1.days, bar: time + 1.days }
        it { is_expected.to be e }
      end
    end
    it_behaves_like "before" do
      let(:a) { true }
    end
    context "with include_equal option" do
      it_behaves_like "before" do
        let(:options) { {include_equal: true} }
        let(:a) { true }
        let(:b) { true }
      end
    end
  end
  describe "::wow_after" do
    shared_examples "after" do
      before do
        klass.create! foo: time - 100.days, bar: time - 100.days
      end
      let(:options) { {} }
      let(:a) { false }
      let(:b) { false }
      let(:c) { false }
      let(:d) { false }
      let(:e) { false }
      subject { klass.wow_after(time, options) == [model] }
      # A
      # .=====.
      # ......!
      context "foo < bar < time" do
        let!(:model) { klass.create! foo: time - 2.days, bar: time - 1.days }
        it { is_expected.to be a }
      end
      # B
      # .=====.
      # .....!.
      context "foo < bar = time" do
        let!(:model) { klass.create! foo: time - 2.days, bar: time }
        it { is_expected.to be b }
      end
      # C
      # .=====.
      # !......
      context "time < foo < bar" do
        let!(:model) { klass.create! foo: time + 1.days, bar: time + 2.days }
        it { is_expected.to be c }
      end
      # D
      # .=====.
      # .!.....
      context "time = foo < bar" do
        let!(:model) { klass.create! foo: time, bar: time + 2.days }
        it { is_expected.to be d }
      end
      # E
      # .=====.
      # ...!...
      context "foo < time < bar" do
        let!(:model) { klass.create! foo: time - 1.days, bar: time + 1.days }
        it { is_expected.to be e }
      end
    end
    it_behaves_like "after" do
      let(:c) { true }
    end
    context "with include_equal option" do
      it_behaves_like "after" do
        let(:options) { {include_equal: true} }
        let(:c) { true }
        let(:d) { true }
      end
    end
  end
  describe "::wow_within" do
    shared_examples "within" do
      before do
        klass.create! foo: time + 100.days, bar: time + 100.days
      end
      let(:from_options) { {} }
      let(:to_options) { {} }
      let(:a) { false }
      let(:b) { false }
      let(:c) { false }
      let(:d) { false }
      let(:e) { false }
      let(:f) { false }
      let(:g) { false }
      let(:h) { false }
      let(:i) { false }
      let(:j) { false }
      let(:k) { false }
      subject { klass.wow_within(time - 2.days, time + 2.days, from_options, to_options) == [model] }
      # A
      # .=====.
      # .!....!
      context "time1 = foo < bar < time2" do
        let!(:model) { klass.create! foo: time - 2.days, bar: time + 1.days }
        it { is_expected.to be a }
      end
      # B
      # .=====.
      # !.....!
      context "time1 < foo < bar < time2" do
        let!(:model) { klass.create! foo: time - 1.days, bar: time + 1.days }
        it { is_expected.to be b }
      end
      # C
      # .=====.
      # !....!.
      context "time1 < foo < bar = time2" do
        let!(:model) { klass.create! foo: time - 1.days, bar: time + 2.days }
        it { is_expected.to be c }
      end
      # D
      # .=====.
      # !..!...
      context "time1 < foo < time2 < bar" do
        let!(:model) { klass.create! foo: time + 1.days, bar: time + 3.days }
        it { is_expected.to be d }
      end
      # E
      # .=====.
      # ...!..!
      context "foo < time1 < bar < time2" do
        let!(:model) { klass.create! foo: time - 3.days, bar: time - 1.days }
        it { is_expected.to be e }
      end
      # F
      # ..=====
      # !!.....
      context "time1 < time2 < foo < bar" do
        let!(:model) { klass.create! foo: time + 3.days, bar: time + 4.days }
        it { is_expected.to be f }
      end
      # G
      # ..=====
      # !.!....
      context "time1 < time2 = foo < bar" do
        let!(:model) { klass.create! foo: time + 2.days, bar: time + 4.days }
        it { is_expected.to be g }
      end
      # H
      # =====..
      # .....!!
      context "foo < bar < time1 < time2" do
        let!(:model) { klass.create! foo: time - 4.days, bar: time - 3.days }
        it { is_expected.to be h }
      end
      # I
      # =====..
      # ....!.!
      context "foo < bar = time1 < time2" do
        let!(:model) { klass.create! foo: time - 4.days, bar: time - 2.days }
        it { is_expected.to be i }
      end
      # J
      # .=====.
      # .!...!.
      context "foo = time1 < time2 = bar" do
        let!(:model) { klass.create! foo: time - 2.days, bar: time + 2.days }
        it { is_expected.to be j }
      end
      # K
      # .=====.
      # ..!.!..
      context "foo < time1 < time2 < bar" do
        let!(:model) { klass.create! foo: time - 3.days, bar: time + 3.days }
        it { is_expected.to be k }
      end
    end
    it_behaves_like "within" do
      let(:b) { true }
    end
    context "with include_equal option" do
      it_behaves_like "within" do
        let(:from_options) { {include_equal: true} }
        let(:a) { true }
        let(:b) { true }
      end
      it_behaves_like "within" do
        let(:to_options) { {include_equal: true} }
        let(:b) { true }
        let(:c) { true }
      end
      it_behaves_like "within" do
        let(:from_options) { {include_equal: true} }
        let(:to_options) { {include_equal: true} }
        let(:a) { true }
        let(:b) { true }
        let(:c) { true }
        let(:j) { true }
      end
    end
  end
end
