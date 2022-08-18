local MissionTemplates = require("scripts/settings/mission/mission_templates")

local function _warning(...)
	Log.info("LocalDetermineLevelState", ...)
end

local LocalDetermineLevelState = class("LocalDetermineLevelState")

LocalDetermineLevelState.init = function (self, state_machine, shared_state)
	fassert(type(shared_state.network_delegate) == "table", "Network delegate required")
	fassert(type(shared_state.timeout) == "number", "Timeout required")
	fassert(type(shared_state.host_channel_id) == "number", "Host channel required")
	fassert(type(shared_state.loaders) == "table", "Loaders are required")
	fassert(shared_state.mission_name == nil, "Mission name must be cleared")

	self._shared_state = shared_state
	self._mission_name = nil
end

LocalDetermineLevelState.destroy = function (self)
	self._mission_name = nil
end

LocalDetermineLevelState.update = function (self, dt)
	local mission_name = self._mission_name

	if mission_name then
		local mission_template = MissionTemplates[mission_name]
		local is_hub = mission_template.is_hub

		if is_hub then
			return "hub_determined"
		else
			return "mission_determined"
		end
	end
end

LocalDetermineLevelState.load_mission = function (self)
	local shared_state = self._shared_state
	local mission_name = shared_state.mission_name
	self._mission_name = mission_name
end

return LocalDetermineLevelState
