-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_psyker_buff_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
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

templates.hordes_buff_psyker_smite_always_max_damage = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.psyker_chain_lightning_full_charge,
	},
}
templates.hordes_buff_psyker_shout_always_stagger = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.shout_forces_strong_stagger,
	},
}

local percent_damage_taken_reduction_during_overcharge = HordesBuffsData.hordes_buff_psyker_overcharge_reduced_damage_taken.buff_stats.dammage.value

templates.hordes_buff_psyker_overcharge_reduced_damage_taken = {
	class_name = "server_only_proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = percent_damage_taken_reduction_during_overcharge,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	start_func = function (template_data, template_context)
		template_data.player_fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")

		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.is_active = template_data.buff_extension:has_keyword(buff_keywords.psyker_overcharge)
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return template_data.is_active
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.reduced_damage_hit, false, template_context.unit)
	end,
}

local burn_bleed_stacks_on_psyker_brain_burst = HordesBuffsData.hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit.buff_stats.stack.value

templates.hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_smite_attack,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacked_unit

		if HEALTH_ALIVE[target_unit] then
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", burn_bleed_stacks_on_psyker_brain_burst, t, "owner_unit", player_unit)
				buff_extension:add_internally_controlled_buff_with_stacks("bleed", burn_bleed_stacks_on_psyker_brain_burst, t, "owner_unit", player_unit)
			end
		end
	end,
}

local max_num_enemies_hit_by_brain_burst = HordesBuffsData.hordes_buff_psyker_brain_burst_hits_nearby_enemies.buff_stats.ennemies.value

templates.hordes_buff_psyker_brain_burst_hits_nearby_enemies = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.next_target_index = 1
		template_data.hit_targets_left = 0
		template_data.target_units = {}
		template_data.delay_between_hits = 0.1
		template_data.next_hit_t = 0
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return CheckProcFunctions.on_smite_attack(params, template_data, template_context, t) and params.attack_type ~= attack_types.buff
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local dying_unit = params.attacked_unit
		local enemy_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
		local range = 5
		local targets_left_to_spread = max_num_enemies_hit_by_brain_burst
		local num_hits = broadphase.query(broadphase, enemy_position, range, BROADPHASE_RESULTS, enemy_side_names)

		template_data.next_target_index = 1
		template_data.hit_targets_left = 0
		template_data.next_hit_t = t + template_data.delay_between_hits

		table.clear(template_data.target_units)

		for i = 1, num_hits do
			local nearby_enemy_unit = BROADPHASE_RESULTS[i]

			if nearby_enemy_unit ~= dying_unit and HEALTH_ALIVE[nearby_enemy_unit] then
				if HEALTH_ALIVE[nearby_enemy_unit] then
					table.insert(template_data.target_units, nearby_enemy_unit)

					template_data.hit_targets_left = template_data.hit_targets_left + 1
				end

				targets_left_to_spread = targets_left_to_spread - 1
			end

			if targets_left_to_spread <= 0 then
				break
			end
		end
	end,
	update_func = function (template_data, template_context, dt, t)
		local hit_targets_left = template_data.hit_targets_left

		if hit_targets_left <= 0 or t < template_data.next_hit_t then
			return
		end

		local target_units = template_data.target_units
		local target_unit_index = template_data.next_target_index
		local target_unit = target_units[target_unit_index]

		template_data.next_target_index = template_data.next_target_index + 1
		template_data.hit_targets_left = template_data.hit_targets_left - 1
		template_data.next_hit_t = t + template_data.delay_between_hits

		if not HEALTH_ALIVE[target_unit] then
			return
		end

		local player_unit = template_context.unit
		local player_pos = POSITION_LOOKUP[player_unit]
		local damage_profile = DamageProfileTemplates.psyker_smite_kill
		local hit_unit_pos = POSITION_LOOKUP[target_unit]
		local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
		local target_breed = target_unit_data_extension and target_unit_data_extension:breed()
		local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)
		local hit_world_position = hit_unit_pos
		local hit_zone_name, hit_actor

		if target_breed then
			local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
			local preferred_hit_zone_name = "head"
			local hit_zone = hit_zone_weakspot_types and (hit_zone_weakspot_types[preferred_hit_zone_name] and preferred_hit_zone_name or next(hit_zone_weakspot_types)) or hit_zone_names.center_mass
			local actors = HitZone.get_actor_names(target_unit, hit_zone)
			local hit_actor_name = actors[1]

			hit_zone_name = hit_zone
			hit_actor = Unit.actor(target_unit, hit_actor_name)

			local actor_node = Actor.node(hit_actor)

			hit_world_position = Unit.world_position(target_unit, actor_node)
		end

		local damage_dealt, attack_result, damage_efficiency = Attack.execute(target_unit, damage_profile, "power_level", 500, "charge_level", 1, "hit_zone_name", hit_zone_name, "hit_actor", hit_actor, "attacking_unit", player_unit, "attack_type", attack_types.buff, "damage_type", damage_types.smite)

		ImpactEffect.play(target_unit, hit_actor, damage_dealt, damage_types.smite, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)
	end,
}

