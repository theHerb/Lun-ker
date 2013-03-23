class UserFriendship < ActiveRecord::Base

	belongs_to :user
	belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

	attr_accessible :user, :friend, :friend_id, :user_id, :state

	validates :user_id, uniqueness: true

	after_destroy :delete_mutual_friendship!

	state_machine :state, initial: :pending do

		state :requested

		after_transition on: :accept, do: :accept_mutual_friendship!
			after_transition on: :accept, do: [:send_acceptance_email, :accept_mutual_friendship!]
		event :accept do
			transition any => :accepted
		end
		
	end

	def self.request(user1, user2)
		transaction do 
			friendship1 = create!(user: user1,friend: user2, state: 'pending')
			friendship2 = create!(user: user2,friend: user1, state: 'requested')

			friendship1.send_request_email
			friendship1
		end
	end

	def send_request_email 
		UserNotifier.delay_for(5.seconds).friend_requested(id)
	end

	def send_acceptance_email 
		UserNotifier.delay_for(5.seconds).friend_request_accepted(id)
	end

	def mutual_friendship 
		self.class.where({user_id: friend_id, friend_id: user_id}).first
	end

	def accept_mutual_friendship!
		#Grab the mutual friendship and update the state without using 
		#the state machine so as not to invoke callbacks.
		mutual_friendship.update_attribute(:state, 'accepted')
	end

	def delete_mutual_friendship!
		mutual_friendship.delete
	end
end
