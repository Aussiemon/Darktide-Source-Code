-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_target_effects.lua

local Action = require("scripts/utilities/action/action")
local Breed = require("scripts/utilities/breed")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ChainLightningTargetEffects = class("ChainLightningTargetEffects")
local Unit_world_position = Unit.world_position

ChainLightningTargetEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local wwise_world = context.wwise_world

	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	self._action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._targeting_effects = {}
end

ChainLightningTargetEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ChainLightningTargetEffects.update = function (self, unit, dt, t)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local targeting_fx = action_settings and action_settings.targeting_fx

	if not targeting_fx then
		self:_destroy_effects()

		return
	end

	local max_target = targeting_fx.max_targets
	local target_unit_1 = max_target >= 1 and self._action_module_targeting_component.target_unit_1
	local target_unit_2 = max_target >= 2 and self._action_module_targeting_component.target_unit_2
	local target_unit_3 = max_target >= 3 and self._action_module_targeting_component.target_unit_3

	if target_unit_1 then
		self:_create_effect(target_unit_1, targeting_fx)
	end

	if target_unit_2 then
		self:_create_effect(target_unit_2, targeting_fx)
	end

	if target_unit_3 then
		self:_create_effect(target_unit_3, targeting_fx)
	end

	local world = self._world
	local targeting_effects = self._targeting_effects

	for targeted_unit, effect_id in pairs(targeting_effects) do
		if targeted_unit ~= target_unit_1 and targeted_unit ~= target_unit_2 and targeted_unit ~= target_unit_3 then
			World.destroy_particles(world, effect_id)

			targeting_effects[targeted_unit] = nil
		end
	end
end

ChainLightningTargetEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ChainLightningTargetEffects.wield = function (self)
	return
end

ChainLightningTargetEffects.unwield = function (self)
	self:_destroy_effects()
end

ChainLightningTargetEffects.destroy = function (self)
	self:_destroy_effects()
end

ChainLightningTargetEffects._create_effect = function (self, unit, targeting_fx)
	local targeting_effects = self._targeting_effects

	if targeting_effects[unit] or not unit then
		return
	end

	local world = self._world
	local effect_name = targeting_fx.effect_name
	local material_emission = targeting_fx.material_emission
	local mesh_name_or_nil = targeting_fx.emission_mesh_name
	local material_name_or_nil = targeting_fx.emission_material_name
	local attach_node_name = targeting_fx.attach_node_name
	local orphaned_policy = targeting_fx.orphaned_policy or "destroy"
	local attach_node = Unit.node(unit, attach_node_name)
	local position = Unit_world_position(unit, attach_node)
	local effect_id = World.create_particles(world, effect_name, position)

	if material_emission then
		local apply_for_children = true

		World.set_particles_surface_effect(world, effect_id, unit, mesh_name_or_nil, material_name_or_nil, apply_for_children)

		local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()

		if Breed.is_minion(breed) and not ScriptUnit.extension(unit, "visual_loadout_system"):ailment_effect() then
			Unit.set_vector3_for_materials(unit, "offset_time_duration", Vector3(0, 0, -10), true)
		end
	else
		World.link_particles(world, effect_id, unit, attach_node, Matrix4x4.identity(), orphaned_policy)
	end

	targeting_effects[unit] = effect_id
end

ChainLightningTargetEffects._destroy_effect = function (self, unit)
	local world = self._world
	local targeting_effects = self._targeting_effects
	local effect_id = targeting_effects[unit]

	if effect_id then
		World.destroy_particles(world, effect_id)

		targeting_effects[unit] = nil
	end
end

ChainLightningTargetEffects._destroy_effects = function (self)
	local world = self._world
	local targeting_effects = self._targeting_effects

	for targeted_unit, effect_id in pairs(targeting_effects) do
		World.destroy_particles(world, effect_id)

		targeting_effects[targeted_unit] = nil
	end
end

implements(ChainLightningTargetEffects, WieldableSlotScriptInterface)

return ChainLightningTargetEffects
