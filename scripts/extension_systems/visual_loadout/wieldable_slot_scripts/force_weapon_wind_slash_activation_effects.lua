-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_wind_slash_activation_effects.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/charge_effects")

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ForceWeaponWindSlashActivationEffects = class("ForceWeaponWindSlashActivationEffects", "ChargeEffects")
local PARTICLE_ALIAS_ARM_CAGE = "psyker_hand_effects_arm_cage"
local PARTICLE_ALIAS_FINGERS = "psyker_hand_effects_fingers"
local PARTICLE_VARIABLE_NAME = "length"
local DEFAULT_HAND = "left"
local VFX_CAGE_DURATION = 1.66
local VFX_FINGER_DURATION = 1.6
local CAGE_FX_SOURCE_LOOKUP = {
	right = {
		hand = "fx_right_hand",
		sword = "fx_anim_01",
	},
	left = {
		hand = "fx_left_hand",
		sword = "fx_anim_01",
	},
}
local FINGER_FX_SOURCE_LOOKUP = {
	right = {
		index = "fx_right_finger_tip_index",
		middle = "fx_right_finger_tip_middle",
		pinky = "fx_right_finger_tip_pinky",
		ring = "fx_right_finger_tip_ring",
		thumb = "fx_right_finger_tip_thumb",
	},
	left = {
		index = "fx_left_finger_tip_index",
		middle = "fx_left_finger_tip_middle",
		pinky = "fx_left_finger_tip_pinky",
		ring = "fx_left_finger_tip_ring",
		thumb = "fx_left_finger_tip_thumb",
	},
}
local _external_properties = {}

ForceWeaponWindSlashActivationEffects.init = function (self, context, slot, weapon_template, fx_sources)
	ForceWeaponWindSlashActivationEffects.super.init(self, context, slot, weapon_template, fx_sources)

	if DEDICATED_SERVER then
		return
	end

	self._world = context.world
	self._physics_world = context.physics_world
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._weapon_actions = weapon_template.actions
	self._wwise_world = context.wwise_world
	self._first_person_unit = context.first_person_unit
	self._fx_sources = fx_sources
	self._is_in_first_person = nil
	self._cage_particle_ids = {}
	self._finger_particle_ids = {
		right = {},
		left = {},
	}

	local owner_unit = context.owner_unit

	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
end

ForceWeaponWindSlashActivationEffects.destroy = function (self)
	ForceWeaponWindSlashActivationEffects.super.destroy(self)

	if DEDICATED_SERVER then
		return
	end

	self:_stop_cage_vfx()
end

ForceWeaponWindSlashActivationEffects.wield = function (self)
	ForceWeaponWindSlashActivationEffects.super.wield(self)

	if DEDICATED_SERVER then
		return
	end

	self:_stop_cage_vfx()
end

ForceWeaponWindSlashActivationEffects.unwield = function (self)
	ForceWeaponWindSlashActivationEffects.super.unwield(self)

	if DEDICATED_SERVER then
		return
	end

	self:_stop_cage_vfx()
end

ForceWeaponWindSlashActivationEffects.update_unit_position = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	self:_update_vfx(t)
end

ForceWeaponWindSlashActivationEffects.update_first_person_mode = function (self, first_person_mode)
	ForceWeaponWindSlashActivationEffects.super.update_first_person_mode(self, first_person_mode)

	self._is_in_first_person = first_person_mode
end

ForceWeaponWindSlashActivationEffects._update_vfx = function (self, t)
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local special_active = self._inventory_slot_component.special_active
	local action_kind = action_settings and action_settings.kind
	local activating = action_kind == "activate_special"
	local start_t = weapon_action_component.start_t
	local time_in_action = t - start_t
	local play_cage_vfx = special_active and activating and time_in_action <= VFX_CAGE_DURATION
	local play_finger_vfx = special_active and activating and time_in_action <= VFX_FINGER_DURATION

	if play_cage_vfx then
		self:_update_cage_vfx(t, DEFAULT_HAND)
	else
		self:_stop_cage_vfx()
	end

	if play_finger_vfx then
		self:_update_finger_vfx(t, DEFAULT_HAND)
	else
		self:_stop_finger_vfx()
	end
