-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/grimoire_effects.lua

local Action = require("scripts/utilities/weapon/action")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local EQUIPPED_LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local EQUIPPED_LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local DISCARD_FINISH_PARTICLE_ALIAS = "grimoire_destroy"
local DISCARD_START_SOUND_ALIAS = "windup_start"
local DISCARD_STOP_SOUND_ALIAS = "windup_stop"
local SOURCE_NAME = "_passive"
local SYNC_TO_CLIENTS = false
local INCLUDE_CLIENT = false
local DESTROY_TIME = 0.2
local EXTERNAL_PROPERTIES = {}
local GrimoireEffects = class("GrimoireEffects")

GrimoireEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_husk = context.is_husk
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._slot = slot
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._discard_finish_effect_id = nil
	self._discard_playing_id = nil
	self._looping_idle_effect_id = nil
	self._looping_idle_playing_id = nil

	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension

	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	local fx_source_name = fx_sources[SOURCE_NAME]

	self._fx_source_name = fx_source_name
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_source_name)
end

GrimoireEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

GrimoireEffects.update = function (self, unit, dt, t)
	self:_update_discard(t)
end

GrimoireEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

GrimoireEffects.wield = function (self)
	self:_start_idle_effects()
end

GrimoireEffects.unwield = function (self)
	self:_stop_all_effects()
end

GrimoireEffects.destroy = function (self)
	self:_stop_all_effects()
end

GrimoireEffects._stop_all_effects = function (self)
	self:_stop_idle_effects()
	self:_stop_discard_effects()
end

GrimoireEffects._update_discard = function (self, t)
	local weapon_action_component = self._weapon_action_component
	local start_t = weapon_action_component.start_t
	local time_in_action = t - start_t
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)

	if not action_settings then
		self:_stop_discard_effects()

		return
	end

	local fx_extension = self._fx_extension
	local source_name = self._fx_source_name
	local action_kind = action_settings.kind

	if action_kind == "windup" and not self._discard_playing_id then
		self._discard_playing_id = fx_extension:trigger_gear_wwise_event_with_source(DISCARD_START_SOUND_ALIAS, EXTERNAL_PROPERTIES, source_name, SYNC_TO_CLIENTS, INCLUDE_CLIENT)
	elseif action_kind ~= "windup" and self._discard_playing_id then
		fx_extension:trigger_gear_wwise_event_with_source(DISCARD_STOP_SOUND_ALIAS, EXTERNAL_PROPERTIES, source_name, SYNC_TO_CLIENTS, INCLUDE_CLIENT)

		self._discard_playing_id = nil
	end

	self:_update_discard_finish(time_in_action, action_settings)
end

GrimoireEffects._update_discard_finish = function (self, time_in_action, action_settings)
	local action_kind = action_settings.kind

	if action_kind == "discard" and time_in_action > DESTROY_TIME and not self._discard_finish_effect_id then
		self:_stop_all_effects()

		self._discard_finish_effect_id = self._fx_extension:spawn_gear_particle_effect_with_source(DISCARD_FINISH_PARTICLE_ALIAS, EXTERNAL_PROPERTIES, self._fx_source_name, true, "stop")

		local unit_1p = self._slot.unit_1p
		local unit_3p = self._slot.unit_3p

		Unit.set_unit_visibility(unit_1p, false, true)
		Unit.set_unit_visibility(unit_3p, false, true)
	end
end

GrimoireEffects._start_idle_effects = function (self)
	local visual_loadout_extension = self._visual_loadout_extension
	local is_husk = self._is_husk
	local is_local_unit = self._is_local_unit
	local fx_extension = self._fx_extension
	local fx_source_name = self._fx_source_name

	if not self._looping_idle_effect_id then
		local world = self._world
		local vfx_link_unit, vfx_link_node = self._vfx_link_unit, self._vfx_link_node
		local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(EQUIPPED_LOOPING_PARTICLE_ALIAS, EXTERNAL_PROPERTIES)

		if resolved then
			local effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_idle_effect_id = effect_id
		end
	end

	if not self._looping_idle_playing_id then
		local sound_config = PlayerCharacterLoopingSoundAliases[EQUIPPED_LOOPING_SOUND_ALIAS]
		local start_config = sound_config.start
		local start_event_alias = start_config.event_alias
		local resolved, has_husk_events, start_event_name, stop_event_name

		resolved, start_event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(start_event_alias, EXTERNAL_PROPERTIES)

		if resolved then
			local wwise_world = self._wwise_world
			local source_id = fx_extension:sound_source(fx_source_name)

			start_event_name = (is_husk or not is_local_unit) and has_husk_events and start_event_name .. "_husk" or start_event_name

			local playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event_name, source_id)

			self._looping_idle_playing_id = playing_id

			local stop_config = sound_config.stop
			local stop_event_alias = stop_config.event_alias

			resolved, stop_event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(stop_event_alias, EXTERNAL_PROPERTIES)

			if resolved then
				stop_event_name = (is_husk or not is_local_unit) and has_husk_events and stop_event_name .. "_husk" or stop_event_name
				self._stop_event_name = stop_event_name
			end
		end
	end
end

GrimoireEffects._stop_discard_effects = function (self)
	if self._discard_playing_id then
		self._fx_extension:trigger_gear_wwise_event_with_source(DISCARD_STOP_SOUND_ALIAS, EXTERNAL_PROPERTIES, self._fx_source_name, SYNC_TO_CLIENTS, INCLUDE_CLIENT)

		self._discard_playing_id = nil
	end
end

GrimoireEffects._stop_idle_effects = function (self)
	if self._looping_idle_effect_id then
		World.destroy_particles(self._world, self._looping_idle_effect_id)

		self._looping_idle_effect_id = nil
	end

	local looping_idle_playing_id = self._looping_idle_playing_id

	if looping_idle_playing_id then
		local stop_event_name = self._stop_event_name

		if stop_event_name then
			local source_id = self._fx_extension:sound_source(self._fx_source_name)

			WwiseWorld.trigger_resource_event(self._wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(self._wwise_world, looping_idle_playing_id)
		end

		self._looping_idle_playing_id = nil
		self._stop_event_name = nil
	end
end

return GrimoireEffects
