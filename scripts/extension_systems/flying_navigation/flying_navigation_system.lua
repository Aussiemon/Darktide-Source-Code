-- chunkname: @scripts/extension_systems/flying_navigation/flying_navigation_system.lua

local FlyingSearchEngine = require("scripts/extension_systems/navigation/flying_search_engine")

require("scripts/extension_systems/navigation/flying_nav_queries")

local FlyingNavigationSystem = class("FlyingNavigationSystem", "ExtensionSystemBase")

FlyingNavigationSystem.init = function (self, ...)
	FlyingNavigationSystem.super.init(self, ...)

	self._nav_bot_data = {}
	self._computes = {}
	self._paths = {}
	self._compute_step_max = 1
	self._compute_step_index = 0
	self._svo_build_step_max = 1

	self:_create_svo()
end

FlyingNavigationSystem.register = function (self, nav_bot, position, radius, max_speed)
	self._nav_bot_data[nav_bot] = {
		compute = nil,
		needs_recomputation = false,
		path = nil,
		uses_avoidance = false,
		velocity = Vector3Box(),
		real_position = Vector3Box(position),
		max_speed = max_speed,
		radius = radius,
	}
end

FlyingNavigationSystem.unregister = function (self, nav_bot)
	self:clear_followed_path(nav_bot)
	self:cancel_async_path_computation(nav_bot)

	self._nav_bot_data[nav_bot] = nil
end

FlyingNavigationSystem.update = function (self, context, dt)
	self:_update_svo()
	self:_update_computes()
	self:_update_velocities(dt)
end

FlyingNavigationSystem._update_svo = function (self)
	self._shared_svo:step_build(self._svo_build_step_max)
end

FlyingNavigationSystem._update_computes = function (self)
	local computes = self._computes

	if table.is_empty(self._computes) then
		return
	end

	local paths = self._paths
	local Application_time_since_query = Application.time_since_query
	local step_max = self._compute_step_max
	local nav_bot_data = self._nav_bot_data
	local timer = Application.query_performance_counter()
	local num_computes = #computes
	local step_index = self._compute_step_index

	for i = 1, num_computes do
		local index = math.index_wrapper(step_index + 1, num_computes)
		local nav_bot = computes[index]
		local search_engine = nav_bot_data[nav_bot].compute
		local done, success = search_engine:step(timer, step_max)

		if done then
			local last_nav_bot = computes[num_computes]

			computes[index] = last_nav_bot
			computes[last_nav_bot] = index
			computes[num_computes] = nil
			computes[nav_bot] = nil

			if success then
				local path = search_engine:claim_result()

				nav_bot_data[nav_bot].path = path

				local existing_index = paths[nav_bot]

				if not existing_index then
					local next_path_idx = #paths + 1

					paths[next_path_idx] = nav_bot
					paths[nav_bot] = next_path_idx
				end
			else
				nav_bot_data[nav_bot].needs_recomputation = true
			end

			nav_bot_data[nav_bot].compute = nil
			index = index - 1
			num_computes = num_computes - 1
		end

		step_index = index

		if step_max < Application_time_since_query(timer) then
			break
		end
	end

	self._compute_step_index = step_index
end

FlyingNavigationSystem._update_velocities = function (self, nav_step_dt)
	local paths = self._paths

	if table.is_empty(paths) then
		return
	end

	local Application_time_since_query = Application.time_since_query
	local step_max = self._compute_step_max
	local nav_bot_data = self._nav_bot_data
	local timer = Application.query_performance_counter()
	local num_paths = #paths
	local step_index = self._compute_step_index

	for i = 1, num_paths do
		local index = math.index_wrapper(step_index + 1, num_paths)
		local nav_bot = paths[index]
		local bot_data = nav_bot_data[nav_bot]
		local path = bot_data.path
		local real_position = bot_data.real_position:unbox()
		local max_speed = bot_data.max_speed

		bot_data.velocity:store(path:velocity_at(real_position, max_speed, nav_step_dt))

		step_index = index

		if step_max < Application_time_since_query(timer) then
			break
		end
	end

	self._compute_step_index = step_index
end

FlyingNavigationSystem.set_use_avoidance = function (self, nav_bot, value)
	local nav_data = self._nav_bot_data[nav_bot]

	if nav_data.uses_avoidance == value then
		return
	end

	nav_data.uses_avoidance = value
	nav_data.needs_recomputation = true
end

FlyingNavigationSystem.is_computing_new_path = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.compute
end

FlyingNavigationSystem.has_path = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	return not not nav_data.path
end

FlyingNavigationSystem.is_following_path = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]
	local path = nav_data.path

	if not path then
		return false
	end

	return not path:past_end(nav_data.real_position:unbox())
end

FlyingNavigationSystem.clear_followed_path = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	nav_data.path = nil

	local paths = self._paths
	local idx = paths[nav_bot]

	if idx then
		local last_idx = #paths
		local last_bot = paths[last_idx]

		paths[idx] = last_bot
		paths[last_bot] = idx
		paths[last_idx] = nil
		paths[nav_bot] = nil
	end
end

FlyingNavigationSystem.is_path_recomputation_needed = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.needs_recomputation
end

