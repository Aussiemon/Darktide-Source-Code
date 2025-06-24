-- chunkname: @scripts/managers/achievements/achievement_definitions.lua

local AchievementBreedGroups = require("scripts/settings/achievements/achievement_breed_groups")
local AchievementClassGroups = require("scripts/settings/achievements/achievement_class_groups")
local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementMissionGroups = require("scripts/settings/achievements/achievement_mission_groups")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local AchievementWeaponGroups = require("scripts/settings/achievements/achievement_weapon_groups")
local MissionBuffsAllowed = require("scripts/managers/mission_buffs/mission_buffs_allowed_buffs")
local MissionTypes = require("scripts/settings/mission/mission_types")
local PSNPlatformAchievements = require("scripts/settings/achievements/psn_platform_achievements")
local SteamPlatformAchievements = require("scripts/settings/achievements/steam_platform_achievements")
local XboxLivePlatformAchievements = require("scripts/settings/achievements/xbox_live_platform_achievements")
local AchievementTypesLookup = table.enum(unpack(table.keys(AchievementTypes)))

local function _sort_adventure_missions()
	local sorted_list = {}

	for _, mission_type in pairs(MissionTypes) do
		local i = mission_type.index

		if i then
			sorted_list[i] = mission_type
		end
	end

	return sorted_list
end

local adventure_mission_types = _sort_adventure_missions()
local path = "content/ui/textures/icons/achievements/"
local _achievement_count = 0
local _achievement_data = {}
local AchievementDefinitions = setmetatable({}, {
	__index = function (_, key)
		return _achievement_data[key]
	end,
	__newindex = function (_, key, value)
		_achievement_count, _achievement_data[key] = _achievement_count + 1, value
		value.index, value.id = _achievement_count, key
	end,
})

local function string_replacement(pattern, index, config)
	return string.gsub(pattern, "{([%a%d_]*):*([%a%d%.%%]*)}", function (config_key, format)
		local value = config_key == "index" and index or config[config_key]

		return string.format(format or "%s", value)
	end)
end

local function family(base, overrides, configs)
	local last_id

	for index, config in ipairs(configs) do
		local definition = table.clone(base)

		for key, override in pairs(overrides) do
			local override_type = type(override)

			if override_type == "function" then
				definition[key] = override(index, config, definition, key)
			elseif override_type == "string" then
				definition[key] = string_replacement(override, index, config)
			end
		end

		definition.family_index = index

		local id = definition.id

		if last_id then
			definition.previous = last_id
			AchievementDefinitions[last_id].next = id
		end

		last_id = id
		AchievementDefinitions[id] = definition
	end
end

local function old_numeric_target_family(id_pattern, base, targets)
	local configs = {}

	for i = 1, #targets do
		configs[i] = {
			target = targets[i],
		}
	end

	return family(base, {
		id = id_pattern,
		title = "loc_achievement_" .. id_pattern .. "_name",
		target = function (index, config)
			return config.target
		end,
	}, configs)
end

local function _generate_tier_localization()
	return function (index, config, definition, key)
		local loc_variables = definition[key]

		loc_variables = loc_variables or {}
		loc_variables.tier = tostring(index)

		return loc_variables
	end
end

local function tiered_target_family(id_pattern, base, targets)
	local configs = {}

	for i = 1, #targets do
		configs[i] = {
			target = targets[i],
		}
	end

	return family(base, {
		id = id_pattern,
		loc_title_variables = _generate_tier_localization(),
		target = function (index, config)
			return config.target
		end,
	}, configs)
end

local function target_family(id_pattern, base, targets)
	local configs = {}

	for i = 1, #targets do
		configs[i] = {
			target = targets[i],
		}
	end

	return family(base, {
		id = id_pattern,
		target = function (index, config)
			return config.target
		end,
	}, configs)
end

