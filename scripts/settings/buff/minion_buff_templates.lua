local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local templates = {
	cultist_flamer_hit_by_flame = {
		interval = 0.5,
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 1,
		duration = 1,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
		},
		interval_func = function (template_data, template_context)
			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_template = DamageProfileTemplates.grenadier_liquid_fire_burning
				local power_level_table = MinionDifficultySettings.power_level.cultist_flamer_on_hit_fire
				local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
				local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
			end
		end,
		minion_effects = minion_burning_buff_effects.chemfire
	},
	cultist_flamer_liquid_immunity = {
		unique_buff_id = "cultist_flamer_liquid_immunity",
		class_name = "buff",
		unique_buff_priority = 1,
		keywords = {
			buff_keywords.cultist_flamer_liquid_immunity
		}
	},
	renegade_flamer_hit_by_flame = {
		interval = 0.5,
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 1,
		duration = 1,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
		},
		interval_func = function (template_data, template_context)
			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_template = DamageProfileTemplates.grenadier_liquid_fire_burning
				local power_level_table = MinionDifficultySettings.power_level.renegade_flamer_on_hit_fire
				local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
				local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
			end
		end,
		minion_effects = minion_burning_buff_effects.fire
	},
	renegade_flamer_liquid_immunity = {
		unique_buff_id = "renegade_flamer_liquid_immunity",
		class_name = "buff",
		unique_buff_priority = 1,
		keywords = {
			buff_keywords.renegade_flamer_liquid_immunity
		}
	},
	renegade_grenadier_liquid_immunity = {
		unique_buff_id = "renegade_grenadier_liquid_immunity",
		class_name = "buff",
		unique_buff_priority = 1,
		keywords = {
			buff_keywords.renegade_grenadier_liquid_immunity
		}
	},
	beast_of_nurgle_liquid_immunity = {
		unique_buff_id = "beast_of_nurgle_liquid_immunity",
		class_name = "buff",
		unique_buff_priority = 1,
		keywords = {
			buff_keywords.beast_of_nurgle_liquid_immunity
		}
	}
}
local RELATION = "enemy"
local DAEMONHOST_CORRUPTION_AURA_RESULTS = {}
local CORRUPTION_AURA_DAMAGE_TYPE = "corruption"
local CORRUPTION_AURA_RADIUS = 7
local CORRUPTION_AURA_PERMANENT_PERCENT = {
	0.2,
	0.25,
	0.45,
	0.45,
	0.45
}
templates.daemonhost_corruption_aura = {
	interval = 1,
	refresh_duration_on_stack = true,
	predicted = false,
	max_stacks = 1,
	class_name = "interval_buff",
	keywords = {},
	duration = math.huge,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[unit]
			local target_side_names = side:relation_side_names(RELATION)

			table.clear(DAEMONHOST_CORRUPTION_AURA_RESULTS)

			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase
			local position = POSITION_LOOKUP[unit]
			local num_results = broadphase:query(position, CORRUPTION_AURA_RADIUS, DAEMONHOST_CORRUPTION_AURA_RESULTS, target_side_names)
			local damage_profile = DamageProfileTemplates.daemonhost_corruption_aura
			local power_level_table = MinionDifficultySettings.power_level.daemonhost_corruption_aura
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)

			for i = 1, num_results do
				local nearby_enemy = DAEMONHOST_CORRUPTION_AURA_RESULTS[i]

				if HEALTH_ALIVE[nearby_enemy] then
					local hit_unit_data_extension = ScriptUnit.extension(nearby_enemy, "unit_data_system")
					local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")
					local is_warp_grabbed = PlayerUnitStatus.is_warp_grabbed(disabled_character_state_component)

					if not is_warp_grabbed then
						local health_extension = ScriptUnit.extension(nearby_enemy, "health_system")
						local permanent_damage_taken_percent = health_extension:permanent_damage_taken_percent()
						local allowed_permanent_percent = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_AURA_PERMANENT_PERCENT)

						if permanent_damage_taken_percent < allowed_permanent_percent then
							local attack_direction = Vector3.normalize(POSITION_LOOKUP[nearby_enemy] - position)

							Attack.execute(nearby_enemy, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", attack_direction, "hit_zone_name", "torso", "damage_type", CORRUPTION_AURA_DAMAGE_TYPE)
						end
					end
				end
			end
		end
	end
}
templates.chaos_beast_of_nurgle_hit_by_vomit = {
	refresh_duration_on_stack = true,
	duration = 10,
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud",
	max_stacks = 3,
	class_name = "buff",
	is_negative = true,
	keywords = {
		buff_keywords.beast_of_nurgle_vomit
	},
	forbidden_keywords = {
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.85,
		[buff_stat_buffs.dodge_speed_multiplier] = 0.9
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_bon_vomit_loop",
		looping_wwise_stop_event = "wwise/events/player/play_player_vomit_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_vomit_enter",
		stop_type = "stop",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.chaos_beast_of_nurgle_being_eaten = {
	interval = 1,
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	keywords = {
		buff_keywords.beast_of_nurgle_vomit,
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	damage_template = DamageProfileTemplates.beast_of_nurgle_slime_liquid,
	damage_type = damage_types.minion_vomit,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local max_health = health_extension:max_health()
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
			local damage_template = DamageProfileTemplates.beast_of_nurgle_slime_liquid
			local power_level_table = MinionDifficultySettings.power_level.chaos_beast_of_nurgle_being_eaten
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table) * max_health

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_bon_vomit_hit",
		looping_wwise_start_event = "wwise/events/minions/play_beast_of_nurgle_stomach_loop",
		looping_wwise_stop_event = "wwise/events/minions/stop_beast_of_nurgle_stomach_loop"
	}
}

return templates
