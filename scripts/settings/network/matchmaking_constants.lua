-- chunkname: @scripts/settings/network/matchmaking_constants.lua

local matchmaking_constants = {}

matchmaking_constants.HOST_TYPES = table.enum("player", "mission_server", "hub_server", "party", "singleplay", "singleplay_backend_session")

return settings("MatchmakingConstants", matchmaking_constants)
