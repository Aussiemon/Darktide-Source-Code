local Breeds = require("scripts/settings/breed/breeds")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local SpecialsPacing = class("SpecialsPacing")
local aggro_states = PerceptionSettings.aggro_states

SpecialsPacing.init = function (self, nav_world)
	self._nav_world = nav_world
	self._fx_system = Managers.state.extension:system("fx_system")
	self._timer_modifier = 1
	self._rush_prevention_cooldown = 0
	self._frozen = false
end

SpecialsPacing.on_spawn_points_generated = function (self, template)
	local first_spawn_timer_modifer = template.first_spawn_timer_modifer

	self:_setup(template, first_spawn_timer_modifer)

	local main_path_manager = Managers.state.main_path
	local nav_spawn_points = main_path_manager:nav_spawn_points()

	if nav_spawn_points then
		local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
		self._num_spawn_point_groups = num_groups
		self._nav_spawn_points = nav_spawn_points
	else
		self._disabled = true
	end

	self._destroy_special_distance_sq = template.destroy_special_distance^2
end

local function _setup_specials_slot(specials_slot, template, timer_modifier, optional_breed_name, optional_spawn_timer, optional_injected, optional_coordinated_strike, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group)
	local breed_name = optional_breed_name

	if optional_breed_name == nil then
		local breeds = optional_coordinated_strike and template.coordinated_strike_breeds or template.breeds.all
		breed_name = breeds[math.random(1, #breeds)]
	end

	specials_slot.breed_name = breed_name
	local spawn_timer = optional_spawn_timer

	if optional_spawn_timer == nil then
		local spawn_timer_range = template.timer_range
		spawn_timer = math.random_range(spawn_timer_range[1], spawn_timer_range[2])
	end

	spawn_timer = spawn_timer * timer_modifier
	specials_slot.spawn_timer = spawn_timer
	local prefered_spawn_direction = optional_prefered_spawn_direction or template.optional_prefered_spawn_direction and template.optional_prefered_spawn_direction[breed_name]
	specials_slot.optional_prefered_spawn_direction = prefered_spawn_direction
	local optional_mainpath_offset = template.optional_mainpath_offset
	specials_slot.optional_mainpath_offset = optional_mainpath_offset and optional_mainpath_offset[breed_name]
	local foreshadow_stinger = template.foreshadow_stingers[breed_name]
	local foreshadow_stinger_timer = template.foreshadow_stinger_timers[breed_name]

	if foreshadow_stinger and foreshadow_stinger_timer then
		specials_slot.foreshadow_stinger = foreshadow_stinger
		specials_slot.foreshadow_stinger_timer = spawn_timer - foreshadow_stinger_timer
	else
		specials_slot.foreshadow_stinger = nil
		specials_slot.foreshadow_stinger_timer = nil
	end

	specials_slot.foreshadow_triggered = false
	specials_slot.alone_target_override = false
	specials_slot.coordinated_strike = optional_coordinated_strike
	specials_slot.target_unit = optional_target_unit
	specials_slot.injected = optional_injected
	specials_slot.next_stuck_check_t = 0
	specials_slot.spawner_group = optional_spawner_group
	specials_slot.spawner_queue_id = nil
	specials_slot.spawner = nil
end

SpecialsPacing._setup = function (self, template, optional_first_spawn_modifier)
	self._template = template
	local max_alive_specials = template.max_alive_specials
	local specials_slots = Script.new_array(max_alive_specials)
	self._num_spawned_specials = 0
	self._max_alive_specials = max_alive_specials

	for i = 1, max_alive_specials do
		local specials_slot = {}

		_setup_specials_slot(specials_slot, template, optional_first_spawn_modifier or self._timer_modifier)

		specials_slots[i] = specials_slot
	end

	self._specials_slots = specials_slots
end

SpecialsPacing.switch_template = function (self, new_template)
	self:_setup(new_template)
end

SpecialsPacing.set_timer_modifier = function (self, modifier)
	self._timer_modifier = modifier
end

SpecialsPacing.update = function (self, dt, t, side_id, target_side_id)
	if self._disabled then
		return
	end

	Profiler.start("specials_pacing_update_specials")

	local specials_allowed = Managers.state.pacing:spawn_type_enabled("specials") and not self._frozen
	local specials_slots = self._specials_slots
	local max_alive_specials = self._max_alive_specials
	local template = self._template

	for i = 1, max_alive_specials do
		local specials_slot = specials_slots[i]

		if specials_slot.spawned then
			local unit = specials_slot.spawned_unit

			if HEALTH_ALIVE[unit] then
				if specials_slot.next_stuck_check_t <= t then
					Profiler.start("check_stuck_special")
					self:_check_stuck_special(unit, specials_slot, template, target_side_id, t)
					Profiler.stop("check_stuck_special")
				end
			else
				self._num_spawned_specials = self._num_spawned_specials - 1
				specials_slot.spawned_unit = nil
				specials_slot.spawned = false
				local activated_coordinated_strike = self:_check_and_activate_coordinated_strike(template, specials_slot)

				if not activated_coordinated_strike then
					_setup_specials_slot(specials_slot, template, self._timer_modifier)
				end
			end
		elseif specials_slot.spawner_queue_id then
			local spawner_queue_id = specials_slot.spawner_queue_id
			local spawner = specials_slot.spawner

			if not spawner:is_spawning() then
				local spawned_minions_by_queue_id = spawner:spawned_minions_by_queue_id(spawner_queue_id)
				local spawned_unit = spawned_minions_by_queue_id[1]

				self:_on_special_spawned(specials_slot, spawned_unit)
			end
		elseif specials_slot.spawn_timer <= 0 then
			self:_check_alone_target_override(template, target_side_id, specials_slot)

			local success, spawned_unit, spawner_queue_id, spawner = self:_spawn_special(specials_slot, side_id, target_side_id)

			if success then
				if spawner_queue_id then
					specials_slot.spawner_queue_id = spawner_queue_id
					specials_slot.spawner = spawner
				else
					self:_on_special_spawned(specials_slot, spawned_unit)
				end
			else
				local spawn_failed_wait_time = template.spawn_failed_wait_time
				local spawn_timer = spawn_failed_wait_time
				specials_slot.spawn_timer = spawn_timer
			end
		else
			local foreshadow_stinger = specials_slot.foreshadow_stinger
			local foreshadow_stinger_available = foreshadow_stinger and not specials_slot.foreshadow_triggered
			local can_update_foreshadow_stinger_timer = foreshadow_stinger_available and (specials_allowed or specials_slot.injected)

			if can_update_foreshadow_stinger_timer then
				specials_slot.foreshadow_stinger_timer = math.max(specials_slot.foreshadow_stinger_timer - dt, 0)

				if specials_slot.foreshadow_stinger_timer <= 0 then
					local alone_target_override = self:_check_alone_target_override(template, target_side_id, specials_slot)

					if not alone_target_override then
						local _, _, path_position = Managers.state.main_path:ahead_unit(target_side_id)

						if path_position then
							self._fx_system:trigger_wwise_event(foreshadow_stinger, path_position)

							specials_slot.foreshadow_triggered = true
						end
					end
				end
			end

			local can_update_spawn_timer = specials_allowed or specials_slot.foreshadow_triggered or specials_slot.injected

			if can_update_spawn_timer then
				specials_slot.spawn_timer = specials_slot.spawn_timer - dt
			end
		end
	end

	Profiler.stop("specials_pacing_update_specials")

	if specials_allowed then
		Profiler.start("specials_pacing_update_rush_prevention")
		self:_update_rush_prevention(side_id, target_side_id, template, t)
		Profiler.stop("specials_pacing_update_rush_prevention")
	end
end

SpecialsPacing._spawn_special = function (self, specials_slot, side_id, target_side_id)
	local breed_name = specials_slot.breed_name
	local optional_prefered_spawn_direction = specials_slot.optional_prefered_spawn_direction
	local optional_mainpath_offset = specials_slot.optional_mainpath_offset
	local prefered_ahead_override = optional_prefered_spawn_direction and optional_prefered_spawn_direction == "ahead"
	local prefered_behind_override = optional_prefered_spawn_direction and optional_prefered_spawn_direction == "behind"
	local check_ahead = nil

	if prefered_ahead_override ~= nil or prefered_behind_override ~= nil then
		check_ahead = prefered_ahead_override or not prefered_behind_override
	else
		check_ahead = math.random() > 0.5
	end

	local spawner_group = specials_slot.spawner_group

	if spawner_group then
		local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
		local spawners = minion_spawn_system:spawners_in_group(spawner_group)
		local spawner = spawners[math.random(1, #spawners)]
		local spawner_queue_id = self:_add_spawner_special(spawner, breed_name, side_id, target_side_id)

		return true, nil, spawner_queue_id, spawner
	end

	local spawn_position, closest_target_unit = self:_find_spawn_position(side_id, breed_name, target_side_id, check_ahead, optional_mainpath_offset)

	if not spawn_position then
		spawn_position, closest_target_unit = self:_find_spawn_position(side_id, breed_name, target_side_id, not check_ahead)

		if not spawn_position then
			local nearby_spawner = self:_find_nearby_spawner(target_side_id)

			if nearby_spawner then
				local spawner_queue_id = self:_add_spawner_special(nearby_spawner, breed_name, side_id, target_side_id)

				return true, nil, spawner_queue_id, nearby_spawner
			else
				return false
			end
		end
	end

	local slot_target_unit = specials_slot.target_unit
	local target_unit = ALIVE[slot_target_unit] and slot_target_unit or closest_target_unit
	local unit = Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, aggro_states.aggroed, target_unit, nil, nil, nil, nil)

	return true, unit
end

SpecialsPacing._on_special_spawned = function (self, specials_slot, spawned_unit)
	self._num_spawned_specials = self._num_spawned_specials + 1
	specials_slot.spawned_unit = spawned_unit
	specials_slot.spawned = true
	local breed_name = specials_slot.breed_name
	local spawn_stinger = self._template.spawn_stingers[breed_name]

	if spawn_stinger then
		self._fx_system:trigger_wwise_event(spawn_stinger, nil, spawned_unit)
	end
end

local ABOVE = 1
local BELOW = 1.5
local LATERAL = 1

SpecialsPacing._find_spawn_position = function (self, side_id, breed_name, target_side_id, check_ahead, optional_mainpath_offset)
	local main_path_manager = Managers.state.main_path
	local target_unit, travel_distance = nil

	if check_ahead then
		target_unit, travel_distance = main_path_manager:ahead_unit(target_side_id)
	else
		target_unit, travel_distance = main_path_manager:behind_unit(target_side_id)
	end

	if not target_unit then
		return
	end

	local nav_world = self._nav_world
	local target_position = POSITION_LOOKUP[target_unit]
	local navmesh_position = nil

	if optional_mainpath_offset then
		navmesh_position = MainPathQueries.position_from_distance(travel_distance + optional_mainpath_offset)
	else
		navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, target_position, ABOVE, BELOW, LATERAL)
	end

	if not navmesh_position then
		if check_ahead then
			target_unit = main_path_manager:behind_unit(target_side_id)
		else
			target_unit = main_path_manager:ahead_unit(target_side_id)
		end

		navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, POSITION_LOOKUP[target_unit], ABOVE, BELOW, LATERAL)

		if not navmesh_position then
			return
		end
	end

	local nav_spawn_points = self._nav_spawn_points
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(side_id)
	local template = self._template
	local max_spawn_group_offset_range = template.max_spawn_group_offset_range
	local num_spawn_point_groups = self._num_spawn_point_groups
	local min_distance_from_target = template.min_distances_from_target[breed_name]
	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, navmesh_position, side, max_spawn_group_offset_range, num_spawn_point_groups, min_distance_from_target)

	if not random_occluded_position then
		return
	end

	return random_occluded_position, target_unit
