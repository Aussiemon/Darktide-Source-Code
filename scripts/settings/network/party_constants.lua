-- chunkname: @scripts/settings/network/party_constants.lua

local PartyConstants = {}

PartyConstants.State = table.enum("none", "matchmaking", "matchmaking_acceptance_vote", "in_mission")
PartyConstants.MembershipDeniedReasons = table.enum("in_onboarding")

return PartyConstants
