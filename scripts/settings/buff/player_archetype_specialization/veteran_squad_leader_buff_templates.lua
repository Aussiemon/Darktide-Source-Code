local Action = require("scripts/utilities/weapon/action")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.veteran_3
local templates = {
	veteran_squad_leader_elite_kills_passive = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[proc_events.on_hit] = talent_settings.passive_1.on_hit_proc_chance
		},
		check_proc_func = CheckProcFunctionTemplates.on_elite_kill,
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local ability_extension = ScriptUnit.extension(unit, "ability_system")
			template_data.ability_extension = ability_extension
			template_data.cooldown_reduction = talent_settings.passive_1.cooldown_reduction
			template_data.talent_cooldown_reduction = talent_settings.passive_1.talent_cooldown_reduction
		end,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
			local special_rule = special_rules.veteran_squad_leader_increased_cooldown_restore_on_elite_kills
			local small_reduction = template_data.cooldown_reduction
			local large_reduction = template_data.talent_cooldown_reduction
			local cooldown_reduction = (specialization_extension:has_special_rule(special_rule) and large_reduction) or small_reduction

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_reduction)
		end
	},
	veteran_squad_leader_tag_passive = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_tag_unit] = talent_settings.passive_2.on_tag_unit_proc_chance,
			[proc_events.on_untag_unit] = talent_settings.passive_2.on_untag_unit_proc_chance
		},
		start_func = function (template_data, template_context)
			local player_unit = template_context.unit
			template_data.specialization_extension = ScriptUnit.extension(player_unit, "specialization_system")
			template_data.suppression_cooldown = talent_settings.spec_passive_2.suppression_cooldown
			template_data.last_stagger_t = 0
		end,
		specific_proc_func = {
			on_tag_unit = function (params, template_data, template_context)
				if not template_context.is_server then
					return
				end

				local player_unit = template_context.unit
				local unit = params.unit
				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension then
					local tag_debuff = "veteran_squad_leader_tag_debuff"
					local t = Managers.time:time("gameplay")
					local _, id = buff_extension:add_externally_controlled_buff(tag_debuff, t, "owner_unit", player_unit)
					template_data.tagged_unit_buff_id = id
					template_data.tagged_unit = unit
				end

				local special_rule = special_rules.veteran_squad_leader_tag_suppression
				local has_special_rule = template_data.specialization_extension:has_special_rule(special_rule)

				if has_special_rule then
					local t = Managers.time:time("gameplay")

					if template_data.suppression_cooldown < t - template_data.last_stagger_t then
						local damage_profile = DamageProfileTemplates.veteran_squad_leader_tag_suppression

						Suppression.apply_suppression(unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])

						template_data.last_stagger_t = t
					end
				end
			end,
			on_untag_unit = function (params, template_data, template_context)
				if not template_context.is_server then
					return
				end

				local unit = params.unit
				local tagged_unit = template_data.tagged_unit

				if unit ~= tagged_unit then
					return
				end

				if not HEALTH_ALIVE[unit] then
					return
				end

				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension then
					local id = template_data.tagged_unit_buff_id

					buff_extension:remove_externally_controlled_buff(id)

					template_data.tagged_unit = nil
					template_data.tagged_unit_buff_id = nil
				end
			end
		}
	},
	veteran_squad_leader_tag_debuff = {
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = talent_settings.passive_2.damage_taken_multiplier
		}
	},
	veteran_squad_leader_suppression_immunity = {
		predicted = false,
		class_name = "buff",
		keywords = {
			keywords.suppression_immune
		}
	},
	veteran_squad_leader_better_pickups = {
		predicted = false,
		class_name = "buff",
		keywords = {
			keywords.improved_medical_crate,
			keywords.improved_ammo_pickups
		}
	},
	veteran_squad_leader_better_grenades = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.krak_damage] = talent_settings.mixed_2.krak_damage
		}
	}
}
local crit_cooldown = talent_settings.mixed_3.crit_cooldown
templates.veteran_squad_leader_periodic_guaranteed_critical_strikes = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.mixed_3.on_hit_proc_chance
	},
	cooldown_duration = crit_cooldown,
	check_proc_func = CheckProcFunctionTemplates.on_crit,
	proc_func = function (params, template_data, template_context)
		local t = Managers.time:time("gameplay")

		if not template_data.next_guaranteed_crit then
			template_data.next_guaranteed_crit = t + crit_cooldown
		end
	end,
	start_func = function (template_data, template_context)
		local t = Managers.time:time("gameplay")
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension

		buff_extension:add_internally_controlled_buff("veteran_squad_leader_periodic_crit_buff", t)
	end,
	update_func = function (template_data, template_context, dt, t)
		local next_guaranteed_crit = template_data.next_guaranteed_crit

		if next_guaranteed_crit and next_guaranteed_crit < t then
			template_data.buff_extension:add_internally_controlled_buff("veteran_squad_leader_periodic_crit_buff", t)

			template_data.next_guaranteed_crit = nil
		end
	end
}
templates.veteran_squad_leader_periodic_crit_buff = {
	class_name = "proc_buff",
	max_stacks = talent_settings.mixed_3.max_stacks,
	max_stacks_cap = talent_settings.mixed_3.max_stacks_cap,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.mixed_3.critical_strike_chance
	},
	proc_events = {
		[proc_events.on_hit] = talent_settings.mixed_3.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_crit,
	proc_func = function (params, template_data)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.done
	end
}
templates.veteran_squad_leader_coherency_increased_damage = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "veteran_squad_leader_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.coherency.damage
	}
}
templates.veteran_squad_leader_coherency_increased_damage_improved = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "veteran_squad_leader_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coop_2.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.coop_2.damage
	}
}
templates.veteran_squad_leader_increased_damage_vs_armored = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.armored_damage] = talent_settings.offensive_1.armored_damage,
		[stat_buffs.super_armor_damage] = talent_settings.offensive_1.super_armor_damage
	}
}
templates.veteran_squad_leader_allies_kills_change_to_trigger_increased_damage = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = talent_settings.offensive_3.active_duration,
	proc_events = {
		[proc_events.on_minion_death] = talent_settings.offensive_3.on_minion_death_proc_chance
	},
	proc_stat_buffs = {
		[stat_buffs.suppression_dealt] = talent_settings.offensive_3.suppression_dealt,
		[stat_buffs.damage] = talent_settings.offensive_3.damage
	},
	check_proc_func = function (params, template_data, template_context)
		local current_unit = template_context.unit
		local attacking_unit = params.attacking_unit
		local is_killed_by_this_unit = current_unit == attacking_unit

		return not is_killed_by_this_unit
	end
}
templates.veteran_squad_leader_movespeed_when_knocked_allies = {
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.defensive_1.movement_speed
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local local_player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[local_player_unit]
		local player_units = side.valid_player_units
		local knocked_allies = false

		for _, unit in pairs(player_units) do
			if ALIVE[unit] and unit ~= local_player_unit then
				local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
				local character_state_component = unit_data_extension:read_component("character_state")
				local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

				if is_knocked_down then
					knocked_allies = true

					break
				end
			end
		end

		return knocked_allies
	end
}
local valid_actions = {
	action_vent = true,
	action_reload_state = true,
	action_reload = true,
	action_reload_shotgun = true
}
templates.veteran_squad_leader_damage_reduction_while_reloading_or_venting = {
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.defensive_1.damage_taken_multiplier
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local current_action_name, _ = Action.current_action(weapon_action_component, weapon_template)

		return valid_actions[current_action_name]
	end
}
templates.veteran_squad_leader_increased_toughness_and_stamina = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness] = talent_settings.defensive_3.toughness,
		[stat_buffs.stamina_modifier] = talent_settings.defensive_3.stamina_modifier
	}
}
templates.veteran_squad_leader_coherency_boost = {
	predicted = false,
	class_name = "buff",
	max_stacks = talent_settings.coop_1.max_stacks,
	duration = talent_settings.coop_1.duration,
	keywords = {},
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.coop_1.damage
	}
}
templates.veteran_squad_leader_combat_ability_boost_passive = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local cohrency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.cohrency_extension = cohrency_extension
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local cohrency_extension = template_data.cohrency_extension
		local cohrent_units = cohrency_extension:in_coherence_units()

		for in_coherence_unit, _ in pairs(cohrent_units) do
			local in_coherence_buff_extension = ScriptUnit.has_extension(in_coherence_unit, "buff_system")

			if in_coherence_buff_extension then
				local t = Managers.time:time("gameplay")

				in_coherence_buff_extension:add_internally_controlled_buff("veteran_squad_leader_coherency_boost", t)
			end
		end
	end
}
templates.veteran_squad_leader_coherency_toughness_regen_rate = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "veteran_squad_leader_coherency_toughness_regen_rate",
	class_name = "buff",
	max_stacks = talent_settings.coop_3.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = talent_settings.coop_3.toughness_regen_rate_modifier
	}
}
templates.veteran_squad_leader_allies_elite_kills_passive = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = talent_settings.spec_passive_3.on_minion_death_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
		template_data.cooldown_reduction = talent_settings.spec_passive_3.cooldown_reduction
		local side_system = Managers.state.extension:system("side_system")
		template_data.side_system = side_system
	end,
	check_proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local attacking_unit = params.attacking_unit
		local breed_name = params.breed_name
		local breed = Breeds[breed_name]
		local is_elite = breed.tags.elite
		local is_self = attacking_unit == unit
		local side_system = template_data.side_system
		local same_side = side_system:is_same_side(unit, attacking_unit)

		return is_elite and same_side and not is_self
	end,
	proc_func = function (params, template_data, template_context)
		local cooldown_reduction = template_data.cooldown_reduction

		template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_reduction)
	end
}
templates.veteran_squad_leader_combat_ability_boost_ranged = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local cohrency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.cohrency_extension = cohrency_extension
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local cohrency_extension = template_data.cohrency_extension
		local cohrent_units = cohrency_extension:in_coherence_units()

		for in_coherence_unit, _ in pairs(cohrent_units) do
			local in_coherence_buff_extension = ScriptUnit.has_extension(in_coherence_unit, "buff_system")

			if in_coherence_buff_extension then
				local t = Managers.time:time("gameplay")

				in_coherence_buff_extension:add_internally_controlled_buff("veteran_squad_leader_shout_ranged_buff", t)
			end
		end
	end
}
templates.veteran_squad_leader_shout_ranged_buff = {
	class_name = "buff",
	duration = talent_settings.combat_ability_1.duration,
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.combat_ability_1.reload_speed,
		[stat_buffs.spread_modifier] = talent_settings.combat_ability_1.spread_modifier,
		[stat_buffs.recoil_modifier] = talent_settings.combat_ability_1.recoil_modifier,
		[stat_buffs.sway_modifier] = talent_settings.combat_ability_1.sway_modifier,
		[stat_buffs.charge_up_time] = talent_settings.combat_ability_1.charge_up_time
	}
}
templates.veteran_squad_leader_combat_ability_boost_melee = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local cohrency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.cohrency_extension = cohrency_extension
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local cohrency_extension = template_data.cohrency_extension
		local cohrent_units = cohrency_extension:in_coherence_units()

		for in_coherence_unit, _ in pairs(cohrent_units) do
			local in_coherence_buff_extension = ScriptUnit.has_extension(in_coherence_unit, "buff_system")

			if in_coherence_buff_extension then
				local t = Managers.time:time("gameplay")

				in_coherence_buff_extension:add_internally_controlled_buff("veteran_squad_leader_shout_melee_buff", t)
			end
		end
	end
}
templates.veteran_squad_leader_shout_melee_buff = {
	class_name = "buff",
	duration = talent_settings.combat_ability_2.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.combat_ability_2.melee_damage,
		[stat_buffs.impact_modifier] = talent_settings.combat_ability_2.impact_modifier,
		[stat_buffs.movement_speed] = talent_settings.combat_ability_2.movement_speed,
		[stat_buffs.block_cost_multiplier] = talent_settings.combat_ability_2.block_cost_multiplier,
		[stat_buffs.attack_speed] = talent_settings.combat_ability_2.attack_speed
	}
}

return templates
