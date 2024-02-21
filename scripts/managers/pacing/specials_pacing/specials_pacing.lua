local Breeds = require("scripts/settings/breed/breeds")
local HordeSettings = require("scripts/settings/horde/horde_settings")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local SpecialsPacing = class("SpecialsPacing")
local HORDE_TYPES = HordeSettings.horde_types
local aggro_states = PerceptionSettings.aggro_states

SpecialsPacing.init = function (self, nav_world)
	self._nav_world = nav_world
	self._fx_system = Managers.state.extension:system("fx_system")
	self._timer_modifier = 1
	self._timer_multiplier = 1
	self._max_alive_specials_multiplier = 1
	self._max_alive_specials_bonus = 0
	self._rush_prevention_cooldown = 0
	self._frozen = false
	self._speed_running_prevention_cooldown = 0
	self._next_speed_running_check_t = 0
	self._num_speed_running_checks = 0
	self._old_furthest_travel_distance = 0
	self._specials_slots = {}
	self._num_failed_attempts = 0
	self._num_coordinated_surges = 0
end

SpecialsPacing.on_spawn_points_generated = function (self, template)
	local first_spawn_timer_modifer = template.first_spawn_timer_modifer

	self:_setup(template, first_spawn_timer_modifer)

	self._template = template
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
	local has_move_timer_when_horde_active_mutator = Managers.state.mutator:mutator("mutator_move_specials_timer_when_horde_active")
	local has_move_timer_when_monster_active_mutator = Managers.state.mutator:mutator("mutator_move_specials_timer_when_monster_active")
	self._has_move_timer_when_horde_active_mutator = has_move_timer_when_horde_active_mutator
	self._has_move_timer_when_monster_active_mutator = has_move_timer_when_monster_active_mutator
end

local MIN_TIMER_DIFF_RANGE = {
	3,
	5
}
local USED_BREEDS = {}

