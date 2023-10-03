local Action = require("scripts/utilities/weapon/action")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings_shared = TalentSettings.ogryn_shared
local damage_types = DamageSettings.damage_types
local stagger_results = AttackSettings.stagger_results
local talent_settings_1 = TalentSettings.ogryn_1
local talent_settings_2 = TalentSettings.ogryn_2
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local _passive_revive_conditional, _big_bull_add_stacks = nil
local templates = {
	ogryn_base_passive_tank = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_shared.tank.toughness_damage_taken_multiplier,
			[stat_buffs.damage_taken_multiplier] = talent_settings_shared.tank.damage_taken_multiplier,
			[stat_buffs.static_movement_reduction_multiplier] = talent_settings_shared.tank.static_movement_reduction_multiplier
		}
	},
	ogryn_base_passive_revive = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.revive_speed_modifier] = talent_settings_shared.revive.revive_speed_modifier,
			[stat_buffs.assist_speed_modifier] = talent_settings_shared.revive.assist_speed_modifier
		}
	},
	coherency_aura_size_increase = {
		predicted = false,
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[stat_buffs.coherency_radius_modifier] = talent_settings_shared.radius.coherency_aura_size_increase
		}
	},
	ogryn_toughness_regen_aura = {
		predicted = false,
		coherency_priority = 2,
		coherency_id = "ogryn_toughness_regen_coherency_aura",
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.toughness_regen_rate_modifier] = 0.2
		}
	},
	ogryn_passive_heavy_hitter = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_hit] = 1
		},
		start_func = function (template_data, template_context)
			local player_unit = template_context.unit
			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
			template_data.buff_extension = buff_extension
			template_data.max_stacks = 5
			local specialization_extension = ScriptUnit.extension(player_unit, "specialization_system")
			template_data.light_attacks_refreshes_duration = specialization_extension:has_special_rule(special_rules.ogryn_heavy_hitter_light_attacks_refresh_duration)
			template_data.max_stacks_improves_attack_speed = specialization_extension:has_special_rule(special_rules.ogryn_heavy_hitter_max_stacks_improves_attack_speed)
			template_data.max_stacks_improves_toughness = specialization_extension:has_special_rule(special_rules.ogryn_heavy_hitter_max_stacks_improves_toughness)
		end,
		proc_func = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			if params.target_number and params.target_number > 1 then
				return
			end

			if params.attack_type ~= attack_types.melee then
				return
			end

			local light_attacks_refreshes_duration = template_data.light_attacks_refreshes_duration
			local is_heavy_hit = CheckProcFunctions.on_heavy_hit(params)

			if not is_heavy_hit and not light_attacks_refreshes_duration then
				return
			end

			local damage_buff_name = "ogryn_heavy_hitter_damage_effect"
			local buff_extension = template_data.buff_extension
			local max_stacks = template_data.max_stacks
			local current_stacks = buff_extension:current_stacks(damage_buff_name)
			local at_max_stacks = current_stacks == max_stacks
			local will_be_max_stacks = current_stacks == max_stacks - 1
			local add_stack = not at_max_stacks and is_heavy_hit
			local refresh_duration = current_stacks > 0 and (at_max_stacks and is_heavy_hit or light_attacks_refreshes_duration and not is_heavy_hit)

			if add_stack then
				buff_extension:add_internally_controlled_buff(damage_buff_name, t)
			elseif refresh_duration then
				buff_extension:refresh_duration_of_stacking_buff(damage_buff_name, t)
			end

			local max_stacks_improves_attack_speed = template_data.max_stacks_improves_attack_speed
			local max_stacks_improves_toughness = template_data.max_stacks_improves_toughness

			if will_be_max_stacks and is_heavy_hit then
				if max_stacks_improves_attack_speed then
					buff_extension:add_internally_controlled_buff("ogryn_heavy_hitter_attack_speed_effect", t)
				end

				if max_stacks_improves_toughness then
					buff_extension:add_internally_controlled_buff("ogryn_heavy_hitter_toughness_regen_effect", t)
				end
			end
		end
	},
	ogryn_heavy_hitter_damage_effect = {
		refresh_duration_on_stack = true,
		predicted = false,
		hud_priority = 1,
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_keystone_heavy_hitter",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
		max_stacks = 5,
		duration = 7.5,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.melee_damage] = 0.05
		}
	},
	ogryn_heavy_hitter_attack_speed_effect = {
		class_name = "buff",
		predicted = false,
		max_stacks = 1,
		stat_buffs = {
			[stat_buffs.attack_speed] = 0.1
		},
		start_func = function (template_data, template_context)
			template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
			template_data.max_stacks = 5
		end,
		conditional_exit_func = function (template_data, template_context)
			local buff_extension = template_data.buff_extension
			local max_stacks = template_data.max_stacks
			local current_stacks = buff_extension:current_stacks("ogryn_heavy_hitter_damage_effect")

			return current_stacks < max_stacks
		end
	},
	ogryn_heavy_hitter_toughness_regen_effect = {
		class_name = "buff",
		predicted = false,
		max_stacks = 1,
		stat_buffs = {
			[stat_buffs.toughness_melee_replenish] = 0.1
		},
		start_func = function (template_data, template_context)
			template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
			template_data.max_stacks = 5
		end,
		conditional_exit_func = function (template_data, template_context)
			local buff_extension = template_data.buff_extension
			local max_stacks = template_data.max_stacks
			local current_stacks = buff_extension:current_stacks("ogryn_heavy_hitter_damage_effect")

			return current_stacks < max_stacks
		end
	},
	ogryn_rending_on_elite_kills = {
		predicted = false,
		hud_priority = 3,
		allow_proc_while_active = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_rending_on_elite_kills",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
		class_name = "proc_buff",
		active_duration = 10,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.rending_multiplier] = 0.3
		},
		check_proc_func = CheckProcFunctions.on_elite_kill
	},
	ogryn_taunt_staggers_reduce_cooldown = {
		predicted = false,
		class_name = "proc_buff",
		cooldown_reduction_percentage = 0.025,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		check_proc_func = CheckProcFunctions.on_stagger_hit,
		proc_func = function (params, template_data, template_context)
			local ability_extension = ScriptUnit.has_extension(template_context.unit, "ability_system")
			local ability_type = "combat_ability"

			if not ability_extension or not ability_extension:has_ability_type(ability_type) then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()

			if template_data.next_proc_t and t < template_data.next_proc_t then
				return
			end

			if not params.attack_type or params.attack_type ~= attack_types.melee and params.attack_type ~= attack_types.push then
				return
			end

			local cd_reduction = template_context.template.cooldown_reduction_percentage

			ability_extension:reduce_ability_cooldown_percentage(ability_type, cd_reduction)

			template_data.next_proc_t = t + 0.1
		end
	},
	ogryn_taunt_radius_increase = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.shout_radius_modifier] = 0.5
		}
	},
	ogryn_taunt_increased_damage_taken_buff = {
		predicted = false,
		duration = 15,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 1.25
		}
	},
	ogryn_blocking_ranged_taunts = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_block] = 1,
			[proc_events.on_push_hit] = 1
		},
		proc_func = function (params, template_data, template_context, t)
			local affected_unit = params.attacking_unit or params.pushed_unit

			if not HEALTH_ALIVE[affected_unit] then
				return
			end

			local unit_data_extension = ScriptUnit.extension(affected_unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local is_monster = breed.tags.monster

			if is_monster then
				return
			end

			local buff_extension = ScriptUnit.has_extension(affected_unit, "buff_system")

			if buff_extension then
				local is_already_taunted = buff_extension:has_keyword(buff_keywords.taunted)

				if not is_already_taunted then
					buff_extension:add_internally_controlled_buff("taunted_short", t, "owner_unit", template_context.unit)
				end
			end
		end
	},
	ogryn_windup_reduces_damage_taken = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.85
		},
		start_func = function (template_data, template_context)
			local player_unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			local weapon_action_component = template_data.weapon_action_component
			local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
			local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
			local is_windup = action_settings and action_settings.kind == "windup"

			return is_windup
		end
	},
	ogryn_windup_is_uninterruptible = {
		predicted = false,
		class_name = "buff",
		conditional_keywords = {
			buff_keywords.uninterruptible
		},
		start_func = function (template_data, template_context)
			local player_unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			local weapon_action_component = template_data.weapon_action_component
			local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
			local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
			local is_windup = action_settings and action_settings.kind == "windup"

			return is_windup
		end
	},
	ogryn_bracing_reduces_damage_taken = {
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_bracing_reduces_damage_taken",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
		predicted = false,
		hud_priority = 4,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.85
		},
		start_func = function (template_data, template_context)
			local player_unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			local weapon_action_component = template_data.weapon_action_component
			local braced = PlayerUnitAction.has_current_action_keyword(weapon_action_component, "braced")

			return braced
		end
	},
	ogryn_carapace_armor_child = {
		max_stacks = 10,
		refresh_start_time_on_stack = true,
		predicted = false,
		stack_offset = -1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.toughness_regen_rate_modifier] = 0.025,
			[stat_buffs.toughness_damage_taken_modifier] = -0.025
		},
		conditional_stat_buffs = {
			[stat_buffs.toughness_regen_rate_modifier] = 0.025
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
			template_data.specialization_extension = specialization_extension
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			local specialization_extension = template_data.specialization_extension
			local ogryn_carapace_armor_more_toughness_special_rule = specialization_extension:has_special_rule(special_rules.ogryn_carapace_armor_more_toughness)

			return ogryn_carapace_armor_more_toughness_special_rule
		end
	},
	ogryn_carapace_armor_parent = {
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
		child_buff_template = "ogryn_carapace_armor_child",
		predicted = false,
		start_at_max = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_keystone_carapace_armor",
		restore_child_duration = 6,
		class_name = "parent_proc_buff",
		always_show_in_hud = true,
		proc_events = {
			[proc_events.on_player_hit_received] = 1,
			[proc_events.on_push_finish] = 1
		},
		add_child_proc_events = {
			[proc_events.on_push_finish] = 1
		},
		remove_child_proc_events = {
			[proc_events.on_player_hit_received] = 1
		},
		specific_check_proc_funcs = {
			[proc_events.on_player_hit_received] = function (params, template_data, template_context)
				return params.damage > 0
			end,
			[proc_events.on_push_finish] = function (params, template_data, template_context)
				local specialization_extension = template_data.specialization_extension
				local refresh_on_push = specialization_extension:has_special_rule(special_rules.ogryn_carapace_armor_add_stack_on_push)

				return refresh_on_push and params.num_hit_units > 0
			end
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
			template_data.specialization_extension = specialization_extension
		end,
		on_stacks_removed_func = function (num_child_stacks, num_child_stacks_removed, t, template_data, template_context)
			local specialization_extension = template_data.specialization_extension
			local trigger_on_zero_stack_special_rule = specialization_extension:has_special_rule(special_rules.ogryn_carapace_armor_explosion_on_zero_stacks)
			local buff_extension = template_context.buff_extension
			local has_buff = buff_extension:has_unique_buff_id("ogryn_carapace_armor_explosion_on_zero_stacks_effect")

			if trigger_on_zero_stack_special_rule and num_child_stacks <= 1 and not has_buff then
				buff_extension:add_internally_controlled_buff("ogryn_carapace_armor_explosion_on_zero_stacks_effect", t)
			end
		end
	},
	ogryn_carapace_armor_explosion_on_zero_stacks_effect = {
		unique_buff_id = "ogryn_carapace_armor_explosion_on_zero_stacks_effect",
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_carapace_armor_trigger_on_zero_stacks",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
		predicted = false,
		duration = 30,
		class_name = "buff",
		inverse_duration_progress = true,
		start_func = function (template_data, template_context)
			if not template_context.is_server then
				return
			end

			local unit = template_context.unit
			local world = template_context.world

			Toughness.replenish_percentage(unit, 1, false, "talent_toughness_2")

			local physics_world = World.physics_world(world)
			local explosion_template = ExplosionTemplates.ogryn_carapace_armor_explosion
			local power_level = DEFAULT_POWER_LEVEL
			local position = Unit.local_position(unit, 1)
			local attack_type = AttackSettings.attack_types.explosion

			Explosion.create_explosion(world, physics_world, position + Vector3.up(), nil, unit, explosion_template, power_level, 1, attack_type)
		end
	},
	ogryn_increase_explosion_radius = {
		predicted = false,
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.explosion_radius_modifier] = 0.225
		}
	},
	ogryn_targets_recieve_damage_taken_increase_debuff = {
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_targets_recieve_damage_taken_increase_debuff",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
		predicted = true,
		hud_priority = 3,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_hit] = 1
		},
		check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_melee_hit, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill),
		proc_func = function (params, template_data, template_context, t)
			if CheckProcFunctions.on_kill(params) then
				return
			end

			local victim_unit = params.attacked_unit
			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("ogryn_recieve_damage_taken_increase_debuff", num_stacks, t, "owner_unit", template_context.unit)
			end
		end
	},
	ogryn_recieve_damage_taken_increase_debuff = {
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 1,
		duration = 5,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_taken_modifier] = 0.15
		}
	},
	ogryn_decrease_suppressed_decay = {
		predicted = false,
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.suppressor_decay_multiplier] = 0.5
		}
	},
	ogryn_block_cost_reduction = {
		predicted = false,
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.block_cost_multiplier] = 0.8
		}
	},
	ogryn_blocking_reduces_push_cost = {
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blocking_reduces_push_cost",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
		predicted = true,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[proc_events.on_block] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.push_cost_multiplier] = 0.8
		}
	},
	ogryn_fully_charged_attacks_gain_damage_and_stagger = {
		predicted = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_fully_charged_attacks_gain_damage_and_stagger",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_sweep_start] = 1,
			[proc_events.on_sweep_finish] = 1
		},
		conditional_stat_buffs = {
			[stat_buffs.melee_damage] = 0.4,
			[stat_buffs.melee_impact_modifier] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			return template_data.is_fully_charged
		end,
		check_active_func = function (template_data, template_context)
			return template_data.is_fully_charged
		end,
		specific_proc_func = {
			[proc_events.on_sweep_start] = function (params, template_data, template_context)
				template_data.is_fully_charged = params.is_auto_completed
			end,
			[proc_events.on_sweep_finish] = function (params, template_data, template_context)
				template_data.is_fully_charged = false
			end
		}
	},
	ogryn_charge_speed_on_lunge = {
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ability_bull_rush",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
		predicted = true,
		hud_priority = 3,
		class_name = "proc_buff",
		active_duration = talent_settings_2.combat_ability.active_duration,
		proc_events = {
			[proc_events.on_lunge_end] = talent_settings_2.combat_ability.on_lunge_end_proc_chance
		},
		proc_stat_buffs = {
			[stat_buffs.movement_speed] = talent_settings_2.combat_ability.movement_speed,
			[stat_buffs.melee_attack_speed] = talent_settings_2.combat_ability.melee_attack_speed
		}
	},
	ogryn_charge_bleed = {
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
			if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge then
				return false
			end

			return true
		end,
		proc_func = function (params, template_data, template_context, t)
			local stacks = talent_settings_2.combat_ability_1.stacks
			local hit_unit = params.attacked_unit

			if HEALTH_ALIVE[hit_unit] then
				local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

				if buff_extension then
					buff_extension:add_internally_controlled_buff_with_stacks("bleed", stacks, t, "owner_unit", template_context.unit)
				end
			end
		end
	},
	ogryn_charge_trample = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		check_proc_func = function (params)
			if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge then
				return false
			end

			return true
		end,
		proc_func = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff("ogryn_charge_trample_buff", t)
		end
	},
	ogryn_charge_trample_buff = {
		class_name = "buff",
		max_stacks_cap = 25,
		predicted = false,
		refresh_duration_on_stack = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ability_charge_trample",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
		max_stacks = 25,
		duration = 8,
		stat_buffs = {
			[stat_buffs.damage] = 0.01
		}
	},
	ogryn_base_lunge_toughness_and_damage_resistance = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.melee_heavy_damage] = talent_settings_2.passive_2.melee_heavy_damage,
			[stat_buffs.damage_taken_multiplier] = talent_settings_2.passive_2.damage_taken_multiplier
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

