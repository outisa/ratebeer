require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved with too short password" do
    user = User.create username: "Pekka", password: "to1", password_confirmation: "to1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password that has only small letters" do
    user = User.create username: "Pekka", password: "notgoodone", password_confirmation: "notgoodone"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) } 
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:style) { Style.new name: "Lager" }
    let(:test_beer) { Beer.create name: "testbeer", style: style, brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      
      FactoryBot.create(:rating, beer:test_beer, score: 10, user: user)
      FactoryBot.create(:rating, beer:test_beer, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating.round(1)).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let!(:user){ FactoryBot.create(:user) }
    let!(:style){ FactoryBot.create(:style, name: "Lager") }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer, style: style)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user, style: style}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user, style: style }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end
  describe "favorite style" do
    let!(:user){ FactoryBot.create(:user) }
    let!(:style){ FactoryBot.create(:style, name: "Lager") }

    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style from the only rated beer" do
      beer = FactoryBot.create(:beer, style: style)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with the highest average rating if several rated" do
      create_beers_with_many_ratings({user: user, style: style}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user, style: style }, 25 )
      Rating.create({ beer: best, user: user, score: 45})

      expect(user.favorite_style).to eq(best.style.name)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style) }
 
    it "has method for determining the favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the brewery from the only rated beer" do
      beer = FactoryBot.create(:beer, style:style)
      brewery = Brewery.find_by(id: beer.brewery_id)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with the highest average rating if several rated" do
      create_beers_with_many_ratings({user: user, style: style }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({user: user, style: style }, 25 )
      Rating.create({ beer: best, user: user, score: 45})
      brewery = Brewery.find_by(id: best.brewery_id)

      expect(user.favorite_brewery).to eq(brewery)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer, style: object[:style] )
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
