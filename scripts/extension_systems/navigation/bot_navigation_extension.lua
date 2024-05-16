-- chunkname: @scripts/extension_systems/navigation/bot_navigation_extension.lua

local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerNavTransitionGenerator = require("scripts/extension_systems/navigation/player_nav_transition_generator")
local BotNavigationExtension = class("BotNavigationExtension")

BotNavigationExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local nav_world = extension_init_context.nav_world
	local nav_tag_allowed_layers, nav_cost_map_multipliers = extension_init_data.nav_tag_allowed_layers, extension_init_data.nav_cost_map_multipliers
	local traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table = Navigation.create_traverse_logic(nav_world, nav_tag_allowed_layers, nav_cost_map_multipliers, false)

	self._traverse_logic, self._nav_tag_cost_table, self._nav_cost_map_multiplier_table = traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table
	self._unit = unit
	self._nav_world = nav_world
	self._player_nav_transition_generator = PlayerNavTransitionGenerator:new(unit, nav_world, traverse_logic)
	self._player = extension_init_data.player
	self._close_to_goal_t = nil
	self._final_goal_reached = false
	self._position_when_final_goal_reached = Vector3Box(0, 0, 0)
	self._destination = Vector3Box(0, 0, 0)
	self._has_queued_target = false
	self._queued_target_position = Vector3Box(0, 0, 0)
	self._astar, self._live_path = GwNavAStar.create(), GwNavAStar.create_live_path()
	self._running_astar = false
	self._astar_cancelled = false
	self._path = nil
	self._path_nav_graphs = nil
	self._last_successful_path_t = 0
	self._num_successive_failed_paths = 0
	self.is_on_nav_mesh = nil
	self._latest_position_on_nav_mesh, self._is_latest_position_on_nav_mesh_valid = Vector3Box(Vector3.invalid_vector()), false

	self:update_position(unit)
end

BotNavigationExtension.register_extension_update = function (self, unit)
	local navigation_system = Managers.state.extension:system("navigation_system")

	navigation_system:set_enabled_unit(unit, true)
end

BotNavigationExtension.destroy = function (self)
	GwNavAStar.destroy_live_path(self._live_path)

	local astar = self._astar

	if not GwNavAStar.processing_finished(astar) then
		GwNavAStar.cancel(astar)
	end

	GwNavAStar.destroy(astar)
	GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
	GwNavCostMapMultiplierTable.destroy(self._nav_cost_map_multiplier_table)
	GwNavTraverseLogic.destroy(self._traverse_logic)
end

BotNavigationExtension.update = function (self, unit, t)
	self:_update_destination(unit, t)
end

BotNavigationExtension.fixed_update = function (self, unit, dt, t, ...)
	local is_on_nav_mesh, latest_position_on_nav_mesh = self.is_on_nav_mesh, self:latest_position_on_nav_mesh()

	self._player_nav_transition_generator:fixed_update(unit, is_on_nav_mesh, latest_position_on_nav_mesh)
end

BotNavigationExtension._update_destination = function (self, unit, t)
	if self._astar_cancelled then
		self._astar_cancelled = false
	end

	if self._running_astar then
		self:_update_astar(t)
	end

	self:_update_path(unit, t)
end

local LAST_NODE_NAV_MESH_CHECK_ABOVE = 0.3
local LAST_NODE_NAV_MESH_CHECK_BELOW = 0.3

BotNavigationExtension._update_astar = function (self, t)
	local astar = self._astar
	local result = GwNavAStar.processing_finished(astar)

	if result then
		if GwNavAStar.path_found(astar) then
			local num_nodes = GwNavAStar.node_count(astar)
			local nav_world, traverse_logic = self._nav_world, self._traverse_logic
			local path_last_node_position = GwNavAStar.node_at_index(astar, num_nodes)
			local last_node_position = NavQueries.position_on_mesh(nav_world, path_last_node_position, LAST_NODE_NAV_MESH_CHECK_ABOVE, LAST_NODE_NAV_MESH_CHECK_BELOW, traverse_logic)

			if not last_node_position and num_nodes <= 2 then
				self:_path_failed(t)
			else
				self._path = Script.new_array(num_nodes)
				self._path_nav_graphs = GwNavAStar.nav_graphs(astar)

				self:_path_successful(t)

				local GwNavAStar_node_at_index = GwNavAStar.node_at_index

				for i = 1, num_nodes - 1 do
					local position = GwNavAStar_node_at_index(astar, i)

					self._path[i] = Vector3Box(position)
				end

				self._path[num_nodes] = last_node_position and Vector3Box(last_node_position) or nil
				self._path_index = 2
				self._close_to_goal_t = nil

				GwNavAStar.init_live_path(self._live_path, astar)
			end
		else
			self:_path_failed(t)
		end

		self._running_astar = false
		self._last_path = nil
		self._last_path_index = nil

		if self._has_queued_target then
			self._has_queued_target = false

			self:move_to(self._queued_target_position:unbox(), self._queued_path_callback)

			self._queued_path_callback = nil
		end
	end