do
	local rank_targets = {
		5,
		10,
		15,
		20,
		25,
		30,
	}
	local generic_mission_targets = {
		5,
		25,
		50,
		75,
		100,
	}

	local function _generate_mission_difficulties(archetype_name)
		return function (index, config)
			local difficulty = config.difficulty
			local stats = {}

			for i = 1, #adventure_mission_types do
				local mission_type = adventure_mission_types[i]
				local stat_name = string.format("mission_type_%s_max_difficulty_%s", mission_type.index, archetype_name)

				stats[stat_name] = {
					increasing = true,
					target = difficulty,
				}
			end

			return stats
		end
	end

	local function _generate_mission_difficulties_sorting(archetype_name)
		return function (index, config)
			local stats_sorting = {}

			for i = 1, #adventure_mission_types do
				local mission_type = adventure_mission_types[i]
				local stat_name = string.format("mission_type_%s_max_difficulty_%s", mission_type.index, archetype_name)

				stats_sorting[#stats_sorting + 1] = stat_name
			end

			return stats_sorting
		end
	end

	local function _generate_base_archetype_penances(archetype_name, archetype_category_name, category_progression, category_abilites, achievement_icons, legacy_group_class_targets, group_class_targets)
		tiered_target_family(string.format("rank_%s_2", archetype_name) .. "_{index:%d}", {
			type = AchievementTypesLookup.increasing_stat,
			title = string.format("loc_achievement_rank_%s_2_x_name", archetype_name),
			description = string.format("loc_achievement_rank_%s_2_x_description", archetype_name),
			icon = achievement_icons.rank,
			stat_name = string.format("max_rank_%s", archetype_name),
			category = category_progression,
			flags = {},
		}, rank_targets)
		tiered_target_family(string.format("missions_%s_2", archetype_name) .. "_{index:%d}", {
			type = AchievementTypesLookup.increasing_stat,
			title = string.format("loc_achievement_missions_%s_2_x_name", archetype_name),
			description = string.format("loc_achievement_missions_%s_2_x_description", archetype_name),
			icon = achievement_icons.missions,
			stat_name = string.format("missions_%s_2", archetype_name),
			category = category_progression,
			flags = {},
		}, generic_mission_targets)
		family({
			type = AchievementTypesLookup.multi_stat,
			icon = achievement_icons.missions_objective,
			category = category_progression,
			target = #adventure_mission_types,
			flags = {},
		}, {
			id = string.format("missions_%s_2_objective", archetype_name) .. "_{index:%d}",
			title = string.format("loc_achievement_missions_%s_2_objective", archetype_name) .. "_{index:%d}_name",
			description = string.format("loc_achievement_missions_%s_2_objective", archetype_name) .. "_{index:%d}_description",
			stats = _generate_mission_difficulties(archetype_name),
			stats_sorting = _generate_mission_difficulties_sorting(archetype_name),
		}, {
			{
				difficulty = 1,
			},
			{
				difficulty = 3,
			},
			{
				difficulty = 4,
			},
		})
		family({
			target = 1,
			title = "loc_achievement_complete_missions_easy_difficulty_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = achievement_icons.mission_easy_difficulty,
			category = category_progression,
			flags = {},
		}, {
			description = "loc_achievement_complete_missions_difficulty_{index:%d}_description",
			id = string.format("missions_%s_2_easy_difficulty", archetype_name) .. "_{index:%d}",
			stat_name = string.format("missions_%s_2_difficulty", archetype_name) .. "_{index:%d}",
			loc_title_variables = _generate_tier_localization(),
		}, {
			{},
			{},
			{},
			{},
			{},
		})
		family({
			target = 5,
			title = "loc_achievement_complete_missions_medium_difficulty_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = achievement_icons.mission_medium_difficulty,
			category = category_progression,
			flags = {},
		}, {
			description = "loc_achievement_complete_missions_difficulty_{index:%d}_description",
			id = string.format("missions_%s_2_medium_difficulty", archetype_name) .. "_{index:%d}",
			stat_name = string.format("missions_%s_2_difficulty", archetype_name) .. "_{index:%d}",
			loc_title_variables = _generate_tier_localization(),
		}, {
			{},
			{},
			{},
			{},
			{},
		})

		local rank_and_difficulties = {
			{
				1,
				1,
			},
			{
				2,
				2,
			},
			{
				4,
				3,
			},
			{
				5,
				4,
			},
		}

		for index, rank_and_difficulty in ipairs(rank_and_difficulties) do
			local rank = rank_and_difficulty[1]
			local difficulty = rank_and_difficulty[2]
			local group_achievement_name = string.format("group_%s_2_rank_%d_difficulty_%d", archetype_name, rank, difficulty)

			AchievementDefinitions[group_achievement_name] = {
				target = 2,
				type = AchievementTypesLookup.meta,
				title = string.format("loc_achievement_group_rank_%d_difficulty_%d_name", rank, difficulty),
				description = string.format("loc_achievement_group_%s_2_description", archetype_name),
				icon = index > 2 and achievement_icons.group_rank_and_difficulty_b or achievement_icons.group_rank_and_difficulty,
				achievements = table.set({
					string.format("rank_%s_2_%d", archetype_name, rank),
					string.format("missions_%s_2_easy_difficulty_%d", archetype_name, difficulty),
				}),
				category = category_progression,
				flags = {},
			}
		end

		if legacy_group_class_targets then
			family({
				title = "loc_achievement_group_class_challenges_x_name",
				type = AchievementTypesLookup.meta,
				description = string.format("loc_achievement_group_%s_2_description", archetype_name),
				icon = achievement_icons.class_group_legacy,
				category = category_progression,
				flags = {},
			}, {
				id = string.format("group_class_%s_2", archetype_name) .. "_{index:%d}",
				target = function (self, config)
					return #config
				end,
				achievements = function (self, config)
					return table.set(config)
				end,
				loc_title_variables = _generate_tier_localization(),
			}, legacy_group_class_targets)
		end

		if group_class_targets then
			family({
				type = AchievementTypesLookup.meta,
				description = string.format("loc_achievement_group_%s_2_description", archetype_name),
				icon = achievement_icons.class_group,
				category = category_progression,
				flags = {},
			}, {
				id = string.format("group_class_%s_2", archetype_name) .. "_{index:%d}_rework",
				title = string.format("loc_achievement_group_class_%s_2", archetype_name) .. "_{index:%d}_name",
				target = function (self, config)
					return #config
				end,
				achievements = function (self, config)
					return table.set(config)
				end,
			}, group_class_targets)
		end
	end

	do
		local category_name = "veteran_2"
		local category_progression = "veteran_progression"
		local category_abilites = "veteran_abilites"
		local base_achievement_icons = {
			class_group = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_12",
			class_group_legacy = "content/ui/textures/icons/achievements/achievement_icon_0096",
			group_rank_and_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_10",
			group_rank_and_difficulty_b = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_11",
			mission_easy_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_02",
			mission_medium_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_09",
			missions = "content/ui/textures/icons/achievements/achievement_icon_0012",
			missions_objective = "content/ui/textures/icons/achievements/achievement_icon_0013",
			rank = "content/ui/textures/icons/achievements/achievement_icon_0011",
		}
		local legacy_group_class_targets = {
			{
				"veteran_2_unbounced_grenade_kills",
				"veteran_2_weakspot_hits_during_volley_fire_alternate_fire",
			},
			{
				"group_class_veteran_2_1",
				"veteran_2_no_melee_damage_taken",
				"veteran_2_kills_with_last_round_in_mag",
			},
			{
				"group_class_veteran_2_2",
				"veteran_2_no_missed_shots_empty_ammo",
				"veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire",
			},
		}

		_generate_base_archetype_penances("veteran", category_name, category_progression, category_abilites, base_achievement_icons, legacy_group_class_targets)

		AchievementDefinitions.veteran_2_easy_1 = {
			description = "loc_achievement_veteran_2_easy_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_03",
			stat_name = "veteran_2_weakspot_kills",
			target = 350,
			title = "loc_achievement_veteran_2_easy_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.veteran_2_easy_2 = {
			description = "loc_achievement_veteran_2_easy_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_04",
			stat_name = "veteran_2_ammo_given",
			target = 5000,
			title = "loc_achievement_veteran_2_easy_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_infiltrate_supress = {
			description = "loc_achievement_veteran_infiltrate_supress_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_18",
			stat_name = "veteran_infiltrate_stagger",
			target = 750,
			title = "loc_achievement_veteran_infiltrate_supress_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_voice_of_command_toughness_given = {
			description = "loc_achievement_veteran_voice_of_command_toughness_given_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_17",
			stat_name = "veteran_voice_of_command_toughness_given",
			target = 7500,
			title = "loc_achievement_veteran_voice_of_command_toughness_given_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_enemies_killed_with_max_focus_fire = {
			description = "loc_achievement_veteran_enemies_killed_with_max_focus_fire_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_19",
			stat_name = "kills_during_max_focus_fire_stack",
			target = 2500,
			title = "loc_achievement_veteran_enemies_killed_with_max_focus_fire_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_krak_grenade_kills = {
			description = "loc_achievement_veteran_krak_grenade_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_13",
			stat_name = "veteran_krak_grenade_kills",
			target = 500,
			title = "loc_achievement_veteran_krak_grenade_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_smoke_grenade_engulfed = {
			description = "loc_achievement_veteran_smoke_grenade_engulfed_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_14",
			stat_name = "veteran_smoke_grenade_engulfed",
			target = 2000,
			title = "loc_achievement_veteran_smoke_grenade_engulfed_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_kills_with_improved_tag = {
			description = "loc_achievement_veteran_kills_with_improved_tag_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_20",
			stat_name = "veteran_kills_with_improved_tag",
			target = 500,
			title = "loc_achievement_veteran_kills_with_improved_tag_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_weapon_switch_passive_keystone_kills = {
			description = "loc_achievement_veteran_weapon_switch_passive_keystone_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_21",
			stat_name = "veteran_weapon_switch_passive_keystone_kills",
			target = 250,
			title = "loc_achievement_veteran_weapon_switch_passive_keystone_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_team_damage_aura_amplified = {
			description = "loc_achievement_veteran_team_damage_amplified_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_15",
			stat_name = "veteran_team_damage_amplified",
			target = 7500,
			title = "loc_achievement_veteran_team_damage_amplified_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_team_movement_aura_amplified = {
			description = "loc_achievement_veteran_team_movement_amplifed_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_16",
			stat_name = "veteran_team_movement_amplifed",
			target = 10000,
			title = "loc_achievement_veteran_team_movement_amplifed_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_2_medium_1 = {
			description = "loc_achievement_veteran_2_medium_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_05",
			stat_name = "veteran_2_kill_volley_fire_target_malice",
			target = 150,
			title = "loc_achievement_veteran_2_medium_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.veteran_2_medium_2 = {
			description = "loc_achievement_veteran_2_medium_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_06",
			stat_name = "veteran_2_long_range_kills",
			target = 100,
			title = "loc_achievement_veteran_2_medium_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				distance = 30,
			},
		}
		AchievementDefinitions.veteran_2_hard_1 = {
			description = "loc_achievement_veteran_2_hard_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_07",
			stat_name = "max_multiple_elite_or_special_kills_during_volley_fire_heresy",
			target = 50,
			title = "loc_achievement_veteran_2_hard_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				num_enemies = 2,
			},
		}
		AchievementDefinitions.veteran_2_hard_2 = {
			description = "loc_achievement_veteran_2_hard_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_08",
			stat_name = "veteran_2_extended_volley_fire_duration",
			target = 5,
			title = "loc_achievement_veteran_2_hard_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				time = 20,
			},
		}

		family({
			description = "loc_achievement_group_class_veteran_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_12",
			type = AchievementTypesLookup.meta,
			category = category_progression,
			flags = {},
		}, {
			id = "group_class_veteran_2_{index:%d}_rework",
			title = "loc_achievement_group_class_veteran_2_{index:%d}_name",
			target = function (self, config)
				return #config
			end,
			achievements = function (self, config)
				return table.set(config)
			end,
		}, {
			{
				"rank_veteran_2_4",
				"missions_veteran_2_objective_1",
				"missions_veteran_2_1",
				"veteran_2_easy_1",
				"veteran_2_easy_2",
			},
			{
				"group_class_veteran_2_1_rework",
				"rank_veteran_2_5",
				"missions_veteran_2_objective_2",
				"missions_veteran_2_2",
				"veteran_2_medium_1",
				"veteran_2_medium_2",
			},
			{
				"group_class_veteran_2_2_rework",
				"rank_veteran_2_6",
				"missions_veteran_2_objective_3",
				"missions_veteran_2_3",
				"veteran_2_hard_1",
				"veteran_2_hard_2",
			},
		})
	end

	do
		local category_name = "zealot_2"
		local category_progression = "zealot_progression"
		local category_abilites = "zealot_abilites"
		local base_achievement_icons = {
			class_group = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_12",
			class_group_legacy = "content/ui/textures/icons/achievements/achievement_icon_0096",
			group_rank_and_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_10",
			group_rank_and_difficulty_b = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_11",
			mission_easy_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_02",
			mission_medium_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_09",
			missions = "content/ui/textures/icons/achievements/achievement_icon_0032",
			missions_objective = "content/ui/textures/icons/achievements/achievement_icon_0033",
			rank = "content/ui/textures/icons/achievements/achievement_icon_0031",
		}
		local legacy_group_class_targets = {
			{
				"zelot_2_kill_mutant_charger_with_melee_while_dashing",
				"zealot_2_stagger_sniper_with_grenade_distance",
			},
			{
				"group_class_zealot_2_1",
				"zealot_2_kills_of_shocked_enemies_last_15",
				"zealot_2_not_use_ranged_attacks",
			},
			{
				"group_class_zealot_2_2",
				"zealot_2_health_on_last_segment_enough_during_mission",
				"zealot_2_healed_up_after_resisting_death",
			},
		}

		_generate_base_archetype_penances("zealot", category_name, category_progression, category_abilites, base_achievement_icons, legacy_group_class_targets)

		AchievementDefinitions.zealot_2_easy_1 = {
			description = "loc_achievement_zealot_2_easy_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_03",
			stat_name = "zealot_2_number_of_shocked_enemies",
			target = 1500,
			title = "loc_achievement_zealot_2_easy_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_2_easy_2 = {
			description = "loc_achievement_zealot_2_easy_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_04",
			stat_name = "zealot_2_toughness_gained_from_chastise_the_wicked",
			target = 7500,
			title = "loc_achievement_zealot_2_easy_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_elite_or_special_kills_with_shroudfield = {
			description = "loc_achievement_zealot_elite_or_special_kills_with_shroudfield_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_19",
			stat_name = "zealot_elite_or_special_kills_with_shroudfield",
			target = 150,
			title = "loc_achievement_zealot_elite_or_special_kills_with_shroudfield_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_team_toughness_restored_with_chorus = {
			description = "loc_achievement_zealot_team_toughness_restored_with_chorus_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_18",
			stat_name = "zealot_team_toughness_restored_with_chorus",
			target = 7500,
			title = "loc_achievement_zealot_team_toughness_restored_with_chorus_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_elite_or_special_kills_during_fanatic_rage = {
			description = "loc_achievement_zealot_elite_or_special_kills_during_fanatic_rage_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_20",
			stat_name = "zealot_elite_or_special_kills_during_fanatic_rage",
			target = 2000,
			title = "loc_achievement_zealot_elite_or_special_kills_during_fanatic_rage_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_kills_during_movement_keystone_activated = {
			description = "loc_achievement_zealot_kills_during_movement_keystone_activated_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_21",
			stat_name = "zealot_kills_during_movement_keystone_activated",
			target = 250,
			title = "loc_achievement_zealot_kills_during_movement_keystone_activated_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_elite_or_special_kills_with_blade_of_faith = {
			description = "loc_achievement_zealot_elite_or_special_kills_with_blade_of_faith_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_14",
			stat_name = "zealot_elite_or_special_kills_with_blade_of_faith",
			target = 500,
			title = "loc_achievement_zealot_elite_or_special_kills_with_blade_of_faith_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_kills_with_fire_grenade = {
			description = "loc_achievement_zealot_kills_with_fire_grenade_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_13",
			stat_name = "zealot_kills_with_fire_grenade",
			target = 2000,
			title = "loc_achievement_zealot_kills_with_fire_grenade_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_aura_backstab_kills_while_alone = {
			description = "loc_achievement_zealot_aura_backstab_kills_while_alone_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_17",
			stat_name = "zealot_aura_backstab_kills_while_alone",
			target = 200,
			title = "loc_achievement_zealot_aura_backstab_kills_while_alone_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_aura_toughness_damage_reduced = {
			description = "loc_achievement_zealot_aura_toughness_damage_reduced_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_15",
			stat_name = "zealot_aura_toughness_damage_reduced",
			target = 1500,
			title = "loc_achievement_zealot_aura_toughness_damage_reduced_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_aura_corruption_healed = {
			description = "loc_achievement_zealot_aura_corruption_healed_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_16",
			stat_name = "zealot_aura_corruption_healed",
			target = 5000,
			title = "loc_achievement_zealot_aura_corruption_healed_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_2_medium_1 = {
			description = "loc_achievement_zealot_2_medium_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_05",
			stat_name = "zealot_2_number_of_critical_hits_kills_when_stunned",
			target = 75,
			title = "loc_achievement_zealot_2_medium_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.zealot_2_medium_2 = {
			description = "loc_achievement_zealot_2_medium_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_06",
			stat_name = "zealot_2_kills_with_martyrdoom_stacks",
			target = 1000,
			title = "loc_achievement_zealot_2_medium_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				stacks = 3,
			},
		}
		AchievementDefinitions.zealot_2_hard_1 = {
			description = "loc_achievement_zealot_2_hard_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_07",
			stat_name = "zealot_2_killed_elites_and_specials_with_activated_attacks",
			target = 75,
			title = "loc_achievement_zealot_2_hard_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.zealot_2_hard_2 = {
			description = "loc_achievement_zealot_2_hard_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_08",
			stat_name = "zealot_2_charged_enemy_wielding_ranged_weapon",
			target = 40,
			title = "loc_achievement_zealot_2_hard_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}

		family({
			description = "loc_achievement_group_class_zealot_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_12",
			type = AchievementTypesLookup.meta,
			category = category_progression,
			flags = {},
		}, {
			id = "group_class_zealot_2_{index:%d}_rework",
			title = "loc_achievement_group_class_zealot_2_{index:%d}_name",
			target = function (self, config)
				return #config
			end,
			achievements = function (self, config)
				return table.set(config)
			end,
		}, {
			{
				"rank_zealot_2_4",
				"missions_zealot_2_objective_1",
				"missions_zealot_2_1",
				"zealot_2_easy_1",
				"zealot_2_easy_2",
			},
			{
				"group_class_zealot_2_1_rework",
				"rank_zealot_2_5",
				"missions_zealot_2_objective_2",
				"missions_zealot_2_2",
				"zealot_2_medium_1",
				"zealot_2_medium_2",
			},
			{
				"group_class_zealot_2_2_rework",
				"rank_zealot_2_6",
				"missions_zealot_2_objective_3",
				"missions_zealot_2_3",
				"zealot_2_hard_1",
				"zealot_2_hard_2",
			},
		})
	end

	do
		local category_name = "psyker_2"
		local category_progression = "psyker_progression"
		local category_abilites = "psyker_abilites"
		local base_achievement_icons = {
			class_group = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_12",
			class_group_legacy = "content/ui/textures/icons/achievements/achievement_icon_0096",
			group_rank_and_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_10",
			group_rank_and_difficulty_b = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_11",
			mission_easy_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_02",
			mission_medium_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_09",
			missions = "content/ui/textures/icons/achievements/achievement_icon_0022",
			missions_objective = "content/ui/textures/icons/achievements/achievement_icon_0023",
			rank = "content/ui/textures/icons/achievements/achievement_icon_0021",
		}
		local legacy_group_class_targets = {
			{
				"psyker_2_edge_kills_last_2_sec",
				"psyker_2_smite_hound_mid_leap",
			},
			{
				"group_class_psyker_2_1",
				"psyker_2_perils_of_the_warp_elite_kills",
				"psyker_2_stay_at_max_souls_for_duration",
			},
			{
				"group_class_psyker_2_2",
				"psyker_2_elite_or_special_kills_with_smite_last_10_sec",
				"psyker_2_kill_boss_solo_with_smite",
			},
		}

		_generate_base_archetype_penances("psyker", category_name, category_progression, category_abilites, base_achievement_icons, legacy_group_class_targets)

		AchievementDefinitions.psyker_2_easy_1 = {
			description = "loc_achievement_psyker_2_easy_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_03",
			stat_name = "psyker_2_elite_or_special_kills_with_smite",
			target = 200,
			title = "loc_achievement_psyker_2_easy_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_2_easy_2 = {
			description = "loc_achievement_psyker_2_easy_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_04",
			stat_name = "psyker_2_survived_perils",
			target = 50,
			title = "loc_achievement_psyker_2_easy_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_2_medium_1 = {
			description = "loc_achievement_psyker_2_medium_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_05",
			stat_name = "psyker_2_smite_kills_at_max_souls",
			target = 100,
			title = "loc_achievement_psyker_2_medium_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_2_medium_2 = {
			description = "loc_achievement_psyker_2_medium_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_06",
			stat_name = "psyker_2_warp_kills",
			target = 2500,
			title = "loc_achievement_psyker_2_medium_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.psyker_2_hard_1 = {
			description = "loc_achievement_psyker_2_hard_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_07",
			stat_name = "psyker_2_killed_disablers_before_disabling",
			target = 25,
			title = "loc_achievement_psyker_2_hard_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_2_hard_2 = {
			description = "loc_achievement_psyker_2_hard_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_08",
			stat_name = "psyker_2_x_missions_no_elite_melee_damage_taken",
			target = 3,
			title = "loc_achievement_psyker_2_hard_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.psyker_elite_or_special_kills_with_assail = {
			description = "loc_achievement_psyker_elite_or_special_kills_with_assail_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_14",
			stat_name = "psyker_elite_or_special_kills_with_assail",
			target = 250,
			title = "loc_achievement_psyker_elite_or_special_kills_with_assail_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_kills_during_overcharge_stance = {
			description = "loc_achievement_psyker_kills_during_overcharge_stance_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_19",
			stat_name = "max_psyker_kills_during_overcharge_stance",
			target = 40,
			title = "loc_achievement_psyker_kills_during_overcharge_stance_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_kills_with_empowered_abilites = {
			description = "loc_achievement_psyker_kills_with_empowered_abilites_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_20",
			stat_name = "psyker_kills_with_empowered_abilites",
			target = 250,
			title = "loc_achievement_psyker_kills_with_empowered_abilites_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_time_at_max_unnatural = {
			description = "loc_achievement_psyker_time_at_max_unnatural_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_21",
			stat_name = "psyker_time_at_max_unnatural",
			target = 1800,
			title = "loc_achievement_psyker_time_at_max_unnatural_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_damage_blocked_with_shield = {
			description = "loc_achievement_psyker_damage_blocked_with_shield_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_18",
			stat_name = "psyker_shield_total_damage_taken",
			target = 150000,
			title = "loc_achievement_psyker_damage_blocked_with_shield_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_team_elite_aura_kills = {
			description = "loc_achievement_psyker_team_elite_aura_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_15",
			stat_name = "psyker_team_elite_aura_kills",
			target = 2500,
			title = "loc_achievement_psyker_team_elite_aura_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_team_cooldown_reduced = {
			description = "loc_achievement_psyker_team_cooldown_reduced_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_16",
			stat_name = "psyker_team_cooldown_reduced",
			target = 2000,
			title = "loc_achievement_psyker_team_cooldown_reduced_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_team_critical_hits = {
			description = "loc_achievement_psyker_team_critical_hits_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_17",
			stat_name = "psyker_team_critical_hits",
			target = 7500,
			title = "loc_achievement_psyker_team_critical_hits_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.psyker_threshold_kills_reached_with_grenade_chain = {
			description = "loc_achievement_psyker_threshold_kills_reached_with_grenade_chain_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_13",
			stat_name = "psyker_threshold_kills_reached_with_grenade_chain",
			target = 2500,
			title = "loc_achievement_psyker_threshold_kills_reached_with_grenade_chain_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}

		family({
			description = "loc_achievement_group_class_psyker_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_12",
			type = AchievementTypesLookup.meta,
			category = category_progression,
			flags = {},
		}, {
			id = "group_class_psyker_2_{index:%d}_rework",
			title = "loc_achievement_group_class_psyker_2_{index:%d}_name",
			target = function (self, config)
				return #config
			end,
			achievements = function (self, config)
				return table.set(config)
			end,
		}, {
			{
				"rank_psyker_2_4",
				"missions_psyker_2_objective_1",
				"missions_psyker_2_1",
				"psyker_2_easy_1",
				"psyker_2_easy_2",
			},
			{
				"group_class_psyker_2_1_rework",
				"rank_psyker_2_5",
				"missions_psyker_2_objective_2",
				"missions_psyker_2_2",
				"psyker_2_medium_1",
				"psyker_2_medium_2",
			},
			{
				"group_class_psyker_2_2_rework",
				"rank_psyker_2_6",
				"missions_psyker_2_objective_3",
				"missions_psyker_2_3",
				"psyker_2_hard_1",
				"psyker_2_hard_2",
			},
		})
	end

	do
		local category_name = "ogryn_2"
		local category_progression = "ogryn_progression"
		local category_abilites = "ogryn_abilites"
		local base_achievement_icons = {
			class_group = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_12",
			class_group_legacy = "content/ui/textures/icons/achievements/achievement_icon_0096",
			group_rank_and_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_10",
			group_rank_and_difficulty_b = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_11",
			mission_easy_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_02",
			mission_medium_difficulty = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_09",
			missions = "content/ui/textures/icons/achievements/achievement_icon_0002",
			missions_objective = "content/ui/textures/icons/achievements/achievement_icon_0003",
			rank = "content/ui/textures/icons/achievements/achievement_icon_0001",
		}
		local legacy_group_class_targets = {
			{
				"ogryn_2_killed_corruptor_with_grenade_impact",
				"ogryn_2_bull_rushed_charging_ogryn",
			},
			{
				"group_class_ogryn_2_1",
				"ogryn_2_bull_rushed_100_enemies",
				"ogryn_2_win_with_coherency_all_alive_units",
			},
			{
				"group_class_ogryn_2_2",
				"ogryn_2_bull_rushed_70_within_25_seconds",
				"ogryn_2_bull_rushed_4_ogryns",
			},
		}

		_generate_base_archetype_penances("ogryn", category_name, category_progression, category_abilites, base_achievement_icons, legacy_group_class_targets)

		AchievementDefinitions.ogryn_2_easy_1 = {
			description = "loc_achievement_ogryn_2_easy_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_03",
			stat_name = "ogryn_2_number_of_revived_or_assisted_allies",
			target = 40,
			title = "loc_achievement_ogryn_2_easy_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.ogryn_2_easy_2 = {
			description = "loc_achievement_ogryn_2_easy_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_04",
			stat_name = "ogryn_2_number_of_knocked_down_enemies",
			target = 5000,
			title = "loc_achievement_ogryn_2_easy_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.ogryn_2_medium_1 = {
			description = "loc_achievement_ogryn_2_medium_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_05",
			stat_name = "ogryn_2_bullrushed_group_of_ranged_enemies",
			target = 25,
			title = "loc_achievement_ogryn_2_medium_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				num_enemies = 3,
			},
		}
		AchievementDefinitions.ogryn_2_medium_2 = {
			description = "loc_achievement_ogryn_2_medium_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_06",
			stat_name = "ogryn_2_killed_multiple_enemies_with_sweep",
			target = 250,
			title = "loc_achievement_ogryn_2_medium_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				amount = 2,
			},
		}
		AchievementDefinitions.ogryn_2_hard_1 = {
			description = "loc_achievement_ogryn_2_hard_1_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_07",
			stat_name = "ogryn_2_number_of_missions_with_no_deaths_and_all_revives_within_x_seconds",
			target = 3,
			title = "loc_achievement_ogryn_2_hard_1_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				time = 10,
			},
		}
		AchievementDefinitions.ogryn_2_hard_2 = {
			description = "loc_achievement_ogryn_2_hard_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_08",
			stat_name = "ogryn_2_grenade_box_kills_without_missing",
			target = 5,
			title = "loc_achievement_ogryn_2_hard_2_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 4,
			},
		}
		AchievementDefinitions.ogryn_taunt_shout_hit = {
			description = "loc_achievement_ogryn_taunt_shout_hit_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_18",
			stat_name = "ogryn_taunt_shout_hit",
			target = 1000,
			title = "loc_achievement_ogryn_taunt_shout_hit_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.ogryn_grenade_rock_elites_or_specialists = {
			description = "loc_achievement_ogryn_grenade_rock_elites_or_specialists_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_13",
			stat_name = "ogryn_grenade_rock_elites_or_specialists",
			target = 75,
			title = "loc_achievement_ogryn_grenade_rock_elites_or_specialists_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.ogryn_grenade_frag_group_of_enemies = {
			description = "loc_achievement_ogryn_grenade_frag_group_of_enemies_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_14",
			stat_name = "ogryn_grenade_frag_group_of_enemies_killed",
			target = 25,
			title = "loc_achievement_ogryn_grenade_frag_group_of_enemies_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 25,
			},
		}
		AchievementDefinitions.ogryn_kills_during_max_stacks_heavy_hitter = {
			description = "loc_achievement_ogryn_kills_during_max_stacks_heavy_hitter_new_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_20",
			stat_name = "ogryn_kills_during_max_stacks_heavy_hitter",
			target = 5000,
			title = "loc_achievement_ogryn_kills_during_max_stacks_heavy_hitter_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.ogryn_kills_during_barrage_threshold = {
			description = "loc_achievement_ogryn_kills_during_barrage_threshold_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_19",
			stat_name = "kills_achieved_group_barrage_threshold",
			target = 50,
			title = "loc_achievement_ogryn_kills_during_barrage_threshold_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 25,
			},
		}
		AchievementDefinitions.ogryn_feel_no_pain_kills_at_max = {
			description = "loc_achievement_ogryn_feel_no_pain_kills_at_max_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_21",
			stat_name = "ogryn_feel_no_pain_kills_at_max",
			target = 2500,
			title = "loc_achievement_ogryn_ogryn_feel_no_pain_kills_at_max_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 7,
			},
		}
		AchievementDefinitions.ogryn_leadbelcher_free_shot = {
			description = "loc_achievement_ogryn_leadbelcher_free_shot_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_22",
			stat_name = "ogryn_leadbelcher_free_shot",
			target = 4500,
			title = "loc_achievement_ogryn_leadbelcher_free_shot_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.ogryn_team_heavy_aura_kills = {
			description = "loc_achievement_ogryn_team_heavy_aura_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_15",
			stat_name = "ogryn_team_heavy_aura_kills",
			target = 5000,
			title = "loc_achievement_ogryn_team_heavy_aura_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.ogryn_team_suppressed_aura_kills = {
			description = "loc_achievement_ogryn_team_suppressed_aura_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_17",
			stat_name = "ogryn_team_suppressed_aura_kills",
			target = 7500,
			title = "loc_achievement_ogryn_team_suppressed_aura_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.ogryn_team_toughness_restored_aura = {
			description = "loc_achievement_ogryn_team_toughness_restored_aura_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_16",
			stat_name = "ogryn_team_toughness_restored_aura",
			target = 15000,
			title = "loc_achievement_ogryn_team_toughness_restored_aura_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}

		family({
			description = "loc_achievement_group_class_ogryn_2_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_12",
			type = AchievementTypesLookup.meta,
			category = category_progression,
			flags = {},
		}, {
			id = "group_class_ogryn_2_{index:%d}_rework",
			title = "loc_achievement_group_class_ogryn_2_{index:%d}_name",
			target = function (self, config)
				return #config
			end,
			achievements = function (self, config)
				return table.set(config)
			end,
		}, {
			{
				"rank_ogryn_2_4",
				"missions_ogryn_2_objective_1",
				"missions_ogryn_2_1",
				"ogryn_2_easy_1",
				"ogryn_2_easy_2",
			},
			{
				"group_class_ogryn_2_1_rework",
				"rank_ogryn_2_5",
				"missions_ogryn_2_objective_2",
				"missions_ogryn_2_2",
				"ogryn_2_medium_1",
				"ogryn_2_medium_2",
			},
			{
				"group_class_ogryn_2_2_rework",
				"rank_ogryn_2_6",
				"missions_ogryn_2_objective_3",
				"missions_ogryn_2_3",
				"ogryn_2_hard_1",
				"ogryn_2_hard_2",
			},
		})
	end

	do
		local category_name = "adamant"
		local category_progression = "adamant_progression"
		local category_abilites = "adamant_abilites"
		local base_achievement_icons = {
			class_group = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0009",
			class_group_legacy = "content/ui/textures/icons/achievements/achievement_icon_0096",
			group_rank_and_difficulty = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0007",
			group_rank_and_difficulty_b = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0008",
			mission_easy_difficulty = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0005",
			mission_medium_difficulty = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0006",
			missions = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0003",
			missions_objective = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0004",
			rank = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0002",
		}
		local legacy_group_class_targets = {
			{
				"adamant_pet_companion",
				"adamant_saved_by_companion_from_disabling_hound",
			},
			{
				"group_class_adamant_2_1",
				"adamant_companion_pounced_special_enemies",
				"adamant_companion_knocked_away_special_enemies",
			},
			{
				"group_class_adamant_2_2",
				"adamant_killed_enemies_pounced_by_companion",
				"adamant_enemies_affected_by_buff_drone",
			},
		}
		local rework_group_class_targets = {
			{
				"rank_adamant_2_4",
				"missions_adamant_2_objective_1",
				"missions_adamant_2_1",
				"adamant_team_companion_in_coherency_kills",
				"adamant_blocked_attack_from_unique_enemies",
			},
			{
				"group_class_adamant_2_1_rework",
				"rank_adamant_2_5",
				"missions_adamant_2_objective_2",
				"missions_adamant_2_2",
				"adamant_companion_pounced_special_enemies",
				"adamant_killed_electrocuted_enemies",
			},
			{
				"group_class_adamant_2_2_rework",
				"rank_adamant_2_6",
				"missions_adamant_2_objective_3",
				"missions_adamant_2_3",
				"adamant_cluster_of_enemies_killed_with_grenade",
				"adamant_monsters_staggered_by_whistle_explosion",
			},
		}

		_generate_base_archetype_penances("adamant", category_name, category_progression, category_abilites, base_achievement_icons, legacy_group_class_targets, rework_group_class_targets)

		AchievementDefinitions.adamant_team_staggered_enemies_aura_kills = {
			description = "loc_achievement_adamant_team_staggered_enemies_aura_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0010",
			stat_name = "adamant_team_staggered_enemies_aura_kills",
			target = 5000,
			title = "loc_achievement_adamant_team_staggered_enemies_aura_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.adamant_team_wield_speed_aura_kills = {
			description = "loc_achievement_adamant_team_wield_speed_aura_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0011",
			stat_name = "adamant_team_wield_speed_aura_kills",
			target = 7500,
			title = "loc_achievement_adamant_team_wield_speed_aura_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.adamant_team_companion_in_coherency_kills = {
			description = "loc_achievement_adamant_team_companion_in_coherency_kills_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0012",
			stat_name = "adamant_team_companion_in_coherency_kills",
			target = 2500,
			title = "loc_achievement_adamant_team_companion_in_coherency_kills_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.adamant_time_enemies_electrocuted_by_shockmine = {
			description = "loc_achievement_adamant_time_enemies_electrocuted_by_shockmine_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0013",
			stat_name = "adamant_time_enemies_electrocuted_by_shockmine",
			target = 5000,
			title = "loc_achievement_adamant_time_enemies_electrocuted_by_shockmine_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.adamant_enemies_affected_by_buff_drone = {
			description = "loc_achievement_adamant_enemies_affected_by_buff_drone_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0014",
			stat_name = "adamant_enemies_affected_by_buff_drone",
			target = 2500,
			title = "loc_achievement_adamant_enemies_affected_by_buff_drone_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.adamant_time_allies_buffed_by_buff_drone = {
			description = "loc_achievement_adamant_time_allies_buffed_by_buff_drone_description",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0015",
			stat_name = "adamant_time_allies_buffed_by_buff_drone",
			target = 10000,
			title = "loc_achievement_adamant_time_allies_buffed_by_buff_drone_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.adamant_enemies_killed_during_stance = {
			description = "loc_achievement_adamant_kill_during_stance_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0016",
			stat_name = "adamant_enemies_killed_during_stance",
			target = 250,
			title = "loc_achievement_adamant_kill_during_stance",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 250,
				talent_name = Localize("loc_talent_adamant_stance_ability_name"),
			},
		}
		AchievementDefinitions.adamant_enemies_staggered_during_charge = {
			description = "loc_achievement_adamant_stagger_elites_with_bash_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0017",
			stat_name = "adamant_enemies_staggered_during_charge",
			target = 500,
			title = "loc_achievement_adamant_stagger_elites_with_bash",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 500,
				talent_name = Localize("loc_talent_adamant_charge_ability_name"),
			},
		}
		AchievementDefinitions.adamant_monsters_staggered_by_whistle_explosion = {
			description = "loc_achievement_adamant_stagger_monster_detonation_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0018",
			stat_name = "adamant_monsters_staggered_by_whistle_explosion",
			target = 50,
			title = "loc_achievement_adamant_stagger_monster_detonation",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 50,
				talent_name = Localize("loc_talent_ability_detonate"),
			},
		}
		AchievementDefinitions.adamant_cluster_of_enemies_killed_with_grenade = {
			description = "loc_achievement_adamant_kill_cluster_with_grenade_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0019",
			stat_name = "adamant_cluster_of_enemies_killed_with_grenade",
			target = 50,
			title = "loc_achievement_adamant_kill_cluster_with_grenade",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 50,
				cluster = 3,
				talent_name = Localize("loc_talent_ability_adamant_grenade_improved"),
			},
		}
		AchievementDefinitions.adamant_companion_pounced_special_enemies = {
			description = "loc_achievement_adamant_hunt_snipers_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0020",
			stat_name = "adamant_companion_pounced_special_enemies",
			target = 50,
			title = "loc_achievement_adamant_hunt_snipers",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				amount = 50,
			},
		}
		AchievementDefinitions.adamant_companion_knocked_away_special_enemies = {
			description = "loc_achievement_adamant_knock_chargers_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0021",
			stat_name = "adamant_companion_knocked_away_special_enemies",
			target = 50,
			title = "loc_achievement_adamant_knock_chargers",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				amount = 50,
			},
		}
		AchievementDefinitions.adamant_killed_enemies_pounced_by_companion = {
			description = "loc_achievement_adamant_kill_pounced_enemies_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0022",
			stat_name = "adamant_killed_enemies_pounced_by_companion",
			target = 750,
			title = "loc_achievement_adamant_kill_pounced_enemies",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				amount = 750,
			},
		}
		AchievementDefinitions.adamant_killed_electrocuted_enemies = {
			description = "loc_achievement_adamant_kill_electrocuted_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0023",
			stat_name = "adamant_killed_electrocuted_enemies",
			target = 500,
			title = "loc_achievement_adamant_kill_electrocuted",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				amount = 500,
			},
		}
		AchievementDefinitions.adamant_saved_by_companion_from_disabling_hound = {
			description = "loc_achievement_adamant_saved_from_dog_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0024",
			title = "loc_achievement_adamant_saved_from_dog",
			type = AchievementTypesLookup.direct_unlock,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.adamant_pet_companion = {
			description = "loc_achievement_adamant_pet_dog_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0025",
			title = "loc_achievement_adamant_pet_dog",
			type = AchievementTypesLookup.direct_unlock,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.adamant_blocked_attack_from_unique_enemies = {
			description = "loc_achievement_adamant_block_enemies_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0026",
			stat_name = "adamant_blocked_attack_from_unique_enemies",
			target = 250,
			title = "loc_achievement_adamant_block_enemies",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {},
			loc_variables = {
				amount = 250,
			},
		}
		AchievementDefinitions.adamant_killed_enemies_marked_by_execution_order = {
			description = "loc_achievement_adamant_kill_marked_enemies_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0027",
			stat_name = "adamant_killed_enemies_marked_by_execution_order",
			target = 3500,
			title = "loc_achievement_adamant_kill_marked_enemies",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 3500,
				talent_name = Localize("loc_talent_adamant_exterminator"),
			},
		}
		AchievementDefinitions.adamant_melee_kills_with_terminus_warrant = {
			description = "loc_achievement_adamant_kill_with_melee_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0028",
			stat_name = "adamant_melee_kills_with_terminus_warrant",
			target = 3500,
			title = "loc_achievement_adamant_kill_with_melee",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 3500,
				talent_name = Localize("loc_talent_adamant_bullet_rain"),
			},
		}
		AchievementDefinitions.adamant_ranged_kills_with_terminus_warrant = {
			description = "loc_achievement_adamant_kill_with_ranged_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0029",
			stat_name = "adamant_ranged_kills_with_terminus_warrant",
			target = 3500,
			title = "loc_achievement_adamant_kill_with_ranged",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				amount = 3500,
				talent_name = Localize("loc_talent_adamant_bullet_rain"),
			},
		}
		AchievementDefinitions.adamant_time_at_max_forceful_stacks = {
			description = "loc_achievement_adamant_time_in_forceful_desc",
			icon = "content/ui/textures/icons/achievements/class_achievements/adamant/achievement_icon_adamant_0030",
			stat_name = "adamant_time_at_max_forceful_stacks",
			target = 3500,
			title = "loc_achievement_adamant_time_in_forceful",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
			loc_variables = {
				time = 3500,
				talent_name = Localize("loc_talent_adamant_forceful"),
			},
		}
	end

	do
		local category_name = "veteran_2"
		local category_progression = "veteran_progression"
		local category_abilites = "veteran_abilites"

		AchievementDefinitions.veteran_2_weakspot_hits_during_volley_fire_alternate_fire = {
			description = "loc_achievement_veteran_2_weakspot_hits_during_volley_fire_alternate_fire_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0015",
			stat_name = "max_weakspot_hit_during_volley_fire_alternate_fire",
			target = 4,
			title = "loc_achievement_veteran_2_weakspot_hits_during_volley_fire_alternate_fire_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				"hide_from_carousel",
			},
		}
		AchievementDefinitions.veteran_2_unbounced_grenade_kills = {
			description = "loc_achievement_veteran_2_unbounced_grenade_kills_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0014",
			title = "loc_achievement_veteran_2_unbounced_grenade_kills_name",
			type = AchievementTypesLookup.direct_unlock,
			category = category_abilites,
			flags = {},
			loc_variables = {
				target = 5,
			},
		}
		AchievementDefinitions.veteran_2_kills_with_last_round_in_mag = {
			description = "loc_achievement_veteran_2_kills_with_last_round_in_mag_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0017",
			stat_name = "max_veteran_2_kills_with_last_round_in_mag",
			target = 8,
			title = "loc_achievement_veteran_2_kills_with_last_round_in_mag_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {
				"hide_from_carousel",
			},
		}
		AchievementDefinitions.veteran_2_no_melee_damage_taken = {
			description = "loc_achievement_veteran_2_no_melee_damage_taken_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0016",
			stat_name = "veteran_min_melee_damage_taken",
			target = 1,
			title = "loc_achievement_veteran_2_no_melee_damage_taken_name",
			type = AchievementTypesLookup.decreasing_stat,
			category = category_progression,
			flags = {},
		}
		AchievementDefinitions.veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire = {
			description = "loc_achievement_veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0018",
			stat_name = "max_elite_weakspot_kill_during_volley_fire_alternate_fire",
			target = 5,
			title = "loc_achievement_veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				"hide_from_carousel",
			},
		}
		AchievementDefinitions.veteran_2_no_missed_shots_empty_ammo = {
			description = "loc_achievement_veteran_2_no_missed_shots_empty_ammo_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0019",
			stat_name = "veteran_accuracy_at_end_of_mission_with_no_ammo_left",
			target = 90,
			title = "loc_achievement_veteran_2_no_missed_shots_empty_ammo_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {
				AchievementFlags.hide_progress,
			},
			loc_variables = {
				accuracy = 90,
			},
		}
	end

	do
		local category_name = "zealot_2"
		local category_progression = "zealot_progression"
		local category_abilites = "zealot_abilites"

		AchievementDefinitions.zealot_2_stagger_sniper_with_grenade_distance = {
			description = "loc_achievement_zealot_2_stagger_sniper_with_grenade_distance_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0035",
			stat_name = "max_zealot_2_stagger_sniper_with_grenade_distance",
			target = 40,
			title = "loc_achievement_zealot_2_stagger_sniper_with_grenade_distance_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				"hide_from_carousel",
			},
		}
		AchievementDefinitions.zelot_2_kill_mutant_charger_with_melee_while_dashing = {
			description = "loc_achievement_zelot_2_kill_mutant_charger_with_melee_while_dashing_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0039",
			stat_name = "zelot_2_kill_mutant_charger_with_melee_while_dashing",
			target = 1,
			title = "loc_achievement_zelot_2_kill_mutant_charger_with_melee_while_dashing_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				AchievementFlags.hide_progress,
			},
		}
		AchievementDefinitions.zealot_2_kills_of_shocked_enemies_last_15 = {
			description = "loc_achievement_zealot_2_kills_of_shocked_enemies_last_15_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0037",
			stat_name = "max_zealot_2_kills_of_shocked_enemies_last_15",
			target = 40,
			title = "loc_achievement_zealot_2_kills_of_shocked_enemies_last_15_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				"hide_from_carousel",
			},
			loc_variables = {
				time_window = 10,
			},
		}
		AchievementDefinitions.zealot_2_not_use_ranged_attacks = {
			description = "loc_achievement_zealot_2_not_use_ranged_attacks_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0038",
			stat_name = "zealot_2_not_use_ranged_attacks",
			target = 1,
			title = "loc_achievement_zealot_2_not_use_ranged_attacks_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {
				AchievementFlags.hide_progress,
			},
		}
		AchievementDefinitions.zealot_2_healed_up_after_resisting_death = {
			description = "loc_achievement_zealot_2_healed_up_after_resisting_death_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0036",
			stat_name = "max_zealot_2_health_healed_with_leech_during_resist_death",
			target = 25,
			title = "loc_achievement_zealot_2_healed_up_after_resisting_death_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {},
		}
		AchievementDefinitions.zealot_2_health_on_last_segment_enough_during_mission = {
			description = "loc_achievement_zealot_2_health_on_last_segment_enough_during_mission_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0034",
			stat_name = "zealot_2_fastest_mission_with_low_health",
			target = 1200,
			title = "loc_achievement_zealot_2_health_on_last_segment_enough_during_mission_name",
			type = AchievementTypesLookup.decreasing_stat,
			category = category_progression,
			flags = {
				AchievementFlags.private_only,
			},
			loc_variables = {
				health = 75,
				time_window = 20,
			},
		}
	end

	do
		local category_name = "psyker_2"
		local category_progression = "psyker_progression"
		local category_abilites = "psyker_abilites"

		AchievementDefinitions.psyker_2_smite_hound_mid_leap = {
			description = "loc_achievement_psyker_2_smite_hound_mid_leap_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0024",
			stat_name = "smite_hound_mid_leap",
			target = 1,
			title = "loc_achievement_psyker_2_smite_hound_mid_leap_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				AchievementFlags.hide_progress,
			},
		}
		AchievementDefinitions.psyker_2_edge_kills_last_2_sec = {
			description = "loc_achievement_psyker_2_edge_kills_last_2_sec_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0028",
			stat_name = "max_psyker_2_edge_kills_last_2_sec",
			target = 7,
			title = "loc_achievement_psyker_2_edge_kills_last_2_sec_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_progression,
			flags = {
				"hide_from_carousel",
			},
			loc_variables = {
				time_window = 2,
			},
		}
		AchievementDefinitions.psyker_2_stay_at_max_souls_for_duration = {
			description = "loc_achievement_psyker_2_stay_at_max_souls_for_duration_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0027",
			stat_name = "max_psyker_2_time_at_max_souls",
			target = 120,
			title = "loc_achievement_psyker_2_stay_at_max_souls_for_duration_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				"hide_from_carousel",
			},
		}
		AchievementDefinitions.psyker_2_perils_of_the_warp_elite_kills = {
			description = "loc_achievement_psyker_2_perils_of_the_warp_elite_kills_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0025",
			title = "loc_achievement_psyker_2_perils_of_the_warp_elite_kills_name",
			type = AchievementTypesLookup.direct_unlock,
			category = category_abilites,
			flags = {},
			loc_variables = {
				target = 1,
			},
		}
		AchievementDefinitions.psyker_2_elite_or_special_kills_with_smite_last_10_sec = {
			description = "loc_achievement_psyker_2_elite_or_special_kills_with_smite_last_10_sec_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0027",
			stat_name = "max_elite_or_special_kills_with_smite_last_12_sec",
			target = 4,
			title = "loc_achievement_psyker_2_elite_or_special_kills_with_smite_last_10_sec_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				"hide_from_carousel",
			},
			loc_variables = {
				time_window = 12,
			},
		}
		AchievementDefinitions.psyker_2_kill_boss_solo_with_smite = {
			description = "loc_achievement_psyker_2_kill_boss_solo_with_smite_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0029",
			stat_name = "max_smite_damage_done_to_boss",
			target = 50,
			title = "loc_achievement_psyker_2_kill_boss_solo_with_smite_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_abilites,
			flags = {
				AchievementFlags.hide_progress,
				AchievementFlags.private_only,
			},
		}
	end

	local category_name = "ogryn_2"
	local category_progression = "ogryn_progression"
	local category_abilites = "ogryn_abilites"

	AchievementDefinitions.ogryn_2_bull_rushed_charging_ogryn = {
		description = "loc_achievement_ogryn_2_bull_rushed_charging_ogryn_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0004",
		title = "loc_achievement_ogryn_2_bull_rushed_charging_ogryn_name",
		type = AchievementTypesLookup.direct_unlock,
		category = category_abilites,
		flags = {},
	}
	AchievementDefinitions.ogryn_2_killed_corruptor_with_grenade_impact = {
		description = "loc_achievement_ogryn_2_killed_corruptor_with_grenade_impact_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0008",
		stat_name = "ogryn_2_killed_corruptor_with_grenade_impact",
		target = 1,
		title = "loc_achievement_ogryn_2_killed_corruptor_with_grenade_impact_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_abilites,
		flags = {
			AchievementFlags.hide_progress,
		},
	}
	AchievementDefinitions.ogryn_2_win_with_coherency_all_alive_units = {
		description = "loc_achievement_ogryn_2_win_with_coherency_all_alive_units_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0009",
		stat_name = "ogryn_2_win_with_coherency_all_alive_units",
		target = 90,
		title = "loc_achievement_ogryn_2_win_with_coherency_all_alive_units_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_progression,
		flags = {
			AchievementFlags.hide_progress,
		},
		loc_variables = {
			time = 90,
		},
	}
	AchievementDefinitions.ogryn_2_bull_rushed_100_enemies = {
		description = "loc_achievement_ogryn_2_bull_rushed_100_enemies_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0006",
		stat_name = "max_ogryn_2_lunge_number_of_enemies_hit",
		target = 60,
		title = "loc_achievement_ogryn_2_bull_rushed_100_enemies_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_abilites,
		flags = {
			"hide_from_carousel",
		},
	}
	AchievementDefinitions.ogryn_2_bull_rushed_70_within_25_seconds = {
		description = "loc_achievement_ogryn_2_bull_rushed_70_within_25_seconds_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0007",
		stat_name = "max_ogryn_2_lunge_distance_last_x_seconds",
		target = 40,
		title = "loc_achievement_ogryn_2_bull_rushed_70_within_25_seconds_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_abilites,
		flags = {
			"hide_from_carousel",
		},
		loc_variables = {
			time_window = 20,
		},
	}
	AchievementDefinitions.ogryn_2_bull_rushed_4_ogryns = {
		description = "loc_achievement_ogryn_2_bull_rushed_4_ogryns_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0005",
		stat_name = "max_ogryns_bullrushed",
		target = 4,
		title = "loc_achievement_ogryn_2_bull_rushed_4_ogryns_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_abilites,
		flags = {
			"hide_from_carousel",
		},
	}