SpecialsPacing._setup_specials_slot = function (self, specials_slots, specials_slot, template, timer_modifier, optional_breed_name, optional_spawn_timer, optional_injected, optional_coordinated_strike, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group, optional_is_prevention)
	local spawn_timer = optional_spawn_timer

	if optional_spawn_timer == nil then
		local spawn_timer_range = template.timer_range
		spawn_timer = math.random_range(spawn_timer_range[1], spawn_timer_range[2])
	end

	spawn_timer = spawn_timer * timer_modifier

	table.clear(USED_BREEDS)

	specials_slot.breed_name = nil

	for i = 1, #specials_slots do
		local other_special_slot = specials_slots[i]

		if not optional_spawn_timer then
			local other_special_slot_timer = other_special_slot.spawn_timer
			local min_timer_diff = math.random_range(MIN_TIMER_DIFF_RANGE[1], MIN_TIMER_DIFF_RANGE[2])

			if other_special_slot_timer and math.abs(spawn_timer - other_special_slot_timer) < min_timer_diff then
				spawn_timer = spawn_timer + min_timer_diff
			end
		end

		local other_breed_name = other_special_slot.breed_name

		if other_breed_name then
			USED_BREEDS[other_breed_name] = USED_BREEDS[other_breed_name] and USED_BREEDS[other_breed_name] + 1 or 1
		end
	end

	specials_slot.spawn_timer = spawn_timer
	local optional_health_modifier = nil
	local breed_name = optional_breed_name

	if optional_breed_name == nil then
		local breeds = optional_coordinated_strike and template.coordinated_strike_breeds or template.breeds.all
		local monster_breed_override, monster_health_modifier = self:_check_monster_override(template)
		optional_health_modifier = monster_health_modifier
		breed_name = monster_breed_override or breeds[math.random(1, #breeds)]
		local optional_max_of_same_override = self._optional_max_of_same_override
		local max_of_same = optional_max_of_same_override and optional_max_of_same_override[breed_name] or template.max_of_same[breed_name]
		local num_used_breeds = USED_BREEDS[breed_name]

		if num_used_breeds and max_of_same and max_of_same <= num_used_breeds then
			local check_breed_name = self:_get_breed_name(breed_name)
			local tags = Breeds[check_breed_name].tags
			local new_breeds = nil

			if tags.disabler then
				new_breeds = template.breeds.disablers
			elseif tags.scrambler then
				new_breeds = template.breeds.scramblers
			elseif tags.monster then
				new_breeds = template.breeds.all
			else
				new_breeds = template.breeds.all
			end

			local breeds_copy = table.clone(new_breeds)

			table.shuffle(breeds_copy)

			for i = 1, #breeds_copy do
				local other_breed_name = breeds_copy[i]

				if not USED_BREEDS[other_breed_name] or USED_BREEDS[other_breed_name] < max_of_same then
					breed_name = other_breed_name

					break
				end
			end
		end
	end

	specials_slot.breed_name = breed_name
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
	specials_slot.disabler_override = false
	specials_slot.coordinated_strike = optional_coordinated_strike
	specials_slot.target_unit = optional_target_unit
	specials_slot.injected = optional_injected
	specials_slot.next_stuck_check_t = 0
	specials_slot.spawner_group = optional_spawner_group
	specials_slot.spawner_queue_id = nil
	specials_slot.spawner = nil
	specials_slot.disabler_is_active = nil
	specials_slot.optional_is_prevention = optional_is_prevention
	specials_slot.optional_health_modifier = optional_health_modifier
end

SpecialsPacing._setup = function (self, template, optional_first_spawn_modifier)
	self._template = template
	local max_alive_specials = math.ceil(template.max_alive_specials * self._max_alive_specials_multiplier + self._max_alive_specials_bonus)
	local specials_slots = Script.new_array(max_alive_specials)
	self._num_spawned_specials = 0
	self._max_alive_specials = max_alive_specials

	for i = 1, max_alive_specials do
		local specials_slot = {}

		self:_setup_specials_slot(specials_slots, specials_slot, template, optional_first_spawn_modifier or self._timer_modifier)

		specials_slots[i] = specials_slot
	end

	self._specials_slots = specials_slots
	local num_coordinated_surges_range = template.num_coordinated_surges_range

	if num_coordinated_surges_range then
		self._num_coordinated_surges = math.random(num_coordinated_surges_range[1], num_coordinated_surges_range[2])
	end
end

SpecialsPacing.switch_template = function (self, new_template)
	self:_setup(new_template)
end

SpecialsPacing.set_timer_modifier = function (self, modifier)
	self._timer_modifier = modifier
end

SpecialsPacing.set_timer_multiplier = function (self, multiplier)
	self._timer_multiplier = multiplier
end

local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_BEHIND_MIN = 5
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_BEHIND_MAX = 15
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_FORWARD_MIN = 8
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_FORWARD_MAX = 20
local NO_MODIFIER_TIME = 10

SpecialsPacing.update = function (self, dt, t, side_id, target_side_id)
	if self._disabled then
		return
	end

	local main_path_manager = Managers.state.main_path
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local traveled_this_frame = furthest_travel_distance - self._old_furthest_travel_distance
	self._old_furthest_travel_distance = furthest_travel_distance
	local time_since_forward_travel_changed = main_path_manager:time_since_forward_travel_changed(target_side_id)
	local time_since_forward_behind_changed = main_path_manager:time_since_behind_travel_changed(target_side_id)
	local travel_distance_allowed_forward = time_since_forward_travel_changed < TRAVEL_DISTANCE_CHANGE_ALLOWANCE_FORWARD_MIN or TRAVEL_DISTANCE_CHANGE_ALLOWANCE_FORWARD_MAX < time_since_forward_travel_changed
	local travel_distance_allowed_behind = time_since_forward_behind_changed < TRAVEL_DISTANCE_CHANGE_ALLOWANCE_BEHIND_MIN or TRAVEL_DISTANCE_CHANGE_ALLOWANCE_BEHIND_MAX < time_since_forward_behind_changed
	local travel_distance_allowed = travel_distance_allowed_forward or travel_distance_allowed_behind
	local pacing_specials_enabled, reason = Managers.state.pacing:spawn_type_enabled("specials")
	local specials_allowed = travel_distance_allowed and pacing_specials_enabled and not self._frozen

	if reason and reason == "disabled_by_challenge_rating" and self._ahead_unit_has_no_units_in_coherency then
		specials_allowed = true
	end

	local ramp_up_timer_modifier = Managers.state.pacing:get_ramp_up_frequency_modifier("specials")
	local specials_slots = self._specials_slots
	local max_alive_specials = self._max_alive_specials
	local template = self._template
	local has_travel_distance_mutator = Managers.state.mutator:mutator("mutator_travel_distance_spawning_specials")
	local move_timer_when_horde_active = template.move_timer_when_horde_active or self._has_move_timer_when_horde_active_mutator
	local move_timer_when_monster_active = template.move_timer_when_monster_active or self._has_move_timer_when_monster_active_mutator
	local move_timer_when_terror_event_active = template.move_timer_when_terror_event_active
	local move_timer_override = false
	local pacing_manager = Managers.state.pacing
	local move_timer_when_challenge_rating_above = self._override_move_timer_when_challenge_rating_above or template.move_timer_when_challenge_rating_above

	if move_timer_when_challenge_rating_above then
		local delay_is_active = self._move_timer_when_challenge_rating_above_delay and self._move_timer_when_challenge_rating_above_delay > 0

		if delay_is_active or move_timer_when_challenge_rating_above < pacing_manager:total_challenge_rating() then
			move_timer_override = true

			if not delay_is_active then
				self._move_timer_when_challenge_rating_above_delay = template.move_timer_when_challenge_rating_above_delay or 30
			end
		end
	end

	if self._always_move_timer then
		move_timer_override = true
	end

	if not move_timer_override and move_timer_when_horde_active then
		local horde_manager = Managers.state.horde
		local num_active_hordes = 0

		for horde_type, _ in pairs(HORDE_TYPES) do
			if horde_type ~= "trickle_horde" then
				num_active_hordes = num_active_hordes + horde_manager:num_active_hordes(horde_type)

				if num_active_hordes > 0 then
					move_timer_override = true
				end
			end
		end
	end

	if not move_timer_override and move_timer_when_monster_active then
		if pacing_manager:num_aggroed_monsters() > 0 then
			move_timer_override = true
		end

		if self._force_move_timer then
			move_timer_override = true
		end
	end

	if not move_timer_override and move_timer_when_terror_event_active and Managers.state.terror_event:num_active_events() > 0 then
		move_timer_override = true
	end

	if self._coordinated_surge_duration and t <= self._coordinated_surge_duration then
		move_timer_override = true
	end

	local travel_distance_spawning = self:_travel_distance_spawning() or has_travel_distance_mutator

	for i = 1, max_alive_specials do
		local specials_slot = specials_slots[i]

		if specials_slot.spawned then
			local unit = specials_slot.spawned_unit

			if HEALTH_ALIVE[unit] then
				if specials_slot.next_stuck_check_t <= t then
					self:_check_stuck_special(unit, specials_slot, template, target_side_id, t)
				end
			else
				self._num_spawned_specials = self._num_spawned_specials - 1
				specials_slot.spawned_unit = nil
				specials_slot.spawned = false
				local activated_coordinated_strike = self:_check_and_activate_coordinated_strike(template, specials_slot)

				if not activated_coordinated_strike then
					self:_setup_specials_slot(specials_slots, specials_slot, template, self._timer_modifier)
				end
			end
		elseif specials_slot.spawner_queue_id then
			local spawner_queue_id = specials_slot.spawner_queue_id
			local spawner = specials_slot.spawner

			if not spawner:is_spawning() then
				local spawned_minions_by_queue_id = spawner:spawned_minions_by_queue_id(spawner_queue_id)

				if spawned_minions_by_queue_id then
					local spawned_unit = spawned_minions_by_queue_id[1]

					self:_on_special_spawned(specials_slot, spawned_unit)
				end
			end
		elseif specials_slot.spawn_timer <= 0 then
			self:_check_disabler_override(template, target_side_id, specials_slot)

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

				Managers.server_metrics:add_annotation("special_failed_to_spawn", {
					travel_distance = furthest_travel_distance
				})
			end
		else
			local total_challenge_rating = pacing_manager:total_challenge_rating()
			local include_travel_distance_in_timer = nil

			if not move_timer_override and template.always_update_breeds then
				local breed_name = self:_get_special_slot_breed_name(specials_slot)
				local required_challenge_rating = template.always_update_breeds[breed_name]
				move_timer_override = required_challenge_rating and required_challenge_rating <= total_challenge_rating
				include_travel_distance_in_timer = move_timer_override
			end

			local foreshadow_stinger = specials_slot.foreshadow_stinger
			local foreshadow_stinger_available = foreshadow_stinger and not specials_slot.foreshadow_triggered
			local can_update_foreshadow_stinger_timer = foreshadow_stinger_available and (specials_allowed or specials_slot.injected)
			local coordinated_strike_challenge_rating = self._override_move_timer_when_challenge_rating_above or template.coordinated_strike_challenge_rating
			local coordinated_strike_update_override = specials_slot.coordinated_strike and (not coordinated_strike_challenge_rating or coordinated_strike_challenge_rating < total_challenge_rating)
			local should_update_by_travel_distance = not coordinated_strike_update_override and not move_timer_override and travel_distance_spawning
			local pause_spawn = false
			local pause_spawn_timer = false
			local required_challenge_rating = self._required_challenge_rating

			if required_challenge_rating and total_challenge_rating <= required_challenge_rating then
				pause_spawn = true
			end

			if can_update_foreshadow_stinger_timer then
				local current_foreshadow_timer = specials_slot.foreshadow_stinger_timer

				if should_update_by_travel_distance then
					local time_reduction = current_foreshadow_timer < NO_MODIFIER_TIME and traveled_this_frame or traveled_this_frame * ramp_up_timer_modifier
					specials_slot.foreshadow_stinger_timer = math.max(current_foreshadow_timer - time_reduction, 0)
				elseif include_travel_distance_in_timer then
					local time_reduction = current_foreshadow_timer < NO_MODIFIER_TIME and dt or (dt + traveled_this_frame) * ramp_up_timer_modifier * self._timer_multiplier
					specials_slot.foreshadow_stinger_timer = math.max(current_foreshadow_timer - time_reduction, 0)
				else
					local time_reduction = current_foreshadow_timer < NO_MODIFIER_TIME and dt or dt * ramp_up_timer_modifier * self._timer_multiplier
					specials_slot.foreshadow_stinger_timer = math.max(current_foreshadow_timer - time_reduction, 0)
				end

				if specials_slot.foreshadow_stinger_timer <= 0 then
					if pause_spawn then
						specials_slot.foreshadow_stinger_timer = 0
						pause_spawn_timer = true
					else
						local disabler_override = self:_check_disabler_override(template, target_side_id, specials_slot)

						if not disabler_override then
							local _, _, path_position = Managers.state.main_path:ahead_unit(target_side_id)

							if path_position then
								self._fx_system:trigger_wwise_event(foreshadow_stinger, path_position)

								specials_slot.foreshadow_triggered = true
							end
						end

						local breed_name = self:_get_special_slot_breed_name(specials_slot)
						local breed = Breeds[breed_name]
						local tags = breed.tags

						if tags.disabler then
							specials_slot.disabler_is_active = true
						end
					end
				end
			end

			local can_update_spawn_timer = specials_allowed and not pause_spawn_timer or specials_slot.foreshadow_triggered or specials_slot.injected

			if can_update_spawn_timer then
				local new_spawn_timer = nil
				local current_spawn_timer = specials_slot.spawn_timer

				if should_update_by_travel_distance and not specials_slot.foreshadow_triggered then
					local time_reduction = current_spawn_timer < NO_MODIFIER_TIME and traveled_this_frame or traveled_this_frame * ramp_up_timer_modifier
					new_spawn_timer = specials_slot.spawn_timer - time_reduction
				elseif include_travel_distance_in_timer then
					local time_reduction = current_spawn_timer < NO_MODIFIER_TIME and dt or (dt + traveled_this_frame) * ramp_up_timer_modifier * self._timer_multiplier
					new_spawn_timer = specials_slot.spawn_timer - time_reduction
				else
					local time_reduction = current_spawn_timer < NO_MODIFIER_TIME and dt or dt * ramp_up_timer_modifier * self._timer_multiplier
					new_spawn_timer = specials_slot.spawn_timer - time_reduction
				end

				if not pause_spawn or new_spawn_timer > 0 then
					specials_slot.spawn_timer = new_spawn_timer
				else
					specials_slot.spawn_timer = math.random(5, 10)
				end
			end
		end
	end

	if specials_allowed then
		self:_update_rush_prevention(target_side_id, template, t)

		if self._disabler_override_duration then
			self._disabler_override_duration = math.max(self._disabler_override_duration - dt, 0)
		end

		if self._move_timer_when_challenge_rating_above_delay then
			self._move_timer_when_challenge_rating_above_delay = self._move_timer_when_challenge_rating_above_delay - dt

			if self._move_timer_when_challenge_rating_above_delay <= 0 then
				self._move_timer_when_challenge_rating_above_delay = nil
			end
		end
	end

	self:_update_speed_running_prevention(target_side_id, template, t)
end

SpecialsPacing._spawn_special = function (self, specials_slot, side_id, target_side_id)
	local breed_name = self:_get_special_slot_breed_name(specials_slot)
	local optional_prefered_spawn_direction = specials_slot.optional_prefered_spawn_direction
	local optional_mainpath_offset = specials_slot.optional_mainpath_offset

	if Managers.state.terror_event:num_active_events() > 0 then
		optional_mainpath_offset = 0
	end

	local prefered_ahead_override = optional_prefered_spawn_direction and optional_prefered_spawn_direction == "ahead"
	local prefered_behind_override = optional_prefered_spawn_direction and optional_prefered_spawn_direction == "behind"
	local check_ahead = nil

	if prefered_ahead_override ~= nil or prefered_behind_override ~= nil then
		check_ahead = prefered_ahead_override or not prefered_behind_override
	else
		check_ahead = math.random() > 0.5
	end

	local optional_health_modifier = specials_slot.optional_health_modifier
	local specials_slot_spawner_group = specials_slot.spawner_group

	if specials_slot_spawner_group then
		local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
		local spawners = minion_spawn_system:spawners_in_group(specials_slot_spawner_group)
		local spawner = self:_filter_too_close_spawners(target_side_id, spawners)

		if spawner then
			local spawner_queue_id = self:_add_spawner_special(spawner, breed_name, side_id, target_side_id, optional_health_modifier)

			return true, nil, spawner_queue_id, spawner
		end

		return false
	end

	local randomize = specials_slot.coordinated_strike
	local spawn_position, closest_target_unit = self:_find_spawn_position(side_id, breed_name, target_side_id, check_ahead, optional_mainpath_offset, randomize)

	if not spawn_position then
		spawn_position, closest_target_unit = self:_find_spawn_position(side_id, breed_name, target_side_id, not check_ahead, nil, randomize)

		if not spawn_position then
			local spawner_groups = self._spawner_groups

			if spawner_groups then
				local spawner_group = spawner_groups[math.random(1, #spawner_groups)]
				local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
				local spawners = minion_spawn_system:spawners_in_group(spawner_group)
				local spawner = self:_filter_too_close_spawners(target_side_id, spawners)

				if spawner then
					local spawner_queue_id = self:_add_spawner_special(spawner, breed_name, side_id, target_side_id, optional_health_modifier)

					return true, nil, spawner_queue_id, spawner
				end

				return false
			else
				local nearby_spawner = self:_find_nearby_spawner(target_side_id)

				if nearby_spawner then
					local spawner_queue_id = self:_add_spawner_special(nearby_spawner, breed_name, side_id, target_side_id, optional_health_modifier)

					return true, nil, spawner_queue_id, nearby_spawner
				else
					Log.info("SpecialsPacing", "Failed to spawn special %s. No occluded positions OR spawners nearby.", breed_name)

					return false
				end
			end
		end
	end

	local slot_target_unit = specials_slot.target_unit
	local target_unit = ALIVE[slot_target_unit] and slot_target_unit or closest_target_unit
	local unit = Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, aggro_states.aggroed, target_unit, nil, nil, nil, nil, optional_health_modifier)

	return true, unit
end

SpecialsPacing._travel_distance_spawning = function (self)
	return self._travel_distance_spawning_override ~= nil and self._travel_distance_spawning_override or self._template.travel_distance_spawning
end

SpecialsPacing.set_travel_distance_spawning_override = function (self, travel_distance_spawning)
	self._travel_distance_spawning_override = travel_distance_spawning
end

SpecialsPacing._on_special_spawned = function (self, specials_slot, spawned_unit)
	self._num_spawned_specials = self._num_spawned_specials + 1
	specials_slot.spawned_unit = spawned_unit
	specials_slot.spawned = true
	local breed_name = self:_get_special_slot_breed_name(specials_slot)
	local spawn_stinger = self._template.spawn_stingers[breed_name]

	if spawn_stinger and ALIVE[spawned_unit] then
		self._fx_system:trigger_wwise_event(spawn_stinger, nil, spawned_unit)
	end

	local breed = Breeds[breed_name]
	local tags = breed.tags

	if tags.disabler then
		specials_slot.disabler_is_active = true
	end
end

SpecialsPacing._get_special_slot_breed_name = function (self, specials_slot)
	local breed_name = specials_slot.breed_name
	local new_breed_name = self:_get_breed_name(breed_name)

	return new_breed_name
end

SpecialsPacing._get_breed_name = function (self, breed_name)
	local faction_bound_breeds = self._template.faction_bound_breeds

	if faction_bound_breeds and faction_bound_breeds[breed_name] then
		local current_faction = Managers.state.pacing:current_faction()
		local faction_bound_breed = faction_bound_breeds[breed_name]
		breed_name = faction_bound_breed and faction_bound_breed[current_faction]

		if not breed_name then
			local _, next_breed_name = next(faction_bound_breed)
			breed_name = next_breed_name
		end
	end

	return breed_name
end

local ABOVE = 1
local BELOW = 1.5
local LATERAL = 1

local function _find_travel_distance(nav_world, target_unit, nav_spawn_points)
	local target_navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, POSITION_LOOKUP[target_unit], ABOVE, BELOW, LATERAL)

	if not target_navmesh_position then
		return
	end

	local spawn_point_group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, target_navmesh_position)
	local start_index = Managers.state.main_path:node_index_by_nav_group_index(spawn_point_group_index or 1)
	local end_index = start_index + 1
	local _, target_travel_distance, _, _, _ = MainPathQueries.closest_position_between_nodes(target_navmesh_position, start_index, end_index)

	if target_travel_distance then
		return target_travel_distance
	end
end

local ALONE_TARGETS = {}

SpecialsPacing._find_spawn_position = function (self, side_id, breed_name, target_side_id, check_ahead, optional_mainpath_offset, optional_randomize)
	local template = self._template
	local disabler_target_alone_player_chance = template.disabler_target_alone_player_chance and template.disabler_target_alone_player_chance[breed_name]
	local breed = Breeds[breed_name]
	local target_unit, travel_distance = nil
	local side_system = Managers.state.extension:system("side_system")

	if not optional_randomize and disabler_target_alone_player_chance and breed.tags.disabler and math.random() <= disabler_target_alone_player_chance then
		local side = side_system:get_side(target_side_id)
		local target_units = side.valid_player_units
		local num_target_units = #target_units

		table.clear(ALONE_TARGETS)

		for i = 1, num_target_units do
			local possible_target = target_units[i]
			local coherency_extension = ScriptUnit.has_extension(possible_target, "coherency_system")
			local num_units_in_coherency = coherency_extension:num_units_in_coherency()

			if num_units_in_coherency == 1 then
				ALONE_TARGETS[#ALONE_TARGETS + 1] = possible_target
			end
		end

		if #ALONE_TARGETS > 0 then
			target_unit = ALONE_TARGETS[math.random(1, #ALONE_TARGETS)]
		end
	end

	local nav_world = self._nav_world
	local main_path_manager = Managers.state.main_path

	if not target_unit then
		if optional_randomize then
			local side = side_system:get_side(target_side_id)
			local target_units = side.valid_player_units
			local num_target_units = #target_units
			local random_target_unit = target_units[math.random(1, num_target_units)]

			if random_target_unit then
				travel_distance = _find_travel_distance(nav_world, random_target_unit, self._nav_spawn_points)
				target_unit = random_target_unit
			end
		elseif check_ahead then
			target_unit, travel_distance = main_path_manager:ahead_unit(target_side_id)
		else
			target_unit, travel_distance = main_path_manager:behind_unit(target_side_id)
		end

		if not target_unit then
			return
		end
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local navmesh_position = nil

	if optional_mainpath_offset then
		if not travel_distance then
			local target_travel_distance = _find_travel_distance(nav_world, target_unit, self._nav_spawn_points)

			if target_travel_distance then
				travel_distance = target_travel_distance
			else
				return
			end
		end

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
	local side = side_system:get_side(side_id)
	local max_spawn_group_offset_range = template.max_spawn_group_offset_range + math.min(self._num_failed_attempts, 12)
	local num_spawn_point_groups = self._num_spawn_point_groups
	local min_distance_from_target = template.min_distances_from_target[breed_name]
	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, navmesh_position, side, max_spawn_group_offset_range, num_spawn_point_groups, min_distance_from_target)

	if not random_occluded_position then
		self._num_failed_attempts = self._num_failed_attempts + 1

		return
	end

	self._num_failed_attempts = 0

	return random_occluded_position, target_unit
end

local ALLOWED_Z_DIFF = 12

SpecialsPacing._find_nearby_spawner = function (self, target_side_id)
	local main_path_manager = Managers.state.main_path
	local target_unit = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return
	end

	local nearby_valid_spawner = self:_filter_too_close_spawners(target_side_id)

	return nearby_valid_spawner
end

SpecialsPacing._filter_too_close_spawners = function (self, target_side_id, optional_spawners)
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
	local spawn_type = "specials"
	local nearby_spawners = optional_spawners or minion_spawn_system:spawners_in_range(pos, spawners_max_range, spawn_type)

	table.shuffle(nearby_spawners)

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
			local z_diff = math.abs(spawner_position.z - player_position.z)

			if z_diff < ALLOWED_Z_DIFF then
				local distance = Vector3.distance(spawner_position, player_position)

				if distance < spawners_min_range then
					is_valid_spawner = false

					break
				end
			end
		end

		if is_valid_spawner then
			nearby_valid_spawner = spawner

			break
		end
	end

	if not nearby_valid_spawner then
		-- Nothing
	end

	return nearby_valid_spawner
end

SpecialsPacing._add_spawner_special = function (self, spawner, breed_name, side_id, target_side_id, optional_health_modifier)
	local spawner_queue_id = spawner:add_spawns({
		breed_name
	}, side_id, target_side_id, nil, nil, nil, nil, nil, optional_health_modifier)

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

SpecialsPacing._check_disabler_override = function (self, template, target_side_id, specials_slot)
	if specials_slot.optional_is_prevention or specials_slot.disabler_override or specials_slot.disabler_is_active then
		return false
	end

	local breed_name = self:_get_special_slot_breed_name(specials_slot)
	local breed = Breeds[breed_name]
	local tags = breed.tags

	if not tags.disabler then
		return false
	end

	local specials_slots = self._specials_slots
	local num_active_disablers = 0

	for i = 1, self._max_alive_specials do
		local other_specials_slot = specials_slots[i]

		if other_specials_slot.disabler_is_active then
			num_active_disablers = num_active_disablers + 1
		end
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
		end
	end

	if num_non_disabled_players == 0 then
		return false
	end

	num_non_disabled_players = math.min(num_non_disabled_players, 4)
	local num_allowed_disablers_challenge_table = Managers.state.difficulty:get_table_entry_by_challenge(template.num_allowed_disablers_per_alive_targets)
	local num_allowed_disablers_per_alive_targets = num_allowed_disablers_challenge_table[num_non_disabled_players]
	local allowed_disablers = num_allowed_disablers_per_alive_targets - num_active_disablers

	if allowed_disablers <= 0 and (not self._disabler_override_duration or self._disabler_override_duration > 0) then
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

		specials_slot.disabler_override = true
		specials_slot.disabler_is_active = nil

		Log.info("SpecialsPacing", "Replaced %s breed with %s because of disabler override", breed_name, new_breed_name)

		if not self._disabler_override_duration and num_non_disabled_players == 1 then
			local disabler_override_duration = Managers.state.difficulty:get_table_entry_by_challenge(template.disabler_override_duration)
			self._disabler_override_duration = disabler_override_duration
		end

		return true
	end

	if allowed_disablers > 0 then
		self._disabler_override_duration = nil
	end

	return false
end

SpecialsPacing._check_monster_override = function (self, template)
	local t = Managers.time:time("gameplay")

	if self._max_monster_duration then
		if self._max_monster_duration < t then
			self._max_monster_duration = nil
		else
			return
		end
	end

	if not self._specials_slots then
		return
	end

	local monster_spawn_config = self._monster_spawn_config

	if not monster_spawn_config then
		return
	end

	local chance_to_spawn_monster = monster_spawn_config.chance_to_spawn_monster

	if chance_to_spawn_monster < math.random() then
		return
	end

	local monster_breed_name = monster_spawn_config.breeds[math.random(1, #monster_spawn_config.breeds)]
	local max_monsters = monster_spawn_config.max_monsters
	local num_monsters = 0
	local specials_slots = self._specials_slots

	for i = 1, #specials_slots do
		local specials_slot = specials_slots[i]
		local breed_name = self:_get_special_slot_breed_name(specials_slot)

		if breed_name then
			local tags = Breeds[breed_name].tags

			if tags.monster then
				num_monsters = num_monsters + 1
			end
		end
	end

	if max_monsters <= num_monsters then
		if not self._max_monster_duration then
			self._max_monster_duration = t + math.random_range(monster_spawn_config.max_monster_duration[1], monster_spawn_config.max_monster_duration[2])
		end

		return
	end

	local optional_health_modifier = monster_spawn_config.health_modifiers[monster_breed_name]

	return monster_breed_name, optional_health_modifier
end

local MIN_COORDINATED_TIMER = 20
local COORDINATED_STRIKE_TIMER_OFFSET_RANGE = {
	3,
	6
}

SpecialsPacing._check_and_activate_coordinated_strike = function (self, template, current_special_slot)
	local specials_slots = self._specials_slots
	local t = Managers.time:time("gameplay")

	if self._coordinated_surge_duration and t <= self._coordinated_surge_duration then
		local optional_coordinated_strike = true
		local coordinated_surge_timer_range = template.coordinated_surge_timer_range
		local min_timer_range = coordinated_surge_timer_range[1]
		local max_timer_range = coordinated_surge_timer_range[2]
		local coordinated_surge_timer = math.random_range(min_timer_range, max_timer_range)

		self:_setup_specials_slot(specials_slots, current_special_slot, template, self._timer_modifier, nil, coordinated_surge_timer, nil, optional_coordinated_strike)

		return true
	end

	if self._num_spawned_specials > 0 then
		return false
	end

	for i = 1, self._max_alive_specials do
		local specials_slot = specials_slots[i]

		if specials_slot.coordinated_strike then
			return false
		end
	end

	local chance_for_coordinated_strike = self._coordinated_strike_chance_override or template.chance_for_coordinated_strike

	if not chance_for_coordinated_strike then
		return false
	end

	local random_roll = math.random()
	local should_activate_coordinated_strike = random_roll < chance_for_coordinated_strike

	if not should_activate_coordinated_strike then
		return false
	end

	local coordinated_strike_timer_range = template.coordinated_strike_timer_range
	local min_timer_range = coordinated_strike_timer_range[1]
	local max_timer_range = coordinated_strike_timer_range[2]
	local lowest_spawn_timer = math.huge

	for i = 1, self._max_alive_specials do
		local specials_slot = specials_slots[i]
		local spawn_timer = specials_slot.spawn_timer

		if spawn_timer < lowest_spawn_timer and MIN_COORDINATED_TIMER < spawn_timer then
			lowest_spawn_timer = spawn_timer
		end
	end

	local coordinated_strike_timer = nil

	if lowest_spawn_timer < min_timer_range then
		local diff = max_timer_range - min_timer_range
		local max = lowest_spawn_timer + diff
		coordinated_strike_timer = math.random_range(lowest_spawn_timer, max)
	else
		coordinated_strike_timer = math.random_range(min_timer_range, max_timer_range)
	end

	Log.info("SpecialsPacing", "Coordinated strike in %.02f", coordinated_strike_timer)

	if self._num_coordinated_surges and self._num_coordinated_surges > 0 then
		local is_coordinated_surge = math.random() <= template.coordinated_surge_chance

		if is_coordinated_surge then
			local coordinated_surge_duration = math.random_range(template.coordinated_surge_duration_range[1], template.coordinated_surge_duration_range[2])
			self._coordinated_surge_duration = t + coordinated_surge_duration
			local coordinated_surge_timer_range = template.coordinated_surge_timer_range
			local surge_min_timer_range = coordinated_surge_timer_range[1]
			local surge_max_timer_range = coordinated_surge_timer_range[2]
			coordinated_strike_timer = math.random_range(surge_min_timer_range, surge_max_timer_range)
			self._num_coordinated_surges = self._num_coordinated_surges - 1
		end
	end

	local coordinated_strike_num_breeds = template.coordinated_strike_num_breeds
	local num_breeds = type(coordinated_strike_num_breeds) == "table" and math.random(coordinated_strike_num_breeds[1], coordinated_strike_num_breeds[2]) or coordinated_strike_num_breeds
	num_breeds = math.min(num_breeds * self._max_alive_specials_multiplier + self._max_alive_specials_bonus, #specials_slots)

	for i = 1, num_breeds do
		local specials_slot = specials_slots[i]
		local optional_coordinated_strike = true

		self:_setup_specials_slot(specials_slots, specials_slot, template, self._timer_modifier, nil, coordinated_strike_timer, nil, optional_coordinated_strike)

		coordinated_strike_timer = coordinated_strike_timer + math.random_range(COORDINATED_STRIKE_TIMER_OFFSET_RANGE[1], COORDINATED_STRIKE_TIMER_OFFSET_RANGE[2])
	end

	return true
end

SpecialsPacing._update_rush_prevention = function (self, target_side_id, template, t)
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
		if not self._extra_scrambler_cooldown or self._extra_scrambler_cooldown < t then
			local player_unit = target_units[1]
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")

			if disabled_character_state_component then
				local is_pounced = PlayerUnitStatus.is_pounced(disabled_character_state_component)

				if is_pounced then
					if math.random() < 0.4 then
						self:try_inject_special("chaos_poxwalker_bomber", "behind", player_unit)
					end

					self._extra_scrambler_cooldown = t + math.random_range(20, 50)
				end
			end
		end

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

SpecialsPacing._update_speed_running_prevention = function (self, target_side_id, template, t)
	local speed_running_prevention_breeds = template.speed_running_prevention_breeds

	if not speed_running_prevention_breeds or t < self._speed_running_prevention_cooldown then
		return
	end

	local ahead_unit, ahead_travel_distance = Managers.state.main_path:ahead_unit(target_side_id)

	if not ahead_unit then
		return
	end

	local required_challenge_rating = template.speed_running_required_challenge_rating
	local challenge_rating = Managers.state.pacing:total_challenge_rating()

	if challenge_rating < required_challenge_rating then
		return
	end

	local next_speed_running_check_t = self._next_speed_running_check_t

	if t < next_speed_running_check_t then
		return
	end

	self._ahead_unit_has_no_units_in_coherency = false
	self._next_speed_running_check_t = t + template.speed_running_check_frequency
	local previous_speed_running_distance = self._previous_speed_running_distance

	if not previous_speed_running_distance then
		self._previous_speed_running_distance = ahead_travel_distance

		return
	end

	local distance_diff = ahead_travel_distance - previous_speed_running_distance
	local speed_running_required_distance = template.speed_running_required_distance
	self._previous_speed_running_distance = ahead_travel_distance

	if distance_diff < speed_running_required_distance then
		self._num_speed_running_checks = 0
		self._previous_speed_running_distance = nil

		return
	end

	self._num_speed_running_checks = self._num_speed_running_checks + 1

	Log.info("SpecialsPacing", "Identitying speed running.. %d %.02f", self._num_speed_running_checks, distance_diff)

	local num_required_speed_running_checks = template.num_required_speed_running_checks
	local coherency_extension = ScriptUnit.has_extension(ahead_unit, "coherency_system")
	local num_units_in_coherency = coherency_extension and coherency_extension:num_units_in_coherency() or math.huge
	self._ahead_unit_has_no_units_in_coherency = num_units_in_coherency == 1

	if self._num_speed_running_checks < num_required_speed_running_checks and (num_units_in_coherency > 1 or self._num_speed_running_checks == 1) then
		return
	end

	local speed_running_prevention_breed_name = speed_running_prevention_breeds[math.random(1, #speed_running_prevention_breeds)]

	Log.info("SpecialsPacing", "Trying to inject speed running prevention breed ahead %s.", speed_running_prevention_breed_name)

	local ignore_allowance = true
	local is_prevention = true
	local success = self:try_inject_special(speed_running_prevention_breed_name, "ahead", ahead_unit, nil, ignore_allowance, is_prevention)

	if success then
		self._num_speed_running_checks = 0
		self._previous_speed_running_distance = nil
	end

	local cooldown = success and template.speed_running_prevention_cooldown or template.speed_running_prevention_failed_cooldown
	self._speed_running_prevention_cooldown = t + math.random_range(cooldown[1], cooldown[2])
end

SpecialsPacing.try_inject_special = function (self, breed_name, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group, optional_ignore_allowance, optional_is_prevention)
	local specials_allowed = Managers.state.pacing:spawn_type_allowed("specials")

	if not optional_ignore_allowance and not specials_allowed then
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

	self:_setup_specials_slot(specials_slots, chosen_slot, template, self._timer_modifier, breed_name, spawn_timer, injected, nil, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group, optional_is_prevention)

	return true
end

SpecialsPacing.freeze = function (self, should_freeze)
	self._frozen = should_freeze
end

SpecialsPacing.set_max_alive_specials_multiplier = function (self, multiplier)
	if type(multiplier) == "table" then
		multiplier = Managers.state.difficulty:get_table_entry_by_challenge(multiplier)
	end

	self._max_alive_specials_multiplier = multiplier
	local template = self._template

	if not template then
		return
	end

	local first_spawn_timer_modifer = template.first_spawn_timer_modifer

	self:_setup(template, first_spawn_timer_modifer)
end

SpecialsPacing.set_chance_of_coordinated_strike = function (self, coordinated_strike_chance)
	self._coordinated_strike_chance_override = coordinated_strike_chance
end

SpecialsPacing.set_coordinated_strike_num_breeds_override = function (self, coordinated_strike_num_breeds_override)
	self._coordinated_strike_num_breeds_override = coordinated_strike_num_breeds_override
end

SpecialsPacing.set_max_of_same_override = function (self, max_of_same_override)
	self._optional_max_of_same_override = max_of_same_override
end

SpecialsPacing.set_required_challenge_rating = function (self, required_challenge_rating)
	if type(required_challenge_rating) == "table" then
		required_challenge_rating = Managers.state.difficulty:get_table_entry_by_challenge(required_challenge_rating)
	end

	self._required_challenge_rating = required_challenge_rating
end

SpecialsPacing.set_monster_spawn_config = function (self, monster_spawn_config)
	self._monster_spawn_config = monster_spawn_config
end

SpecialsPacing.set_always_move_timer = function (self, always_move)
	self._always_move_timer = always_move
end

local REFUND_TIMER = 15

SpecialsPacing.refund_special_slot = function (self)
	local specials_slots = self._specials_slots
	local chosen_slot = nil

	for i = 1, self._max_alive_specials do
		local specials_slot = specials_slots[i]

		if not specials_slot.spawned and not specials_slot.foreshadow_triggered then
			chosen_slot = specials_slot

			break
		end
	end

	if chosen_slot then
		chosen_slot.spawn_timer = REFUND_TIMER
	end
end

SpecialsPacing.set_force_move_timer = function (self, should_force_move_timer)
	self._force_move_timer = should_force_move_timer
end

SpecialsPacing.force_coordinated_strike = function (self, timer, override_num_breeds)
	Log.info("SpecialsPacing", "Forced Coordinated strike in %.02f", timer)

	local specials_slots = self._specials_slots
	local template = self._template
	local coordinated_strike_num_breeds = template.coordinated_strike_num_breeds
	local num_breeds = override_num_breeds or type(coordinated_strike_num_breeds) == "table" and math.random(coordinated_strike_num_breeds[1], coordinated_strike_num_breeds[2]) or coordinated_strike_num_breeds
	num_breeds = math.min(num_breeds * self._max_alive_specials_multiplier + self._max_alive_specials_bonus, #specials_slots)

	for i = 1, num_breeds do
		local specials_slot = specials_slots[i]

		if not ALIVE[specials_slot.spawned_unit] then
			local optional_coordinated_strike = true

			self:_setup_specials_slot(specials_slots, specials_slot, template, self._timer_modifier, nil, timer, nil, optional_coordinated_strike)

			timer = timer + math.random_range(COORDINATED_STRIKE_TIMER_OFFSET_RANGE[1], COORDINATED_STRIKE_TIMER_OFFSET_RANGE[2])
		end
	end
end

SpecialsPacing.set_spawner_groups = function (self, spawner_groups)
	self._spawner_groups = spawner_groups
end

SpecialsPacing.set_move_timer_when_challenge_rating_above = function (self, challenge_rating)
	self._override_move_timer_when_challenge_rating_above = challenge_rating
end

return SpecialsPacing
