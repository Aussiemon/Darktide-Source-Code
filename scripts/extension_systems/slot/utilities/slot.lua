-- chunkname: @scripts/extension_systems/slot/utilities/slot.lua

local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local SlotPosition = require("scripts/extension_systems/slot/utilities/slot_position")
local SlotSystemSettings = require("scripts/settings/slot/slot_system_settings")
local SlotTypeSettings = require("scripts/settings/slot/slot_type_settings")
local Vo = require("scripts/utilities/vo")
local GwNavQueries_raycango, GwNavQueries_triangle_from_position = GwNavQueries.raycango, GwNavQueries.triangle_from_position
local NavQueries_position_on_mesh, NavQueries_ray_can_go_projected = NavQueries.position_on_mesh, NavQueries.ray_can_go_projected
local SlotPosition_rotated_around_origin = SlotPosition.rotated_around_origin
local Quaternion_rotate, QuaternionBox_unbox = Quaternion.rotate, QuaternionBox.unbox
local Vector3_distance, Vector3_distance_squared = Vector3.distance, Vector3.distance_squared
local Vector3_dot, Vector3_flat = Vector3.dot, Vector3.flat
local Vector3_length, Vector3_length_squared = Vector3.length, Vector3.length_squared
local Vector3_normalize = Vector3.normalize
local Vector3Box_unbox, Vector3Box_store = Vector3Box.unbox, Vector3Box.store
local math_ceil, math_floor, math_max, math_min = math.ceil, math.floor, math.max, math.min
local math_degrees_to_radians, math_sqrt, table_clear = math.degrees_to_radians, math.sqrt, table.clear
local Slot = {}
local SLOT_TYPES = {}
local EDGE_ROTATION_BOXES = {}
local MAX_OVERLAP_RADIUS = 0

