-- chunkname: @scripts/managers/stats/stat_definitions.lua

local AchievementBreedGroups = require("scripts/settings/achievements/achievement_breed_groups")
local AchievementTweakData = require("scripts/managers/achievements/achievement_tweak_data")
local AchievementWeaponGroups = require("scripts/settings/achievements/achievement_weapon_groups")
local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local StatConfigMacros = require("scripts/managers/stats/utility/stat_config_macros")
local Breeds = require("scripts/settings/breed/breeds")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MechanicusEventWeapons = require("scripts/settings/live_event/mechanicus_event_weapons")
local MissionBuffsAllowed = require("scripts/managers/mission_buffs/mission_buffs_allowed_buffs")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local StatFlags = require("scripts/managers/stats/stat_flags")
local StatMacros = require("scripts/managers/stats/stat_macros")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local Weakspot = require("scripts/utilities/attack/weakspot")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local Zones = require("scripts/settings/zones/zones")
local _stat_count = 0
local _stat_data = {}
local stat_definitions = setmetatable({}, {
	__index = function (_, key)
		return _stat_data[key]
	end,
	__newindex = function (_, key, value)
		_stat_count, _stat_data[key] = _stat_count + 1, value
		value.index, value.id = _stat_count, key
	end,
})
local stagger_results = AttackSettings.stagger_results

local function _sorted(t)
	table.sort(t)

	return t
end

local function _sort_adventure_missions()
	local sorted_list = {}

	for type, mission_type in pairs(MissionTypes) do
		local i = mission_type.index

		if i then
			local clone_type = table.clone(mission_type)

			clone_type.type = type
			sorted_list[i] = clone_type
		end
	end

	return sorted_list
end

local breed_name_to_sub_faction_lookup = {}

for breed_name, breed in pairs(Breeds) do
	local sub_faction_name = breed.sub_faction_name

	breed_name_to_sub_faction_lookup[breed_name] = sub_faction_name
end

local archetype_names = _sorted(table.clone(ArchetypeSettings.archetype_names_array))
local breed_names = _sorted(table.keys(table.conditional_copy(Breeds, function (_, value)
	return value.faction_name == "chaos"
end)))
local adventure_mission_types = _sort_adventure_missions()
local mission_templates = _sorted(table.keys(table.conditional_copy(MissionTemplates, function (_, value)
	return not value.is_dev_mission and not value.is_hub
end)))
local mission_zones = _sorted(table.keys(table.conditional_copy(Zones, function (_, zone)
	return zone.name
end)))
local chaos_breeds = _sorted(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.sub_faction_name == "chaos"
end)))
local cultist_breeds = _sorted(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.sub_faction_name == "cultist"
end)))
local renegade_breeds = _sorted(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.sub_faction_name == "renegade"
end)))
local boss_breeds = _sorted(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.is_boss
end)))
local disabler_breeds = _sorted(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.tags.disabler
end)))
local ranged_breed_lookup = table.set(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.ranged
end)))
local volley_fire_target_breed_lookup = table.set(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.volley_fire_target
end)))
local elite_breed_lookup = table.set(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.tags.elite
end)))
local special_and_elite_breed_lookup = table.set(table.keys(table.conditional_copy(Breeds, function (_, breed)
	local tags = breed.tags

	return tags.special or tags.elite
end)))
local armor_breeds = table.set(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.armor_type == "resistant" or breed.armor_type == "armored" or breed.armor_type == "super_armor"
end)))
local general_breed_lookup = table.set(table.keys(table.conditional_copy(Breeds, function (_, breed)
	return breed.tags.minion
end)))
local weapon_names = _sorted(table.keys(WeaponTemplates))
local weapons_with_activated_specials = table.set(table.keys(table.conditional_copy(WeaponTemplates, function (_, weapon)
	return WeaponTemplate.has_keyword(weapon, "activated")
end)))

local function is_weakspot_hit(attack_data)
	local breed = Breeds[attack_data.target_breed_name]
	local hit_zone_name = attack_data.hit_zone_name
	local attacking_unit = attack_data.attacking_unit
	local is_weak_spot_hit = Weakspot.hit_weakspot(breed, hit_zone_name, attacking_unit)

	return is_weak_spot_hit
end

local function is_ranged_close_hit(attack_data)
	local CLOSE_RANGE_RANGED = DamageSettings.ranged_close
	local is_close = CLOSE_RANGE_RANGED >= attack_data.distance_between_units

	return is_close
end

local function non_horde_target(attack_data)
	local breed = Breeds[attack_data.target_breed_name]
	local non_horde = not breed.tags or not breed.tags.horde

	return non_horde
end

local function read_stat(stat_definition, stat_data)
	local id = stat_definition.id

	return stat_data[id] or stat_definition.default
end

local function constant(stat_definition, _, amount)
	local id = stat_definition.id

	return id, amount
end

local function increment_by(stat_definition, stat_data, amount)
	local id = stat_definition.id

	stat_data[id] = (stat_data[id] or stat_definition.default) + amount

	return id, stat_data[id]
end

local function increment(stat_definition, stat_data)
	local id = stat_definition.id

	stat_data[id] = (stat_data[id] or stat_definition.default) + 1

	return id, stat_data[id]
end

local function set_to(stat_definition, stat_data, value)
	local id = stat_definition.id

	stat_data[id] = value

	return id, value
end

local function decrement(stat_definition, stat_data)
	local id = stat_definition.id

	stat_data[id] = (stat_data[id] or stat_definition.default) - 1

	return id, stat_data[id]
end

local function set_to_max(stat_definition, stat_data, value)
	local id = stat_definition.id
	local current_value = stat_data[id] or stat_definition.default

	if current_value < value then
		stat_data[id] = value

		return id, value
	end
end

local function set_to_min(stat_definition, stat_data, value)
	local id = stat_definition.id
	local current_value = stat_data[id] or stat_definition.default

	if value < current_value then
		stat_data[id] = value

		return id, value
	end
end

local function seconds(amount)
	return amount
end

local function minutes(amount)
	return 60 * seconds(amount)
end

local function hours(amount)
	return 60 * minutes(amount)
end

stat_definitions.hook_player_spawned = {
	flags = {
		StatFlags.hook,
	},
}

do
	local function include_condition(self, config)
		local correct_archetype_name = self.data.archetype_name == config.archetype_name
		local is_hub = config.is_hub

		return is_hub and correct_archetype_name
	end

	for i = 1, #archetype_names do
		local archetype_name = archetype_names[i]
		local stat_name = string.format("max_rank_%s", archetype_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				archetype_name = archetype_name,
			},
			triggers = {
				{
					id = "hook_player_spawned",
					trigger = function (self, stat_data, profile)
						local current_level = profile.current_level or 0

						return set_to_max(self, stat_data, current_level)
					end,
				},
			},
			include_condition = include_condition,
		}
	end
end

stat_definitions.hook_ranged_attack_concluded = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.shots_fired = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.shots_missed = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if not hit_minion then
					return increment(self, stat_data)
				end
			end,
		},
	},
}

do
	local function accuracy_function(self, stat_data, _)
		local total_shots = read_stat(stat_definitions.shots_fired, stat_data)
		local missed_shots = read_stat(stat_definitions.shots_missed, stat_data)
		local percentage_raw = 1 - missed_shots / total_shots
		local accuracy = math.round(100 * percentage_raw)
		local id = self.id

		stat_data[id] = accuracy

		return self.id, accuracy
	end

	stat_definitions.accuracy = {
		default = 0,
		flags = {},
		triggers = {
			{
				id = "shots_fired",
				trigger = accuracy_function,
			},
			{
				id = "shots_missed",
				trigger = accuracy_function,
			},
		},
	}
end

stat_definitions.shot_hit_weakspot = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_recover,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if hit_weakspot then
					return self.id, hit_minion, hit_weakspot, killing_blow, last_round_in_mag
				end
			end,
		},
	},
}
stat_definitions.shot_missed_weakspot = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_recover,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if not hit_weakspot then
					return self.id, hit_minion, hit_weakspot, killing_blow, last_round_in_mag
				end
			end,
		},
	},
}
stat_definitions.hook_projectile_hit = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_health_update = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log,
	},
}
stat_definitions.time_spent_on_last_health_segment = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_health_update",
			trigger = function (self, stat_data, dt, remaining_health_segments, is_knocked_down)
				if not is_knocked_down and remaining_health_segments <= 0 then
					return increment_by(self, stat_data, dt)
				end
			end,
		},
	},
}
stat_definitions.hook_alternate_fire_start = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_alternate_fire_stop = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.alternate_fire_active = {
	flags = {
		StatFlags.no_recover,
		StatFlags.never_log,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_alternate_fire_start",
			trigger = function (self, stat_data)
				return set_to_max(self, stat_data, 1)
			end,
		},
		{
			id = "hook_alternate_fire_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end,
		},
	},
}
stat_definitions.hook_kill = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.team_kill = {
	flags = {
		StatFlags.team,
		StatFlags.never_log,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.forward,
		},
	},
}
stat_definitions.session_team_kills = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.local_team_kills = {
	flags = {},
	triggers = {
		{
			id = "team_kill",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.total_kills = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.increment,
		},
	},
}

do
	local tree = {}

	for _, sub_faction_name in ipairs({
		"chaos",
		"renegade",
		"cultist",
	}) do
		for _, attack_type in ipairs({
			"melee",
			"ranged",
			"explosion",
		}) do
			local stat_name = string.format("team_%s_killed_with_%s", sub_faction_name, attack_type)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.never_log,
				},
			}
			tree[sub_faction_name] = tree[sub_faction_name] or {}
			tree[sub_faction_name][attack_type] = stat_name
		end
	end

	stat_definitions.team_killed_with_splitter = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			stat_lookup = tree,
			breed_lookup = breed_name_to_sub_faction_lookup,
		},
		triggers = {
			{
				id = "team_kill",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local attack_type = attack_data.attack_type
					local data = self.data
					local stat_lookup = data.stat_lookup
					local sub_faction_name = data.breed_lookup[breed_name]
					local id = stat_lookup[sub_faction_name] and stat_lookup[sub_faction_name][attack_type]

					if id then
						stat_data[id] = (stat_data[id] or self.default) + 1

						return id, stat_data[id]
					end
				end,
			},
		},
	}
end

do
	local tree = {}

	for _, sub_faction_name in ipairs({
		"chaos",
		"renegade",
		"cultist",
	}) do
		for _, attack_type in ipairs({
			"melee",
			"ranged",
			"explosion",
		}) do
			local stat_name = string.format("%s_killed_with_%s", sub_faction_name, attack_type)

			stat_definitions[stat_name] = {
				flags = {},
			}
			tree[sub_faction_name] = tree[sub_faction_name] or {}
			tree[sub_faction_name][attack_type] = stat_name
		end
	end

	stat_definitions.killed_with_splitter = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			stat_lookup = tree,
			breed_lookup = breed_name_to_sub_faction_lookup,
		},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local attack_type = attack_data.attack_type
					local data = self.data
					local stat_lookup = data.stat_lookup
					local sub_faction_name = data.breed_lookup[breed_name]
					local id = stat_lookup[sub_faction_name] and stat_lookup[sub_faction_name][attack_type]

					if id then
						stat_data[id] = (stat_data[id] or self.default) + 1

						return id, stat_data[id]
					end
				end,
			},
		},
	}
end

do
	local breed_to_stat = {}

	for i = 1, #breed_names do
		local breed_name = breed_names[i]
		local id = string.format("%s_killed", breed_name)

		breed_to_stat[breed_name] = id

		local flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		}

		stat_definitions[id] = {
			flags = flags,
		}
	end

	stat_definitions.breed_kill_splitter = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			breed_to_stat = breed_to_stat,
		},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local id = self.data.breed_to_stat[breed_name]

					return id, attack_data
				end,
			},
		},
	}

	for i = 1, #breed_names do
		local breed_name = breed_names[i]
		local hook_id = breed_to_stat[breed_name]
		local stat_id = string.format("total_%s_killed", breed_name)

		stat_definitions[stat_id] = {
			flags = {
				StatFlags.backend,
			},
			triggers = {
				{
					id = hook_id,
					trigger = StatMacros.increment,
				},
			},
			stat_name = Breeds[breed_name].display_name,
		}
	end

	local function breed_kill_triggers(breeds)
		local triggers = {}

		for i = 1, #breeds do
			local hook_id = breed_to_stat[breeds[i]]

			triggers[i] = {
				id = hook_id,
				trigger = StatMacros.increment,
			}
		end

		return triggers
	end

	stat_definitions.total_renegade_kills = {
		flags = {
			StatFlags.backend,
		},
		triggers = breed_kill_triggers(renegade_breeds),
	}
	stat_definitions.total_cultist_kills = {
		flags = {
			StatFlags.backend,
		},
		triggers = breed_kill_triggers(cultist_breeds),
	}
	stat_definitions.total_chaos_kills = {
		flags = {
			StatFlags.backend,
		},
		triggers = breed_kill_triggers(chaos_breeds),
	}
end

stat_definitions.weakspot_kill = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				if is_weakspot_hit(attack_data) then
					return self.id, attack_data
				end
			end,
		},
	},
}
stat_definitions.team_weakspot_kill = {
	flags = {
		StatFlags.team,
		StatFlags.never_log,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "weakspot_kill",
			trigger = StatMacros.forward,
		},
	},
}
stat_definitions.head_shot_kill = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "weakspot_kill",
			trigger = function (self, stat_data, attack_data)
				if attack_data.attack_type == "ranged" then
					return self.id, attack_data
				end
			end,
		},
	},
}
stat_definitions.non_head_shot_kill = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local is_head_shot = attack_data.attack_type == "ranged" and is_weakspot_hit(attack_data)

				if not is_head_shot then
					return self.id, attack_data
				end
			end,
		},
	},
}
stat_definitions.session_weakspot_kills = {
	flags = {},
	triggers = {
		{
			id = "team_weakspot_kill",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.head_shot_kills_last_10_sec = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "head_shot_kill",
			trigger = StatMacros.increment,
		},
		{
			id = "head_shot_kill",
			trigger = StatMacros.decrement,
			delay = seconds(10),
		},
	},
}
stat_definitions.max_head_shot_kills_last_10_sec = {
	running_stat = "head_shot_kills_last_10_sec",
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "head_shot_kills_last_10_sec",
			trigger = StatMacros.set_to_max,
		},
	},
}
stat_definitions.head_shot_kills_in_a_row = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "head_shot_kill",
			trigger = StatMacros.increment,
		},
		{
			id = "non_head_shot_kill",
			trigger = function (self, stat_data, attack_data)
				return set_to_min(self, stat_data, 0)
			end,
		},
	},
}
stat_definitions.max_head_shot_in_a_row = {
	running_stat = "head_shot_kills_in_a_row",
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "head_shot_kills_in_a_row",
			trigger = StatMacros.set_to_max,
		},
	},
}
stat_definitions.kills_last_60_sec = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.increment,
		},
		{
			id = "hook_kill",
			trigger = StatMacros.decrement,
			delay = seconds(30),
		},
	},
}
stat_definitions.max_kills_last_60_sec = {
	running_stat = "kills_last_60_sec",
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "kills_last_60_sec",
			trigger = StatMacros.set_to_max,
		},
	},
}
stat_definitions.kill_climbing = {
	flags = {
		StatFlags.backend,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local action = attack_data.target_action

				if action == "climb" then
					return increment(self, stat_data)
				end
			end,
		},
	},
}
stat_definitions.ledge_kill = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local damage_profile_name = attack_data.damage_profile_name

				if damage_profile_name == "kill_volume_and_off_navmesh" then
					return self.id, attack_data
				end
			end,
		},
	},
}
stat_definitions.hook_boss_died = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.fastest_boss_kill = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_boss_died",
			trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
				return set_to_min(self, stat_data, time_since_first_damage)
			end,
		},
	},
	default = hours(5),
}
stat_definitions.session_boss_kills = {
	flags = {},
	triggers = {
		{
			id = "hook_boss_died",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.hook_damage_dealt = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_explosion = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_team_explosion = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}

do
	local breed_to_stat = {}

	for i = 1, #breed_names do
		local breed_name = breed_names[i]
		local id = string.format("%s_damaged", breed_name)

		breed_to_stat[breed_name] = id

		local flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		}

		stat_definitions[id] = {
			flags = flags,
		}
	end

	stat_definitions.breed_damage_splitter = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			breed_to_stat = breed_to_stat,
		},
		triggers = {
			{
				id = "hook_damage_dealt",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local id = self.data.breed_to_stat[breed_name]

					return id, attack_data
				end,
			},
		},
	}
