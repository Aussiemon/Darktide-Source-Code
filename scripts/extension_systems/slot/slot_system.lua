local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
local Slot = require("scripts/extension_systems/slot/utilities/slot")
local SlotSystemSettings = require("scripts/settings/slot/slot_system_settings")
local SlotTemplates = require("scripts/settings/slot/slot_templates")
local SlotTypeSettings = require("scripts/settings/slot/slot_type_settings")
local SLOT_TYPES = {}

for slot_type, _ in pairs(SlotTypeSettings) do
	SLOT_TYPES[#SLOT_TYPES + 1] = slot_type
end

local NUM_SLOT_TYPES = #SLOT_TYPES
local SlotSystem = class("SlotSystem", "ExtensionSystemBase")
local NAV_TAG_LAYER_COSTS = {}

SlotSystem.init = function (self, extension_system_creation_context, ...)
	SlotSystem.super.init(self, extension_system_creation_context, ...)

	self._unit_extension_data = {}
	self._update_slots_user_units = {}
	self._update_slots_user_units_prioritized = {}
	self._target_units = {}
	self._current_user_index = 1
	self._next_occupied_slot_count_update = 0
	self._next_disabled_slot_count_update = 0
	self._next_slot_sound_update = 0
	self._next_unique_target_index = 1
end

local FORBIDDEN_NAV_TAG_VOLUME_TYPES = {
	"content/volume_types/nav_tag_volumes/minion_no_destination"
}

SlotSystem.on_gameplay_post_init = function (self, level)
	local nav_world = self._nav_world
	local traverse_logic, nav_tag_cost_table = Navigation.create_traverse_logic(nav_world, NAV_TAG_LAYER_COSTS, nil, false)
	self._nav_tag_cost_table = nav_tag_cost_table
	self._traverse_logic = traverse_logic
	local nav_mesh_manager = Managers.state.nav_mesh

	for i = 1, #FORBIDDEN_NAV_TAG_VOLUME_TYPES, 1 do
		local volume_type = FORBIDDEN_NAV_TAG_VOLUME_TYPES[i]
		local layer_ids = nav_mesh_manager:nav_tag_volume_layer_ids_by_volume_type(volume_type)

		for j = 1, #layer_ids, 1 do
			GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_ids[j])
		end
	end

	local target_units = self._target_units
	local unit_extension_data = self._unit_extension_data
	local num_target_units = #target_units

	for i = 1, num_target_units, 1 do
		local unit = target_units[i]
		local extension = unit_extension_data[unit]

		self:_update_target_slots(0, unit, target_units, unit_extension_data, extension, nav_world, traverse_logic)
	end
end

SlotSystem.destroy = function (self)
	local traverse_logic = self._traverse_logic

	if traverse_logic then
		GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
		GwNavTraverseLogic.destroy(traverse_logic)
	end

	SlotSystem.super.destroy(self)
end

SlotSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = {}

	ScriptUnit.set_extension(unit, self._name, extension)

	if extension_name == "SlotExtension" then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		extension.locomotion_component = unit_data_extension:read_component("locomotion")
		extension.character_state_component = unit_data_extension:read_component("character_state")
		extension.ladder_character_state_component = unit_data_extension:read_component("ladder_character_state")
		extension.all_slots = Slot.create_slots(unit)
		extension.position = Vector3Box(POSITION_LOOKUP[unit])
		extension.moved_at = 0
		extension.next_slot_status_update_at = 0
		extension.num_occupied_slots = 0
		extension.full_slots_at_t = {}
	elseif extension_name == "SlotUserExtension" then
		extension.improve_wait_slot_position_t = 0
		local blackboard = BLACKBOARDS[unit]
		local perception_component = blackboard.perception
		extension.perception_component = perception_component
		local breed = extension_init_data.breed
		local activate_slot_system_on_spawn = breed.activate_slot_system_on_spawn
		extension.do_search = activate_slot_system_on_spawn
		local slot_template_name = breed.slot_template

		fassert(slot_template_name, "[SlotSystem] %s does not have slot_template set in its breed.", breed.name)

		local slot_template_per_challenge = SlotTemplates[slot_template_name]

		fassert(slot_template_per_challenge, "[SlotSystem] %s does not have slot_template %s setup in SlotTemplates.", breed.name, slot_template_name)

		local slot_template = Managers.state.difficulty:get_table_entry_by_challenge(slot_template_per_challenge)
		local slot_type = slot_template.slot_type
		extension.slot_template = slot_template
		extension.use_slot_type = slot_type

		self:_init_blackboard_values(unit, extension)
	end

	self._unit_extension_data[unit] = extension

	return extension
