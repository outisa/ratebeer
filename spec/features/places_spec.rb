require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      { "request" => {"query" => "Kumpula, Finland"},
        "current" => {
          "temperature" => 18,
          "weather_icons" => [""],
          "wind_speed" => 0,
          "wind_dir" => "NNW",
          "feelslike" => 17
        }
      }
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    expect(page).to have_content "Current beer weather in Kumpula, Finland"
    expect(page).to have_content "Temperature: 18 Celsius"
    expect(page).to have_content "Feels like: 17 Celsius"
    expect(page).to have_content "Wind: 0, direction NNW"
    expect(page).to have_content "Oljenkorsi"
  end

  it "if more than one place is returned by the API, the all placed are shown" do
    allow(WeatherApi).to receive(:weather_in).with("hamburg").and_return(
      { "request" => {"query" => "Hamburg, Germany"},
        "current" => {
          "temperature" => 18,
          "weather_icons" => [""],
          "wind_speed" => 12,
          "wind_dir" => "NW",
          "feelslike" => 13
        }
      }
    )
    allow(BeermappingApi).to receive(:places_in).with("hamburg").and_return(
      [ Place.new( name: "Alster", id: 1 ), Place.new( name: "Bar Wedel", id: 2 ), Place.new( name: "Thibo", id: 3 ) ]
    )

    visit places_path
    fill_in('city', with: 'hamburg')
    click_button "Search"
    expect(page).to have_content "Current beer weather in Hamburg, Germany"
    expect(page).to have_content "Temperature: 18 Celsius"
    expect(page).to have_content "Feels like: 13 Celsius"
    expect(page).to have_content "Wind: 12, direction NW"
    expect(page).to have_content "Alster"
    expect(page).to have_content "Bar Wedel"
    expect(page).to have_content "Thibo"
  end

  it "if empty list is returned by the API, the correct notice is shown" do
    allow(WeatherApi).to receive(:weather_in).with("oulu").and_return(
      { "request" => {"query" => "Oulu, Finland"},
        "current" => {
          "temperature" => 18,
          "weather_icons" => [""],
          "wind_speed" => 0,
          "wind_dir" => "NNW",
          "feelslike" => 18
        }
      }
    )
    allow(BeermappingApi).to receive(:places_in).with("oulu").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'oulu')
    click_button('Search')

    expect(page).to have_content "No locations in oulu"
  end
end
