require 'spec_helper'

describe GogoMaps do
  it 'has a version number' do
    expect(GogoMaps::VERSION).not_to be nil
  end

  describe '#parameters' do
    it 'should raise error' do
      expect { GogoMaps.parameters }.to raise_error(RuntimeError)
    end

    it 'should return proper parameters' do
      expect(GogoMaps.parameters(address: '長野県高山村')).to eq "?address=長野県高山村&"
    end
  end
end
