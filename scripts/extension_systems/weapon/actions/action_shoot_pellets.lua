require("scripts/extension_systems/weapon/actions/action_shoot")

local Armor = require("scripts/utilities/attack/armor")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Explosion = require("scripts/utilities/attack/explosion")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local Health = require("scripts/utilities/health")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitScan = require("scripts/utilities/attack/hit_scan")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionDeath = require("scripts/utilities/minion_death")
local ObjectPenetration = require("scripts/utilities/attack/object_penetration")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Suppression = require("scripts/utilities/attack/suppression")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local attack_types = AttackSettings.attack_types
local hit_types = SurfaceMaterialSettings.hit_types
local proc_events = BuffSettings.proc_events
local ActionShootPellets = class("ActionShootPellets", "ActionShoot")
local EMPTY_TABLE = {}
local IMPACT_FX_DATA = {
	will_be_predicted = true
}
local NUM_PELLETS = 32
local MAX_NUM_HITS_UNITS = 128
local MAX_NUM_SAVED_PELLET_HITS = 256
local MAX_NUM_SURFACE_IMPACT_EFFECTS = 32
local MAX_NUM_HITS_PER_UNIT = 32
local _shotshell_template = nil

ActionShootPellets.init = function (self, action_context, action_params, action_settings)
	ActionShootPellets.super.init(self, action_context, action_params, action_settings)

	local saved_pellet_hits = {}

	for i = 1, NUM_PELLETS do
		saved_pellet_hits[i] = {
			charge_level = 0,
			num_hits = 0,
			power_level = 0,
			fire_position = Vector3Box(),
			direction = Vector3Box(),
			hit_results = {}
		}

		for j = 1, MAX_NUM_SAVED_PELLET_HITS do
			saved_pellet_hits[i].hit_results[j] = {
				distance = 0,
				position = Vector3Box(),
				normal = Vector3Box(),
				actor = ActorBox()
			}
		end
	end

	self._saved_pellet_hits = saved_pellet_hits
	self._hit_units = {}
	self._suppressed_hits_per_unit = {}
	self._suppressed_hit_positions_per_unit = {}
	self._num_hits_per_unit_per_hit_zone = {}
	self._num_hits_per_unit = {}
	self._num_impact_fx_per_unit = {}
	local unit_damage_data = {}

	for i = 1, MAX_NUM_HITS_UNITS do
		unit_damage_data[i] = {}
	end

	self._unit_damage_data = unit_damage_data
	self._unit_to_damage_data_index = {}
	self._num_unit_damage_index = 0
	local surface_impact_data = {}

	for hit_type, _ in pairs(hit_types) do
		surface_impact_data[hit_type] = {}

		for ii = 1, MAX_NUM_SURFACE_IMPACT_EFFECTS do
			local hits = {}

			for jj = 1, MAX_NUM_HITS_PER_UNIT do
				hits[jj] = {}
			end

			surface_impact_data[hit_type][ii] = {
				hits = hits
			}
		end
	end

	self._surface_impact_data = surface_impact_data
	self._surface_impact_num_hits_per_unit = {
		penetration_entry = {},
		penetration_exit = {},
		stop = {}
	}
	self._surface_impact_num_hits = {
		penetration_exit = 0,
		penetration_entry = 0,
		stop = 0
	}
	self._num_saved_pellets = 0
	local unit_data_extension = action_context.unit_data_extension
	self._action_shoot_pellets_component = unit_data_extension:write_component("action_shoot_pellets")
	self._action_reload_component = unit_data_extension:write_component("action_reload")
end

ActionShootPellets.start = function (self, ...)
	Managers.server_metrics:add_annotation("action_shoot_pellets")
	ActionShootPellets.super.start(self, ...)
	table.clear(self._hit_units)
	table.clear(self._suppressed_hits_per_unit)
	table.clear(self._suppressed_hit_positions_per_unit)
	table.clear(self._num_hits_per_unit_per_hit_zone)
	table.clear(self._num_hits_per_unit)
	table.clear(self._num_impact_fx_per_unit)

	local unit_damage_data = self._unit_damage_data

	for i = 1, MAX_NUM_HITS_UNITS do
		table.clear(unit_damage_data[i])
	end

	table.clear(self._unit_to_damage_data_index)

	self._num_unit_damage_index = 0
	self._num_saved_pellets = 0
	self._action_shoot_pellets_component.num_pellets_fired = 0
	self._number_of_pellets_hit = 0
