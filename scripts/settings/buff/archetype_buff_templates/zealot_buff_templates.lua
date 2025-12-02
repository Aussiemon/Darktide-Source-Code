-- chunkname: @scripts/settings/buff/archetype_buff_templates/zealot_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local CoherencyUtils = require("scripts/extension_systems/coherency/coherency_utils")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PushAttack = require("scripts/utilities/attack/push_attack")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Suppression = require("scripts/utilities/attack/suppression")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Stamina = require("scripts/utilities/attack/stamina")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local special_rules = SpecialRulesSettings.special_rules
local talent_settings = TalentSettings.zealot
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
	active_duration = 4,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_lunge_end] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local lunge_template_name = params.lunge_template_name

		if lunge_template_name == "zealot_dash" then
			return true
		end

		return false
	end,
}
templates.zealot_channel_damage = {
	class_name = "buff",
	duration = 10,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_channel_grants_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	stat_buffs = {
		[stat_buffs.damage] = 0.3,
	},
	related_talents = {
		"zealot_channel_grants_damage",
	},
}
templates.zealot_channel_toughness_damage_reduction = {
	class_name = "buff",
	duration = 10,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_channel_grants_toughness_damage_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 0.6,
	},
	player_effects = {
		effect_template = EffectTemplates.zealot_relic_blessed,
	},
	related_talents = {
		"zealot_channel_grants_toughness_damage_reduction",
	},
}
templates.zealot_channel_toughness_bonus = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_bolstering_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	duration = talent_settings_3.bolstering_prayer.toughness_duration,
	max_stacks = talent_settings_3.bolstering_prayer.toughness_stacks,
	stat_buffs = {
		[stat_buffs.toughness_bonus_flat] = talent_settings_3.bolstering_prayer.toughness_bonus,
	},
	related_talents = {
		"zealot_bolstering_prayer",
	},
}
templates.bolstering_prayer_resist_death = {
	class_name = "buff",
	duration = 1.5,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	keywords = {
		keywords.resist_death,
		keywords.stun_immune,
	},
}

local quickness_max_stacks = talent_settings_3.quickness.max_stacks
local quickness_toughness_percentage = talent_settings_3.quickness.toughness_percentage
local quickness_successful_dodge_stacks = talent_settings_3.quickness.dodge_stacks
local quickness_increased_duration = talent_settings_3.quickness.increased_duration

templates.zealot_quickness_passive = {
	always_show_in_hud = true,
	child_buff_template = "zealot_quickness_counter",
	class_name = "parent_proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_quickness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_successful_dodge] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_successful_dodge] = quickness_successful_dodge_stacks,
	},
	remove_child_proc_events = {
		[proc_events.on_hit] = quickness_max_stacks,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.dodge_stacks = talent_extension:has_special_rule(special_rules.zealot_quickness_dodge_stacks)
		template_data.toughness_per_stack = talent_extension:has_special_rule(special_rules.zealot_quickness_toughness_per_stack)
		template_data.increased_duration = talent_extension:has_special_rule(special_rules.zealot_quickness_increased_duration)
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
			local buff_name = template_data.increased_duration and "zealot_quickness_active_increased_duration" or "zealot_quickness_active"
			local is_active_buff_active = buff_extension:has_buff_using_buff_template(buff_name)

			return not is_active_buff_active
		end,
		[proc_events.on_successful_dodge] = function (params, template_data, template_context)
			return template_data.dodge_stacks
		end,
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
		local buff_name = template_data.increased_duration and "zealot_quickness_active_increased_duration" or "zealot_quickness_active"

		buff_extension:add_internally_controlled_buff_with_stacks(buff_name, num_child_stacks_removed, t)

		if template_data.toughness_per_stack then
			Toughness.replenish_percentage(template_context.unit, num_child_stacks_removed * quickness_toughness_percentage, nil, "zealot_quickness_passive")
		end

		template_data.cooldown = t + 8

		if not template_data.achievement_target_reached and num_child_stacks_removed >= template_data.achievement_target then
			Managers.stats:record_private("hook_zealot_movement_keystone_start", template_context.player, num_child_stacks_removed, template_data.achievement_target)

			template_data.achievement_target_reached = true
		end
	end,
	related_talents = {
		"zealot_quickness_passive",
	},
}
templates.zealot_quickness_counter = {
	class_name = "buff",
	predicted = false,
	refresh_start_time_on_stack = true,
	stack_offset = -1,
	max_stacks = quickness_max_stacks,
	max_stacks_cap = quickness_max_stacks,
}
templates.zealot_quickness_active = {
	class_name = "buff",
	duration = 6,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_quickness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 4,
	predicted = false,
	max_stacks = quickness_max_stacks,
	max_stacks_cap = quickness_max_stacks,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = 0.01,
		[stat_buffs.ranged_attack_speed] = 0.01,
		[stat_buffs.damage] = 0.01,
		[stat_buffs.dodge_speed_multiplier] = 1.005,
		[stat_buffs.dodge_distance_modifier] = 0.005,
		[stat_buffs.dodge_cooldown_reset_modifier] = -0.01,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.momentum_toughness_per_stack = talent_extension:has_special_rule(special_rules.zealot_momentum_toughness_replenish)
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.momentum_toughness_per_stack then
			local stack_count = template_context.stack_count

			Toughness.replenish_percentage(template_context.unit, talent_settings.zealot_momentum_toughness_replenish.toughness_to_restore * stack_count * dt, false, "zealot_quickness_active")
		end
	end,
	related_talents = {
		"zealot_quickness_passive",
	},
}
templates.zealot_quickness_active_increased_duration = table.clone(templates.zealot_quickness_active)
templates.zealot_quickness_active_increased_duration.duration = quickness_increased_duration
templates.zealot_improved_weapon_handling_after_dodge = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_weapon_handling_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.spread_modifier] = -0.75,
		[stat_buffs.recoil_modifier] = -0.5,
	},
	related_talents = {
		"zealot_improved_weapon_handling_after_dodge",
	},
}
templates.zealot_improved_weapon_swapping_no_ammo = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_melee_after_no_ammo",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:read_component("slot_secondary")
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local current_ammo = Ammo.current_ammo_in_clips(template_data.inventory_slot_component)

		if current_ammo == 0 then
			template_data.buff_extension:add_internally_controlled_buff("zealot_improved_weapon_swapping_impact", t)
		end
	end,
	related_talents = {
		"zealot_improved_melee_after_no_ammo",
	},
}
templates.zealot_improved_weapon_swapping_impact = {
	class_name = "buff",
	duration = 5,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_melee_after_no_ammo",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.3,
		[stat_buffs.melee_attack_speed] = 0.1,
	},
	related_talents = {
		"zealot_improved_melee_after_no_ammo",
	},
}
templates.zealot_improved_weapon_swapping_melee_kills_reload_speed = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("zealot_improved_weapon_swapping_reload_speed_buff", t)
	end,
}
templates.zealot_improved_weapon_swapping_reload_speed_buff = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_increased_reload_speed_on_melee_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.06,
		[stat_buffs.wield_speed] = 0.06,
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
	end,
	related_talents = {
		"zealot_increased_reload_speed_on_melee_kills",
	},
}
templates.zealot_leaving_stealth_restores_toughness = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_leaving_stealth_restores_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 4,
	max_stacks = 1,
	predicted = false,
	duration = talent_settings.zealot_leave_stealth_toughness_regen.damage_reduction_duration,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.zealot_leave_stealth_toughness_regen.damage_reduction_percentage,
	},
	related_talents = {
		"zealot_leaving_stealth_restores_toughness",
	},
}
templates.zealot_decrease_threat_increase_backstab_damage = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_increased_duration.duration,
	stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings.zealot_increased_duration.threat_weight_multiplier,
		[stat_buffs.backstab_damage] = talent_settings.zealot_increased_duration.backstab_damage,
	},
	related_talents = {
		"zealot_decrease_threat_increase_backstab_damage",
	},
}
templates.zealot_toughness_on_heavy_kills = {
	class_name = "proc_buff",
	predicted = false,
	toughness_percentage = 0.1,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		local template = template_context.template

		Toughness.replenish_percentage(template_context.unit, template.toughness_percentage, false, "zealot_heavy_kill")
	end,
}
templates.zealot_toughness_on_ranged_kill = {
	class_name = "proc_buff",
	predicted = false,
	toughness_percentage = 0.04,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context)
		local template = template_context.template

		Toughness.replenish_percentage(template_context.unit, template.toughness_percentage, false, "zealot_ranged_kill")
	end,
}
templates.zealot_toughness_on_dodge = {
	class_name = "proc_buff",
	cooldown_duration = 0.5,
	predicted = false,
	toughness_percentage = 0.15,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local toughness_percentage = template_context.template.toughness_percentage

		Toughness.replenish_percentage(template_context.unit, toughness_percentage, false, "zealot_dodge")
	end,
}
templates.zealot_improved_stun_grenade = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier_shock] = 0.5,
	},
}
templates.zealot_increased_coherency_regen = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_coherency_regen_rate_modifier] = 0.5,
	},
}
templates.zealot_preacher_ally_defensive = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
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
	end,
}
templates.zealot_preacher_ally_defensive_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/talents/zealot_3/hud/zealot_3_tier_4_3",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	buff_category = buff_categories.talents_secondary,
	duration = talent_settings_3.coop_3.duration,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings_3.coop_3.damage_taken_multiplier,
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_preacher_defense",
	},
	related_talents = {
		"zealot_ally_damage_taken_reduced",
	},
}

