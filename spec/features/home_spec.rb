require 'spec_helper'

describe 'home page' do
  before(:each) do
    school = FactoryGirl.create(:school, name: 'Enabled')
    school2 = FactoryGirl.create(:school, name: 'Disabled', disable_adding: true)
    FactoryGirl.create(:term, school: school)
    FactoryGirl.create(:term, school: school2)
  end

  it 'hides disabled schools on anonymous home page' do
    visit root_path
    # make sure schools are/aren't in the list of supported schools
    expect(page).to have_content('Enabled')
    expect(page).not_to have_content('Disabled')
    # then look for the dropdown
    expect(page).to have_select('school_id', with_options: ['Enabled'])
    expect(page).not_to have_select('school_id', with_options: ['Disabled'])
  end

  it 'hides disabled school in logged in view', js: true do
    user = FactoryGirl.create(:user, email: 'johndoe@getmyclass.com', password: 'abc123')
    visit new_user_session_path
    fill_in 'Email', with: 'johndoe@getmyclass.com'
    fill_in 'Password', with: 'abc123'
    click_button 'Sign in'
    expect(page).to have_select('school_id', with_options: ['Enabled'])
    expect(page).not_to have_select('school_id', with_options: ['Disabled'])
  end
end