local function _spread_fire_to_nearby_units(broadphase, query_side_name, query_results, player_unit, origin_unit, origin_position, range, max_units_to_spread, fire_stacks, warp_fire_stacks)
	if fire_stacks == 0 and warp_fire_stacks == 0 then
		warp_fire_stacks = 10
	end

	local t = FixedFrame.get_latest_fixed_time()
	local num_hits = broadphase.query(broadphase, origin_position, range, query_results, query_side_name)
	local targets_left_to_spread = max_units_to_spread

	for i = 1, num_hits do
		local nearby_enemy_unit = query_results[i]
		local nearby_enemy_buff_extension = ScriptUnit.has_extension(nearby_enemy_unit, "buff_system")

		if nearby_enemy_unit ~= origin_unit and HEALTH_ALIVE[nearby_enemy_unit] and nearby_enemy_buff_extension then
			if fire_stacks > 0 then
				nearby_enemy_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", fire_stacks, t, "owner_unit", player_unit)
			end

			if warp_fire_stacks > 0 then
				nearby_enemy_buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", warp_fire_stacks, t, "owner_unit", player_unit)
			end

			targets_left_to_spread = targets_left_to_spread - 1
		end

		if targets_left_to_spread <= 0 then
			break
		end
	end
end

templates.hordes_buff_psyker_brain_burst_spreads_fire_on_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	check_proc_func = CheckProcFunctions.on_smite_attack,
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context)
			local player_unit = template_context.unit
			local target_unit = params.attacked_unit
			local target_unit_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if target_unit_buff_extension then
				local is_target_alive_and_not_burning = HEALTH_ALIVE[target_unit] and not target_unit_buff_extension:has_keyword(buff_keywords.burning)

				if is_target_alive_and_not_burning then
					return
				end

				local fire_stacks = target_unit_buff_extension:current_stacks("flamer_assault")
				local warp_fire_stacks = target_unit_buff_extension:current_stacks("warp_fire")
				local broadphase = template_data.broadphase
				local enemy_position = POSITION_LOOKUP[target_unit]
				local enemy_side_names = template_data.enemy_side_names
				local range = 5

				_spread_fire_to_nearby_units(broadphase, enemy_side_names, BROADPHASE_RESULTS, player_unit, target_unit, enemy_position, range, 100, fire_stacks, warp_fire_stacks)
			end
		end,
		[proc_events.on_kill] = function (params, template_data, template_context)
			local player_unit = template_context.unit
			local target_unit = params.attacked_unit
			local fire_stacks = 10
			local warp_fire_stacks = 0
			local broadphase = template_data.broadphase
			local enemy_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
			local enemy_side_names = template_data.enemy_side_names
			local range = 5

			_spread_fire_to_nearby_units(broadphase, enemy_side_names, BROADPHASE_RESULTS, player_unit, target_unit, enemy_position, range, 100, fire_stacks, warp_fire_stacks)
		end,
	},
}

local percent_stat_value_from_psyker_shout = HordesBuffsData.hordes_buff_psyker_shout_boosts_allies.buff_stats.dammage.value
local psyker_shout_ally_boost_duration = HordesBuffsData.hordes_buff_psyker_shout_boosts_allies.buff_stats.time.value

templates.hordes_buff_psyker_shout_boosts_allies = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_psyker_shout_hit_ally] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local ally_unit = params.ally_unit

		if HEALTH_ALIVE[ally_unit] then
			local buff_extension = ScriptUnit.has_extension(ally_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff("hordes_buff_psyker_shout_boosts_allies_effect", t)
			end
		end
	end,
}
templates.hordes_buff_psyker_shout_boosts_allies_effect = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	duration = psyker_shout_ally_boost_duration,
	stat_buffs = {
		[stat_buffs.damage] = percent_stat_value_from_psyker_shout,
		[stat_buffs.toughness_damage_taken_multiplier] = percent_stat_value_from_psyker_shout,
	},
}
templates.hordes_buff_psyker_burning_on_throwing_knife_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.damage_type == damage_types.throwing_knife
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", 2, t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_psyker_recover_knife_on_knife_kill = {
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

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return params.damage_type == damage_types.throwing_knife
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			return
		end

		local missing_charges = ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			return
		end

		ability_extension:restore_ability_charge("grenade_ability", 1)

		local player_unit = template_context.uni
		local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, player_unit)
		end
	end,
}
templates.hordes_buff_psyker_shock_on_touch_force_field = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_unit_touch_force_field] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local is_player_unit = params.is_player_unit

		if is_player_unit then
			return
		end

		local player_unit = template_context.unit
		local enemy_unit = params.passing_unit
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if HEALTH_ALIVE[enemy_unit] and buff_extension then
			buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 1, t, "owner_unit", player_unit)

			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

return templates
