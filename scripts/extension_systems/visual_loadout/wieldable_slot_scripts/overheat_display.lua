local Component = require("scripts/utilities/component")
local OverheatDisplay = class("OverheatDisplay")

OverheatDisplay.init = function (self, context, slot, weapon_template, fx_sources)
	if not context.is_husk then
		local owner_unit = context.owner_unit
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
		self._wieldable_component = unit_data_extension:read_component(slot.name)
		self._overheat_configuration = weapon_template.overheat_configuration
		self._ammo_displays = {}
		local num_attachments = #slot.attachments_1p

		for i = 1, num_attachments do
			local attachment_unit = slot.attachments_1p[i]
			local ammo_display_components = Component.get_components_by_name(attachment_unit, "OverheatDisplay")

			for _, ammo_display_component in ipairs(ammo_display_components) do
				self._ammo_displays[#self._ammo_displays + 1] = {
					unit = attachment_unit,
					component = ammo_display_component
				}
			end
		end
	end
end

OverheatDisplay.fixed_update = function (self, unit, dt, t, frame)
	local wieldable_component = self._wieldable_component
	local current_overheat = wieldable_component.overheat_current_percentage
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

return OverheatDisplay
