-- chunkname: @scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_objective_progression.lua

require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupObjectiveProgression = class("WwiseStateGroupObjectiveProgression", "WwiseStateGroupBase")

WwiseStateGroupObjectiveProgression.init = function (self, wwise_world, wwise_state_group_name)
	WwiseStateGroupObjectiveProgression.super.init(self, wwise_world, wwise_state_group_name)

	self._mission_objective_system = nil
end

WwiseStateGroupObjectiveProgression.on_gameplay_post_init = function (self, level)
	WwiseStateGroupObjectiveProgression.super.on_gameplay_post_init(self, level)

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	self._mission_objective_system = mission_objective_system
end

WwiseStateGroupObjectiveProgression.on_gameplay_shutdown = function (self)
	WwiseStateGroupObjectiveProgression.super.on_gameplay_shutdown(self)

	self._mission_objective_system = nil
end

WwiseStateGroupObjectiveProgression.update = function (self, dt, t)
	WwiseStateGroupObjectiveProgression.super.update(self, dt, t)

	local wwise_state = WwiseGameSyncSettings.default_group_state

	if self._mission_objective_system then
		local event_progress = self._mission_objective_system:get_objective_event_music_progress()

		if event_progress then
			if event_progress >= 0 and event_progress < 0.33 then
				wwise_state = "one"
			elseif event_progress >= 0.33 and event_progress < 0.66 then
				wwise_state = "two"
			elseif event_progress >= 0.66 and event_progress < 1 then
				wwise_state = "three"
			end
		end
	end

	self:_set_wwise_state(wwise_state)
end

return WwiseStateGroupObjectiveProgression
