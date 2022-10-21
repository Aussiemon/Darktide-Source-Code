local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local DodgeSettings = require("scripts/settings/dodge/dodge_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local Health = require("scripts/utilities/health")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionDeath = require("scripts/utilities/minion_death")
local ObjectPenetration = require("scripts/utilities/attack/object_penetration")
local PropUtilities = require("scripts/utilities/level_props/prop_utilities")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Suppression = require("scripts/utilities/attack/suppression")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local attack_types = AttackSettings.attack_types
local dodge_types = DodgeSettings.dodge_types
local surface_hit_types = SurfaceMaterialSettings.hit_types
local HitScan = {}
local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4
local DEFAULT_TEST_AGAINST = "both"
local DEFAULT_COLLISION_FILTER = "filter_player_character_shooting"
local MAX_HITS = 256
local HIT_UNITS = {}
local SUPPRESSED_UNITS = {}

HitScan.raycast = function (physics_world, position, direction, max_distance, optional_test_against, optional_collision_filter, optional_rewind_ms, optional_is_local_unit, optional_player, optional_is_server)
	local hits = PhysicsWorld.raycast(physics_world, position, direction, max_distance, "all", "types", optional_test_against or DEFAULT_TEST_AGAINST, "max_hits", MAX_HITS, "collision_filter", optional_collision_filter or DEFAULT_COLLISION_FILTER, "rewind_ms", optional_rewind_ms or 0)

	return hits
end

HitScan.sphere_sweep = function (physics_world, position, direction, max_distance, optional_test_against, optional_collision_filter, optional_rewind_ms, optional_radius)
	local end_position = position + direction * max_distance

	PhysicsProximitySystem.prepare_for_overlap(physics_world, position, 0.1, optional_rewind_ms or 0)

	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, position, end_position, optional_radius or 0.1, MAX_HITS, "types", optional_test_against or DEFAULT_TEST_AGAINST, "collision_filter", optional_collision_filter or DEFAULT_COLLISION_FILTER, "report_initial_overlap", true)

	return hits
end