end

SpecialsPacing._find_nearby_spawner = function (self, target_side_id)
	local main_path_manager = Managers.state.main_path
	local target_unit = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return
	end

	local template = self._template
	local spawners_min_range = template.spawners_min_range
	local spawners_max_range = template.spawners_max_range
	local pos = POSITION_LOOKUP[target_unit]
	local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
	local nearby_spawners = minion_spawn_system:spawners_in_range(pos, spawners_max_range)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local nearby_valid_spawner = nil

	for i = 1, #nearby_spawners do
		local spawner = nearby_spawners[i]
		local spawner_position = spawner:position()
		local is_valid_spawner = true

		for j = 1, num_target_units do
			local player_unit = target_units[j]
			local player_position = POSITION_LOOKUP[player_unit]
			local distance = Vector3.distance(spawner_position, player_position)

			if distance < spawners_min_range then
				is_valid_spawner = false

				break
			end
		end

		if is_valid_spawner then
			nearby_valid_spawner = spawner

			break
		end
	end

	return nearby_valid_spawner
end

SpecialsPacing._add_spawner_special = function (self, spawner, breed_name, side_id, target_side_id)
	local spawner_queue_id = spawner:add_spawns({
		breed_name
	}, side_id, target_side_id)

	return spawner_queue_id, spawner
