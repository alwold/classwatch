require 'spec_helper'

describe 'home page' do
  it 'hides disabled schools' do
    school = FactoryGirl.create(:school, name: 'Enabled')
    school2 = FactoryGirl.create(:school, name: 'Disabled', disable_adding: true)
    visit root_path
    expect(page).to have_content('Enabled')
    expect(page).not_to have_content('Disabled')
  end
end
