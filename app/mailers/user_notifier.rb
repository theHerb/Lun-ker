class UserNotifier < ActionMailer::Base
  default from: "do-not-reply@lun-ker.com"

  def friend_requested(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @friend.email,
  		subject: "#{@user.first_name} wants to be friends"

  end

  def friend_request_accepted(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend
    #friend and user are reversed because the pending friend must log in as a user to accept the friendship

  	mail to: @friend.email,
  		subject: "#{@user.first_name} has accepted your friend request"

  end



end
