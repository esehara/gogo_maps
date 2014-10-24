# -*- coding: utf-8 -*-
require 'spec_helper'
require 'pry'

describe GogoMaps do
  it 'has a version number' do
    expect(GogoMaps::VERSION).not_to be nil
  end

  describe '#get_latlng' do
    it 'should return proper parameters' do
      expect(
        GogoMaps.get_latlng('長野県上高井郡高山村')
      ).to eq(
        { lat: 36.6797676, lng: 138.3632554 }
      )
      expect(
        GogoMaps.get_latlng('神奈川県横浜市港北区日吉')
      ).to eq(
        { lat: 35.5565107, lng: 139.6460026 }
      )
      expect(
        GogoMaps.get_latlng('902 Rockefeller Dr, Sunnyvale, CA', language: :en)
      ).to eq(
        { lat: 37.358126, lng: -122.050636 }
      )
    end
  end

  describe 'get_address' do
    it 'should return proper parameters' do
      expect(
        GogoMaps.get_address(35.6506135, 139.7539103)
      ).to eq(
        '日本, 東京都港区芝１丁目１１−１４'
      )
      expect(
        GogoMaps.get_address(37.358126, -122.050636, language: :en)
      ).to eq(
        '902 Rockefeller Drive, Sunnyvale, CA 94087, USA'
      )
    end
  end

  describe '#random' do
    it 'should return proper parameters' do
      expect(
        GogoMaps.random
      ).not_to be_nil
    end
  end

  describe '#random_by' do
    it 'should return error when set invalid parameter' do
      gogomap_invalid = false
      begin
        GogoMaps.random_by(100, 120, 100, 120)
      rescue GogoMaps::InvalidRandomMapError
        gogomap_invalid = true
      end
      expect(gogomap_invalid).to be_true
    end

    it 'should return proper prameters' do
      expect(
        GogoMaps.random_by(30, 35, 130, 140)
      ).not_to be_nil
    end
  end

end
