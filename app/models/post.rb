class Post < ApplicationRecord
  belongs_to :user
  has_many :likes

  def get_likers
    return User.where(:id => self.likes.pluck('likeUser')).pluck('name')
  end
end
