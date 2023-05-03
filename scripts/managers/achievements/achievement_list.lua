local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local BackendTrigger = require("scripts/managers/achievements/triggers/achievement_backend_trigger")
local Breeds = require("scripts/settings/breed/breeds")
local BreedGroups = require("scripts/settings/achievements/achievement_breed_groups")
local Categories = require("scripts/settings/achievements/achievement_categories")
local DecreasingStatTrigger = require("scripts/managers/achievements/triggers/achievement_decreasing_stat_trigger")
local EventTrigger = require("scripts/managers/achievements/triggers/achievement_event_trigger")
local Factory = require("scripts/managers/achievements/utility/achievement_factory")
local IncreasingStatTrigger = require("scripts/managers/achievements/triggers/achievement_increasing_stat_trigger")
local MetaTrigger = require("scripts/managers/achievements/triggers/achievement_meta_trigger")
local UITypes = require("scripts/settings/achievements/achievement_ui_types")
local WeaponCategories = require("scripts/settings/achievements/achievement_weapon_categories")
local MissionTypes = require("scripts/settings/mission/mission_types")
local AchievementList = {}

local function _add_achievement(...)
	AchievementList[#AchievementList + 1] = Factory.create_unique(...)
end

local function _add_achievement_family(...)
	local achievement_definitions = Factory.create_family(...)

	for i = 1, #achievement_definitions do
		AchievementList[#AchievementList + 1] = achievement_definitions[i]
	end
end

local function _add_achievement_family_from_trigger(...)
	local achievement_definitions = Factory.create_family_from_triggers(...)

	for i = 1, #achievement_definitions do
		AchievementList[#AchievementList + 1] = achievement_definitions[i]
	end
end

local function _add_meta_family(description, category, icon, ...)
	local previous_id = nil
	local triggers = {}

	for i = 1, select("#", ...) do
		local id = string.format(description, i)
		local t = select(i, ...)
		t[#t + 1] = previous_id
		previous_id = id
		triggers[i] = MetaTrigger:new(t)
	end

	_add_achievement_family_from_trigger(description, UITypes.meta, icon, category, triggers, nil, nil, false)
end

local function _range(from, to, step)
	local array = {}

	for at = from, to, step or 1 do
		array[#array + 1] = at
	end

	return array
end

local function _add_specialization_ranks(specialization, icon)
	local description = string.format("rank_%s_%%s", specialization)
	local stat_id = string.format("max_rank_%s", specialization)

	_add_achievement_family(description, UITypes.event, icon, specialization, IncreasingStatTrigger, AchievementStats.definitions[stat_id], _range(5, 30, 5))
end

local function _add_specialization_missions(specialization, icon)
	local description = string.format("missions_%s_%%s", specialization)
	local stat_id = string.format("missions_%s", specialization)

	_add_achievement_family(description, UITypes.increasing_stat, icon, specialization, IncreasingStatTrigger, AchievementStats.definitions[stat_id], {
		25,
		50,
		100,
		150,
		250
	})
end

local function _add_specialization_objectives(specialization, icon)
	local achievement_id = string.format("missions_%s_objective_%%s", specialization)
	local stat_id = string.format("mission_%s_%%s_objectives", specialization)

	_add_achievement_family_from_trigger(achievement_id, UITypes.increasing_stat, icon, specialization, {
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 1)], 7),
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 2)], 7),
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 3)], 7)
	})
end

local function _add_specialization_group(specialization, icon, ...)
	local description = string.format("group_class_%s_%%s", specialization)

	_add_meta_family(description, specialization, icon, ...)
end

local function _add_specialization_missions_difficulty(specialization, category, complexity, amount, icon, ...)
	local achievement_id = string.format("missions_%s_%s_difficulty_%%s", specialization, complexity)
	local stat_id = string.format("missions_%s_difficulty_%%s", specialization)

	_add_achievement_family_from_trigger(achievement_id, UITypes.increasing_stat, icon, category, {
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 1)], amount),
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 2)], amount),
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 3)], amount),
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 4)], amount),
		IncreasingStatTrigger:new(AchievementStats.definitions[string.format(stat_id, 5)], amount)
	})
end

local specialization = "ogryn_2"

_add_specialization_ranks(specialization, "content/ui/textures/icons/achievements/achievement_icon_0001")
_add_specialization_missions(specialization, "content/ui/textures/icons/achievements/achievement_icon_0002")
_add_specialization_objectives(specialization, "content/ui/textures/icons/achievements/achievement_icon_0003")

local category = "ogryn_2_challenges"