end

stat_definitions.hook_buff = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_shout_buff = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_liquid_area_entering_buff_added_on_enemy = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_liquid_area_exiting_buff_added_on_enemy = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_damage_taken = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.session_damage_taken = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
				return increment_by(self, stat_data, damage_dealt)
			end,
		},
	},
}
stat_definitions.session_team_damage_taken = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
				return increment_by(self, stat_data, damage_dealt)
			end,
		},
	},
}
stat_definitions.hook_dodged_attack = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.dodges_in_a_row = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "hook_dodged_attack",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				if attack_type ~= "ranged" and dodge_type == "dodge" then
					return increment(self, stat_data)
				end
			end,
		},
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				return set_to_min(self, stat_data, 0)
			end,
		},
	},
}
stat_definitions.max_dodges_in_a_row = {
	running_stat = "dodges_in_a_row",
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "dodges_in_a_row",
			trigger = StatMacros.set_to_max,
		},
	},
}
stat_definitions.total_sprint_dodges = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_dodged_attack",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				if attack_type == "ranged" and dodge_type == "sprint" then
					return increment(self, stat_data)
				end
			end,
		},
	},
}
stat_definitions.total_slide_dodges = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_dodged_attack",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				if dodge_type == "slide" then
					return increment(self, stat_data)
				end
			end,
		},
	},
}
stat_definitions.hook_blocked_damage = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_blocked_damage_from_unique_enemy = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.team_blocked_damage = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
		StatFlags.never_log,
	},
	triggers = {
		{
			id = "hook_blocked_damage",
			trigger = StatMacros.forward,
		},
	},
}
stat_definitions.session_my_blocked_damage = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, damage_blocked)
			end,
		},
	},
}
stat_definitions.session_team_blocked_damage = {
	flags = {
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "team_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, damage_blocked)
			end,
		},
	},
}
stat_definitions.damage_blocked_last_20_sec = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "hook_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, damage_blocked)
			end,
		},
		{
			id = "hook_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, -damage_blocked)
			end,
			delay = seconds(10),
		},
	},
}
stat_definitions.max_damage_blocked_last_20_sec = {
	running_stat = "damage_blocked_last_20_sec",
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "damage_blocked_last_20_sec",
			trigger = StatMacros.set_to_max,
		},
	},
}
stat_definitions.hook_knocked_down = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.session_knock_downs = {
	flags = {},
	triggers = {
		{
			id = "hook_knocked_down",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.team_knock_downs = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "hook_knocked_down",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.hook_death = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.session_deaths = {
	flags = {},
	triggers = {
		{
			id = "hook_death",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.team_deaths = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "hook_death",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.hook_collect_material = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.team_collect_material = {
	flags = {
		StatFlags.no_sync,
		StatFlags.team,
		StatFlags.never_log,
	},
	triggers = {
		{
			id = "hook_collect_material",
			trigger = StatMacros.forward,
		},
	},
}

do
	local function material_increases(self, stat_data, type, amount)
		local desired_material = self.data.material

		if type == desired_material then
			return increment_by(self, stat_data, amount)
		end
	end

	for _, material in ipairs({
		"plasteel",
		"diamantine",
	}) do
		local total_id = string.format("total_%s_collected", material)

		stat_definitions[total_id] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				material = material,
			},
			triggers = {
				{
					id = "hook_collect_material",
					trigger = material_increases,
				},
			},
		}

		local team_id = string.format("team_%s_collected", material)

		stat_definitions[team_id] = {
			flags = {
				StatFlags.team,
			},
			data = {
				material = material,
			},
			triggers = {
				{
					id = "hook_collect_material",
					trigger = material_increases,
				},
			},
		}

		local seen_id = string.format("seen_%s_collected", material)

		stat_definitions[seen_id] = {
			flags = {
				StatFlags.team,
			},
			data = {
				material = material,
			},
			triggers = {
				{
					id = "team_collect_material",
					trigger = material_increases,
				},
			},
		}
	end
end

do
	local function _max_difficulty(self, stat_data, difficulty)
		return set_to_max(self, stat_data, difficulty)
	end

	stat_definitions.hook_mission_ended = {
		flags = {
			StatFlags.hook,
			StatFlags.team,
		},
	}
	stat_definitions.hook_fan_kill = {
		flags = {
			StatFlags.hook,
			StatFlags.team,
		},
	}
	stat_definitions.hook_bottle_kill = {
		flags = {
			StatFlags.hook,
			StatFlags.team,
		},
	}
	stat_definitions.mission_won = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_mission_ended",
				trigger = function (self, stat_data, won, ...)
					if won then
						return self.id, ...
					end
				end,
			},
		},
	}
	stat_definitions.mission_failed = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_mission_ended",
				trigger = function (self, stat_data, won, ...)
					if not won then
						return self.id, ...
					end
				end,
			},
		},
	}
	stat_definitions.whole_mission_won = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.forward,
			},
		},
		include_condition = function (self, config)
			return config.joined_at <= 0.2
		end,
	}
	stat_definitions.missions = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.increment,
			},
		},
	}
	stat_definitions.auric_missions = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					return increment(self, stat_data)
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_auric_mission
		end,
	}
	stat_definitions.personal_flawless_auric = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local personal_deaths = read_stat(stat_definitions.session_deaths, stat_data)

					if personal_deaths == 0 then
						return increment(self, stat_data)
					else
						return set_to_min(self, stat_data, 0)
					end
				end,
			},
			{
				id = "hook_death",
				trigger = function (self, stat_data)
					return set_to_min(self, stat_data, 0)
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_auric_mission and config.joined_at <= 0.2
		end,
	}
	stat_definitions.mission_maelstrom = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.increment,
			},
		},
		include_condition = function (self, config)
			return config.is_flash_mission
		end,
	}
	stat_definitions.mission_auric_maelstrom = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					return increment(self, stat_data)
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_flash_mission and config.is_auric_mission
		end,
	}
	stat_definitions.flawless_auric_maelstrom = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local team_knock_downs = read_stat(stat_definitions.team_knock_downs, stat_data)

					if team_knock_downs == 0 then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_auric_mission and config.difficulty >= 5
		end,
	}
	stat_definitions.flawless_auric_maelstrom_consecutive = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local personal_deaths = read_stat(stat_definitions.session_deaths, stat_data)

					if personal_deaths == 0 then
						return increment(self, stat_data)
					else
						return set_to_min(self, stat_data, 0)
					end
				end,
			},
			{
				id = "hook_death",
				trigger = function (self, stat_data)
					return set_to_min(self, stat_data, 0)
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_flash_mission and config.is_auric_mission and config.difficulty >= 5 and config.joined_at <= 0.2
		end,
	}
	stat_definitions.flawless_auric_maelstrom_won = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local team_knock_downs = read_stat(stat_definitions.team_knock_downs, stat_data)

					if team_knock_downs == 0 then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_flash_mission and config.is_auric_mission and config.difficulty >= 5
		end,
	}
	stat_definitions.mission_propaganda_fan_kills = {
		flags = {},
		data = {},
		triggers = {
			{
				id = "hook_fan_kill",
				trigger = StatMacros.increment,
			},
		},
		include_condition = function (self, config)
			return config.mission_name == "dm_propaganda"
		end,
	}
	stat_definitions.mission_raid_bottles_destroyed = {
		flags = {},
		data = {},
		triggers = {
			{
				id = "hook_bottle_kill",
				trigger = StatMacros.increment,
			},
		},
		include_condition = function (self, config)
			return config.mission_name == "cm_raid"
		end,
	}
	stat_definitions.mission_circumstance = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.increment,
			},
		},
		include_condition = function (self, config)
			return StatConfigMacros.has_circumstance(config)
		end,
	}
	stat_definitions.mission_twins = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = _max_difficulty,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return circumstance_name ~= nil and circumstance_name == "player_journey_010"
		end,
	}
	stat_definitions.mission_twins_hard_mode = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data, difficulty)
					local has_hard_mode = Managers.state.pacing:has_hard_mode()

					if has_hard_mode and difficulty >= 5 then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name
			local has_correct_circumstance = circumstance_name ~= nil and circumstance_name == "player_journey_010"

			return has_correct_circumstance
		end,
	}
	stat_definitions.mission_twins_secret_puzzle_trigger = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data, difficulty)
					local has_hard_mode = Managers.state.pacing:has_hard_mode()

					if has_hard_mode then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name
			local has_correct_circumstance = circumstance_name ~= nil and circumstance_name == "player_journey_010"

			return has_correct_circumstance
		end,
	}
	stat_definitions.mission_twins_kills_within_x = {
		flags = {
			StatFlags.always_log,
		},
		triggers = {
			{
				id = "hook_boss_died",
				trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
					if breed_name == "renegade_twin_captain" or breed_name == "renegade_twin_captain_two" then
						return increment(self, stat_data)
					end
				end,
			},
			{
				id = "hook_boss_died",
				trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
					if breed_name == "renegade_twin_captain" or breed_name == "renegade_twin_captain_two" then
						return decrement(self, stat_data)
					end
				end,
				delay = seconds(5),
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return circumstance_name and circumstance_name == "player_journey_010"
		end,
	}
	stat_definitions.mission_twins_killed_successfully_within_x = {
		running_stat = "mission_twins_kills_within_x",
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_twins_kills_within_x",
				trigger = function (self, stat_data, value)
					if value == 2 then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return circumstance_name and circumstance_name == "player_journey_010"
		end,
	}
	stat_definitions.hook_mission_twins_mine_triggered = {
		flags = {
			StatFlags.hook,
			StatFlags.team,
		},
	}
	stat_definitions.hook_mission_twins_boss_started_mine_intialized = {
		flags = {
			StatFlags.hook,
			StatFlags.team,
		},
	}
	stat_definitions.team_twins_boss_fight_started = {
		flags = {
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_mission_twins_boss_started_mine_intialized",
				trigger = function (self, stat_data)
					return set_to(self, stat_data, 1)
				end,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return circumstance_name and circumstance_name == "player_journey_010"
		end,
	}
	stat_definitions.mission_twins_mine_triggered_count = {
		default = 3,
		flags = {
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_mission_twins_mine_triggered",
				trigger = function (self, stat_data)
					local _boss_fight_started = read_stat(stat_definitions.team_twins_boss_fight_started, stat_data) == 1

					if _boss_fight_started then
						return decrement(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return circumstance_name and circumstance_name == "player_journey_010"
		end,
	}
	stat_definitions.mission_twins_no_mines_triggered = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					local track_mines = read_stat(stat_definitions.mission_twins_mine_triggered_count, stat_data) > 0

					if track_mines then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return circumstance_name and circumstance_name == "player_journey_010"
		end,
	}
	stat_definitions.team_knocked_down_timer_stat = {
		flags = {
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_health_update",
				trigger = function (self, stat_data, dt, remaining_health_segments, is_knocked_down)
					if is_knocked_down then
						return increment_by(self, stat_data, dt)
					end
				end,
			},
		},
	}
	stat_definitions.team_win_without_ally_downed_longer_then_x = {
		flags = {
			StatFlags.backend,
		},
		data = {
			threshold = 5,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local team_knock_downs = read_stat(stat_definitions.team_knock_downs, stat_data)

					if team_knock_downs < self.data.threshold then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			return config.difficulty >= 4
		end,
	}

	do
		local story_circumstances = table.filter_array(table.keys(CircumstanceTemplates), function (name)
			return table.nested_get(CircumstanceTemplates, name, "mission_overrides", "stat_settings", "story") == true
		end)

		table.sort(story_circumstances)

		for _, entry in ipairs(story_circumstances) do
			local stat_name = string.format("circumstance_%s_max_difficulty", entry)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.backend,
				},
				data = {
					circumstance_name = entry,
				},
				stat_name = CircumstanceTemplates[entry].ui.display_name,
				triggers = {
					{
						id = "whole_mission_won",
						trigger = _max_difficulty,
					},
				},
				include_condition = function (self, config)
					return self.data.circumstance_name == config.circumstance_name
				end,
			}
		end
	end

	do
		local circumstance_entries = {
			{
				mutator = "mutator_darkness_los",
				name = "darkness",
			},
			{
				mutator = "mutator_ventilation_purge_los",
				name = "ventilation",
			},
			{
				mutator = "mutator_toxic_gas_volumes",
				name = "toxic_gas",
			},
		}

		local function has_correct_mutator(self, config)
			local circumstance_name = config.circumstance_name
			local circumstance_mutators = CircumstanceTemplates[circumstance_name] and CircumstanceTemplates[circumstance_name].mutators

			return circumstance_mutators and table.array_contains(circumstance_mutators, self.data.mutator)
		end

		for _, entry in ipairs(circumstance_entries) do
			local stat_name = string.format("%s_circumstance_completed", entry.name)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.backend,
				},
				data = {
					mutator = entry.mutator,
				},
				triggers = {
					{
						id = "mission_won",
						trigger = StatMacros.increment,
					},
				},
				include_condition = has_correct_mutator,
			}
		end
	end

	for i = 1, #adventure_mission_types do
		local mission_type = adventure_mission_types[i]
		local stat_name = string.format("type_%s_missions", i)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				mission_type = mission_type.type,
			},
			triggers = {
				{
					id = "mission_won",
					trigger = StatMacros.increment,
				},
			},
			include_condition = function (self, config)
				return self.data.mission_type == config.mission_type
			end,
		}
	end

	for i = 1, #adventure_mission_types do
		local mission_type = adventure_mission_types[i]
		local stat_name = string.format("max_difficulty_%s_mission", i)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				mission_type = mission_type.type,
			},
			stat_name = mission_type.name,
			triggers = {
				{
					id = "mission_won",
					trigger = _max_difficulty,
				},
			},
			include_condition = function (self, config)
				return self.data.mission_type == config.mission_type
			end,
			init = function (self, stat_data)
				for difficulty = 5, 1, -1 do
					local old_id = string.format("_mission_difficulty_%s_objectives_%s_flag", difficulty, i)

					if stat_data[old_id] then
						return difficulty
					end
				end
			end,
		}
	end

	for i = 1, #mission_templates do
		local mission_name = mission_templates[i]
		local stat_name = string.format("__m_%s_md", mission_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				mission_name = mission_name,
			},
			triggers = {
				{
					id = "mission_won",
					trigger = _max_difficulty,
				},
			},
			include_condition = function (self, config)
				return self.data.mission_name == config.mission_name
			end,
		}
	end

	for i = 1, #mission_templates do
		local mission_name = mission_templates[i]

		for difficulty = 1, 5 do
			local stat_name = string.format("mission_%s_difficulty_%s", mission_name, difficulty)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.backend,
				},
				data = {
					mission_name = mission_name,
					difficulty = difficulty,
				},
				triggers = {
					{
						id = "mission_won",
						trigger = function (self, stat_data)
							return set_to_max(self, stat_data, 1)
						end,
					},
				},
				include_condition = function (self, config)
					return self.data.mission_name == config.mission_name and self.data.difficulty <= config.difficulty and not config.is_havoc
				end,
			}
		end
	end

	for i = 1, #mission_templates do
		local mission_name = mission_templates[i]

		for difficulty = 4, 5 do
			local stat_name = string.format("mission_%s_difficulty_%s_auric", mission_name, difficulty)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.backend,
				},
				data = {
					mission_name = mission_name,
					difficulty = difficulty,
				},
				triggers = {
					{
						id = "mission_won",
						trigger = function (self, stat_data)
							return set_to_max(self, stat_data, 1)
						end,
					},
				},
				include_condition = function (self, config)
					return self.data.mission_name == config.mission_name and self.data.difficulty <= config.difficulty and config.is_auric_mission and not config.is_havoc
				end,
			}
		end
	end

	for i = 1, #mission_zones do
		local zone_name = mission_zones[i]
		local stat_name = string.format("zone_%s_missions_completed", zone_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				zone_id = zone_name,
			},
			triggers = {
				{
					id = "mission_won",
					trigger = StatMacros.increment,
				},
			},
			include_condition = function (self, config)
				local is_hub = config.is_hub

				if is_hub then
					return false
				end

				return MissionTemplates[config.mission_name].zone_id == self.data.zone_id
			end,
		}
	end

	for i = 1, #archetype_names do
		local archetype_name = archetype_names[i]

		do
			local stat_name = string.format("missions_%s_2", archetype_name)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.backend,
				},
				data = {
					archetype_name = archetype_name,
				},
				triggers = {
					{
						id = "mission_won",
						trigger = StatMacros.increment,
					},
				},
				include_condition = function (self, config)
					return self.data.archetype_name == config.archetype_name
				end,
			}
		end

		for j = 1, #adventure_mission_types do
			local mission_type = adventure_mission_types[j]
			local stat_name = string.format("mission_type_%s_max_difficulty_%s", j, archetype_name)

			stat_definitions[stat_name] = {
				flags = {
					StatFlags.backend,
				},
				stat_name = mission_type.name,
				data = {
					mission_type = mission_type.type,
					archetype_name = archetype_name,
				},
				triggers = {
					{
						id = "mission_won",
						trigger = _max_difficulty,
					},
				},
				include_condition = function (self, config)
					local data = self.data
					local correct_mission_type = data.mission_type == config.mission_type
					local correct_archetype_name = data.archetype_name == config.archetype_name

					return correct_mission_type and correct_archetype_name
				end,
				init = function (self, stat_data)
					local data = self.data

					for difficulty = 3, 1, -1 do
						local old_id = string.format("_mission_%s_2_%s_objectives_%s_flag", data.archetype_name, difficulty, j)

						if stat_data[old_id] then
							return difficulty
						end
					end
				end,
			}
		end

		for difficulty = 1, 5 do
			local stat_id = string.format("missions_%s_2_difficulty_%s", archetype_name, difficulty)

			stat_definitions[stat_id] = {
				flags = {
					StatFlags.backend,
				},
				data = {
					archetype_name = archetype_name,
					difficulty = difficulty,
				},
				triggers = {
					{
						id = "mission_won",
						trigger = StatMacros.increment,
					},
				},
				include_condition = function (self, config)
					local data = self.data
					local correct_difficulty = config.difficulty >= data.difficulty
					local correct_archetype_name = config.archetype_name == data.archetype_name

					return correct_difficulty and correct_archetype_name
				end,
			}
		end
	end

	stat_definitions._flawless_missions_in_a_row = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local session_deaths = read_stat(stat_definitions.session_deaths, stat_data)
					local session_knock_downs = read_stat(stat_definitions.session_knock_downs, stat_data)

					if session_deaths == 0 and session_knock_downs == 0 then
						return increment(self, stat_data)
					else
						return set_to_min(self, stat_data, 0)
					end
				end,
			},
			{
				id = "hook_knocked_down",
				trigger = function (self, stat_data)
					return set_to_min(self, stat_data, 0)
				end,
			},
			{
				id = "hook_death",
				trigger = function (self, stat_data)
					return set_to_min(self, stat_data, 0)
				end,
			},
		},
		include_condition = function (self, config)
			return config.difficulty >= 3 and config.joined_at <= 0.2
		end,
		init = function (self, stat_data)
			return math.max(stat_data.flawless_missions_in_a_row or 0, stat_data.flawless_mission_in_a_row or 0)
		end,
	}
	stat_definitions.max_flawless_mission_in_a_row = {
		running_stat = "_flawless_missions_in_a_row",
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "_flawless_missions_in_a_row",
				trigger = StatMacros.set_to_max,
			},
		},
	}
	stat_definitions.team_flawless_missions = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local team_downs = read_stat(stat_definitions.team_knock_downs, stat_data)

					if team_downs == 0 then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.lowest_damage_taken_on_win = {
		default = 9999,
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local damage_taken = read_stat(stat_definitions.session_damage_taken, stat_data)

					return set_to_min(self, stat_data, damage_taken)
				end,
			},
		},
	}
	stat_definitions.havoc_weekly_rewards_received = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.havoc_missions = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					return increment(self, stat_data)
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_havoc
		end,
	}
	stat_definitions.havoc_win_assisted = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.increment,
			},
		},
		include_condition = function (self, config)
			return config.is_havoc and config.havoc_order_owner ~= config.account_id
		end,
	}

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

	for i = 1, #havoc_rank_thresholds do
		local required_rank = havoc_rank_thresholds[i]
		local stat_name = string.format("havoc_rank_reached_0%s", i)

		stat_definitions[stat_name] = {
			flags = {},
			data = {
				required_rank = required_rank,
			},
			triggers = {
				{
					id = "mission_won",
					trigger = function (self, stat_data)
						return increment(self, stat_data)
					end,
				},
			},
			include_condition = function (self, config)
				return config.is_havoc and self.data.required_rank <= config.havoc_rank
			end,
		}
	end

	stat_definitions.flawless_havoc_won = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "whole_mission_won",
				trigger = function (self, stat_data)
					local team_deaths = read_stat(stat_definitions.team_deaths, stat_data)
					local team_knock_downs = read_stat(stat_definitions.team_knock_downs, stat_data)

					if team_knock_downs == 0 and team_deaths == 0 then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			return config.is_havoc and config.havoc_rank >= 35
		end,
	}
