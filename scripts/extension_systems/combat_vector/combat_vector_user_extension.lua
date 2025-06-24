-- chunkname: @scripts/extension_systems/combat_vector/combat_vector_user_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CombatVectorSettings = require("scripts/settings/combat_vector/combat_vector_settings")
local CombatVectorUserExtension = class("CombatVectorUserExtension")
local range_types = CombatVectorSettings.range_types

CombatVectorUserExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local breed = extension_init_data.breed

	self._breed = breed
	self._current_location = nil
	self._previous_combat_range = nil
	self._config = breed.combat_vector_config
	self._current_vector_type = nil

	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)
end

CombatVectorUserExtension.destroy = function (self)
	self:_check_and_release_location()
end

CombatVectorUserExtension._init_blackboard_components = function (self, blackboard)
	local combat_vector_component = Blackboard.write_component(blackboard, "combat_vector")

	combat_vector_component.position:store(0, 0, 0)

	combat_vector_component.has_position = false
	combat_vector_component.distance = 0
	combat_vector_component.combat_vector_is_closer = false
	self._combat_vector_component = combat_vector_component
	self._behavior_component = blackboard.behavior
	self._perception_component = blackboard.perception
end

local MAIN_VECTOR_TYPE = "main"

CombatVectorUserExtension._get_best_location_type = function (self, unit_position, claimed_location_counters, nav_mesh_locations, flank_positions, combat_vector_position, combat_range)
	local config = self._config
	local can_flank = config.can_flank
	local best_location_type
	local lowest_amount = math.huge
	local vector_type

	if can_flank then
		local closest_distance = Vector3.distance(unit_position, combat_vector_position:unbox())
		local closest_flank_vector_type

		for flank_type, flank_position in pairs(flank_positions) do
			repeat
				local distance = Vector3.distance(unit_position, flank_position:unbox())

				if distance < closest_distance then
					closest_flank_vector_type = flank_type
					closest_distance = distance
				end
			until true
		end

		if closest_flank_vector_type then
			local flank_num_claimed_locations = claimed_location_counters[closest_flank_vector_type]
			local vector_locations = nav_mesh_locations[closest_flank_vector_type]

			for location_type, num_claimed in pairs(flank_num_claimed_locations) do
				local locations = vector_locations[location_type][combat_range]
				local has_free_locations = num_claimed < #locations

				if has_free_locations and num_claimed < lowest_amount then
					best_location_type = location_type
					lowest_amount = num_claimed
					vector_type = closest_flank_vector_type
				end
			end
		end
	end

	local vector_locations = nav_mesh_locations[MAIN_VECTOR_TYPE]

	for location_type, num_claimed in pairs(claimed_location_counters.main) do
		local locations = vector_locations[location_type][combat_range]
		local has_free_locations = num_claimed < #locations

		if has_free_locations and num_claimed < lowest_amount then
			best_location_type = location_type
			lowest_amount = num_claimed
			vector_type = MAIN_VECTOR_TYPE
		end
	end

	return best_location_type, vector_type
end

CombatVectorUserExtension._get_new_location = function (self, unit_position, locations, combat_range)
	local range_locations = locations[combat_range]

	if #range_locations == 0 then
		local new_range = combat_range == range_types.close and range_types.far or range_types.close

		range_locations = locations[new_range]

		if not range_locations or #range_locations == 0 then
			return
		end
	end

	local new_location
	local min_dist, max_dist = self._new_location_min_distance or 0, self._new_location_max_distance or math.huge
	local config = self._config
	local choose_furthest_away = config.choose_furthest_away
	local choose_closest_to_target = config.choose_closest_to_target
	local best_distance = choose_furthest_away and 0 or math.huge
	local target_unit = self._perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]

	for i = 1, #range_locations do
		local range_location = range_locations[i]

		if not range_location.claimed then
			local range_position = range_location.position:unbox()

			if choose_closest_to_target then
				local target_distance_to_position = Vector3.distance(target_position, range_position)

				if target_distance_to_position < best_distance then
					best_distance = target_distance_to_position
					new_location = range_location
				end
			else
				local distance_to_range_position = Vector3.distance(choose_furthest_away and target_position or unit_position, range_position)

				if min_dist < distance_to_range_position and distance_to_range_position < max_dist then
					if choose_furthest_away then
						if best_distance < distance_to_range_position then
							best_distance = distance_to_range_position
							new_location = range_location
						end
					elseif distance_to_range_position < best_distance then
						best_distance = distance_to_range_position
						new_location = range_location
					end
				end
			end
		end
	end

	return new_location
