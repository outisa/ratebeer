require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end


  it "A signed in user can add a valid beer" do
    visit new_beer_path
    fill_in('beer_name', with: 'Special Beer')
    select('IPA')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end
  it "A signed in user cannnot add a invalid beer" do
    visit new_beer_path
    select('IPA')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name is too short (minimum is 1 character)"
  end
end