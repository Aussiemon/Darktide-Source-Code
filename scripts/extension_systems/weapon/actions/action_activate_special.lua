-- chunkname: @scripts/extension_systems/weapon/actions/action_activate_special.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local ActionActivateSpecial = class("ActionActivateSpecial", "ActionWeaponBase")
local ALL_CLIENTS = false

ActionActivateSpecial.init = function (self, action_context, action_params, action_settings)
	ActionActivateSpecial.super.init(self, action_context, action_params, action_settings)

	local fx_sources = action_params.weapon.fx_sources
	local abort_fx_source_name = action_settings.abort_fx_source_name

	self._abort_fx_source_name = fx_sources[abort_fx_source_name]

	local weapon_template = self._weapon_template
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	self._weapon_special_tweak_data = weapon_special_tweak_data
end

ActionActivateSpecial.start = function (self, action_settings, t, time_scale, params)
	ActionActivateSpecial.super.start(self, action_settings, t, time_scale, params)

	self._weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or "none"

	local particle_name = action_settings.pre_activation_vfx_name

	if particle_name then
		local node_name = action_settings.pre_activation_vfx_node
		local position_offset, rotation_offset, scale
		local create_network_index = true

		self._pre_activation_particle_id = self._fx_extension:spawn_unit_particles(particle_name, node_name, true, "stop", position_offset, rotation_offset, scale, ALL_CLIENTS, create_network_index)
	end
end

ActionActivateSpecial.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local activation_time = action_settings.activation_time
	local should_activate = ActionUtility.is_within_trigger_time(time_in_action, dt, activation_time)

	if should_activate then
		local particle_id = self._pre_activation_particle_id

		if particle_id then
			self._fx_extension:stop_player_particles(particle_id, ALL_CLIENTS)

			self._pre_activation_particle_id = nil
		end

		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true, "manual_toggle")

		local weapon_special_tweak_data = self._weapon_special_tweak_data
		local allow_reactivation_while_active = weapon_special_tweak_data and weapon_special_tweak_data.allow_reactivation_while_active
		local clear_charges_on_activation = weapon_special_tweak_data and weapon_special_tweak_data.clear_charges_on_activation

		if allow_reactivation_while_active or clear_charges_on_activation then
			self._inventory_slot_component.num_special_charges = 0
		end
	end
end

return ActionActivateSpecial