end

local NUM_FAILED_MOVE_TO_DESPAWN = 8
local STUCK_CHECK_FREQUENCY = 0.5

SpecialsPacing._check_stuck_special = function (self, unit, specials_slot, template, target_side_id, t)
	specials_slot.next_stuck_check_t = t + STUCK_CHECK_FREQUENCY
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance, ahead_position = main_path_manager:ahead_unit(target_side_id)
	local _, behind_travel_distance, behind_position = main_path_manager:behind_unit(target_side_id)

	if ahead_position and behind_position then
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local failed_move_attempts = navigation_extension:failed_move_attempts()

		if NUM_FAILED_MOVE_TO_DESPAWN < failed_move_attempts then
			Managers.state.minion_spawn:despawn(unit)

			return
		end

		local destroy_special_distance_sq = self._destroy_special_distance_sq
		local special_position = POSITION_LOOKUP[unit]
		local nav_world = self._nav_world
		local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, special_position, ABOVE, BELOW, LATERAL)

		if not navmesh_position then
			return
		end

		local spawn_point_group_index = SpawnPointQueries.group_from_position(nav_world, self._nav_spawn_points, navmesh_position)
		local start_index = Managers.state.main_path:node_index_by_nav_group_index(spawn_point_group_index or 1)
		local end_index = start_index + 1
		local _, enemy_travel_distance, _, _, _ = MainPathQueries.closest_position_between_nodes(navmesh_position, start_index, end_index)

		if enemy_travel_distance < ahead_travel_distance and behind_travel_distance < enemy_travel_distance then
			return
		end

		local distance_ahead_sq = Vector3.distance_squared(special_position, ahead_position)
		local distance_behind_sq = Vector3.distance_squared(special_position, behind_position)

		if destroy_special_distance_sq <= distance_ahead_sq and destroy_special_distance_sq <= distance_behind_sq then
			Managers.state.minion_spawn:despawn(unit)
		end
	end
