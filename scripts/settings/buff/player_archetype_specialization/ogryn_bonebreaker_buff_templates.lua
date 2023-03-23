local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local Damage = require("scripts/utilities/attack/damage")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local breed_types = BreedSettings.types
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.ogryn_2
local stagger_results = AttackSettings.stagger_results
local damage_types = DamageSettings.damage_types
local templates = {
	ogryn_bonebreaker_speed_on_lunge = {
		hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_1_3",
		predicted = true,
		hud_priority = 3,
		class_name = "proc_buff",
		active_duration = talent_settings.combat_ability.active_duration,
		proc_events = {
			[proc_events.on_lunge_end] = talent_settings.combat_ability.on_lunge_end_proc_chance
		},
		proc_stat_buffs = {
			[stat_buffs.movement_speed] = talent_settings.combat_ability.movement_speed,
			[stat_buffs.melee_attack_speed] = talent_settings.combat_ability.melee_attack_speed
		}
	},
	ogryn_base_lunge_toughness_and_damage_resistance = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.melee_heavy_damage] = talent_settings.passive_2.melee_heavy_damage,
			[stat_buffs.damage_taken_multiplier] = talent_settings.passive_2.damage_taken_multiplier
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_lunging
	}
}
local valid_help_interactions = {
	rescue = true,
	pull_up = true,
	revive = true,
	remove_net = true
}

local function _passive_revive_conditional(template_data, template_context)
	local is_interacting = template_data.interactor_extension:is_interacting()

	if is_interacting then
		local interaction = template_data.interactor_extension:interaction()
		local interaction_type = interaction:type()
		local is_helping = valid_help_interactions[interaction_type]

		return is_helping
	end
end

