local PropUtilities = {}
local HazardPropSettings = require("scripts/settings/hazard_prop/hazard_prop_settings")

PropUtilities.is_inactive_hazard_prop = function (unit)
	local hazard_prop_extension = ScriptUnit.has_extension(unit, "hazard_prop_system")

	if hazard_prop_extension then
		local current_state = hazard_prop_extension:current_state()

		if current_state == HazardPropSettings.hazard_state.broken then
			return true
		end

		local content = hazard_prop_extension:content()

		if content == HazardPropSettings.hazard_content.none then
			return true
		end
	end

	return false
end

return PropUtilities
