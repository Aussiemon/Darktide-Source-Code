-- chunkname: @scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_zone.lua

require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupZone = class("WwiseStateGroupZone", "WwiseStateGroupBase")

WwiseStateGroupZone.update = function (self, dt, t)
	WwiseStateGroupZone.super.update(self, dt, t)

	local wwise_state = WwiseGameSyncSettings.default_group_state
	local mission_manager = Managers.state and Managers.state.mission

	if mission_manager then
		local mission = mission_manager:mission()

		wwise_state = mission and mission.wwise_state or wwise_state
	end

	self:_set_wwise_state(wwise_state)
end

return WwiseStateGroupZone
