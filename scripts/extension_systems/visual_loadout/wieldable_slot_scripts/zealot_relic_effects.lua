local Action = require("scripts/utilities/weapon/action")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings_3 = TalentSettings.zealot_3
local EQUIPPED_LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local EQUIPPED_LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local FX_SOURCE_NAME = "_emit"
local external_properties = {}
local ZealotRelicEffects = class("ZealotRelicEffects")

ZealotRelicEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local unit = context.owner_unit
	local wwise_world = context.wwise_world
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._unit = unit
	self._world = context.world
	self._wwise_world = wwise_world
	self._vfx = weapon_template.vfx
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension
	self._tick_cooldown = 0
	self._start_tick_cooldown = 0
	self._num_tick = 0
	self._ability_extension = ScriptUnit.extension(unit, "ability_system")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	local first_person_component = unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	self._source_id = WwiseWorld.make_manual_source(wwise_world, unit, rotation)
end

ZealotRelicEffects.fixed_update = function (self, unit, dt, t)
	return
end

ZealotRelicEffects.update = function (self, unit, dt, t, frame)
	local current_action_name = self._weapon_action_component.current_action_name

	if current_action_name ~= "action_zealot_channel" then
		return
	end

	local tick_cooldown = self._tick_cooldown - dt

	if tick_cooldown <= 0 then
		self:_destroy_pulse_vfx()
		self:_on_channel_tick(t)

		tick_cooldown = talent_settings_3.bolstering_prayer.tick_rate
		self._num_tick = self._num_tick + 1
	end

	self._tick_cooldown = tick_cooldown
	local max = self._ability_extension:max_ability_cooldown("combat_ability")
	local current = self._ability_extension:remaining_ability_cooldown("combat_ability")
	local variable = (max - current) / max

	WwiseWorld.set_source_parameter(self._wwise_world, self._source_id, "player_ability_health", variable)
end

ZealotRelicEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ZealotRelicEffects._on_channel_tick = function (self, t, action_settings)
	action_settings = action_settings or Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	self._action_settings = action_settings

	if not self._action_settings then
		return
	end

	if self._num_tick == 0 then
		self:_trigger_pulse_sfx(t, action_settings)
		self:_trigger_pulse_vfx(t, action_settings)
	else
		self:_trigger_pulse_vfx(t, action_settings)
		self:_trigger_pulse_sfx(t, action_settings)
	end
end

ZealotRelicEffects._trigger_pulse_vfx = function (self, t, action_settings)
	self:_destroy_pulse_vfx()

	local time_in_action = t - self._weapon_action_component.start_t
	local effect_name = self._vfx.name
	local unit_position = Unit.world_position(self._unit, 1)
	local position = unit_position + Vector3.up()
	local radius_time_in_action_multiplier = action_settings.radius_time_in_action_multiplier or 0
	local radius = action_settings.radius + time_in_action * radius_time_in_action_multiplier
	local variable_name = "radius"
	local variable_value = Vector3(radius, radius, radius)
	local effect_id = World.create_particles(self._world, effect_name, position, nil, nil, nil)
	local variable_index = World.find_particles_variable(self._world, effect_name, variable_name)

	World.set_particles_variable(self._world, effect_id, variable_index, variable_value)

	self._effect_id = effect_id
end

ZealotRelicEffects._trigger_pulse_sfx = function (self, t, action_settings)
	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(external_properties)

	external_properties.ability_template = "zealot_relic"

	self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", external_properties, source_name, sync_to_clients, include_client)
end

ZealotRelicEffects._destroy_pulse_vfx = function (self)
	local world = self._world

	if self._effect_id then
		World.destroy_particles(world, self._effect_id)

		self._effect_id = nil
	end
end

ZealotRelicEffects.wield = function (self)
	self._tick_cooldown = self._start_tick_cooldown
	self._num_tick = 0

	self:_create_passive_vfx()
	self:_create_passive_sfx()
end

ZealotRelicEffects.unwield = function (self)
	if self._tick_cooldown < self._start_tick_cooldown then
		self:_destroy_pulse_vfx()

		local t = FixedFrame.get_latest_fixed_time()

		self:_on_channel_tick(t, self._action_settings)
	end

	self:_destroy_passive_vfx()
	self:_destroy_passive_sfx()
end

ZealotRelicEffects.destroy = function (self)
	self:_destroy_pulse_vfx()
	self:_destroy_passive_vfx()
	self:_destroy_passive_sfx()
end

ZealotRelicEffects._create_passive_vfx = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(EQUIPPED_LOOPING_PARTICLE_ALIAS, external_properties)

	if resolved then
		local world = self._world
		local effect_id = World.create_particles(world, effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(self._fx_source_name)

		World.link_particles(world, effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_passive_effect_id = effect_id
	end
end

ZealotRelicEffects._destroy_passive_vfx = function (self)
	if self._looping_passive_effect_id then
		World.destroy_particles(self._world, self._looping_passive_effect_id)

		self._looping_passive_effect_id = nil
	end
end

ZealotRelicEffects._create_passive_sfx = function (self)
	local visual_loadout_extension = self._visual_loadout_extension
	local is_husk = self._is_husk
	local is_local_unit = self._is_local_unit
	local fx_extension = self._fx_extension
	local fx_source_name = self._fx_source_name

	if not self._looping_passive_playing_id then
		local sound_config = PlayerCharacterLoopingSoundAliases[EQUIPPED_LOOPING_SOUND_ALIAS]
		local start_config = sound_config.start
		local start_event_alias = start_config.event_alias
		local resolved, has_husk_events, start_event_name, stop_event_name = nil
		resolved, start_event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(start_event_alias, external_properties)

		if resolved then
			local wwise_world = self._wwise_world
			local source_id = fx_extension:sound_source(fx_source_name)

			if (is_husk or not is_local_unit) and has_husk_events then
				start_event_name = start_event_name .. "_husk" or start_event_name
			end

			local playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event_name, source_id)
			self._looping_passive_playing_id = playing_id
			local stop_config = sound_config.stop
			local stop_event_alias = stop_config.event_alias
			resolved, stop_event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(stop_event_alias, external_properties)

			if resolved then
				if (is_husk or not is_local_unit) and has_husk_events then
					stop_event_name = stop_event_name .. "_husk" or stop_event_name
				end

				self._stop_event_name = stop_event_name
			end
		end
	end
end

ZealotRelicEffects._destroy_passive_sfx = function (self)
	local looping_passive_playing_id = self._looping_passive_playing_id

	if looping_passive_playing_id then
		local stop_event_name = self._stop_event_name

		if stop_event_name then
			local source_id = self._fx_extension:sound_source(self._fx_source_name)

			WwiseWorld.trigger_resource_event(self._wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(self._wwise_world, looping_passive_playing_id)
		end

		self._looping_passive_playing_id = nil
		self._stop_event_name = nil
	end
end

return ZealotRelicEffects