local PUSH_SETTINGS = {
	push_radius = talent_settings_3.defensive_1.push_radius,
	inner_push_rad = talent_settings_3.defensive_1.inner_push_rad,
	outer_push_rad = talent_settings_3.defensive_1.outer_push_rad,
	inner_damage_profile = DamageProfileTemplates.push_test,
	inner_damage_type = damage_types.physical,
	outer_damage_profile = DamageProfileTemplates.push_test,
	outer_damage_type = damage_types.physical,
}
local PUSH_POWER_LEVEL = talent_settings_3.defensive_1.power_level

templates.zealot_preacher_push_on_hit = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_defensive_knockback",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 4,
	predicted = false,
	cooldown_duration = talent_settings_3.defensive_1.cooldown_duration,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.character_state_component = unit_data_extension:read_component("character_state")
	end,
	check_proc_func = function (params, template_data, template_context)
		local is_melee = params.attack_type == attack_types.melee
		local is_hurting_hit = AttackSettings.is_damaging_result[params.attack_result]
		local has_attacking_unit = not not params.attacking_unit and ALIVE[params.attacking_unit]
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
	end,
	related_talents = {
		"zealot_defensive_knockback",
	},
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
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = {
			min = 0,
			max = toughness_reduction_per_stack * martyrdom_max_stacks,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		return math.clamp01(missing_segments / martyrdom_max_stacks)
	end,
}

local toughness_modifier_per_stack = talent_settings.zealot_martyrdom_toughness_modifier.toughness_modifier

templates.zealot_martyrdom_toughness_modifier = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.toughness_replenish_modifier] = {
			min = 0,
			max = toughness_modifier_per_stack * martyrdom_max_stacks,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		return math.clamp01(missing_segments / martyrdom_max_stacks)
	end,
}

local ability_cooldown_regeneration_per_stack = talent_settings.zealot_martyrdom_cdr.ability_cooldown_regeneration_per_stack

templates.zealot_martyrdom_cdr = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")

		local fixed_t = FixedFrame.get_latest_fixed_time()

		template_data.timer = fixed_t + 1
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		_martyrdom_update_func(template_data, template_context, dt, t)

		local missing_segments = _martyrdom_missing_health_segments(template_data)

		if missing_segments < 1 then
			return
		end

		if t > template_data.timer then
			template_data.timer = template_data.timer + 1

			local cooldown = ability_cooldown_regeneration_per_stack * missing_segments

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown)
		end
	end,
	related_talents = {
		"zealot_martyrdom_cdr",
	},
}
templates.zealot_preacher_segment_breaking_half_damage = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	keywords = {
		keywords.health_segment_breaking_reduce_damage_taken,
	},
	stat_buffs = {
		[stat_buffs.health_segment_damage_taken_multiplier] = talent_settings_3.defensive_2.health_segment_damage_taken_multiplier,
	},
}

local max_dist = talent_settings_3.passive_1.max_dist
local max_dist_sqaured = max_dist * max_dist
local out_of_combat_time = talent_settings_3.passive_1.duration
local buff_removal_interval_time = talent_settings_3.passive_1.buff_removal_time_modifier
local toughness_on_max_stacks = talent_settings_3.passive_1.toughness_on_max_stacks
local toughness_on_max_stacks_small = talent_settings_3.passive_1.toughness_on_max_stacks_small
local toughness_over_time = talent_settings_3.passive_1.toughness_over_time
local _fanatic_rage_add_stack

templates.zealot_fanatic_rage = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	use_talent_resource = true,
	proc_events = {
		[proc_events.on_minion_death] = 1,
		[proc_events.on_hit] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 0.75,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not template_data.toughness_on_max then
			return false
		end

		local current_resource = template_data.talent_resource_component.current_resource
		local max_resource = template_data.talent_resource_component.max_resource

		return current_resource == max_resource
	end,
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

			if distance_sq > max_dist_sqaured then
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
		end,
	},
	update_func = function (template_data, template_context, dt, t)
		if template_data.remove_stack_t and t > template_data.remove_stack_t then
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

		if template_data.toughness_on_max then
			local current_resource = template_data.talent_resource_component.current_resource
			local max_resource = template_data.talent_resource_component.max_resource
			local at_max = current_resource == max_resource

			if at_max then
				local percentage = toughness_over_time * dt

				Toughness.replenish_percentage(template_context.unit, percentage, false, "fanatic_rage")
			end
		end
	end,
	related_talents = {
		"zealot_fanatic_rage",
	},
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

			if not rage_buff_active then
				local toughness_amount = toughness_on_max_stacks

				Toughness.replenish_percentage(template_context.unit, toughness_amount, false, "fanatic_rage")
			end
		end

		Managers.stats:record_private("hook_zealot_fanatic_rage_start", template_context.player)
		template_data.buff_extension:add_internally_controlled_buff("zealot_fanatic_rage_buff", t)
	end

	template_data.talent_resource_component.current_resource = current_resource
	template_data.remove_stack_t = t + out_of_combat_time
end

templates.zealot_fanatic_rage_buff = {
	always_active = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.passive_1.crit_chance,
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.spec_passive_2.crit_chance,
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
			local buff_name = "zealot_fanatic_rage_shared"
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
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_preacher_rage",
	},
	related_talents = {
		"zealot_fanatic_rage",
	},
}
templates.zealot_fanatic_rage_shared = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.offensive_2.crit_chance,
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/abilities/squad_leader_ability_damage_buff",
	},
	related_talents = {
		"zealot_fanatic_rage",
	},
}
templates.zealot_preacher_damage_vs_disgusting = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.zealot_toughness,
	},
	stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = talent_settings_3.passive_2.damage_vs_disgusting,
		[stat_buffs.resistant_damage] = talent_settings_3.passive_2.damage_vs_resistant,
	},
}

local corruption_heal_amount = talent_settings_3.coherency.corruption_heal_amount

templates.zealot_preacher_coherency_corruption_healing = {
	class_name = "interval_buff",
	coherency_id = "zealot_preacher_coherency_corruption_healing",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_cleansing_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	interval = talent_settings_3.coherency.interval,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
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

			template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(parent_buff_name, hook_name, corruption_heal_amount)
		end
	end,
	related_talents = {
		"utilitieszealot_corruption_healing_coherency",
	},
}

local corruption_heal_amount_increased = talent_settings_3.coop_2.corruption_heal_amount_increased

