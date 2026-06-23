-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/transonic_weapon_effects.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local STANCE_TOGGLE_START = 1
local STANCE_TOGGLE_END = 0
local STANCE_TOGGLE_DURATION = 0.5
local TransonicWeaponEffects = class("TransonicWeaponEffects")
local _unit_components

TransonicWeaponEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local slot_name = slot.name

	self._inventory_slot_component = unit_data_extension:read_component(slot_name)
	self._is_active = false
	self._stance_change_start_time = nil
	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}

	_unit_components(self._weapon_material_variables_1p, slot.attachments_by_unit_1p[unit_1p])
	_unit_components(self._weapon_material_variables_3p, slot.attachments_by_unit_3p[unit_3p])
end

TransonicWeaponEffects.destroy = function (self)
	return
end

TransonicWeaponEffects.wield = function (self)
	self:_toggle_on_off(true)
end

TransonicWeaponEffects.unwield = function (self)
	self:_toggle_on_off(false)
end

TransonicWeaponEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

TransonicWeaponEffects.update = function (self, unit, dt, t)
	local toggled_active = self:_update_active()

	if toggled_active then
		self._stance_change_start_time = t
	end

	self:_update_stance_change(dt, t)
end

TransonicWeaponEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

TransonicWeaponEffects._update_active = function (self)
	local is_active = self._is_active
	local special_active = self._inventory_slot_component.special_active
	local should_start = not is_active and special_active
	local should_stop = is_active and not special_active

	if should_start or should_stop then
		self:_toggle_direction(special_active)
	end

	self._is_active = special_active

	return is_active ~= special_active
end

TransonicWeaponEffects._update_stance_change = function (self, dt, t)
	local stance_change_start_time = self._stance_change_start_time

	if not stance_change_start_time then
		return
	end

	local stance_change_end_time = stance_change_start_time + STANCE_TOGGLE_DURATION
	local lerp_t = math.ilerp(stance_change_start_time, stance_change_end_time, t)
	local value = math.lerp(STANCE_TOGGLE_START, STANCE_TOGGLE_END, lerp_t)

	self:_set_stance_trigger(value)

	if lerp_t >= 1 then
		self._stance_change_start_time = nil
	end
end

TransonicWeaponEffects._toggle_direction = function (self, toggle_direction)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:toggle_direction(toggle_direction, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:toggle_direction(toggle_direction, weapon_material_variable.unit)
	end
end

TransonicWeaponEffects._toggle_on_off = function (self, is_on)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:toggle_on_off(is_on, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:toggle_on_off(is_on, weapon_material_variable.unit)
	end
end

TransonicWeaponEffects._set_stance_trigger = function (self, value)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:set_stance_trigger(value, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:set_stance_trigger(value, weapon_material_variable.unit)
	end
end

function _unit_components(components, attachments)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		for _, component in ipairs(unit_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end
end

implements(TransonicWeaponEffects, WieldableSlotScriptInterface)

return TransonicWeaponEffects
