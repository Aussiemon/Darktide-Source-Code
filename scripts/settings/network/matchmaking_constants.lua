local MatchmakingConstants = {
	HOST_TYPES = table.enum("player", "mission_server", "hub_server", "party", "singleplay", "singleplay_backend_session"),
	SINGLEPLAY_TYPES = table.enum("onboarding", "training_grounds")
}

return settings("MatchmakingConstants", MatchmakingConstants)