templates.zealot_preacher_coherency_corruption_healing_improved = {
	class_name = "interval_buff",
	coherency_id = "zealot_preacher_coherency_corruption_healing",
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_cleansing_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	interval = talent_settings_3.coop_2.interval,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
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

			template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(parent_buff_name, hook_name, corruption_heal_amount_increased)
		end
	end,
	related_talents = {
		"zealot_corruption_healing_coherency_improved",
	},
}
templates.zealot_preacher_reduce_corruption_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = talent_settings_3.passive_3.corruption_taken_multiplier,
	},
}
templates.zealot_always_in_coherency_buff = {
	class_name = "buff",
	coherency_id = "zealot_always_at_least_one_coherency",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_always_in_coherency",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	related_talents = {
		"zealot_always_in_coherency",
	},
}
templates.zealot_preacher_impact_power = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings_3.mixed_1.impact_modifier,
	},
}
templates.zealot_preacher_more_segments = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = talent_settings_3.mixed_3.extra_max_amount_of_wounds,
	},
}
templates.zealot_pious_stabguy_increased_weaskpot_impact = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_weakspot_impact_modifier] = 0.5,
	},
}
templates.zealot_preacher_melee_increase_next_melee_proc = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_increase_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = talent_settings_3.offensive_1.melee_damage * talent_settings_3.offensive_1.max_stacks,
		},
	},
	specific_proc_func = {
		on_sweep_finish = function (params, template_data, template_context)
			local hits = params.num_hit_units

			template_data.hits = hits
		end,
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local hits = template_data.hits or 0
		local max_hits = talent_settings_3.offensive_1.max_stacks

		return math.clamp(hits / max_hits, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		local hits = template_data.hits or 0
		local number_of_stacks = math.clamp(hits, 0, talent_settings_3.offensive_1.max_stacks)

		return number_of_stacks
	end,
	check_active_func = function (template_data, template_context)
		local hits = template_data.hits or 0
		local show = hits > 0

		return show
	end,
	related_talents = {
		"zealot_preacher_melee_increase_next_melee_proc",
	},
}

local crit_chance_shared = talent_settings_3.offensive_2.crit_share

templates.zealot_fanatic_rage_minor = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.passive_1.crit_chance * crit_chance_shared,
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/abilities/squad_leader_ability_damage_buff",
	},
	related_talents = {
		"zealot_fanatic_rage",
	},
}
templates.zealot_fanatic_rage_major = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_fanatic_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_3.spec_passive_2.crit_chance * crit_chance_shared,
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/abilities/squad_leader_ability_damage_buff",
	},
	related_talents = {
		"zealot_fanatic_rage_improved",
	},
}
templates.zealot_preacher_increased_cleave = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.max_hit_mass_impact_modifier] = talent_settings_3.offensive_3.max_hit_mass_impact_modifier,
	},
}
templates.zealot_dash_buff = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings_2.combat_ability.max_stacks,
	duration = talent_settings_2.combat_ability.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_2.combat_ability.melee_damage,
		[stat_buffs.melee_critical_strike_chance] = talent_settings_2.combat_ability.melee_critical_strike_chance,
		[stat_buffs.melee_rending_multiplier] = talent_settings_2.combat_ability.melee_rending_multiplier,
	},
	proc_events = {
		[proc_events.on_hit] = talent_settings_2.combat_ability.on_hit_proc_chance,
		[proc_events.on_weapon_special_deactivate] = 1,
		[proc_events.on_weapon_special_activate] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local action_sweep_component = unit_data_extension:read_component("action_sweep")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action = Action.current_action(weapon_action_component, weapon_template)

		if current_action and current_action.kind == "sweep" then
			local critical_strike_component = unit_data_extension:write_component("critical_strike")

			critical_strike_component.is_active = true
		end

		local inventory_slot_component = unit_data_extension:read_component("slot_primary")

		template_data.activate = inventory_slot_component and inventory_slot_component.special_active
		template_data.was_sticking_to_unit = SweepStickyness.is_sticking_to_unit(action_sweep_component)
		template_data.weapon_template = weapon_template
		template_data.weapon_action_component = weapon_action_component
		template_data.action_sweep_component = action_sweep_component

		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local zealot_fotf_refund_cooldown = talent_extension:has_special_rule(special_rules.zealot_fotf_refund_cooldown)

		if zealot_fotf_refund_cooldown then
			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("zealot_fotf_refund_cooldown", t)
		end
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = CheckProcFunctions.on_melee_hit,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			local is_push = params.damage_efficiency and params.damage_efficiency == damage_efficiencies.push
			local is_ranged = params.attack_type == attack_types.ranged

			if is_push or is_ranged then
				return
			end

			template_data.hit = true
		end,
		on_weapon_special_deactivate = function (params, template_data, template_context)
			template_data.deactivate = true
			template_data.end_t = template_data.weapon_action_component.end_t
		end,
		on_weapon_special_activate = function (params, template_data, template_context)
			template_data.activate = true
			template_data.deactivate = false
		end,
	},
	conditional_exit_func = function (template_data)
		local has_hit = template_data.hit or false
		local activate = template_data.activate or false
		local deactivate = template_data.deactivate or false
		local was_sticking_to_unit = template_data.was_sticking_to_unit
		local weapon_template = template_data.weapon_template
		local current_weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data
		local keep_buff_ability_active_on_special = current_weapon_special_tweak_data and current_weapon_special_tweak_data.keep_buff_ability_active_on_special

		if was_sticking_to_unit then
			local is_sticking_to_unit = SweepStickyness.is_sticking_to_unit(template_data.action_sweep_component)

			return not is_sticking_to_unit
		end

		if not has_hit then
			return false
		end

		local is_active = keep_buff_ability_active_on_special and template_data.activate
		local is_deactivated = keep_buff_ability_active_on_special and template_data.deactivate
		local end_t = template_data.end_t
		local t = Managers.time:time("gameplay")

		return not is_active or is_deactivated and end_t and end_t < t
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_dash_charge",
	},
}

local martyrdom_damage_step = talent_settings_2.passive_1.damage_per_step

templates.zealot_martyrdom_base = {
	class_name = "zealot_passive_buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_keystone_martyrdom",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 2,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = martyrdom_max_stacks * martyrdom_damage_step,
		},
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
	end,
	related_talents = {
		"zealot_martyrdom",
	},
}
templates.zealot_increased_melee_attack_speed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings_2.passive_3.melee_attack_speed,
	},
}
templates.zealot_flame_grenade_thrown = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_grenade_thrown] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local buff_name = "zealot_enemies_engulfed_by_flames"

		buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", template_context.unit)
	end,
}

local ALLOWED_FIRE_DAMAGE_PROFILES = {
	fire_grenade_impact = true,
	flame_grenade_liquid_area_fire_burning = true,
	liquid_area_fire_burning = true,
}

templates.zealot_enemies_engulfed_by_flames = {
	class_name = "proc_buff",
	duration = 10,
	predicted = false,
	proc_events = {
		[proc_events.on_damage_dealt] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not ALLOWED_FIRE_DAMAGE_PROFILES[params.damage_profile_name] then
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
	end,
}
templates.zealot_increased_toughness_recovery_from_kills = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = 1,
	},
}
templates.zealot_reduced_toughness_damage_taken_on_critical_strike_hits = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	start_func = function (template_data, template_context)
		template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("zealot_reduced_toughness_damage_taken_on_critical_strike_hits_effect", t)
	end,
}
templates.zealot_reduced_toughness_damage_taken_on_critical_strike_hits_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_reduce_toughness_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.toughness_2.duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.toughness_2.toughness_damage_taken_multiplier,
	},
	related_talents = {
		"zealot_crits_reduce_toughness_damage",
	},
}

local zealot_toughness_regen_in_melee_range = talent_settings.zealot_toughness_in_melee.range

templates.zealot_toughness_regen_in_melee = {
	class_name = "buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_toughness_in_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
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

		template_data.toughness_percent = 0
		template_data.enemy_side_names = enemy_side_names
		template_data.current_tick = 0
		template_data.character_state_component = character_state_component
		template_data.dt_since_last_check = 0
		template_data.check_enemy_proximity_t = 0
		template_data.current_stacks = 0
	end,
	visual_stack_count = function (template_data, template_context)
		return template_data.current_stacks
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			template_data.check_enemy_proximity_t = t + 0.1
			template_data.dt_since_last_check = 0

			return
		end

		if template_data.toughness_percent > 0 then
			Toughness.replenish_percentage(template_context.unit, template_data.toughness_percent * dt, false, "talent_toughness_3")
		end

		template_data.dt_since_last_check = template_data.dt_since_last_check + dt

		local check_enemy_proximity_t = template_data.check_enemy_proximity_t

		if t < check_enemy_proximity_t then
			return
		end

		template_data.check_enemy_proximity_t = t + 0.1

		local initial_percentage_toughness = talent_settings.zealot_toughness_in_melee.initial_percentage_toughness
		local percentage_toughness_per_enemy = talent_settings.zealot_toughness_in_melee.percentage_toughness_per_enemy
		local percentage_toughness_per_monster = talent_settings.zealot_toughness_in_melee.percentage_toughness_per_enemy
		local max_percentage_toughness = talent_settings.zealot_toughness_in_melee.max_percentage_toughness
		local monster_count = talent_settings.zealot_toughness_in_melee.monster_count
		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local num_hits = broadphase.query(broadphase, player_position, zealot_toughness_regen_in_melee_range, broadphase_results, enemy_side_names)

		if num_hits == 0 then
			template_data.toughness_percent = 0
		else
			local count = 0

			for ii = 1, num_hits do
				local enemy_unit = broadphase_results[ii]
				local unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
				local breed = unit_data_extension and unit_data_extension:breed()

				if breed then
					local tags = breed.tags
					local add = (tags.monster or tags.captain or tags.cultist_captain) and monster_count or 1

					count = count + add
				end
			end

			count = count - 1

			local toughness_percent = math.min(initial_percentage_toughness + percentage_toughness_per_enemy * count, max_percentage_toughness)

			template_data.toughness_percent = toughness_percent
			template_data.current_stacks = math.min(count, 6)
		end

		template_data.dt_since_last_check = 0
	end,
	related_talents = {
		"zealot_toughness_in_melee",
	},
}
templates.zealot_bleeding_crits = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
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
	end,
}
templates.zealot_bleeding_crits_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_apply_bleed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.offensive_1.duration,
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = talent_settings_2.offensive_1.melee_critical_strike_chance,
	},
	related_talents = {
		"zealot_crits_apply_bleed",
	},
}

local min_hits = talent_settings_2.offensive_2.min_hits

templates.zealot_multi_hits_increase_impact = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
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
	end,
}

local impact_buff_max_stacks = talent_settings_2.offensive_2.max_stacks

templates.zealot_multi_hits_increase_impact_effect = {
	always_active = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.offensive_2.duration,
	max_stacks = impact_buff_max_stacks,
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings_2.offensive_2.impact_modifier,
	},
	conditional_keywords = {
		keywords.uninterruptible,
		keywords.stun_immune,
	},
	conditional_keywords_func = function (template_data, template_context)
		return template_context.stack_count >= impact_buff_max_stacks
	end,
	check_active_func = function (template_data, template_context)
		return true
	end,
	related_talents = {
		"zealot_multi_hits_grant_impact_and_uninterruptible",
	},
}

local attack_speed = talent_settings_2.offensive_3.attack_speed_per_segment

