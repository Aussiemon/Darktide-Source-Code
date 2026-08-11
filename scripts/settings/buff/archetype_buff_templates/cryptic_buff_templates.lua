-- chunkname: @scripts/settings/buff/archetype_buff_templates/cryptic_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CompanionServoSkullAbility = require("scripts/utilities/companion/companion_servo_skull_ability")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local MinionState = require("scripts/utilities/minion_state")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local CrypticBuffUtils = require("scripts/settings/buff/cryptic_buff_utils")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local PlayerDeath = require("scripts/utilities/player_death")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local buff_categories = BuffSettings.buff_categories
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local group_keywords = BuffSettings.group_keywords
local group_to_keywords = BuffSettings.group_to_keywords
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local special_rules = SpecialRulesSettings.special_rules
local proc_events = BuffSettings.proc_events
local talent_settings = TalentSettings.cryptic
local combat_ability_cooldown_recharge_on_kill = talent_settings.combat_ability_cooldown_recharge_on_kill
local discharge_talent_settings = talent_settings.discharge_ability
local precision_stance_talent_settings = talent_settings.precision_stance
local chordclaw_ability_talent_settings = talent_settings.chordclaw_ability
local force_field_ability_talent_settings = talent_settings.force_field
local arc_grenade_ability_talent_settings = talent_settings.arc_grenade
local monster_hunter_keystone_talent_settings = talent_settings.monster_hunter
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local bionic_senses_talent_settings = talent_settings.bionic_senses
local surge_keystone_talent_settings = talent_settings.surge
local power_generation_keystone_talent_settings = talent_settings.power_generation
local dissector_keystone_talent_settings = talent_settings.dissector
local overload_keystone_talent_settings = talent_settings.overload
local power_generation_strength_keystone_talent_settings = talent_settings.power_generation_strength
local redline_keystone_talent_settings = talent_settings.redline
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"
local BROADPHASE_RESULTS = {}
local MAX_ABILITY_CHARGES_NETWORK_VALUE = 25
local MAX_BUFF_STACK_COUNT = BuffSettings.max_stack_count
local COMBAT_ABILITY_SLOT = "slot_combat_ability"
local COMBAT_ABILITY_TYPE = "combat_ability"
local GRENADE_ABILITY_TYPE = "grenade_ability"
local HUD_PRIORITIES = {
	abilities = 1,
	auras = 5,
	keystones = 2,
	talents = 3,
}
local _bespoke_monster_hunter_keystone_hit_tracking_start = CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_start
local _bespoke_monster_hunter_keystone_hit_tracking_update = CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_update
local _bespoke_monster_hunter_keystone_hit_tracking_is_tagged_check = CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_is_tagged_check
local _bespoke_monster_hunter_keystone_hit_tracking_proc = CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_proc
local _bespoke_monster_hunter_keystone_hit_tracking_proc_on_minion_death = CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_proc_on_minion_death

local function _toughness_regen_over_time_on_proc_generator()
	return {
		active_duration = 5,
		allow_proc_while_active = true,
		class_name = "proc_buff",
		hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_default_defensive_talent",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
		predicted = false,
		toughness_regen_on_proc = 0.25,
		toughness_regen_per_second = 0.05,
		hud_priority = HUD_PRIORITIES.talents,
		proc_events = {
			[proc_events.on_kill] = 1,
		},
		check_proc_func = CheckProcFunctions.on_melee_kill,
		proc_func = function (params, template_data, template_context, t)
			template_data.toughness_left_to_restore = template_context.template.toughness_regen_on_proc
		end,
		update_func = function (template_data, template_context, dt, t)
			local is_proc_active = template_context.buff:is_proc_active(t)
			local toughness_left_to_restore = template_data.toughness_left_to_restore or 0

			if template_context.is_server and is_proc_active and toughness_left_to_restore > 0 then
				local toughness_to_regen = template_context.template.toughness_regen_per_second * dt

				template_data.toughness_left_to_restore = template_data.toughness_left_to_restore - toughness_to_regen

				Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
			end
		end,
		related_talents = {
			"cryptic_electrocution_toughness",
		},
	}
end

local templates = {}

table.make_unique(templates)

local function _give_cryptic_aura_ammo_reserve_effect_to_player(player, template_data, template_context, fixed_t)
	local player_unit = player.player_unit

	if player_unit and HEALTH_ALIVE[player_unit] then
		local player_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if player_buff_extension then
			local _, buff_index, component_index = player_buff_extension:add_externally_controlled_buff("cryptic_ammo_aura_effect", fixed_t)

			table.insert(template_data.buffs_given_to_other_players, {
				player_unit = player_unit,
				buff_index = buff_index,
				component_index = component_index,
			})
		end
	end
end

templates.cryptic_coherency_empty = {
	class_name = "buff",
	coherency_id = "cryptic_aura_blitz_charges",
	coherency_priority = 2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.aura,
}
templates.cryptic_ammo_aura = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = talent_settings.cryptic_ammo_aura.toughness,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.start_time = template_context.buff:start_time()
		template_data.buffs_given_to_other_players = {}

		local fixed_t = FixedFrame.get_latest_fixed_time()
		local human_players = Managers.player:human_players()

		for _, player in pairs(human_players) do
			_give_cryptic_aura_ammo_reserve_effect_to_player(player, template_data, template_context, fixed_t)
		end

		template_context.buff.player_spawned_func = function (buff, player, is_respawn)
			local t = FixedFrame.get_latest_fixed_time()
			local is_human_player = player and player:is_human_controlled()

			if is_human_player and buff:template_context().player ~= player then
				_give_cryptic_aura_ammo_reserve_effect_to_player(player, template_data, template_context, t)
			end
		end

		Managers.event:register(template_context.buff, "mission_buffs_event_player_spawned", "player_spawned_func")
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		for _, player_data in ipairs(template_data.buffs_given_to_other_players) do
			local player_unit = player_data.player_unit
			local buff_index = player_data.buff_index
			local component_index = player_data.component_index

			if player_unit and HEALTH_ALIVE[player_unit] then
				local player_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

				if player_buff_extension and player_buff_extension:has_running_buff_with_index(buff_index) then
					player_buff_extension:remove_externally_controlled_buff(buff_index, component_index)
				end
			end
		end

		Managers.event:unregister(template_context.buff, "mission_buffs_event_player_spawned")
	end,
}
templates.cryptic_ammo_aura_effect = {
	class_name = "stepped_stat_buff",
	hud_always_never_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_ammo_aura",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	max_stacks = 4,
	max_stacks_cap = 4,
	predicted = false,
	buff_category = buff_categories.aura,
	hud_priority = HUD_PRIORITIES.auras,
	visual_stack_count = function (template_data, template_context)
		return 1
	end,
	stepped_stat_buffs = {},
	min_max_step_func = function (template_data, template_context)
		return 0, 1
	end,
	related_talents = {
		"cryptic_ammo_aura",
	},
}

for i = 1, templates.cryptic_ammo_aura_effect.max_stacks do
	table.insert(templates.cryptic_ammo_aura_effect.stepped_stat_buffs, {
		[stat_buffs.ammo_reserve_capacity] = talent_settings.cryptic_ammo_aura.ammo_reserve_capacity,
	})
end

templates.cryptic_aura_weapon_improved = {
	class_name = "buff",
	coherency_id = "cryptic_aura_weapon_improved",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_aura_weapon_improved",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	hud_priority = HUD_PRIORITIES.auras,
	stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings.cryptic_aura_weapon_improved.max_hit_mass_attack_modifier,
		[stat_buffs.rending_multiplier] = talent_settings.cryptic_aura_weapon_improved.rending_multiplier,
	},
	related_talents = {
		"cryptic_aura_weapon_improved",
	},
}
templates.cryptic_aura_weapon_improved_personal_boost = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = talent_settings.cryptic_aura_weapon_improved.toughness,
	},
}
templates.cryptic_coherency_regen_aura = {
	class_name = "buff",
	coherency_id = "cryptic_coherency_regen_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_coherency_regen_aura",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	hud_priority = HUD_PRIORITIES.auras,
	stat_buffs = {
		[stat_buffs.min_toughness_coherency_regen_rate_modifier] = talent_settings.cryptic_coherency_regen_aura.min_toughness_coherency_regen_rate_modifier,
	},
	related_talents = {
		"cryptic_coherency_regen_aura",
	},
}
templates.cryptic_coherency_regen_aura_improved = {
	class_name = "buff",
	coherency_id = "cryptic_coherency_regen_aura",
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_coherency_regen_aura_improved",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	hud_priority = HUD_PRIORITIES.auras,
	stat_buffs = {
		[stat_buffs.min_toughness_coherency_regen_rate_modifier] = talent_settings.cryptic_coherency_regen_aura_improved.min_toughness_coherency_regen_rate_modifier,
	},
	related_talents = {
		"cryptic_coherency_regen_aura_improved",
	},
}
templates.cryptic_coherency_regen_aura_improved_personal_boost = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = talent_settings.cryptic_coherency_regen_aura_improved.toughness,
	},
	related_talents = {
		"cryptic_coherency_regen_aura_improved",
	},
}
templates.cryptic_ability_recharge = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	skip_tactical_overlay = true,
	unique_buff_id = "cryptic_ability_regen",
	unique_buff_priority = 1,
	cooldown_replenish_base = combat_ability_cooldown_recharge_on_kill.cooldown_replenish_base,
	cooldown_replenish_elite_or_special = combat_ability_cooldown_recharge_on_kill.cooldown_replenish_elite_or_special,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")

		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		template_data.has_dissector_extra_cooldown_on_elite_or_special_kills = talent_extension:has_special_rule(special_rules.cryptic_dissector_increased_cooldown_gained_on_elite_or_special_kills)
	end,
	proc_func = function (params, template_data, template_context, t)
		if template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance) then
			return
		end

		local breed_tags = params.tags

		if breed_tags then
			local cooldown_to_restore = template_context.template.cooldown_replenish_base

			if breed_tags.elite or breed_tags.special then
				cooldown_to_restore = template_context.template.cooldown_replenish_elite_or_special

				if template_data.has_dissector_extra_cooldown_on_elite_or_special_kills then
					cooldown_to_restore = cooldown_to_restore + dissector_keystone_talent_settings.extra_cooldown_on_elite_or_special_kills
				end
			end

			if cooldown_to_restore > 0 then
				local cooldown_per_kill_stat_buff = 1

				template_data.ability_extension:reduce_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, cooldown_to_restore * cooldown_per_kill_stat_buff)
			end
		end
	end,
}

local function _extend_ability_duration(start_time, template_context, max_duration, added_duration, divisor, t)
	local time_since_start = t - start_time
	local steps = math.floor(time_since_start / max_duration)
	local modified_divisor = divisor^steps

	added_duration = added_duration / modified_divisor

	local new_start_time = math.min(t, template_context.buff:start_time() + added_duration)

	template_context.buff:set_start_time(new_start_time)
end

local horde_cryptic_precision_stance_cooldown_decrease_per_hit = HordesBuffsData.hordes_buff_cryptic_precision_stance_duration_extension_on_kill.buff_stats.capacitance.value

templates.cryptic_precision_stance_one_charge = {
	ability_charges_used = 1,
	always_active = true,
	always_show_in_hud = true,
	auto_aim_target_effect = "content/fx/particles/abilities/cryptic/precision_stance_target_effect",
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_precision_stance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = true,
	hud_priority = HUD_PRIORITIES.abilities,
	toughness_regen_per_second = precision_stance_talent_settings.cryptic_precision_stance_toughness_suppression.toughness_regen_per_second,
	keywords = {
		keywords.cryptic_precision_stance,
		keywords.enable_auto_aim,
	},
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = -1,
		[stat_buffs.spread_modifier] = precision_stance_talent_settings.spread_modifier,
		[stat_buffs.recoil_modifier] = precision_stance_talent_settings.recoil_modifier,
	},
	player_effects = {
		looping_wwise_start_event = "wwise/events/player/play_ability_active_cryptic_precision_stance",
		looping_wwise_stop_event = "wwise/events/player/stop_ability_active_cryptic_precision_stance",
		on_screen_effect = "content/fx/particles/screenspace/screen_cryptic_precision_stance",
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "cryptic_mechanical",
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.start_time = template_context.buff:start_time()
		template_data.bonus_buff_ids = {}
		template_data.ammo_spent = 0

		local fixed_t = FixedFrame.get_latest_fixed_time()

		template_data.start_t = fixed_t
		template_data.cooldown_percent_used = 0

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.combat_ability_component = unit_data_extension:write_component("combat_ability")
		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.should_restore_toughness_over_time = template_data.talent_extension:has_special_rule(special_rules.cryptic_precision_stance_restores_toughness)
		template_data.has_damage_on_elite_kills_talent = template_data.talent_extension:has_special_rule(special_rules.cryptic_precision_stance_damage_on_elite_kill)

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:read_component("slot_secondary")
		template_data.inventory_component = unit_data_extension:read_component("inventory")

		local current_ammo_in_clip = Ammo.current_ammo_in_clips(template_data.inventory_slot_secondary_component)

		if current_ammo_in_clip <= 0 then
			template_data.start_with_reload = true
		end

		if not DEDICATED_SERVER then
			template_data.smart_targeting_extension = ScriptUnit.extension(template_context.unit, "smart_targeting_system")
			template_data.fx_extension = ScriptUnit.extension(template_context.unit, "fx_system")
			template_data.target_unit = nil
		end
	end,
	stop_func = function (template_data, template_context)
		for _, buff_id in ipairs(template_data.bonus_buff_ids) do
			template_context.buff_extension:mark_buff_finished(buff_id)
		end

		local targeting_effect_id = template_data.targeting_effect_id

		if targeting_effect_id then
			local world = template_context.world

			World.destroy_particles(world, targeting_effect_id)

			template_data.targeting_effect_id = nil
		end

		if template_context.template.ability_charges_used >= 3 then
			local ammo_gain = template_data.ammo_spent

			Ammo.add_to_all_slots_flat(template_context.unit, ammo_gain)
		end

		local num_charges_used_during_ability = math.floor(template_data.cooldown_percent_used + precision_stance_talent_settings.cooldown_percent_cost_on_activation)

		if template_context.is_server and num_charges_used_during_ability > 0 then
			if template_data.talent_extension:has_special_rule(special_rules.cryptic_overload_keystone_gain_stacks_per_combat_ability_charge_used) then
				local num_stacks = num_charges_used_during_ability * overload_keystone_talent_settings.num_stacks_gained_per_combat_ability_charge

				Managers.event:trigger("cryptic_buffs_event_give_overload_keystone_stacks", template_context.player, num_stacks)
			end

			Managers.stats:record_private("hook_ability_charges_used_from_action", template_context.player, "combat_ability", num_charges_used_during_ability)
		end
	end,
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_kill] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_kill] = function (params, template_data, template_context, t)
			local is_ranged_kill = CheckProcFunctions.on_ranged_kill(params, template_data, template_context, t)

			if is_ranged_kill and not DEDICATED_SERVER then
				template_data.fx_extension:trigger_wwise_event("wwise/events/player/play_ability_cryptic_precision_stance_target_killed", false)
			end

			local is_elite_ranged_kill = is_ranged_kill and CheckProcFunctions.on_elite_kill(params, template_data, template_context, t)

			return template_data.has_damage_on_elite_kills_talent and is_elite_ranged_kill
		end,
	},
	specific_proc_func = {
		[proc_events.on_shoot] = function (params, template_data, template_context, t)
			local num_hits = params.num_hit_units
			local can_extend_duration = template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance_duration_extension_on_elite_hit)
			local hit_elite = params.hit_elite

			if num_hits > 0 and hit_elite and can_extend_duration then
				template_data.ability_extension:reduce_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, horde_cryptic_precision_stance_cooldown_decrease_per_hit)

				return
			end

			local cooldown_percent_used_on_shoot = precision_stance_talent_settings.cooldown_percent_used_on_shoot

			template_data.cooldown_percent_used = template_data.cooldown_percent_used + cooldown_percent_used_on_shoot

			local new_num_charges, new_percent_cooldown = template_data.ability_extension:increase_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, cooldown_percent_used_on_shoot)

			if new_num_charges == 0 and new_percent_cooldown >= 1 then
				template_data.stop_ability = true
			end
		end,
		[proc_events.on_kill] = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff("cryptic_precision_stance_damage_on_elite_kill_stack", t)
		end,
	},
	update_func = function (template_data, template_context, dt, t)
		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)
		local should_lose_cooldown_over_time = not is_reloading

		if should_lose_cooldown_over_time then
			local cooldown_percent_to_lose = precision_stance_talent_settings.cooldown_percent_lost_per_second * dt

			template_data.cooldown_percent_used = template_data.cooldown_percent_used + cooldown_percent_to_lose

			local new_num_charges, new_percent_cooldown = template_data.ability_extension:increase_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, cooldown_percent_to_lose)

			if new_num_charges == 0 and new_percent_cooldown >= 1 then
				template_data.stop_ability = true
			end
		end

		local wielded_slot = template_data.inventory_component.wielded_slot

		if template_data.stop_ability or wielded_slot ~= "slot_secondary" then
			template_data.combat_ability_component.active = false

			template_context.buff:force_finish()

			return
		end

		if template_data.should_restore_toughness_over_time then
			local toughness_to_regen = template_context.template.toughness_regen_per_second * dt

			Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "ability_stance")
		end

		if DEDICATED_SERVER then
			return
		end

		local world = template_context.world
		local wwise_world = template_context.wwise_world
		local smart_targeting_extension = template_data.smart_targeting_extension
		local targeting_data = smart_targeting_extension:targeting_data()
		local target_unit = targeting_data.unit
		local target_position = targeting_data and targeting_data.target_position and targeting_data.target_position:unbox() or nil
		local wielding_melee = wielded_slot == "slot_primary"
		local targeting_effect_id = template_data.targeting_effect_id

		if target_position and not wielding_melee then
			if not targeting_effect_id then
				local effect_name = template_context.template.auto_aim_target_effect

				template_data.targeting_effect_id = template_data.fx_extension:spawn_particles_local(effect_name, target_position)
			else
				World.move_particles(world, targeting_effect_id, target_position)
			end

			if target_unit ~= template_data.target_unit then
				template_data.target_unit = target_unit

				template_data.fx_extension:trigger_wwise_event("wwise/events/player/play_ability_cryptic_precision_stance_target", false)
			end
		elseif targeting_effect_id then
			World.destroy_particles(world, targeting_effect_id)

			template_data.targeting_effect_id = nil
			template_data.target_unit = nil
		end
	end,
	related_talents = {
		"cryptic_precision_stance",
	},
}
templates.cryptic_precision_stance_two_charges = table.clone(templates.cryptic_precision_stance_one_charge)
templates.cryptic_precision_stance_two_charges.ability_charges_used = 2
templates.cryptic_precision_stance_three_charges = table.clone(templates.cryptic_precision_stance_two_charges)
templates.cryptic_precision_stance_three_charges.ability_charges_used = 3
templates.cryptic_precision_stance_suppression_immune = {
	class_name = "buff",
	duration = 1,
	predicted = false,
	keywords = {
		keywords.suppression_immune,
	},
}

