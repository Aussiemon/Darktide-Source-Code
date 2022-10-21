require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionActivateSpecial = class("ActionActivateSpecial", "ActionWeaponBase")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_proc_events = BuffSettings.proc_events

ActionActivateSpecial.init = function (self, action_context, action_params, action_settings)
	ActionActivateSpecial.super.init(self, action_context, action_params, action_settings)

	local fx_sources = action_params.weapon.fx_sources
	local abort_fx_source_name = action_settings.abort_fx_source_name
	self._abort_fx_source_name = fx_sources[abort_fx_source_name]
end

ActionActivateSpecial.start = function (self, action_settings, t, time_scale, params)
	ActionActivateSpecial.super.start(self, action_settings, t, time_scale, params)

	self._weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or "none"
	local special_implementation = self._weapon.special_implementation

	if special_implementation then
		special_implementation:on_action_start(t, self._num_hit_enemies)
	end

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
