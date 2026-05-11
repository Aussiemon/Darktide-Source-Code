-- chunkname: @scripts/settings/circumstance/templates/live_event_skulls_guns_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local core_mutators = {
	"mutator_enable_twin_havoc_inventory",
	"mutator_nurgle_totem_more",
	"mutator_live_event_skulls_drop_single_skull_pickup_on_death",
	"mutator_live_event_skulls_drop_many_skull_pickups_on_death",
	"mutator_live_event_skulls_guns_full",
}
local base_templates = CircumstanceUtils.inherit(BaseLiveEventTemplate, core_mutators, {
	"stats_live_event_skulls_guns",
}, "skulls_guns")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})

circumstance_templates.skulls_guns.ui.display_name = "loc_circumstance_skulls_guns_default_title"
circumstance_templates.skulls_guns.ui.description = "loc_circumstance_skulls_guns_default_description"
circumstance_templates.skulls_guns_more_res.ui.display_name = "loc_circumstance_skulls_guns_increased_resistance_title"
circumstance_templates.skulls_guns_more_res.ui.description = "loc_circumstance_skulls_guns_increased_resistance_description"
circumstance_templates.skulls_guns_waves_spec.ui.display_name = "loc_circumstance_skulls_guns_waves_of_specials_title"
circumstance_templates.skulls_guns_waves_spec.ui.description = "loc_circumstance_skulls_guns_waves_of_specials_description"
circumstance_templates.skulls_guns_hunt_grou.ui.display_name = "loc_circumstance_skulls_guns_hunting_grounds_title"
circumstance_templates.skulls_guns_hunt_grou.ui.description = "loc_circumstance_skulls_guns_hunting_grounds_description"
circumstance_templates.skulls_guns_darkness.ui.display_name = "loc_circumstance_skulls_guns_darkness_title"
circumstance_templates.skulls_guns_darkness.ui.description = "loc_circumstance_skulls_guns_darkness_description"
circumstance_templates.skulls_guns_ventilation.ui.display_name = "loc_circumstance_skulls_guns_ventilation_title"
circumstance_templates.skulls_guns_ventilation.ui.description = "loc_circumstance_skulls_guns_ventilation_description"
circumstance_templates.skulls_guns_gas.ui.display_name = "loc_circumstance_skulls_guns_gas_title"
circumstance_templates.skulls_guns_gas.ui.description = "loc_circumstance_skulls_guns_gas_description"

return circumstance_templates
