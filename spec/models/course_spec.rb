require 'spec_helper'

describe Course do

  describe '#info_cache_key' do
    context 'course with only input_1 defined' do
      it 'computes correct cache key' do
        course = create(:course)
        expect(course.info_cache_key).to eq("class_info_#{course.term.term_code}_#{course.input_1}")
      end
    end
    context 'course with input_1 and input_2 defined' do
      it 'computes correct cache key'
    end
    context 'course with input_1, input_2 and input_3 defined' do
      it 'computes correct cache key'
    end
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
    context 'closed course' do
      it 'gets class status' do
        course = create(:closed_course)
        expect(course.get_class_status).to eq(:closed)
      end
    end
    context 'open course' do
      it 'gets class status' do
        course = create(:open_course)
        expect(course.get_class_status).to eq(:open)
      end
    end
    it "returns nil for class that doesn't exist"
    it "caches status"
  end

  describe "#reconcile_notifiers" do
  end
end