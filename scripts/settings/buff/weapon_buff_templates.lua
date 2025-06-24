-- chunkname: @scripts/settings/buff/weapon_buff_templates.lua

local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffUtils = require("scripts/settings/buff/buff_utils")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitMass = require("scripts/utilities/attack/hit_mass")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local ailment_effects = AilmentSettings.effects
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = BuffSettings.targets
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local special_rules = SpecialRulesSettings.special_rules
local stagger_results = AttackSettings.stagger_results
local attack_types = AttackSettings.attack_types
local CHAIN_LIGHTNING_POWER_LEVEL = 500
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PI = math.pi
local PI_2 = PI * 2
local psyker_talent_settings = TalentSettings.psyker_2
local templates = {}

table.make_unique(templates)

templates.flamer_assault = {
	buff_id = "flamer_assault",
	class_name = "interval_buff",
	duration = 4,
	interval = 0.5,
	interval_stack_removal = true,
	max_stacks = 31,
	max_stacks_cap = 31,
	predicted = false,
	refresh_duration_on_stack = true,
	keywords = {
		buff_keywords.burning,
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

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.burning, "attacking_unit", owner_unit, "item", source_item, "attack_type", attack_types.buff)
		end
	end,
	minion_effects = minion_burning_buff_effects.fire,
}

local function warpfire_added_proc_func(template_data, template_context)
	local owner_unit = template_context.owner_unit

	if owner_unit then
		local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

		if buff_extension then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.buffed_unit = template_context.unit
				param_table.buffer_unit = owner_unit

				buff_extension:add_proc_event(buff_proc_events.on_warp_fire_applied, param_table)
			end
		end
	end
end

local _warpfire_broadphase_results = {}

