-- chunkname: @scripts/extension_systems/group/bot_group.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BotAoeThreat = require("scripts/utilities/attack/bot_aoe_threat")
local BotOrder = require("scripts/utilities/bot_order")
local Daemonhost = require("scripts/utilities/daemonhost")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Pickups = require("scripts/settings/pickup/pickups")
local BLACKBOARDS = BLACKBOARDS
local BotGroup = class("BotGroup")

BotGroup.init = function (self, side, nav_world, traverse_logic, extension_manager)
	self._nav_world = nav_world
	self._traverse_logic = traverse_logic
	self._broadphase_system = extension_manager:system("broadphase_system")
	self._moveable_platform_system = Managers.state.extension:system("moveable_platform_system")
	self._last_move_target_unit = nil
	self._last_move_target_rotations = {}

	local mule_pickups = {}

	for _, pickup_settings in pairs(Pickups) do
		if pickup_settings.bots_mule_pickup then
			local slot = pickup_settings.slot_name

			mule_pickups[slot] = mule_pickups[slot] or {}
		end
	end

	self._available_mule_pickups = mule_pickups
	self._available_health_pickups = {}
	self._side = side
	self._bot_data = {}
	self._num_bots = 0
	self.priority_targets = Script.new_map(4)
	self.priority_targets_duration = Script.new_map(4)
	self._urgent_targets = {}
	self._ally_needs_aid_priority = {}
	self._disallowed_nav_tag_layer_ids = {}
	self._t = 0
	self._in_carry_event = false

	local up = Vector3.up()

	self._left_vectors_outside_volume = {
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 1 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 2 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 3 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 4 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 5 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 6 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 7 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 0 / 8)))
	}
	self._right_vectors_outside_volume = {
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 1 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 2 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 3 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 4 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 5 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 6 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 7 / 8)))
	}
	self._left_vectors = {
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 0.5))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 5 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 3 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 6 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 2 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 7 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 1 / 8)))
	}
	self._right_vectors = {
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 0.5))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 5 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 3 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 6 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 2 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 7 / 8))),
		Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 1 / 8)))
	}
	self._previous_available_pickups_player_unit_index = 0
	self._update_pickups_at = -math.huge
	self._used_covers = {}
	self._pathing_points = {}
end

BotGroup.add_bot_unit = function (self, unit)
	local blackboard, unit_data_extension = BLACKBOARDS[unit], ScriptUnit.extension(unit, "unit_data_system")
	local data = {
		nav_point_utility = {},
		aoe_threat = {
			expires = -math.huge,
			escape_direction = Vector3Box()
		},
		pickup_orders = {},
		behavior_component = Blackboard.write_component(blackboard, "behavior"),
		perception_component = Blackboard.write_component(blackboard, "perception"),
		pickup_component = Blackboard.write_component(blackboard, "pickup"),
		behavior_extension = ScriptUnit.extension(unit, "behavior_system"),
		navigation_extension = ScriptUnit.extension(unit, "navigation_system"),
		character_state_component = unit_data_extension:read_component("character_state")
	}

	self._bot_data[unit] = data
	self._num_bots = self._num_bots + 1
end

BotGroup.data = function (self)
	local data = self._bot_data

	return data
end

BotGroup.data_by_unit = function (self, unit)
	local data = self._bot_data[unit]

	return data
end

BotGroup.remove_bot_unit = function (self, unit)
	self._bot_data[unit] = nil
	self._num_bots = self._num_bots - 1
end

BotGroup.set_in_carry_event = function (self, enable)
	self._in_carry_event = enable
end

local BOT_RADIUS = 0.75
local BOT_HEIGHT = 1.8

BotGroup.aoe_threat_created = function (self, position, shape, size, rotation, duration)
	local detect_func

	if shape == "oobb" then
		detect_func = BotAoeThreat.detect_oobb
	elseif shape == "cylinder" then
		detect_func = BotAoeThreat.detect_cylinder
	elseif shape == "sphere" then
		detect_func = BotAoeThreat.detect_sphere
	end

	local t = self._t
	local expires = t + duration
	local nav_world, traverse_logic = self._nav_world, self._traverse_logic
	local pos_x, pos_y, pos_z = position.x, position.y, position.z
	local bot_data = self._bot_data

	for unit, data in pairs(bot_data) do
		local threat_data = data.aoe_threat

		if expires > threat_data.expires then
			local bot_position = POSITION_LOOKUP[unit]
			local escape_dir = detect_func(nav_world, traverse_logic, bot_position, BOT_HEIGHT, BOT_RADIUS, pos_x, pos_y, pos_z, rotation, size, duration)

			if escape_dir then
				threat_data.expires = expires

				threat_data.escape_direction:store(escape_dir)

				threat_data.dodge_t = math.min(t + math.random() * 0.5, expires)
			end
		end
	end
end

BotGroup.set_in_cover = function (self, bot_unit, cover_hash)
	self._used_covers[bot_unit] = cover_hash
end

BotGroup.in_cover = function (self, wanted_cover_hash)
	local used_covers = self._used_covers

	for bot_unit, cover_hash in pairs(used_covers) do
		if cover_hash == wanted_cover_hash then
			return bot_unit
		end
	end

	return nil
end

local ALLY_AID_PRIORITY_STICKINESS_DISTANCE = 3

BotGroup.register_ally_needs_aid_priority = function (self, bot_unit, target_ally)
	local set_new_aider = true
	local ally_needs_aid_priority = self._ally_needs_aid_priority
	local aider_unit = ally_needs_aid_priority[target_ally]

	if aider_unit then
		local bot_data = self._bot_data
		local current_aider_data, new_aider_data = bot_data[aider_unit], bot_data[bot_unit]
		local current_aider_perception_component = current_aider_data.perception_component
		local new_aider_perception_component = new_aider_data.perception_component
		local current_aider_distance = current_aider_perception_component.target_ally_distance
		local new_aider_distance = new_aider_perception_component.target_ally_distance

		set_new_aider = new_aider_distance < current_aider_distance - ALLY_AID_PRIORITY_STICKINESS_DISTANCE
	end

	if set_new_aider then
		ally_needs_aid_priority[target_ally] = bot_unit
	end
end

BotGroup.is_prioritized_ally = function (self, bot_unit, target_ally)
	local is_prioritized_ally = self._ally_needs_aid_priority[target_ally] == bot_unit

	return is_prioritized_ally
