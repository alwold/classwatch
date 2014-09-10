module LoginHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'abc123'
    click_button 'Sign in'
  end
end
