local AchievementBreedGroups = require("scripts/settings/achievements/achievement_breed_groups")
local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local MissionTypes = require("scripts/settings/mission/mission_types")
local SteamPlatformAchievements = require("scripts/settings/achievements/steam_platform_achievements")
local XboxLivePlatformAchievements = require("scripts/settings/achievements/xbox_live_platform_achievements")
local AchievementTypesLookup = table.enum(unpack(table.keys(AchievementTypes)))
local _achievement_count = 0
local _achievement_data = {}
local AchievementDefinitions = setmetatable({}, {
	__index = function (_, key)
		return _achievement_data[key]
	end,
	__newindex = function (_, key, value)
		_achievement_data[key] = value
		_achievement_count = _achievement_count + 1
		value.id = key
		value.index = _achievement_count
	end
})

local function string_replacement(pattern, index, config)
	return string.gsub(pattern, "{([%a%d_]*):*([%a%d%.%%]*)}", function (config_key, format)
		local value = config_key == "index" and index or config[config_key]

		return string.format(format or "%s", value)
	end)
end

local function family(base, overrides, configs)
	local last_id = nil

	for index, config in ipairs(configs) do
		local definition = table.clone(base)

		for key, override in pairs(overrides) do
			local override_type = type(override)

			if override_type == "function" then
				definition[key] = override(index, config)
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

local function numeric_target_family(id_pattern, base, targets)
	local configs = {}

	for i = 1, #targets do
		configs[i] = {
			target = targets[i]
		}
	end

	return family(base, {
		id = id_pattern,
		title = "loc_achievement_" .. id_pattern .. "_name",
		target = function (index, config)
			return config.target
		end
	}, configs)
end

local rank_targets = {
	5,
	10,
	15,
	20,
	25,
	30
}
local generic_mission_targets = {
	25,
	50,
	100,
	150,
	250
}

local function generate_mission_difficulties(archetype_name)
	return function (index, config)
		local difficulty = config.difficulty
		local stats = {}

		for _, mission_type in pairs(MissionTypes) do
			local stat_name = string.format("mission_type_%s_max_difficulty_%s", mission_type.id, archetype_name)
			stats[stat_name] = {
				increasing = true,
				target = difficulty
			}
		end

		return stats
	end
end

local category_name = "veteran_2"