end

BotNavigationExtension._path_failed = function (self, t)
	self._num_successive_failed_paths = self._num_successive_failed_paths + 1

	local cb = self._path_callback

	if cb then
		cb(false, self._destination:unbox())
	end
end

BotNavigationExtension._path_successful = function (self, t)
	self._last_successful_path_t = t
	self._num_successive_failed_paths = 0

	local cb = self._path_callback

	if cb then
		cb(true, self._destination:unbox())
	end
end

local MAX_TIME_IN_TRANSITION = 10
local MAX_TIME_IN_TELEPORT_FRIENDLY_TRANSITION = 5

BotNavigationExtension._update_path = function (self, unit, t)
	local path = self._path

	if not path or self._final_goal_reached then
		return
	end

	local position = POSITION_LOOKUP[unit]
	local current_path_index = self._path_index
	local previous_path_index = current_path_index - 1
	local previous_goal = path[previous_path_index]:unbox()
	local current_transition = self._current_transition

	if current_transition and current_transition.is_following_waypoint then
		local transition_waypoint = current_transition.waypoint:unbox()
		local transition_waypoint_reached = self:_goal_reached(position, transition_waypoint, previous_goal, t)

		if transition_waypoint_reached then
			current_transition.is_following_waypoint = false
		else
			return
		end
	end

	local transition_type = current_transition and current_transition.type
	local teleport_friendly_transition = transition_type == "bot_jumps" or transition_type == "bot_drops" or transition_type == "bot_leap_of_faith"
	local time_in_transition = transition_type and t - current_transition.t

	if current_transition == nil or not teleport_friendly_transition and time_in_transition >= MAX_TIME_IN_TRANSITION then
		local is_path_valid = GwNavAStar.is_valid(self._live_path, self._astar)

		if not is_path_valid then
			self:move_to(self._destination:unbox())

			return
		end
	elseif teleport_friendly_transition and time_in_transition >= MAX_TIME_IN_TELEPORT_FRIENDLY_TRANSITION then
		PlayerMovement.teleport(self._player, current_transition.transition_end:unbox(), Quaternion.identity())

		return
	end

	local current_goal = path[current_path_index]:unbox()
	local goal_reached = self:_goal_reached(position, current_goal, previous_goal, t)

	if goal_reached then
		local new_path_index = current_path_index + 1

		self._path_index = new_path_index

		local final_reached = new_path_index > #path

		self._final_goal_reached = final_reached

		if final_reached then
			self._position_when_final_goal_reached:store(position)

			self._current_transition = nil
		else
			self._current_transition = self:_reevaluate_current_nav_transition(current_path_index, t)
		end
	end
end

local FLAT_THRESHOLD_DEFAULT = 0.05
local TIME_UNTIL_RAMP_THRESHOLD = 0.25
local MAX_FLAT_THRESHOLD = 0.2
local RAMP_TIME = 0.25
local RAMP_SPEED = (MAX_FLAT_THRESHOLD - FLAT_THRESHOLD_DEFAULT) / RAMP_TIME

BotNavigationExtension._goal_reached = function (self, position, goal, previous_goal, t)
	local unit_to_goal_direction = goal - position
	local previous_to_goal_direction = goal - previous_goal
	local dot = Vector3.dot(unit_to_goal_direction, previous_to_goal_direction)
	local passed_goal = dot < 0
	local remaining = goal - position
	local distance_z = remaining.z
	local flat_distance = Vector3.length(Vector3.flat(remaining))
	local flat_threshold = FLAT_THRESHOLD_DEFAULT
	local close_to_goal_t = self._close_to_goal_t

	if close_to_goal_t then
		flat_threshold = math.clamp(flat_threshold + (t - close_to_goal_t - TIME_UNTIL_RAMP_THRESHOLD) * RAMP_SPEED, FLAT_THRESHOLD_DEFAULT, MAX_FLAT_THRESHOLD)
	end

	local at_goal = flat_distance < flat_threshold and distance_z > -0.35 and distance_z < 0.5
	local goal_reached = passed_goal or at_goal

	if goal_reached then
		self._close_to_goal_t = nil
	elseif flat_distance < MAX_FLAT_THRESHOLD and not close_to_goal_t then
		self._close_to_goal_t = t
	end

	return goal_reached
