-- chunkname: @scripts/settings/buff/archetype_buff_templates/adamant_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local CoherencyUtils = require("scripts/extension_systems/coherency/coherency_utils")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local MinionState = require("scripts/utilities/minion_state")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushAttack = require("scripts/utilities/attack/push_attack")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local aggro_states = PerceptionSettings.aggro_states
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local stagger_results = AttackSettings.stagger_results
local buff_categories = BuffSettings.buff_categories
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local slot_configuration = PlayerCharacterConstants.slot_configuration
local special_rules = SpecialRulesSettings.special_rules
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.adamant
local templates = {}

table.make_unique(templates)

local function _penance_start_func(buff_name)
	return function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

templates.adamant_companion_damage_per_level = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.companion_damage_multiplier] = {
			max = 2,
			min = 1,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local player = unit and Managers.state.player_unit_spawn:owner(unit)
		local profile = player:profile()
		local level = profile and profile.current_level or 1
		local fifth_level = math.floor(level / 5)
		local lerp_value = fifth_level / 6

		template_data.lerp_value = lerp_value
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.lerp_value
	end,
}
templates.adamant_charge_passive_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_lunge_end] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("adamant_post_charge_buff", t)
	end,
}
templates.adamant_post_charge_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_lunge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_adamant_charge_02",
	},
	duration = talent_settings.combat_ability.charge.duration,
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings.combat_ability.charge.impact,
		[stat_buffs.damage] = talent_settings.combat_ability.charge.damage,
	},
	related_talents = {
		"adamant_charge",
	},
}
templates.adamant_charge_cooldown_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_lunge_end] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.cooldown = 0
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			local damage_profile_name = params.damage_profile and params.damage_profile.name

			if damage_profile_name ~= "adamant_charge_impact" then
				return
			end

			local elite = params.tags.elite or params.tags.special or params.tags.monster
			local time = elite and talent_settings.combat_ability.charge.cooldown_elite or talent_settings.combat_ability.charge.cooldown_reduction

			template_data.cooldown = template_data.cooldown + time
		end,
		on_lunge_end = function (params, template_data, template_context, t)
			local cooldown_time = math.min(template_data.cooldown, talent_settings.combat_ability.charge.cooldown_max)

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_time)
		end,
	},
}

local _adamant_toughness_hits = {}

templates.adamant_charge_toughness_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_lunge_end] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.hits = 0
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			local damage_profile_name = params.damage_profile and params.damage_profile.name

			if damage_profile_name ~= "adamant_charge_impact" then
				return
			end

			local elite = params.tags.elite or params.tags.special or params.tags.monster

			if not elite then
				return
			end

			local attacked_unit = params.attacked_unit

			if _adamant_toughness_hits[attacked_unit] then
				return
			end

			_adamant_toughness_hits[attacked_unit] = true
			template_data.hits = template_data.hits + 1
		end,
		on_lunge_end = function (params, template_data, template_context, t)
			local toughness = talent_settings.combat_ability.charge.toughness * template_data.hits

			toughness = math.min(toughness, talent_settings.combat_ability.charge.toughness_max)

			Toughness.replenish_percentage(template_context.unit, toughness)

			local stamina = talent_settings.combat_ability.charge.stamina * template_data.hits

			stamina = math.min(stamina, talent_settings.combat_ability.charge.stamina_max)

			Stamina.add_stamina_percent(template_context.unit, stamina)

			template_data.hits = 0

			table.clear(_adamant_toughness_hits)
		end,
	},
}
templates.adamant_charge_increased_distance = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.lunge_distance] = talent_settings.combat_ability.charge.distance_increase,
	},
}
templates.adamant_grenade_radius_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier_frag] = talent_settings.blitz_ability.grenade.radius_increase,
	},
}
templates.adamant_grenade_damage_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.frag_damage] = talent_settings.blitz_ability.grenade.damage_increase,
	},
}

local external_properties = {}

templates.adamant_whistle_replenishment = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_whistle_improved",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	hud_priority = 4,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0

		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff("adamant_whistle_explosion_stagger_tracking_buff", t)
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
			template_data.next_charge_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_charge_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_charge_t = template_data.next_charge_t

		if not next_charge_t then
			local cooldown = ability_extension:max_ability_cooldown("grenade_ability")

			template_data.next_charge_t = t + cooldown
			template_data.cooldown = cooldown

			return
		end

		if next_charge_t < t then
			template_data.next_charge_t = nil

			local first_person_extension = template_data.first_person_extension

			if first_person_extension and first_person_extension:is_in_first_person_mode() and missing_charges == 1 then
				external_properties.indicator_type = "psyker_throwing_knives"

				template_data.fx_extension:trigger_gear_wwise_event("charge_ready_indicator", external_properties)
			end
		end
	end,
	check_active_func = function (template_data, template_context)
		local is_missing_charges = template_data.missing_charges > 0

		return is_missing_charges
	end,
	duration_func = function (template_data, template_context)
		local next_charge_t = template_data.next_charge_t

		if not next_charge_t then
			return 1
		end

		local t = FixedFrame.get_latest_fixed_time()
		local time_until_next = next_charge_t - t
		local percentage_left = time_until_next / template_data.cooldown

		return 1 - percentage_left
	end,
	related_talents = {
		"adamant_whistle",
	},
}
templates.adamant_whistle_explosion_stagger_tracking_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local damage_profile = params.damage_profile
		local is_whistle_explosion_hit = damage_profile.name == "close_whistle_explosion" or damage_profile.name == "whistle_explosion"
		local staggered_enemy = params.stagger_result == "stagger"
		local target_is_monster = params.tags.monster

		return template_context.is_server and target_is_monster and staggered_enemy and is_whistle_explosion_hit
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		Managers.stats:record_private("hook_adamant_whistle_explosion_stagger_monster", template_context.player)
	end,
}

local target_num_enemies_killed_from_grenade = 3

