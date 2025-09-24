-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_generic_buff_templates.lua

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
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushAttack = require("scripts/utilities/attack/push_attack")
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
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
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
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local templates = {}

table.make_unique(templates)

templates.hordes_buff_uninterruptible_more_damage_taken = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.uninterruptible,
	},
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = 0,
	},
}

local percent_ability_cooldown_recovered_per_kill = HordesBuffsData.hordes_buff_combat_ability_cooldown_on_kills.buff_stats.cooldown.value

templates.hordes_buff_combat_ability_cooldown_on_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
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
		local is_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context)

		if not is_melee_hit then
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

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", percent_ability_cooldown_recovered_per_kill)
	end,
}

local percent_ammo_refil_while_holding_melee = HordesBuffsData.hordes_buff_auto_clip_fill_while_melee.buff_stats.ammo.value

templates.hordes_buff_auto_clip_fill_while_melee = {
	class_name = "proc_buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1,
	},
	specific_proc_func = {
		[proc_events.on_wield_ranged] = function (params, template_data, template_context)
			template_data.is_wielding_melee = false
		end,
		[proc_events.on_wield_melee] = function (params, template_data, template_context)
			template_data.is_wielding_melee = true

			local t = FixedFrame.get_latest_fixed_time()

			template_data.next_check_time = t + 5
		end,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")

		local start_time = 0

		template_context.item_slot_name = "slot_primary"

		local is_wielding_melee = ConditionalFunctions.is_item_slot_wielded(template_data, template_context)

		if is_wielding_melee then
			local t = FixedFrame.get_latest_fixed_time()

			start_time = t + 5
		end

		template_data.next_check_time = start_time
		template_data.is_wielding_melee = is_wielding_melee
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server or not template_data.is_wielding_melee then
			return
		end

		local next_check_time = template_data.next_check_time

		if next_check_time < t then
			template_data.next_check_time = t + 5

			local player_unit = template_context.unit
			local missing_ammo_in_clip = Ammo.missing_slot_clip_amount(player_unit, "slot_secondary")
			local current_reserve_percentage = Ammo.current_slot_percentage(player_unit, "slot_secondary")

			if missing_ammo_in_clip <= 0 or current_reserve_percentage <= 0 then
				return
			end

			local ammo_replenished_amount = math.ceil(Ammo.max_ammo_in_clips(template_data.inventory_slot_secondary_component) * percent_ammo_refil_while_holding_melee)

			Ammo.transfer_from_reserve_to_clip(template_data.inventory_slot_secondary_component, ammo_replenished_amount)

			local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.ammo_refil, nil, player_unit)
			end
		end
	end,
}
templates.hordes_buff_weakspot_ranged_hit_always_stagger = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit_ranged,
	proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local enemy_unit = params.attacked_unit
		local attack_direction = params.attack_direction:unbox()
		local stagger_result = params.stagger_result
		local is_critical_strike = params.is_critical_strike
		local target_stagger_type = is_critical_strike and stagger_types.medium or stagger_types.light
		local is_enemy_staggered_with_stronger_force = stagger_impact_comparison[stagger_result] and stagger_impact_comparison[target_stagger_type] < stagger_impact_comparison[stagger_result]

		if HEALTH_ALIVE[enemy_unit] and not is_enemy_staggered_with_stronger_force then
			Stagger.force_stagger(enemy_unit, target_stagger_type, attack_direction, 4, 1, 4, player_unit)
		end
	end,
}

local percent_chance_enemy_explodes_on_ranged_kill = HordesBuffsData.hordes_buff_explode_enemies_on_ranged_kill.buff_stats.chance.value

templates.hordes_buff_explode_enemies_on_ranged_kill = {
	class_name = "server_only_proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = percent_chance_enemy_explodes_on_ranged_kill,
	},
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_func = function (params, template_data, template_context)
		local dying_unit_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
		local explosion_position = dying_unit_position + Vector3.up()
		local explosion_template = ExplosionTemplates.frag_grenade

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, Vector3.up(), template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end,
}

local aoe_shock_interval = HordesBuffsData.hordes_buff_aoe_shock_closest_enemy_on_interval.buff_stats.time.value
local aoe_shock_on_interval_range = HordesBuffsData.hordes_buff_aoe_shock_closest_enemy_on_interval.buff_stats.range.value

