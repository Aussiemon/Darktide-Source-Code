-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_broker_buff_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local minion_effects_priorities = BuffSettings.minion_effects_priorities
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local templates = {}

table.make_unique(templates)

local max_damage_gained_over_time_during_focus = HordesBuffsData.hordes_buff_broker_damage_increase_over_time_during_focus_stance.buff_stats.damage_increase.value
local time_needed_for_max_damage_during_focus = HordesBuffsData.hordes_buff_broker_damage_increase_over_time_during_focus_stance.buff_stats.time.value

templates.hordes_buff_broker_damage_increase_over_time_during_focus_stance = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	lerped_stat_buffs = {
		[stat_buffs.ranged_damage] = {
			min = 0,
			max = max_damage_gained_over_time_during_focus,
		},
	},
	start_func = function (template_data, template_context)
		template_data.lerp_t = 0
		template_data.focus_stance_start_time = nil
		template_data.is_in_focus_stance = false
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.lerp_t
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local buff_extension = template_context.buff_extension
		local is_in_focus_stance = buff_extension and buff_extension:has_keyword(buff_keywords.broker_combat_ability_focus) or false

		if not template_data.is_in_focus_stance and is_in_focus_stance then
			template_data.focus_stance_start_time = t
			template_data.is_in_focus_stance = true
		elseif template_data.is_in_focus_stance and not is_in_focus_stance then
			template_data.focus_stance_start_time = nil
			template_data.is_in_focus_stance = false
		end

		if not is_in_focus_stance then
			template_data.lerp_t = 0

			return
		end

		local time_in_stance = t - template_data.focus_stance_start_time
		local lerp_t = math.clamp01(time_in_stance / time_needed_for_max_damage_during_focus)

		template_data.lerp_t = lerp_t
	end,
}
templates.hordes_buff_broker_bleedfire_on_melee_hits_during_punk_rage = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = function (template_data, template_context)
		local buff_extension = template_context.buff_extension
		local is_using_punk_rage_ability = buff_extension and buff_extension:has_keyword(buff_keywords.broker_combat_ability_punk_rage)

		return is_using_punk_rage_ability
	end,
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacked_unit

		if HEALTH_ALIVE[target_unit] then
			local attacked_unit_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if attacked_unit_buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				attacked_unit_buff_extension:add_internally_controlled_buff("hordes_buff_bleeding_and_burning_on_melee_hit_ailment", t, "owner_unit", player_unit)
			end
		end
	end,
}

local percentage_health_regen_on_interval = HordesBuffsData.hordes_buff_broker_health_regen_during_punk_rage.buff_stats.hp_regen.value
local health_regen_interval = HordesBuffsData.hordes_buff_broker_health_regen_during_punk_rage.buff_stats.time.value

templates.hordes_buff_broker_health_regen_during_punk_rage = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local buff_extension = template_context.buff_extension
		local is_using_punk_rage_ability = buff_extension and buff_extension:has_keyword(buff_keywords.broker_combat_ability_punk_rage) or false

		return is_using_punk_rage_ability
	end,
	proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local health_extension = ScriptUnit.extension(player_unit, "health_system")

		if health_extension then
			local max_health = health_extension:max_health()
			local heal_amount = max_health * percentage_health_regen_on_interval
			local actual_healing_amount = health_extension:add_heal(heal_amount, DamageSettings.heal_types.buff)
			local healing_remaining = heal_amount - actual_healing_amount

			if healing_remaining > 0 then
				health_extension:add_heal(healing_remaining, DamageSettings.heal_types.buff_corruption_healing)
				health_extension:add_heal(healing_remaining, DamageSettings.heal_types.buff)
			end
		end
	end,
}
templates.hordes_buff_broker_stimm_field_shock_on_interval = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.broker_stimm_field_shocks_enemies_in_range,
	},
}
templates.hordes_buff_broker_missile_launcher_special_kill_restores_grenade = {
	active_duration = 3,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_buff_horde_broker_boom_bringer_restore_charge",
		},
	},
	start_func = function (template_data, template_context)
		template_data.last_grenade_kill_t = 0
		template_data.grenade_restored = false
		template_data.ability_extension = ScriptUnit.has_extension(template_context.unit, "ability_system")
		template_data.player_fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local target_breed_tags_or_nil = params.tags
		local target_is_special = target_breed_tags_or_nil and (target_breed_tags_or_nil.special or target_breed_tags_or_nil.elite) or false
		local is_missile_launcher_kill = params.damage_profile.name == "broker_missile_launcher_explosion_close" or params.damage_profile.name == "broker_missile_launcher_explosion" or params.damage_profile.name == "broker_missile_launcher_impact"

		return template_context.is_server and target_is_special and is_missile_launcher_kill
	end,
	proc_func = function (params, template_data, template_context, t)
		if t - template_data.last_grenade_kill_t > 1 then
			template_data.grenade_restored = false
		end

		template_data.last_grenade_kill_t = t

		if template_data.grenade_restored then
			return
		end

		local ability_extension = template_data.ability_extension

		if ability_extension and ability_extension:has_ability_type("grenade_ability") then
			ability_extension:restore_ability_charge("grenade_ability", 1)
		end

		template_data.grenade_restored = true
	end,
}

