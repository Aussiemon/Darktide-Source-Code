local Archetypes = require("scripts/settings/archetype/archetypes")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local StatFlags = require("scripts/managers/stats/stat_flags")
local StatMacros = require("scripts/managers/stats/stat_macros")
local Weakspot = require("scripts/utilities/attack/weakspot")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local _stat_count = 0
local _stat_data = {}
local StatDefinitions = setmetatable({}, {
	__index = function (_, key)
		return _stat_data[key]
	end,
	__newindex = function (_, key, value)
		_stat_data[key] = value
		_stat_count = _stat_count + 1
		value.id = key
		value.index = _stat_count
	end
})

local function _sorted(t)
	table.sort(t)

	return t
end

local breed_name_to_sub_faction_lookup = {}

for breed_name, breed in pairs(Breeds) do
	local sub_faction_name = breed.sub_faction_name
	breed_name_to_sub_faction_lookup[breed_name] = sub_faction_name
end

local archetype_names = _sorted(table.keys(Archetypes))
local breed_names = _sorted(table.keys(table.conditional_copy(Breeds, function (_, value)
	return value.faction_name == "chaos"
end)))
local mission_types = _sorted(table.keys(MissionTypes))
local mission_templates = _sorted(table.keys(table.conditional_copy(MissionTemplates, function (_, value)
	return not value.is_dev_mission and not value.is_hub
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
local weapons_with_activated_specials = table.set(table.keys(table.conditional_copy(WeaponTemplates, function (_, weapon)
	return WeaponTemplate.has_keyword(weapon, "activated")
end)))

local function is_weakspot_hit(attack_data)
	local breed = Breeds[attack_data.target_breed_name]
	local hit_zone_name = attack_data.hit_zone_name
	local is_weak_spot_hit = Weakspot.hit_weakspot(breed, hit_zone_name)

	return is_weak_spot_hit
end

local function read_stat(stat_definition, stat_data)
	local id = stat_definition.id

	return stat_data[id] or stat_definition.default
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

StatDefinitions.hook_player_spawned = {
	flags = {
		StatFlags.hook
	}
}

local function include_condition(self, config)
	local correct_archetype_name = self.data.archetype_name == config.archetype_name
	local is_hub = config.is_hub

	return is_hub and correct_archetype_name
end

for i = 1, #archetype_names do
	local archetype_name = archetype_names[i]
	local stat_name = string.format("max_rank_%s", archetype_name)
	StatDefinitions[stat_name] = {
		flags = {
			StatFlags.backend
		},
		data = {
			archetype_name = archetype_name
		},
		triggers = {
			{
				id = "hook_player_spawned",
				trigger = function (self, stat_data, profile)
					local current_level = profile.current_level or 0

					return set_to_max(self, stat_data, current_level)
				end
			}
		},
		include_condition = include_condition
	}
end

StatDefinitions.hook_ranged_attack_concluded = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.shots_fired = {
	flags = {},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.shots_missed = {
	flags = {},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if not hit_minion then
					return increment(self, stat_data)
				end
			end
		}
	}
}

local function accuracy_function(self, stat_data, _)
	local total_shots = read_stat(StatDefinitions.shots_fired, stat_data)
	local missed_shots = read_stat(StatDefinitions.shots_missed, stat_data)
	local percentage_raw = 1 - missed_shots / total_shots
	local accuracy = math.round(100 * percentage_raw)
	local id = self.id
	stat_data[id] = accuracy

	return self.id, accuracy
end

StatDefinitions.accuracy = {
	default = 0,
	flags = {},
	triggers = {
		{
			id = "shots_fired",
			trigger = accuracy_function
		},
		{
			id = "shots_missed",
			trigger = accuracy_function
		}
	}
}
StatDefinitions.shot_hit_weakspot = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_recover,
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if hit_weakspot then
					return self.id, hit_minion, hit_weakspot, killing_blow, last_round_in_mag
				end
			end
		}
	}
}
StatDefinitions.shot_missed_weakspot = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_recover,
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if not hit_weakspot then
					return self.id, hit_minion, hit_weakspot, killing_blow, last_round_in_mag
				end
			end
		}
	}
}
StatDefinitions.hook_projectile_hit = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_health_update = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log
	}
}
StatDefinitions.time_spent_on_last_health_segment = {
	flags = {
		StatFlags.never_log
	},
	triggers = {
		{
			id = "hook_health_update",
			trigger = function (self, stat_data, dt, remaining_health_segments, is_knocked_down)
				if not is_knocked_down and remaining_health_segments <= 0 then
					return increment_by(self, stat_data, dt)
				end
			end
		}
	}
}
StatDefinitions.hook_alternate_fire_start = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_alternate_fire_stop = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.alternate_fire_active = {
	flags = {
		StatFlags.no_recover,
		StatFlags.never_log,
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_alternate_fire_start",
			trigger = function (self, stat_data)
				return set_to_max(self, stat_data, 1)
			end
		},
		{
			id = "hook_alternate_fire_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	}
}
StatDefinitions.hook_kill = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.team_kill = {
	flags = {
		StatFlags.team,
		StatFlags.never_log,
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.forward
		}
	}
}
StatDefinitions.session_team_kills = {
	flags = {
		StatFlags.team
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.local_team_kills = {
	flags = {},
	triggers = {
		{
			id = "team_kill",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.total_kills = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.increment
		}
	}
}
local tree = {}

for _, sub_faction_name in ipairs({
	"chaos",
	"renegade",
	"cultist"
}) do
	for _, attack_type in ipairs({
		"melee",
		"ranged",
		"explosion"
	}) do
		local stat_name = string.format("team_%s_killed_with_%s", sub_faction_name, attack_type)
		StatDefinitions[stat_name] = {
			flags = {
				StatFlags.never_log
			}
		}
		tree[sub_faction_name] = tree[sub_faction_name] or {}
		tree[sub_faction_name][attack_type] = stat_name
	end
end

StatDefinitions.team_killed_with_splitter = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	},
	data = {
		stat_lookup = tree,
		breed_lookup = breed_name_to_sub_faction_lookup
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
			end
		}
	}
}
local tree = {}