end

SpecialsPacing._check_alone_target_override = function (self, template, target_side_id, specials_slot)
	if specials_slot.alone_target_override then
		return false
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local num_non_disabled_players = 0

	for i = 1, num_target_units do
		local player_unit = target_units[i]
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not requires_help then
			num_non_disabled_players = num_non_disabled_players + 1

			if num_non_disabled_players > 1 then
				return false
			end
		end
	end

	if template.skip_disablers_when_one_target_alive then
		local breed_name = specials_slot.breed_name
		local breed = Breeds[breed_name]
		local tags = breed.tags

		if tags.disabler then
			local scrambler_breeds = template.breeds.scramblers
			local new_breed_name = scrambler_breeds[math.random(1, #scrambler_breeds)]
			specials_slot.breed_name = new_breed_name
			local foreshadow_stinger = template.foreshadow_stingers[new_breed_name]
			local foreshadow_stinger_timer = template.foreshadow_stinger_timers[new_breed_name]

			if foreshadow_stinger and foreshadow_stinger_timer then
				specials_slot.foreshadow_stinger = foreshadow_stinger
				specials_slot.foreshadow_stinger_timer = foreshadow_stinger_timer
			else
				specials_slot.foreshadow_stinger = nil
				specials_slot.foreshadow_stinger_timer = nil
			end

			specials_slot.alone_target_override = true

			Log.info("SpecialsPacing", "Replaced %s breed with %s because of alone target override", breed_name, new_breed_name)

			return true
		end
	end

	return false
end

local COORDINATED_STRIKE_TIMER_OFFSET = 3

SpecialsPacing._check_and_activate_coordinated_strike = function (self, template, current_special_slot)
	if self._num_spawned_specials > 0 or current_special_slot.coordinated_strike then
		return false
	end

	local chance_for_coordinated_strike = template.chance_for_coordinated_strike

	if not chance_for_coordinated_strike then
		return false
	end

	local random_roll = math.random()
	local should_activate_coordinated_strike = random_roll < chance_for_coordinated_strike

	if not should_activate_coordinated_strike then
		return false
	end

	local coordinated_strike_timer_range = template.coordinated_strike_timer_range
	local coordinated_strike_timer = math.random_range(coordinated_strike_timer_range[1], coordinated_strike_timer_range[2])

	Log.info("SpecialsPacing", "Coordinated strike in %.02f", coordinated_strike_timer)

	local specials_slots = self._specials_slots

	for i = 1, self._max_alive_specials do
		local specials_slot = specials_slots[i]
		local optional_coordinated_strike = true

		_setup_specials_slot(specials_slot, template, self._timer_modifier, nil, coordinated_strike_timer, nil, optional_coordinated_strike)

		coordinated_strike_timer = coordinated_strike_timer + COORDINATED_STRIKE_TIMER_OFFSET
	end

	return true
end

SpecialsPacing._update_rush_prevention = function (self, side_id, target_side_id, template, t)
	local rush_prevention_breeds = template.rush_prevention_breeds

	if not rush_prevention_breeds or t < self._rush_prevention_cooldown then
		return
	end

	if self._max_alive_specials <= self._num_spawned_specials then
		return
	end

	local ahead_unit, ahead_travel_distance = Managers.state.main_path:ahead_unit(target_side_id)

	if not ahead_unit then
		return
	end

	local behind_unit, behind_travel_distance = Managers.state.main_path:behind_unit(target_side_id)
	local nav_world = self._nav_world
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local second_ahead_distance = 0
	local second_behind_distance = math.huge

	if num_target_units == 1 then
		return
	elseif num_target_units == 2 then
		second_ahead_distance = behind_travel_distance
		second_behind_distance = ahead_travel_distance
	else
		for i = 1, num_target_units do
			local target_unit = target_units[i]

			if target_unit ~= ahead_unit and target_unit ~= behind_unit then
				local enemy_position = POSITION_LOOKUP[target_unit]
				local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, enemy_position, ABOVE, BELOW, LATERAL)

				if navmesh_position then
					local spawn_point_group_index = SpawnPointQueries.group_from_position(nav_world, self._nav_spawn_points, navmesh_position)
					local start_index = Managers.state.main_path:node_index_by_nav_group_index(spawn_point_group_index or 1)
					local end_index = start_index + 1
					local _, enemy_travel_distance, _, _, _ = MainPathQueries.closest_position_between_nodes(navmesh_position, start_index, end_index)

					if second_ahead_distance < enemy_travel_distance then
						second_ahead_distance = enemy_travel_distance
					end

					if enemy_travel_distance < second_behind_distance then
						second_behind_distance = enemy_travel_distance
					end
				end
			end
		end
	end

	if second_ahead_distance == 0 and math.huge <= second_behind_distance then
		return
	end

	local rushing_distance = template.rushing_distance
	local ahead_travel_distance_diff = math.abs(ahead_travel_distance - second_ahead_distance)
	local behind_travel_distance_diff = math.abs(behind_travel_distance - second_behind_distance)

	if rushing_distance <= ahead_travel_distance_diff then
		local rush_prevention_breed_name = rush_prevention_breeds[math.random(1, #rush_prevention_breeds)]

		Log.info("SpecialsPacing", "Trying to inject rush prevention breed ahead %s.", rush_prevention_breed_name)

		local success = self:try_inject_special(rush_prevention_breed_name, "ahead", ahead_unit)
		local cooldown = success and template.rush_prevention_cooldown or template.rush_prevention_failed_cooldown
		self._rush_prevention_cooldown = t + math.random_range(cooldown[1], cooldown[2])
	elseif rushing_distance <= behind_travel_distance_diff then
		local rush_prevention_breed_name = rush_prevention_breeds[math.random(1, #rush_prevention_breeds)]

		Log.info("SpecialsPacing", "Trying to inject rush prevention breed behind %s.", rush_prevention_breed_name)

		local success = self:try_inject_special(rush_prevention_breed_name, "behind", behind_unit)
		local cooldown = success and template.rush_prevention_cooldown or template.rush_prevention_failed_cooldown
		self._rush_prevention_cooldown = t + math.random_range(cooldown[1], cooldown[2])
	end
end

SpecialsPacing.try_inject_special = function (self, breed_name, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group)
	local specials_allowed = Managers.state.pacing:spawn_type_allowed("specials")

	if not specials_allowed then
		return false
	end

	local specials_slots = self._specials_slots
	local chosen_slot = nil

	for i = 1, self._max_alive_specials do
		local specials_slot = specials_slots[i]

		if not specials_slot.spawned and not specials_slot.foreshadow_triggered then
			chosen_slot = specials_slot

			break
		end
	end

	if not chosen_slot then
		Log.info("SpecialsPacing", "Couldn't find unused specials slot to inject into.")

		return false
	end

	local template = self._template
	local foreshadow_stinger_timer = template.foreshadow_stinger_timers[breed_name]
	local spawn_timer = foreshadow_stinger_timer or 0
	local injected = true

	_setup_specials_slot(chosen_slot, template, self._timer_modifier, breed_name, spawn_timer, injected, nil, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group)

	return true
end

SpecialsPacing.freeze = function (self, should_freeze)
	self._frozen = should_freeze
end

return SpecialsPacing
