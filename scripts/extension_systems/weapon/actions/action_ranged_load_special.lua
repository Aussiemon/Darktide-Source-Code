require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AlternateFire = require("scripts/utilities/alternate_fire")
local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_proc_events = BuffSettings.proc_events
local ActionReloadShotgunSpecial = class("ActionReloadShotgunSpecial", "ActionWeaponBase")

ActionReloadShotgunSpecial.init = function (self, action_context, ...)
	ActionReloadShotgunSpecial.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_reload_component = unit_data_extension:write_component("action_reload")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._alternate_fire_component = unit_data_extension:write_component("alternate_fire")
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
end

ActionReloadShotgunSpecial.start = function (self, action_settings, t, time_scale, ...)
	ActionReloadShotgunSpecial.super.start(self, action_settings, t, time_scale, ...)

	if action_settings.stop_alternate_fire and self._alternate_fire_component.is_active then
		AlternateFire.stop(self._alternate_fire_component, self._peeking_component, self._first_person_extension, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, false, self._player_unit)
	end

	local action_reload_component = self._action_reload_component
	action_reload_component.has_refilled_ammunition = false
	action_reload_component.has_removed_ammunition = false
	local event_data = self._dialogue_input:get_event_data_payload()

	self._dialogue_input:trigger_dialogue_event("reloading", event_data)

	if Ammo.clip_ammo_is_full(self._player_unit) then
		local inventory_slot_component = self._inventory_slot_component
		inventory_slot_component.current_ammunition_clip = inventory_slot_component.current_ammunition_clip - 1
		inventory_slot_component.current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve + 1
	end
end

ActionReloadShotgunSpecial.fixed_update = function (self, dt, t, time_in_action)
	self:_reload(t, time_in_action)
end

ActionReloadShotgunSpecial.finish = function (self, reason, data, t, time_in_action)
	ActionReloadShotgunSpecial.super.finish(self, reason, data, t)
	self:_reload(t, time_in_action)
end

ActionReloadShotgunSpecial._reload = function (self, t, time_in_action)
	local action_reload_component = self._action_reload_component
	local inventory_slot_component = self._inventory_slot_component
	local weapon_action_component = self._weapon_action_component
	local reload_settings = self._action_settings.reload_settings
	local refill_at_time = reload_settings.refill_at_time
	local has_refilled_ammunition = action_reload_component.has_refilled_ammunition
	local time_scale = weapon_action_component.time_scale

	if time_in_action > refill_at_time * time_scale and not has_refilled_ammunition then
		local cost = reload_settings.cost

		if cost and cost > 0 then
			Ammo.remove_from_reserve(inventory_slot_component, cost)
		end

		local refill_amount = reload_settings.refill_amount

		if refill_amount and refill_amount > 0 then
			Ammo.add_to_clip(inventory_slot_component, refill_amount)
		end

		action_reload_component.has_refilled_ammunition = true

		self:_set_weapon_special(true, t)
	end
end

ActionReloadShotgunSpecial.running_action_state = function (self, t, time_in_action)
	local inventory_slot_component = self._inventory_slot_component
	local action_reload_component = self._action_reload_component
	local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
	local current_ammo_in_clip = inventory_slot_component.current_ammunition_clip
	local has_refilled_ammunition = action_reload_component.has_refilled_ammunition

	if current_ammo_in_clip < max_ammo_in_clip and has_refilled_ammunition then
		return "reload_loop"
	end

	return nil
end

return ActionReloadShotgunSpecial