local precision_stance_fire_rate_base = precision_stance_talent_settings.cryptic_precision_stance_fire_rate_increased.ranged_attack_speed
local precision_stance_fire_rate_conditional_increase = precision_stance_talent_settings.cryptic_precision_stance_fire_rate_increased.increased_ranged_attack_speed - precision_stance_fire_rate_base

templates.cryptic_precision_stance_fire_rate_increased_base = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.ranged_attack_speed] = precision_stance_fire_rate_base,
	},
	start_func = function (template_data, template_context)
		template_data.precision_stance_active = false
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.precision_stance_active
	end,
	update_func = function (template_data, template_context, dt, t)
		template_data.precision_stance_active = template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance)
	end,
}
templates.cryptic_precision_stance_fire_rate_increased_delayed = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_precision_stance_fire_rate_increased",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	hud_priority = HUD_PRIORITIES.abilities,
	conditional_stat_buffs = {
		[stat_buffs.ranged_attack_speed] = precision_stance_fire_rate_conditional_increase,
	},
	start_func = function (template_data, template_context)
		template_data.precision_stance_active = false
		template_data.ranged_attack_speed_active = false
		template_data.reload_speed_boost_start_t = 0
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.ranged_attack_speed_active
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_precision_stance_active = template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance)

		if is_precision_stance_active and not template_data.precision_stance_active then
			template_data.precision_stance_active = true
			template_data.reload_speed_boost_start_t = t + precision_stance_talent_settings.cryptic_precision_stance_fire_rate_increased.buff_start_delay
		elseif not is_precision_stance_active and template_data.precision_stance_active then
			template_data.precision_stance_active = false
			template_data.reload_speed_boost_start_t = 0

			if template_data.ranged_attack_speed_active then
				template_data.ranged_attack_speed_active = false
			end
		elseif template_data.precision_stance_active and not template_data.ranged_attack_speed_active and t >= template_data.reload_speed_boost_start_t then
			template_data.ranged_attack_speed_active = true
		end
	end,
	related_talents = {
		"cryptic_precision_stance_fire_rate_increased",
	},
}
templates.cryptic_precision_stance_reload_speed_delayed = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_precision_stance_reload_speed_delayed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	hud_priority = HUD_PRIORITIES.abilities,
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = precision_stance_talent_settings.cryptic_precision_stance_reload_speed_delayed.reload_speed,
	},
	start_func = function (template_data, template_context)
		template_data.precision_stance_active = false
		template_data.reload_speed_active = false
		template_data.reload_speed_boost_start_t = 0
		template_data.reload_speed_boost_end_t = 0
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local fixed_t = FixedFrame.get_latest_fixed_time()

		return template_data.reload_speed_active or fixed_t < template_data.reload_speed_boost_end_t
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_precision_stance_active = template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance)

		if is_precision_stance_active and not template_data.precision_stance_active then
			template_data.precision_stance_active = true
			template_data.reload_speed_boost_start_t = t + precision_stance_talent_settings.cryptic_precision_stance_reload_speed_delayed.buff_start_delay
			template_data.reload_speed_boost_end_t = 0
		elseif not is_precision_stance_active and template_data.precision_stance_active then
			template_data.precision_stance_active = false
			template_data.reload_speed_boost_start_t = 0

			if template_data.reload_speed_active then
				template_data.reload_speed_active = false
				template_data.reload_speed_boost_end_t = t + precision_stance_talent_settings.cryptic_precision_stance_reload_speed_delayed.lingering_buff_time
			end
		elseif template_data.precision_stance_active and not template_data.reload_speed_active and t >= template_data.reload_speed_boost_start_t then
			template_data.reload_speed_active = true
		end
	end,
	duration_func = function (template_data, template_context)
		local fixed_t = FixedFrame.get_latest_fixed_time()

		if template_data.reload_speed_active then
			return 1
		elseif not template_data.reload_speed_active and fixed_t > template_data.reload_speed_boost_end_t then
			return 0
		end

		local duration_remaining = template_data.reload_speed_boost_end_t - fixed_t
		local duration_progress = duration_remaining / precision_stance_talent_settings.cryptic_precision_stance_reload_speed_delayed.lingering_buff_time

		return math.clamp01(duration_progress)
	end,
}
templates.cryptic_precision_stance_damage_on_elite_kill_stack = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_precision_stance_damage_on_elite_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = precision_stance_talent_settings.cryptic_precision_stance_damage_on_elite_kill.max_stacks,
	max_stacks_cap = precision_stance_talent_settings.cryptic_precision_stance_damage_on_elite_kill.max_stacks,
	duration = precision_stance_talent_settings.cryptic_precision_stance_damage_on_elite_kill.duration,
	hud_priority = HUD_PRIORITIES.abilities,
	stat_buffs = {
		[stat_buffs.damage] = precision_stance_talent_settings.cryptic_precision_stance_damage_on_elite_kill.damage,
	},
	related_talents = {
		"cryptic_precision_stance_damage_on_elite_kill",
	},
}

local precision_stance_hit_mass_base = precision_stance_talent_settings.cryptic_precision_stance_crit_cleave.ranged_max_hit_mass_attack_modifier
local precision_stance_hit_mass_conditional_increase = precision_stance_talent_settings.cryptic_precision_stance_crit_cleave.increased_ranged_max_hit_mass_attack_modifier - precision_stance_hit_mass_base
local precision_stance_crit_chance_base = precision_stance_talent_settings.cryptic_precision_stance_crit_cleave.ranged_critical_strike_chance
local precision_stance_crit_chance_conditional_increase = precision_stance_talent_settings.cryptic_precision_stance_crit_cleave.increased_ranged_critical_strike_chance - precision_stance_crit_chance_base