templates.zealot_martyrdom_attack_speed = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.melee_attack_speed] = {
			min = 0,
			max = martyrdom_max_stacks * attack_speed,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		return math.clamp01(missing_segments / martyrdom_max_stacks)
	end,
}
templates.zealot_cleave_impact_post_push = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	check_proc_func = CheckProcFunctions.on_push_hit,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_cleave_impact_post_push_effect", t)
	end,
}
templates.zealot_cleave_impact_post_push_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_cleave_impact_post_push.duration,
	max_stacks = talent_settings.zealot_cleave_impact_post_push.max_stacks,
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings.zealot_cleave_impact_post_push.impact_modifier,
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings.zealot_cleave_impact_post_push.cleave,
	},
}
templates.zealot_damage_after_heavy_attack = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_damage_after_heavy_attack_effect", t)
	end,
}
templates.zealot_damage_after_heavy_attack_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_damage_after_heavy_attack.duration,
	max_stacks = talent_settings.zealot_damage_after_heavy_attack.max_stacks,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.zealot_damage_after_heavy_attack.damage,
	},
}
templates.zealot_kills_increase_damage_of_next_melee = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			if template_data.zealot_kills_increase_damage_of_next_melee_effect_id then
				template_data.buff_extension:mark_buff_finished(template_data.zealot_kills_increase_damage_of_next_melee_effect_id)

				template_data.zealot_kills_increase_damage_of_next_melee_effect_id = nil
			end
		end,
		on_kill = function (params, template_data, template_context)
			local t = FixedFrame.get_latest_fixed_time()
			local _, id = template_context.buff_extension:add_externally_controlled_buff("zealot_kills_increase_damage_of_next_melee_effect", t)

			template_data.zealot_kills_increase_damage_of_next_melee_effect_id = id
		end,
	},
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			return params.attack_type == attack_types.melee
		end,
	},
}
templates.zealot_kills_increase_damage_of_next_melee_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.zealot_kills_increase_damage_of_next_melee.max_stacks,
	max_stacks_cap = talent_settings.zealot_kills_increase_damage_of_next_melee.max_stacks,
	duration = talent_settings.zealot_kills_increase_damage_of_next_melee.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.zealot_kills_increase_damage_of_next_melee.melee_damage,
	},
}
templates.zealot_multihits_reduce_damage_of_next_attack = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_player_hit_received] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
		template_data.min_hits = talent_settings.zealot_multihits_reduce_damage_of_next_attack.min_hits
	end,
	specific_proc_func = {
		on_sweep_finish = function (params, template_data, template_context)
			if params.num_hit_units < template_data.min_hits then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()
			local _, id = template_data.buff_extension:add_externally_controlled_buff("zealot_multihits_reduce_damage_of_next_attack_effect", t)

			template_data.zealot_multihits_reduce_damage_of_next_attack_effect_id = id
		end,
		on_player_hit_received = function (params, template_data, template_context)
			if template_data.zealot_multihits_reduce_damage_of_next_attack_effect_id then
				template_data.buff_extension:mark_buff_finished(template_data.zealot_multihits_reduce_damage_of_next_attack_effect_id)

				template_data.zealot_multihits_reduce_damage_of_next_attack_effect_id = nil
			end
		end,
	},
}
templates.zealot_multihits_reduce_damage_of_next_attack_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.zealot_multihits_reduce_damage_of_next_attack.max_stacks,
	duration = talent_settings.zealot_multihits_reduce_damage_of_next_attack.duration,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.zealot_multihits_reduce_damage_of_next_attack.damage_taken_multiplier,
	},
}
templates.zealot_blocking_increases_damage_of_next_melee = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_block] = 1,
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
		template_data.min_hits = talent_settings.zealot_blocking_increases_damage_of_next_melee.min_hits
	end,
	specific_proc_func = {
		on_block = function (params, template_data, template_context)
			local t = FixedFrame.get_latest_fixed_time()
			local _, id = template_data.buff_extension:add_externally_controlled_buff("zealot_blocking_increases_damage_of_next_melee_effect", t)

			template_data.zealot_blocking_increases_damage_of_next_melee_effect_id = id
		end,
		on_hit = function (params, template_data, template_context)
			if template_data.zealot_blocking_increases_damage_of_next_melee_effect_id then
				template_data.buff_extension:mark_buff_finished(template_data.zealot_blocking_increases_damage_of_next_melee_effect_id)

				template_data.zealot_blocking_increases_damage_of_next_melee_effect_id = nil
			end
		end,
	},
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			return params.attack_type == attack_types.melee
		end,
	},
}
templates.zealot_blocking_increases_damage_of_next_melee_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.zealot_blocking_increases_damage_of_next_melee.max_stacks,
	max_stacks_cap = talent_settings.zealot_blocking_increases_damage_of_next_melee.max_stacks,
	duration = talent_settings.zealot_blocking_increases_damage_of_next_melee.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.zealot_blocking_increases_damage_of_next_melee.melee_damage,
	},
}
templates.zealot_multihits_restore_stamina = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
		template_data.min_hits = talent_settings.zealot_multihits_restore_stamina.min_hits
	end,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units < template_data.min_hits then
			return
		end

		Stamina.add_stamina_percent(template_context.unit, talent_settings.zealot_multihits_restore_stamina.stamina)
	end,
}
templates.zealot_crits_rend = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_rending_multiplier] = talent_settings.zealot_crits_rend.rending_multiplier,
	},
}
templates.zealot_elite_kills_empowers = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	check_proc_func = CheckProcFunctions.on_elite_kill,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_elite_kills_empowers_effect", t)
	end,
}
templates.zealot_elite_kills_empowers_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_elite_kills_empowers",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_elite_kills_empowers.duration,
	max_stacks = talent_settings.zealot_elite_kills_empowers.max_stacks,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.zealot_elite_kills_empowers.damage,
	},
	update_func = function (template_data, template_context, dt, t)
		local toughness = talent_settings.zealot_elite_kills_empowers.toughness * dt / talent_settings.zealot_elite_kills_empowers.duration

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
}
templates.zealot_uninterruptible_no_slow_heavies = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.uninterruptible,
	},
	conditional_stat_buffs = {
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = talent_settings.zealot_uninterruptible_no_slow_heavies.multiplier,
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
	end,
}
templates.zealot_stacking_weakspot_power = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	check_proc_func = CheckProcFunctions.on_melee_weakspot_kills,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_stacking_weakspot_power_effect", t)
	end,
}
templates.zealot_stacking_weakspot_power_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_stacking_weakspot_power.duration,
	max_stacks = talent_settings.zealot_stacking_weakspot_power.max_stacks,
	stat_buffs = {
		[stat_buffs.melee_weakspot_power_modifier] = talent_settings.zealot_stacking_weakspot_power.melee_weakspot_power_modifier,
	},
}
templates.zealot_damage_vs_elites = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = talent_settings.zealot_damage_vs_elites.damage_vs_elites,
	},
}
templates.zealot_weakspot_damage_reduction = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_weakspot_damage_reduction_effect", t)
	end,
}
templates.zealot_weakspot_damage_reduction_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_weakspot_damage_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_weakspot_damage_reduction.duration,
	max_stacks = talent_settings.zealot_weakspot_damage_reduction.max_stacks,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.zealot_weakspot_damage_reduction.damage_taken_multiplier,
	},
	related_talents = {
		"zealot_weakspot_damage_reduction",
	},
}
templates.zealot_stacking_melee_damage_after_dodge = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_stacking_melee_damage_after_dodge_effect", t)
	end,
	related_talents = {
		"zealot_stacking_melee_damage_after_dodge",
	},
}
templates.zealot_stacking_melee_damage_after_dodge_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_stacking_melee_damage_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_stacking_melee_damage_after_dodge.duration,
	max_stacks = talent_settings.zealot_stacking_melee_damage_after_dodge.max_stacks,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.zealot_stacking_melee_damage_after_dodge.melee_damage,
	},
	related_talents = {
		"zealot_stacking_melee_damage_after_dodge",
	},
}
templates.zealot_bled_enemies_take_more_damage = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_buff_added] = 1,
		[proc_events.on_buff_stack_added] = 1,
		[proc_events.on_max_stack_refresh_buff] = 1,
	},
	check_proc_func = CheckProcFunctions.on_bleeding_buff_added,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local target_unit = params.unit
		local extension_manager = Managers.state.extension
		local side_system = extension_manager:system("side_system")
		local target_is_enemy = side_system:is_enemy(unit, target_unit)

		if target_is_enemy then
			local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if target_buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				target_buff_extension:add_internally_controlled_buff("zealot_bled_enemies_take_more_damage_effect", t)
			end
		end
	end,
}
templates.zealot_bled_enemies_take_more_damage_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_bled_enemies_take_more_damage.duration,
	max_stacks = talent_settings.zealot_bled_enemies_take_more_damage.max_stacks,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.zealot_bled_enemies_take_more_damage.damage_taken_multiplier,
	},
}
templates.zealot_damage_vs_nonthreat = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_nonthreat] = talent_settings.zealot_damage_vs_nonthreat.damage_vs_nonthreat,
	},
}
templates.zealot_dodge_improvements = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_consecutive_dodges] = talent_settings.zealot_dodge_improvements.extra_consecutive_dodges,
		[stat_buffs.dodge_distance_modifier] = talent_settings.zealot_dodge_improvements.dodge_distance_modifier,
	},
}
templates.zealot_revive_speed = {
	class_name = "proc_buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.revive_speed_modifier] = talent_settings.zealot_revive_speed.revive_speed_modifier,
	},
	proc_events = {
		[proc_events.on_revive] = 1,
		[proc_events.on_rescue] = 1,
		[proc_events.on_pull_up] = 1,
		[proc_events.on_remove_net] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.has_extension(params.target_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("zealot_revive_speed_effect", t)
		end
	end,
}
templates.zealot_revive_speed_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_revive_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_revive_speed.duration,
	max_stacks = talent_settings.zealot_revive_speed.max_stacks,
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.zealot_revive_speed.movement_speed,
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.zealot_revive_speed.toughness_damage_taken_multiplier,
	},
}
templates.zealot_melee_crits_restore_stamina = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	cooldown_duration = talent_settings.zealot_melee_crits_restore_stamina.cooldown_duration,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit_melee,
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, talent_settings.zealot_melee_crits_restore_stamina.stamina)
	end,
}
templates.zealot_heavy_multihits_increase_melee_damage = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
		template_data.min_hits = talent_settings.zealot_heavy_multihits_increase_melee_damage.min_hits
	end,
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units < template_data.min_hits then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_heavy_multihits_increase_melee_damage_effect", t)
	end,
}
templates.zealot_heavy_multihits_increase_melee_damage_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_heavy_multihits_increase_melee_damage.duration,
	max_stacks = talent_settings.zealot_heavy_multihits_increase_melee_damage.max_stacks,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.zealot_heavy_multihits_increase_melee_damage.melee_damage,
	},
}
templates.zealot_backstabs_increase_backstab_damage = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local is_backstab = params.is_backstab

		if not is_backstab then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_backstabs_increase_backstab_damage_effect", t)
	end,
}
templates.zealot_backstabs_increase_backstab_damage_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_backstabs_increase_backstab_damage.duration,
	max_stacks = talent_settings.zealot_backstabs_increase_backstab_damage.max_stacks,
	stat_buffs = {
		[stat_buffs.backstab_damage] = talent_settings.zealot_backstabs_increase_backstab_damage.backstab_damage,
	},
}
templates.zealot_reduced_threat_after_backstab_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local is_backstab = params.is_backstab

		if not is_backstab then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_reduced_threat_after_backstab_kill_effect", t)
	end,
}
templates.zealot_reduced_threat_after_backstab_kill_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_reduced_threat_after_backstab_kill.duration,
	max_stacks = talent_settings.zealot_reduced_threat_after_backstab_kill.max_stacks,
	stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings.zealot_reduced_threat_after_backstab_kill.threat_weight_multiplier,
	},
}
templates.zealot_melee_crits_reduce_damage_dealt = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	check_proc_func = CheckProcFunctions.on_crit_melee,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if attacked_unit then
			local target_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if target_buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				target_buff_extension:add_internally_controlled_buff("zealot_melee_crits_reduce_damage_dealt_effect", t)
			end
		end
	end,
}
templates.zealot_melee_crits_reduce_damage_dealt_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_melee_crits_reduce_damage_dealt.duration,
	max_stacks = talent_settings.zealot_melee_crits_reduce_damage_dealt.max_stacks,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.zealot_melee_crits_reduce_damage_dealt.damage,
	},
}
templates.zealot_stamina_on_block_break = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_multihits_restore_stamina",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	cooldown_duration = talent_settings.zealot_stamina_on_block_break.cooldown_duration,
	conditional_keywords = {
		keywords.stun_immune_block_broken,
	},
	conditional_keywords_func = function (template_data, template_context)
		return template_context.active
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_events = {
		[proc_events.on_block] = 1,
	},
	check_proc_func = CheckProcFunctions.on_block_broken,
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, talent_settings.zealot_stamina_on_block_break.stamina)
	end,
}
templates.zealot_cooldown_based_on_health = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")

		local t = FixedFrame.get_latest_fixed_time()

		template_data.timer = t + 1
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		if t > template_data.timer then
			local cooldown = talent_settings_3.combat_ability_cd_restore_on_damage.cooldown_regen
			local health_percent = template_data.health_extension:current_health_percent()
			local multiplier = math.clamp((1 - health_percent) / (1 - talent_settings_3.combat_ability_cd_restore_on_damage.max_health), 0, 1)
			local value = cooldown * multiplier

			template_data.timer = template_data.timer + 1

			if value > 0 then
				template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", value)
			end
		end
	end,
}
templates.zealot_toughness_reduction_on_high_toughness = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_block_break_gives_tdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.zealot_toughness_reduction_on_high_toughness.tdr,
	},
	start_func = function (template_data, template_context)
		local toughness_extension = ScriptUnit.has_extension(template_context.unit, "toughness_system")

		template_data.toughness_extension = toughness_extension
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_toughness = template_data.toughness_extension:current_toughness_percent()

		return current_toughness > talent_settings.zealot_toughness_reduction_on_high_toughness.threshold
	end,
	related_talents = {
		"veteran_tdr_on_high_toughness",
	},
}
templates.zealot_sprint_improvements = {
	class_name = "proc_buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.sprinting_cost_multiplier] = talent_settings.zealot_sprint_improvements.sprint_cost,
		[stat_buffs.sprint_movement_speed] = talent_settings.zealot_sprint_improvements.sprint_speed,
	},
	proc_events = {
		[proc_events.on_sprint_started] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local buff_extension = template_data.buff_extension
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff("zealot_sprint_improvements_slowdown_immunity", t)
	end,
	related_talents = {
		"zealot_sprint_improvements",
	},
}
templates.zealot_push_attacks_attack_speed = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_cleave_impact_post_push",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = true,
	active_duration = talent_settings.zealot_push_attacks_attack_speed.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_push_finish] = 1,
		[proc_events.on_action_finish] = 1,
	},
	specific_check_proc_funcs = {
		on_hit = function (params, template_data, template_context, t)
			if template_data.valid then
				template_data.valid = false

				return true
			end
		end,
		on_sweep_start = function (params, template_data, template_context, t)
			if not template_data.action_complete then
				return false
			end

			template_data.action_complete = false
			template_data.valid = true

			return false
		end,
		on_sweep_finish = function (params, template_data, template_context, t)
			template_data.valid = false
		end,
		on_push_finish = function (params, template_data, template_context, t)
			template_data.push = true

			return false
		end,
		on_action_finish = function (params, template_data, template_context, t)
			if template_data.push then
				template_data.action_complete = params.reason == "new_interrupting_action"
			else
				template_data.action_complete = false
			end

			template_data.push = false

			return false
		end,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.zealot_push_attacks_attack_speed.melee_attack_speed,
	},
	related_talents = {
		"zealot_push_attacks_attack_speed",
	},
}
templates.zealot_stacking_rending = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			local kill = params.attack_result == attack_results.died

			if kill then
				template_data.kill = kill
			end
		end,
		on_sweep_finish = function (params, template_data, template_context, t)
			if template_data.kill then
				template_context.buff_extension:add_internally_controlled_buff_with_stacks("zealot_stacking_rending_buff", talent_settings.zealot_stacking_rending.stacks_gain, t)
			end

			template_data.kill = false
		end,
	},
}
templates.zealot_stacking_rending_buff = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_damage_boosts_movement",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			local kill = params.attack_result == attack_results.died

			if kill then
				template_data.kill = true
			else
				template_data.hit = true
			end
		end,
		on_sweep_finish = function (params, template_data, template_context, t)
			if not template_data.kill and template_data.hit then
				template_data.finish = true
			end

			template_data.hit = false
			template_data.kill = false
		end,
	},
	conditional_stack_exit_func = function (template_data, template_context)
		local finish = template_data.finish

		template_data.finish = false

		return finish and template_context.stack_count > 1
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish and template_context.stack_count <= 1
	end,
	stat_buffs = {
		[stat_buffs.melee_rending_multiplier] = talent_settings.zealot_stacking_rending.rending,
	},
	duration = talent_settings.zealot_stacking_rending.duration,
	max_stacks = talent_settings.zealot_stacking_rending.max_stacks,
	max_stacks_cap = talent_settings.zealot_stacking_rending.max_stacks,
}
templates.zealot_stealth_cooldown_regeneration = {
	class_name = "proc_buff",
	cooldown_duration = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if not attacked_unit then
			return
		end

		local buff_extension = template_context.buff_extension
		local has_stealth = buff_extension:has_unique_buff_id("zealot_invisibility")

		if not has_stealth then
			return
		end

		local attacked_unit_breed = Breed.unit_breed_or_nil(attacked_unit)
		local attacked_breed_tags = attacked_unit_breed and attacked_unit_breed.tags

		if not attacked_breed_tags then
			return
		end

		local cooldown_percent

		if attacked_breed_tags.monster then
			cooldown_percent = talent_settings.zealot_stealth_cooldown_regeneration.monster
		elseif attacked_breed_tags.ogryn then
			cooldown_percent = talent_settings.zealot_stealth_cooldown_regeneration.ogryn
		else
			cooldown_percent = talent_settings.zealot_stealth_cooldown_regeneration.other
		end

		local ability_extension = template_data.ability_extension

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_percent)
	end,
	related_talents = {
		"zealot_stealth_cooldown_regeneration",
	},
}
templates.zealot_sprint_angle_improvements = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = talent_settings.zealot_sprint_angle_improvements.sprint_dodge_reduce_angle_threshold_rad,
	},
	keywords = {
		keywords.sprint_dodge_in_overtime,
	},
	related_talents = {
		"zealot_sprint_angle_improvements",
	},
}
templates.zealot_suppress_on_backstab_kill = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_heavy_multihits_increase_melee_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	cooldown_duration = talent_settings.zealot_suppress_on_backstab_kill.cooldown_duration,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_heavy_hit, CheckProcFunctions.is_backstab),
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local from_position = POSITION_LOOKUP[unit]
		local relation = "enemy"
		local suppression_settings = talent_settings.zealot_suppress_on_backstab_kill.suppression

		Suppression.apply_area_minion_suppression(unit, suppression_settings, from_position, relation)
	end,
	related_talents = {
		"zealot_suppress_on_backstab_kill",
	},
}
templates.zealot_fotf_refund_cooldown = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_dash_increased_duration",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 4,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_fotf_refund_cooldown.duration,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_elite_or_special_kill),
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension then
			local restored_percentage = talent_settings.zealot_fotf_refund_cooldown.restored_percentage

			ability_extension:reduce_ability_cooldown_percentage("combat_ability", restored_percentage)

			template_data.remove_buff = true
		end
	end,
	conditional_exit_func = function (template_data)
		return template_data.remove_buff
	end,
	related_talents = {
		"zealot_fotf_refund_cooldown",
	},
}
templates.zealot_block_dodging_synergy = {
	class_name = "proc_buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension

		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff("zealot_on_perfect_blocking_block_dodging_synergy", t)
	end,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	specific_proc_func = {
		on_successful_dodge = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local buff_extension = template_data.buff_extension
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("zealot_on_dodge_block_dodging_synergy", t)
		end,
	},
	related_talents = {
		"zealot_block_dodging_synergy",
	},
}
templates.zealot_on_dodge_block_dodging_synergy = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_dodge_improvements",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_block_dodging_synergy.on_dodge_block_cost_multiplier_duration,
	stat_buffs = {
		[stat_buffs.block_cost_multiplier] = talent_settings.zealot_block_dodging_synergy.on_dodge_block_cost_multiplier,
	},
	related_talents = {
		"zealot_block_dodging_synergy",
	},
}
templates.zealot_on_perfect_blocking_block_dodging_synergy = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_dodge_improvements",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	cooldown_duration = talent_settings.zealot_block_dodging_synergy.on_perfect_blocking_cooldown,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	check_proc_func = CheckProcFunctions.can_restore_dodges,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
		local dodge_write_component = unit_data_extension:write_component("dodge_character_state")
		local num_effective_dodges = Dodge.num_effective_dodges(unit)
		local consecutive_dodges = dodge_write_component.consecutive_dodges
		local minimum_number_of_dodges = math.min(num_effective_dodges, consecutive_dodges)
		local number_of_restored_dodges = talent_settings.zealot_block_dodging_synergy.number_of_restored_dodges

		dodge_write_component.consecutive_dodges = math.max(0, minimum_number_of_dodges - number_of_restored_dodges)
	end,
}
templates.zealot_sprint_improvements_slowdown_immunity = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_improved_sprint",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_sprint_ended] = 1,
	},
	start_func = function (template_data, template_context)
		local gameplay_t = Managers.time:time("gameplay")

		template_data.starting_gameplay_t = gameplay_t
	end,
	proc_func = function (params, template_data, template_context)
		template_data.sprint_ended = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.sprint_ended
	end,
	conditional_keywords = {
		keywords.slowdown_immune,
	},
	conditional_keywords_func = function (template_data, template_context)
		local gameplay_t = Managers.time:time("gameplay")

		return gameplay_t >= template_data.starting_gameplay_t + talent_settings.zealot_sprint_improvements.slowdown_immune_start_t
	end,
}
templates.zealot_reload_from_backstab = {
	class_name = "proc_buff",
	predicted = false,
	max_stacks = talent_settings.zealot_reload_from_backstab.max_stacks,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_melee_kill, CheckProcFunctions.is_backstab),
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_reload_from_backstab_replenish_ammo", t)
	end,
	related_talents = {
		"zealot_reload_from_backstab",
	},
}
templates.zealot_reload_from_backstab_replenish_ammo = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_increased_reload_speed_on_melee_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	max_stacks = talent_settings.zealot_reload_from_backstab.max_stacks,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
	end,
	proc_func = function (params, template_data, template_context)
		local ammo_percentage_for_stack = talent_settings.zealot_reload_from_backstab.ammo_percentage_for_stack
		local total_ammo_percentage_to_restore = ammo_percentage_for_stack * template_context.stack_count
		local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
		local missing_ammo_in_clip = Ammo.missing_ammo_in_clips(inventory_slot_secondary_component)

		if missing_ammo_in_clip < 1 then
			return
		end

		local wanted_ammo = missing_ammo_in_clip * total_ammo_percentage_to_restore

		wanted_ammo = math.floor(wanted_ammo * 100) / 100
		wanted_ammo = math.ceil(wanted_ammo)

		Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, wanted_ammo)

		template_data.remove_buff = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.remove_buff
	end,
}
templates.zealot_backstab_allied_toughness = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_damage_boosts_movement",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		template_data.coherency_extension = coherency_extension
	end,
	check_proc_func = CheckProcFunctions.is_backstab,
	proc_func = function (params, template_data, template_context)
		local coherency_extension = template_data.coherency_extension
		local in_coherence_units = coherency_extension:in_coherence_units()

		for unit, _ in pairs(in_coherence_units) do
			if ALIVE[unit] then
				local buff_extension = ScriptUnit.extension(unit, "buff_system")

				if buff_extension then
					local t = FixedFrame.get_latest_fixed_time()

					buff_extension:add_internally_controlled_buff("zealot_backstab_allied_toughness_buff", t)
				end
			end
		end
	end,
	related_talents = {
		"zealot_backstab_allied_toughness",
	},
}
templates.zealot_backstab_allied_toughness_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_chastise_the_wicked",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_backstab_allied_toughness.duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = talent_settings.zealot_backstab_allied_toughness.toughness_damage_taken_modifier,
	},
	update_func = function (template_data, template_context, dt, t)
		local toughness = talent_settings.zealot_backstab_allied_toughness.toughness_replenish_percentage * dt

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
}

