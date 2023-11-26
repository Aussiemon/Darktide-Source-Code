-- chunkname: @scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_circumstance.lua

require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupCircumstance = class("WwiseStateGroupCircumstance", "WwiseStateGroupBase")

WwiseStateGroupCircumstance.update = function (self, dt, t)
	WwiseStateGroupCircumstance.super.update(self, dt, t)
end

WwiseStateGroupCircumstance.on_gameplay_post_init = function (self, level)
	local circumstance_manager = Managers.state.circumstance
	local circumstance_name = circumstance_manager:circumstance_name()

	if circumstance_name then
		local circumstance_template = CircumstanceTemplates[circumstance_name]
		local circumstance_wwise_state = circumstance_template.wwise_state
		local wwise_state = circumstance_wwise_state or WwiseGameSyncSettings.default_group_state

		self:_set_wwise_state(wwise_state)

		local wwise_event_init = circumstance_template.wwise_event_init

		if wwise_event_init then
			WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_init)
		end
	end
end

WwiseStateGroupCircumstance.on_gameplay_shutdown = function (self)
	local circumstance_manager = Managers.state.circumstance

	if not circumstance_manager then
		return
	end

	local circumstance_name = circumstance_manager:circumstance_name()

	if circumstance_name then
		local circumstance_template = CircumstanceTemplates[circumstance_name]
		local wwise_event_stop = circumstance_template.wwise_event_stop

		if wwise_event_stop then
			WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_stop)
		end

		self:_set_wwise_state(WwiseGameSyncSettings.default_group_state)
	end
end

return WwiseStateGroupCircumstance