end

BotGroup.pickup_order = function (self, bot_unit, slot_name)
	local bot_data = self._bot_data[bot_unit]
	local order = bot_data.pickup_orders[slot_name]

	return order
end

BotGroup.ammo_pickup_order_unit = function (self, bot_unit)
	local bot_data = self._bot_data[bot_unit]
	local pickup_unit = bot_data.ammo_pickup_order_unit

	return pickup_unit
end

BotGroup.has_pending_pickup_order = function (self, bot_unit)
	local bot_data = self._bot_data[bot_unit]
	local pickup_orders = bot_data.pickup_orders

	for _, order in pairs(pickup_orders) do
		if order.unit then
			return true
		end
	end

	return false
end

BotGroup.update = function (self, side, dt, t)
	self._t = t

	local num_bots = self._num_bots

	if num_bots == 0 then
		return
	end

	local bot_data = self._bot_data
	local nav_world = self._nav_world

	self:_update_move_targets(bot_data, num_bots, nav_world, side)
	self:_update_priority_targets(bot_data, side, dt)
	self:_update_ally_needs_aid_priority(bot_data)
	self:_update_pickups(bot_data, side, dt, t)
end

local ADDITIONAL_PRESENCE_DISTANCE = 5

BotGroup._check_unaggroed_daemonhost_presence = function (self, side, unit_position)
	local enemy_daemonhost = side:alive_units_by_tag("enemy", "witch")
	local num_enemy_daemonhosts = enemy_daemonhost.size

	if num_enemy_daemonhosts == 0 then
		return false, nil
	end

	local in_unaggroed_daemonhost_presence, daemonhost_position = false
	local game_session = Managers.state.game_session:game_session()
	local unit_spawner_manager = Managers.state.unit_spawner
	local game_object_field = GameSession.game_object_field
	local aggroed_minions = side.aggroed_minion_target_units

	for i = 1, num_enemy_daemonhosts do
		local daemonhost = enemy_daemonhost[i]

		if not aggroed_minions[daemonhost] then
			local go_id = unit_spawner_manager:game_object_id(daemonhost)
			local stage = game_object_field(game_session, go_id, "stage")
			local distances = Daemonhost.anger_distance_settings(stage)
			local furthest_distance = distances[#distances].distance + ADDITIONAL_PRESENCE_DISTANCE
			local furthest_distance_sq = furthest_distance^2
			local daemonhost_pos = POSITION_LOOKUP[daemonhost]
			local distance_sq = Vector3.distance_squared(unit_position, daemonhost_pos)

			if distance_sq <= furthest_distance_sq then
				in_unaggroed_daemonhost_presence = true
				daemonhost_position = daemonhost_pos

				break
			end
		end
	end

	return in_unaggroed_daemonhost_presence, daemonhost_position
end

local TEMP_HUMAN_UNITS = {}
local TEMP_DISABLED_HUMAN_UNITS = {}
local TEMP_MAN_MAN_POINTS = {}

BotGroup._update_move_targets = function (self, bot_data, num_bots, nav_world, side)
	local human_units = side.valid_human_units
	local num_human_units = #human_units

	for i = 1, num_human_units do
		local human_unit = human_units[i]
		local unit_data_extension = ScriptUnit.extension(human_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

		if is_disabled then
			TEMP_DISABLED_HUMAN_UNITS[#TEMP_DISABLED_HUMAN_UNITS + 1] = human_unit
		else
			TEMP_HUMAN_UNITS[#TEMP_HUMAN_UNITS + 1] = human_unit
		end
	end

	local num_units, num_disabled_units = #TEMP_HUMAN_UNITS, #TEMP_DISABLED_HUMAN_UNITS

	if num_units == 0 and num_disabled_units > 0 then
		TEMP_HUMAN_UNITS, TEMP_DISABLED_HUMAN_UNITS = TEMP_DISABLED_HUMAN_UNITS, TEMP_HUMAN_UNITS
		num_units = num_disabled_units
	end

	local selected_unit
	local in_carry_event, last_move_target_unit = self._in_carry_event, self._last_move_target_unit

	if num_units == 0 then
		selected_unit = nil
	elseif num_units >= 3 then
		if in_carry_event then
			local bot_unit, _ = next(bot_data)

			selected_unit = self:_find_most_lonely_move_target(TEMP_HUMAN_UNITS, bot_unit)
		else
			selected_unit = self:_find_least_lonely_move_target(TEMP_HUMAN_UNITS, last_move_target_unit)
		end
	elseif num_units == 2 and num_bots == 2 and in_carry_event then
		for j = 1, num_units do
			local unit = TEMP_HUMAN_UNITS[j]
			local unit_position = POSITION_LOOKUP[unit]
			local disallowed_at_position, volume_points = self:_selected_unit_is_in_disallowed_nav_tag_volume(nav_world, unit_position)
			local needed_points, destination_points = 1

			if disallowed_at_position then
				local origin_point = self:_find_origin(nav_world, unit_position)

				destination_points = self:_find_destination_points_outside_volume(nav_world, unit_position, volume_points, origin_point, needed_points)
			else
				local in_unaggroed_daemonhost_presence, daemonhost_position = self:_check_unaggroed_daemonhost_presence(side, unit_position)
				local cluster_position, rotation = self:_find_cluster_position(nav_world, unit, unit_position, in_unaggroed_daemonhost_presence, daemonhost_position)

				destination_points = self:_find_destination_points(nav_world, cluster_position, rotation, needed_points)
			end

			table.append(TEMP_MAN_MAN_POINTS, destination_points)
		end

		self:_assign_destination_points(bot_data, TEMP_MAN_MAN_POINTS, nil, TEMP_HUMAN_UNITS)
		table.clear(TEMP_HUMAN_UNITS)
		table.clear(TEMP_DISABLED_HUMAN_UNITS)
		table.clear(TEMP_MAN_MAN_POINTS)

		return
	else
		local average_bot_pos = Vector3(0, 0, 0)

		for unit, _ in pairs(bot_data) do
			average_bot_pos = average_bot_pos + POSITION_LOOKUP[unit]
		end

		average_bot_pos = average_bot_pos / num_bots
		selected_unit = self:_find_closest_move_target(TEMP_HUMAN_UNITS, last_move_target_unit, average_bot_pos)
	end

	local bot_follow_disabled
	local locked_on_platform = self._moveable_platform_system:units_are_locked()

	if locked_on_platform then
		bot_follow_disabled = true
	end

	if selected_unit and not bot_follow_disabled then
		self._last_move_target_unit = selected_unit

		local unit_position = POSITION_LOOKUP[selected_unit]
		local disallowed_at_position, volume_points = self:_selected_unit_is_in_disallowed_nav_tag_volume(nav_world, unit_position)
		local destination_points

		if disallowed_at_position then
			local origin_point = self:_find_origin(nav_world, unit_position)

			destination_points = self:_find_destination_points_outside_volume(nav_world, unit_position, volume_points, origin_point, num_bots)
		else
			local in_unaggroed_daemonhost_presence, daemonhost_position = self:_check_unaggroed_daemonhost_presence(side, unit_position)
			local cluster_position, rotation = self:_find_cluster_position(nav_world, selected_unit, unit_position, in_unaggroed_daemonhost_presence, daemonhost_position)

			destination_points = self:_find_destination_points(nav_world, cluster_position, rotation, num_bots)
		end

		self:_assign_destination_points(bot_data, destination_points, selected_unit)
	else
		for _, data in pairs(bot_data) do
			data.follow_unit, data.follow_position = nil
		end
	end

	table.clear(TEMP_HUMAN_UNITS)
	table.clear(TEMP_DISABLED_HUMAN_UNITS)
end

local TEMP_PLAYER_POSITIONS = {}
local LONELINESS_FAR_AWAY_DISTANCE_SQ = 900
local LONELINESS_FAR_AWAY_MODIFIER = 3

BotGroup._find_most_lonely_move_target = function (self, targets, origin_unit)
	local num_targets = #targets

	for i = 1, num_targets do
		local unit = targets[i]

		TEMP_PLAYER_POSITIONS[i] = POSITION_LOOKUP[unit]
	end

	local most_lonely_index, most_lonely_value = nil, -math.huge
	local origin = POSITION_LOOKUP[origin_unit]
	local Vector3_distance_squared = Vector3.distance_squared
	local num_positions = #TEMP_PLAYER_POSITIONS

	for i = 1, num_positions do
		local position1 = TEMP_PLAYER_POSITIONS[i]
		local loneliness
		local distance_sq = Vector3_distance_squared(position1, origin)

		if distance_sq > LONELINESS_FAR_AWAY_DISTANCE_SQ then
			loneliness = -distance_sq * LONELINESS_FAR_AWAY_MODIFIER
		else
			loneliness = 0
		end

		for j = 1, num_positions do
			local position2 = TEMP_PLAYER_POSITIONS[j]

			loneliness = loneliness + Vector3_distance_squared(position1, position2)
		end

		if most_lonely_value < loneliness then
			most_lonely_index, most_lonely_value = i, loneliness
		end
	end

	table.clear(TEMP_PLAYER_POSITIONS)

	return targets[most_lonely_index]
end

local LONELINESS_PREVIOUS_TARGET_STICKINESS = 25

BotGroup._find_least_lonely_move_target = function (self, targets, last_target)
	local num_targets = #targets

	for i = 1, num_targets do
		local unit = targets[i]

		TEMP_PLAYER_POSITIONS[i] = POSITION_LOOKUP[unit]
	end

	local Vector3_distance_squared = Vector3.distance_squared
	local least_lonely_index, least_lonely_value = nil, math.huge
	local num_positions = #TEMP_PLAYER_POSITIONS

	for i = 1, num_positions do
		local position1 = TEMP_PLAYER_POSITIONS[i]
		local loneliness

		if targets[i] == last_target then
			loneliness = -LONELINESS_PREVIOUS_TARGET_STICKINESS
		else
			loneliness = 0
		end

		for j = 1, num_positions do
			local position2 = TEMP_PLAYER_POSITIONS[j]

			loneliness = loneliness + Vector3_distance_squared(position1, position2)
		end

		if loneliness < least_lonely_value then
			least_lonely_index, least_lonely_value = i, loneliness
		end
	end

	table.clear(TEMP_PLAYER_POSITIONS)

	return targets[least_lonely_index]
end

local function _fetch_nav_tag_volume_points(nav_tag_volume)
	local nav_mesh_manager = Managers.state.nav_mesh
	local nav_tag_volume_data = nav_mesh_manager:nav_tag_volume_data()
	local num_nav_tag_volume_data = #nav_tag_volume_data

	for i = 1, num_nav_tag_volume_data do
		local data = nav_tag_volume_data[i]

		if data.nav_tag_volume == nav_tag_volume then
			return data.bottom_points
		end
	end
end

local VOLUME_NAV_MESH_ABOVE, VOLUME_NAV_MESH_BELOW = 2, 2

BotGroup._selected_unit_is_in_disallowed_nav_tag_volume = function (self, nav_world, selected_unit_position)
	local tag_volumes_query = GwNavQueries.tag_volumes_from_position(nav_world, selected_unit_position, VOLUME_NAV_MESH_ABOVE, VOLUME_NAV_MESH_BELOW)
	local result, volume_points = false

	if tag_volumes_query then
		local GwNavQueries_nav_tag_volume, GwNavTagVolume_navtag = GwNavQueries.nav_tag_volume, GwNavTagVolume.navtag
		local disallowed_nav_tag_layer_ids = self._disallowed_nav_tag_layer_ids
		local volume_count = GwNavQueries.nav_tag_volume_count(tag_volumes_query)

		for i = 1, volume_count do
			local nav_tag_volume = GwNavQueries_nav_tag_volume(tag_volumes_query, i)
			local _, _, layer_id, _, _ = GwNavTagVolume_navtag(nav_tag_volume)

			if disallowed_nav_tag_layer_ids[layer_id] then
				result, volume_points = true, _fetch_nav_tag_volume_points(nav_tag_volume)
			end
		end

		GwNavQueries.destroy_query_dynamic_output(tag_volumes_query)
	end

	return result, volume_points
end

local ORIGIN_NAV_MESH_ABOVE, ORIGIN_NAV_MESH_BELOW, ORIGIN_NAV_MESH_LATERAL = 5, 5, 5
local ORIGIN_NAV_MESH_DISTANCE_FROM_NAV_MESH = 0.5

BotGroup._find_origin = function (self, nav_world, unit_position)
	local origin_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, unit_position, ORIGIN_NAV_MESH_ABOVE, ORIGIN_NAV_MESH_BELOW, ORIGIN_NAV_MESH_LATERAL, ORIGIN_NAV_MESH_DISTANCE_FROM_NAV_MESH)

	if origin_position == nil then
		origin_position = unit_position
	end

	return origin_position
end

BotGroup._find_destination_points_outside_volume = function (self, nav_world, selected_unit_position, volume_points, origin_point, needed_points)
	local center_point, area_radius = self:_calculate_center_of_volume(volume_points)
	local range = area_radius + 1
	local direction = Vector3.flat(Vector3.normalize(selected_unit_position - center_point))
	local rotation = Quaternion.look(direction, Vector3.up())
	local space_per_player = range - 1
	local search_point = Vector3(center_point[1], center_point[2], selected_unit_position[3])
	local left_vectors, right_vectors = self._left_vectors_outside_volume, self._right_vectors_outside_volume
	local points = self:_find_points(nav_world, search_point, rotation, left_vectors, right_vectors, space_per_player, range, needed_points)
	local num_points = #points
	local current_index = 1
	local last_point = points[current_index]

	if num_points < needed_points then
		for i = num_points + 1, needed_points do
			points[i] = points[current_index] or last_point or origin_point
			last_point = points[current_index] or last_point
			current_index = current_index + 1
		end
	end

	return points
end

BotGroup._calculate_center_of_volume = function (self, volume_points)
	local center_position = Navigation.nav_tag_volume_points_center(volume_points)
	local Vector3_distance_squared = Vector3.distance_squared
	local longest_distance_sq, num_points = 0, #volume_points

	for i = 1, num_points do
		local point = Vector3.from_array(volume_points[i])
		local distance_sq = Vector3_distance_squared(center_position, point)

		longest_distance_sq = math.max(distance_sq, longest_distance_sq)
	end

	local longest_distance = math.sqrt(longest_distance_sq)

	return center_position, longest_distance
end

local function _add_points(points, from_position, to_position, amount)
	if amount == 0 then
		return
	end

	for i = 1, amount do
		local position = Vector3.lerp(from_position, to_position, i / amount)

		points[#points + 1] = position
	end
end

BotGroup._find_points = function (self, nav_world, origin_point, rotation, left_vectors, right_vectors, space_per_player, range, needed_points)
	local found_points_left, found_points_right = 0, 0
	local left_index, right_index = 0, 0
	local points = self._pathing_points

	table.clear(points)

	while (left_index < #left_vectors or right_index < #right_vectors) and needed_points > found_points_left + found_points_right do
		if left_index + 1 > #left_vectors then
			right_index = right_index + 1

			local distance, hit_pos = self:_raycast(nav_world, origin_point, Quaternion.rotate(rotation, right_vectors[right_index]:unbox()), range)
			local num_points = math.floor(distance / space_per_player)

			_add_points(points, origin_point, hit_pos, num_points)

			found_points_right = found_points_right + num_points
		elseif right_index + 1 > #right_vectors then
			left_index = left_index + 1

			local distance, hit_pos = self:_raycast(nav_world, origin_point, Quaternion.rotate(rotation, left_vectors[left_index]:unbox()), range)
			local num_points = math.floor(distance / space_per_player)

			_add_points(points, origin_point, hit_pos, num_points)

			found_points_left = found_points_left + num_points
		elseif found_points_right == found_points_left then
			left_index = left_index + 1
			right_index = right_index + 1

			local distance_left, hit_pos_left = self:_raycast(nav_world, origin_point, Quaternion.rotate(rotation, left_vectors[left_index]:unbox()), range)
			local distance_right, hit_pos_right = self:_raycast(nav_world, origin_point, Quaternion.rotate(rotation, right_vectors[right_index]:unbox()), range)
			local points_left = math.floor(distance_left / space_per_player)
			local points_right = math.floor(distance_right / space_per_player)
			local points_total = points_left + points_right

			if needed_points < points_total then
				local assign_left = points_left / points_total * needed_points
				local assign_right = points_right / points_total * needed_points
				local floored_assign_left = math.floor(assign_left)
				local fraction = assign_left - floored_assign_left

				if fraction >= 0.5 then
					assign_left = math.ceil(assign_left)
					assign_right = math.floor(assign_right)
				else
					assign_left = floored_assign_left
					assign_right = math.ceil(assign_right)
				end

				_add_points(points, origin_point, hit_pos_left, assign_left)
				_add_points(points, origin_point, hit_pos_right, assign_right)

				found_points_left = found_points_left + assign_left
				found_points_right = found_points_right + assign_right
			else
				_add_points(points, origin_point, hit_pos_left, points_left)
				_add_points(points, origin_point, hit_pos_right, points_right)

				found_points_left = found_points_left + points_left
				found_points_right = found_points_right + points_right
			end
		elseif found_points_left < found_points_right then
			left_index = left_index + 1

			local distance, hit_pos = self:_raycast(nav_world, origin_point, Quaternion.rotate(rotation, left_vectors[left_index]:unbox()), range)
			local num_points = math.floor(distance / space_per_player)

			_add_points(points, origin_point, hit_pos, num_points)

			found_points_left = found_points_left + num_points
		elseif found_points_right < found_points_left then
			right_index = right_index + 1

			local distance, hit_pos = self:_raycast(nav_world, origin_point, Quaternion.rotate(rotation, right_vectors[right_index]:unbox()), range)
			local num_points = math.floor(distance / space_per_player)

			_add_points(points, origin_point, hit_pos, num_points)

			found_points_right = found_points_right + num_points
		end
	end

	return points
end

local SPACE_NEEDED = 0.25

BotGroup._raycast = function (self, nav_world, point, vector, range)
	local ray_range = range + SPACE_NEEDED
	local to = point + vector * ray_range
	local traverse_logic = self._traverse_logic
	local success, pos = GwNavQueries.raycast(nav_world, point, to, traverse_logic)

	if success then
		return range, pos - vector * SPACE_NEEDED
	else
		local distance = Vector3.length(Vector3.flat(pos - point))

		if distance < SPACE_NEEDED then
			return 0, point
		else
			return distance - SPACE_NEEDED, pos - vector * SPACE_NEEDED
		end
	end
end

local CLUSTER_MAX_NAV_MESH_DISTANCE = 4
local CLUSTER_STOP_THRESHOLD_SQ = 0.010000000000000002
local CLUSTER_NAV_MESH_ABOVE, CLUSTER_NAV_MESH_BELOW, CLUSTER_NAV_MESH_LATERAL = 5, 5, 5
local CLUSTER_DISTANCE_FROM_NAV_MESH = 0.5
local CLUSTER_RAYCAST_RANGE = 5
local CLUSTER_RAYCAST_RANGE_DAEMONHOST = 1

BotGroup._find_cluster_position = function (self, nav_world, selected_unit, selected_unit_position, in_unaggroed_daemonhost_presence, daemonhost_position_or_nil)
	local unit_data_extension = ScriptUnit.extension(selected_unit, "unit_data_system")
	local locomotion_component = unit_data_extension:read_component("locomotion")
	local current_velocity = locomotion_component.velocity_current
	local velocity = current_velocity

	if Vector3.length_squared(current_velocity) <= CLUSTER_STOP_THRESHOLD_SQ then
		velocity = Vector3(0, 0, 0)
	end

	local traverse_logic = self._traverse_logic
	local navigation_extension = ScriptUnit.extension(selected_unit, "navigation_system")
	local latest_position_on_nav_mesh = navigation_extension:latest_position_on_nav_mesh()
	local ray_start_position

	if latest_position_on_nav_mesh and Vector3.distance_squared(selected_unit_position, latest_position_on_nav_mesh) < CLUSTER_MAX_NAV_MESH_DISTANCE then
		ray_start_position = latest_position_on_nav_mesh
	else
		ray_start_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, selected_unit_position, CLUSTER_NAV_MESH_ABOVE, CLUSTER_NAV_MESH_BELOW, CLUSTER_NAV_MESH_LATERAL, CLUSTER_DISTANCE_FROM_NAV_MESH)
	end

	local cluster_position

	if ray_start_position then
		local raycast_range = in_unaggroed_daemonhost_presence and CLUSTER_RAYCAST_RANGE_DAEMONHOST or CLUSTER_RAYCAST_RANGE
		local _, ray_position = self:_raycast(nav_world, ray_start_position, velocity, raycast_range)

		cluster_position = Vector3.lerp(ray_start_position, ray_position, 0.6)

		local altitude = GwNavQueries.triangle_from_position(nav_world, cluster_position, CLUSTER_NAV_MESH_ABOVE, CLUSTER_NAV_MESH_BELOW)

		if altitude then
			cluster_position.z = altitude
		else
			cluster_position = ray_position
		end
	else
		cluster_position = selected_unit_position
	end

	local rotation

	if in_unaggroed_daemonhost_presence then
		rotation = Quaternion.look(daemonhost_position_or_nil - cluster_position, Vector3.up())
		self._last_move_target_rotations[selected_unit] = nil
	elseif Vector3.length_squared(velocity) > CLUSTER_STOP_THRESHOLD_SQ then
		rotation = Quaternion.look(velocity, Vector3.up())
		self._last_move_target_rotations[selected_unit] = nil
	elseif self._last_move_target_rotations[selected_unit] then
		rotation = self._last_move_target_rotations[selected_unit]:unbox()
	else
		local first_person_component = unit_data_extension:read_component("first_person")
		local selected_unit_rotation = first_person_component.rotation
		local forward_direction = Quaternion.forward(selected_unit_rotation)
		local flat_forward_direction = Vector3.flat(forward_direction)

		rotation = Quaternion.look(flat_forward_direction, Vector3.up())
		self._last_move_target_rotations[selected_unit] = QuaternionBox(rotation)
	end

	return cluster_position, rotation
end

local DESTINATION_POINTS_SPACE_PER_PLAYER, DESTINATION_POINTS_RANGE = 1, 3

BotGroup._find_destination_points = function (self, nav_world, origin_point, rotation, needed_points)
	local points = self:_find_points(nav_world, origin_point, rotation, self._left_vectors, self._right_vectors, DESTINATION_POINTS_SPACE_PER_PLAYER, DESTINATION_POINTS_RANGE, needed_points)
	local num_points = #points

	if num_points < needed_points then
		for i = num_points + 1, needed_points do
			points[i] = origin_point
		end
	end

	return points
end

local function _find_permutation(current_index, units, tested_points, current_solution, utility, data, best_utility, best_solution)
	local num_units = #units

	if num_units < current_index then
		if best_utility < utility then
			for i = 1, num_units do
				best_solution[i] = current_solution[i]
			end

			return utility
		else
			return best_utility
		end
	else
		local unit = units[current_index]

		for i = 1, num_units do
			if not tested_points[i] then
				current_solution[current_index] = i
				tested_points[i] = true

				local point_utility = data[unit].nav_point_utility[i]
				local new_utility = utility + point_utility

				best_utility = _find_permutation(current_index + 1, units, tested_points, current_solution, new_utility, data, best_utility, best_solution)
				tested_points[i] = false
			end
		end

		return best_utility
	end
end

local TEMP_UNITS = {}
local TEMP_TESTED_POINTS = {}
local TEMP_CURRENT_SOLUTION = {}
local TEMP_BEST_SOLUTION = {}
local DESTINATION_POINTS_EPSILON = 0.001

BotGroup._assign_destination_points = function (self, bot_data, points, follow_unit, follow_unit_table)
	local Vector3_distance = Vector3.distance
	local num_points = #points

	for unit, data in pairs(bot_data) do
		local utility = data.nav_point_utility

		table.clear(utility)

		local position = POSITION_LOOKUP[unit]

		for i = 1, num_points do
			local point = points[i]
			local distance = Vector3_distance(position, point)

			utility[i] = 1 / math.sqrt(math.max(DESTINATION_POINTS_EPSILON, distance))
		end

		TEMP_UNITS[#TEMP_UNITS + 1] = unit
	end

	local best_utility = _find_permutation(1, TEMP_UNITS, TEMP_TESTED_POINTS, TEMP_CURRENT_SOLUTION, 0, bot_data, -math.huge, TEMP_BEST_SOLUTION)
	local num_units = #TEMP_UNITS

	for i = 1, num_units do
		local unit = TEMP_UNITS[i]
		local data = bot_data[unit]
		local behavior_extension = data.behavior_extension
		local hold_position, _ = behavior_extension:hold_position()

		if hold_position then
			data.follow_position = hold_position
			data.follow_unit = nil
		else
			local point_index = TEMP_BEST_SOLUTION[i]

			data.follow_position = points[point_index]

			if follow_unit_table then
				data.follow_unit = follow_unit_table[point_index]
			elseif follow_unit then
				data.follow_unit = follow_unit
			else
				data.follow_unit = nil
			end
		end
	end

	table.clear(TEMP_UNITS)
	table.clear(TEMP_TESTED_POINTS)
	table.clear(TEMP_CURRENT_SOLUTION)
	table.clear(TEMP_BEST_SOLUTION)
end

local CLOSEST_TARGET_PREVIOUS_TARGET_STICKINESS = 3

BotGroup._find_closest_move_target = function (self, targets, last_target, position)
	local Vector3_distance = Vector3.distance
	local closest_index, closest_value = nil, math.huge
	local num_targets = #targets

	for i = 1, num_targets do
		local unit = targets[i]
		local distance = Vector3_distance(position, POSITION_LOOKUP[unit])

		if unit == last_target then
			distance = distance - CLOSEST_TARGET_PREVIOUS_TARGET_STICKINESS
		end

		if distance < closest_value then
			closest_index, closest_value = i, distance
		end
	end

	return targets[closest_index]
end

local PRIORITY_TARGETS_TEMP, PRIORITY_TARGETS_DURATION_TEMP = Script.new_map(4), Script.new_map(4)

BotGroup._update_priority_targets = function (self, bot_data, side, dt)
	local priority_targets, priority_targets_duration = self.priority_targets, self.priority_targets_duration
	local player_units = side.valid_player_units
	local num_players = #player_units

	for i = 1, num_players do
		local player_unit = player_units[i]
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
		local is_pounced, pouncing_unit = PlayerUnitStatus.is_pounced(disabled_character_state_component)

		if is_pounced and pouncing_unit then
			PRIORITY_TARGETS_TEMP[pouncing_unit] = player_unit
			PRIORITY_TARGETS_DURATION_TEMP[pouncing_unit] = (priority_targets_duration[pouncing_unit] or 0) + dt
		end
	end

	for unit, data in pairs(bot_data) do
		local perception_component = data.perception_component
		local current_priority_target = perception_component.priority_target_enemy
		local best_ally, best_utility = nil, -math.huge
		local character_state_component = data.character_state_component

		if not PlayerUnitStatus.is_disabled(character_state_component) then
			local self_position = POSITION_LOOKUP[unit]

			for target, ally in pairs(PRIORITY_TARGETS_TEMP) do
				local duration = PRIORITY_TARGETS_DURATION_TEMP[target]
				local utility = self:_calculate_priority_target_utility(self_position, current_priority_target, target, duration)

				if best_utility < utility then
					best_ally, best_utility = ally, utility
				end
			end
		end

		if perception_component.priority_target_disabled_ally or best_ally then
			perception_component.priority_target_disabled_ally = best_ally
		end
	end

	for priority_target, _ in pairs(priority_targets) do
		if PRIORITY_TARGETS_TEMP[priority_target] then
			priority_targets_duration = PRIORITY_TARGETS_DURATION_TEMP[priority_target]
		else
			priority_targets[priority_target] = nil
			priority_targets_duration[priority_target] = nil
		end
	end

	table.clear(PRIORITY_TARGETS_TEMP)
	table.clear(PRIORITY_TARGETS_DURATION_TEMP)
end

local STICKYNESS_DISTANCE_MODIFIER = -0.2

BotGroup._calculate_priority_target_utility = function (self, self_position, current_target, target, duration)
	local stickyness_modifier = target == current_target and STICKYNESS_DISTANCE_MODIFIER or 0
	local target_position = POSITION_LOOKUP[target]
	local real_distance = Vector3.distance(self_position, target_position)
	local distance = math.max(real_distance, 1)
	local proximity = 1 / (distance + stickyness_modifier)

	return proximity + duration
end

BotGroup._update_ally_needs_aid_priority = function (self, bot_data)
	local ally_needs_aid_priority = self._ally_needs_aid_priority
	local HEALTH_ALIVE = HEALTH_ALIVE

	for target_ally, bot_unit in pairs(ally_needs_aid_priority) do
		local reset_priority_aid = true

		if HEALTH_ALIVE[bot_unit] then
			local data = bot_data[bot_unit]
			local perception_component = data.perception_component
			local target_ally_needs_aid = perception_component.target_ally_needs_aid

			reset_priority_aid = perception_component.target_ally ~= target_ally or not target_ally_needs_aid
		end

		if reset_priority_aid then
			ally_needs_aid_priority[target_ally] = nil
		end
	end
end

local PICKUP_OVERLAP_INTERVAL_MIN, PICKUP_OVERLAP_INTERVAL_MAX = 0.15, 0.25

BotGroup._update_pickups = function (self, bot_data, side, dt, t)
	local Vector3_distance = Vector3.distance
	local ALIVE = ALIVE

	for unit, data in pairs(bot_data) do
		local pickup_component = data.pickup_component
		local ammo_pickup = pickup_component.ammo_pickup

		if ALIVE[ammo_pickup] then
			local bot_position, ammo_position = POSITION_LOOKUP[unit], POSITION_LOOKUP[ammo_pickup]
			local ammo_distance = Vector3_distance(bot_position, ammo_position)

			pickup_component.ammo_pickup_distance = ammo_distance
		elseif ammo_pickup then
			pickup_component.ammo_pickup, pickup_component.ammo_pickup_distance = nil, math.huge
			pickup_component.ammo_pickup_valid_until = -math.huge

			if data.ammo_pickup_order_unit then
				data.ammo_pickup_order_unit = nil
			end
		end
	end

	if t > self._update_pickups_at then
		self._update_pickups_at = t + math.lerp(PICKUP_OVERLAP_INTERVAL_MIN, PICKUP_OVERLAP_INTERVAL_MAX, math.random())

		local player_units = side.valid_player_units
		local num_player_units = #player_units
		local previous_player_unit_index = self._previous_available_pickups_player_unit_index
		local player_unit_index = previous_player_unit_index % num_player_units + 1

		self._previous_available_pickups_player_unit_index = player_unit_index

		local player_unit = player_units[player_unit_index]

		if HEALTH_ALIVE[player_unit] then
			self:_update_pickups_and_deployables_near_player(bot_data, player_unit, t)
		end
	end

	self:_update_mule_pickups(bot_data, side, t)
end

local PICKUP_BROADPHASE_CATEGORY = {
	"pickups"
}
local DEPLOYABLE_BROADPHASE_CATEGORY = {
	"deployable"
}
local UNIT_CHECK_RANGE = 15
local UNIT_CHECK_RESULTS = {}
local PICKUP_VALID_DURATION = 5
local AMMO_MAX_DISTANCE = 5
local AMMO_MAX_FOLLOW_DISTANCE = 15
local AMMO_STICKINESS = 2.5
local HEALTH_DEPLOYABLE_MAX_DISTANCE = 10
local HEALTH_DEPLOYABLE_MAX_FOLLOW_DISTANCE = 15

BotGroup._update_pickups_and_deployables_near_player = function (self, bot_data, player_unit, t)
	local Vector3_distance = Vector3.distance
	local valid_until = t + PICKUP_VALID_DURATION
	local broadphase_system = self._broadphase_system
	local broadphase = broadphase_system.broadphase
	local player_position = POSITION_LOOKUP[player_unit]
	local num_units = Broadphase.query(broadphase, player_position, UNIT_CHECK_RANGE, UNIT_CHECK_RESULTS, PICKUP_BROADPHASE_CATEGORY)
	local pickups_by_name = Pickups.by_name
	local available_mule_pickups = self._available_mule_pickups

	for i = 1, num_units do
		local pickup_unit = UNIT_CHECK_RESULTS[i]
		local pickup_name = Unit.get_data(pickup_unit, "pickup_type")
		local pickup_data = pickups_by_name[pickup_name]

		if pickup_data.bots_mule_pickup then
			local slot_name = pickup_data.slot_name

			available_mule_pickups[slot_name][pickup_unit] = valid_until
		elseif pickup_data.group == "ammo" then
			for unit, data in pairs(bot_data) do
				local follow_position = data.follow_position

				if follow_position then
					local pickup_component = data.pickup_component
					local ammo_pickup_order_unit = data.ammo_pickup_order_unit

					if not ammo_pickup_order_unit or t >= pickup_component.ammo_pickup_valid_until then
						local current_pickup = pickup_component.ammo_pickup
						local bot_position, pickup_position = POSITION_LOOKUP[unit], POSITION_LOOKUP[pickup_unit]
						local distance = Vector3_distance(bot_position, pickup_position)
						local ammo_condition = (distance < AMMO_MAX_DISTANCE or follow_position and Vector3_distance(follow_position, pickup_position) < AMMO_MAX_FOLLOW_DISTANCE) and (not current_pickup or distance - (current_pickup == pickup_unit and AMMO_STICKINESS or 0) < pickup_component.ammo_pickup_distance)

						if ammo_condition then
							pickup_component.ammo_pickup = pickup_unit
							pickup_component.ammo_pickup_valid_until = valid_until
							pickup_component.ammo_pickup_distance = distance

							if ammo_pickup_order_unit then
								data.ammo_pickup_order_unit = nil
							end
						end
					end
				end
			end
		end
	end

	num_units = Broadphase.query(broadphase, player_position, UNIT_CHECK_RANGE, UNIT_CHECK_RESULTS, DEPLOYABLE_BROADPHASE_CATEGORY)

	for i = 1, num_units do
		local found_unit = UNIT_CHECK_RESULTS[i]
		local deployable_name = Unit.get_data(found_unit, "deployable_type")

		if deployable_name == "medical_crate" then
			for unit, data in pairs(bot_data) do
				local follow_position = data.follow_position

				if follow_position then
					local pickup_component = data.pickup_component
					local bot_position, unit_position = POSITION_LOOKUP[unit], POSITION_LOOKUP[found_unit]
					local distance = Vector3_distance(bot_position, unit_position)
					local distance_to_follow_position = Vector3_distance(follow_position, unit_position)
					local within_max_distance = distance < HEALTH_DEPLOYABLE_MAX_DISTANCE
					local within_follow_distance = follow_position and distance_to_follow_position < HEALTH_DEPLOYABLE_MAX_FOLLOW_DISTANCE
					local condition = within_max_distance or within_follow_distance

					if condition then
						pickup_component.health_deployable = found_unit
						pickup_component.health_deployable_valid_until = valid_until
					end
				end
			end
		end
	end
end

local BOT_POSES = {}
local BOT_HEALTH = {}
local STICKINESS = 225
local HP_DISTANCE_MODIFIER = 225
local BOT_PICKUP_COMPONENTS = {}

local function _find_health_permutation(current_bot_index, current_utility, solution, best_utility, best_solution, empties_left, health_item_lookup, health_item_list, num_valid_bots)
	if num_valid_bots < current_bot_index then
		if current_utility < best_utility then
			for i = 1, num_valid_bots do
				best_solution[i] = solution[i]
			end

			return current_utility
		else
			return best_utility
		end
	else
		local perception_component = BOT_PICKUP_COMPONENTS[current_bot_index]
		local current_pickup = perception_component.health_deployable
		local bot_position = BOT_POSES[current_bot_index]
		local bot_hp = BOT_HEALTH[current_bot_index] or 0
		local Vector3_distance_squared = Vector3.distance_squared

		for unit, position in pairs(health_item_list) do
			if health_item_lookup[unit] then
				local stickiness_modifier = current_pickup == unit and STICKINESS or 0
				local utility = current_utility + Vector3_distance_squared(bot_position, position) - stickiness_modifier - bot_hp * HP_DISTANCE_MODIFIER

				health_item_lookup[unit] = nil
				solution[current_bot_index] = unit
				best_utility = _find_health_permutation(current_bot_index + 1, utility, solution, best_utility, best_solution, empties_left, health_item_lookup, health_item_list, num_valid_bots)
				solution[current_bot_index] = nil
				health_item_lookup[unit] = position
			end
		end

		if empties_left > 0 then
			best_utility = _find_health_permutation(current_bot_index + 1, current_utility, solution, best_utility, best_solution, empties_left - 1, health_item_lookup, health_item_list, num_valid_bots)
		end

		return best_utility
	end
end

local BOT_UNITS = {}
local SOLUTION_TEMP = {}
local BEST_SOLUTION_TEMP = {}
local BOT_INDICES = {}
local MAX_PICKUP_RANGE = 15
local AUXILIARY_HEALTH_SLOT_ITEMS_TEMP = {}
local RESERVED_HEALTH_ITEMS_TEMP = {}
local HEALTH_ITEMS_TEMP = {}
local HEALTH_ITEMS_TEMP_TEMP = {}
local ASSIGNED_MULE_PICKUPS_TEMP = {}
local MULE_PICKUP_MAX_DISTANCE_SQ = 400

BotGroup._update_mule_pickups = function (self, bot_data, side, t)
	local Vector3_distance_squared = Vector3.distance_squared

	table.clear(ASSIGNED_MULE_PICKUPS_TEMP)

	local ALIVE, POSITION_LOOKUP = ALIVE, POSITION_LOOKUP
	local available_mule_pickups = self._available_mule_pickups

	for unit, data in pairs(bot_data) do
		local best_order, best_distance_sq = nil, math.huge
		local pickup_orders = data.pickup_orders

		for slot_name, available_pickups in pairs(available_mule_pickups) do
			local order = pickup_orders[slot_name]
			local ordered_unit = order and order.unit

			if ordered_unit then
				available_pickups[ordered_unit] = nil
				ASSIGNED_MULE_PICKUPS_TEMP[ordered_unit] = true

				local distance_sq = Vector3_distance_squared(POSITION_LOOKUP[ordered_unit], POSITION_LOOKUP[unit])

				if distance_sq < best_distance_sq then
					best_order = ordered_unit
					best_distance_sq = distance_sq
				end
			end
		end

		if best_order then
			local pickup_component = data.pickup_component

			pickup_component.mule_pickup = best_order
			pickup_component.mule_pickup_distance = math.sqrt(best_distance_sq)
		end
	end

	local Vector3_distance = Vector3.distance

	for unit, data in pairs(bot_data) do
		local pickup_component = data.pickup_component
		local current_pickup = pickup_component.mule_pickup

		if current_pickup then
			local pickup_position = POSITION_LOOKUP[current_pickup]

			if ASSIGNED_MULE_PICKUPS_TEMP[current_pickup] then
				local order

				if not order or order.unit ~= current_pickup then
					pickup_component.mule_pickup = nil
				end
			elseif not ALIVE[current_pickup] or Vector3_distance_squared(pickup_position, data.follow_position or pickup_position) > MULE_PICKUP_MAX_DISTANCE_SQ then
				pickup_component.mule_pickup = nil
			else
				ASSIGNED_MULE_PICKUPS_TEMP[current_pickup] = true

				local bot_position = POSITION_LOOKUP[unit]

				pickup_component.mule_pickup_distance = Vector3_distance(bot_position, pickup_position)
			end
		end
	end

	local human_units = side.valid_human_units
	local num_human_units = #human_units

	for slot_name, available_pickups in pairs(available_mule_pickups) do
		local num_items = 0

		for unit, valid_until in pairs(available_pickups) do
			if ALIVE[unit] and t <= valid_until then
				num_items = num_items + 1
			else
				available_pickups[unit] = nil
			end
		end

		local num_nearby_humans = 0

		for i = 1, num_human_units do
			local human_unit = human_units[i]

			if HEALTH_ALIVE[human_unit] then
				local item

				if not item then
					local human_position = POSITION_LOOKUP[human_unit]

					for pickup_unit, _ in pairs(available_pickups) do
						local pickup_position = POSITION_LOOKUP[pickup_unit]

						if Vector3_distance_squared(pickup_position, human_position) < MULE_PICKUP_MAX_DISTANCE_SQ then
							num_nearby_humans = num_nearby_humans + 1

							break
						end
					end
				end
			end
		end

		if num_nearby_humans == 0 then
			for unit, data in pairs(bot_data) do
				local pickup_component = data.pickup_component
				local order = data.pickup_orders[slot_name]
				local is_slot_free = true

				if not pickup_component.mule_pickup and is_slot_free and not order then
					local best_pickup, best_pickup_distance_sq = nil, math.huge

					for pickup_unit, _ in pairs(available_pickups) do
						if not ASSIGNED_MULE_PICKUPS_TEMP[pickup_unit] then
							local pickup_position = POSITION_LOOKUP[pickup_unit]
							local bot_position = POSITION_LOOKUP[unit]
							local bot_distance_sq = Vector3_distance_squared(bot_position, pickup_position)
							local follow_distance_sq = Vector3_distance_squared(data.follow_position or bot_position, pickup_position)

							if follow_distance_sq < MULE_PICKUP_MAX_DISTANCE_SQ and bot_distance_sq < best_pickup_distance_sq then
								best_pickup, best_pickup_distance_sq = pickup_unit, bot_distance_sq
							end
						end
					end

					if best_pickup then
						pickup_component.mule_pickup = best_pickup
						pickup_component.mule_pickup_distance = math.sqrt(best_pickup_distance_sq)
						ASSIGNED_MULE_PICKUPS_TEMP[best_pickup] = true
					end
				end
			end
		end
	end
end

BotGroup.rpc_bot_unit_order = function (self, channel_id, order_type_id, bot_unit_id, order_target_id, ordering_player_peer_id, ordering_local_player_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local bot_unit = unit_spawner_manager:unit(bot_unit_id)
	local target_unit = unit_spawner_manager:unit(order_target_id)
	local ordering_player = Managers.player:player(ordering_player_peer_id, ordering_local_player_id)
	local ALIVE = ALIVE

	if ALIVE[bot_unit] and ALIVE[target_unit] and ordering_player then
		local order_type = NetworkLookup.bot_orders[order_type_id]

		BotOrder[order_type](bot_unit, target_unit, ordering_player)
	end
end

BotGroup.rpc_bot_lookup_order = function (self, channel_id, order_type_id, bot_unit_id, order_target_id, ordering_player_peer_id, ordering_local_player_id)
	local bot_unit = Managers.state.unit_spawner:unit(bot_unit_id)
	local ordering_player = Managers.player:player(ordering_player_peer_id, ordering_local_player_id)

	if ALIVE[bot_unit] and ordering_player then
		local order_type = NetworkLookup.bot_orders[order_type_id]
		local lookup_name = BotOrder.lookup[order_type]
		local target = NetworkLookup[lookup_name][order_target_id]

		BotOrder[order_type](bot_unit, target, ordering_player)
	end
end

return BotGroup