end

stat_definitions.hook_lunge_start = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_lunge_stop = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_lunge_distance = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.is_lunging = {
	flags = {
		StatFlags.no_sync,
		StatFlags.no_recover,
		StatFlags.never_log,
	},
	triggers = {
		{
			id = "hook_lunge_start",
			trigger = function (self, stat_data)
				return set_to_max(self, stat_data, 1)
			end,
		},
		{
			id = "hook_lunge_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end,
		},
	},
}
stat_definitions.hook_coherency_toughness_regenerated = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log,
	},
}
stat_definitions.hook_lounge_toughness_regenerated = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log,
	},
}
stat_definitions.hook_melee_kill_toughness_regenerated = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log,
	},
}
stat_definitions.hook_toughness_broken = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.total_coherency_toughness = {
	flags = {
		StatFlags.backend,
		StatFlags.never_log,
	},
	data = {
		cap = 2000,
	},
	triggers = {
		{
			id = "hook_coherency_toughness_regenerated",
			trigger = function (self, stat_data, amount)
				local id = self.id
				local current_value = stat_data[id] or self.default
				local cap = self.data.cap

				if current_value < cap then
					stat_data[id] = math.min(current_value + amount, cap)

					return id, stat_data[id]
				end
			end,
		},
	},
}
stat_definitions.total_melee_toughness_regen = {
	flags = {
		StatFlags.backend,
	},
	data = {
		cap = 40000,
	},
	triggers = {
		{
			id = "hook_melee_kill_toughness_regenerated",
			trigger = function (self, stat_data, amount)
				local id = self.id
				local current_value = stat_data[id] or self.default
				local cap = self.data.cap

				if current_value < cap then
					stat_data[id] = math.min(current_value + amount, cap)

					return id, stat_data[id]
				end
			end,
		},
	},
}

do
	local valid_chaos_hound_breeds = {
		chaos_hound = true,
	}

	stat_definitions.poxhound_pushed_mid_air = {
		flags = {
			StatFlags.backend,
		},
		data = {
			cap = 50,
		},
		triggers = {
			{
				id = "hook_damage_dealt",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local attack_type = attack_data.attack_type
					local action = attack_data.target_action
					local id = self.id
					local current_value = stat_data[id] or self.default

					if current_value >= self.data.cap then
						return
					end

					if valid_chaos_hound_breeds[breed_name] and action == "leap" and attack_type == "push" then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.trapper_net_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged)
					if breed_name == "renegade_netgunner" and not previously_dodged then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.sniper_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged)
					if breed_name == "renegade_sniper" and attacker_action == "shoot" and not previously_dodged then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.shotgunner_spread_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged)
					if (breed_name == "cultist_shocktrooper" or breed_name == "renegade_shocktrooper") and not previously_dodged then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}

	local valid_mutant_breeds = {
		cultist_mutant = true,
	}

	stat_definitions.mutant_charge_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged)
					if valid_mutant_breeds[breed_name] and attacker_action == "charge" and not previously_dodged then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.mauler_attack_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged)
					if breed_name == "renegade_executor" and (attacker_action == "moving_melee_cleave_attack" or attacker_action == "melee_cleave_attack") and not previously_dodged then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.crusher_overhead_smash_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged)
					if breed_name == "chaos_ogryn_executor" and (attacker_action == "moving_melee_attack_cleave" or attacker_action == "melee_attack_cleave") and not previously_dodged then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.bulwark_backstab_damage_inflicted = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_damage_dealt",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local damage_amount = attack_data.damage_dealt
					local is_backstab = attack_data.is_backstab

					if is_backstab and breed_name == "chaos_ogryn_bulwark" then
						return increment_by(self, stat_data, damage_amount)
					end
				end,
			},
		},
	}

	local valid_human_gunner_breeds = {
		cultist_gunner = true,
		renegade_gunner = true,
	}

	stat_definitions.cultist_gunner_shot_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
					if attack_type == "ranged" and valid_human_gunner_breeds[breed_name] and (dodge_type == "sprint" or dodge_type == "slide") then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}

	local valid_ogryn_gunner_breeds = {
		chaos_ogryn_gunner = true,
	}

	stat_definitions.ogryn_gunner_shot_dodged = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_id)
					if valid_ogryn_gunner_breeds[breed_name] and attack_type == "ranged" and (dodge_type == "sprint" or dodge_type == "slide") then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}

	local valid_grenadier_breeds = {
		cultist_grenadier = true,
		renegade_grenadier = true,
	}

	stat_definitions.grenadier_killed_before_attack_occurred = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name

					if valid_grenadier_breeds[breed_name] then
						local target_blackboard = attack_data.target_blackboard

						if not target_blackboard then
							return
						end

						local num_attacked = target_blackboard.statistics.num_attacks_done

						if num_attacked <= 0 then
							return increment(self, stat_data)
						end
					end
				end,
			},
		},
	}

	local valid_flamer_breeds = {
		cultist_flamer = true,
		renegade_flamer = true,
	}

	stat_definitions.flamer_killed_before_attack_occurred = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name

					if valid_flamer_breeds[breed_name] then
						local target_blackboard = attack_data.target_blackboard

						if not target_blackboard then
							return
						end

						local num_attacked = target_blackboard.statistics.num_attacks_done

						if num_attacked <= 0 then
							return increment(self, stat_data)
						end
					end
				end,
			},
		},
	}
	stat_definitions.team_poxburster_damage_avoided = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_team_explosion",
				trigger = function (self, stat_data, explosion_template, explosion_data)
					if explosion_template.name == "poxwalker_bomber" then
						local hits = explosion_data.result

						for i = 2, #hits, 2 do
							local breed_or_nil = hits[i]

							if breed_or_nil and breed_or_nil.breed_type == "player" then
								return
							end
						end

						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.team_chaos_spawned_killed_no_players_grabbed = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_boss_died",
				trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage, attack_data)
					if attack_data.target_breed_name == "chaos_spawn" then
						local target_blackboard = attack_data.target_blackboard

						if not target_blackboard then
							return
						end

						local num_grabs = target_blackboard.statistics.num_grabs_done

						if num_grabs <= 0 then
							return increment(self, stat_data)
						end
					end
				end,
			},
		},
	}
	stat_definitions.team_chaos_beast_of_nurgle_slain_no_corruption = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_boss_died",
				trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage, attack_data)
					if attack_data.target_breed_name == "chaos_beast_of_nurgle" then
						local target_blackboard = attack_data.target_blackboard

						if not target_blackboard then
							return
						end

						local num_in_liquid = target_blackboard.statistics.num_in_liquid

						if num_in_liquid <= 0 then
							return increment(self, stat_data)
						end
					end
				end,
			},
		},
	}
	stat_definitions.enemies_killed_with_barrels = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_explosion",
				trigger = function (self, stat_data, explosion_template, explosion_data)
					if explosion_template.name == "explosive_barrel" or explosion_template.name == "fire_barrel" then
						local killed_units = 0
						local hits = explosion_data.result

						for i = 1, #hits, 2 do
							local health_result = hits[i]

							if health_result and health_result == "died" then
								killed_units = killed_units + 1
							end
						end

						return increment_by(self, stat_data, killed_units)
					end
				end,
			},
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local damage_profile_name = attack_data.damage_profile_name

					if damage_profile_name == "liquid_area_fire_burning_barrel" then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.enemies_killed_with_poxburster_explosion = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_explosion",
				trigger = function (self, stat_data, explosion_template, explosion_data)
					if explosion_template.name == "poxwalker_bomber" then
						local killed_units = 0
						local hits = explosion_data.result

						for i = 1, #hits, 2 do
							local health_result = hits[i]

							if health_result and health_result == "died" then
								killed_units = killed_units + 1
							end
						end

						if killed_units >= 1 then
							killed_units = killed_units - 1
						end

						return increment_by(self, stat_data, killed_units)
					end
				end,
			},
		},
	}
