require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "With empty" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }

    it "name field a beer is not saved" do
      beer = Beer.create name: "", style: "IPA", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  
    it "style field a beer is not saved" do
      beer = Beer.create name: "Outi's Special", style: "", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

  describe "with a valid field values a beer" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:beer){ Beer.create name: "Special", style: "IPA", brewery: test_brewery }

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
end
