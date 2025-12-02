-- chunkname: @scripts/extension_systems/weapon/actions/action_toggle_weapon_special.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local WieldableSlotScripts = require("scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts")
local ActionToggleWeaponSpecial = class("ActionToggleWeaponSpecial", "ActionWeaponBase")

ActionToggleWeaponSpecial.init = function (self, action_context, action_params, action_settings)
	ActionToggleWeaponSpecial.super.init(self, action_context, action_params, action_settings)

	self._visual_loadout_extension = ScriptUnit.has_extension(action_params.player_unit, "visual_loadout_system")
end

ActionToggleWeaponSpecial.start = function (self, action_settings, t, ...)
	ActionToggleWeaponSpecial.super.start(self, action_settings, t, ...)

	if not action_settings.anim_event then
		local inventory_slot_component = self._inventory_slot_component
		local special_active = inventory_slot_component.special_active
		local activate_anim_event = action_settings.activate_anim_event
		local deactivate_anim_event = action_settings.deactivate_anim_event
		local activate_anim_event_3p = action_settings.activate_anim_event_3p or activate_anim_event
		local deactivate_anim_event_3p = action_settings.deactivate_anim_event_3p or deactivate_anim_event

		if special_active and deactivate_anim_event then
			self:trigger_anim_event(deactivate_anim_event, deactivate_anim_event_3p)
		elseif not special_active and activate_anim_event then
			self:trigger_anim_event(activate_anim_event, activate_anim_event_3p)
		end
	end

	local wieldable_slot_scripts = self._visual_loadout_extension:current_wielded_slot_scripts()

	if wieldable_slot_scripts then
		WieldableSlotScripts.on_weapon_special_toggle(wieldable_slot_scripts)
	end
end

ActionToggleWeaponSpecial.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local weapon_action_component = self._weapon_action_component
	local should_deactivate = weapon_action_component.special_active_at_start
	local trigger_time = should_deactivate and action_settings.deactivation_time or action_settings.activation_time
	local should_toggle = ActionUtility.is_within_trigger_time(time_in_action, dt, trigger_time)

	if should_deactivate and should_toggle then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "manual_toggle")
	elseif not should_deactivate and should_toggle then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true, "manual_toggle")
	end
end

ActionToggleWeaponSpecial.finish = function (self, reason, data, t, time_in_action, action_settings, next_action_params)
	ActionToggleWeaponSpecial.super.finish(self, reason, data, t, time_in_action, action_settings, next_action_params)

	local wieldable_slot_scripts = self._visual_loadout_extension:current_wielded_slot_scripts()

	if wieldable_slot_scripts then
		WieldableSlotScripts.on_weapon_special_toggle_finished(wieldable_slot_scripts, reason)
	end
end

return ActionToggleWeaponSpecial
