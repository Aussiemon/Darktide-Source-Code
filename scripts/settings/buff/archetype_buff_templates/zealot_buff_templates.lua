local Action = require("scripts/utilities/weapon/action")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local CoherencyUtils = require("scripts/extension_systems/coherency/coherency_utils")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PushAttack = require("scripts/utilities/attack/push_attack")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local special_rules = SpecialRulesSetting.special_rules
local talent_settings_2 = TalentSettings.zealot_2
local talent_settings_3 = TalentSettings.zealot_3

local function _shroudfield_penance_start(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_shroudfield_start", player)
end

local function _shroudfield_penance_stop(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_shroudfield_stop", player)
end

local templates = {}

table.make_unique(templates)

templates.zealot_damage_after_dash = {
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
}
templates.zealot_channel_damage = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_channel_grants_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	duration = 10,
	class_name = "buff",
	buff_category = buff_categories.talents_secondary,
	stat_buffs = {
		[stat_buffs.damage] = 0.2
	}
}
templates.zealot_channel_toughness_damage_reduction = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_channel_grants_toughness_damage_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	duration = 10,
	class_name = "buff",
	buff_category = buff_categories.talents_secondary,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 0.7
	},
	player_effects = {
		effect_template = EffectTemplates.zealot_relic_blessed
	}
}
templates.zealot_channel_toughness_bonus = {
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_bolstering_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 5,
	duration = 10,
	class_name = "buff",
	buff_category = buff_categories.talents_secondary,
	stat_buffs = {
		[stat_buffs.toughness_bonus_flat] = 20
	}
}
templates.bolstering_prayer_resist_death = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	duration = 1.5,
	class_name = "buff",
	keywords = {
		keywords.resist_death,
		keywords.stun_immune
	}
}
local quickness_max_stacks = talent_settings_3.quickness.max_stacks
local quickness_toughness_percentage = talent_settings_3.quickness.toughness_percentage
local quickness_successful_dodge_stacks = talent_settings_3.quickness.dodge_stacks
templates.zealot_quickness_passive = {
	child_buff_template = "zealot_quickness_counter",
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_quickness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "parent_proc_buff",
	always_show_in_hud = true,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_successful_dodge] = 1
	},
	add_child_proc_events = {
		[proc_events.on_successful_dodge] = quickness_successful_dodge_stacks
	},
	remove_child_proc_events = {
		[proc_events.on_hit] = quickness_max_stacks
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.dodge_stacks = talent_extension:has_special_rule(special_rules.zealot_quickness_dodge_stacks)
		template_data.toughness_per_stack = talent_extension:has_special_rule(special_rules.zealot_quickness_toughness_per_stack)
		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.movement_counter = 0
		template_data.cooldown = 0
		template_data.achievement_target = 15
		template_data.achievement_target_reached = false
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			local attack_type = params.attack_type
			local is_melee = attack_type == attack_types.melee
			local is_ranged = attack_type == attack_types.ranged

			if not is_melee and not is_ranged then
				return false
			end

			local buff_extension = template_context.buff_extension
			local is_active_buff_active = buff_extension:has_buff_using_buff_template("zealot_quickness_active")

			return not is_active_buff_active
		end,
		[proc_events.on_successful_dodge] = function (params, template_data, template_context)
			return template_data.dodge_stacks
		end
	},
	restore_child_update = function (template_data, template_context, dt, t)
		local player_velocity = template_data.locomotion_component.velocity_current
		local is_moving = Vector3.length(player_velocity) > 0

		if template_data.achievement_target_reached and template_data.cooldown <= t + 1 then
			Managers.stats:record_private("hook_zealot_movement_keystone_stop", template_context.player)

			template_data.achievement_target_reached = false
		end

		if not is_moving then
			return 0
		end

		local movement_value = Vector3.length(player_velocity) * dt
		local is_sprinting = Sprint.is_sprinting(template_data.sprint_character_state_component)

		if is_sprinting then
			movement_value = movement_value * 2
		end

		local movement_chunk = 5
		local movement_counter = template_data.movement_counter + movement_value
		local number_of_stacks_to_restore = math.floor(movement_counter / movement_chunk)
		movement_counter = movement_counter - number_of_stacks_to_restore * movement_chunk
		template_data.movement_counter = movement_counter

		return number_of_stacks_to_restore
	end,
	on_stacks_removed_func = function (num_child_stacks, num_child_stacks_removed, t, template_data, template_context)
		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff_with_stacks("zealot_quickness_active", num_child_stacks_removed, t)

		if template_data.toughness_per_stack then
			Toughness.replenish_percentage(template_context.unit, num_child_stacks_removed * quickness_toughness_percentage, nil, "zealot_quickness_passive")
		end

		template_data.cooldown = t + 8

		if not template_data.achievement_target_reached and template_data.achievement_target <= num_child_stacks_removed then
			Managers.stats:record_private("hook_zealot_movement_keystone_start", template_context.player, num_child_stacks_removed, template_data.achievement_target)

			template_data.achievement_target_reached = true
		end
	end
}
templates.zealot_quickness_counter = {
	predicted = false,
	refresh_start_time_on_stack = true,
	stack_offset = -1,
	class_name = "buff",
	max_stacks = quickness_max_stacks,
	max_stacks_cap = quickness_max_stacks
}
templates.zealot_quickness_active = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_quickness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	duration = 6,
	class_name = "buff",
	max_stacks = quickness_max_stacks,
	max_stacks_cap = quickness_max_stacks,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = 0.01,
		[stat_buffs.ranged_attack_speed] = 0.01,
		[stat_buffs.damage] = 0.01,
		[stat_buffs.dodge_speed_multiplier] = 1.005,
		[stat_buffs.dodge_distance_modifier] = 0.005,
		[stat_buffs.dodge_cooldown_reset_modifier] = 0.01
	}
}
templates.zealot_improved_weapon_handling_after_dodge = {
	predicted = false,
	hud_priority = 3,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_weapon_handling_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
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
}
templates.zealot_improved_weapon_swapping_no_ammo = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_melee_after_no_ammo",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
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
}
templates.zealot_improved_weapon_swapping_impact = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_melee_after_no_ammo",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	duration = 5,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.3,
		[stat_buffs.melee_attack_speed] = 0.1
	}
}
templates.zealot_improved_weapon_swapping_melee_kills_reload_speed = {
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
}
templates.zealot_improved_weapon_swapping_reload_speed_buff = {
	hud_always_show_stacks = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_increased_reload_speed_on_melee_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
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
		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local inventory_component = template_data.inventory_component
		local visual_loadout_extension = template_data.visual_loadout_extension
		local wielded_slot_id = inventory_component.wielded_slot
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)
		local _, current_action = Action.current_action(template_data.weapon_action_component, weapon_template)
		local action_kind = current_action and current_action.kind
		local is_reloading = action_kind and (action_kind == "reload_shotgun" or action_kind == "reload_state" or action_kind == "ranged_load_special")

		return template_data.done and not is_reloading
	end
}
templates.zealot_leaving_stealth_restores_toughness = {
	predicted = false,
	total_toughness_restored = 0.4,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_leaving_stealth_restores_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
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

		local template = template_context.template
		local total_toughness_restored = template.total_toughness_restored
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
}
templates.zealot_toughness_on_heavy_kills = {
	predicted = false,
	toughness_percentage = 0.075,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		local template = template_context.template

		Toughness.replenish_percentage(template_context.unit, template.toughness_percentage, false, "zealot_heavy_kill")
	end
}
templates.zealot_toughness_on_ranged_kill = {
	predicted = false,
	toughness_percentage = 0.025,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context)
		local template = template_context.template

		Toughness.replenish_percentage(template_context.unit, template.toughness_percentage, false, "zealot_ranged_kill")
	end
}
templates.zealot_toughness_on_dodge = {
	cooldown_duration = 0.5,
	predicted = false,
	toughness_percentage = 0.15,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_successful_dodge] = 1
	},
	proc_func = function (params, template_data, template_context)
		local toughness_percentage = template_context.template.toughness_percentage

		Toughness.replenish_percentage(template_context.unit, toughness_percentage, false, "zealot_dodge")
	end
}
templates.zealot_improved_stun_grenade = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier_shock] = 0.5
	}
}
templates.zealot_increased_coherency_regen = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_coherency_regen_rate_modifier] = 0.25
	}
}
templates.zealot_preacher_ally_defensive = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_damage_taken] = 1
	},
	cooldown_duration = talent_settings_3.coop_3.cooldown_duration,
	check_proc_func = function (params, template_data, template_context)
		return params.damage_amount > 0
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local buff_extension = ScriptUnit.has_extension(params.attacked_unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("zealot_preacher_ally_defensive_buff", t)
		end
	end
}
templates.zealot_preacher_ally_defensive_buff = {
	predicted = false,
	class_name = "buff",
	buff_category = buff_categories.talents_secondary,
	duration = talent_settings_3.coop_3.duration,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings_3.coop_3.damage_taken_multiplier
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_preacher_defense"
	}
}
local PUSH_SETTINGS = {
	push_radius = talent_settings_3.defensive_1.push_radius,
	inner_push_rad = talent_settings_3.defensive_1.inner_push_rad,
	outer_push_rad = talent_settings_3.defensive_1.outer_push_rad,
	inner_damage_profile = DamageProfileTemplates.push_test,
	inner_damage_type = damage_types.physical,
	outer_damage_profile = DamageProfileTemplates.push_test,
	outer_damage_type = damage_types.physical
}
local PUSH_POWER_LEVEL = talent_settings_3.defensive_1.power_level
templates.zealot_preacher_push_on_hit = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_defensive_knockback",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	class_name = "proc_buff",
	cooldown_duration = talent_settings_3.defensive_1.cooldown_duration,
	proc_events = {
		[proc_events.on_player_hit_received] = 1
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.character_state_component = unit_data_extension:read_component("character_state")
	end,
	check_proc_func = function (params, template_data, template_context)
		local is_melee = params.attack_type == attack_types.melee
		local is_hurting_hit = AttackSettings.is_damaging_result[params.attack_result]
		local has_attacking_unit = not not params.attacking_unit
		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		return is_melee and is_hurting_hit and has_attacking_unit and not is_disabled
	end,
	proc_func = function (params, template_data, template_context)
		local is_server = template_context.is_server

		if is_server then
			local world = template_context.world
			local physics_world = World.physics_world(world)
			local unit = template_context.unit
			local attacking_unit = params.attacking_unit
			local player_position = POSITION_LOOKUP[unit]
			local attacking_position = POSITION_LOOKUP[attacking_unit]
			local push_direction = Vector3.normalize(Vector3.flat(attacking_position - player_position))

			if Vector3.length(push_direction) == 0 then
				push_direction = Vector3.up()
			end

			local is_predicted = false
			local rewind_ms = 0

			PushAttack.push(physics_world, player_position, push_direction, rewind_ms, PUSH_POWER_LEVEL, PUSH_SETTINGS, unit, is_predicted, nil)
		end
	end
}
local martyrdom_max_stacks = talent_settings_2.passive_1.martyrdom_max_stacks

