-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_utilities.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local hordes_buffs_utilities = {}
local VFX_NAMES = {
	big_shock = "content/fx/particles/player_buffs/buff_electricity_grenade_01",
	enchance_melee_screen_effect = "content/fx/particles/screenspace/screen_buff_enhanced_melee_attack_01",
	enchance_melee_screen_effect_less_intense = "content/fx/particles/screenspace/screen_buff_enhanced_melee_attack_02",
	fire_pulse = "content/fx/particles/player_buffs/buff_fire_360angle_01",
	healing_explosion = "content/fx/particles/player_buffs/buff_healing_area",
	push_wave = "content/fx/particles/player_buffs/buff_unstoppable_double_push_01",
	single_target_shock = "content/fx/particles/player_buffs/buff_electricity_one_target_01",
	stagger_pulse = "content/fx/particles/player_buffs/buff_staggering_pulse",
	veteran_shout = "content/fx/particles/abilities/squad_leader_ability_shout_activate",
}
local SFX_NAMES = {
	ammo_refil = "wwise/events/player/play_horde_mode_buff_ammo_refill",
	avoid_hit_cooldown_finished = "wwise/events/player/play_horde_mode_buff_avoid_hit_activated",
	avoid_hit_triggered = "wwise/events/player/play_horde_mode_buff_avoid_hit",
	burn_bleeding_ailment_proc = "wwise/events/player/play_horde_mode_buff_burn_bleeding_hit",
	burning_proc = "wwise/events/player/play_horde_mode_buff_fire_ignite",
	damage_negated = "wwise/events/player/play_horde_mode_buff_self_damage_negated",
	duplication = "wwise/events/player/play_horde_mode_buff_dublicate",
	electric_pulse = "wwise/events/player/play_horde_mode_buff_electric_pulse",
	enhanced_melee_hit = "wwise/events/player/play_horde_mode_buff_enhanced_damage",
	enhanced_ranged_hit = "wwise/events/player/play_horde_mode_buff_enhanced_damage_ranged",
	enhanced_swing = "wwise/events/player/play_horde_mode_buff_enhanced_swing",
	fire_burst = "wwise/events/player/play_horde_mode_buff_fire_burst",
	fire_pulse = "wwise/events/player/play_horde_mode_buff_fire_pulse",
	friendly_rock_charge_finish = "wwise/events/player/play_horde_mode_buff_rock_charge_finish",
	friendly_rock_charge_start = "wwise/events/player/play_horde_mode_buff_rock_charge_loop",
	friendly_rock_charge_stop = "wwise/events/player/stop_horde_mode_buff_rock_charge_loop",
	gravity_pull = "wwise/events/player/play_horde_mode_buff_gravitation",
	grenade_refil = "wwise/events/player/play_horde_mode_buff_grenade_refill",
	healing = "wwise/events/weapon/play_horde_mode_heal_self_confirmation",
	inferno = "wwise/events/player/play_horde_mode_buff_fire_inferno",
	infinite_ammo_start = "wwise/events/player/play_horde_mode_buff_infinite_ammo_start",
	infinite_ammo_stop = "wwise/events/player/play_horde_mode_buff_infinite_ammo_stop",
	infinite_cleave_hit = "wwise/events/player/play_horde_mode_buff_infinite_cleave_hit",
	reduced_damage_hit = "wwise/events/player/play_horde_mode_buff_shield_hit",
	shield = "wwise/events/weapon/play_horde_mode_buff_shield",
	shock_aoe_big = "wwise/events/player/play_horde_mode_buff_electric_shock",
	shock_crit = "wwise/events/player/play_horde_mode_buff_electric_crit",
	shock_proc = "wwise/events/player/play_horde_mode_buff_electric_damage",
	stagger_hit = "wwise/events/player/play_horde_mode_buff_stagger_hit",
	stagger_pulse = "wwise/events/player/play_horde_mode_buff_stagger_pulse",
	super_crit = "wwise/events/player/play_horde_mode_buff_super_crit",
}

