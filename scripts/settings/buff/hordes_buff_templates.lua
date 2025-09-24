-- chunkname: @scripts/settings/buff/hordes_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PI = math.pi
local PI_2 = PI * 2
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local grenade_replenishment_external_properties = {
	indicator_type = "human_grenade",
}
local GRENADE_IMPACT_DAMAGE_TEMPLATES = {
	fire_grenade_impact = true,
	frag_grenade_impact = true,
	krak_grenade_impact = true,
	ogryn_grenade_box_cluster_impact = true,
	ogryn_grenade_box_impact = true,
	ogryn_grenade_impact = true,
}
local GRENADE_EXPLOSION_DAMAGE_TYPES = {
	[damage_types.grenade_frag] = true,
	[damage_types.electrocution] = true,
	[damage_types.plasma] = true,
	[damage_types.physical] = true,
	[damage_types.laser] = true,
}
local VFX_NAMES = {
	big_shock = "content/fx/particles/player_buffs/buff_electricity_grenade_01",
	fire_pulse = "content/fx/particles/player_buffs/buff_fire_360angle_01",
	healing_explosion = "content/fx/particles/player_buffs/buff_healing_area",
	single_target_shock = "content/fx/particles/player_buffs/buff_electricity_one_target_01",
	stagger_pulse = "content/fx/particles/player_buffs/buff_staggering_pulse",
	veteran_shout = "content/fx/particles/abilities/squad_leader_ability_shout_activate",
}
local SFX_NAMES = {
	ammo_refil = "wwise/events/player/play_horde_mode_buff_ammo_refill",
	burning_proc = "wwise/events/player/play_horde_mode_buff_fire_ignite",
	duplication = "wwise/events/player/play_horde_mode_buff_dublicate",
	electric_pulse = "wwise/events/player/play_horde_mode_buff_electric_pulse",
	fire_burst = "wwise/events/player/play_horde_mode_buff_fire_burst",
	fire_pulse = "wwise/events/player/play_horde_mode_buff_fire_pulse",
	friendly_rock_charge_finish = "wwise/events/player/play_horde_mode_buff_rock_charge_finish",
	friendly_rock_charge_start = "wwise/events/player/play_horde_mode_buff_rock_charge_loop",
	friendly_rock_charge_stop = "wwise/events/player/stop_horde_mode_buff_rock_charge_loop",
	gravity_pull = "wwise/events/player/play_horde_mode_buff_gravitation",
	grenade_refil = "wwise/events/player/play_horde_mode_buff_grenade_refill",
	healing = "wwise/events/weapon/play_horde_mode_heal_self_confirmation",
	inferno = "wwise/events/player/play_horde_mode_buff_fire_inferno",
	reduced_damage_hit = "wwise/events/player/play_horde_mode_buff_shield_hit",
	shield = "wwise/events/weapon/play_horde_mode_buff_shield",
	shock_aoe_big = "wwise/events/player/play_horde_mode_buff_electric_shock",
	shock_crit = "wwise/events/player/play_horde_mode_buff_electric_crit",
	shock_proc = "wwise/events/player/play_horde_mode_buff_electric_damage",
	stagger_hit = "wwise/events/player/play_horde_mode_buff_stagger_hit",
	stagger_pulse = "wwise/events/player/play_horde_mode_buff_stagger_pulse",
	super_crit = "wwise/events/player/play_horde_mode_buff_super_crit",
}
local templates = {}

table.make_unique(templates)

local _compute_fire_pulse, _give_passive_grenade_replenishment_buff, _pull_enemies_towards_position