_add_specialization_missions_difficulty(specialization, category, "medium", 5, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_09")
_add_achievement("ogryn_2_bull_rushed_charging_ogryn", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0004", category, EventTrigger:new("ogryn_2_bull_rushed_charging_ogryn_event"))
_add_achievement("ogryn_2_killed_corruptor_with_grenade_impact", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0008", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_killed_corruptor_with_grenade_impact, 1))
_add_achievement("ogryn_2_win_with_coherency_all_alive_units", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0009", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_win_with_coherency_all_alive_units, 1), nil, {
	time = 90
})

local ogryn_2_bull_rushed_100_enemies_requirement = 60

_add_achievement("ogryn_2_bull_rushed_100_enemies", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0006", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_ogryn_2_lunge_number_of_enemies_hit, ogryn_2_bull_rushed_100_enemies_requirement))
_add_achievement("ogryn_2_bull_rushed_70_within_25_seconds", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0007", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_ogryn_2_lunge_distance_last_x_seconds, 40), nil, {
	tag_color_b = 20,
	tag_color_g = 140,
	tag_color_r = 200,
	time_window = 20,
	description_tag = "\n " .. Localize("loc_private_tag_name") .. ": " .. Localize("loc_private_tag_description")
}, {
	name_tag = "",
	tag_color_g = 170,
	tag_color_r = 255,
	tag_color_b = 30
})

local ogryn_2_bull_rushed_4_ogryns_requirement = 4

_add_achievement("ogryn_2_bull_rushed_4_ogryns", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0005", category, EventTrigger:new("ogryn_2_bull_rushed_x_ogryns_event"), nil, {
	target = ogryn_2_bull_rushed_4_ogryns_requirement
})
_add_achievement("group_class_ogryn_2_1", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"ogryn_2_killed_corruptor_with_grenade_impact",
	"ogryn_2_bull_rushed_charging_ogryn"
}))
_add_achievement("group_class_ogryn_2_2", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_ogryn_2_1",
	"ogryn_2_bull_rushed_100_enemies",
	"ogryn_2_win_with_coherency_all_alive_units"
}))
_add_achievement("group_class_ogryn_2_3", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_ogryn_2_2",
	"ogryn_2_bull_rushed_70_within_25_seconds",
	"ogryn_2_bull_rushed_4_ogryns"
}))

local category = "ogryn_2"

_add_specialization_missions_difficulty(specialization, category, "easy", 1, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_02")
_add_achievement("group_ogryn_2_rank_1_difficulty_1", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_10", category, MetaTrigger:new({
	"rank_ogryn_2_1",
	"missions_ogryn_2_easy_difficulty_1"
}))
_add_achievement("group_ogryn_2_rank_2_difficulty_2", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_10", category, MetaTrigger:new({
	"rank_ogryn_2_2",
	"missions_ogryn_2_easy_difficulty_2"
}))
_add_achievement("ogryn_2_easy_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_03", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_number_of_revived_or_assisted_allies, 40))
_add_achievement("ogryn_2_easy_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_04", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_number_of_knocked_down_enemies, 5000))
_add_achievement("group_ogryn_2_rank_4_difficulty_3", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_11", category, MetaTrigger:new({
	"rank_ogryn_2_4",
	"missions_ogryn_2_easy_difficulty_3"
}))
_add_achievement("group_ogryn_2_rank_5_difficulty_4", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_11", category, MetaTrigger:new({
	"rank_ogryn_2_5",
	"missions_ogryn_2_easy_difficulty_4"
}))
_add_achievement("ogryn_2_medium_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_05", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_bullrushed_group_of_ranged_enemies, 25), nil, {
	num_enemies = 3
})
_add_achievement("ogryn_2_medium_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_06", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_killed_multiple_enemies_with_sweep, 250), nil, {
	amount = 2
})
_add_achievement("ogryn_2_hard_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_07", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_number_of_missions_with_no_deaths_and_all_revives_within_x_seconds, 3), nil, {
	time = 10
})
_add_achievement("ogryn_2_hard_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_08", category, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_grenade_box_kills_without_missing, 5), nil, {
	amount = 4
})
_add_achievement("group_class_ogryn_2_1_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_12", category, MetaTrigger:new({
	"rank_ogryn_2_4",
	"missions_ogryn_2_objective_1",
	"missions_ogryn_2_1",
	"ogryn_2_easy_1",
	"ogryn_2_easy_2"
}))
_add_achievement("group_class_ogryn_2_2_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_12", category, MetaTrigger:new({
	"group_class_ogryn_2_1_rework",
	"rank_ogryn_2_5",
	"missions_ogryn_2_objective_2",
	"missions_ogryn_2_2",
	"ogryn_2_medium_1",
	"ogryn_2_medium_2"
}))
_add_achievement("group_class_ogryn_2_3_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_12", category, MetaTrigger:new({
	"group_class_ogryn_2_2_rework",
	"rank_ogryn_2_6",
	"missions_ogryn_2_objective_3",
	"missions_ogryn_2_3",
	"ogryn_2_hard_1",
	"ogryn_2_hard_2"
}))

