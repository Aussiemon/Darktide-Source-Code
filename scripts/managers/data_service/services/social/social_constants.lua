-- chunkname: @scripts/managers/data_service/services/social/social_constants.lua

local SocialConstants = {}

SocialConstants.max_num_party_members = 4
SocialConstants.min_num_party_members_to_vote = 3
SocialConstants.Platforms = table.enum("steam", "xbox", "lan")
SocialConstants.OnlineStatus = table.enum("offline", "platform_online", "online", "reconnecting")
SocialConstants.PartyStatus = table.enum("none", "mine", "same_mission", "other", "invite_pending")
SocialConstants.FriendStatus = table.enum("none", "friend", "invite", "invited", "ignored")

return SocialConstants