HitScan.process_hits = function (is_server, world, physics_world, attacker_unit, fire_configuration, hits, position, direction, power_level, charge_level, impact_fx_data, max_distance, optional_debug_drawer, optional_is_local_unit, optional_player, optional_instakill, optional_is_critical_strike, optional_weapon_item)
	if not hits then
		return
	end

	table.clear(HIT_UNITS)
	table.clear(SUPPRESSED_UNITS)

	HIT_UNITS[attacker_unit] = true
	local hit_scan_template = fire_configuration.hit_scan_template
	local damage_config = hit_scan_template.damage
	local impact_config = damage_config.impact
	local penetration_config = damage_config.penetration
	local damage_profile = damage_config.impact.damage_profile
	local damage_type = fire_configuration.damage_type
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, attacker_unit)
	local hit_mass_budget_attack, hit_mass_budget_impact = DamageProfile.max_hit_mass(damage_profile, power_level, charge_level, damage_profile_lerp_values, optional_is_critical_strike)
	local target_index = 0
	local exit_distance = 0
	local penetrated = false
	local try_penetration = not impact_config.destroy_on_impact and penetration_config
	local stop = false
	local end_position = nil
	local exploded = false
	local optional_attacker_data_extension = ScriptUnit.has_extension(attacker_unit, "unit_data_system")
	local optional_attacker_breed = optional_attacker_data_extension and optional_attacker_data_extension:breed()
	local optional_attacker_breed_name = optional_attacker_breed and optional_attacker_breed.name
	local is_attacker_player = Breed.is_player(optional_attacker_breed)
	local num_hits = #hits

	for index = 1, num_hits do
		repeat
			local hit = hits[index]
			local hit_position = hit.position or hit[INDEX_POSITION]
			local hit_normal = hit.normal or hit[INDEX_NORMAL]
			local hit_distance = hit.distance or hit[INDEX_DISTANCE]
			local hit_actor = hit.actor or hit[INDEX_ACTOR]
			local hit_unit = Actor.unit(hit_actor)

			if HIT_UNITS[hit_unit] then
				break
			end

			if hit_distance < exit_distance then
				break
			end

			local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
			local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro

			if Health.is_ragdolled(hit_unit) then
				if hit_afro then
					break
				end

				MinionDeath.attack_ragdoll(hit_unit, direction, damage_profile, damage_type, hit_zone_name_or_nil, hit_position, attacker_unit, hit_actor, nil, optional_is_critical_strike)
			else
				ImpactEffect.play(hit_unit, hit_actor, 0, damage_type, hit_zone_name_or_nil, attack_types.ranged, hit_position, hit_normal, direction, attacker_unit, impact_fx_data, stop, nil, "full", damage_profile)

				if is_attacker_player and not HitScan.check_faded_players(hit_unit, hit_distance) then
					break
				end

				local is_undodgeable = damage_profile.undodgeable
				local is_dodging, dodge_type = Dodge.is_dodging(hit_unit, attack_types.ranged)
				local is_sprinting = Sprint.is_sprint_dodging(hit_unit, attacker_unit)
				HIT_UNITS[hit_unit] = true
				local hit_unit_fx_extension = ScriptUnit.has_extension(hit_unit, "fx_system")

				if is_server and hit_unit_fx_extension then
					local optional_position = hit_position
					local optional_except_sender = false

					hit_unit_fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_player_dodge_ranged_success", optional_position, optional_except_sender)
				end

				local player_unit_spawn_manager = Managers.state.player_unit_spawn
				local dodging_player = player_unit_spawn_manager:owner(hit_unit)
				local is_human = dodging_player and dodging_player:is_human_controlled()

				Managers.stats:record_dodge(dodging_player, optional_attacker_breed_name, attack_types.ranged, is_sprinting and dodge_types.sprint or dodge_type)
				Suppression.apply_suppression(hit_unit, attacker_unit, damage_profile, hit_position)

				SUPPRESSED_UNITS[hit_unit] = true
				target_index = RangedAction.target_index(target_index, penetrated, penetration_config)
				hit_mass_budget_attack, hit_mass_budget_impact = HitMass.consume_hit_mass(hit_unit, hit_mass_budget_attack, hit_mass_budget_impact)
				stop = HitMass.stopped_attack(hit_unit, hit_zone_name_or_nil, hit_mass_budget_attack, hit_mass_budget_impact, impact_config)
				local damage_dealt, attack_result, damage_efficiency = RangedAction.execute_attack(target_index, attacker_unit, hit_unit, hit_actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name_or_nil, damage_profile, damage_profile_lerp_values, power_level, charge_level, penetrated, damage_config, optional_instakill, damage_type, optional_is_critical_strike, optional_weapon_item)

				ImpactEffect.play(hit_unit, hit_actor, damage_dealt, damage_type, hit_zone_name_or_nil, attack_result, hit_position, hit_normal, direction, attacker_unit, impact_fx_data, stop, nil, damage_efficiency, damage_profile)

				exploded = exploded or RangedAction.armor_explosion(is_server, world, physics_world, attacker_unit, hit_unit, hit_zone_name_or_nil, hit_position, hit_normal, hit_distance, direction, damage_config, power_level, charge_level, optional_weapon_item)
				exploded = exploded or RangedAction.hitmass_explosion(is_server, world, physics_world, hit_mass_budget_attack, hit_mass_budget_impact, attacker_unit, hit_unit, hit_position, hit_normal, hit_distance, direction, damage_config, attack_result, power_level, charge_level, optional_weapon_item)

				if is_server and not SUPPRESSED_UNITS[hit_unit] and HEALTH_ALIVE[hit_unit] then
					Suppression.apply_suppression(hit_unit, attacker_unit, damage_profile, hit_position)

					SUPPRESSED_UNITS[hit_unit] = true

					if true then
						if try_penetration and not penetrated then
							local exit_position, exit_normal, _ = ObjectPenetration.test_for_penetration(physics_world, hit_position, direction, penetration_config.depth)

							if exit_position then
								try_penetration = false
								penetrated = true
								local object_thickness = Vector3.distance(hit_position, exit_position)
								exit_distance = hit_distance + object_thickness

								if penetration_config.exit_explosion_template and is_server then
									local attack_type = AttackSettings.attack_types.explosion

									Explosion.create_explosion(world, physics_world, exit_position, exit_normal, attacker_unit, penetration_config.exit_explosion_template, power_level, charge_level, attack_type, nil, optional_weapon_item)

									exploded = true
								end

								ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.penetration_entry, impact_fx_data)
								ImpactEffect.play_surface_effect(physics_world, attacker_unit, exit_position, exit_normal, direction, damage_type, surface_hit_types.penetration_exit, impact_fx_data)
							end

							ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.stop, impact_fx_data)

							if not exit_position or penetration_config.destroy_on_exit then
								stop = true
							end

							if not exit_position and penetration_config.stop_explosion_template and is_server then
								local attack_type = AttackSettings.attack_types.explosion

								Explosion.create_explosion(world, physics_world, hit_position, hit_normal, attacker_unit, penetration_config.stop_explosion_template, power_level, charge_level, attack_type, nil, optional_weapon_item)

								exploded = true
							end
						else
							if penetrated and penetration_config.stop_explosion_template and is_server then
								local attack_type = AttackSettings.attack_types.explosion

								Explosion.create_explosion(world, physics_world, hit_position, hit_normal, attacker_unit, penetration_config.stop_explosion_template, power_level, charge_level, attack_type, nil, optional_weapon_item)

								exploded = true
							end

							stop = true

							ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.stop, impact_fx_data)
						end
					end
				end
			end

			if (stop or penetrated) and impact_config.explosion_template and is_server then
				local attack_type = AttackSettings.attack_types.explosion

				Explosion.create_explosion(world, physics_world, hit_position, hit_normal, attacker_unit, impact_config.explosion_template, power_level, charge_level, attack_type, nil, optional_weapon_item)

				exploded = true
			end

			if stop then
				end_position = hit_position
			end

			HIT_UNITS[hit_unit] = true
		until true

		if stop then
			break
		end
	end

	return end_position
end

HitScan.check_faded_players = function (hit_unit, hit_distance)
	local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")

	if unit_data_extension then
		local breed = unit_data_extension:breed()
		local is_target_player = breed and Breed.is_player(breed)
		local fade_distance = breed and breed.fade and (breed.fade.min_distance + breed.fade.max_distance) * 0.5 or 0

		if is_target_player and hit_distance < fade_distance then
			return false
		end
	end

	return true
end

return HitScan
