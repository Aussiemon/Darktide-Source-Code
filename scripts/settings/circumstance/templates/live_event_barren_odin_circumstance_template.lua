-- chunkname: @scripts/settings/circumstance/templates/live_event_barren_odin_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local core_mutators = {
	"mutator_gameplay_barren_odin",
}
local templates = table.clone(BaseLiveEventTemplate)

templates["<ID>_gas"] = nil

local base_templates = CircumstanceUtils.inherit(templates, core_mutators, {
	"stats_live_event_barren",
	"no_resource_pickups",
	"health_disable_all_stations",
}, "barren_odin")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})

circumstance_templates.barren_odin.ui.display_name = "loc_circumstance_barren_odin_default_title"
circumstance_templates.barren_odin.ui.description = "loc_circumstance_barren_odin_default_description"
circumstance_templates.barren_odin_more_res.ui.display_name = "loc_circumstance_barren_odin_increased_resistance_title"
circumstance_templates.barren_odin_more_res.ui.description = "loc_circumstance_barren_odin_increased_resistance_description"
circumstance_templates.barren_odin_waves_spec.ui.display_name = "loc_circumstance_barren_odin_waves_of_specials_title"
circumstance_templates.barren_odin_waves_spec.ui.description = "loc_circumstance_barren_odin_waves_of_specials_description"
circumstance_templates.barren_odin_hunt_grou.ui.display_name = "loc_circumstance_barren_odin_hunting_grounds_title"
circumstance_templates.barren_odin_hunt_grou.ui.description = "loc_circumstance_barren_odin_hunting_grounds_description"
circumstance_templates.barren_odin_darkness.ui.display_name = "loc_circumstance_barren_odin_darkness_title"
circumstance_templates.barren_odin_darkness.ui.description = "loc_circumstance_barren_odin_darkness_description"
circumstance_templates.barren_odin_ventilation.ui.display_name = "loc_circumstance_barren_odin_ventilation_title"
circumstance_templates.barren_odin_ventilation.ui.description = "loc_circumstance_barren_odin_ventilation_description"

return circumstance_templates
