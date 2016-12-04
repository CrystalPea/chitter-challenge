require './app/app'

RSpec.feature "Signing up", :type => :feature do
  before do
    DatabaseCleaner.clean
    @user_count = User.all.count
    signup
    fill_in('password_confirmation', with: 'gweatonidas36')
    click_button('Submit')
  end

  scenario "user creates an account" do
    expect(current_path).to eq '/dashboard'
    message = "Welcome to Chitter, Miko!"
    expect(page).to have_content(message)
    expect(User.all.count).to eq (@user_count + 1)
  end

  scenario "username already exists" do
    visit '/users/new'
    fill_in('username', with: 'Miko')
    fill_in('email', with: 'miko2@o2.pl')
    fill_in('password', with: 'gweatonidas36')
    fill_in('password_confirmation', with: 'gweatonidas36')
    click_button('Submit')

    expect(current_path).to eq '/users/new'
    message = "'Miko' is taken already, please choose a different username."
    expect(page).to have_content(message)
    expect(User.all.count).to eq (@user_count + 1)
  end
end
