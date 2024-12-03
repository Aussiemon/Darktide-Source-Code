-- chunkname: @scripts/extension_systems/weapon/actions/action_overload_charge_weapon_special.lua

require("scripts/extension_systems/weapon/actions/action_charge")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local WarpCharge = require("scripts/utilities/warp_charge")
local ActionOverloadChargeWeaponSpecial = class("ActionOverloadChargeWeaponSpecial", "ActionCharge")
local ALL_CLIENTS = true

ActionOverloadChargeWeaponSpecial.init = function (self, action_context, action_params, action_settings)
	ActionOverloadChargeWeaponSpecial.super.init(self, action_context, action_params, action_settings)

	local overload_module_class_name = action_settings.overload_module_class_name

	self._overload_module = ActionModules[overload_module_class_name]:new(self._player_unit, action_settings, self._inventory_slot_component)
end

ActionOverloadChargeWeaponSpecial.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionOverloadChargeWeaponSpecial.super.start(self, action_settings, t, time_scale, action_start_params)
	self._overload_module:start(t)

	self._weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or "none"

	local particle_name = action_settings.pre_activation_vfx_name

	if particle_name then
		local node_name = action_settings.pre_activation_vfx_node
		local position_offset, rotation_offset, scale
		local create_network_index = true

		self._pre_activation_particle_id = self._fx_extension:spawn_unit_particles(particle_name, node_name, true, "stop", position_offset, rotation_offset, scale, ALL_CLIENTS, create_network_index)
	end

	self:_start_warp_charge_action(t)

	local warp_charge_component = self._warp_charge_component
	local buff_extension = self._buff_extension

	WarpCharge.check_and_set_state(t, warp_charge_component, buff_extension)
end

ActionOverloadChargeWeaponSpecial.fixed_update = function (self, dt, t, time_in_action)
	ActionOverloadChargeWeaponSpecial.super.fixed_update(self, dt, t, time_in_action)
	self._overload_module:fixed_update(dt, t)

	local action_settings = self._action_settings
	local activation_time = action_settings.activation_time
	local should_activate = ActionUtility.is_within_trigger_time(time_in_action, dt, activation_time)

	if should_activate then
		local particle_id = self._pre_activation_particle_id

		if particle_id then
			self._fx_extension:stop_player_particles(particle_id, ALL_CLIENTS)

			self._pre_activation_particle_id = nil
		end

		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true, "trigger_window")

		local weapon_special_tweak_data = self._weapon_special_tweak_data
		local allow_reactivation_while_active = weapon_special_tweak_data and weapon_special_tweak_data.allow_reactivation_while_active

		if allow_reactivation_while_active then
			self._inventory_slot_component.num_special_charges = 0
		end
	end
end

ActionOverloadChargeWeaponSpecial.finish = function (self, reason, data, t, time_in_action)
	ActionOverloadChargeWeaponSpecial.super.finish(self, reason, data, t, time_in_action)
	self._overload_module:finish(reason, data, t)
end

ActionOverloadChargeWeaponSpecial.running_action_state = function (self, t, time_in_action)
	if self._overload_module.running_action_state then
		return self._overload_module:running_action_state(t, time_in_action)
	end
end

return ActionOverloadChargeWeaponSpecial