templates.hordes_buff_aoe_shock_closest_enemy_on_interval = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = aoe_shock_interval,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(unit)
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not HEALTH_ALIVE[player_unit] or requires_help then
			return
		end

		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, 10, BROADPHASE_RESULTS, enemy_side_names)

		if num_hits > 0 then
			local random_enemy_unit_index = math.random(num_hits)
			local enemy_unit = BROADPHASE_RESULTS[random_enemy_unit_index]

			if HEALTH_ALIVE[enemy_unit] then
				local enemy_unit_position = POSITION_LOOKUP[enemy_unit]

				HordesBuffsUtilities.trigger_aoe_shock_at_position(enemy_unit_position, player_unit, broadphase, enemy_side_names, aoe_shock_on_interval_range, t)
			end
		end
	end,
}

local staggering_pulse_interval = HordesBuffsData.hordes_buff_staggering_pulse.buff_stats.time.value

templates.hordes_buff_staggering_pulse = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = staggering_pulse_interval,
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
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		HordesBuffsUtilities.compute_stagger_and_supression_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t)
	end,
}

local extra_ability_charges = HordesBuffsData.hordes_buff_extra_ability_charge.buff_stats.stack.value

templates.hordes_buff_extra_ability_charge = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = extra_ability_charges,
	},
	keywords = {
		buff_keywords.allow_extra_ability_charges,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.restored_ability_charge = false
	end,
	post_update_keywords_and_stats_func = function (template_data, template_context)
		if not template_context.is_server or template_data.restored_ability_charge then
			return
		end

		local player_unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

		if ability_extension then
			ability_extension:restore_ability_charge("combat_ability", 1)
		end

		template_data.restored_ability_charge = true
	end,
}

local random_damage_immunity_chance = HordesBuffsData.hordes_buff_random_damage_immunity.buff_stats.chance.value

templates.hordes_buff_random_damage_immunity = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.random_damage_immune,
	},
	stat_buffs = {
		[stat_buffs.random_damage_immunity_chance] = random_damage_immunity_chance,
	},
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")
	end,
	check_proc_func = function (params, template_data, template_context)
		local was_damage_negated = params.damage_efficiency == damage_efficiencies.negated

		return was_damage_negated
	end,
	proc_func = function (params, template_data, template_context)
		local player_fx_extension = template_data.player_fx_extension

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.damage_negated, false, template_context.unit)
		end
	end,
}

local big_weakspot_damage_increase = HordesBuffsData.hordes_buff_big_weakspot_damage_increase.buff_stats.damage.value

templates.hordes_buff_big_weakspot_damage_increase = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.weakspot_damage] = big_weakspot_damage_increase,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		return (not template_context.is_server or not DEDICATED_SERVER) and CheckProcFunctions.on_weakspot_hit(params, template_data, template_context)
	end,
	proc_func = function (params, template_data, template_context)
		local hit_unit = params.attacked_unit
		local is_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context)
		local is_ranged_hit = CheckProcFunctions.on_ranged_hit(params, template_data, template_context)
		local wwise_world = template_context.wwise_world
		local wwise_event = is_melee_hit and SFX_NAMES.enhanced_melee_hit or is_ranged_hit and SFX_NAMES.enhanced_ranged_hit or nil

		if wwise_event and ALIVE[hit_unit] then
			WwiseWorld.trigger_resource_event(wwise_world, wwise_event, hit_unit)
		end
	end,
}

local num_enemies_per_cluster_for_coherency_from_enemies = HordesBuffsData.hordes_buff_toughness_coherency_from_enemies_instead_of_players.buff_stats.count.value