templates.adamant_grenade_cluster_kills_tracking_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.last_grenade_kill_t = 0
		template_data.num_enemies_killed_in_cluster = 0
		template_data.recorded_cluster = false
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local is_grenade_kill = params.damage_profile.name == "close_adamant_grenade" or params.damage_profile.name == "adamant_grenade"

		return template_context.is_server and is_grenade_kill
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		if t - template_data.last_grenade_kill_t > 0.25 then
			template_data.num_enemies_killed_in_cluster = 0
			template_data.recorded_cluster = false
		end

		template_data.last_grenade_kill_t = t
		template_data.num_enemies_killed_in_cluster = template_data.num_enemies_killed_in_cluster + 1

		if not template_data.recorded_cluster and template_data.num_enemies_killed_in_cluster >= target_num_enemies_killed_from_grenade then
			Managers.stats:record_private("hook_adamant_killed_cluster_of_enemies_with_grenade", template_context.player)

			template_data.recorded_cluster = true
		end
	end,
}
templates.adamant_drone_base_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_nuncio_aquila",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	update_func = function (template_data, template_context, dt, t)
		local toughness = talent_settings.blitz_ability.drone.toughness * dt

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_adamant_drone_buff",
	},
}
templates.adamant_drone_improved_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_nuncio_aquila",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	keywords = {
		keywords.suppression_immune,
		keywords.slowdown_immune,
		keywords.ranged_alternate_fire_interrupt_immune,
	},
	stat_buffs = {
		[stat_buffs.suppression_dealt] = talent_settings.blitz_ability.drone.suppression,
		[stat_buffs.impact_modifier] = talent_settings.blitz_ability.drone.impact,
		[stat_buffs.recoil_modifier] = talent_settings.blitz_ability.drone.recoil_modifier,
	},
	update_func = function (template_data, template_context, dt, t)
		local toughness = talent_settings.blitz_ability.drone.toughness_improved * dt

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_adamant_drone_buff",
	},
}
templates.adamant_drone_talent_buff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.blitz_ability.drone.tdr,
		[stat_buffs.revive_speed_modifier] = talent_settings.blitz_ability.drone.revive_speed_modifier,
		[stat_buffs.attack_speed] = talent_settings.blitz_ability.drone.attack_speed,
	},
}
templates.adamant_drone_enemy_debuff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.blitz_ability.drone.damage_taken,
	},
}
templates.adamant_drone_talent_debuff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.blitz_ability.drone.enemy_melee_attack_speed,
		[stat_buffs.melee_damage] = talent_settings.blitz_ability.drone.enemy_melee_damage,
	},
}
templates.adamant_reload_speed_aura = {
	class_name = "buff",
	coherency_id = "adamant_reload_speed_coherency",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_wield_speed_aura",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.coherency.reload_speed_aura.reload_speed,
	},
	start_func = _penance_start_func("adamant_wield_speed_aura_tracking_buff"),
	related_talents = {
		"adamant_reload_speed_aura",
	},
}
templates.adamant_wield_speed_aura_tracking_buff = {
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
		template_data.hook_name = "hook_adamant_wield_speed_aura_kill"
		template_data.parent_buff_name = "adamant_reload_speed_aura"
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.parent_buff_name, template_data.hook_name)
	end,
}
templates.adamant_companion_aura_base = {
	class_name = "buff",
	coherency_id = "adamant_companion_coherency",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_companion_coherency",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	related_talents = {
		"adamant_companion_coherency",
	},
}
templates.adamant_companion_aura = {
	class_name = "buff",
	coherency_id = "adamant_companion_coherency",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_companion_coherency",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = talent_settings.coherency.companion.tdr,
	},
	related_talents = {
		"adamant_companion_coherency",
	},
}
templates.adamant_damage_vs_staggered_aura = {
	class_name = "buff",
	coherency_id = "adamant_damage_vs_staggered_coherency",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_damage_vs_suppressed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	stat_buffs = {
		[stat_buffs.damage_vs_staggered] = talent_settings.coherency.adamant_damage_vs_staggered_aura.damage_vs_staggered,
	},
	start_func = _penance_start_func("adamant_damage_vs_staggered_aura_tracking_buff"),
	related_talents = {
		"adamant_damage_vs_staggered_aura",
	},
}
templates.adamant_damage_vs_staggered_aura_tracking_buff = {
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
		template_data.hook_name = "hook_adamant_staggered_enemy_aura_kill"
		template_data.parent_buff_name = "adamant_damage_vs_staggered_aura"
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		return CheckProcFunctions.on_staggered_kill(params, template_data, template_context, t)
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.last_num_in_coherency = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.parent_buff_name, template_data.hook_name)
	end,
}
templates.adamant_companion_counts_for_coherency = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_player_companion_spawn] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.coherency_system = Managers.state.extension:system("coherency_system")
	end,
	check_proc_func = function (params, template_data, template_context)
		local is_companion_ours = params.owner_unit and params.owner_unit == template_context.unit
		local is_arbites_companion_dog = params.companion_breed == "companion_dog"

		return is_companion_ours and is_arbites_companion_dog
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local spawned_companion_unit = params.companion_unit

		template_data.coherency_buff_index = template_data.coherency_system:add_external_buff(spawned_companion_unit, "adamant_companion_coherency_tracking_buff")
		template_data.companion_unit = params.companion_unit
	end,
	stop_func = function (template_data, template_context)
		local companion_unit = template_data.companion_unit

		if ALIVE[companion_unit] and template_data.coherency_buff_index then
			template_data.coherency_system:remove_external_buff(companion_unit, template_data.coherency_buff_index)
		end
	end,
	related_talents = {
		"adamant_companion_coherency",
	},
}
templates.adamant_no_companion_coherency = {
	class_name = "buff",
	predicted = false,
}
templates.adamant_companion_coherency_tracking_buff = {
	class_name = "proc_buff",
	coherency_id = "adamant_companion_coherency_tracking_buff",
	coherency_priority = 2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.hook_name = "hook_adamant_companion_coherency_aura_kill"
		template_data.parent_talent_name = "adamant_companion_coherency"
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local units_in_coherency = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, coherency_extension in pairs(units_in_coherency) do
			local unit_data_extension = ScriptUnit.extension(coherency_unit, "unit_data_system")
			local breed = unit_data_extension and unit_data_extension:breed()

			if breed.name == "companion_dog" then
				local owner_player = Managers.state.player_unit_spawn:owner(coherency_unit)
				local player_unit = owner_player and owner_player.player_unit
				local talent_extension = player_unit and ScriptUnit.has_extension(player_unit, "talent_system")
				local player_current_talents = talent_extension and talent_extension:talents()

				if player_current_talents and player_current_talents[template_data.parent_talent_name] then
					Managers.stats:record_private(template_data.hook_name, owner_player)
				end
			end
		end
	end,
}
templates.adamant_hunt_stance = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_stance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	predicted = false,
	unique_buff_id = "adamant_hunt_stance",
	duration = talent_settings.combat_ability.stance.duration,
	player_effects = {
		looping_wwise_start_event = "wwise/events/player/play_player_ability_adamant_damage_on",
		looping_wwise_stop_event = "wwise/events/player/play_player_ability_adamant_damage_off",
		on_screen_effect = "content/fx/particles/screenspace/screen_adamant_ability_stance",
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "ogryn_stance",
		},
	},
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.combat_ability.stance.movement_speed,
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = talent_settings.combat_ability.stance.movement_speed_reduction_multiplier,
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = talent_settings.combat_ability.stance.movement_speed_reduction_multiplier,
		[stat_buffs.damage_taken_multiplier] = talent_settings.combat_ability.stance.damage_taken_multiplier,
	},
	keywords = {
		keywords.no_sprint,
		keywords.adamant_hunt_stance,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		template_data.ability_extension = ability_extension

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		template_data.visual_loadout_extension = visual_loadout_extension

		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.damage_talent = talent_extension:has_special_rule(special_rules.adamant_stance_elite_kills_stack_damage)
		template_data.ammo_talent = talent_extension:has_special_rule(special_rules.adamant_stance_ammo_from_reserve)
		template_data.next_ammo_t = 0
	end,
	proc_func = function (params, template_data, template_context, t)
		if CheckProcFunctions.on_ranged_hit(params, template_data, template_context) and template_data.ammo_talent and t >= template_data.next_ammo_t then
			local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
			local max_ammo_in_clip = inventory_slot_secondary_component.max_ammunition_clip
			local current_ammo_in_clip = inventory_slot_secondary_component.current_ammunition_clip
			local missing_ammo_in_clip = max_ammo_in_clip - current_ammo_in_clip
			local ammo_replenish_percent = talent_settings.combat_ability.stance.ammo_percent
			local wanted_ammo = math.ceil(max_ammo_in_clip * ammo_replenish_percent)
			local amount = math.min(wanted_ammo, missing_ammo_in_clip)

			Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, amount)

			local weapon_template = template_data.visual_loadout_extension:weapon_template_from_slot("slot_secondary")
			local reload_template = weapon_template.reload_template

			if reload_template then
				ReloadStates.reset(reload_template, inventory_slot_secondary_component)
			end

			template_data.next_ammo_t = t + talent_settings.combat_ability.stance.ammo_icd
		end

		if template_data.damage_talent and CheckProcFunctions.on_elite_or_special_kill(params, template_data, template_context) then
			template_context.buff_extension:add_internally_controlled_buff("adamant_hunt_stance_damage", t)
		end
	end,
	stop_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_context.buff_extension:add_internally_controlled_buff("adamant_hunt_stance_linger_dr", t)
	end,
	related_talents = {
		"adamant_stance",
	},
}
templates.adamant_hunt_stance_linger_dr = {
	class_name = "buff",
	predicted = false,
	duration = talent_settings.combat_ability.stance.linger_time,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.combat_ability.stance.damage_taken_multiplier,
	},
	related_talents = {
		"adamant_stance",
	},
}
templates.adamant_hunt_stance_damage = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_verispex",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.combat_ability.stance.damage_talent_stacks,
	duration = talent_settings.combat_ability.stance.damage_talent_duration,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.combat_ability.stance.damage_talent_damage,
	},
	related_talents = {
		"adamant_stance_elite_kills_stack_damage",
	},
}
templates.adamant_hunt_stance_dog_bloodlust = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	active_duration = talent_settings.combat_ability.stance.duration,
	proc_keywords = {
		keywords.adamant_dog_bloodlust,
	},
	proc_stat_buffs = {
		[stat_buffs.companion_damage_modifier] = talent_settings.combat_ability.stance.companion_damage,
	},
}

function _adamant_mark_enemies_select_unit(template_data, template_context, last_unit_pos, t)
	local player_unit = template_context.unit
	local player_rotation = template_data.first_person_component.rotation
	local player_horizontal_look_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(player_rotation)))
	local player_position = POSITION_LOOKUP[player_unit]
	local broadphase_distance = template_data.distance

	for marked_unit, t in pairs(template_data.targets) do
		if not ALIVE[marked_unit] then
			template_data.targets[marked_unit] = nil
		else
			local marked_unit_position = POSITION_LOOKUP[marked_unit]
			local distance_sq = Vector3.distance_squared(player_position, marked_unit_position)
			local check_distance = broadphase_distance * broadphase_distance

			if check_distance < distance_sq then
				local direction_to_player = Vector3.normalize(marked_unit_position - player_position)
				local dot = Vector3.dot(player_horizontal_look_direction, direction_to_player)

				if dot < 0 then
					local target_blackboard = BLACKBOARDS[marked_unit]
					local aggro_state = target_blackboard.perception.aggro_state

					if aggro_state ~= PerceptionSettings.aggro_states.aggroed then
						local unit_id = Managers.state.unit_spawner:game_object_id(marked_unit)
						local outline_name = "adamant_mark_target"
						local outline_id = NetworkLookup.outline_types[outline_name]
						local channel_id = template_context.player:channel_id()

						if channel_id and unit_id then
							RPC.rpc_remove_outline_from_unit(channel_id, unit_id, outline_id)
						end

						if not DEDICATED_SERVER then
							local outline_system = Managers.state.extension:system("outline_system")

							outline_system:remove_outline(marked_unit, outline_name)
						end

						template_data.targets[marked_unit] = nil

						break
					end
				end
			end
		end
	end

	local broadphase = template_data.broadphase
	local enemy_side_names = template_data.enemy_side_names
	local broadphase_results = template_data.broadphase_results

	table.clear(broadphase_results)

	local num_results = broadphase.query(broadphase, player_position, broadphase_distance, broadphase_results, enemy_side_names)
	local chosen_unit
	local chosen_distance = math.huge

	for i = 1, num_results do
		local enemy_unit = broadphase_results[i]

		if HEALTH_ALIVE[enemy_unit] and not template_data.targets[enemy_unit] then
			local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local tags = breed.tags
			local instant_type = tags.monster or tags.captain or tags.cultist_captain
			local valid_breed = tags.elite or tags.special

			if instant_type or valid_breed and t > template_data.next_t then
				local enemy_pos = POSITION_LOOKUP[enemy_unit]
				local direction_to_player = Vector3.normalize(enemy_pos - player_position)
				local dot = Vector3.dot(player_horizontal_look_direction, direction_to_player)

				if dot > 0.5 then
					local perception_extension = ScriptUnit.has_extension(enemy_unit, "perception_system")
					local has_line_of_sight = perception_extension and perception_extension:has_line_of_sight(player_unit)

					if has_line_of_sight then
						local distance_to_unit = Vector3.distance_squared(enemy_pos, player_position)

						if distance_to_unit < chosen_distance then
							chosen_distance = distance_to_unit
							chosen_unit = enemy_unit

							break
						end
					end
				end
			end
		end
	end

	if chosen_unit then
		local unit_id = Managers.state.unit_spawner:game_object_id(chosen_unit)
		local outline_name = "adamant_mark_target"
		local outline_id = NetworkLookup.outline_types[outline_name]
		local channel_id = template_context.player:channel_id()

		if channel_id and unit_id then
			RPC.rpc_add_outline_to_unit(channel_id, unit_id, outline_id)
		end

		if not DEDICATED_SERVER then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:add_outline(chosen_unit, outline_name)
		end

		template_data.next_t = t + talent_settings.execution_order.target_time
		template_data.targets[chosen_unit] = t
	end