templates.cryptic_precision_stance_crit_cleave_base = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.ranged_max_hit_mass_attack_modifier] = precision_stance_hit_mass_base,
		[stat_buffs.ranged_critical_strike_chance] = precision_stance_crit_chance_base,
	},
	start_func = function (template_data, template_context)
		template_data.precision_stance_active = false
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.precision_stance_active
	end,
	update_func = function (template_data, template_context, dt, t)
		template_data.precision_stance_active = template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance)
	end,
}
templates.cryptic_precision_stance_crit_cleave_increased = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_precision_stance_crit_cleave",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	hud_priority = HUD_PRIORITIES.abilities,
	conditional_stat_buffs = {
		[stat_buffs.ranged_max_hit_mass_attack_modifier] = precision_stance_hit_mass_conditional_increase,
		[stat_buffs.ranged_critical_strike_chance] = precision_stance_crit_chance_conditional_increase,
	},
	start_func = function (template_data, template_context)
		template_data.precision_stance_active = false
		template_data.increased_crit_cleave_active = false
		template_data.increased_crit_cleave_boost_start_t = 0
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.increased_crit_cleave_active
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_precision_stance_active = template_context.buff_extension:has_keyword(keywords.cryptic_precision_stance)

		if is_precision_stance_active and not template_data.precision_stance_active then
			template_data.precision_stance_active = true
			template_data.increased_crit_cleave_boost_start_t = t + precision_stance_talent_settings.cryptic_precision_stance_fire_rate_increased.buff_start_delay
		elseif not is_precision_stance_active and template_data.precision_stance_active then
			template_data.precision_stance_active = false
			template_data.increased_crit_cleave_boost_start_t = 0

			if template_data.increased_crit_cleave_active then
				template_data.increased_crit_cleave_active = false
			end
		elseif template_data.precision_stance_active and not template_data.increased_crit_cleave_active and t >= template_data.increased_crit_cleave_boost_start_t then
			template_data.increased_crit_cleave_active = true
		end
	end,
	related_talents = {
		"cryptic_precision_stance_crit_cleave",
	},
}
templates.cryptic_discharge_weapon_malfunction = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			local hit_unit = params.attacked_unit

			return template_context.is_server and HEALTH_ALIVE[hit_unit] and params.damage_profile.name == "cryptic_discharge_weapon_malfunction_explosion"
		end,
	},
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			local hit_unit = params.attacked_unit
			local fixed_t = FixedFrame.get_latest_fixed_time()

			MinionState.apply_weapon_malfunction(hit_unit, fixed_t)

			local breed = params.breed_name and Breeds[params.breed_name]
			local is_target_breed_type = breed and breed.tags and breed.tags.elite and breed.ranged

			if template_context.is_server and is_target_breed_type then
				Managers.stats:record_private("hook_cryptic_weapon_malfunction_applied_elite_ranged", template_context.player)
			end
		end,
	},
}
templates.cryptic_discharge_weapon_shock_effect = {
	always_show_in_hud = true,
	class_name = "server_only_proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_discharge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = 1,
	duration = discharge_talent_settings.buff_duration,
	hud_priority = HUD_PRIORITIES.abilities,
	player_effects = {
		looping_wwise_start_event = "wwise/events/player/play_ability_cryptic_voltaic_buff_loop",
		looping_wwise_stop_event = "wwise/events/player/stop_ability_cryptic_voltaic_buff_loop",
		on_screen_effect = "content/fx/particles/screenspace/screen_voltaic_emitter_electric",
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local non_kill = CheckProcFunctions.on_non_kill(params, template_data, template_context, t)
		local ranged_or_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context, t) or CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t)

		return non_kill and ranged_or_melee_hit
	end,
	proc_func = function (params, template_data, template_context, t)
		local hit_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

		if buff_extension then
			local player_unit = template_context.unit

			buff_extension:add_internally_controlled_buff("cryptic_discharge_weapon_shock", t, "owner_unit", player_unit)
		end
	end,
	related_talents = {
		"cryptic_discharge",
	},
}
templates.cryptic_discharge_attack_speed_increase = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_discharge_attack_speed_increase",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	hud_priority = HUD_PRIORITIES.abilities,
	duration = discharge_talent_settings.two_charge_bonus.duration,
	stat_buffs = {
		[stat_buffs.attack_speed] = discharge_talent_settings.two_charge_bonus.attack_speed,
	},
	related_talents = {
		"cryptic_discharge_attack_speed_increase",
	},
}
templates.cryptic_discharge_toughness = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local hit_unit = params.attacked_unit

		return template_context.is_server and HEALTH_ALIVE[hit_unit] and params.damage_profile.name == "cryptic_discharge_explosion"
	end,
	proc_func = function (params, template_data, template_context, t)
		Toughness.replenish_percentage(template_context.unit, discharge_talent_settings.cryptic_discharge_toughness.toughness_percent_per_hit, false, "ability_shout")
	end,
}
templates.cryptic_chordclaw = {
	class_name = "proc_buff",
	duration = 10,
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = true,
	keywords = {
		keywords.cryptic_chordclaw,
		keywords.stun_immune,
	},
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local is_melee_kill = CheckProcFunctions.on_melee_kill(params, template_data, template_context, t)
		local has_kill_restore_charge_keyword = template_context.buff_extension:has_keyword(keywords.cryptic_chordclaw_kill_restores_charge)
		local can_restore_charge = has_kill_restore_charge_keyword

		return can_restore_charge and is_melee_kill
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.ability_extension:restore_ability_charge(COMBAT_ABILITY_TYPE, chordclaw_ability_talent_settings.num_charges_replenished_on_kill)
	end,
	stat_buffs = {
		[stat_buffs.melee_damage] = chordclaw_ability_talent_settings.melee_damage,
		[stat_buffs.consumed_hit_mass_modifier] = chordclaw_ability_talent_settings.consumed_hit_mass_modifier,
		[stat_buffs.melee_rending_multiplier] = 1,
	},
	stat_buff_multipliers = {
		[stat_buffs.melee_rending_multiplier] = function (template_data, template_context)
			local melee_rending_multiplier = chordclaw_ability_talent_settings.rending

			return melee_rending_multiplier
		end,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.combat_ability_component = unit_data_extension:write_component("combat_ability")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.ability_extension = ScriptUnit.extension(player_unit, "ability_system")
		template_data.talent_extension = ScriptUnit.extension(player_unit, "talent_system")
		template_data.combat_ability_charges_upon_use = template_data.ability_extension:ability_charges_used_on_activation(COMBAT_ABILITY_TYPE)
		template_data.ability_ended = false
		template_data.delayed_deactivation_t = nil
	end,
	stop_func = function (template_data, template_context)
		template_data.combat_ability_component.active = false
	end,
	conditional_exit_func = function (template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot
		local is_not_wielding_combat_ability_slot = wielded_slot ~= COMBAT_ABILITY_SLOT
		local fixed_t = FixedFrame.get_latest_fixed_time()

		if is_not_wielding_combat_ability_slot and not template_data.ability_ended then
			template_data.ability_ended = true
			template_data.delayed_deactivation_t = fixed_t
		end

		return template_data.ability_ended and fixed_t >= template_data.delayed_deactivation_t
	end,
}
templates.cryptic_chordclaw_capacitance_restoration = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_chordclaw_capacitance_restoration",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = true,
	active_duration = chordclaw_ability_talent_settings.cooldown_restoration.cooldown_regen_time,
	cooldown_replenished_over_time = chordclaw_ability_talent_settings.cooldown_restoration.cooldown_percent_over_time,
	cooldown_regen_time = chordclaw_ability_talent_settings.cooldown_restoration.cooldown_regen_time,
	hud_priority = HUD_PRIORITIES.abilities,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local damage_type = params.damage_type
		local is_melee_kill = CheckProcFunctions.on_melee_kill(params, template_data, template_context, t)
		local is_chordclaw_kill = damage_type == damage_types.transonic_claw or damage_type == damage_types.transonic_claw_stick or damage_type == damage_types.transonic_claw_rip

		return is_melee_kill and is_chordclaw_kill
	end,
	proc_func = function (params, template_data, template_context, t)
		return
	end,
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(player_unit, "ability_system")
		template_data.cooldown_to_regen_per_second = template_context.template.cooldown_replenished_over_time / template_context.template.cooldown_regen_time
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_context.buff:is_proc_active(t) then
			local cooldown_to_regen = template_data.cooldown_to_regen_per_second * dt

			template_data.ability_extension:reduce_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, cooldown_to_regen)
		end
	end,
}
templates.cryptic_chordclaw_consecutive_bonus = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_chordclaw_consecutive_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = chordclaw_ability_talent_settings.consecutive_bonus.max_stacks,
	max_stacks_cap = chordclaw_ability_talent_settings.consecutive_bonus.max_stacks,
	duration = chordclaw_ability_talent_settings.consecutive_bonus.duration,
	hud_priority = HUD_PRIORITIES.abilities,
	stat_buffs = {
		[stat_buffs.cryptic_chordclaw_damage] = chordclaw_ability_talent_settings.consecutive_bonus.chordclaw_damage,
	},
}
templates.cryptic_servo_skull_tagging_buff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.servo_skull_shooting_tagging.duration,
	stat_buffs = {
		[stat_buffs.minion_shoot_cooldown_modifier] = talent_settings.servo_skull_shooting_tagging.cooldown_modifier,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not ALIVE[unit] then
			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local template_effect_name = CompanionServoSkullSettings.empowered_template_name
		local effect_template = EffectTemplates[template_effect_name]
		local global_effect_id = fx_system:start_template_effect(effect_template, unit)

		template_data.fx_system = fx_system
		template_data.global_effect_id = global_effect_id
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not ALIVE[unit] then
			return
		end

		local fx_system = template_data.fx_system
		local global_effect_id = template_data.global_effect_id

		if global_effect_id and fx_system:has_running_template_effect_with_global_effect_id(global_effect_id) then
			fx_system:stop_template_effect(global_effect_id)
		end

		CompanionServoSkullAbility.finish_shooting_ability(template_context.unit)
	end,
}
templates.cryptic_servo_skull_medicae_buff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	duration = talent_settings.servo_skull_medicae.duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.servo_skull_medicae.tdr,
	},
	update_func = function (template_data, template_context, dt, t)
		local toughness = talent_settings.servo_skull_medicae.toughness_percent * dt

		Toughness.replenish_percentage(template_context.unit, toughness, false, "medicae_skull")
	end,
}
templates.cryptic_servo_skull_temporary_buff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	duration = talent_settings.servo_skull_shooting_base.duration,
	stat_buffs = {
		[stat_buffs.minion_shoot_cooldown_modifier] = talent_settings.servo_skull_shooting_base.cooldown_modifier,
		[stat_buffs.damage] = talent_settings.servo_skull_shooting_base.damage_modifier,
	},
	keywords = {
		keywords.training_ground_force_companion_in_combat_state,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not ALIVE[unit] then
			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local template_effect_name = CompanionServoSkullSettings.empowered_template_name
		local effect_template = EffectTemplates[template_effect_name]
		local global_effect_id = fx_system:start_template_effect(effect_template, unit)

		template_data.fx_system = fx_system
		template_data.global_effect_id = global_effect_id

		local owner_unit = template_context.owner_unit
		local player_buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")
		local fixed_t = FixedFrame.get_latest_fixed_time()

		if player_buff_extension then
			local _, buff_if = player_buff_extension:add_externally_controlled_buff("cryptic_servo_skull_order", fixed_t)

			template_data.on_hit_buff = buff_if
			template_data.player_buff_extension = player_buff_extension
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not ALIVE[unit] then
			return
		end

		local on_hit_buff = template_data.on_hit_buff
		local player_buff_extension = template_data.player_buff_extension

		if on_hit_buff and player_buff_extension then
			player_buff_extension:remove_externally_controlled_buff(on_hit_buff)
		end

		local game_mode_name = Managers.state.game_mode:game_mode_name()

		if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
			Managers.event:trigger("tg_on_servo_skull_empowered_finished")
		end

		local fx_system = template_data.fx_system
		local global_effect_id = template_data.global_effect_id

		if global_effect_id and fx_system:has_running_template_effect_with_global_effect_id(global_effect_id) then
			fx_system:stop_template_effect(global_effect_id)
		end
	end,
}
templates.cryptic_servo_skull_temporary_buff_player_dummy = table.clone(templates.cryptic_servo_skull_temporary_buff)
templates.cryptic_servo_skull_temporary_buff_player_dummy.stat_buffs = nil
templates.cryptic_servo_skull_temporary_buff_player_dummy.keywords = nil
templates.cryptic_servo_skull_temporary_buff_player_dummy.start_func = nil
templates.cryptic_servo_skull_temporary_buff_player_dummy.stop_func = nil
templates.cryptic_servo_skull_temporary_buff_player_dummy.hud_icon = "content/ui/textures/icons/throwables/hud/cryptic_servo_skull_order_shooting"
templates.cryptic_servo_skull_temporary_buff_player_dummy.skip_tactical_overlay = true
templates.cryptic_servo_skull_permanent_buff = table.clone(templates.cryptic_servo_skull_temporary_buff)
templates.cryptic_servo_skull_permanent_buff.keywords = nil
templates.cryptic_servo_skull_permanent_buff.duration = nil
templates.cryptic_servo_skull_permanent_buff.start_func = nil
templates.cryptic_servo_skull_permanent_buff.stop_func = nil

local max_burn_stacks = talent_settings.servo_skull_shooting_base.max_burn_stacks
local burning_buff = "flamer_assault"

templates.cryptic_servo_skull_order = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local companion_spawner_extension = ScriptUnit.extension(unit, "companion_spawner_system")

		template_data.companion_spawner_extension = companion_spawner_extension
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local companion_unit = template_data.companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)
		local attack_instigator_unit = params.attack_instigator_unit
		local hit_unit = params.attacked_unit

		if not HEALTH_ALIVE[hit_unit] or not HEALTH_ALIVE[hit_unit] or attack_instigator_unit ~= companion_unit then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local hit_unit = params.attacked_unit
		local hit_unit_buff_extension = hit_unit and ScriptUnit.has_extension(hit_unit, "buff_system")

		if hit_unit_buff_extension then
			hit_unit_buff_extension:add_internally_controlled_buff("cryptic_servo_skull_debuff", t)

			local current_stacks = hit_unit_buff_extension:current_stacks(burning_buff)

			if current_stacks < max_burn_stacks then
				hit_unit_buff_extension:add_internally_controlled_buff(burning_buff, t, "owner_unit", template_context.unit)
			else
				hit_unit_buff_extension:refresh_duration_of_stacking_buff(burning_buff, t, "owner_unit", template_context.unit)
			end
		end
	end,
}
templates.cryptic_servo_skull_debuff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.servo_skull_shooting_base.debuff_duration,
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = talent_settings.servo_skull_shooting_base.damage_taken_multiplier,
	},
}
templates.servo_skull_extra_grenade = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = talent_settings.servo_skull_extra_charges.extra_grenade_charges,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.has_extension(unit, "talent_system")
		local has_inject_ally = talent_extension and talent_extension:has_special_rule(special_rules.cryptic_servo_skull_inject_ally)

		template_data.allow_extra_grenade = has_inject_ally

		if has_inject_ally then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local template = template_context.template
			local extra_grenades = template.conditional_stat_buffs[stat_buffs.extra_max_amount_of_grenades]
			local grenade_ability_component = unit_data_extension:write_component("grenade_ability")

			template_context.initial_num_charges = grenade_ability_component.num_charges
			grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades
		end
	end,
	stop_func = function (template_data, template_context)
		if template_data.allow_extra_grenade then
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

			if unit_data_extension then
				local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
				local initial_num_charges = template_context.initial_num_charges

				grenade_ability_component.num_charges = math.min(grenade_ability_component.num_charges, initial_num_charges)
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.allow_extra_grenade
	end,
}
templates.servo_skull_inject_ally_invulnerable = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	keywords = {
		keywords.invulnerable,
	},
}
templates.cryptic_grenade_ability_force_field_active = {
	always_active = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_force_field",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	predicted = false,
	skip_tactical_overlay = false,
	force_field_duration = force_field_ability_talent_settings.duration,
	force_field_duration_increased = force_field_ability_talent_settings.increased_duration,
	hud_priority = HUD_PRIORITIES.abilities,
	keywords = {
		keywords.cryptic_grenade_ability_force_field,
		keywords.suppression_immune,
		keywords.count_as_dodge_vs_ranged,
	},
	conditional_keywords = {
		keywords.limit_health_damage_taken,
	},
	conditional_stat_buffs = {
		[stat_buffs.max_health_damage_taken_per_hit] = force_field_ability_talent_settings.max_health_damage_taken_per_hit,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.has_limit_damage_taken_talent
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local has_increased_duration_talent = talent_extension:has_special_rule(special_rules.cryptic_force_field_increased_duration_and_extra_explosion)

		template_data.force_field_duration = has_increased_duration_talent and template_context.template.force_field_duration_increased or template_context.template.force_field_duration
		template_data.has_limit_damage_taken_talent = talent_extension:has_special_rule(special_rules.cryptic_force_field_limit_damage_taken)
	end,
	duration_func = function (template_data, template_context)
		local start_time = template_context.buff:start_time()
		local t = FixedFrame.get_latest_fixed_time()
		local elapsed_time = t - start_time
		local percentage_left = math.clamp01(elapsed_time / template_data.force_field_duration)

		return 1 - percentage_left
	end,
	related_talents = {
		"cryptic_grenade_ability_force_field",
	},
}
templates.cryptic_grenade_ability_force_field_extra_charges = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = talent_settings.force_field_extra_charges.charges,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local buff_stat_buffs = template.stat_buffs.extra_max_amount_of_grenades
		local extra_grenades = buff_stat_buffs
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")

		template_context.initial_num_charges = grenade_ability_component.num_charges
		grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		local initial_num_charges = template_context.initial_num_charges

		grenade_ability_component.num_charges = math.min(grenade_ability_component.num_charges, initial_num_charges)
	end,
}
templates.cryptic_arc_grenades_capacitance_generation = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	capacitance_per_kill = arc_grenade_ability_talent_settings.capacitance_per_kill,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local is_elite_or_special_kill = CheckProcFunctions.any(CheckProcFunctions.on_elite_kill, CheckProcFunctions.on_special_kill)(params, template_data, template_context, t)

		if not is_elite_or_special_kill then
			return false
		end

		local damage_profile = params.damage_profile
		local name = damage_profile and damage_profile.name

		return name == "arc_grenade" or name == "arc_grenade_chain_jump_damage" or name == "cryptic_arc_grenade_shock_damage"
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local capacitance_per_kill = template_context.template.capacitance_per_kill

		template_data.ability_extension:reduce_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, capacitance_per_kill)
	end,
}
templates.cryptic_arc_grenades_weapon_malfunction = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local hit_unit = params.attacked_unit
		local name = params.damage_profile.name

		return HEALTH_ALIVE[hit_unit] and (name == "arc_grenade" or name == "arc_grenade_chain_jump_damage")
	end,
	proc_func = function (params, template_data, template_context)
		local hit_unit = params.attacked_unit
		local fixed_t = FixedFrame.get_latest_fixed_time()

		MinionState.apply_weapon_malfunction(hit_unit, fixed_t)

		local breed = params.breed_name and Breeds[params.breed_name]
		local is_target_breed_type = breed and breed.tags and breed.tags.elite and breed.ranged

		if template_context.is_server and is_target_breed_type then
			Managers.stats:record_private("hook_cryptic_weapon_malfunction_applied_elite_ranged", template_context.player)
		end
	end,
}
templates.cryptic_grenade_ability_arc_grenade_extra_arcs = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.arc_grenade_extra_arcs] = arc_grenade_ability_talent_settings.extra_arcs,
	},
}
templates.cryptic_power_generation_strength_base = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local ability_charges_used = params.ability_charges_used or 1

		template_context.buff_extension:add_internally_controlled_buff_with_stacks("cryptic_power_generation_strength_base_stack", ability_charges_used, t)
	end,
}
templates.cryptic_power_generation_strength_base_stack = {
	always_show_in_hud = true,
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_default_offensive_talent",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = power_generation_strength_keystone_talent_settings.max_stacks,
	max_stacks_cap = power_generation_strength_keystone_talent_settings.max_stacks,
	duration = power_generation_strength_keystone_talent_settings.duration,
	hud_priority = HUD_PRIORITIES.keystones,
	stepped_stat_buffs = {},
	related_talents = {
		"cryptic_power_generation_strength_base",
	},
}

