-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_hand_effects.lua

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ChainLightningHandEffects = class("ChainLightningHandEffects")
local LOOPING_HAND_VFX_ALIAS = "chain_lightning_hand"
local DEFAULT_HAND = "left"
local _vfx_external_properties = {}

ChainLightningHandEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	self._physics_world = context.physics_world
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._weapon_actions = weapon_template.actions
	self._wwise_world = context.wwise_world
	self._first_person_unit = context.first_person_unit

	local weapon_chain_settings = weapon_template.chain_settings
	local right_fx_source_name = fx_sources[weapon_chain_settings.right_fx_source_name]
	local left_fx_source_name = fx_sources[weapon_chain_settings.left_fx_source_name]

	if weapon_chain_settings.right_fx_source_name_base_unit then
		right_fx_source_name = weapon_chain_settings.right_fx_source_name_base_unit
	end

	if weapon_chain_settings.left_fx_source_name_base_unit then
		left_fx_source_name = weapon_chain_settings.left_fx_source_name_base_unit
	end

	self._right_fx_source_name = right_fx_source_name
	self._left_fx_source_name = left_fx_source_name
	self._is_in_first_person = nil
	self._right_hand_particle_id = nil
	self._left_hand_particle_id = nil
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._charge_level = false
end

ChainLightningHandEffects.destroy = function (self)
	self:_reset()
end

ChainLightningHandEffects.wield = function (self)
	self:_reset()
end

ChainLightningHandEffects.unwield = function (self)
	self:_reset()
end

ChainLightningHandEffects.update_unit_position = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	self:_update_vfx(t)
end

ChainLightningHandEffects._update_vfx = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local fx_settings = action_settings and action_settings.fx
	local is_critical_strike = self._critical_strike_component.is_active
	local world = self._world
	local fx_hand = fx_settings and (is_critical_strike and fx_settings.fx_hand_critical_strike or fx_settings.fx_hand) or DEFAULT_HAND
	local use_charge = fx_settings and fx_settings.use_charge
	local action_module_charge_component = self._action_module_charge_component
	local charge_level = use_charge and action_module_charge_component.charge_level or 1

	self._charge_level = charge_level

	local action_kind = action_settings and action_settings.kind
	local targeting = action_kind == "overload_charge_target_finder" or action_kind == "overload_target_finder"
	local attacking = action_kind == "chain_lightning"
	local play_right = fx_hand == "right" or fx_hand == "both"
	local play_left = fx_hand == "left" or fx_hand == "both"

	if attacking then
		local spawner_unit_right, spawner_node_right = self._fx_extension:vfx_spawner_unit_and_node(self._right_fx_source_name)
		local spawner_unit_left, spawner_node_left = self._fx_extension:vfx_spawner_unit_and_node(self._left_fx_source_name)

		if play_right then
			self._right_hand_particle_id = self:_update_hand_vfx(t, world, self._right_hand_particle_id, spawner_unit_right, spawner_node_right)
		end

		if play_left then
			self._left_hand_particle_id = self:_update_hand_vfx(t, world, self._left_hand_particle_id, spawner_unit_left, spawner_node_left)
		end
	elseif targeting then
		local spawner_unit_right, spawner_node_right = self._fx_extension:vfx_spawner_unit_and_node(self._right_fx_source_name)
		local spawner_unit_left, spawner_node_left = self._fx_extension:vfx_spawner_unit_and_node(self._left_fx_source_name)

		if play_right then
			self._right_hand_particle_id = self:_update_hand_vfx(t, world, self._right_hand_particle_id, spawner_unit_right, spawner_node_right)
		end

		if play_left then
			self._left_hand_particle_id = self:_update_hand_vfx(t, world, self._left_hand_particle_id, spawner_unit_left, spawner_node_left)
		end
	else
		self._right_hand_particle_id = self:_stop_vfx(world, self._right_hand_particle_id)
		self._left_hand_particle_id = self:_stop_vfx(world, self._left_hand_particle_id)
		self._charge_level = false
	end
end

ChainLightningHandEffects.update_first_person_mode = function (self, first_person_mode)
	self._is_in_first_person = first_person_mode
end

ChainLightningHandEffects._update_hand_vfx = function (self, t, world, current_particle_id, node_unit, node)
	if current_particle_id then
		return current_particle_id
	else
		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(LOOPING_HAND_VFX_ALIAS, _vfx_external_properties)

		if resolved then
			local effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, effect_id, node_unit, node, Matrix4x4.identity(), "destroy")

			local in_first_person = self._is_in_first_person

			if in_first_person then
				World.set_particles_use_custom_fov(world, effect_id, true)
			end

			return effect_id
		end
	end
end

ChainLightningHandEffects._stop_vfx = function (self, world, particle_id)
	if particle_id then
		World.destroy_particles(world, particle_id)
	end
end

ChainLightningHandEffects._reset = function (self)
	local world = self._world

	self._right_hand_particle_id = self:_stop_vfx(world, self._right_hand_particle_id)
	self._left_hand_particle_id = self:_stop_vfx(world, self._left_hand_particle_id)
end

implements(ChainLightningHandEffects, WieldableSlotScriptInterface)

return ChainLightningHandEffects
