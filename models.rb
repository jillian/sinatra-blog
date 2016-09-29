# class User < ActiveRecord::Base
# 	has_many :posts
# 	has_many :comments
# end

class Post < ActiveRecord::Base
	# belongs_to :user
	has_many :comments
	validates :title, :body, presence: true
end

# class Comment < ActiveRecord::Base
# 	belongs_to :post
# 	belongs_to :user
# end