end

local function _execution_order_proc(template_data, template_context, t)
	template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_buff", t)
	template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_companion_buff", t)
	Toughness.replenish_percentage(template_context.unit, talent_settings.execution_order.toughness, false, "execution_order")

	if template_data.adamant_execution_order_crit then
		template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_crit", t)
	end

	if template_data.adamant_execution_order_cdr then
		template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_cdr", t)
	end

	if template_data.adamant_execution_order_rending then
		template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_rending", t)
	end

	if template_data.adamant_execution_order_permastack then
		template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_permastack", t)
	end

	if template_data.adamant_execution_order_ally_toughness then
		local units_in_coherency = template_data.coherency_extension:in_coherence_units()
		local toughness_to_restore = talent_settings.execution_order.ally_toughness

		for unit, _ in pairs(units_in_coherency) do
			if unit ~= template_context.unit then
				Toughness.replenish_flat(unit, toughness_to_restore, false, "execution_order_ally_toughness")
			end
		end
	end
end

templates.adamant_execution_order = {
	class_name = "proc_buff",
	hide_in_hud = true,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local template = template_context.template

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		template_data.targets = {}

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.first_person_component = unit_data_extension:read_component("first_person")

		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension

		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")

		template_data.coherency_extension = coherency_extension
		template_data.mark_bonus_buff = "adamant_mark_enemies_passive_bonus_stacking"
		template_data.distance = 40
		template_data.next_t = 0

		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local adamant_execution_order_crit = special_rules.adamant_execution_order_crit
		local adamant_execution_order_cdr = special_rules.adamant_execution_order_cdr
		local adamant_execution_order_rending = special_rules.adamant_execution_order_rending
		local adamant_execution_order_permastack = special_rules.adamant_execution_order_permastack
		local adamant_execution_order_monster_debuff = special_rules.adamant_execution_order_monster_debuff
		local adamant_execution_order_ally_toughness = special_rules.adamant_execution_order_ally_toughness

		template_data.adamant_execution_order_crit = talent_extension:has_special_rule(adamant_execution_order_crit)
		template_data.adamant_execution_order_cdr = talent_extension:has_special_rule(adamant_execution_order_cdr)
		template_data.adamant_execution_order_rending = talent_extension:has_special_rule(adamant_execution_order_rending)
		template_data.adamant_execution_order_permastack = talent_extension:has_special_rule(adamant_execution_order_permastack)
		template_data.adamant_execution_order_monster_debuff = talent_extension:has_special_rule(adamant_execution_order_monster_debuff)
		template_data.adamant_execution_order_ally_toughness = talent_extension:has_special_rule(adamant_execution_order_ally_toughness)
	end,
	update_func = function (template_data, template_context, dt, t)
		_adamant_mark_enemies_select_unit(template_data, template_context, nil, t)
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			local victim_unit = params.attacked_unit
			local kill = params.attack_result == attack_results.died

			if kill then
				if not template_data.targets[victim_unit] then
					return
				end

				_execution_order_proc(template_data, template_context, t)

				template_data.targets[victim_unit] = nil

				if template_context.player then
					Managers.stats:record_private("hook_adamant_killed_enemy_marked_by_execution_order", template_context.player)
				end
			elseif CheckProcFunctions.attacker_is_my_companion(params, template_data, template_context) then
				if template_data.targets[victim_unit] then
					local pounce = params.damage_profile and params.damage_profile.initial_pounce

					if pounce then
						template_context.buff_extension:add_internally_controlled_buff("adamant_execution_order_companion_buff", t)
					end
				end

				if template_data.adamant_execution_order_monster_debuff then
					local tags = params.tags

					if tags.monster then
						local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

						if buff_extension then
							buff_extension:add_internally_controlled_buff("adamant_execution_order_monster_debuff", t)
						end
					end
				end
			end
		end,
		on_minion_death = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			if not template_data.adamant_execution_order_ally_toughness then
				return
			end

			local attacker_unit = params.attacking_unit

			if attacker_unit == template_context.unit then
				return
			end

			local victim_unit = params.dying_unit

			if not template_data.targets[victim_unit] then
				return
			end

			local in_coherency = template_data.coherency_extension:is_unit_in_coherency(attacker_unit)

			if not in_coherency then
				return
			end

			_execution_order_proc(template_data, template_context, t)

			template_data.targets[victim_unit] = nil
		end,
	},
}
templates.adamant_execution_order_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_exterminator",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.execution_order.time,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.execution_order.damage,
		[stat_buffs.attack_speed] = talent_settings.execution_order.attack_speed,
	},
}
templates.adamant_execution_order_companion_buff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.execution_order.time,
	stat_buffs = {
		[stat_buffs.companion_damage_modifier] = talent_settings.execution_order.companion_damage,
	},
}
templates.adamant_execution_order_crit = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.execution_order.time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.execution_order.crit_chance,
		[stat_buffs.critical_strike_damage] = talent_settings.execution_order.crit_damage,
	},
	related_talents = {
		"adamant_execution_order_crit",
	},
}
templates.adamant_execution_order_rending = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.execution_order.time,
	stat_buffs = {
		[stat_buffs.rending_multiplier] = talent_settings.execution_order.rending,
	},
	related_talents = {
		"adamant_execution_order_rending",
	},
}
templates.adamant_execution_order_cdr = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.execution_order.time,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		if not template_data.timer then
			template_data.timer = t + 1
		end

		if t > template_data.timer then
			template_data.timer = t + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings.execution_order.cdr)
		end
	end,
	related_talents = {
		"adamant_execution_order_cdr",
	},
}
templates.adamant_execution_order_permastack = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_exterminator_boss_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	max_stacks = talent_settings.execution_order.perma_max_stack,
	stat_buffs = {
		[stat_buffs.damage_vs_monsters] = talent_settings.execution_order.damage_vs_monsters,
		[stat_buffs.monster_damage_taken_multiplier] = talent_settings.execution_order.damage_taken_vs_monsters,
	},
	related_talents = {
		"adamant_execution_order_permastack",
	},
}
templates.adamant_execution_order_monster_debuff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.execution_order.monster_damage,
	},
}
templates.adamant_forceful = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_block] = 1,
		[proc_events.on_player_hit_received] = 1,
	},
	start_func = function (template_data, template_context)
		return
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if params.target_number > 1 then
				return
			end

			if CheckProcFunctions.attacker_is_my_companion(params, template_data, template_context) then
				return
			end

			if CheckProcFunctions.on_staggering_hit(params, template_data, template_context, t) then
				template_context.buff_extension:add_internally_controlled_buff("adamant_forceful_stacks", t)
			end
		end,
		on_block = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff("adamant_forceful_stacks", t)
		end,
	},
}
templates.adamant_forceful_stacks = {
	always_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_forceful",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.forceful.stack_duration,
	max_stacks = talent_settings.forceful.stacks,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
		[proc_events.on_combat_ability] = 1,
	},
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings.forceful.impact,
		[stat_buffs.damage_taken_multiplier] = talent_settings.forceful.dr,
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_attack_speed] = talent_settings.forceful.ranged_attack_speed,
		[stat_buffs.reload_speed] = talent_settings.forceful.reload_speed,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local stun_immune = special_rules.adamant_forceful_stun_immune
		local offensive = special_rules.adamant_forceful_offensive
		local ability_strength = special_rules.adamant_forceful_ability_strength
		local ranged_rule = special_rules.adamant_forceful_ranged
		local toughness_rule = special_rules.adamant_forceful_toughness_regen

		template_data.stun_immune = talent_extension:has_special_rule(stun_immune)
		template_data.offensive = talent_extension:has_special_rule(offensive)
		template_data.ability_strength = talent_extension:has_special_rule(ability_strength)
		template_data.ranged_talent = talent_extension:has_special_rule(ranged_rule)
		template_data.toughness_talent = talent_extension:has_special_rule(toughness_rule)
		template_data.wanted_stacks = 1
		template_data.next_allowed_remove_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		local should_be_active = template_context.stack_count >= talent_settings.forceful.stacks

		if template_data.active and not should_be_active then
			template_context.buff_extension:mark_buff_finished(template_data.active_index)

			if template_data.stun_immune then
				template_context.buff_extension:mark_buff_finished(template_data.stun_immune_index)
				template_context.buff_extension:add_internally_controlled_buff("adamant_forceful_stun_immune_duration", t)
			end

			if template_data.offensive then
				template_context.buff_extension:mark_buff_finished(template_data.offensive_index)
				template_context.buff_extension:add_internally_controlled_buff("adamant_forceful_offensive_duration", t)
			end

			if template_context.is_server and template_data.max_stacks_tracking_buff_index then
				template_context.buff_extension:mark_buff_finished(template_data.max_stacks_tracking_buff_index)

				template_data.max_stacks_tracking_buff_index = nil
			end

			template_data.active = false
		elseif should_be_active and not template_data.active then
			local _, index = template_context.buff_extension:add_externally_controlled_buff("adamant_forceful_active_effect", t)

			template_data.active_index = index

			if template_data.stun_immune then
				local _, stun_immune_index = template_context.buff_extension:add_externally_controlled_buff("adamant_forceful_stun_immune", t)

				template_data.stun_immune_index = stun_immune_index
			end

			if template_data.offensive then
				local _, offensive_index = template_context.buff_extension:add_externally_controlled_buff("adamant_forceful_offensive", t)

				template_data.offensive_index = offensive_index
			end

			if template_context.is_server and not template_data.max_stacks_tracking_buff_index then
				local _, buff_index = template_context.buff_extension:add_externally_controlled_buff("adamant_forceful_max_stacks_tracking_buff", t)

				template_data.max_stacks_tracking_buff_index = buff_index
			end

			template_data.active = true
		end

		if template_data.toughness_talent then
			local unit = template_context.unit
			local stacks = math.min(template_context.stack_count, talent_settings.forceful.stacks)
			local toughness = talent_settings.forceful.toughness * dt * template_context.stack_count

			Toughness.replenish_percentage(unit, toughness)
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.ranged_talent
	end,
	specific_proc_func = {
		on_combat_ability = function (params, template_data, template_context, t)
			if template_data.ability_strength then
				template_data.finish = true

				template_context.buff_extension:add_internally_controlled_buff_with_stacks("adamant_forceful_strength_stacks", template_context.stack_count, t)
			end
		end,
		on_player_hit_received = function (params, template_data, template_context, t)
			if params.damage <= 0 and params.damage_absorbed <= 0 then
				return
			end

			if not params.attack_result or params.attack_result == "blocked" then
				return
			end

			if t < template_data.next_allowed_remove_t then
				return
			end

			template_data.next_allowed_remove_t = t + 0.25
			template_data.wanted_stacks = template_data.wanted_stacks - 1
		end,
	},
	on_add_stack_func = function (template_data, template_context)
		template_data.wanted_stacks = math.min(template_context.stack_count, talent_settings.forceful.stacks)
	end,
	conditional_stack_exit_func = function (template_data, template_context)
		if template_data.wanted_stacks < template_context.stack_count and template_context.stack_count > 0 then
			return true
		end

		return false
	end,
	conditional_exit_func = function (template_data, template_context)
		if template_data.wanted_stacks < 1 then
			return true
		end

		if template_data.finish then
			return true
		end

		return false
	end,
}
templates.adamant_forceful_max_stacks_tracking_buff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		template_data.time_entered_max_stacks = FixedFrame.get_latest_fixed_time()
	end,
	stop_func = function (template_data, template_context)
		local current_time = FixedFrame.get_latest_fixed_time()
		local time_at_max_stacks_rounded = math.round(current_time - template_data.time_entered_max_stacks)

		if template_context.player and time_at_max_stacks_rounded > 0 then
			Managers.stats:record_private("hook_adamant_exited_max_forceful_stacks", template_context.player, time_at_max_stacks_rounded)
		end
	end,
}