local corruption_taken_multiplier_per_stack = talent_settings.zealot_corruption_resistance_stacking.corruption_taken_multiplier_per_stack

templates.zealot_corruption_resistance_stacking = {
	class_name = "buff",
	hud_always_show = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_chastise_the_wicked",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	lerped_stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = {
			min = 1,
			max = martyrdom_max_stacks * corruption_taken_multiplier_per_stack,
		},
	},
	update_func = _martyrdom_update_func,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local missing_segments = _martyrdom_missing_health_segments(template_data)

		return math.clamp01(missing_segments / martyrdom_max_stacks)
	end,
	related_talents = {
		"zealot_corruption_resistance_stacking",
	},
}

local zealot_offensive_vs_many_max_stack = talent_settings.zealot_offensive_vs_many.max_stack

templates.zealot_offensive_vs_many = {
	class_name = "buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_damage_after_heavy_attack",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = zealot_offensive_vs_many_max_stack * talent_settings.zealot_offensive_vs_many.damage,
		},
		[stat_buffs.max_hit_mass_attack_modifier] = {
			min = 0,
			max = zealot_offensive_vs_many_max_stack * talent_settings.zealot_offensive_vs_many.cleave,
		},
	},
	visual_stack_count = function (template_data, template_context)
		return template_data.current_stacks
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.character_state_component = character_state_component

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}

		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.current_stacks = 0
		template_data.lerp_value = 0
		template_data.check_enemy_proximity_t = 0
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			return 0
		end

		local check_enemy_proximity_t = template_data.check_enemy_proximity_t

		if t < check_enemy_proximity_t then
			return template_data.lerp_value
		end

		template_data.check_enemy_proximity_t = t + 0.1

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local range = talent_settings.zealot_offensive_vs_many.range
		local num_hits = broadphase.query(broadphase, player_position, range, broadphase_results, enemy_side_names)
		local initial_number_of_enemies = talent_settings.zealot_offensive_vs_many.initial_number_of_enemies

		if initial_number_of_enemies <= num_hits then
			local remaining_enemies = num_hits - initial_number_of_enemies
			local additional_number_of_enemies = talent_settings.zealot_offensive_vs_many.additional_number_of_enemies
			local number_of_remaining_stacks = math.floor(remaining_enemies / additional_number_of_enemies)

			number_of_remaining_stacks = math.min(number_of_remaining_stacks + 1, zealot_offensive_vs_many_max_stack)
			template_data.current_stacks = number_of_remaining_stacks
		else
			template_data.current_stacks = 0
		end

		template_data.lerp_value = math.clamp01(template_data.current_stacks / talent_settings.zealot_offensive_vs_many.max_stack)

		return template_data.lerp_value
	end,
	related_talents = {
		"zealot_offensive_vs_many",
	},
}
templates.zealot_backstab_periodic_damage = {
	class_name = "proc_buff",
	hud_always_show = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_rend",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	cooldown_duration = talent_settings.zealot_backstab_periodic_damage.cooldown_duration,
	conditional_stat_buffs = {
		[stat_buffs.backstab_damage] = talent_settings.zealot_backstab_periodic_damage.backstab_damage,
	},
	keywords = {
		keywords.allow_backstabbing,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.is_damaging_backstab,
	proc_func = function (params, template_data, template_context)
		return
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_context.active
	end,
	related_talents = {
		"zealot_backstab_periodic_damage",
	},
}
templates.zealot_backstab_kills_while_loner_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
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
	end,
}
templates.zealot_coherency_toughness_damage_resistance = {
	class_name = "buff",
	coherency_id = "zelot_maniac_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_the_emperor_will",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coherency.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.coherency.toughness_damage_taken_multiplier,
	},
	related_talents = {
		"zealot_toughness_damage_coherency",
	},
}
templates.zealot_toughness_on_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.last_num_in_coherency = 0
		template_data.last_damage_recived = 0
		template_data.damage_to_take = 0
		template_data.damage_reduction = talent_settings_2.coherency.toughness_damage_taken_multiplier
		template_data.toughness_damage_reduced_percentage = (template_data.damage_reduction - 1) * -1
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
		local toughness_damage = toughness_extension:toughness_damage()

		template_data.damage_to_take = toughness_damage - template_data.last_damage_recived
		template_data.damage_to_take = template_data.damage_to_take * template_data.toughness_damage_reduced_percentage

		if template_data.damage_to_take >= 0 then
			local parent_buff_name = "zealot_toughness_damage_coherency"
			local hook_name = "hook_toughness_reduced_aura"

			template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(parent_buff_name, hook_name, template_data.damage_to_take)
			template_data.last_damage_recived = toughness_damage
		else
			template_data.last_damage_recived = 0
		end
	end,
}
templates.zealot_coherency_toughness_damage_resistance_improved = {
	class_name = "buff",
	coherency_id = "zelot_maniac_coherency_aura",
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_aura_the_emperor_demand",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.coop_2.toughness_damage_taken_multiplier,
	},
	related_talents = {
		"zealot_toughness_damage_reduction_coherency_improved",
	},
}
templates.zealot_improved_toughness_on_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.last_num_in_coherency = 0
		template_data.last_damage_recived = 0
		template_data.damage_to_take = 0
		template_data.damage_reduction = talent_settings_2.coop_2.toughness_damage_taken_multiplier
		template_data.toughness_damage_reduced_percentage = (template_data.damage_reduction - 1) * -1
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
		local toughness_damage = toughness_extension:toughness_damage()

		template_data.damage_to_take = toughness_damage - template_data.last_damage_recived
		template_data.damage_to_take = template_data.damage_to_take * template_data.toughness_damage_reduced_percentage

		if template_data.damage_to_take >= 0 then
			local parent_buff_name = "zealot_toughness_damage_reduction_coherency_improved"
			local hook_name = "hook_toughness_reduced_aura"

			template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(parent_buff_name, hook_name, template_data.damage_to_take)
			template_data.last_damage_recived = toughness_damage
		else
			template_data.last_damage_recived = 0
		end
	end,
}

