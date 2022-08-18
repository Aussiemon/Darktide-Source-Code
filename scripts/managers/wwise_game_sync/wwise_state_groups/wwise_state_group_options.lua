require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupOptions = class("WwiseStateGroupOptions", "WwiseStateGroupBase")
local STATES = WwiseGameSyncSettings.state_groups.options

WwiseStateGroupOptions.init = function (self, wwise_world, wwise_state_group_name)
	WwiseStateGroupOptions.super.init(self, wwise_world, wwise_state_group_name)
end

WwiseStateGroupOptions.update = function (self, dt, t)
	WwiseStateGroupOptions.super.update(self, dt, t)

	local ui_wwise_state = Managers.ui:wwise_music_state(self._wwise_state_group_name)

	if ui_wwise_state then
		self:_set_wwise_state(ui_wwise_state)

		return
	else
		self:_set_wwise_state(STATES.none)
	end
end

return WwiseStateGroupOptions
