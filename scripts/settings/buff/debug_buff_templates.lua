local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local buff_keywords = BuffSettings.keywords
local buff_targets = BuffSettings.targets
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local templates = {
	debug_movement_speed_on_kill = {
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.movement_speed] = 2
		},
		check_proc_func = function (params, template_data, template_context)
			local result = params.attack_result

			return result == attack_results.died
		end
	},
	weapon_trait_lasgun_tier_1 = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15,
			[buff_stat_buffs.sway_modifier] = 0.7
		}
	},
	weapon_trait_lasgun_tier_2 = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15,
			[buff_stat_buffs.sway_modifier] = 0.7,
			[buff_stat_buffs.recoil_modifier] = -0.33
		}
	},
	weapon_trait_lasgun_tier_3 = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15,
			[buff_stat_buffs.sway_modifier] = 0.7,
			[buff_stat_buffs.recoil_modifier] = -0.33,
			[buff_stat_buffs.ranged_weakspot_damage] = 0.5
		}
	},
	weapon_trait_lasgun_tier_4 = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15,
			[buff_stat_buffs.sway_modifier] = 0.7,
			[buff_stat_buffs.recoil_modifier] = -0.33,
			[buff_stat_buffs.ranged_weakspot_damage] = 0.5
		}
	},
	weapon_trait_lasgun_ranged_weakspot_damage = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.ranged_weakspot_damage] = 0.5
		}
	},
	weapon_trait_lasgun_spread_and_sway_reduction = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15,
			[buff_stat_buffs.sway_modifier] = 0.7
		}
	},
	weapon_trait_lasgun_recoil_reduction = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.recoil_modifier] = -0.33
		}
	},
	weapon_trait_lasgun_alternate_fire_movement_speed = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.1
		}
	},
	weapon_gestalt_trait_reload_on_kill = {
		class_name = "proc_buff",
		active_duration = 0,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_func = function (params)
			local attacking_unit = params.attacking_unit
			local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local wielded_slot_name = inventory_component.wielded_slot
			local inventory_slot_component = unit_data_extension:write_component(wielded_slot_name)

			Ammo.transfer_from_reserve_to_clip(inventory_slot_component, 1)
		end,
		check_proc_func = function (params, template_data, template_context)
			local result = params.attack_result

			if result ~= attack_results.died then
				return false
			end

			local attacking_unit = params.attacking_unit
			local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local wielded_slot_name = inventory_component.wielded_slot
			local inventory_slot_component = unit_data_extension:write_component(wielded_slot_name)

			if not ReloadStates.uses_reload_states(inventory_slot_component) then
				return false
			end

			local ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip

			if ammo_in_reserve < 1 or max_ammo_in_clip <= current_ammunition_clip then
				return false
			end

			return true
		end
	},
	weapon_gestalt_trait_ranged_weakspot_damage_increase_on_stagger = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.ranged_weakspot_damage_vs_staggered] = 0.5
		}
	},
	debug_burninating_burning = {
		interval = 0.75,
		refresh_duration_on_stack = true,
		max_stacks = 5,
		duration = 5,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
		},
		target = buff_targets.minion_only,
		on_reached_max_stack_func = function (template_data, template_context)
			template_data.has_reached_max_stacks = true
		end,
		interval_func = function (template_data, template_context)
			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local stack_count = template_context.stack_count
				local base_power_level = 100
				local extra_stack_power_level = base_power_level * (stack_count - 1)
				local extra_reached_max_stacks_power_level = template_data.has_reached_max_stacks and 500 or 0
				local power_level = base_power_level + extra_stack_power_level + extra_reached_max_stacks_power_level
				local damage_template = DamageProfileTemplates.grenadier_liquid_fire_burning

				Attack.execute(unit, damage_template, "power_level", power_level)
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
	debug_ignite_on_hit = {
		unique_buff_id = "debug_ignite_on_hit",
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_func = function (params, template_data, template_context)
			local attacked_unit = params.attacked_unit

			if ALIVE[attacked_unit] then
				local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

				if attacked_unit_buff_extension then
					local t = FixedFrame.get_latest_fixed_time()
					local buff_to_add = "debug_burninating_burning"

					attacked_unit_buff_extension:add_internally_controlled_buff(buff_to_add, t)
				end
			end
		end
	},
	debug_power_buff = {
		predicted = false,
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.1
		}
	}
}

return templates