local function _penance_start_func(buff_name)
	return function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

templates.zealot_stamina_cost_multiplier_aura = {
	class_name = "buff",
	coherency_id = "zealot_stamina_cost_multiplier_aura",
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_default_general_talent-1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coop_2.max_stacks,
	start_func = _penance_start_func("zealot_stamina_cost_multiplier_aura_tracking_buff"),
	stat_buffs = {
		[stat_buffs.stamina_cost_multiplier] = talent_settings.zealot_stamina_cost_multiplier_aura.stamina_cost_multiplier,
	},
	related_talents = {
		"zealot_toughness_damage_reduction_coherency_improved",
	},
}
templates.zealot_stamina_cost_multiplier_aura_tracking_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.hook_name = "hook_zealot_loner_aura"
		template_data.parent_buff_name = "zealot_stamina_cost_multiplier_aura"
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.parent_buff_name, template_data.hook_name)
	end,
}
templates.zealot_toughness_on_combat_ability = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
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
	end,
}
templates.zealot_resist_death = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_resist_death",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 2,
	predicted = false,
	active_duration = talent_settings_2.passive_2.active_duration,
	cooldown_duration = talent_settings_2.passive_2.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.passive_2.on_damage_taken_proc_chance,
	},
	off_cooldown_keywords = {
		BuffSettings.keywords.resist_death,
	},
	check_proc_func = CheckProcFunctions.would_die,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")

		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.ally_toughness_special_rule = talent_extension:has_special_rule(special_rules.zealot_toughness_on_resist_death)
		template_data.instant_ability = talent_extension:has_special_rule(special_rules.zealot_resist_death_instant_ability)
	end,
	proc_func = function (params, template_data, template_context)
		if template_data.instant_ability then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if ability_extension then
				local missing_ability_charges = ability_extension:missing_ability_charges("combat_ability", 1)

				if missing_ability_charges > 1 then
					ability_extension:restore_ability_charge("combat_ability", 1)
				else
					ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)
				end
			end
		end

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
			looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
			looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_invincibility",
			wwise_state = {
				group = "player_ability",
				off_state = "none",
				on_state = "zealot_maniac_resist_death",
			},
		},
	},
	related_talents = {
		"zealot_resist_death",
	},
}
templates.zealot_resist_death_improved_with_leech = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_resist_death_healing",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 2,
	predicted = false,
	active_duration = talent_settings_2.defensive_1.active_duration,
	cooldown_duration = talent_settings_2.defensive_1.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.defensive_1.on_damage_taken_proc_chance,
	},
	off_cooldown_keywords = {
		keywords.resist_death,
	},
	check_proc_func = CheckProcFunctions.would_die,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")

		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.ally_toughness_special_rule = talent_extension:has_special_rule(special_rules.zealot_toughness_on_resist_death)
		template_data.instant_ability = talent_extension:has_special_rule(special_rules.zealot_resist_death_instant_ability)
	end,
	proc_func = function (params, template_data, template_context)
		local buff_name = "zealot_resist_death_leech_effect"
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(buff_name, t)

		if template_data.instant_ability then
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if ability_extension then
				local missing_ability_charges = ability_extension:missing_ability_charges("combat_ability", 1)

				if missing_ability_charges > 1 then
					ability_extension:restore_ability_charge("combat_ability", 1)
				else
					ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)
				end
			end
		end

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
			looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
			looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_invincibility",
			wwise_state = {
				group = "player_ability",
				off_state = "none",
				on_state = "zealot_maniac_resist_death",
			},
		},
	},
	related_talents = {
		"zealot_resist_death_healing",
	},
}