end

stat_definitions.hook_picked_up_item = {
	flags = {
		StatFlags.hook,
		StatFlags.always_log,
	},
}
stat_definitions.hook_placed_item = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_collect_collectible = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_team_chest_opened = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.hook_health_station_interaccion_success = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_objective_side_incremented_progression = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.hook_game_mode_survival_island_completed = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.hook_game_mode_survival_class_completed = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_game_mode_survival_game_end = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.hook_game_mode_survival_waves_completed = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.hook_game_mode_mcguffins_returned = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}

do
	local vo_stats = {
		{
			name = "hook_backstory_morrow_part_",
			num_parts = 11,
		},
		{
			name = "hook_backstory_zola_part_",
			num_parts = 9,
		},
		{
			name = "hook_backstory_brahms_part_",
			num_parts = 10,
		},
		{
			name = "hook_backstory_zorin_part_",
			num_parts = 2,
		},
	}

	for i = 1, #vo_stats do
		local character = vo_stats[i]

		for j = 1, character.num_parts do
			local name = vo_stats[i].name .. j

			stat_definitions[name] = {
				flags = {
					StatFlags.hook,
					StatFlags.team,
				},
			}
		end
	end

	stat_definitions.hook_on_syringe_use = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_red_stimm_deactivated = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_red_stimm_active = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_blue_stimm_deactivated = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_blue_stimm_active = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_green_stimm_corruption_healed = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_ability_time_saved_by_yellow_stimm = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.total_syringes_used = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_on_syringe_use",
				trigger = StatMacros.increment,
			},
		},
	}

	local _syringe_data = {
		{
			color = "green",
			loc_var = "loc_pickup_pocketable_01",
			pickup_name = "syringe_corruption_pocketable",
		},
		{
			color = "red",
			loc_var = "loc_pickup_syringe_pocketable_03",
			pickup_name = "syringe_power_boost_pocketable",
		},
		{
			color = "blue",
			loc_var = "loc_pickup_syringe_pocketable_04",
			pickup_name = "syringe_speed_boost_pocketable",
		},
		{
			color = "yellow",
			loc_var = "loc_pickup_syringe_pocketable_02",
			pickup_name = "syringe_ability_boost_pocketable",
		},
		{
			color = "broker",
			loc_var = "loc_pickup_syringe_pocketable_02",
			pickup_name = "syringe_ability_boost_pocketable",
		},
	}

	for i = 1, #_syringe_data do
		local syringe_type = _syringe_data[i]
		local color = syringe_type.color
		local localization_key = syringe_type.loc_var
		local stat_name = string.format("%s_syringe_used", color)

		stat_definitions[stat_name] = {
			flags = {},
			data = {
				pickup_name = syringe_type.pickup_name,
			},
			stat_name = localization_key,
			triggers = {
				{
					id = "hook_on_syringe_use",
					trigger = function (self, stat_data, syringe_data)
						local syringe_name = syringe_data.pickup_name

						if syringe_name == self.data.pickup_name then
							return set_to_max(self, stat_data, 1)
						end
					end,
				},
			},
		}
	end

	stat_definitions.red_stimm_active_status = {
		flags = {},
		data = {},
		triggers = {
			{
				id = "hook_red_stimm_active",
				trigger = function (self, stat_data, item_name)
					return set_to_max(self, stat_data, 1)
				end,
			},
			{
				id = "hook_red_stimm_deactivated",
				trigger = function (self, stat_data, item_name)
					return set_to_min(self, stat_data, 0)
				end,
			},
		},
	}
	stat_definitions.total_kills_gained_while_using_red_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {
			breed_lookup = special_and_elite_breed_lookup,
		},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local breed_name = attack_data.target_breed_name
					local breed_lookup = self.data.breed_lookup

					if not breed_lookup[breed_name] then
						return
					end

					local red_stim_active = read_stat(stat_definitions.red_stimm_active_status, stat_data) == 1

					if red_stim_active then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.corruption_healed_with_green_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_green_stimm_corruption_healed",
				trigger = function (self, stat_data, amount_healed)
					return increment_by(self, stat_data, amount_healed)
				end,
			},
		},
	}
	stat_definitions.ability_time_saved_by_yellow_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_ability_time_saved_by_yellow_stimm",
				trigger = function (self, stat_data, time_reduced)
					return increment_by(self, stat_data, time_reduced)
				end,
			},
		},
	}
	stat_definitions.blue_stimm_active_status = {
		flags = {},
		data = {},
		triggers = {
			{
				id = "hook_blue_stimm_active",
				trigger = function (self, stat_data, item_name)
					return set_to_max(self, stat_data, 1)
				end,
			},
			{
				id = "hook_blue_stimm_deactivated",
				trigger = function (self, stat_data, item_name)
					return set_to_min(self, stat_data, 0)
				end,
			},
		},
	}
	stat_definitions.total_kills_gained_while_using_blue_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local blue_stim_active = read_stat(stat_definitions.blue_stimm_active_status, stat_data) == 1

					if blue_stim_active then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.total_deployables_placed = {
		flags = {
			StatFlags.backend,
		},
		data = {
			item_lookup = table.set({
				"medical_crate_deployable",
				"ammo_cache_deployable",
			}),
		},
		triggers = {
			{
				id = "hook_placed_item",
				trigger = function (self, stat_data, item_name)
					local item_lookup = self.data.item_lookup

					if item_lookup[item_name] then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.collectibles_picked_up = {
		flags = {},
		triggers = {
			{
				id = "hook_collect_collectible",
				trigger = StatMacros.increment,
			},
		},
	}

	for i = 1, #mission_templates do
		local mission_name = mission_templates[i]
		local stat_name = string.format("mission_%s_collectible", mission_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				mission_name = mission_name,
			},
			triggers = {
				{
					id = "mission_won",
					trigger = function (self, stat_data)
						local track_collectible = read_stat(stat_definitions.collectibles_picked_up, stat_data) >= 1

						if track_collectible then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = function (self, config)
				return self.data.mission_name == config.mission_name
			end,
		}
	end

	stat_definitions.chest_opened = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "hook_team_chest_opened",
				trigger = StatMacros.increment,
			},
		},
	}
	stat_definitions.grimoire_carried = {
		flags = {
			StatFlags.team,
		},
		data = {},
		triggers = {
			{
				id = "hook_objective_side_incremented_progression",
				trigger = function (self, stat_data, objective_name, value)
					if objective_name == "side_mission_grimoire" then
						return set_to(self, stat_data, value)
					end
				end,
			},
		},
	}
	stat_definitions.grimoire_delivered = {
		flags = {
			StatFlags.team,
			StatFlags.no_sync,
		},
		data = {},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					local grimoire_count = read_stat(stat_definitions.grimoire_carried, stat_data)

					if grimoire_count >= 1 then
						return self.id, grimoire_count
					end
				end,
			},
		},
	}
	stat_definitions.grimoire_recovered_mission_won = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "grimoire_delivered",
				trigger = StatMacros.increment_by,
			},
		},
	}
	stat_definitions.scriptures_carried = {
		flags = {
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_objective_side_incremented_progression",
				trigger = function (self, stat_data, objective_name, value)
					if objective_name == "side_mission_tome" then
						return set_to(self, stat_data, value)
					end
				end,
			},
		},
	}
	stat_definitions.scriptures_delivered = {
		flags = {
			StatFlags.team,
			StatFlags.no_sync,
		},
		data = {},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					local scriptures_count = read_stat(stat_definitions.scriptures_carried, stat_data)

					if scriptures_count >= 1 then
						return self.id, scriptures_count
					end
				end,
			},
		},
	}
	stat_definitions.side_communication_hack_device_completed = {
		flags = {
			StatFlags.team,
		},
		triggers = {
			{
				id = "hook_objective_side_incremented_progression",
				trigger = function (self, stat_data, objective_name, value)
					if objective_name == "side_mission_hack_communications" then
						return set_to(self, stat_data, value)
					end
				end,
			},
		},
	}
	stat_definitions.side_communication_hack_device_end_of_round = {
		flags = {
			StatFlags.team,
			StatFlags.no_sync,
		},
		data = {},
		triggers = {
			{
				id = "mission_won",
				trigger = function (self, stat_data)
					local minigame_complete_count = read_stat(stat_definitions.side_communication_hack_device_completed, stat_data)

					if minigame_complete_count >= 1 then
						return set_to(self, stat_data, minigame_complete_count)
					end
				end,
			},
		},
	}
	stat_definitions.scripture_recovered_mission_won = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "scriptures_delivered",
				trigger = StatMacros.increment_by,
			},
		},
	}
end

stat_definitions.hook_assist_ally = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_rescue_ally = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.total_player_rescues = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_rescue_ally",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.total_player_assists = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_assist_ally",
			trigger = function (self, stat_data, target_id, assistance_type)
				if assistance_type == "revive" then
					return increment(self, stat_data)
				end
			end,
		},
	},
}
stat_definitions.hook_escaped_captivitiy = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.longest_time_spent_in_captivity = {
	flags = {},
	triggers = {
		{
			id = "hook_escaped_captivitiy",
			trigger = function (self, stat_data, state_name, time_disabled)
				return set_to_max(self, stat_data, time_disabled)
			end,
		},
	},
}
stat_definitions.team_longest_time_spent_in_captivity = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "longest_time_spent_in_captivity",
			trigger = StatMacros.set_to_max,
		},
	},
}
stat_definitions.session_time_spent_in_captivity = {
	flags = {},
	triggers = {
		{
			id = "hook_escaped_captivitiy",
			trigger = function (self, stat_data, state_name, time_disabled)
				return increment_by(self, stat_data, time_disabled)
			end,
		},
	},
}
stat_definitions.different_players_rescued = {
	flags = {
		StatFlags.no_sync,
		StatFlags.team,
	},
	triggers = {
		{
			id = "hook_rescue_ally",
			trigger = function (self, stat_data, rescued_player_id)
				local id = self.id
				local data = stat_data[id] or {}

				stat_data[id] = data

				if not data[rescued_player_id] then
					data[rescued_player_id] = true

					return id, rescued_player_id
				end
			end,
		},
	},
}
stat_definitions.amount_different_players_rescued = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "different_players_rescued",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.max_different_players_rescued = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "mission_won",
			trigger = function (self, stat_data, difficulty)
				local amount_different_players_rescued = read_stat(stat_definitions.amount_different_players_rescued, stat_data)

				return set_to_max(self, stat_data, amount_different_players_rescued)
			end,
		},
	},
}
stat_definitions.hook_coherency_update = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log,
	},
}
stat_definitions.session_time_coherency = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_coherency_update",
			trigger = function (self, stat_data, time_since_update, units_in_coherency)
				if units_in_coherency > 1 then
					return increment_by(self, stat_data, time_since_update)
				end
			end,
		},
	},
}
stat_definitions.hook_sweep_finished = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.hook_scan = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.total_scans = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_scan",
			trigger = function (self, stat_data, amount)
				return increment(self, stat_data)
			end,
		},
	},
}
stat_definitions.hook_hack = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.total_hacks = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_hack",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.perfect_hacks = {
	flags = {
		StatFlags.backend,
	},
	triggers = {
		{
			id = "hook_hack",
			trigger = function (self, stat_data, mistakes)
				if mistakes == 0 then
					return increment(self, stat_data)
				end
			end,
		},
	},
}
stat_definitions.mission_destructible_destroyed = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}

for i = 1, #mission_zones do
	local zone_name = mission_zones[i]
	local stat_name = string.format("zone_%s_destructible", zone_name)

	stat_definitions[stat_name] = {
		flags = {
			StatFlags.backend,
		},
		data = {
			zone_name = zone_name,
		},
		triggers = {
			{
				id = "mission_destructible_destroyed",
				trigger = StatMacros.increment,
			},
		},
		include_condition = function (self, config)
			return not config.is_hub and MissionTemplates[config.mission_name].zone_id == self.data.zone_name
		end,
	}
end

stat_definitions.total_destructibles_destroyed = {
	flags = {
		StatFlags.backend,
	},
	data = {},
	triggers = {
		{
			id = "mission_destructible_destroyed",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.hook_ammo_consumed = {
	flags = {
		StatFlags.hook,
	},
}
stat_definitions.remaining_primary_ammo = {
	default = 0,
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "hook_ammo_consumed",
			trigger = function (self, stat_data, wielded_slot, ammo_usage, current_clip_ammo, current_ammo_reserve)
				local total_ammo = current_clip_ammo + current_ammo_reserve

				if wielded_slot == "slot_primary" then
					local id = self.id

					stat_data[id] = total_ammo

					return id, total_ammo
				end
			end,
		},
	},
}
stat_definitions.remaining_secondary_ammo = {
	default = 0,
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "hook_ammo_consumed",
			trigger = function (self, stat_data, wielded_slot, ammo_usage, current_clip_ammo, current_ammo_reserve)
				local total_ammo = current_clip_ammo + current_ammo_reserve

				if wielded_slot == "slot_secondary" then
					local id = self.id

					stat_data[id] = total_ammo

					return id, total_ammo
				end
			end,
		},
	},
}

do
	local special_and_elite_breed_groups = AchievementBreedGroups.special_and_elite_breed_lookup

	for i = 1, #special_and_elite_breed_groups do
		local breed_group_data = special_and_elite_breed_groups[i]
		local breed_group_name = breed_group_data.name
		local breeds_in_group = breed_group_data.breeds_in_group
		local stat_name = string.format("x_amount_of_%s_killed", breed_group_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				target_breed_names = breeds_in_group,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local target_breed_names = self.data.target_breed_names
						local target_breed = attack_data.target_breed_name

						if target_breed_names[target_breed] then
							return increment(self, stat_data)
						end
					end,
				},
			},
		}
	end

	stat_definitions.total_renegade_grenadier_melee = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "renegade_grenadier_killed",
				trigger = function (self, stat_data, attack_data)
					local attack_type = attack_data.attack_type

					if attack_type == "melee" then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.id_of_renegade_executors_hit_by_weakspot = {
		default = false,
		flags = {
			StatFlags.no_sync,
			StatFlags.team,
		},
		triggers = {
			{
				id = "renegade_executor_damaged",
				trigger = function (self, stat_data, attack_data)
					local target_id = attack_data.target_unit_id

					if not target_id then
						return
					end

					local id = self.id

					stat_data[id] = stat_data[id] or {}

					local data = stat_data[id]
					local current_value = data[target_id] or self.default

					if current_value then
						return
					end

					if is_weakspot_hit(attack_data) then
						data[target_id] = true

						return id, target_id, data[target_id]
					end
				end,
			},
		},
	}
	stat_definitions.total_renegade_executors_non_headshot = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "renegade_executor_killed",
				trigger = function (self, stat_data, attack_data)
					local target_id = attack_data.target_unit_id
					local weakspot_hits = stat_data.id_of_renegade_executors_hit_by_weakspot
					local has_been_hit = weakspot_hits and weakspot_hits[target_id]

					if has_been_hit then
						return
					end

					if is_weakspot_hit(attack_data) then
						return
					end

					return increment(self, stat_data)
				end,
			},
		},
	}
	stat_definitions.total_cultist_berzerker_head = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "cultist_berzerker_killed",
				trigger = function (self, stat_data, attack_data)
					local hit_zone_name = attack_data.hit_zone_name

					if hit_zone_name == "head" then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}
	stat_definitions.total_ogryn_gunner_melee = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "chaos_ogryn_gunner_killed",
				trigger = function (self, stat_data, attack_data)
					local attack_type = attack_data.attack_type

					if attack_type == "melee" then
						return increment(self, stat_data)
					end
				end,
			},
		},
	}

	local valid_daemonhost_breeds = {
		chaos_daemonhost = true,
	}

	stat_definitions.kill_daemonhost = {
		flags = {
			StatFlags.backend,
		},
		triggers = {
			{
				id = "hook_boss_died",
				trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
					if valid_daemonhost_breeds[breed_name] then
						return set_to_max(self, stat_data, 1)
					end
				end,
			},
		},
	}
