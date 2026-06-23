-- chunkname: @scripts/extension_systems/ability/equipped_ability_effect_scripts/targeted_ally_effects.lua

local TargetedAllyEffects = class("TargetedAllyEffects")
local OUTLINE_NAME_VALID = "buff"
local OUTLINE_NAMES_INVALID = "knocked_down"

TargetedAllyEffects.init = function (self, equipped_ability_effect_scripts_context, ability_template)
	if DEDICATED_SERVER then
		return
	end

	self._ability_template = ability_template
	self._world = equipped_ability_effect_scripts_context.world
	self._wwise_world = equipped_ability_effect_scripts_context.wwise_world
	self._unit = equipped_ability_effect_scripts_context.unit

	local equipped_ability_effect_scripts_tweak_data = ability_template.equipped_ability_effect_scripts_tweak_data

	self._targeting_fx = equipped_ability_effect_scripts_tweak_data.targeting_fx
	self._validate_target_func = equipped_ability_effect_scripts_tweak_data.targeting.effect_validate_target_func
	self._select_target_outline_func = equipped_ability_effect_scripts_tweak_data.targeting.select_target_outline_func
	self._is_local_unit = equipped_ability_effect_scripts_context.is_local_unit

	local module_target_component_name = ability_template.module_target_component_name or "action_module_target_finder"
	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")

	self._action_module_target_finder_component = unit_data_extension:read_component(module_target_component_name)
	self._outline_system = Managers.state.extension:system("outline_system")
	self._ability_extension = ScriptUnit.has_extension(self._unit, "ability_system")
	self._companion_spawner_extension = ScriptUnit.has_extension(self._unit, "companion_spawner_system")

	if self._is_local_unit then
		self._input_extension = ScriptUnit.extension(self._unit, "input_system")
		self._talent_extension = ScriptUnit.extension(self._unit, "talent_system")
	end

	self._unit_data_extension = unit_data_extension
	self._target_unit_1 = nil
	self._target_unit_2 = nil
	self._target_unit_3 = nil
	self._target_unit_1_outline_name = nil
	self._target_unit_2_outline_name = nil
	self._target_unit_3_outline_name = nil
end

TargetedAllyEffects.update = function (self, unit, dt, t)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	self:_update_outlines(self._validate_target_func)
end

TargetedAllyEffects.destroy = function (self)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	self:_remove_outlines()
end

TargetedAllyEffects._update_outlines = function (self, validate_target_func)
	local new_unit_1 = self._action_module_target_finder_component.target_unit_1
	local old_unit_1 = self._target_unit_1
	local old_outline_name_1 = self._target_unit_1_outline_name
	local new_outline_name_1 = self:_update_unit_outline(new_unit_1, old_unit_1, old_outline_name_1, validate_target_func)

	self._target_unit_1 = new_unit_1
	self._target_unit_1_outline_name = new_outline_name_1

	local new_unit_2 = self._action_module_target_finder_component.target_unit_2
	local old_unit_2 = self._target_unit_2
	local old_outline_name_2 = self._target_unit_2_outline_name
	local new_outline_name_2 = self:_update_unit_outline(new_unit_2, old_unit_2, old_outline_name_2, validate_target_func)

	self._target_unit_2 = new_unit_2
	self._target_unit_2_outline_name = new_outline_name_2

	local new_unit_3 = self._action_module_target_finder_component.target_unit_3
	local old_unit_3 = self._target_unit_3
	local old_outline_name_3 = self._target_unit_3_outline_name
	local new_outline_name_3 = self:_update_unit_outline(new_unit_3, old_unit_3, old_outline_name_3, validate_target_func)

	self._target_unit_3 = new_unit_3
	self._target_unit_3_outline_name = new_outline_name_3
end

TargetedAllyEffects._update_unit_outline = function (self, new_unit, old_unit, old_outline_name, validate_target_func)
	local is_valid, no_outline

	if not validate_target_func then
		is_valid = false
	else
		is_valid, no_outline = validate_target_func(self._unit_data_extension, new_unit, self._ability_extension, self._companion_spawner_extension, self._input_extension, self._talent_extension)
	end

	if no_outline then
		self:_set_outline(old_unit, false, old_outline_name)

		return nil, nil
	end

	is_valid = not new_unit or is_valid

	local new_outline_name = self._select_target_outline_func and self._select_target_outline_func(self._unit_data_extension, new_unit, is_valid, self._talent_extension) or is_valid and OUTLINE_NAME_VALID or OUTLINE_NAMES_INVALID

	if new_unit ~= old_unit or old_outline_name ~= new_outline_name then
		self:_set_outline(old_unit, false, old_outline_name)
		self:_set_outline(new_unit, true, new_outline_name)
	end

	return new_unit and new_outline_name
end

TargetedAllyEffects._remove_outlines = function (self)
	self:_set_outline(self._target_unit_1, false, self._target_unit_1_outline_name)

	self._target_unit_1 = nil
	self._target_unit_1_outline_name = nil

	self:_set_outline(self._target_unit_2, false, self._target_unit_2_outline_name)

	self._target_unit_2 = nil
	self._target_unit_3_outline_name = nil

	self:_set_outline(self._target_unit_3, false, self._target_unit_3_outline_name)

	self._target_unit_3 = nil
	self._target_unit_3_outline_name = nil
end

TargetedAllyEffects._set_outline = function (self, unit, enabled, outline_name)
	if not unit or not outline_name then
		return
	end

	if enabled then
		self._outline_system:add_outline(unit, outline_name)
	else
		self._outline_system:remove_outline(unit, outline_name)
	end
end

return TargetedAllyEffects
