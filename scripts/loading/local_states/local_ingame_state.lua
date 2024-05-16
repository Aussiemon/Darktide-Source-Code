-- chunkname: @scripts/loading/local_states/local_ingame_state.lua

local MissionTemplates = require("scripts/settings/mission/mission_templates")
local LocalIngameState = class("LocalIngameState")

LocalIngameState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	shared_state.state = "playing"
	self._mission_name = nil
end

LocalIngameState.destroy = function (self)
	self._mission_name = nil
end

LocalIngameState.update = function (self)
	local mission_name = self._mission_name

	if mission_name then
		local mission_template = MissionTemplates[mission_name]
		local is_hub = mission_template.is_hub

		if is_hub then
			return "load_hub"
		else
			return "load_mission"
		end
	end
end

LocalIngameState.load_mission = function (self)
	local shared_state = self._shared_state
	local mission_name = shared_state.mission_name

	self._mission_name = mission_name
end

return LocalIngameState