for _, sub_faction_name in ipairs({
	"chaos",
	"renegade",
	"cultist"
}) do
	for _, attack_type in ipairs({
		"melee",
		"ranged",
		"explosion"
	}) do
		local stat_name = string.format("%s_killed_with_%s", sub_faction_name, attack_type)
		StatDefinitions[stat_name] = {
			flags = {}
		}
		tree[sub_faction_name] = tree[sub_faction_name] or {}
		tree[sub_faction_name][attack_type] = stat_name
	end
end

StatDefinitions.killed_with_splitter = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	},
	data = {
		stat_lookup = tree,
		breed_lookup = breed_name_to_sub_faction_lookup
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
			end
		}
	}
}
local breed_to_stat = {}

for i = 1, #breed_names do
	local breed_name = breed_names[i]
	local id = string.format("%s_killed", breed_name)
	breed_to_stat[breed_name] = id
	local flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	}
	StatDefinitions[id] = {
		flags = flags
	}
end

StatDefinitions.breed_kill_splitter = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	},
	data = {
		breed_to_stat = breed_to_stat
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local breed_name = attack_data.target_breed_name
				local id = self.data.breed_to_stat[breed_name]

				return id, attack_data
			end
		}
	}
}

for i = 1, #breed_names do
	local breed_name = breed_names[i]
	local hook_id = breed_to_stat[breed_name]
	local stat_id = string.format("total_%s_killed", breed_name)
	StatDefinitions[stat_id] = {
		flags = {
			StatFlags.backend
		},
		triggers = {
			{
				id = hook_id,
				trigger = StatMacros.increment
			}
		},
		stat_name = Breeds[breed_name].display_name
	}
end

local function breed_kill_triggers(breeds)
	local triggers = {}

	for i = 1, #breeds do
		local hook_id = breed_to_stat[breeds[i]]
		triggers[i] = {
			id = hook_id,
			trigger = StatMacros.increment
		}
	end

	return triggers
end