templates.hordes_buff_toughness_coherency_from_enemies_instead_of_players = {
	class_name = "stepped_stat_buff",
	max_stacks = 8,
	max_stacks_cap = 8,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.prevent_coherency_toughness_buff,
	},
	stepped_stat_buffs = {
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 0,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 0.5,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 0.75,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 1,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 1.25,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 1.5,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 1.75,
		},
		{
			[stat_buffs.toughness_coherency_regen_rate_modifier] = 2,
		},
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit

		template_data.talent_extension = ScriptUnit.extension(player_unit, "talent_system")
		template_data.num_enemies_in_range = 0
		template_data.sticky_num_enemies_in_range = 0
		template_data.next_sticky_refresh_t = 0
		template_data.sticky_refresh_rate = 5
		template_data.next_enemies_in_range_refresh_t = 0
		template_data.enemies_in_range_refresh_rate = 1
		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(player_unit)
	end,
	bonus_step_func = function (template_data, template_context)
		return math.floor(template_data.sticky_num_enemies_in_range / num_enemies_per_cluster_for_coherency_from_enemies)
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit

		if t > template_data.next_enemies_in_range_refresh_t then
			template_data.next_enemies_in_range_refresh_t = t + template_data.enemies_in_range_refresh_rate

			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local player_position = POSITION_LOOKUP[player_unit]
			local num_hits = broadphase.query(broadphase, player_position, 8, BROADPHASE_RESULTS, enemy_side_names)

			template_data.num_enemies_in_range = num_hits

			if num_hits > 0 and num_hits >= template_data.sticky_num_enemies_in_range then
				template_data.sticky_num_enemies_in_range = num_hits
				template_data.next_sticky_refresh_t = t + template_data.sticky_refresh_rate
			end
		end

		if t > template_data.next_sticky_refresh_t then
			template_data.sticky_num_enemies_in_range = template_data.num_enemies_in_range
			template_data.next_sticky_refresh_t = t + template_data.sticky_refresh_rate
		end
	end,
}

local bleed_burn_melee_hit_burning_stacks = HordesBuffsData.hordes_buff_bleeding_and_burning_on_melee_hit.buff_stats.burn.value
local bleed_burn_melee_hit_bleeding_stacks = HordesBuffsData.hordes_buff_bleeding_and_burning_on_melee_hit.buff_stats.bleed.value

templates.hordes_buff_bleeding_and_burning_on_melee_hit = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 0.4,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local is_ogryn_lunge_hit = params.damage_type == "ogryn_lunge"
		local is_zealot_dash_hit = params.damage_profile and params.damage_profile.name == "zealot_dash_impact"
		local is_valid_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context, t)

		return template_context.is_server and is_valid_melee_hit and not is_ogryn_lunge_hit and not is_zealot_dash_hit
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local fixed_t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_bleeding_and_burning_on_melee_hit_ailment", fixed_t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.burn_bleeding_ailment_proc, enemy_position)
		end
	end,
}
templates.hordes_buff_bleeding_and_burning_on_melee_hit_ailment = {
	class_name = "interval_buff",
	interval = 0.5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.burning,
		buff_keywords.bleeding,
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local bleed_damage_template = DamageProfileTemplates.bleeding
			local power_level = 650
			local source_item = template_context.is_server and template_context.source_item
			local owner_unit = template_context.is_server and template_context.owner_unit or template_context.unit

			Attack.execute(unit, bleed_damage_template, "power_level", power_level, "damage_type", damage_types.bleeding, "attack_type", attack_types.buff, "attacking_unit", owner_unit, "item", source_item)

			local burning_damage_template = DamageProfileTemplates.burning

			Attack.execute(unit, burning_damage_template, "power_level", power_level, "damage_type", damage_types.burning, "attacking_unit", owner_unit, "item", source_item, "attack_type", attack_types.buff)
		end
	end,
	minion_effects = minion_burning_buff_effects.bleedfire,
}

local boosted_melee_swing_cooldown = HordesBuffsData.hordes_buff_boosted_melee_attack_on_cooldown.buff_stats.time.value
local boosted_melee_swing_stat_boost = HordesBuffsData.hordes_buff_boosted_melee_attack_on_cooldown.buff_stats.enhanced.value