templates.ogryn_bonebreaker_passive_revive = {
	predicted = false,
	class_name = "buff",
	conditional_keywords = {
		buff_keywords.uninterruptible
	},
	conditional_stat_buffs = {
		[stat_buffs.push_speed_modifier] = -0.9
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")
		template_data.interactor_extension = interactor_extension
	end,
	conditional_keywords_func = _passive_revive_conditional,
	conditional_stat_buffs_func = _passive_revive_conditional
}
templates.ogryn_bonebreaker_passive_stagger = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_impact_modifier] = talent_settings.passive_1.impact_modifier
	}
}
templates.ogryn_bonebreaker_increased_coherency_regen = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = talent_settings.toughness_1.toughness_bonus
	}
}
templates.ogryn_bonebreaker_heavy_hits_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings.toughness_2.on_sweep_finish_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units ~= 1 then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_2.toughness, false, "talent_toughness_2")
	end
}
templates.ogryn_bonebreaker_multiple_enemy_heavy_hits_restore_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings.toughness_3.on_sweep_finish_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units <= 1 then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_3.toughness, false, "talent_toughness_3")
	end
}
templates.ogryn_bonebreaker_better_ogryn_fighting = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn] = talent_settings.offensive_1.damage_vs_ogryn,
		[stat_buffs.ogryn_damage_taken_multiplier] = talent_settings.offensive_1.ogryn_damage_taken_multiplier
	}
}
templates.ogryn_bonebreaker_heavy_attacks_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_heavy_hit, CheckProcFunctions.on_non_kill),
	proc_func = function (params, template_data, template_context, t)
		if CheckProcFunctions.on_kill(params) then
			return
		end

		local victim_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and buff_extension then
			local num_stacks = talent_settings.offensive_3.stacks

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", template_context.unit)
		end
	end
}
templates.ogryn_bonebreaker_direct_grenade_hits_on_supers_explode = {
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.cluster_explode_on_super_armored
	}
}
templates.ogryn_bonebreaker_bigger_coherency_radius = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.coherency_radius_modifier] = talent_settings.coop_1.coherency_aura_size_increase
	}
}
templates.ogryn_bonebreaker_charge_grants_allied_movement_speed = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_lunge_start] = talent_settings.coop_2.on_lunge_start_proc_chance
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		if coherency_extension then
			local units_in_coherence = coherency_extension:in_coherence_units()
			local movement_speed_buff = "ogryn_bonebreaker_allied_movement_speed_buff"
			local t = FixedFrame.get_latest_fixed_time()

			for coherency_unit, _ in pairs(units_in_coherence) do
				local is_local_unit = coherency_unit == unit

				if not is_local_unit then
					local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

					coherency_buff_extension:add_internally_controlled_buff(movement_speed_buff, t, "owner_unit", unit)
				end
			end
		end
	end
}
templates.ogryn_bonebreaker_allied_movement_speed_buff = {
	class_name = "buff",
	hud_priority = 4,
	predicted = true,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_1_3",
	duration = talent_settings.coop_2.duration,
	max_stacks = talent_settings.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.coop_2.movement_speed
	},
	keywords = {
		buff_keywords.stun_immune,
		buff_keywords.suppression_immune
	}
}
templates.ogryn_bonebreaker_take_ally_damage = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_damage_taken] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.coherency_extension = coherency_extension
		template_data.ally_unit = nil
		template_data.buff_id = nil
		template_data.buff_name = "ogryn_bonebreaker_ally_damage_reduction"
		local t = Managers.time:time("gameplay")
		template_data.next_update_t = t
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.damage = 0
		template_data.permanent_damage = 0
		local max_health = template_data.health_extension:max_health()
		local max_wounds = template_data.health_extension:max_wounds()
		template_data.health_cut_off = math.round(max_health / max_wounds)
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local attacked_unit = params.attacked_unit

		if attacked_unit ~= template_data.ally_unit then
			return
		end

		local damage = params.damage_amount < 1 and 0 or params.damage_amount
		local permanent_damage = params.permanent_damage < 1 and 0 or params.permanent_damage
		template_data.attacking_unit = template_data.attacking_unit or params.attacking_unit
		template_data.attacking_unit_owner_unit = template_data.attacking_unit_owner_unit or params.attacking_unit_owner_unit
		template_data.damage = template_data.damage + damage
		template_data.permanent_damage = template_data.permanent_damage + permanent_damage
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local current_health = template_data.health_extension:current_health()

		if current_health <= template_data.health_cut_off then
			local unit = template_data.ally_unit

			if unit then
				local buff_id = template_data.buff_id

				if buff_id then
					local component_index = template_data.component_index
					local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

					if buff_extension then
						buff_extension:remove_externally_controlled_buff(buff_id, component_index)
					end
				end

				template_data.ally_unit = nil
				template_data.buff_id = nil
			end

			return
		end

		local damage = template_data.damage
		local permanent_damage = template_data.permanent_damage
		local excess_damage = 1 - (current_health - damage)

		if excess_damage > 0 then
			damage = damage - excess_damage
		end

		if damage > 0 or permanent_damage > 0 then
			local unit = template_context.unit
			local attack_direction = Vector3.direction_length(POSITION_LOOKUP[unit], POSITION_LOOKUP[template_data.ally_unit])
			local attacking_unit = template_data.attacking_unit
			local attacking_unit_owner_unit = template_data.attacking_unit_owner_unit
			attacking_unit = attacking_unit_owner_unit or attacking_unit

			if damage > 0 then
				local damage_profile = DamageProfileTemplates.ogryn_bonebreaker_ally_damage

				Attack.execute(unit, damage_profile, "power_level", damage, "attacking_unit", attacking_unit, "attack_direction", attack_direction)

				template_data.damage = 0
			end

			if permanent_damage > 0 then
				local damage_profile = DamageProfileTemplates.ogryn_bonebreaker_ally_damage_permanent

				Attack.execute(unit, damage_profile, "power_level", permanent_damage, "attacking_unit", attacking_unit, "attack_direction", attack_direction)

				template_data.permanent_damage = 0
			end

			template_data.attacking_unit = nil
			template_data.attacking_unit_owner_unit = nil
		end

		if t < template_data.next_update_t then
			return
		end

		template_data.next_update_t = t + 1
		local unit = template_context.unit
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()
		local closest_ally_unit = nil
		local dist = math.huge
		local pos = POSITION_LOOKUP[unit]

		for ally_unit, _ in pairs(units_in_coherence) do
			if HEALTH_ALIVE[ally_unit] and ally_unit ~= unit then
				local unit_data_extension = ScriptUnit.has_extension(ally_unit, "unit_data_system")

				if unit_data_extension then
					local component = unit_data_extension:read_component("character_state")
					local is_knocked_down = PlayerUnitStatus.is_knocked_down(component)

					if not is_knocked_down then
						local ally_pos = POSITION_LOOKUP[ally_unit]
						local distance = Vector3.distance_squared(pos, ally_pos)

						if distance < dist then
							dist = distance
							closest_ally_unit = ally_unit
						end
					end
				end
			end
		end

		if (not closest_ally_unit or closest_ally_unit ~= template_data.ally_unit) and ALIVE[template_data.ally_unit] then
			local buff_id = template_data.buff_id

			if buff_id then
				local ally_unit = template_data.ally_unit
				local buff_extension = ScriptUnit.has_extension(ally_unit, "buff_system")

				if buff_extension then
					buff_extension:remove_externally_controlled_buff(buff_id, nil)
				end
			end

			template_data.ally_unit = nil
			template_data.buff_id = nil
		end

		if closest_ally_unit and closest_ally_unit ~= template_data.ally_unit then
			local buff_name = template_data.buff_name
			local buff_extension = ScriptUnit.extension(closest_ally_unit, "buff_system")
			local _, buff_id = buff_extension:add_externally_controlled_buff(buff_name, t)
			template_data.ally_unit = closest_ally_unit
			template_data.buff_id = buff_id
		end
	end,
	stop_func = function (template_data, template_context)
		if ALIVE[template_data.ally_unit] then
			local buff_id = template_data.buff_id

			if buff_id then
				local ally_unit = template_data.ally_unit
				local buff_extension = ScriptUnit.has_extension(ally_unit, "buff_system")

				if buff_extension then
					buff_extension:remove_externally_controlled_buff(buff_id, nil)
				end
			end

			template_data.ally_unit = nil
			template_data.buff_id = nil
		end
	end
}
templates.ogryn_bonebreaker_ally_damage_reduction = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.coop_3.damage_taken_multiplier
	}
}
templates.ogryn_bonebreaker_coherency_increased_melee_damage = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "ogryn_bonebreaker_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings.coherency.melee_damage
	}
}
templates.ogryn_bonebreaker_cooldown_on_elite_kills_by_coherence = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = 1
	},
	proc_func = function (params, template_data, template_context)
		local breed_name = params.breed_name
		local breed = breed_name and Breeds[breed_name]

		if not breed or not breed.tags or not breed.tags.elite then
			return
		end

		local attacker_unit = params.attacking_unit
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local units_in_coherence = coherency_extension:in_coherence_units()

		if not units_in_coherence[attacker_unit] then
			return
		end

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		local ability_type = "combat_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		ability_extension:reduce_ability_cooldown_percentage(ability_type, talent_settings.coop_3.cooldown)
	end
}
local bleed_dr_max_stacks = talent_settings.defensive_1.max_stacks
local bleed_range = DamageSettings.in_melee_range
templates.ogryn_bonebreaker_reduce_damage_taken_per_bleed = {
	hud_always_show_stacks = true,
	predicted = false,
	hud_priority = 3,
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_3_2",
	class_name = "buff",
	always_show_in_hud = true,
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = talent_settings.defensive_1.min,
			max = talent_settings.defensive_1.max
		}
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		template_data.num_stacks = 0
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local t = FixedFrame.get_latest_fixed_time()
		template_data.next_bleed_check_t = t + talent_settings.defensive_1.time
		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local next_bleed_check_t = template_data.next_bleed_check_t

		if next_bleed_check_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local num_stacks = 0
			local num_hits = broadphase:query(player_position, bleed_range, broadphase_results, enemy_side_names)

			for i = 1, num_hits do
				local enemy_unit = broadphase_results[i]
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local target_is_bleeding = buff_extension:has_keyword(buff_keywords.bleeding)

					if target_is_bleeding then
						num_stacks = num_stacks + 1
					end
				end
			end

			template_data.num_stacks = num_stacks
			template_data.next_bleed_check_t = t + talent_settings.defensive_1.time
		end

		return math.clamp(template_data.num_stacks / bleed_dr_max_stacks, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.clamp(template_data.num_stacks, 0, bleed_dr_max_stacks)
	end
}
local reduced_damage_distance = talent_settings.defensive_2.distance * talent_settings.defensive_2.distance
templates.ogryn_bonebreaker_reduce_damage_taken_on_disabled_allies = {
	hud_always_show_stacks = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_2_2",
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = talent_settings.defensive_2.min,
			max = talent_settings.defensive_2.max
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		template_data.side = side
		template_data.lerp_t = 0
		local t = Managers.time:time("gameplay")
		template_data.update_t = t + 0.1
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		if template_data.update_t < t then
			local max_players = 3
			local player_units = template_data.side.valid_player_units
			local valid_units = 0
			local unit = template_context.unit
			local pos = POSITION_LOOKUP[unit]

			for i = 1, #player_units do
				local player_unit = player_units[i]

				if player_unit ~= unit then
					local player_pos = POSITION_LOOKUP[player_unit]
					local distance = Vector3.distance_squared(pos, player_pos)

					if distance < reduced_damage_distance then
						local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
						local character_state_component = unit_data_extension:read_component("character_state")
						local requires_help = PlayerUnitStatus.requires_help(character_state_component)

						if requires_help then
							valid_units = valid_units + 1
						end
					end
				end
			end

			template_data.lerp_t = valid_units / max_players
			template_data.update_t = t + 0.1
		end

		return template_data.lerp_t
	end,
	check_active_func = function (template_data, template_context)
		return template_data.lerp_t > 0
	end,
	visual_stack_count = function (template_data, template_context)
		local stack_count = math.floor(template_data.lerp_t * 3 + 0.5)

		return stack_count
	end
}
local increased_toughness_health_threshold = talent_settings.defensive_3.increased_toughness_health_threshold
templates.ogryn_bonebreaker_increased_toughness_at_low_health = {
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_3_3",
	predicted = false,
	hud_priority = 3,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.toughness_replenish_multiplier] = talent_settings.defensive_3.toughness_replenish_multiplier
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			local current_health_percent = health_extension:current_health_percent()

			return current_health_percent < increased_toughness_health_threshold
		end
	end
}
local breed_buff_names = {}