StatDefinitions.total_renegade_kills = {
	flags = {
		StatFlags.backend
	},
	triggers = breed_kill_triggers(renegade_breeds)
}
StatDefinitions.total_cultist_kills = {
	flags = {
		StatFlags.backend
	},
	triggers = breed_kill_triggers(cultist_breeds)
}
StatDefinitions.total_chaos_kills = {
	flags = {
		StatFlags.backend
	},
	triggers = breed_kill_triggers(chaos_breeds)
}
StatDefinitions.head_shot_kill = {
	flags = {
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local is_head_shot = attack_data.attack_type == "ranged" and is_weakspot_hit(attack_data)

				if is_head_shot then
					return self.id, attack_data
				end
			end
		}
	}
}
StatDefinitions.non_head_shot_kill = {
	flags = {
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local is_head_shot = attack_data.attack_type == "ranged" and is_weakspot_hit(attack_data)

				if not is_head_shot then
					return self.id, attack_data
				end
			end
		}
	}
}
StatDefinitions.head_shot_kills_last_10_sec = {
	flags = {
		StatFlags.no_recover
	},
	triggers = {
		{
			id = "head_shot_kill",
			trigger = StatMacros.increment
		},
		{
			id = "head_shot_kill",
			trigger = StatMacros.decrement,
			delay = seconds(10)
		}
	}
}
StatDefinitions.max_head_shot_kills_last_10_sec = {
	running_stat = "head_shot_kills_last_10_sec",
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "head_shot_kills_last_10_sec",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.head_shot_kills_in_a_row = {
	flags = {
		StatFlags.no_recover
	},
	triggers = {
		{
			id = "head_shot_kill",
			trigger = StatMacros.increment
		},
		{
			id = "non_head_shot_kill",
			trigger = function (self, stat_data, attack_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	}
}
StatDefinitions.max_head_shot_in_a_row = {
	running_stat = "head_shot_kills_in_a_row",
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "head_shot_kills_in_a_row",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.kills_last_60_sec = {
	flags = {
		StatFlags.no_recover
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = StatMacros.increment
		},
		{
			id = "hook_kill",
			trigger = StatMacros.decrement,
			delay = seconds(30)
		}
	}
}
StatDefinitions.max_kills_last_60_sec = {
	running_stat = "kills_last_60_sec",
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "kills_last_60_sec",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.kill_climbing = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local action = attack_data.target_action

				if action == "climb" then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.ledge_kill = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local damage_profile_name = attack_data.damage_profile_name

				if damage_profile_name == "kill_volume_and_off_navmesh" then
					return self.id, attack_data
				end
			end
		}
	}
}
StatDefinitions.hook_boss_died = {
	flags = {
		StatFlags.hook,
		StatFlags.team
	}
}
StatDefinitions.fastest_boss_kill = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_boss_died",
			trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
				return set_to_min(self, stat_data, time_since_first_damage)
			end
		}
	},
	default = hours(5)
}
StatDefinitions.session_boss_kills = {
	flags = {},
	triggers = {
		{
			id = "hook_boss_died",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.hook_damage_dealt = {
	flags = {
		StatFlags.hook
	}
}
local breed_to_stat = {}

for i = 1, #breed_names do
	local breed_name = breed_names[i]
	local id = string.format("%s_damaged", breed_name)
	breed_to_stat[breed_name] = id
	local flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	}
	StatDefinitions[id] = {
		flags = flags
	}
end

StatDefinitions.breed_damage_splitter = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	},
	data = {
		breed_to_stat = breed_to_stat
	},
	triggers = {
		{
			id = "hook_damage_dealt",
			trigger = function (self, stat_data, attack_data)
				local breed_name = attack_data.target_breed_name
				local id = self.data.breed_to_stat[breed_name]

				return id, attack_data
			end
		}
	}
}
StatDefinitions.hook_buff = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_damage_taken = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.session_damage_taken = {
	flags = {},
	triggers = {
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
				return increment_by(self, stat_data, damage_dealt)
			end
		}
	}
}
StatDefinitions.session_team_damage_taken = {
	flags = {
		StatFlags.team
	},
	triggers = {
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
				return increment_by(self, stat_data, damage_dealt)
			end
		}
	}
}
StatDefinitions.hook_dodged_attack = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.dodges_in_a_row = {
	flags = {
		StatFlags.no_recover
	},
	triggers = {
		{
			id = "hook_dodged_attack",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				if attack_type ~= "ranged" and dodge_type == "dodge" then
					return increment(self, stat_data)
				end
			end
		},
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				return set_to_min(self, stat_data, 0)
			end
		}
	}
}
StatDefinitions.max_dodges_in_a_row = {
	running_stat = "dodges_in_a_row",
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "dodges_in_a_row",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.total_sprint_dodges = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_dodged_attack",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				if attack_type == "ranged" and dodge_type == "sprint" then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.total_slide_dodges = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_dodged_attack",
			trigger = function (self, stat_data, breed_name, attack_type, dodge_type)
				if dodge_type == "slide" then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.hook_blocked_damage = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.team_blocked_damage = {
	flags = {
		StatFlags.team,
		StatFlags.no_sync,
		StatFlags.never_log
	},
	triggers = {
		{
			id = "hook_blocked_damage",
			trigger = StatMacros.forward
		}
	}
}
StatDefinitions.session_my_blocked_damage = {
	flags = {},
	triggers = {
		{
			id = "hook_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, damage_blocked)
			end
		}
	}
}
StatDefinitions.session_team_blocked_damage = {
	flags = {},
	triggers = {
		{
			id = "team_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, damage_blocked)
			end
		}
	}
}
StatDefinitions.damage_blocked_last_20_sec = {
	flags = {
		StatFlags.no_recover
	},
	triggers = {
		{
			id = "hook_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, damage_blocked)
			end
		},
		{
			id = "hook_blocked_damage",
			trigger = function (self, stat_data, weapon_template_name, damage_blocked)
				return increment_by(self, stat_data, -damage_blocked)
			end,
			delay = seconds(10)
		}
	}
}
StatDefinitions.max_damage_blocked_last_20_sec = {
	running_stat = "damage_blocked_last_20_sec",
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "damage_blocked_last_20_sec",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.hook_knocked_down = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.session_knock_downs = {
	flags = {},
	triggers = {
		{
			id = "hook_knocked_down",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.team_knock_downs = {
	flags = {
		StatFlags.team
	},
	triggers = {
		{
			id = "hook_knocked_down",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.hook_death = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.session_deaths = {
	flags = {},
	triggers = {
		{
			id = "hook_death",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.team_deaths = {
	flags = {
		StatFlags.team
	},
	triggers = {
		{
			id = "hook_death",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.hook_collect_material = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.team_collect_material = {
	flags = {
		StatFlags.no_sync,
		StatFlags.team,
		StatFlags.never_log
	},
	triggers = {
		{
			id = "hook_collect_material",
			trigger = StatMacros.forward
		}
	}
}

local function material_increases(self, stat_data, type, amount)
	local desired_material = self.data.material

	if type == desired_material then
		return increment_by(self, stat_data, amount)
	end
end

for _, material in ipairs({
	"plasteel",
	"diamantine"
}) do
	local total_id = string.format("total_%s_collected", material)
	StatDefinitions[total_id] = {
		flags = {
			StatFlags.backend
		},
		data = {
			material = material
		},
		triggers = {
			{
				id = "hook_collect_material",
				trigger = material_increases
			}
		}
	}
	local team_id = string.format("team_%s_collected", material)
	StatDefinitions[team_id] = {
		flags = {
			StatFlags.team
		},
		data = {
			material = material
		},
		triggers = {
			{
				id = "hook_collect_material",
				trigger = material_increases
			}
		}
	}
	local seen_id = string.format("seen_%s_collected", material)
	StatDefinitions[seen_id] = {
		flags = {
			StatFlags
		},
		data = {
			material = material
		},
		triggers = {
			{
				id = "team_collect_material",
				trigger = material_increases
			}
		}
	}
end

local function _max_difficulty(self, stat_data, difficulty)
	return set_to_max(self, stat_data, difficulty)
end

StatDefinitions.hook_mission_ended = {
	flags = {
		StatFlags.hook,
		StatFlags.team
	}
}
StatDefinitions.mission_won = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log,
		StatFlags.team
	},
	triggers = {
		{
			id = "hook_mission_ended",
			trigger = function (self, stat_data, won, ...)
				if won then
					return self.id, ...
				end
			end
		}
	}
}
StatDefinitions.whole_mission_won = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.forward
		}
	},
	include_condition = function (self, config)
		return config.joined_at <= 0.05
	end
}
StatDefinitions.missions = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.mission_circumstance = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment
		}
	},
	include_condition = function (self, config)
		local circumstance_name = config.circumstance_name

		return circumstance_name ~= nil and circumstance_name ~= "default"
	end
}
StatDefinitions.mission_flash = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "mission_won",
			trigger = StatMacros.increment
		}
	},
	include_condition = function (self, config)
		return config.is_flash_mission
	end
}
StatDefinitions.max_difficulty_flash = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "mission_won",
			trigger = _max_difficulty
		}
	},
	include_condition = function (self, config)
		return config.is_flash_mission
	end
}

for i = 1, #mission_types do
	local mission_type = mission_types[i]
	local stat_name = string.format("type_%s_missions", MissionTypes[mission_type].id)
	StatDefinitions[stat_name] = {
		flags = {
			StatFlags.backend
		},
		data = {
			mission_type = mission_type
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.increment
			}
		},
		include_condition = function (self, config)
			return self.data.mission_type == config.mission_type
		end
	}
end

for i = 1, #mission_types do
	local mission_type = mission_types[i]
	local mission_type_id = MissionTypes[mission_type].id
	local stat_name = string.format("max_difficulty_%s_mission", mission_type_id)
	StatDefinitions[stat_name] = {
		flags = {
			StatFlags.backend
		},
		data = {
			mission_type = mission_type
		},
		stat_name = MissionTypes[mission_type].name,
		triggers = {
			{
				id = "mission_won",
				trigger = _max_difficulty
			}
		},
		include_condition = function (self, config)
			return self.data.mission_type == config.mission_type
		end,
		init = function (self, stat_data)
			for difficulty = 5, 1, -1 do
				local old_id = string.format("_mission_difficulty_%s_objectives_%s_flag", difficulty, mission_type_id)

				if stat_data[old_id] then
					return difficulty
				end
			end
		end
	}
