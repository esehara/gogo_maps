require 'spec_helper'

describe GogoMaps do
  it 'has a version number' do
    expect(GogoMaps::VERSION).not_to be nil
  end

  describe '.get' do
    it 'should raise error' do
      expect { GogoMaps.get }.to raise_error(RuntimeError)
    end

    context 'to_latlng' do
      it 'should return proper parameters' do
        expect(
          GogoMaps.get(address: '長野県上高井郡高山村')
        ).to eq(
          {"lat"=>36.6797676, "lng"=>138.3632554}
        )
        expect(
          GogoMaps.get(address: '神奈川県横浜市港北区日吉')
        ).to eq(
          {"lat"=>35.5565107, "lng"=>139.6460026}
        )
        expect(
          GogoMaps.get(address: '902 Rockefeller Dr, Sunnyvale, CA', language: :en)
        ).to eq(
          {"lat"=>37.358126, "lng"=>-122.050636}
        )
      end
    end

    context 'to_address' do
      it 'should return proper parameters' do
        expect(
          GogoMaps.get(latlng: '35.6506135,139.7539103')
        ).to eq(
          '日本, 東京都港区芝１丁目１１−１４'
        )
      end
    end

  end
end