end

local START_NODE_INDEX = 0
local END_NODE_INDEX = 1
local SMART_OBJECT_ID_INDEX = 2
local LAYER_ID_INDEX = 3
local STEP_LENGTH = 4

BotNavigationExtension._reevaluate_current_nav_transition = function (self, path_index, t)
	local path_nav_graphs = self._path_nav_graphs

	if not path_nav_graphs then
		return nil
	end

	local path_nav_graphs_size = #path_nav_graphs

	for i = 1, path_nav_graphs_size, STEP_LENGTH do
		local start_node_index = path_nav_graphs[i + START_NODE_INDEX]

		if path_index < start_node_index then
			return nil
		end

		if path_index == start_node_index then
			local smart_object_id = path_nav_graphs[i + SMART_OBJECT_ID_INDEX]
			local layer_id = path_nav_graphs[i + LAYER_ID_INDEX]
			local layer_name = Managers.state.nav_mesh:nav_tag_layer_id(layer_id)
			local new_transition = {
				type = layer_name,
				t = t,
			}
			local nav_graph_system = Managers.state.extension:system("nav_graph_system")
			local smart_object_unit = nav_graph_system:unit_from_smart_object_id(smart_object_id)

			if smart_object_unit then
				new_transition.unit = smart_object_unit
			else
				local bot_nav_transition_manager = Managers.state.bot_nav_transition
				local transition_data = bot_nav_transition_manager:transition_data(smart_object_id)

				new_transition.is_following_waypoint, new_transition.waypoint, new_transition.transition_end = true, transition_data.waypoint, transition_data.to
			end

			return new_transition
		end
	end
end

local NAV_MESH_POSITION_ABOVE, NAV_MESH_POSITION_BELOW = 1.1, 0.5

BotNavigationExtension.update_position = function (self, unit)
	local position = Unit.local_position(unit, 1)
	local nav_world, traverse_logic = self._nav_world, self._traverse_logic
	local position_on_navmesh = NavQueries.position_on_mesh(nav_world, position, NAV_MESH_POSITION_ABOVE, NAV_MESH_POSITION_BELOW, traverse_logic)

	if position_on_navmesh then
		self._latest_position_on_nav_mesh:store(position_on_navmesh)

		self._is_latest_position_on_nav_mesh_valid = true
	elseif self._is_latest_position_on_nav_mesh_valid then
		local latest_position_on_nav_mesh = self._latest_position_on_nav_mesh:unbox()

		if not NavQueries.position_on_mesh(nav_world, latest_position_on_nav_mesh, NAV_MESH_POSITION_ABOVE, NAV_MESH_POSITION_BELOW, traverse_logic) then
			self._latest_position_on_nav_mesh:store(Vector3.invalid_vector())

			self._is_latest_position_on_nav_mesh_valid = false
		end
	end

	self.is_on_nav_mesh = position_on_navmesh ~= nil
end

local NAV_MESH_CHECK_ABOVE = 0.75
local NAV_MESH_CHECK_BELOW = 0.5
local PROPAGATION_BOX_EXTENT = 40
local SAME_DIRECTION_THRESHOLD = math.cos(math.pi / 8)

BotNavigationExtension.move_to = function (self, target_position, callback)
	if self._astar_cancelled then
		Log.error("BotNavigationExtension", "Can't path, AStar was cancelled, need to wait for command queue to be flushed.")

		return false
	end

	local transition = self._current_transition

	if transition and Managers.time:time("gameplay") - transition.t < MAX_TIME_IN_TRANSITION then
		return false
	end

	if self._running_astar then
		self._has_queued_target = true

		self._queued_target_position:store(target_position)

		self._queued_path_callback = callback

		return true
	end

	local unit = self._unit
	local position = POSITION_LOOKUP[unit]
	local nav_world, traverse_logic = self._nav_world, self._traverse_logic
	local position_on_mesh = NavQueries.position_on_mesh(nav_world, position, NAV_MESH_CHECK_ABOVE, NAV_MESH_CHECK_BELOW, traverse_logic)

	if position_on_mesh then
		position = position_on_mesh
	end

	if Vector3.equal(position, target_position) then
		Log.exception("BotNavigationExtension", "Bot tried to move to its current position (%s), AStar will probably fail.", position)
	end

	local astar = self._astar

	GwNavAStar.start_with_propagation_box(astar, nav_world, position, target_position, PROPAGATION_BOX_EXTENT, traverse_logic)

	self._running_astar = true

	if not self._final_goal_reached and Vector3.dot(Vector3.normalize(target_position - position), Vector3.normalize(self._destination:unbox() - position)) > SAME_DIRECTION_THRESHOLD then
		self._last_path = self._path
		self._last_path_index = self._path_index
	end

	self._path = nil
	self._path_nav_graphs = nil
	self._current_transition = nil
	self._path_index = 0
	self._close_to_goal_t = nil
	self._final_goal_reached = false

	self._destination:store(target_position)

	self._path_callback = callback

	return true
