-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_ability_hand_effects.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/charge_effects")

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ChainLightningAbilityHandEffects = class("ChainLightningAbilityHandEffects", "ChargeEffects")
local PARTICLE_ALIAS_ARM_CAGE = "psyker_hand_effects_arm_cage"
local PARTICLE_ALIAS_FINGERS = "psyker_hand_effects_fingers"
local PARTICLE_VARIABLE_NAME = "length"
local DEFAULT_HAND = "both"
local CAGE_FX_SOURCE_LOOKUP = {
	right = {
		elbow = "fx_right_elbow",
		hand = "fx_right_hand",
	},
	left = {
		elbow = "fx_left_elbow",
		hand = "fx_left_hand",
	},
}
local CHARGE_FX_TARGET_LOOKUP = "_charge"
local CHARGE_FX_SOURCE_LOOKUP = {
	index = "fx_right_finger_tip_index",
	middle = "fx_right_finger_tip_middle",
	pinky = "fx_right_finger_tip_pinky",
	ring = "fx_right_finger_tip_ring",
	thumb = "fx_right_finger_tip_thumb",
}
local _vfx_external_properties = {}

ChainLightningAbilityHandEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	ChainLightningAbilityHandEffects.super.init(self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)

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
	self._charge_particle_ids = {}

	local owner_unit = context.owner_unit

	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
end

ChainLightningAbilityHandEffects.destroy = function (self)
	ChainLightningAbilityHandEffects.super.destroy(self)

	if DEDICATED_SERVER then
		return
	end

	self:_stop_cage_vfx()
	self:_stop_charge_vfx()
end

ChainLightningAbilityHandEffects.wield = function (self)
	ChainLightningAbilityHandEffects.super.wield(self)

	if DEDICATED_SERVER then
		return
	end

	self:_stop_cage_vfx()
	self:_stop_charge_vfx()
end

ChainLightningAbilityHandEffects.unwield = function (self)
	ChainLightningAbilityHandEffects.super.unwield(self)

	if DEDICATED_SERVER then
		return
	end

	self:_stop_cage_vfx()
	self:_stop_charge_vfx()
end

ChainLightningAbilityHandEffects.update_unit_position = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	self:_update_vfx(t)
end

ChainLightningAbilityHandEffects.update_first_person_mode = function (self, first_person_mode)
	ChainLightningAbilityHandEffects.super.update_first_person_mode(self, first_person_mode)

	self._is_in_first_person = first_person_mode
end

ChainLightningAbilityHandEffects._update_vfx = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local fx_settings = action_settings and action_settings.fx
	local is_critical_strike = self._critical_strike_component.is_active
	local fx_hand = fx_settings and (is_critical_strike and fx_settings.fx_hand_critical_strike or fx_settings.fx_hand) or DEFAULT_HAND
	local action_kind = action_settings and action_settings.kind
	local attacking = action_kind == "chain_lightning"
	local targeting = action_kind == "overload_charge_target_finder" or action_kind == "overload_target_finder"
	local play_right = fx_hand == "right" or fx_hand == "both"
	local play_left = fx_hand == "left" or fx_hand == "both"
	local play_cage_vfx = attacking or targeting

	if play_cage_vfx then
		if play_right then
			self:_update_cage_vfx(t, "right")
		end

		if play_left then
			self:_update_cage_vfx(t, "left")
		end
	else
		self:_stop_cage_vfx()
	end

	local action_module_charge_component = self._action_module_charge_component
	local charge_level = action_module_charge_component.charge_level
	local have_charge = charge_level > 0

	if have_charge then
		self:_update_charge_vfx(t)
	else
		self:_stop_charge_vfx()
	end
end

