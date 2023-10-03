local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CoverSettings = require("scripts/settings/cover/cover_settings")
local CombatVectorSettings = require("scripts/settings/combat_vector/combat_vector_settings")
local CoverUserExtension = class("CoverUserExtension")
local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

CoverUserExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._combat_vector_system = Managers.state.extension:system("combat_vector_system")
	self._cover_system = Managers.state.extension:system("cover_system")
	self._side_system = Managers.state.extension:system("side_system")
	self._unit = unit
	local blackboard = BLACKBOARDS[unit]
	local breed = extension_init_data.breed

	self:_init_blackboard_components(blackboard, breed)

	self._cover_config = breed.cover_config
	local side_id = extension_init_data.side_id
	self._side_id = side_id
	self._nav_world = extension_init_context.nav_world
end

CoverUserExtension._init_blackboard_components = function (self, blackboard, breed)
	local cover_component = Blackboard.write_component(blackboard, "cover")

	cover_component.position:store(0, 0, 0)
	cover_component.navmesh_position:store(0, 0, 0)
	cover_component.direction:store(0, 0, 0)

	cover_component.has_cover = false
	cover_component.is_in_cover = false
	cover_component.type = ""
	cover_component.peek_type = ""
	cover_component.distance_to_cover = 0
	self._behavior_component = blackboard.behavior
	self._cover_component = cover_component
	self._perception_component = blackboard.perception

	if breed.suppress_config then
		self._suppression_component = blackboard.suppression
	end
end

CoverUserExtension.extensions_ready = function (self, world, unit)
	self._combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")
	self._perception_extension = ScriptUnit.extension(unit, "perception_system")
end

CoverUserExtension.update = function (self, unit, dt, t)
	local cover_config = self._cover_config
	local perception_component = self._perception_component

	if not cover_config.ignore_aggro_requirement then
		local is_aggroed = perception_component.aggro_state == "aggroed"
		local target_unit = perception_component.target_unit

		if not ALIVE[target_unit] or not is_aggroed then
			return
		end
	end

	local behavior_component = self._behavior_component
	local combat_range = behavior_component.combat_range
	local combat_range_uses_cover = cover_config.cover_combat_ranges[combat_range]

	if not combat_range_uses_cover then
		return
	end

	local has_line_of_sight = perception_component.has_line_of_sight
	local max_distance_modifier_duration = cover_config.max_distance_modifier_duration

	if max_distance_modifier_duration and ALIVE[perception_component.target_unit] then
		local target_unit = perception_component.target_unit

		if self._old_target_unit ~= target_unit then
			self._old_target_unit = target_unit
			self._max_distance_modifier = 1
			self._max_distance_modifier_timer = t + max_distance_modifier_duration
		elseif has_line_of_sight then
			local time_diff = t - self._last_t
			self._max_distance_modifier_timer = self._max_distance_modifier_timer + time_diff
		else
			local time_diff = max_distance_modifier_duration - (self._max_distance_modifier_timer - t)
			local percentage = math.min(time_diff / max_distance_modifier_duration, 1)
			local max_distance_modifier_percentage = cover_config.max_distance_modifier_percentage
			self._max_distance_modifier = 1 - max_distance_modifier_percentage * percentage
		end
	end

	local leave_cover_after_losing_los = false
	local leave_cover_after_losing_los_duration = cover_config.leave_cover_after_losing_los_duration

	if leave_cover_after_losing_los_duration then
		if not self._leave_cover_after_losing_los_duration and not has_line_of_sight then
			self._leave_cover_after_losing_los_duration = t + leave_cover_after_losing_los_duration
		elseif self._leave_cover_after_losing_los_duration then
			if has_line_of_sight then
				self._leave_cover_after_losing_los_duration = nil
			elseif self._leave_cover_after_losing_los_duration < t then
				leave_cover_after_losing_los = true
			end
		end

		if leave_cover_after_losing_los then
			if self._current_cover_slot then
				self:release_cover_slot()
			end

			self._last_t = t

			return
		end
	end

	if self._reaction_time and self._reaction_time > 0 then
		self._reaction_time = self._reaction_time - dt
	else
		local cover_component = self._cover_component
		local need_to_find_cover = not cover_component.has_cover

		if need_to_find_cover then
			local target_unit = perception_component.target_unit
			local cover_slot = self:_find_cover_slot(unit, cover_config, target_unit, t)

			if cover_slot then
				self:_claim_cover_slot(cover_slot)
			elseif self._max_distance_modifier_timer then
				self._max_distance_modifier = 1
				self._max_distance_modifier_timer = t + max_distance_modifier_duration
			end
		else
			local current_cover_slot = self._current_cover_slot
			local cover_slot_is_valid = self:_validate_cover_slot(current_cover_slot, cover_config, t)

			if not cover_slot_is_valid then
				if cover_config.reaction_time_range and not self._reaction_time then
					local reaction_time = math.random_range(cover_config.reaction_time_range[1], cover_config.reaction_time_range[2])
					self._reaction_time = reaction_time
				else
					self._reaction_time = nil

					self:release_cover_slot()
				end
			else
				local current_cover_position = current_cover_slot.navmesh_position:unbox()
				local distance = Vector3.distance(POSITION_LOOKUP[unit], current_cover_position)
				cover_component.distance_to_cover = distance
			end
		end
	end

	self._last_t = t