for i = 1, power_generation_strength_keystone_talent_settings.max_stacks do
	table.insert(templates.cryptic_power_generation_strength_base_stack.stepped_stat_buffs, {
		[stat_buffs.power_level_modifier] = power_generation_strength_keystone_talent_settings.base_power_level_modifier + power_generation_strength_keystone_talent_settings.power_level_modifier_per_stack * i,
	})
end

local cryptic_power_generation_stats_for_charge_settings = power_generation_strength_keystone_talent_settings.cryptic_power_generation_stats_for_charge

templates.cryptic_power_generation_stats_for_charge = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = -cryptic_power_generation_stats_for_charge_settings.num_reduced_ability_charges,
		[stat_buffs.damage] = cryptic_power_generation_stats_for_charge_settings.damage,
		[stat_buffs.damage_taken_multiplier] = cryptic_power_generation_stats_for_charge_settings.damage_taken_multiplier,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")

		local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		template_data.ability_extension:set_ability_charges(COMBAT_ABILITY_TYPE, current_ability_charges - cryptic_power_generation_stats_for_charge_settings.num_reduced_ability_charges)
	end,
	related_talents = {
		"cryptic_power_generation_stats_for_charge",
	},
}

local power_generation_capacitance_for_charge_settings = power_generation_strength_keystone_talent_settings.cryptic_power_generation_capacitance_for_charge

templates.cryptic_power_generation_capacitance_for_charge = {
	class_name = "interval_buff",
	predicted = false,
	interval = power_generation_capacitance_for_charge_settings.interval,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = -power_generation_capacitance_for_charge_settings.num_reduced_ability_charges,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")

		local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		template_data.ability_extension:set_ability_charges(COMBAT_ABILITY_TYPE, current_ability_charges - power_generation_capacitance_for_charge_settings.num_reduced_ability_charges)
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t, dt)
		if not template_context.is_server then
			return
		end

		template_data.ability_extension:restore_ability_charge(GRENADE_ABILITY_TYPE, power_generation_capacitance_for_charge_settings.blitz_charges)
	end,
	related_talents = {
		"cryptic_power_generation_capacitance_for_charge",
	},
}

local power_generation_mini_bonus_settings = power_generation_strength_keystone_talent_settings.cryptic_power_generation_charges_mini_bonus
local power_generation_mini_bonus_target_num_current_charges_damage_bonus = {
	[power_generation_mini_bonus_settings.damage_bonus_valid_charge_one] = true,
	[power_generation_mini_bonus_settings.damage_bonus_valid_charge_two] = true,
	[power_generation_mini_bonus_settings.damage_bonus_valid_charge_three] = true,
}

templates.cryptic_power_generation_charges_mini_bonus_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = power_generation_mini_bonus_settings.num_increased_ability_charges,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage] = power_generation_mini_bonus_settings.damage,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
		template_data.gave_extra_ability_charge_on_start = false
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		return not not power_generation_mini_bonus_target_num_current_charges_damage_bonus[current_ability_charges]
	end,
	post_update_keywords_and_stats_func = function (template_data, template_context, dt, t)
		if not template_data.gave_extra_ability_charge_on_start then
			template_data.gave_extra_ability_charge_on_start = true

			local ability_extension = template_data.ability_extension
			local current_ability_charges = ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

			ability_extension:set_ability_charges(COMBAT_ABILITY_TYPE, current_ability_charges + power_generation_mini_bonus_settings.num_increased_ability_charges)
		end
	end,
	related_talents = {
		"cryptic_power_generation_charges_mini_bonus",
	},
}

local power_generation_mini_bonus_target_num_current_charges_toughness_regen_bonus = {
	[power_generation_mini_bonus_settings.toughness_regen_bonus_valid_charge_one] = true,
	[power_generation_mini_bonus_settings.toughness_regen_bonus_valid_charge_two] = true,
	[power_generation_mini_bonus_settings.toughness_regen_bonus_valid_charge_three] = true,
}

templates.cryptic_power_generation_charges_mini_bonus_toughness_regen = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.toughness_replenish_modifier] = power_generation_mini_bonus_settings.toughness_replenish_modifier,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		return not not power_generation_mini_bonus_target_num_current_charges_toughness_regen_bonus[current_ability_charges]
	end,
	related_talents = {
		"cryptic_power_generation_charges_mini_bonus",
	},
}

local power_generation_capacitance_bonuses_settings = power_generation_strength_keystone_talent_settings.cryptic_power_generation_capacitance_bonuses