end

for i = 1, #mission_templates do
	local mission_name = mission_templates[i]
	local stat_name = string.format("__m_%s_md", mission_name)
	StatDefinitions[stat_name] = {
		flags = {
			StatFlags.backend
		},
		data = {
			mission_name = mission_name
		},
		triggers = {
			{
				id = "mission_won",
				trigger = _max_difficulty
			}
		},
		include_condition = function (self, config)
			return self.data.mission_name == config.mission_name
		end
	}
end

for i = 1, #archetype_names do
	local archetype_name = archetype_names[i]
	local stat_name = string.format("missions_%s_2", archetype_name)
	StatDefinitions[stat_name] = {
		flags = {
			StatFlags.backend
		},
		data = {
			archetype_name = archetype_name
		},
		triggers = {
			{
				id = "mission_won",
				trigger = StatMacros.increment
			}
		},
		include_condition = function (self, config)
			return self.data.archetype_name == config.archetype_name
		end
	}

	for j = 1, #mission_types do
		local mission_type = mission_types[j]
		local mission_type_id = MissionTypes[mission_type].id
		local stat_name = string.format("mission_type_%s_max_difficulty_%s", mission_type_id, archetype_name)
		StatDefinitions[stat_name] = {
			flags = {
				StatFlags.backend
			},
			stat_name = MissionTypes[mission_type].name,
			data = {
				mission_type = mission_type,
				archetype_name = archetype_name
			},
			triggers = {
				{
					id = "mission_won",
					trigger = _max_difficulty
				}
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
					local old_id = string.format("_mission_%s_2_%s_objectives_%s_flag", data.archetype_name, difficulty, mission_type_id)

					if stat_data[old_id] then
						return difficulty
					end
				end
			end
		}
	end

	for difficulty = 1, 5 do
		local stat_id = string.format("missions_%s_2_difficulty_%s", archetype_name, difficulty)
		StatDefinitions[stat_id] = {
			flags = {
				StatFlags.backend
			},
			data = {
				archetype_name = archetype_name,
				difficulty = difficulty
			},
			triggers = {
				{
					id = "mission_won",
					trigger = StatMacros.increment
				}
			},
			include_condition = function (self, config)
				local data = self.data
				local correct_difficulty = data.difficulty <= config.difficulty
				local correct_archetype_name = config.archetype_name == data.archetype_name

				return correct_difficulty and correct_archetype_name
			end
		}
	end
end

StatDefinitions.flawless_missions_in_a_row = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data)
				local session_deaths = read_stat(StatDefinitions.session_deaths, stat_data)
				local session_knock_downs = read_stat(StatDefinitions.session_knock_downs, stat_data)

				if session_deaths == 0 and session_knock_downs == 0 then
					return increment(self, stat_data)
				else
					return set_to_min(self, stat_data, 0)
				end
			end
		},
		{
			id = "hook_knocked_down",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		},
		{
			id = "hook_death",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	},
	include_condition = function (self, config)
		return config.difficulty >= 3
	end
}
StatDefinitions.max_flawless_mission_in_a_row = {
	running_stat = "flawless_missions_in_a_row",
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "flawless_missions_in_a_row",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.team_flawless_missions = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data, difficulty)
				local team_downs = read_stat(StatDefinitions.team_knock_downs, stat_data)

				if team_downs == 0 then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.lowest_damage_taken_on_win = {
	default = 9999,
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data, difficulty)
				local damage_taken = read_stat(StatDefinitions.session_damage_taken, stat_data)

				return set_to_min(self, stat_data, damage_taken)
			end
		}
	}
}
StatDefinitions.hook_lunge_start = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_lunge_stop = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_lunge_distance = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.is_lunging = {
	flags = {
		StatFlags.no_sync,
		StatFlags.no_recover,
		StatFlags.never_log
	},
	triggers = {
		{
			id = "hook_lunge_start",
			trigger = function (self, stat_data)
				return set_to_max(self, stat_data, 1)
			end
		},
		{
			id = "hook_lunge_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	}
}
StatDefinitions.hook_toughness_regenerated = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log
	}
}
StatDefinitions.hook_toughness_broken = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.total_coherency_toughness = {
	flags = {
		StatFlags.backend,
		StatFlags.never_log
	},
	data = {
		cap = 2000
	},
	triggers = {
		{
			id = "hook_toughness_regenerated",
			trigger = function (self, stat_data, reason, starting_amount, amount)
				local id = self.id
				local current_value = stat_data[id] or self.default
				local cap = self.data.cap

				if reason == "coherency" and current_value <= cap then
					stat_data[id] = math.min(current_value + amount, cap)

					return id, stat_data[id]
				end
			end
		}
	}
}
StatDefinitions.total_melee_toughness_regen = {
	flags = {
		StatFlags.backend
	},
	data = {
		cap = 40000
	},
	triggers = {
		{
			id = "hook_toughness_regenerated",
			trigger = function (self, stat_data, reason, starting_amount, amount)
				if reason == "melee_kill" then
					local id = self.id
					local current_value = stat_data[id] or self.default
					local cap = self.data.cap

					if current_value <= cap then
						stat_data[id] = math.min(current_value + amount, cap)

						return id, stat_data[id]
					end
				end
			end
		}
	}
}
StatDefinitions.hook_picked_item = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_shared_item = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_discard_item = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_placed_item = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.total_deployables_placed = {
	flags = {
		StatFlags.backend
	},
	data = {
		item_lookup = table.set({
			"medical_crate_deployable",
			"ammo_cache_deployable"
		})
	},
	triggers = {
		{
			id = "hook_placed_item",
			trigger = function (self, stat_data, item_name)
				local item_lookup = self.data.item_lookup

				if item_lookup[item_name] then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.hook_assist_ally = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_rescue_ally = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.total_player_rescues = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_rescue_ally",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.total_player_assists = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_assist_ally",
			trigger = function (self, stat_data, target_id, assistance_type)
				if assistance_type == "revive" then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.hook_escaped_captivitiy = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.longest_time_spent_in_captivity = {
	flags = {},
	triggers = {
		{
			id = "hook_escaped_captivitiy",
			trigger = function (self, stat_data, state_name, time_disabled)
				return set_to_max(self, stat_data, time_disabled)
			end
		}
	}
}
StatDefinitions.team_longest_time_spent_in_captivity = {
	flags = {
		StatFlags.team
	},
	triggers = {
		{
			id = "longest_time_spent_in_captivity",
			trigger = StatMacros.set_to_max
		}
	}
}
StatDefinitions.session_time_spent_in_captivity = {
	flags = {},
	triggers = {
		{
			id = "hook_escaped_captivitiy",
			trigger = function (self, stat_data, state_name, time_disabled)
				return increment_by(self, stat_data, time_disabled)
			end
		}
	}
}
StatDefinitions.different_players_rescued = {
	flags = {
		StatFlags.no_sync
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
			end
		}
	}
}
StatDefinitions.max_different_players_rescued = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "mission_won",
			trigger = function (self, stat_data, difficulty)
				local rescued_players = stat_data.different_players_rescued

				if rescued_players then
					local amount_of_different_rescued_players = table.size(rescued_players)

					return set_to_max(self, stat_data, amount_of_different_rescued_players)
				end
			end
		}
	}
}
StatDefinitions.hook_coherency_update = {
	flags = {
		StatFlags.hook,
		StatFlags.never_log
	}
}
StatDefinitions.session_time_coherency = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync
	},
	triggers = {
		{
			id = "hook_coherency_update",
			trigger = function (self, stat_data, time_since_update, units_in_coherency)
				if units_in_coherency > 1 then
					return increment_by(self, stat_data, time_since_update)
				end
			end
		}
	}
}
StatDefinitions.hook_sweep_finished = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_scan = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.total_scans = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_scan",
			trigger = function (self, stat_data, amount)
				return increment_by(self, stat_data, amount)
			end
		}
	}
}
StatDefinitions.hook_hack = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.total_hacks = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_hack",
			trigger = StatMacros.increment
		}
	}
}
StatDefinitions.perfect_hacks = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_hack",
			trigger = function (self, stat_data, mistakes)
				if mistakes == 0 then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.hook_ammo_consumed = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.remaining_primary_ammo = {
	default = 0,
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
		StatFlags.no_recover
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
			end
		}
	}
}
StatDefinitions.remaining_secondary_ammo = {
	default = 0,
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
		StatFlags.no_recover
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
			end
		}
	}
}
StatDefinitions.total_renegade_grenadier_melee = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "renegade_grenadier_killed",
			trigger = function (self, stat_data, attack_data)
				local attack_type = attack_data.attack_type

				if attack_type == "melee" then
					local id = self.id
					stat_data[id] = (stat_data[id] or self.default) + 1

					return id, stat_data[id]
				end
			end
		}
	}
}
StatDefinitions.id_of_renegade_executors_hit_by_weakspot = {
	default = false,
	flags = {
		StatFlags.no_sync,
		StatFlags.team
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
			end
		}
	}
}
StatDefinitions.total_renegade_executors_non_headshot = {
	flags = {
		StatFlags.backend
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
			end
		}
	}
}
StatDefinitions.total_cultist_berzerker_head = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "cultist_berzerker_killed",
			trigger = function (self, stat_data, attack_data)
				local hit_zone_name = attack_data.hit_zone_name

				if hit_zone_name == "head" then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.total_ogryn_gunner_melee = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "chaos_ogryn_gunner_killed",
			trigger = function (self, stat_data, attack_data)
				local attack_type = attack_data.attack_type

				if attack_type == "melee" then
					return increment(self, stat_data)
				end
			end
		}
	}
}
StatDefinitions.kill_daemonhost = {
	flags = {
		StatFlags.backend
	},
	triggers = {
		{
			id = "hook_boss_died",
			trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
				if breed_name == "chaos_daemonhost" then
					return set_to_max(self, stat_data, 1)
				end
			end
		}
	}
}

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