local function _martyrdom_update_func(template_data, template_context, dt, t)
	local health_extension = template_data.health_extension

	if health_extension then
		local max_wounds = health_extension:max_wounds()
		local max_health = health_extension:max_health()
		local damage_taken = health_extension:damage_taken()
		local permanent_damage_taken = health_extension:permanent_damage_taken()
		local current_wounds = Health.calculate_num_segments(math.max(damage_taken, permanent_damage_taken), max_health, max_wounds)
		template_data.max_wounds = max_wounds
		template_data.current_wounds = current_wounds
	end
end

local function _martyrdom_missing_health_segments(template_data)
	local missing_segments = (template_data.max_wounds or 0) - (template_data.current_wounds or 0)

	return math.min(missing_segments, martyrdom_max_stacks)
end

local toughness_reduction_per_stack = talent_settings_2.passive_1.toughness_reduction_per_stack
templates.zealot_martyrdom_toughness = {
	max_stacks = 1,
	predicted = false,
	max_stacks_cap = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = {
			min = 0,
			max = toughness_reduction_per_stack * martyrdom_max_stacks
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.number_of_health_segements_damage_taken = 0
	end,
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		return math.clamp01(missing_segments / martyrdom_max_stacks)
	end
}
templates.zealot_preacher_segment_breaking_half_damage = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	keywords = {
		keywords.health_segment_breaking_reduce_damage_taken
	},
	stat_buffs = {
		[stat_buffs.health_segment_damage_taken_multiplier] = talent_settings_3.defensive_2.health_segment_damage_taken_multiplier
	}
}
local max_dist = talent_settings_3.passive_1.max_dist
local max_dist_sqaured = max_dist * max_dist
local out_of_combat_time = talent_settings_3.passive_1.duration
local buff_removal_interval_time = talent_settings_3.passive_1.buff_removal_time_modifier
local toughness_on_max_stacks = talent_settings_3.passive_1.toughness_on_max_stacks
local toughness_on_max_stacks_small = talent_settings_3.passive_1.toughness_on_max_stacks_small
local _fanatic_rage_add_stack = nil
templates.zealot_fanatic_rage = {
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	predicted = false,
	hud_priority = 1,
	hud_always_show_stacks = true,
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	use_talent_resource = true,
	class_name = "proc_buff",
	always_show_in_hud = true,
	proc_events = {
		[proc_events.on_minion_death] = 1,
		[proc_events.on_hit] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.side_system = Managers.state.extension:system("side_system")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.talent_resource_component = unit_data_extension:write_component("talent_resource")
		template_data.talent_resource_component.max_resource = talent_settings_3.passive_1.max_resource
		template_data.remove_stack_t = nil
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.kills_restore_cooldown = talent_extension:has_special_rule(special_rules.zealot_preacher_fanatic_kills_restore_cooldown)
		template_data.crits_grants_stack = talent_extension:has_special_rule(special_rules.zealot_preacher_crits_grants_stack)
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.toughness_on_max = talent_extension:has_special_rule(special_rules.zealot_fanatic_rage_toughness)
		local side = template_data.side_system.side_by_unit[unit]
		local side_name = side:name()
		template_data.side_name = side_name
	end,
	specific_proc_func = {
		on_minion_death = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local unit = template_context.unit
			local unit_pos = POSITION_LOOKUP[unit]
			local dying_unit_pos = params.position and params.position:unbox() or unit_pos
			local distance_sq = Vector3.distance_squared(unit_pos, dying_unit_pos)

			if max_dist_sqaured < distance_sq then
				return
			end

			if template_data.side_name == params.side_name then
				return
			end

			_fanatic_rage_add_stack(template_data, template_context)
		end,
		on_hit = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			if template_data.kills_restore_cooldown and CheckProcFunctions.on_kill(params) then
				local cooldown_time = talent_settings_3.spec_passive_1.cooldown_time

				template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_time)
			end

			if template_data.crits_grants_stack and CheckProcFunctions.on_crit(params) then
				_fanatic_rage_add_stack(template_data, template_context)
			end
		end
	},
	update_func = function (template_data, template_context, dt, t)
		if template_data.remove_stack_t and template_data.remove_stack_t < t then
			local current_resource = template_data.talent_resource_component.current_resource
			current_resource = math.max(current_resource - 1, 0)
			template_data.talent_resource_component.current_resource = current_resource
			local timer = math.abs(current_resource / 5 - 5) * buff_removal_interval_time

			if current_resource > 0 then
				template_data.remove_stack_t = t + timer
			else
				template_data.remove_stack_t = nil
			end
		end
	end
}