templates.cryptic_power_generation_capacitance_bonuses_decreased_cooldown_regen = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = power_generation_capacitance_bonuses_settings.num_increased_ability_charges,
	},
	conditional_stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = power_generation_capacitance_bonuses_settings.cooldown_regen_modifier_low,
		[stat_buffs.combat_ability_cooldown_replenish_modifier] = power_generation_capacitance_bonuses_settings.cooldown_regen_modifier_low,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
		template_data.gave_extra_ability_charge_on_start = false
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		return current_ability_charges < power_generation_capacitance_bonuses_settings.reduced_cooldown_regen_target_charges
	end,
	post_update_keywords_and_stats_func = function (template_data, template_context, dt, t)
		if not template_data.gave_extra_ability_charge_on_start then
			template_data.gave_extra_ability_charge_on_start = true

			local ability_extension = template_data.ability_extension
			local current_ability_charges = ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

			ability_extension:set_ability_charges(COMBAT_ABILITY_TYPE, current_ability_charges + power_generation_capacitance_bonuses_settings.num_increased_ability_charges)
		end
	end,
	related_talents = {
		"cryptic_power_generation_capacitance_bonuses",
	},
}
templates.cryptic_power_generation_capacitance_bonuses_increased_cooldown_regen = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = power_generation_capacitance_bonuses_settings.cooldown_regen_modifier_high,
		[stat_buffs.combat_ability_cooldown_replenish_modifier] = power_generation_capacitance_bonuses_settings.cooldown_regen_modifier_high,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		return current_ability_charges >= power_generation_capacitance_bonuses_settings.increased_cooldown_regen_target_charges
	end,
	related_talents = {
		"cryptic_power_generation_capacitance_bonuses",
	},
}
templates.cryptic_dissector = {
	class_name = "server_only_proc_buff",
	predicted = false,
	stacks_needed_for_penance = dissector_keystone_talent_settings.max_stacks,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.has_combat_ability_restores_stacks_talent = template_data.talent_extension:has_special_rule(special_rules.cryptic_dissector_combat_ability_restores_stacks)

		local has_extra_max_stacks_talent = template_data.talent_extension:has_special_rule(special_rules.cryptic_dissector_extra_max_stacks)

		template_data.num_max_stacks = dissector_keystone_talent_settings.max_stacks + (has_extra_max_stacks_talent and dissector_keystone_talent_settings.extra_max_stacks or 0)
		template_data.stack_lost_cooldown_end_t = 0
		template_data.buff_stacks_index = Script.new_array(template_data.num_max_stacks)

		local stacks_to_add = template_data.num_max_stacks
		local fixed_t = FixedFrame.get_latest_fixed_time()
		local _, base_stacking_buff_index, _ = template_context.buff_extension:add_externally_controlled_buff("cryptic_dissector_stack", fixed_t)

		template_data.base_stacking_buff_index = base_stacking_buff_index

		for i = 1, stacks_to_add do
			local _, buff_index = template_context.buff_extension:add_externally_controlled_buff("cryptic_dissector_stack", fixed_t)

			table.insert(template_data.buff_stacks_index, buff_index)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local current_stacks = #template_data.buff_stacks_index

		for i = current_stacks, 1, -1 do
			local buff_index_to_remove = template_data.buff_stacks_index[i]

			if template_context.buff_extension:has_running_buff_with_index(buff_index_to_remove) then
				template_context.buff_extension:remove_externally_controlled_buff(buff_index_to_remove)
			end
		end

		if template_context.buff_extension:has_running_buff_with_index(template_data.base_stacking_buff_index) then
			template_context.buff_extension:remove_externally_controlled_buff(template_data.base_stacking_buff_index)
		end
	end,
	proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_damage_taken] = 1,
		[proc_events.on_combat_ability] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_kill] = CheckProcFunctions.any(CheckProcFunctions.on_elite_kill, CheckProcFunctions.on_special_kill),
		[proc_events.on_damage_taken] = function (params, template_data, template_context, t)
			if params.attacked_unit ~= template_context.unit or params.damage_amount <= 0 and params.toughness_damage_amount <= 0 then
				return false
			end

			local has_stacks = template_context.buff_extension:current_stacks("cryptic_dissector_stack") > 1

			return has_stacks and t >= template_data.stack_lost_cooldown_end_t
		end,
		[proc_events.on_combat_ability] = function (params, template_data, template_context, t)
			return template_data.has_combat_ability_restores_stacks_talent
		end,
	},
	specific_proc_func = {
		[proc_events.on_kill] = function (params, template_data, template_context, t)
			local current_stacks = template_context.buff_extension:current_stacks("cryptic_dissector_stack") - 1
			local missing_stacks = template_data.num_max_stacks - current_stacks

			if missing_stacks > 0 then
				local stacks_to_add = math.min(dissector_keystone_talent_settings.stacks_per_elite_or_special_kill, missing_stacks)

				for i = 1, stacks_to_add do
					local _, buff_index = template_context.buff_extension:add_externally_controlled_buff("cryptic_dissector_stack", t)

					table.insert(template_data.buff_stacks_index, buff_index)
				end
			end

			Toughness.replenish_percentage(template_context.unit, dissector_keystone_talent_settings.toughness_regen_percent_per_elite_or_special_kill, false, "cryptic_talent")
		end,
		[proc_events.on_damage_taken] = function (params, template_data, template_context, t)
			template_data.stack_lost_cooldown_end_t = t + dissector_keystone_talent_settings.stacks_lost_on_damage_taken_cooldown

			local current_stacks = template_context.buff_extension:current_stacks("cryptic_dissector_stack") - 1
			local stacks_to_lose = math.min(dissector_keystone_talent_settings.stacks_lost_on_damage_taken, current_stacks)

			for i = 1, stacks_to_lose do
				local buff_index_to_remove = template_data.buff_stacks_index[#template_data.buff_stacks_index]

				if template_context.buff_extension:has_running_buff_with_index(buff_index_to_remove) then
					template_context.buff_extension:remove_externally_controlled_buff(buff_index_to_remove)
				end

				table.remove(template_data.buff_stacks_index, #template_data.buff_stacks_index)
			end
		end,
		[proc_events.on_combat_ability] = function (params, template_data, template_context, t)
			local current_stacks = template_context.buff_extension:current_stacks("cryptic_dissector_stack") - 1
			local stacks_to_add = template_data.num_max_stacks - current_stacks

			if stacks_to_add > 0 then
				for i = 1, stacks_to_add do
					local _, buff_index = template_context.buff_extension:add_externally_controlled_buff("cryptic_dissector_stack", t)

					table.insert(template_data.buff_stacks_index, buff_index)
				end
			end
		end,
	},
	update_func = function (template_data, template_context, dt, t)
		if template_context.is_server then
			local current_stacks = template_context.buff_extension:current_stacks("cryptic_dissector_stack") - 1

			if current_stacks >= template_context.template.stacks_needed_for_penance then
				Managers.stats:record_private("hook_cryptic_dissector_update_time_at_required_stacks", template_context.player, dt)
			end
		end
	end,
}
templates.cryptic_dissector_stack = {
	always_active = true,
	always_show_in_hud = true,
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_dissector",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	stack_offset = -1,
	max_stacks = dissector_keystone_talent_settings.max_stacks,
	max_stacks_cap = dissector_keystone_talent_settings.max_stacks,
	hud_priority = HUD_PRIORITIES.keystones,
	stat_buffs = {
		[stat_buffs.damage] = dissector_keystone_talent_settings.damage,
	},
	stepped_stat_buffs = {},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = dissector_keystone_talent_settings.critical_strike_chance,
		[stat_buffs.melee_attack_speed] = dissector_keystone_talent_settings.melee_attack_speed,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.give_crit_and_attack_speed
	end,
	start_func = function (template_data, template_context)
		template_data.talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")
		template_data.give_crit_and_attack_speed = template_data.talent_extension:has_special_rule(special_rules.cryptic_dissector_gives_crit_and_attack_speed)

		if template_data.talent_extension:has_special_rule(special_rules.cryptic_dissector_extra_max_stacks) then
			template_context.buff:add_max_stacks(dissector_keystone_talent_settings.extra_max_stacks)
			template_context.buff:add_max_stacks_cap(dissector_keystone_talent_settings.extra_max_stacks)
		end
	end,
	related_talents = {
		"cryptic_dissector",
	},
}

for i = 1, dissector_keystone_talent_settings.max_stacks + dissector_keystone_talent_settings.extra_max_stacks do
	table.insert(templates.cryptic_dissector_stack.stepped_stat_buffs, {
		[stat_buffs.toughness_damage_taken_multiplier] = 1 - dissector_keystone_talent_settings.toughness_damage_taken_multiplier * i,
	})
end

local function _trigger_overload_keystone(params, template_data, template_context, t)
	if not template_context.is_server then
		return
	end

	local buff_extension = template_context.buff_extension

	buff_extension:remove_externally_controlled_buff_stacks(template_data.buff_stacks_index)
	table.clear(template_data.buff_stacks_index)

	local player_unit = template_context.unit
	local player_position = POSITION_LOOKUP[player_unit]

	if template_data.has_aoe_debuff_talent then
		local target_explosion_template = ExplosionTemplates.cryptic_overload_keystone_debuff_explosion

		Explosion.create_explosion(template_context.world, template_context.physics_world, player_position, Quaternion.identity(), player_unit, target_explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	else
		local player_fx_extension = template_data.player_fx_extension

		template_data.fx_system:trigger_vfx("content/fx/particles/abilities/cryptic/cryptic_force_field_electric_explosion", player_position)
		player_fx_extension:trigger_wwise_event_synced("wwise/events/player/play_player_ability_discharge_light", true, false, nil, player_unit)
	end

	if template_data.has_permanent_boosts_talent then
		template_data.num_keystone_triggers = template_data.num_keystone_triggers + 1

		local next_trigger_target = template_data.permanent_buffs_to_give_per_trigger_count[template_data.next_permanent_buffs_to_give_index]

		if next_trigger_target and next_trigger_target.num_triggers_needed <= template_data.num_keystone_triggers then
			local _, buff_index, _ = buff_extension:add_externally_controlled_buff(next_trigger_target.buff_to_give, t, "owner_unit", player_unit)

			table.insert(template_data.keystone_perma_stacks_buffs_index, buff_index)

			template_data.next_permanent_buffs_to_give_index = template_data.next_permanent_buffs_to_give_index + 1
		end

		if next_trigger_target then
			local _, buff_index, _ = buff_extension:add_externally_controlled_buff("cryptic_overload_keystone_triggered_counter", t)

			table.insert(template_data.keystone_triggered_counter_buffs_index, buff_index)
		end
	end

	local units_in_coherency = template_data.coherency_extension:in_coherence_units()

	for coherency_unit in pairs(units_in_coherency) do
		local unit_data_extension = ScriptUnit.has_extension(coherency_unit, "unit_data_system")
		local is_companion_unit = unit_data_extension and unit_data_extension:is_companion()

		if not is_companion_unit then
			local coherency_unit_buff_extension = ScriptUnit.has_extension(coherency_unit, "buff_system")

			coherency_unit_buff_extension:add_internally_controlled_buff("cryptic_overload_keystone_allies_buff", t)

			if template_data.has_restores_toughness_and_stamina_talent then
				Toughness.replenish_percentage(coherency_unit, overload_keystone_talent_settings.toughness_percent_restored, false, "cryptic_talent")
				Stamina.add_stamina_percent(coherency_unit, overload_keystone_talent_settings.stamina_percent_restored)
			end
		end
	end

	Managers.stats:record_private("hook_cryptic_overload_keystone_triggered", template_context.player)
end

local function _add_overload_stack(num_stacks_to_add, params, template_data, template_context, t)
	if not template_context.is_server then
		return
	end

	local max_stacks = template_data.num_max_stacks
	local current_stacks = template_context.buff_extension:current_stacks("cryptic_overload_keystone_stack") - 1

	if max_stacks <= current_stacks + num_stacks_to_add then
		_trigger_overload_keystone(params, template_data, template_context, t)

		return
	end

	for i = 1, num_stacks_to_add do
		local _, buff_index, _ = template_context.buff_extension:add_externally_controlled_buff("cryptic_overload_keystone_stack", t)

		table.insert(template_data.buff_stacks_index, buff_index)
	end
end

local num_overload_keystone_permanent_buffs = #overload_keystone_talent_settings.permanent_buffs_to_give_per_trigger_count
local num_overload_keystone_triggers_for_full_permanent_stacks = overload_keystone_talent_settings.permanent_buffs_to_give_per_trigger_count[num_overload_keystone_permanent_buffs].num_triggers_needed

templates.cryptic_overload_keystone = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = false,
	predicted = false,
	num_stacks_to_add = overload_keystone_talent_settings.stacks_per_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()

		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.player_fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.has_aoe_debuff_talent = template_data.talent_extension:has_special_rule(special_rules.cryptic_overload_keystone_aoe_debuff)
		template_data.has_restores_toughness_and_stamina_talent = template_data.talent_extension:has_special_rule(special_rules.cryptic_overload_keystone_explosion_restores_toughness_and_stamina)
		template_data.has_gain_stacks_per_combat_ability_charge_used = template_data.talent_extension:has_special_rule(special_rules.cryptic_overload_keystone_gain_stacks_per_combat_ability_charge_used)
		template_data.has_permanent_boosts_talent = template_data.talent_extension:has_special_rule(special_rules.cryptic_overload_keystone_gives_permanent_boosts)

		if template_data.has_permanent_boosts_talent then
			template_data.num_keystone_triggers = 0
			template_data.next_permanent_buffs_to_give_index = 1
			template_data.permanent_buffs_to_give_per_trigger_count = overload_keystone_talent_settings.permanent_buffs_to_give_per_trigger_count

			if template_context.is_server then
				template_data.keystone_perma_stacks_buffs_index = Script.new_array(num_overload_keystone_permanent_buffs)
				template_data.keystone_triggered_counter_buffs_index = Script.new_array(num_overload_keystone_triggers_for_full_permanent_stacks)
			end
		end

		template_data.num_max_stacks = overload_keystone_talent_settings.max_stacks

		if template_context.is_server then
			template_data.buff_stacks_index = Script.new_array(template_data.num_max_stacks)
		end

		local _, base_stacking_buff_index, _ = template_context.buff_extension:add_externally_controlled_buff("cryptic_overload_keystone_stack", t)

		template_data.base_stacking_buff_index = base_stacking_buff_index

		if template_context.is_server then
			template_data.fx_system = Managers.state.extension:system("fx_system")

			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase

			template_data.broadphase = broadphase

			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[unit]
			local enemy_side_names = side:relation_side_names("enemy")

			template_data.enemy_side_names = enemy_side_names

			template_context.buff.event_add_overload_stack = function (buff, target_player, num_stacks)
				local fixed_t = FixedFrame.get_latest_fixed_time()

				if template_context.player == target_player then
					_add_overload_stack(num_stacks, nil, template_data, template_context, fixed_t)
				end
			end

			Managers.event:register(template_context.buff, "cryptic_buffs_event_give_overload_keystone_stacks", "event_add_overload_stack")
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		Managers.event:unregister(template_context.buff, "cryptic_buffs_event_give_overload_keystone_stacks")

		local current_stacks = #template_data.buff_stacks_index

		for i = current_stacks, 1, -1 do
			local buff_index_to_remove = template_data.buff_stacks_index[i]

			if template_context.buff_extension:has_running_buff_with_index(buff_index_to_remove) then
				template_context.buff_extension:remove_externally_controlled_buff(buff_index_to_remove)
			end
		end

		if template_context.buff_extension:has_running_buff_with_index(template_data.base_stacking_buff_index) then
			template_context.buff_extension:remove_externally_controlled_buff(template_data.base_stacking_buff_index)
		end

		if template_data.has_permanent_boosts_talent then
			local current_permanent_stacks = #template_data.keystone_perma_stacks_buffs_index

			for i = current_permanent_stacks, 1, -1 do
				local buff_index_to_remove = template_data.keystone_perma_stacks_buffs_index[i]

				if template_context.buff_extension:has_running_buff_with_index(buff_index_to_remove) then
					template_context.buff_extension:remove_externally_controlled_buff(buff_index_to_remove)
				end
			end

			local current_trigger_counter_stacks = #template_data.keystone_triggered_counter_buffs_index

			for i = current_trigger_counter_stacks, 1, -1 do
				local buff_index_to_remove = template_data.keystone_triggered_counter_buffs_index[i]

				if template_context.buff_extension:has_running_buff_with_index(buff_index_to_remove) then
					template_context.buff_extension:remove_externally_controlled_buff(buff_index_to_remove)
				end
			end
		end
	end,
	proc_events = {
		[proc_events.on_minion_death] = 1,
		[proc_events.on_combat_ability] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_minion_death] = function (params, template_data, template_context, t)
			local attacking_unit = params.attacking_unit

			if not attacking_unit then
				return false
			end

			local attacking_unit_player_owner = Managers.state.player_unit_spawn:owner(attacking_unit)

			if not attacking_unit_player_owner then
				return false
			end

			local player_unit = template_context.unit
			local is_in_coherency = template_data.coherency_extension:is_unit_in_coherency(attacking_unit)

			return is_in_coherency
		end,
		[proc_events.on_combat_ability] = function (params, template_data, template_context, t)
			if not template_data.has_gain_stacks_per_combat_ability_charge_used then
				return false
			end

			local ability_charges_used = params.ability_charges_used or 1

			return ability_charges_used > 0
		end,
	},
	specific_proc_func = {
		[proc_events.on_minion_death] = function (params, template_data, template_context, t)
			local is_elite_or_special_kill = CheckProcFunctions.on_elite_kill(params, template_data, template_context, t) or CheckProcFunctions.on_special_kill(params, template_data, template_context, t)
			local num_stacks_gained = not is_elite_or_special_kill and overload_keystone_talent_settings.num_stacks_per_kill or overload_keystone_talent_settings.num_stacks_per_elite_or_special_kill

			_add_overload_stack(num_stacks_gained, params, template_data, template_context, t)
		end,
		[proc_events.on_combat_ability] = function (params, template_data, template_context, t)
			local ability_charges_used = params.ability_charges_used or 1

			_add_overload_stack(ability_charges_used * overload_keystone_talent_settings.num_stacks_gained_per_combat_ability_charge, params, template_data, template_context, t)
		end,
	},
}
templates.cryptic_overload_keystone_stack = {
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_overload",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	stack_offset = -1,
	max_stacks = overload_keystone_talent_settings.max_stacks,
	max_stacks_cap = overload_keystone_talent_settings.max_stacks,
	hud_priority = HUD_PRIORITIES.keystones,
	related_talents = {
		"cryptic_overload_keystone",
	},
}
templates.cryptic_overload_keystone_triggered_counter = {
	always_show_in_hud = true,
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_overload_keystone_permastack",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	skip_tactical_overlay = true,
	max_stacks = num_overload_keystone_triggers_for_full_permanent_stacks,
	max_stacks_cap = num_overload_keystone_triggers_for_full_permanent_stacks,
	hud_priority = HUD_PRIORITIES.keystones,
}
templates.cryptic_overload_keystone_allies_buff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = overload_keystone_talent_settings.allies_buff_duration,
	stat_buffs = {
		[stat_buffs.damage] = overload_keystone_talent_settings.damage,
		[stat_buffs.toughness_damage_taken_multiplier] = overload_keystone_talent_settings.toughness_damage_taken_multiplier,
	},
}
templates.cryptic_overload_keystone_increase_damage_taken_debuff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = overload_keystone_talent_settings.aoe_damage_taken_multiplier_debuff_duration,
	keywords = {
		keywords.electrocuted,
	},
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = overload_keystone_talent_settings.aoe_damage_taken_multiplier_debuff,
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_arclightning",
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
templates.cryptic_overload_keystone_permanent_increase_damage = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage] = overload_keystone_talent_settings.permanent_damage,
	},
}
templates.cryptic_overload_keystone_permanent_reduce_toughness_damage_taken = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = overload_keystone_talent_settings.permanent_toughness_damage_taken_multiplier,
	},
}
templates.cryptic_overload_keystone_permanent_increase_cooldown_regen = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = overload_keystone_talent_settings.permanent_combat_ability_cooldown_regen_modifier,
		[stat_buffs.combat_ability_cooldown_replenish_modifier] = overload_keystone_talent_settings.permanent_combat_ability_cooldown_regen_modifier,
	},
}
templates.cryptic_redline = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = redline_keystone_talent_settings.ability_extra_charges,
	},
	conditional_stat_buffs = {
		[stat_buffs.rending_multiplier] = redline_keystone_talent_settings.cryptic_redline_rending.rending_multiplier,
	},
	start_func = function (template_data, template_context)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		template_data.has_rending_while_at_stacks_talent = talent_extension:has_special_rule("cryptic_redline_gives_rending_while_above_stacks")
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
		template_data.gave_extra_ability_charge_on_start = false
	end,
	post_update_keywords_and_stats_func = function (template_data, template_context, dt, t)
		if not template_data.gave_extra_ability_charge_on_start then
			template_data.gave_extra_ability_charge_on_start = true

			local ability_extension = template_data.ability_extension
			local current_ability_charges = ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

			ability_extension:set_ability_charges(COMBAT_ABILITY_TYPE, current_ability_charges + redline_keystone_talent_settings.ability_extra_charges)
		end
	end,
	proc_events = {
		[proc_events.on_combat_ability_charge_replenished] = 1,
		[proc_events.on_combat_ability_charge_consumed] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local num_stacks = params.num_charges_gained or params.num_charges_consumed or 1

		template_context.buff_extension:add_internally_controlled_buff_with_stacks("cryptic_redline_stack", num_stacks, t)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		if not template_data.has_rending_while_at_stacks_talent then
			return false
		end

		local currently_held_stacks = template_context.buff_extension:current_stacks("cryptic_redline_stack")

		return currently_held_stacks >= redline_keystone_talent_settings.cryptic_redline_rending.num_stacks_needed
	end,
}
templates.cryptic_redline_stack = {
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_redline",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = true,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	max_stacks = redline_keystone_talent_settings.max_stacks,
	max_stacks_cap = redline_keystone_talent_settings.max_stacks,
	duration = redline_keystone_talent_settings.duration,
	hud_priority = HUD_PRIORITIES.keystones,
	stepped_stat_buffs = {},
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = redline_keystone_talent_settings.combat_ability_cooldown_regen_modifier,
		[stat_buffs.combat_ability_cooldown_replenish_modifier] = redline_keystone_talent_settings.combat_ability_cooldown_regen_modifier,
	},
	start_func = function (template_data, template_context)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")
		local has_extra_max_stacks_talent = talent_extension:has_special_rule("cryptic_redline_has_extra_max_stacks")

		if has_extra_max_stacks_talent then
			template_data.extra_max_stacks = redline_keystone_talent_settings.cryptic_redline_extra_max_stacks.extra_redline_max_stacks
			template_data.extra_max_stacks_cap = redline_keystone_talent_settings.cryptic_redline_extra_max_stacks.extra_redline_max_stacks
		end
	end,
	related_talents = {
		"cryptic_redline",
	},
}

for i = 1, redline_keystone_talent_settings.max_stacks + redline_keystone_talent_settings.cryptic_redline_extra_max_stacks.extra_redline_max_stacks do
	table.insert(templates.cryptic_redline_stack.stepped_stat_buffs, {
		[stat_buffs.toughness_damage_taken_multiplier] = 1 - redline_keystone_talent_settings.toughness_damage_taken_multiplier_step * i,
	})
end

templates.cryptic_redline_strength = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local remaining_ability_charges_before_use = params.remaining_ability_charges_before_use or 1

		template_context.buff_extension:add_internally_controlled_buff_with_stacks("cryptic_redline_strength_stack", remaining_ability_charges_before_use, t)
	end,
}
templates.cryptic_redline_strength_stack = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_redline_strength",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = redline_keystone_talent_settings.cryptic_redline_strength.max_stacks,
	max_stacks_cap = redline_keystone_talent_settings.cryptic_redline_strength.max_stacks,
	duration = redline_keystone_talent_settings.cryptic_redline_strength.duration,
	hud_priority = HUD_PRIORITIES.keystones,
	stat_buffs = {
		[stat_buffs.power_level_modifier] = redline_keystone_talent_settings.cryptic_redline_strength.power_level_modifier_per_stack,
	},
	related_talents = {
		"cryptic_redline_strength",
	},
}
templates.cryptic_redline_extra_max_stacks = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = redline_keystone_talent_settings.cryptic_redline_extra_max_stacks.ability_extra_charges,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
		template_data.gave_extra_ability_charge_on_start = false
	end,
	post_update_keywords_and_stats_func = function (template_data, template_context, dt, t)
		if not template_data.gave_extra_ability_charge_on_start then
			template_data.gave_extra_ability_charge_on_start = true

			local ability_extension = template_data.ability_extension
			local current_ability_charges = ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

			ability_extension:set_ability_charges(COMBAT_ABILITY_TYPE, current_ability_charges + redline_keystone_talent_settings.cryptic_redline_extra_max_stacks.ability_extra_charges)
		end
	end,
}
templates.cryptic_redline_toughness = _toughness_regen_over_time_on_proc_generator()
templates.cryptic_redline_toughness.active_duration = redline_keystone_talent_settings.cryptic_redline_toughness.duration
templates.cryptic_redline_toughness.hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_redline_toughness"
templates.cryptic_redline_toughness.toughness_restored_on_proc = redline_keystone_talent_settings.cryptic_redline_toughness.toughness_restored
templates.cryptic_redline_toughness.toughness_regen_per_second = redline_keystone_talent_settings.cryptic_redline_toughness.toughness_restored / redline_keystone_talent_settings.cryptic_redline_toughness.duration
templates.cryptic_redline_toughness.check_proc_func = nil
templates.cryptic_redline_toughness.proc_events = {
	[proc_events.on_combat_ability_charge_replenished] = 1,
	[proc_events.on_combat_ability_charge_consumed] = 1,
}

