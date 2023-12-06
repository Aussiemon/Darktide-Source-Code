local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local DodgeSettings = require("scripts/settings/dodge/dodge_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local Health = require("scripts/utilities/health")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionDeath = require("scripts/utilities/minion_death")
local ObjectPenetration = require("scripts/utilities/attack/object_penetration")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Suppression = require("scripts/utilities/attack/suppression")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local Weakspot = require("scripts/utilities/attack/weakspot")
local attack_types = AttackSettings.attack_types
local attack_results = AttackSettings.attack_results
local proc_events = BuffSettings.proc_events
local dodge_types = DodgeSettings.dodge_types
local surface_hit_types = SurfaceMaterialSettings.hit_types
local HitScan = {}
local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4
local DEFAULT_TEST_AGAINST = "both"
local DEFAULT_COLLISION_FILTER = "filter_player_character_shooting_raycast"
local MAX_HITS = 256
local HIT_UNITS = {}
local SUPPRESSED_UNITS = {}
local _block_position, _fetch_damage_type = nil

HitScan.raycast = function (physics_world, position, direction, max_distance, optional_test_against, optional_collision_filter, optional_rewind_ms, optional_is_local_unit, optional_player, optional_is_server)
	local hits = PhysicsWorld.raycast(physics_world, position, direction, max_distance, "all", "types", optional_test_against or DEFAULT_TEST_AGAINST, "max_hits", MAX_HITS, "collision_filter", optional_collision_filter or DEFAULT_COLLISION_FILTER, "rewind_ms", optional_rewind_ms or 0)

	return hits
end

HitScan.sphere_sweep = function (physics_world, position, direction, max_distance, optional_test_against, optional_collision_filter, optional_rewind_ms, optional_radius)
	local end_position = position + direction * max_distance
	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, position, end_position, optional_radius or 0.1, MAX_HITS, "types", optional_test_against or DEFAULT_TEST_AGAINST, "collision_filter", optional_collision_filter or DEFAULT_COLLISION_FILTER, "rewind_ms", optional_rewind_ms or 0, "report_initial_overlap", true)

	return hits
end