local function _forceful_explosion(template_data, template_context)
	if not template_context.is_server then
		return
	end

	local unit = template_context.unit
	local world = template_context.world
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")
	local physics_world = World.physics_world(world)
	local explosion_template = ExplosionTemplates.adamant_forceful_explosion
	local power_level = 500
	local position = Unit.local_position(unit, 1)
	local attack_type = AttackSettings.attack_types.explosion

	Explosion.create_explosion(world, physics_world, position + Vector3.up(), nil, unit, explosion_template, power_level, 1, attack_type)
end

templates.adamant_forceful_stagger = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		template_data.stacks = 0
		template_data.next_low_t = 0
		template_data.next_high_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		local stacks = template_context.buff_extension:current_stacks("adamant_forceful_stacks")

		if template_data.stacks > 0 and stacks <= 0 then
			if t >= template_data.next_low_t then
				_forceful_explosion(template_data, template_context)

				template_data.next_low_t = t + talent_settings.forceful.internal_cd
			end
		elseif template_data.stacks < talent_settings.forceful.stacks and stacks >= talent_settings.forceful.stacks and t >= template_data.next_high_t then
			_forceful_explosion(template_data, template_context)

			template_data.next_high_t = t + talent_settings.forceful.internal_cd
		end

		template_data.stacks = stacks
	end,
}
templates.adamant_forceful_active_effect = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_adamant_forceful_keystone",
	},
}
templates.adamant_forceful_strength_stacks = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_forceful_refresh_on_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	max_stacks = talent_settings.forceful.stacks,
	duration = talent_settings.forceful.strength_duration,
	stat_buffs = {
		[stat_buffs.power_level_modifier] = talent_settings.forceful.strength,
	},
	related_talents = {
		"adamant_forceful_ability_damage",
	},
}
templates.adamant_forceful_offensive = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings.forceful.attack_speed,
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings.forceful.cleave,
	},
}
templates.adamant_forceful_offensive_duration = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_forceful_ranged",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 3,
	predicted = false,
	duration = talent_settings.forceful.stun_immune_linger_time,
	stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings.forceful.attack_speed,
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings.forceful.cleave,
	},
}
templates.adamant_forceful_stun_immune = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.stun_immune,
		keywords.slowdown_immune,
	},
	conditional_keywords = {
		keywords.block_unblockable,
	},
	start_func = function (template_data, template_context)
		local unit_data = ScriptUnit.extension(template_context.unit, "unit_data_system")
		local block_component = unit_data:read_component("block")

		template_data.block_component = block_component
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.block_component.is_perfect_blocking
	end,
}
templates.adamant_forceful_stun_immune_duration = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_forceful_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 3,
	predicted = false,
	keywords = {
		keywords.stun_immune,
		keywords.slowdown_immune,
	},
	conditional_keywords = {
		keywords.block_unblockable,
	},
	duration = talent_settings.forceful.stun_immune_linger_time,
	start_func = function (template_data, template_context)
		local unit_data = ScriptUnit.extension(template_context.unit, "unit_data_system")
		local block_component = unit_data:read_component("block")

		template_data.block_component = block_component
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.block_component.is_perfect_blocking
	end,
}

local teminus_warrant_attacked_units = {}

templates.adamant_terminus_warrant = {
	class_name = "proc_buff",
	predicted = false,
	keywords = {
		keywords.adamant_terminus_warrant,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_wield_melee] = 1,
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_shoot] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.has_upgrade_talent = talent_extension:has_special_rule(special_rules.adamant_terminus_warrant_upgrade_talent)
		template_data.has_talent = talent_extension:has_special_rule(special_rules.adamant_terminus_warrant_improved_talent)
		template_data.max_stacks = talent_settings.terminus_warrant.max_stacks
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			if CheckProcFunctions.attacker_is_my_companion(params, template_data, template_context) then
				return
			end

			local is_ranged_attack = params.attack_type == attack_types.ranged or params.damage_profile and params.damage_profile.count_as_ranged_attack

			if is_ranged_attack then
				local attacked_unit = params.attacked_unit

				if not teminus_warrant_attacked_units[attacked_unit] then
					local _, buff_id = template_context.buff_extension:add_externally_controlled_buff("adamant_terminus_warrant_melee", t)

					template_data.melee_buff_id = buff_id
					teminus_warrant_attacked_units[attacked_unit] = true
				end
			end

			local is_melee_attack = params.attack_type == attack_types.melee

			if is_melee_attack then
				local _, buff_id = template_context.buff_extension:add_externally_controlled_buff("adamant_terminus_warrant_ranged", t)

				template_data.ranged_buff_id = buff_id
			end
		end,
		on_wield_melee = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			local current_stacks = template_context.buff_extension:current_stacks("adamant_terminus_warrant_melee")

			if template_data.has_upgrade_talent and current_stacks >= talent_settings.terminus_warrant.swap_stacks then
				template_context.buff_extension:add_internally_controlled_buff("adamant_terminus_warrant_melee_temporary", t)
			end

			if template_data.has_talent and current_stacks >= talent_settings.terminus_warrant.swap_stacks_talent then
				template_context.buff_extension:add_internally_controlled_buff("adamant_terminus_warrant_melee_rending", t)
			end
		end,
		on_wield_ranged = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			local current_stacks = template_context.buff_extension:current_stacks("adamant_terminus_warrant_ranged")

			if template_data.has_upgrade_talent and current_stacks >= talent_settings.terminus_warrant.swap_stacks then
				template_context.buff_extension:add_internally_controlled_buff("adamant_terminus_warrant_ranged_temporary", t)
			end

			if template_data.has_talent and current_stacks >= talent_settings.terminus_warrant.swap_stacks_talent then
				template_context.buff_extension:add_internally_controlled_buff("adamant_terminus_warrant_ranged_rending", t)
			end
		end,
		on_sweep_finish = function (params, template_data, template_context, t)
			return
		end,
		on_shoot = function (params, template_data, template_context, t)
			table.clear(teminus_warrant_attacked_units)
		end,
	},
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		if template_data.ranged_buff_id then
			template_context.buff_extension:mark_buff_finished(template_data.ranged_buff_id)

			template_data.ranged_id = nil
		end

		if template_data.melee_buff_id then
			template_context.buff_extension:mark_buff_finished(template_data.melee_buff_id)

			template_data.melee_buff_id = nil
		end
	end,
}
templates.adamant_terminus_warrant_melee_stat_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	proc_events = {
		[proc_events.on_toughness_replenished] = 1,
	},
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.terminus_warrant.melee_damage,
		[stat_buffs.melee_impact_modifier] = talent_settings.terminus_warrant.melee_impact,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")

		template_data.coherency_extension = coherency_extension

		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.has_talent = talent_extension:has_special_rule(special_rules.adamant_terminus_warrant_melee_talent)
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.has_talent then
			return
		end

		local reason = params.reason

		if reason == "shared" then
			return
		end

		local amount = params.amount
		local percent = talent_settings.terminus_warrant.toughness_shared
		local toughness_to_restore = amount * percent
		local units_in_coherency = template_data.coherency_extension:in_coherence_units()

		for unit, _ in pairs(units_in_coherency) do
			if unit ~= template_context.unit then
				Toughness.replenish_flat(unit, toughness_to_restore, false, "shared")
			end
		end
	end,
	conditional_stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = talent_settings.terminus_warrant.melee_toughness,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.has_talent
	end,
}
templates.adamant_terminus_warrant_ranged_stat_buff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.terminus_warrant.ranged_damage,
		[stat_buffs.suppression_dealt] = talent_settings.terminus_warrant.suppression_dealt,
		[stat_buffs.ranged_max_hit_mass_attack_modifier] = talent_settings.terminus_warrant.ranged_max_hit_mass_attack_modifier,
	},
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.terminus_warrant.reload_speed,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.has_talent = talent_extension:has_special_rule(special_rules.adamant_terminus_warrant_ranged_talent)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.has_talent
	end,
}