local crits_grant_power_target_cd_time_to_gain = talent_settings.cryptic_crits_grant_power.cooldown_regen * talent_settings.general.combat_ability_cooldown_time
local crits_grant_power_cooldown_over_time_regen_modifier = crits_grant_power_target_cd_time_to_gain / talent_settings.cryptic_crits_grant_power.cooldown_regen_time

templates.cryptic_crits_grant_power = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	force_predicted_proc = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_crits_grant_power",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_crits_grant_power.cooldown_regen_time,
	hud_priority = HUD_PRIORITIES.talents,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	proc_stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = crits_grant_power_cooldown_over_time_regen_modifier,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	proc_func = function (params, template_data, template_context, t)
		return
	end,
}
templates.cryptic_weakspot_kills_grant_power = {
	class_name = "server_only_proc_buff",
	predicted = false,
	cooldown_replenished_on_proc = talent_settings.cryptic_weakspot_kills_grant_power.cooldown_replenished_on_proc,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
	proc_func = function (params, template_data, template_context, t)
		local cooldown_to_restore = template_context.template.cooldown_replenished_on_proc

		if cooldown_to_restore > 0 then
			template_data.ability_extension:reduce_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, cooldown_to_restore)
		end
	end,
}
templates.cryptic_multi_hits_grant_power = {
	class_name = "server_only_proc_buff",
	predicted = false,
	buff_data = {
		required_num_hits = talent_settings.cryptic_multi_hits_grant_power.num_hits,
	},
	cooldown_replenished_on_proc = talent_settings.cryptic_multi_hits_grant_power.cooldown_replenished_on_proc,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.multi_hit_window_end_t = 0
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local buff_data = template_context.template.buff_data
		local required_num_hits = buff_data.required_num_hits
		local target_number = params.target_number > 0 and params.target_number or params.target_index
		local should_proc = target_number and target_number == required_num_hits or false

		if t >= template_data.multi_hit_window_end_t and should_proc then
			template_data.multi_hit_window_end_t = t + talent_settings.cryptic_multi_hits_grant_power.multi_hit_window

			return true
		end

		return false
	end,
	proc_func = function (params, template_data, template_context, t)
		local cooldown_to_restore = template_context.template.cooldown_replenished_on_proc

		if cooldown_to_restore > 0 then
			template_data.ability_extension:reduce_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, cooldown_to_restore)
		end
	end,
}

local increased_passive_cooldown_regen_percent_value = talent_settings.general.combat_ability_cooldown_time / (1 / talent_settings.cryptic_increased_passive_cooldown_regen.cooldown_percent_regen_per_second)

templates.cryptic_increased_passive_cooldown_regen = {
	class_name = "buff",
	predicted = false,
	cooldown_regen_per_second = talent_settings.cryptic_increased_passive_cooldown_regen.cooldown_percent_regen_per_second,
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = increased_passive_cooldown_regen_percent_value,
	},
}
templates.cryptic_passive_cooldown_regen = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = 0,
	},
}
templates.cryptic_multi_hits_restore_toughness = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_multi_hits_restore_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_multi_hits_restore_toughness.toughness_regen_time,
	hud_priority = HUD_PRIORITIES.talents,
	toughness_regen_per_second = talent_settings.cryptic_multi_hits_restore_toughness.toughness_regen / talent_settings.cryptic_multi_hits_restore_toughness.toughness_regen_time,
	buff_data = {
		required_num_hits = talent_settings.cryptic_multi_hits_restore_toughness.num_hits,
	},
	start_func = function (template_data, template_context)
		template_data.multi_hit_window_end_t = 0
		template_data.multi_hit_procced = false
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local buff_data = template_context.template.buff_data
		local required_num_hits = buff_data.required_num_hits
		local target_number = params.target_number > 0 and params.target_number or params.target_index
		local should_proc = target_number and target_number == required_num_hits or false

		if t >= template_data.multi_hit_window_end_t and should_proc then
			template_data.multi_hit_window_end_t = t + talent_settings.cryptic_multi_hits_restore_toughness.multi_hit_window

			return true
		end

		return false
	end,
	proc_func = function (params, template_data, template_context, t)
		return
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_regen_active = template_context.buff:is_proc_active(t)

		if is_regen_active and template_context.is_server then
			local toughness_to_regen = template_context.template.toughness_regen_per_second * dt

			Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
		end
	end,
}
templates.cryptic_weakspot_kills_restore_toughness = {
	class_name = "server_only_proc_buff",
	predicted = false,
	toughness_restored_on_proc = talent_settings.cryptic_weakspot_kills_restore_toughness.toughness_restored,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
	proc_func = function (params, template_data, template_context, t)
		local toughness_to_regen = template_context.template.toughness_restored_on_proc

		Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
	end,
}
templates.cryptic_crits_grant_tdr = _toughness_regen_over_time_on_proc_generator()
templates.cryptic_crits_grant_tdr.active_duration = talent_settings.cryptic_crits_grant_tdr.duration
templates.cryptic_crits_grant_tdr.hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_crits_grant_tdr"
templates.cryptic_crits_grant_tdr.toughness_restored_on_proc = talent_settings.cryptic_crits_grant_tdr.toughness_restored
templates.cryptic_crits_grant_tdr.toughness_regen_per_second = talent_settings.cryptic_crits_grant_tdr.toughness_restored / talent_settings.cryptic_crits_grant_tdr.duration
templates.cryptic_crits_grant_tdr.check_proc_func = CheckProcFunctions.on_crit
templates.cryptic_crits_grant_tdr.proc_events = {
	[proc_events.on_hit] = 1,
}
templates.cryptic_crits_grant_tdr.proc_stat_buffs = {
	[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.cryptic_crits_grant_tdr.toughness_damage_taken_multiplier,
}
templates.cryptic_ammo_reserve = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = talent_settings.cryptic_ammo_reserve.ammo_reserve_capacity,
	},
}
templates.cryptic_ranged_kills_tdr = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("cryptic_ranged_kills_tdr_stack", t)
	end,
}
templates.cryptic_ranged_kills_tdr_stack = {
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_ranged_kills_tdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_ranged_kills_tdr.max_stacks,
	max_stacks_cap = talent_settings.cryptic_ranged_kills_tdr.max_stacks,
	duration = talent_settings.cryptic_ranged_kills_tdr.duration,
	hud_priority = HUD_PRIORITIES.talents,
	stepped_stat_buffs = {},
	min_max_step_func = function (template_data, template_context)
		local max_steps = talent_settings.cryptic_ranged_kills_tdr.max_stacks

		return 0, max_steps
	end,
	related_talents = {
		"cryptic_ranged_kills_tdr",
	},
}

for i = 1, talent_settings.cryptic_ranged_kills_tdr.max_stacks do
	table.insert(templates.cryptic_ranged_kills_tdr_stack.stepped_stat_buffs, {
		[stat_buffs.toughness_damage_taken_multiplier] = 1 - math.min(talent_settings.cryptic_ranged_kills_tdr.toughness_damage_taken_multiplier_step * i, 1),
	})
end

templates.cryptic_elite_kills_damage = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_ranged_kill, CheckProcFunctions.on_elite_kill),
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("cryptic_elite_kills_damage_stack", t)
	end,
}
templates.cryptic_elite_kills_damage_stack = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_elite_kills_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_elite_kills_damage.max_stacks,
	max_stacks_cap = talent_settings.cryptic_elite_kills_damage.max_stacks,
	duration = talent_settings.cryptic_elite_kills_damage.duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.cryptic_elite_kills_damage.damage,
	},
	related_talents = {
		"cryptic_elite_kills_damage",
	},
}
templates.cryptic_weakspot_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.weakspot_damage] = talent_settings.cryptic_weakspot_damage.weakspot_damage,
	},
}
templates.cryptic_elite_kills_toughness = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_elite_kills_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_elite_kills_toughness.toughness_regen_time,
	hud_priority = HUD_PRIORITIES.talents,
	toughness_regen_per_second = talent_settings.cryptic_elite_kills_toughness.toughness_regen / talent_settings.cryptic_elite_kills_toughness.toughness_regen_time,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_kill,
	proc_func = function (params, template_data, template_context, t)
		return
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_regen_active = template_context.buff:is_proc_active(t)

		if is_regen_active and template_context.is_server then
			local toughness_to_regen = template_context.template.toughness_regen_per_second * dt

			Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
		end
	end,
	related_talents = {
		"cryptic_elite_kills_toughness",
	},
}
templates.cryptic_electrocution_defense = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_electrocution_defense",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	cooldown_duration = talent_settings.cryptic_electrocution_defense.cooldown_duration,
	hud_priority = HUD_PRIORITIES.talents,
	electrocution_radius = talent_settings.cryptic_electrocution_defense.electrocution_radius,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local is_hurting_hit = AttackSettings.is_damaging_result[params.attack_result]

		if not is_hurting_hit then
			return false
		end

		return params.attack_type == attack_types.melee
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacking_unit
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local enemy_position = POSITION_LOOKUP[target_unit] or Unit.world_position(target_unit, 1)
		local broadphase_radius = template_context.template.electrocution_radius
		local num_hits = broadphase.query(broadphase, enemy_position, broadphase_radius, BROADPHASE_RESULTS, enemy_side_names)

		for i = 1, num_hits do
			local enemy_unit = BROADPHASE_RESULTS[i]

			if HEALTH_ALIVE[enemy_unit] then
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local t = FixedFrame.get_latest_fixed_time()

					buff_extension:add_internally_controlled_buff("cryptic_electrocution_default", t, "owner_unit", player_unit)
				end
			end
		end
	end,
	related_talents = {
		"cryptic_electrocution_defense",
	},
}
templates.cryptic_mobile_defense = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.movement_state_component = unit_data_extension:read_component("movement_state")
	end,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.cryptic_mobile_defense.damage_taken_multiplier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local current_stamina, _ = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local is_sprinting = Sprint.is_sprinting(template_data.sprint_character_state_component)
		local is_sliding = template_data.movement_state_component.method == "sliding"

		return is_sprinting and current_stamina > 0 or is_sliding
	end,
}
templates.cryptic_stun_suppression_immune = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_stun_suppression_immune",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	active_duration = talent_settings.cryptic_stun_suppression_immune.duration,
	hud_priority = HUD_PRIORITIES.keystones,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
	proc_keywords = {
		keywords.stun_immune,
		keywords.suppression_immune,
	},
	related_talents = {
		"cryptic_stun_suppression_immune",
	},
}
templates.cryptic_stacking_tdr = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.target_index and params.target_index == 1 or false
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("cryptic_stacking_tdr_buff", t)
	end,
}
templates.cryptic_stacking_tdr_buff = {
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_stacking_tdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_stacking_tdr.max_stacks,
	max_stacks_cap = talent_settings.cryptic_stacking_tdr.max_stacks,
	duration = talent_settings.cryptic_stacking_tdr.duration,
	hud_priority = HUD_PRIORITIES.talents,
	stepped_stat_buffs = {},
	min_max_step_func = function (template_data, template_context)
		local max_steps = talent_settings.cryptic_stacking_tdr.max_stacks

		return 0, max_steps
	end,
	related_talents = {
		"cryptic_stacking_tdr",
	},
}

for i = 1, talent_settings.cryptic_stacking_tdr.max_stacks do
	table.insert(templates.cryptic_stacking_tdr_buff.stepped_stat_buffs, {
		[stat_buffs.toughness_damage_taken_multiplier] = 1 - math.min(talent_settings.cryptic_stacking_tdr.toughness_damage_taken_multiplier * i, 1),
	})
end

templates.cryptic_successful_dodge_stamina = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		Stamina.add_stamina_percent(template_context.unit, talent_settings.cryptic_successful_dodge_stamina.stamina_replenished_percent)
	end,
}
templates.cryptic_pushing_grants_cleave = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_pushing_grants_cleave",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_pushing_grants_cleave.duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_push_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.max_melee_hit_mass_attack_modifier] = talent_settings.cryptic_pushing_grants_cleave.max_melee_hit_mass_attack_modifier,
	},
	related_talents = {
		"cryptic_pushing_grants_cleave",
	},
}
templates.cryptic_melee_crits_electrocute_first = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_crit_melee, CheckProcFunctions.on_first_target_melee_hit),
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("cryptic_electrocution_default", t, "owner_unit", player_unit)
		end
	end,
}
templates.cryptic_cleave_while_above_stamina_threshold = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template
		template_data.stamina_component = unit_data_extension:read_component("stamina")
	end,
	conditional_stat_buffs = {
		[stat_buffs.max_melee_hit_mass_attack_modifier] = talent_settings.cryptic_cleave_and_impact.max_hit_mass_attack_modifier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local current_toughness_percent = Toughness.current_toughness_percent(unit)

		return current_toughness_percent > talent_settings.cryptic_cleave_and_impact.stamina_threshold
	end,
}
templates.cryptic_impact_while_below_stamina_threshold = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template
		template_data.stamina_component = unit_data_extension:read_component("stamina")
	end,
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = talent_settings.cryptic_cleave_and_impact.impact_modifier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local current_toughness_percent = Toughness.current_toughness_percent(unit)

		return current_toughness_percent <= talent_settings.cryptic_cleave_and_impact.stamina_threshold
	end,
}
templates.cryptic_electrocution_applies_brittleness = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_buff_added] = 1,
		[proc_events.on_buff_stack_added] = 1,
		[proc_events.on_max_stack_refresh_buff] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local buff_template = params.template
		local buff_template_keywords = buff_template.keywords
		local has_keywords = buff_template_keywords and #buff_template_keywords > 0 or false

		if not has_keywords then
			return false
		end

		local electrocuted_group_keywords = group_to_keywords[group_keywords.electrocuted]

		for _, buff_keyword in ipairs(buff_template_keywords) do
			if electrocuted_group_keywords[buff_keyword] then
				return true
			end
		end

		return false
	end,
	proc_func = function (params, template_data, template_context)
		local target_unit = params.unit
		local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

		if HEALTH_ALIVE[target_unit] and target_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit
			local stacks = talent_settings.cryptic_electrocution_applies_brittleness.stacks

			target_buff_extension:add_internally_controlled_buff_with_stacks("rending_debuff", stacks, t, "owner_unit", player_unit)
		end
	end,
}
templates.cryptic_coherency_toughness_on_ability = {
	class_name = "server_only_proc_buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local toughness_to_regen = talent_settings.cryptic_coherency_toughness_on_ability.toughness_replenish_percent
		local units_in_coherency = template_data.coherency_extension:in_coherence_units()

		for coherency_unit in pairs(units_in_coherency) do
			Toughness.replenish_percentage(coherency_unit, toughness_to_regen, false, "cryptic_talent")
		end
	end,
}
templates.cryptic_hybrid_damage = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.any(CheckProcFunctions.on_ranged_kill, CheckProcFunctions.on_melee_kill),
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = template_context.buff_extension

		if CheckProcFunctions.on_ranged_kill(params, template_data, template_context, t) then
			buff_extension:add_internally_controlled_buff("cryptic_hybrid_melee_damage_buff", t)
		elseif CheckProcFunctions.on_melee_kill(params, template_data, template_context, t) then
			buff_extension:add_internally_controlled_buff("cryptic_hybrid_ranged_damage_buff", t)
		end
	end,
}
templates.cryptic_hybrid_melee_damage_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_crit_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_hybrid_damage.melee_max_stacks,
	max_stacks_cap = talent_settings.cryptic_hybrid_damage.melee_max_stacks,
	duration = talent_settings.cryptic_hybrid_damage.melee_duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.cryptic_hybrid_damage.melee_damage,
	},
	related_talents = {
		"cryptic_hybrid_damage",
	},
}
templates.cryptic_hybrid_ranged_damage_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_cleave_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_hybrid_damage.ranged_max_stacks,
	max_stacks_cap = talent_settings.cryptic_hybrid_damage.ranged_max_stacks,
	duration = talent_settings.cryptic_hybrid_damage.ranged_duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.cryptic_hybrid_damage.ranged_damage,
	},
	related_talents = {
		"cryptic_hybrid_damage",
	},
}
templates.cryptic_electrocution_toughness = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_electrocution_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_electrocution_toughness.toughness_regen_time,
	hud_priority = HUD_PRIORITIES.talents,
	toughness_regen_per_second = talent_settings.cryptic_electrocution_toughness.toughness_regen / talent_settings.cryptic_electrocution_toughness.toughness_regen_time,
	proc_events = {
		[proc_events.on_buff_added] = 1,
		[proc_events.on_buff_stack_added] = 1,
		[proc_events.on_max_stack_refresh_buff] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local buff_template = params.template
		local buff_template_keywords = buff_template.keywords
		local has_keywords = buff_template_keywords and #buff_template_keywords > 0 or false

		if not has_keywords then
			return false
		end

		local electrocuted_group_keywords = group_to_keywords[group_keywords.electrocuted]

		for _, buff_keyword in ipairs(buff_template_keywords) do
			if electrocuted_group_keywords[buff_keyword] then
				return true
			end
		end

		return false
	end,
	proc_func = function (params, template_data, template_context)
		return
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_regen_active = template_context.buff:is_proc_active(t)

		if is_regen_active and template_context.is_server then
			local toughness_to_regen = template_context.template.toughness_regen_per_second * dt

			Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
		end
	end,
	related_talents = {
		"cryptic_electrocution_toughness",
	},
}

