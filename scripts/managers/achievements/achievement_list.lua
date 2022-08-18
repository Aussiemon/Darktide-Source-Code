local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
local BackendTrigger = require("scripts/managers/achievements/triggers/achievement_backend_trigger")
local Breeds = require("scripts/settings/breed/breeds")
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

	for i = 1, #achievement_definitions, 1 do
		AchievementList[#AchievementList + 1] = achievement_definitions[i]
	end
end

local function _add_achievement_family_from_trigger(...)
	local achievement_definitions = Factory.create_family_from_triggers(...)

	for i = 1, #achievement_definitions, 1 do
		AchievementList[#AchievementList + 1] = achievement_definitions[i]
	end
end

local function _range(from, to, step)
	local array = {}
	slot4 = from
	slot5 = to
	slot6 = step or 1

	for at = slot4, slot5, slot6 do
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

local function _add_weapon_missions(category_name)
	local description = string.format("missions_%s_%%s", category_name)
	local stat_id = string.format("missions_%s", category_name)

	_add_achievement_family(description, UITypes.increasing_stat, Categories[category_name], IncreasingStatTrigger, AchievementStats.definitions[stat_id], {
		3,
		12,
		60,
		120,
		300
	})
end

local category_name = "autogun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "autogun_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "autogun_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "autopistol_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "autopistol_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "bolter_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "chain_axe_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "chain_sword_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_axe_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_axe_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_axe_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_blade_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_knife_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_sword_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_sword_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "combat_sword_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "flamer_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "force_staff_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "force_staff_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "force_staff_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "force_sword_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "grenadier_gauntlet_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "heavystubber_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "lasgun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "lasgun_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "lasgun_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "laspistol_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "ogryn_club_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "ogryn_club_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "ogryn_power_maul_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "ogryn_powermaul_slabshield_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "plasma_rifle_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "plasma_rifle_p2"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "power_maul_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "power_sword_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "rippergun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "shotgun_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "shotgun_p3"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "shotgun_grenade_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "stub_pistol_p1"

_add_weapon_kills(category_name)
_add_weapon_missions(category_name)

local category_name = "stub_rifle_p1"

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
	local achievement_id = string.format("missions_%s_objective", specialization)
	local stat_id = string.format("mission_%s_objectives", specialization)

	_add_achievement(achievement_id, UITypes.increasing_stat, specialization, IncreasingStatTrigger:new(AchievementStats.definitions[stat_id], 6))
end

local specialization = Categories.ogryn_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.ogryn_1

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.veteran_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.veteran_3

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.psyker_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.psyker_3

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.zealot_2

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)

local specialization = Categories.zealot_3

_add_specialization_ranks(specialization)
_add_specialization_missions(specialization)
_add_specialization_objectives(specialization)
_add_achievement_family("kill_renegades_%s", UITypes.increasing_stat, Categories.enemies, IncreasingStatTrigger, AchievementStats.definitions.total_renegade_kills, {
	500,
	3000,
	10000,
	25000,
	60000
})
_add_achievement("melee_renegade", UITypes.event, Categories.enemies, IncreasingStatTrigger:new(AchievementStats.definitions.total_renegade_grenadier_melee, 10))
_add_achievement_family("kill_cultists_%s", UITypes.increasing_stat, Categories.enemies, IncreasingStatTrigger, AchievementStats.definitions.total_cultist_kills, {
	500,
	3000,
	10000,
	25000,
	60000
})
_add_achievement_family("kill_chaos_%s", UITypes.increasing_stat, Categories.enemies, IncreasingStatTrigger, AchievementStats.definitions.total_chaos_kills, {
	400,
	2500,
	9000,
	24000,
	60000
})
_add_achievement("banish_daemonhost", UITypes.event, Categories.enemies, IncreasingStatTrigger:new(AchievementStats.definitions.kill_daemonhost, 1), true)

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

_add_mission_objective("kill")
_add_mission_objective("demolition")
_add_mission_objective("luggable")
_add_mission_objective("decode")
_add_mission_objective("fortification")
_add_mission_objective("scanning")
_add_achievement_family("missions_%s", UITypes.increasing_stat, Categories.mission, IncreasingStatTrigger, AchievementStats.definitions.missions, {
	1,
	10,
	50,
	250,
	1200
})
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
_add_achievement("hack_perfect", UITypes.event, Categories.mission, IncreasingStatTrigger:new(AchievementStats.definitions.perfect_hacks, 1), true)
_add_achievement_family_from_trigger("mission_difficulty_objectives_%s", UITypes.increasing_stat, Categories.mission, {
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_1_objectives, 6),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_2_objectives, 6),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_3_objectives, 6),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_4_objectives, 6),
	IncreasingStatTrigger:new(AchievementStats.definitions.mission_difficulty_5_objectives, 6)
}, nil, {
	2,
	4
})
_add_achievement_family("multi_class_%s", UITypes.increasing_stat, Categories.account, MetaTrigger, {
	"rank_ogryn_2_6",
	"rank_ogryn_1_6",
	"rank_veteran_2_6",
	"rank_veteran_3_6",
	"rank_psyker_2_6",
	"rank_psyker_3_6",
	"rank_zealot_2_6",
	"rank_zealot_3_6"
}, {
	2,
	4,
	6,
	8
}, {
	1,
	2
})
_add_achievement("prologue", UITypes.event, Categories.story, BackendTrigger:new(), true)
_add_achievement_family("path_of_trust_%s", UITypes.event, Categories.story, BackendTrigger, nil, _range(1, 9), _range(1, 9))
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
_add_achievement("flawless_team", UITypes.event, Categories.cooperation, IncreasingStatTrigger:new(AchievementStats.definitions.team_flawless_missions, 1), true)
_add_achievement("coherency_toughness", UITypes.increasing_stat, Categories.cooperation, IncreasingStatTrigger:new(AchievementStats.definitions.total_coherency_toughness, 2000))
_add_achievement_family("enemies_%s", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger, AchievementStats.definitions.total_kills, {
	1000,
	5000,
	15000,
	40000,
	100000
}, {
	3
})
_add_achievement("consecutive_headshots", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger:new(AchievementStats.definitions.max_head_shot_in_a_row, 20), true)
_add_achievement_family("boss_fast_%s", UITypes.time_trial, Categories.offence, DecreasingStatTrigger, AchievementStats.definitions.fastest_boss_kill, {
	60,
	20,
	5
}, {
	1
})
_add_achievement_family("fast_enemies_%s", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger, AchievementStats.definitions.max_kills_last_60_sec, {
	40,
	60,
	90
}, {
	1
})
_add_achievement("enemies_climbing", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger:new(AchievementStats.definitions.kill_climbing, 50))
_add_achievement_family("fast_headshot_%s", UITypes.increasing_stat, Categories.offence, IncreasingStatTrigger, AchievementStats.definitions.max_head_shot_kills_last_10_sec, {
	3,
	7,
	15
})
_add_achievement_family("fast_blocks_%s", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger, AchievementStats.definitions.max_damage_blocked_last_20_sec, {
	400,
	600,
	900
}, {
	1
})
_add_achievement_family("consecutive_dodge_%s", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger, AchievementStats.definitions.max_dodges_in_a_row, {
	7,
	17,
	37
}, {
	1
})
_add_achievement_family("flawless_mission_%s", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger, AchievementStats.definitions.highest_flawless_difficulty, {
	1,
	3,
	5
}, {
	1
})
_add_achievement("total_sprint_dodges", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.total_sprint_dodges, 99))
_add_achievement("slide_dodge", UITypes.event, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.total_slide_dodges, 1))
_add_achievement("melee_toughness", UITypes.increasing_stat, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.total_melee_toughness_regen, 40000))
_add_achievement("mission_no_damage", UITypes.event, Categories.defence, IncreasingStatTrigger:new(AchievementStats.definitions.mission_no_damage, 1))

AchievementList._lookup = {}

for index, achievement_definition in ipairs(AchievementList) do
	fassert(AchievementList._lookup[achievement_definition:id()] == nil, "Achievement with '%s' declared twice.", achievement_definition:id())

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