hordes_buffs_utilities.SFX_NAMES = SFX_NAMES
hordes_buffs_utilities.VFX_NAMES = VFX_NAMES

hordes_buffs_utilities.give_passive_grenade_replenishment_buff = function (unit)
	local current_time = FixedFrame.get_latest_fixed_time()
	local buff_extension = ScriptUnit.extension(unit, "buff_system")

	if buff_extension then
		local _, _, _ = buff_extension:add_externally_controlled_buff("hordes_buff_grenade_replenishment_over_time_passive", current_time)
	end
end

hordes_buffs_utilities.compute_enemy_pulse_and_apply_buff = function (is_server, player_unit, broadphase, enemy_side_names, t, buff_to_add, optional_stacks, optional_enemy_sfx, optional_pulse_vfx, optional_pulse_sfx, optional_pulse_sfx_stronger)
	if not is_server then
		return
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local requires_help = PlayerUnitStatus.requires_help(character_state_component)

	if not HEALTH_ALIVE[player_unit] or requires_help then
		return
	end

	local fx_system = Managers.state.extension:system("fx_system")
	local player_position = POSITION_LOOKUP[player_unit]
	local num_hits = broadphase.query(broadphase, player_position, 12, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff_with_stacks(buff_to_add, optional_stacks or 1, t, "owner_unit", player_unit)

			if optional_enemy_sfx then
				local enemy_position = POSITION_LOOKUP[enemy_unit]

				fx_system:trigger_wwise_event(optional_enemy_sfx, enemy_position)
			end
		end
	end

	if optional_pulse_sfx then
		local target_sfx = optional_pulse_sfx_stronger and num_hits >= 10 and optional_pulse_sfx_stronger or optional_pulse_sfx

		fx_system:trigger_wwise_event(target_sfx, nil, player_unit)
	end

	if optional_pulse_vfx then
		local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

		if player_fx_extension then
			local variable_name = "radius"
			local variable_value = Vector3(10, 10, 10)
			local vfx_position = player_position + Vector3(0, 0, 0.65)

			player_fx_extension:spawn_particles(optional_pulse_vfx, vfx_position, nil, nil, variable_name, variable_value, true)
		end
	end
end

hordes_buffs_utilities.compute_fire_pulse = function (is_server, player_unit, broadphase, enemy_side_names, t, optional_stacks, optional_skip_effects)
	local enemy_hit_sfx = hordes_buffs_utilities.SFX_NAMES.burning_proc
	local pulse_vfx = not optional_skip_effects and hordes_buffs_utilities.VFX_NAMES.fire_pulse or nil
	local pulse_sfx = not optional_skip_effects and hordes_buffs_utilities.SFX_NAMES.fire_pulse or nil
	local pulse_sfx_stronger = not optional_skip_effects and hordes_buffs_utilities.SFX_NAMES.inferno or nil

	hordes_buffs_utilities.compute_enemy_pulse_and_apply_buff(is_server, player_unit, broadphase, enemy_side_names, t, "flamer_assault", optional_stacks, enemy_hit_sfx, pulse_vfx, pulse_sfx, pulse_sfx_stronger)
end

hordes_buffs_utilities.compute_stagger_and_supression_pulse = function (is_server, player_unit, broadphase, enemy_side_names, t, optional_skip_effects)
	if not is_server then
		return
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local requires_help = PlayerUnitStatus.requires_help(character_state_component)

	if not HEALTH_ALIVE[player_unit] or requires_help then
		return
	end

	local player_position = POSITION_LOOKUP[player_unit]
	local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)
	local fx_system = Managers.state.extension:system("fx_system")

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local blackboard = BLACKBOARDS[enemy_unit]
		local stagger_component = blackboard.stagger
		local is_staggered = stagger_component.num_triggered_staggers > 0

		if HEALTH_ALIVE[enemy_unit] and not is_staggered then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local attack_direction = Vector3.normalize(Vector3.flat(enemy_position - player_position))
			local random_duration_range = math.random_range(2.6666666666666665, 4)

			Stagger.force_stagger(enemy_unit, stagger_types.medium, attack_direction, random_duration_range, 1, 0.3333333333333333, player_unit)

			if not optional_skip_effects and i <= 5 then
				fx_system:trigger_wwise_event(hordes_buffs_utilities.SFX_NAMES.stagger_hit, enemy_position)
			end
		end
	end

	if not optional_skip_effects then
		fx_system:trigger_wwise_event(hordes_buffs_utilities.SFX_NAMES.stagger_pulse, nil, player_unit)

		local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

		if player_fx_extension then
			local vfx_position = player_position + Vector3(0, 0, 0.65)

			player_fx_extension:spawn_particles(hordes_buffs_utilities.VFX_NAMES.stagger_pulse, vfx_position, nil, nil, nil, nil, true)
		end
	end
