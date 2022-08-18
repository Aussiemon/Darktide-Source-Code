local Promise = require("scripts/foundation/utilities/promise")
local LocalMissionBoardSettings = require("scripts/settings/mission/local_mission_board_settings")
local MISSIONS = {}
local _missions_settings = LocalMissionBoardSettings.missions

for i = 1, #_missions_settings, 1 do
	local settings = _missions_settings[i]
	local mission = {
		expiry = 2000000000000.0,
		start = 0,
		map = settings.mission,
		challenge = settings.challenge,
		resistance = settings.resistance,
		circumstance = settings.circumstance,
		sideMission = settings.side_mission,
		xp = settings.xp or 200,
		credits = settings.credits or 100,
		requiredLevel = settings.required_level,
		id = string.format("00000000-0000-0000-0000-%012d", i),
		bonuses = {},
		flags = settings.flags or {}
	}
	mission.flags.event = LocalMissionBoardSettings.happening_name and true

	if mission.flags.altered == nil and mission.circumstance ~= "default" then
		mission.flags.altered = true
	end

	MISSIONS[i] = mission
end

MissionBoardLocal = {
	fetch_mission = function (mission_id)
		local data = nil

		for i = 1, #MISSIONS, 1 do
			local mission = MISSIONS[i]

			if mission.id == mission_id then
				data = {
					mission = mission
				}
			end
		end

		local promise = Promise:new()

		promise:resolve(data)

		return promise
	end,
	fetch = function ()
		local t = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(t)
		local time_jump = LocalMissionBoardSettings.time_between_missions_popping_in
		local alive_time = LocalMissionBoardSettings.mission_alive_time
		local missions = {}

		for i = 1, #MISSIONS * 2, 1 do
			local index = math.index_wrapper(i, #MISSIONS)
			local mission = table.clone(MISSIONS[index])
			mission.start = server_time + (i - 1) * time_jump * 1000
			mission.expiry = mission.start + alive_time * 1000
			missions[i] = mission
		end

		local data = {
			refreshAt = server_time + LocalMissionBoardSettings.refresh_time * 1000,
			missions = missions
		}
		local promise = Promise:new()

		promise:resolve(data)

		return promise
	end,
	fetch_happening = function ()
		local t = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(t)
		local data = {
			name = LocalMissionBoardSettings.happening_name,
			expiry = server_time + 3605000,
			circumstances = table.clone(LocalMissionBoardSettings.happening_cirucumstances)
		}
		local promise = Promise:new()

		promise:resolve(data)

		return promise
	end
}

return MissionBoardLocal
