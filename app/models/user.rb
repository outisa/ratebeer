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
end