local leech = talent_settings_2.defensive_1.leech
local melee_multiplier = talent_settings_2.defensive_1.melee_multiplier

templates.zealot_resist_death_leech_effect = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_damage_dealt] = talent_settings_2.defensive_1.on_hit_proc_chance,
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
	end,
}
templates.zealot_movement_enhanced = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_damage_boosts_movement",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = true,
	active_duration = talent_settings_2.defensive_2.active_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.defensive_2.on_damage_taken_proc_chance,
	},
	check_proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit
		local unit = template_context.unit

		return attacked_unit == unit
	end,
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_2.defensive_2.movement_speed,
	},
	keywords = {
		keywords.slowdown_immune,
		keywords.stun_immune,
	},
	related_talents = {
		"zealot_damage_boosts_movement",
	},
}

local num_slices = 10

templates.zealot_recuperate_a_portion_of_damage_taken = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_heal_part_of_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings_2.defensive_3.duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings_2.defensive_3.on_damage_taken_proc_chance,
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
				current_damage = 0,
				ticks = 0,
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
	end,
	related_talents = {
		"zealot_heal_part_of_damage_taken",
	},
}
templates.zealot_close_ranged_damage = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = talent_settings_2.offensive_2_1.damage,
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
	end,
}
templates.zealot_stacking_melee_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings_2.offensive_2_2.on_hit_proc_chance,
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
	end,
}
templates.zealot_stacking_melee_damage_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_hits_grant_stacking_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings_2.offensive_2_2.max_stacks,
	duration = talent_settings_2.offensive_2_2.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_2.offensive_2_2.melee_damage,
	},
	related_talents = {
		"zealot_hits_grant_stacking_damage",
	},
}

local external_properties = {}