end

SlotSystem._init_blackboard_values = function (self, unit, extension)
	local blackboard = BLACKBOARDS[unit]
	local slot_component = Blackboard.write_component(blackboard, "slot")
	slot_component.has_slot = false
	slot_component.slot_distance = math.huge
	slot_component.wait_slot_distance = math.huge
	slot_component.is_waiting_on_slot = false
	slot_component.has_ghost_slot = false
	extension.slot_component = slot_component
end

SlotSystem.register_extension_update = function (self, unit, extension_name, extension)
	if extension_name == "SlotExtension" then
		local target_units = self._target_units
		target_units[#target_units + 1] = unit
		extension.index = self._next_unique_target_index
		self._next_unique_target_index = self._next_unique_target_index + 1
		local traverse_logic = self._traverse_logic

		if traverse_logic then
			self:_update_target_slots(0, unit, target_units, self._unit_extension_data, extension, self._nav_world, traverse_logic)
		end
	elseif extension_name == "SlotUserExtension" then
		self._update_slots_user_units[#self._update_slots_user_units + 1] = unit
	end
end

SlotSystem.on_remove_extension = function (self, unit, extension_name)
	local unit_extension_data = self._unit_extension_data
	local extension = unit_extension_data[unit]

	if extension_name == "SlotExtension" then
		local all_slots = extension.all_slots

		for slot_type, slot_data in pairs(all_slots) do
			local slots = slot_data.slots
			local slots_n = #slots

			for i = slots_n, 1, -1 do
				local slot = slots[i]

				Slot.remove(slot, unit_extension_data)
			end
		end

		local target_units = self._target_units
		local target_units_n = #target_units

		for i = 1, target_units_n, 1 do
			if target_units[i] == unit then
				target_units[i] = target_units[target_units_n]
				target_units[target_units_n] = nil

				break
			end
		end
	elseif extension_name == "SlotUserExtension" then
		if extension.slot or extension.wait_slot then
			Slot.detach_user_unit(unit, extension, unit_extension_data)
		end

		local update_slots_user_units = self._update_slots_user_units
		local update_slots_user_units_n = #update_slots_user_units
		self._update_slots_user_units_prioritized[unit] = nil

		for i = 1, update_slots_user_units_n, 1 do
			local user_unit = update_slots_user_units[i]

			if user_unit == unit then
				update_slots_user_units[i] = update_slots_user_units[update_slots_user_units_n]
				update_slots_user_units[update_slots_user_units_n] = nil

				break
			end
		end
	end

	unit_extension_data[unit] = nil

	ScriptUnit.remove_extension(unit, self._name)
end

SlotSystem.do_slot_search = function (self, user_unit, set)
	local user_slot_extension = self._unit_extension_data[user_unit]

	if user_slot_extension then
		user_slot_extension.do_search = set
	end
end

SlotSystem.is_slot_searching = function (self, user_unit)
	local user_slot_extension = self._unit_extension_data[user_unit]

	return user_slot_extension and user_slot_extension.do_search
end

local function _new_random_goal_uniformly_distributed_with_inside_from_outside_on_last(nav_world, start_pos, min_dist, max_dist, max_tries, test_points, above, below, horizontal, traverse_logic)
	above = above or 30
	below = below or 30
	horizontal = horizontal or 3
	local distance_from_obstacle = 0.1
	local tries = 0

	while max_tries > tries do
		local min_dist_proportion = (min_dist / max_dist)^2
		local random_value = math.random()
		local normalized_dist = min_dist_proportion + random_value * (1 - min_dist_proportion)
		local uniformly_scaled_dist = math.sqrt(normalized_dist)
		local dist = uniformly_scaled_dist * max_dist
		local add_vec = Vector3(dist, 0, 1.5)
		local pos = start_pos + Quaternion.rotate(Quaternion(Vector3.up(), math.random() * math.pi * 2), add_vec)

		if test_points then
			test_points[#test_points + 1] = Vector3Box(pos)
		end

		local altitude = GwNavQueries.triangle_from_position(nav_world, pos, above, below, traverse_logic)

		if altitude then
			pos.z = altitude

			return pos
		end

		if tries == max_tries - 1 then
			local clamped_position = GwNavQueries.inside_position_from_outside_position(nav_world, pos, above, below, horizontal, distance_from_obstacle, traverse_logic)

			if clamped_position then
				return clamped_position
			end
		end

		tries = tries + 1
	end
end

local Vector3_dot = Vector3.dot
local Vector3_distance = Vector3.distance
local Vector3_distance_sq = Vector3.distance_squared
local IMPROVE_WAIT_SLOT_MIN_FREQUENCY = 1
local IMPROVE_WAIT_SLOT_MAX_FREQUENCY = 2
local MIN_DISTANCE = 0.2
local WAITING_ON_SLOT_DISTANCE = 2

SlotSystem._improve_slot_position = function (self, user_unit, user_slot_extension, nav_world, traverse_logic, t)
	local user_unit_position = POSITION_LOOKUP[user_unit]
	local slot_component = user_slot_extension.slot_component
	local position = nil
	local slot = user_slot_extension.slot
	local waiting_on_slot = user_slot_extension.wait_slot

	if slot then
		if slot.ghost_position.x ~= 0 then
			position = slot.ghost_position:unbox()
		else
			position = slot.absolute_position:unbox()
		end

		slot_component.is_waiting_on_slot = false
	elseif waiting_on_slot then
		local queue_position = waiting_on_slot.queue_position:unbox()
		local should_improve_wait_slot_position = user_slot_extension.improve_wait_slot_position_t < t

		if should_improve_wait_slot_position then
			local above_limit = SlotSystemSettings.slot_queue_random_position_max_up
			local below_limit = SlotSystemSettings.slot_queue_random_position_max_down
			local horizontal_limit = SlotSystemSettings.slot_queue_random_position_max_horizontal
			local min_dist = 0
			local max_dist = SlotSystemSettings.slot_queue_radius
			local max_tries = 2
			local random_goal_function = _new_random_goal_uniformly_distributed_with_inside_from_outside_on_last
			local random_slot_position = (queue_position and random_goal_function(nav_world, queue_position, min_dist, max_dist, max_tries, nil, above_limit, below_limit, horizontal_limit, traverse_logic)) or nil
			local z_diff = (random_slot_position and math.abs(user_unit_position.z - random_slot_position.z)) or 0
			local z_diff_exceded = SlotSystemSettings.z_max_difference_above < z_diff
			local distance = (random_slot_position and Vector3_distance(random_slot_position, user_unit_position)) or math.huge
			local close_distance = distance < 5
			position = random_slot_position

			if z_diff_exceded and close_distance then
				position = nil
			else
				slot_component.wait_slot_distance = distance
			end

			slot_component.is_waiting_on_slot = distance <= WAITING_ON_SLOT_DISTANCE
			user_slot_extension.improve_wait_slot_position_t = t + IMPROVE_WAIT_SLOT_MIN_FREQUENCY + math.random() * IMPROVE_WAIT_SLOT_MAX_FREQUENCY
		else
			local distance_to_queue = Vector3_distance(user_unit_position, queue_position)
			slot_component.wait_slot_distance = distance_to_queue

			return
		end
	else
		return
	end

	if not position then
		return
	end

	local distance = Vector3_distance(user_unit_position, position)
	local navigation_extension = ScriptUnit.extension(user_unit, "navigation_system")
	local previous_destination = navigation_extension:destination()

	if MIN_DISTANCE < distance or Vector3_dot(position - user_unit_position, previous_destination - user_unit_position) < 0 then
		navigation_extension:move_to(position)

		slot_component.slot_distance = distance
	end
end

SlotSystem.user_unit_wait_slot_distance = function (self, user_unit)
	local user_slot_extension = self._unit_extension_data[user_unit]

	if not user_slot_extension then
		return math.huge
	end

	local slot = user_slot_extension.slot

	if slot then
		return math.huge
	end

	local waiting_on_slot = user_slot_extension.wait_slot

	if not waiting_on_slot then
		return math.huge
	end

	local distance = user_slot_extension.wait_slot_distance or math.huge

	return distance
end

SlotSystem.user_unit_slot_position = function (self, user_unit)
	local user_slot_extension = self._unit_extension_data[user_unit]

	if not user_slot_extension then
		return nil
	end

	local slot = user_slot_extension.slot or user_slot_extension.wait_slot

	if slot then
		return slot.absolute_position:unbox()
	end

	return nil
end

SlotSystem.user_unit_blocked_attack = function (self, user_unit)
	local user_slot_extension = self._unit_extension_data[user_unit]

	if not user_slot_extension or user_slot_extension.wait_slot then
		return nil
	end

	local slot = user_slot_extension.slot

	if not slot then
		return nil
	end

	local slot_template = user_slot_extension.slot_template

	if slot_template.abandon_slot_when_blocked then
		if slot_template.abandon_slot_when_blocked_time then
			local t = Managers.time:time("gameplay")
			user_slot_extension.delayed_prioritized_user_unit_update_time = t + slot_template.abandon_slot_when_blocked_time
		else
			Slot.detach_user_unit(user_unit, user_slot_extension, self._unit_extension_data)
			self:register_prioritized_user_unit_update(user_unit)
		end
	end
end

SlotSystem.user_unit_staggered = function (self, user_unit)
	local user_slot_extension = self._unit_extension_data[user_unit]

	if not user_slot_extension or user_slot_extension.wait_slot then
		return nil
	end

	local slot = user_slot_extension.slot

	if not slot then
		return nil
	end

	local slot_template = user_slot_extension.slot_template

	if slot_template.abandon_slot_when_staggered then
		if slot_template.abandon_slot_when_staggered_time then
			local t = Managers.time:time("gameplay")
			user_slot_extension.delayed_prioritized_user_unit_update_time = t + slot_template.abandon_slot_when_staggered_time
		else
			Slot.detach_user_unit(user_unit, user_slot_extension, self._unit_extension_data)
			self:register_prioritized_user_unit_update(user_unit)
		end
	end
end

SlotSystem.slots_count = function (self, unit, slot_type)
	local unit_extension = self._unit_extension_data[unit]
	local slot_data = unit_extension.all_slots[slot_type]
	local count = slot_data.slots_count

	return count
end

SlotSystem.total_slots_count = function (self, unit, slot_type)
	local unit_extension = self._unit_extension_data[unit]
	local slot_data = unit_extension.all_slots[slot_type]
	local total_slots_count = slot_data.total_slots_count

	return total_slots_count
end

SlotSystem.disabled_slots_count = function (self, unit, slot_type)
	local unit_extension = self._unit_extension_data[unit]
	local slot_data = unit_extension.all_slots[slot_type]
	local disabled_slots_count = slot_data.disabled_slots_count

	return disabled_slots_count
end

SlotSystem.set_release_slot_lock = function (self, unit, release_slot_lock)
	local unit_extension = self._unit_extension_data[unit]

	if unit_extension then
		unit_extension.release_slot_lock = release_slot_lock
	end
end

SlotSystem.physics_async_update = function (self, context, dt, t)
	local target_units = self._target_units
	local target_units_n = #target_units

	if target_units_n == 0 then
		return
	end

	local nav_world = self._nav_world
	local traverse_logic = self._traverse_logic
	local unit_extension_data = self._unit_extension_data

	Profiler.start("SlotSystem:physics_async_update")
	Profiler.start("update_target_slots")

	for i = 1, target_units_n, 1 do
		local target_unit = target_units[i]
		local target_slot_extension = unit_extension_data[target_unit]
		local successful = self:_update_target_slots(t, target_unit, target_units, unit_extension_data, target_slot_extension, nav_world, traverse_logic)

		if successful then
			break
		end
	end

	Profiler.stop("update_target_slots")

	if self._next_occupied_slot_count_update < t then
		Profiler.start("update_occupied_slots")
		self:_update_occupied_slots(unit_extension_data)

		self._next_occupied_slot_count_update = t + SlotSystemSettings.occupied_slots_count_update_interval

		Profiler.stop("update_occupied_slots")
	end

	if self._next_disabled_slot_count_update < t then
		Profiler.start("update_disabled_slots_count")
		Slot.update_disabled_slots_count(target_units, unit_extension_data)

		self._next_disabled_slot_count_update = t + SlotSystemSettings.disabled_slots_count_update_interval

		Profiler.stop("update_disabled_slots_count")
	end

	if self._next_slot_sound_update < t then
		Profiler.start("update_slot_sound")
		Slot.update_slot_sound(self._is_server, self._network_transmit, target_units, unit_extension_data)

		self._next_slot_sound_update = t + SlotSystemSettings.slot_sound_update_interval

		Profiler.stop("update_slot_sound")
	end

	local update_slots_user_units_prioritized = self._update_slots_user_units_prioritized

	for user_unit, user_slot_extension in pairs(update_slots_user_units_prioritized) do
		self:_update_user_unit_slot(user_unit, user_slot_extension, target_units, unit_extension_data, nav_world, traverse_logic, t)
		self:_update_user_unit_blackboard_components(user_slot_extension)

		update_slots_user_units_prioritized[user_unit] = nil
	end

	local update_slots_user_units = self._update_slots_user_units
	local update_slots_user_units_n = #update_slots_user_units
	local max_user_updates = (self._max_slot_update_override and update_slots_user_units_n) or math.min(SlotSystemSettings.max_user_updates_per_frame, update_slots_user_units_n)
	local max_user_loops = (self._max_slot_update_override and update_slots_user_units_n) or math.min(SlotSystemSettings.max_user_loops_per_frame, update_slots_user_units_n)
	local index = self._current_user_index
	local update_counter = 0
	local loop_counter = 0

	while update_counter < max_user_updates and loop_counter < max_user_loops do
		if update_slots_user_units_n < index then
			index = 1
		end

		local user_unit = update_slots_user_units[index]
		local user_slot_extension = unit_extension_data[user_unit]
		local consume_update = self:_update_user_unit_slot(user_unit, user_slot_extension, target_units, unit_extension_data, nav_world, traverse_logic, t)

		self:_update_user_unit_blackboard_components(user_slot_extension)

		loop_counter = loop_counter + 1
		index = index + 1
		update_counter = update_counter + ((consume_update and 1) or 0)
	end

	self._current_user_index = index
	self._max_slot_update_override = nil

	Profiler.stop("SlotSystem:physics_async_update")
end

local GwNavQueries_inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position

local function _get_target_position_on_navmesh(target_position, nav_world, traverse_logic)
	local above_limit = SlotSystemSettings.z_max_difference_above
	local below_limit = SlotSystemSettings.z_max_difference_below
	local position_on_navmesh = NavQueries.position_on_mesh(nav_world, target_position, above_limit, below_limit, traverse_logic)

	if position_on_navmesh then
		return position_on_navmesh
	end

	local horizontal_limit = 1
	local distance_from_nav_border = 0.05
	local border_position = GwNavQueries_inside_position_from_outside_position(nav_world, target_position, above_limit, below_limit, horizontal_limit, distance_from_nav_border, traverse_logic)

	if border_position then
		return border_position
	end

	below_limit = SlotSystemSettings.slot_z_max_down
	position_on_navmesh = NavQueries.position_on_mesh(nav_world, target_position, above_limit, below_limit, traverse_logic)

	if position_on_navmesh then
		return position_on_navmesh
	end

	return nil
end

local function _get_ladder_coordinates(ladder_unit)
	local bottom_node = Unit.node(ladder_unit, "node_bottom")
	local bottom_position = Unit.world_position(ladder_unit, bottom_node)
	local top_node = Unit.node(ladder_unit, "node_top")
	local top_position = Unit.world_position(ladder_unit, top_node)

	return bottom_position, top_position
end

local Vector3_length_squared = Vector3.length_squared

SlotSystem._update_target_slots = function (self, t, target_unit, target_units, unit_extension_data, target_slot_extension, nav_world, traverse_logic)
	local dist_sq = 0
	local is_on_ladder = false
	local ladder_unit, bottom, top = nil
	local was_on_ladder = target_slot_extension.was_on_ladder
	local character_state_component = target_slot_extension.character_state_component

	if character_state_component then
		local character_state_name = character_state_component.state_name
		is_on_ladder = character_state_name == "ladder_climbing"

		if is_on_ladder then
			local ladder_character_state_component = target_slot_extension.ladder_character_state_component
			local ladder_unit_id = ladder_character_state_component.ladder_unit_id
			ladder_unit = Managers.state.unit_spawner:unit(ladder_unit_id, true)
			bottom, top = _get_ladder_coordinates(ladder_unit)
		end

		target_slot_extension.was_on_ladder = is_on_ladder
	end

	local real_target_unit_position = POSITION_LOOKUP[target_unit]
	local target_unit_position = (is_on_ladder and real_target_unit_position) or _get_target_position_on_navmesh(real_target_unit_position, nav_world, traverse_logic)
	local target_unit_position_known = target_slot_extension.position:unbox()
	local outside_navmesh_at_t = target_slot_extension.outside_navmesh_at_t
	local outside_navmesh = false
	local force_update = self._max_slot_update_override

	if target_unit_position then
		dist_sq = Vector3_distance_sq(target_unit_position, target_unit_position_known)
		target_slot_extension.outside_navmesh_at_t = nil
	elseif outside_navmesh_at_t == nil or t < outside_navmesh_at_t + SlotSystemSettings.target_slots_outside_navmesh_timeout then
		if outside_navmesh_at_t == nil then
			target_slot_extension.outside_navmesh_at_t = t
		end

		target_unit_position = target_unit_position_known
	else
		outside_navmesh = true
		target_unit_position = POSITION_LOOKUP[target_unit]
		dist_sq = Vector3_distance_sq(target_unit_position, target_unit_position_known)
	end

	if SlotSystemSettings.target_slots_moved_distance_sq < dist_sq or is_on_ladder ~= was_on_ladder or (is_on_ladder and target_slot_extension.next_slot_status_update_at < t) then
		local should_offset_slot = true

		target_slot_extension.position:store(target_unit_position)
		Slot.update_target_slots_positions(target_unit, target_units, unit_extension_data, should_offset_slot, nav_world, traverse_logic, is_on_ladder, ladder_unit, bottom, top, outside_navmesh, t)

		target_slot_extension.moved_at = t
		target_slot_extension.next_slot_status_update_at = t + SlotSystemSettings.slot_status_update_interval

		return true
	end

	local moved_at = target_slot_extension.moved_at
	local target_locomotion_component = target_slot_extension.locomotion_component
	local target_speed_sq = (target_locomotion_component and Vector3_length_squared(target_locomotion_component.velocity_current)) or 0

	if not is_on_ladder and moved_at and SlotSystemSettings.target_slots_update < t - moved_at and (target_speed_sq <= SlotSystemSettings.target_slots_stopped_moving_speed_sq or SlotSystemSettings.target_slots_update_long < t - moved_at) then
		local should_offset_slot = false

		Slot.update_target_slots_positions(target_unit, target_units, unit_extension_data, should_offset_slot, nav_world, traverse_logic, is_on_ladder, ladder_unit, bottom, top, outside_navmesh, t)

		target_slot_extension.moved_at = nil
		target_slot_extension.next_slot_status_update_at = t + SlotSystemSettings.slot_status_update_interval

		return true
	end

	if force_update or target_slot_extension.next_slot_status_update_at < t then
		Slot.update_target_slots_status(target_unit, target_units, unit_extension_data, nav_world, traverse_logic, outside_navmesh, t)

		target_slot_extension.next_slot_status_update_at = t + SlotSystemSettings.slot_status_update_interval

		return true
	end

	return false
end

SlotSystem._update_occupied_slots = function (self, unit_extension_data)
	local target_units = self._target_units
	local target_units_n = #target_units

	for j = 1, target_units_n, 1 do
		local target_unit = target_units[j]
		local target_slot_extension = unit_extension_data[target_unit]
		local all_slots = target_slot_extension.all_slots
		local num_occupied = 0

		for i = 1, NUM_SLOT_TYPES, 1 do
			local slot_type = SLOT_TYPES[i]
			local slot_data = all_slots[slot_type]
			local slots = slot_data.slots
			local total_slots_count = slot_data.total_slots_count

			for k = 1, total_slots_count, 1 do
				local slot = slots[k]
				local occupied = not slot.released and slot.user_unit

				if occupied then
					num_occupied = num_occupied + 1
				end
			end
		end

		target_slot_extension.num_occupied_slots = num_occupied
	end
end

SlotSystem._update_user_unit_blackboard_components = function (self, user_slot_extension)
	local slot = user_slot_extension.slot
	local has_slot = slot ~= nil
	local has_ghost_slot = has_slot and slot.ghost_position.x ~= 0
	local slot_component = user_slot_extension.slot_component
	slot_component.has_slot = has_slot
	slot_component.has_ghost_slot = has_ghost_slot
end

SlotSystem._update_user_unit_slot = function (self, user_unit, user_slot_extension, target_units, unit_extension_data, nav_world, traverse_logic, t)
	local perception_component = user_slot_extension.perception_component
	local target_unit = perception_component.target_unit

	if user_slot_extension.slot and user_slot_extension.slot.target_unit ~= target_unit then
		Slot.detach_user_unit(user_unit, user_slot_extension, unit_extension_data)
	end

	if not ALIVE[target_unit] or not user_slot_extension.do_search then
		return false
	end

	local target_slot_extension = unit_extension_data[target_unit]

	if not target_slot_extension then
		return false
	end

	Profiler.start("get_best_slot")
	Slot.find_best_slot(target_unit, target_units, user_unit, unit_extension_data, nav_world, t)
	Profiler.stop("get_best_slot")

	local slot = user_slot_extension.slot

	if slot then
		Slot.release_check(slot, unit_extension_data)
		Profiler.start("set_ghost_position")

		local slot_behind_target = Slot.is_behind_target(slot, user_unit, target_slot_extension)

		if slot_behind_target then
			Slot.set_ghost_position(target_slot_extension, slot, nav_world, traverse_logic)
		else
			Slot.clear_ghost_position(slot)
		end

		Profiler.stop("set_ghost_position")
	else
		Profiler.start("get_best_slot_to_wait_on")
		Slot.find_best_slot_to_wait_on(target_unit, user_unit, unit_extension_data, nav_world, t)
		Profiler.stop("get_best_slot_to_wait_on")
	end

	Profiler.start("improve_slot_position")
	self:_improve_slot_position(user_unit, user_slot_extension, nav_world, traverse_logic, t)
	Profiler.stop("improve_slot_position")

	local delayed_priotized_time = user_slot_extension.delayed_prioritized_user_unit_update_time

	if delayed_priotized_time and delayed_priotized_time < t then
		Slot.detach_user_unit(user_unit, user_slot_extension, unit_extension_data)
		self:register_prioritized_user_unit_update(user_unit)

		user_slot_extension.delayed_prioritized_user_unit_update_time = nil
	end

	return true
end

SlotSystem.detach_user_unit = function (self, user_unit)
	local user_slot_extension = self._unit_extension_data[user_unit]

	if user_slot_extension then
		Slot.detach_user_unit(user_unit, user_slot_extension, self._unit_extension_data)
	end
end

SlotSystem.register_prioritized_user_unit_update = function (self, unit)
	local user_slot_extension = self._unit_extension_data[unit]
	self._update_slots_user_units_prioritized[unit] = user_slot_extension
end

SlotSystem._prioritize_queued_units_on_slot = function (self, slot)
	if slot and slot.queue then
		local queue = slot.queue
		local queue_n = #queue

		for i = 1, queue_n, 1 do
			local queued_unit = queue[i]

			self:register_prioritized_user_unit_update(queued_unit)
		end
	end
end

SlotSystem.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end

	self._max_slot_update_override = true
end

SlotSystem.is_traverse_logic_initialized = function (self)
	return self._traverse_logic ~= nil
end

return SlotSystem
