-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/overheat_display.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local OverheatDisplay = class("OverheatDisplay")

OverheatDisplay.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	if not context.is_husk then
		local owner_unit = context.owner_unit
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

		self._inventory_slot_component = unit_data_extension:read_component(slot.name)
		self._overheat_configuration = weapon_template.overheat_configuration
		self._ammo_displays = {}

		local attachments_1p = slot.attachments_by_unit_1p[unit_1p]
		local num_attachments = #attachments_1p

		for i = 1, num_attachments do
			local attachment_unit = attachments_1p[i]
			local ammo_display_components = Component.get_components_by_name(attachment_unit, "OverheatDisplay")

			for _, ammo_display_component in ipairs(ammo_display_components) do
				self._ammo_displays[#self._ammo_displays + 1] = {
					unit = attachment_unit,
					component = ammo_display_component,
				}
			end
		end
	end
end

OverheatDisplay.fixed_update = function (self, unit, dt, t, frame)
	local inventory_slot_component = self._inventory_slot_component
	local current_overheat = inventory_slot_component.overheat_current_percentage
	local overheat_configuration = self._overheat_configuration
	local warning_threshold = overheat_configuration.critical_threshold
	local num_displays = #self._ammo_displays

	for i = 1, num_displays do
		local display = self._ammo_displays[i]

		display.component:set_overheat_level(display.unit, current_overheat, warning_threshold)
	end
end

OverheatDisplay.update = function (self, unit, dt, t)
	return
end

OverheatDisplay.update_first_person_mode = function (self, first_person_mode)
	return
end

OverheatDisplay.wield = function (self)
	return
end

OverheatDisplay.unwield = function (self)
	return
end

OverheatDisplay.destroy = function (self)
	return
end

implements(OverheatDisplay, WieldableSlotScriptInterface)

return OverheatDisplay