end

do
	local function archetype_include_condition(archetype_name)
		return function (self, config)
			local data = self.data
			local required_difficulty = data.difficulty
			local correct_archetype_name = config.archetype_name == archetype_name
			local correct_difficulty = required_difficulty == nil or required_difficulty <= config.difficulty
			local correct_session_type = data.private_session == nil or config.private_session

			return correct_archetype_name and correct_difficulty and correct_session_type
		end
	end

	do
		local include_condition = archetype_include_condition("veteran")

		stat_definitions.hook_volley_fire_start = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_volley_fire_stop = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_ammo_given = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_kill_volley_fire_target = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_infiltrate_stagger = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_voice_of_command_toughness_given = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_focus_fire_max_stacks = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_focus_fire_max_reset = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_improved_tag = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_weapon_switch_keystone = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_damage_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_movement_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_veteran_units_engulfed_smoke = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.volley_fire_active = {
			flags = {
				StatFlags.no_sync,
				StatFlags.no_recover,
				StatFlags.never_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_volley_fire_start",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_volley_fire_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.weakspot_hit_during_volley_fire_alternate_fire = {
			flags = {},
			data = {},
			triggers = {
				{
					id = "shot_hit_weakspot",
					trigger = function (self, stat_data)
						local volley_fire_active = read_stat(stat_definitions.volley_fire_active, stat_data) == 1
						local alternate_fire_active = read_stat(stat_definitions.alternate_fire_active, stat_data) == 1

						if volley_fire_active and alternate_fire_active then
							return increment(self, stat_data)
						end
					end,
				},
				{
					id = "shot_missed_weakspot",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
				{
					id = "hook_volley_fire_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_weakspot_hit_during_volley_fire_alternate_fire = {
			running_stat = "weakspot_hit_during_volley_fire_alternate_fire",
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "weakspot_hit_during_volley_fire_alternate_fire",
					trigger = StatMacros.set_to_max,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_veteran_2_kills_with_last_round_in_mag = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_ranged_attack_concluded",
					trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
						if last_round_in_mag and killing_blow then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_melee_damage_taken = {
			flags = {},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_damage_taken",
					trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
						if attack_type == "melee" then
							return increment_by(self, stat_data, damage_dealt)
						end
					end,
				},
			},
		}
		stat_definitions.veteran_min_melee_damage_taken = {
			default = 999,
			running_stat = "veteran_melee_damage_taken",
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data)
						local damage_taken = read_stat(stat_definitions.veteran_melee_damage_taken, stat_data)

						return set_to_min(self, stat_data, damage_taken)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.elite_weakspot_kill_during_volley_fire_alternate_fire = {
			flags = {},
			data = {
				difficulty = 4,
				breed_lookup = volley_fire_target_breed_lookup,
			},
			triggers = {
				{
					id = "head_shot_kill",
					trigger = function (self, stat_data, attack_data)
						local breed_name = attack_data.target_breed_name

						if self.data.breed_lookup[breed_name] then
							return increment(self, stat_data)
						end
					end,
				},
				{
					id = "hook_volley_fire_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_elite_weakspot_kill_during_volley_fire_alternate_fire = {
			running_stat = "elite_weakspot_kill_during_volley_fire_alternate_fire",
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "elite_weakspot_kill_during_volley_fire_alternate_fire",
					trigger = StatMacros.set_to_max,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_accuracy_at_end_of_mission_with_no_ammo_left = {
			running_stat = "accuracy",
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data)
						local accuracy = read_stat(stat_definitions.accuracy, stat_data)
						local remaining_secondary_ammo = read_stat(stat_definitions.remaining_secondary_ammo, stat_data)

						if remaining_secondary_ammo == 0 then
							return set_to_max(self, stat_data, accuracy)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_2_weakspot_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "head_shot_kill",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_2_ammo_given = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_veteran_ammo_given",
					trigger = function (self, stat_data, ammo_given)
						return increment_by(self, stat_data, ammo_given)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_team_damage_amplified = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_veteran_damage_aura",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_team_movement_amplifed = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_veteran_movement_aura",
					trigger = function (self, stat_data, distance)
						return increment_by(self, stat_data, distance)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_infiltrate_stagger = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_veteran_infiltrate_stagger",
					trigger = function (self, stat_data, count)
						return increment_by(self, stat_data, count)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_voice_of_command_toughness_given = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_voice_of_command_toughness_given",
					trigger = function (self, stat_data, count)
						return increment_by(self, stat_data, count)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.focus_fire_max_stacks_active = {
			flags = {
				StatFlags.no_sync,
				StatFlags.no_recover,
				StatFlags.never_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_focus_fire_max_stacks",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_focus_fire_max_reset",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.kills_during_max_focus_fire_stack = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data)
						local track_focus_status = read_stat(stat_definitions.focus_fire_max_stacks_active, stat_data) == 1

						if track_focus_status then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_krak_grenade_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = armor_breeds,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local weapon_name = attack_data.weapon_template_name
						local breed_name = attack_data.target_breed_name
						local data = self.data

						if data.breed_lookup[breed_name] and weapon_name == "krak_grenade" then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_smoke_grenade_engulfed = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_veteran_units_engulfed_smoke",
					trigger = function (self, stat_data, num_engulfed)
						return increment_by(self, stat_data, num_engulfed)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_kills_with_improved_tag = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_veteran_improved_tag",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_weapon_switch_passive_keystone_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_veteran_weapon_switch_keystone",
					trigger = function (self, stat_data, params)
						local breed_name = params.breed_name
						local breed_lookup = self.data.breed_lookup

						if breed_lookup[breed_name] and params.hit_weakspot == true then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_2_kill_volley_fire_target_malice = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_veteran_kill_volley_fire_target",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_2_long_range_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
				distance = 30,
				breed_lookup = ranged_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local distance = attack_data.distance_between_units
						local breed_name = attack_data.target_breed_name
						local data = self.data
						local required_distance = data.distance

						if data.breed_lookup[breed_name] and required_distance <= distance then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.elite_or_special_kills_during_current_volley_fire = {
			flags = {
				StatFlags.no_recover,
				StatFlags.no_sync,
			},
			data = {
				difficulty = 4,
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed_name = attack_data.target_breed_name
						local breed_lookup = self.data.breed_lookup

						if not breed_lookup[breed_name] then
							return
						end

						local volley_fire_active = read_stat(stat_definitions.volley_fire_active, stat_data)

						if volley_fire_active then
							return increment(self, stat_data)
						end
					end,
				},
				{
					id = "hook_volley_fire_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_multiple_elite_or_special_kills_during_volley_fire_heresy = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "elite_or_special_kills_during_current_volley_fire",
					trigger = function (self, stat_data, amount)
						if amount == 2 then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.veteran_2_extended_volley_fire_duration = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
				time = 20,
			},
			triggers = {
				{
					id = "hook_volley_fire_stop",
					trigger = function (self, stat_data, volley_fire_tota_time)
						local required_time = self.data.time

						if required_time <= volley_fire_tota_time then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
	end

	do
		local include_condition = archetype_include_condition("zealot")

		stat_definitions.hook_zealot_health_leeched_during_resist_death = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_martyrdom_stacks = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_shroudfield_start = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_shroudfield_stop = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_chorus_toughness_restored = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_fanatic_rage_start = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_fanatic_rage_stop = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_movement_keystone_start = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_movement_keystone_stop = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_corruption_healed_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_toughness_reduced_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_loner_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_zealot_engulfed_enemies = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.last_seen_martyrdom_stacks = {
			flags = {
				StatFlags.never_log,
				StatFlags.no_sync,
				StatFlags.no_recover,
			},
			data = {},
			triggers = {
				{
					id = "hook_martyrdom_stacks",
					trigger = function (self, stat_data, stacks)
						local id = self.id

						stat_data[id] = stacks

						return id, stacks
					end,
				},
			},
		}
		stat_definitions.max_zealot_2_stagger_sniper_with_grenade_distance = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_damage_dealt",
					trigger = function (self, stat_data, attack_data)
						local breed_name = attack_data.target_breed_name
						local weapon_name = attack_data.weapon_template_name

						if breed_name == "renegade_sniper" and weapon_name == "shock_grenade" then
							local distance = attack_data.distance_between_units

							return set_to_max(self, stat_data, distance)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zelot_2_kill_mutant_charger_with_melee_while_dashing = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed_name = attack_data.target_breed_name
						local attack_type = attack_data.attack_type

						if breed_name ~= "cultist_mutant" or attack_type ~= "melee" then
							return
						end

						local is_lunging = read_stat(stat_definitions.is_lunging, stat_data) == 1

						if not is_lunging then
							return
						end

						return increment(self, stat_data)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_shocked_kill = {
			flags = {
				StatFlags.never_log,
				StatFlags.no_sync,
				StatFlags.no_recover,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local buffs = attack_data.target_buff_keywords

						if buffs and buffs.shock_grenade_shock then
							return self.id, attack_data
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_kills_of_shocked_enemies_last_15 = {
			flags = {
				StatFlags.no_recover,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "zealot_shocked_kill",
					trigger = StatMacros.increment,
				},
				{
					delay = 10,
					id = "zealot_shocked_kill",
					trigger = StatMacros.decrement,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_zealot_2_kills_of_shocked_enemies_last_15 = {
			running_stat = "zealot_2_kills_of_shocked_enemies_last_15",
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "zealot_2_kills_of_shocked_enemies_last_15",
					trigger = function (self, stat_data, value)
						return set_to_max(self, stat_data, value)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_not_use_ranged_attacks = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data)
						local shots_fired = read_stat(stat_definitions.shots_fired, stat_data)

						if shots_fired == 0 then
							return set_to_max(self, stat_data, 1)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_zealot_2_health_healed_with_leech_during_resist_death = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "hook_zealot_health_leeched_during_resist_death",
					trigger = function (self, stat_data, percent_leeched)
						return set_to_max(self, stat_data, percent_leeched)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_fastest_mission_with_low_health = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
				percent_at_low_health = 75,
				private_session = true,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data, difficulty, mission_time)
						local data = self.data
						local target_percent = data.percent_at_low_health / 100
						local time_at_low_health = read_stat(stat_definitions.time_spent_on_last_health_segment, stat_data)
						local rounded_mission_time = math.round(mission_time)

						if time_at_low_health >= target_percent * mission_time then
							return set_to_min(self, stat_data, rounded_mission_time)
						end
					end,
				},
			},
			include_condition = include_condition,
			default = minutes(99),
		}
		stat_definitions.zealot_2_number_of_shocked_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_buff",
					trigger = function (self, stat_data, breed_name, template_name, stack_count, weapon_template_name)
						if template_name == "shock_grenade_interval" then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_toughness_gained_from_chastise_the_wicked = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_lounge_toughness_regenerated",
					trigger = function (self, stat_data, amount)
						return increment_by(self, stat_data, amount)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.shroudfield_stance_active = {
			flags = {
				StatFlags.no_sync,
				StatFlags.no_recover,
				StatFlags.never_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_shroudfield_start",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_shroudfield_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_elite_or_special_kills_with_shroudfield = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed = attack_data.target_breed_name
						local shroudfield_stance_active = read_stat(stat_definitions.shroudfield_stance_active, stat_data) == 1
						local data = self.data

						if attack_data.is_backstab and shroudfield_stance_active and data.breed_lookup[breed] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_team_toughness_restored_with_chorus = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_zealot_chorus_toughness_restored",
					trigger = function (self, stat_data, toughness_amount)
						return increment_by(self, stat_data, toughness_amount)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_elite_or_special_kills_with_blade_of_faith = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed = attack_data.target_breed_name
						local damage_type = attack_data.damage_type
						local attack_type = attack_data.attack_type
						local data = self.data

						if data.breed_lookup[breed] and damage_type == "throwing_knife_zealot" and attack_type == "ranged" then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_fanatic_rage_status = {
			flags = {
				StatFlags.no_sync,
				StatFlags.no_recover,
				StatFlags.never_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_zealot_fanatic_rage_start",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_zealot_fanatic_rage_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_elite_or_special_kills_during_fanatic_rage = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local fanatic_rage_active = read_stat(stat_definitions.zealot_fanatic_rage_status, stat_data) == 1

						if fanatic_rage_active then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_movement_keystone_status = {
			flags = {
				StatFlags.no_sync,
				StatFlags.no_recover,
				StatFlags.never_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_zealot_movement_keystone_start",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_zealot_movement_keystone_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_kills_during_movement_keystone_activated = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed = attack_data.target_breed_name
						local movement_keystone_active = read_stat(stat_definitions.zealot_movement_keystone_status, stat_data) == 1
						local data = self.data

						if movement_keystone_active and data.breed_lookup[breed] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_kills_with_fire_grenade = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_zealot_engulfed_enemies",
					trigger = function (self, stat_data, num_engulfed)
						return increment_by(self, stat_data, num_engulfed)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_aura_backstab_kills_while_alone = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_zealot_loner_aura",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_aura_toughness_damage_reduced = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_toughness_reduced_aura",
					trigger = function (self, stat_data, amount)
						return increment_by(self, stat_data, amount)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_aura_corruption_healed = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_zealot_corruption_healed_aura",
					trigger = function (self, stat_data, amount)
						return increment_by(self, stat_data, amount)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_number_of_critical_hits_kills_when_stunned = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local is_critical_hit = attack_data.is_critical_hit
						local target_buff_keywords = attack_data.target_buff_keywords

						if is_critical_hit and target_buff_keywords.shock_grenade_shock then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_kills_with_martyrdoom_stacks = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local attack_type = attack_data.attack_type

						if attack_type ~= "melee" then
							return
						end

						local martyrdom_stacks = read_stat(stat_definitions.last_seen_martyrdom_stacks, stat_data)

						if martyrdom_stacks < 3 then
							return
						end

						return increment(self, stat_data)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_killed_elites_and_specials_with_activated_attacks = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
				weapon_lookup = weapons_with_activated_specials,
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local is_weapon_special = attack_data.is_weapon_special
						local breed = attack_data.target_breed_name
						local weapon = attack_data.weapon_template_name
						local data = self.data

						if is_weapon_special and data.weapon_lookup[weapon] and data.breed_lookup[breed] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.zealot_2_charged_enemy_wielding_ranged_weapon = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "hook_lunge_start",
					trigger = function (self, stat_data, has_target, target_is_ranged)
						if has_target and target_is_ranged then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
	end

	do
		local include_condition = archetype_include_condition("psyker")

		stat_definitions.hook_psyker_time_at_max_souls = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_survived_perils = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_reached_max_souls = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_lost_max_souls = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_overcharge_stance_start = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_overcharge_stance_stop = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_chain_lightning_ability = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_empowered_ability = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_spent_max_unnatural_stack = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_shield_damage_taken = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_team_elite_aura_kills = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_team_critical_hits_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_psyker_team_cooldown_recovery_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.psyker_at_max_souls = {
			flags = {
				StatFlags.no_recover,
				StatFlags.never_log,
				StatFlags.no_sync,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_reached_max_souls",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_psyker_lost_max_souls",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.smite_hound_mid_leap = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "chaos_hound_killed",
					trigger = function (self, stat_data, attack_data)
						local weapon = attack_data.weapon_template_name
						local action = attack_data.target_action

						if action == "leap" and weapon == "psyker_smite" then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_2_edge_kills_last_2_sec = {
			flags = {
				StatFlags.no_recover,
			},
			data = {},
			triggers = {
				{
					id = "ledge_kill",
					trigger = StatMacros.increment,
				},
				{
					id = "ledge_kill",
					trigger = StatMacros.decrement,
					delay = seconds(2),
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_psyker_2_edge_kills_last_2_sec = {
			running_stat = "psyker_2_edge_kills_last_2_sec",
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "psyker_2_edge_kills_last_2_sec",
					trigger = StatMacros.set_to_max,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_psyker_2_time_at_max_souls = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_psyker_time_at_max_souls",
					trigger = function (self, stat_data, time_at_max)
						return set_to_max(self, stat_data, time_at_max)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.elite_or_special_kill_with_smite = {
			flags = {
				StatFlags.never_log,
				StatFlags.no_sync,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed = attack_data.target_breed_name
						local weapon = attack_data.weapon_template_name
						local data = self.data

						if data.breed_lookup[breed] and weapon == "psyker_smite" then
							return self.id, attack_data
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.elite_or_special_kills_with_smite_last_12_sec = {
			flags = {
				StatFlags.no_recover,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "elite_or_special_kill_with_smite",
					trigger = StatMacros.increment,
				},
				{
					delay = 12,
					id = "elite_or_special_kill_with_smite",
					trigger = StatMacros.decrement,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_elite_or_special_kills_with_smite_last_12_sec = {
			running_stat = "elite_or_special_kills_with_smite_last_12_sec",
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "elite_or_special_kills_with_smite_last_12_sec",
					trigger = StatMacros.set_to_max,
				},
			},
			include_condition = include_condition,
		}

		do
			local function damaged_by_smite_trigger(self, stat_data, attack_data)
				local weapon = attack_data.weapon_template_name

				if weapon == "psyker_smite" then
					local target_id = attack_data.target_unit_id
					local id = self.id

					stat_data[id] = stat_data[id] or {}

					local _data = stat_data[id]

					_data[target_id] = (_data[target_id] or self.default) + attack_data.damage_dealt

					return id, target_id, _data[target_id]
				end
			end

			stat_definitions.smite_boss_damage_by_id = {
				flags = {
					StatFlags.no_recover,
					StatFlags.no_sync,
					StatFlags.never_log,
				},
				data = {
					difficulty = 4,
					private_session = true,
				},
				triggers = table.map(boss_breeds, function (breed_name)
					return {
						id = string.format("%s_damaged", breed_name),
						trigger = damaged_by_smite_trigger,
					}
				end),
				include_condition = include_condition,
			}
			stat_definitions.max_smite_damage_done_to_boss = {
				flags = {
					StatFlags.backend,
				},
				data = {
					difficulty = 4,
					private_session = true,
				},
				triggers = {
					{
						id = "hook_boss_died",
						trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
							local damage_dealt = stat_data.smite_boss_damage_by_id and stat_data.smite_boss_damage_by_id[boss_unit_id] or 0
							local percentage_damage_dealt = math.round(100 * damage_dealt / (boss_max_health + 0.01))

							return set_to_max(self, stat_data, percentage_damage_dealt)
						end,
					},
				},
				include_condition = include_condition,
			}
		end

		stat_definitions.psyker_2_elite_or_special_kills_with_smite = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "elite_or_special_kill_with_smite",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_2_survived_perils = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_survived_perils",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_2_smite_kills_at_max_souls = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "elite_or_special_kill_with_smite",
					trigger = function (self, stat_data, attack_data)
						local at_max_souls = read_stat(stat_definitions.psyker_at_max_souls, stat_data) == 1

						if at_max_souls then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_2_warp_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
				damage_type_lookup = DamageSettings.warp_damage_types,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local damage_type = attack_data.damage_type

						if self.data.damage_type_lookup[damage_type] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.elite_or_special_kill_with_assail = {
			flags = {
				StatFlags.never_log,
				StatFlags.no_sync,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed = attack_data.target_breed_name
						local weapon = attack_data.weapon_template_name
						local data = self.data

						if data.breed_lookup[breed] and weapon == "psyker_throwing_knives" then
							return self.id, attack_data
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_threshold_kills_reached_with_grenade_chain = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_chain_lightning_ability",
					trigger = function (self, stat_data, amount)
						return increment_by(self, stat_data, amount)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_elite_or_special_kills_with_assail = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "elite_or_special_kill_with_assail",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.overcharge_stance_active = {
			flags = {
				StatFlags.no_sync,
				StatFlags.no_recover,
				StatFlags.never_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_overcharge_stance_start",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_overcharge_stance_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_kills_during_overcharge_stance = {
			flags = {
				StatFlags.no_recover,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data)
						local overcharge_stance_active = read_stat(stat_definitions.overcharge_stance_active, stat_data) == 1

						if overcharge_stance_active then
							return increment(self, stat_data)
						end
					end,
				},
				{
					id = "hook_overcharge_stance_stop",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_psyker_kills_during_overcharge_stance = {
			running_stat = "psyker_kills_during_overcharge_stance",
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "psyker_kills_during_overcharge_stance",
					trigger = StatMacros.set_to_max,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_kills_with_empowered_abilites = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_psyker_empowered_ability",
					trigger = function (self, stat_data, attack_data)
						local breed_name = attack_data.breed_name
						local breed_lookup = self.data.breed_lookup

						if breed_lookup[breed_name] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_time_at_max_unnatural = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_spent_max_unnatural_stack",
					trigger = function (self, stat_data, rounded_time_value)
						return increment_by(self, stat_data, rounded_time_value)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_shield_total_damage_taken = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_shield_damage_taken",
					trigger = function (self, stat_data, damage)
						return increment_by(self, stat_data, damage)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_team_elite_aura_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_team_elite_aura_kills",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_team_critical_hits = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_team_critical_hits_aura",
					trigger = function (self, stat_data, amount)
						return increment_by(self, stat_data, amount)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_team_cooldown_reduced = {
			flags = {
				StatFlags.backend,
				StatFlags.always_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_psyker_team_cooldown_recovery_aura",
					trigger = function (self, stat_data, saved_time)
						return increment_by(self, stat_data, saved_time)
					end,
				},
			},
			include_condition = include_condition,
		}

		do
			local function kill_before_disabling(self, stat_data, attack_data)
				local weapon = attack_data.weapon_template_name

				if weapon ~= "psyker_smite" then
					return
				end

				local blackboard = attack_data.target_blackboard

				if not blackboard or not Blackboard.has_component(blackboard, "record_state") then
					return
				end

				local record_state = blackboard.record_state
				local has_disabled_player = record_state.has_disabled_player

				if not has_disabled_player then
					return increment(self, stat_data)
				end
			end

			stat_definitions.psyker_2_killed_disablers_before_disabling = {
				flags = {
					StatFlags.backend,
				},
				data = {
					difficulty = 4,
				},
				triggers = table.map(disabler_breeds, function (breed_name)
					return {
						id = string.format("%s_killed", breed_name),
						trigger = kill_before_disabling,
					}
				end),
				include_condition = include_condition,
			}
		end

		stat_definitions.psyker_elite_melee_damage_taken = {
			flags = {
				StatFlags.no_sync,
				StatFlags.never_log,
			},
			data = {
				difficulty = 4,
				breed_lookup = elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_damage_taken",
					trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
						if attack_type == "melee" and self.data.breed_lookup[attacker_breed] then
							return increment_by(self, stat_data, damage_dealt)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.psyker_2_x_missions_no_elite_melee_damage_taken = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data, difficulty, time)
						local damage_taken = read_stat(stat_definitions.psyker_elite_melee_damage_taken, stat_data)

						if damage_taken == 0 then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
	end

	do
		local include_condition = archetype_include_condition("ogryn")

		stat_definitions.hook_ogryn_heavy_hitter_at_max_stacks = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_heavy_hitter_at_max_lost = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_feel_no_pain_kills_at_max = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_leadbelcher_free_shot = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_frag_grenade = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_barrage_end = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_heavy_aura_kills = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_suppressed_aura_kills = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_ogryn_toughness_restored_aura = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.ogryn_2_killed_corruptor_with_grenade_impact = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed_name = attack_data.target_breed_name
						local weapon_template_name = attack_data.weapon_template_name
						local correct_breed = breed_name == "corruptor_body"

						if correct_breed then
							local correct_weapon = weapon_template_name == "ogryn_grenade_box" or weapon_template_name == "ogryn_grenade_box_cluster"

							if correct_weapon then
								return increment(self, stat_data)
							end
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_win_with_coherency_all_alive_units = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data, difficulty, mission_time)
						local time_in_coherency = read_stat(stat_definitions.session_time_coherency, stat_data)
						local raw_percentage_in_coherency = time_in_coherency / mission_time
						local percent_in_coherency = math.clamp(math.round(raw_percentage_in_coherency * 100), 0, 100)

						return set_to_max(self, stat_data, percent_in_coherency)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_ogryn_2_lunge_number_of_enemies_hit = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_lunge_stop",
					trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit, elites_hit, specials_hit)
						return set_to_max(self, stat_data, units_hit)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_lunge_distance_last_x_seconds = {
			flags = {
				StatFlags.no_recover,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "hook_lunge_distance",
					trigger = function (self, stat_data, delta_distance)
						return increment_by(self, stat_data, delta_distance)
					end,
				},
				{
					delay = 20,
					id = "hook_lunge_distance",
					trigger = function (self, stat_data, delta_distance)
						return increment_by(self, stat_data, -delta_distance)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_ogryn_2_lunge_distance_last_x_seconds = {
			running_stat = "ogryn_2_lunge_distance_last_x_seconds",
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "ogryn_2_lunge_distance_last_x_seconds",
					trigger = StatMacros.set_to_max,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.max_ogryns_bullrushed = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "hook_lunge_stop",
					trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit, elites_hit, specials_hit)
						return set_to_max(self, stat_data, ogryns_hit)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_number_of_revived_or_assisted_allies = {
			flags = {
				StatFlags.backend,
			},
			data = {
				assistance_types = table.set({
					"revive",
					"pull_up",
					"remove_net",
				}),
			},
			triggers = {
				{
					id = "hook_assist_ally",
					trigger = function (self, stat_data, target_id, assistance_type)
						local assistance_type_lookup = self.data.assistance_types

						if assistance_type_lookup[assistance_type] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_number_of_knocked_down_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {
				stagger_types = table.set({
					StaggerSettings.stagger_types.heavy,
					StaggerSettings.stagger_types.explosion,
				}),
			},
			triggers = {
				{
					id = "hook_damage_dealt",
					trigger = function (self, stat_data, attack_data)
						local attack_result = attack_data.attack_result
						local stagger_type = attack_data.stagger_type
						local stagger_type_lookup = self.data.stagger_types

						if attack_result ~= "died" and stagger_type_lookup[stagger_type] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_taunt_shout_hit = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_shout_buff",
					trigger = function (self, stat_data, buff_name, breed_name)
						local data = self.data

						if buff_name == "taunted" and data.breed_lookup[breed_name] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_grenade_rock_elites_or_specialists = {
			flags = {
				StatFlags.backend,
			},
			data = {
				breed_lookup = special_and_elite_breed_lookup,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local breed = attack_data.target_breed_name
						local weapon = attack_data.weapon_template_name
						local data = self.data

						if data.breed_lookup[breed] and weapon == "ogryn_grenade_friend_rock" then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_grenade_frag_group_of_enemies_killed = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_frag_grenade",
					trigger = function (self, stat_data)
						return increment(self, stat_data)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_heavy_hitter_status = {
			flags = {
				StatFlags.never_log,
				StatFlags.no_recover,
				StatFlags.no_sync,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_heavy_hitter_at_max_stacks",
					trigger = function (self, stat_data)
						return set_to_max(self, stat_data, 1)
					end,
				},
				{
					id = "hook_ogryn_heavy_hitter_at_max_lost",
					trigger = function (self, stat_data)
						return set_to_min(self, stat_data, 0)
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_kills_during_max_stacks_heavy_hitter = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local track_status = read_stat(stat_definitions.ogryn_heavy_hitter_status, stat_data) == 1
						local is_heavy_attack = attack_data.is_heavy_attack

						if track_status and is_heavy_attack then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.kills_achieved_group_barrage_threshold = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_barrage_end",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_feel_no_pain_kills_at_max = {
			flags = {
				StatFlags.backend,
				StatFlags.always_log,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_feel_no_pain_kills_at_max",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_leadbelcher_free_shot = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_leadbelcher_free_shot",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_team_heavy_aura_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_heavy_aura_kills",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_team_suppressed_aura_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_ogryn_suppressed_aura_kills",
					trigger = StatMacros.increment,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_team_toughness_restored_aura = {
			flags = {
				StatFlags.backend,
			},
			data = {
				cap = 40000,
			},
			triggers = {
				{
					id = "hook_ogryn_toughness_restored_aura",
					trigger = function (self, stat_data, amount)
						local id = self.id
						local current_value = stat_data[id] or self.default
						local cap = self.data.cap

						if current_value < cap then
							stat_data[id] = math.min(current_value + amount, cap)

							return id, stat_data[id]
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_bullrushed_group_of_ranged_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_lunge_stop",
					trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit, elites_hit, specials_hit)
						if ranged_units_hit >= 3 then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_killed_multiple_enemies_with_sweep = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_sweep_finished",
					trigger = function (self, stat_data, num_hit_enemies, num_killed_enemies, combo_count, hit_weakspot, is_heavy)
						if num_killed_enemies >= 2 then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_number_of_missions_with_no_deaths_and_all_revives_within_x_seconds = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
				max_time_in_captivity = 10,
			},
			triggers = {
				{
					id = "whole_mission_won",
					trigger = function (self, stat_data, difficulty, mission_time)
						local team_deaths = read_stat(stat_definitions.team_deaths, stat_data)
						local longest_time_spent_in_captivity = read_stat(stat_definitions.team_longest_time_spent_in_captivity, stat_data)
						local max_time_in_captivity = self.data.max_time_in_captivity

						if team_deaths == 0 and longest_time_spent_in_captivity <= max_time_in_captivity then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_grenade_box_kills_without_missing_counter = {
			flags = {
				StatFlags.no_recover,
			},
			data = {
				difficulty = 4,
			},
			triggers = {
				{
					id = "hook_projectile_hit",
					trigger = function (self, stat_data, impact_hit, num_impact_hit_weakspot, num_impact_hit_kill, num_impact_hit_elite, num_impact_hit_special, projectile_template_name)
						if projectile_template_name ~= "ogryn_grenade_box" and projectile_template_name ~= "ogryn_grenade_box_cluster" then
							return
						end

						local id = self.id
						local default = self.default
						local current_value = stat_data[id] or default
						local hit_elite_or_special = num_impact_hit_elite + num_impact_hit_special > 0

						if hit_elite_or_special then
							return increment(self, stat_data)
						elseif current_value ~= default then
							return set_to(self, stat_data, default)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
		stat_definitions.ogryn_2_grenade_box_kills_without_missing = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 4,
				number_of_hits = 4,
			},
			triggers = {
				{
					id = "ogryn_2_grenade_box_kills_without_missing_counter",
					trigger = function (self, stat_data, hits_in_a_row)
						local number_of_hits = self.data.number_of_hits

						if hits_in_a_row > 0 and hits_in_a_row % number_of_hits == 0 then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = include_condition,
		}
	end

	do
		local archetype_condition = archetype_include_condition("adamant")

		stat_definitions.hook_adamant_companion_pounce_enemy = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_companion_knock_enemy = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_wield_speed_aura_kill = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_staggered_enemy_aura_kill = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_companion_coherency_aura_kill = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_enemy_affected_by_buff_drone = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_ally_affected_by_buff_drone = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_time_ally_buffed_by_buff_drone = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_time_enemy_electrocuted_by_shockmine = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_whistle_explosion_stagger_monster = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_killed_cluster_of_enemies_with_grenade = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_killed_enemy_marked_by_execution_order = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.hook_adamant_exited_max_forceful_stacks = {
			flags = {
				StatFlags.hook,
			},
		}
		stat_definitions.adamant_team_wield_speed_aura_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_wield_speed_aura_kill",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_team_staggered_enemies_aura_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_staggered_enemy_aura_kill",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_team_companion_in_coherency_kills = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_companion_coherency_aura_kill",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_time_enemies_electrocuted_by_shockmine = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_time_enemy_electrocuted_by_shockmine",
					trigger = function (self, stat_data, count)
						return increment_by(self, stat_data, count)
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_enemies_affected_by_buff_drone = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_enemy_affected_by_buff_drone",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_cluster_of_enemies_killed_with_grenade = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_killed_cluster_of_enemies_with_grenade",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_time_allies_buffed_by_buff_drone = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_time_ally_buffed_by_buff_drone",
					trigger = function (self, stat_data, count)
						return increment_by(self, stat_data, count)
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_enemies_killed_during_stance = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local is_attacker_owner_in_stance = attack_data.attacker_owner_buff_keywords.adamant_hunt_stance

						if is_attacker_owner_in_stance then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_enemies_staggered_during_charge = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_lunge_stop",
					trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit, elites_hit, specials_hit)
						local elites_and_specials_hit = elites_hit + specials_hit

						return increment_by(self, stat_data, elites_and_specials_hit)
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_monsters_staggered_by_whistle_explosion = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_whistle_explosion_stagger_monster",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_killed_enemies_pounced_by_companion = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local attacking_unit = attack_data.attacking_unit
						local target_blackboard = attack_data.target_blackboard
						local has_disable_component = target_blackboard and Blackboard.has_component(target_blackboard, "disable")
						local is_in_pounced_state = has_disable_component and target_blackboard.disable.type == "pounced" or false

						if is_in_pounced_state then
							local pouncing_unit = target_blackboard.disable.attacker_unit
							local pouncing_unit_owner = Managers.state.player_unit_spawn:owner(pouncing_unit)
							local is_killer_owner_of_pouncing_companion = pouncing_unit_owner and pouncing_unit_owner.player_unit and pouncing_unit_owner.player_unit == attacking_unit

							if is_killer_owner_of_pouncing_companion then
								return increment(self, stat_data)
							end
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_killed_electrocuted_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local is_electrocuted = attack_data.target_buff_keywords.electrocuted

						if is_electrocuted then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_blocked_attack_from_unique_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_blocked_damage_from_unique_enemy",
					trigger = StatMacros.increment,
				},
			},
			include_condition = archetype_condition,
		}

		local valid_companion_pounce_target_breeds = {
			cultist_grenadier = true,
			renegade_grenadier = true,
			renegade_netgunner = true,
			renegade_sniper = true,
		}

		stat_definitions.adamant_companion_pounced_special_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_companion_pounce_enemy",
					trigger = function (self, stat_data, companion_unit, companion_breed_name, pounced_unit, pounced_unit_breed, previously_pounced)
						if valid_companion_pounce_target_breeds[pounced_unit_breed] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}

		local valid_companion_knock_away_target_breeds = {
			chaos_poxwalker_bomber = true,
			cultist_mutant = true,
		}

		stat_definitions.adamant_companion_knocked_away_special_enemies = {
			flags = {
				StatFlags.backend,
			},
			data = {},
			triggers = {
				{
					id = "hook_adamant_companion_knock_enemy",
					trigger = function (self, stat_data, companion_unit, companion_breed_name, pounced_unit, pounced_unit_breed, previously_pounced, has_companion_saved_disabled_owner)
						if not previously_pounced and valid_companion_knock_away_target_breeds[pounced_unit_breed] then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_killed_enemies_marked_by_execution_order = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_adamant_killed_enemy_marked_by_execution_order",
					trigger = function (self, stat_data, attack_data)
						return increment(self, stat_data)
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_melee_kills_with_terminus_warrant = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local is_ranged_attack = attack_data.attack_type == "melee"
						local is_attacker_owner_in_terminus_warrant = attack_data.attacker_owner_buff_keywords.adamant_terminus_warrant

						if is_ranged_attack and is_attacker_owner_in_terminus_warrant then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_ranged_kills_with_terminus_warrant = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_kill",
					trigger = function (self, stat_data, attack_data)
						local is_ranged_attack = attack_data.attack_type == "ranged"
						local is_attacker_owner_in_terminus_warrant = attack_data.attacker_owner_buff_keywords.adamant_terminus_warrant

						if is_ranged_attack and is_attacker_owner_in_terminus_warrant then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = archetype_condition,
		}
		stat_definitions.adamant_time_at_max_forceful_stacks = {
			flags = {
				StatFlags.backend,
			},
			data = {
				difficulty = 3,
			},
			triggers = {
				{
					id = "hook_adamant_exited_max_forceful_stacks",
					trigger = function (self, stat_data, count)
						return increment_by(self, stat_data, count)
					end,
				},
			},
			include_condition = archetype_condition,
		}
	end

	local archetype_condition = archetype_include_condition("broker")

	stat_definitions.hook_broker_cluster_staggered_by_flash_grenade = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_exited_punk_rage = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_deployed_stimm_field = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_time_ally_buffed_by_stimm_field = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_shared_ammo_through_aura = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_enemy_killed_ruffian_aura = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_critical_hit_with_anarchist_aura = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_stack_of_vulture_keystone = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_proc_max_stacks_adrenaline_keystone = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_exited_max_stacks_of_chemical_dependency = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_stimm_used = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.hook_broker_stimm_restored_tougness = {
		flags = {
			StatFlags.hook,
		},
	}
	stat_definitions.broker_ammo_shared_through_aura = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_shared_ammo_through_aura",
				trigger = function (self, stat_data, ammo_restored)
					return increment_by(self, stat_data, ammo_restored)
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_enemies_killed_ruffian_aura = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_enemy_killed_ruffian_aura",
				trigger = StatMacros.increment,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_critical_hits_with_anarchist_aura = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_critical_hit_with_anarchist_aura",
				trigger = StatMacros.increment,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_enemies_staggered_by_flash_grenade = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_cluster_staggered_by_flash_grenade",
				trigger = StatMacros.increment,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_enemies_killed_by_missile_launcher = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local breed = Breeds[attack_data.target_breed_name]
					local is_special_elite_or_monster = breed and breed.tags and (breed.tags.special or breed.tags.elite or breed.tags.monster)
					local weapon_name = attack_data.weapon_template_name

					if is_special_elite_or_monster and weapon_name == "missile_launcher" then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_enemies_affected_by_chem_bomb = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_liquid_area_entering_buff_added_on_enemy",
				trigger = function (self, stat_data, liquid_area_buff_data)
					local area_template_name = liquid_area_buff_data.area_template_name

					if area_template_name == "broker_tox_grenade" then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_enemies_killed_with_focus_mode = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local attacker_owner_buff_keywords = attack_data.attacker_owner_buff_keywords
					local is_in_focus_stance = attacker_owner_buff_keywords and attacker_owner_buff_keywords.broker_combat_ability_focus

					if is_in_focus_stance then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_attacks_dodged_in_focus_mode = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_dodged_attack",
				trigger = function (self, stat_data, breed_name, attack_type, dodge_type, attacker_action, previously_dodged, dodging_unit_buff_keywords)
					local is_in_focus_stance = dodging_unit_buff_keywords and dodging_unit_buff_keywords.broker_combat_ability_focus

					if is_in_focus_stance then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_deal_damage_in_punk_rage = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_damage_dealt",
				trigger = function (self, stat_data, attack_data)
					local damage_dealt = attack_data.damage_dealt
					local attacker_owner_buff_keywords = attack_data.attacker_owner_buff_keywords
					local is_in_focus_stance = attacker_owner_buff_keywords and attacker_owner_buff_keywords.broker_combat_ability_punk_rage

					if damage_dealt > 0 and is_in_focus_stance then
						return increment_by(self, stat_data, damage_dealt)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_time_stay_in_punk_rage = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_exited_punk_rage",
				trigger = function (self, stat_data, time_in_punk_rage_rounded)
					if time_in_punk_rage_rounded > 0 then
						return increment_by(self, stat_data, time_in_punk_rage_rounded)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_deploy_stimm_field = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_deployed_stimm_field",
				trigger = StatMacros.increment,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_time_buff_allies_chem_field = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_time_ally_buffed_by_stimm_field",
				trigger = function (self, stat_data, time_buffed_rounded)
					if time_buffed_rounded > 0 then
						return increment_by(self, stat_data, time_buffed_rounded)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stacks_gained_of_vulture_keystone = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_stack_of_vulture_keystone",
				trigger = StatMacros.increment,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_times_activated_max_stacks_of_adrenaline_keystone = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_proc_max_stacks_adrenaline_keystone",
				trigger = StatMacros.increment,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_time_spent_max_stacks_chemical_dependency = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_exited_max_stacks_of_chemical_dependency",
				trigger = function (self, stat_data, time_at_max_stacks_rounded)
					if time_at_max_stacks_rounded > 0 then
						return increment_by(self, stat_data, time_at_max_stacks_rounded)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stimm_attack_speed_gained_from_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_stimm_used",
				trigger = function (self, stat_data, stats_gained, player)
					local attack_speed_gained = stats_gained.attack_speed

					if attack_speed_gained and attack_speed_gained > 0 then
						local viscosity = TalentLayoutParser.profile_percent_specialization_points_used(player:profile())

						if viscosity >= AchievementTweakData.broker_stimm_celerity_potency.min_potency then
							return increment_by(self, stat_data, attack_speed_gained * 100)
						end
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stimm_hit_weakspots = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_damage_dealt",
				trigger = function (self, stat_data, attack_data)
					local hit_weakspot = attack_data.hit_weakspot
					local attacker_owner_buff_keywords = attack_data.attacker_owner_buff_keywords
					local has_broker_syringe_active = attacker_owner_buff_keywords and attacker_owner_buff_keywords.syringe_broker

					if has_broker_syringe_active and hit_weakspot then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stimm_powerl_level_gained_from_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_stimm_used",
				trigger = function (self, stat_data, stats_gained, player)
					local power_level_gained = stats_gained.power_level_modifier

					if power_level_gained and power_level_gained > 0 then
						local viscosity = TalentLayoutParser.profile_percent_specialization_points_used(player:profile())

						if viscosity >= AchievementTweakData.broker_stimm_combat_potency.min_potency then
							return increment_by(self, stat_data, power_level_gained * 100)
						end
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stimm_heavy_attack_kills = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, stat_data, attack_data)
					local is_heavy_attack = attack_data.is_heavy_attack
					local attacker_owner_buff_keywords = attack_data.attacker_owner_buff_keywords
					local has_broker_syringe_active = attacker_owner_buff_keywords and attacker_owner_buff_keywords.syringe_broker

					if has_broker_syringe_active and is_heavy_attack then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stimm_toughness_restored_from_stimm = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_broker_stimm_restored_tougness",
				trigger = function (self, stat_data, toughness_restored, player)
					local toughness_restored_rounded = math.round(toughness_restored)

					if toughness_restored_rounded > 0 then
						local viscosity = TalentLayoutParser.profile_percent_specialization_points_used(player:profile())

						if viscosity >= AchievementTweakData.broker_stimm_durability_potency.min_potency then
							return increment_by(self, stat_data, math.round(toughness_restored_rounded))
						end
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
	stat_definitions.broker_stimm_apply_toxin = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_buff",
				trigger = function (self, stat_data, breed_name, template_name, stack_count, weapon_template_name, source_player_buff_keywords)
					local has_broker_syringe_active = source_player_buff_keywords and source_player_buff_keywords.syringe_broker

					if has_broker_syringe_active and template_name == "neurotoxin_interval_buff3" then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = archetype_condition,
	}
end

do
	local function template_name_to_id(template_name)
		return string.format("%s_kill", template_name)
	end

	local weapon_to_stat = {}

	for _, template_name in ipairs(weapon_names) do
		local id = template_name_to_id(template_name)

		weapon_to_stat[template_name] = id
		stat_definitions[id] = {
			flags = {
				StatFlags.no_sync,
			},
		}
	end

	stat_definitions.weapon_kill_splitter = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			weapon_to_stat = weapon_to_stat,
		},
		triggers = {
			{
				id = "hook_kill",
				trigger = function (self, _, attack_data)
					local weapon_name = attack_data.weapon_template_name
					local id = self.data.weapon_to_stat[weapon_name]

					return id, attack_data
				end,
			},
		},
	}

	local triggers = {}

	for _, template_name in ipairs(MechanicusEventWeapons) do
		triggers[#triggers + 1] = {
			id = template_name_to_id(template_name),
			trigger = function (self, stat_data, attack_data)
				local breed_name = attack_data.target_breed_name
				local breed_lookup = self.data.breed_lookup

				if breed_lookup[breed_name] then
					return self.id, attack_data
				end
			end,
		}
	end

	stat_definitions._session_new_weapon_kills = {
		flags = {
			StatFlags.team,
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			breed_lookup = special_and_elite_breed_lookup,
		},
		triggers = triggers,
	}
	stat_definitions.session_new_weapon_kills = {
		flags = {},
		data = {},
		triggers = {
			{
				id = "_session_new_weapon_kills",
				trigger = StatMacros.increment,
			},
		},
	}
end

do
	local weapons = AchievementWeaponGroups.weapons

	for _, weapon in ipairs(weapons) do
		local stat_name = string.format("mastery_track_reached_20_%s", weapon.pattern)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
				StatFlags.no_sync,
			},
			data = {},
		}
	end

	stat_definitions.mastery_track_levels = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.expertise_reached_50_primary = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.expertise_reached_50_secondary = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.expertise_reached_30 = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.expertise_reached_40 = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.expertise_reached_50 = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
	stat_definitions.crafting_unique_traits_seen = {
		flags = {
			StatFlags.backend,
			StatFlags.no_sync,
		},
		data = {},
	}
end

stat_definitions.game_mode_survival_waves_score = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "hook_game_mode_survival_waves_completed",
			trigger = function (self, stat_data, waves_completed)
				local score = math.floor((waves_completed + 1e-06) / 4)

				return set_to(self, stat_data, score)
			end,
		},
	},
	include_condition = function (self, config)
		local game_mode_name = config.game_mode_name

		return game_mode_name == "survival"
	end,
}
stat_definitions.game_mode_survival_score_end_of_round = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {},
	triggers = {
		{
			id = "hook_mission_ended",
			trigger = function (self, stat_data)
				local survival_waves_score = read_stat(stat_definitions.game_mode_survival_waves_score, stat_data)

				return set_to(self, stat_data, survival_waves_score)
			end,
		},
	},
	include_condition = function (self, config)
		local game_mode_name = config.game_mode_name

		return game_mode_name == "survival"
	end,
}
stat_definitions.game_mode_survival_islands_completed = {
	flags = {
		StatFlags.backend,
	},
	data = {},
	triggers = {
		{
			id = "hook_game_mode_survival_island_completed",
			trigger = StatMacros.increment,
		},
	},
}

do
	local islands = {
		"island_void",
		"island_rooftops",
		"island_machine",
	}

	for i = 1, #islands do
		local island_name = islands[i]
		local stat_name = string.format("horde_win_%s", island_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			stat_name = string.format("loc_horde_%s_name", island_name),
			data = {
				island_name = island_name,
			},
			triggers = {
				{
					id = "hook_game_mode_survival_island_completed",
					trigger = function (self, stat_data, island_completed_name)
						if island_completed_name == self.data.island_name then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = function (self, config)
				local game_mode_name = config.game_mode_name

				return game_mode_name == "survival"
			end,
		}
	end

	stat_definitions.game_mode_survival_mcguffin_returned = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_game_mode_mcguffins_returned",
				trigger = StatMacros.increment,
			},
		},
	}
	stat_definitions.game_mode_survival_game_end_flawless = {
		flags = {
			StatFlags.backend,
		},
		data = {},
		triggers = {
			{
				id = "hook_game_mode_survival_game_end",
				trigger = function (self, stat_data, game_won, completion_time, difficulty)
					if game_won and difficulty >= 3 and completion_time > 0 and completion_time <= 1500 then
						return increment(self, stat_data)
					end
				end,
			},
		},
		include_condition = function (self, config)
			local game_mode_name = config.game_mode_name

			return game_mode_name == "survival"
		end,
	}

	local game_mode_survival_ammo_pickups_names_to_track = {
		ammo_cache_deployable = true,
		large_clip = true,
		small_clip = true,
	}

	stat_definitions.game_mode_survival_auric_session_ammo_pickups_and_health_station_uses = {
		flags = {},
		data = {},
		triggers = {
			{
				id = "hook_picked_up_item",
				trigger = function (self, stat_data, source_name)
					if game_mode_survival_ammo_pickups_names_to_track[source_name] then
						return increment(self, stat_data)
					end
				end,
			},
			{
				id = "hook_health_station_interaccion_success",
				trigger = function (self, stat_data)
					return increment(self, stat_data)
				end,
			},
		},
		include_condition = function (self, config)
			local game_mode_name = config.game_mode_name
			local correct_difficulty = config.is_auric_mission

			return game_mode_name == "survival" and correct_difficulty
		end,
	}

	local survival_classes = MissionBuffsAllowed.available_family_builds

	for i = 1, #survival_classes do
		local class_name = survival_classes[i]
		local stat_name = string.format("horde_win_%s_archetype", class_name)

		stat_definitions[stat_name] = {
			flags = {
				StatFlags.backend,
			},
			data = {
				class_name = class_name,
			},
			triggers = {
				{
					id = "hook_game_mode_survival_class_completed",
					trigger = function (self, stat_data, buff_family_selected_by_player)
						if buff_family_selected_by_player == self.data.class_name then
							return increment(self, stat_data)
						end
					end,
				},
			},
			include_condition = function (self, config)
				local game_mode_name = config.game_mode_name

				return game_mode_name == "survival"
			end,
		}
	end

	local vo_stats = {
		{
			name = "backstory_morrow_part_",
			num_parts = 11,
		},
		{
			name = "backstory_zola_part_",
			num_parts = 9,
		},
		{
			name = "backstory_brahms_part_",
			num_parts = 10,
		},
		{
			name = "backstory_zorin_part_",
			num_parts = 2,
		},
	}

	for i = 1, #vo_stats do
		local character = vo_stats[i]
		local loc_prefix = "loc_horde_backstory_chapter_"

		for j = 1, character.num_parts do
			local name = vo_stats[i].name .. j
			local loc_name = loc_prefix .. j

			stat_definitions[name] = {
				flags = {
					StatFlags.backend,
				},
				triggers = {
					{
						id = "hook_" .. name,
						trigger = StatMacros.increment,
					},
				},
				stat_name = loc_name,
			}
		end
	end
end

stat_definitions.live_event_darkness_twins_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
		StatFlags.never_log,
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return circumstance_name == "darkness_twins_solo_01"
	end,
}
stat_definitions.live_event_moebian_21_deliveries = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
		StatFlags.never_log,
	},
	data = {
		circumstances = {
			moebian_21st_01 = true,
			moebian_21st_02 = true,
			moebian_21st_03 = true,
			moebian_21st_04 = true,
			moebian_21st_05 = true,
			moebian_21st_06 = true,
			moebian_21st_07 = true,
		},
	},
	triggers = {
		{
			id = "grimoire_delivered",
			trigger = StatMacros.increment_by,
		},
		{
			id = "scriptures_delivered",
			trigger = StatMacros.increment_by,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.live_event_nurgle_explosion_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			nurgle_explosion_01 = true,
			nurgle_explosion_02 = true,
			nurgle_explosion_03 = true,
			nurgle_explosion_04 = true,
			nurgle_explosion_05 = true,
			nurgle_explosion_06 = true,
			nurgle_explosion_07 = true,
		},
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.havoc_won_live_event = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		return config.is_havoc
	end,
}
stat_definitions.mission_won_with_sub_30_player = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
		StatFlags.always_log,
	},
	triggers = {
		{
			id = "mission_won",
			trigger = function (self, stat_data)
				local players = Managers.player:human_players()
				local num_sub_30 = 0

				for _, player in pairs(players) do
					local profile = player:profile()

					if profile.current_level < 30 then
						num_sub_30 = num_sub_30 + 1
					end
				end

				if num_sub_30 >= 1 then
					return increment(self, stat_data)
				end
			end,
		},
	},
}
stat_definitions.live_event_get_em_in_shape_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
		StatFlags.always_log,
	},
	triggers = {
		{
			id = "havoc_won_live_event",
			trigger = StatMacros.increment,
		},
		{
			id = "mission_won_with_sub_30_player",
			trigger = StatMacros.increment,
		},
	},
}
stat_definitions.live_event_abhuman_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			abhuman_01 = true,
			abhuman_02 = true,
			abhuman_03 = true,
			abhuman_04 = true,
			abhuman_05 = true,
			abhuman_06 = true,
			abhuman_07 = true,
		},
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.hook_destroy_skull_totem = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
}
stat_definitions.live_event_skulls_forward = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_destroy_skull_totem",
			trigger = function (self, stat_data, amount)
				return constant(self, stat_data, amount or 1)
			end,
		},
		{
			id = "hook_picked_up_item",
			trigger = function (self, stat_data, item_name)
				if item_name == "skulls_01_pickup" then
					return constant(self, stat_data, 1)
				end
			end,
		},
	},
	data = {
		circumstances = {
			skulls_event_01 = true,
			skulls_event_01_02 = true,
			skulls_event_01_03 = true,
			skulls_event_01_04 = true,
			skulls_event_01_05 = true,
			skulls_event_01_06 = true,
			skulls_event_01_07 = true,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.live_event_skulls_count = {
	flags = {
		StatFlags.always_log,
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "live_event_skulls_forward",
			trigger = StatMacros.increment_by,
		},
	},
	data = {
		circumstances = {
			skulls_event_01 = true,
			skulls_event_01_02 = true,
			skulls_event_01_03 = true,
			skulls_event_01_04 = true,
			skulls_event_01_05 = true,
			skulls_event_01_06 = true,
			skulls_event_01_07 = true,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.ember_mission_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			ember_01 = true,
			ember_01_hunt_grou = true,
			ember_01_more_res = true,
			ember_01_waves_spec = true,
		},
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.rotten_armor_mission_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			rotten_armor = true,
			rotten_armor_darkness = true,
			rotten_armor_gas = true,
			rotten_armor_hunt_grou = true,
			rotten_armor_more_res = true,
			rotten_armor_waves_spec = true,
		},
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.barrel_grounds_mission_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			barrel_grounds = true,
			barrel_grounds_darkness = true,
			barrel_grounds_gas = true,
			barrel_grounds_hunt_grou = true,
			barrel_grounds_more_res = true,
			barrel_grounds_ventilation = true,
			barrel_grounds_waves_spec = true,
		},
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions.plasma_smugglers_captain_kills = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			plasma_smugglers_darkness = true,
			plasma_smugglers_default = true,
			plasma_smugglers_hunting_grounds = true,
			plasma_smugglers_increased_resistance = true,
			plasma_smugglers_toxic_gas = true,
			plasma_smugglers_ventilation = true,
			plasma_smugglers_waves_of_specials = true,
		},
	},
	triggers = {
		{
			id = "renegade_captain_killed",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}

do
	local stolen_rations_circumstances = {
		rations_core = true,
		rations_core_hunt_grou = true,
		rations_core_more_res = true,
		rations_core_waves_spec = true,
		rations_destroy = true,
		rations_destroy_embers = true,
		rations_destroy_embers_hunt_grou = true,
		rations_destroy_embers_more_res = true,
		rations_destroy_embers_waves_spec = true,
		rations_destroy_hunt_grou = true,
		rations_destroy_more_res = true,
		rations_destroy_waves_spec = true,
		rations_recover = true,
		rations_recover_hunt_grou = true,
		rations_recover_more_res = true,
		rations_recover_waves_spec = true,
	}

	stat_definitions.hook_stolen_rations_destroyed = {
		flags = {
			StatFlags.hook,
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
	stat_definitions.stolen_rations_destroyed = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		triggers = {
			{
				id = "hook_stolen_rations_destroyed",
				trigger = StatMacros.increment_by,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
	stat_definitions.stolen_rations_destroyed_team = {
		flags = {
			StatFlags.team,
			StatFlags.never_log,
			StatFlags.no_sync,
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		triggers = {
			{
				id = "hook_stolen_rations_destroyed",
				trigger = StatMacros.forward,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
	stat_definitions.hook_stolen_rations_recovered = {
		flags = {
			StatFlags.hook,
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
	stat_definitions.stolen_rations_recovered_team = {
		flags = {
			StatFlags.team,
			StatFlags.never_log,
			StatFlags.no_sync,
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		triggers = {
			{
				id = "hook_stolen_rations_recovered",
				trigger = StatMacros.forward,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
	stat_definitions.stolen_rations_recovered = {
		flags = {
			StatFlags.no_sync,
			StatFlags.never_log,
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		triggers = {
			{
				id = "hook_stolen_rations_recovered",
				trigger = StatMacros.increment_by,
			},
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
	stat_definitions.stolen_rations_handled = {
		flags = {
			StatFlags.no_recover,
		},
		triggers = {
			{
				id = "stolen_rations_destroyed_team",
				trigger = StatMacros.increment_by,
			},
			{
				id = "stolen_rations_recovered_team",
				trigger = StatMacros.increment_by,
			},
		},
		data = {
			circumstances = stolen_rations_circumstances,
		},
		include_condition = function (self, config)
			local circumstance_name = config.circumstance_name

			return self.data.circumstances[circumstance_name]
		end,
	}
end

stat_definitions.hook_saint_points_acquired = {
	flags = {
		StatFlags.hook,
		StatFlags.team,
	},
	data = {
		stat_override = "saints",
	},
	include_condition = function (self, config)
		return StatConfigMacros.circumstance_has_stat_override(config, self.data.stat_override)
	end,
}
stat_definitions.saint_points_acquired = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "hook_saint_points_acquired",
			trigger = StatMacros.increment_by,
		},
	},
	data = {
		stat_override = "saints",
	},
	include_condition = function (self, config)
		return StatConfigMacros.circumstance_has_stat_override(config, self.data.stat_override)
	end,
}
stat_definitions.hook_on_syringe_use_team = {
	flags = {
		StatFlags.team,
	},
	triggers = {
		{
			id = "hook_on_syringe_use",
			trigger = StatMacros.forward,
		},
	},
	data = {
		stat_override = "live_event_broker_stimms",
	},
	include_condition = function (self, config)
		return StatConfigMacros.circumstance_has_stat_override(config, self.data.stat_override)
	end,
}
stat_definitions.broker_stimms_points_acquired = {
	flags = {
		StatFlags.no_recover,
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	data = {
		stat_override = "live_event_broker_stimms",
	},
	include_condition = function (self, config)
		return StatConfigMacros.circumstance_has_stat_override(config, self.data.stat_override)
	end,
}
stat_definitions.live_event_stimms_used_team = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	triggers = {
		{
			id = "hook_on_syringe_use",
			trigger = function (self, stat_data, amount)
				return constant(self, stat_data, 1)
			end,
		},
	},
	data = {
		stat_override = "live_event_broker_stimms",
	},
	include_condition = function (self, config)
		return StatConfigMacros.circumstance_has_stat_override(config, self.data.stat_override)
	end,
}
stat_definitions.abhuman_explosions_mission_won = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
	},
	data = {
		circumstances = {
			abhuman_explosions = true,
			abhuman_explosions_darkness = true,
			abhuman_explosions_gas = true,
			abhuman_explosions_hunt_grou = true,
			abhuman_explosions_more_res = true,
			abhuman_explosions_ventilation = true,
			abhuman_explosions_waves_spec = true,
		},
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment,
		},
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return self.data.circumstances[circumstance_name]
	end,
}
stat_definitions = _stat_data

for _, stat in pairs(stat_definitions) do
	stat.flags = table.set(stat.flags)
	stat.default = stat.default or 0
end

return settings("StatDefinitions", stat_definitions)