end

ForceWeaponWindSlashActivationEffects._update_cage_vfx = function (self, t, fx_hand)
	local world = self._world
	local fx_extension = self._fx_extension
	local particle_id = self._cage_particle_ids[fx_hand]

	if not particle_id then
		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(PARTICLE_ALIAS_ARM_CAGE, _external_properties)

		if resolved then
			particle_id = World.create_particles(world, effect_name, Vector3.zero())

			local in_first_person = self._is_in_first_person

			if in_first_person then
				World.set_particles_use_custom_fov(world, particle_id, true)
			end
		end
	end

	local source_unit, source_node = fx_extension:vfx_spawner_unit_and_node(CAGE_FX_SOURCE_LOOKUP[fx_hand].sword)
	local target_unit, target_node = fx_extension:vfx_spawner_unit_and_node(CAGE_FX_SOURCE_LOOKUP[fx_hand].hand)
	local source_pos = Unit.world_position(source_unit, source_node)
	local target_pos = Unit.world_position(target_unit, target_node)
	local direction = Vector3.normalize(target_pos - source_pos)
	local rotation = Quaternion.look(direction)

	World.move_particles(world, particle_id, source_pos, rotation)

	self._cage_particle_ids[fx_hand] = particle_id
end

ForceWeaponWindSlashActivationEffects._update_finger_vfx = function (self, t, fx_hand)
	local world = self._world
	local fx_extension = self._fx_extension
	local particle_ids = self._finger_particle_ids[fx_hand]

	for name, fx_source_lookup in pairs(FINGER_FX_SOURCE_LOOKUP[fx_hand]) do
		local particle_id = particle_ids[name]
		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(PARTICLE_ALIAS_FINGERS, _external_properties)

		if not particle_id and resolved then
			particle_id = World.create_particles(world, effect_name, Vector3.zero())

			local in_first_person = self._is_in_first_person

			if in_first_person then
				World.set_particles_use_custom_fov(world, particle_id, true)
			end
		end

		local source_unit, source_node = fx_extension:vfx_spawner_unit_and_node(fx_source_lookup)
		local target_unit, target_node = fx_extension:vfx_spawner_unit_and_node(CAGE_FX_SOURCE_LOOKUP[fx_hand].sword)
		local source_pos = Unit.world_position(source_unit, source_node)
		local target_pos = Unit.world_position(target_unit, target_node)
		local line = target_pos - source_pos
		local direction, length = Vector3.direction_length(line)
		local rotation = Quaternion.look(direction)
		local particle_length = Vector3(length, length, length)
		local length_variable_index = World.find_particles_variable(world, effect_name, PARTICLE_VARIABLE_NAME)

		World.set_particles_variable(world, particle_id, length_variable_index, particle_length)
		World.move_particles(world, particle_id, source_pos, rotation)

		particle_ids[name] = particle_id
	end
end

ForceWeaponWindSlashActivationEffects._stop_cage_vfx = function (self)
	local world = self._world

	for _, particle_id in pairs(self._cage_particle_ids) do
		World.destroy_particles(world, particle_id)
	end

	table.clear(self._cage_particle_ids)
end

ForceWeaponWindSlashActivationEffects._stop_finger_vfx = function (self)
	local world = self._world

	for _, particle_ids in pairs(self._finger_particle_ids) do
		for _, particle_id in pairs(particle_ids) do
			World.destroy_particles(world, particle_id)
		end

		table.clear(particle_ids)
	end
end

implements(ForceWeaponWindSlashActivationEffects, WieldableSlotScriptInterface)

return ForceWeaponWindSlashActivationEffects
