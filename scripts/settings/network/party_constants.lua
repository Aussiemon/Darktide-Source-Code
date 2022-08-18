local PartyConstants = {
	State = table.enum("none", "matchmaking", "matchmaking_acceptance_vote", "in_mission"),
	MembershipDeniedReasons = table.enum("in_onboarding")
}

return PartyConstants
