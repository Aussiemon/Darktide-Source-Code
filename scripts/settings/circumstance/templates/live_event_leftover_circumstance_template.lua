-- chunkname: @scripts/settings/circumstance/templates/live_event_leftover_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local core_mutators = {
	"mutator_only_cultist_faction",
	"mutator_leftover_gameplay_logic",
	"mutator_live_event_leftover_drop_large_pickups_on_death",
	"mutator_live_event_leftover_loot_point_spawns",
}
local base_templates = CircumstanceUtils.inherit(BaseLiveEventTemplate, core_mutators, {
	"stats_live_event_leftover",
}, "leftover")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})

circumstance_templates.leftover.ui.display_name = "loc_circumstance_leftover_default_title"
circumstance_templates.leftover.ui.description = "loc_circumstance_leftover_default_description"
circumstance_templates.leftover_more_res.ui.display_name = "loc_circumstance_leftover_increased_resistance_title"
circumstance_templates.leftover_more_res.ui.description = "loc_circumstance_leftover_increased_resistance_description"
circumstance_templates.leftover_waves_spec.ui.display_name = "loc_circumstance_leftover_waves_of_specials_title"
circumstance_templates.leftover_waves_spec.ui.description = "loc_circumstance_leftover_waves_of_specials_description"
circumstance_templates.leftover_hunt_grou.ui.display_name = "loc_circumstance_leftover_hunting_grounds_title"
circumstance_templates.leftover_hunt_grou.ui.description = "loc_circumstance_leftover_hunting_grounds_description"
circumstance_templates.leftover_darkness.ui.display_name = "loc_circumstance_leftover_darkness_title"
circumstance_templates.leftover_darkness.ui.description = "loc_circumstance_leftover_darkness_description"
circumstance_templates.leftover_ventilation.ui.display_name = "loc_circumstance_leftover_ventilation_title"
circumstance_templates.leftover_ventilation.ui.description = "loc_circumstance_leftover_ventilation_description"
circumstance_templates.leftover_gas.ui.display_name = "loc_circumstance_leftover_gas_title"
circumstance_templates.leftover_gas.ui.description = "loc_circumstance_leftover_gas_description"

return circumstance_templates