end

local tg_on_claim_cover_slot_data = {}

CoverUserExtension._claim_cover_slot = function (self, cover_slot)
	local cover_component = self._cover_component
	local cover_slot_position = cover_slot.position
	local cover_slot_navmesh_position = cover_slot.navmesh_position
	local cover_slot_direction = cover_slot.direction
	local cover_slot_type = cover_slot.type
	local cover_slot_peek_type = cover_slot.peek_type
	cover_component.has_cover = true

	cover_component.position:store(cover_slot_position:unbox())
	cover_component.navmesh_position:store(cover_slot_navmesh_position:unbox())
	cover_component.direction:store(cover_slot_direction:unbox())

	cover_component.type = cover_slot_type
	cover_component.peek_type = cover_slot_peek_type
	cover_slot.occupied = true
	self._current_cover_slot = cover_slot
	self._current_cover_slot_id = cover_slot.id
	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
		table.clear(tg_on_claim_cover_slot_data)

		tg_on_claim_cover_slot_data.unit = self._unit

		Managers.event:trigger("tg_on_claim_cover_slot", tg_on_claim_cover_slot_data)
	end
end

CoverUserExtension._find_cover_slot = function (self, unit, cover_config, target_unit, t)
	local cover_system = self._cover_system
	local search_sources = CoverSettings.user_search_sources
	local search_source = cover_config.search_source
	local search_position = nil

	if search_source == search_sources.from_self then
		search_position = POSITION_LOOKUP[unit]
	elseif search_source == search_sources.from_target then
		search_position = POSITION_LOOKUP[target_unit]
	elseif search_source == search_sources.from_combat_vector_start then
		local combat_vector_system = self._combat_vector_system
		search_position = combat_vector_system:get_from_position()
	end

	local radius = nil
	local suppressed_search_radius = cover_config.suppressed_search_radius
	local suppression_component = self._suppression_component
	local is_suppressed = suppression_component and suppression_component.is_suppressed

	if suppressed_search_radius and is_suppressed then
		radius = suppressed_search_radius
	else
		radius = cover_config.search_radius
	end

	local nearby_cover_slots = cover_system:find_cover_slots(search_position, radius)
	local best_cover_slot = nil
	local num_nearby_cover_slots = #nearby_cover_slots

	for i = 1, num_nearby_cover_slots do
		local cover_slot = nearby_cover_slots[i]

		if not cover_slot.occupied then
			local cover_slot_is_valid = self:_validate_cover_slot(cover_slot, cover_config, t)

			if cover_slot_is_valid then
				best_cover_slot = cover_slot
				local suppressed_search_sticky_time = cover_config.suppressed_search_sticky_time

				if is_suppressed and suppressed_search_sticky_time then
					best_cover_slot.sticky_time = t + math.random_range(suppressed_search_sticky_time[1], suppressed_search_sticky_time[2])
				end

				break
			end
		end
	end

	return best_cover_slot
end

local DEFAULT_MAX_DISTANCE_FROM_COMBAT_VECTOR_TYPE = "to"

