local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
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

local function _range(from, to, step)
	local array = {}

	for at = from, to, step or 1 do
		array[#array + 1] = at
	end

	return array
end

local function _add_weapon_kills(category_name)
	local description = string.format("kill_%s_%%s", category_name)
	local stat_id = string.format("total_kills_%s", category_name)

	_add_achievement_family(description, UITypes.increasing_stat, Categories[category_name], IncreasingStatTrigger, AchievementStats.definitions[stat_id], {
		400,
		1000,
		5000,
		15000,
		20000
	})
end

local function _add_weapon_missions(weapon_type, category_name)
	return
end

local category_name = "autogun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "autopistol_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "chain_sword_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_axe_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_axe_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_blade_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "force_staff_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "force_sword_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "lasgun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "ogryn_club_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "rippergun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "shotgun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "shotgun_grenade_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "stub_pistol_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "thunder_hammer_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local function _add_specialization_ranks(specialization)
	local description = string.format("rank_%s_%%s", specialization)
	local stat_id = string.format("max_rank_%s", specialization)

	_add_achievement_family(description, UITypes.event, specialization, IncreasingStatTrigger, AchievementStats.definitions[stat_id], _range(5, 30, 5))
end

local function _add_specialization_missions(specialization)
	local description = string.format("missions_%s_%%s", specialization)
	local stat_id = string.format("missions_%s", specialization)

	_add_achievement_family(description, UITypes.increasing_stat, specialization, IncreasingStatTrigger, AchievementStats.definitions[stat_id], {
		5,
		25,
		75,
		200,
		500
	})
end

local function _add_specialization_objectives(specialization)
	return
end

local specialization = Categories.ogryn_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)
_add_achievement("ogryn_2_bull_rushed_charging_ogryn", UITypes.event, Categories.ogryn_2, EventTrigger:new("ogryn_2_bull_rushed_charging_ogryn_event"))
_add_achievement("ogryn_2_killed_corruptor_with_grenade_impact", UITypes.event, Categories.ogryn_2, IncreasingStatTrigger:new(AchievementStats.definitions.ogryn_2_killed_corruptor_with_grenade_impact, 1))

local specialization = Categories.veteran_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)
_add_achievement("veteran_2_unbounced_grenade_kills", UITypes.event, Categories.veteran_2, EventTrigger:new("veteran_2_unbounced_grenade_kills_event"))
_add_achievement("veteran_2_weakspot_hits_during_volley_fire_alternate_fire", UITypes.increasing_stat, Categories.veteran_2, IncreasingStatTrigger:new(AchievementStats.definitions.max_weakspot_hit_during_volley_fire_alternate_fire, 4))

local specialization = Categories.psyker_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)
_add_achievement("psyker_2_smite_hound_mid_leap", UITypes.event, Categories.psyker_2, IncreasingStatTrigger:new(AchievementStats.definitions.smite_hound_mid_leap, 1))
_add_achievement("psyker_2_edge_kills_last_2_sec", UITypes.increasing_stat, Categories.psyker_2, IncreasingStatTrigger:new(AchievementStats.definitions.max_psyker_2_edge_kills_last_2_sec, 20), false, {
	time_window = 2
})

local specialization = Categories.zealot_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)
_add_achievement("zealot_2_stagger_sniper_with_grenade_distance", UITypes.increasing_stat, Categories.zealot_2, IncreasingStatTrigger:new(AchievementStats.definitions.max_zealot_2_stagger_sniper_with_grenade_distance, 40))
_add_achievement("zelot_2_kill_mutant_charger_with_melee_while_dashing", UITypes.event, Categories.zealot_2, IncreasingStatTrigger:new(AchievementStats.definitions.zelot_2_kill_mutant_charger_with_melee_while_dashing, 1))

local function _add_mission_objective(objective_name)
	local description = string.format("%s_mission_%%s", objective_name)
	local stat_id = string.format("%s_missions", objective_name)

	_add_achievement_family(description, UITypes.increasing_stat, Categories.mission, IncreasingStatTrigger, AchievementStats.definitions[stat_id], {
		5,
		25,
		75,
		200,
		500
	})