numeric_target_family("rank_veteran_2_{index:%d}", {
	description = "loc_achievement_rank_veteran_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0031",
	stat_name = "max_rank_veteran",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, rank_targets)
numeric_target_family("missions_veteran_2_{index:%d}", {
	description = "loc_achievement_missions_veteran_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0032",
	stat_name = "missions_veteran_2",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, generic_mission_targets)
family({
	icon = "content/ui/textures/icons/achievements/achievement_icon_0033",
	type = AchievementTypesLookup.multi_stat,
	category = category_name,
	target = table.size(MissionTypes),
	flags = {}
}, {
	id = "missions_veteran_2_objective_{index:%d}",
	title = "loc_achievement_missions_veteran_2_objective_{index:%d}_name",
	description = "loc_achievement_missions_veteran_2_objective_{index:%d}_description",
	stats = generate_mission_difficulties("veteran")
}, {
	{
		difficulty = 1
	},
	{
		difficulty = 2
	},
	{
		difficulty = 3
	}
})
family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_02",
	target = 1,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_veteran_2_easy_difficulty_{index:%d}",
	title = "loc_missions_veteran_2_easy_difficulty_{index:%d}_name",
	description = "loc_missions_veteran_2_easy_difficulty_{index:%d}_description",
	stat_name = "missions_veteran_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.group_veteran_2_rank_1_difficulty_1 = {
	description = "loc_group_veteran_2_rank_1_difficulty_1_description",
	title = "loc_group_veteran_2_rank_1_difficulty_1_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_veteran_2_1",
		"missions_veteran_2_easy_difficulty_1"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_veteran_2_rank_2_difficulty_2 = {
	description = "loc_group_veteran_2_rank_2_difficulty_2_description",
	title = "loc_group_veteran_2_rank_2_difficulty_2_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_veteran_2_2",
		"missions_veteran_2_easy_difficulty_2"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_easy_1 = {
	description = "loc_achievement_veteran_2_easy_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_03",
	title = "loc_achievement_veteran_2_easy_1_name",
	target = 350,
	stat_name = "veteran_2_weakspot_kills",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_easy_2 = {
	description = "loc_achievement_veteran_2_easy_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_04",
	title = "loc_achievement_veteran_2_easy_2_name",
	target = 5000,
	stat_name = "veteran_2_ammo_given",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_veteran_2_rank_4_difficulty_3 = {
	description = "loc_group_veteran_2_rank_4_difficulty_3_description",
	title = "loc_group_veteran_2_rank_4_difficulty_3_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_veteran_2_4",
		"missions_veteran_2_easy_difficulty_3"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_veteran_2_rank_5_difficulty_4 = {
	description = "loc_group_veteran_2_rank_5_difficulty_4_description",
	title = "loc_group_veteran_2_rank_5_difficulty_4_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_veteran_2_5",
		"missions_veteran_2_easy_difficulty_4"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_medium_1 = {
	description = "loc_achievement_veteran_2_medium_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_05",
	title = "loc_achievement_veteran_2_medium_1_name",
	target = 150,
	stat_name = "veteran_2_kill_volley_fire_target_malice",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_medium_2 = {
	description = "loc_achievement_veteran_2_medium_2_description",
	title = "loc_achievement_veteran_2_medium_2_name",
	target = 100,
	stat_name = "veteran_2_long_range_kills",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_06",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		distance = 30
	}
}
AchievementDefinitions.veteran_2_hard_1 = {
	description = "loc_achievement_veteran_2_hard_1_description",
	title = "loc_achievement_veteran_2_hard_1_name",
	target = 50,
	stat_name = "max_multiple_elite_or_special_kills_during_volley_fire_heresy",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_07",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		num_enemies = 2
	}
}
AchievementDefinitions.veteran_2_hard_2 = {
	description = "loc_achievement_veteran_2_hard_2_description",
	title = "loc_achievement_veteran_2_hard_2_name",
	target = 5,
	stat_name = "veteran_2_extended_volley_fire_duration",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_08",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time = 20
	}
}

family({
	description = "loc_achievement_group_class_veteran_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_12",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_veteran_2_{index:%d}_rework",
	title = "loc_achievement_group_class_veteran_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"rank_veteran_2_4",
		"missions_veteran_2_objective_1",
		"missions_veteran_2_1",
		"veteran_2_easy_1",
		"veteran_2_easy_2"
	},
	{
		"group_class_veteran_2_1_rework",
		"rank_veteran_2_5",
		"missions_veteran_2_objective_2",
		"missions_veteran_2_2",
		"veteran_2_medium_1",
		"veteran_2_medium_2"
	},
	{
		"group_class_veteran_2_2_rework",
		"rank_veteran_2_6",
		"missions_veteran_2_objective_3",
		"missions_veteran_2_3",
		"veteran_2_hard_1",
		"veteran_2_hard_2"
	}
})

local category_name = "zealot_2"

numeric_target_family("rank_zealot_2_{index:%d}", {
	description = "loc_achievement_rank_zealot_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0031",
	stat_name = "max_rank_zealot",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, rank_targets)
numeric_target_family("missions_zealot_2_{index:%d}", {
	description = "loc_achievement_missions_zealot_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0032",
	stat_name = "missions_zealot_2",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, generic_mission_targets)
family({
	icon = "content/ui/textures/icons/achievements/achievement_icon_0033",
	type = AchievementTypesLookup.multi_stat,
	category = category_name,
	target = table.size(MissionTypes),
	flags = {}
}, {
	id = "missions_zealot_2_objective_{index:%d}",
	title = "loc_achievement_missions_zealot_2_objective_{index:%d}_name",
	description = "loc_achievement_missions_zealot_2_objective_{index:%d}_description",
	stats = generate_mission_difficulties("zealot")
}, {
	{
		difficulty = 1
	},
	{
		difficulty = 2
	},
	{
		difficulty = 3
	}
})
family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_02",
	target = 1,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_zealot_2_easy_difficulty_{index:%d}",
	title = "loc_missions_zealot_2_easy_difficulty_{index:%d}_name",
	description = "loc_missions_zealot_2_easy_difficulty_{index:%d}_description",
	stat_name = "missions_zealot_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.group_zealot_2_rank_1_difficulty_1 = {
	description = "loc_group_zealot_2_rank_1_difficulty_1_description",
	title = "loc_group_zealot_2_rank_1_difficulty_1_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_zealot_2_1",
		"missions_zealot_2_easy_difficulty_1"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_zealot_2_rank_2_difficulty_2 = {
	description = "loc_group_zealot_2_rank_2_difficulty_2_description",
	title = "loc_group_zealot_2_rank_2_difficulty_2_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_zealot_2_2",
		"missions_zealot_2_easy_difficulty_2"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.zealot_2_easy_1 = {
	description = "loc_achievement_zealot_2_easy_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_03",
	title = "loc_achievement_zealot_2_easy_1_name",
	target = 1500,
	stat_name = "zealot_2_number_of_shocked_enemies",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.zealot_2_easy_2 = {
	description = "loc_achievement_zealot_2_easy_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_04",
	title = "loc_achievement_zealot_2_easy_2_name",
	target = 7500,
	stat_name = "zealot_2_toughness_gained_from_chastise_the_wicked",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_zealot_2_rank_4_difficulty_3 = {
	description = "loc_group_zealot_2_rank_4_difficulty_3_description",
	title = "loc_group_zealot_2_rank_4_difficulty_3_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_zealot_2_4",
		"missions_zealot_2_easy_difficulty_3"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_zealot_2_rank_5_difficulty_4 = {
	description = "loc_group_zealot_2_rank_5_difficulty_4_description",
	title = "loc_group_zealot_2_rank_5_difficulty_4_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_zealot_2_5",
		"missions_zealot_2_easy_difficulty_4"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.zealot_2_medium_1 = {
	description = "loc_achievement_zealot_2_medium_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_05",
	title = "loc_achievement_zealot_2_medium_1_name",
	target = 75,
	stat_name = "zealot_2_number_of_critical_hits_kills_when_stunned",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.zealot_2_medium_2 = {
	description = "loc_achievement_zealot_2_medium_2_description",
	title = "loc_achievement_zealot_2_medium_2_name",
	target = 1000,
	stat_name = "zealot_2_kills_with_martyrdoom_stacks",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_06",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		stacks = 3
	}
}
AchievementDefinitions.zealot_2_hard_1 = {
	description = "loc_achievement_zealot_2_hard_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_07",
	title = "loc_achievement_zealot_2_hard_1_name",
	target = 75,
	stat_name = "zealot_2_killed_elites_and_specials_with_activated_attacks",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.zealot_2_hard_2 = {
	description = "loc_achievement_zealot_2_hard_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_08",
	title = "loc_achievement_zealot_2_hard_2_name",
	target = 40,
	stat_name = "zealot_2_charged_enemy_wielding_ranged_weapon",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

family({
	description = "loc_achievement_group_class_zealot_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_12",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_zealot_2_{index:%d}_rework",
	title = "loc_achievement_group_class_zealot_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"rank_zealot_2_4",
		"missions_zealot_2_objective_1",
		"missions_zealot_2_1",
		"zealot_2_easy_1",
		"zealot_2_easy_2"
	},
	{
		"group_class_zealot_2_1_rework",
		"rank_zealot_2_5",
		"missions_zealot_2_objective_2",
		"missions_zealot_2_2",
		"zealot_2_medium_1",
		"zealot_2_medium_2"
	},
	{
		"group_class_zealot_2_2_rework",
		"rank_zealot_2_6",
		"missions_zealot_2_objective_3",
		"missions_zealot_2_3",
		"zealot_2_hard_1",
		"zealot_2_hard_2"
	}
})

local category_name = "psyker_2"

numeric_target_family("rank_psyker_2_{index:%d}", {
	description = "loc_achievement_rank_psyker_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0021",
	stat_name = "max_rank_psyker",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, rank_targets)
numeric_target_family("missions_psyker_2_{index:%d}", {
	description = "loc_achievement_missions_psyker_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0022",
	stat_name = "missions_psyker_2",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, generic_mission_targets)
family({
	icon = "content/ui/textures/icons/achievements/achievement_icon_0023",
	type = AchievementTypesLookup.multi_stat,
	category = category_name,
	target = table.size(MissionTypes),
	flags = {}
}, {
	id = "missions_psyker_2_objective_{index:%d}",
	title = "loc_achievement_missions_psyker_2_objective_{index:%d}_name",
	description = "loc_achievement_missions_psyker_2_objective_{index:%d}_description",
	stats = generate_mission_difficulties("psyker")
}, {
	{
		difficulty = 1
	},
	{
		difficulty = 2
	},
	{
		difficulty = 3
	}
})
family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_02",
	target = 1,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_psyker_2_easy_difficulty_{index:%d}",
	title = "loc_missions_psyker_2_easy_difficulty_{index:%d}_name",
	description = "loc_missions_psyker_2_easy_difficulty_{index:%d}_description",
	stat_name = "missions_psyker_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.group_psyker_2_rank_1_difficulty_1 = {
	description = "loc_group_psyker_2_rank_1_difficulty_1_description",
	title = "loc_group_psyker_2_rank_1_difficulty_1_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_psyker_2_1",
		"missions_psyker_2_easy_difficulty_1"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_psyker_2_rank_2_difficulty_2 = {
	description = "loc_group_psyker_2_rank_2_difficulty_2_description",
	title = "loc_group_psyker_2_rank_2_difficulty_2_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_psyker_2_2",
		"missions_psyker_2_easy_difficulty_2"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_easy_1 = {
	description = "loc_achievement_psyker_2_easy_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_03",
	title = "loc_achievement_psyker_2_easy_1_name",
	target = 200,
	stat_name = "psyker_2_elite_or_special_kills_with_smite",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_easy_2 = {
	description = "loc_achievement_psyker_2_easy_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_04",
	title = "loc_achievement_psyker_2_easy_2_name",
	target = 50,
	stat_name = "psyker_2_survived_perils",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_psyker_2_rank_4_difficulty_3 = {
	description = "loc_group_psyker_2_rank_4_difficulty_3_description",
	title = "loc_group_psyker_2_rank_4_difficulty_3_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_psyker_2_4",
		"missions_psyker_2_easy_difficulty_3"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_psyker_2_rank_5_difficulty_4 = {
	description = "loc_group_psyker_2_rank_5_difficulty_4_description",
	title = "loc_group_psyker_2_rank_5_difficulty_4_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_psyker_2_5",
		"missions_psyker_2_easy_difficulty_4"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_medium_1 = {
	description = "loc_achievement_psyker_2_medium_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_05",
	title = "loc_achievement_psyker_2_medium_1_name",
	target = 100,
	stat_name = "psyker_2_smite_kills_at_max_souls",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_medium_2 = {
	description = "loc_achievement_psyker_2_medium_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_06",
	title = "loc_achievement_psyker_2_medium_2_name",
	target = 2500,
	stat_name = "psyker_2_warp_kills",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_hard_1 = {
	description = "loc_achievement_psyker_2_hard_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_07",
	title = "loc_achievement_psyker_2_hard_1_name",
	target = 25,
	stat_name = "psyker_2_killed_disablers_before_disabling",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_hard_2 = {
	description = "loc_achievement_psyker_2_hard_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_08",
	title = "loc_achievement_psyker_2_hard_2_name",
	target = 3,
	stat_name = "psyker_2_x_missions_no_elite_melee_damage_taken",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

family({
	description = "loc_achievement_group_class_psyker_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_12",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_psyker_2_{index:%d}_rework",
	title = "loc_achievement_group_class_psyker_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"rank_psyker_2_4",
		"missions_psyker_2_objective_1",
		"missions_psyker_2_1",
		"psyker_2_easy_1",
		"psyker_2_easy_2"
	},
	{
		"group_class_psyker_2_1_rework",
		"rank_psyker_2_5",
		"missions_psyker_2_objective_2",
		"missions_psyker_2_2",
		"psyker_2_medium_1",
		"psyker_2_medium_2"
	},
	{
		"group_class_psyker_2_2_rework",
		"rank_psyker_2_6",
		"missions_psyker_2_objective_3",
		"missions_psyker_2_3",
		"psyker_2_hard_1",
		"psyker_2_hard_2"
	}
})

local category_name = "ogryn_2"

numeric_target_family("rank_ogryn_2_{index:%d}", {
	description = "loc_achievement_rank_ogryn_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0001",
	stat_name = "max_rank_ogryn",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, rank_targets)
numeric_target_family("missions_ogryn_2_{index:%d}", {
	description = "loc_achievement_missions_ogryn_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0002",
	stat_name = "missions_ogryn_2",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, generic_mission_targets)
family({
	icon = "content/ui/textures/icons/achievements/achievement_icon_0003",
	type = AchievementTypesLookup.multi_stat,
	category = category_name,
	target = table.size(MissionTypes),
	flags = {}
}, {
	id = "missions_ogryn_2_objective_{index:%d}",
	title = "loc_achievement_missions_ogryn_2_objective_{index:%d}_name",
	description = "loc_achievement_missions_ogryn_2_objective_{index:%d}_description",
	stats = generate_mission_difficulties("ogryn")
}, {
	{
		difficulty = 1
	},
	{
		difficulty = 2
	},
	{
		difficulty = 3
	}
})
family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_02",
	target = 1,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_ogryn_2_easy_difficulty_{index:%d}",
	title = "loc_missions_ogryn_2_easy_difficulty_{index:%d}_name",
	description = "loc_missions_ogryn_2_easy_difficulty_{index:%d}_description",
	stat_name = "missions_ogryn_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.group_ogryn_2_rank_1_difficulty_1 = {
	description = "loc_group_ogryn_2_rank_1_difficulty_1_description",
	title = "loc_group_ogryn_2_rank_1_difficulty_1_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_ogryn_2_1",
		"missions_ogryn_2_easy_difficulty_1"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_ogryn_2_rank_2_difficulty_2 = {
	description = "loc_group_ogryn_2_rank_2_difficulty_2_description",
	title = "loc_group_ogryn_2_rank_2_difficulty_2_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_10",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_ogryn_2_2",
		"missions_ogryn_2_easy_difficulty_2"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.ogryn_2_easy_1 = {
	description = "loc_achievement_ogryn_2_easy_1_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_03",
	title = "loc_achievement_ogryn_2_easy_1_name",
	target = 40,
	stat_name = "ogryn_2_number_of_revived_or_assisted_allies",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.ogryn_2_easy_2 = {
	description = "loc_achievement_ogryn_2_easy_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_04",
	title = "loc_achievement_ogryn_2_easy_2_name",
	target = 5000,
	stat_name = "ogryn_2_number_of_knocked_down_enemies",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_ogryn_2_rank_4_difficulty_3 = {
	description = "loc_group_ogryn_2_rank_4_difficulty_3_description",
	title = "loc_group_ogryn_2_rank_4_difficulty_3_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_ogryn_2_4",
		"missions_ogryn_2_easy_difficulty_3"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_ogryn_2_rank_5_difficulty_4 = {
	description = "loc_group_ogryn_2_rank_5_difficulty_4_description",
	title = "loc_group_ogryn_2_rank_5_difficulty_4_name",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_11",
	target = 2,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_ogryn_2_5",
		"missions_ogryn_2_easy_difficulty_4"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.ogryn_2_medium_1 = {
	description = "loc_achievement_ogryn_2_medium_1_description",
	title = "loc_achievement_ogryn_2_medium_1_name",
	target = 25,
	stat_name = "ogryn_2_bullrushed_group_of_ranged_enemies",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_05",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		num_enemies = 3
	}
}
AchievementDefinitions.ogryn_2_medium_2 = {
	description = "loc_achievement_ogryn_2_medium_2_description",
	title = "loc_achievement_ogryn_2_medium_2_name",
	target = 250,
	stat_name = "ogryn_2_killed_multiple_enemies_with_sweep",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_06",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		amount = 2
	}
}
AchievementDefinitions.ogryn_2_hard_1 = {
	description = "loc_achievement_ogryn_2_hard_1_description",
	title = "loc_achievement_ogryn_2_hard_1_name",
	target = 3,
	stat_name = "ogryn_2_number_of_missions_with_no_deaths_and_all_revives_within_x_seconds",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_07",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time = 10
	}
}
AchievementDefinitions.ogryn_2_hard_2 = {
	description = "loc_achievement_ogryn_2_hard_2_description",
	title = "loc_achievement_ogryn_2_hard_2_name",
	target = 5,
	stat_name = "ogryn_2_grenade_box_kills_without_missing",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_08",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		amount = 4
	}
}

family({
	description = "loc_achievement_group_class_ogryn_2_description",
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_12",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_ogryn_2_{index:%d}_rework",
	title = "loc_achievement_group_class_ogryn_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"rank_ogryn_2_4",
		"missions_ogryn_2_objective_1",
		"missions_ogryn_2_1",
		"ogryn_2_easy_1",
		"ogryn_2_easy_2"
	},
	{
		"group_class_ogryn_2_1_rework",
		"rank_ogryn_2_5",
		"missions_ogryn_2_objective_2",
		"missions_ogryn_2_2",
		"ogryn_2_medium_1",
		"ogryn_2_medium_2"
	},
	{
		"group_class_ogryn_2_2_rework",
		"rank_ogryn_2_6",
		"missions_ogryn_2_objective_3",
		"missions_ogryn_2_3",
		"ogryn_2_hard_1",
		"ogryn_2_hard_2"
	}
})

local category_name = "veteran_2_challenges"

family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_veteran_achievement_09",
	target = 5,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_veteran_2_medium_difficulty_{index:%d}",
	title = "loc_missions_veteran_2_medium_difficulty_{index:%d}_name",
	description = "loc_missions_veteran_2_medium_difficulty_{index:%d}_description",
	stat_name = "missions_veteran_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.veteran_2_weakspot_hits_during_volley_fire_alternate_fire = {
	description = "loc_achievement_veteran_2_weakspot_hits_during_volley_fire_alternate_fire_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0015",
	title = "loc_achievement_veteran_2_weakspot_hits_during_volley_fire_alternate_fire_name",
	target = 4,
	stat_name = "max_weakspot_hit_during_volley_fire_alternate_fire",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_unbounced_grenade_kills = {
	description = "loc_achievement_veteran_2_unbounced_grenade_kills_description",
	title = "loc_achievement_veteran_2_unbounced_grenade_kills_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0014",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {},
	loc_variables = {
		target = 5
	}
}
AchievementDefinitions.veteran_2_kills_with_last_round_in_mag = {
	description = "loc_achievement_veteran_2_kills_with_last_round_in_mag_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0017",
	title = "loc_achievement_veteran_2_kills_with_last_round_in_mag_name",
	target = 8,
	stat_name = "max_veteran_2_kills_with_last_round_in_mag",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_no_melee_damage_taken = {
	description = "loc_achievement_veteran_2_no_melee_damage_taken_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0016",
	title = "loc_achievement_veteran_2_no_melee_damage_taken_name",
	target = 1,
	stat_name = "veteran_min_melee_damage_taken",
	type = AchievementTypesLookup.decreasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire = {
	description = "loc_achievement_veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0018",
	title = "loc_achievement_veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire_name",
	target = 5,
	stat_name = "max_elite_weakspot_kill_during_volley_fire_alternate_fire",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.veteran_2_no_missed_shots_empty_ammo = {
	description = "loc_achievement_veteran_2_no_missed_shots_empty_ammo_description",
	title = "loc_achievement_veteran_2_no_missed_shots_empty_ammo_name",
	target = 90,
	stat_name = "veteran_accuracy_at_end_of_mission_with_no_ammo_left",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0019",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress
	},
	loc_variables = {
		accuracy = 90
	}
}

family({
	description = "loc_group_class_challenges_veteran_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_veteran_2_{index:%d}",
	title = "loc_group_class_challenges_veteran_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"veteran_2_unbounced_grenade_kills",
		"veteran_2_weakspot_hits_during_volley_fire_alternate_fire"
	},
	{
		"group_class_veteran_2_1",
		"veteran_2_no_melee_damage_taken",
		"veteran_2_kills_with_last_round_in_mag"
	},
	{
		"group_class_veteran_2_2",
		"veteran_2_no_missed_shots_empty_ammo",
		"veteran_2_elite_weakspot_kills_during_volley_fire_alternate_fire"
	}
})

local category_name = "zealot_2_challenges"

family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_zealot_achievement_09",
	target = 5,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_zealot_2_medium_difficulty_{index:%d}",
	title = "loc_missions_zealot_2_medium_difficulty_{index:%d}_name",
	description = "loc_missions_zealot_2_medium_difficulty_{index:%d}_description",
	stat_name = "missions_zealot_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.zealot_2_stagger_sniper_with_grenade_distance = {
	description = "loc_achievement_zealot_2_stagger_sniper_with_grenade_distance_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0035",
	title = "loc_achievement_zealot_2_stagger_sniper_with_grenade_distance_name",
	target = 40,
	stat_name = "max_zealot_2_stagger_sniper_with_grenade_distance",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.zelot_2_kill_mutant_charger_with_melee_while_dashing = {
	description = "loc_achievement_zelot_2_kill_mutant_charger_with_melee_while_dashing_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0039",
	title = "loc_achievement_zelot_2_kill_mutant_charger_with_melee_while_dashing_name",
	target = 1,
	stat_name = "zelot_2_kill_mutant_charger_with_melee_while_dashing",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress
	}
}
AchievementDefinitions.zealot_2_kills_of_shocked_enemies_last_15 = {
	description = "loc_achievement_zealot_2_kills_of_shocked_enemies_last_15_description",
	title = "loc_achievement_zealot_2_kills_of_shocked_enemies_last_15_name",
	target = 40,
	stat_name = "max_zealot_2_kills_of_shocked_enemies_last_15",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0037",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time_window = 10
	}
}
AchievementDefinitions.zealot_2_not_use_ranged_attacks = {
	description = "loc_achievement_zealot_2_not_use_ranged_attacks_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0038",
	title = "loc_achievement_zealot_2_not_use_ranged_attacks_name",
	target = 1,
	stat_name = "zealot_2_not_use_ranged_attacks",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress
	}
}
AchievementDefinitions.zealot_2_healed_up_after_resisting_death = {
	description = "loc_achievement_zealot_2_healed_up_after_resisting_death_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0036",
	title = "loc_achievement_zealot_2_healed_up_after_resisting_death_name",
	target = 25,
	stat_name = "max_zealot_2_health_healed_with_leech_during_resist_death",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.zealot_2_health_on_last_segment_enough_during_mission = {
	description = "loc_achievement_zealot_2_health_on_last_segment_enough_during_mission_description",
	title = "loc_achievement_zealot_2_health_on_last_segment_enough_during_mission_name",
	target = 1200,
	stat_name = "zealot_2_fastest_mission_with_low_health",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0034",
	type = AchievementTypesLookup.decreasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.private_only
	},
	loc_variables = {
		health = 75,
		time_window = 20
	}
}

family({
	description = "loc_group_class_challenges_zealot_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_zealot_2_{index:%d}",
	title = "loc_group_class_challenges_zealot_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"zelot_2_kill_mutant_charger_with_melee_while_dashing",
		"zealot_2_stagger_sniper_with_grenade_distance"
	},
	{
		"group_class_zealot_2_1",
		"zealot_2_kills_of_shocked_enemies_last_15",
		"zealot_2_not_use_ranged_attacks"
	},
	{
		"group_class_zealot_2_2",
		"zealot_2_health_on_last_segment_enough_during_mission",
		"zealot_2_healed_up_after_resisting_death"
	}
})

local category_name = "psyker_2_challenges"

family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_psyker_achievement_09",
	target = 5,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_psyker_2_medium_difficulty_{index:%d}",
	title = "loc_missions_psyker_2_medium_difficulty_{index:%d}_name",
	description = "loc_missions_psyker_2_medium_difficulty_{index:%d}_description",
	stat_name = "missions_psyker_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.psyker_2_smite_hound_mid_leap = {
	description = "loc_achievement_psyker_2_smite_hound_mid_leap_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0024",
	title = "loc_achievement_psyker_2_smite_hound_mid_leap_name",
	target = 1,
	stat_name = "smite_hound_mid_leap",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress
	}
}
AchievementDefinitions.psyker_2_edge_kills_last_2_sec = {
	description = "loc_achievement_psyker_2_edge_kills_last_2_sec_description",
	title = "loc_achievement_psyker_2_edge_kills_last_2_sec_name",
	target = 7,
	stat_name = "max_psyker_2_edge_kills_last_2_sec",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0028",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time_window = 2
	}
}
AchievementDefinitions.psyker_2_stay_at_max_souls_for_duration = {
	description = "loc_achievement_psyker_2_stay_at_max_souls_for_duration_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0027",
	title = "loc_achievement_psyker_2_stay_at_max_souls_for_duration_name",
	target = 300,
	stat_name = "max_psyker_2_time_at_max_souls",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.psyker_2_perils_of_the_warp_elite_kills = {
	description = "loc_achievement_psyker_2_perils_of_the_warp_elite_kills_description",
	title = "loc_achievement_psyker_2_perils_of_the_warp_elite_kills_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0025",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {},
	loc_variables = {
		target = 1
	}
}
AchievementDefinitions.psyker_2_elite_or_special_kills_with_smite_last_10_sec = {
	description = "loc_achievement_psyker_2_elite_or_special_kills_with_smite_last_10_sec_description",
	title = "loc_achievement_psyker_2_elite_or_special_kills_with_smite_last_10_sec_name",
	target = 4,
	stat_name = "max_elite_or_special_kills_with_smite_last_12_sec",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0027",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time_window = 12
	}
}
AchievementDefinitions.psyker_2_kill_boss_solo_with_smite = {
	description = "loc_achievement_psyker_2_kill_boss_solo_with_smite_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0029",
	title = "loc_achievement_psyker_2_kill_boss_solo_with_smite_name",
	target = 90,
	stat_name = "max_smite_damage_done_to_boss",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress,
		AchievementFlags.private_only
	}
}

family({
	description = "loc_group_class_challenges_psyker_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_psyker_2_{index:%d}",
	title = "loc_group_class_challenges_psyker_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"psyker_2_edge_kills_last_2_sec",
		"psyker_2_smite_hound_mid_leap"
	},
	{
		"group_class_psyker_2_1",
		"psyker_2_perils_of_the_warp_elite_kills",
		"psyker_2_stay_at_max_souls_for_duration"
	},
	{
		"group_class_psyker_2_2",
		"psyker_2_elite_or_special_kills_with_smite_last_10_sec",
		"psyker_2_kill_boss_solo_with_smite"
	}
})

local category_name = "ogryn_2_challenges"

family({
	icon = "content/ui/textures/icons/achievements/class_achievements/class_ogryn_achievement_09",
	target = 5,
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	id = "missions_ogryn_2_medium_difficulty_{index:%d}",
	title = "loc_missions_ogryn_2_medium_difficulty_{index:%d}_name",
	description = "loc_missions_ogryn_2_medium_difficulty_{index:%d}_description",
	stat_name = "missions_ogryn_2_difficulty_{index:%d}"
}, {
	{},
	{},
	{},
	{},
	{}
})

AchievementDefinitions.ogryn_2_bull_rushed_charging_ogryn = {
	description = "loc_achievement_ogryn_2_bull_rushed_charging_ogryn_description",
	title = "loc_achievement_ogryn_2_bull_rushed_charging_ogryn_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0004",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}
AchievementDefinitions.ogryn_2_killed_corruptor_with_grenade_impact = {
	description = "loc_achievement_ogryn_2_killed_corruptor_with_grenade_impact_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0008",
	title = "loc_achievement_ogryn_2_killed_corruptor_with_grenade_impact_name",
	target = 1,
	stat_name = "ogryn_2_killed_corruptor_with_grenade_impact",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress
	}
}
AchievementDefinitions.ogryn_2_win_with_coherency_all_alive_units = {
	description = "loc_achievement_ogryn_2_win_with_coherency_all_alive_units_description",
	title = "loc_achievement_ogryn_2_win_with_coherency_all_alive_units_name",
	target = 90,
	stat_name = "ogryn_2_win_with_coherency_all_alive_units",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0009",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_progress
	},
	loc_variables = {
		time = 90
	}
}
AchievementDefinitions.ogryn_2_bull_rushed_100_enemies = {
	description = "loc_achievement_ogryn_2_bull_rushed_100_enemies_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0006",
	title = "loc_achievement_ogryn_2_bull_rushed_100_enemies_name",
	target = 60,
	stat_name = "max_ogryn_2_lunge_number_of_enemies_hit",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.ogryn_2_bull_rushed_70_within_25_seconds = {
	description = "loc_achievement_ogryn_2_bull_rushed_70_within_25_seconds_description",
	title = "loc_achievement_ogryn_2_bull_rushed_70_within_25_seconds_name",
	target = 40,
	stat_name = "max_ogryn_2_lunge_distance_last_x_seconds",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0007",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.private_only
	},
	loc_variables = {
		time_window = 20
	}
}
AchievementDefinitions.ogryn_2_bull_rushed_4_ogryns = {
	description = "loc_achievement_ogryn_2_bull_rushed_4_ogryns_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0005",
	title = "loc_achievement_ogryn_2_bull_rushed_4_ogryns_name",
	target = 4,
	stat_name = "max_ogryns_bullrushed",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

family({
	description = "loc_group_class_challenges_ogryn_2_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	type = AchievementTypesLookup.meta,
	category = category_name,
	flags = {}
}, {
	id = "group_class_ogryn_2_{index:%d}",
	title = "loc_group_class_challenges_ogryn_2_{index:%d}_name",
	target = function (self, config)
		return #config
	end,
	achievements = function (self, config)
		return table.set(config)
	end
}, {
	{
		"ogryn_2_killed_corruptor_with_grenade_impact",
		"ogryn_2_bull_rushed_charging_ogryn"
	},
	{
		"group_class_ogryn_2_1",
		"ogryn_2_bull_rushed_100_enemies",
		"ogryn_2_win_with_coherency_all_alive_units"
	},
	{
		"group_class_ogryn_2_2",
		"ogryn_2_bull_rushed_70_within_25_seconds",
		"ogryn_2_bull_rushed_4_ogryns"
	}
})

local category_name = "enemies"
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
			target = target
		}
	end

	return stats
end

AchievementDefinitions.all_renegade_specials_killed = {
	description = "loc_achievement_all_renegade_specials_killed_description",
	title = "loc_achievement_all_renegade_specials_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0041",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.renegade_special,
	stats = stats_from_breeds(AchievementBreedGroups.renegade_special, kill_all_specials_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_specials_target
	}
}
AchievementDefinitions.all_renegade_elites_killed = {
	description = "loc_achievement_all_renegade_elites_killed_description",
	title = "loc_achievement_all_renegade_elites_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0042",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.renegade_elite,
	stats = stats_from_breeds(AchievementBreedGroups.renegade_elite, kill_all_elites_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_elites_target
	}
}
AchievementDefinitions.all_renegades_killed = {
	description = "loc_achievement_all_renegades_killed_description",
	title = "loc_achievement_all_renegades_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0043",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.renegade,
	stats = stats_from_breeds(AchievementBreedGroups.renegade, kill_all_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_target
	}
}

numeric_target_family("kill_renegades_{index:%d}", {
	description = "loc_achievement_kill_renegades_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0044",
	stat_name = "total_renegade_kills",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	1000,
	5000,
	10000,
	15000,
	25000
})

AchievementDefinitions.melee_renegade = {
	description = "loc_achievement_melee_renegade_description",
	title = "loc_achievement_melee_renegade_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0045",
	target = 10,
	stat_name = "total_renegade_grenadier_melee",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.executor_non_headshot = {
	description = "loc_achievement_executor_non_headshot_description",
	title = "loc_achievement_executor_non_headshot_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0046",
	target = 10,
	stat_name = "total_renegade_executors_non_headshot",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_enemies_renegades = {
	description = "loc_achievement_group_enemies_renegades_description",
	title = "loc_achievement_group_enemies_renegades_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	target = 6,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"all_renegade_specials_killed",
		"all_renegade_elites_killed",
		"all_renegades_killed",
		"kill_renegades_5",
		"melee_renegade",
		"executor_non_headshot"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.all_cultist_specials_killed = {
	description = "loc_achievement_all_cultist_specials_killed_description",
	title = "loc_achievement_all_cultist_specials_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0048",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.cultist_special,
	stats = stats_from_breeds(AchievementBreedGroups.cultist_special, kill_all_specials_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_specials_target
	}
}
AchievementDefinitions.all_cultist_elites_killed = {
	description = "loc_achievement_all_cultist_elites_killed_description",
	title = "loc_achievement_all_cultist_elites_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0049",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.cultist_elite,
	stats = stats_from_breeds(AchievementBreedGroups.cultist_elite, kill_all_elites_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_elites_target
	}
}
AchievementDefinitions.all_cultists_killed = {
	description = "loc_achievement_all_cultists_killed_description",
	title = "loc_achievement_all_cultists_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0050",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.cultist,
	stats = stats_from_breeds(AchievementBreedGroups.cultist, kill_all_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_target
	}
}

numeric_target_family("kill_cultists_{index:%d}", {
	description = "loc_achievement_kill_cultists_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0051",
	stat_name = "total_cultist_kills",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	1000,
	5000,
	10000,
	15000,
	25000
})

AchievementDefinitions.cultist_berzerker_head = {
	description = "loc_achievement_cultist_berzerker_head_description",
	title = "loc_achievement_cultist_berzerker_head_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0052",
	target = 10,
	stat_name = "total_cultist_berzerker_head",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_enemies_cultists = {
	description = "loc_achievement_group_enemies_cultists_description",
	title = "loc_achievement_group_enemies_cultists_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	target = 5,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"all_cultist_specials_killed",
		"all_cultist_elites_killed",
		"all_cultists_killed",
		"kill_cultists_5",
		"cultist_berzerker_head"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions.all_chaos_specials_killed = {
	description = "loc_achievement_all_chaos_specials_killed_description",
	title = "loc_achievement_all_chaos_specials_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0048",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.chaos_special,
	stats = stats_from_breeds(AchievementBreedGroups.chaos_special, kill_all_specials_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_specials_target
	}
}
AchievementDefinitions.all_chaos_elites_killed = {
	description = "loc_achievement_all_chaos_elites_killed_description",
	title = "loc_achievement_all_chaos_elites_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0049",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.chaos_elite,
	stats = stats_from_breeds(AchievementBreedGroups.chaos_elite, kill_all_elites_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_elites_target
	}
}
AchievementDefinitions.all_chaos_killed = {
	description = "loc_achievement_all_chaos_killed_description",
	title = "loc_achievement_all_chaos_killed_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0050",
	type = AchievementTypesLookup.multi_stat,
	target = #AchievementBreedGroups.chaos,
	stats = stats_from_breeds(AchievementBreedGroups.chaos, kill_all_target),
	category = category_name,
	flags = {},
	loc_variables = {
		target = kill_all_target
	}
}

numeric_target_family("kill_chaos_{index:%d}", {
	description = "loc_achievement_kill_chaos_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0051",
	stat_name = "total_chaos_kills",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	1000,
	5000,
	10000,
	15000,
	25000
})

AchievementDefinitions.ogryn_gunner_melee = {
	description = "loc_achievement_ogryn_gunner_melee_description",
	title = "loc_achievement_ogryn_gunner_melee_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0052",
	target = 10,
	stat_name = "total_ogryn_gunner_melee",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.banish_daemonhost = {
	description = "loc_achievement_banish_daemonhost_description",
	title = "loc_achievement_banish_daemonhost_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0052",
	target = 1,
	stat_name = "kill_daemonhost",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_enemies_chaos = {
	description = "loc_achievement_group_enemies_chaos_description",
	title = "loc_achievement_group_enemies_chaos_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0047",
	target = 5,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"all_chaos_specials_killed",
		"all_chaos_elites_killed",
		"all_chaos_killed",
		"kill_chaos_5",
		"ogryn_gunner_melee"
	}),
	category = category_name,
	flags = {}
}
local category_name = "missions"
local category_name = "missions_general"

local function _add_mission_objective_family(id, icon)
	local pattern = "type_" .. id .. "_mission_{index:%d}"

	numeric_target_family(pattern, {
		type = AchievementTypesLookup.increasing_stat,
		description = "loc_achievement_type_" .. id .. "_mission_x_description",
		icon = icon,
		stat_name = "type_" .. id .. "_missions",
		category = category_name,
		flags = {}
	}, {
		50,
		100,
		150,
		200,
		250
	})
end

_add_mission_objective_family("1", "content/ui/textures/icons/achievements/achievement_icon_0061")
_add_mission_objective_family("2", "content/ui/textures/icons/achievements/achievement_icon_0062")
_add_mission_objective_family("3", "content/ui/textures/icons/achievements/achievement_icon_0063")
_add_mission_objective_family("4", "content/ui/textures/icons/achievements/achievement_icon_0064")
_add_mission_objective_family("5", "content/ui/textures/icons/achievements/achievement_icon_0065")
_add_mission_objective_family("6", "content/ui/textures/icons/achievements/achievement_icon_0066")
_add_mission_objective_family("7", "content/ui/textures/icons/achievements/achievement_icon_0067")
numeric_target_family("missions_{index:%d}", {
	description = "loc_achievement_missions_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0068",
	stat_name = "missions",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	100,
	250,
	500,
	1000,
	1500
})
numeric_target_family("scan_{index:%d}", {
	description = "loc_achievement_scan_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0069",
	stat_name = "total_scans",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	10,
	25,
	50,
	100,
	200
})
numeric_target_family("hack_{index:%d}", {
	description = "loc_achievement_hack_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0070",
	stat_name = "total_hacks",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	10,
	25,
	50,
	100,
	200
})

AchievementDefinitions.hack_perfect = {
	description = "loc_achievement_hack_perfect_description",
	title = "loc_achievement_hack_perfect_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0072",
	target = 1,
	stat_name = "perfect_hacks",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

numeric_target_family("mission_circumstace_{index:%d}", {
	description = "loc_achievement_mission_circumstace_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0071",
	stat_name = "mission_circumstance",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	1,
	50,
	150,
	250,
	500
})

local mission_type_count = table.size(MissionTypes)

local function _generate_stats(index, config)
	local difficulty = config.difficulty
	local stats = {}

	for _, mission_type in pairs(MissionTypes) do
		local stat_name = string.format("max_difficulty_%s_mission", mission_type.id)
		stats[stat_name] = {
			increasing = true,
			target = difficulty
		}
	end

	return stats
end

family({
	icon = "content/ui/textures/icons/achievements/achievement_icon_0073",
	type = AchievementTypesLookup.multi_stat,
	category = category_name,
	target = mission_type_count,
	flags = {}
}, {
	id = "mission_difficulty_objectives_{index:%d}",
	title = "loc_achievement_mission_difficulty_objectives_{index:%d}_name",
	description = "loc_achievement_mission_difficulty_objectives_{index:%d}_description",
	stats = _generate_stats
}, {
	{
		difficulty = 1
	},
	{
		difficulty = 2
	},
	{
		difficulty = 3
	},
	{
		difficulty = 4
	},
	{
		difficulty = 5
	}
})

AchievementDefinitions.group_missions = {
	description = "loc_achievement_group_missions_description",
	title = "loc_achievement_group_missions_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0078",
	target = 7,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"type_1_mission_2",
		"type_2_mission_2",
		"type_3_mission_2",
		"type_4_mission_2",
		"type_5_mission_2",
		"type_6_mission_2",
		"type_7_mission_2"
	}),
	category = category_name,
	flags = {}
}
local category_name = "twins_mission"
AchievementDefinitions.mission_twins_win = {
	description = "loc_achievement_mission_twins_win_description",
	title = "loc_achievement_mission_twins_win_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_twins_mission",
	target = 1,
	stat_name = "mission_twins",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_missing
	}
}
AchievementDefinitions.difficult_mission_twins_win = {
	description = "loc_achievement_difficult_mission_twins_win_description",
	title = "loc_achievement_difficult_mission_twins_win_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_twins_mission_level5",
	target = 5,
	stat_name = "mission_twins",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_missing
	}
}
AchievementDefinitions.difficult_mission_twins_hard_mode_win = {
	description = "loc_achievement_difficult_mission_twins_hard_mode_win_description",
	title = "loc_achievement_difficult_mission_twins_hard_mode_win_name",
	target = 1,
	stat_name = "mission_twins_hard_mode",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_missing
	}
}
AchievementDefinitions.mission_twins_secret = {
	description = "loc_achievement_mission_twins_unlocked_puzzle_description",
	title = "loc_achievement_mission_twins_unlocked_puzzle_name",
	target = 1,
	stat_name = "mission_twins_secret_puzzle_trigger",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.hide_missing
	}
}
local category_name = "account"

numeric_target_family("multi_class_{index:%d}", {
	description = "loc_achievement_multi_class_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0079",
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"rank_veteran_2_6",
		"rank_zealot_2_6",
		"rank_psyker_2_6",
		"rank_ogryn_2_6"
	}),
	category = category_name,
	flags = {}
}, {
	2,
	4
})

local category_name = "account"
AchievementDefinitions.prologue = {
	description = "loc_achievement_prologue_description",
	title = "loc_achievement_prologue_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0080",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}
AchievementDefinitions.basic_training = {
	description = "loc_achievement_basic_training_description",
	title = "loc_achievement_basic_training_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0081",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}
AchievementDefinitions.unlock_gadgets = {
	description = "loc_achievement_unlock_gadgets_description",
	title = "loc_achievement_unlock_gadgets_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0077",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}
AchievementDefinitions.unlock_contracts = {
	description = "loc_achievement_unlock_contracts_description",
	title = "loc_achievement_unlock_contracts_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0104",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}
AchievementDefinitions.unlock_crafting = {
	description = "loc_achievement_unlock_crafting_description",
	title = "loc_achievement_unlock_crafting_name",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}

numeric_target_family("path_of_trust_{index:%d}", {
	description = "loc_achievement_path_of_trust_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0082",
	type = AchievementTypesLookup.direct_unlock,
	category = category_name,
	flags = {}
}, {
	1,
	2,
	3,
	4,
	5,
	6
})

local category_name = "teamplay"

numeric_target_family("revive_{index:%d}", {
	description = "loc_achievement_revive_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0083",
	stat_name = "total_player_rescues",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	10,
	50,
	100,
	250,
	500
})
numeric_target_family("assists_{index:%d}", {
	description = "loc_achievement_assists_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0084",
	stat_name = "total_player_assists",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	10,
	50,
	100,
	500,
	1000
})

AchievementDefinitions.flawless_team = {
	description = "loc_achievement_flawless_team_description",
	title = "loc_achievement_flawless_team_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0085",
	target = 100,
	stat_name = "team_flawless_missions",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.coherency_toughness = {
	description = "loc_achievement_coherency_toughness_description",
	title = "loc_achievement_coherency_toughness_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0086",
	target = 2000,
	stat_name = "total_coherency_toughness",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.revive_all = {
	description = "loc_achievement_revive_all_description",
	title = "loc_achievement_revive_all_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0087",
	target = 3,
	stat_name = "max_different_players_rescued",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

numeric_target_family("deployables_{index:%d}", {
	description = "loc_achievement_deployables_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0076",
	stat_name = "total_deployables_placed",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	25,
	50,
	100,
	250,
	500
})

AchievementDefinitions.group_cooperation = {
	description = "loc_achievement_group_cooperation_description",
	title = "loc_achievement_group_cooperation_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0088",
	target = 5,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"revive_3",
		"assists_3",
		"flawless_team",
		"coherency_toughness",
		"deployables_3"
	}),
	category = category_name,
	flags = {}
}
local category_name = "offensive"

numeric_target_family("enemies_{index:%d}", {
	description = "loc_achievement_enemies_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0089",
	stat_name = "total_kills",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	1000,
	40000,
	100000,
	500000,
	1000000
})

AchievementDefinitions.consecutive_headshots = {
	description = "loc_achievement_consecutive_headshots_description",
	title = "loc_achievement_consecutive_headshots_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0090",
	target = 20,
	stat_name = "max_head_shot_in_a_row",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

numeric_target_family("boss_fast_{index:%d}", {
	description = "loc_achievement_boss_fast_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0091",
	stat_name = "fastest_boss_kill",
	type = AchievementTypesLookup.decreasing_stat,
	category = category_name,
	flags = {}
}, {
	60,
	20,
	5
})
numeric_target_family("fast_enemies_{index:%d}", {
	description = "loc_achievement_fast_enemies_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0092",
	stat_name = "max_kills_last_60_sec",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time_window = 30
	}
}, {
	60,
	90,
	120
})

AchievementDefinitions.enemies_climbing = {
	description = "loc_achievement_enemies_climbing_description",
	title = "loc_achievement_enemies_climbing_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0093",
	target = 50,
	stat_name = "kill_climbing",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}

numeric_target_family("fast_headshot_{index:%d}", {
	description = "loc_achievement_fast_headshot_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0094",
	stat_name = "max_head_shot_kills_last_10_sec",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time_window = 10
	}
}, {
	3,
	7,
	15
})

AchievementDefinitions.group_offence = {
	description = "loc_achievement_group_offence_description",
	title = "loc_achievement_group_offence_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0088",
	target = 6,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"enemies_2",
		"consecutive_headshots",
		"boss_fast_2",
		"fast_enemies_2",
		"enemies_climbing",
		"fast_headshot_2"
	}),
	category = category_name,
	flags = {}
}
local category_name = "defensive"

numeric_target_family("fast_blocks_{index:%d}", {
	description = "loc_achievement_fast_blocks_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0096",
	stat_name = "max_damage_blocked_last_20_sec",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {},
	loc_variables = {
		time_window = 10
	}
}, {
	400,
	600,
	900
})
numeric_target_family("consecutive_dodge_{index:%d}", {
	description = "loc_achievement_consecutive_dodge_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0097",
	stat_name = "max_dodges_in_a_row",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}, {
	7,
	12,
	20
})
numeric_target_family("flawless_mission_{index:%d}", {
	description = "loc_achievement_flawless_mission_x_description",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0098",
	stat_name = "max_flawless_mission_in_a_row",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {
		AchievementFlags.prioritize_running
	}
}, {
	5,
	10,
	15
})

AchievementDefinitions.total_sprint_dodges = {
	description = "loc_achievement_total_sprint_dodges_description",
	title = "loc_achievement_total_sprint_dodges_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0099",
	target = 99,
	stat_name = "total_sprint_dodges",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.slide_dodge = {
	description = "loc_achievement_slide_dodge_description",
	title = "loc_achievement_slide_dodge_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0100",
	target = 1,
	stat_name = "total_slide_dodges",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.melee_toughness = {
	description = "loc_achievement_melee_toughness_description",
	title = "loc_achievement_melee_toughness_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0101",
	target = 40000,
	stat_name = "total_melee_toughness_regen",
	type = AchievementTypesLookup.increasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.mission_no_damage = {
	description = "loc_achievement_mission_no_damage_description",
	title = "loc_achievement_mission_no_damage_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0102",
	target = 1,
	stat_name = "lowest_damage_taken_on_win",
	type = AchievementTypesLookup.decreasing_stat,
	category = category_name,
	flags = {}
}
AchievementDefinitions.group_defence = {
	description = "loc_achievement_group_defence_description",
	title = "loc_achievement_group_defence_name",
	icon = "content/ui/textures/icons/achievements/achievement_icon_0103",
	target = 7,
	type = AchievementTypesLookup.meta,
	achievements = table.set({
		"fast_blocks_2",
		"consecutive_dodge_2",
		"flawless_mission_1",
		"total_sprint_dodges",
		"slide_dodge",
		"melee_toughness",
		"mission_no_damage"
	}),
	category = category_name,
	flags = {}
}
AchievementDefinitions = _achievement_data

for _, definition in pairs(AchievementDefinitions) do
	definition.flags = table.set(definition.flags)
end

for id, definition in pairs(AchievementDefinitions) do
	local platform_id = XboxLivePlatformAchievements.backend_to_platform[id]

	if platform_id ~= nil then
		definition.xbox = {
			id = platform_id,
			show_progress = not not XboxLivePlatformAchievements.show_progress[platform_id]
		}
	end
end

for id, definition in pairs(AchievementDefinitions) do
	local platform_id = SteamPlatformAchievements.backend_to_platform[id]

	if platform_id ~= nil then
		definition.steam = {
			id = platform_id,
			stat_id = SteamPlatformAchievements.platform_to_stat[platform_id]
		}
	end
end

return settings("AchievementDefinitions", AchievementDefinitions)