CoverUserExtension._validate_cover_slot = function (self, cover_slot, cover_config, t)
	local disabled = cover_slot.disabled

	if disabled then
		return false
	end

	local disable_t = cover_slot.disable_t

	if disable_t and t < disable_t then
		return false
	end

	local sticky_time = cover_slot.sticky_time

	if sticky_time and t < sticky_time then
		return true
	end

	local optional_wanted_cover_type = cover_config.optional_wanted_cover_type

	if optional_wanted_cover_type and cover_slot.type ~= optional_wanted_cover_type then
		return false
	end

	local suppression_component = self._suppression_component
	local is_suppressed = suppression_component and suppression_component.is_suppressed
	local perception_component = self._perception_component
	local current_target_unit = perception_component.target_unit

	if ALIVE[current_target_unit] then
		local cover_slot_position = cover_slot.position:unbox()
		local max_distance_from_target = is_suppressed and cover_config.suppressed_max_distance_from_target or cover_config.max_distance_from_target

		if max_distance_from_target then
			local max_distance_modified = self._max_distance_modifier and max_distance_from_target * self._max_distance_modifier or max_distance_from_target
			local target_position = POSITION_LOOKUP[current_target_unit]
			local distance_to_slot = Vector3.distance(cover_slot_position, target_position)

			if max_distance_modified < distance_to_slot then
				return false
			end
		end

		local min_distance_from_target = cover_config.min_distance_from_target

		if min_distance_from_target then
			local target_position = POSITION_LOOKUP[current_target_unit]
			local distance_to_slot = Vector3.distance(cover_slot_position, target_position)

			if distance_to_slot < min_distance_from_target then
				return false
			end
		end
	end

	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if is_main_path_available then
		local combat_vector_system = self._combat_vector_system
		local current_vector_type = self._combat_vector_extension:get_vector_type()
		local combat_vector_direction = nil

		if current_vector_type and current_vector_type ~= CombatVectorSettings.vector_types.main then
			combat_vector_direction = combat_vector_system:get_flank_direction(current_vector_type)
		else
			combat_vector_direction = combat_vector_system:get_combat_direction()
		end

		local cover_slot_position = cover_slot.position:unbox()
		local max_distance_from_combat_vector = is_suppressed and cover_config.suppressed_max_distance_from_combat_vector or cover_config.max_distance_from_combat_vector

		if max_distance_from_combat_vector then
			local max_distance_from_combat_vector_type = cover_config.max_distance_from_combat_vector_type or DEFAULT_MAX_DISTANCE_FROM_COMBAT_VECTOR_TYPE
			local combat_vector_position = combat_vector_system:get_to_position(current_vector_type)

			if max_distance_from_combat_vector_type == "to" then
				combat_vector_position = combat_vector_system:get_to_position(current_vector_type)
			elseif max_distance_from_combat_vector_type == "from" then
				combat_vector_position = combat_vector_system:get_from_position()
			end

			local distance_to_combat_vector = Vector3.distance(cover_slot_position, combat_vector_position)

			if max_distance_from_combat_vector < distance_to_combat_vector then
				return false
			end
		end

		if ALIVE[current_target_unit] then
			local max_distance_from_target_z = cover_config.max_distance_from_target_z

			if max_distance_from_target_z then
				local target_position = POSITION_LOOKUP[current_target_unit]
				local z_distance = math.abs(target_position.z - cover_slot_position.z)

				if max_distance_from_target_z < z_distance then
					return false
				end
			end

			local max_distance_from_target_z_below = cover_config.max_distance_from_target_z_below

			if max_distance_from_target_z_below then
				local target_position = POSITION_LOOKUP[current_target_unit]
				local z_distance = cover_slot_position.z - target_position.z

				if max_distance_from_target_z_below > z_distance then
					return false
				end
			end
		end

		if combat_vector_direction then
			local invert_cover_direction = cover_config.invert_cover_direction

			if invert_cover_direction then
				combat_vector_direction = -combat_vector_direction
			end

			local slot_direction = cover_slot.direction:unbox()
			local dot = Vector3.dot(-combat_vector_direction, slot_direction)

			if dot < CoverSettings.flanking_cover_dot then
				return false
			end
		end
	end

	local side_id = self._side_id
	local side_system = self._side_system
	local side = side_system:get_side(side_id)
	local valid_enemy_player_units = side.valid_enemy_player_units
	local perception_extension = self._perception_extension

	for i = 1, #valid_enemy_player_units do
		local target_unit = valid_enemy_player_units[i]
		local last_los_position = perception_extension:last_los_position(target_unit)

		if last_los_position then
			local cover_slot_position = cover_slot.position:unbox()
			local slot_direction = cover_slot.direction:unbox()
			local slot_to_target = Vector3.normalize(last_los_position - cover_slot_position)
			local dot = Vector3.dot(slot_to_target, slot_direction)

			if dot < CoverSettings.flanking_cover_dot then
				return false
			end
		end
	end

	if cover_config.dot_against_current_target and ALIVE[current_target_unit] then
		local cover_slot_position = cover_slot.position:unbox()
		local slot_direction = cover_slot.direction:unbox()
		local slot_to_target = Vector3.normalize(POSITION_LOOKUP[current_target_unit] - cover_slot_position)
		local dot = Vector3.dot(slot_to_target, slot_direction)

		if dot < CoverSettings.flanking_cover_dot then
			return false
		end
	end

	return true
end

CoverUserExtension.release_cover_slot = function (self, optional_cover_disable_t)
	local current_cover_slot = self._current_cover_slot

	if current_cover_slot then
		local cover_component = self._cover_component
		cover_component.has_cover = false
		cover_component.is_in_cover = false
		current_cover_slot.occupied = false

		if optional_cover_disable_t then
			local t = Managers.time:time("gameplay")
			current_cover_slot.disable_t = t + optional_cover_disable_t
		end
	end

	self._current_cover_slot = nil
	self._current_cover_slot_id = nil
end

CoverUserExtension.cover_slot_id = function (self)
	return self._cover_slot_id
end

CoverUserExtension.has_claimed_cover_slot = function (self)
	return not not self._current_cover_slot
end

return CoverUserExtension