end

_add_achievement_family("scan_%s", UITypes.increasing_stat, Categories.mission, IncreasingStatTrigger, AchievementStats.definitions.total_scans, {
	5,
	15,
	75,
	180,
	600
})
_add_achievement_family("hack_%s", UITypes.increasing_stat, Categories.mission, IncreasingStatTrigger, AchievementStats.definitions.total_hacks, {
	4,
	10,
	30,
	80,
	240
})
_add_achievement_family("mission_circumstace_%s", UITypes.increasing_stat, Categories.mission, IncreasingStatTrigger, AchievementStats.definitions.mission_circumstance, {
	5,
	25,
	75,
	200,
	500
})
_add_achievement("hack_perfect", UITypes.event, Categories.mission, IncreasingStatTrigger:new(AchievementStats.definitions.perfect_hacks, 1))
_add_achievement("prologue", UITypes.event, Categories.story, BackendTrigger:new())
_add_achievement("basic_training", UITypes.event, Categories.story, BackendTrigger:new())
_add_achievement("path_of_trust_1", UITypes.event, Categories.story, BackendTrigger:new())
_add_achievement_family("revive_%s", UITypes.increasing_stat, Categories.cooperation, IncreasingStatTrigger, AchievementStats.definitions.total_player_rescues, {
	5,
	40,
	125,
	300,
	750
})
_add_achievement_family("assists_%s", UITypes.increasing_stat, Categories.cooperation, IncreasingStatTrigger, AchievementStats.definitions.total_player_assists, {
	10,
	50,
	150,
	400,
	1000
})
_add_achievement("flawless_team", UITypes.event, Categories.cooperation, IncreasingStatTrigger:new(AchievementStats.definitions.team_flawless_missions, 1))
_add_achievement("coherency_toughness", UITypes.increasing_stat, Categories.cooperation, IncreasingStatTrigger:new(AchievementStats.definitions.total_coherency_toughness, 2000))
_add_achievement("revive_all", UITypes.increasing_stat, Categories.cooperation, IncreasingStatTrigger:new(AchievementStats.definitions.max_different_players_rescued, 3))
_add_achievement("consecutive_headshots", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger:new(AchievementStats.definitions.max_head_shot_in_a_row, 20))
_add_achievement_family("boss_fast_%s", UITypes.time_trial, Categories.offence, DecreasingStatTrigger, AchievementStats.definitions.fastest_boss_kill, {
	60,
	20,
	5
})
_add_achievement_family("fast_enemies_%s", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger, AchievementStats.definitions.max_kills_last_60_sec, {
	40,
	60,
	90
}, nil, {
	time_window = 60
})
_add_achievement("enemies_climbing", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger:new(AchievementStats.definitions.kill_climbing, 50))
_add_achievement_family("fast_headshot_%s", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger, AchievementStats.definitions.max_head_shot_kills_last_10_sec, {
	3,
	7,
	15
}, nil, {
	time_window = 10
})
_add_achievement_family("fast_blocks_%s", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger, AchievementStats.definitions.max_damage_blocked_last_20_sec, {
	400,
	600,
	900
}, nil, {
	time_window = 10
})
_add_achievement_family("consecutive_dodge_%s", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger, AchievementStats.definitions.max_dodges_in_a_row, {
	7,
	17,
	37
})
_add_achievement_family("flawless_mission_%s", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger, AchievementStats.definitions.highest_flawless_difficulty, {
	1,
	3,
	5
})
_add_achievement("total_sprint_dodges", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.total_sprint_dodges, 99))
_add_achievement("slide_dodge", UITypes.event, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.total_slide_dodges, 1))
_add_achievement("melee_toughness", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.total_melee_toughness_regen, 40000))
_add_achievement("mission_no_damage", UITypes.event, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.mission_no_damage, 1))

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
