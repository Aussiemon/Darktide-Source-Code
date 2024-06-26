-- chunkname: @scripts/backend/mission_board.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch",
	"create_mission",
}
local MissionBoard = class("MissionBoard")
local missionboard_path = "/mission-board"

MissionBoard.init = function (self)
	return
end

MissionBoard.fetch_mission = function (self, mission_id)
	return Managers.backend:title_request(missionboard_path .. "/" .. mission_id):next(function (data)
		return data.body
	end)
end

MissionBoard.fetch = function (self, on_expiry, pause_time)
	return Managers.backend:title_request(missionboard_path):next(function (data)
		data.body.expire_in = BackendUtilities.on_expiry_do(data.headers, on_expiry, pause_time)
		data.body.server_time = data.headers["server-time"]
		data.body.data_age = (data.headers.age or 0) * 1000

		return data.body
	end)
end

MissionBoard.create_mission = function (self, mission_data)
	if not next(mission_data.flags) then
		mission_data.flags = {
			none = {
				none = "test",
			},
		}
	end

	return Managers.backend:title_request(missionboard_path .. "/create", {
		method = "POST",
		body = {
			mission = mission_data,
		},
	}):next(function (data)
		return data.body
	end)
end

MissionBoard.get_rewards = function (self, on_expiry, pause_time)
	return Managers.backend:title_request(missionboard_path .. "/rewards", {
		method = "GET",
	}):next(function (data)
		return data.body
	end)
end

implements(MissionBoard, Interface)

return MissionBoard
