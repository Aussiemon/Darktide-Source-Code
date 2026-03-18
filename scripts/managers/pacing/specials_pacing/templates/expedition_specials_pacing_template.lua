-- chunkname: @scripts/managers/pacing/specials_pacing/templates/expedition_specials_pacing_template.lua

local SpecialPacingTemplateSettings = require("scripts/managers/pacing/specials_pacing/templates/special_pacing_template_settings")
local GamemodeSpecificSettings = SpecialPacingTemplateSettings.expedition
local ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS = GamemodeSpecificSettings.always_update_at_challange_rating_breeds
local DEFAULT_BREEDS = SpecialPacingTemplateSettings.default_breeds
local DEFAULT_COORDINATED_STRIKE_BREEDS = SpecialPacingTemplateSettings.default_coordinated_strike_breeds
local DEFAULT_DISABLER_OVERRIDE_DURATION = GamemodeSpecificSettings.default_disabler_override_duration
local DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE = GamemodeSpecificSettings.default_disabler_target_alone_player_chance
local DEFAULT_FORESHADOW_STINGER_TIMERS = SpecialPacingTemplateSettings.default_foreshadow_stinger_timers
local DEFAULT_FORESHADOW_STINGERS = SpecialPacingTemplateSettings.default_foreshadow_stingers
local DEFAULT_LONER_PREVENTION_BREEDS = SpecialPacingTemplateSettings.default_loner_prevention_breeds
local DEFAULT_MAX_OF_SAME = GamemodeSpecificSettings.default_max_of_same
local DEFAULT_MIN_DISTANCES_FROM_TARGET = GamemodeSpecificSettings.default_min_distances_from_target
local DEFAULT_MIN_SPAWNERS_RANGES = GamemodeSpecificSettings.default_min_spawners_ranges
local DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS = GamemodeSpecificSettings.default_num_allowed_disabled_per_alive_targets
local DEFAULT_OPTIONAL_MAINPATH_OFFSET = SpecialPacingTemplateSettings.default_optional_mainpath_offset
local DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION = SpecialPacingTemplateSettings.default_optional_prefered_spawn_direction
local DEFAULT_RUSH_PREVENTION_BREEDS = SpecialPacingTemplateSettings.default_rush_prevention_breeds
local DEFAULT_SPAWN_STINGERS = SpecialPacingTemplateSettings.default_spawn_stingers
local DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS = SpecialPacingTemplateSettings.default_speed_running_prevention_breeds
local OPTIONAL_SKIP_MAIN_PATH = GamemodeSpecificSettings.optional_skip_main_path
local FACTION_BOUND_BREEDS = SpecialPacingTemplateSettings.faction_bound_breeds
local HIGH_MAX_OF_SAME = GamemodeSpecificSettings.high_max_of_same
local MIN_TIMER_DIFF_RANGE = GamemodeSpecificSettings.min_timer_diff_range
local TIMER_REDUCTION_MULTIPLIER = GamemodeSpecificSettings.timer_reduction_multiplier
local LOW_MAX_OF_SAME = GamemodeSpecificSettings.low_max_of_same
local specials_pacing_template = {
	name = "expedition_specials",
	resistance_templates = {
		{
			chance_for_coordinated_strike = 0.1,
			coordinated_strike_challenge_rating = 5,
			destroy_special_distance = 100,
			first_spawn_timer_modifer = 0.75,
			max_alive_specials = 3,
			max_spawn_group_offset_range = 6,
			move_timer_when_challenge_rating_above = 30,
			move_timer_when_challenge_rating_above_delay = 20,
			move_timer_when_horde_active = false,
			move_timer_when_monster_active = false,
			rushing_distance = 80,
			spawn_failed_wait_time = 5,
			travel_distance_spawning = true,
			timer_range = {
				200,
				420,
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = LOW_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				180,
				240,
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				2,
				3,
			},
			rush_prevention_breeds = DEFAULT_RUSH_PREVENTION_BREEDS,
			rush_prevention_cooldown = {
				150,
				250,
			},
			rush_prevention_failed_cooldown = {
				5,
				10,
			},
			min_timer_diff_range = MIN_TIMER_DIFF_RANGE,
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			timer_reduction_multiplier = TIMER_REDUCTION_MULTIPLIER,
			optional_skip_main_path = OPTIONAL_SKIP_MAIN_PATH,
		},
		{
			chance_for_coordinated_strike = 0.15,
			coordinated_strike_challenge_rating = 5,
			destroy_special_distance = 100,
			first_spawn_timer_modifer = 0.65,
			max_alive_specials = 4,
			max_spawn_group_offset_range = 6,
			move_timer_when_challenge_rating_above = 30,
			move_timer_when_challenge_rating_above_delay = 20,
			move_timer_when_horde_active = false,
			move_timer_when_monster_active = false,
			spawn_failed_wait_time = 5,
			travel_distance_spawning = true,
			timer_range = {
				200,
				420,
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = LOW_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				350,
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				3,
				4,
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			min_timer_diff_range = MIN_TIMER_DIFF_RANGE,
			timer_reduction_multiplier = TIMER_REDUCTION_MULTIPLIER,
			optional_skip_main_path = OPTIONAL_SKIP_MAIN_PATH,
		},
		{
			chance_for_coordinated_strike = 0.2,
			coordinated_strike_challenge_rating = 5,
			destroy_special_distance = 100,
			first_spawn_timer_modifer = 0.65,
			max_alive_specials = 5,
			max_spawn_group_offset_range = 6,
			move_timer_when_challenge_rating_above = 30,
			move_timer_when_challenge_rating_above_delay = 20,
			move_timer_when_horde_active = true,
			move_timer_when_monster_active = true,
			spawn_failed_wait_time = 5,
			travel_distance_spawning = true,
			timer_range = {
				180,
				400,
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = DEFAULT_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				280,
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				4,
				5,
			},
			loner_prevention_breeds = DEFAULT_LONER_PREVENTION_BREEDS,
			loner_prevention_cooldown = {
				20,
				40,
			},
			loner_prevention_failed_cooldown = {
				3,
				7,
			},
			loner_time = {
				6,
				10,
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			min_timer_diff_range = MIN_TIMER_DIFF_RANGE,
			timer_reduction_multiplier = TIMER_REDUCTION_MULTIPLIER,
			optional_skip_main_path = OPTIONAL_SKIP_MAIN_PATH,
		},
		{
			chance_for_coordinated_strike = 0.225,
			coordinated_strike_challenge_rating = 5,
			coordinated_surge_chance = 0.1,
			destroy_special_distance = 100,
			first_spawn_timer_modifer = 0.6,
			max_alive_specials = 6,
			max_spawn_group_offset_range = 6,
			move_timer_when_challenge_rating_above = 30,
			move_timer_when_challenge_rating_above_delay = 20,
			move_timer_when_horde_active = true,
			move_timer_when_monster_active = true,
			move_timer_when_terror_event_active = true,
			spawn_failed_wait_time = 5,
			travel_distance_spawning = true,
			timer_range = {
				120,
				320,
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = HIGH_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				200,
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				4,
				6,
			},
			coordinated_surge_timer_range = {
				8,
				16,
			},
			coordinated_surge_duration_range = {
				20,
				60,
			},
			num_coordinated_surges_range = {
				0,
				3,
			},
			loner_prevention_breeds = DEFAULT_LONER_PREVENTION_BREEDS,
			loner_prevention_cooldown = {
				40,
				60,
			},
			loner_prevention_failed_cooldown = {
				3,
				7,
			},
			loner_time = {
				10,
				14,
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			min_timer_diff_range = MIN_TIMER_DIFF_RANGE,
			timer_reduction_multiplier = TIMER_REDUCTION_MULTIPLIER,
			optional_skip_main_path = OPTIONAL_SKIP_MAIN_PATH,
		},
		{
			chance_for_coordinated_strike = 0.25,
			coordinated_strike_challenge_rating = 5,
			coordinated_surge_chance = 0.2,
			destroy_special_distance = 100,
			first_spawn_timer_modifer = 0.6,
			max_alive_specials = 8,
			max_spawn_group_offset_range = 6,
			move_timer_when_challenge_rating_above = 20,
			move_timer_when_challenge_rating_above_delay = 20,
			move_timer_when_horde_active = true,
			move_timer_when_monster_active = true,
			move_timer_when_terror_event_active = true,
			spawn_failed_wait_time = 5,
			travel_distance_spawning = true,
			timer_range = {
				80,
				240,
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = HIGH_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				200,
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				6,
				8,
			},
			coordinated_surge_timer_range = {
				8,
				16,
			},
			coordinated_surge_duration_range = {
				40,
				80,
			},
			num_coordinated_surges_range = {
				3,
				6,
			},
			loner_prevention_breeds = DEFAULT_LONER_PREVENTION_BREEDS,
			loner_prevention_cooldown = {
				20,
				40,
			},
			loner_prevention_failed_cooldown = {
				3,
				7,
			},
			loner_time = {
				25,
				45,
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			min_timer_diff_range = MIN_TIMER_DIFF_RANGE,
			timer_reduction_multiplier = TIMER_REDUCTION_MULTIPLIER,
			optional_skip_main_path = OPTIONAL_SKIP_MAIN_PATH,
		},
	},
}

return specials_pacing_template
