class User < ActiveRecord::Base
	has_many :posts
	has_many :comments
end

class Post < ActiveRecord::Base
	belongs_to :author, foreign_key: 'user_id', class_name: 'User'
	has_many :comments
	validates :title, :body, presence: true
end

class Comment < ActiveRecord::Base
	belongs_to :author, foreign_key: 'user_id', class_name: 'User'
	belongs_to :post
	validates :name, :body, presence: true
end