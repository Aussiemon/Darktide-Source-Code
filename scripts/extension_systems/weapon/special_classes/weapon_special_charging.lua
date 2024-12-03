-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_charging.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Overheat = require("scripts/utilities/overheat")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local proc_events = BuffSettings.proc_events
local buff_keywords = BuffSettings.keywords
local WeaponSpecialCharging = class("WeaponSpecialCharging")

WeaponSpecialCharging.init = function (self, context, init_data)
	self._weapon_extension = context.weapon_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	self._charge_component = context.action_module_charge_component
	self._weapon_template = init_data.weapon_template
	self._weapon_tweak_templates_component = context.weapon_tweak_templates_component
end

WeaponSpecialCharging.fixed_update = function (self, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local buff_extension = self._buff_extension
	local current_overheat_state = inventory_slot_component.overheat_state

	WeaponSpecial.update_active(t, self._tweak_data, inventory_slot_component, buff_extension, self._input_extension, self._weapon_extension)

	if inventory_slot_component.special_active then
		local weapon_extension = self._weapon_extension
		local charge_level = self._charge_component.charge_level
		local charge_template = weapon_extension:charge_template()

		if charge_template then
			Overheat.increase_over_time(dt, t, charge_level, inventory_slot_component, charge_template.overheat_overtime, self._player_unit)
		end

		local new_overheat_state = inventory_slot_component.overheat_state

		if new_overheat_state == "soft_lockout" and current_overheat_state ~= "soft_lockout" then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				buff_extension:add_proc_event(proc_events.on_overheat_soft_lockout, param_table)
			end
		end

		local use_overheat_soft_lockout = buff_extension:has_keyword(buff_keywords.use_overheat_soft_lockout)

		if not use_overheat_soft_lockout and new_overheat_state == "lockout" then
			weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "overheat_lockout")

			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				buff_extension:add_proc_event(proc_events.on_overheat_lockout, param_table)
			end
		end
	end
end

WeaponSpecialCharging.on_special_activation = function (self, t)
	self._weapon_tweak_templates_component.charge_template_name = self._weapon_template.special_charge_template
end

WeaponSpecialCharging.on_special_deactivation = function (self, t)
	local use_overheat_soft_lockout = self._buff_extension:has_keyword(buff_keywords.use_overheat_soft_lockout)
	local overheat_state = self._inventory_slot_component.overheat_state

	if use_overheat_soft_lockout and overheat_state == "soft_lockout" then
		self._inventory_slot_component.overheat_state = "lockout"
	end

	self._weapon_tweak_templates_component.charge_template_name = "none"
end

WeaponSpecialCharging.on_sweep_action_start = function (self, t)
	if self._inventory_slot_component.special_active then
		local charge_level = self._charge_component.charge_level
		local charge_template = self._weapon_extension:charge_template()

		if charge_template then
			Overheat.increase_immediate(t, charge_level, self._inventory_slot_component, charge_template.overheat_overtime, self._player_unit)
		end
	end
end

WeaponSpecialCharging.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialCharging.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	return
end

WeaponSpecialCharging.on_exit_damage_window = function (self, t, num_hit_enemies, aborted)
	return
end

implements(WeaponSpecialCharging, WeaponSpecialInterface)

return WeaponSpecialCharging
