-- chunkname: @scripts/settings/circumstance/templates/live_event_saints_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local core_mutators = {
	"mutator_live_event_saints_shrine_spawns",
	"mutator_enable_twin_havoc_inventory",
	"mutator_saints_main_path_pickup_spawns",
	"mutator_live_event_saints_auto_events",
	"mutator_live_event_saints_shrine_gameplay",
	"mutator_saints_horde_pacing",
	"mutator_saints_headshot_parasite_enemies",
	"mutator_saints_nurgle_hordes",
}
local base_templates = CircumstanceUtils.inherit(BaseLiveEventTemplate, core_mutators, {
	"stats_saints",
}, "saints_core")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})

circumstance_templates.saints_core.ui.display_name = "loc_circumstance_saints_core_default_title"
circumstance_templates.saints_core.ui.description = "loc_circumstance_saints_core_default_description"
circumstance_templates.saints_core_more_res.ui.display_name = "loc_circumstance_saints_core_increased_resistance_title"
circumstance_templates.saints_core_more_res.ui.description = "loc_circumstance_saints_core_increased_resistance_description"
circumstance_templates.saints_core_waves_spec.ui.display_name = "loc_circumstance_saints_core_waves_of_specials_title"
circumstance_templates.saints_core_waves_spec.ui.description = "loc_circumstance_saints_core_waves_of_specials_description"
circumstance_templates.saints_core_hunt_grou.ui.display_name = "loc_circumstance_saints_core_hunting_grounds_title"
circumstance_templates.saints_core_hunt_grou.ui.description = "loc_circumstance_saints_core_hunting_grounds_description"
circumstance_templates.saints_core_darkness.ui.display_name = "loc_circumstance_saints_core_darkness_title"
circumstance_templates.saints_core_darkness.ui.description = "loc_circumstance_saints_core_darkness_description"
circumstance_templates.saints_core_ventilation.ui.display_name = "loc_circumstance_saints_core_ventilation_title"
circumstance_templates.saints_core_ventilation.ui.description = "loc_circumstance_saints_core_ventilation_description"
circumstance_templates.saints_core_gas.ui.display_name = "loc_circumstance_saints_core_gas_title"
circumstance_templates.saints_core_gas.ui.description = "loc_circumstance_saints_core_gas_description"

return circumstance_templates