end

ActionShootPellets._shoot = function (self, position, rotation, power_level, charge_level, t)
	local weapon_spread_extension = self._weapon_spread_extension
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration
	local shotshell_template = _shotshell_template(fire_config, self._inventory_slot_component)
	local num_spread_circles = shotshell_template.num_spread_circles
	local bullseye = shotshell_template.bullseye
	local spread_pitch = shotshell_template.spread_pitch
	local spread_yaw = shotshell_template.spread_yaw
	local max_distance = shotshell_template.range
	local no_random_roll = shotshell_template.no_random_roll
	local roll_offset = shotshell_template.roll_offset
	local scatter_range = shotshell_template.scatter_range
	local num_pellets_fired = self._action_shoot_pellets_component.num_pellets_fired
	local num_pellets_total = shotshell_template.num_pellets
	local number_of_pellets_hit = self._number_of_pellets_hit
	local remaining_pellets = num_pellets_total - num_pellets_fired
	local num_pellets_this_frame = math.min(shotshell_template.pellets_per_frame, remaining_pellets)

	for i = 1, num_pellets_this_frame do
		num_pellets_fired = num_pellets_fired + 1
		local pellet_rotation = weapon_spread_extension:target_style_spread(rotation, num_pellets_fired, num_pellets_total, num_spread_circles, bullseye, spread_pitch, spread_yaw, scatter_range, no_random_roll, roll_offset)
		local direction = Quaternion.forward(pellet_rotation)
		local rewind_ms = self:_rewind_ms(self._is_local_unit, self._player, position, direction, max_distance)
		local hits = HitScan.raycast(self._physics_world, position, direction, max_distance, nil, "filter_player_character_shooting", rewind_ms)

		if hits then
			local pellet_hit = self:_save_pellet_hits(hits, position, direction, max_distance, charge_level)

			if pellet_hit then
				number_of_pellets_hit = number_of_pellets_hit + 1
			end
		end
	end

	local process_hits = num_pellets_total <= num_pellets_fired

	if process_hits then
		local number_of_units_hit = self:_process_hits(power_level, t)

		table.clear(self._num_hits_per_unit_per_hit_zone)
		table.clear(self._num_hits_per_unit)

		local unit_damage_data = self._unit_damage_data

		for i = 1, MAX_NUM_HITS_UNITS do
			table.clear(unit_damage_data[i])
		end

		table.clear(self._unit_to_damage_data_index)

		self._num_unit_damage_index = 0
		local hit_all_pellets = num_pellets_total <= number_of_pellets_hit
		local action_component = self._action_component
		local player_unit = self._player_unit
		local attacker_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local param_table = attacker_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.attacking_unit = player_unit
			param_table.num_shots_fired = action_component.num_shots_fired
			param_table.combo_count = self._combo_count
			param_table.num_hit_units = number_of_units_hit
			param_table.hit_all_pellets = hit_all_pellets

			attacker_buff_extension:add_proc_event(proc_events.on_shoot, param_table)
		end
	end

	self._action_shoot_pellets_component.num_pellets_fired = num_pellets_fired
	self._number_of_pellets_hit = number_of_pellets_hit
end

local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4
local counted_units = {}

