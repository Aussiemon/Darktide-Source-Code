-- chunkname: @scripts/extension_systems/visual_loadout/equipped_slot_scripts/equipped_health_bar_gauge.lua

local Health = require("scripts/utilities/health")
local Component = require("scripts/utilities/component")
local EquippedSlotScriptInterface = require("scripts/extension_systems/visual_loadout/equipped_slot_scripts/equipped_slot_script_interface")
local EquippedHealthBarGauge = class("EquippedHealthBarGauge")

EquippedHealthBarGauge.init = function (self, context, slot, fx_sources, item, unit_1p, unit_3p)
	if DEDICATED_SERVER then
		return
	end

	local unit_components = {}
	local attachments_3p = slot.attachments_by_unit_3p[unit_3p]
	local num_attachments_3p = #attachments_3p

	if num_attachments_3p > 0 then
		for ii = 1, num_attachments_3p do
			local attachment_unit = attachments_3p[ii]
			local components = Component.get_components_by_name(attachment_unit, "HealthBarGauge")

			for _, component in ipairs(components) do
				unit_components[#unit_components + 1] = {
					unit = attachment_unit,
					component = component,
				}
			end
		end
	else
		local components = Component.get_components_by_name(unit_3p, "HealthBarGauge")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = unit_3p,
				component = component,
			}
		end
	end

	self._unit_components = unit_components
end

EquippedHealthBarGauge.fixed_update = function (self, unit, dt, t, frame)
	return
end

EquippedHealthBarGauge.update = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	local current_health_percent = Health.current_health_percent(unit)
	local unit_components = self._unit_components
	local num_displays = #unit_components

	for ii = 1, num_displays do
		local display = unit_components[ii]

		if Unit.alive(unit) and Unit.alive(display.unit) and display.component then
			display.component:set_health(display.unit, current_health_percent)
		end
	end
end

EquippedHealthBarGauge.update_first_person_mode = function (self, first_person_mode)
	return
end

EquippedHealthBarGauge.wield = function (self)
	return
end

EquippedHealthBarGauge.unwield = function (self)
	return
end

EquippedHealthBarGauge.destroy = function (self)
	return
end

implements(EquippedHealthBarGauge, EquippedSlotScriptInterface)

return EquippedHealthBarGauge
