require 'spec_helper'

feature 'payment integration', js: true do
  # should we test a good credit card? it is already tested in the class management stuff
  scenario 'payment with bad credit card info fails gracefully' do
    user = create(:user)
    course = build(:closed_course)

    sign_in user

    visit root_path
    expect(page).to have_content('not currently watching any classes')

    select course.term.school.name, from: 'School'
    find_field 'Term'
    select course.term.name, from: 'Term'
    fill_in 'Course Number', with: course.input_1
    click_button 'Add'

    expect(current_path).to eq pay_classes_path
    expect(page).not_to have_content('Please enable JavaScript')
    fill_in 'Card Number', with: '4242424242424241'
    fill_in 'CVC', with: '123'
    fill_in 'exp-month', with: '12'
    fill_in 'exp-year', with: '2016'
    click_button 'Submit Payment'
    expect(page).to have_content('Your card number is incorrect.')
    expect(current_path).to eq pay_classes_path
  end

  scenario 'fail to load stripe api degrades gracefully'

  scenario 'disabled javascript fails gracefully', js: false do
    user = create(:user)
    course = build(:closed_course)

    sign_in user

    visit root_path
    expect(page).to have_content('not currently watching any classes')

    select course.term.school.name, from: 'School'
    find_field 'Term'
    select course.term.name, from: 'Term'
    fill_in 'Course Number', with: course.input_1
    click_button 'Add'

    expect(current_path).to eq pay_classes_path
    expect(page).to have_content('Please enable JavaScript')
    fill_in 'Card Number', with: '4242424242424241'
    fill_in 'CVC', with: '123'
    fill_in 'exp-month', with: '12'
    fill_in 'exp-year', with: '2016'
    expect(find_button('Submit Payment', disabled: true)).to be_disabled
  end
end