local teminus_warrant_ranged_attacked_units = {}

templates.adamant_terminus_warrant_ranged = {
	always_active = true,
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_weapon_handling",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stat_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	max_stacks = talent_settings.terminus_warrant.max_stacks,
	max_stacks_cap = talent_settings.terminus_warrant.max_stacks,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_shoot] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local _, id = template_context.buff_extension:add_externally_controlled_buff("adamant_terminus_warrant_ranged_stat_buff", t)

		template_data.ranged_stat_id = id
		template_data.wanted_stacks = 1
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			if CheckProcFunctions.attacker_is_my_companion(params, template_data, template_context) then
				return
			end

			local is_ranged_attack = params.attack_type == attack_types.ranged or params.damage_profile and params.damage_profile.count_as_ranged_attack

			if is_ranged_attack then
				local attacked_unit = params.attacked_unit

				if not teminus_warrant_ranged_attacked_units[attacked_unit] then
					teminus_warrant_ranged_attacked_units[attacked_unit] = true
					template_data.wanted_stacks = template_data.wanted_stacks - 1
				end
			end
		end,
		on_shoot = function (params, template_data, template_context)
			table.clear(teminus_warrant_ranged_attacked_units)
		end,
	},
	on_add_stack_func = function (template_data, template_context)
		template_data.wanted_stacks = math.min(template_context.stack_count, talent_settings.terminus_warrant.max_stacks)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.min(template_context.template.max_stacks_cap, template_context.stack_count)
	end,
	conditional_stack_exit_func = function (template_data, template_context)
		if template_data.wanted_stacks < template_context.stack_count and template_context.stack_count > 0 then
			return true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		if template_data.wanted_stacks < 1 or template_context.stack_count < 1 then
			if template_data.ranged_stat_id then
				template_context.buff_extension:mark_buff_finished(template_data.ranged_stat_id)

				template_data.ranged_stat_id = nil
			end

			return true
		end

		return false
	end,
}
templates.adamant_terminus_warrant_melee = {
	always_active = true,
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_default_offensive_talent",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stat_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	max_stacks = talent_settings.terminus_warrant.max_stacks,
	max_stacks_cap = talent_settings.terminus_warrant.max_stacks,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local _, id = template_context.buff_extension:add_externally_controlled_buff("adamant_terminus_warrant_melee_stat_buff", t)

		template_data.melee_stat_id = id
		template_data.wanted_stacks = 1
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		if CheckProcFunctions.attacker_is_my_companion(params, template_data, template_context) then
			return
		end

		local is_melee_attack = params.attack_type == attack_types.melee

		if is_melee_attack then
			template_data.wanted_stacks = template_data.wanted_stacks - 1
		end
	end,
	on_add_stack_func = function (template_data, template_context)
		template_data.wanted_stacks = math.min(template_context.stack_count, talent_settings.terminus_warrant.max_stacks)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.min(template_context.template.max_stacks_cap, template_context.stack_count)
	end,
	conditional_stack_exit_func = function (template_data, template_context)
		if template_data.wanted_stacks < template_context.stack_count and template_context.stack_count > 0 then
			return true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		if template_data.wanted_stacks < 1 or template_context.stack_count < 1 then
			if template_data.melee_stat_id then
				template_context.buff_extension:mark_buff_finished(template_data.melee_stat_id)

				template_data.melee_stat_id = nil
			end

			return true
		end

		return false
	end,
}
templates.adamant_terminus_warrant_ranged_temporary = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_wield_melee] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	stat_buffs = {
		[stat_buffs.ranged_attack_speed] = talent_settings.terminus_warrant.fire_rate,
	},
	conditional_exit_func = function (template_data, template_context)
		local has_no_stacks = not template_context.buff_extension:has_buff_using_buff_template("adamant_terminus_warrant_ranged")

		return has_no_stacks or template_data.finish
	end,
}
templates.adamant_terminus_warrant_melee_temporary = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.terminus_warrant.melee_attack_speed,
	},
	conditional_exit_func = function (template_data, template_context)
		local has_no_stacks = not template_context.buff_extension:has_buff_using_buff_template("adamant_terminus_warrant_melee")

		return has_no_stacks or template_data.finish
	end,
}
templates.adamant_terminus_warrant_ranged_rending = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_wield_melee] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	stat_buffs = {
		[stat_buffs.critical_strike_damage] = talent_settings.terminus_warrant.crit_damage,
		[stat_buffs.weakspot_damage] = talent_settings.terminus_warrant.weakspot_damage,
	},
	conditional_exit_func = function (template_data, template_context)
		local has_no_stacks = not template_context.buff_extension:has_buff_using_buff_template("adamant_terminus_warrant_ranged")

		return has_no_stacks or template_data.finish
	end,
}
templates.adamant_terminus_warrant_melee_rending = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	stat_buffs = {
		[stat_buffs.melee_rending_multiplier] = talent_settings.terminus_warrant.melee_rending,
	},
	conditional_exit_func = function (template_data, template_context)
		local has_no_stacks = not template_context.buff_extension:has_buff_using_buff_template("adamant_terminus_warrant_melee")

		return has_no_stacks or template_data.finish
	end,
}
templates.adamant_melee_weakspot_hits_count_as_stagger = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_weakspot_hit, CheckProcFunctions.on_melee_hit),
	proc_func = function (params, template_data, template_context, t)
		local victim_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("adamant_melee_weakspot_hits_count_as_stagger_debuff", t)
		end
	end,
}
templates.adamant_melee_weakspot_hits_count_as_stagger_debuff = {
	class_name = "buff",
	predicted = false,
	duration = talent_settings.melee_weakspot_hits_count_as_stagger.duration,
	keywords = {
		keywords.count_as_staggered,
	},
}

local function _is_in_weapon_alternate_fire(template_data, template_context)
	local wielded_slot = template_data.inventory_component.wielded_slot

	if wielded_slot == "none" then
		return false, false
	end

	local wielded_slot_configuration = slot_configuration[wielded_slot]
	local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type
	local is_weapon = slot_type == "weapon"

	if not is_weapon then
		return false, false
	end

	local is_alternate_fire_active = template_data.alternate_fire_component.is_active

	if not is_alternate_fire_active then
		return false, false
	end

	return true, is_alternate_fire_active
end

templates.adamant_weapon_handling_buff = {
	class_name = "proc_buff",
	predicted = true,
	max_stacks = talent_settings.weapon_handling.stacks,
	max_stacks_cap = talent_settings.weapon_handling.stacks,
	proc_events = {
		[proc_events.on_shoot] = 1,
	},
	stat_buffs = {
		[stat_buffs.spread_modifier] = talent_settings.weapon_handling.spread,
		[stat_buffs.recoil_modifier] = talent_settings.weapon_handling.recoil,
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_contex, t)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		if not _is_in_weapon_alternate_fire(template_data, template_context) then
			return true
		end

		return template_data.finish
	end,
	related_talents = {
		"adamant_weapon_handling",
	},
}
templates.adamant_weapon_handling = {
	class_name = "buff",
	predicted = true,
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.next_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_active, is_alternate_fire_active = _is_in_weapon_alternate_fire(template_data, template_context)

		if is_active and t > template_data.next_t then
			template_data.next_t = t + talent_settings.weapon_handling.time

			template_context.buff_extension:add_internally_controlled_buff("adamant_weapon_handling_buff", t)
		end
	end,
}
templates.adamant_ranged_damage_on_melee_stagger = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_mag_strips",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	active_duration = talent_settings.ranged_damage_on_melee_stagger.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_push_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		if not CheckProcFunctions.on_staggering_hit(params, template_data, template_context) then
			return false
		end

		local attack_type = params.attack_type

		if attack_type ~= attack_types.melee and attack_type ~= attack_types.push then
			return false
		end

		return true
	end,
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.ranged_damage_on_melee_stagger.ranged_damage,
	},
}
templates.adamant_movement_speed_on_block = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_movement_speed_on_block",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = true,
	active_duration = talent_settings.movement_speed_on_block.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.movement_speed_on_block.movement_speed,
	},
	related_talents = {
		"adamant_movement_speed_on_block",
	},
}
templates.adamant_damage_vs_suppressed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_suppressed] = talent_settings.damage_vs_suppressed.damage_vs_suppressed,
	},
}
templates.adamant_clip_size = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.clip_size_modifier] = talent_settings.clip_size.clip_size_modifier,
	},
}
templates.adamant_suppression_immunity = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.suppression_immune,
	},
}
templates.adamant_disable_companion_buff = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.disable_companion.damage,
		[stat_buffs.toughness_damage_taken_modifier] = talent_settings.disable_companion.tdr,
		[stat_buffs.attack_speed] = talent_settings.disable_companion.attack_speed,
		[stat_buffs.extra_max_amount_of_grenades] = talent_settings.disable_companion.extra_max_amount_of_grenades,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local stat_buffs = template.stat_buffs.extra_max_amount_of_grenades
		local extra_grenades = stat_buffs
		local is_server = template_context.is_server
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")

		template_context.initial_num_charges = grenade_ability_component.num_charges
		grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades

		local unit_spawner_manager = Managers.state.unit_spawner

		if is_server and unit_spawner_manager then
			local companion_spawner_extension = ScriptUnit.has_extension(unit, "companion_spawner_system")

			if companion_spawner_extension then
				companion_spawner_extension:despawn_unit()
			end
		end
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		local initial_num_charges = template_context.initial_num_charges

		grenade_ability_component.num_charges = math.min(grenade_ability_component.num_charges, initial_num_charges)
	end,
}