ActionShootPellets._save_pellet_hits = function (self, hit_results, position, direction, max_distance, charge_level)
	local saved_pellet_hits = self._saved_pellet_hits
	local num_saved_pellets = self._num_saved_pellets + 1
	local pellet_hits = saved_pellet_hits[num_saved_pellets]
	local pellet_hit = false
	self._num_saved_pellets = num_saved_pellets

	table.clear(counted_units)

	local num_hits = 0
	local num_hit_results = #hit_results

	for i = 1, num_hit_results do
		local hit = hit_results[i]
		local hit_position = hit[INDEX_POSITION]
		local hit_normal = hit[INDEX_NORMAL]
		local hit_distance = hit[INDEX_DISTANCE]
		local hit_actor = hit[INDEX_ACTOR]
		local hit_unit = Actor.unit(hit_actor)
		local hit_zone_name = HitZone.get_name(hit_unit, hit_actor) or "center_mass"

		if hit_unit ~= self._player_unit then
			num_hits = num_hits + 1
			local hit_entry = pellet_hits.hit_results[num_hits]

			hit_entry.actor:store(hit_actor)

			hit_entry.hit_zone_name = hit_zone_name

			hit_entry.position:store(hit_position)
			hit_entry.normal:store(hit_normal)

			hit_entry.distance = hit_distance
			local has_health = ScriptUnit.has_extension(hit_unit, "health_system")

			if has_health and not counted_units[hit_unit] and hit_zone_name ~= HitZone.hit_zone_names.afro then
				if not self._num_hits_per_unit_per_hit_zone[hit_unit] then
					self._num_hits_per_unit_per_hit_zone[hit_unit] = {}
				end

				self._num_hits_per_unit_per_hit_zone[hit_unit][hit_zone_name] = (self._num_hits_per_unit_per_hit_zone[hit_unit][hit_zone_name] or 0) + 1
				self._num_hits_per_unit[hit_unit] = (self._num_hits_per_unit[hit_unit] or 0) + 1
				counted_units[hit_unit] = true
				pellet_hit = true
			end
		end
	end

	pellet_hits.num_hits = num_hits
	pellet_hits.max_distance = max_distance
	pellet_hits.charge_level = charge_level

	pellet_hits.fire_position:store(position)
	pellet_hits.direction:store(direction)

	return pellet_hit
end

local unit_to_index_lookup = {
	penetration_entry = {},
	penetration_exit = {},
	stop = {}
}

