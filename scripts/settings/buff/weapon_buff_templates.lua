local Action = require("scripts/utilities/weapon/action")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionState = require("scripts/utilities/minion_state")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local stagger_results = AttackSettings.stagger_results
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local CHAIN_LIGHTNING_POWER_LEVEL = 500
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
				local owner_unit = template_context.is_server and template_context.owner_unit or nil
				local source_item = template_context.is_server and template_context.source_item or nil

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.burning, "attacking_unit", owner_unit, "item", source_item)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	warp_fire = {
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
				local owner_unit = template_context.is_server and template_context.owner_unit or nil
				local source_item = template_context.is_server and template_context.source_item or nil

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.warpfire, "attacking_unit", owner_unit, "item", source_item)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.warpfire,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_warpfire",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	bleed = {
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
				local source_item = template_context.is_server and template_context.source_item or nil
				local owner_unit = template_context.is_server and template_context.owner_unit or template_context.unit or nil

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
	},
	increase_impact_received_while_staggered = {
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
	},
	increase_damage_received_while_staggered = {
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
	},
	rending_debuff = {
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 8,
		duration = 5,
		class_name = "buff",
		stat_buffs = {
			[buff_stat_buffs.rending_multiplier] = 0.05
		}
	},
	ogryn_slabshield_shield_plant = {
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
	},
	power_maul_chock_hit = {
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

					stick_to_buff_extension:add_internally_controlled_buff("chock_effect", t)
				end
			end
		end
	},
	chain_lightning_interval = {
		predicted = false,
		start_with_frame_offset = true,
		max_stacks = 1,
		max_stacks_cap = 1,
		chock_effect_buff_template = "chock_effect",
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

				buff_extension:add_internally_controlled_buff(template.chock_effect_buff_template, t)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.electrocution
		}
	},
	chain_lightning_quick_interval = {
		predicted = false,
		start_with_frame_offset = true,
		max_stacks = 1,
		max_stacks_cap = 1,
		quick_multiplier = 0.25,
		chock_effect_buff_template = "chock_effect",
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

				buff_extension:add_internally_controlled_buff(template.chock_effect_buff_template, t)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.electrocution
		}
	},
	chock_effect = {
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
}

return templates
