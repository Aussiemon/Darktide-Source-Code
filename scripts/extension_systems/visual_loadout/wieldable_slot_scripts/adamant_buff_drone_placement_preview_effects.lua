-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/adamant_buff_drone_placement_preview_effects.lua

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local AdamantBuffDronePlacementPreviewEffects = class("AdamantBuffDronePlacementPreviewEffects")
local DEFAULT_DISTANCE_FROM_PLAYER = 4

AdamantBuffDronePlacementPreviewEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local wwise_world = context.wwise_world

	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._owner_unit = owner_unit

	if self._is_local_unit then
		self._weapon_action_component = unit_data_extension:read_component("weapon_action")
		self._first_person_component = unit_data_extension:read_component("first_person")
		self._position_finder_component = unit_data_extension:write_component("action_module_position_finder")
		self._placement_preview_settings = weapon_template.placement_preview_settings
	end
end

AdamantBuffDronePlacementPreviewEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

AdamantBuffDronePlacementPreviewEffects.update = function (self, unit, dt, t)
	if not self._is_local_unit then
		return
	end

	self:_update_effects(dt, t)
end

AdamantBuffDronePlacementPreviewEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

AdamantBuffDronePlacementPreviewEffects.wield = function (self)
	return
end

AdamantBuffDronePlacementPreviewEffects.unwield = function (self)
	self:_destroy_effects()
end

AdamantBuffDronePlacementPreviewEffects.destroy = function (self)
	self:_destroy_effects()
end

AdamantBuffDronePlacementPreviewEffects._update_effects = function (self, dt, t)
	local weapon_action_component = self._weapon_action_component
	local current_action_name = weapon_action_component.current_action_name

	if current_action_name == "action_aim_drone" and not self._targeting_effect_id then
		self:_spawn_effects()
	elseif current_action_name ~= "action_aim_drone" and self._targeting_effect_id then
		self:_destroy_effects()
	end

	if ALIVE[self._owner_unit] and self._targeting_effect_id then
		self:_update_effect_positions()
	end
end

AdamantBuffDronePlacementPreviewEffects._spawn_effects = function (self)
	local world = self._world
	local spawn_pos = self:_get_target_position()
	local targeting_fx_name = self._placement_preview_settings.vfx
	local effect_id = World.create_particles(world, targeting_fx_name, spawn_pos)

	self._targeting_effect_id = effect_id
end

AdamantBuffDronePlacementPreviewEffects._destroy_effects = function (self)
	if self._targeting_effect_id then
		World.destroy_particles(self._world, self._targeting_effect_id)

		self._targeting_effect_id = nil
	end
end

AdamantBuffDronePlacementPreviewEffects._update_effect_positions = function (self)
	local effect_id = self._targeting_effect_id

	if effect_id then
		local target_position = self:_get_target_position()

		World.move_particles(self._world, effect_id, target_position)
	end
end

AdamantBuffDronePlacementPreviewEffects._get_target_position = function (self)
	return self._position_finder_component.position
end

implements(AdamantBuffDronePlacementPreviewEffects, WieldableSlotScriptInterface)

return AdamantBuffDronePlacementPreviewEffects
