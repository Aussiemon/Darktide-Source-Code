-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/shock_maul_hit_effects.lua

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ShockMaulHitEffects = class("ShockMaulHitEffects")
local external_properties = {}
local BURST_PARTICLE_ALIAS = "vfx_weapon_special_start"
local BURST_SOUND_ALIAS = "sfx_special_activate"

ShockMaulHitEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local is_husk = context.is_husk

	self._is_husk = is_husk
	self._wwise_world = context.wwise_world
	self._world = context.world
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions

	local owner_unit = context.owner_unit

	self._owner_unit = owner_unit
	self._visual_loadout_extension = context.visual_loadout_extension
	self._first_person_extension = ScriptUnit.has_extension(owner_unit, "first_person_system")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")

	local source_alias = "_special_active"
	local source_name = fx_sources and fx_sources[source_alias]

	self._source_name = source_name

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
end

ShockMaulHitEffects.fixed_update = function (self, unit, dt, t)
	local weapon_action_component = self._weapon_action_component

	if weapon_action_component.current_action_name == "action_special_action" then
		local time_in_action = t - weapon_action_component.start_t
		local first_trigger_time = 0.6666666666666666
		local is_in_activate_time = ActionUtility.is_within_trigger_time(time_in_action, dt, first_trigger_time)

		if is_in_activate_time then
			self:_start_particle_effect(BURST_PARTICLE_ALIAS)
			self:_play_sound(BURST_SOUND_ALIAS)
		end
	end
end

ShockMaulHitEffects.update = function (self, unit, dt, t, frame)
	return
end

ShockMaulHitEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ShockMaulHitEffects.wield = function (self)
	self:_register()

	self._is_wielded = true
end

ShockMaulHitEffects.unwield = function (self)
	self:_unregister()
	self:_stop_sound()

	self._is_wielded = false
end

ShockMaulHitEffects.destroy = function (self)
	self:_unregister()
	self:_stop_sound()

	self._is_wielded = false
end

ShockMaulHitEffects._register = function (self)
	if not self._registerd then
		local event_manager = Managers.event

		event_manager:register(self, "event_on_player_hit", "event_on_player_hit")

		self._registerd = true
	end
end

ShockMaulHitEffects._unregister = function (self)
	if self._registerd then
		local event_manager = Managers.event

		event_manager:unregister(self, "event_on_player_hit")

		self._registerd = false
	end
end

local _powermaul_damage_profiles = {
	powermaul_heavy_tank = true,
	powermaul_weapon_special = true,
	powermaul_light_smiter = true
}

ShockMaulHitEffects.event_on_player_hit = function (self, attacking_unit, attack_result, did_damage, hit_weakspot, hit_world_position, damage_efficiency, is_critical_strike, damage_profile)
	local damage_profile_name = damage_profile.name
	local is_triggering_damage_profile = damage_profile_name and _powermaul_damage_profiles[damage_profile_name]

	if self._is_wielded and self._owner_unit == attacking_unit and is_triggering_damage_profile then
		self:_start_particle_effect(BURST_PARTICLE_ALIAS)
		self:_play_sound(BURST_SOUND_ALIAS)
	end
end

ShockMaulHitEffects._use_1p = function (self, particle_alias)
	local first_person_extension = self._first_person_extension
	local is_camera_following = first_person_extension and first_person_extension:is_camera_follow_target()
	local is_in_first_person_mode = first_person_extension and first_person_extension:is_in_first_person_mode()
	local use_1p = is_in_first_person_mode and is_camera_following

	return use_1p
end

ShockMaulHitEffects._start_particle_effect = function (self, particle_alias)
	local use_1p = self:_use_1p()
	local unit_1p, node_1p, unit_3p, node_3p = self._fx_extension:vfx_spawner_unit_and_node(self._source_name)
	local vfx_link_unit = use_1p and unit_1p or unit_3p
	local vfx_link_unit, vfx_link_node = vfx_link_unit, use_1p and node_1p or node_3p
	local particle_resolved, particle_name = self._visual_loadout_extension:resolve_gear_particle(particle_alias, external_properties)

	if particle_resolved then
		local world = self._world

		self:_stop_particle_effect()

		local new_effect_id = World.create_particles(world, particle_name, Vector3.zero())

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._effect_id = new_effect_id
		self._using_1p = use_1p
	end
end

ShockMaulHitEffects._stop_particle_effect = function (self)
	local world = self._world
	local effect_id = self._effect_id

	if effect_id and World.are_particles_playing(world, effect_id) then
		World.destroy_particles(world, effect_id)
	end

	self._effect_id = nil
end

ShockMaulHitEffects._play_sound = function (self, sound_alias)
	local use_1p = self:_use_1p()
	local sfx_source_id = self._fx_extension:sound_source(self._source_name)
	local use_husk_event = not use_1p
	local sound_resolved, sound_event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, external_properties)

	if sound_resolved then
		local wwise_world = self._wwise_world

		sound_event_name = use_husk_event and has_husk_events and sound_event_name .. "_husk" or sound_event_name

		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, sound_event_name, sfx_source_id)

		self._sound_id = new_playing_id
	end
end

ShockMaulHitEffects._stop_sound = function (self)
	local wwise_world = self._wwise_world
	local sound_id = self._sound_id

	if sound_id and WwiseWorld.is_playing(wwise_world, sound_id) then
		WwiseWorld.stop_event(wwise_world, sound_id)
	end

	self._sound_id = nil
end

implements(ShockMaulHitEffects, WieldableSlotScriptInterface)

return ShockMaulHitEffects