local self_propagating_toxin_duration = HordesBuffsData.hordes_buff_broker_tox_grenade_applies_self_propagating_toxin.buff_stats.time.value
local self_propagating_toxin_damage_template = DamageProfileTemplates.horde_mode_self_propagating_toxin
local self_propagating_toxin_damage_interval = 0.85

templates.hordes_buff_broker_tox_grenade_applies_self_propagating_toxin = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(player_unit)

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(player_unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local position = params.position:unbox()
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, position, 5, BROADPHASE_RESULTS, enemy_side_names)
		local t = FixedFrame.get_latest_fixed_time()

		for i = 1, num_hits do
			local victim_unit = BROADPHASE_RESULTS[i]
			local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")
			local has_toxin = victim_buff_extension and victim_buff_extension:has_buff_using_buff_template("hordes_buff_broker_self_propagating_toxin_debuff") or false

			if HEALTH_ALIVE[victim_unit] and not has_toxin then
				victim_buff_extension:add_internally_controlled_buff("hordes_buff_broker_self_propagating_toxin_debuff", t, "owner_unit", player_unit)
			end
		end
	end,
}
templates.hordes_buff_broker_self_propagating_toxin_debuff = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	duration = self_propagating_toxin_duration,
	keywords = {
		buff_keywords.toxin,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.owner_unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(player_unit)
		template_data.next_damage_t = FixedFrame.get_latest_fixed_time() + self_propagating_toxin_damage_interval
	end,
	proc_events = {
		[proc_events.on_death] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.owner_unit
		local position = params.position:unbox()
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, position, 2, BROADPHASE_RESULTS, enemy_side_names)
		local t = FixedFrame.get_latest_fixed_time()

		for i = 1, num_hits do
			local victim_unit = BROADPHASE_RESULTS[i]
			local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")
			local has_toxin = victim_buff_extension and victim_buff_extension:has_buff_using_buff_template("hordes_buff_broker_self_propagating_toxin_debuff") or false

			if HEALTH_ALIVE[victim_unit] and not has_toxin then
				victim_buff_extension:add_internally_controlled_buff("hordes_buff_broker_self_propagating_toxin_debuff", t, "owner_unit", player_unit)
			end
		end
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server or t < template_data.next_damage_t then
			return
		end

		template_data.next_damage_t = t + self_propagating_toxin_damage_interval

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = self_propagating_toxin_damage_template
			local power_level = 500
			local owner_unit = template_context.is_server and template_context.owner_unit
			local source_item = template_context.is_server and template_context.source_item

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.burning, "attacking_unit", owner_unit, "item", source_item, "attack_type", attack_types.buff)
		end
	end,
	minion_effects = minion_burning_buff_effects.chemfire,
}

local percent_damage_taken_increase_after_flash_grenade = HordesBuffsData.hordes_buff_broker_flash_grenade_increase_damage_taken.buff_stats.damage_taken.value
local duration_damage_taken_increase_after_flash_grenade = HordesBuffsData.hordes_buff_broker_flash_grenade_increase_damage_taken.buff_stats.time.value

templates.hordes_buff_broker_flash_grenade_increase_damage_taken = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and (params.damage_profile and params.damage_profile.name == "broker_flash_grenade" or params.damage_profile.name == "broker_flash_grenade_close")
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_broker_flash_grenade_increase_damage_taken_effect", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_broker_flash_grenade_increase_damage_taken_effect = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	duration = duration_damage_taken_increase_after_flash_grenade,
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = percent_damage_taken_increase_after_flash_grenade,
	},
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.player_effects,
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					material_emission = false,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_horde_broker_flash_grenade",
					stop_type = "stop",
				},
				sfx = {
					looping_wwise_start_event = "wwise/events/player/play_horde_mode_buff_enemy_blind_loop",
					looping_wwise_stop_event = "wwise/events/player/stop_horde_mode_buff_enemy_blind_loop",
				},
			},
		},
	},
}

return templates