local grenade_replenishment_cooldown = talent_settings.disable_companion.blitz_replenish_time
local ABILITY_TYPE = "grenade_ability"
local grenades_restored = 1
local external_properties = {}

templates.adamant_grenade_replenishment = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_disable_companion",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 4,
	predicted = false,
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

		if not ability_extension or not ability_extension:has_ability_type(ABILITY_TYPE) then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges(ABILITY_TYPE)

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			if ability_extension and ability_extension:has_ability_type(ABILITY_TYPE) then
				ability_extension:restore_ability_charge(ABILITY_TYPE, grenades_restored)

				local first_person_extension = template_data.first_person_extension

				if first_person_extension and first_person_extension:is_in_first_person_mode() then
					external_properties.indicator_type = "human_grenade"

					template_data.fx_extension:trigger_gear_wwise_event("charge_ready_indicator", external_properties)
				end
			end

			template_data.next_grenade_t = nil
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
		local percentage_left = time_until_next / grenade_replenishment_cooldown

		return 1 - percentage_left
	end,
	related_talents = {
		"adamant_disable_companion",
	},
}
templates.adamant_elite_special_kills_replenish_toughness = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		buff_extension:add_internally_controlled_buff("adamant_toughness_on_elite_kill_effect", t)
		Toughness.replenish_percentage(template_context.unit, talent_settings.elite_special_kills_replenish_toughness.instant_toughness, false)
	end,
}
templates.adamant_toughness_on_elite_kill_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_elite_special_kills_replenish_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	duration = talent_settings.elite_special_kills_replenish_toughness.duration,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings.elite_special_kills_replenish_toughness.toughness * dt, false)

		template_data.next_regen_t = nil
	end,
	related_talents = {
		"adamant_elite_special_kills_replenish_toughness",
	},
}
templates.adamant_close_kills_restore_toughness = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_close_kill,
	proc_func = function (params, template_data, template_context, t)
		local toughness = talent_settings.close_kills_restore_toughness.toughness

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
}
templates.adamant_staggers_replenish_toughness = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_staggering_hit, CheckProcFunctions.on_melee_hit),
	proc_func = function (params, template_data, template_context, t)
		if params.target_number and params.target_number > 1 then
			return
		end

		local toughness = talent_settings.staggers_replenish_toughness.toughness

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
}
templates.adamant_limit_dmg_taken_from_hits = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	keywords = {
		keywords.limit_health_damage_taken,
	},
	stat_buffs = {
		[stat_buffs.max_health_damage_taken_per_hit] = talent_settings.limit_dmg_taken_from_hits.limit,
	},
}
templates.adamant_increased_damage_to_high_health = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_healthy] = talent_settings.increased_damage_to_high_health.damage,
	},
}
templates.adamant_increased_damage_vs_horde = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_horde] = talent_settings.increased_damage_vs_horde.damage,
	},
}
templates.adamant_armor = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = talent_settings.armor.toughness,
	},
}
templates.adamant_mag_strips = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.wield_speed] = talent_settings.mag_strips.wield_speed,
	},
}
templates.adamant_plasteel_plates = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = talent_settings.plasteel_plates.toughness,
	},
}
templates.adamant_ammo_belt = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = talent_settings.ammo_belt.ammo_reserve_capacity,
	},
}
templates.adamant_rebreather = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = talent_settings.rebreather.corruption_taken_multiplier,
		[stat_buffs.damage_taken_from_toxic_gas_multiplier] = talent_settings.rebreather.damage_taken_from_toxic_gas_multiplier,
	},
}

local OUTLINE_NAME = "special_target"
local distance_verispex_sq = talent_settings.verispex.range * talent_settings.verispex.range

