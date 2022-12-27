# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
b1 = Brewery.create name: "Koff", year: 1897
b2 = Brewery.create name: "Malmgard", year: 2001
b3 = Brewery.create name: "Weihenstephaner", year: 1040

s1 = Style.create name: "Lager", description: "Lager ..."
s2 = Style.create name: "Pale ale", description: "Pale ale ..."
s3 = Style.create name: "Porter", description: "Porter ..."
s4 = Style.create name: "Weizen", description: "Weizen ..."
s5 = Style.create name: "Lowalcohol", description: "Lowalcohol ..."
s6 = Style.create name: "IPA", description: "IPA ..."

b1.beers.create name: "Iso 3", style_id: s1.id
b1.beers.create name: "Karhu", style_id: s1.id
b1.beers.create name: "Tuplahumala", style_id: s1.id
b2.beers.create name: "Huvila Pale Ale", style_id: s2.id
b2.beers.create name: "X Porter", style_id: s3.id
b3.beers.create name: "Hefeweizen", style_id: s4.id
b3.beers.create name: "Helles", style_id: s1.id
