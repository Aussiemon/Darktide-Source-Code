local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local special_rules = SpecialRulesSetting.special_rules
local templates = {
	zealot_damage_after_dash = {
		class_name = "proc_buff",
		active_duration = 4,
		proc_events = {
			[proc_events.on_lunge_end] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.melee_damage] = 1
		},
		check_proc_func = function (params, template_data, template_context)
			local lunge_template_name = params.lunge_template_name

			if lunge_template_name == "zealot_dash" then
				return true
			end

			return false
		end
	},
	zealot_channel_damage = {
		duration = 10,
		max_stacks = 5,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		refresh_duration_on_stack = true,
		predicted = false,
		hud_priority = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage] = 0.03
		}
	},
	zealot_channel_toughness_damage_reduction = {
		duration = 10,
		max_stacks = 5,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_heal_over_time_buff_hud",
		refresh_duration_on_stack = true,
		predicted = false,
		hud_priority = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.toughness_damage_taken_multiplier] = 0.95
		}
	},
	zealot_quickness_passive = {
		hud_always_show_stacks = true,
		predicted = false,
		hud_priority = 1,
		use_specialization_resource = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		max_stacks = 1,
		class_name = "proc_buff",
		always_show_in_hud = true,
		proc_events = {
			[proc_events.on_successful_dodge] = 1,
			[proc_events.on_hit] = 1
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
			local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
			template_data.dodge_stacks = specialization_extension:has_special_rule(special_rules.zealot_quickness_dodge_stacks)
			template_data.toughness_per_stack = specialization_extension:has_special_rule(special_rules.zealot_quickness_toughness_per_stack)
			template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
			template_data.specialization_resource_component.max_resource = 15
			template_data.specialization_resource_component.current_resource = 1
			template_data.locomotion_component = unit_data_extension:read_component("locomotion")
			template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
			template_data.movement_counter = 0
			template_data.cooldown = 0
		end,
		update_func = function (template_data, template_context, dt, t)
			if template_data.movement_counter > 5 then
				template_data.movement_counter = template_data.movement_counter - 5
				local current_resource = template_data.specialization_resource_component.current_resource
				template_data.specialization_resource_component.current_resource = math.min(current_resource + 1, 15)
			end

			local player_velocity = template_data.locomotion_component.velocity_current
			local is_moving = Vector3.length(player_velocity) > 0

			if not is_moving then
				return
			end

			local movement_value = Vector3.length(player_velocity) * dt
			local is_sprinting = Sprint.is_sprinting(template_data.sprint_character_state_component)

			if is_sprinting then
				movement_value = movement_value * 2
			end

			template_data.movement_counter = template_data.movement_counter + movement_value
		end,
		specific_proc_func = {
			on_hit = function (params, template_data, template_context, t)
				if t < template_data.cooldown then
					return
				end

				local current_resource = template_data.specialization_resource_component.current_resource

				template_data.buff_extension:add_internally_controlled_buff_with_stacks("zealot_quickness_active", current_resource, t)

				if template_data.toughness_per_stack then
					Toughness.replenish_percentage(template_context.unit, current_resource * 0.02, nil, "zealot_quickness_passive")
				end

				template_data.cooldown = t + 8
				template_data.specialization_resource_component.current_resource = 1
			end,
			on_successful_dodge = function (params, template_data, template_context, t)
				if template_data.dodge_stacks then
					local current_resource = template_data.specialization_resource_component.current_resource
					template_data.specialization_resource_component.current_resource = math.min(current_resource + 3, 15)
				end
			end
		}
	},
	zealot_quickness_active = {
		max_stacks = 15,
		max_stacks_cap = 15,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		duration = 8,
		predicted = false,
		hud_priority = 4,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.melee_attack_speed] = 0.01,
			[stat_buffs.ranged_attack_speed] = 0.01
		}
	},
	zealot_improved_weapon_handling_after_dodge = {
		predicted = false,
		hud_priority = 4,
		allow_proc_while_active = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		max_stacks = 1,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[proc_events.on_successful_dodge] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.spread_modifier] = -0.75,
			[stat_buffs.recoil_modifier] = -0.5
		}
	},
	zealot_improved_weapon_swapping_no_ammo = {
		max_stacks = 1,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		predicted = false,
		hud_priority = 4,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_ammo_consumed] = 1
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.wieldable_component = unit_data_extension:read_component("slot_secondary")
			template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		end,
		proc_func = function (params, template_data, template_context, t)
			local current_ammo = template_data.wieldable_component.current_ammunition_clip

			if current_ammo == 0 then
				template_data.buff_extension:add_internally_controlled_buff("zealot_improved_weapon_swapping_impact", t)
			end
		end
	},
	zealot_improved_weapon_swapping_impact = {
		max_stacks = 1,
		refresh_duration_on_stack = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		duration = 5,
		predicted = false,
		hud_priority = 4,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.melee_impact_modifier] = 0.3,
			[stat_buffs.melee_attack_speed] = 0.1
		}
	},
	zealot_improved_weapon_swapping_melee_kills_reload_speed = {
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_kill] = 1
		},
		check_proc_func = CheckProcFunctions.on_melee_kill,
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		end,
		proc_func = function (params, template_data, template_context, t)
			template_data.buff_extension:add_internally_controlled_buff("zealot_improved_weapon_swapping_reload_speed_buff", t)
		end
	},
	zealot_improved_weapon_swapping_reload_speed_buff = {
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		predicted = false,
		hud_priority = 4,
		hud_always_show_stacks = true,
		max_stacks = 10,
		class_name = "proc_buff",
		always_show_in_hud = true,
		proc_events = {
			[proc_events.on_reload] = 1
		},
		stat_buffs = {
			[stat_buffs.reload_speed] = 0.03
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		end,
		proc_func = function (params, template_data, template_context, t)
			if params.shotgun then
				local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

				buff_extension:add_internally_controlled_buff_with_stacks("zealot_improved_weapon_swapping_reload_speed_buff_shotgun", template_context.stack_count, t)
			end

			template_data.done = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.done
		end
	},
	zealot_improved_weapon_swapping_reload_speed_buff_shotgun = {
		max_stacks = 10,
		duration = 4,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		predicted = false,
		hud_priority = 4,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.reload_speed] = 0.03
		}
	},
	zealot_leaving_stealth_restores_toughness = {
		predicted = false,
		hud_priority = 4,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
		max_stacks = 1,
		duration = 5,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.8
		},
		start_func = function (template_data, template_context)
			if not template_context.is_server then
				return
			end

			local total_toughness_restored = 0.4
			local duration = template_context.template.duration
			local toughness_per_second = total_toughness_restored / duration
			template_data.toughness_left = total_toughness_restored
			template_data.toughness_per_second = toughness_per_second
		end,
		update_func = function (template_data, template_context, dt, t)
			if not template_context.is_server then
				return
			end

			local toughness_left = template_data.toughness_left
			local toughness_per_second = template_data.toughness_per_second
			local toughness_to_restore = math.min(toughness_left, dt * toughness_per_second)
			toughness_left = toughness_left - toughness_to_restore

			Toughness.replenish_percentage(template_context.unit, toughness_to_restore)

			template_data.toughness_left = toughness_left
		end,
		stop_func = function (template_data, template_context)
			if not template_context.is_server then
				return
			end

			local toughness_left = template_data.toughness_left

			if toughness_left > 0 then
				Toughness.replenish_percentage(template_context.unit, toughness_left)
			end
		end
	},
	zealot_toughness_on_heavy_kills = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[proc_events.on_kill] = 1
		},
		check_proc_func = CheckProcFunctions.on_heavy_hit,
		proc_func = function (params, template_data, template_context)
			Toughness.replenish_percentage(template_context.unit, 0.075, false, "zealot_heavy_kill")
		end
	}
}

return templates
