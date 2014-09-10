require 'spec_helper'

feature 'class management', js: true do
  scenario 'adding a class' do
    user = FactoryGirl.create(:user)
    term = FactoryGirl.create(:term)

    sign_in user

    visit root_path
    expect(page).to have_content('not currently watching any classes')

    select term.school.name, from: 'School'
    find_field 'Term'
    select term.name, from: 'Term'
    fill_in 'Course Number', with: '12345'
    click_button 'Add'

    expect(current_path).to eq pay_classes_path
    fill_in 'Card Number', with: '4242424242424242'
    fill_in 'CVC', with: '123'
    fill_in 'exp-month', with: '12'
    fill_in 'exp-year', with: '2016'
    click_button 'Submit Payment'

    expect(page).to have_content('You are watching')
    expect(page).to have_content('Fake Course')
    expect(current_path).to eq root_path
  end

  scenario 'adding a class with invalid credit card' do
    user = FactoryGirl.create(:user)
    term = FactoryGirl.create(:term)

    sign_in user

    visit root_path
    expect(page).to have_content('not currently watching any classes')

    select term.school.name, from: 'School'
    find_field 'Term'
    select term.name, from: 'Term'
    fill_in 'Course Number', with: '12345'
    click_button 'Add'

    expect(current_path).to eq pay_classes_path
    fill_in 'Card Number', with: '4242424242424241'
    fill_in 'CVC', with: '123'
    fill_in 'exp-month', with: '12'
    fill_in 'exp-year', with: '2016'
    click_button 'Submit Payment'
    expect(page).to have_content('Your card number is incorrect.')
    expect(current_path).to eq pay_classes_path
  end

  scenario 'new user adds class and signs up in process' do
    term = FactoryGirl.create(:term)

    visit root_path
    expect(page).to have_content('To get started')
    select term.school.name, from: 'School'
    find_field 'Term'
    select term.name, from: 'Term'
    fill_in 'Course Number', with: '12345'
    click_button 'Add'

    # create acct
    expect(current_path).to eq new_user_session_path
    click_link 'Sign up'

    expect(current_path).to eq new_user_registration_path

    fill_in 'Email', with: 'johndoe@johndoe.com'
    fill_in 'Password', with: 'abc123'
    fill_in 'Password confirmation', with: 'abc123'
    click_button 'Sign up'

    expect(current_path).to eq create_class_from_session_path
    fill_in 'Card Number', with: '4242424242424242'
    fill_in 'CVC', with: '123'
    fill_in 'exp-month', with: '12'
    fill_in 'exp-year', with: '2016'
    click_button 'Submit Payment'

    expect(page).to have_content('You are watching')
    expect(page).to have_content('Fake Course')
    expect(current_path).to eq root_path
  end

  scenario 'existing user adds class and logs in in process' do
    user = FactoryGirl.create(:user)
    term = FactoryGirl.create(:term)

    visit root_path
    expect(page).to have_content('To get started')

    select term.school.name, from: 'School'
    find_field 'Term'
    select term.name, from: 'Term'
    fill_in 'Course Number', with: '12345'
    click_button 'Add'

    expect(current_path).to eq new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'abc123'
    click_button 'Sign in'

    expect(current_path).to eq create_class_from_session_path
    fill_in 'Card Number', with: '4242424242424242'
    fill_in 'CVC', with: '123'
    fill_in 'exp-month', with: '12'
    fill_in 'exp-year', with: '2016'
    click_button 'Submit Payment'

    expect(page).to have_content('You are watching')
    expect(page).to have_content('Fake Course')
    expect(current_path).to eq root_path  
  end
end