local AFFLICTED_KEYWORDS = {
	keywords.bleeding,
	keywords.burning,
	keywords.toxin,
	keywords.warpfire_burning,
}

templates.cryptic_afflicted_increased_damage = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_afflicted_increased_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_afflicted_increased_damage.duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local is_melee_or_ranged_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context, t) or CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t)

		if not is_melee_or_ranged_hit then
			return false
		end

		local attacked_unit = params.attacked_unit
		local attacked_unit_buff_extension = attacked_unit and ScriptUnit.has_extension(attacked_unit, "buff_system") or nil

		if attacked_unit_buff_extension then
			if MinionState.is_electrocuted(attacked_unit_buff_extension, group_keywords.electrocuted) then
				return true
			end

			for _, target_keyword in ipairs(AFFLICTED_KEYWORDS) do
				if attacked_unit_buff_extension:has_keyword(target_keyword) then
					return true
				end
			end
		end

		return false
	end,
	proc_stat_buffs = {
		[stat_buffs.damage] = talent_settings.cryptic_afflicted_increased_damage.damage,
	},
	related_talents = {
		"cryptic_afflicted_increased_damage",
	},
}
templates.cryptic_stacking_melee_damage = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local num_hits = params.num_hit_units

		return num_hits > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("cryptic_stacking_melee_damage_buff", t)
	end,
}
templates.cryptic_stacking_melee_damage_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_stacking_melee_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_stacking_melee_damage.max_stacks,
	max_stacks_cap = talent_settings.cryptic_stacking_melee_damage.max_stacks,
	duration = talent_settings.cryptic_stacking_melee_damage.duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.cryptic_stacking_melee_damage.damage,
	},
	related_talents = {
		"cryptic_stacking_melee_damage",
	},
}
templates.cryptic_shared_toughness = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_toughness_replenished] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local wanted_amount = params.amount
		local reason = params.reason
		local actual_recovered_amount = params.recovered_amount
		local player_toughness_percent = Toughness.current_toughness_percent(player_unit)

		return reason ~= "shared" and wanted_amount > 0 and actual_recovered_amount == 0 and player_toughness_percent >= 1
	end,
	proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local wanted_amount = params.amount
		local toughness_to_regen = talent_settings.cryptic_shared_toughness.toughness_replenish_percent * wanted_amount
		local units_in_coherency = template_data.coherency_extension:in_coherence_units()

		for coherency_unit in pairs(units_in_coherency) do
			if coherency_unit ~= player_unit then
				Toughness.replenish_flat(coherency_unit, toughness_to_regen, false, "shared")
			end
		end
	end,
}
templates.cryptic_stamina_increases_damage = {
	class_name = "buff",
	predicted = false,
	stamina_consumed_to_proc = talent_settings.cryptic_stamina_increases_damage.stamina_consumed_to_proc,
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
		local stamina_consumed_to_proc = template_context.template.stamina_consumed_to_proc
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

		if stamina_consumed_to_proc <= template_data.spent_stamina then
			template_data.spent_stamina = template_data.spent_stamina - stamina_consumed_to_proc

			template_context.buff_extension:add_internally_controlled_buff("cryptic_stamina_increases_damage_effect", t)
		end

		template_data.last_stamina = current_stamina
	end,
}
templates.cryptic_stamina_increases_damage_effect = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_stamina_increases_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.cryptic_stamina_increases_damage.duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.cryptic_stamina_increases_damage.damage,
	},
	related_talents = {
		"cryptic_stamina_increases_damage",
	},
}
templates.cryptic_stacking_ranged_damage = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_stacking_ranged_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	num_steps_for_max_stat = talent_settings.cryptic_stacking_ranged_damage.max_stacks,
	time_since_last_shot_before_stacking = talent_settings.cryptic_stacking_ranged_damage.time_since_last_shot_before_stacking,
	time_between_stacks = talent_settings.cryptic_stacking_ranged_damage.time_between_stacks,
	hud_priority = HUD_PRIORITIES.talents,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.action_shoot_component = unit_data_extension and unit_data_extension:read_component("action_shoot")
		template_data.shooting_status_component = unit_data_extension and unit_data_extension:read_component("shooting_status")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
		template_data.lerp_t_value = 0
		template_data.steps = 0
		template_data.is_shooting = false
		template_data.consume_charges = false
	end,
	lerped_stat_buffs = {
		[stat_buffs.ranged_damage] = {
			min = 0,
			max = talent_settings.cryptic_stacking_ranged_damage.ranged_damage_per_stack * talent_settings.cryptic_stacking_ranged_damage.max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.lerp_t_value
	end,
	check_active_func = function (template_data, template_context)
		return template_data.steps > 0
	end,
	visual_stack_count = function (template_data, template_context)
		return template_data.steps
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local shooting_status_component = template_data.shooting_status_component
		local weapon_action_component = template_data.weapon_action_component
		local action_shoot_component = template_data.action_shoot_component
		local is_shooting = shooting_status_component.shooting
		local is_full_auto_shooting = is_shooting and weapon_action_component.is_infinite_duration
		local was_shooting = template_data.is_shooting

		template_data.is_shooting = is_shooting

		local last_shoot_time = action_shoot_component.fire_last_t
		local fixed_t = FixedFrame.get_latest_fixed_time()
		local time_lapsed = fixed_t - last_shoot_time - (template.time_since_last_shot_before_stacking - template.time_between_stacks)

		if time_lapsed <= 0.1 then
			template_data.lerp_t_value = 0
			template_data.steps = 0

			return
		end

		local time_between_stacks = template.time_between_stacks
		local num_steps_for_max_stat = template.num_steps_for_max_stat
		local steps = math.min(math.floor(time_lapsed / time_between_stacks), num_steps_for_max_stat)

		template_data.lerp_t_value = 1 / num_steps_for_max_stat * steps
		template_data.steps = steps
	end,
}
templates.cryptic_passive_ammo_replenishment = {
	class_name = "interval_buff",
	predicted = false,
	interval = talent_settings.cryptic_passive_ammo_replenishment.interval,
	percent_ammo_replenish_per_tick = talent_settings.cryptic_passive_ammo_replenishment.percent_ammo_replenish_per_tick,
	interval_func = function (template_data, template_context, template, time_since_start, t, dt)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		Ammo.add_to_all_slots(unit, template.percent_ammo_replenish_per_tick)
	end,
}
templates.cryptic_better_heavies = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.uninterruptible,
	},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings.cryptic_better_heavies.melee_heavy_damage,
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
templates.cryptic_stun_dr_power = {
	class_name = "server_only_proc_buff",
	predicted = false,
	percent_cooldown_spent_per_melee_hit_taken = talent_settings.cryptic_stun_dr_power.percent_cooldown_spent_per_melee_hit_taken,
	keywords = {
		keywords.stun_immune,
	},
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.cryptic_stun_dr_power.damage_taken_multiplier,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.character_state_component = unit_data_extension:read_component("character_state")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local character_state_component = template_data.character_state_component
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

		if is_disabled then
			return false
		end

		return params.attacked_unit == template_context.unit and CheckProcFunctions.on_melee_hit(params, template_data, template_context, t)
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.ability_extension:increase_ability_cooldown_percentage(COMBAT_ABILITY_TYPE, template_context.template.percent_cooldown_spent_per_melee_hit_taken)
	end,
}

local valid_help_interactions = {
	pull_up = true,
	remove_net = true,
	rescue = true,
	revive = true,
}

local function _passive_revive_conditional(template_data, template_context)
	local is_interacting = template_data.interactor_extension:is_interacting()

	if is_interacting then
		local interaction = template_data.interactor_extension:interaction()
		local interaction_type = interaction:type()
		local is_helping = valid_help_interactions[interaction_type]

		return is_helping
	end
end

templates.cryptic_revive_speed_and_dr = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.cryptic_revive_speed_and_dr.damage_taken_multiplier,
	},
	stat_buffs = {
		[stat_buffs.revive_speed_modifier] = talent_settings.cryptic_revive_speed_and_dr.revive_speed_modifier,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")

		template_data.interactor_extension = interactor_extension
	end,
	conditional_stat_buffs_func = _passive_revive_conditional,
}
templates.cryptic_corruption_resistance_doom = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	interval = talent_settings.cryptic_corruption_resistance_doom.interval,
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = talent_settings.cryptic_corruption_resistance_doom.corruption_taken_multiplier,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local health_extension = ScriptUnit.extension(player_unit, "health_system")

		template_data.health_extension = health_extension

		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.character_state_component = character_state_component
		template_data.corruption_damage_profile = DamageProfileTemplates.cryptic_corruption_resistance_doom_tick

		local corruption_taken_multiplier_correction = 1 / talent_settings.cryptic_corruption_resistance_doom.corruption_taken_multiplier

		template_data.corruption_damage_power_level = 50 * talent_settings.cryptic_corruption_resistance_doom.corruption_damage_taken * corruption_taken_multiplier_correction
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local character_state_component = template_data.character_state_component
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not HEALTH_ALIVE[player_unit] or requires_help then
			return
		end

		local health_extension = template_data.health_extension

		if health_extension then
			Attack.execute(player_unit, template_data.corruption_damage_profile, "power_level", template_data.corruption_damage_power_level, "is_critical_strike", false, "attack_type", attack_types.buff, "damage_type", DamageSettings.damage_types.grimoire)
		end
	end,
}
templates.cryptic_ranged_stacking_toughness = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("cryptic_ranged_stacking_toughness_stack", t)
	end,
	related_talents = {
		"cryptic_ranged_stacking_toughness",
	},
}
templates.cryptic_ranged_stacking_toughness_stack = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_ranged_stacking_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_ranged_stacking_toughness.max_stacks,
	max_stacks_cap = talent_settings.cryptic_ranged_stacking_toughness.max_stacks,
	duration = talent_settings.cryptic_ranged_stacking_toughness.duration,
	hud_priority = HUD_PRIORITIES.talents,
	toughness_regen_per_second_per_stack = talent_settings.cryptic_ranged_stacking_toughness.toughness_regen_per_second_per_stack,
	update_func = function (template_data, template_context, dt, t)
		if template_context.is_server then
			local num_stacks = template_context.stack_count
			local toughness_to_regen = template_context.template.toughness_regen_per_second_per_stack * num_stacks * dt

			Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
		end
	end,
	related_talents = {
		"cryptic_ranged_stacking_toughness",
	},
}
templates.cryptic_toughness_on_damage_taken = _toughness_regen_over_time_on_proc_generator()
templates.cryptic_toughness_on_damage_taken.active_duration = talent_settings.cryptic_toughness_on_damage_taken.toughness_regen_time
templates.cryptic_toughness_on_damage_taken.cooldown = talent_settings.cryptic_toughness_on_damage_taken.cooldown
templates.cryptic_toughness_on_damage_taken.hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_toughness_on_damage_taken"
templates.cryptic_toughness_on_damage_taken.toughness_regen_on_proc = talent_settings.cryptic_toughness_on_damage_taken.toughness_regen
templates.cryptic_toughness_on_damage_taken.toughness_regen_per_second = talent_settings.cryptic_toughness_on_damage_taken.toughness_regen / talent_settings.cryptic_toughness_on_damage_taken.toughness_regen_time
templates.cryptic_toughness_on_damage_taken.proc_events = {
	[proc_events.on_damage_taken] = 1,
}

templates.cryptic_toughness_on_damage_taken.check_proc_func = function (params, template_data, template_context, t)
	return params.attacked_unit == template_context.unit and params.damage_amount > 0
end

