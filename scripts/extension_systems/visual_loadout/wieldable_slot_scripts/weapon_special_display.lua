-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/weapon_special_display.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local WeaponSpecialDisplay = class("WeaponSpecialDisplay")

WeaponSpecialDisplay.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)

	local unit_components = {}
	local attachments_1p = slot.attachments_by_unit_1p[unit_1p]
	local num_attachments_1p = #attachments_1p

	for ii = 1, num_attachments_1p do
		local attachment_unit = attachments_1p[ii]
		local components = Component.get_components_by_name(attachment_unit, "WeaponSpecialDisplay")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	local attachments_3p = slot.attachments_by_unit_3p[unit_3p]
	local num_attachments_3p = #attachments_3p

	for ii = 1, num_attachments_3p do
		local attachment_unit = attachments_3p[ii]
		local components = Component.get_components_by_name(attachment_unit, "WeaponSpecialDisplay")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	self._unit_components = unit_components
	self._is_special_active = false
end

WeaponSpecialDisplay.fixed_update = function (self, unit, dt, t, frame)
	return
end

WeaponSpecialDisplay.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local special_active = inventory_slot_component.special_active

	if self._is_special_active == special_active then
		return
	end

	self._is_special_active = special_active

	local unit_components = self._unit_components
	local num_displays = #unit_components

	for ii = 1, num_displays do
		local display = unit_components[ii]

		display.component:set_special_active(display.unit, special_active, t, false)
	end
end

WeaponSpecialDisplay.update_first_person_mode = function (self, first_person_mode)
	return
end

WeaponSpecialDisplay.wield = function (self)
	local inventory_slot_component = self._inventory_slot_component
	local special_active = inventory_slot_component.special_active

	self._is_special_active = special_active

	local unit_components = self._unit_components
	local num_displays = #unit_components

	for ii = 1, num_displays do
		local display = unit_components[ii]

		display.component:set_special_active(display.unit, special_active, nil, true)
	end
end

WeaponSpecialDisplay.unwield = function (self)
	return
end

WeaponSpecialDisplay.destroy = function (self)
	return
end

implements(WeaponSpecialDisplay, WieldableSlotScriptInterface)

return WeaponSpecialDisplay
