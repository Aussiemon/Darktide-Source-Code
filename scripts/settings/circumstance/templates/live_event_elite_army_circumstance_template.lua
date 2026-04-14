-- chunkname: @scripts/settings/circumstance/templates/live_event_elite_army_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local core_mutators = {
	"mutator_no_hordes",
	"mutator_reduced_ramp_duration_low",
	"mutator_specials_required_challenge_rating",
	"mutator_travel_distance_spawning_specials",
	"mutator_move_specials_timer_when_monster_active",
	"mutator_live_elite_army_less_roamers",
	"mutator_live_event_increase_terror_event_points",
	"mutator_live_elite_army_override_roamer_pack",
	"mutator_only_elite_terror_events",
	"mutator_ignore_roamer_limits",
	"mutator_no_encampments",
}
local base_templates = CircumstanceUtils.inherit(BaseLiveEventTemplate, core_mutators, {}, "elite_army")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})
local minion_health_modifier = {
	0,
	0,
	0.075,
	0.075,
	0.15,
	0.15,
}

circumstance_templates.elite_army.ui.display_name = "loc_circumstance_elite_army_default_title"
circumstance_templates.elite_army.ui.description = "loc_circumstance_elite_army_default_description"
circumstance_templates.elite_army.minion_health_modifier = minion_health_modifier
circumstance_templates.elite_army_more_res.ui.display_name = "loc_circumstance_elite_army_increased_resistance_title"
circumstance_templates.elite_army_more_res.ui.description = "loc_circumstance_elite_army_increased_resistance_description"
circumstance_templates.elite_army_more_res.minion_health_modifier = minion_health_modifier
circumstance_templates.elite_army_waves_spec.ui.display_name = "loc_circumstance_elite_army_waves_of_specials_title"
circumstance_templates.elite_army_waves_spec.ui.description = "loc_circumstance_elite_army_waves_of_specials_description"
circumstance_templates.elite_army_waves_spec.minion_health_modifier = minion_health_modifier
circumstance_templates.elite_army_hunt_grou.ui.display_name = "loc_circumstance_elite_army_hunting_grounds_title"
circumstance_templates.elite_army_hunt_grou.ui.description = "loc_circumstance_elite_army_hunting_grounds_description"
circumstance_templates.elite_army_hunt_grou.minion_health_modifier = minion_health_modifier
circumstance_templates.elite_army_darkness.ui.display_name = "loc_circumstance_elite_army_darkness_title"
circumstance_templates.elite_army_darkness.ui.description = "loc_circumstance_elite_army_darkness_description"
circumstance_templates.elite_army_darkness.minion_health_modifier = minion_health_modifier
circumstance_templates.elite_army_ventilation.ui.display_name = "loc_circumstance_elite_army_ventilation_title"
circumstance_templates.elite_army_ventilation.ui.description = "loc_circumstance_elite_army_ventilation_description"
circumstance_templates.elite_army_ventilation.minion_health_modifier = minion_health_modifier
circumstance_templates.elite_army_gas.ui.display_name = "loc_circumstance_elite_army_gas_title"
circumstance_templates.elite_army_gas.ui.description = "loc_circumstance_elite_army_gas_description"
circumstance_templates.elite_army_gas.minion_health_modifier = minion_health_modifier

return circumstance_templates
