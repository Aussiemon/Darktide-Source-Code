local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local sfx_external_properties = {}
local vfx_external_properties = {}
local ThunderHammerEffects = class("ThunderHammerEffects")
local FX_SOURCE_NAME = "_special_active"
local SPECIAL_ACTIVE_LOOPING_SFX_CONFIG = PlayerCharacterLoopingSoundAliases.weapon_special_loop
local SPECIAL_ACTIVE_LOOPING_VFX_ALIAS = "weapon_special_loop"

ThunderHammerEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._is_husk = is_husk
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._slot = slot
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._equipment_component = context.equipment_component
	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._visual_loadout_extension = context.visual_loadout_extension
	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
	self._looping_effect_id = nil
end

ThunderHammerEffects.destroy = function (self)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop(true)
end

ThunderHammerEffects.wield = function (self)
	return
end

ThunderHammerEffects.unwield = function (self)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop(true)
end

ThunderHammerEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ThunderHammerEffects.update = function (self, unit, dt, t)
	self:_update_active()
end

ThunderHammerEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ThunderHammerEffects._update_active = function (self)
	local special_active = self._inventory_slot_component.special_active
	local current_playing_id = self._looping_playing_id
	local current_effect_id = self._looping_effect_id
	local should_start_sfx = not current_playing_id and special_active
	local should_stop_sfx = current_playing_id and not special_active
	local should_start_vfx = not current_effect_id and special_active
	local should_stop_vfx = current_effect_id and not special_active

	if should_start_sfx then
		self:_start_sfx_loop()
	elseif should_stop_sfx then
		self:_stop_sfx_loop()
	end

	if should_start_vfx then
		self:_start_vfx_loop()
	elseif should_stop_vfx then
		self:_stop_vfx_loop(false)
	end
end

ThunderHammerEffects._start_sfx_loop = function (self)
	local is_husk = self._is_husk
	local is_local_unit = self._is_local_unit
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local use_husk_event = is_husk or not is_local_unit
	local start_config = SPECIAL_ACTIVE_LOOPING_SFX_CONFIG.start
	local stop_config = SPECIAL_ACTIVE_LOOPING_SFX_CONFIG.stop
	local start_event_alias = start_config.event_alias
	local stop_event_alias = stop_config.event_alias
	local resolved, has_husk_events, event_name = nil
	resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(start_event_alias, sfx_external_properties)

	if resolved then
		if use_husk_event and has_husk_events then
			event_name = event_name .. "_husk" or event_name
		end

		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)
		self._looping_playing_id = new_playing_id
		resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(stop_event_alias, sfx_external_properties)

		if resolved then
			if use_husk_event and has_husk_events then
				event_name = event_name .. "_husk" or event_name
			end

			self._looping_stop_event_name = event_name
		end
	end
end

ThunderHammerEffects._stop_sfx_loop = function (self)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local current_playing_id = self._looping_playing_id
	local stop_event_name = self._looping_stop_event_name

	if stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

ThunderHammerEffects._start_vfx_loop = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(SPECIAL_ACTIVE_LOOPING_VFX_ALIAS, vfx_external_properties)

	if resolved then
		local world = self._world
		local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(self._special_active_fx_source_name)

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_effect_id = new_effect_id
	end
end

ThunderHammerEffects._stop_vfx_loop = function (self, destroy)
	local current_effect_id = self._looping_effect_id

	if current_effect_id then
		if destroy then
			World.destroy_particles(self._world, current_effect_id)
		else
			World.stop_spawning_particles(self._world, current_effect_id)
		end
	end

	self._looping_effect_id = nil
end

return ThunderHammerEffects