for slot_type, setting in pairs(SlotTypeSettings) do
	SLOT_TYPES[#SLOT_TYPES + 1] = slot_type

	local radians_per_slot = math_degrees_to_radians(360 / setting.count)

	EDGE_ROTATION_BOXES[slot_type] = {
		right = QuaternionBox(Quaternion(Vector3.down(), radians_per_slot)),
		left = QuaternionBox(Quaternion(Vector3.down(), -radians_per_slot)),
	}

	if MAX_OVERLAP_RADIUS < setting.radius then
		MAX_OVERLAP_RADIUS = setting.radius
	end
end

local NUM_SLOT_TYPES = #SLOT_TYPES

Slot.create_slots = function (target_unit)
	local check_middle_index = SlotSystemSettings.slot_position_check_index.check_middle
	local all_slots = Script.new_map(NUM_SLOT_TYPES)

	for slot_type, setting in pairs(SlotTypeSettings) do
		local total_slots_count = setting.count
		local slots = Script.new_array(total_slots_count)

		for i = 1, total_slots_count do
			local slot = {
				anchor_weight = 0,
				has_ghost_position = false,
				target_unit = target_unit,
				queue = {},
				original_absolute_position = Vector3Box(0, 0, 0),
				absolute_position = Vector3Box(0, 0, 0),
				ghost_position = Vector3Box(0, 0, 0),
				queue_position = Vector3Box(0, 0, 0),
				index = i,
				type = slot_type,
				priority = setting.priority,
				position_check_index = check_middle_index,
			}

			slots[i] = slot
		end

		local slot_data = {
			disabled_slots_count = 0,
			slots_count = 0,
			total_slots_count = total_slots_count,
			slots = slots,
		}

		all_slots[slot_type] = slot_data
	end

	return all_slots
end

Slot.remove = function (slot, unit_extension_data)
	local user_unit = slot.user_unit

	if user_unit then
		local user_slot_extension = unit_extension_data[user_unit]

		user_slot_extension.slot = nil
	end

	local queue = slot.queue
	local queue_n = #queue

	for i = 1, queue_n do
		local waiting_user_unit = queue[i]
		local waiting_user_slot_extension = unit_extension_data[waiting_user_unit]

		waiting_user_slot_extension.wait_slot = nil
	end

	local target_unit = slot.target_unit
	local target_slot_extension = unit_extension_data[target_unit]
	local slot_type, slot_index = slot.type, slot.index
	local slot_data = target_slot_extension.all_slots[slot_type]
	local slots = slot_data.slots
	local slots_n = #slots

	slots[slot_index] = slots[slots_n]
	slots[slot_index].index = slot_index
	slots[slots_n] = nil
end

local function _slots_count(slot_data)
	local slots_n = 0
	local slots = slot_data.slots
	local total_slots_count = slot_data.total_slots_count

	for i = 1, total_slots_count do
		local slot = slots[i]

		if slot.user_unit then
			slots_n = slots_n + 1
		end

		slots_n = slots_n + #slot.queue
	end

	return slots_n
end

Slot.detach_user_unit = function (user_unit, user_slot_extension, unit_extension_data)
	local slot, waiting_on_slot = user_slot_extension.slot, user_slot_extension.wait_slot

	if slot then
		local queue = slot.queue
		local queue_n = #queue

		slot.user_unit = nil

		local slot_type = slot.type

		for i = queue_n, 1, -1 do
			local user_unit_waiting = queue[i]
			local user_unit_waiting_extension = unit_extension_data[user_unit_waiting]

			if user_unit_waiting_extension.use_slot_type == slot_type then
				slot.user_unit = user_unit_waiting
				user_unit_waiting_extension.slot = slot
				user_unit_waiting_extension.wait_slot = nil
				queue[i] = queue[queue_n]
				queue[queue_n] = nil

				break
			end
		end

		local target_unit = slot.target_unit
		local target_slot_extension = unit_extension_data[target_unit]
		local slot_data = target_slot_extension.all_slots[slot_type]

		slot_data.slots_count = _slots_count(slot_data)
	elseif waiting_on_slot then
		local queue = waiting_on_slot.queue
		local queue_n = #queue

		for i = 1, queue_n do
			local user_unit_waiting = queue[i]

			if user_unit_waiting == user_unit then
				queue[i] = queue[queue_n]
				queue[queue_n] = nil

				break
			end
		end

		local target_unit = waiting_on_slot.target_unit
		local target_slot_extension = unit_extension_data[target_unit]
		local slot_type = waiting_on_slot.type
		local slot_data = target_slot_extension.all_slots[slot_type]

		slot_data.slots_count = _slots_count(slot_data)
	end

	user_slot_extension.wait_slot = nil
	user_slot_extension.slot = nil
end

local _abs_pos_cache = {}
local _target_pos_cache = {}
local _queue_dir_cache = {}
local _right_pos_cache = {}
local _left_pos_cache = {}
local _offset_move_direction, _offset_speed

local function _cached_absolute_position(slot)
	local pos = _abs_pos_cache[slot]

	if not pos then
		pos = Vector3Box_unbox(slot.absolute_position)
		_abs_pos_cache[slot] = pos
	end

	return pos
end

local function _cached_target_position(target_unit_extension)
	local pos = _target_pos_cache[target_unit_extension]

	if not pos then
		pos = Vector3Box_unbox(target_unit_extension.position)
		_target_pos_cache[target_unit_extension] = pos
	end

	return pos
end

local function _clear_caches()
	table_clear(_abs_pos_cache)
	table_clear(_target_pos_cache)
	table_clear(_queue_dir_cache)
	table_clear(_right_pos_cache)
	table_clear(_left_pos_cache)

	_offset_move_direction = nil
	_offset_speed = nil
end

local function _set_slot_edge_positions(slot, target_unit_position)
	local slot_absolute_position = Vector3Box_unbox(slot.original_absolute_position)
	local direction_vector = Vector3_normalize(Vector3_flat(slot_absolute_position - target_unit_position))
	local rotations = EDGE_ROTATION_BOXES[slot.type]
	local slot_distance = SlotTypeSettings[slot.type].distance

	_right_pos_cache[slot] = target_unit_position + Quaternion_rotate(QuaternionBox_unbox(rotations.right), direction_vector) * slot_distance
	_left_pos_cache[slot] = target_unit_position + Quaternion_rotate(QuaternionBox_unbox(rotations.left), direction_vector) * slot_distance
end

local function _set_slot_absolute_position(slot, position, target_unit_extension, update_edges)
	local target_position = _cached_target_position(target_unit_extension)
	local flat_direction = Vector3_normalize(Vector3_flat(position - target_position))

	Vector3Box_store(slot.absolute_position, position)

	_abs_pos_cache[slot] = position
	_queue_dir_cache[slot] = flat_direction

	if update_edges then
		_set_slot_edge_positions(slot, target_position)
	end
end

local function _offset_slot(slot_absolute_position, target_unit_position)
	if not _offset_move_direction then
		return slot_absolute_position
	end

	local wanted_slot_offset = _offset_move_direction * _offset_speed
	local slot_to_target_dir = Vector3_normalize(target_unit_position - slot_absolute_position)
	local dot = Vector3_dot(slot_to_target_dir, _offset_move_direction)
	local predict_time = math_max(2 * (dot - 0.5), 0)
	local current_slot_offset = wanted_slot_offset * predict_time
	local slot_offset_position = slot_absolute_position + current_slot_offset

	return slot_offset_position
end

local function _get_slot_position_on_navmesh(target_unit_extension, target_position, wanted_position, radians, distance, should_offset_slot, nav_world, above, below, traverse_logic)
	local original_position = radians and SlotPosition_rotated_around_origin(target_position, wanted_position, radians, distance) or wanted_position
	local offsetted_position = should_offset_slot and _offset_slot(original_position, target_position) or original_position
	local position_on_navmesh = NavQueries_position_on_mesh(nav_world, offsetted_position, above, below, traverse_logic)

	return position_on_navmesh, original_position
end

local function _get_slot_position_on_navmesh_from_outside_target(target_position, slot_direction, radians, distance, nav_world, traverse_logic, above, below)
	local position_on_navmesh
	local max_tries = 10
	local dist_per_try = 0.15

	if radians then
		local rotation = Quaternion(-Vector3.up(), radians)

		slot_direction = Quaternion_rotate(rotation, slot_direction)
	end

	for i = 0, max_tries - 1 do
		local wanted_position = target_position + slot_direction * (i * dist_per_try + distance)

		position_on_navmesh = NavQueries_position_on_mesh(nav_world, wanted_position, above, below, traverse_logic)

		if position_on_navmesh then
			break
		end
	end

	return position_on_navmesh, position_on_navmesh
end

local function _get_reachable_slot_position_on_navmesh(slot, target_unit_extension, target_position, wanted_position, radians, distance, should_offset_slot, nav_world, traverse_logic, above, below)
	local position_on_navmesh, original_position = _get_slot_position_on_navmesh(target_unit_extension, target_position, wanted_position, radians, distance, should_offset_slot, nav_world, above, below, traverse_logic)
	local check_index = slot.position_check_index
	local check_middle_index = SlotSystemSettings.slot_position_check_index.check_middle
	local is_using_middle_check = check_index == check_middle_index
	local check_radians = not is_using_middle_check and SlotSystemSettings.slot_position_check_radians[check_index] or nil
	local raycango_offset = SlotSystemSettings.slot_position_check_raycango_offset
	local default_slot_radius = SlotTypeSettings.normal.radius

	if position_on_navmesh then
		local check_position

		if is_using_middle_check then
			check_position = position_on_navmesh
		else
			check_position = SlotPosition_rotated_around_origin(position_on_navmesh, target_position, check_radians, default_slot_radius)
		end

		local ray_target_pos = target_position + Vector3_normalize(check_position - target_position) * raycango_offset
		local ray_can_go = GwNavQueries_raycango(nav_world, check_position, ray_target_pos, traverse_logic)

		if not ray_can_go then
			position_on_navmesh = nil
		end
	elseif not is_using_middle_check then
		local check_position = SlotPosition_rotated_around_origin(wanted_position, target_position, check_radians, default_slot_radius)

		position_on_navmesh, original_position = _get_slot_position_on_navmesh(target_unit_extension, target_position, check_position, radians, distance, should_offset_slot, nav_world, above, below, traverse_logic)

		if position_on_navmesh then
			local ray_target_pos = target_position + Vector3_normalize(position_on_navmesh - target_position) * raycango_offset
			local ray_can_go = GwNavQueries_raycango(nav_world, position_on_navmesh, ray_target_pos, traverse_logic)

			if ray_can_go then
				slot.position_check_index = check_middle_index
			else
				position_on_navmesh = nil
			end
		end
	end

	if not position_on_navmesh then
		slot.position_check_index = (slot.position_check_index + 1) % SlotSystemSettings.slot_position_check_index_size
	end

	return position_on_navmesh, original_position
end

local function _overlap_with_other_target_slot(slot, target_units, unit_extension_data)
	local slot_target_unit = slot.target_unit
	local slot_position = _cached_absolute_position(slot)
	local target_units_n = #target_units

	for i = 1, target_units_n do
		repeat
			local target_unit = target_units[i]

			if target_unit == slot_target_unit then
				break
			end

			local target_unit_extension = unit_extension_data[target_unit]
			local bound = target_unit_extension.slots_bound

			if bound and Vector3_distance_squared(slot_position, _cached_target_position(target_unit_extension)) > bound * bound then
				break
			end

			local all_slots = target_unit_extension.all_slots

			for j = 1, NUM_SLOT_TYPES do
				local slot_type = SLOT_TYPES[j]
				local slot_data = all_slots[slot_type]
				local radius = SlotTypeSettings[slot_type].radius
				local overlap_distance_sq = radius * radius
				local target_slots = slot_data.slots
				local total_slots_count = slot_data.total_slots_count

				for k = 1, total_slots_count do
					repeat
						local target_slot = target_slots[k]

						if target_slot.disabled then
							break
						end

						local target_slot_position = _cached_absolute_position(target_slot)
						local distance_squared = Vector3_distance_squared(slot_position, target_slot_position)

						if distance_squared < overlap_distance_sq then
							return target_slot
						end
					until true
				end
			end
		until true
	end

	return false
end

local function _overlap_with_own_slots(slot, unit_extension_data)
	local slot_a_position = _cached_absolute_position(slot)
	local slot_a_type = slot.type
	local target_unit = slot.target_unit
	local target_unit_extension = unit_extension_data[target_unit]
	local all_slots = target_unit_extension.all_slots

	for i = 1, NUM_SLOT_TYPES do
		repeat
			local slot_b_type = SLOT_TYPES[i]
			local slot_data = all_slots[slot_b_type]

			if slot_a_type == slot_b_type then
				break
			end

			local slot_b_radius = SlotTypeSettings[slot_b_type].radius
			local overlap_distance_sq = slot_b_radius * slot_b_radius
			local slots = slot_data.slots
			local num_slots = slot_data.total_slots_count

			for j = 1, num_slots do
				repeat
					local slot_b = slots[j]

					if slot_b.disabled then
						break
					end

					local user_unit_b = slot_b.user_unit

					if not user_unit_b then
						break
					end

					local slot_b_position = _cached_absolute_position(slot_b)
					local distance_squared = Vector3_distance_squared(slot_a_position, slot_b_position)

					if distance_squared < overlap_distance_sq then
						return slot_b
					end
				until true
			end
		until true
	end

	return false
end

local function _overlap_with_other_target(slot, target_units, unit_extension_data)
	local slot_target_unit = slot.target_unit
	local slot_position = _cached_absolute_position(slot)
	local target_units_n = #target_units
	local overlap_slot_to_target_distance_sq = SlotSystemSettings.overlap_slot_to_target_distance_sq

	for i = 1, target_units_n do
		repeat
			local target_unit = target_units[i]

			if target_unit == slot_target_unit then
				break
			end

			local target_unit_position = _cached_target_position(unit_extension_data[target_unit])
			local distance_squared = Vector3_distance_squared(slot_position, target_unit_position)

			if distance_squared < overlap_slot_to_target_distance_sq then
				return true
			end
		until true
	end

	return false
end

local function _disable_slot(slot, unit_extension_data)
	local user_unit = slot.user_unit

	if user_unit then
		local queue = slot.queue
		local queue_n = #queue

		for i = 1, queue_n do
			local user_unit_waiting = queue[i]
			local user_unit_waiting_extension = unit_extension_data[user_unit_waiting]

			user_unit_waiting_extension.wait_slot = nil
			queue[i] = nil
		end

		local user_unit_extension = unit_extension_data[user_unit]

		Slot.detach_user_unit(user_unit, user_unit_extension, unit_extension_data)
	end

	slot.disabled = true
	slot.queue_slot_disabled = true
	slot.released = false
end

local function _enable_slot(slot)
	slot.disabled = false
end

local function _disable_overlaping_slot(slot, overlap_slot, unit_extension_data)
	local slot_priority = slot.priority
	local overlap_slot_priority = overlap_slot.priority
	local target_unit = slot.target_unit
	local target_unit_extension = unit_extension_data[target_unit]
	local target_index = target_unit_extension.index
	local slot_index = slot.index
	local overlap_target_unit = overlap_slot.target_unit
	local overlap_target_unit_extension = unit_extension_data[overlap_target_unit]
	local overlap_target_index = overlap_target_unit_extension.index
	local overlap_slot_index = overlap_slot.index

	if slot_priority < overlap_slot_priority and not slot.user_unit then
		return false
	elseif overlap_slot_priority < slot_priority and not overlap_slot.user_unit then
		return false
	end

	if slot_priority < overlap_slot_priority then
		_disable_slot(overlap_slot, unit_extension_data)

		return false
	elseif overlap_slot_priority < slot_priority then
		_disable_slot(slot, unit_extension_data)

		return true
	end

	if overlap_slot_index < slot_index then
		_disable_slot(slot, unit_extension_data)

		return true
	end

	if slot_index < overlap_slot_index then
		_disable_slot(overlap_slot, unit_extension_data)

		return false
	end

	if overlap_target_index < target_index then
		_disable_slot(slot, unit_extension_data)

		return true
	else
		_disable_slot(overlap_slot, unit_extension_data)

		return false
	end
end

Slot.is_behind_target = function (slot, user_unit, target_unit_extension)
	local slot_position = Vector3Box_unbox(slot.original_absolute_position)
	local user_unit_position = POSITION_LOOKUP[user_unit]
	local target_unit_position = Vector3Box_unbox(target_unit_extension.position)
	local flat_target_unit_to_slot_vector = Vector3_flat(slot_position - target_unit_position)
	local normalized_target_unit_to_slot_vector = Vector3_normalize(flat_target_unit_to_slot_vector)
	local flat_target_unit_to_user_unit_vector = Vector3_flat(user_unit_position - target_unit_position)
	local normalized_target_unit_to_user_unit_vector = Vector3_normalize(flat_target_unit_to_user_unit_vector)
	local dot_value = Vector3_dot(normalized_target_unit_to_slot_vector, normalized_target_unit_to_user_unit_vector)

	return dot_value < 0.5, dot_value
end

local function _normalized_target_to_user(user_unit, target_unit_position)
	local user_unit_position = POSITION_LOOKUP[user_unit]

	return Vector3_normalize(Vector3_flat(user_unit_position - target_unit_position))
end

local function _is_slot_behind_target(slot_position, target_unit_position, normalized_target_to_user)
	local flat_target_unit_to_slot_vector = Vector3_flat(slot_position - target_unit_position)
	local normalized_target_unit_to_slot_vector = Vector3_normalize(flat_target_unit_to_slot_vector)
	local dot_value = Vector3_dot(normalized_target_unit_to_slot_vector, normalized_target_to_user)

	return dot_value < 0.5
end

Slot.clear_ghost_position = function (slot)
	Vector3Box_store(slot.ghost_position, Vector3(0, 0, 0))

	slot.has_ghost_position = false
end

Slot.set_ghost_position = function (target_unit_extension, slot, nav_world, traverse_logic)
	local slot_position = Vector3Box_unbox(slot.absolute_position)
	local user_unit = slot.user_unit
	local user_unit_position = POSITION_LOOKUP[user_unit]
	local target_unit_position = Vector3Box_unbox(target_unit_extension.position)
	local distance = math_min(Vector3_distance(target_unit_position, user_unit_position), SlotSystemSettings.ghost_position_distance)
	local ghost_radians = SlotSystemSettings.slot_ghost_radians
	local above, below = SlotSystemSettings.z_max_difference_above, SlotSystemSettings.z_max_difference_below
	local ghost_position_left = SlotPosition_rotated_around_origin(slot_position, user_unit_position, -ghost_radians, distance)
	local ghost_position_right = SlotPosition_rotated_around_origin(slot_position, user_unit_position, ghost_radians, distance)
	local distance_ghost_position_left = Vector3_distance_squared(target_unit_position, ghost_position_left)
	local distance_ghost_position_right = Vector3_distance_squared(target_unit_position, ghost_position_right)
	local use_ghost_position_left = distance_ghost_position_right < distance_ghost_position_left
	local ghost_position = use_ghost_position_left and ghost_position_left or ghost_position_right
	local ghost_position_on_navmesh = NavQueries_position_on_mesh(nav_world, ghost_position, above, below, traverse_logic)
	local ghost_position_direction

	if ghost_position_on_navmesh then
		ghost_position_direction = Vector3_normalize(ghost_position_on_navmesh - slot_position)
	else
		ghost_position_direction = Vector3_normalize(ghost_position - slot_position)
	end

	local max_tries = 5
	local slot_type = slot.type
	local slot_distance = SlotTypeSettings[slot_type].distance

	for i = 1, max_tries do
		if ghost_position_on_navmesh then
			local ray_can_go = GwNavQueries_raycango(nav_world, ghost_position_on_navmesh, slot_position, traverse_logic)

			if ray_can_go then
				Vector3Box_store(slot.ghost_position, ghost_position_on_navmesh)

				slot.has_ghost_position = true

				return
			end
		end

		local ghost_position_distance = slot_distance + (distance - slot_distance) * (max_tries - i) / max_tries

		ghost_position = target_unit_position + ghost_position_direction * ghost_position_distance
		ghost_position_on_navmesh = NavQueries_position_on_mesh(nav_world, ghost_position, above, below, traverse_logic)
	end

	Slot.clear_ghost_position(slot)
end

local function _update_slot_anchor_weight(slot, target_slots, total_slots_count)
	local slot_index = slot.index
	local score = 128
	local slot_valid = slot.user_unit and not slot.released

	slot.anchor_weight = slot_valid and 256 or 0

	for i = 1, total_slots_count do
		local index = slot_index + i

		if total_slots_count < index then
			index = index - total_slots_count
		end

		local slot_right = target_slots[index]
		local slot_disabled = slot_right.disabled
		local user_unit = slot_right.user_unit

		if slot_disabled or not user_unit then
			break
		end

		local slot_released = slot_right.released

		if not slot_released then
			slot.anchor_weight = slot.anchor_weight + score
			score = score / 2
		end
	end

	score = 128

	for i = 1, total_slots_count do
		local index = slot_index - i

		if index < 1 then
			index = index + total_slots_count
		end

		local slot_left = target_slots[index]
		local slot_disabled = slot_left.disabled
		local user_unit = slot_left.user_unit

		if slot_disabled or not user_unit then
			break
		end

		local slot_released = slot_left.released

		if not slot_released then
			slot.anchor_weight = slot.anchor_weight + score
			score = score / 2
		end
	end
end

local function _update_anchor_weights_for_type(slot_data)
	local target_slots = slot_data.slots
	local total_slots_count = slot_data.total_slots_count

	for j = 1, total_slots_count do
		local slot = target_slots[j]

		_update_slot_anchor_weight(slot, target_slots, total_slots_count)
	end
end

local function _update_anchor_weights(all_slots)
	for i = 1, NUM_SLOT_TYPES do
		local slot_type = SLOT_TYPES[i]
		local slot_data = all_slots[slot_type]

		_update_anchor_weights_for_type(slot_data)
	end
end

Slot.release_check = function (slot, unit_extension_data)
	if slot.disabled then
		return
	end

	local user_unit = slot.user_unit

	if not user_unit then
		slot.released = false

		return
	end

	local user_unit_extension = unit_extension_data[user_unit]
	local release_slot_lock = user_unit_extension.release_slot_lock

	if not release_slot_lock then
		local user_unit_position = POSITION_LOOKUP[user_unit]
		local slot_position = Vector3Box_unbox(slot.absolute_position)
		local distance_to_slot_position = Vector3_distance_squared(user_unit_position, slot_position)
		local slot_released = distance_to_slot_position > SlotSystemSettings.slot_release_distance_sq

		slot.released = slot_released
	else
		slot.released = false
	end
end

Slot.anchor = function (slot_type, target_unit, unit_extension_data)
	local target_unit_extension = unit_extension_data[target_unit]
	local slot_data = target_unit_extension.all_slots[slot_type]
	local target_slots = slot_data.slots
	local total_slots_count = slot_data.total_slots_count
	local best_slot = target_slots[1]
	local best_anchor_weight = best_slot.anchor_weight

	for i = 1, total_slots_count do
		repeat
			local slot = target_slots[i]
			local slot_disabled = slot.disabled

			if slot_disabled then
				break
			end

			local slot_anchor_weight = slot.anchor_weight

			if best_anchor_weight < slot_anchor_weight or slot_anchor_weight == best_anchor_weight and slot.index < best_slot.index then
				best_slot = slot
				best_anchor_weight = slot_anchor_weight
			end
		until true
	end

	return best_slot
end

local function _update_anchor_slot_position(target_unit_extension, slot, should_offset_slot, nav_world, traverse_logic, above, below, target_outside_navmesh, update_edges)
	local target_position = _cached_target_position(target_unit_extension)
	local user_unit = slot.user_unit
	local user_position = user_unit and POSITION_LOOKUP[user_unit]
	local direction_vector = user_unit and Vector3_normalize(user_position - target_position) or Vector3.forward()
	local slot_type = slot.type
	local slot_distance = SlotTypeSettings[slot_type].distance
	local wanted_position = target_position + direction_vector * slot_distance
	local position_on_navmesh, original_position

	if target_outside_navmesh then
		position_on_navmesh, original_position = _get_slot_position_on_navmesh_from_outside_target(target_position, direction_vector, nil, slot_distance, nav_world, traverse_logic, above, below)
	else
		position_on_navmesh, original_position = _get_reachable_slot_position_on_navmesh(slot, target_unit_extension, target_position, wanted_position, nil, nil, should_offset_slot, nav_world, traverse_logic, above, below)
	end

	local retrying = not position_on_navmesh

	if retrying then
		-- Nothing
	end

	local i = slot.anchor_retry_index or 0
	local max_get_slot_position_tries = SlotSystemSettings.slot_anchor_max_position_tries
	local max_tries_per_update = SlotSystemSettings.slot_anchor_max_position_tries_per_update
	local tries = 0

	while i <= max_get_slot_position_tries and tries < max_tries_per_update and not position_on_navmesh do
		local sign = i % 2 > 0 and -1 or 1
		local radians = math_ceil(i / 2) * sign

		if target_outside_navmesh then
			position_on_navmesh, original_position = _get_slot_position_on_navmesh_from_outside_target(target_position, direction_vector, radians, slot_distance, nav_world, traverse_logic, above, below)
		else
			position_on_navmesh, original_position = _get_reachable_slot_position_on_navmesh(slot, target_unit_extension, target_position, wanted_position, radians, slot_distance, should_offset_slot, nav_world, traverse_logic, above, below)
		end

		i = i + 1
		tries = tries + 1
	end

	if retrying then
		-- Nothing
	end

	slot.anchor_retry_index = nil

	if position_on_navmesh then
		Vector3Box_store(slot.original_absolute_position, original_position)
		_set_slot_absolute_position(slot, position_on_navmesh, target_unit_extension, update_edges)

		return true, position_on_navmesh
	elseif max_get_slot_position_tries < i then
		Vector3Box_store(slot.original_absolute_position, wanted_position)
		_set_slot_absolute_position(slot, wanted_position, target_unit_extension, update_edges)

		return false, wanted_position
	else
		local current_position = _cached_absolute_position(slot)
		local has_previous_position = Vector3_length_squared(current_position) > 0
		local current_on_navmesh = has_previous_position and GwNavQueries_triangle_from_position(nav_world, current_position, above, below, traverse_logic)

		if current_on_navmesh then
			slot.anchor_retry_index = i

			_set_slot_absolute_position(slot, current_position, target_unit_extension, update_edges)

			return true, current_position
		end

		Vector3Box_store(slot.original_absolute_position, wanted_position)
		_set_slot_absolute_position(slot, wanted_position, target_unit_extension, update_edges)

		return false, wanted_position
	end
end

local function _update_slot_position(target_unit_extension, slot, slot_position, should_offset_slot, nav_world, traverse_logic, above, below, target_outside_navmesh, update_edges)
	local target_position = _cached_target_position(target_unit_extension)
	local position_on_navmesh, original_position

	if target_outside_navmesh then
		local slot_type = slot.type
		local slot_distance = SlotTypeSettings[slot_type].distance

		position_on_navmesh, original_position = _get_slot_position_on_navmesh_from_outside_target(target_position, Vector3_normalize(slot_position - target_position), nil, slot_distance, nav_world, traverse_logic, above, below)
	else
		position_on_navmesh, original_position = _get_reachable_slot_position_on_navmesh(slot, target_unit_extension, target_position, slot_position, nil, nil, should_offset_slot, nav_world, traverse_logic, above, below)
	end

	if position_on_navmesh then
		Vector3Box_store(slot.original_absolute_position, original_position)
		_set_slot_absolute_position(slot, position_on_navmesh, target_unit_extension, update_edges)

		return true, position_on_navmesh
	else
		Vector3Box_store(slot.original_absolute_position, slot_position)
		_set_slot_absolute_position(slot, slot_position, target_unit_extension, update_edges)

		return false, slot_position
	end
end

local function _update_slot_queue_position_and_status(target_slot_extension, slot, unit_extension_data, nav_world, traverse_logic)
	local slot_position = _cached_absolute_position(slot)
	local slot_queue_direction = _queue_dir_cache[slot]
	local slot_type = slot.type
	local slot_queue_distance = SlotTypeSettings[slot_type].queue_distance
	local slot_queue_position = slot_position + slot_queue_direction * slot_queue_distance

	if slot.disabled then
		Vector3Box_store(slot.queue_position, slot_queue_position)

		return
	end

	local max_queue_z_diff_above, max_queue_z_diff_below = SlotSystemSettings.slot_queue_max_z_diff_above, SlotSystemSettings.slot_queue_max_z_diff_below
	local slot_queue_position_on_navmesh = NavQueries_position_on_mesh(nav_world, slot_queue_position, max_queue_z_diff_above, max_queue_z_diff_below, traverse_logic)

	if slot_queue_position_on_navmesh then
		Vector3Box_store(slot.queue_position, slot_queue_position_on_navmesh)
	else
		Vector3Box_store(slot.queue_position, slot_queue_position)
	end

	local slot_position_on_navmesh = slot_position
	local ray_can_go = NavQueries_ray_can_go_projected(nav_world, slot_queue_position_on_navmesh, slot_position_on_navmesh, traverse_logic)

	if ray_can_go then
		slot.queue_slot_disabled = false
	elseif not slot.queue_slot_disabled then
		local queue = slot.queue
		local queue_n = #queue

		for i = 1, queue_n do
			local user_unit_waiting = queue[i]
			local user_unit_waiting_extension = unit_extension_data[user_unit_waiting]

			user_unit_waiting_extension.wait_slot = nil
			queue[i] = nil
		end

		local slot_data = target_slot_extension.all_slots[slot_type]

		slot_data.slots_count = _slots_count(slot_data)
		slot.queue_slot_disabled = true
	end
end

local function _update_slot_status(slot, is_on_navmesh, target_units, unit_extension_data)
	if is_on_navmesh then
		_enable_slot(slot)
	else
		_disable_slot(slot, unit_extension_data)

		return false
	end

	local overlaps_with_other_target = _overlap_with_other_target(slot, target_units, unit_extension_data)

	if not overlaps_with_other_target then
		_enable_slot(slot)
	else
		_disable_slot(slot, unit_extension_data)

		return false
	end

	local overlap_slot = _overlap_with_other_target_slot(slot, target_units, unit_extension_data)

	if overlap_slot then
		local disabled = _disable_overlaping_slot(slot, overlap_slot, unit_extension_data)

		if not disabled then
			_enable_slot(slot)
		else
			return false
		end
	end

	local overlap_own_slot = _overlap_with_own_slots(slot, unit_extension_data)

	if overlap_own_slot then
		local disabled = _disable_overlaping_slot(slot, overlap_own_slot, unit_extension_data)

		if not disabled then
			_enable_slot(slot)
		else
			return false
		end
	end

	Slot.release_check(slot, unit_extension_data)

	return true
end

local function _compute_own_slots_bound(target_unit_extension)
	local center = _cached_target_position(target_unit_extension)
	local max_dist_sq = 0
	local all_slots = target_unit_extension.all_slots

	for j = 1, NUM_SLOT_TYPES do
		local slot_data = all_slots[SLOT_TYPES[j]]
		local slots = slot_data.slots
		local total_slots_count = slot_data.total_slots_count

		for k = 1, total_slots_count do
			local dist_sq = Vector3_distance_squared(center, _cached_absolute_position(slots[k]))

			if max_dist_sq < dist_sq then
				max_dist_sq = dist_sq
			end
		end
	end

	target_unit_extension.slots_bound = math_sqrt(max_dist_sq) + MAX_OVERLAP_RADIUS
end

Slot.update_target_slots_status = function (target_unit, target_units, unit_extension_data, nav_world, traverse_logic, outside_navmesh)
	_clear_caches()

	local target_unit_extension = unit_extension_data[target_unit]
	local all_slots = target_unit_extension.all_slots

	for i = 1, NUM_SLOT_TYPES do
		local slot_type = SLOT_TYPES[i]
		local slot_data = all_slots[slot_type]
		local target_slots = slot_data.slots
		local total_slots_count = slot_data.total_slots_count
		local should_offset_slot = false

		for j = 1, total_slots_count do
			local slot = target_slots[j]
			local slot_position = _cached_absolute_position(slot)
			local update_edges = false
			local is_on_navmesh = _update_slot_position(target_unit_extension, slot, slot_position, should_offset_slot, nav_world, traverse_logic, nil, nil, outside_navmesh, update_edges)

			_update_slot_status(slot, is_on_navmesh, target_units, unit_extension_data)
			_update_slot_queue_position_and_status(target_unit_extension, slot, unit_extension_data, nav_world, traverse_logic)
		end
	end

	_update_anchor_weights(all_slots)
	_compute_own_slots_bound(target_unit_extension)
end

local function _update_target_slots_positions_on_ladder(target_unit_extension, target_units, unit_extension_data, nav_world, traverse_logic, ladder_unit, bottom, top)
	local ladder_dir = Vector3_normalize(Vector3_flat(Quaternion.forward(Unit.world_rotation(ladder_unit, 1))))
	local inverse_ladder_dir = -ladder_dir
	local slot_offset_dist = 1
	local all_slots = target_unit_extension.all_slots

	for i = 1, NUM_SLOT_TYPES do
		local slot_type = SLOT_TYPES[i]
		local slot_data = all_slots[slot_type]
		local target_slots = slot_data.slots
		local total_slots_count = slot_data.total_slots_count
		local top_half = math_floor(total_slots_count / 2)
		local top_anchor_index = math_ceil(top_half / 2)
		local top_anchor_slot = target_slots[top_anchor_index]
		local last_pos_on_navmesh, _ = _get_slot_position_on_navmesh_from_outside_target(top, ladder_dir, nil, slot_offset_dist, nav_world, traverse_logic, 0.5, 0.5)
		local last_pos = last_pos_on_navmesh or top
		local is_on_navmesh = last_pos_on_navmesh ~= nil

		Vector3Box_store(top_anchor_slot.original_absolute_position, last_pos)
		_set_slot_absolute_position(top_anchor_slot, last_pos, target_unit_extension, false)
		_update_slot_status(top_anchor_slot, is_on_navmesh, target_units, unit_extension_data)
		_update_slot_queue_position_and_status(target_unit_extension, top_anchor_slot, unit_extension_data, nav_world, traverse_logic)

		for j = top_anchor_index - 1, 1, -1 do
			local slot = target_slots[j]

			_update_slot_status(slot, false, target_units, unit_extension_data)
		end

		for j = top_anchor_index + 1, top_half do
			local slot = target_slots[j]

			_update_slot_status(slot, false, target_units, unit_extension_data)
		end

		local bottom_anchor_index = top_half + math_ceil((total_slots_count - top_half) / 2)
		local bottom_anchor_slot = target_slots[bottom_anchor_index]
		local bottom_pos_on_navmesh, _ = _get_slot_position_on_navmesh_from_outside_target(bottom, inverse_ladder_dir, nil, slot_offset_dist, nav_world, traverse_logic, 0.5, 0.5)

		last_pos = bottom_pos_on_navmesh or bottom
		is_on_navmesh = bottom_pos_on_navmesh ~= nil

		Vector3Box_store(bottom_anchor_slot.original_absolute_position, last_pos)
		_set_slot_absolute_position(bottom_anchor_slot, last_pos, target_unit_extension, false)
		_update_slot_status(bottom_anchor_slot, is_on_navmesh, target_units, unit_extension_data)
		_update_slot_queue_position_and_status(target_unit_extension, bottom_anchor_slot, unit_extension_data, nav_world, traverse_logic)

		for j = bottom_anchor_index - 1, top_half + 1, -1 do
			local slot = target_slots[j]

			_update_slot_status(slot, false, target_units, unit_extension_data)
		end

		for j = bottom_anchor_index + 1, total_slots_count do
			local slot = target_slots[j]

			_update_slot_status(slot, false, target_units, unit_extension_data)
		end

		_update_anchor_weights(all_slots)
	end
end

Slot.update_target_slots_positions = function (target_unit, target_units, unit_extension_data, should_offset_slot, nav_world, traverse_logic, is_on_ladder, ladder_unit, bottom, top, target_outside_navmesh)
	_clear_caches()

	local target_unit_extension = unit_extension_data[target_unit]

	if is_on_ladder then
		_update_target_slots_positions_on_ladder(target_unit_extension, target_units, unit_extension_data, nav_world, traverse_logic, ladder_unit, bottom, top)
		_compute_own_slots_bound(target_unit_extension)

		return
	end

	local above, below

	if target_outside_navmesh then
		above, below = SlotSystemSettings.slot_z_max_up, SlotSystemSettings.slot_z_max_down
	else
		above, below = SlotSystemSettings.z_max_difference_above, SlotSystemSettings.z_max_difference_below
	end

	if should_offset_slot then
		local locomotion_component = target_unit_extension.locomotion_component
		local velocity = locomotion_component and locomotion_component.velocity_current or Vector3(0, 0, 0)
		local speed = Vector3_length(velocity)

		if speed > 0.1 then
			_offset_move_direction = Vector3_normalize(velocity)
			_offset_speed = speed
		end
	end

	local update_edges = true
	local all_slots = target_unit_extension.all_slots

	for i = 1, NUM_SLOT_TYPES do
		local slot_type = SLOT_TYPES[i]
		local slot_data = all_slots[slot_type]
		local target_slots = slot_data.slots

		_update_anchor_weights_for_type(slot_data)

		local anchor_slot = Slot.anchor(slot_type, target_unit, unit_extension_data)
		local total_slots_count = slot_data.total_slots_count
		local slot_index = anchor_slot.index
		local is_on_navmesh = _update_anchor_slot_position(target_unit_extension, anchor_slot, should_offset_slot, nav_world, traverse_logic, above, below, target_outside_navmesh, update_edges)

		_update_slot_status(anchor_slot, is_on_navmesh, target_units, unit_extension_data)
		_update_slot_queue_position_and_status(target_unit_extension, anchor_slot, unit_extension_data, nav_world, traverse_logic)

		for j = slot_index + 1, total_slots_count do
			local slot = target_slots[j]
			local slot_left = target_slots[j - 1]
			local position = _right_pos_cache[slot_left]

			is_on_navmesh = _update_slot_position(target_unit_extension, slot, position, should_offset_slot, nav_world, traverse_logic, above, below, target_outside_navmesh, update_edges)

			_update_slot_status(slot, is_on_navmesh, target_units, unit_extension_data)
			_update_slot_queue_position_and_status(target_unit_extension, slot, unit_extension_data, nav_world, traverse_logic)
		end

		for j = slot_index - 1, 1, -1 do
			local slot = target_slots[j]
			local slot_right = target_slots[j + 1]
			local position = _left_pos_cache[slot_right]

			is_on_navmesh = _update_slot_position(target_unit_extension, slot, position, should_offset_slot, nav_world, traverse_logic, above, below, target_outside_navmesh, update_edges)

			_update_slot_status(slot, is_on_navmesh, target_units, unit_extension_data)
			_update_slot_queue_position_and_status(target_unit_extension, slot, unit_extension_data, nav_world, traverse_logic)
		end
	end

	_compute_own_slots_bound(target_unit_extension)
end

Slot.find_best_slot = function (target_unit, user_unit, unit_extension_data)
	local user_unit_position = POSITION_LOOKUP[user_unit]
	local user_unit_extension = unit_extension_data[user_unit]
	local target_unit_extension = unit_extension_data[target_unit]
	local slot_type = user_unit_extension.use_slot_type
	local all_slots = target_unit_extension.all_slots
	local slot_data = all_slots[slot_type]
	local target_slots = slot_data.slots
	local best_slot
	local best_score = math.huge
	local previous_slot = user_unit_extension.slot
	local disabled_slots_count = slot_data.disabled_slots_count
	local total_slots_count = slot_data.total_slots_count
	local slot_template = user_unit_extension.slot_template
	local avoid_slots_behind_overwhelmed_target = slot_template.avoid_slots_behind_overwhelmed_target
	local is_overwhelmed = slot_template and avoid_slots_behind_overwhelmed_target and disabled_slots_count >= 2
	local released_owner_distance_modifier = SlotSystemSettings.slot_release_owner_distance_modifier
	local owner_sticky_value = SlotSystemSettings.slot_owner_sticky_value
	local skip_slots_behind_target = is_overwhelmed
	local target_unit_position = skip_slots_behind_target and Vector3Box_unbox(target_unit_extension.position) or nil
	local normalized_target_to_user = skip_slots_behind_target and _normalized_target_to_user(user_unit, target_unit_position) or nil

	for i = 1, total_slots_count do
		repeat
			local slot = target_slots[i]
			local disabled = slot.disabled

			if disabled then
				break
			end

			local slot_position = Vector3Box_unbox(slot.original_absolute_position)

			if skip_slots_behind_target and _is_slot_behind_target(slot_position, target_unit_position, normalized_target_to_user) then
				break
			end

			local slot_owner = slot.user_unit
			local slot_released = slot.released
			local slot_distance = Vector3_distance_squared(slot_position, user_unit_position)
			local slot_score = math.huge

			if slot_owner then
				if slot_owner == user_unit then
					slot_score = slot_distance + owner_sticky_value
				elseif slot_released then
					local owner_position = POSITION_LOOKUP[slot_owner]
					local owner_distance = Vector3_distance_squared(slot_position, owner_position) + released_owner_distance_modifier

					if slot_distance < owner_distance then
						slot_score = slot_distance
					end
				end
			else
				slot_score = slot_distance
			end

			if slot_score < best_score then
				best_slot = slot
				best_score = slot_score
			end
		until true
	end

	if best_slot then
		repeat
			local current_slot = user_unit_extension.slot

			if current_slot and current_slot == best_slot then
				break
			end

			local waiting_on_slot = user_unit_extension.wait_slot

			if current_slot or waiting_on_slot then
				Slot.detach_user_unit(user_unit, user_unit_extension, unit_extension_data)
			end

			local previous_slot_owner = best_slot.user_unit

			if previous_slot_owner then
				local previous_slot_owner_extension = unit_extension_data[previous_slot_owner]

				previous_slot_owner_extension.slot = nil
			end

			best_slot.user_unit = user_unit
			user_unit_extension.slot = best_slot

			_update_anchor_weights(all_slots)
		until true
	end

	if previous_slot ~= user_unit_extension.slot then
		slot_data.slots_count = _slots_count(slot_data)
	elseif not best_slot and previous_slot and skip_slots_behind_target and Slot.is_behind_target(previous_slot, user_unit, target_unit_extension) then
		Slot.detach_user_unit(user_unit, user_unit_extension, unit_extension_data)
	end
end

Slot.find_best_slot_to_wait_on = function (target_unit, user_unit, unit_extension_data)
	local user_unit_extension = unit_extension_data[user_unit]
	local waiting_on_slot = user_unit_extension.wait_slot
	local target_unit_extension = unit_extension_data[target_unit]
	local slot_type = user_unit_extension.use_slot_type
	local all_slots = target_unit_extension.all_slots
	local slot_data = all_slots[slot_type]
	local disabled_slots_count = slot_data.disabled_slots_count
	local slot_template = user_unit_extension.slot_template
	local avoid_slots_behind_overwhelmed_target = slot_template.avoid_slots_behind_overwhelmed_target
	local is_overwhelmed = slot_template and avoid_slots_behind_overwhelmed_target and disabled_slots_count >= 2
	local skip_slots_behind_target = is_overwhelmed

	if waiting_on_slot then
		if skip_slots_behind_target and Slot.is_behind_target(waiting_on_slot, user_unit, target_unit_extension) then
			Slot.detach_user_unit(user_unit, user_unit_extension, unit_extension_data)
		else
			return
		end
	end

	local user_unit_position = POSITION_LOOKUP[user_unit]
	local best_distance = math.huge
	local best_slot
	local slot_queue_penalty_multiplier = SlotSystemSettings.slot_queue_penalty_multiplier
	local target_unit_position = skip_slots_behind_target and Vector3Box_unbox(target_unit_extension.position) or nil
	local normalized_target_to_user = skip_slots_behind_target and _normalized_target_to_user(user_unit, target_unit_position) or nil

	for i = 1, NUM_SLOT_TYPES do
		local other_slot_type = SLOT_TYPES[i]
		local other_slot_data = all_slots[other_slot_type]
		local target_slots = other_slot_data.slots
		local total_slots_count = other_slot_data.total_slots_count

		for j = 1, total_slots_count do
			repeat
				local slot = target_slots[j]

				if slot.queue_slot_disabled then
					break
				end

				local slot_is_behind_penalty = 0

				if skip_slots_behind_target then
					local slot_position = Vector3Box_unbox(slot.original_absolute_position)

					if _is_slot_behind_target(slot_position, target_unit_position, normalized_target_to_user) then
						slot_is_behind_penalty = 100
					end
				end

				local queue = slot.queue
				local queue_n = #queue
				local slot_queue_position = Vector3Box_unbox(slot.queue_position)
				local slot_queue_distance = Vector3_distance_squared(slot_queue_position, user_unit_position) + queue_n * queue_n * slot_queue_penalty_multiplier + slot_is_behind_penalty

				if slot_queue_distance < best_distance then
					best_distance = slot_queue_distance
					best_slot = slot
				end
			until true
		end
	end

	if best_slot then
		local queue = best_slot.queue
		local queue_n = #queue

		queue[queue_n + 1] = user_unit
		user_unit_extension.wait_slot = best_slot

		local best_slot_type = best_slot.type
		local best_slot_data = all_slots[best_slot_type]

		best_slot_data.slots_count = _slots_count(best_slot_data)
	end
end

Slot.update_disabled_slots_count = function (target_units, unit_extension_data)
	local target_units_n = #target_units

	for i = 1, target_units_n do
		local target_unit = target_units[i]
		local target_unit_extension = unit_extension_data[target_unit]
		local all_slots = target_unit_extension.all_slots

		for j = 1, NUM_SLOT_TYPES do
			local slot_type = SLOT_TYPES[j]
			local slot_data = all_slots[slot_type]
			local target_slots = slot_data.slots
			local target_slots_n = #target_slots
			local disabled_count = 0

			for slot_i = 1, target_slots_n do
				local slot = target_slots[slot_i]

				if slot.disabled then
					disabled_count = disabled_count + 1
				end
			end

			slot_data.disabled_slots_count = disabled_count
		end
	end
end

Slot.update_slot_sound = function (target_units, unit_extension_data)
	local surrounded_vo_slot_percent = DialogueSettings.surrounded_vo_slot_percent
	local target_units_n = #target_units

	for unit_i = 1, target_units_n do
		local target_unit = target_units[unit_i]
		local slot_extension = unit_extension_data[target_unit]
		local slot_occupancy_percent = slot_extension.slot_occupancy_percent

		if surrounded_vo_slot_percent < slot_occupancy_percent then
			local trigger_id = "surrounded"

			Vo.generic_mission_vo_event(target_unit, trigger_id)
		end
	end
end

return Slot