for breed_name, breed in pairs(Breeds) do
	if breed.breed_type == breed_types.minion then
		local buff_name = "ogryn_bonebreaker_revenge_damage_vs_" .. breed_name
		templates[buff_name] = {
			predicted = false,
			max_stacks = 1,
			refresh_duration_on_stack = true,
			class_name = "buff",
			duration = talent_settings.offensive_2_1.time,
			stat_buffs = {
				[stat_buffs["damage_vs_" .. breed_name]] = talent_settings.offensive_2_1.damage
			}
		}
		breed_buff_names[breed_name] = buff_name
	end
end

templates.ogryn_bonebreaker_revenge_damage = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_player_hit_recieved] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local damage = params.damage

		if damage > 0 then
			local attacking_unit = params.attacking_unit
			local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")

			if unit_data_extension then
				local breed = unit_data_extension:breed()

				if breed then
					local breed_name = breed.name
					local buff_name = breed_buff_names[breed_name]

					if buff_name then
						local t = FixedFrame.get_latest_fixed_time()

						template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
					end
				end
			end
		end
	end
}
templates.ogryn_bonebreaker_fully_charged_attacks_infinite_cleave = {
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.fully_charged_attacks_infinite_cleave,
		buff_keywords.ignore_armor_aborts_attack
	}
}
local breed_name_size = {
	renegade_flamer = 2,
	renegade_rifleman = 1,
	renegade_assault = 1,
	cultist_grenadier = 2,
	cultist_melee = 1,
	chaos_hound_mutator = 3,
	chaos_beast_of_nurgle = 10,
	cultist_flamer = 2,
	cultist_mutant = 5,
	chaos_poxwalker = 1,
	chaos_poxwalker_bomber = 2,
	cultist_shocktrooper = 2,
	chaos_ogryn_gunner = 5,
	renegade_shocktrooper = 2,
	renegade_gunner = 2,
	cultist_berzerker = 3,
	chaos_newly_infected = 1,
	chaos_spawn = 10,
	renegade_melee = 1,
	chaos_ogryn_executor = 5,
	cultist_assault = 1,
	renegade_grenadier = 2,
	chaos_daemonhost = 8,
	chaos_plague_ogryn = 10,
	renegade_berzerker = 3,
	renegade_sniper = 1,
	renegade_netgunner = 2,
	renegade_captain = 8,
	chaos_hound = 3,
	chaos_ogryn_bulwark = 5,
	cultist_gunner = 2,
	renegade_executor = 3,
	chaos_plague_ogryn_sprayer = 10
}