function _passive_revive_conditional(template_data, template_context)
	local is_interacting = template_data.interactor_extension:is_interacting()

	if is_interacting then
		local interaction = template_data.interactor_extension:interaction()
		local interaction_type = interaction:type()
		local is_helping = valid_help_interactions[interaction_type]

		return is_helping
	end
end

templates.ogryn_passive_revive = {
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
templates.ogryn_passive_stagger = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_impact_modifier] = talent_settings_2.passive_1.impact_modifier
	}
}
templates.ogryn_increased_coherency_regen = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = talent_settings_2.toughness_1.toughness_bonus
	}
}
templates.ogryn_heavy_hits_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings_2.toughness_2.on_sweep_finish_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units ~= 1 then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings_2.toughness_2.toughness, false, "talent_toughness_2")
	end
}
templates.ogryn_multiple_enemy_heavy_hits_restore_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings_2.toughness_3.on_sweep_finish_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units <= 1 then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings_2.toughness_3.toughness, false, "talent_toughness_3")
	end
}
templates.ogryn_better_ogryn_fighting = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn] = talent_settings_2.offensive_1.damage_vs_ogryn,
		[stat_buffs.ogryn_damage_taken_multiplier] = talent_settings_2.offensive_1.ogryn_damage_taken_multiplier
	}
}
templates.ogryn_heavy_attacks_bleed = {
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
			local num_stacks = talent_settings_2.offensive_3.stacks

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", template_context.unit)
		end
	end
}
local external_properties = {}
templates.ogryn_friend_grenade_replenishment = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blitz_big_friendly_rock_replenish",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	class_name = "buff",
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges
		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			local cooldown = ability_extension:max_ability_cooldown("grenade_ability")
			template_data.next_grenade_t = t + cooldown
			template_data.cooldown = cooldown

			return
		end

		if next_grenade_t < t then
			template_data.next_grenade_t = nil
			local first_person_extension = template_data.first_person_extension

			if first_person_extension and first_person_extension:is_in_first_person_mode() then
				external_properties.indicator_type = "ogryn_grenade_friend_rock"

				template_data.fx_extension:trigger_gear_wwise_event("grenade_recover_indicator", external_properties)
			end
		end
	end,
	check_active_func = function (template_data, template_context)
		local is_missing_charges = template_data.missing_charges > 0

		return is_missing_charges
	end,
	duration_func = function (template_data, template_context)
		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			return 1
		end

		local t = FixedFrame.get_latest_fixed_time()
		local time_until_next = next_grenade_t - t
		local percentage_left = time_until_next / template_data.cooldown

		return 1 - percentage_left
	end
}
templates.ogryn_bigger_coherency_radius = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.coherency_radius_modifier] = talent_settings_2.coop_1.coherency_aura_size_increase
	}
}
templates.ogryn_charge_grants_allied_movement_speed = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = talent_settings_2.coop_2.on_lunge_start_proc_chance
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		if coherency_extension then
			local units_in_coherence = coherency_extension:in_coherence_units()
			local movement_speed_buff = "ogryn_allied_movement_speed_buff"
			local t = FixedFrame.get_latest_fixed_time()

			for coherency_unit, _ in pairs(units_in_coherence) do
				local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

				coherency_buff_extension:add_internally_controlled_buff(movement_speed_buff, t, "owner_unit", unit)
			end
		end
	end
}
templates.ogryn_allied_movement_speed_buff = {
	hud_priority = 4,
	predicted = true,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ally_movement_boost_on_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	duration = talent_settings_2.coop_2.duration,
	max_stacks = talent_settings_2.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_2.coop_2.movement_speed
	},
	keywords = {
		buff_keywords.stun_immune,
		buff_keywords.suppression_immune
	}
}
templates.ogryn_coherency_increased_melee_damage = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "ogryn_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings_2.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings_2.coherency.melee_damage
	}
}
templates.ogryn_melee_damage_coherency_improved = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "ogryn_coherency_aura_improved",
	class_name = "buff",
	max_stacks = talent_settings_2.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings_2.coherency.melee_damage_improved
	}
}
templates.ogryn_cooldown_on_elite_kills_by_coherence = {
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

		ability_extension:reduce_ability_cooldown_percentage(ability_type, talent_settings_2.coop_3.cooldown)
	end
}
local bleed_dr_max_stacks = talent_settings_2.defensive_1.max_stacks
local bleed_range = DamageSettings.in_melee_range
templates.ogryn_reduce_damage_taken_per_bleed = {
	hud_always_show_stacks = true,
	predicted = false,
	hud_priority = 3,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_nearby_bleeds_reduce_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	always_show_in_hud = true,
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = talent_settings_2.defensive_1.min,
			max = talent_settings_2.defensive_1.max
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
		template_data.next_bleed_check_t = t + talent_settings_2.defensive_1.time
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
			template_data.next_bleed_check_t = t + talent_settings_2.defensive_1.time
		end

		return math.clamp(template_data.num_stacks / bleed_dr_max_stacks, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.clamp(template_data.num_stacks, 0, bleed_dr_max_stacks)
	end
}
local reduced_damage_distance = talent_settings_2.defensive_2.distance * talent_settings_2.defensive_2.distance
templates.ogryn_reduce_damage_taken_on_disabled_allies = {
	hud_always_show_stacks = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_knocked_allies_grant_damage_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = talent_settings_2.defensive_2.min,
			max = talent_settings_2.defensive_2.max
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
local increased_toughness_health_threshold = talent_settings_2.defensive_3.increased_toughness_health_threshold
templates.ogryn_increased_toughness_at_low_health = {
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_toughness_on_low_health",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 3,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.toughness_replenish_multiplier] = talent_settings_2.defensive_3.toughness_replenish_multiplier
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
local breed_name_size = {
	chaos_poxwalker_bomber = 2,
	cultist_flamer = 2,
	renegade_assault = 1,
	chaos_spawn = 10,
	chaos_hound_mutator = 3,
	cultist_mutant = 5,
	chaos_daemonhost = 8,
	chaos_plague_ogryn = 10,
	cultist_melee = 1,
	chaos_poxwalker = 1,
	cultist_shocktrooper = 2,
	chaos_beast_of_nurgle = 10,
	chaos_ogryn_gunner = 5,
	renegade_berzerker = 3,
	cultist_assault = 1,
	renegade_sniper = 1,
	renegade_flamer = 2,
	renegade_shocktrooper = 2,
	renegade_gunner = 2,
	renegade_netgunner = 2,
	cultist_berzerker = 3,
	renegade_rifleman = 1,
	renegade_grenadier = 2,
	chaos_newly_infected = 1,
	renegade_captain = 8,
	chaos_hound = 3,
	chaos_ogryn_bulwark = 5,
	cultist_gunner = 2,
	renegade_melee = 1,
	renegade_executor = 3,
	chaos_ogryn_executor = 5
}

function _big_bull_add_stacks(template_context, stacks)
	local unit = template_context.unit
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension then
		local t = FixedFrame.get_latest_fixed_time()

		for i = 1, stacks do
			buff_extension:add_internally_controlled_buff("ogryn_big_bully_heavy_hits_buff", t)
		end
	end
end

templates.ogryn_big_bully_heavy_hits = {
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
				_big_bull_add_stacks(template_context, stacks)

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

			_big_bull_add_stacks(template_context, stacks)

			template_data.stacks = 0
			template_data.delay = nil
		end
	end
}
templates.ogryn_big_bully_heavy_hits_buff = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 3,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_staggering_increases_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	duration = talent_settings_2.offensive_2_2.duration,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings_2.offensive_2_2.melee_heavy_damage
	},
	max_stacks = talent_settings_2.offensive_2_2.max_stacks,
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
templates.ogryn_melee_revenge_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_hit_received] = 1
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

			template_data.buff_extension:add_internally_controlled_buff("ogryn_melee_revenge_damage_buff", t)
		end
	end
}
templates.ogryn_melee_revenge_damage_buff = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 3,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_revenge_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage] = talent_settings_2.offensive_2_1.damage
	},
	duration = talent_settings_2.offensive_2_1.time
}
templates.ogryn_hitting_multiple_with_melee_grants_melee_damage_bonus = {
	force_predicted_proc = true,
	hud_always_show_stacks = true,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_more_hits_more_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings_2.offensive_2_3.on_sweep_finish_proc_chance
	},
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = talent_settings_2.offensive_2_3.melee_damage * talent_settings_2.offensive_2_3.max_targets
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
		local max_hits = talent_settings_2.offensive_2_3.max_targets

		return math.clamp(hits / max_hits, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		local hits = template_data.hits or 0
		local number_of_stacks = math.clamp(hits, 0, talent_settings_2.offensive_2_3.max_targets)

		return number_of_stacks
	end,
	check_active_func = function (template_data, template_context)
		local hits = template_data.hits or 0
		local show = hits > 0

		return show
	end
}
templates.ogryn_bull_rush_hits_replenish_toughness = {
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
		if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local is_lunging = template_data.lunge_character_state_component.is_lunging

		if not is_lunging then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings_2.combat_ability_3.toughness, false, "bull_rush_toughness_talent")
	end
}
local stance_duration = 10
templates.ogryn_ranged_stance = {
	unique_buff_id = "ogryn_ranged_stance",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ability_speshul_ammo",
	predicted = true,
	class_name = "buff",
	duration = stance_duration,
	keywords = {
		buff_keywords.ogryn_combat_ability_stance
	},
	stat_buffs = {
		[stat_buffs.ranged_attack_speed] = 0.25,
		[stat_buffs.reload_speed] = 0.7
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local no_movement_penalty = special_rules.ogryn_combat_no_movement_penalty

		if specialization_extension:has_special_rule(no_movement_penalty) then
			local buff_name = "ogryn_ranged_stance_no_movement_penalty_buff"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local fire_shots = special_rules.ogryn_ranged_stance_fire_shots

		if specialization_extension:has_special_rule(fire_shots) then
			local buff_name = "ogryn_ranged_stance_fire_shots"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local armor_piercing_shots = special_rules.ogryn_combat_armor_pierce

		if specialization_extension:has_special_rule(armor_piercing_shots) then
			local buff_name = "ogryn_ranged_stance_armor_pierce"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local toughness_regen = special_rules.ogryn_ranged_stance_toughness_regen

		if specialization_extension:has_special_rule(toughness_regen) then
			local buff_name = "ogryn_ranged_stance_toughness_regen"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end
}
templates.ogryn_increased_ammo_reserve_passive = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = talent_settings_1.passive_3.increased_max_ammo
	}
}
templates.ogryn_passive_proc_combat_ability_cooldown_reduction = {
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_leadbelcher_cooldown_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	hud_priority = 3,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_ammo_consumed] = 1
	},
	proc_func = function (params, template_data, template_context)
		local specialization_extension = template_data.specialization_extension

		if params.is_leadbelcher_shot then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.buff_extension:add_internally_controlled_buff("ogryn_no_ammo_consumption_passive_cooldown_buff", t)
		end
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end
}
templates.ogryn_no_ammo_consumption_passive_cooldown_buff = {
	predicted = false,
	max_stacks = 1,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings_1.spec_passive_1.duration,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if not template_data.timer then
			template_data.timer = t + 1
		end

		if template_data.timer < t then
			template_data.timer = t + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings_1.spec_passive_1.increased_cooldown_regeneration)
		end
	end
}
templates.ogryn_aura_increased_damage_vs_suppressed = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "ogryn_aura_increased_damage_vs_suppressed",
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_suppressed] = 0.2
	}
}
templates.ogryn_increased_damage_after_reload = {
	predicted = false,
	hud_priority = 4,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_reloading_grants_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = talent_settings_1.mixed_1.duration,
	proc_events = {
		[proc_events.on_reload] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings_1.mixed_1.damage_after_reload
	}
}
templates.ogryn_increased_clip_size = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.clip_size_modifier] = talent_settings_1.mixed_3.increased_clip_size
	}
}
templates.ogryn_crit_chance_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("ogryn_crit_chance_on_kill_effect", t)
		end
	end,
	check_proc_func = CheckProcFunctions.on_kill
}
templates.ogryn_crit_chance_on_kill_effect = {
	predicted = false,
	refresh_duration_on_stack = true,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_kills_grant_crit_chance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	duration = talent_settings_1.offensive_1.duration,
	max_stacks = talent_settings_1.offensive_1.max_stacks,
	max_stacks_cap = talent_settings_1.offensive_1.max_stacks,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_1.offensive_1.crit_chance_on_kill
	}
}
templates.ogryn_increased_suppression = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.suppression_dealt] = talent_settings_1.offensive_2.increased_suppression
	}
}
templates.ogryn_increased_reload_speed_on_multiple_hits = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	start_func = function (template_data, template_context)
		template_data.hit_units = {}
		template_data.num_hit_units = 0
		template_data.num_hits_required = talent_settings_1.offensive_3.num_multi_hit
		template_data.multi_hit_window = talent_settings_1.offensive_3.multi_hit_window
		template_data.last_added_buff_t = 0
	end,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local hit_units = template_data.hit_units
		local unit = params.attacked_unit
		local num_hit_units = template_data.num_hit_units

		if not hit_units[unit] then
			num_hit_units = num_hit_units + 1
			template_data.num_hit_units = num_hit_units
		end

		hit_units[unit] = t + template_data.multi_hit_window

		if num_hit_units > 0 then
			for hit_unit, unit_t in pairs(hit_units) do
				if unit_t < t then
					template_data.num_hit_units = template_data.num_hit_units - 1
					hit_units[hit_unit] = nil
				end
			end
		end

		if template_data.num_hits_required <= template_data.num_hit_units and template_data.last_added_buff_t < t then
			template_data.last_added_buff_t = t
			local player_unit = template_context.unit
			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
			local reload_buff = "ogryn_increased_reload_speed_on_multiple_hits_effect"

			buff_extension:add_internally_controlled_buff(reload_buff, t)
		end
	end
}
templates.ogryn_increased_reload_speed_on_multiple_hits_effect = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	class_name = "buff",
	duration = talent_settings_1.offensive_3.duration,
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings_1.offensive_3.reload_speed_on_multi_hit
	}
}
templates.ogryn_movement_speed_on_ranged_kill = {
	predicted = true,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_movement_speed_after_ranged_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = talent_settings_1.defensive_2.duration,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_1.defensive_2.move_speed_on_ranged_kill
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill
}
templates.ogryn_regen_toughness_on_braced = {
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_toughness_while_bracing",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 4,
	class_name = "buff",
	update_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_component = unit_data_extension:read_component("weapon_action")
		local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")
		template_data.braced = braced

		if braced then
			Toughness.replenish(unit, "ogryn_braced_regen")
		end
	end,
	check_active_func = function (template_data, template_context)
		return template_data.braced
	end
}
templates.ogryn_ranged_stance_no_movement_penalty_buff = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	duration = stance_duration,
	conditional_stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = talent_settings_1.combat_ability_3.reduced_move_penalty,
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = talent_settings_1.combat_ability_3.reduced_move_penalty,
		[stat_buffs.damage_near] = talent_settings_1.combat_ability_3.increased_damage_vs_close
	},
	start_func = function (template_data, template_context)
		template_data.wielding_ranged = true
	end,
	specific_proc_func = {
		on_wield_ranged = function (params, template_data, template_context)
			template_data.wielding_ranged = true
		end,
		on_wield_melee = function (params, template_data, template_context)
			template_data.wielding_ranged = false
		end
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.wielding_ranged
	end
}
templates.ogryn_ranged_stance_toughness_regen = {
	predicted = false,
	class_name = "proc_buff",
	duration = stance_duration,
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_reload] = 1
	},
	specific_proc_func = {
		on_shoot = function (params, template_data, template_context)
			Toughness.replenish_percentage(template_context.unit, 0.02, false, "ogryn_ranged_stance_shoot")
		end,
		on_reload = function (params, template_data, template_context)
			Toughness.replenish_percentage(template_context.unit, 0.1, false, "ogryn_ranged_stance_reload")
		end
	}
}
templates.ogryn_ranged_stance_armor_pierce = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	duration = stance_duration,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1
	},
	conditional_stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.3
	},
	start_func = function (template_data, template_context)
		template_data.wielding_ranged = true
	end,
	specific_proc_func = {
		on_wield_ranged = function (params, template_data, template_context)
			template_data.wielding_ranged = true
		end,
		on_wield_melee = function (params, template_data, template_context)
			template_data.wielding_ranged = false
		end
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.wielding_ranged
	end
}
local burning_buff = "flamer_assault"
templates.ogryn_ranged_stance_fire_shots = {
	predicted = false,
	max_stacks = 1,
	duration = 10,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = function (params, template_data, template_context, t)
		return CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t) and CheckProcFunctions.attacked_unit_is_minion(params, template_data, template_context, t)
	end,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if ALIVE[attacked_unit] then
			local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local damage_profile = params.damage_profile
				local num_stacks = damage_profile.ogryn_ranged_stance_fire_shots_override or talent_settings_1.combat_ability_1.num_stacks

				for i = 1, num_stacks do
					buff_extension:add_internally_controlled_buff(burning_buff, t, "owner_unit", template_context.unit)
				end
			end
		end
	end
}

return templates
