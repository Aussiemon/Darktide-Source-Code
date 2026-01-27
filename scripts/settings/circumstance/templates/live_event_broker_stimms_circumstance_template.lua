-- chunkname: @scripts/settings/circumstance/templates/live_event_broker_stimms_circumstance_template.lua

local BaseLiveEventTemplate = require("scripts/settings/circumstance/templates/base_live_event_template")
local CircumstanceUtils = require("scripts/settings/circumstance/utilities/circumstance_utils")
local core_mutators = {
	"mutator_player_buff_broker_stimms_syringe_speed",
	"mutator_player_buff_broker_stimms_syringe_heal_corruption",
	"mutator_player_buff_broker_stimms_syringe_ability",
	"mutator_player_buff_broker_stimms_syringe_power",
	"mutator_player_buff_broker_stimms_broker_extra_buff",
	"mutator_only_cultist_faction",
	"mutator_stimmed_minions",
	"mutator_live_event_broker_stimms_crate_spawns",
	"mutator_live_event_broker_stimms_more_tox_bombers",
	"mutator_live_event_broker_stimms_stat_trigger",
	"mutator_enable_twin_havoc_inventory",
	"mutator_live_event_broker_stimms_gameplay",
}
local base_templates = CircumstanceUtils.inherit(BaseLiveEventTemplate, core_mutators, {
	"pickups_more_syringes",
	"stats_live_event_broker_stimms",
}, "broker_stimms")
local circumstance_templates = table.reduce({
	base_templates,
}, table.merge, {})

circumstance_templates.broker_stimms.ui.display_name = "loc_circumstance_broker_stimms_default_title"
circumstance_templates.broker_stimms.ui.description = "loc_circumstance_broker_stimms_default_description"
circumstance_templates.broker_stimms_more_res = table.clone(circumstance_templates.broker_stimms_gas)
circumstance_templates.broker_stimms_more_res.mutators = table.append(circumstance_templates.broker_stimms_more_res.mutators, {
	"mutator_add_resistance",
})
circumstance_templates.broker_stimms_more_res.ui.display_name = "loc_circumstance_broker_stimms_increased_resistance_title"
circumstance_templates.broker_stimms_more_res.ui.description = "loc_circumstance_broker_stimms_increased_resistance_description"
circumstance_templates.broker_stimms_waves_spec = table.clone(circumstance_templates.broker_stimms_gas)
circumstance_templates.broker_stimms_waves_spec.mutators = table.append(circumstance_templates.broker_stimms_waves_spec.mutators, {
	"mutator_waves_of_specials",
	"mutator_increase_terror_event_points",
	"mutator_reduced_ramp_duration_low",
	"mutator_auric_tension_modifier",
})
circumstance_templates.broker_stimms_waves_spec.ui.display_name = "loc_circumstance_broker_stimms_waves_of_specials_title"
circumstance_templates.broker_stimms_waves_spec.ui.description = "loc_circumstance_broker_stimms_waves_of_specials_description"
circumstance_templates.broker_stimms_hunt_grou = table.clone(circumstance_templates.broker_stimms_gas)
circumstance_templates.broker_stimms_hunt_grou.mutators = table.append(circumstance_templates.broker_stimms_hunt_grou.mutators, {
	"mutator_chaos_hounds",
})
circumstance_templates.broker_stimms_hunt_grou.ui.display_name = "loc_circumstance_broker_stimms_hunting_grounds_title"
circumstance_templates.broker_stimms_hunt_grou.ui.description = "loc_circumstance_broker_stimms_hunting_grounds_description"
circumstance_templates.broker_stimms_darkness.ui.display_name = "loc_circumstance_broker_stimms_darkness_title"
circumstance_templates.broker_stimms_darkness.ui.description = "loc_circumstance_broker_stimms_darkness_description"
circumstance_templates.broker_stimms_ventilation.ui.display_name = "loc_circumstance_broker_stimms_ventilation_title"
circumstance_templates.broker_stimms_ventilation.ui.description = "loc_circumstance_broker_stimms_ventilation_description"
circumstance_templates.broker_stimms_gas.ui.display_name = "loc_circumstance_broker_stimms_gas_title"
circumstance_templates.broker_stimms_gas.ui.description = "loc_circumstance_broker_stimms_gas_description"

return circumstance_templates