local include_condition = archetype_include_condition("veteran")
StatDefinitions.hook_volley_fire_start = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_volley_fire_stop = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_veteran_ammo_given = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_veteran_kill_volley_fire_target = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.volley_fire_active = {
	flags = {
		StatFlags.no_sync,
		StatFlags.no_recover,
		StatFlags.never_log
	},
	data = {},
	triggers = {
		{
			id = "hook_volley_fire_start",
			trigger = function (self, stat_data)
				return set_to_max(self, stat_data, 1)
			end
		},
		{
			id = "hook_volley_fire_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.weakspot_hit_during_volley_fire_alternate_fire = {
	flags = {},
	data = {},
	triggers = {
		{
			id = "shot_hit_weakspot",
			trigger = function (self, stat_data)
				local volley_fire_active = read_stat(StatDefinitions.volley_fire_active, stat_data) == 1
				local alternate_fire_active = read_stat(StatDefinitions.alternate_fire_active, stat_data) == 1

				if volley_fire_active and alternate_fire_active then
					return increment(self, stat_data)
				end
			end
		},
		{
			id = "shot_missed_weakspot",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		},
		{
			id = "hook_volley_fire_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_weakspot_hit_during_volley_fire_alternate_fire = {
	running_stat = "weakspot_hit_during_volley_fire_alternate_fire",
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "weakspot_hit_during_volley_fire_alternate_fire",
			trigger = StatMacros.set_to_max
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_veteran_2_kills_with_last_round_in_mag = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_ranged_attack_concluded",
			trigger = function (self, stat_data, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
				if last_round_in_mag and killing_blow then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_melee_damage_taken = {
	flags = {},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
				if attack_type == "melee" then
					return increment_by(self, stat_data, damage_dealt)
				end
			end
		}
	}
}
StatDefinitions.veteran_min_melee_damage_taken = {
	default = 999,
	running_stat = "veteran_melee_damage_taken",
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data)
				local damage_taken = read_stat(StatDefinitions.veteran_melee_damage_taken, stat_data)

				return set_to_min(self, stat_data, damage_taken)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.elite_weakspot_kill_during_volley_fire_alternate_fire = {
	flags = {},
	data = {
		difficulty = 4,
		breed_lookup = volley_fire_target_breed_lookup
	},
	triggers = {
		{
			id = "head_shot_kill",
			trigger = function (self, stat_data, attack_data)
				local breed_name = attack_data.target_breed_name

				if self.data.breed_lookup[breed_name] then
					return increment(self, stat_data)
				end
			end
		},
		{
			id = "hook_volley_fire_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_elite_weakspot_kill_during_volley_fire_alternate_fire = {
	running_stat = "elite_weakspot_kill_during_volley_fire_alternate_fire",
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "elite_weakspot_kill_during_volley_fire_alternate_fire",
			trigger = StatMacros.set_to_max
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_accuracy_at_end_of_mission_with_no_ammo_left = {
	running_stat = "accuracy",
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data)
				local accuracy = read_stat(StatDefinitions.accuracy, stat_data)
				local remaining_secondary_ammo = read_stat(StatDefinitions.remaining_secondary_ammo, stat_data)

				if remaining_secondary_ammo == 0 then
					return set_to_max(self, stat_data, accuracy)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_2_weakspot_kills = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "head_shot_kill",
			trigger = StatMacros.increment
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_2_ammo_given = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "hook_veteran_ammo_given",
			trigger = function (self, stat_data, ammo_given)
				return increment_by(self, stat_data, ammo_given)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_2_kill_volley_fire_target_malice = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_veteran_kill_volley_fire_target",
			trigger = StatMacros.increment
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_2_long_range_kills = {
	flags = {
		StatFlags.backend
	},
	data = {
		distance = 30,
		difficulty = 3,
		breed_lookup = ranged_breed_lookup
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.elite_or_special_kills_during_current_volley_fire = {
	flags = {
		StatFlags.no_recover,
		StatFlags.no_sync
	},
	data = {
		difficulty = 4,
		breed_lookup = special_and_elite_breed_lookup
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

				local volley_fire_active = read_stat(StatDefinitions.volley_fire_active, stat_data)

				if volley_fire_active then
					return increment(self, stat_data)
				end
			end
		},
		{
			id = "hook_volley_fire_stop",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_multiple_elite_or_special_kills_during_volley_fire_heresy = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "elite_or_special_kills_during_current_volley_fire",
			trigger = function (self, stat_data, amount)
				if amount == 2 then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.veteran_2_extended_volley_fire_duration = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4,
		time = 20
	},
	triggers = {
		{
			id = "hook_volley_fire_stop",
			trigger = function (self, stat_data, volley_fire_tota_time)
				local required_time = self.data.time

				if required_time <= volley_fire_tota_time then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
local include_condition = archetype_include_condition("zealot")
StatDefinitions.hook_zealot_health_leeched_during_resist_death = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_martyrdom_stacks = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.last_seen_martyrdom_stacks = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
		StatFlags.no_recover
	},
	data = {},
	triggers = {
		{
			id = "hook_martyrdom_stacks",
			trigger = function (self, stat_data, stacks)
				local id = self.id
				stat_data[id] = stacks

				return id, stacks
			end
		}
	}
}
StatDefinitions.max_zealot_2_stagger_sniper_with_grenade_distance = {
	flags = {
		StatFlags.backend
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zelot_2_kill_mutant_charger_with_melee_while_dashing = {
	flags = {
		StatFlags.backend
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

				local is_lunging = read_stat(StatDefinitions.is_lunging, stat_data) == 1

				if not is_lunging then
					return
				end

				return increment(self, stat_data)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_shocked_kill = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync,
		StatFlags.no_recover
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_kills_of_shocked_enemies_last_15 = {
	flags = {
		StatFlags.no_recover
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "zealot_shocked_kill",
			trigger = StatMacros.increment
		},
		{
			id = "zealot_shocked_kill",
			delay = 10,
			trigger = StatMacros.decrement
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_zealot_2_kills_of_shocked_enemies_last_15 = {
	running_stat = "zealot_2_kills_of_shocked_enemies_last_15",
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "zealot_2_kills_of_shocked_enemies_last_15",
			trigger = function (self, stat_data, value)
				return set_to_max(self, stat_data, value)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_not_use_ranged_attacks = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data)
				local shots_fired = read_stat(StatDefinitions.shots_fired, stat_data)

				if shots_fired == 0 then
					return set_to_max(self, stat_data, 1)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_zealot_2_health_healed_with_leech_during_resist_death = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "hook_zealot_health_leeched_during_resist_death",
			trigger = function (self, stat_data, percent_leeched)
				return set_to_max(self, stat_data, percent_leeched)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_fastest_mission_with_low_health = {
	flags = {
		StatFlags.backend
	},
	data = {
		private_session = true,
		difficulty = 4,
		percent_at_low_health = 75
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data, difficulty, mission_time)
				local data = self.data
				local target_percent = data.percent_at_low_health / 100
				local time_at_low_health = read_stat(StatDefinitions.time_spent_on_last_health_segment, stat_data)
				local rounded_mission_time = math.round(mission_time)

				if time_at_low_health >= target_percent * mission_time then
					return set_to_min(self, stat_data, rounded_mission_time)
				end
			end
		}
	},
	include_condition = include_condition,
	default = minutes(99)
}
StatDefinitions.zealot_2_number_of_shocked_enemies = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "hook_buff",
			trigger = function (self, stat_data, breed_name, template_name, stack_count, weapon_template_name)
				if template_name == "shock_grenade_interval" then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_toughness_gained_from_chastise_the_wicked = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "hook_toughness_regenerated",
			trigger = function (self, stat_data, reason, starting_amount, amount)
				if reason == "lunging" then
					return increment_by(self, stat_data, amount)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_number_of_critical_hits_kills_when_stunned = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_kills_with_martyrdoom_stacks = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local attack_type = attack_data.attack_type

				if attack_type ~= "melee" then
					return
				end

				local martyrdom_stacks = read_stat(StatDefinitions.last_seen_martyrdom_stacks, stat_data)

				if martyrdom_stacks < 3 then
					return
				end

				return increment(self, stat_data)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_killed_elites_and_specials_with_activated_attacks = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4,
		weapon_lookup = weapons_with_activated_specials,
		breed_lookup = special_and_elite_breed_lookup
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.zealot_2_charged_enemy_wielding_ranged_weapon = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "hook_lunge_start",
			trigger = function (self, stat_data, has_target, target_is_ranged)
				if has_target and target_is_ranged then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
local include_condition = archetype_include_condition("psyker")
StatDefinitions.hook_psyker_time_at_max_souls = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_psyker_survived_perils = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_psyker_reached_max_souls = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.hook_psyker_lost_max_souls = {
	flags = {
		StatFlags.hook
	}
}
StatDefinitions.psyker_at_max_souls = {
	flags = {
		StatFlags.no_recover,
		StatFlags.never_log,
		StatFlags.no_sync
	},
	data = {},
	triggers = {
		{
			id = "hook_psyker_reached_max_souls",
			trigger = function (self, stat_data)
				return set_to_max(self, stat_data, 1)
			end
		},
		{
			id = "hook_psyker_lost_max_souls",
			trigger = function (self, stat_data)
				return set_to_min(self, stat_data, 0)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.smite_hound_mid_leap = {
	flags = {
		StatFlags.backend
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.psyker_2_edge_kills_last_2_sec = {
	flags = {
		StatFlags.no_recover
	},
	data = {},
	triggers = {
		{
			id = "ledge_kill",
			trigger = StatMacros.increment
		},
		{
			id = "ledge_kill",
			trigger = StatMacros.decrement,
			delay = seconds(2)
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_psyker_2_edge_kills_last_2_sec = {
	running_stat = "psyker_2_edge_kills_last_2_sec",
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "psyker_2_edge_kills_last_2_sec",
			trigger = StatMacros.set_to_max
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_psyker_2_time_at_max_souls = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_psyker_time_at_max_souls",
			trigger = function (self, stat_data, time_at_max)
				return set_to_max(self, stat_data, time_at_max)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.elite_or_special_kill_with_smite = {
	flags = {
		StatFlags.never_log,
		StatFlags.no_sync
	},
	data = {
		breed_lookup = special_and_elite_breed_lookup
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
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.elite_or_special_kills_with_smite_last_12_sec = {
	flags = {
		StatFlags.no_recover
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "elite_or_special_kill_with_smite",
			trigger = StatMacros.increment
		},
		{
			id = "elite_or_special_kill_with_smite",
			delay = 12,
			trigger = StatMacros.decrement
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_elite_or_special_kills_with_smite_last_12_sec = {
	running_stat = "elite_or_special_kills_with_smite_last_12_sec",
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "elite_or_special_kills_with_smite_last_12_sec",
			trigger = StatMacros.set_to_max
		}
	},
	include_condition = include_condition
}

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

StatDefinitions.smite_boss_damage_by_id = {
	flags = {
		StatFlags.no_recover,
		StatFlags.no_sync,
		StatFlags.never_log
	},
	data = {
		difficulty = 4,
		private_session = true
	},
	triggers = table.map(boss_breeds, function (breed_name)
		return {
			id = string.format("%s_damaged", breed_name),
			trigger = damaged_by_smite_trigger
		}
	end),
	include_condition = include_condition
}
StatDefinitions.max_smite_damage_done_to_boss = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4,
		private_session = true
	},
	triggers = {
		{
			id = "hook_boss_died",
			trigger = function (self, stat_data, breed_name, boss_max_health, boss_unit_id, time_since_first_damage)
				local damage_dealt = stat_data.smite_boss_damage_by_id and stat_data.smite_boss_damage_by_id[boss_unit_id] or 0
				local percentage_damage_dealt = math.round(100 * damage_dealt / (boss_max_health + 0.01))

				return set_to_max(self, stat_data, percentage_damage_dealt)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.psyker_2_elite_or_special_kills_with_smite = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "elite_or_special_kill_with_smite",
			trigger = StatMacros.increment
		}
	},
	include_condition = include_condition
}
StatDefinitions.psyker_2_survived_perils = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "hook_psyker_survived_perils",
			trigger = StatMacros.increment
		}
	},
	include_condition = include_condition
}
StatDefinitions.psyker_2_smite_kills_at_max_souls = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "elite_or_special_kill_with_smite",
			trigger = function (self, stat_data, attack_data)
				local at_max_souls = read_stat(StatDefinitions.psyker_at_max_souls, stat_data) == 1

				if at_max_souls then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.psyker_2_warp_kills = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3,
		damage_type_lookup = DamageSettings.warp_damage_types
	},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local damage_type = attack_data.damage_type

				if self.data.damage_type_lookup[damage_type] then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}

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

StatDefinitions.psyker_2_killed_disablers_before_disabling = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = table.map(disabler_breeds, function (breed_name)
		return {
			id = string.format("%s_killed", breed_name),
			trigger = kill_before_disabling
		}
	end),
	include_condition = include_condition
}
StatDefinitions.psyker_elite_melee_damage_taken = {
	flags = {
		StatFlags.no_sync,
		StatFlags.never_log
	},
	data = {
		difficulty = 4,
		breed_lookup = elite_breed_lookup
	},
	triggers = {
		{
			id = "hook_damage_taken",
			trigger = function (self, stat_data, damage_dealt, attack_type, attacker_breed)
				if attack_type == "melee" and self.data.breed_lookup[attacker_breed] then
					return increment_by(self, stat_data, damage_dealt)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.psyker_2_x_missions_no_elite_melee_damage_taken = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data, difficulty, time)
				local damage_taken = read_stat(StatDefinitions.psyker_elite_melee_damage_taken, stat_data)

				if damage_taken == 0 then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
local include_condition = archetype_include_condition("ogryn")
StatDefinitions.ogryn_2_killed_corruptor_with_grenade_impact = {
	flags = {
		StatFlags.backend
	},
	data = {},
	triggers = {
		{
			id = "hook_kill",
			trigger = function (self, stat_data, attack_data)
				local breed_name = attack_data.target_breed_name
				local weapon_template_name = attack_data.weapon_template_name
				local correct_breed = breed_name == "corruptor_body"
				local correct_weapon = weapon_template_name == "ogryn_grenade_box"

				if correct_breed and correct_weapon then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_win_with_coherency_all_alive_units = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data, difficulty, mission_time)
				local time_in_coherency = read_stat(StatDefinitions.session_time_coherency, stat_data)
				local raw_percentage_in_coherency = time_in_coherency / mission_time
				local percent_in_coherency = math.clamp(math.round(raw_percentage_in_coherency * 100), 0, 100)

				return set_to_max(self, stat_data, percent_in_coherency)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_ogryn_2_lunge_number_of_enemies_hit = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_lunge_stop",
			trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit)
				return set_to_max(self, stat_data, units_hit)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_lunge_distance_last_x_seconds = {
	flags = {
		StatFlags.no_recover
	},
	data = {
		difficulty = 4,
		private_session = true
	},
	triggers = {
		{
			id = "hook_lunge_distance",
			trigger = function (self, stat_data, delta_distance)
				return increment_by(self, stat_data, delta_distance)
			end
		},
		{
			delay = 20,
			id = "hook_lunge_distance",
			trigger = function (self, stat_data, delta_distance)
				return increment_by(self, stat_data, -delta_distance)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_ogryn_2_lunge_distance_last_x_seconds = {
	running_stat = "ogryn_2_lunge_distance_last_x_seconds",
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4,
		private_session = true
	},
	triggers = {
		{
			id = "ogryn_2_lunge_distance_last_x_seconds",
			trigger = StatMacros.set_to_max
		}
	},
	include_condition = include_condition
}
StatDefinitions.max_ogryns_bullrushed = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "hook_lunge_stop",
			trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit)
				return set_to_max(self, stat_data, ogryns_hit)
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_number_of_revived_or_assisted_allies = {
	flags = {
		StatFlags.backend
	},
	data = {
		assistance_types = table.set({
			"revive",
			"pull_up",
			"remove_net"
		})
	},
	triggers = {
		{
			id = "hook_assist_ally",
			trigger = function (self, stat_data, target_id, assistance_type)
				local assistance_type_lookup = self.data.assistance_types

				if assistance_type_lookup[assistance_type] then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_number_of_knocked_down_enemies = {
	flags = {
		StatFlags.backend
	},
	data = {
		stagger_types = table.set({
			StaggerSettings.stagger_types.heavy,
			StaggerSettings.stagger_types.explosion
		})
	},
	triggers = {
		{
			id = "hook_damage_dealt",
			trigger = function (self, stat_data, attack_data)
				local attack_result = attack_data.attack_result
				local stagger_type = attack_data.stagger_type
				local stagger_type_lookup = self.data.stagger_types

				if attack_result ~= "died" and stagger_type_lookup[stagger_type] then
					local id = self.id
					stat_data[id] = (stat_data[id] or self.default) + 1

					return id, stat_data[id]
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_bullrushed_group_of_ranged_enemies = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_lunge_stop",
			trigger = function (self, stat_data, units_hit, ranged_units_hit, ogryns_hit)
				if ranged_units_hit >= 3 then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_killed_multiple_enemies_with_sweep = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 3
	},
	triggers = {
		{
			id = "hook_sweep_finished",
			trigger = function (self, stat_data, num_hit_enemies, num_killed_enemies, combo_count, hit_weakspot, is_heavy)
				if num_killed_enemies >= 2 then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_number_of_missions_with_no_deaths_and_all_revives_within_x_seconds = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4,
		max_time_in_captivity = 10
	},
	triggers = {
		{
			id = "whole_mission_won",
			trigger = function (self, stat_data, difficulty, mission_time)
				local team_deaths = read_stat(StatDefinitions.team_deaths, stat_data)
				local longest_time_spent_in_captivity = read_stat(StatDefinitions.team_longest_time_spent_in_captivity, stat_data)
				local max_time_in_captivity = self.data.max_time_in_captivity

				if team_deaths == 0 and longest_time_spent_in_captivity <= max_time_in_captivity then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_grenade_box_kills_without_missing_counter = {
	flags = {
		StatFlags.no_recover
	},
	data = {
		difficulty = 4
	},
	triggers = {
		{
			id = "hook_projectile_hit",
			trigger = function (self, stat_data, impact_hit, num_impact_hit_weakspot, num_impact_hit_kill, num_impact_hit_elite, num_impact_hit_special, weapon_template_name)
				if weapon_template_name ~= "ogryn_grenade_box" and weapon_template_name ~= "ogryn_grenade_box_cluster" then
					return
				end

				local id = self.id
				local default = self.default
				local current_value = stat_data[id] or default
				local hit_elite_or_special = num_impact_hit_elite + num_impact_hit_special > 0

				if hit_elite_or_special then
					stat_data[id] = current_value + 1

					return id, stat_data[id]
				elseif current_value ~= default then
					stat_data[id] = default

					return id, stat_data[id]
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions.ogryn_2_grenade_box_kills_without_missing = {
	flags = {
		StatFlags.backend
	},
	data = {
		difficulty = 4,
		number_of_hits = 4
	},
	triggers = {
		{
			id = "ogryn_2_grenade_box_kills_without_missing_counter",
			trigger = function (self, stat_data, hits_in_a_row)
				local number_of_hits = self.data.number_of_hits

				if hits_in_a_row > 0 and hits_in_a_row % number_of_hits == 0 then
					return increment(self, stat_data)
				end
			end
		}
	},
	include_condition = include_condition
}
StatDefinitions = _stat_data

for _, stat in pairs(StatDefinitions) do
	stat.flags = table.set(stat.flags)
	stat.default = stat.default or 0
end

return settings("StatDefinitions", StatDefinitions)
