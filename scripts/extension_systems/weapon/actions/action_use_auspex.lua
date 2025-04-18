-- chunkname: @scripts/extension_systems/weapon/actions/action_use_auspex.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUseAuspex = class("ActionUseAuspex", "ActionWeaponBase")

ActionUseAuspex.init = function (self, action_context, action_params, action_settings)
	ActionUseAuspex.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._minigame_character_state_component = unit_data_extension:write_component("minigame_character_state")
end

ActionUseAuspex.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionUseAuspex.super.start(self, action_settings, t, time_scale, action_start_params)

	self._minigame_character_state_component.pocketable_device_active = true

	self:trigger_anim_event("scan_start_che")
end

ActionUseAuspex.finish = function (self, reason, data, t, time_in_action)
	ActionUseAuspex.super.finish(self, reason, data, t, time_in_action)
end

return ActionUseAuspex
