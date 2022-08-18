require("scripts/extension_systems/weapon/actions/action_charge")

local Ammo = require("scripts/utilities/ammo")
local ActionChargeAmmo = class("ActionChargeAmmo", "ActionCharge")

ActionChargeAmmo.start = function (self, action_settings, t, time_scale, action_start_params)
	local charge_template = self._weapon_extension:charge_template()

	if charge_template.limit_max_charge_to_ammo_clip then
		local unit = self._player_unit
		local slot_name = self._inventory_component.wielded_slot
		local max_ammo_charge = charge_template.max_ammo_charge
		local starting_ammo_percentage = nil

		if max_ammo_charge then
			starting_ammo_percentage = Ammo.current_slot_ammo_consumption_percentage(unit, slot_name, max_ammo_charge)
		else
			starting_ammo_percentage = Ammo.current_slot_clip_percentage(unit, slot_name)
		end

		local limit_func = charge_template.max_charge_limit_func

		if limit_func then
			self._charge_component.max_charge = charge_template.max_charge_limit_func(starting_ammo_percentage)
		else
			self._charge_component.max_charge = starting_ammo_percentage
		end
	else
		self._charge_component.max_charge = 1
	end

	local charge_effects = action_settings.charge_effects
	local charge_done_sound_alias = charge_effects.charge_done_sound_alias
	self._is_charge_done_sound_played = charge_done_sound_alias == nil
	self._charge_done_sound_alias = charge_done_sound_alias

	ActionChargeAmmo.super.start(self, action_settings, t, time_scale, action_start_params)
end

ActionChargeAmmo.fixed_update = function (self, dt, t, time_in_action)
	ActionChargeAmmo.super.fixed_update(self, dt, t, time_in_action)

	if self._fx_muzzle_source_name and not self._is_charge_done_sound_played then
		local charge_done = self._charge_component.max_charge <= self._charge_component.charge_level

		if charge_done then
			local sync_to_clients = false
			local external_properties = nil

			self._fx_extension:trigger_gear_wwise_event_with_source(self._charge_done_sound_alias, external_properties, self._fx_muzzle_source_name, sync_to_clients)

			self._is_charge_done_sound_played = true
		end
	end
end

return ActionChargeAmmo
