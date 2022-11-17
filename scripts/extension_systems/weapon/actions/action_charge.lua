require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionCharge = class("ActionCharge", "ActionWeaponBase")

ActionCharge.init = function (self, action_context, action_params, action_settings)
	ActionCharge.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local first_person_unit = self._first_person_unit
	local physics_world = self._physics_world
	local unit_data_extension = action_context.unit_data_extension
	local action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	self._action_module_charge_component = action_module_charge_component
	self._charge_module = ActionModules.charge:new(physics_world, player_unit, first_person_unit, action_module_charge_component, action_settings)
	self._action_settings = action_settings
	local weapon = action_params.weapon
	self._fx_sources = weapon.fx_sources
end

ActionCharge.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionCharge.super.start(self, action_settings, t, time_scale, action_start_params)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
	self._played_start_effects = false
	self._action_module_charge_component.max_charge = 1
	local charge_template = self._weapon_extension:charge_template()
	local charge_level = self._action_module_charge_component.charge_level
	local have_charge = charge_level > 0
	local keep_charge = action_settings.keep_charge and have_charge

	if charge_template and charge_template.charge_on_action_start and not keep_charge then
		self._charge_module:start(t)
	end

	self._is_charge_done_sound_played = false
end

ActionCharge.update = function (self, dt, t)
	self:_play_charged_done_effects()

	local action_settings = self._action_settings
	local action_module_charge_component = self._action_module_charge_component
	local charge_level = action_module_charge_component.charge_level
	local weapon_template = self._weapon_template
	local charge_effects = action_settings and action_settings.charge_effects or weapon_template and weapon_template.charge_effects
	local charge_sfx_parameter = charge_effects and charge_effects.sfx_parameter

	if charge_sfx_parameter == nil then
		return
	end

	local fx_source_name = charge_effects.sfx_source_name
	local source_name = self._fx_sources[fx_source_name]
	local wwise_world = self._wwise_world
	local source = self._fx_extension:sound_source(source_name)
	local parameter = charge_sfx_parameter
	local parameter_value = charge_level

	WwiseWorld.set_source_parameter(wwise_world, source, parameter, parameter_value)
end

ActionCharge.fixed_update = function (self, dt, t, time_in_action, ignore_update_charge_module)
	if not ignore_update_charge_module then
		self._charge_module:fixed_update(dt, t)
	end

	if not self._played_start_effects then
		self._played_start_effects = self:_play_start_effects(t)
	end
end

ActionCharge._play_start_effects = function (self, t)
	local fx_extension = self._fx_extension
	local action_settings = self._action_settings
	local charge_template = self._weapon_extension:charge_template()
	local time_in_action = t - self._weapon_action_component.start_t
	local charge_delay = charge_template.charge_delay or 0

	if time_in_action < charge_delay then
		return false
	end

	local charge_effects = action_settings.charge_effects

	if charge_effects then
		local fx_sources = self._fx_sources
		local looping_sound_alias = charge_effects.looping_sound_alias
		local looping_sound_is_playing = looping_sound_alias and fx_extension:is_looping_wwise_event_playing(looping_sound_alias)

		if looping_sound_alias and not looping_sound_is_playing then
			local sfx_source_name = charge_effects.sfx_source_name
			local sfx_source = fx_sources[sfx_source_name]

			fx_extension:trigger_looping_wwise_event(looping_sound_alias, sfx_source)

			self._looping_sound_alias = looping_sound_alias
		end

		local looping_effect_alias = charge_effects.looping_effect_alias
		local looping_effect_is_playing = looping_effect_alias and fx_extension:is_looping_particles_playing(looping_effect_alias)

		if looping_effect_alias and not looping_effect_is_playing then
			local vfx_source_name = charge_effects.vfx_source_name
			local vfx_source = fx_sources[vfx_source_name]

			fx_extension:spawn_looping_particles(looping_effect_alias, vfx_source)

			self._looping_effect_alias = looping_effect_alias
			self._should_fade_kill = not charge_effects.destroy_on_end
		end
	end

	return true
end

ActionCharge._play_charged_done_effects = function (self)
	local fx_extension = self._fx_extension
	local action_settings = self._action_settings
	local charge_effects = action_settings.charge_effects
	local fx_sources = self._fx_sources

	if not charge_effects then
		return
	end

	local charge_done_source_name = charge_effects.charge_done_source_name

	if charge_done_source_name and not self._is_charge_done_sound_played then
		local action_module_charge_component = self._action_module_charge_component
		local charge_done = action_module_charge_component.max_charge <= action_module_charge_component.charge_level

		if charge_done then
			local sync_to_clients = false
			local external_properties = nil
			local charge_done_source = fx_sources[charge_done_source_name]
			local charge_done_sound_alias = charge_effects.charge_done_sound_alias

			if charge_done_sound_alias then
				fx_extension:trigger_gear_wwise_event_with_source(charge_done_sound_alias, external_properties, charge_done_source, sync_to_clients)
			end

			local charge_done_effect_alias = charge_effects.charge_done_effect_alias

			if charge_done_effect_alias then
				local link = true
				local orphaned_policy = "destroy"

				fx_extension:spawn_gear_particle_effect_with_source(charge_done_effect_alias, external_properties, charge_done_source, link, orphaned_policy)
			end

			self._is_charge_done_sound_played = true
		end
	end
end

ActionCharge.finish = function (self, reason, data, t, time_in_action)
	ActionCharge.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings
	local ignore_reset = action_settings.ignore_reset
	local reset_charge_action_kinds = action_settings.reset_charge_action_kinds

	self._charge_module:finish(reason, data, t, false, ignore_reset, reset_charge_action_kinds)

	local fx_extension = self._fx_extension
	local looping_sound_alias = self._looping_sound_alias
	local looping_sound_is_playing = looping_sound_alias and fx_extension:is_looping_wwise_event_playing(looping_sound_alias)

	if looping_sound_alias and looping_sound_is_playing then
		fx_extension:stop_looping_wwise_event(looping_sound_alias)

		self._looping_sound_alias = nil
	end

	local looping_effect_alias = self._looping_effect_alias
	local looping_effect_is_playing = looping_effect_alias and fx_extension:is_looping_particles_playing(looping_effect_alias)

	if looping_effect_alias and looping_effect_is_playing then
		fx_extension:stop_looping_particles(looping_effect_alias, self._should_fade_kill)

		self._looping_effect_alias = nil
	end

	if reason ~= "new_interrupting_action" then
		self._weapon_tweak_templates_component.spread_template_name = self._weapon_template.spread_template or "none"
	end

	self._played_start_effects = false
end

ActionCharge.running_action_state = function (self, t, time_in_action)
	local charge_level = self._action_module_charge_component.charge_level
	local charge_template = self._weapon_extension:charge_template()
	local fully_charged_charge_level = charge_template.fully_charged_charge_level or 1

	if charge_level >= fully_charged_charge_level then
		return "fully_charged"
	end

	return nil
end

return ActionCharge