templates.adamant_verispex = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local is_local_unit = template_context.is_local_unit
		local player = template_context.player
		local is_human_controlled = player:is_human_controlled()
		local local_player = Managers.player:local_player(1)
		local camera_handler = local_player and local_player.camera_handler
		local is_observing = camera_handler and camera_handler:is_observing()

		template_data.valid_player = is_local_unit and is_human_controlled or is_observing

		if not template_data.valid_player then
			return
		end

		template_data.outlined_units = {}
		template_data.next_update_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_data.valid_player then
			return
		end

		if t < template_data.next_update_t then
			return
		end

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system and side_system.side_by_unit[unit]
		local enemy_units = side and side.enemy_units_lookup or {}
		local player_position = Unit.world_position(unit, 1)
		local outline_system = Managers.state.extension:system("outline_system")

		for enemy_unit, _ in pairs(enemy_units) do
			local is_outlined = template_data.outlined_units[enemy_unit]

			if not is_outlined then
				local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
				local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
				local breed_tags = breed and breed.tags
				local is_special = breed_tags and breed_tags.special

				if is_special then
					local special_position = Unit.world_position(enemy_unit, 1)
					local from_player = special_position - player_position
					local distance_squared = Vector3.length_squared(from_player)
					local distance_score_low_enough = distance_squared < distance_verispex_sq

					if distance_squared < distance_verispex_sq then
						outline_system:add_outline(enemy_unit, OUTLINE_NAME)

						template_data.outlined_units[enemy_unit] = true
					end
				end
			end
		end

		template_data.next_update_t = t + 1
	end,
}
templates.adamant_shield_plates = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
		[proc_events.on_block] = 1,
	},
	specific_proc_func = {
		on_perfect_block = function (params, template_data, template_context, t)
			if not template_data.perfect_t or t > template_data.perfect_t then
				local toughness = talent_settings.shield_plates.perfect_toughness

				Toughness.replenish_percentage(template_context.unit, toughness)

				template_data.perfect_t = t + talent_settings.shield_plates.icd
			end
		end,
		on_block = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff("adamant_shield_plates_buff", t)
		end,
	},
	related_talents = {
		"adamant_shield_plates",
	},
}
templates.adamant_shield_plates_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_shield_plates",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.shield_plates.duration,
	update_func = function (template_data, template_context, dt, t)
		local toughness = talent_settings.shield_plates.toughness * dt / talent_settings.shield_plates.duration

		Toughness.replenish_percentage(template_context.unit, toughness)
	end,
	related_talents = {
		"adamant_shield_plates",
	},
}
templates.adamant_damage_after_reloading = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_damage_after_reloading",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.damage_after_reloading.duration,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.damage_after_reloading.ranged_damage,
	},
}
templates.adamant_cleave_after_push = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_cleave_after_push",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.cleave_after_push.duration,
	proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.num_hit_units > 0
	end,
	proc_stat_buffs = {
		[stat_buffs.max_melee_hit_mass_attack_modifier] = talent_settings.cleave_after_push.cleave,
	},
}
templates.adamant_dog_damage_after_ability = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_dog_damage_after_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	predicted = false,
	skip_tactical_overlay = true,
	active_duration = talent_settings.dog_damage_after_ability.duration,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.companion_damage_modifier] = talent_settings.dog_damage_after_ability.damage,
	},
}
templates.adamant_heavy_attacks_increase_damage = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_heavy_attacks_increase_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.heavy_attacks_increase_damage.duration,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local is_heavy = params.is_heavy or params.melee_attack_strength == "heavy"

		if not params.is_heavy then
			return false
		end

		return params.num_hit_units > 0
	end,
	proc_stat_buffs = {
		[stat_buffs.damage] = talent_settings.heavy_attacks_increase_damage.damage,
	},
}
templates.adamant_wield_speed_on_melee_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("adamant_wield_speed_on_melee_kill_buff", t)
	end,
}
templates.adamant_wield_speed_on_melee_kill_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_wield_speed_on_melee_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	duration = talent_settings.wield_speed_on_melee_kill.duration,
	max_stacks = talent_settings.wield_speed_on_melee_kill.max_stacks,
	stat_buffs = {
		[stat_buffs.wield_speed] = talent_settings.wield_speed_on_melee_kill.wield_speed_per_stack,
	},
}
templates.adamant_elite_special_kills_offensive_boost = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_elite_special_kills_offensive_boost",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = true,
	active_duration = talent_settings.elite_special_kills_offensive_boost.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_stat_buffs = {
		[stat_buffs.damage] = talent_settings.elite_special_kills_offensive_boost.damage,
		[stat_buffs.movement_speed] = talent_settings.elite_special_kills_offensive_boost.movement_speed,
	},
}
templates.adamant_melee_attacks_on_staggered_rend = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_rending_vs_staggered_multiplier] = talent_settings.melee_attacks_on_staggered_rend.rending_multiplier,
	},
}
templates.adamant_hitting_multiple_gives_tdr = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_hitting_multiple_gives_tdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.hitting_multiple_gives_tdr.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local min = talent_settings.hitting_multiple_gives_tdr.num_hits
		local hit = params.target_number

		return min == hit
	end,
	proc_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.hitting_multiple_gives_tdr.tdr,
	},
}
templates.adamant_multiple_hits_attack_speed = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_multiple_hits_attack_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.multiple_hits_attack_speed.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local is_melee = params.attack_type == attack_types.melee

		if not is_melee then
			return false
		end

		local min = talent_settings.multiple_hits_attack_speed.num_hits
		local hit = params.target_number

		return min == hit
	end,
	proc_stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.multiple_hits_attack_speed.melee_attack_speed,
	},
}
templates.adamant_restore_toughness_to_allies_on_combat_ability = {
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
		local coherency_extension = template_data.coherency_extension
		local units_in_coherence = coherency_extension:in_coherence_units()
		local toughness = talent_settings.restore_toughness_to_allies_on_combat_ability.toughness_percent

		for coherency_unit, _ in pairs(units_in_coherence) do
			Toughness.replenish_percentage(coherency_unit, toughness)
		end
	end,
}
templates.adamant_dog_pounces_bleed_nearby = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.attacker_is_my_companion,
	proc_func = function (params, template_data, template_context, t)
		if not template_data.companion_unit then
			local companion_spawner_extension = ScriptUnit.has_extension(template_context.unit, "companion_spawner_system")
			local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

			template_data.companion_unit = companion_unit
		end

		local pounce = params.damage_profile and (params.damage_profile.name == "cyber_mastiff_push" or params.damage_profile.companion_pounce)

		if pounce then
			local victim_unit = params.attacked_unit

			if HEALTH_ALIVE[victim_unit] then
				local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

				if buff_extension then
					local stacks = talent_settings.dog_pounces_bleed_nearby.bleed_stacks

					buff_extension:add_internally_controlled_buff_with_stacks("bleed", stacks, t, "owner_unit", template_data.companion_unit)
				end
			end
		end
	end,
}
templates.adamant_dog_applies_brittleness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.attacker_is_my_companion,
	proc_func = function (params, template_data, template_context, t)
		local initial_pounce = params.damage_profile and params.damage_profile.initial_pounce

		if initial_pounce then
			local victim_unit = params.attacked_unit

			if HEALTH_ALIVE[victim_unit] then
				local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

				if buff_extension then
					local stacks = talent_settings.dog_applies_brittleness.stacks

					buff_extension:add_internally_controlled_buff_with_stacks("rending_debuff", stacks, t)
				end
			end
		end
	end,
}
templates.adamant_pinning_dog_elite_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_companion_pounce] = 1,
		[proc_events.on_player_companion_pounce_finish] = 1,
		[proc_events.on_kill] = 1,
	},
	specific_proc_func = {
		on_player_companion_pounce = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = pounced_unit
		end,
		on_player_companion_pounce_finish = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = nil
		end,
		on_kill = function (params, template_data, template_context, t)
			local victim_unit = params.attacked_unit

			if not victim_unit or victim_unit ~= template_data.pounced_unit then
				return
			end

			if not CheckProcFunctions.on_elite_or_special_kill(params) then
				return
			end

			template_context.buff_extension:add_internally_controlled_buff("adamant_pinning_dog_elite_damage_buff", t)
		end,
	},
}
templates.adamant_pinning_dog_elite_damage_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_pinning_dog_elite_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.pinning_dog_elite_damage.duration,
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = talent_settings.pinning_dog_elite_damage.damage,
		[stat_buffs.damage_vs_specials] = talent_settings.pinning_dog_elite_damage.damage,
	},
	related_talents = {
		"adamant_pinning_dog_elite_damage",
	},
}
templates.adamant_pinning_dog_kills_cdr = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_companion_pounce] = 1,
		[proc_events.on_player_companion_pounce_finish] = 1,
		[proc_events.on_kill] = 1,
	},
	specific_proc_func = {
		on_player_companion_pounce = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = pounced_unit
		end,
		on_player_companion_pounce_finish = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = nil
		end,
		on_kill = function (params, template_data, template_context, t)
			local victim_unit = params.attacked_unit

			if not victim_unit or victim_unit ~= template_data.pounced_unit then
				return
			end

			template_context.buff_extension:add_internally_controlled_buff("adamant_pinning_dog_kills_cdr_buff", t)
		end,
	},
}
templates.adamant_pinning_dog_kills_cdr_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_pinning_dog_kills_cdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.pinning_dog_kills_cdr.time,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if not template_data.timer then
			template_data.timer = t + 1
		end

		if t > template_data.timer then
			template_data.timer = t + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings.pinning_dog_kills_cdr.regen)
		end
	end,
}
templates.adamant_pinning_dog_permanent_stacks = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_companion_pounce] = 1,
		[proc_events.on_player_companion_pounce_finish] = 1,
		[proc_events.on_kill] = 1,
	},
	specific_proc_func = {
		on_player_companion_pounce = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = pounced_unit
		end,
		on_player_companion_pounce_finish = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = nil
		end,
		on_kill = function (params, template_data, template_context, t)
			local victim_unit = params.attacked_unit

			if not victim_unit or victim_unit ~= template_data.pounced_unit then
				return
			end

			template_context.buff_extension:add_internally_controlled_buff("adamant_pinning_dog_permanent_stacks_buff", t)
		end,
	},
}
templates.adamant_pinning_dog_permanent_stacks_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_pinning_dog_permanent_stacks",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	max_stacks = talent_settings.pinning_dog_permanent_stacks.stacks,
	stat_buffs = {
		[stat_buffs.companion_damage_modifier] = talent_settings.pinning_dog_permanent_stacks.damage,
	},
}
templates.adamant_pinning_dog_bonus_moving_towards = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_companion_pounce] = 1,
	},
	specific_proc_func = {
		on_player_companion_pounce = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff("adamant_pinning_dog_bonus_moving_towards_buff", t)
		end,
	},
}
templates.adamant_pinning_dog_bonus_moving_towards_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_pinning_dog_bonus_moving_towards",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.pinning_dog_bonus_moving_towards.time,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.pinning_dog_bonus_moving_towards.damage,
		[stat_buffs.movement_speed] = talent_settings.pinning_dog_bonus_moving_towards.movement_speed,
	},
	related_talents = {
		"adamant_pinning_dog_bonus_moving_towards",
	},
}
templates.adamant_pinning_dog_kills_buff_allies = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_companion_pounce] = 1,
		[proc_events.on_player_companion_pounce_finish] = 1,
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")

		template_data.coherency_extension = coherency_extension
	end,
	specific_proc_func = {
		on_player_companion_pounce = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = pounced_unit
		end,
		on_player_companion_pounce_finish = function (params, template_data, template_context)
			local pounced_unit = params.pounced_unit

			template_data.pounced_unit = nil
		end,
		on_kill = function (params, template_data, template_context, t)
			local victim_unit = params.attacked_unit

			if not victim_unit or victim_unit ~= template_data.pounced_unit then
				return
			end

			local units_in_coherency = template_data.coherency_extension:in_coherence_units()

			for unit, _ in pairs(units_in_coherency) do
				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension then
					buff_extension:add_internally_controlled_buff("adamant_pinning_dog_kills_buff_allies_buff", t)
				end
			end
		end,
	},
}
templates.adamant_pinning_dog_kills_buff_allies_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_pinning_dog_kills_buff_allies",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.pinning_dog_kills_buff_allies.duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.pinning_dog_kills_buff_allies.tdr,
	},
	update_func = function (template_data, template_context, dt)
		local percent_toughness = talent_settings.pinning_dog_kills_buff_allies.toughness * dt / talent_settings.pinning_dog_kills_buff_allies.duration

		Toughness.replenish_percentage(template_context.unit, percent_toughness, false, "pinning_dog_kills_buff_allies")
	end,
	related_talents = {
		"adamant_pinning_dog_kills_buff_allies",
	},
}
templates.adamant_sprinting_sliding = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_sprinting_sliding",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.sprinting_sliding.duration,
	proc_events = {
		[proc_events.on_slide_end] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.sprint_movement_speed] = talent_settings.sprinting_sliding.speed,
	},
	related_talents = {
		"adamant_sprinting_sliding",
	},
}
templates.adamant_sprinting_sliding_kills = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	cooldown_duration = talent_settings.sprinting_sliding.cd,
	proc_func = function (params, template_data, template_context)
		local stamina = talent_settings.sprinting_sliding.stamina

		Stamina.add_stamina_percent(template_context.unit, stamina)
	end,
}
templates.adamant_monster_hunter = {
	class_name = "buff",
	prediced = false,
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn_and_monsters] = talent_settings.monster_hunter.damage,
	},
}
templates.adamant_uninterruptible_heavies = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.uninterruptible,
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
templates.adamant_first_melee_hit_increased_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_hit] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.first_melee_hit_increased_damage.damage,
		[stat_buffs.impact_modifier] = talent_settings.first_melee_hit_increased_damage.impact,
	},
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.active = true
		end,
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctions.on_melee_hit(params, template_data, template_context) then
				return
			end

			template_data.active = false
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.active = false
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.adamant_stamina_spent_replenish_toughness = {
	class_name = "buff",
	prediced = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_component = unit_data_extension:read_component("stamina")

		template_data.stamina_component = stamina_component

		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template

		local current_stamina, max_stamina = Stamina.current_and_max_value(unit, stamina_component, base_stamina_template)

		template_data.spent_stamina = 0
		template_data.last_stamina = current_stamina
		template_data.max_stamina = max_stamina
	end,
	update_func = function (template_data, template_context, dt, t)
		local unit = template_context.unit
		local current_stamina, max_stamina = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local dif = template_data.last_stamina - current_stamina

		if dif > 0 then
			local max_dif = template_data.max_stamina - max_stamina

			if max_dif ~= 0 then
				template_data.max_stamina = max_stamina
			else
				template_data.spent_stamina = template_data.spent_stamina + dif
			end
		end

		if template_data.spent_stamina >= talent_settings.stamina_spent_replenish_toughness.stamina then
			template_data.spent_stamina = template_data.spent_stamina - talent_settings.stamina_spent_replenish_toughness.stamina

			template_context.buff_extension:add_internally_controlled_buff("adamant_stamina_spent_replenish_toughness_buff", t)
		end

		template_data.last_stamina = current_stamina
	end,
}
templates.adamant_stamina_spent_replenish_toughness_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_stamina_regens_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.stamina_spent_replenish_toughness.duration,
	update_func = function (template_data, template_context, dt)
		local percent_toughness = talent_settings.stamina_spent_replenish_toughness.toughness * dt / talent_settings.stamina_spent_replenish_toughness.duration

		Toughness.replenish_percentage(template_context.unit, percent_toughness, false, "stamina_spent_replenish_toughness")
	end,
	related_talents = {
		"adamant_stamina_spent_replenish_toughness",
	},
}
templates.adamant_dodge_improvement = {
	class_name = "buff",
	prediced = false,
	stat_buffs = {
		[stat_buffs.extra_consecutive_dodges] = talent_settings.dodge_improvement.dodge,
		[stat_buffs.dodge_linger_time_modifier] = talent_settings.dodge_improvement.dodge_duration,
	},
}
templates.adamant_companion_focus_melee = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.companion_damage_vs_melee] = talent_settings.companion_focus_melee.damage,
	},
}
templates.adamant_companion_focus_ranged = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.companion_damage_vs_ranged] = talent_settings.companion_focus_ranged.damage,
	},
}
templates.adamant_companion_focus_elite = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.companion_damage_vs_elites] = talent_settings.companion_focus_elite.damage,
		[stat_buffs.companion_damage_vs_special] = talent_settings.companion_focus_elite.damage,
	},
}
templates.adamant_no_movement_penalty = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = talent_settings.no_movement_penalty.reduced_move_penalty,
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = talent_settings.no_movement_penalty.reduced_move_penalty,
	},
	start_func = function (template_data, template_context)
		template_data.wielding_ranged = false
	end,
	specific_proc_func = {
		on_wield_ranged = function (params, template_data, template_context)
			template_data.wielding_ranged = true
		end,
		on_wield_melee = function (params, template_data, template_context)
			template_data.wielding_ranged = false
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.wielding_ranged
	end,
}
templates.adamant_dog_attacks_electrocute = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.attacker_is_my_companion,
	proc_func = function (params, template_data, template_context, t)
		local pounce = params.damage_profile and params.damage_profile.companion_pounce

		if pounce then
			local victim_unit = params.attacked_unit

			if HEALTH_ALIVE[victim_unit] then
				local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

				if buff_extension then
					local player_unit = template_context.unit

					buff_extension:add_internally_controlled_buff("dog_attacks_electrocute_electrocute_buff", t, "owner_unit", player_unit)
				end
			end
		end
	end,
}

