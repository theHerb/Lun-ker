class Status < ActiveRecord::Base
	attr_accessible :content, :user_id

	belongs_to :user

	has_many :comments, as: :commentable

	validates :content, presence: true,
				length: {minimum: 2}

	validates :user_id, presence: true
end
