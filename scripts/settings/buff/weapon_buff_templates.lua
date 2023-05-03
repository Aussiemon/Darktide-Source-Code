local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local ailment_effects = AilmentSettings.effects
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local buff_stat_buffs = BuffSettings.stat_buffs
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local stagger_results = AttackSettings.stagger_results
local special_rules = SpecialRulesSetting.special_rules
local CHAIN_LIGHTNING_POWER_LEVEL = 500
local psyker_talent_settings = TalentSettings.psyker_2
local templates = {
	flamer_assault = {
		interval = 0.5,
		duration = 4,
		buff_id = "flamer_assault",
		interval_stack_removal = true,
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks_cap = 31,
		max_stacks = 31,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
		},
		interval_func = function (template_data, template_context, template)
			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_template = DamageProfileTemplates.burning
				local stack_multiplier = template_context.stack_count / template.max_stacks
				local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
				local power_level = smoothstep_multiplier * 500
				local owner_unit = template_context.is_server and template_context.owner_unit
				local source_item = template_context.is_server and template_context.source_item

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.burning, "attacking_unit", owner_unit, "item", source_item)
			end
		end,
		minion_effects = minion_burning_buff_effects.fire
	}
}
local warpfire_broadphase_results = {}
templates.warp_fire = {
	interval = 0.75,
	predicted = false,
	interval_stack_removal = true,
	max_stacks_cap = 31,
	refresh_duration_on_stack = true,
	max_stacks = 31,
	duration = 8,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.burning,
		buff_keywords.warpfire_burning
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.warpfire
			local stack_multiplier = template_context.stack_count / template.max_stacks
			local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
			local power_level = smoothstep_multiplier * 500
			local owner_unit = template_context.is_server and template_context.owner_unit
			local source_item = template_context.is_server and template_context.source_item

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.warpfire, "attacking_unit", owner_unit, "item", source_item)
		end
	end,
	on_remove_stack_func = function (template_data, template_context, change, new_stack_count)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] and not template_data.stacks_on_death then
			template_data.stacks_on_death = math.min(new_stack_count + change, psyker_talent_settings.offensive_2_2.stacks_to_share)
		end
	end,
	stop_func = function (template_data, template_context)
		local stacks_to_share = template_data.stacks_on_death

		if stacks_to_share then
			local owner_unit = template_context.owner_unit
			local specialization_extension = ScriptUnit.has_extension(owner_unit, "specialization_system")

			if specialization_extension then
				local spread_warpfire_on_kill = special_rules.psyker_biomancer_spread_warpfire_on_kill
				local has_special_rule = specialization_extension:has_special_rule(spread_warpfire_on_kill)

				if has_special_rule then
					local broadphase_system = Managers.state.extension:system("broadphase_system")
					local broadphase = broadphase_system.broadphase
					local side_system = Managers.state.extension:system("side_system")
					local side = side_system.side_by_unit[owner_unit]
					local enemy_side_names = side:relation_side_names("enemy")
					local victim_unit = template_context.unit
					local position = POSITION_LOOKUP[victim_unit]
					local distance = 5
					local num_results = broadphase:query(position, distance, warpfire_broadphase_results, enemy_side_names)

					if num_results > 0 then
						local i = 1
						local num_invalid_targets = 0

						while stacks_to_share > 0 do
							local unit = warpfire_broadphase_results[i]
							local valid_target = false

							if HEALTH_ALIVE[unit] then
								local enemy_unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
								local enemy_breed = enemy_unit_data_extension:breed()

								if not enemy_breed.tags.witch then
									valid_target = true
								else
									local blackboard = BLACKBOARDS[unit]
									local perception_component = blackboard.perception

									if perception_component.aggro_state == "aggroed" then
										valid_target = true
									end
								end

								if valid_target then
									local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

									if buff_extension then
										if buff_extension:current_stacks("warp_fire") < template_data.stacks_on_death then
											local t = FixedFrame.get_latest_fixed_time()

											buff_extension:add_internally_controlled_buff("warp_fire", t, "owner_unit", owner_unit)

											stacks_to_share = stacks_to_share - 1
										else
											valid_target = false
										end
									end
								end
							end

							if not valid_target then
								num_invalid_targets = num_invalid_targets + 1

								if num_results <= num_invalid_targets then
									break
								end
							end

							if i == num_results then
								i = 1
							else
								i = i + 1
							end
						end
					end
				end
			end
		end
	end,
	minion_effects = minion_burning_buff_effects.warpfire
}
templates.bleed = {
	interval = 0.5,
	predicted = false,
	interval_stack_removal = true,
	max_stacks_cap = 16,
	refresh_duration_on_stack = true,
	max_stacks = 16,
	duration = 1.5,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.bleeding
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.bleeding
			local stack_multiplier = template_context.stack_count / template.max_stacks
			local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
			local power_level = smoothstep_multiplier * 500
			local source_item = template_context.is_server and template_context.source_item
			local owner_unit = template_context.is_server and template_context.owner_unit or template_context.unit

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.bleeding, "attacking_unit", owner_unit, "item", source_item)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					particle_effect = "content/fx/particles/enemies/buff_bleeding",
					orphaned_policy = "destroy",
					stop_type = "stop"
				}
			}
		}
	}
}
templates.increase_impact_received_while_staggered = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 8,
	duration = 5,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.impact_modifier] = 0.05
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit

		return MinionState.is_staggered(unit)
	end
}
templates.increase_damage_received_while_staggered = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 8,
	duration = 5,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.damage_vs_staggered] = 0.05
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit

		return MinionState.is_staggered(unit)
	end
}
templates.rending_debuff = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 8,
	duration = 5,
	class_name = "buff",
	stat_buffs = {
		[buff_stat_buffs.rending_multiplier] = 0.05
	}
}
templates.ogryn_slabshield_shield_plant = {
	max_stacks = 1,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.block_cost_multiplier] = 0.15
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local slot_name = template_context.item_slot_name
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		template_data.inventory_slot_component = unit_data_extension:read_component(slot_name)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.inventory_slot_component.special_active
	end
}
templates.power_maul_shock_hit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		local damage_efficiency = params.damage_efficiency
		local stagger_result = params.stagger_result

		return stagger_result == stagger_results.stagger and damage_efficiency == damage_efficiencies.full
	end,
	proc_func = function (params, template_data, template_context)
		if template_context.is_server then
			local attacked_unit = params.attacked_unit
			local stick_to_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if stick_to_buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				stick_to_buff_extension:add_internally_controlled_buff("shock_effect", t)
			end
		end
	end
}
templates.chain_lightning_interval = {
	predicted = false,
	start_with_frame_offset = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	shock_effect_buff_template = "shock_effect",
	start_interval_on_apply = true,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.electrocuted
	},
	interval = {
		0.1,
		0.3
	},
	interval_attack_damage_profile = DamageProfileTemplates.default_chain_lighting_interval,
	start_func = function (template_data, template_context, template)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local buff_extension = ScriptUnit.has_extension(template_context.unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	interval_func = function (template_data, template_context, template)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = template.interval_attack_damage_profile
			local owner_unit = template_context.owner_unit
			local attack_direction = nil
			local target_position = POSITION_LOOKUP[unit]
			local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

			if owner_position and target_position then
				attack_direction = Vector3.normalize(target_position - owner_position)
			end

			Attack.execute(unit, damage_template, "power_level", CHAIN_LIGHTNING_POWER_LEVEL, "damage_type", damage_types.electrocution, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end

		local buff_extension = template_data.buff_extension

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(template.shock_effect_buff_template, t)
		end
	end,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution
	}
}
templates.chain_lightning_quick_interval = {
	predicted = false,
	start_with_frame_offset = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	quick_multiplier = 0.25,
	shock_effect_buff_template = "shock_effect",
	start_interval_on_apply = true,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.electrocuted
	},
	interval = {
		0.1,
		0.3
	},
	interval_attack_damage_profile = DamageProfileTemplates.default_chain_lighting_interval,
	start_func = function (template_data, template_context, template)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local buff_extension = ScriptUnit.has_extension(template_context.unit, "buff_extension")
		template_data.buff_extension = buff_extension
	end,
	interval_func = function (template_data, template_context, template)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		quick_multiplier = template.quick_multiplier
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = template.interval_attack_damage_profile
			local owner_unit = template_context.owner_unit
			local power_level = CHAIN_LIGHTNING_POWER_LEVEL * quick_multiplier
			local attack_direction = nil
			local target_position = POSITION_LOOKUP[unit]
			local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

			if owner_position and target_position then
				attack_direction = Vector3.normalize(target_position - owner_position)
			end

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end

		local buff_extension = template_data.buff_extension

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(template.shock_effect_buff_template, t)
		end
	end,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution
	}
}
templates.shock_effect = {
	refresh_duration_on_stack = true,
	max_stacks = 1,
	predicted = false,
	duration = 2,
	class_name = "buff",
	keywords = {
		buff_keywords.electrocuted
	},
	minion_effects = {
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
templates.taunted = {
	unique_buff_id = "taunted",
	duration = 10,
	buff_id = "taunted",
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.taunted
	},
	start_func = function (template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local taunter_unit = template_context.owner_unit
		local taunter_buff_extension = ScriptUnit.extension(taunter_unit, "buff_system")
		template_data.taunter_buff_extension = taunter_buff_extension
		local taunter_unit_data_extension = ScriptUnit.extension(taunter_unit, "unit_data_system")
		local taunter_breed = taunter_unit_data_extension:breed()

		if Breed.is_player(taunter_breed) then
			local taunter_character_state_component = taunter_unit_data_extension:read_component("character_state")
			template_data.taunter_character_state_component = taunter_character_state_component
		end

		local breed = template_context.breed
		local is_disabler = breed.tags.disabler
		template_data.is_disabler = is_disabler
		local unit = template_context.unit
		local blackboard = BLACKBOARDS[unit]
		local perception_component = blackboard.perception

		if perception_component.target_unit ~= taunter_unit then
			Managers.state.extension:system("perception_system"):register_prioritized_unit_update(unit)
		end
	end,
	conditional_stack_exit_func = function (template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return false
		end

		local taunter_unit = template_context.owner_unit

		if not HEALTH_ALIVE[taunter_unit] then
			return true
		end

		local taunter_buff_extension = template_data.taunter_buff_extension
		local is_invisible = taunter_buff_extension:has_keyword(buff_keywords.invisible)
		local is_unperceivable = taunter_buff_extension:has_keyword(buff_keywords.unperceivable)

		if is_invisible or is_unperceivable then
			return true
		end

		local is_disabler = template_data.is_disabler
		local taunter_character_state_component = template_data.taunter_character_state_component

		if is_disabler and taunter_character_state_component and PlayerUnitStatus.is_disabled(taunter_character_state_component) then
			return true
		end

		return false
	end
}

return templates
