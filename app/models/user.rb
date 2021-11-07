class User < ApplicationRecord
	has_many :posts
	validates :email, uniqueness: true
  	validates :name, uniqueness: true
  	validates :name, :email, :password, presence: true
	has_secure_password

	has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  	has_many :followees, through: :followed_users
  	has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  	has_many :followers, through: :following_users

  	def get_feed_post
  	@user = self
  	@feedpost = Array.new
  	User.find(@user.id).followees.each do |followee|
		followee.posts.each do |post|
			@feedpost.push(post)
		end
	end
	@feedpost = @feedpost.sort_by{ |created_at| created_at }
  end
end