local specialization = "veteran_2"

_add_specialization_ranks(specialization, "content/ui/textures/icons/achievements/achievement_icon_0011")
_add_specialization_missions(specialization, "content/ui/textures/icons/achievements/achievement_icon_0012")
_add_specialization_objectives(specialization, "content/ui/textures/icons/achievements/achievement_icon_0013")

local category = "veteran_2_challenges"

_add_specialization_missions_difficulty(specialization, category, "medium", 5, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_09")
_add_achievement("veteran_2_weakspot_hits_during_volley_fire_alternate_fire", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0015", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_weakspot_hit_during_volley_fire_alternate_fire, 4))
_add_achievement("veteran_2_unbounced_grenade_kills", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0014", category, EventTrigger:new("veteran_2_unbounced_grenade_hits_event"), nil, {
	target = 5
})

local veteran_2_kills_with_last_round_in_mag_requirement = 8

_add_achievement("veteran_2_kills_with_last_round_in_mag", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0017", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_veteran_2_kills_with_last_round_in_mag, veteran_2_kills_with_last_round_in_mag_requirement))
_add_achievement("veteran_2_no_melee_damage_taken", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0016", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_mission_no_melee_damage_taken, 1))
_add_achievement("veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0018", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_elite_weakspot_kill_during_volley_fire_alternate_fire, 5))
_add_achievement("veteran_2_no_missed_shots_empty_ammo", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0016", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_mission_no_missed_shots_empty_ammo, 1), nil, {
	accuracy = 90
})
_add_achievement("group_class_veteran_2_1", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"veteran_2_unbounced_grenade_kills",
	"veteran_2_weakspot_hits_during_volley_fire_alternate_fire"
}))
_add_achievement("group_class_veteran_2_2", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_veteran_2_1",
	"veteran_2_no_melee_damage_taken",
	"veteran_2_kills_with_last_round_in_mag"
}))
_add_achievement("group_class_veteran_2_3", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_veteran_2_2",
	"veteran_2_no_missed_shots_empty_ammo",
	"veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire"
}))

local category = "veteran_2"

_add_specialization_missions_difficulty(specialization, category, "easy", 1, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_02")
_add_achievement("group_veteran_2_rank_1_difficulty_1", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_10", category, MetaTrigger:new({
	"rank_veteran_2_1",
	"missions_veteran_2_easy_difficulty_1"
}))
_add_achievement("group_veteran_2_rank_2_difficulty_2", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_10", category, MetaTrigger:new({
	"rank_veteran_2_2",
	"missions_veteran_2_easy_difficulty_2"
}))
_add_achievement("veteran_2_easy_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_03", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_weakspot_kills, 350))
_add_achievement("veteran_2_easy_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_04", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_ammo_given, 5000))
_add_achievement("group_veteran_2_rank_4_difficulty_3", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_11", category, MetaTrigger:new({
	"rank_veteran_2_4",
	"missions_veteran_2_easy_difficulty_3"
}))
_add_achievement("group_veteran_2_rank_5_difficulty_4", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_11", category, MetaTrigger:new({
	"rank_veteran_2_5",
	"missions_veteran_2_easy_difficulty_4"
}))
_add_achievement("veteran_2_medium_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_05", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_kill_volley_fire_target_malice, 150))
_add_achievement("veteran_2_medium_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_06", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_long_range_kills, 100), nil, {
	distance = 25
})
_add_achievement("veteran_2_hard_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_07", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_multiple_elite_or_special_kills_during_volley_fire_heresy, 50), nil, {
	num_enemies = 2
})
_add_achievement("veteran_2_hard_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_08", category, IncreasingStatTrigger:new(AchievementStats.definitions.veteran_2_extended_volley_fire_duration, 5), nil, {
	time = 20
})
_add_achievement("group_class_veteran_2_1_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_12", category, MetaTrigger:new({
	"rank_veteran_2_4",
	"missions_veteran_2_objective_1",
	"missions_veteran_2_1",
	"veteran_2_easy_1",
	"veteran_2_easy_2"
}))
_add_achievement("group_class_veteran_2_2_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_12", category, MetaTrigger:new({
	"group_class_veteran_2_1_rework",
	"rank_veteran_2_5",
	"missions_veteran_2_objective_2",
	"missions_veteran_2_2",
	"veteran_2_medium_1",
	"veteran_2_medium_2"
}))
_add_achievement("group_class_veteran_2_3_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_12", category, MetaTrigger:new({
	"group_class_veteran_2_2_rework",
	"rank_veteran_2_6",
	"missions_veteran_2_objective_3",
	"missions_veteran_2_3",
	"veteran_2_hard_1",
	"veteran_2_hard_2"
}))