ActionShootPellets._process_hits = function (self, power_level, t)
	local is_server = self._is_server
	local player_unit = self._player_unit
	local world = self._world
	local physics_world = self._physics_world
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration
	local shotshell_template = _shotshell_template(fire_config, self._inventory_slot_component)
	local damage_config = shotshell_template.damage
	local weapon_item = self._weapon.item
	local wielded_slot = self._inventory_component.wielded_slot
	local impact_config = damage_config.impact
	local penetration_config = damage_config.penetration
	local damage_profile = damage_config.impact.damage_profile
	local damage_type = fire_config.damage_type
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit)
	local is_critical_strike = self._critical_strike_component.is_active
	local saved_pellet_hits = self._saved_pellet_hits
	local num_saved_pellets = self._num_saved_pellets
	local hit_weakspot = false
	local killing_blow = false
	local hit_minion = false
	local surface_impact_data = self._surface_impact_data
	local surface_impact_num_hits_per_unit = self._surface_impact_num_hits_per_unit
	local penetration_entry_effects = surface_impact_data.penetration_entry
	local penetration_exit_effects = surface_impact_data.penetration_exit
	local stop_effects = surface_impact_data.stop
	local entry_effect_index = 0
	local exit_effect_index = 0
	local stop_effect_index = 0

	table.clear(self._suppressed_hits_per_unit)
	table.clear(self._suppressed_hit_positions_per_unit)
	table.clear(self._num_impact_fx_per_unit)
	table.clear(unit_to_index_lookup.penetration_entry)
	table.clear(unit_to_index_lookup.penetration_exit)
	table.clear(unit_to_index_lookup.stop)
	table.clear(surface_impact_num_hits_per_unit.penetration_entry)
	table.clear(surface_impact_num_hits_per_unit.penetration_exit)
	table.clear(surface_impact_num_hits_per_unit.stop)

	local scaled_power_levels, number_of_units_hit = self:_scale_power_level_with_num_hits(shotshell_template, power_level)

	for i = 1, num_saved_pellets do
		table.clear(self._hit_units)

		local pellet_hits = saved_pellet_hits[i]
		local num_hits = pellet_hits.num_hits
		local direction = pellet_hits.direction:unbox()
		local hit_results = pellet_hits.hit_results
		local charge_level = pellet_hits.charge_level
		local position = pellet_hits.fire_position:unbox()
		local hit_mass_budget_attack, hit_mass_budget_impact = DamageProfile.max_hit_mass(damage_profile, power_level, charge_level, damage_profile_lerp_values, is_critical_strike, player_unit)
		local target_index = 0
		local exit_distance = 0
		local penetrated = false
		local try_penetration = not impact_config.destroy_on_impact and penetration_config
		local exploded = false
		local num_impact_fx = 0
		local can_play_impact_fx = nil
		local stop = false

		for index = 1, num_hits do
			repeat
				local num_unit_damage_index = self._num_unit_damage_index

				if MAX_NUM_HITS_UNITS <= num_unit_damage_index then
					break
				end

				local hit = hit_results[index]
				local hit_position = hit.position:unbox()
				local hit_distance = hit.distance
				local hit_normal = hit.normal:unbox()
				local hit_actor = hit.actor:unbox()

				if not hit_actor then
					break
				end

				local hit_unit = Actor.unit(hit_actor)

				if self._hit_units[hit_unit] then
					break
				end

				local target_breed_or_nil = Breed.unit_breed_or_nil(hit_unit)

				if not HitScan.inside_faded_player(target_breed_or_nil, hit_distance) then
					break
				end

				local entry_hit_index = surface_impact_num_hits_per_unit.penetration_entry[hit_unit] or 0
				local exit_hit_index = surface_impact_num_hits_per_unit.penetration_exit[hit_unit] or 0
				local stop_hit_index = surface_impact_num_hits_per_unit.stop[hit_unit] or 0

				if hit_distance < exit_distance then
					break
				end

				local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
				local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro
				local is_damagable = Health.is_damagable(hit_unit)

				if Health.is_ragdolled(hit_unit) then
					if hit_afro then
						break
					end

					MinionDeath.attack_ragdoll(hit_unit, direction, damage_profile, damage_type, hit_zone_name_or_nil, hit_position, player_unit, hit_actor, nil, is_critical_strike)
				elseif is_damagable then
					if self._is_server and HEALTH_ALIVE[hit_unit] then
						local suppressed_hits_per_unit = self._suppressed_hits_per_unit[hit_unit] or 0
						self._suppressed_hits_per_unit[hit_unit] = suppressed_hits_per_unit + 1
						local suppressed_hit_positions_per_unit = self._suppressed_hit_positions_per_unit[hit_unit] or Vector3.zero()
						self._suppressed_hit_positions_per_unit[hit_unit] = suppressed_hit_positions_per_unit + hit_position
					end

					if hit_afro then
						break
					end

					local unit_damage_data = self._unit_damage_data
					local unit_to_damage_data_index = self._unit_to_damage_data_index

					if not unit_to_damage_data_index[hit_unit] then
						target_index = RangedAction.target_index(target_index, penetrated, penetration_config)
						hit_mass_budget_attack, hit_mass_budget_impact = HitMass.consume_hit_mass(player_unit, hit_unit, hit_mass_budget_attack, hit_mass_budget_impact, false)
						stop = HitMass.stopped_attack(hit_unit, hit_zone_name_or_nil, hit_mass_budget_attack, hit_mass_budget_impact, impact_config)
						local instakill = false
						local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(hit_unit)
						local deal_damage = not target_is_hazard_prop or target_is_hazard_prop and hazard_prop_is_active
						local total_damage_dealt = 0
						local best_attack_result, best_damage_efficiency = nil

						if deal_damage then
							local hit_zone_power_levels = scaled_power_levels[hit_unit]

							for hit_zone_name, hit_zone_power_level in pairs(hit_zone_power_levels) do
								local previous_hit_weakspot = hit_weakspot
								local damage_dealt, attack_result, damage_efficiency, hit_weakspot = RangedAction.execute_attack(target_index, player_unit, hit_unit, hit_actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name, damage_profile, damage_profile_lerp_values, hit_zone_power_level, charge_level, penetrated, damage_config, instakill, damage_type, is_critical_strike, weapon_item)
								total_damage_dealt = total_damage_dealt + damage_dealt
								best_attack_result = attack_result
								best_damage_efficiency = damage_efficiency
								hit_weakspot = previous_hit_weakspot or hit_weakspot
								killing_blow = killing_blow or attack_result == AttackSettings.attack_results.died
								local breed_is_minion = Breed.is_minion(target_breed_or_nil)
								local breed_is_living_prop = Breed.is_living_prop(target_breed_or_nil)
								hit_minion = hit_minion or breed_is_minion or breed_is_living_prop
							end
						end

						if Breed.is_character(target_breed_or_nil) or Breed.count_as_character(target_breed_or_nil) then
							exploded = exploded or RangedAction.armor_explosion(is_server, world, physics_world, self._player_unit, hit_unit, hit_zone_name_or_nil, hit_position, hit_normal, hit_distance, direction, damage_config, power_level, charge_level, weapon_item)
							exploded = exploded or RangedAction.hitmass_explosion(self._is_server, world, physics_world, hit_mass_budget_attack, hit_mass_budget_impact, self._player_unit, hit_unit, hit_position, hit_normal, hit_distance, direction, damage_config, best_attack_result, power_level, charge_level, weapon_item)
						end

						num_unit_damage_index = num_unit_damage_index + 1
						unit_to_damage_data_index[hit_unit] = num_unit_damage_index
						unit_damage_data[num_unit_damage_index].damage_dealt = total_damage_dealt
						unit_damage_data[num_unit_damage_index].attack_result = best_attack_result
						unit_damage_data[num_unit_damage_index].stopped = stop
						unit_damage_data[num_unit_damage_index].damage_efficiency = best_damage_efficiency
						self._num_unit_damage_index = num_unit_damage_index
					end

					if unit_to_damage_data_index[hit_unit] then
						local impact_damage_dealt = unit_damage_data[num_unit_damage_index].damage_dealt
						local impact_attack_result = unit_damage_data[num_unit_damage_index].attack_result
						local impact_damage_efficiency = unit_damage_data[num_unit_damage_index].damage_efficiency
						stop = stop or unit_damage_data[num_unit_damage_index].stopped

						if Breed.is_character(target_breed_or_nil) or Breed.count_as_character(target_breed_or_nil) then
							can_play_impact_fx, num_impact_fx = self:_can_play_impact_fx(hit_unit, num_impact_fx)

							if can_play_impact_fx then
								ImpactEffect.play(hit_unit, hit_actor, impact_damage_dealt, damage_type, hit_zone_name_or_nil, impact_attack_result, hit_position, hit_normal, direction, player_unit, IMPACT_FX_DATA, stop, attack_types.ranged, impact_damage_efficiency, damage_profile)
							end
						else
							can_play_impact_fx, num_impact_fx = self:_can_play_impact_fx(hit_unit, num_impact_fx, 30)

							if can_play_impact_fx then
								if not unit_to_index_lookup.stop[hit_unit] then
									stop_effect_index = stop_effect_index + 1
									unit_to_index_lookup.stop[hit_unit] = stop_effect_index
								end

								local stop_unit_index = unit_to_index_lookup.stop[hit_unit]
								stop_hit_index = stop_hit_index + 1

								ImpactEffect.save_surface_effect(stop_effects, stop_unit_index, stop_hit_index, position, hit_unit, hit_actor, hit_position, hit_normal)
							end
						end
					end
				elseif try_penetration and not penetrated then
					local exit_position, exit_normal, _ = ObjectPenetration.test_for_penetration(physics_world, hit_position, direction, penetration_config.depth)

					if exit_position then
						try_penetration = false
						penetrated = true
						local object_thickness = Vector3.distance(hit_position, exit_position)
						exit_distance = hit_distance + object_thickness

						if penetration_config.exit_explosion_template and is_server then
							local attack_type = attack_types.explosion

							Explosion.create_explosion(world, physics_world, exit_position, exit_normal, player_unit, penetration_config.exit_explosion_template, power_level, charge_level, attack_type, false, false, weapon_item, wielded_slot)

							exploded = true
						end

						can_play_impact_fx, num_impact_fx = self:_can_play_impact_fx(hit_unit, num_impact_fx)

						if can_play_impact_fx then
							if not unit_to_index_lookup.penetration_entry[hit_unit] then
								entry_effect_index = entry_effect_index + 1
								unit_to_index_lookup.penetration_entry[hit_unit] = entry_effect_index
							end

							if not unit_to_index_lookup.penetration_exit[hit_unit] then
								exit_effect_index = exit_effect_index + 1
								unit_to_index_lookup.penetration_exit[hit_unit] = exit_effect_index
							end

							local entry_unit_index = unit_to_index_lookup.penetration_entry[hit_unit]
							local exit_unit_index = unit_to_index_lookup.penetration_exit[hit_unit]
							entry_effect_index = (unit_to_index_lookup.penetration_entry[hit_unit] or 0) + 1
							exit_effect_index = (unit_to_index_lookup.penetration_exit[hit_unit] or 0) + 1
							entry_hit_index = entry_hit_index + 1
							exit_hit_index = exit_hit_index + 1

							ImpactEffect.save_surface_effect(penetration_entry_effects, entry_unit_index, entry_hit_index, position, hit_unit, hit_actor, hit_position, hit_normal)
							ImpactEffect.save_surface_effect(penetration_exit_effects, exit_unit_index, exit_hit_index, position, hit_unit, hit_actor, exit_position, exit_normal)
						end
					end

					if not exit_position or penetration_config.destroy_on_exit then
						stop = true
						can_play_impact_fx, num_impact_fx = self:_can_play_impact_fx(hit_unit, num_impact_fx)

						if can_play_impact_fx then
							if not unit_to_index_lookup.stop[hit_unit] then
								stop_effect_index = stop_effect_index + 1
								unit_to_index_lookup.stop[hit_unit] = stop_effect_index
							end

							local stop_unit_index = unit_to_index_lookup.stop[hit_unit]
							stop_hit_index = stop_hit_index + 1

							ImpactEffect.save_surface_effect(stop_effects, stop_unit_index, stop_hit_index, hit_unit, hit_actor, hit_position, hit_normal, direction)
						end
					end

					if not exit_position and penetration_config.stop_explosion_template and is_server then
						local attack_type = attack_types.explosion

						Explosion.create_explosion(world, physics_world, hit_position, hit_normal, player_unit, penetration_config.stop_explosion_template, power_level, charge_level, attack_type, false, false, weapon_item, wielded_slot)

						exploded = true
					end
				else
					if penetrated and penetration_config.stop_explosion_template and is_server then
						local attack_type = attack_types.explosion

						Explosion.create_explosion(world, physics_world, hit_position, hit_normal, player_unit, penetration_config.stop_explosion_template, power_level, charge_level, attack_type, false, false, weapon_item, wielded_slot)

						exploded = true
					end

					stop = true
					can_play_impact_fx, num_impact_fx = self:_can_play_impact_fx(hit_unit, num_impact_fx, 30)

					if can_play_impact_fx then
						if not unit_to_index_lookup.stop[hit_unit] then
							stop_effect_index = stop_effect_index + 1
							unit_to_index_lookup.stop[hit_unit] = stop_effect_index
						end

						local stop_unit_index = unit_to_index_lookup.stop[hit_unit]
						stop_hit_index = stop_hit_index + 1

						ImpactEffect.save_surface_effect(stop_effects, stop_unit_index, stop_hit_index, position, hit_unit, hit_actor, hit_position, hit_normal)
					end
				end

				if (stop or penetrated) and impact_config.explosion_template and is_server then
					local attack_type = attack_types.explosion

					Explosion.create_explosion(world, physics_world, hit_position, hit_normal, player_unit, penetration_config.stop_explosion_template, power_level, charge_level, attack_type, false, false, weapon_item, wielded_slot)

					exploded = true
				end

				if stop and hit_position then
					local fx_settings = action_settings.fx
					local line_effect = fx_settings and fx_settings.line_effect

					self:_play_line_fx(line_effect, position, hit_position)
				end

				self._hit_units[hit_unit] = true
				surface_impact_num_hits_per_unit.penetration_entry[hit_unit] = entry_hit_index
				surface_impact_num_hits_per_unit.penetration_exit[hit_unit] = exit_hit_index
				surface_impact_num_hits_per_unit.stop[hit_unit] = stop_hit_index
			until true

			if stop then
				break
			end
		end
	end

	for unit, num_hits in pairs(self._suppressed_hits_per_unit) do
		local hit_positions_added = self._suppressed_hit_positions_per_unit[unit]
		local average_hit_position = hit_positions_added / num_hits

		Suppression.apply_suppression(unit, player_unit, damage_profile, average_hit_position, nil, num_hits)
	end

	ImpactEffect.play_shotshell_surface_effect(physics_world, player_unit, unit_to_index_lookup.penetration_entry, surface_impact_num_hits_per_unit.penetration_entry, surface_impact_data.penetration_entry, damage_type, hit_types.stop, IMPACT_FX_DATA)
	ImpactEffect.play_shotshell_surface_effect(physics_world, player_unit, unit_to_index_lookup.penetration_exit, surface_impact_num_hits_per_unit.penetration_exit, surface_impact_data.penetration_exit, damage_type, hit_types.stop, IMPACT_FX_DATA)
	ImpactEffect.play_shotshell_surface_effect(physics_world, player_unit, unit_to_index_lookup.stop, surface_impact_num_hits_per_unit.stop, surface_impact_data.stop, damage_type, hit_types.stop, IMPACT_FX_DATA)

	self._num_saved_pellets = 0
	self._shot_result.data_valid = true
	self._shot_result.hit_minion = hit_minion
	self._shot_result.hit_weakspot = hit_weakspot
	self._shot_result.killing_blow = killing_blow

	return number_of_units_hit
