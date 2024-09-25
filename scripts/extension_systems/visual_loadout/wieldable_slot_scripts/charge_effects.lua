-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/charge_effects.lua

local Action = require("scripts/utilities/weapon/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ChargeEffects = class("ChargeEffects")

ChargeEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._fx_sources = fx_sources

	local owner_unit = context.owner_unit

	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._weapon_template = weapon_template
	self._weapon_template_charge_effects = weapon_template.charge_effects

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	self._is_charge_done_sound_played = true
end

ChargeEffects.fixed_update = function (self, unit, dt, t, frame)
	local charge_level = self:_charge_level(t)
	local have_charge = charge_level > 0

	if not self._played_start_effects and have_charge then
		self:_start_effects(t)

		self._played_start_effects = true
		self._is_charge_done_sound_played = false
	elseif self._played_start_effects and not have_charge then
		self:_stop_effects(t)

		self._played_start_effects = false
		self._is_charge_done_sound_played = false
	end

	self:_play_charged_done_effects()
end

ChargeEffects.update = function (self, unit, dt, t)
	self:_update_sfx_parameter(t)
end

ChargeEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ChargeEffects.wield = function (self)
	self._is_charge_done_sound_played = true
end

ChargeEffects.unwield = function (self)
	self._is_charge_done_sound_played = true

	self:_stop_effects()
end

ChargeEffects.destroy = function (self)
	self:_stop_effects()
end

ChargeEffects._start_effects = function (self, t)
	local fx_extension = self._fx_extension
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local charge_effects = action_settings and action_settings.charge_effects or self._weapon_template_charge_effects

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
			self._should_fade_kill = not not charge_effects.should_fade_kill
		end

		self._played_start_effects = true
	end

	return true
end

ChargeEffects._stop_effects = function (self)
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

	self._played_start_effects = false
	self._is_charge_done_sound_played = false
end

ChargeEffects._play_charged_done_effects = function (self)
	local fx_extension = self._fx_extension
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local charge_effects = action_settings and action_settings.charge_effects or self._weapon_template_charge_effects
	local fx_sources = self._fx_sources

	if not charge_effects then
		return
	end

	local charge_done_source_name = charge_effects.charge_done_source_name

	if charge_done_source_name and not self._is_charge_done_sound_played then
		local action_module_charge_component = self._action_module_charge_component
		local charge_done = action_module_charge_component.charge_level >= action_module_charge_component.max_charge

		if charge_done then
			local sync_to_clients = false
			local external_properties
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

ChargeEffects._charge_level = function (self, t)
	local action_module_charge_component = self._action_module_charge_component
	local charge_level = action_module_charge_component.charge_level

	return charge_level
end

ChargeEffects._update_sfx_parameter = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local charge_effects = action_settings and action_settings.charge_effects or self._weapon_template_charge_effects
	local charge_sfx_parameter = charge_effects and charge_effects.sfx_parameter

	if charge_sfx_parameter == nil then
		return
	end

	local fx_source_name = charge_effects.sfx_source_name
	local source_name = self._fx_sources[fx_source_name]
	local wwise_world, source = self._wwise_world, self._fx_extension:sound_source(source_name)
	local charge_level = self:_charge_level(t)

	WwiseWorld.set_source_parameter(wwise_world, source, charge_sfx_parameter, charge_level)
end

implements(ChargeEffects, WieldableSlotScriptInterface)

return ChargeEffects