function _fanatic_rage_add_stack(template_data, template_context)
	local current_resource = template_data.talent_resource_component.current_resource
	local max_resource = template_data.talent_resource_component.max_resource
	local t = FixedFrame.get_latest_fixed_time()
	current_resource = math.min(max_resource, current_resource + 1)

	if current_resource == max_resource then
		if template_data.toughness_on_max then
			local buff_extension = template_context.buff_extension
			local rage_buff_active = buff_extension:has_buff_using_buff_template("zealot_fanatic_rage_buff")
			local toughness_amount = rage_buff_active and toughness_on_max_stacks_small or toughness_on_max_stacks

			Toughness.replenish_percentage(template_context.unit, toughness_amount, false, "fanatic_rage")
		end

		Managers.stats:record_private("hook_zealot_fanatic_rage_start", template_context.player)
		template_data.buff_extension:add_internally_controlled_buff("zealot_fanatic_rage_buff", t)
	end

	template_data.talent_resource_component.current_resource = current_resource
	template_data.remove_stack_t = t + out_of_combat_time
end

templates.zealot_fanatic_rage_buff = {
	predicted = false,
	hud_priority = 1,
	refresh_duration_on_stack = true,
	always_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	max_stacks = 1,
	class_name = "buff",
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.passive_1.crit_chance
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.spec_passive_2.crit_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.conditional_stat_buff_active = talent_extension:has_special_rule(special_rules.zealot_preacher_increased_crit_chance)

		if not template_context.is_server then
			return
		end

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.talent_resource_component = unit_data_extension:write_component("talent_resource")
		local spread_fanatic_rage = talent_extension:has_special_rule(special_rules.zealot_preacher_spread_fanatic_rage)

		if spread_fanatic_rage then
			local buff_name = template_data.conditional_stat_buff_active and "zealot_fanatic_rage_major" or "zealot_fanatic_rage_minor"
			local t = FixedFrame.get_latest_fixed_time()

			CoherencyUtils.add_buff_to_all_in_coherency(unit, buff_name, t, true)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		Managers.stats:record_private("hook_zealot_fanatic_rage_stop", template_context.player)

		template_data.talent_resource_component.current_resource = 0
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.conditional_stat_buff_active
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_preacher_rage"
	}
}
templates.zealot_preacher_damage_vs_disgusting = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.zealot_toughness
	},
	stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = talent_settings_3.passive_2.damage_vs_disgusting,
		[stat_buffs.resistant_damage] = talent_settings_3.passive_2.damage_vs_resistant
	}
}
local corruption_heal_amount = talent_settings_3.coherency.corruption_heal_amount
templates.zealot_preacher_coherency_corruption_healing = {
	coherency_id = "zealot_preacher_coherency_corruption_healing",
	predicted = false,
	hud_priority = 5,
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_cleansing_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	class_name = "interval_buff",
	buff_category = buff_categories.aura,
	interval = talent_settings_3.coherency.interval,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	interval_func = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		template_data.health_extension:reduce_permanent_damage(corruption_heal_amount)

		local permanent_damage_taken = template_data.health_extension:permanent_damage_taken()

		if permanent_damage_taken ~= 0 then
			local hook_name = "hook_zealot_corruption_healed_aura"
			local parent_buff_name = "zealot_corruption_healing_coherency"
			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, corruption_heal_amount)
		end
	end
}
local corruption_heal_amount_increased = talent_settings_3.coop_2.corruption_heal_amount_increased
templates.zealot_preacher_coherency_corruption_healing_improved = {
	coherency_id = "zealot_preacher_coherency_corruption_healing",
	predicted = false,
	hud_priority = 5,
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_cleansing_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	class_name = "interval_buff",
	buff_category = buff_categories.aura,
	interval = talent_settings_3.coop_2.interval,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	interval_func = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		template_data.health_extension:reduce_permanent_damage(corruption_heal_amount_increased)

		local permanent_damage_taken = template_data.health_extension:permanent_damage_taken()

		if permanent_damage_taken ~= 0 then
			local hook_name = "hook_zealot_corruption_healed_aura"
			local parent_buff_name = "zealot_corruption_healing_coherency_improved"
			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, corruption_heal_amount_increased)
		end
	end
}
templates.zealot_preacher_reduce_corruption_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = talent_settings_3.passive_3.corruption_taken_multiplier
	}
}
templates.zealot_preacher_impact_power = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings_3.mixed_1.impact_modifier
	}
}
templates.zealot_preacher_more_segments = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = talent_settings_3.mixed_3.extra_max_amount_of_wounds
	}
}
templates.zealot_pious_stabguy_increased_weaskpot_impact = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_weakspot_impact_modifier] = 0.5
	}
}
local ZEALOT_PREACHER_MELEE_INCREASE_NEXT_MELEE_BUFF_ID = "zealot_preacher_melee_increase_next_melee_buff"
templates.zealot_preacher_melee_increase_next_melee_proc = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = 1
	},
	proc_func = function (params, template_data, template_context, t)
		local num_hit_units = math.min(params.num_hit_units, talent_settings_3.offensive_1.max_stacks)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		local has_buff = buff_extension and buff_extension:has_buff_id(ZEALOT_PREACHER_MELEE_INCREASE_NEXT_MELEE_BUFF_ID)

		if buff_extension and num_hit_units > 0 and not has_buff then
			buff_extension:add_internally_controlled_buff_with_stacks("zealot_preacher_melee_increase_next_melee_buff", num_hit_units, t)
		end
	end
}
templates.zealot_preacher_melee_increase_next_melee_buff = {
	predicted = false,
	hud_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_increase_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	always_show_in_hud = true,
	buff_id = ZEALOT_PREACHER_MELEE_INCREASE_NEXT_MELEE_BUFF_ID,
	proc_events = {
		[proc_events.on_sweep_finish] = 1
	},
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_3.offensive_1.melee_damage
	},
	max_stacks = talent_settings_3.offensive_1.max_stacks,
	max_stacks_cap = talent_settings_3.offensive_1.max_stacks,
	proc_func = function (params, template_data, template_context)
		template_data.exit = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.exit
	end
}
local crit_chance_shared = talent_settings_3.offensive_2.crit_share
templates.zealot_fanatic_rage_minor = {
	max_stacks_cap = 1,
	refresh_duration_on_stack = true,
	predicted = true,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	max_stacks = 1,
	class_name = "buff",
	buff_category = buff_categories.talents_secondary,
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.passive_1.crit_chance * crit_chance_shared
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/abilities/squad_leader_ability_damage_buff"
	}
}
templates.zealot_fanatic_rage_major = {
	max_stacks_cap = 1,
	refresh_duration_on_stack = true,
	predicted = true,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	max_stacks = 1,
	class_name = "buff",
	buff_category = buff_categories.talents_secondary,
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.spec_passive_2.crit_chance * crit_chance_shared
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/abilities/squad_leader_ability_damage_buff"
	}
}
templates.zealot_preacher_increased_cleave = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.max_hit_mass_impact_modifier] = talent_settings_3.offensive_3.max_hit_mass_impact_modifier
	}
}
templates.zealot_dash_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = talent_settings_2.combat_ability.max_stacks,
	duration = talent_settings_2.combat_ability.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_2.combat_ability.melee_damage,
		[stat_buffs.melee_critical_strike_chance] = talent_settings_2.combat_ability.melee_critical_strike_chance
	},
	keywords = {
		keywords.armor_penetrating
	},
	proc_events = {
		[proc_events.on_hit] = talent_settings_2.combat_ability.on_hit_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action = Action.current_action(weapon_action_component, weapon_template)

		if current_action and current_action.kind == "sweep" then
			local critical_strike_component = unit_data_extension:write_component("critical_strike")
			critical_strike_component.is_active = true
		end
	end,
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local is_push = params.damage_efficiency and params.damage_efficiency == damage_efficiencies.push
		local is_ranged = params.attack_type == attack_types.ranged

		if is_push or is_ranged then
			return
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.finish
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_dash_charge"
	}
}
local martyrdom_damage_step = talent_settings_2.passive_1.damage_per_step
templates.zealot_martyrdom_base = {
	hud_always_show_stacks = true,
	predicted = true,
	hud_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_martyrdom",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "zealot_passive_buff",
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = martyrdom_max_stacks * martyrdom_damage_step
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.max_stacks = martyrdom_max_stacks
		template_data.martyrdom_grants_ally_power_bonus = talent_extension:has_special_rule(special_rules.zealot_martyrdom_grants_ally_power_bonus)
		template_data.current_stacks = 0
		local health_extension = ScriptUnit.has_extension(unit, "health_system")
		template_data.health_extension = health_extension
	end,
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		if missing_segments ~= template_data.current_stacks then
			local player = template_context.player

			Managers.stats:record_private("hook_martyrdom_stacks", player, missing_segments)
		end

		template_data.current_stacks = missing_segments
		local lerp_t = math.clamp01(missing_segments / martyrdom_max_stacks)

		return lerp_t
	end
}
templates.zealot_increased_melee_attack_speed = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings_2.passive_3.melee_attack_speed
	}
}
templates.zealot_flame_grenade_thrown = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_grenade_thrown] = 1
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local buff_name = "zealot_enemies_engulfed_by_flames"

		buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", template_context.unit)
	end
}
templates.zealot_enemies_engulfed_by_flames = {
	predicted = false,
	duration = 10,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_damage_dealt] = 1
	},
	proc_func = function (params, template_data, template_context)
		if not params.damage_profile_name == "liquid_area_fire_burning" then
			return
		end

		if not template_data._list_of_engulfed_enemies[params.attacked_unit] then
			template_data.engulfed_enemies = template_data.engulfed_enemies + 1
			template_data._list_of_engulfed_enemies[params.attacked_unit] = true
		end
	end,
	start_func = function (template_data, template_context)
		template_data._list_of_engulfed_enemies = {}
		template_data.engulfed_enemies = 0
	end,
	stop_func = function (template_data, template_context)
		Managers.stats:record_private("hook_zealot_engulfed_enemies", template_context.player, template_data.engulfed_enemies)
	end
}
templates.zealot_increased_toughness_recovery_from_kills = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = 1
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness_melee_replenish] = talent_settings_2.toughness_1.toughness_melee_replenish / 2 * 1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_melee_replenish] = talent_settings_2.toughness_1.toughness_melee_replenish / 2 * 2
			}
		}
	}
}
templates.zealot_reduced_toughness_damage_taken_on_critical_strike_hits = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_crit,
	start_func = function (template_data, template_context)
		template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("zealot_reduced_toughness_damage_taken_on_critical_strike_hits_effect", t)
	end
}
templates.zealot_reduced_toughness_damage_taken_on_critical_strike_hits_effect = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_reduce_toughness_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	class_name = "buff",
	duration = talent_settings_2.toughness_2.duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.toughness_2.toughness_damage_taken_multiplier
	}
}
local range = talent_settings_2.toughness_3.range
templates.zealot_toughness_regen_in_melee = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_toughness_in_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	always_show_in_hud = true,
	talent_overrides = {
		{
			toughness_percentage = talent_settings_2.toughness_3.toughness / 2 * 1
		},
		{
			toughness_percentage = talent_settings_2.toughness_3.toughness / 2 * 2
		}
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		template_data.enemy_side_names = enemy_side_names
		template_data.current_tick = 0
		template_data.character_state_component = character_state_component
		template_data.check_enemy_proximity_t = 0
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if template_data.is_active and template_data.next_toughness_regen <= t then
			template_data.next_toughness_regen = t + 1 / talent_settings_2.toughness_3.ticks_per_second

			if template_context.is_server then
				local percent_toughness = template_context.template_override_data.toughness_percentage / talent_settings_2.toughness_3.ticks_per_second

				Toughness.replenish_percentage(template_context.unit, percent_toughness, false, "talent_toughness_3")
			end
		end

		local check_enemy_proximity_t = template_data.check_enemy_proximity_t

		if t < check_enemy_proximity_t then
			return
		end

		template_data.check_enemy_proximity_t = t + 0.1
		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			template_data.is_active = false

			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local num_hits = broadphase:query(player_position, range, broadphase_results, enemy_side_names)
		local was_active = template_data.is_active
		local is_active = talent_settings_2.toughness_3.num_enemies <= num_hits

		if was_active ~= is_active then
			if is_active then
				template_data.next_toughness_regen = t + 1 / talent_settings_2.toughness_3.ticks_per_second
			end

			template_data.is_active = is_active
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end
}
templates.zealot_bleeding_crits = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")
		local target_is_bleeding = victim_buff_extension and (victim_buff_extension:has_keyword(keywords.bleeding) or victim_buff_extension:had_keyword(keywords.bleeding))

		if target_is_bleeding then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.buff_extension:add_internally_controlled_buff("zealot_bleeding_crits_effect", t)
		end

		local damage = params.damage or 0
		local is_damaging_crit = params.is_critical_strike and damage > 0

		if is_damaging_crit and HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local bleeding_dot_buff_name = "bleed"
			local t = FixedFrame.get_latest_fixed_time()
			local unit = template_context.unit
			local num_stacks = talent_settings_2.offensive_1.stacks

			for ii = 1, num_stacks do
				victim_buff_extension:add_internally_controlled_buff(bleeding_dot_buff_name, t, "owner_unit", unit)
			end
		end
	end
}
templates.zealot_bleeding_crits_effect = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_apply_bleed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 3,
	class_name = "buff",
	duration = talent_settings_2.offensive_1.duration,
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = talent_settings_2.offensive_1.melee_critical_strike_chance
	}
}
local min_hits = talent_settings_2.offensive_2.min_hits
templates.zealot_multi_hits_increase_impact = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units < min_hits then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_multi_hits_increase_impact_effect", t)
	end
}
local impact_buff_max_stacks = talent_settings_2.offensive_2.max_stacks
templates.zealot_multi_hits_increase_impact_effect = {
	refresh_duration_on_stack = true,
	always_active = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	duration = talent_settings_2.offensive_2.duration,
	max_stacks = impact_buff_max_stacks,
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings_2.offensive_2.impact_modifier
	},
	conditional_keywords = {
		keywords.uninterruptible,
		keywords.stun_immune
	},
	conditional_keywords_func = function (template_data, template_context)
		return impact_buff_max_stacks <= template_context.stack_count
	end,
	check_active_func = function (template_data, template_context)
		return true
	end
}
local attack_speed = talent_settings_2.offensive_3.attack_speed_per_segment
templates.zealot_martyrdom_attack_speed = {
	max_stacks = 1,
	predicted = false,
	max_stacks_cap = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.melee_attack_speed] = {
			min = 0,
			max = martyrdom_max_stacks * attack_speed
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.number_of_health_segements_damage_taken = 0
	end,
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		return math.clamp01(missing_segments / martyrdom_max_stacks)
	end
}
templates.zealot_backstab_kills_while_loner_aura_tracking_buff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	check_proc_func = CheckProcFunctions.on_ranged_enemy_killed,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local is_backstab = params.is_backstab

		if not is_backstab then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		local player = template_context.player

		Managers.stats:record_private("hook_zealot_loner_aura", player)
	end
}
templates.zealot_coherency_toughness_damage_resistance = {
	coherency_id = "zelot_maniac_coherency_aura",
	predicted = false,
	hud_priority = 5,
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_the_emperor_will",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	class_name = "buff",
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coherency.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.coherency.toughness_damage_taken_multiplier
	}
}
templates.zealot_toughness_on_aura_tracking_buff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_player_hit_received] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
		template_data.last_damage_recived = 0
		template_data.damage_to_take = 0
		template_data.damage_reduction = talent_settings_2.coherency.toughness_damage_taken_multiplier
		template_data.toughness_damage_reduced_percentage = (template_data.damage_reduction - 1) * -1
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
		local toughness_damage = toughness_extension:toughness_damage()
		template_data.damage_to_take = toughness_damage - template_data.last_damage_recived
		template_data.damage_to_take = template_data.damage_to_take * template_data.toughness_damage_reduced_percentage

		if template_data.damage_to_take >= 0 then
			local parent_buff_name = "zealot_toughness_damage_coherency"
			local hook_name = "hook_toughness_reduced_aura"
			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, template_data.damage_to_take)
			template_data.last_damage_recived = toughness_damage
		else
			template_data.last_damage_recived = 0
		end
	end
}
templates.zealot_coherency_toughness_damage_resistance_improved = {
	coherency_id = "zelot_maniac_coherency_aura",
	predicted = false,
	hud_priority = 5,
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_the_emperor_demand",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	class_name = "buff",
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.coop_2.toughness_damage_taken_multiplier
	}
}
templates.zealot_improved_toughness_on_aura_tracking_buff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_player_hit_received] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
		template_data.last_damage_recived = 0
		template_data.damage_to_take = 0
		template_data.damage_reduction = talent_settings_2.coop_2.toughness_damage_taken_multiplier
		template_data.toughness_damage_reduced_percentage = (template_data.damage_reduction - 1) * -1
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
		local toughness_damage = toughness_extension:toughness_damage()
		template_data.damage_to_take = toughness_damage - template_data.last_damage_recived
		template_data.damage_to_take = template_data.damage_to_take * template_data.toughness_damage_reduced_percentage

		if template_data.damage_to_take >= 0 then
			local parent_buff_name = "zealot_toughness_damage_reduction_coherency_improved"
			local hook_name = "hook_toughness_reduced_aura"
			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, template_data.damage_to_take)
			template_data.last_damage_recived = toughness_damage
		else
			template_data.last_damage_recived = 0
		end
	end
}
templates.zealot_toughness_on_combat_ability = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.coherency_extension = coherency_extension
	end,
	proc_func = function (params, template_data, template_context)
		local in_coherence_units = template_data.coherency_extension:in_coherence_units()
		local percentage = talent_settings_2.coop_3.toughness

		for coherency_unit, _ in pairs(in_coherence_units) do
			if coherency_unit ~= template_context.unit then
				Toughness.replenish_percentage(coherency_unit, percentage, false, "manaic_coop_3")
			end
		end
	end
}
templates.zealot_resist_death = {
	predicted = false,
	hud_priority = 2,
	always_show_in_hud = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_resist_death",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "proc_buff",
	active_duration = talent_settings_2.passive_2.active_duration,
	cooldown_duration = talent_settings_2.passive_2.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.passive_2.on_damage_taken_proc_chance
	},
	off_cooldown_keywords = {
		BuffSettings.keywords.resist_death
	},
	check_proc_func = CheckProcFunctions.would_die,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.ally_toughness_special_rule = talent_extension:has_special_rule(special_rules.zealot_toughness_on_resist_death)
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.ally_toughness_special_rule then
			return
		end

		local in_coherence_units = template_data.coherency_extension:in_coherence_units()
		local percentage = talent_settings_2.coop_1.replenish_percentage

		for coherency_unit, _ in pairs(in_coherence_units) do
			Toughness.replenish_percentage(coherency_unit, percentage, false, "maniac_coop_1")
		end
	end,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_invincibility",
			looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
			looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
			wwise_state = {
				group = "player_ability",
				on_state = "zealot_maniac_resist_death",
				off_state = "none"
			}
		}
	}
}
templates.zealot_resist_death_improved_with_leech = {
	predicted = false,
	hud_priority = 2,
	always_show_in_hud = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_resist_death_healing",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "proc_buff",
	active_duration = talent_settings_2.defensive_1.active_duration,
	cooldown_duration = talent_settings_2.defensive_1.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.defensive_1.on_damage_taken_proc_chance
	},
	off_cooldown_keywords = {
		keywords.resist_death
	},
	check_proc_func = CheckProcFunctions.would_die,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.ally_toughness_special_rule = talent_extension:has_special_rule(special_rules.zealot_toughness_on_resist_death)
	end,
	proc_func = function (params, template_data, template_context)
		local buff_name = "zealot_resist_death_leech_effect"
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(buff_name, t)

		if template_data.ally_toughness_special_rule then
			local in_coherence_units = template_data.coherency_extension:in_coherence_units()
			local percentage = talent_settings_2.coop_1.replenish_percentage

			for coherency_unit, _ in pairs(in_coherence_units) do
				Toughness.replenish_percentage(coherency_unit, percentage, false, "maniac_coop_1")
			end
		end
	end,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_invincibility",
			looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
			looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
			wwise_state = {
				group = "player_ability",
				on_state = "zealot_maniac_resist_death",
				off_state = "none"
			}
		}
	}
}
local leech = talent_settings_2.defensive_1.leech
local melee_multiplier = talent_settings_2.defensive_1.melee_multiplier
templates.zealot_resist_death_leech_effect = {
	predicted = false,
	class_name = "proc_buff",
	allow_proc_while_active = true,
	proc_events = {
		[proc_events.on_damage_dealt] = talent_settings_2.defensive_1.on_hit_proc_chance
	},
	duration = talent_settings_2.defensive_1.duration,
	start_func = function (template_data, template_context)
		template_data.heal_amount = 0
	end,
	proc_func = function (params, template_data, template_context)
		local damage_dealt = params.damage
		local health_per_kill = damage_dealt * leech

		if params.attack_type == attack_types.melee then
			template_data.heal_amount = template_data.heal_amount + health_per_kill * melee_multiplier
		else
			template_data.heal_amount = template_data.heal_amount + health_per_kill
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if not health_extension then
			return
		end

		local current_health_percent = health_extension:current_health_percent()

		if current_health_percent >= 0.25 then
			return
		end

		local current_health = health_extension:current_health()
		local max_health = health_extension:max_health()
		local heal_left = max_health * 0.25 - current_health
		local amount_to_add = template_data.heal_amount
		amount_to_add = math.clamp(amount_to_add, 0, heal_left)

		Health.add(unit, amount_to_add, "leech")

		local heal_percentage = math.round(100 * amount_to_add / max_health)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)

		Managers.stats:record_private("hook_zealot_health_leeched_during_resist_death", player, heal_percentage)
	end
}
templates.zealot_movement_enhanced = {
	predicted = true,
	hud_priority = 4,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_damage_boosts_movement",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = talent_settings_2.defensive_2.active_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.defensive_2.on_damage_taken_proc_chance
	},
	check_proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit
		local unit = template_context.unit

		return attacked_unit == unit
	end,
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_2.defensive_2.movement_speed
	},
	keywords = {
		keywords.slowdown_immune,
		keywords.stun_immune
	}
}
local num_slices = 10
templates.zealot_recuperate_a_portion_of_damage_taken = {
	predicted = false,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_heal_part_of_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = talent_settings_2.defensive_3.duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.defensive_3.on_damage_taken_proc_chance
	},
	check_proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit

		return victim_unit == template_context.unit
	end,
	start_func = function (template_data, template_context)
		local duration = talent_settings_2.defensive_3.duration
		template_data.update_frequency = 0.041666
		template_data.ticks = math.floor(duration / template_data.update_frequency + 0.5)
		template_data.last_update_t = 0
		template_data.damage_pool = {}

		for i = 1, num_slices do
			local damage_pool_slice = {
				ticks = 0,
				current_damage = 0
			}
			template_data.damage_pool[i] = damage_pool_slice
		end
	end,
	proc_func = function (params, template_data, template_context)
		local damage_amount = params.damage_amount
		local found_empty = false
		local damage_pool = template_data.damage_pool
		local recuperate_percentage = talent_settings_2.defensive_3.recuperate_percentage
		damage_amount = damage_amount * recuperate_percentage

		for i = 1, num_slices do
			local slice = damage_pool[i]

			if slice.ticks == 0 then
				slice.ticks = template_data.ticks
				slice.current_damage = damage_amount
				template_data.last_slice = i
				found_empty = true

				break
			end
		end

		if not found_empty then
			local last_slice = template_data.last_slice
			damage_pool[last_slice].current_damage = damage_pool[last_slice].current_damage + damage_amount
		end

		template_data.active = true
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.active then
			return
		end

		if not template_context.is_server then
			return
		end

		local last_update_t = template_data.last_update_t
		local update_frequency = template_data.update_frequency

		if t > last_update_t + update_frequency then
			local damage_pool = template_data.damage_pool
			local unit = template_context.unit
			local active = false
			local total_heal = 0

			for i = 1, num_slices do
				local slice = damage_pool[i]
				local ticks = slice.ticks

				if ticks > 0 then
					local heal = slice.current_damage / ticks
					total_heal = total_heal + heal
					slice.current_damage = slice.current_damage - heal
					ticks = ticks - 1
					slice.ticks = ticks

					if ticks ~= 0 then
						active = true
					end
				end
			end

			Health.add(unit, total_heal, DamageSettings.heal_types.heal_over_time_tick)

			template_data.active = active
			template_data.last_update_t = t
		end
	end
}
templates.zealot_close_ranged_damage = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = talent_settings_2.offensive_2_1.damage
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		template_data.inventory_component = inventory_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot

		if wielded_slot == "slot_secondary" then
			return true
		end

		return false
	end
}
templates.zealot_stacking_melee_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings_2.offensive_2_2.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local buff_extension = template_data.buff_extension

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("zealot_stacking_melee_damage_effect", t)
		end
	end
}
templates.zealot_stacking_melee_damage_effect = {
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_hits_grant_stacking_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	max_stacks = talent_settings_2.offensive_2_2.max_stacks,
	duration = talent_settings_2.offensive_2_2.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_2.offensive_2_2.melee_damage
	}
}
local external_properties = {}
templates.zealot_passive_replenish_throwing_knives_from_melee_kills = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_melee_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		local first_person_extension = ScriptUnit.has_extension(unit, "first_person_system")
		template_data.ability_extension = ability_extension
		template_data.first_person_extension = first_person_extension
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension
		local ability_type = "grenade_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		if ability_extension then
			local num_charges_restored = talent_settings_2.throwing_knives.melee_kill_refill_amount

			ability_extension:restore_ability_charge("grenade_ability", num_charges_restored)

			external_properties.indicator_type = "zealot_throwing_knives"
		end
	end
}
templates.zealot_combat_ability_crits_reduce_cooldown = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_crit_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension
		local ability_type = "combat_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		ability_extension:reduce_ability_cooldown_time(ability_type, talent_settings_2.combat_ability_1.time)
	end
}
templates.zealot_combat_ability_attack_speed_increase = {
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	hud_priority = 3,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_chastise_the_wicked",
	class_name = "proc_buff",
	active_duration = talent_settings_2.combat_ability_2.active_duration + 1,
	proc_keywords = {
		keywords.zealot_maniac_empowered_martyrdom
	},
	proc_events = {
		[proc_events.on_lunge_start] = talent_settings_2.combat_ability_2.on_lunge_end_proc_chance
	},
	proc_stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings_2.combat_ability_2.attack_speed
	}
}
local ALLOWED_INVISIBILITY_DAMAGE_TYPES = {
	[damage_types.bleeding] = true,
	[damage_types.burning] = true,
	[damage_types.grenade_frag] = true,
	[damage_types.plasma] = true,
	[damage_types.electrocution] = true
}
templates.zealot_invisibility = {
	unique_buff_id = "zealot_invisibility",
	duration = 3,
	hud_priority = 4,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_stealth",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	class_name = "proc_buff",
	keywords = {
		keywords.invisible
	},
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.2,
		[stat_buffs.critical_strike_chance] = 1,
		[stat_buffs.finesse_modifier_bonus] = 1,
		[stat_buffs.backstab_damage] = 1
	},
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_revive] = 1,
		[proc_events.on_rescue] = 1,
		[proc_events.on_pull_up] = 1,
		[proc_events.on_remove_net] = 1,
		[proc_events.on_action_start] = 1
	},
	player_effects = {
		wwise_state = {
			group = "player_ability",
			on_state = "zealot_invisible",
			off_state = "none"
		},
		wwise_parameters = {
			player_zealot_invisible_effect = 1
		}
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if template_data.exit_grace and t < template_data.exit_grace then
			return
		end

		local damage_type = params.damage_type

		if damage_type and ALLOWED_INVISIBILITY_DAMAGE_TYPES[damage_type] then
			return
		end

		local damage = params.damage
		local result = params.attack_result

		if damage and damage <= 0 and (not result or result ~= attack_results.toughness_absorbed) then
			return
		end

		local action_name = params.action_name

		if action_name and action_name ~= "action_throw_grenade" and action_name ~= "action_underhand_throw_grenade" then
			return
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	start_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		template_data.exit_grace = t + 0.5

		_shroudfield_penance_start(template_data, template_context)
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.has_extension(unit, "talent_system")
		local zealot_leave_stealth_toughness_regen_talent = talent_extension and talent_extension:has_special_rule(special_rules.zealot_leave_stealth_toughness_regen)

		if zealot_leave_stealth_toughness_regen_talent then
			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("zealot_leaving_stealth_restores_toughness", t)
		end

		_shroudfield_penance_stop(template_data, template_context)
	end
}
templates.zealot_invisibility_increased_duration = table.clone(templates.zealot_invisibility)
templates.zealot_invisibility_increased_duration.duration = 6
templates.zealot_sprinting_cost_reduction = {
	predicted = true,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.sprinting_cost_multiplier] = 0.8
	}
}
templates.zealot_backstab_damage = {
	class_name = "buff",
	coherency_priority = 1,
	coherency_id = "stab_guy_backstab_coherency_aura",
	predicted = false,
	keywords = {
		keywords.allow_backstabbing
	},
	stat_buffs = {
		[stat_buffs.backstab_damage] = 0.2
	}
}
templates.zealot_critstrike_damage_on_dodge = {
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_increased_crit_and_weakspot_damage_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	class_name = "proc_buff",
	active_duration = 3,
	proc_events = {
		[proc_events.on_successful_dodge] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_damage] = 0.5,
		[stat_buffs.weakspot_damage] = 0.5
	},
	proc_effects = {
		player_effects = {
			wwise_proc_event = "wwise/events/player/play_player_buff_damage_increase"
		}
	}
}
templates.zealot_melee_damage_on_stamina_depleted = {
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_more_damage_when_low_on_stamina",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 3,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_stamina_depleted] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = 0.2
	}
}
templates.zealot_damage_reduction_after_dodge = {
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_reduced_damage_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 4,
	class_name = "proc_buff",
	active_duration = 2.5,
	proc_events = {
		[proc_events.on_successful_dodge] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 0.75
	}
}
templates.zealot_increased_sprint_speed = {
	class_name = "buff",
	keywords = {
		keywords.sprint_dodge_in_overtime
	},
	stat_buffs = {
		[stat_buffs.sprint_movement_speed] = 0.1
	}
}
local damage_taken_to_ability_cd_percentage = talent_settings_3.combat_ability_cd_restore_on_damage.damage_taken_to_ability_cd_percentage
templates.zealot_ability_cooldown_on_heavy_melee_damage = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_damage_taken] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.health_extension = health_extension
		local ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_read_component = unit_data_extension:read_component("character_state")
		template_data.character_state_read_component = character_state_read_component
	end,
	check_proc_func = function (params, template_data, template_context)
		if params.attacked_unit ~= template_context.unit then
			return false
		end

		local character_state_read_component = template_data.character_state_read_component
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_read_component)

		if is_knocked_down then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension
		local damage_taken = params.damage_amount
		local cooldown_percent = damage_taken * damage_taken_to_ability_cd_percentage

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_percent)
	end
}
templates.zealot_ability_cooldown_on_leaving_coherency = {
	cooldown_duration = 15,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_coherency_exit] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
	end,
	check_proc_func = function (params, template_data, template_context)
		local number_of_unit_in_coherency = params.number_of_unit_in_coherency
		local is_only_left = number_of_unit_in_coherency <= 1
		local ability_extension = template_data.ability_extension
		local remaining_time = ability_extension:remaining_ability_cooldown("combat_ability")
		local has_remaining_time = remaining_time and remaining_time > 0

		return is_only_left and has_remaining_time
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)
	end
}
templates.zealot_flanking_damage = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	keywords = {
		keywords.allow_flanking
	},
	stat_buffs = {
		[stat_buffs.flanking_damage] = 0.2
	}
}
local combat_ability_cd_restore_on_backstab = talent_settings_3.zealot_backstab_kills_restore_cd.combat_ability_cd_percentage
templates.zealot_ability_cooldown_on_leaving_coherency_on_backstab = {
	cooldown_duration = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
	end,
	check_proc_func = function (params, template_data, template_context)
		local is_kill = CheckProcFunctions.on_kill(params)
		local is_backstab = params.is_backstab
		local ability_extension = template_data.ability_extension
		local remaining_time = ability_extension:remaining_ability_cooldown("combat_ability")
		local has_remaining_time = remaining_time and remaining_time > 0
		local should_trigger = is_kill and is_backstab and has_remaining_time

		if should_trigger and template_data.next_proc_t then
			local t = FixedFrame.get_latest_fixed_time()

			if t < template_data.next_proc_t then
				should_trigger = false
			end
		end

		return should_trigger
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", combat_ability_cd_restore_on_backstab)

		local t = FixedFrame.get_latest_fixed_time()
		template_data.next_proc_t = t + 0.2
	end
}
templates.zealot_increase_ability_cooldown_increase_bonus = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.ability_cooldown_modifier] = 0.5
	},
	conditional_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.5,
		[stat_buffs.backstab_damage] = 0.5
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local buff_extension = template_context.buff_extension
		local has_stealth = buff_extension:has_unique_buff_id("zealot_invisibility")

		return has_stealth
	end
}

return templates