end

ActionShootPellets._can_play_impact_fx = function (self, hit_unit, num_impact_fx, max_hits_per_unit)
	local num_fx_per_unit = self._num_impact_fx_per_unit[hit_unit]

	if (not num_fx_per_unit or num_fx_per_unit < (max_hits_per_unit or 4)) and num_impact_fx < 1 then
		self._num_impact_fx_per_unit[hit_unit] = num_fx_per_unit and num_fx_per_unit + 1 or 1

		return true, num_impact_fx + 1
	end

	return false, num_impact_fx
end

ActionShootPellets.server_correction_occurred = function (self)
	table.clear(self._hit_units)
	table.clear(self._suppressed_hits_per_unit)
	table.clear(self._suppressed_hit_positions_per_unit)
	table.clear(self._num_hits_per_unit_per_hit_zone)
	table.clear(self._num_hits_per_unit)

	local unit_damage_data = self._unit_damage_data

	for i = 1, MAX_NUM_HITS_UNITS do
		table.clear(unit_damage_data[i])
	end

	table.clear(self._unit_to_damage_data_index)

	self._num_unit_damage_index = 0
	self._num_saved_pellets = 0
	self._number_of_pellets_hit = 0
end

ActionShootPellets._next_fire_state = function (self, dt, t)
	local action_component = self._action_component
	local action_settings = self._action_settings
	local weapon_handling_template = self._weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local fire_rate_settings = weapon_handling_template.fire_rate or EMPTY_TABLE
	local max_num_shots = fire_rate_settings.max_shots or math.huge
	local auto_fire_timing = fire_rate_settings.auto_fire_time
	local num_pellets_fired = self._action_shoot_pellets_component.num_pellets_fired
	local fire_config = action_settings.fire_configuration
	local shotshell_template = _shotshell_template(fire_config, self._inventory_slot_component)
	local num_pellets_total = shotshell_template.num_pellets

	if num_pellets_fired < num_pellets_total then
		return "shooting"
	elseif max_num_shots <= action_component.num_shots_fired then
		self:_set_weapon_special(false, t)

		return "shot"
	elseif auto_fire_timing then
		action_component.fire_at_time = t + auto_fire_timing

		return "waiting_to_shoot"
	else
		self:_set_weapon_special(false, t)

		return "shot"
	end