HitScan.process_hits = function (is_server, world, physics_world, attacker_unit, fire_configuration, hits, position, direction, power_level, charge_level, impact_fx_data, max_distance, optional_debug_drawer, optional_is_local_unit, optional_player, optional_instakill, optional_is_critical_strike, optional_weapon_item, optional_origin_slot)
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
	local damage_type = _fetch_damage_type(fire_configuration, optional_is_critical_strike, charge_level)
	local attack_type = AttackSettings.attack_types.ranged
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, attacker_unit)
	local hit_mass_budget_attack, hit_mass_budget_impact = DamageProfile.max_hit_mass(damage_profile, power_level, charge_level, damage_profile_lerp_values, optional_is_critical_strike, attacker_unit, attack_type)
	local target_index = 0
	local exit_distance = 0
	local penetrated = false
	local try_penetration = not impact_config.destroy_on_impact and penetration_config
	local stop = false
	local end_position = nil
	local exploded = false
	local hit_minion = false
	local hit_weakspot = false
	local killing_blow = false
	local number_of_units_hit = 0
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
			local explosion_arming_distance = damage_config.explosion_arming_distance or 0
			local can_explode = hit_distance >= explosion_arming_distance

			if HIT_UNITS[hit_unit] then
				break
			end

			if hit_distance < exit_distance then
				break
			end

			local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
			local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro
			local target_breed_or_nil = Breed.unit_breed_or_nil(hit_unit)
			local is_damagable = Health.is_damagable(hit_unit)
			local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(hit_unit)
			local is_breed_with_hit_zone = target_breed_or_nil and hit_zone_name_or_nil
			local is_damagable_hazard_prop = target_is_hazard_prop and hazard_prop_is_active

			if Health.is_ragdolled(hit_unit) then
				if hit_afro then
					break
				end

				MinionDeath.attack_ragdoll(hit_unit, direction, damage_profile, damage_type, hit_zone_name_or_nil, hit_position, attacker_unit, hit_actor, nil, optional_is_critical_strike)
			elseif is_damagable then
				if is_attacker_player and not HitScan.inside_faded_player(target_breed_or_nil, hit_distance) then
					break
				end

				if not target_is_hazard_prop then
					local should_break = false
					local is_undodgeable = damage_profile.undodgeable

					if not is_undodgeable and is_server then
						local is_dodging, dodge_type = Dodge.is_dodging(hit_unit, attack_types.ranged)
						local is_sprint_dodging = Sprint.is_sprint_dodging(hit_unit, attacker_unit, damage_profile.run_away_dodge)

						if is_dodging or is_sprint_dodging then
							HIT_UNITS[hit_unit] = true
							local hit_unit_fx_extension = ScriptUnit.has_extension(hit_unit, "fx_system")

							if is_server and hit_unit_fx_extension then
								local optional_position = hit_position
								local optional_except_sender = false

								hit_unit_fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_player_dodge_ranged_success", optional_position, optional_except_sender)
								Managers.event:trigger("on_sprint_dodge")
							end

							local target_buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

							if target_buff_extension then
								if is_sprint_dodging then
									local param_table = target_buff_extension:request_proc_event_param_table()

									if param_table then
										target_buff_extension:add_proc_event(proc_events.on_sprint_dodge, param_table)
									end
								end

								local param_table = target_buff_extension:request_proc_event_param_table()

								if param_table then
									target_buff_extension:add_proc_event(proc_events.on_ranged_dodge, param_table)
								end
							end

							local player_unit_spawn_manager = Managers.state.player_unit_spawn
							local dodging_player = player_unit_spawn_manager:owner(hit_unit)

							if dodging_player then
								local stat_dodge_type = is_sprint_dodging and dodge_types.sprint or dodge_type

								Managers.stats:record_private("hook_dodged_attack", dodging_player, optional_attacker_breed_name, attack_types.ranged, stat_dodge_type)
							end

							should_break = true
						end
					end

					if hit_afro then
						if is_server and not SUPPRESSED_UNITS[hit_unit] and HEALTH_ALIVE[hit_unit] then
							Suppression.apply_suppression(hit_unit, attacker_unit, damage_profile, hit_position)

							SUPPRESSED_UNITS[hit_unit] = true
						end

						should_break = true
					end

					if should_break then
						break
					end
				end

				hit_weakspot = Weakspot.hit_weakspot(target_breed_or_nil, hit_zone_name_or_nil)
				target_index = RangedAction.target_index(target_index, penetrated, penetration_config)
				hit_mass_budget_attack, hit_mass_budget_impact = HitMass.consume_hit_mass(attacker_unit, hit_unit, hit_mass_budget_attack, hit_mass_budget_impact, hit_weakspot)
				stop = HitMass.stopped_attack(hit_unit, hit_zone_name_or_nil, hit_mass_budget_attack, hit_mass_budget_impact, impact_config)
				local should_deal_damage = target_is_hazard_prop and hazard_prop_is_active or not target_is_hazard_prop and is_breed_with_hit_zone or not target_breed_or_nil
				local damage_dealt, attack_result, damage_efficiency = nil

				if should_deal_damage then
					local previous_hit_weakspot = hit_weakspot
					damage_dealt, attack_result, damage_efficiency, hit_weakspot = RangedAction.execute_attack(target_index, attacker_unit, hit_unit, hit_actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name_or_nil, damage_profile, damage_profile_lerp_values, power_level, charge_level, penetrated, damage_config, optional_instakill, damage_type, optional_is_critical_strike, optional_weapon_item)

					if attack_result == attack_results.blocked then
						hit_position = _block_position(hit_unit, hit_position, direction)
					end

					hit_weakspot = previous_hit_weakspot or hit_weakspot
					killing_blow = killing_blow or attack_result == AttackSettings.attack_results.died
					local breed_is_minion = Breed.is_minion(target_breed_or_nil)
					local breed_is_living_prop = Breed.is_living_prop(target_breed_or_nil)
					hit_minion = hit_minion or breed_is_minion or breed_is_living_prop
					number_of_units_hit = number_of_units_hit + 1
				end

				if Breed.is_character(target_breed_or_nil) or Breed.count_as_character(target_breed_or_nil) then
					exploded = exploded or RangedAction.armor_explosion(is_server, world, physics_world, attacker_unit, hit_unit, hit_zone_name_or_nil, hit_position, hit_normal, hit_distance, direction, damage_config, power_level, charge_level, optional_weapon_item)
					exploded = exploded or RangedAction.hitmass_explosion(is_server, world, physics_world, hit_mass_budget_attack, hit_mass_budget_impact, attacker_unit, hit_unit, hit_position, hit_normal, hit_distance, direction, damage_config, attack_result, power_level, charge_level, optional_weapon_item)
				end

				if not target_is_hazard_prop and target_breed_or_nil and hit_zone_name_or_nil or is_damagable_hazard_prop then
					ImpactEffect.play(hit_unit, hit_actor, damage_dealt, damage_type, hit_zone_name_or_nil, attack_result, hit_position, hit_normal, direction, attacker_unit, impact_fx_data, stop, nil, damage_efficiency, damage_profile)
				else
					ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.stop, impact_fx_data)
				end

				if is_server and not SUPPRESSED_UNITS[hit_unit] and HEALTH_ALIVE[hit_unit] then
					Suppression.apply_suppression(hit_unit, attacker_unit, damage_profile, hit_position)

					SUPPRESSED_UNITS[hit_unit] = true
				end
			elseif try_penetration and not penetrated then
				local exit_position, exit_normal, _ = ObjectPenetration.test_for_penetration(physics_world, hit_position, direction, penetration_config.depth)

				if exit_position then
					try_penetration = false
					penetrated = true
					local object_thickness = Vector3.distance(hit_position, exit_position)
					exit_distance = hit_distance + object_thickness

					if penetration_config.exit_explosion_template and is_server then
						local explosion_attack_type = AttackSettings.attack_types.explosion

						Explosion.create_explosion(world, physics_world, exit_position, exit_normal, attacker_unit, penetration_config.exit_explosion_template, power_level, charge_level, explosion_attack_type, false, false, optional_weapon_item, optional_origin_slot)

						exploded = true
					end

					ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.penetration_entry, impact_fx_data)
					ImpactEffect.play_surface_effect(physics_world, attacker_unit, exit_position, exit_normal, direction, damage_type, surface_hit_types.penetration_exit, impact_fx_data)
				end

				ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.stop, impact_fx_data)

				if not exit_position or penetration_config.destroy_on_exit then
					stop = true
				end

				if can_explode and not exit_position and penetration_config.stop_explosion_template and is_server then
					local explosion_attack_type = AttackSettings.attack_types.explosion

					Explosion.create_explosion(world, physics_world, hit_position, hit_normal, attacker_unit, penetration_config.stop_explosion_template, power_level, charge_level, explosion_attack_type, false, false, optional_weapon_item, optional_origin_slot)

					exploded = true
				end
			else
				if can_explode and penetrated and penetration_config.stop_explosion_template and is_server then
					local explosion_attack_type = AttackSettings.attack_types.explosion

					Explosion.create_explosion(world, physics_world, hit_position, hit_normal, attacker_unit, penetration_config.stop_explosion_template, power_level, charge_level, explosion_attack_type, false, false, optional_weapon_item, optional_origin_slot)

					exploded = true
				end

				stop = true

				ImpactEffect.play_surface_effect(physics_world, attacker_unit, hit_position, hit_normal, direction, damage_type, surface_hit_types.stop, impact_fx_data)
			end

			if can_explode and (stop or penetrated) and impact_config.explosion_template and is_server then
				local explosion_attack_type = AttackSettings.attack_types.explosion

				Explosion.create_explosion(world, physics_world, hit_position, hit_normal, attacker_unit, impact_config.explosion_template, power_level, charge_level, explosion_attack_type, false, false, optional_weapon_item, optional_origin_slot)

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

	return end_position, hit_weakspot, killing_blow, hit_minion, number_of_units_hit
