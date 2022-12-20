class User < ApplicationRecord
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  has_many :ratings   # käyttäjällä on monta ratingia

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end
end