end

ActionShootPellets._prepare_shooting = function (self, ...)
	ActionShootPellets.super._prepare_shooting(self, ...)

	self._action_shoot_pellets_component.num_pellets_fired = 0
	self._number_of_pellets_hit = 0
end

local power_levels = {}

ActionShootPellets._scale_power_level_with_num_hits = function (self, shotshell_template, power_level)
	table.clear(power_levels)

	local num_hits_per_unit_per_hit_zone = self._num_hits_per_unit_per_hit_zone
	local num_hits_per_unit = self._num_hits_per_unit
	local max_hits = shotshell_template.num_pellets
	local number_of_units_hit = 0

	for hit_unit, hit_zones in pairs(num_hits_per_unit_per_hit_zone) do
		power_levels[hit_unit] = {}
		local num_unit_hits = num_hits_per_unit[hit_unit]
		local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local breed_or_nil = unit_data_extension and unit_data_extension:breed()
		local breed_armor_type = Armor.armor_type(hit_unit, breed_or_nil)
		local min_num_hits = breed_armor_type and shotshell_template.min_num_hits[breed_armor_type] or 0
		local adjusted_num_unit_hits = math.max(min_num_hits, num_unit_hits)
		local unit_power_level = power_level * adjusted_num_unit_hits / max_hits

		for hit_zone_name, hit_zone_hits in pairs(hit_zones) do
			local ratio_of_total_hits = hit_zone_hits / num_unit_hits
			local final_power_level = unit_power_level * ratio_of_total_hits
			power_levels[hit_unit][hit_zone_name] = final_power_level
		end

		number_of_units_hit = number_of_units_hit + 1
	end

	return power_levels, number_of_units_hit
end

function _shotshell_template(fire_config, inventory_slot_component)
	local shotshell_template = fire_config.shotshell
	local shotshell_special_template = fire_config.shotshell_special
	local special_active = inventory_slot_component.special_active

	if special_active and shotshell_special_template then
		shotshell_template = shotshell_special_template
	end

	return shotshell_template
end

return ActionShootPellets
