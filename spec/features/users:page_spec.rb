require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end

describe "User page shown correctly" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style, name: "Lager" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", style: style, brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", style: style, brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: 'Minna' }
  let!(:r1) { FactoryBot.create :rating, beer: beer1, score: 20, user: user }
  let!(:r2) { FactoryBot.create :rating, beer: beer1, score: 44, user: user }
  let!(:r3) { FactoryBot.create :rating, beer: beer1, score: 9, user: user2 }
  let!(:r4) { FactoryBot.create :rating, beer: beer2, score: 10, user: user }
  
  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "Ratings are shown in the user page" do
    visit user_path user
    expect(page).to have_content "Ratings:"
    expect(page).to have_content "Has made 3 ratings, average rating 24.7"
    expect(page).to have_content "iso 3, score: 20"
    expect(page).to have_content "iso 3, score: 44"
    expect(page).not_to have_content "iso 3, score: 9 "
    expect(page).to have_content "Karhu, score: 10"
  end

  it "Signed in user can remove rating" do
    visit user_path user
    expect(page).to have_content "Has made 3 ratings, average rating 24.7"
    expect(page).to have_content "iso 3, score: 20"
    expect(user.ratings.count).to eq(3)
    page.first(:link, "delete").click
    expect(page).to have_content "Has made 2 ratings, average rating 27.0"
    expect(page).not_to have_content "iso 3, score: 20"
    expect(user.ratings.count).to eq(2)
  end

  it "Favorite style is shown in user page" do
    visit user_path user
    expect(page).to have_content "Favorite style is Lager"
  end

  it "Favorite brewery is shown in user page" do
    visit user_path user
    expect(page).to have_content "Favorite brewery is Koff"
  end
end