end

CombatVectorUserExtension.look_for_new_location = function (self, min_distance, max_distance, new_combat_range)
	self._wants_new_location = true
	self._new_location_min_distance = min_distance
	self._new_location_max_distance = max_distance
	self._wants_new_combat_range = new_combat_range
end

CombatVectorUserExtension.switch_range = function (self, new_combat_range)
	self._combat_vector_component.range = new_combat_range
end

CombatVectorUserExtension.update = function (self, unit, dt, t, context, nav_mesh_locations, claimed_location_counters, changed, flank_positions, combat_vector_position)
	local config = self._config
	local perception_component = self._perception_component

	if not config.update_when_passive then
		local is_aggroed = perception_component.aggro_state == "aggroed"
		local target_unit = perception_component.target_unit

		if not is_aggroed or not ALIVE[target_unit] then
			return
		end
	end

	local current_location = self._current_location
	local combat_vector_component, behavior_component = self._combat_vector_component, self._behavior_component
	local current_combat_range, previous_combat_range = behavior_component.combat_range, self._previous_combat_range
	local wants_new_location = self._wants_new_location

	if not current_location or changed or current_combat_range ~= previous_combat_range or wants_new_location then
		local valid_combat_ranges = config.valid_combat_ranges
		local unit_position = POSITION_LOOKUP[unit]
		local combat_range = wants_new_location and self._wants_new_combat_range or valid_combat_ranges[current_combat_range] and current_combat_range or config.default_combat_range
		local best_location_type, vector_type = self:_get_best_location_type(unit_position, claimed_location_counters, nav_mesh_locations, flank_positions, combat_vector_position, combat_range)
		local chosen_location

		if best_location_type then
			local locations = nav_mesh_locations[vector_type][best_location_type]

			chosen_location = self:_get_new_location(unit_position, locations, combat_range)
		end

		if chosen_location then
			self:_check_and_release_location()

			chosen_location.claimed = true
			self._current_location = chosen_location
			self._previous_combat_range = current_combat_range

			local position = chosen_location.position:unbox()
			local self_position = POSITION_LOOKUP[unit]
			local distance = Vector3.distance(self_position, position)

			if not config.update_when_passive then
				local target_unit = perception_component.target_unit
				local target_position = POSITION_LOOKUP[target_unit]
				local distance_to_target = Vector3.distance(self_position, target_position)
				local combat_vector_is_closer = distance < distance_to_target

				combat_vector_component.combat_vector_is_closer = combat_vector_is_closer
			end

			combat_vector_component.position:store(position)

			combat_vector_component.has_position = true
			combat_vector_component.distance = distance

			local location_counters = claimed_location_counters[vector_type]
			local current_location_count = location_counters[best_location_type]

			location_counters[best_location_type] = current_location_count + 1
			self._claimed_location_counters = location_counters
			self._current_location_type = best_location_type
			self._current_vector_type = vector_type

			if wants_new_location then
				self._wants_new_location = nil
				self._wants_new_combat_range = nil
			end
		elseif self._current_location then
			self:_check_and_release_location()

			combat_vector_component.has_position = false
			combat_vector_component.distance = 0
			self._current_vector_type = nil
		else
			combat_vector_component.has_position = false
			combat_vector_component.distance = 0
		end
	elseif current_location then
		local self_position = POSITION_LOOKUP[unit]
		local current_location_position = current_location.position:unbox()

		if not config.update_when_passive then
			local target_unit = perception_component.target_unit
			local target_position = POSITION_LOOKUP[target_unit]
			local current_to_target_distance = Vector3.distance(current_location_position, target_position)
			local self_to_target_distance = Vector3.distance(self_position, target_position)
			local combat_vector_is_closer = current_to_target_distance < self_to_target_distance

			combat_vector_component.combat_vector_is_closer = combat_vector_is_closer
		end

		combat_vector_component.distance = Vector3.distance(self_position, current_location_position)
	end
end

CombatVectorUserExtension._check_and_release_location = function (self)
	if self._current_location then
		self._current_location.claimed = false
		self._current_location = nil
	end

	if self._current_location_type then
		local location_counters = self._claimed_location_counters

		location_counters[self._current_location_type] = location_counters[self._current_location_type] - 1
		self._current_location_type = nil
	end
end

CombatVectorUserExtension.get_vector_type = function (self)
	return self._current_vector_type
end

return CombatVectorUserExtension
