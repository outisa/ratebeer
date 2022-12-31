require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new app, browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    end
  
    Capybara.javascript_driver = :chrome
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", style:@style1, brewery: @brewery1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", style:@style2, brewery: @brewery2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", style:@style3, brewery: @brewery3)
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    expect(page).to have_content "Fastenbier"
    expect(page).to have_content "Nikolai"

  end

  it "Beers are in alphabetical order", :js => true do
    visit beerlist_path
    all_beers = page.all(:css, '.tablerow')
    expect(all_beers[0]).to have_content "Fastenbier"
    expect(all_beers[1]).to have_content "Lechte Weisse"
    expect(all_beers[2]).to have_content "Nikolai"
  end

  it "Beers are in correct order after clicking style", :js => true do
    visit beerlist_path
    find("#style").click()
    all_beers = page.all(:css, '.tablerow')
    expect(all_beers[0]).to have_content "Nikolai"
    expect(all_beers[1]).to have_content "Fastenbier"
    expect(all_beers[2]).to have_content "Lechte Weisse"
  end

    it "Beers are in correct order after clicking style", :js => true do
    visit beerlist_path
    find("#brewery").click()
    all_beers = page.all(:css, '.tablerow')
    expect(all_beers[0]).to have_content "Lechte Weisse"
    expect(all_beers[1]).to have_content "Nikolai"
    expect(all_beers[2]).to have_content "Fastenbier"
  end
end