end

HitScan.inside_faded_player = function (breed_or_nil, hit_distance)
	if breed_or_nil then
		local is_target_player = breed_or_nil and Breed.is_player(breed_or_nil)
		local fade_distance = breed_or_nil and breed_or_nil.fade and (breed_or_nil.fade.min_distance + breed_or_nil.fade.max_distance) * 0.5 or 0

		if is_target_player and hit_distance < fade_distance then
			return false
		end
	end

	return true
end

function _block_position(hit_unit, hit_position, attack_direction)
	local hit_unit_weapon_extension = ScriptUnit.has_extension(hit_unit, "weapon_system")

	if not hit_unit_weapon_extension then
		return hit_position
	end

	if not hit_unit_weapon_extension.get_shield_block_position then
		return hit_position
	end

	local moved_position = hit_unit_weapon_extension:get_shield_block_position(hit_position, attack_direction)

	return moved_position
end

function _fetch_damage_type(fire_configuration, is_critical_strike, charge_level)
	local damage_type_to_use = is_critical_strike and fire_configuration.damage_type_critical_strike or fire_configuration.damage_type
	local is_charge_dependant = damage_type_to_use and type(damage_type_to_use) == "table"

	if is_charge_dependant then
		local damage_type_table = damage_type_to_use
		damage_type_to_use = nil

		for i = 1, #damage_type_table do
			local entry = damage_type_table[i]
			local required_charge = entry.charge_level
			local damage_type = entry.damage_type

			if required_charge <= charge_level then
				damage_type_to_use = damage_type
			end
		end
	end

	return damage_type_to_use
end

return HitScan
