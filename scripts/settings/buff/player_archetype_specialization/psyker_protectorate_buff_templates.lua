local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WarpCharge = require("scripts/utilities/warp_charge")
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.psyker_3
local DEFUALT_POWER_LEVEL = talent_settings.grenade.default_power_level
local templates = {
	chain_lightning_interval = {
		predicted = false,
		start_interval_on_apply = true,
		class_name = "interval_buff",
		keywords = {
			keywords.electrocuted
		},
		interval = talent_settings.grenade.interval,
		max_stacks = talent_settings.grenade.max_stacks,
		max_stacks_cap = talent_settings.grenade.max_stacks_cap,
		interval_function = function (template_data, template_context, template)
			local is_server = template_context.is_server

			if not is_server then
				return
			end

			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_template = DamageProfileTemplates.psyker_protectorate_smite_interval
				local owner_unit = template_context.owner_unit
				local power_level = DEFUALT_POWER_LEVEL
				local attack_direction = nil
				local target_position = POSITION_LOOKUP[unit]
				local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

				if owner_position and target_position then
					attack_direction = Vector3.normalize(target_position - owner_position)
				end

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, HEALTH_ALIVE[owner_unit] and "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, attack_direction and "attack_direction", attack_direction)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.electrocution,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_chainlightning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
						looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit"
					}
				}
			}
		}
	},
	chain_lightning_quick_interval = {
		predicted = false,
		start_interval_on_apply = true,
		class_name = "interval_buff",
		keywords = {
			keywords.electrocuted
		},
		interval = talent_settings.grenade.quick_interval,
		max_stacks = talent_settings.grenade.quick_max_stacks,
		max_stacks_cap = talent_settings.grenade.quick_max_stacks_cap,
		interval_function = function (template_data, template_context, template)
			local is_server = template_context.is_server

			if not is_server then
				return
			end

			local quick_multiplier = talent_settings.grenade.quick_multiplier
			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_template = DamageProfileTemplates.psyker_protectorate_smite_interval
				local owner_unit = template_context.owner_unit
				local power_level = DEFUALT_POWER_LEVEL * quick_multiplier
				local attack_direction = nil
				local target_position = POSITION_LOOKUP[unit]
				local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

				if owner_position and target_position then
					attack_direction = Vector3.normalize(target_position - owner_position)
				end

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, HEALTH_ALIVE[owner_unit] and "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, attack_direction and "attack_direction", attack_direction)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.electrocution,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_chainlightning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
						looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit"
					}
				}
			}
		}
	}
}
local empowered_chain_lightning_chance = talent_settings.passive_1.empowered_chain_lightning_chance
local max_stack = talent_settings.passive_1.max_stacks
local max_stack_talent = talent_settings.offensive_2.max_stacks_talent
local toughness_for_allies = talent_settings.spec_passive_1.toughness_for_allies
local warp_charge_removal = talent_settings.spec_passive_2.warp_charge_removal
templates.psyker_protectorate_base_passive = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = empowered_chain_lightning_chance,
		[proc_events.on_chain_lightning_finished] = 1,
		[proc_events.on_chain_lightning_start] = 1
	},
	conditional_stat_buffs = {
		[stat_buffs.chain_lightning_damage] = talent_settings.passive_1.chain_lightning_damage,
		[stat_buffs.chain_lightning_cost_multiplier] = talent_settings.passive_1.chain_lightning_cost_multiplier
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.increased_stacks = specialization_extension:has_special_rule(special_rules.psyker_protectorate_increased_chain_lightnings)
		template_data.lightning_toughness = specialization_extension:has_special_rule(special_rules.psyker_protectorate_lightning_toughness)
		template_data.lightning_warp_charge = specialization_extension:has_special_rule(special_rules.psyker_protectorate_lightning_warp_charge)
		template_data.lightning_attack_speed = specialization_extension:has_special_rule(special_rules.psyker_protectorate_lightning_attack_speed)
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.warp_charge_component = unit_data_extension:write_component("warp_charge")
		template_data.charges = 0
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.charges > 0
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctionTemplates.on_kill(params) then
				return
			end

			local max_stacks = (template_data.increased_stacks and max_stack_talent) or max_stack
			template_data.charges = math.clamp(template_data.charges + 1, 0, max_stacks)
			local buff_name = (template_data.increased_stacks and "psyker_protectorate_base_passive_visual_buff_increased") or "psyker_protectorate_base_passive_visual_buff"
			local t = Managers.time:time("gameplay")

			template_data.fx_extension:spawn_exclusive_particle("content/fx/particles/screenspace/screen_biomancer_souls", Vector3(0, 0, 1))
			template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
		end,
		on_chain_lightning_finished = function (params, template_data, template_context)
			if template_data.charges < 1 then
				return
			end

			template_data.charges = template_data.charges - 1
		end,
		on_chain_lightning_start = function (params, template_data, template_context)
			if template_data.lightning_toughness then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()

				for coherency_unit, _ in pairs(units_in_coherence) do
					Toughness.replenish_percentage(coherency_unit, toughness_for_allies)
				end
			elseif template_data.lightning_warp_charge then
				local warp_charge_component = template_data.warp_charge_component
				local current_percentage = warp_charge_component.current_percentage
				local remove_percentage = current_percentage * warp_charge_removal

				WarpCharge.decrease_immediate(remove_percentage, warp_charge_component)
			elseif template_data.lightning_attack_speed then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()
				local movement_speed_buff = "psyker_protectorate_attack_speed_buff"
				local t = Managers.time:time("gameplay")

				for coherency_unit, _ in pairs(units_in_coherence) do
					local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

					coherency_buff_extension:add_internally_controlled_buff(movement_speed_buff, t)
				end
			end
		end
	}
}
templates.psyker_protectorate_base_passive_visual_buff = {
	predicted = false,
	unique_removal = true,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_chain_lightning_finished] = 1
	},
	max_stacks = max_stack,
	max_stacks_cap = max_stack,
	proc_func = function (params, template_data)
		template_data.finish = true
	end,
	conditional_stack_exit_func = function (template_data)
		if template_data.finish then
			return true
		end
	end,
	on_remove_stack_function = function (template_data)
		template_data.finish = false
	end
}
templates.psyker_protectorate_base_passive_visual_buff_increased = {
	predicted = false,
	unique_removal = true,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_chain_lightning_finished] = 1
	},
	max_stacks = max_stack_talent,
	max_stacks_cap = max_stack_talent,
	proc_func = function (params, template_data)
		template_data.finish = true
	end,
	conditional_stack_exit_func = function (template_data)
		if template_data.finish then
			return true
		end
	end,
	on_remove_stack_function = function (template_data)
		template_data.finish = false
	end
}
templates.psyker_protectorate_damage_aura = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "psyker_protectorate_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.coherency.damage
	}
}
templates.psyker_protectorate_damage_aura_improved = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "psyker_protectorate_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coop_2.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.coop_2.damage
	}
}
local fixed_percentage = talent_settings.mixed_1.fixed_percentage
templates.psyker_protectorate_warp_kills_replenish_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.mixed_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_warp_kill,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, fixed_percentage)
	end
}
templates.psyker_protectorate_chain_lightning_reduces_movement_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.mixed_2.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_chain_lightning_hit,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("psyker_protectorate_chain_lightning_movement_speed_debuff", t)
		end
	end
}
templates.psyker_protectorate_chain_lightning_movement_speed_debuff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.mixed_2.duration,
	max_stacks = talent_settings.mixed_2.max_stacks,
	max_stacks_cap = talent_settings.mixed_2.max_stacks_cap,
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.mixed_2.movement_speed
	}
}
templates.psyker_protectorate_increase_vent_speed = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.vent_warp_charge_speed] = talent_settings.mixed_3.vent_warp_charge_speed
	}
}
templates.psyker_protectorate_increase_chain_lightning_size = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.chain_lightning_max_jumps] = talent_settings.offensive_1.chain_lightning_max_jumps,
		[stat_buffs.chain_lightning_max_radius] = talent_settings.offensive_1.chain_lightning_max_radius,
		[stat_buffs.chain_lightning_max_angle] = talent_settings.offensive_1.chain_lightning_max_angle
	}
}
templates.psyker_protectorate_units_pass_through_force_field = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_unit_enter_force_field] = 1
	},
	start_func = function (template_data, template_context)
		template_data.force_fields_used = {}
	end,
	proc_func = function (params, template_data, template_context)
		local unit = params.passing_unit
		local force_field_owner_unit = params.force_field_owner_unit
		local side_system = Managers.state.extension:system("side_system")
		local target_is_enemy = side_system:is_enemy(force_field_owner_unit, unit)

		if not target_is_enemy then
			return
		end

		local force_field_unit = params.force_field_unit

		if not template_data.force_fields_used[force_field_unit] then
			template_data.force_fields_used[force_field_unit] = {}
		elseif template_data.force_fields_used[force_field_unit][unit] then
			return
		end

		local unit_pos = POSITION_LOOKUP[unit]
		local force_field_pos = POSITION_LOOKUP[force_field_unit]
		local damage_profile = DamageProfileTemplates.protectorate_force_field
		local power_level = talent_settings.offensive_3.power_level
		local attack_direction = Vector3.normalize(unit_pos - force_field_pos)
		local damage_type = damage_types.warp
		local attack_type = attack_types.buff

		Attack.execute(unit, damage_profile, "attack_direction", attack_direction, "power_level", power_level, "hit_zone_name", "torso", "damage_type", damage_type, "attack_type", attack_type, "attacking_unit", template_context.unit)
	end
}
templates.psyker_protectorate_player_pass_through_force_field = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_unit_enter_force_field] = 1
	},
	start_func = function (template_data, template_context)
		template_data.force_fields_used = {}
	end,
	proc_func = function (params, template_data, template_context)
		local unit = params.passing_unit
		local force_field_unit = params.force_field_unit

		if not params.is_player_unit then
			return
		end

		if not template_data.force_fields_used[force_field_unit] then
			template_data.force_fields_used[force_field_unit] = {}
		elseif template_data.force_fields_used[force_field_unit][unit] then
			return
		end

		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("psyker_protectorate_force_field_buff", t)

			template_data.force_fields_used[force_field_unit][unit] = true
		end
	end
}
templates.psyker_protectorate_force_field_buff = {
	predicted = true,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.defensive_1.duration,
	max_stacks = talent_settings.defensive_1.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.defensive_1.toughness_damage_taken_multiplier,
		[stat_buffs.movement_speed] = talent_settings.defensive_1.movement_speed
	}
}
templates.psyker_protectorate_reduced_toughness_damage_taken = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.defensive_2.toughness_damage_taken_multiplier
	}
}
templates.psyker_protectorate_chain_lightning_increases_movement_speed = {
	predicted = true,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_chain_lightning_start] = talent_settings.defensive_3.on_chain_lighting_start_proc_chance
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.defensive_3.movement_speed
	},
	active_duration = talent_settings.defensive_3.active_duration
}
templates.toughness_when_allied_gets_knocked_down = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_ally_knocked_down] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local toughness_percent = talent_settings.coop_1.toughness_percent
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, _ in pairs(units_in_coherence) do
			Toughness.replenish_percentage(coherency_unit, toughness_percent)
		end
	end
}
local distance = talent_settings.coop_3.distance
local valid_distance_sq = distance * distance
local toughness_percentage = talent_settings.coop_3.toughness_percentage
templates.psyker_protectorate_toughness_regen_at_shield = {
	interval = 1,
	predicted = false,
	class_name = "interval_buff",
	start_func = function (template_data, template_context)
		local side_system = Managers.state.extension:system("side_system")
		template_data.side = side_system.side_by_unit[template_context.unit]
		template_data.force_field_system = Managers.state.extension:system("force_field_system")
	end,
	interval_function = function (template_data, template_context)
		local unit = template_context.unit
		local extensions = template_data.force_field_system:get_extensions_by_owner_unit(unit)

		if #extensions > 0 then
			local valid_player_units = template_data.side.valid_player_units

			for i = 1, #valid_player_units, 1 do
				local player_unit = valid_player_units[i]

				for _, extension in pairs(extensions) do
					local force_field_unit = extension:force_field_unit()
					local force_field_pos = Unit.local_position(force_field_unit, 1)
					local player_unit_pos = POSITION_LOOKUP[player_unit]
					local distance_sq = Vector3.distance_squared(force_field_pos, player_unit_pos)

					if distance_sq < valid_distance_sq then
						Toughness.replenish_percentage(player_unit, toughness_percentage)
					end
				end
			end
		end
	end
}
templates.psyker_protectorate_attack_speed_buff = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings.spec_passive_3.attack_speed
	},
	duration = talent_settings.spec_passive_3.duration
}

return templates
