-- chunkname: @scripts/settings/warp_charge/archetype_warp_charge_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local archetype_warp_charge_templates = {}

archetype_warp_charge_templates.default = {
	auto_vent_delay = 30,
	auto_vent_duration = 240,
	critical_threshold = 0.8,
	critical_threshold_decay_rate = 0.05,
	explode_action = "action_warp_charge_explode",
	extreme_threshold = 0.97,
	high_threshold = 0.5,
	high_threshold_decay_rate = 0.15,
	low_threshold = 0.2,
	low_threshold_decay_rate = 0.75,
	min_vent_time_fraction = 0.25,
	ramping_interval_modifier = 1,
	vent_duration = 60,
	vent_interval = 2,
	vent_power_level = {
		20,
		20,
	},
	vent_damage_profile = DamageProfileTemplates.plasma_vent_damage,
	vent_damage_type = damage_types.warp,
	fx = {
		looping_venting_wwise_start_event = "wwise/events/player/play_psyker_venting",
		looping_venting_wwise_stop_event = "wwise/events/player/stop_psyker_venting",
		looping_wwise_parameter_name = "psyker_overload",
	},
}
archetype_warp_charge_templates.psyker = {
	auto_vent_delay = 3,
	auto_vent_duration = 12,
	critical_threshold = 0.97,
	critical_threshold_decay_rate = 0.7,
	explode_action = "action_warp_charge_explode",
	extreme_threshold = 0.97,
	high_threshold = 0.5,
	high_threshold_decay_rate = 0.9,
	low_threshold = 0.3,
	low_threshold_decay_rate = 1,
	min_vent_time_fraction = 0.2,
	ramping_interval_modifier = 1,
	vent_duration = 2.9,
	vent_interval = 0.25,
	vent_power_level = {
		0,
		8,
	},
	vent_damage_profile = DamageProfileTemplates.plasma_vent_damage,
	vent_damage_type = damage_types.warp,
	fx = {
		looping_venting_wwise_start_event = "wwise/events/player/play_psyker_venting",
		looping_venting_wwise_stop_event = "wwise/events/player/stop_psyker_venting",
		looping_wwise_parameter_name = "psyker_overload",
	},
}

return settings("ArchetypeWarpChargeTemplates", archetype_warp_charge_templates)