templates.warp_fire = {
	buff_id = "warp_fire",
	class_name = "interval_buff",
	duration = 8,
	interval = 0.75,
	interval_stack_removal = true,
	max_stacks = 31,
	max_stacks_cap = 31,
	predicted = false,
	refresh_duration_on_stack = true,
	keywords = {
		buff_keywords.burning,
		buff_keywords.warpfire_burning,
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

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.warpfire, "attack_type", attack_types.buff, "attacking_unit", owner_unit, "item", source_item)
		end
	end,
	on_remove_stack_func = function (template_data, template_context, change, new_stack_count)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] and not template_data.stacks_on_death then
			template_data.stacks_on_death = math.min(new_stack_count + change, psyker_talent_settings.offensive_2_2.stacks_to_share)
		end
	end,
	start_func = function (template_data, template_context)
		template_data.previous_stacks = 0
	end,
	update_func = function (template_data, template_context)
		if template_data.previous_stacks < template_context.stack_count then
			template_data.should_proc = true
			template_data.previous_stacks = template_context.stack_count
		end

		if template_data.should_proc then
			warpfire_added_proc_func(template_data, template_context)

			template_data.should_proc = false
		end
	end,
	stop_func = function (template_data, template_context)
		local stacks_to_share = template_data.stacks_on_death

		if stacks_to_share then
			local owner_unit = template_context.owner_unit
			local talent_extension = ScriptUnit.has_extension(owner_unit, "talent_system")

			if talent_extension then
				local spread_warpfire_on_kill = special_rules.psyker_spread_warpfire_on_kill
				local has_special_rule = talent_extension:has_special_rule(spread_warpfire_on_kill)

				if has_special_rule then
					local broadphase_system = Managers.state.extension:system("broadphase_system")
					local broadphase = broadphase_system.broadphase
					local side_system = Managers.state.extension:system("side_system")
					local side = side_system.side_by_unit[owner_unit]
					local enemy_side_names = side:relation_side_names("enemy")
					local victim_unit = template_context.unit
					local position = POSITION_LOOKUP[victim_unit]
					local distance = 5
					local num_results = broadphase.query(broadphase, position, distance, _warpfire_broadphase_results, enemy_side_names)

					if num_results > 0 then
						local i = 1
						local num_invalid_targets = 0

						while stacks_to_share > 0 do
							local target_unit = _warpfire_broadphase_results[i]
							local valid_target = false

							if HEALTH_ALIVE[target_unit] then
								local enemy_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
								local enemy_breed = enemy_unit_data_extension:breed()

								if not enemy_breed.tags.witch then
									valid_target = true
								else
									local blackboard = BLACKBOARDS[target_unit]
									local perception_component = blackboard.perception

									if perception_component.aggro_state == "aggroed" then
										valid_target = true
									end
								end

								if valid_target then
									local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

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

							i = i == num_results and 1 or i + 1
						end
					end
				end
			end
		end
	end,
	minion_effects = minion_burning_buff_effects.warpfire,
}
templates.bleed = {
	class_name = "interval_buff",
	duration = 1.5,
	interval = 0.5,
	interval_stack_removal = true,
	max_stacks = 16,
	max_stacks_cap = 16,
	predicted = false,
	refresh_duration_on_stack = true,
	keywords = {
		buff_keywords.bleeding,
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

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.bleeding, "attack_type", attack_types.buff, "attacking_unit", owner_unit, "item", source_item)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_bleeding",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.increase_damage_taken = {
	class_name = "buff",
	duration = 5,
	max_stacks = 8,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.damage_taken_modifier] = 0.1,
	},
}
templates.increase_impact_received_while_staggered = {
	class_name = "buff",
	duration = 5,
	max_stacks = 8,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.impact_modifier] = 0.1,
	},
}
templates.increase_damage_received_while_staggered = {
	class_name = "buff",
	duration = 5,
	max_stacks = 8,
	predicted = false,
	refresh_duration_on_stack = true,
	conditional_stat_buffs = {
		[buff_stat_buffs.damage_vs_staggered] = 0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit

		return MinionState.is_staggered(unit)
	end,
}
templates.increase_damage_received_while_electrocuted = {
	class_name = "buff",
	duration = 5,
	max_stacks = 8,
	predicted = false,
	refresh_duration_on_stack = true,
	conditional_stat_buffs = {
		[buff_stat_buffs.damage_vs_electrocuted] = 0.05,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit

		return MinionState.is_electrocuted(unit)
	end,
}
templates.rending_debuff = {
	class_name = "buff",
	duration = 5,
	max_stacks = 16,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.rending_multiplier] = 0.025,
	},
}
templates.rending_debuff_medium = {
	class_name = "buff",
	duration = 5,
	max_stacks = 2,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.rending_multiplier] = 0.1,
	},
}
templates.rending_burn_debuff = {
	class_name = "buff",
	duration = 5,
	max_stacks = 20,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.rending_multiplier] = 0.01,
	},
}
templates.shock_grenade_interval = {
	buff_id = "shock_grenade_shock",
	class_name = "interval_buff",
	duration = 8,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
		buff_keywords.shock_grenade_shock,
	},
	interval = {
		0.3,
		0.8,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
		local breed = unit_data and unit_data:breed()
		local is_poxwalker_bomber = breed and breed.tags and breed.name == "chaos_poxwalker_bomber"

		template_data.is_poxwalker_bomber = is_poxwalker_bomber
	end,
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit
		local is_staggered_poxwalker_bomber = template_data.is_poxwalker_bomber and MinionState.is_staggered(unit)

		if HEALTH_ALIVE[unit] and not is_staggered_poxwalker_bomber then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = false,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_stummed",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.shock_mine_interval = {
	class_name = "interval_buff",
	duration = 3,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
		local breed = unit_data and unit_data:breed()
		local is_poxwalker_bomber = breed and breed.tags and breed.name == "chaos_poxwalker_bomber"

		template_data.is_poxwalker_bomber = is_poxwalker_bomber
		template_data.start_time = FixedFrame.get_latest_fixed_time()

		local owner_unit = template_context.owner_unit

		template_data.player_applying_buff = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)
	end,
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit
		local is_staggered_poxwalker_bomber = template_data.is_poxwalker_bomber and MinionState.is_staggered(unit)

		if HEALTH_ALIVE[unit] and not is_staggered_poxwalker_bomber then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	stop_func = function (template_data, template_context)
		local player_applying_buff = template_data.player_applying_buff

		if not template_context.is_server or not player_applying_buff then
			return
		end

		local stop_time = FixedFrame.get_latest_fixed_time()
		local rounded_time_shocked = math.round(stop_time - template_data.start_time)

		Managers.stats:record_private("hook_adamant_time_enemy_electrocuted_by_shockmine", player_applying_buff, rounded_time_shocked)
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = false,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_stummed",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.ogryn_slabshield_shield_plant = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	conditional_stat_buffs = {
		[buff_stat_buffs.block_cost_multiplier] = 0.15,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local slot_name = template_context.item_slot_name
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:read_component(slot_name)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.inventory_slot_component.special_active
	end,
}
templates.shockmaul_stun_interval = {
	class_name = "interval_buff",
	duration = 8,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.shockmaul_stun_interval_damage
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = false,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_stummed",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.power_maul_shock_hit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
			return false
		end

		local damage_efficiency = params.damage_efficiency
		local stagger_result = params.stagger_result

		return stagger_result == stagger_results.stagger and damage_efficiency == damage_efficiencies.full
	end,
	proc_func = function (params, template_data, template_context, t)
		if template_context.is_server then
			local attacked_unit = params.attacked_unit
			local stick_to_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if stick_to_buff_extension then
				stick_to_buff_extension:add_internally_controlled_buff("shock_effect", t)
			end
		end
	end,
}
templates.power_maul_p2_special_hit_primer = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_weapon_special_activate] = 1,
		[buff_proc_events.on_weapon_special_deactivate] = 1,
		[buff_proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		[buff_proc_events.on_hit] = CheckProcFunctions.on_melee_hit,
	},
	specific_proc_func = {
		[buff_proc_events.on_weapon_special_activate] = function (params, template_data, template_context)
			template_data.active = true
		end,
		[buff_proc_events.on_weapon_special_deactivate] = function (params, template_data, template_context)
			template_data.active = false
		end,
		[buff_proc_events.on_hit] = function (params, template_data, template_context)
			if not template_data.active then
				return
			end

			if not template_context.is_server then
				return
			end

			local target_unit = params.attacked_unit

			if HEALTH_ALIVE[target_unit] then
				local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

				if buff_extension then
					local target_is_electrocuted = buff_extension:has_keyword(buff_keywords.electrocuted)

					if target_is_electrocuted then
						local t = FixedFrame.get_latest_fixed_time()

						buff_extension:add_internally_controlled_buff("power_maul_p2_activated_stun_extra", t, "owner_unit", template_context.owner_unit)
					else
						local t = FixedFrame.get_latest_fixed_time()

						buff_extension:add_internally_controlled_buff("power_maul_p2_activated_stun_basic", t, "owner_unit", template_context.owner_unit)
					end
				end
			end
		end,
	},
}
templates.power_maul_p2_activated_stun_extra = {
	buff_id = "power_maul_p2_activated_stun_extra",
	class_name = "interval_buff",
	duration = 3.5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if ALIVE[unit] and HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.powermaul_p2_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_chainlightning",
					stop_type = "stop",
				},
				sfx = {
					looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit",
					looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
				},
			},
		},
	},
}
templates.power_maul_p2_activated_stun_basic = {
	buff_id = "power_maul_p2_activated_stun_basic",
	class_name = "interval_buff",
	duration = 0.1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	interval = {
		0.3,
		0.8,
	},
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if ALIVE[unit] and HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.powermaul_p2_stun_interval_basic
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
}
templates.power_maul_sticky_tick = table.clone(templates.shockmaul_stun_interval)
templates.power_maul_sticky_tick.duration = 0.7
templates.power_maul_sticky_tick.max_stacks = 5
templates.power_maul_sticky_tick.max_stacks_cap = 5
templates.power_maul_sticky_tick.duration_per_stack = true
templates.power_maul_sticky_tick.minion_effects = {
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				material_emission = true,
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/buff_chainlightning",
				stop_type = "stop",
			},
			sfx = {
				looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit",
				looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
			},
		},
	},
}
templates.ogryn_pick_axe_weapon_special_debuff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "increase_damage_taken",
		max_stacks = 1,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_weapon_special_hit),
	start_func = BuffUtils.add_debuff_on_hit_start,
	proc_func = BuffUtils.add_debuff_on_hit_proc,
}
templates.power_maul_stun = {
	buff_id = "power_maul_stun",
	class_name = "interval_buff",
	duration = 3,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if ALIVE[unit] and HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)

			local buff_extension = template_context.buff_extension

			if buff_extension then
				buff_extension:add_internally_controlled_buff("shock_effect", t)
			end
		end
	end,
}
templates.shotgun_special_stun = {
	class_name = "interval_buff",
	duration = 3,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
		local breed = unit_data and unit_data:breed()
		local is_poxwalker_bomber = breed and breed.tags and breed.name == "chaos_poxwalker_bomber"

		template_data.is_poxwalker_bomber = is_poxwalker_bomber
	end,
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit
		local is_staggered_poxwalker_bomber = template_data.is_poxwalker_bomber and MinionState.is_staggered(unit)

		if ALIVE[unit] and HEALTH_ALIVE[unit] and not is_staggered_poxwalker_bomber then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local stack_multiplier = template_context.stack_count / template.max_stacks
			local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
			local power_level = smoothstep_multiplier * 500
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)

			local buff_extension = template_context.buff_extension

			if buff_extension then
				buff_extension:add_internally_controlled_buff("shock_effect", t)
			end
		end
	end,
}
templates.shotgun_special_rending_debuff = {
	class_name = "buff",
	duration = 8,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.rending_multiplier] = 0.25,
	},
}