end

do
	local category_name = "mastery"
	local weapons = AchievementWeaponGroups.weapons

	for _, weapon in ipairs(weapons) do
		local achievement_name = "mastery_complete_" .. weapon.pattern
		local pattern_name_string = weapon.pattern_name_string or "loc_weapon_family_" .. weapon.pattern .. "_m1"
		local localized_pattern_name = Localize(pattern_name_string)

		AchievementDefinitions[achievement_name] = {
			description = "loc_achievement_max_mastery_description",
			title = "loc_achievement_max_mastery_name",
			type = AchievementTypesLookup.direct_unlock,
			stat_name = "mastery_track_reached_20_" .. weapon.pattern,
			loc_title_variables = {
				weapon_name = localized_pattern_name,
			},
			loc_variables = {
				rank = 20,
				weapon_name = localized_pattern_name,
			},
			icon = "content/ui/textures/icons/achievements/weapon_achievements/" .. weapon.pattern .. "_mastery",
			category = category_name,
			flags = {},
		}
	end
end

do
	local category_name = "weapons"
	local mastery_level_tiers = {
		40,
		80,
		120,
		160,
		200,
	}

	for i = 1, #mastery_level_tiers do
		local mastery_track_levels_name = "mastery_complete_total_mastery_levels_" .. i

		AchievementDefinitions[mastery_track_levels_name] = {
			description = "loc_achievement_total_mastery_description",
			icon = "content/ui/textures/icons/achievements/weapon_achievements/weapon_achievements_icon_0003",
			stat_name = "mastery_track_levels",
			title = "loc_achievement_total_mastery_name",
			type = AchievementTypesLookup.increasing_stat,
			target = mastery_level_tiers[i],
			loc_variables = {
				level = mastery_level_tiers[i],
			},
			loc_title_variables = {
				rank = i,
			},
			category = category_name,
			flags = {},
		}
	end

	local unlock_blessings = {
		20,
		30,
		40,
		50,
	}

	for i = 1, #unlock_blessings do
		local mastery_track_levels_name = "blessings_unlocked_" .. i

		AchievementDefinitions[mastery_track_levels_name] = {
			description = "loc_achievement_total_blessings_unlocked_description",
			icon = "content/ui/textures/icons/achievements/weapon_achievements/weapon_achievements_icon_0001",
			stat_name = "crafting_unique_traits_seen",
			title = "loc_achievement_total_blessings_unlocked_name",
			type = AchievementTypesLookup.increasing_stat,
			target = unlock_blessings[i],
			loc_variables = {
				amount = unlock_blessings[i],
			},
			loc_title_variables = {
				rank = i,
			},
			category = category_name,
			flags = {},
		}
	end

	local expertise_tiers_variable = {
		300,
		400,
		500,
	}
	local expertise_tiers = {
		30,
		40,
		50,
	}

	for i = 1, #expertise_tiers do
		local expertise_tiers_name = "expertise_tiers_reached_" .. i

		AchievementDefinitions[expertise_tiers_name] = {
			description = "loc_achievement_expertise_level_description",
			icon = "content/ui/textures/icons/achievements/weapon_achievements/weapon_achievements_icon_0005",
			title = "loc_achievement_expertise_level_name",
			type = AchievementTypesLookup.direct_unlock,
			stat_name = "expertise_reached_" .. expertise_tiers[i],
			loc_variables = {
				level = expertise_tiers_variable[i],
			},
			loc_title_variables = {
				rank = i,
			},
			category = category_name,
			flags = {},
		}
	end

	AchievementDefinitions.primary_weapon_max_expertise = {
		description = "loc_achievement_primary_weapon_max_expertise_description",
		icon = "content/ui/textures/icons/achievements/weapon_achievements/weapon_achievements_icon_0004",
		stat_name = "expertise_reached_50_primary",
		title = "loc_achievement_primary_weapon_max_expertise_name",
		type = AchievementTypesLookup.direct_unlock,
		loc_variables = {
			level = 500,
		},
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.secondary_weapon_max_expertise = {
		description = "loc_achievement_secondary_weapon_max_expertise_description",
		icon = "content/ui/textures/icons/achievements/weapon_achievements/weapon_achievements_icon_0002",
		stat_name = "expertise_reached_50_secondary",
		title = "loc_achievement_secondary_weapon_max_expertise_name",
		type = AchievementTypesLookup.direct_unlock,
		loc_variables = {
			level = 500,
		},
		category = category_name,
		flags = {},
	}
end

do
	local category_name = "heretics"
	local kill_all_target = 1
	local kill_all_specials_target = 10
	local kill_all_elites_target = 10

	local function stats_from_breeds(breeds, target)
		local stats = {}

		for i = 1, #breeds do
			local breed_name = breeds[i]
			local stat_name = string.format("total_%s_killed", breed_name)

			stats[stat_name] = {
				increasing = true,
				target = target,
			}
		end

		return stats
	end

	AchievementDefinitions.all_renegade_specials_killed = {
		description = "loc_achievement_all_renegade_specials_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0041",
		title = "loc_achievement_all_renegade_specials_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.renegade_special,
		stats = stats_from_breeds(AchievementBreedGroups.renegade_special, kill_all_specials_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_specials_target,
		},
	}
	AchievementDefinitions.all_renegade_elites_killed = {
		description = "loc_achievement_all_renegade_elites_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0042",
		title = "loc_achievement_all_renegade_elites_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.renegade_elite,
		stats = stats_from_breeds(AchievementBreedGroups.renegade_elite, kill_all_elites_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_elites_target,
		},
	}
	AchievementDefinitions.all_renegades_killed = {
		description = "loc_achievement_all_renegades_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0043",
		title = "loc_achievement_all_renegades_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.renegade,
		stats = stats_from_breeds(AchievementBreedGroups.renegade, kill_all_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_target,
		},
	}

	old_numeric_target_family("kill_renegades_{index:%d}", {
		description = "loc_achievement_kill_renegades_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0044",
		stat_name = "total_renegade_kills",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		500,
		2500,
		5000,
		7500,
		12500,
	})

	AchievementDefinitions.melee_renegade = {
		description = "loc_achievement_melee_renegade_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0045",
		stat_name = "total_renegade_grenadier_melee",
		target = 10,
		title = "loc_achievement_melee_renegade_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.executor_non_headshot = {
		description = "loc_achievement_executor_non_headshot_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0046",
		stat_name = "total_renegade_executors_non_headshot",
		target = 10,
		title = "loc_achievement_executor_non_headshot_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.group_enemies_renegades = {
		description = "loc_achievement_group_enemies_renegades_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
		target = 6,
		title = "loc_achievement_group_enemies_renegades_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"all_renegade_specials_killed",
			"all_renegade_elites_killed",
			"all_renegades_killed",
			"kill_renegades_5",
			"melee_renegade",
			"executor_non_headshot",
		}),
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.all_cultist_specials_killed = {
		description = "loc_achievement_all_cultist_specials_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0048",
		title = "loc_achievement_all_cultist_specials_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.cultist_special,
		stats = stats_from_breeds(AchievementBreedGroups.cultist_special, kill_all_specials_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_specials_target,
		},
	}
	AchievementDefinitions.all_cultist_elites_killed = {
		description = "loc_achievement_all_cultist_elites_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0049",
		title = "loc_achievement_all_cultist_elites_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.cultist_elite,
		stats = stats_from_breeds(AchievementBreedGroups.cultist_elite, kill_all_elites_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_elites_target,
		},
	}
	AchievementDefinitions.all_cultists_killed = {
		description = "loc_achievement_all_cultists_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0050",
		title = "loc_achievement_all_cultists_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.cultist,
		stats = stats_from_breeds(AchievementBreedGroups.cultist, kill_all_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_target,
		},
	}

	old_numeric_target_family("kill_cultists_{index:%d}", {
		description = "loc_achievement_kill_cultists_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0051",
		stat_name = "total_cultist_kills",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		500,
		2500,
		5000,
		7500,
		12500,
	})

	AchievementDefinitions.cultist_berzerker_head = {
		description = "loc_achievement_cultist_berzerker_head_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0052",
		stat_name = "total_cultist_berzerker_head",
		target = 10,
		title = "loc_achievement_cultist_berzerker_head_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.group_enemies_cultists = {
		description = "loc_achievement_group_enemies_cultists_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0107",
		target = 5,
		title = "loc_achievement_group_enemies_cultists_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"all_cultist_specials_killed",
			"all_cultist_elites_killed",
			"all_cultists_killed",
			"kill_cultists_5",
			"cultist_berzerker_head",
		}),
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.all_chaos_specials_killed = {
		description = "loc_achievement_all_chaos_specials_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0048",
		title = "loc_achievement_all_chaos_specials_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.chaos_special,
		stats = stats_from_breeds(AchievementBreedGroups.chaos_special, kill_all_specials_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_specials_target,
		},
	}
	AchievementDefinitions.all_chaos_elites_killed = {
		description = "loc_achievement_all_chaos_elites_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0049",
		title = "loc_achievement_all_chaos_elites_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.chaos_elite,
		stats = stats_from_breeds(AchievementBreedGroups.chaos_elite, kill_all_elites_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_elites_target,
		},
	}
	AchievementDefinitions.all_chaos_killed = {
		description = "loc_achievement_all_chaos_killed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0050",
		title = "loc_achievement_all_chaos_killed_name",
		type = AchievementTypesLookup.multi_stat,
		target = #AchievementBreedGroups.chaos,
		stats = stats_from_breeds(AchievementBreedGroups.chaos, kill_all_target),
		category = category_name,
		flags = {},
		loc_variables = {
			target = kill_all_target,
		},
	}

	old_numeric_target_family("kill_chaos_{index:%d}", {
		description = "loc_achievement_kill_chaos_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0051",
		stat_name = "total_chaos_kills",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		1000,
		5000,
		7500,
		10000,
		15000,
	})

	AchievementDefinitions.ogryn_gunner_melee = {
		description = "loc_achievement_ogryn_gunner_melee_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0109",
		stat_name = "total_ogryn_gunner_melee",
		target = 10,
		title = "loc_achievement_ogryn_gunner_melee_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.banish_daemonhost = {
		description = "loc_achievement_banish_daemonhost_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0110",
		stat_name = "kill_daemonhost",
		target = 1,
		title = "loc_achievement_banish_daemonhost_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.group_enemies_chaos = {
		description = "loc_achievement_group_enemies_chaos_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0108",
		target = 5,
		title = "loc_achievement_group_enemies_chaos_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"all_chaos_specials_killed",
			"all_chaos_elites_killed",
			"all_chaos_killed",
			"kill_chaos_5",
			"ogryn_gunner_melee",
		}),
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.training_grounds_fully_unlocked = {
		description = "loc_achievement_training_grounds_fully_unlocked_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0120",
		target = 6,
		title = "loc_achievement_training_grounds_fully_unlocked_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"all_renegade_specials_killed",
			"all_chaos_specials_killed",
			"all_renegade_elites_killed",
			"all_chaos_elites_killed",
			"all_cultist_specials_killed",
			"all_cultist_elites_killed",
		}),
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.pox_hounds_pushed_midair = {
		description = "loc_achievement_pox_hounds_pushed_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0129",
		stat_name = "poxhound_pushed_mid_air",
		target = 50,
		title = "loc_achievement_pox_hounds_pushed_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.trappers_net_dodged = {
		description = "loc_achievement_trapper_net_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0130",
		stat_name = "trapper_net_dodged",
		target = 50,
		title = "loc_achievement_trapper_net_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.shotgunner_spread_dodged = {
		description = "loc_achievement_shotgunner_spread_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0132",
		stat_name = "shotgunner_spread_dodged",
		target = 50,
		title = "loc_achievement_shotgunner_spread_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.mutant_charge_dodged = {
		description = "loc_achievement_mutant_charge_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0135",
		stat_name = "mutant_charge_dodged",
		target = 50,
		title = "loc_achievement_mutant_charge_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.mauler_attack_dodged = {
		description = "loc_achievement_mauler_attack_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0139",
		stat_name = "mauler_attack_dodged",
		target = 50,
		title = "loc_achievement_mauler_attack_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.crusher_overhead_smash_dodged = {
		description = "loc_achievement_crusher_overhead_smash_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0140",
		stat_name = "crusher_overhead_smash_dodged",
		target = 50,
		title = "loc_achievement_crusher_overhead_smash_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.renegade_sniper_dodged = {
		description = "loc_achievement_sniper_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0138",
		stat_name = "sniper_dodged",
		target = 50,
		title = "loc_achievement_sniper_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.bulwark_backstab_damage_inflicted = {
		description = "loc_achievement_bulwark_backstab_damage_inflicted_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0141",
		stat_name = "bulwark_backstab_damage_inflicted",
		target = 25000,
		title = "loc_achievement_bulwark_backstab_damage_inflicted_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.cultist_gunner_shot_dodged = {
		description = "loc_achievement_cultist_gunner_shot_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0133",
		stat_name = "cultist_gunner_shot_dodged",
		target = 500,
		title = "loc_achievement_cultist_gunner_shot_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.ogryn_gunner_shot_dodged = {
		description = "loc_achievement_ogryn_gunner_shot_dodged_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0142",
		stat_name = "ogryn_gunner_shot_dodged",
		target = 500,
		title = "loc_achievement_ogryn_gunner_shot_dodged_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.team_poxburster_damage_avoided = {
		description = "loc_achievement_team_poxburster_damage_avoided_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0136",
		stat_name = "team_poxburster_damage_avoided",
		target = 50,
		title = "loc_achievement_team_poxburster_damage_avoided_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.grenadier_killed_before_attack_occurred = {
		description = "loc_achievement_grenadier_killed_before_attack_occurred_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0137",
		stat_name = "grenadier_killed_before_attack_occurred",
		target = 50,
		title = "loc_achievement_grenadier_killed_before_attack_occurred_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.flamer_killed_before_attack_occurred = {
		description = "loc_achievement_flamer_killed_before_attack_occurred_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0134",
		stat_name = "flamer_killed_before_attack_occurred",
		target = 50,
		title = "loc_achievement_flamer_killed_before_attack_occurred_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.team_chaos_spawned_killed_no_players_grabbed = {
		description = "loc_achievement_team_chaos_spawned_killed_no_players_grabbed_description",
		stat_name = "team_chaos_spawned_killed_no_players_grabbed",
		target = 1,
		title = "loc_achievement_team_chaos_spawned_killed_no_players_grabbed_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "achievement_icon_0127",
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.team_chaos_beast_of_nurgle_slain_no_corruption = {
		description = "loc_achievement_team_chaos_beast_of_nurgle_slain_no_corruption_description",
		stat_name = "team_chaos_beast_of_nurgle_slain_no_corruption",
		target = 1,
		title = "loc_achievement_team_team_chaos_beast_of_nurgle_slain_no_corruption_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "achievement_icon_0124",
		category = category_name,
		flags = {},
	}
end

do
	local missions = AchievementMissionGroups.missions

	do
		local category_name = "missions_general"
		local excluded_maps = {
			psykhanium = true,
		}
		local excluded_zones = {
			horde = true,
		}
		local excluded_zones_for_destructible = {
			horde = true,
			operations = true,
		}

		do
			local function _add_mission_objective_family(id, icon)
				local pattern = "type_" .. id .. "_mission_{index:%d}"

				old_numeric_target_family(pattern, {
					type = AchievementTypesLookup.increasing_stat,
					description = "loc_achievement_type_" .. id .. "_mission_x_description",
					icon = icon,
					stat_name = "type_" .. id .. "_missions",
					category = category_name,
					flags = {},
				}, {
					10,
					25,
					50,
					75,
					100,
				})
			end

			_add_mission_objective_family("1", "content/ui/textures/icons/achievements/achievement_icon_0061")
			_add_mission_objective_family("2", "content/ui/textures/icons/achievements/achievement_icon_0062")
			_add_mission_objective_family("3", "content/ui/textures/icons/achievements/achievement_icon_0063")
			_add_mission_objective_family("4", "content/ui/textures/icons/achievements/achievement_icon_0064")
			_add_mission_objective_family("5", "content/ui/textures/icons/achievements/achievement_icon_0065")
			_add_mission_objective_family("6", "content/ui/textures/icons/achievements/achievement_icon_0066")
			_add_mission_objective_family("7", "content/ui/textures/icons/achievements/achievement_icon_0067")
		end

		local function _generate_difficulty_localization()
			local difficulty_name

			return function (index, config, definition, key)
				local loc_variables = definition[key]

				loc_variables = loc_variables or {}
				difficulty_name = "loc_achievement_difficulty_" .. string.format("%02d", index)
				loc_variables.difficulty = Localize(difficulty_name)

				return loc_variables
			end
		end

		for _, mission in ipairs(missions) do
			if not excluded_maps[mission.name] then
				family({
					description = "loc_achievement_level_mission_description",
					target = 1,
					title = "loc_achievement_level_mission_name",
					type = AchievementTypesLookup.increasing_stat,
					category = mission.category.default,
					icon = mission.icon.mission_default,
					flags = {},
					loc_title_variables = {
						mission_name = Localize(mission.local_variable),
					},
					loc_variables = {
						mission_name = Localize(mission.local_variable),
					},
				}, {
					id = "level_" .. mission.name .. "_mission_{index:%d}",
					stat_name = "mission_" .. mission.name .. "_difficulty_{index:%d}",
					loc_title_variables = _generate_tier_localization(),
					loc_variables = _generate_difficulty_localization(),
				}, {
					{},
					{},
					{},
					{},
					{},
				})
			end
		end

		local function _generate_auric_difficulty_stats(name)
			local stat_name

			return function (index, config)
				stat_name = string.format("mission_%s_difficulty_%s_auric", name, index + 3)

				return stat_name
			end
		end

		local function _generate_difficulty_auric_localization()
			local difficulty_name

			return function (index, config, definition, key)
				local loc_variables = definition[key]

				loc_variables = loc_variables or {}
				difficulty_name = "loc_achievement_difficulty_0" .. index + 3
				loc_variables.difficulty = Localize(difficulty_name)

				return loc_variables
			end
		end

		for _, mission in ipairs(missions) do
			if not excluded_maps[mission.name] then
				family({
					description = "loc_achievement_level_mission_auric_description",
					target = 1,
					title = "loc_achievement_level_mission_auric_name",
					type = AchievementTypesLookup.increasing_stat,
					category = mission.category.default,
					icon = mission.icon.auric,
					flags = {},
					loc_title_variables = {
						mission_name = Localize(mission.local_variable),
					},
					loc_variables = {
						mission_name = Localize(mission.local_variable),
					},
				}, {
					id = "level_" .. mission.name .. "_mission_{index:%d}_auric",
					stat_name = _generate_auric_difficulty_stats(mission.name),
					loc_title_variables = _generate_tier_localization(),
					loc_variables = _generate_difficulty_auric_localization(),
				}, {
					{},
					{},
				})
			end
		end

		for _, zone in ipairs(AchievementMissionGroups.zones) do
			if not excluded_zones[zone.name] then
				target_family("mission_zone_" .. zone.name .. "_{index:%d}", {
					description = "loc_achievement_zone_mission_x_description",
					title = "loc_achievement_zone_mission_x_name",
					type = AchievementTypesLookup.increasing_stat,
					icon = zone.icon.zone_default,
					stat_name = string.format("zone_%s_missions_completed", zone.name),
					category = zone.category,
					flags = {},
					loc_variables = {
						zone_name = Localize(zone.local_variable),
					},
					loc_title_variables = {
						zone_name = Localize(zone.local_variable),
					},
				}, {
					10,
					25,
					50,
				})
			end

			if not excluded_zones_for_destructible[zone.name] then
				target_family("mission_zone_" .. zone.name .. "_destructible_{index:%d}", {
					description = "loc_achievement_zone_mission_destructibles_description",
					title = "loc_achievement_zone_mission_destructibles_name",
					type = AchievementTypesLookup.increasing_stat,
					icon = zone.icon.destructible,
					stat_name = string.format("zone_%s_destructible", zone.name),
					category = zone.category,
					flags = {},
					loc_variables = {
						zone_name = Localize(zone.local_variable),
					},
					loc_title_variables = {
						zone_name = Localize(zone.local_variable),
					},
				}, {
					10,
					25,
					50,
				})
			end
		end

		tiered_target_family("missions_{index:%d}", {
			description = "loc_achievement_missions_x_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0068",
			stat_name = "missions",
			title = "loc_achievement_missions_x_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_name,
			flags = {},
		}, {
			25,
			50,
			150,
			250,
			500,
			750,
			1000,
		})
		old_numeric_target_family("scan_{index:%d}", {
			description = "loc_achievement_scan_x_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0069",
			stat_name = "total_scans",
			type = AchievementTypesLookup.increasing_stat,
			category = category_name,
			flags = {},
		}, {
			10,
			25,
			50,
			100,
			200,
		})
		old_numeric_target_family("hack_{index:%d}", {
			description = "loc_achievement_hack_x_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0070",
			stat_name = "total_hacks",
			type = AchievementTypesLookup.increasing_stat,
			category = category_name,
			flags = {},
		}, {
			10,
			25,
			50,
			100,
			200,
		})
		tiered_target_family("amount_of_chests_opened_{index:%d}", {
			description = "loc_achievement_amount_of_chests_opened_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0122",
			stat_name = "chest_opened",
			title = "loc_achievement_amount_of_chests_opened_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_name,
			flags = {},
		}, {
			100,
			250,
			500,
			1000,
			2500,
		})

		AchievementDefinitions.hack_perfect = {
			description = "loc_achievement_hack_perfect_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0072",
			stat_name = "perfect_hacks",
			target = 1,
			title = "loc_achievement_hack_perfect_name",
			type = AchievementTypesLookup.increasing_stat,
			category = category_name,
			flags = {},
		}

		old_numeric_target_family("mission_circumstace_{index:%d}", {
			description = "loc_achievement_mission_circumstace_x_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0071",
			stat_name = "mission_circumstance",
			type = AchievementTypesLookup.increasing_stat,
			category = category_name,
			flags = {},
		}, {
			1,
			25,
			50,
			100,
			250,
		})

		do
			local function _generate_mission_completion_per_difficulty_stats(index, config)
				local difficulty = config.difficulty
				local stats = {}

				for i = 1, #adventure_mission_types do
					local stat_name = string.format("max_difficulty_%s_mission", i)

					stats[stat_name] = {
						increasing = true,
						target = difficulty,
					}
				end

				return stats
			end

			family({
				icon = "content/ui/textures/icons/achievements/achievement_icon_0073",
				type = AchievementTypesLookup.multi_stat,
				category = category_name,
				target = #adventure_mission_types,
				flags = {},
			}, {
				description = "loc_achievement_mission_difficulty_objectives_{index:%d}_description",
				id = "mission_difficulty_objectives_{index:%d}",
				title = "loc_achievement_mission_difficulty_objectives_{index:%d}_name",
				stats = _generate_mission_completion_per_difficulty_stats,
			}, {
				{
					difficulty = 1,
				},
				{
					difficulty = 2,
				},
				{
					difficulty = 3,
				},
				{
					difficulty = 4,
				},
				{
					difficulty = 5,
				},
			})
		end

		AchievementDefinitions.group_missions = {
			description = "loc_achievement_group_missions_description",
			icon = "content/ui/textures/icons/achievements/achievement_icon_0078",
			target = 7,
			title = "loc_achievement_group_missions_name",
			type = AchievementTypesLookup.meta,
			achievements = table.set({
				"type_1_mission_2",
				"type_2_mission_2",
				"type_3_mission_2",
				"type_4_mission_2",
				"type_5_mission_2",
				"type_6_mission_2",
				"type_7_mission_2",
			}),
			category = category_name,
			flags = {},
		}

		tiered_target_family("mission_auric_{index:%d}", {
			category = "mission_auric",
			description = "loc_achievement_mission_auric_x_description",
			icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_0012",
			stat_name = "auric_missions",
			title = "loc_achievement_mission_auric_x_name",
			type = AchievementTypesLookup.increasing_stat,
			flags = {},
		}, {
			1,
			20,
			50,
			100,
			250,
		})
		tiered_target_family("mission_auric_maelstrom_{index:%d}", {
			category = "mission_auric",
			description = "loc_achievement_mission_auric_maelstrom_x_description",
			icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_0013",
			stat_name = "mission_auric_maelstrom",
			title = "loc_achievement_mission_auric_maelstrom_x_name",
			type = AchievementTypesLookup.increasing_stat,
			flags = {},
		}, {
			1,
			5,
			30,
		})

		AchievementDefinitions.mission_auric_flawless_maelstrom = {
			category = "mission_auric",
			description = "loc_achievement_mission_auric_flawless_description",
			stat_name = "flawless_auric_maelstrom",
			target = 1,
			title = "loc_achievement_mission_auric_flawless_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0012",
			flags = {},
		}
		AchievementDefinitions.mission_auric_flawless_maelstrom_won = {
			category = "mission_auric",
			description = "loc_achievement_mission_auric_flawless_maelstrom_x_description",
			stat_name = "flawless_auric_maelstrom_won",
			target = 1,
			title = "loc_achievement_mission_auric_flawless_maelstrom_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0014",
			flags = {},
		}
		AchievementDefinitions.flawless_auric_maelstrom_consecutive = {
			category = "mission_auric",
			description = "loc_achievement_mission_consecutive_maelstrom_x_description",
			stat_name = "flawless_auric_maelstrom_consecutive",
			target = 5,
			title = "loc_achievement_mission_consecutive_maelstrom_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0034",
			flags = {},
		}

		tiered_target_family("personal_mission_auric_flawless_{index:%d}", {
			category = "mission_auric",
			description = "loc_achievement_personal_flawless_auric_description",
			stat_name = "personal_flawless_auric",
			title = "loc_achievement_personal_flawless_auric_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0033",
			flags = {},
		}, {
			5,
			10,
		})
		tiered_target_family("mission_maelstrom_{index:%d}", {
			category = "missions_general",
			description = "loc_achievement_mission_maelstrom_x_description",
			stat_name = "mission_maelstrom",
			title = "loc_achievement_mission_maelstrom_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0015",
			flags = {},
		}, {
			10,
			25,
			50,
		})
		tiered_target_family("mission_tox_gas_{index:%d}", {
			category = "missions_general",
			description = "loc_achievement_mission_tox_gas_x_description",
			stat_name = "toxic_gas_circumstance_completed",
			title = "loc_achievement_mission_tox_gas_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0037",
			flags = {},
		}, {
			1,
			10,
			50,
		})
		tiered_target_family("mission_ventilation_{index:%d}", {
			category = "missions_general",
			description = "loc_achievement_mission_ventilation_x_description",
			stat_name = "ventilation_circumstance_completed",
			title = "loc_achievement_mission_ventilation_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0036",
			flags = {},
		}, {
			1,
			10,
			50,
		})
		tiered_target_family("mission_darkness_{index:%d}", {
			category = "missions_general",
			description = "loc_achievement_mission_darkness_x_description",
			stat_name = "darkness_circumstance_completed",
			title = "loc_achievement_mission_darkness_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "mission_achievements/missions_achievement_0035",
			flags = {},
		}, {
			1,
			10,
			50,
		})
		tiered_target_family("mission_havoc_{index:%d}", {
			category = "mission_havoc",
			description = "loc_achievement_havoc_veteran_desc",
			stat_name = "havoc_missions",
			title = "loc_achievement_havoc_veteran_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "havoc_achievements/havoc_missions_havoc_veteran",
			flags = {},
		}, {
			10,
			25,
			50,
			75,
			100,
		})
		tiered_target_family("havoc_win_assisted_{index:%d}", {
			category = "mission_havoc",
			description = "loc_achievement_havoc_clutch_description",
			stat_name = "havoc_win_assisted",
			title = "loc_achievement_havoc_clutch_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "havoc_achievements/havoc_missions_expedited_backup",
			flags = {},
		}, {
			10,
			25,
			50,
			75,
			100,
		})

		local function _generate_havoc_rank_name()
			local havoc_rank_name

			return function (index, config, definition, key)
				local loc_variables = definition[key]

				loc_variables = loc_variables or {}
				havoc_rank_name = "loc_havoc_militarium_rank_" .. string.format("%02d", index)
				loc_variables.rank = Localize(havoc_rank_name)

				return loc_variables
			end
		end

		local function _generate_havoc_rank()
			local havoc_rank_thresholds = {
				5,
				10,
				15,
				20,
				25,
				30,
				35,
				40,
			}
			local havoc_rank

			return function (index, config, definition, key)
				local loc_variables = definition[key]

				loc_variables = loc_variables or {}
				havoc_rank = havoc_rank_thresholds[index]
				loc_variables.rank = tostring(havoc_rank)

				return loc_variables
			end
		end

		family({
			category = "mission_havoc",
			description = "loc_achievement_havoc_tier_description",
			target = 1,
			title = "loc_achievement_havoc_tier_reached",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "havoc_achievements/havoc_missions_adept_of_the_53rd",
			flags = {},
			loc_title_variables = {
				rank = Localize("loc_havoc_militarium_rank_01"),
			},
			loc_variables = {
				rank = Localize(40),
			},
		}, {
			id = "mission_havoc_rank_reached_0{index:%d}",
			stat_name = "havoc_rank_reached_0{index:%d}",
			loc_title_variables = _generate_havoc_rank_name(),
			loc_variables = _generate_havoc_rank(),
		}, {
			{},
			{},
			{},
			{},
			{},
			{},
			{},
			{},
		})
		tiered_target_family("mission_havoc_caches_earned_{index:%d}", {
			category = "mission_havoc",
			description = "loc_achievement_havoc_weekly_cache_description",
			stat_name = "havoc_weekly_rewards_received",
			title = "loc_achievement_havoc_weekly_cache_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "havoc_achievements/havoc_missions_the_militarium_giveth",
			flags = {},
		}, {
			1,
			5,
			10,
			15,
			20,
		})

		AchievementDefinitions.flawless_havoc_won = {
			category = "mission_havoc",
			description = "loc_achievement_havoc_flawless_win_description",
			stat_name = "flawless_havoc_won",
			target = 1,
			title = "loc_havoc_plus_flawless_win_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "havoc_achievements/havoc_missions_the_insane",
			flags = {},
			loc_variables = {
				rank = 35,
			},
		}

		tiered_target_family("horde_complete_{index:%d}_island", {
			category = "mission_survival",
			description = "loc_achievement_horde_complete_islands_description",
			icon = "content/ui/textures/icons/achievements/horde_achievements/horde_island_complete",
			stat_name = "game_mode_survival_islands_completed",
			title = "loc_achievement_horde_complete_islands_name",
			type = AchievementTypesLookup.increasing_stat,
			flags = {},
		}, {
			1,
			10,
			20,
			50,
		})

		AchievementDefinitions.horde_mortis_collect_one = {
			category = "mission_survival",
			description = "loc_achievement_horde_mortis_collect_one_description",
			stat_name = "game_mode_survival_mcguffin_returned",
			target = 1,
			title = "loc_achievement_horde_mortis_collect_one_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "horde_achievements/horde_memory_shard_one",
			flags = {},
		}
		AchievementDefinitions.horde_win_in_less_than_X = {
			category = "mission_survival",
			description = "loc_achievement_horde_win_in_less_than_X_description",
			stat_name = "game_mode_survival_game_end_flawless",
			target = 1,
			title = "loc_achievement_horde_win_in_less_than_X_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = path .. "horde_achievements/horde_archetype_time",
			flags = {},
			loc_variables = {
				target = 25,
			},
		}
		AchievementDefinitions.horde_complete_all_maps = {
			category = "mission_survival",
			description = "loc_achievement_horde_complete_all_maps_description",
			target = 2,
			title = "loc_achievement_horde_complete_all_maps_name",
			type = AchievementTypesLookup.multi_stat,
			icon = path .. "horde_achievements/horde_island_complete_two_maps",
			stats = {
				horde_win_island_void = {
					increasing = true,
					target = 1,
				},
				horde_win_island_rooftops = {
					increasing = true,
					target = 1,
				},
			},
			flags = {},
			loc_variables = {},
		}

		local survival_classes = MissionBuffsAllowed.available_family_builds
		local icon_prefix = "content/ui/textures/icons/achievements/horde_achievements/horde_archetype_"

		for i = 1, #survival_classes do
			local class_name = survival_classes[i]
			local horde_win_all_archetype = "horde_win_" .. class_name .. "_archetype"
			local icon_name = icon_prefix .. class_name
			local title = "loc_achievement_horde_win_" .. class_name .. "_archetype_name"
			local description = "loc_achievement_horde_win_" .. class_name .. "_archetype_description"

			AchievementDefinitions[horde_win_all_archetype] = {
				category = "mission_survival",
				target = 1,
				type = AchievementTypesLookup.increasing_stat,
				stat_name = horde_win_all_archetype,
				title = title,
				description = description,
				loc_variables = {
					class = class_name,
				},
				icon = icon_name,
				flags = {},
			}
		end

		AchievementDefinitions.horde_win_all_archetype = {
			category = "mission_survival",
			description = "loc_achievement_horde_win_all_archetype_description",
			icon = "content/ui/textures/icons/achievements/horde_achievements/horde_archetype_all",
			target = 5,
			title = "loc_achievement_horde_win_all_archetype_name",
			type = AchievementTypesLookup.meta,
			achievements = table.set({
				"horde_win_fire_archetype",
				"horde_win_electric_archetype",
				"horde_win_cowboy_archetype",
				"horde_win_elementalist_archetype",
				"horde_win_unkillable_archetype",
			}),
			flags = {},
		}

		local function generate_vo_stats(name, num_vo, target)
			local stats = {}

			for i = 1, num_vo do
				local stat_name = string.format("backstory_%s_part_%s", name, i)

				stats[stat_name] = {
					increasing = true,
					target = target,
				}
			end

			return stats
		end

		local function generate_vo_stats_sorting(name, num_vo)
			local stats_sorting = {}

			for i = 1, num_vo do
				local stat_name = string.format("backstory_%s_part_%s", name, i)

				stats_sorting[#stats_sorting + 1] = stat_name
			end

			return stats_sorting
		end

		local vo_target = 1
		local morrow_num_vo = 9

		AchievementDefinitions.horde_morrow_story = {
			category = "mission_survival",
			description = "loc_horde_morrow_story_desc",
			icon = "content/ui/textures/icons/achievements/horde_achievements/horde_memo_morrow",
			title = "loc_horde_morrow_story_title",
			type = AchievementTypesLookup.multi_stat,
			target = morrow_num_vo,
			stats = generate_vo_stats("morrow", morrow_num_vo, vo_target),
			stats_sorting = generate_vo_stats_sorting("morrow", morrow_num_vo),
			flags = {},
			loc_variables = {
				target = vo_target,
			},
		}

		local zola_num_vo = 7

		AchievementDefinitions.horde_zola_story = {
			category = "mission_survival",
			description = "loc_horde_zola_story_desc",
			icon = "content/ui/textures/icons/achievements/horde_achievements/horde_memo_zola",
			title = "loc_horde_zola_story_title",
			type = AchievementTypesLookup.multi_stat,
			target = zola_num_vo,
			stats = generate_vo_stats("zola", zola_num_vo, vo_target),
			stats_sorting = generate_vo_stats_sorting("zola", zola_num_vo),
			flags = {},
			loc_variables = {
				target = vo_target,
			},
		}

		local brahms_num_vo = 10

		AchievementDefinitions.horde_brahms_story = {
			category = "mission_survival",
			description = "loc_horde_brahms_story_desc",
			icon = "content/ui/textures/icons/achievements/horde_achievements/horde_memo_brahms",
			title = "loc_horde_brahms_story_title",
			type = AchievementTypesLookup.multi_stat,
			target = brahms_num_vo,
			stats = generate_vo_stats("brahms", brahms_num_vo, vo_target),
			stats_sorting = generate_vo_stats_sorting("brahms", brahms_num_vo),
			flags = {},
			loc_variables = {
				target = vo_target,
			},
		}
		AchievementDefinitions.horde_mortis_collect_all = {
			category = "mission_survival",
			description = "loc_achievement_horde_mortis_collect_all_description",
			icon = "content/ui/textures/icons/achievements/horde_achievements/horde_memory_shard_collect_all",
			target = 3,
			title = "loc_achievement_horde_mortis_collect_all_name",
			type = AchievementTypesLookup.meta,
			achievements = table.set({
				"horde_morrow_story",
				"horde_zola_story",
				"horde_brahms_story",
			}),
			flags = {},
		}
	end

	AchievementDefinitions.mission_scavenge_samples = {
		category = "exploration_dust",
		description = "loc_achievement_mission_scavenge_samples_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_challenge_0010",
		title = "loc_achievement_mission_scavenge_samples_name",
		type = AchievementTypesLookup.direct_unlock,
		flags = {},
		loc_variables = {
			target = 5,
		},
	}
	AchievementDefinitions.mission_propaganda_fan_kills = {
		category = "exploration_dust",
		description = "loc_achievement_mission_propganda_fan_kills_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_challenge_0008",
		stat_name = "mission_propaganda_fan_kills",
		target = 10,
		title = "loc_achievement_mission_propganda_fan_kills_name",
		type = AchievementTypesLookup.increasing_stat,
		flags = {},
		loc_variables = {
			target = 10,
		},
	}
	AchievementDefinitions.mission_raid_bottles = {
		category = "exploration_entertainment",
		description = "loc_achievement_mission_raid_bottles_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_challenge_0026",
		stat_name = "mission_raid_bottles_destroyed",
		target = 12,
		title = "loc_achievement_mission_raid_bottles_name",
		type = AchievementTypesLookup.increasing_stat,
		flags = {},
	}

	tiered_target_family("grimoire_recovered_{index:%d}", {
		category = "missions_general",
		description = "loc_achievement_mission_grimoire_recovery_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_0031",
		stat_name = "grimoire_recovered_mission_won",
		title = "loc_achievement_mission_grimoire_recovery_name",
		type = AchievementTypesLookup.increasing_stat,
		flags = {},
	}, {
		1,
		10,
		25,
		45,
		75,
	})
	tiered_target_family("scripture_recovered_{index:%d}", {
		category = "missions_general",
		description = "loc_achievement_mission_scripture_recovery_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_0030",
		stat_name = "scripture_recovered_mission_won",
		title = "loc_achievement_mission_scripture_recovery_name",
		type = AchievementTypesLookup.increasing_stat,
		flags = {},
	}, {
		1,
		10,
		30,
		60,
		100,
	})

	do
		local excluded_maps_for_puzzles = {
			core_research = true,
			op_train = true,
			psykhanium = true,
		}

		for _, mission in ipairs(missions) do
			local mission_name = mission.name

			if not excluded_maps_for_puzzles[mission_name] then
				AchievementDefinitions["mission_zone_" .. mission.name .. "_mission_collectible_1"] = {
					description = "loc_achievement_level_collectible_description",
					target = 1,
					title = "loc_achievement_level_collectible_name",
					type = AchievementTypesLookup.increasing_stat,
					category = mission.category.puzzle,
					icon = mission.icon.collectible,
					flags = {
						"hide_progress",
					},
					stat_name = string.format("mission_%s_collectible", mission.name),
					loc_title_variables = {
						mission_name = Localize(mission.local_variable),
					},
					loc_variables = {
						mission_name = Localize(mission.local_variable),
					},
				}
			end
		end

		local excluded_zones = {
			horde = true,
			operations = true,
		}

		for _, zone in ipairs(AchievementMissionGroups.zone_meta) do
			if not excluded_zones[zone.name] then
				family({
					description = "loc_achievement_zone_wide_completion_description",
					type = AchievementTypesLookup.meta,
					icon = zone.icon,
					category = zone.category,
					flags = {},
					loc_title_variables = {
						zone_name = Localize(zone.local_variable),
					},
					loc_variables = {
						zone_name = Localize(zone.local_variable),
					},
				}, {
					title = "loc_achievement_zone_wide_completion_name",
					id = "group_mission_zone_wide_" .. zone.name .. "_completion",
					target = function (self, config)
						return #config
					end,
					achievements = function (self, config)
						return table.set(config)
					end,
				}, {
					zone.achievements,
				})
			end
		end
	end

	local category_name = "exploration_twins_mission"

	AchievementDefinitions.mission_twins_win = {
		description = "loc_achievement_mission_twins_win_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_twins_mission",
		stat_name = "mission_twins",
		target = 1,
		title = "loc_achievement_mission_twins_win_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			AchievementFlags.hide_missing,
		},
	}
	AchievementDefinitions.difficult_mission_twins_win = {
		description = "loc_achievement_difficult_mission_twins_win_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_twins_mission_level5",
		stat_name = "mission_twins",
		target = 5,
		title = "loc_achievement_difficult_mission_twins_win_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			AchievementFlags.hide_missing,
		},
	}
	AchievementDefinitions.difficult_mission_twins_hard_mode_win = {
		description = "loc_achievement_difficult_mission_twins_hard_mode_win_description",
		stat_name = "mission_twins_hard_mode",
		target = 1,
		title = "loc_achievement_difficult_mission_twins_hard_mode_win_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			AchievementFlags.hide_missing,
		},
	}
	AchievementDefinitions.mission_twins_secret = {
		description = "loc_achievement_mission_twins_unlocked_puzzle_description",
		stat_name = "mission_twins_secret_puzzle_trigger",
		target = 1,
		title = "loc_achievement_mission_twins_unlocked_puzzle_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			AchievementFlags.hide_missing,
		},
	}
	AchievementDefinitions.mission_twins_killed_successfully_within_x = {
		description = "loc_achievement_mission_twins_within_limit_name_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_challenge_0023",
		stat_name = "mission_twins_killed_successfully_within_x",
		target = 1,
		title = "loc_achievement_mission_twins_within_limit_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
		loc_variables = {
			target = 5,
		},
	}
	AchievementDefinitions.mission_twins_killed_no_mines_triggered = {
		description = "loc_achievement_mission_twins_killed_no_mines_triggered_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_challenge_0024",
		stat_name = "mission_twins_no_mines_triggered",
		target = 1,
		title = "loc_achievement_mission_twins_killed_no_mines_triggered_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
		loc_variables = {
			amount = 3,
		},
	}
