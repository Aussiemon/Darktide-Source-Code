local Component = require("scripts/utilities/component")
local LasgunAmmoDisplay = class("LasgunAmmoDisplay")
local CRITICAL_THRESHOLD_MULTIPLIER = 0.1

LasgunAmmoDisplay.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._wieldable_component = unit_data_extension:read_component(slot.name)
	local ammo_displays = {}
	local num_attachments_1p = #slot.attachments_1p

	for i = 1, num_attachments_1p, 1 do
		local attachment_unit = slot.attachments_1p[i]
		local ammo_display_components = Component.get_components_by_name(attachment_unit, "AmmoDisplay")

		for _, ammo_display_component in ipairs(ammo_display_components) do
			ammo_displays[#ammo_displays + 1] = {
				unit = attachment_unit,
				component = ammo_display_component
			}
		end
	end

	local num_attachments_3p = #slot.attachments_3p

	for i = 1, num_attachments_3p, 1 do
		local attachment_unit = slot.attachments_3p[i]
		local ammo_display_components = Component.get_components_by_name(attachment_unit, "AmmoDisplay")

		for _, ammo_display_component in ipairs(ammo_display_components) do
			ammo_displays[#ammo_displays + 1] = {
				unit = attachment_unit,
				component = ammo_display_component
			}
		end
	end

	self._ammo_displays = ammo_displays
end

LasgunAmmoDisplay.fixed_update = function (self, unit, dt, t, frame)
	return
end

LasgunAmmoDisplay.update = function (self, unit, dt, t)
	local wieldable_component = self._wieldable_component
	local current_ammo = wieldable_component.current_ammunition_clip
	local max_ammo = wieldable_component.max_ammunition_clip
	local critical_threshold = max_ammo * CRITICAL_THRESHOLD_MULTIPLIER
	local ammo_displays = self._ammo_displays
	local num_displays = #ammo_displays

	for i = 1, num_displays, 1 do
		local display = ammo_displays[i]

		display.component:set_ammo(display.unit, current_ammo, max_ammo, critical_threshold)
	end
end

LasgunAmmoDisplay.update_first_person_mode = function (self, first_person_mode)
	return
end

LasgunAmmoDisplay.wield = function (self)
	return
end

LasgunAmmoDisplay.unwield = function (self)
	return
end

LasgunAmmoDisplay.destroy = function (self)
	return
end

return LasgunAmmoDisplay