templates.zealot_passive_replenish_throwing_knives_from_melee_kills = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
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
	end,
}
templates.zealot_throwing_knife_on_bleed_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = 0.15,
	},
	start_func = function (template_data, template_context)
		return
	end,
	proc_func = function (params, template_data, template_context)
		local killed_unit = params.dying_unit
		local killed_unit_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")
		local valid_target = killed_unit_buff_extension and (killed_unit_buff_extension:has_keyword(keywords.bleeding) or killed_unit_buff_extension:had_keyword(keywords.bleeding))

		if not valid_target then
			local own_unit = template_context.unit
			local attacking_unit = params.attacking_unit

			if own_unit == attacking_unit then
				local damage_type = params.damage_type

				valid_target = damage_type == damage_types.bleeding
			end
		end

		if valid_target then
			-- Nothing
		end
	end,
}
templates.zealot_combat_ability_crits_reduce_cooldown = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			if not template_data.active then
				return
			end

			if not CheckProcFunctions.on_melee_crit_hit(params, template_data, template_context) then
				return
			end

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

			template_data.active = false

			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("zealot_crits_cooldown_buff", t)
		end,
		on_sweep_start = function (params, template_data, template_context)
			template_data.active = true
		end,
	},
}
templates.zealot_crits_cooldown_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_grant_cd",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.crits_grants_cd.duration,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local fixed_t = FixedFrame.get_latest_fixed_time()

		template_data.timer = fixed_t + 1

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		if t > template_data.timer then
			template_data.timer = template_data.timer + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings.crits_grants_cd.cooldown_regen)
		end
	end,
	related_talents = {
		"zealot_crits_grant_cd",
	},
}
templates.zealot_combat_ability_weakspot_backstab_hit_cooldown = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		if not CheckProcFunctions.is_backstab(params, template_data, template_context) and not CheckProcFunctions.on_weakspot_hit(params, template_data, template_context) then
			return
		end

		local ability_extension = template_data.ability_extension
		local ability_type = "combat_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		template_context.buff_extension:add_internally_controlled_buff("zealot_weakspot_backstab_hit_cooldown_cooldown_buff", t)
	end,
}
templates.zealot_weakspot_backstab_hit_cooldown_cooldown_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_crits_grant_cd",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.zealot_combat_ability_weakspot_backstab_hit_cooldown.duration,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local fixed_t = FixedFrame.get_latest_fixed_time()

		template_data.timer = fixed_t + 1

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		if t > template_data.timer then
			template_data.timer = template_data.timer + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings.zealot_combat_ability_weakspot_backstab_hit_cooldown.cooldown)
		end
	end,
	related_talents = {
		"zealot_crits_grant_cd",
	},
}
templates.zealot_combat_ability_attack_speed_increase = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_chastise_the_wicked",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.combat_ability_2.active_duration + 1,
	proc_keywords = {
		keywords.zealot_maniac_empowered_martyrdom,
	},
	stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings_2.combat_ability_2.attack_speed,
	},
	related_talents = {
		"zealot_attack_speed_post_ability",
	},
}
templates.zealot_combat_ability_attack_speed_increased_duration = table.clone(templates.zealot_combat_ability_attack_speed_increase)
templates.zealot_combat_ability_attack_speed_increased_duration.duration = talent_settings.zealot_dash_increased_duration.duration + 1

local ALLOWED_INVISIBILITY_DAMAGE_TYPES = {
	[damage_types.bleeding] = true,
	[damage_types.burning] = true,
	[damage_types.grenade_frag] = true,
	[damage_types.plasma] = true,
	[damage_types.electrocution] = true,
}

templates.zealot_invisibility = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	duration = 3,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_stealth",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 4,
	predicted = true,
	unique_buff_id = "zealot_invisibility",
	keywords = {
		keywords.invisible,
		keywords.allow_backstabbing,
		keywords.allow_flanking,
	},
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.2,
		[stat_buffs.critical_strike_chance] = 1,
		[stat_buffs.finesse_modifier_bonus] = 1.5,
		[stat_buffs.backstab_damage] = 1.5,
		[stat_buffs.flanking_damage] = 1.5,
		[stat_buffs.melee_rending_multiplier] = 1,
	},
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_revive] = 1,
		[proc_events.on_rescue] = 1,
		[proc_events.on_pull_up] = 1,
		[proc_events.on_remove_net] = 1,
		[proc_events.on_action_start] = 1,
	},
	player_effects = {
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "zealot_invisible",
		},
		wwise_parameters = {
			player_zealot_invisible_effect = 1,
		},
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local damage = params.damage

		if template_data.exit_grace and t < template_data.exit_grace and (not damage or damage <= 0) then
			return
		end

		local buff_extension = template_context.buff_extension
		local can_attack_during_invisibility = not not buff_extension:has_keyword(keywords.can_attack_during_invisibility)
		local damage_type = params.damage_type

		if damage_type and (ALLOWED_INVISIBILITY_DAMAGE_TYPES[damage_type] or can_attack_during_invisibility) then
			return
		end

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

		local unit = template_context.unit
		local talent_extension = ScriptUnit.has_extension(unit, "talent_system")
		local zealot_leave_stealth_toughness_regen_talent = talent_extension and talent_extension:has_special_rule(special_rules.zealot_leave_stealth_toughness_regen)

		if zealot_leave_stealth_toughness_regen_talent then
			local toughness_to_restore = talent_settings.zealot_leave_stealth_toughness_regen.toughness_to_restore

			Toughness.replenish_percentage(template_context.unit, toughness_to_restore, false, "zealot_stealth")
		end
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.has_extension(unit, "talent_system")
		local zealot_leave_stealth_toughness_regen_talent = talent_extension and talent_extension:has_special_rule(special_rules.zealot_leave_stealth_toughness_regen)

		if zealot_leave_stealth_toughness_regen_talent then
			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("zealot_leaving_stealth_restores_toughness", t)
		end

		local zealot_increased_duration_talent = talent_extension and talent_extension:has_special_rule(special_rules.zealot_increased_duration)

		if zealot_increased_duration_talent then
			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("zealot_decrease_threat_increase_backstab_damage", t)
		end

		_shroudfield_penance_stop(template_data, template_context)
	end,
	related_talents = {
		"zealot_stealth",
	},
}
templates.zealot_invisibility_increased_duration = table.clone(templates.zealot_invisibility)
templates.zealot_invisibility_increased_duration.duration = talent_settings.zealot_increased_duration.duration
templates.zealot_sprinting_cost_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.sprinting_cost_multiplier] = 0.8,
	},
}
templates.zealot_backstab_damage = {
	class_name = "buff",
	coherency_id = "stab_guy_backstab_coherency_aura",
	coherency_priority = 1,
	predicted = false,
	keywords = {
		keywords.allow_backstabbing,
		keywords.allow_flanking,
	},
	stat_buffs = {
		[stat_buffs.backstab_damage] = 0.25,
		[stat_buffs.flanking_damage] = 0.25,
	},
}
templates.zealot_critstrike_damage_on_dodge = {
	active_duration = 3,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_increased_crit_and_weakspot_damage_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.5,
	},
	proc_effects = {
		player_effects = {
			wwise_proc_event = "wwise/events/player/play_player_buff_damage_increase",
		},
	},
	related_talents = {
		"zealot_increased_crit_and_weakspot_damage_after_dodge",
	},
}
templates.zealot_melee_damage_on_stamina_depleted = {
	active_duration = 5,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_more_damage_when_low_on_stamina",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	proc_events = {
		[proc_events.on_stamina_depleted] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = 0.2,
	},
	related_talents = {
		"zealot_more_damage_when_low_on_stamina",
	},
}
templates.zealot_more_power_when_low_on_stamina = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = talent_settings.zealot_more_damage_when_low_on_stamina.melee_damage,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local unit = template_context.unit
		local current_stamina, max_stamina = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local current_percent = current_stamina / max_stamina

		return 1 - current_percent
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_component = unit_data_extension:read_component("stamina")

		template_data.stamina_component = stamina_component

		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template

		local current_stamina, max_stamina = Stamina.current_and_max_value(unit, stamina_component, base_stamina_template)
	end,
	related_talents = {
		"psyker_warp_attacks_rending",
	},
}
templates.zealot_damage_reduction_after_dodge = {
	active_duration = 2.5,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_reduced_damage_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 0.75,
	},
	related_talents = {
		"zealot_reduced_damage_after_dodge",
	},
}
templates.zealot_increased_sprint_speed = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.sprint_dodge_in_overtime,
	},
	stat_buffs = {
		[stat_buffs.sprint_movement_speed] = 0.05,
	},
}

local damage_taken_to_ability_cd_percentage = talent_settings_3.combat_ability_cd_restore_on_damage.damage_taken_to_ability_cd_percentage

templates.zealot_ability_cooldown_on_heavy_melee_damage = {
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
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
	end,
}
templates.zealot_ability_cooldown_on_leaving_coherency = {
	class_name = "proc_buff",
	cooldown_duration = 15,
	predicted = true,
	proc_events = {
		[proc_events.on_coherency_exit] = 1,
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
	end,
}
templates.zealot_flanking_damage = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	keywords = {
		keywords.allow_flanking,
	},
	stat_buffs = {
		[stat_buffs.flanking_damage] = 0.3,
	},
}

local combat_ability_cd_restore_on_backstab = talent_settings_3.zealot_backstab_kills_restore_cd.combat_ability_cd_percentage

templates.zealot_ability_cooldown_on_leaving_coherency_on_backstab = {
	class_name = "proc_buff",
	cooldown_duration = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
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
	end,
}
templates.zealot_increase_ability_cooldown_increase_bonus = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_cooldown_flat_reduction] = -5,
	},
	conditional_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.5,
		[stat_buffs.backstab_damage] = 0.5,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local buff_extension = template_context.buff_extension
		local has_stealth = buff_extension:has_unique_buff_id("zealot_invisibility")

		template_data.has_stealth = has_stealth

		return has_stealth
	end,
	update_func = function (template_data, template_context, dt, t)
		local has_stealth = template_data.has_stealth

		if not has_stealth and template_data.had_stealth then
			template_context.buff_extension:add_internally_controlled_buff("zealot_stealth_improved_with_block", t)
		end

		template_data.had_stealth = has_stealth
	end,
}
templates.zealot_stealth_improved_with_block = {
	class_name = "buff",
	duration = 8,
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_reduced_damage_after_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.perfect_block_timing] = 0.2,
	},
	conditional_keywords = {
		keywords.block_unblockable,
		keywords.stun_immune_block_broken,
	},
	start_func = function (template_data, template_context)
		local unit_data = ScriptUnit.extension(template_context.unit, "unit_data_system")
		local block_component = unit_data:write_component("block")

		template_data.block_component = block_component
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.block_component.is_perfect_blocking
	end,
}

return templates
