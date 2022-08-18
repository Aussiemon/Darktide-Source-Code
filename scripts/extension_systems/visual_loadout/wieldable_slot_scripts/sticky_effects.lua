local Action = require("scripts/utilities/weapon/action")
local Armor = require("scripts/utilities/attack/armor")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local StickyEffects = class("StickyEffects")
local STICKY_FX_SOURCE_NAME = "_sticky"

StickyEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_husk = context.is_husk
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension
	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	local sticky_fx_source_name = fx_sources[STICKY_FX_SOURCE_NAME]
	self._sticky_fx_source_name = sticky_fx_source_name
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(sticky_fx_source_name)
	self._looping_playing_id = nil
	self._stop_event_name = nil
	self._looping_effect_id = nil
	self._was_sticky = false
	self._current_sticky_armor_type = nil
end

StickyEffects.destroy = function (self)
	self:_stop_stickyness()
end

StickyEffects.wield = function (self)
	return
end

StickyEffects.unwield = function (self)
	self:_stop_stickyness()
end

StickyEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

StickyEffects.update = function (self, unit, dt, t)
	local action_sweep_component = self._action_sweep_component
	local is_sticky = action_sweep_component.is_sticky
	local was_sticky = self._was_sticky

	if is_sticky and not was_sticky then
		self:_start_stickyness()
	elseif was_sticky and not is_sticky then
		self:_stop_stickyness()
	elseif was_sticky and is_sticky then
		self:_update_stickyness()
	end

	self._was_sticky = is_sticky
end

StickyEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

local external_properties = {
	armor_type = "n/a"
}

StickyEffects._start_stickyness = function (self, t)
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local special_active_at_start = weapon_action_component.special_active_at_start
	local hit_stickyness_settings = (special_active_at_start and action_settings.hit_stickyness_settings_special_active) or action_settings.hit_stickyness_settings

	if not hit_stickyness_settings then
		return
	end

	local action_sweep_component = self._action_sweep_component
	local sticky_armor_type = _sticky_armor_type(action_sweep_component)

	if sticky_armor_type and self._sticky_armor_type ~= sticky_armor_type then
		local visual_loadout_extension = self._visual_loadout_extension
		local sfx_loop_alias = hit_stickyness_settings.stickyness_sfx_loop_alias

		if sfx_loop_alias then
			local is_husk = self._is_husk
			local sound_config = PlayerCharacterLoopingSoundAliases[sfx_loop_alias]
			local start_config = sound_config.start
			local start_event_alias = start_config.event_alias
			local resolved, has_husk_events, start_event_name, stop_event_name = nil
			resolved, start_event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(start_event_alias)

			if resolved then
				local wwise_world = self._wwise_world
				local sticky_fx_source_name = self._sticky_fx_source_name
				local source_id = self._fx_extension:sound_source(sticky_fx_source_name)

				WwiseWorld.set_switch(self._wwise_world, "armor_types", sticky_armor_type, source_id)

				if is_husk and has_husk_events then
					start_event_name = start_event_name .. "_husk" or start_event_name
				end

				local playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event_name, source_id)
				self._looping_playing_id = playing_id
				local stop_config = sound_config.stop
				local stop_event_alias = stop_config.event_alias
				resolved, stop_event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(stop_event_alias)

				if resolved then
					if is_husk and has_husk_events then
						stop_event_name = stop_event_name .. "_husk" or stop_event_name
					end

					self._stop_event_name = stop_event_name
				end
			end
		end

		local vfx_loop_alias = hit_stickyness_settings.stickyness_vfx_loop_alias

		if vfx_loop_alias then
			local world = self._world
			local vfx_link_unit = self._vfx_link_unit
			local vfx_link_node = self._vfx_link_node
			external_properties.armor_type = _sticky_armor_type(action_sweep_component)
			local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(vfx_loop_alias, external_properties)

			if resolved then
				local effect_id = World.create_particles(world, effect_name, Vector3.zero())

				World.link_particles(world, effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

				self._looping_effect_id = effect_id
			end
		end
	end

	self._current_sticky_armor_type = sticky_armor_type
end

StickyEffects._update_stickyness = function (self)
	local action_sweep_component = self._action_sweep_component
	local sticky_armor_type = _sticky_armor_type(action_sweep_component)

	if sticky_armor_type and sticky_armor_type ~= self._current_sticky_armor_type then
		self._current_sticky_armor_type = sticky_armor_type
		local source_id = self._fx_extension:sound_source(self._sticky_fx_source_name)

		WwiseWorld.set_switch(self._wwise_world, "armor_types", sticky_armor_type, source_id)
	end
end

StickyEffects._stop_stickyness = function (self)
	local looping_playing_id = self._looping_playing_id

	if looping_playing_id then
		local stop_event_name = self._stop_event_name

		if stop_event_name then
			local source_id = self._fx_extension:sound_source(self._sticky_fx_source_name)

			WwiseWorld.trigger_resource_event(self._wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(self._wwise_world, looping_playing_id)
		end

		self._looping_playing_id = nil
		self._stop_event_name = nil
	end

	if self._looping_effect_id then
		World.stop_spawning_particles(self._world, self._looping_effect_id)

		self._looping_effect_id = nil
	end

	self._current_sticky_armor_type = nil
end

function _sticky_armor_type(action_sweep_component)
	local stick_to_unit, stick_to_actor = SweepStickyness.unit_which_aborted_sweep(action_sweep_component)

	if stick_to_unit and stick_to_actor then
		local hit_zone_name = stick_to_actor and HitZone.get_name(stick_to_unit, stick_to_actor)
		local unit_data_extension = hit_zone_name and ScriptUnit.extension(stick_to_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()
		local sticky_armor_type = breed and Armor.armor_type(stick_to_unit, breed, hit_zone_name)

		return sticky_armor_type
	end
end

return StickyEffects
