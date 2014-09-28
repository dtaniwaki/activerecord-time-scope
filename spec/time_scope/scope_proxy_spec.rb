require 'spec_helper'

RSpec.describe ActiveRecord::TimeScope::ScopeProxy do
  let(:klass) do
    Class.new(described_class) do
      def initialize(*args)
      end
    end
  end

  it "returns the same instance" do
    ins = klass.new
    expect(klass.new).to be ins
    expect(klass.new).to be ins
    expect(klass.new).to be ins
  end
  context "with arguments" do
    it "returns the correspondent instances" do
      ins1 = klass.new(1)
      ins2 = klass.new(2)
      expect(klass.new(1)).to be ins1
      expect(klass.new(1)).to be ins1
      expect(klass.new(1)).to be ins1
      expect(klass.new(2)).to be ins2
      expect(klass.new(2)).to be ins2
      expect(klass.new(2)).to be ins2
    end
  end
end
