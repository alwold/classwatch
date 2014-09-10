require 'spec_helper'

describe Course do
  describe '#get_class_info' do
    it 'gets info for a class' do
      course = create(:course)
      class_info = course.get_class_info
      expect(class_info.name).to eq('Fake Course')
      expect(class_info.schedule).to eq('MWF')
    end
    it "returns nil if class doesn't exist"
    it "caches class info"
  end

  describe "#get_class_status" do
    it 'gets class status'
    it "returns nil for class that doesn't exist"
    it "caches status"
  end

  describe "#reconcile_notifiers" do
  end
end