ChainLightningAbilityHandEffects._update_cage_vfx = function (self, t, fx_hand)
	local world = self._world
	local fx_extension = self._fx_extension
	local particle_id = self._cage_particle_ids[fx_hand]

	if not particle_id then
		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(PARTICLE_ALIAS_ARM_CAGE, _vfx_external_properties)

		if resolved then
			particle_id = World.create_particles(world, effect_name, Vector3.zero())

			local in_first_person = self._is_in_first_person

			if in_first_person then
				World.set_particles_use_custom_fov(world, particle_id, true)
			end
		end
	end

	local source_unit, source_node = fx_extension:vfx_spawner_unit_and_node(CAGE_FX_SOURCE_LOOKUP[fx_hand].hand)
	local target_unit, target_node = fx_extension:vfx_spawner_unit_and_node(CAGE_FX_SOURCE_LOOKUP[fx_hand].elbow)
	local source_pos = Unit.world_position(source_unit, source_node)
	local target_pos = Unit.world_position(target_unit, target_node)
	local direction = target_pos - source_pos
	local rotation = Quaternion.look(direction)

	World.move_particles(world, particle_id, source_pos, rotation)

	self._cage_particle_ids[fx_hand] = particle_id
end

ChainLightningAbilityHandEffects._update_charge_vfx = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local charge_effects = action_settings and action_settings.charge_effects or self._weapon_template_charge_effects

	if not charge_effects then
		return
	end

	local world = self._world
	local fx_extension = self._fx_extension
	local fx_sources = self._fx_sources
	local target_unit, target_node = fx_extension:vfx_spawner_unit_and_node(fx_sources[CHARGE_FX_TARGET_LOOKUP])
	local visual_loadout_extension = self._visual_loadout_extension

	for name, fx_source_name in pairs(CHARGE_FX_SOURCE_LOOKUP) do
		local particle_id = self._charge_particle_ids[name]
		local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(PARTICLE_ALIAS_FINGERS, _vfx_external_properties)

		if not particle_id and resolved then
			particle_id = World.create_particles(world, effect_name, Vector3.zero())

			local in_first_person = self._is_in_first_person

			if in_first_person then
				World.set_particles_use_custom_fov(world, particle_id, true)
			end
		end

		local source_unit, source_node = fx_extension:vfx_spawner_unit_and_node(fx_source_name)
		local source_pos = Unit.world_position(source_unit, source_node)
		local target_pos = Unit.world_position(target_unit, target_node)
		local line = target_pos - source_pos
		local direction, length = Vector3.direction_length(line)
		local rotation = Quaternion.look(direction)
		local particle_length = Vector3(length, length, length)
		local length_variable_index = World.find_particles_variable(world, effect_name, PARTICLE_VARIABLE_NAME)

		World.set_particles_variable(world, particle_id, length_variable_index, particle_length)
		World.move_particles(world, particle_id, source_pos, rotation)

		self._charge_particle_ids[name] = particle_id
	end
end

ChainLightningAbilityHandEffects._stop_cage_vfx = function (self)
	local world = self._world

	for _, particle_id in pairs(self._cage_particle_ids) do
		World.destroy_particles(world, particle_id)
	end

	table.clear(self._cage_particle_ids)
end

ChainLightningAbilityHandEffects._stop_charge_vfx = function (self)
	local world = self._world

	for _, particle_id in pairs(self._charge_particle_ids) do
		World.destroy_particles(world, particle_id)
	end

	table.clear(self._charge_particle_ids)
end

ChainLightningAbilityHandEffects._charge_level = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local charge_effects = action_settings and action_settings.charge_effects or self._weapon_template_charge_effects

	if charge_effects == nil or not charge_effects.use_chain_jumping_as_charge then
		return ChainLightningAbilityHandEffects.super._charge_level(self, t)
	end

	local chain_settings = action_settings.chain_settings
	local max_jumps_at_time = chain_settings.max_jumps_at_time
	local weapon_action_component = self._weapon_action_component
	local time_in_action = t - weapon_action_component.start_t
	local last_jump = max_jumps_at_time[#max_jumps_at_time]
	local last_jump_time = last_jump.t
	local jump_charge = math.clamp01(time_in_action / last_jump_time)

	return jump_charge
end

implements(ChainLightningAbilityHandEffects, WieldableSlotScriptInterface)

return ChainLightningAbilityHandEffects
