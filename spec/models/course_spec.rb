require 'spec_helper'

describe Course do
  describe '#info_cache_key' do
    it 'computes correct cache key'
  end
  describe '#get_class_info' do
    before :each do
      Rails.cache.clear
    end
    it 'gets info for a class' do
      course = create(:course)
      class_info = course.get_class_info
      expect(class_info.name).to eq('Fake Course')
      expect(class_info.schedule).to eq('MWF')
    end
    it "returns nil if class doesn't exist" do
      course = create(:invalid_course)
      expect(course.get_class_info).to be_nil
    end
    it "caches class info" do
      course = create(:course)
      expect(Rails.cache.exist? course.info_cache_key).to be_false
      course.get_class_info
      expect(Rails.cache.exist? course.info_cache_key).to be_true
    end
  end

  describe "#get_class_status" do
    it 'gets class status'
    it "returns nil for class that doesn't exist"
    it "caches status"
  end

  describe "#reconcile_notifiers" do
  end
end