local specialization = "psyker_2"

_add_specialization_ranks(specialization, "content/ui/textures/icons/achievements/achievement_icon_0021")
_add_specialization_missions(specialization, "content/ui/textures/icons/achievements/achievement_icon_0022")
_add_specialization_objectives(specialization, "content/ui/textures/icons/achievements/achievement_icon_0023")

local category = "psyker_2_challenges"

_add_specialization_missions_difficulty(specialization, category, "medium", 5, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_09")
_add_achievement("psyker_2_smite_hound_mid_leap", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0024", category, IncreasingStatTrigger:new(AchievementStats.definitions.smite_hound_mid_leap, 1))
_add_achievement("psyker_2_edge_kills_last_2_sec", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0028", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_psyker_2_edge_kills_last_2_sec, 7), nil, {
	time_window = 2
})
_add_achievement("psyker_2_stay_at_max_souls_for_duration", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0027", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_psyker_2_time_at_max_souls, 300))

local psyker_2_perils_of_the_warp_elite_kills_requirement = 1

_add_achievement("psyker_2_perils_of_the_warp_elite_kills", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0025", category, EventTrigger:new("psyker_2_perils_of_the_warp_elite_kills_event"), nil, {
	target = psyker_2_perils_of_the_warp_elite_kills_requirement
})

local psyker_2_elite_or_special_kills_with_smite_last_10_sec_requirement = 4

_add_achievement("psyker_2_elite_or_special_kills_with_smite_last_10_sec", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0026", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_elite_or_special_kills_with_smite_last_12_sec, psyker_2_elite_or_special_kills_with_smite_last_10_sec_requirement), nil, {
	time_window = 12
})
_add_achievement("psyker_2_kill_boss_solo_with_smite", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0029", category, IncreasingStatTrigger:new(AchievementStats.definitions.kill_boss_solo_with_smite, 1), nil, {
	tag_color_g = 140,
	tag_color_r = 200,
	tag_color_b = 20,
	description_tag = "\n " .. Localize("loc_private_tag_name") .. ": " .. Localize("loc_private_tag_description")
}, {
	name_tag = "",
	tag_color_g = 170,
	tag_color_r = 255,
	tag_color_b = 30
})
_add_achievement("group_class_psyker_2_1", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"psyker_2_edge_kills_last_2_sec",
	"psyker_2_smite_hound_mid_leap"
}))
_add_achievement("group_class_psyker_2_2", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_psyker_2_1",
	"psyker_2_perils_of_the_warp_elite_kills",
	"psyker_2_stay_at_max_souls_for_duration"
}))
_add_achievement("group_class_psyker_2_3", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_psyker_2_2",
	"psyker_2_elite_or_special_kills_with_smite_last_10_sec",
	"psyker_2_kill_boss_solo_with_smite"
}))

local category = "psyker_2"