local PI = math.pi
local PI_2 = PI * 2

templates.dog_attacks_electrocute_electrocute_buff = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	duration = talent_settings.dog_attacks_electrocute.duration,
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.shockmaul_stun_interval_damage
			local owner_unit = template_context.owner_unit
			local power_level = talent_settings.dog_attacks_electrocute.power_level
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution,
	},
}
templates.adamant_damage_reduction_after_elite_kill = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_damage_reduction_after_elite_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings.damage_reduction_after_elite_kill.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.damage_reduction_after_elite_kill.damage_taken_multiplier,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	related_talents = {
		"adamant_damage_reduction_after_elite_kill",
	},
}

local toughness_range_sq = talent_settings.toughness_regen_near_companion.range * talent_settings.toughness_regen_near_companion.range

templates.adamant_toughness_regen_near_companion = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_toughness_regen_near_companion",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.character_state_component = character_state_component
		template_data.check_t = 0
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if template_data.is_active and template_context.is_server then
			local percent_toughness = talent_settings.toughness_regen_near_companion.toughness_percentage_per_second * dt

			Toughness.replenish_percentage(template_context.unit, percent_toughness, false, "near_companion_toughness")
		end

		local check_t = template_data.check_t

		if t < check_t then
			return
		end

		template_data.check_t = t + 0.1

		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			template_data.is_active = false

			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local companion_spawner_extension = ScriptUnit.has_extension(player_unit, "companion_spawner_system")
		local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

		if companion_unit then
			local companion_position = POSITION_LOOKUP[companion_unit]
			local distance = Vector3.distance_squared(player_position, companion_position)
			local is_active = distance <= toughness_range_sq

			template_data.is_active = is_active
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	related_talents = {
		"adamant_toughness_regen_near_companion",
	},
}
templates.adamant_perfect_block_damage_boost = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	stat_buffs = {
		[stat_buffs.block_cost_multiplier] = talent_settings.perfect_block_damage_boost.block_cost,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("adamant_perfect_block_damage_boost_buff", t)
	end,
}
templates.adamant_perfect_block_damage_boost_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_perfect_block_damage_boost",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.perfect_block_damage_boost.duration,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.perfect_block_damage_boost.damage,
		[stat_buffs.attack_speed] = talent_settings.perfect_block_damage_boost.attack_speed,
	},
	related_talents = {
		"adamant_perfect_block_damage_boost",
	},
}
templates.adamant_staggers_reduce_damage_taken = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_staggering_hit,
	proc_func = function (params, template_data, template_context, t)
		local tags = params.tags
		local is_ogryn = tags and tags.ogryn or tags.monster
		local stacks = is_ogryn and talent_settings.staggers_reduce_damage_taken.ogryn_stacks or talent_settings.staggers_reduce_damage_taken.normal_stacks

		template_context.buff_extension:add_internally_controlled_buff_with_stacks("adamant_staggers_reduce_damage_taken_buff", stacks, t)
	end,
}
templates.adamant_staggers_reduce_damage_taken_buff = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_staggers_reduce_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.staggers_reduce_damage_taken.max_stacks,
	duration = talent_settings.staggers_reduce_damage_taken.duration,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.staggers_reduce_damage_taken.damage_taken_multiplier,
	},
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local is_melee = params.attack_type == attack_types.melee

		if not is_melee then
			return
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"adamant_staggers_reduce_damage_taken",
	},
}
templates.adamant_crit_chance_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("adamant_crit_chance_on_kill_effect", t)
		end
	end,
	check_proc_func = CheckProcFunctions.on_kill,
}
templates.adamant_crit_chance_on_kill_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_crit_chance_on_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.crit_chance_on_kill.duration,
	max_stacks = talent_settings.crit_chance_on_kill.max_stacks,
	max_stacks_cap = talent_settings.crit_chance_on_kill.max_stacks,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.crit_chance_on_kill.crit_chance,
	},
	related_talents = {
		"adamant_crit_chance_on_kill",
	},
}
templates.adamant_crits_rend = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ranged_critical_strike_rending_multiplier] = talent_settings.crits_rend.rending,
	},
}
templates.adamant_elite_special_kills_reload_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local reload_buff = "adamant_increased_reload_speed_elite_kill"

		buff_extension:add_internally_controlled_buff(reload_buff, t)
	end,
}
templates.adamant_increased_reload_speed_elite_kill = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_elite_special_kills_reload_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.elite_special_kills_reload_speed.reload_speed,
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
		"adamant_elite_special_kills_reload_speed",
	},
}
templates.adamant_dodge_grants_damage = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_dodge_grants_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	active_duration = talent_settings.dodge_grants_damage.duration,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage] = talent_settings.dodge_grants_damage.damage,
	},
	related_talents = {
		"adamant_dodge_grants_damage",
	},
}
templates.adamant_stacking_weakspot_strength = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("adamant_stacking_weakspot_strength_buff", t)
	end,
}
templates.adamant_stacking_weakspot_strength_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_stacking_weakspot_strength",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.stacking_weakspot_strength.duration,
	max_stacks = talent_settings.stacking_weakspot_strength.max_stacks,
	stat_buffs = {
		[stat_buffs.weakspot_power_level_modifier] = talent_settings.stacking_weakspot_strength.strength,
	},
	related_talents = {
		"adamant_stacking_weakspot_strength",
	},
}
templates.adamant_stacking_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if params.target_number > 1 then
			return
		end

		template_context.buff_extension:add_internally_controlled_buff("adamant_stacking_damage_buff", t)
	end,
}
templates.adamant_stacking_damage_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_pinning_dog_permanent_stacks",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.stacking_damage.duration,
	max_stacks = talent_settings.stacking_damage.stacks,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.stacking_damage.damage,
	},
	related_talents = {
		"adamant_stacking_damage",
	},
}
templates.adamant_staggering_increases_damage_taken = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_push_hit] = 1,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if CheckProcFunctions.on_kill(params) then
				return
			end

			if not CheckProcFunctions.on_melee_stagger_hit(params) then
				return
			end

			local victim_unit = params.attacked_unit
			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("adamant_staggering_enemies_take_more_damage", num_stacks, t, "owner_unit", template_context.unit)
			end
		end,
		on_push_hit = function (params, template_data, template_context, t)
			local victim_unit = params.pushed_unit

			if not MinionState.is_minion(victim_unit) or not MinionState.is_staggered(victim_unit) then
				return
			end

			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("adamant_staggering_enemies_take_more_damage", num_stacks, t, "owner_unit", template_context.unit)
			end
		end,
	},
}
templates.adamant_staggering_enemies_take_more_damage = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.staggering_enemies_take_more_damage.duration,
	stat_buffs = {
		[stat_buffs.melee_damage_taken_modifier] = talent_settings.staggering_enemies_take_more_damage.damage,
	},
}
templates.adamant_staggered_enemies_deal_less_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_push_hit] = 1,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if CheckProcFunctions.on_kill(params) then
				return
			end

			if not CheckProcFunctions.on_melee_stagger_hit(params) then
				return
			end

			local victim_unit = params.attacked_unit
			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("adamant_staggered_enemies_deal_less_damage_debuff", num_stacks, t, "owner_unit", template_context.unit)
			end
		end,
		on_push_hit = function (params, template_data, template_context, t)
			local victim_unit = params.pushed_unit

			if not MinionState.is_minion(victim_unit) or not MinionState.is_staggered(victim_unit) then
				return
			end

			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("adamant_staggered_enemies_deal_less_damage_debuff", num_stacks, t, "owner_unit", template_context.unit)
			end
		end,
	},
}
templates.adamant_staggered_enemies_deal_less_damage_debuff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.staggered_enemies_deal_less_damage.duration,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.staggered_enemies_deal_less_damage.damage,
	},
}

return templates