end

do
	local category_name = "account"

	old_numeric_target_family("multi_class_{index:%d}", {
		description = "loc_achievement_multi_class_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0079",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"rank_veteran_2_6",
			"rank_zealot_2_6",
			"rank_psyker_2_6",
			"rank_ogryn_2_6",
			"rank_adamant_2_6",
		}),
		category = category_name,
		flags = {},
	}, {
		2,
		4,
	})

	local function _generate_class_meta_targets()
		local target = {
			5,
			15,
			25,
			35,
			45,
		}

		return function (index, config)
			return target[index]
		end
	end

	for _, class in ipairs(AchievementClassGroups.classes) do
		family({
			description = "loc_achievement_class_meta_description",
			title = "loc_achievement_class_meta_name",
			type = AchievementTypesLookup.meta,
			icon = class.icon,
			category = class.category,
			flags = {},
			loc_title_variables = {
				class_name = Localize(class.local_variable),
			},
			loc_variables = {
				class_name = Localize(class.local_variable),
			},
		}, {
			id = "group_mission_class_" .. class.name .. "_completion_{index:%d}",
			target = _generate_class_meta_targets(),
			achievements = function (self, config)
				return table.set(config)
			end,
		}, {
			class.achievements,
			class.achievements,
			class.achievements,
			class.achievements,
			class.achievements,
		})
	end
