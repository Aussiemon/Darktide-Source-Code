local Promise = require("scripts/foundation/utilities/promise")
local MissionBoardService = class("MissionBoardService")

MissionBoardService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

MissionBoardService.fetch_mission = function (self, mission_id)
	return self._backend_interface.mission_board:fetch_mission(mission_id)
end

MissionBoardService.fetch = function (self, on_expiry, pause_time)
	local missions_promise, happening_promise = nil
	pause_time = pause_time or 1
	missions_promise = self._backend_interface.mission_board:fetch(on_expiry, pause_time)
	happening_promise = self._backend_interface.mission_happenings:fetch_current()

	local function format_missions_data(result)
		local missions_data, happening_data = unpack(result)
		local t = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(t)
		local mission_data_expiry = tonumber(missions_data.refreshAt)
		missions_data.expiry_game_time = (mission_data_expiry - server_time) / 1000 + t

		if happening_data then
			local happening_expiry = tonumber(happening_data.expiry) or 0
			happening_data.expiry_game_time = (happening_expiry - server_time) / 1000 + t
			missions_data.happening = happening_data
		end

		local missions = missions_data.missions

		for i = 1, #missions do
			local mission = missions[i]
			local start = mission.start
			local expiry = mission.expiry
			mission.duration = (expiry - start) / 1000
			mission.expiry_game_time = (tonumber(expiry) - server_time) / 1000 + t
			mission.start_game_time = (tonumber(start) - server_time) / 1000 + t
			mission.required_level = mission.requiredLevel
			mission.side_mission = mission.sideMission
			mission.mission_xp = mission.xp
			mission.mission_reward = mission.credits
			local flags = mission.flags
			flags.happening_mission = flags.event and flags.altered
		end

		return missions_data
	end

	return Promise.all(missions_promise, happening_promise):next(format_missions_data)
end

return MissionBoardService