local function _chain_lightning_start_func(template_data, template_context)
	local is_server = template_context.is_server

	if not is_server then
		return
	end

	local unit = template_context.unit
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	template_data.buff_extension = buff_extension

	if template_context.template.use_hit_mass_based_timing then
		local owner_unit = template_context.owner_unit
		local target_hit_mass = HitMass.target_hit_mass(owner_unit, unit, false, false)
		local template = template_context.template
		local hit_mass_cost = template.hit_mass_cost or 0.2
		local attack_start_time = math.clamp((target_hit_mass - 1) * hit_mass_cost, 0, 2)

		template_data.attack_start_time = attack_start_time
	end

	local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
	local breed = unit_data and unit_data:breed()
	local is_poxwalker_bomber = breed and breed.tags and breed.name == "chaos_poxwalker_bomber"

	template_data.is_poxwalker_bomber = is_poxwalker_bomber
end

local function _chain_lightning_interval_func(template_data, template_context, template, time_since_start, t, dt)
	local is_server = template_context.is_server

	if not is_server then
		return
	end

	local unit = template_context.unit
	local attack_start_time = template_data.attack_start_time or 0
	local time_since_start_attack = time_since_start - attack_start_time
	local is_attack_time = time_since_start_attack >= 0
	local is_stagered = MinionState.is_staggered(unit)
	local is_staggered_poxwalker_bomber = is_stagered and template_data.is_poxwalker_bomber
	local can_attack = is_attack_time and not is_staggered_poxwalker_bomber

	if HEALTH_ALIVE[unit] and can_attack then
		local damage_template = template.interval_attack_damage_profile
		local owner_unit = template_context.owner_unit
		local attack_direction
		local target_position = POSITION_LOOKUP[unit]
		local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

		if owner_position and target_position then
			attack_direction = Vector3.normalize(target_position - owner_position)
		end

		local charge_level
		local max_charge_at_time = template.max_charge_at_time

		if max_charge_at_time then
			charge_level = math.clamp01(time_since_start_attack / max_charge_at_time)
		end

		local damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot = ChainLightning.execute_attack(unit, owner_unit, CHAIN_LIGHTNING_POWER_LEVEL, charge_level, 1, 1, attack_direction, damage_template, damage_types.electrocution, false, template_context.source_item)

		if template_data.is_poxwalker_bomber and template.trigger_poxwalker_bomber and stagger_result == "stagger" then
			local target_blackboard = BLACKBOARDS[unit]
			local death_component = target_blackboard and Blackboard.write_component(target_blackboard, "death")

			if target_blackboard and death_component.fuse_timer == 0 then
				death_component.fuse_timer = t + 1
			end
		end
	end

	local buff_extension = template_data.buff_extension

	if buff_extension then
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(template.shock_effect_buff_template, t)
	end
