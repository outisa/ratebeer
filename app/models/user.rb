class User < ApplicationRecord
  include RatingAverage
  has_secure_password
  PASSWORD_REQUIREMENTS = /\A
    (?=.{4,})
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
  /x
  validates :username,  uniqueness: true,
                        length: { minimum: 3, maximum: 30 }
  validates :password, format: PASSWORD_REQUIREMENTS

  has_many :ratings,   dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def find_beer
    rated_beers = ratings.group_by(&:beer_id).transform_values { |rating| rating.pluck(:score).reduce(0) { |s, score| s + score } / rating.count.to_f }
    rated_beers.max_by { |_k, v| v }[0]
  end

  def favorite_style
    return nil if ratings.empty?

    beer = find_beer
    Beer.find_by(id: beer).style
  end

  def favorite_brewery
    return nil if ratings.empty?

    beer = find_beer
    Beer.includes(:brewery).joins(:brewery).find_by(id: beer).brewery
  end
end
