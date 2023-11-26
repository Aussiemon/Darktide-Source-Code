-- chunkname: @scripts/extension_systems/weapon/actions/action_activate_special.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local ActionActivateSpecial = class("ActionActivateSpecial", "ActionWeaponBase")

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

		self._pre_activation_particle_id = self._fx_extension:spawn_unit_particles(particle_name, node_name, true, "stop", nil, nil, nil, false)
	end
end

ActionActivateSpecial.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local activation_time = action_settings.activation_time
	local should_activate = ActionUtility.is_within_trigger_time(time_in_action, dt, activation_time)

	if should_activate then
		local particle_id = self._pre_activation_particle_id

		if particle_id then
			self._fx_extension:stop_player_particles(particle_id)
		end

		self:_set_weapon_special(true, t)

		local weapon_special_tweak_data = self._weapon_special_tweak_data
		local allow_reactivation_while_active = weapon_special_tweak_data and weapon_special_tweak_data.allow_reactivation_while_active

		if allow_reactivation_while_active then
			self._inventory_slot_component.num_special_activations = 0
		end
	end
end

ActionActivateSpecial.finish = function (self, reason, data, t, time_in_action)
	ActionActivateSpecial.super.finish(self, reason, data, t, time_in_action)

	if reason ~= "action_complete" then
		local action_settings = self._action_settings
		local abort_sound_alias = action_settings.abort_sound_alias

		if abort_sound_alias then
			-- Nothing
		end
	end
end

return ActionActivateSpecial