templates.cryptic_toughness_on_damage_taken.related_talents = {
	"cryptic_electrocution_toughness",
}
templates.cryptic_ranged_vs_bfg = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ranged_damage_vs_captains] = talent_settings.cryptic_ranged_vs_bfg.ranged_damage_vs_captains,
		[stat_buffs.ranged_damage_vs_monsters] = talent_settings.cryptic_ranged_vs_bfg.ranged_damage_vs_monsters,
		[stat_buffs.ranged_damage_vs_ogryn] = talent_settings.cryptic_ranged_vs_bfg.ranged_damage_vs_ogryn,
	},
}
templates.cryptic_crit_chance_based_on_charge = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.cryptic_crit_chance_based_on_charge.critical_strike_chance,
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.cryptic_crit_chance_based_on_charge.extra_critical_strike_chance,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local num_combat_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		return num_combat_ability_charges <= talent_settings.cryptic_crit_chance_based_on_charge.low_charges
	end,
	start_func = function (template_data, template_context)
		local ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
}
templates.cryptic_melee_attacks_give_melee_attack_speed = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.num_hit_units > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("cryptic_melee_attacks_give_melee_attack_speed_stack", t)
	end,
}
templates.cryptic_melee_attacks_give_melee_attack_speed_stack = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_melee_attacks_give_melee_attack_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.max_stacks,
	max_stacks_cap = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.max_stacks,
	duration = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.melee_attack_speed,
	},
	related_talents = {
		"cryptic_melee_attacks_give_melee_attack_speed",
	},
}
templates.cryptic_tdr_based_on_charge = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 1,
	},
	stat_buff_multipliers = {
		[stat_buffs.toughness_damage_taken_multiplier] = function (template_data, template_context)
			local base = talent_settings.cryptic_tdr_based_on_charge.toughness_damage_taken_multiplier_base
			local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE) or 0
			local toughness_damage_taken_per_charge_multiplier = 1 - base - current_ability_charges * talent_settings.cryptic_tdr_based_on_charge.toughness_damage_taken_multiplier_per_charge

			return toughness_damage_taken_per_charge_multiplier
		end,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
}
templates.cryptic_toughness_per_charge = {
	class_name = "buff",
	predicted = false,
	toughness_regen_per_second = talent_settings.cryptic_toughness_per_charge.toughness_regen_per_second,
	increased_toughness_regen_per_charge = talent_settings.cryptic_toughness_per_charge.increased_toughness_regen_per_charge,
	start_func = function (template_data, template_context)
		local ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_context.is_server then
			local num_combat_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE) or 0
			local toughness_to_regen = (template_context.template.toughness_regen_per_second + template_context.template.increased_toughness_regen_per_charge * num_combat_ability_charges) * dt

			Toughness.replenish_percentage(template_context.unit, toughness_to_regen, false, "cryptic_talent")
		end
	end,
	related_talents = {
		"cryptic_toughness_per_charge",
	},
}
templates.cryptic_no_braced_movement_penalty = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = talent_settings.cryptic_no_braced_movement_penalty.alternate_fire_movement_speed_reduction_modifier,
		[stat_buffs.spread_modifier] = talent_settings.cryptic_no_braced_movement_penalty.spread_modifier,
	},
}
templates.cryptic_damage_on_ability = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_damage_on_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_damage_on_ability.duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage] = talent_settings.cryptic_damage_on_ability.damage,
	},
}
templates.cryptic_dr_on_toughness_break = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_dr_on_toughness_break",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_dr_on_toughness_break.active_duration,
	cooldown_duration = talent_settings.cryptic_dr_on_toughness_break.cooldown_duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return template_context.unit == params.unit
	end,
	proc_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.cryptic_dr_on_toughness_break.damage_taken_multiplier,
	},
	related_talents = {
		"cryptic_dr_on_toughness_break",
	},
}
templates.cryptic_push_stagger_stamina = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.movement_state_component = unit_data_extension:read_component("movement_state")
	end,
	conditional_stat_buffs = {
		[stat_buffs.push_impact_modifier] = talent_settings.cryptic_push_stagger_stamina.push_impact_modifier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local current_stamina, max_stamina = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local current_percent = current_stamina / max_stamina

		return current_percent >= talent_settings.cryptic_push_stagger_stamina.target_stamina_percent
	end,
}

local function _init_outline_tracking(outline_name, range, should_outline_enemy_func, template_data, template_context)
	template_data.outline_name = outline_name
	template_data.range = range
	template_data.should_outline_enemy_func = should_outline_enemy_func
	template_data.outlined_enemies = Script.new_map(32)
	template_data.enemies_to_outline = Script.new_map(32)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[template_context.unit]
	local enemy_side_names = side:relation_side_names("enemy")

	template_data.broadphase = broadphase
	template_data.enemy_side_names = enemy_side_names
end

local function _stop_outlines(template_data, template_context)
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if not has_outline_system then
		return
	end

	local outline_name = template_data.outline_name
	local outlined_enemies = template_data.outlined_enemies
	local outline_system = Managers.state.extension:system("outline_system")

	for outlined_enemy_unit, _ in pairs(outlined_enemies) do
		outlined_enemies[outlined_enemy_unit] = nil

		outline_system:remove_outline(outlined_enemy_unit, outline_name)
	end
end

local function _find_enemies_in_outline_range(template_data, template_context)
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if not has_outline_system then
		return
	end

	local broadphase = template_data.broadphase
	local enemy_side_names = template_data.enemy_side_names
	local enemies_to_outline = template_data.enemies_to_outline
	local player_position = Unit.world_position(template_context.unit, 1)
	local num_hits = broadphase.query(broadphase, player_position, template_data.range, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local should_get_outlined = template_data.should_outline_enemy_func(enemy_unit, template_data, template_context)

		if should_get_outlined then
			enemies_to_outline[enemy_unit] = true
		end
	end
end

local function _update_outlines(template_data, template_context)
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if not has_outline_system then
		return
	end

	local outline_name = template_data.outline_name
	local outlined_enemies = template_data.outlined_enemies
	local enemies_to_outline = template_data.enemies_to_outline
	local outline_system = Managers.state.extension:system("outline_system")

	for outlined_enemy_unit, _ in pairs(outlined_enemies) do
		if not enemies_to_outline[outlined_enemy_unit] then
			outlined_enemies[outlined_enemy_unit] = nil

			outline_system:remove_outline(outlined_enemy_unit, outline_name)
		end
	end

	for enemy_unit, _ in pairs(enemies_to_outline) do
		if not outlined_enemies[enemy_unit] then
			outlined_enemies[enemy_unit] = true

			outline_system:add_outline(enemy_unit, outline_name)
		end
	end

	table.clear(enemies_to_outline)
end

local function _is_alive_special_minion(enemy_unit, template_data)
	if not HEALTH_ALIVE[enemy_unit] then
		return false
	end

	local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
	local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
	local breed_tags = breed and breed.tags

	return breed_tags and breed_tags.special
end

templates.cryptic_specials_marking = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		_init_outline_tracking("broker_proximity_target", talent_settings.cryptic_specials_marking.outline_range, _is_alive_special_minion, template_data, template_context)

		template_data.next_outline_update_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER then
			return
		end

		if t >= template_data.next_outline_update_t then
			_find_enemies_in_outline_range(template_data, template_context)
			_update_outlines(template_data, template_context)

			template_data.next_outline_update_t = t + 0.25
		end
	end,
	stop_func = function (template_data, template_context)
		_stop_outlines(template_data, template_context)
	end,
}
templates.cryptic_electrocution_push = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_electrocution_push",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	cooldown_duration = talent_settings.cryptic_electrocution_push.cooldown_duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_push_hit] = 1,
		[proc_events.on_push_finish] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.should_go_on_cooldown = false
	end,
	specific_check_proc_funcs = {
		[proc_events.on_push_hit] = function (params, template_data, template_context, t)
			local pushed_unit = params.pushed_unit
			local pushed_unit_buff_extension = ScriptUnit.has_extension(pushed_unit, "buff_system")
			local is_staggering_hit = CheckProcFunctions.on_staggering_hit(params, template_data, template_context, t)
			local should_apply_electrocution = pushed_unit and HEALTH_ALIVE[pushed_unit] and pushed_unit_buff_extension and is_staggering_hit

			if should_apply_electrocution then
				local player_unit = template_context.unit

				pushed_unit_buff_extension:add_internally_controlled_buff("cryptic_electrocution_default", t, "owner_unit", player_unit)

				template_data.should_go_on_cooldown = true
			end

			return false
		end,
		[proc_events.on_push_finish] = function (params, template_data, template_context, t)
			return template_data.should_go_on_cooldown
		end,
	},
	specific_proc_func = {
		[proc_events.on_push_finish] = function (params, template_data, template_context, t)
			template_data.should_go_on_cooldown = false
		end,
	},
	related_talents = {
		"cryptic_electrocution_push",
	},
}

local toughness_replenishment_on_kill_bonus_extra_toughness_melee_replenish = talent_settings.cryptic_toughness_replenishment_on_kill_bonus.improved_toughness_melee_replenish - talent_settings.cryptic_toughness_replenishment_on_kill_bonus.toughness_melee_replenish

templates.cryptic_toughness_replenishment_on_kill_bonus = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = talent_settings.cryptic_toughness_replenishment_on_kill_bonus.toughness_melee_replenish,
	},
	conditional_stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = toughness_replenishment_on_kill_bonus_extra_toughness_melee_replenish,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local num_combat_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE)

		return num_combat_ability_charges <= talent_settings.cryptic_toughness_replenishment_on_kill_bonus.improved_min_charges
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
}
templates.cryptic_strength_on_charge_gain = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_strength_on_charge_gain",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	active_duration = talent_settings.cryptic_strength_on_charge_gain.active_duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_combat_ability_charge_replenished] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.power_level_modifier] = talent_settings.cryptic_strength_on_charge_gain.power_level_modifier,
	},
}
templates.cryptic_assisted_allies_defense = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_assist_done] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local assisted_unit = params.assisted_unit
		local interactor_unit = params.interactor_unit

		return assisted_unit and HEALTH_ALIVE[assisted_unit] and interactor_unit == template_context.unit
	end,
	proc_func = function (params, template_data, template_context, t)
		local assisted_unit = params.assisted_unit
		local assisted_unit_buff_extension = ScriptUnit.has_extension(assisted_unit, "buff_system")

		if assisted_unit_buff_extension then
			assisted_unit_buff_extension:add_internally_controlled_buff("cryptic_assisted_allies_defense_buff", t)
		end
	end,
}
templates.cryptic_assisted_allies_defense_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_default_defensive_talent",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings.cryptic_disabled_allies_defense.duration,
	hud_priority = HUD_PRIORITIES.talents,
	keywords = {
		keywords.stun_immune,
	},
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.cryptic_disabled_allies_defense.damage_taken_multiplier,
	},
	related_talents = {
		"cryptic_disabled_allies_defense",
	},
}
templates.cryptic_disabled_allies_defense = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_disabled_allies_defense",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 4,
	max_stacks_cap = 4,
	predicted = false,
	buff_category = buff_categories.aura,
	hud_priority = HUD_PRIORITIES.talents,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.cryptic_disabled_allies_defense.damage_taken_multiplier,
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.character_state_component = character_state_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local character_state_component = template_data.character_state_component
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		return requires_help
	end,
	related_talents = {
		"cryptic_disabled_allies_defense",
	},
}
templates.cryptic_auto_reload = {
	allow_proc_while_cooling_down = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_auto_reload",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = true,
	cooldown_duration = talent_settings.cryptic_auto_reload.cooldown_duration,
	hud_priority = HUD_PRIORITIES.talents,
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.cryptic_auto_reload.reload_speed,
	},
	proc_events = {
		[proc_events.on_shoot] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.reload_interval_start_t = 0
		template_data.next_reload_t = 0

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	end,
	proc_func = function (template_data, template_context, dt, t)
		return
	end,
	update_func = function (template_data, template_context, dt, t)
		local buff = template_context.buff

		if not buff:is_cooling_down(t) then
			local active_start_time = buff:active_start_time()
			local cooldown_ended_t = active_start_time + 5

			if cooldown_ended_t > template_data.reload_interval_start_t then
				template_data.next_reload_t = cooldown_ended_t + 1
				template_data.reload_interval_start_t = cooldown_ended_t
			end

			if template_data.next_reload_t and t >= template_data.next_reload_t then
				template_data.next_reload_t = template_data.next_reload_t + 1

				local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
				local missing_ammo_in_clip = Ammo.missing_ammo_in_clips(inventory_slot_secondary_component)
				local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)

				if not is_reloading and missing_ammo_in_clip > 0 and inventory_slot_secondary_component.current_ammunition_reserve > 0 then
					local max_ammo_in_clip = Ammo.max_ammo_in_clips(inventory_slot_secondary_component)
					local amount = math.clamp(math.ceil(max_ammo_in_clip * talent_settings.cryptic_auto_reload.ammo_replenish_percent), 0, missing_ammo_in_clip)

					Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, amount)

					local weapon_template = template_data.visual_loadout_extension:weapon_template_from_slot("slot_secondary")
					local reload_template = weapon_template.reload_template

					if reload_template then
						ReloadStates.reset(reload_template, inventory_slot_secondary_component)
					end
				end
			end
		elseif template_data.next_reload_t then
			template_data.next_reload_t = nil
		end
	end,
}
templates.cryptic_damage_vs_electrocuted_scaling_on_charge = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_electrocuted] = 1,
	},
	stat_buff_multipliers = {
		[stat_buffs.damage_vs_electrocuted] = function (template_data, template_context)
			local current_ability_charges = template_data.ability_extension:remaining_ability_charges(COMBAT_ABILITY_TYPE) or 0
			local damage_vs_electrocuted_per_charge_multiplier = talent_settings.cryptic_damage_vs_electrocuted_scaling_on_charge.base_damage_vs_electrocuted + current_ability_charges * talent_settings.cryptic_damage_vs_electrocuted_scaling_on_charge.damage_per_charge

			return damage_vs_electrocuted_per_charge_multiplier
		end,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
}
templates.cryptic_ally_coherency_defenses_stamina = {
	class_name = "proc_buff",
	predicted = false,
	skip_tactical_overlay = true,
	cooldown_duration = talent_settings.cryptic_ally_coherency_defenses.stamina_cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit

		if not attacked_unit then
			return false
		end

		local will_die = params.will_die
		local toughness_damage_amount = params.toughness_damage_amount
		local is_attacked_unit_in_coherency = HEALTH_ALIVE[attacked_unit] and template_data.coherency_extension:is_unit_in_coherency(attacked_unit)

		return is_attacked_unit_in_coherency and not will_die and toughness_damage_amount > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit

		Stamina.add_stamina_percent(attacked_unit, talent_settings.cryptic_ally_coherency_defenses.stamina_percent_restored)
	end,
}
templates.cryptic_ally_coherency_defenses_toughness = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_ally_coherency_defenses",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	cooldown_duration = talent_settings.cryptic_ally_coherency_defenses.toughness_cooldown_duration,
	hud_priority = HUD_PRIORITIES.talents,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit

		if not attacked_unit then
			return false
		end

		local will_die = params.will_die
		local damage_amount = params.damage_amount
		local is_attacked_unit_in_coherency = HEALTH_ALIVE[attacked_unit] and template_data.coherency_extension:is_unit_in_coherency(attacked_unit)

		return is_attacked_unit_in_coherency and not will_die and damage_amount > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit

		Toughness.replenish_percentage(attacked_unit, talent_settings.cryptic_ally_coherency_defenses.toughness_percent_to_regen, false, "cryptic_talent")
	end,
	related_talents = {
		"cryptic_ally_coherency_defenses",
	},
}
templates.cryptic_next_hit_all_damage_on_dodge = {
	class_name = "server_only_proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("cryptic_next_hit_all_damage_on_dodge_effect", t)
	end,
}
templates.cryptic_next_hit_all_damage_on_dodge_effect = {
	always_show_in_hud = true,
	class_name = "server_only_proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/cryptic/cryptic_next_hit_all_damage_on_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	hud_priority = HUD_PRIORITIES.talents,
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.cryptic_next_hit_all_damage_on_dodge.damage,
		[stat_buffs.ranged_damage] = talent_settings.cryptic_next_hit_all_damage_on_dodge.damage,
	},
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.attack_boost_active = true
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.attack_boost_active
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.attack_boost_active = false
	end,
	conditional_exit_func = function (template_data, template_context)
		return not template_data.attack_boost_active
	end,
	related_talents = {
		"cryptic_next_hit_all_damage_on_dodge",
	},
}

return templates
