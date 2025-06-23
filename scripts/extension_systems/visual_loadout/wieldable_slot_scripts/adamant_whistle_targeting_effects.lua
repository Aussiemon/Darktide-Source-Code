-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/adamant_whistle_targeting_effects.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local SPAWN_POS = Vector3Box(400, 400, 400)
local AdamantWhistleTargetingEffects = class("AdamantWhistleTargetingEffects")

AdamantWhistleTargetingEffects.init = function (self, equipped_ability_effect_scripts_context, ability_template)
	self._world = equipped_ability_effect_scripts_context.world
	self._wwise_world = equipped_ability_effect_scripts_context.wwise_world

	local is_local_unit = equipped_ability_effect_scripts_context.is_local_unit

	self._ability_template = ability_template
	self._targeting_fx = ability_template.targeting_fx
	self._is_local_unit = is_local_unit

	local unit_data_extension = equipped_ability_effect_scripts_context.unit_data_extension
	local action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")

	self._action_module_targeting_component = action_module_targeting_component

	if is_local_unit then
		local grenade_ability_action_component = unit_data_extension:read_component("grenade_ability_action")

		self._grenade_ability_action_component = grenade_ability_action_component
	end
end

AdamantWhistleTargetingEffects.destroy = function (self)
	self:_destroy_effects()
end

AdamantWhistleTargetingEffects.update = function (self, unit, dt, t)
	local targeting_fx = self._targeting_fx
	local is_local_unit = self._is_local_unit

	if not is_local_unit or not targeting_fx then
		self:_destroy_effects()

		return
	end

	local action_name = self._grenade_ability_action_component.current_action_name
	local action_settings = self._ability_template.actions[action_name]
	local action_kind = action_settings and action_settings.kind
	local is_aiming = action_kind == "target_finder"
	local action_module_targeting_component = self._action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1

	if not target_unit or not is_aiming then
		self:_destroy_effects()

		return
	end

	if not self._targeting_effect_id then
		self:_spawn_effects()
	end

	local hit_zone_name = hit_zone_names.center_mass
	local target_position = HitZone.hit_zone_center_of_mass(target_unit, hit_zone_name)

	self:_update_effect_positions(target_position)
end

AdamantWhistleTargetingEffects._spawn_effects = function (self)
	local world = self._world
	local spawn_pos = SPAWN_POS:unbox()
	local targeting_fx = self._targeting_fx
	local effect_id = World.create_particles(world, targeting_fx.effect_name, spawn_pos)

	self._targeting_effect_id = effect_id
end

AdamantWhistleTargetingEffects._destroy_effects = function (self)
	if self._targeting_effect_id then
		World.destroy_particles(self._world, self._targeting_effect_id)

		self._targeting_effect_id = nil
	end
end

AdamantWhistleTargetingEffects._update_effect_positions = function (self, target_position)
	local effect_id = self._targeting_effect_id

	if effect_id then
		World.move_particles(self._world, effect_id, target_position)
	end
end

return AdamantWhistleTargetingEffects
