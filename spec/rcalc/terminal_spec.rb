# frozen_string_literal: true

RSpec.describe Rcalc::Terminal do
  describe '#split' do
    it 'splits single chars' do
      t = described_class.new

      expect(t.split('a')).to eq(['a'])
    end

    it 'splits normal chars' do
      t = described_class.new

      expect(t.split('abc')).to eq(%w[a b c])
    end

    it 'splits single escape' do
      t = described_class.new

      expect(t.split("\e")).to eq(["\e"])
    end

    it 'splits escapes' do
      t = described_class.new

      expect(t.split("\e\e")).to eq(["\e", "\e"])
    end

    it 'splits single escape strings' do
      t = described_class.new

      expect(t.split("\e[<65;76;64M")).to eq(["\e[<65;76;64M"])
    end

    it 'splits escape strings' do
      t = described_class.new

      expect(t.split("\e[<65;76;64M\e[<65;76;64M")).to eq(["\e[<65;76;64M", "\e[<65;76;64M"])
    end
  end
end