templates.hordes_buff_boosted_melee_attack_on_cooldown = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = boosted_melee_swing_stat_boost,
		[stat_buffs.melee_impact_modifier] = boosted_melee_swing_stat_boost,
	},
	start_func = function (template_data, template_context)
		template_data.melee_attack_boost_active = true
		template_data.cooldown_end_t = 0
		template_data.screen_space_effect_t = 0
	end,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_hit] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context, t)
			return template_data.melee_attack_boost_active
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			local is_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context)

			return is_melee_hit and template_data.melee_attack_boost_active
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context, t)
			local num_hits = params.num_hit_units

			return template_data.melee_attack_boost_active and num_hits > 0
		end,
	},
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context, t)
			if template_data.melee_attack_boost_active and (not template_context.is_server or not DEDICATED_SERVER) then
				local wwise_world = template_context.wwise_world

				WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.enhanced_swing, template_context.unit)
			end
		end,
		on_hit = function (params, template_data, template_context, t)
			if template_data.melee_attack_boost_active and (not template_context.is_server or not DEDICATED_SERVER) then
				local wwise_world = template_context.wwise_world

				WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.enhanced_melee_hit, template_context.unit)

				local world = template_context.world

				if not template_data.on_screen_effect_swing_id then
					template_data.on_screen_effect_swing_id = World.create_particles(world, VFX_NAMES.enchance_melee_screen_effect, Vector3(0, 0, 1))
				end

				if template_data.on_screen_effect_id then
					local world = template_context.world

					World.stop_spawning_particles(world, template_data.on_screen_effect_id)

					template_data.on_screen_effect_id = nil
				end
			end
		end,
		on_sweep_finish = function (params, template_data, template_context, t)
			template_data.melee_attack_boost_active = false
			template_data.cooldown_end_t = t + boosted_melee_swing_cooldown
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.melee_attack_boost_active
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if template_data.melee_attack_boost_active then
			return
		end

		if t > template_data.cooldown_end_t then
			template_data.melee_attack_boost_active = true
			template_data.screen_space_effect_t = t

			local world = template_context.world

			if template_data.on_screen_effect_swing_id then
				World.stop_spawning_particles(world, template_data.on_screen_effect_swing_id)

				template_data.on_screen_effect_swing_id = nil
			end

			if template_data.on_screen_effect_id then
				World.stop_spawning_particles(world, template_data.on_screen_effect_id)

				template_data.on_screen_effect_id = nil
			end

			local wwise_world = template_context.wwise_world

			WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.enhanced_swing, template_context.unit)

			template_data.on_screen_effect_id = World.create_particles(world, VFX_NAMES.enchance_melee_screen_effect_less_intense, Vector3(0, 0, 1))
		end
	end,
	stop_func = function (template_data, template_context)
		if template_data.on_screen_effect_id then
			local world = template_context.world

			World.stop_spawning_particles(world, template_data.on_screen_effect_id)

			template_data.on_screen_effect_id = nil
		end

		if template_data.on_screen_effect_swing_id then
			local world = template_context.world

			World.stop_spawning_particles(world, template_data.on_screen_effect_swing_id)

			template_data.on_screen_effect_swing_id = nil
		end
	end,
}

local explosion_on_toughness_broken_cooldown = HordesBuffsData.hordes_buff_explosion_on_toughness_broken.buff_stats.time.value

templates.hordes_buff_explosion_on_toughness_broken = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	cooldown_duration = explosion_on_toughness_broken_cooldown,
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(unit)
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return template_context.unit == params.unit
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local explosion_position = player_position + Vector3(0, 0, 0.65)
		local explosion_template = ExplosionTemplates.hordes_buff_explosion_on_toughness_broken

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, nil, template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end,
}

local reflect_attack_default_push_settings = {
	name = "default",
	push_radius = 2.75,
	inner_push_rad = math.pi * 0.125,
	outer_push_rad = math.pi * 0.25,
	inner_damage_profile = DamageProfileTemplates.hordes_buff_damage_reflection_hit,
	inner_damage_type = damage_types.physical,
	outer_damage_profile = DamageProfileTemplates.hordes_buff_damage_reflection_hit,
	outer_damage_type = damage_types.physical,
}
local reflect_attack_high_damage_push_settings = {
	name = "high",
	push_radius = 2.75,
	inner_push_rad = math.pi * 0.125,
	outer_push_rad = math.pi * 0.25,
	inner_damage_profile = DamageProfileTemplates.hordes_buff_high_damage_reflection_hit,
	inner_damage_type = damage_types.physical,
	outer_damage_profile = DamageProfileTemplates.hordes_buff_high_damage_reflection_hit,
	outer_damage_type = damage_types.physical,
}

templates.hordes_buff_reflect_melee_damage = {
	class_name = "server_only_proc_buff",
	cooldown_duration = 0.5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
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
			local damage = params.damage or 0
			local damage_absorbed = params.damage_absorbed or 0
			local damage_received = damage + damage_absorbed
			local clamped_minimal_damage = math.max(damage_received or 0, 40)
			local damage_received_lerp = math.ease_in_quad(math.clamp01(clamped_minimal_damage * 0.0038461538461538464))
			local power_level = damage_received_lerp * 23000
			local push_settings = reflect_attack_high_damage_push_settings

			PushAttack.push(physics_world, player_position, push_direction, rewind_ms, power_level, push_settings, unit, is_predicted, nil)
		end
	end,
}

return templates
