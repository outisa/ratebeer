require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style, name: "Lager" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", style:style, brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", style:style, brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

describe "Ratings are shown correctly" do
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

  it "Ratings are shown correctly" do
    visit ratings_path
    expect(page).to have_content "List of ratings"
    expect(page).to have_content "Number of ratings: 4"
    expect(page).to have_content "iso 3 20 Pekka"
    expect(page).to have_content "iso 3 44 Pekka"
    expect(page).to have_content "iso 3 9 Minna"
    expect(page).to have_content "Karhu 10 Pekka"
  end
end
