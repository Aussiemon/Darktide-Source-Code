-- chunkname: @scripts/extension_systems/weapon/actions/action_focus_auspex.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionFocusAuspex = class("ActionFocusAuspex", "ActionWeaponBase")

ActionFocusAuspex.init = function (self, action_context, action_params, action_settings)
	ActionFocusAuspex.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._minigame_character_state_component = unit_data_extension:write_component("minigame_character_state")
end

ActionFocusAuspex.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionFocusAuspex.super.start(self, action_settings, t, time_scale, action_start_params)

	local character_state_machine_extension = ScriptUnit.has_extension(self._player_unit, "character_state_machine_system")
	local current_state_name = character_state_machine_extension:current_state_name()

	if current_state_name ~= "minigame" then
		self._minigame_character_state_component.pocketable_device_active = true

		self:trigger_anim_event("auspex_start_focus")
	else
		local current_state = character_state_machine_extension:current_state()

		current_state:force_cancel()
		self:trigger_anim_event("auspex_stop_focus")
	end
end

ActionFocusAuspex.finish = function (self, reason, data, t, time_in_action)
	ActionFocusAuspex.super.finish(self, reason, data, t, time_in_action)
end

return ActionFocusAuspex