end

hordes_buffs_utilities.pull_enemies_towards_position = function (player_unit, target_position, stagger_type, broadphase, target_side_names, range)
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]

		if HEALTH_ALIVE[enemy_unit] then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local pull_direction = Vector3.normalize(Vector3.flat(target_position - enemy_position))

			if Vector3.length_squared(pull_direction) > 0 then
				Stagger.force_stagger(enemy_unit, stagger_type, pull_direction, 5, 1, 5, player_unit)
			end
		end
	end
end

hordes_buffs_utilities.pull_enemies_towards_target_unit = function (player_unit, target_unit, stagger_type, broadphase, target_side_names, range)
	local target_position = POSITION_LOOKUP[target_unit]
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]

		if enemy_unit ~= target_unit and HEALTH_ALIVE[enemy_unit] then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local pull_direction = Vector3.normalize(Vector3.flat(target_position - enemy_position))

			if Vector3.length_squared(pull_direction) > 0 then
				Stagger.force_stagger(enemy_unit, stagger_type, pull_direction, 5, 1, 5, player_unit)
			end
		end
	end
end

hordes_buffs_utilities.trigger_aoe_shock_at_position = function (target_position, owner_unit, broadphase, target_side_names, range, t)
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("hordes_ailment_shock", t, "owner_unit", owner_unit)
		end
	end

	local fx_system = Managers.state.extension:system("fx_system")

	fx_system:trigger_wwise_event(SFX_NAMES.shock_aoe_big, target_position)
	fx_system:trigger_vfx(VFX_NAMES.big_shock, target_position)
end

hordes_buffs_utilities.get_random_nearby_alive_enemy_from_position = function (target_position, broadphase, target_side_names, range)
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	if num_hits == 0 then
		return nil
	end

	local picked_unit

	for i = 1, num_hits do
		local target_unit = BROADPHASE_RESULTS[i]

		if HEALTH_ALIVE[target_unit] then
			local pick_chance = i / num_hits
			local picked = pick_chance >= math.random()

			if picked then
				picked_unit = target_unit

				break
			elseif picked_unit == nil then
				picked_unit = target_unit
			end
		end
	end

	return picked_unit
end

hordes_buffs_utilities.spawn_telekine_dome_at_position = function (physics_world, owner_unit, target_position)
	local ray_origin = target_position + Vector3.up()
	local down_direction = Vector3.down()
	local ray_distance = 10
	local hit, spawn_position, _, _, _ = PhysicsWorld.raycast(physics_world, ray_origin, down_direction, ray_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")

	if not hit then
		spawn_position = target_position
	end

	local unit_name = "content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_functional"
	local husk_unit_name = "content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_functional"
	local unit_template = "force_field"
	local material
	local rotation = Quaternion.identity()
	local unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, spawn_position, rotation, material, husk_unit_name, nil, owner_unit, "sphere")
end

hordes_buffs_utilities.trigger_brain_burst_on_target = function (target_unit, attacking_unit)
	if not HEALTH_ALIVE[target_unit] then
		return
	end

	local player_unit = attacking_unit
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
end

return hordes_buffs_utilities
