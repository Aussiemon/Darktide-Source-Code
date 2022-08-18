local MatchmakingConstants = {
	HOST_TYPES = table.enum("player", "mission_server", "hub_server", "party", "singleplay")
}

return settings("MatchmakingConstants", MatchmakingConstants)