local function big_bull_add_stacks(template_context, stacks)
	local unit = template_context.unit
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension then
		local t = FixedFrame.get_latest_fixed_time()

		for i = 1, stacks do
			buff_extension:add_internally_controlled_buff("ogryn_bonebreaker_big_bully_heavy_hits_buff", t)
		end
	end
end

templates.ogryn_bonebreaker_big_bully_heavy_hits = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	start_func = function (template_data, template_context)
		template_data.stacks = 0
	end,
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.in_sweep = params.is_heavy
		end,
		on_hit = function (params, template_data, template_context)
			local stagger_result = params.stagger_result

			if stagger_result ~= stagger_results.stagger then
				return
			end

			local breed_name = params.breed_name
			local stacks = breed_name_size[breed_name] or 0

			if not template_data.in_sweep then
				big_bull_add_stacks(template_context, stacks)

				return
			end

			template_data.stacks = template_data.stacks + stacks
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.sweep_done = true
			template_data.in_sweep = nil
		end
	},
	update_func = function (template_data, template_context, dt, t)
		if template_data.sweep_done then
			template_data.sweep_done = nil
			template_data.delay = 0.1
		end

		if not template_data.delay then
			return
		end

		if template_data.delay > 0 then
			template_data.delay = template_data.delay - dt

			return
		end

		if template_data.delay <= 0 then
			local stacks = template_data.stacks or 0

			big_bull_add_stacks(template_context, stacks)

			template_data.stacks = 0
			template_data.delay = nil
		end
	end
}
templates.ogryn_bonebreaker_big_bully_heavy_hits_buff = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 3,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_5_2",
	class_name = "proc_buff",
	duration = talent_settings.offensive_2_2.duration,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings.offensive_2_2.melee_heavy_damage
	},
	max_stacks = talent_settings.offensive_2_2.max_stacks,
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.can_finish = params.is_heavy
			template_data.finished = nil
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.finished = true
		end
	},
	conditional_exit_func = function (template_data, template_context)
		return template_data.can_finish and template_data.finished
	end
}
templates.ogryn_bonebreaker_melee_revenge_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_hit_recieved] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local damage = params.damage
		local damage_absorbed = params.damage_absorbed or 0

		if damage > 0 or damage_absorbed > 0 then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.buff_extension:add_internally_controlled_buff("ogryn_bonebreaker_melee_revenge_damage_buff", t)
		end
	end
}
templates.ogryn_bonebreaker_melee_revenge_damage_buff = {
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_5_1",
	max_stacks = 1,
	predicted = false,
	hud_priority = 3,
	class_name = "buff",
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.offensive_2_1.damage
	},
	duration = talent_settings.offensive_2_1.time
}
templates.ogryn_bonebreaker_hitting_multiple_with_melee_grants_melee_damage_bonus = {
	force_predicted_proc = true,
	hud_always_show_stacks = true,
	predicted = false,
	hud_icon = "content/ui/textures/icons/talents/ogryn_2/hud/ogryn_2_tier_1_1",
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings.offensive_2_3.on_sweep_finish_proc_chance
	},
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = talent_settings.offensive_2_3.melee_damage * talent_settings.offensive_2_3.max_targets
		}
	},
	specific_proc_func = {
		on_sweep_finish = function (params, template_data, template_context)
			local hits = params.num_hit_units
			template_data.hits = hits
		end
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local hits = template_data.hits or 0
		local max_hits = talent_settings.offensive_2_3.max_targets

		return math.clamp(hits / max_hits, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		local hits = template_data.hits or 0
		local number_of_stacks = math.clamp(hits, 0, talent_settings.offensive_2_3.max_targets)

		return number_of_stacks
	end,
	check_active_func = function (template_data, template_context)
		local hits = template_data.hits or 0
		local show = hits > 0

		return show
	end
}
templates.ogryn_bonebreaker_bull_rush_hits_replenish_toughness = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	end,
	check_proc_func = function (params)
		if not params.damage_type or params.damage_type ~= damage_types.ogryn_physical then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local is_lunging = template_data.lunge_character_state_component.is_lunging

		if not is_lunging then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings.combat_ability_3.toughness, false, "bull_rush_toughness_talent")
	end
}

return templates
