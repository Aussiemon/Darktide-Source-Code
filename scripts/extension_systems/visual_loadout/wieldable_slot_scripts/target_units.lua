-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/target_units.lua

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local TargetUnits = class("TargetUnits")
local OUTLINE_NAME_VALID = "buff"
local OUTLINE_NAMES_INVALID = "knocked_down"

TargetUnits.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	if DEDICATED_SERVER then
		return
	end

	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._outline_system = Managers.state.extension:system("outline_system")

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._target_unit_1 = nil
	self._target_unit_2 = nil
	self._target_unit_3 = nil
	self._target_unit_1_outline_name = nil
	self._target_unit_2_outline_name = nil
	self._target_unit_3_outline_name = nil
end

TargetUnits.update = function (self, unit, dt, t)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local validate_target_func = action_settings and action_settings.validate_target_func

	self:_update_outlines(validate_target_func)
end

TargetUnits.update_first_person_mode = function (self, first_person_mode)
	return
end

TargetUnits.wield = function (self)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	self:_update_outlines()
end

TargetUnits.unwield = function (self)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	self:_remove_outlines()
end

TargetUnits.destroy = function (self)
	if DEDICATED_SERVER or not self._is_local_unit then
		return
	end

	self:_remove_outlines()
end

TargetUnits._update_outlines = function (self, validate_target_func)
	local new_unit_1 = self._action_module_targeting_component.target_unit_1
	local old_unit_1 = self._target_unit_1
	local old_outline_name_1 = self._target_unit_1_outline_name
	local new_outline_name_1 = self:_update_unit_outline(new_unit_1, old_unit_1, old_outline_name_1, validate_target_func)

	self._target_unit_1 = new_unit_1
	self._target_unit_1_outline_name = new_outline_name_1

	local new_unit_2 = self._action_module_targeting_component.target_unit_2
	local old_unit_2 = self._target_unit_2
	local old_outline_name_2 = self._target_unit_2_outline_name
	local new_outline_name_2 = self:_update_unit_outline(new_unit_2, old_unit_2, old_outline_name_2, validate_target_func)

	self._target_unit_2 = new_unit_2
	self._target_unit_2_outline_name = new_outline_name_2

	local new_unit_3 = self._action_module_targeting_component.target_unit_3
	local old_unit_3 = self._target_unit_3
	local old_outline_name_3 = self._target_unit_3_outline_name
	local new_outline_name_3 = self:_update_unit_outline(new_unit_3, old_unit_3, old_outline_name_3, validate_target_func)

	self._target_unit_3 = new_unit_3
	self._target_unit_3_outline_name = new_outline_name_3
end

TargetUnits._update_unit_outline = function (self, new_unit, old_unit, old_outline_name, validate_target_func)
	local is_valid = not new_unit or not validate_target_func or validate_target_func(new_unit)
	local new_outline_name = is_valid and OUTLINE_NAME_VALID or OUTLINE_NAMES_INVALID

	if new_unit ~= old_unit or old_outline_name ~= new_outline_name then
		self:_set_outline(old_unit, false, old_outline_name)
		self:_set_outline(new_unit, true, new_outline_name)
	end

	return new_unit and new_outline_name
end

TargetUnits._remove_outlines = function (self)
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

TargetUnits._set_outline = function (self, unit, enabled, outline_name)
	if not unit or not outline_name then
		return
	end

	if enabled then
		self._outline_system:add_outline(unit, outline_name)
	else
		self._outline_system:remove_outline(unit, outline_name)
	end
end

implements(TargetUnits, WieldableSlotScriptInterface)

return TargetUnits
