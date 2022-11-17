local circumstance_templates = {}

local function _extract_circumstance_templates(path)
	local circumstances = require(path)

	for name, circumstance_data in pairs(circumstances) do
		circumstance_templates[name] = circumstance_data
	end
end

_extract_circumstance_templates("scripts/settings/circumstance/templates/default_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/dummy_resistance_changes_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/assault_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/darkness_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/hunting_grounds_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/nurgle_manifestation_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/ventilation_purge_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/resistance_changes_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/gas_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/extra_trickle_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/more_specials_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/more_hordes_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/more_monsters_circumstance_template")
_extract_circumstance_templates("scripts/settings/circumstance/templates/more_witches_circumstance_template")

for name, circumstance_data in pairs(circumstance_templates) do
	circumstance_data.name = name
end

return settings("CircumstanceTemplates", circumstance_templates)