_add_specialization_missions_difficulty(specialization, category, "easy", 1, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_02")
_add_achievement("group_psyker_2_rank_1_difficulty_1", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_10", category, MetaTrigger:new({
	"rank_psyker_2_1",
	"missions_psyker_2_easy_difficulty_1"
}))
_add_achievement("group_psyker_2_rank_2_difficulty_2", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_10", category, MetaTrigger:new({
	"rank_psyker_2_2",
	"missions_psyker_2_easy_difficulty_2"
}))
_add_achievement("psyker_2_easy_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_03", category, IncreasingStatTrigger:new(AchievementStats.definitions.psyker_2_elite_or_special_kills_with_smite, 200))
_add_achievement("psyker_2_easy_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_04", category, IncreasingStatTrigger:new(AchievementStats.definitions.psyker_2_survived_perils, 50))
_add_achievement("group_psyker_2_rank_4_difficulty_3", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_11", category, MetaTrigger:new({
	"rank_psyker_2_4",
	"missions_psyker_2_easy_difficulty_3"
}))
_add_achievement("group_psyker_2_rank_5_difficulty_4", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_11", category, MetaTrigger:new({
	"rank_psyker_2_5",
	"missions_psyker_2_easy_difficulty_4"
}))
_add_achievement("psyker_2_medium_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_05", category, IncreasingStatTrigger:new(AchievementStats.definitions.psyker_2_smite_kills_at_max_souls, 100))
_add_achievement("psyker_2_medium_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_06", category, IncreasingStatTrigger:new(AchievementStats.definitions.psyker_2_warp_kills, 2500))
_add_achievement("psyker_2_hard_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_07", category, IncreasingStatTrigger:new(AchievementStats.definitions.psyker_2_killed_disablers_before_disabling, 25))
_add_achievement("psyker_2_hard_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_08", category, IncreasingStatTrigger:new(AchievementStats.definitions.psyker_2_x_missions_no_elite_melee_damage_taken, 3))
_add_achievement("group_class_psyker_2_1_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_12", category, MetaTrigger:new({
	"rank_psyker_2_4",
	"missions_psyker_2_objective_1",
	"missions_psyker_2_1",
	"psyker_2_easy_1",
	"psyker_2_easy_2"
}))
_add_achievement("group_class_psyker_2_2_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_12", category, MetaTrigger:new({
	"group_class_psyker_2_1_rework",
	"rank_psyker_2_5",
	"missions_psyker_2_objective_2",
	"missions_psyker_2_2",
	"psyker_2_medium_1",
	"psyker_2_medium_2"
}))
_add_achievement("group_class_psyker_2_3_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_12", category, MetaTrigger:new({
	"group_class_psyker_2_2_rework",
	"rank_psyker_2_6",
	"missions_psyker_2_objective_3",
	"missions_psyker_2_3",
	"psyker_2_hard_1",
	"psyker_2_hard_2"
}))

local specialization = "zealot_2"

_add_specialization_ranks(specialization, "content/ui/textures/icons/achievements/achievement_icon_0031")
_add_specialization_missions(specialization, "content/ui/textures/icons/achievements/achievement_icon_0032")
_add_specialization_objectives(specialization, "content/ui/textures/icons/achievements/achievement_icon_0033")

local category = "zealot_2_challenges"

_add_specialization_missions_difficulty(specialization, category, "medium", 5, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_09")
_add_achievement("zealot_2_stagger_sniper_with_grenade_distance", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0035", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_zealot_2_stagger_sniper_with_grenade_distance, 40))
_add_achievement("zelot_2_kill_mutant_charger_with_melee_while_dashing", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0039", category, IncreasingStatTrigger:new(AchievementStats.definitions.zelot_2_kill_mutant_charger_with_melee_while_dashing, 1))
_add_achievement("zealot_2_kills_of_shocked_enemies_last_15", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0037", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_zealot_2_kills_of_shocked_enemies_last_15, 40), nil, {
	time_window = 10
})
_add_achievement("zealot_2_not_use_ranged_attacks", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0038", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_not_use_ranged_attacks, 1))
_add_achievement("zealot_2_healed_up_after_resisting_death", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0036", category, IncreasingStatTrigger:new(AchievementStats.definitions.max_zealot_2_health_healed_with_leech_during_resist_death, 75))
_add_achievement("zealot_2_health_on_last_segment_enough_during_mission", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0034", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_health_on_last_segment_enough_mission_end, 1), nil, {
	tag_color_b = 20,
	tag_color_g = 140,
	health = 75,
	tag_color_r = 200,
	time_window = 20,
	description_tag = "\n " .. Localize("loc_private_tag_name") .. ": " .. Localize("loc_private_tag_description")
}, {
	name_tag = "",
	tag_color_g = 170,
	tag_color_r = 255,
	tag_color_b = 30
})
_add_achievement("group_class_zealot_2_1", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"zelot_2_kill_mutant_charger_with_melee_while_dashing",
	"zealot_2_stagger_sniper_with_grenade_distance"
}))
_add_achievement("group_class_zealot_2_2", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_zealot_2_1",
	"zealot_2_kills_of_shocked_enemies_last_15",
	"zealot_2_not_use_ranged_attacks"
}))
_add_achievement("group_class_zealot_2_3", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category, MetaTrigger:new({
	"group_class_zealot_2_2",
	"zealot_2_health_on_last_segment_enough_during_mission",
	"zealot_2_healed_up_after_resisting_death"
}))

local category = "zealot_2"

