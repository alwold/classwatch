require 'spec_helper'

describe RegistrationsController do
  it 'can register a user' do
    visit new_user_registration_path
    fill_in 'Email', with: 'john@doe.com'
    fill_in 'Password', with: 'abc123'
    fill_in 'Password confirmation', with: 'abc123'
    click_button 'Sign up'
    expect(page).to have_content('signed up successfully')
  end
end