FlyingNavigationSystem.compute_new_path = function (self, nav_bot, wanted_destination, far_pathing_allowed)
	local nav_data = self._nav_bot_data[nav_bot]
	local radius = nav_data.radius
	local compute = FlyingSearchEngine:new(self._shared_svo, nav_data.real_position:unbox(), wanted_destination, radius)

	nav_data.compute = compute
	nav_data.needs_recomputation = false

	local computes = self._computes
	local next_idx = #computes + 1

	computes[nav_bot] = next_idx
	computes[next_idx] = nav_bot
end

FlyingNavigationSystem.output_velocity = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.velocity:unbox()
end

FlyingNavigationSystem.current_or_next_smartobject_interval = function (self, nav_bot, next_smart_object_interval, next_smart_object_distance)
	return nil
end

FlyingNavigationSystem.update_position = function (self, nav_bot, position)
	local nav_data = self._nav_bot_data[nav_bot]

	nav_data.real_position:store(position)
end

FlyingNavigationSystem.cancel_async_path_computation = function (self, nav_bot)
	local computes = self._computes
	local idx = computes[nav_bot]

	if idx then
		local num_computes = #computes
		local last_nav_bot = computes[num_computes]

		computes[idx] = last_nav_bot
		computes[last_nav_bot] = idx
		computes[num_computes] = nil
		computes[nav_bot] = nil
	end

	self._nav_bot_data[nav_bot].compute = nil
end

FlyingNavigationSystem.has_reached_destination = function (self, nav_bot)
	return not self:is_following_path(nav_bot) and not self:is_computing_new_path(nav_bot)
end

FlyingNavigationSystem.enter_manual_control = function (self, nav_bot, smart_object_interval)
	return
end

FlyingNavigationSystem.exit_manual_control = function (self, nav_bot)
	return
end

FlyingNavigationSystem.distance_to_next_smartobject = function (self, nav_bot, optional_max_distance)
	return
end

FlyingNavigationSystem.get_path_nodes_count = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.path:num_nodes()
end

FlyingNavigationSystem.get_path_current_node_index = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]
	local position = nav_data.real_position:unbox()

	return nav_data.path:node_index_from_position(position)
end

FlyingNavigationSystem.get_path_node_pos = function (self, nav_bot, node_index)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.path:node_position(node_index)
end

FlyingNavigationSystem.get_remaining_distance_from_progress_to_end_of_path = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]
	local position = nav_data.real_position:unbox()

	return nav_data.path:remaining_distance_from_position(position)
end

FlyingNavigationSystem.remaining_distance_to_position = function (self, nav_bot, to_position)
	local nav_data = self._nav_bot_data[nav_bot]
	local from_position = nav_data.real_position:unbox()

	return nav_data.path:distance_between_positions(from_position, to_position)
end

FlyingNavigationSystem.distance_to_progress_on_path = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]
	local position = nav_data.real_position:unbox()

	return nav_data.path:distance_to_progress_on_path(position)
end

FlyingNavigationSystem.cut_path_at_distance_from_current = function (self, nav_bot, distance)
	local nav_data = self._nav_bot_data[nav_bot]
	local position = nav_data.real_position:unbox()
	local ahead_pos, is_goal, from_index = nav_data.path:position_ahead_on_path(position, distance)

	if not is_goal then
		nav_data.path:cut_path_at_index(from_index + 1, ahead_pos)
	end
end

FlyingNavigationSystem.velocity = function (self, nav_bot)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.velocity:unbox()
end

FlyingNavigationSystem.get_far_path_nodes_count = function (self, nav_bot)
	return 0
end

FlyingNavigationSystem.get_far_path_node_pos = function (self, nav_bot)
	return nil
end

FlyingNavigationSystem.set_max_desired_linear_speed = function (self, nav_bot, max_speed)
	local nav_data = self._nav_bot_data[nav_bot]

	nav_data.max_speed = max_speed
end

FlyingNavigationSystem.register_nav_units = function (self, units)
	if self._is_server and (DEDICATED_SERVER or IS_WINDOWS) then
		self._shared_svo:register_units(units)
	end
end

FlyingNavigationSystem.remove_nav_data = function (self)
	self:_create_svo()
end

FlyingNavigationSystem._create_svo = function (self)
	self._shared_svo = NavSVO.create(Vector3(12, 12, 12), Vector3(1, 1, 1), Managers.state.out_of_bounds:soft_cap_extents())
end

FlyingNavigationSystem.position_ahead_on_path = function (self, nav_bot, distance)
	local nav_data = self._nav_bot_data[nav_bot]
	local position = nav_data.real_position:unbox()

	return nav_data.path:position_ahead_on_path(position, distance)
end

FlyingNavigationSystem.position_ahead_on_path_from_position = function (self, nav_bot, position, distance)
	local nav_data = self._nav_bot_data[nav_bot]

	return nav_data.path:position_ahead_on_path(position, distance)
end

FlyingNavigationSystem.ray_can_go = function (self, from_position, to_position, radius)
	return not self._shared_svo:overlap_capsule(from_position, to_position, radius)
end

return FlyingNavigationSystem