_add_specialization_missions_difficulty(specialization, category, "easy", 1, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_02")
_add_achievement("group_zealot_2_rank_1_difficulty_1", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_10", category, MetaTrigger:new({
	"rank_zealot_2_1",
	"missions_zealot_2_easy_difficulty_1"
}))
_add_achievement("group_zealot_2_rank_2_difficulty_2", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_10", category, MetaTrigger:new({
	"rank_zealot_2_2",
	"missions_zealot_2_easy_difficulty_2"
}))
_add_achievement("zealot_2_easy_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_03", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_number_of_shocked_enemies, 1500))
_add_achievement("zealot_2_easy_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_04", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_toughness_gained_from_chastise_the_wicked, 7500))
_add_achievement("group_zealot_2_rank_4_difficulty_3", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_11", category, MetaTrigger:new({
	"rank_zealot_2_4",
	"missions_zealot_2_easy_difficulty_3"
}))
_add_achievement("group_zealot_2_rank_5_difficulty_4", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_11", category, MetaTrigger:new({
	"rank_zealot_2_5",
	"missions_zealot_2_easy_difficulty_4"
}))
_add_achievement("zealot_2_medium_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_05", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_number_of_critical_hits_kills_when_stunned, 75))
_add_achievement("zealot_2_medium_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_06", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_kills_with_martyrdoom_stacks, 1000), nil, {
	stacks = 3
})
_add_achievement("zealot_2_hard_1", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_07", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_killed_elites_and_specials_with_activated_attacks, 75))
_add_achievement("zealot_2_hard_2", UITypes.increasing_stat, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_08", category, IncreasingStatTrigger:new(AchievementStats.definitions.zealot_2_charged_enemy_wielding_ranged_weapon, 40))
_add_achievement("group_class_zealot_2_1_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_12", category, MetaTrigger:new({
	"rank_zealot_2_4",
	"missions_zealot_2_objective_1",
	"missions_zealot_2_1",
	"zealot_2_easy_1",
	"zealot_2_easy_2"
}))
_add_achievement("group_class_zealot_2_2_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_12", category, MetaTrigger:new({
	"group_class_zealot_2_1_rework",
	"rank_zealot_2_5",
	"missions_zealot_2_objective_2",
	"missions_zealot_2_2",
	"zealot_2_medium_1",
	"zealot_2_medium_2"
}))
_add_achievement("group_class_zealot_2_3_rework", UITypes.meta, "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_12", category, MetaTrigger:new({
	"group_class_zealot_2_2_rework",
	"rank_zealot_2_6",
	"missions_zealot_2_objective_3",
	"missions_zealot_2_3",
	"zealot_2_hard_1",
	"zealot_2_hard_2"
}))

local category_name = "enemies"

_add_achievement("all_renegade_specials_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0041", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.renegade_specials_killed, #BreedGroups.renegade_special), nil, {
	target = 10
})
_add_achievement("all_renegade_elites_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0042", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.renegade_elites_killed, #BreedGroups.renegade_elite), nil, {
	target = 10
})
_add_achievement("all_renegades_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0043", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.renegade_killed, #BreedGroups.renegade))
_add_achievement_family("kill_renegades_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0044", category_name, IncreasingStatTrigger, AchievementStats.definitions.total_renegade_kills, {
	1000,
	5000,
	10000,
	15000,
	25000
})
_add_achievement("melee_renegade", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0045", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_renegade_grenadier_melee, 10))
_add_achievement("executor_non_headshot", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0046", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_renegade_executors_non_headshot, 10))
_add_achievement("group_enemies_renegades", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0047", category_name, MetaTrigger:new({
	"all_renegade_specials_killed",
	"all_renegade_elites_killed",
	"all_renegades_killed",
	"kill_renegades_5",
	"melee_renegade",
	"executor_non_headshot"
}))
_add_achievement("all_cultist_specials_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0048", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.cultist_specials_killed, #BreedGroups.cultist_special), nil, {
	target = 10
})
_add_achievement("all_cultist_elites_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0049", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.cultist_elites_killed, #BreedGroups.cultist_elite), nil, {
	target = 10
})
_add_achievement("all_cultists_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0050", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.cultist_killed, #BreedGroups.cultist))
_add_achievement_family("kill_cultists_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0051", category_name, IncreasingStatTrigger, AchievementStats.definitions.total_cultist_kills, {
	1000,
	5000,
	10000,
	15000,
	25000
})
_add_achievement("cultist_berzerker_head", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0052", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_cultist_berzerker_head, 10))
_add_achievement("group_enemies_cultists", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0053", category_name, MetaTrigger:new({
	"all_cultist_specials_killed",
	"all_cultist_elites_killed",
	"all_cultists_killed",
	"kill_cultists_5",
	"cultist_berzerker_head"
}))
_add_achievement("all_chaos_specials_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0054", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.chaos_specials_killed, #BreedGroups.chaos_special), nil, {
	target = 10
})
_add_achievement("all_chaos_elites_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0055", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.chaos_elites_killed, #BreedGroups.chaos_elite), nil, {
	target = 10
})
_add_achievement("all_chaos_killed", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0056", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.chaos_killed, #BreedGroups.chaos))
_add_achievement_family("kill_chaos_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0057", category_name, IncreasingStatTrigger, AchievementStats.definitions.total_chaos_kills, {
	1000,
	5000,
	10000,
	25000,
	50000
})
_add_achievement("ogryn_gunner_melee", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0058", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_ogryn_gunner_melee, 10))
_add_achievement("banish_daemonhost", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0059", category_name, IncreasingStatTrigger:new(AchievementStats.definitions.kill_daemonhost, 1), true)
_add_achievement("group_enemies_chaos", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0060", category_name, MetaTrigger:new({
	"all_chaos_specials_killed",
	"all_chaos_elites_killed",
	"all_chaos_killed",
	"kill_chaos_5",
	"ogryn_gunner_melee"
}))

local missions_category_name = "missions"

local function _add_mission_objective_family(mission_type, icon)
	local id = MissionTypes[mission_type].id
	local description = string.format("type_%s_mission_%%s", id)
	local stat_id = string.format("type_%s_missions", id)

	_add_achievement_family(description, UITypes.increasing_stat, icon, missions_category_name, IncreasingStatTrigger, AchievementStats.definitions[stat_id], {
		50,
		100,
		150,
		200,
		250
	})
end

_add_mission_objective_family("01", "content/ui/textures/icons/achievements/achievement_icon_0061")
_add_mission_objective_family("02", "content/ui/textures/icons/achievements/achievement_icon_0062")
_add_mission_objective_family("03", "content/ui/textures/icons/achievements/achievement_icon_0063")
_add_mission_objective_family("04", "content/ui/textures/icons/achievements/achievement_icon_0064")
_add_mission_objective_family("05", "content/ui/textures/icons/achievements/achievement_icon_0065")
_add_mission_objective_family("06", "content/ui/textures/icons/achievements/achievement_icon_0066")
_add_mission_objective_family("07", "content/ui/textures/icons/achievements/achievement_icon_0067")
_add_achievement_family("missions_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0068", missions_category_name, IncreasingStatTrigger, AchievementStats.definitions.missions, {
	100,
	250,
	500,
	1000,
	1500
})
_add_achievement_family("scan_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0069", missions_category_name, IncreasingStatTrigger, AchievementStats.definitions.total_scans, {
	10,
	25,
	50,
	100,
	200
})
_add_achievement_family("hack_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0070", missions_category_name, IncreasingStatTrigger, AchievementStats.definitions.total_hacks, {
	10,
	25,
	50,
	100,
	200
})
_add_achievement_family("mission_circumstace_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0071", missions_category_name, IncreasingStatTrigger, AchievementStats.definitions.mission_circumstance, {
	1,
	50,
	150,
	250,
	500
})
_add_achievement_family("mission_flash_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0074", missions_category_name, IncreasingStatTrigger, AchievementStats.definitions.mission_flash, {
	1,
	10,
	50,
	100,
	200
})
_add_achievement("difficult_flash_win", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0075", missions_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.highest_flash_difficulty, 5))
_add_achievement("hack_perfect", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0072", missions_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.perfect_hacks, 1))
_add_achievement_family_from_trigger("mission_difficulty_objectives_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0073", missions_category_name, {
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_1_objectives, 7),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_2_objectives, 7),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_3_objectives, 7),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_4_objectives, 7),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_5_objectives, 7)
})
_add_achievement("group_missions", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0078", missions_category_name, MetaTrigger:new({
	"type_1_mission_2",
	"type_2_mission_2",
	"type_3_mission_2",
	"type_4_mission_2",
	"type_5_mission_2",
	"type_6_mission_2",
	"type_7_mission_2"
}))
_add_achievement_family("multi_class_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0079", "account", MetaTrigger, {
	"rank_zealot_2_6",
	"rank_psyker_2_6",
	"rank_veteran_2_6",
	"rank_ogryn_2_6"
}, {
	2,
	4
})

