require 'spec_helper'

describe ClassesController do
  it 'can add a class' do
    user = FactoryGirl.create(:user)
    term = FactoryGirl.create(:term)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'abc123'
    click_button 'Sign in'
    expect(page).to have_content('not currently watching any classes')

    select term.school.name, from: 'School'
    select term.name, from: 'Term'
    fill_in 'Course Number', with: '123'
    click_button 'Add'

    # TODO credit card payment here
    # TODO check to make sure it gets added

  end
end
