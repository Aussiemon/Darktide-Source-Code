-- chunkname: @scripts/utilities/level_props/hazard_prop.lua

local HazardPropSettings = require("scripts/settings/hazard_prop/hazard_prop_settings")
local hazard_state = HazardPropSettings.hazard_state
local hazard_content = HazardPropSettings.hazard_content
local HazardProp = {}

HazardProp.status = function (unit)
	local hazard_prop_extension = ScriptUnit.has_extension(unit, "hazard_prop_system")

	if not hazard_prop_extension then
		return false, nil
	end

	local current_state = hazard_prop_extension:current_state()

	if current_state == hazard_state.broken then
		return true, false
	end

	local content = hazard_prop_extension:content()

	if content == hazard_content.none then
		return true, false
	end

	return true, true
end

return HazardProp
