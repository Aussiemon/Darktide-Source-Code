require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupCircumstance = class("WwiseStateGroupCircumstance", "WwiseStateGroupBase")

WwiseStateGroupCircumstance.update = function (self, dt, t)
	WwiseStateGroupCircumstance.super.update(self, dt, t)

	local wwise_state = WwiseGameSyncSettings.default_group_state
	local circumstance_manager = Managers.state.circumstance

	if circumstance_manager then
		local circumstance_name = circumstance_manager:circumstance_name()
		local circumstance_template = CircumstanceTemplates[circumstance_name]
		local circumstance_wwise_state = circumstance_template.wwise_state
		wwise_state = circumstance_wwise_state or wwise_state
	end

	self:_set_wwise_state(wwise_state)
end

return WwiseStateGroupCircumstance
