local SocialConstants = {
	max_num_party_members = 4,
	min_num_party_members_to_vote = 3,
	Platforms = table.enum("steam", "xbox", "lan"),
	OnlineStatus = table.enum("offline", "platform_online", "online", "reconnecting"),
	PartyStatus = table.enum("none", "mine", "same_mission", "other", "invite_pending"),
	FriendStatus = table.enum("none", "friend", "invite", "invited", "ignored")
}

return SocialConstants