templates.hordes_buff_damage_immunity_after_game_end = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.invulnerable,
	},
}
templates.hordes_buff_max_grenades_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = 1,
	},
}
templates.hordes_buff_attack_speed_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.attack_speed] = 0.15,
	},
}
templates.hordes_buff_rending_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.15,
	},
}
templates.hordes_buff_damage_vs_bleeding = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_bleeding] = 0.1,
	},
}
templates.hordes_buff_burning_duration_increase = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.burning_duration] = 0.5,
	},
}
templates.hordes_buff_heavy_attacks_gain_damage_and_stagger = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = 0.15,
		[stat_buffs.melee_impact_modifier] = 0.3,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_heavy
	end,
	check_active_func = function (template_data, template_context)
		return template_data.is_heavy
	end,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			template_data.is_heavy = params.is_heavy
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.is_heavy = false
		end,
	},
}
templates.hordes_buff_damage_vs_ogryn_and_monsters_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn_and_monsters] = 0.35,
	},
}
templates.hordes_buff_damage_vs_super_armor_and_armored_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.super_armor_damage] = 0.15,
		[stat_buffs.armored_damage] = 0.15,
	},
}
templates.hordes_buff_ammo_reserve_capacity_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = 0.15,
	},
}
templates.hordes_buff_melee_damage_on_missing_wounds = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			max = 0.35000000000000003,
			min = 0,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.max_wounds = 7
	end,
	update_func = function (template_data, template_context, dt, t)
		local health_extension = template_data.health_extension

		if health_extension then
			local max_wounds = health_extension:max_wounds()
			local max_health = health_extension:max_health()
			local damage_taken = health_extension:damage_taken()
			local permanent_damage_taken = health_extension:permanent_damage_taken()
			local current_wounds = Health.calculate_num_segments(math.max(damage_taken, permanent_damage_taken), max_health, max_wounds)
			local missing_wounds = (max_wounds or 0) - (current_wounds or 0)

			template_data.missing_wounds = math.min(missing_wounds, max_wounds)
		end
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local max_wounds = template_data.max_wounds
		local missing_wounds = template_data.missing_wounds or 0

		return math.clamp01(missing_wounds / max_wounds)
	end,
}
templates.hordes_buff_improved_weapon_reload_on_non_empty_clip = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = 0.25,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
	end,
	update_func = function (template_data, template_context)
		local unit = template_context.unit
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo_percentage = Ammo.current_slot_clip_percentage(unit, wielded_slot)
		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)
		local active = ammo_percentage > 0

		if not is_reloading then
			template_data.is_active = active
		end
	end,
	check_active_func = ConditionalFunctions.is_reloading,
}
templates.hordes_buff_improved_weapon_reload_on_elite_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("hordes_buff_improved_weapon_reload_on_elite_kill_effect", t)
	end,
}
templates.hordes_buff_improved_weapon_reload_on_elite_kill_effect = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.3,
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
}
templates.hordes_buff_ranged_damage_on_enemy_on_melee_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit
			local num_stacks = 1

			for ii = 1, num_stacks do
				victim_buff_extension:add_internally_controlled_buff("hordes_buff_ranged_damage_on_enemy_on_melee_hit_minion_effect", t, "owner_unit", player_unit)
			end
		end
	end,
}
templates.hordes_buff_ranged_damage_on_enemy_on_melee_hit_minion_effect = {
	class_name = "proc_buff",
	duration = 3,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.is_active = true
	end,
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attacked_unit = template_context.unit
		local attacking_unit = params.attacking_unit
		local valid_attacker_unit = template_context.owner_unit

		if HEALTH_ALIVE[attacked_unit] and attacking_unit == valid_attacker_unit then
			local damage_template = DamageProfileTemplates.burning
			local power_level = 500
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(attacked_unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)

			template_data.is_active = false
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		if not template_context.is_server then
			return false
		end

		return not template_data.is_active
	end,
}
templates.hordes_buff_toughness_regen_out_of_melee_range = {
	always_show_in_hud = true,
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.ticks_per_second = 1
		template_data.toughness_percentage_per_tick = 0.05

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local next_regen_t = template_data.next_regen_t

		if not next_regen_t then
			template_data.next_regen_t = t + 1 / template_data.ticks_per_second

			return
		end

		if next_regen_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)

			if num_hits == 0 then
				if template_context.is_server then
					Toughness.replenish_percentage(template_context.unit, template_data.toughness_percentage_per_tick, false)
				end

				template_data.next_regen_t = t + 1 / template_data.ticks_per_second
				template_data.is_active = true
			else
				template_data.is_active = false
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}
templates.hordes_buff_grenade_replenishment_on_elite_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_minion_death] = 0.05,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attacking_unit = params.attacking_unit
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()
		local attacking_unit_is_in_coherency = false

		for coherency_unit, _ in pairs(units_in_coherence) do
			if coherency_unit == attacking_unit then
				attacking_unit_is_in_coherency = true

				break
			end
		end

		if not attacking_unit_is_in_coherency then
			return
		end

		local unit = template_context.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if fx_extension then
			local position = POSITION_LOOKUP[unit]

			fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)
		end

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension and ability_extension:has_ability_type("grenade_ability") then
			ability_extension:restore_ability_charge("grenade_ability", 1)

			local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
			end
		end
	end,
}
templates.hordes_buff_combat_ability_cooldown_reduction_on_elite_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		local cooldown_reduction = 10

		template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_reduction)
	end,
}
templates.hordes_ailment_minion_burning = {
	class_name = "interval_buff",
	duration = 4,
	interval = 0.5,
	interval_stack_removal = true,
	max_stacks = 31,
	max_stacks_cap = 31,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
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
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	minion_effects = minion_burning_buff_effects.chemfire,
}
templates.hordes_ailment_minion_bleed = {
	class_name = "interval_buff",
	duration = 1.5,
	interval = 0.5,
	interval_stack_removal = true,
	max_stacks = 16,
	max_stacks_cap = 16,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.bleeding,
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.bleeding
			local stack_multiplier = template_context.stack_count / template.max_stacks
			local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
			local power_level = smoothstep_multiplier * 1200
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
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_bleeding",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.hordes_ailment_infinite_minion_bleed = table.clone(templates.hordes_ailment_minion_bleed)
templates.hordes_ailment_infinite_minion_bleed.duration = nil
templates.hordes_ailment_infinite_minion_bleed.interval_stack_removal = false
templates.hordes_ailment_infinite_minion_bleed.max_stacks = 1
templates.hordes_ailment_infinite_minion_bleed.max_stacks_cap = 1
templates.hordes_ailment_infinite_minion_bleed.refresh_duration_on_stack = false
templates.hordes_ailment_shock = {
	class_name = "interval_buff",
	duration = 2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	buff_category = buff_categories.hordes_sub_buff,
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

		if HEALTH_ALIVE[unit] and not is_staggered_poxwalker_bomber then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction, "attack_type", attack_types.buff)
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

return templates