end

BotNavigationExtension.teleport = function (self, destination)
	local astar = self._astar

	if self._running_astar and not GwNavAStar.processing_finished(astar) then
		GwNavAStar.cancel(astar)

		self._running_astar = false
		self._astar_cancelled = true
	end

	self._has_queued_target = false
	self._queued_path_callback = nil
	self._final_goal_reached = true

	self._position_when_final_goal_reached:store(destination)

	self._path = nil
	self._path_nav_graphs = nil
	self._path_index = 0
	self._path_callback = nil

	self._destination:store(destination)

	self._num_successive_failed_paths = 0
	self._close_to_goal_t = nil
	self._last_path = nil
	self._last_path_index = nil
	self._current_transition = nil
end

BotNavigationExtension.stop = function (self)
	local current_position = POSITION_LOOKUP[self._unit]

	self:teleport(current_position)
end

BotNavigationExtension.current_goal = function (self)
	local current_transition = self._current_transition

	if self._final_goal_reached then
		return nil
	elseif current_transition and current_transition.is_following_waypoint then
		return current_transition.waypoint:unbox()
	elseif self._path then
		return self._path[self._path_index]:unbox()
	elseif self._last_path then
		return self._last_path[self._last_path_index]:unbox()
	else
		return nil
	end
end

BotNavigationExtension.is_following_last_goal = function (self)
	local current_transition = self._current_transition

	if self._final_goal_reached then
		return false
	elseif current_transition and current_transition.is_following_waypoint then
		return false
	elseif self._path then
		return self._path_index == #self._path
	elseif self._last_path then
		return self._last_path_index == #self._last_path
	else
		return false
	end
end

BotNavigationExtension.destination_reached = function (self)
	return self._final_goal_reached
end

BotNavigationExtension.path_callback = function (self)
	return self._path_callback
end

BotNavigationExtension.successive_failed_paths = function (self)
	return self._num_successive_failed_paths, self._last_successful_path_t
end

BotNavigationExtension.destination = function (self)
	if self._has_queued_target then
		return self._queued_target_position:unbox()
	else
		return self._destination:unbox()
	end
end

BotNavigationExtension.position_when_destination_reached = function (self)
	if self._final_goal_reached then
		return self._position_when_final_goal_reached:unbox()
	else
		return nil
	end
end

BotNavigationExtension.latest_position_on_nav_mesh = function (self)
	return self._is_latest_position_on_nav_mesh_valid and self._latest_position_on_nav_mesh:unbox() or nil
end

BotNavigationExtension.is_in_transition = function (self)
	return self._current_transition ~= nil
end

BotNavigationExtension.transition_type = function (self)
	local transition = self._current_transition

	return transition.type
end

BotNavigationExtension.transition_unit = function (self)
	local transition = self._current_transition

	return transition.unit
end

local MAX_JUMP_WAYPOINT_DISTANCE_SQ = 1

BotNavigationExtension.transition_requires_jump = function (self, position)
	local transition = self._current_transition

	if transition.type ~= "bot_leap_of_faith" or transition.is_following_waypoint then
		return false
	end

	local waypoint_position = transition.waypoint:unbox()
	local should_jump = Vector3.distance_squared(position, waypoint_position) < MAX_JUMP_WAYPOINT_DISTANCE_SQ

	return should_jump
end

BotNavigationExtension.traverse_logic = function (self)
	return self._traverse_logic
end

BotNavigationExtension.nav_world = function (self)
	return self._nav_world
end

BotNavigationExtension.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end
end

BotNavigationExtension.set_nav_tag_layer_cost = function (self, layer_name, layer_cost)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)

	GwNavTagLayerCostTable.set_layer_cost_multiplier(self._nav_tag_cost_table, layer_id, layer_cost)
end

return BotNavigationExtension