end

templates.chain_lightning_interval = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	shock_effect_buff_template = "shock_effect",
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.1,
		0.3,
	},
	interval_attack_damage_profile = DamageProfileTemplates.default_chain_lighting_interval,
	start_func = _chain_lightning_start_func,
	interval_func = _chain_lightning_interval_func,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution,
	},
}
templates.psyker_protectorate_spread_chain_lightning_interval = {
	class_name = "interval_buff",
	hit_mass_cost = 0.1,
	max_charge_at_time = 5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	shock_effect_buff_template = "shock_effect",
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	trigger_poxwalker_bomber = true,
	use_hit_mass_based_timing = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.1,
		0.3,
	},
	interval_attack_damage_profile = DamageProfileTemplates.psyker_protectorate_spread_chain_lightning_interval,
	start_func = _chain_lightning_start_func,
	interval_func = _chain_lightning_interval_func,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution,
	},
}
templates.psyker_protectorate_spread_chain_lightning_interval_improved = table.clone(templates.psyker_protectorate_spread_chain_lightning_interval)
templates.psyker_protectorate_spread_chain_lightning_interval_improved.stat_buffs = {
	[buff_stat_buffs.damage_taken_multiplier] = 1.1,
}
templates.psyker_protectorate_spread_charged_chain_lightning_interval = table.clone(templates.psyker_protectorate_spread_chain_lightning_interval)
templates.psyker_protectorate_spread_charged_chain_lightning_interval.hit_mass_cost = 0.05
templates.psyker_protectorate_spread_charged_chain_lightning_interval.max_charge_at_time = 2
templates.psyker_protectorate_spread_charged_chain_lightning_interval_improved = table.clone(templates.psyker_protectorate_spread_charged_chain_lightning_interval)
templates.psyker_protectorate_spread_charged_chain_lightning_interval_improved.stat_buffs = {
	[buff_stat_buffs.damage_taken_multiplier] = 1.1,
}
templates.psyker_protectorate_spread_chain_lightning_interval_temporary = table.clone(templates.psyker_protectorate_spread_chain_lightning_interval)
templates.psyker_protectorate_spread_chain_lightning_interval_temporary.duration = 2
templates.psyker_protectorate_spread_chain_lightning_interval_temporary_improved = table.clone(templates.psyker_protectorate_spread_charged_chain_lightning_interval_improved)
templates.psyker_protectorate_spread_chain_lightning_interval_temporary_improved.duration = 2
templates.psyker_heavy_swings_shock = table.clone(templates.psyker_protectorate_spread_chain_lightning_interval_temporary)
templates.psyker_heavy_swings_shock.interval_attack_damage_profile = DamageProfileTemplates.psyker_heavy_swings_shock
templates.psyker_heavy_swings_shock_improved = table.clone(templates.psyker_protectorate_spread_chain_lightning_interval_temporary_improved)
templates.psyker_heavy_swings_shock_improved.interval_attack_damage_profile = DamageProfileTemplates.psyker_heavy_swings_shock
templates.adamant_whistle_electrocution = table.clone(templates.psyker_protectorate_spread_chain_lightning_interval_temporary_improved)
templates.adamant_whistle_electrocution.interval_attack_damage_profile = DamageProfileTemplates.psyker_heavy_swings_shock
templates.shock_effect = {
	class_name = "buff",
	duration = 2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	keywords = {
		buff_keywords.electrocuted,
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_chainlightning",
					stop_type = "stop",
				},
				sfx = {
					looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit",
					looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
				},
			},
		},
	},
}
templates.taunted = {
	buff_id = "taunted",
	class_name = "buff",
	duration = 15,
	predicted = false,
	unique_buff_id = "taunted",
	keywords = {
		buff_keywords.taunted,
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_taunted_1p",
					stop_type = "destroy",
				},
			},
		},
		material_vector = {
			name = "stimmed_color",
			value = {
				0.075,
				0.005,
				0,
			},
		},
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
	end,
}
templates.taunted_short = table.clone(templates.taunted)
templates.taunted_short.duration = 8
templates.in_smoke_fog = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_dodge_buff_hud",
	hud_priority = 1,
	is_negative = false,
	max_stacks = 1,
	predicted = false,
	keywords = {
		buff_keywords.concealed,
		buff_keywords.hud_nameplates_disabled,
	},
}
templates.left_smoke_fog = {
	class_name = "buff",
	duration = 0.5,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_dodge_buff_hud",
	hud_priority = 1,
	is_negative = false,
	max_stacks = 1,
	predicted = false,
	target = buff_targets.player_only,
	keywords = {
		buff_keywords.concealed,
		buff_keywords.hud_nameplates_disabled,
	},
}
templates.shotgun_p1_m2_special_shell_reduced_spread = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	conditional_stat_buffs = {
		[buff_stat_buffs.spread_modifier] = -0.75,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local slot_name = template_context.item_slot_name
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:read_component(slot_name)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.inventory_slot_component.special_active
	end,
}
templates.suppression_immune_while_wielded = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		buff_keywords.suppression_immune,
	},
	conditional_keywords_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.suppression_immune_while_blocking = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		buff_keywords.suppression_immune,
	},
	conditional_keywords_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_blocking),
}

return templates