local account_category_name = "account"

_add_achievement("prologue", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0080", account_category_name, BackendTrigger:new())
_add_achievement("basic_training", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0081", account_category_name, BackendTrigger:new())
_add_achievement("unlock_gadgets", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0077", account_category_name, BackendTrigger:new())
_add_achievement("unlock_contracts", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0104", account_category_name, BackendTrigger:new())
_add_achievement("unlock_crafting", UITypes.event, nil, account_category_name, BackendTrigger:new())
_add_achievement_family("path_of_trust_%s", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0082", account_category_name, BackendTrigger, nil, _range(1, 6))

local teamplay_category_name = "teamplay"

_add_achievement_family("revive_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0083", teamplay_category_name, IncreasingStatTrigger, AchievementStats.definitions.total_player_rescues, {
	10,
	50,
	100,
	250,
	500
})
_add_achievement_family("assists_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0084", teamplay_category_name, IncreasingStatTrigger, AchievementStats.definitions.total_player_assists, {
	10,
	50,
	100,
	500,
	1000
})
_add_achievement("flawless_team", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0085", teamplay_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.team_flawless_missions, 100))
_add_achievement("coherency_toughness", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0086", teamplay_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_coherency_toughness, 2000))
_add_achievement("revive_all", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0087", teamplay_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.max_different_players_rescued, 3))
_add_achievement_family("deployables_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0076", teamplay_category_name, IncreasingStatTrigger, AchievementStats.definitions.total_deployables_placed, {
	25,
	50,
	100,
	250,
	500
})
_add_achievement("group_cooperation", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0088", teamplay_category_name, MetaTrigger:new({
	"revive_3",
	"assists_3",
	"flawless_team",
	"coherency_toughness",
	"deployables_3"
}))

local offensive_category_name = "offensive"

_add_achievement_family("enemies_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0089", offensive_category_name, IncreasingStatTrigger, AchievementStats.definitions.total_kills, {
	1000,
	40000,
	100000,
	500000,
	1000000
})
_add_achievement("consecutive_headshots", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0090", offensive_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.max_head_shot_in_a_row, 20))
_add_achievement_family("boss_fast_%s", UITypes.time_trial, "content/ui/textures/icons/achievements/achievement_icon_0091", offensive_category_name, DecreasingStatTrigger, AchievementStats.definitions.fastest_boss_kill, {
	60,
	20,
	5
})
_add_achievement_family("fast_enemies_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0092", offensive_category_name, IncreasingStatTrigger, AchievementStats.definitions.max_kills_last_60_sec, {
	60,
	90,
	120
}, nil, {
	time_window = 30
})
_add_achievement("enemies_climbing", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0093", offensive_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.kill_climbing, 50))
_add_achievement_family("fast_headshot_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0094", offensive_category_name, IncreasingStatTrigger, AchievementStats.definitions.max_head_shot_kills_last_10_sec, {
	3,
	7,
	15
}, nil, {
	time_window = 10
})
_add_achievement("group_offence", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0095", offensive_category_name, MetaTrigger:new({
	"enemies_2",
	"consecutive_headshots",
	"boss_fast_2",
	"fast_enemies_2",
	"enemies_climbing",
	"fast_headshot_2"
}))

local defensive_category_name = "defensive"

_add_achievement_family("fast_blocks_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0096", defensive_category_name, IncreasingStatTrigger, AchievementStats.definitions.max_damage_blocked_last_20_sec, {
	400,
	600,
	900
}, nil, {
	time_window = 10
})
_add_achievement_family("consecutive_dodge_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0097", defensive_category_name, IncreasingStatTrigger, AchievementStats.definitions.max_dodges_in_a_row, {
	7,
	12,
	20
})
_add_achievement_family("flawless_mission_%s", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0098", defensive_category_name, IncreasingStatTrigger, AchievementStats.definitions.max_flawless_mission_in_a_row, {
	5,
	10,
	15
})
_add_achievement("total_sprint_dodges", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0099", defensive_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_sprint_dodges, 99))
_add_achievement("slide_dodge", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0100", defensive_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_slide_dodges, 1))
_add_achievement("melee_toughness", UITypes.increasing_stat, "content/ui/textures/icons/achievements/achievement_icon_0101", defensive_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.total_melee_toughness_regen, 40000))
_add_achievement("mission_no_damage", UITypes.event, "content/ui/textures/icons/achievements/achievement_icon_0102", defensive_category_name, IncreasingStatTrigger:new(AchievementStats.definitions.mission_no_damage, 1))
_add_achievement("group_defence", UITypes.meta, "content/ui/textures/icons/achievements/achievement_icon_0103", defensive_category_name, MetaTrigger:new({
	"fast_blocks_2",
	"consecutive_dodge_2",
	"flawless_mission_1",
	"total_sprint_dodges",
	"slide_dodge",
	"melee_toughness",
	"mission_no_damage"
}))

AchievementList._lookup = {}

for index, achievement_definition in ipairs(AchievementList) do
	AchievementList._lookup[achievement_definition:id()] = index
end

AchievementList.achievement_exists = function (achievement_id)
	local index = AchievementList._lookup[achievement_id]

	return index ~= nil
end

AchievementList.achievement_from_id = function (achievement_id)
	local index = AchievementList._lookup[achievement_id]

	return index and AchievementList[index]
end

return AchievementList
