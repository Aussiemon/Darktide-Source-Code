-- chunkname: @scripts/settings/circumstance/templates/live_event_endless_hordes_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local core_mutators = {
	"mutator_no_hordes",
	"mutator_live_event_endless_hordes",
	"mutator_no_witches",
	"mutator_no_boss_patrols",
}
local base_templates = CircumstanceUtils.inherit(BaseLiveEventTemplate, core_mutators, {
	"stats_live_event_endless_hordes",
}, "endless_hordes")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})

circumstance_templates.endless_hordes.ui.display_name = "loc_circumstance_endless_hordes_default_title"
circumstance_templates.endless_hordes.ui.description = "loc_circumstance_endless_hordes_default_description"
circumstance_templates.endless_hordes_more_res.ui.display_name = "loc_circumstance_endless_hordes_increased_resistance_title"
circumstance_templates.endless_hordes_more_res.ui.description = "loc_circumstance_endless_hordes_increased_resistance_description"
circumstance_templates.endless_hordes_waves_spec.ui.display_name = "loc_circumstance_endless_hordes_waves_of_specials_title"
circumstance_templates.endless_hordes_waves_spec.ui.description = "loc_circumstance_endless_hordes_waves_of_specials_description"
circumstance_templates.endless_hordes_hunt_grou.ui.display_name = "loc_circumstance_endless_hordes_hunting_grounds_title"
circumstance_templates.endless_hordes_hunt_grou.ui.description = "loc_circumstance_endless_hordes_hunting_grounds_description"
circumstance_templates.endless_hordes_darkness.ui.display_name = "loc_circumstance_endless_hordes_darkness_title"
circumstance_templates.endless_hordes_darkness.ui.description = "loc_circumstance_endless_hordes_darkness_description"
circumstance_templates.endless_hordes_ventilation.ui.display_name = "loc_circumstance_endless_hordes_ventilation_title"
circumstance_templates.endless_hordes_ventilation.ui.description = "loc_circumstance_endless_hordes_ventilation_description"
circumstance_templates.endless_hordes_gas.ui.display_name = "loc_circumstance_endless_hordes_gas_title"
circumstance_templates.endless_hordes_gas.ui.description = "loc_circumstance_endless_hordes_gas_description"

return circumstance_templates