end

do
	local category_name = "account"

	AchievementDefinitions.prologue = {
		description = "loc_achievement_prologue_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0080",
		title = "loc_achievement_prologue_name",
		type = AchievementTypesLookup.direct_unlock,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.basic_training = {
		description = "loc_achievement_basic_training_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0081",
		title = "loc_achievement_basic_training_name",
		type = AchievementTypesLookup.direct_unlock,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.unlock_gadgets = {
		description = "loc_achievement_unlock_gadgets_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0077",
		title = "loc_achievement_unlock_gadgets_name",
		type = AchievementTypesLookup.direct_unlock,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.unlock_contracts = {
		description = "loc_achievement_unlock_contracts_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0104",
		title = "loc_achievement_unlock_contracts_name",
		type = AchievementTypesLookup.direct_unlock,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.unlock_crafting = {
		description = "loc_achievement_unlock_crafting_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0105",
		title = "loc_achievement_unlock_crafting_name",
		type = AchievementTypesLookup.direct_unlock,
		category = category_name,
		flags = {},
	}

	old_numeric_target_family("path_of_trust_{index:%d}", {
		description = "loc_achievement_path_of_trust_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0082",
		type = AchievementTypesLookup.direct_unlock,
		category = category_name,
		flags = {},
	}, {
		1,
		2,
		3,
		4,
		5,
		6,
	})
end

do
	local category_name = "teamplay"

	old_numeric_target_family("revive_{index:%d}", {
		description = "loc_achievement_revive_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0083",
		stat_name = "total_player_rescues",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		10,
		50,
		100,
		250,
		500,
	})
	old_numeric_target_family("assists_{index:%d}", {
		description = "loc_achievement_assists_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0084",
		stat_name = "total_player_assists",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		10,
		50,
		100,
		500,
		1000,
	})

	AchievementDefinitions.flawless_team = {
		description = "loc_achievement_flawless_team_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0085",
		stat_name = "team_flawless_missions",
		target = 100,
		title = "loc_achievement_flawless_team_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.coherency_toughness = {
		description = "loc_achievement_coherency_toughness_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0086",
		stat_name = "total_coherency_toughness",
		target = 2000,
		title = "loc_achievement_coherency_toughness_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.revive_all = {
		description = "loc_achievement_revive_all_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0087",
		stat_name = "max_different_players_rescued",
		target = 3,
		title = "loc_achievement_revive_all_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			"hide_from_carousel",
		},
	}

	old_numeric_target_family("deployables_{index:%d}", {
		description = "loc_achievement_deployables_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0076",
		stat_name = "total_deployables_placed",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		25,
		50,
		100,
		250,
		500,
	})

	AchievementDefinitions.group_cooperation = {
		description = "loc_achievement_group_cooperation_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0088",
		target = 5,
		title = "loc_achievement_group_cooperation_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"revive_3",
			"assists_3",
			"flawless_team",
			"coherency_toughness",
			"deployables_3",
		}),
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.total_syringes_used = {
		description = "loc_achievement_total_syringes_used_description",
		stat_name = "total_syringes_used",
		target = 20,
		title = "loc_achievement_total_syringes_used_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "havoc_achievements/havoc_mission_total_syringes",
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.elites_and_specials_killed_using_red_stimm = {
		description = "loc_achievement_elites_and_specials_killed_using_red_stimm_description",
		stat_name = "total_kills_gained_while_using_red_stimm",
		target = 50,
		title = "loc_achievement_elites_and_specials_killed_using_red_stimm_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "havoc_achievements/havoc_mission_total_syringes",
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.corruption_healed_using_green_stimm = {
		description = "loc_achievement_corruption_healed_using_green_stimm_description",
		stat_name = "corruption_healed_with_green_stimm",
		target = 1000,
		title = "loc_achievement_corruption_healed_using_green_stimm_stimm_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "havoc_achievements/havoc_mission_use_green_stim",
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.ability_time_saved_using_yellow_stimm = {
		description = "loc_achievement_ability_time_saved_using_yellow_stimm_description",
		stat_name = "ability_time_saved_by_yellow_stimm",
		target = 1000,
		title = "loc_achievement_ability_time_saved_using_yellow_stimm_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "havoc_achievements/havoc_mission_use_red_stim",
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.horde_kills_during_blue_stimm = {
		description = "loc_achievement_horde_kills_during_blue_stimm_description",
		stat_name = "total_kills_gained_while_using_blue_stimm",
		target = 1000,
		title = "loc_achievement_horde_kills_during_blue_stimm_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "havoc_achievements/havoc_mission_use_yellow_stim",
		category = category_name,
		flags = {},
	}
end

do
	local category_name = "offensive"

	tiered_target_family("enemies_killed_by_barrels_{index:%d}", {
		description = "loc_achievement_enemies_killed_by_barrels_description",
		stat_name = "enemies_killed_with_barrels",
		title = "loc_achievement_enemies_killed_by_barrels_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "achievement_icon_0128",
		category = category_name,
		flags = {},
	}, {
		100,
		250,
		500,
		1000,
		2500,
	})
	tiered_target_family("enemies_killed_by_poxburster_{index:%d}", {
		description = "loc_achievement_enemies_killed_by_poxburster_description",
		stat_name = "enemies_killed_with_poxburster_explosion",
		title = "loc_achievement_enemies_killed_by_poxburster_name",
		type = AchievementTypesLookup.increasing_stat,
		icon = path .. "achievement_icon_0123",
		category = category_name,
		flags = {},
	}, {
		10,
		50,
		100,
	})

	AchievementDefinitions.team_win_without_ally_downed_longer_then_x = {
		description = "loc_achievement_team_win_without_ally_downed_longer_then_x_description",
		icon = "content/ui/textures/icons/achievements/mission_achievements/missions_achievement_0029",
		stat_name = "team_win_without_ally_downed_longer_then_x",
		target = 1,
		title = "loc_achievement_team_win_without_ally_downed_longer_then_x_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
		loc_variables = {
			downed_times = 5,
		},
	}

	for _, breed in pairs(AchievementBreedGroups.special_and_elite_breed_lookup) do
		tiered_target_family("amount_of_" .. breed.name .. "_killed_{index:%d}", {
			description = "loc_achievement_amount_of_x_description",
			title = "loc_achievement_amount_of_x_name",
			type = AchievementTypesLookup.increasing_stat,
			icon = breed.icon,
			stat_name = string.format("x_amount_of_%s_killed", breed.name),
			category = category_name,
			flags = {},
			loc_variables = {
				breed = Localize(breed.local_variable),
			},
			loc_title_variables = {
				breed = Localize(breed.title_local_variable),
			},
		}, {
			breed.targets[1],
			breed.targets[2],
			breed.targets[3],
			breed.targets[4],
			breed.targets[5],
		})
	end

	tiered_target_family("enemies_{index:%d}", {
		description = "loc_achievement_enemies_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0089",
		stat_name = "total_kills",
		title = "loc_achievement_enemies_x_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		1000,
		40000,
		100000,
		250000,
		500000,
		750000,
		1000000,
	})

	AchievementDefinitions.consecutive_headshots = {
		description = "loc_achievement_consecutive_headshots_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0090",
		stat_name = "max_head_shot_in_a_row",
		target = 20,
		title = "loc_achievement_consecutive_headshots_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}

	old_numeric_target_family("boss_fast_{index:%d}", {
		description = "loc_achievement_boss_fast_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0091",
		stat_name = "fastest_boss_kill",
		type = AchievementTypesLookup.decreasing_stat,
		category = category_name,
		flags = {
			"hide_from_carousel",
		},
	}, {
		60,
		20,
		5,
	})
	old_numeric_target_family("fast_enemies_{index:%d}", {
		description = "loc_achievement_fast_enemies_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0092",
		stat_name = "max_kills_last_60_sec",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			"hide_from_carousel",
		},
		loc_variables = {
			time_window = 30,
		},
	}, {
		60,
		90,
		120,
	})

	AchievementDefinitions.enemies_climbing = {
		description = "loc_achievement_enemies_climbing_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0093",
		stat_name = "kill_climbing",
		target = 50,
		title = "loc_achievement_enemies_climbing_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}

	old_numeric_target_family("fast_headshot_{index:%d}", {
		description = "loc_achievement_fast_headshot_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0094",
		stat_name = "max_head_shot_kills_last_10_sec",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			"hide_from_carousel",
		},
		loc_variables = {
			time_window = 10,
		},
	}, {
		3,
		7,
		15,
	})

	AchievementDefinitions.group_offence = {
		description = "loc_achievement_group_offence_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0088",
		target = 6,
		title = "loc_achievement_group_offence_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"enemies_2",
			"consecutive_headshots",
			"boss_fast_2",
			"fast_enemies_2",
			"enemies_climbing",
			"fast_headshot_2",
		}),
		category = category_name,
		flags = {},
	}
end

do
	local category_name = "defensive"

	old_numeric_target_family("fast_blocks_{index:%d}", {
		description = "loc_achievement_fast_blocks_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0096",
		stat_name = "max_damage_blocked_last_20_sec",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			"hide_from_carousel",
		},
		loc_variables = {
			time_window = 10,
		},
	}, {
		400,
		600,
		900,
	})
	old_numeric_target_family("consecutive_dodge_{index:%d}", {
		description = "loc_achievement_consecutive_dodge_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0097",
		stat_name = "max_dodges_in_a_row",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {
			"hide_from_carousel",
		},
	}, {
		7,
		12,
		20,
	})
	old_numeric_target_family("flawless_mission_{index:%d}", {
		description = "loc_achievement_flawless_mission_x_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0098",
		stat_name = "max_flawless_mission_in_a_row",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}, {
		5,
		10,
		15,
	})

	AchievementDefinitions.total_sprint_dodges = {
		description = "loc_achievement_total_sprint_dodges_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0099",
		stat_name = "total_sprint_dodges",
		target = 99,
		title = "loc_achievement_total_sprint_dodges_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.slide_dodge = {
		description = "loc_achievement_slide_dodge_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0100",
		stat_name = "total_slide_dodges",
		target = 1,
		title = "loc_achievement_slide_dodge_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.melee_toughness = {
		description = "loc_achievement_melee_toughness_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0101",
		stat_name = "total_melee_toughness_regen",
		target = 40000,
		title = "loc_achievement_melee_toughness_name",
		type = AchievementTypesLookup.increasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.mission_no_damage = {
		description = "loc_achievement_mission_no_damage_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0102",
		stat_name = "lowest_damage_taken_on_win",
		target = 1,
		title = "loc_achievement_mission_no_damage_name",
		type = AchievementTypesLookup.decreasing_stat,
		category = category_name,
		flags = {},
	}
	AchievementDefinitions.group_defence = {
		description = "loc_achievement_group_defence_description",
		icon = "content/ui/textures/icons/achievements/achievement_icon_0103",
		target = 7,
		title = "loc_achievement_group_defence_name",
		type = AchievementTypesLookup.meta,
		achievements = table.set({
			"fast_blocks_2",
			"consecutive_dodge_2",
			"flawless_mission_1",
			"total_sprint_dodges",
			"slide_dodge",
			"melee_toughness",
			"mission_no_damage",
		}),
		category = category_name,
		flags = {},
	}
end

AchievementDefinitions = _achievement_data

for _, definition in pairs(AchievementDefinitions) do
	definition.flags = table.set(definition.flags)
end

for id, definition in pairs(AchievementDefinitions) do
	local platform_id = XboxLivePlatformAchievements.backend_to_platform[id]

	if platform_id ~= nil then
		definition.xbox = {
			id = platform_id,
			show_progress = not not XboxLivePlatformAchievements.show_progress[platform_id],
		}
	end
end

for id, definition in pairs(AchievementDefinitions) do
	local platform_id = SteamPlatformAchievements.backend_to_platform[id]

	if platform_id ~= nil then
		definition.steam = {
			id = platform_id,
			stat_id = SteamPlatformAchievements.platform_to_stat[platform_id],
		}
	end
end

for id, definition in pairs(AchievementDefinitions) do
	local platform_id = PSNPlatformAchievements.backend_to_platform[id]

	if platform_id ~= nil then
		definition.psn = {
			id = platform_id,
			show_progress = not not PSNPlatformAchievements.show_progress[platform_id],
		}
	end
end

return settings("AchievementDefinitions", AchievementDefinitions)
