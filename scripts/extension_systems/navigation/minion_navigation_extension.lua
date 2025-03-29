-- chunkname: @scripts/extension_systems/navigation/minion_navigation_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local MinionNavigationExtension = class("MinionNavigationExtension")
local MAX_NUM_MOVEMENT_MODIFERS = 8
local FAR_PATHING_ALLOWED = true

MinionNavigationExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local breed, nav_world = extension_init_data.breed, extension_init_context.nav_world

	self._breed, self._nav_world = breed, nav_world
	self._unit = unit
	self._navigation_system = Managers.state.extension:system("navigation_system")
	self._nav_mesh_manager = Managers.state.nav_mesh
	self._time_manager = Managers.time

	local layer_costs, nav_cost_map_multipliers = breed.nav_tag_allowed_layers, breed.nav_cost_map_multipliers
	local enable_crowd_dispersion = breed.enable_crowd_dispersion == nil or breed.enable_crowd_dispersion
	local traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table = Navigation.create_traverse_logic(nav_world, layer_costs, nav_cost_map_multipliers, enable_crowd_dispersion)

	self._traverse_logic, self._nav_tag_cost_table, self._nav_cost_map_multiplier_table = traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table

	local randomized_nav_tag_costs, tags = breed.randomized_nav_tag_costs, breed.tags

	if randomized_nav_tag_costs or tags.roamer or tags.horde then
		self:_set_randomized_nav_tag_costs(nav_tag_cost_table, randomized_nav_tag_costs)
	end

	local position = POSITION_LOOKUP[unit]
	local nav_bot, max_speed, avoidance_enabled = self:_create_nav_bot(position, breed, traverse_logic, nav_world)

	self._nav_bot, self._max_speed, self._max_speed_with_modifiers, self._avoidance_enabled = nav_bot, max_speed, max_speed, avoidance_enabled
	self._wanted_destination = Vector3Box(position)
	self._destination = Vector3Box(position)
	self._debug_position_when_starting_search = Vector3Box()
	self._enabled = false
	self._waiting_on_getting_to_nav_mesh = false
	self._has_path = false
	self._is_following_path = false
	self._is_computing_path = false
	self._is_computing_path_due_to_crowd_dispersion = false
	self._has_started_pathfind = false
	self._failed_move_attempts = 0
	self._wait_timer = 0
	self._far_pathing_allowed = FAR_PATHING_ALLOWED
	self._current_speed = 0
	self._smart_object_data = nil
	self._is_using_smart_object = false
	self._next_smart_object_interval = GwNavSmartObjectInterval.create(nav_world)
	self._movement_modifiers = Script.new_array(MAX_NUM_MOVEMENT_MODIFERS)
	self._num_movement_modifiers = 0
	self._movement_modifier_table_size = MAX_NUM_MOVEMENT_MODIFERS
	self._last_movement_modifier_index = 1

	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)

	self._blackboard = blackboard
end

local DEFAULT_RANDOMIZED_NAV_TAG_COSTS = {
	{
		chance_to_pick_first_index = 0.5,
		layer_name = "teleporters",
		costs = {
			0.5,
			2,
		},
	},
	{
		chance_to_pick_first_index = 0.25,
		layer_name = "ledges",
		costs = {
			1,
			5,
		},
	},
	{
		chance_to_pick_first_index = 0.25,
		layer_name = "ledges_with_fence",
		costs = {
			1,
			5,
		},
	},
	{
		chance_to_pick_first_index = 0.25,
		layer_name = "cover_ledges",
		costs = {
			1,
			5,
		},
	},
}

MinionNavigationExtension._set_randomized_nav_tag_costs = function (self, nav_tag_cost_table, optional_randomized_nav_tag_costs)
	local nav_mesh_manager = self._nav_mesh_manager
	local randomized_nav_tag_costs = optional_randomized_nav_tag_costs or DEFAULT_RANDOMIZED_NAV_TAG_COSTS

	for i = 1, #randomized_nav_tag_costs do
		local data = randomized_nav_tag_costs[i]
		local costs, chance_to_pick_first_index = data.costs, data.chance_to_pick_first_index
		local random_value = math.random()
		local cost = random_value < chance_to_pick_first_index and costs[1] or costs[2]
		local layer_name = data.layer_name
		local layer_id = nav_mesh_manager:nav_tag_layer_id(layer_name)

		GwNavTagLayerCostTable.set_layer_cost_multiplier(nav_tag_cost_table, layer_id, cost)
	end
end

local NAV_BOT_HEIGHT = 1.6
local NAVIGATION_NAVMESH_RADIUS = 0.38
local FROM_OUTSIDE_NAV_MESH_DISTANCE = 1.5
local TO_OUTSIDE_NAV_MESH_DISTANCE = 0.2
local DEFAULT_PROPAGATION_BOX_EXTENT = 30
local DEFAULT_NAVIGATION_PATH_SPLINE_CONFIG = {
	channel_smoothing_angle = 30,
	max_distance_between_gates = 10,
	max_distance_to_spline_position = 5,
	min_distance_between_gates = 0.5,
	navigation_channel_radius = 4,
	spline_distance_to_borders = 1,
	spline_length = 100,
	spline_recomputation_ratio = 1,
	turn_sampling_angle = 30,
}
local DEFAULT_AVOIDANCE_CONFIG = {
	angle_span = 75,
	enable_forcing = true,
	enable_slowing = true,
	enable_stop = false,
	forcing_time_s = 1,
	forcing_wait_time_s = 0.2,
	frame_delay = 45,
	half_height = 0.5,
	radius = 4,
	sample_count = 20,
	stop_wait_time_s = 1,
	time_to_collision = 1.25,
}

MinionNavigationExtension._create_nav_bot = function (self, position, breed, traverse_logic, nav_world)
	local max_speed = breed.run_speed
	local nav_bot = GwNavBot.create(nav_world, NAV_BOT_HEIGHT, NAVIGATION_NAVMESH_RADIUS, max_speed, position, traverse_logic)

	GwNavBot.set_outside_navmesh_distance(nav_bot, FROM_OUTSIDE_NAV_MESH_DISTANCE, TO_OUTSIDE_NAV_MESH_DISTANCE)

	local use_avoidance = breed.use_avoidance == true

	if use_avoidance then
		local config = breed.avoidance_config or DEFAULT_AVOIDANCE_CONFIG

		GwNavBot.set_use_avoidance(nav_bot, true)
		GwNavBot.set_avoidance_behavior(nav_bot, config.enable_slowing, config.enable_forcing, config.enable_stop, config.stop_wait_time_s, config.forcing_time_s, config.forcing_wait_time_s)
		GwNavBot.set_avoidance_collider_collector_configuration(nav_bot, config.half_height, config.radius, config.forcing_wait_time_s)
		GwNavBot.set_avoidance_computer_configuration(nav_bot, config.angle_span, config.time_to_collision, config.sample_count)
	end

	local propagation_box_extent = breed.navigation_propagation_box_extent or DEFAULT_PROPAGATION_BOX_EXTENT

	GwNavBot.set_propagation_box(nav_bot, propagation_box_extent)

	local use_navigation_path_splines = breed.use_navigation_path_splines
	local can_patrol = breed.can_patrol

	if use_navigation_path_splines or can_patrol then
		local config = breed.navigation_path_spline_config or DEFAULT_NAVIGATION_PATH_SPLINE_CONFIG
		local channel_radius = config.navigation_channel_radius
		local turn_sampling_angle = config.turn_sampling_angle
		local channel_smoothing_angle = config.channel_smoothing_angle
		local min_distance_between_gates = config.min_distance_between_gates
		local max_distance_between_gates = config.max_distance_between_gates

		GwNavBot.set_channel_computer_configuration(nav_bot, channel_radius, turn_sampling_angle, channel_smoothing_angle, min_distance_between_gates, max_distance_between_gates)

		local IS_ANIMATION_DRIVEN = false
		local max_distance_to_spline_position = config.max_distance_to_spline_position
		local spline_length = config.spline_length
		local spline_distance_to_borders = config.spline_distance_to_borders
		local spline_recomputation_ratio = config.spline_recomputation_ratio
		local TARGET_ON_SPLINE_DISTANCE = 0

		GwNavBot.set_spline_trajectory_configuration(nav_bot, IS_ANIMATION_DRIVEN, max_distance_to_spline_position, spline_length, spline_distance_to_borders, spline_recomputation_ratio, TARGET_ON_SPLINE_DISTANCE)

		local use_navigation_path_splines_on_spawn = (not can_patrol or use_navigation_path_splines) and (breed.use_navigation_path_splines_on_spawn == nil or breed.use_navigation_path_splines_on_spawn)

		if use_navigation_path_splines_on_spawn then
			GwNavBot.set_use_channel(nav_bot, use_navigation_path_splines_on_spawn)
		end
	end

	return nav_bot, max_speed, use_avoidance
end

MinionNavigationExtension._init_blackboard_components = function (self, blackboard)
	local nav_smart_object_component = Blackboard.write_component(blackboard, "nav_smart_object")

	nav_smart_object_component.entrance_position:store(0, 0, 0)

	nav_smart_object_component.entrance_is_at_bot_progress_on_path = false

	nav_smart_object_component.exit_position:store(0, 0, 0)

	nav_smart_object_component.exit_is_at_the_end_of_path = false
	nav_smart_object_component.id = -1
	nav_smart_object_component.type = "n/a"
	nav_smart_object_component.unit = nil
	self._nav_smart_object_component = nav_smart_object_component

	local behavior_component = blackboard.behavior

	self._behavior_component = behavior_component
end

MinionNavigationExtension.extensions_ready = function (self, world, unit)
	local traverse_logic = self._traverse_logic
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_traverse_logic(traverse_logic)

	self._locomotion_extension = locomotion_extension
end

local TEMP_SMART_OBJECT_FAILING_MINIONS = {}

MinionNavigationExtension.destroy = function (self, unit)
	TEMP_SMART_OBJECT_FAILING_MINIONS[unit] = nil

	self:set_enabled(false)
	GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
	GwNavCostMapMultiplierTable.destroy(self._nav_cost_map_multiplier_table)
	GwNavBot.destroy(self._nav_bot)
	GwNavTraverseLogic.destroy(self._traverse_logic)
	GwNavSmartObjectInterval.destroy(self._next_smart_object_interval)
end

MinionNavigationExtension.update = function (self, unit, t)
	if self._waiting_on_getting_to_nav_mesh then
		if self._locomotion_extension:is_getting_back_to_nav_mesh() then
			return
		else
			local wanted_destination, destination = self._wanted_destination:unbox(), self._destination:unbox()

			if not self._has_path and Vector3.equal(wanted_destination, destination) then
				self:stop()
			end

			self._waiting_on_getting_to_nav_mesh = false
		end
	end

	local nav_bot = self._nav_bot

	self:_update_destination(unit, nav_bot, t)
	self:_update_desired_velocity(nav_bot)
	self:_update_next_smart_object(nav_bot)
	self:_update_dispersion(nav_bot)
end

local WAIT_TIMER_MAX = 5
local WAIT_TIMER_INCREMENT = 1
local AT_DESTINATION_DISTANCE_SQ = 0.010000000000000002
local FAR_AWAY_DESTINATION_DISTANCE_SQ = 36
local REPATH_NEEDED_DISTANCE_SQ = 0.010000000000000002
local FAR_AWAY_REPATH_NEEDED_DISTANCE_SQ = 9
local DEBUG_NUM_FAILED_PATHINGS_FOR_DRAW = 5
local DEBUG_NUM_FAILED_PATHINGS_FOR_DESPAWN = 10

MinionNavigationExtension._update_destination = function (self, unit, nav_bot, t)
	local is_computing_path = GwNavBot.is_computing_new_path(nav_bot)
	local has_path = GwNavBot.has_path(nav_bot)

	self._is_computing_path = is_computing_path
	self._is_computing_path_due_to_crowd_dispersion = self._is_computing_path_due_to_crowd_dispersion and is_computing_path
	self._has_path = has_path

	if not is_computing_path and t > self._wait_timer then
		local Vector3_distance_squared = Vector3.distance_squared
		local position_unit = POSITION_LOOKUP[unit]
		local current_destination, wanted_destination = self._destination:unbox(), self._wanted_destination:unbox()
		local repath_allowed = true
		local did_pathfind_just_finish = self._has_started_pathfind

		if did_pathfind_just_finish then
			self._has_started_pathfind = false

			local already_at_current_destination = Vector3_distance_squared(position_unit, current_destination) <= AT_DESTINATION_DISTANCE_SQ
			local pathfind_was_successful = has_path or already_at_current_destination

			if pathfind_was_successful then
				self._failed_move_attempts = 0
			else
				repath_allowed = false

				local failed_move_attempts = self._failed_move_attempts + 1

				self._failed_move_attempts = failed_move_attempts
				self._wait_timer = t + math.min(WAIT_TIMER_MAX, failed_move_attempts * WAIT_TIMER_INCREMENT)

				local breed_name = self._breed.name

				if failed_move_attempts == DEBUG_NUM_FAILED_PATHINGS_FOR_DESPAWN then
					Managers.server_metrics:add_annotation("minion_got_stuck_navigating")

					local debug_position = self._debug_position_when_starting_search:unbox()

					Log.warning("MINION STUCK DESPAWN", "Minion %s is totally stuck when trying to navigate from %s to %s, despawning it. MUST FIX.", breed_name, debug_position, current_destination)
					Managers.state.minion_spawn:despawn_minion(unit)

					return
				elseif failed_move_attempts == DEBUG_NUM_FAILED_PATHINGS_FOR_DRAW then
					local debug_position = self._debug_position_when_starting_search:unbox()

					Log.info("MinionNavigationExtension", "Minion %s got stuck when trying to navigate from %s to %s", breed_name, debug_position, current_destination)
				elseif failed_move_attempts > DEBUG_NUM_FAILED_PATHINGS_FOR_DRAW then
					local debug_position = self._debug_position_when_starting_search:unbox()

					Log.info("MinionNavigationExtension", "Minion %s is still stuck when trying to navigate from %s to %s", breed_name, debug_position, current_destination)
				end
			end
		end

		if repath_allowed then
			local destination_change_sq = Vector3_distance_squared(current_destination, wanted_destination)
			local distance_to_wanted_destination_sq = Vector3_distance_squared(position_unit, wanted_destination)
			local wanted_destination_far_away = distance_to_wanted_destination_sq > FAR_AWAY_DESTINATION_DISTANCE_SQ
			local change_large_enough

			if wanted_destination_far_away then
				change_large_enough = destination_change_sq > FAR_AWAY_REPATH_NEEDED_DISTANCE_SQ
			else
				change_large_enough = destination_change_sq > REPATH_NEEDED_DISTANCE_SQ
			end

			local already_at_wanted_destination = distance_to_wanted_destination_sq <= AT_DESTINATION_DISTANCE_SQ
			local is_path_recomputation_needed = GwNavBot.is_path_recomputation_needed(nav_bot)
			local should_start_new_pathfind = is_path_recomputation_needed or not already_at_wanted_destination and (not has_path or change_large_enough)

			if should_start_new_pathfind then
				local far_pathing_allowed = self._far_pathing_allowed

				GwNavBot.compute_new_path(nav_bot, wanted_destination, far_pathing_allowed)
				self._destination:store(wanted_destination)
				self._debug_position_when_starting_search:store(position_unit)

				self._is_computing_path = true
				self._is_computing_path_due_to_crowd_dispersion = false
				self._has_started_pathfind = true
				self._wait_timer = 0

				local nav_smart_object_component = self._nav_smart_object_component

				nav_smart_object_component.id = -1
			end
		end
	end
end

MinionNavigationExtension._update_desired_velocity = function (self, nav_bot)
	self._is_following_path = GwNavBot.is_following_path(nav_bot)

	local desired_velocity, desired_speed
	local behavior_component = self._behavior_component

	if behavior_component.move_state ~= "idle" then
		local nav_bot_velocity = GwNavBot.output_velocity(nav_bot)
		local flat_nav_bot_velocity = Vector3.flat(nav_bot_velocity)
		local flat_nav_bot_speed = Vector3.length(flat_nav_bot_velocity)

		desired_velocity, desired_speed = flat_nav_bot_velocity, flat_nav_bot_speed
	else
		desired_velocity, desired_speed = Vector3.zero(), 0
	end

	local max_speed_with_modifiers = self._max_speed_with_modifiers

	self._current_speed = math.min(desired_speed, max_speed_with_modifiers)
	desired_velocity = Vector3.normalize(desired_velocity) * self._current_speed

	self._locomotion_extension:set_wanted_velocity_flat(desired_velocity)
end

local NEXT_SMART_OBJECT_MAX_DISTANCE = 2

MinionNavigationExtension._update_next_smart_object = function (self, nav_bot)
	local next_smart_object_interval, smart_object_component = self._next_smart_object_interval, self._nav_smart_object_component

	if GwNavBot.current_or_next_smartobject_interval(nav_bot, next_smart_object_interval, NEXT_SMART_OBJECT_MAX_DISTANCE) then
		local entrance_position, entrance_is_at_bot_progress_on_path = GwNavSmartObjectInterval.entrance_position(next_smart_object_interval)

		smart_object_component.entrance_position:store(entrance_position)

		smart_object_component.entrance_is_at_bot_progress_on_path = entrance_is_at_bot_progress_on_path

		local exit_position, exit_is_at_the_end_of_path = GwNavSmartObjectInterval.exit_position(next_smart_object_interval)

		smart_object_component.exit_position:store(exit_position)

		smart_object_component.exit_is_at_the_end_of_path = exit_is_at_the_end_of_path

		local next_smart_object_id = GwNavSmartObjectInterval.smartobject_id(next_smart_object_interval)

		smart_object_component.id = next_smart_object_id

		local nav_graph_system = Managers.state.extension:system("nav_graph_system")
		local smart_object_layer_type = nav_graph_system:smart_object_layer_type(next_smart_object_id)
		local layer_id = self._nav_mesh_manager:nav_tag_layer_id(smart_object_layer_type)

		smart_object_component.type = smart_object_layer_type

		local smart_object_data = nav_graph_system:smart_object_data(next_smart_object_id)

		self._smart_object_data = smart_object_data

		local smart_object_unit_owner = nav_graph_system:unit_from_smart_object_id(next_smart_object_id)

		smart_object_component.unit = smart_object_unit_owner
	else
		smart_object_component.id = -1
		smart_object_component.entrance_is_at_bot_progress_on_path = false
		smart_object_component.exit_is_at_the_end_of_path = false
		smart_object_component.type = "n/a"
		smart_object_component.unit = nil
		self._smart_object_data = nil
	end
end

local APPROACHING_OCCUPIED_SMART_OBJECT = 1
local TOO_CLOSE_TO_SMART_OBJECT_TO_DIVERT = 2

MinionNavigationExtension._update_dispersion = function (self, nav_bot)
	local action = GwNavBot.update_logic_for_crowd_dispersion(nav_bot)
	local is_computing_path = self._is_computing_path

	if action == APPROACHING_OCCUPIED_SMART_OBJECT and not is_computing_path then
		local destination, far_pathing_allowed = self._destination:unbox(), self._far_pathing_allowed

		GwNavBot.compute_new_path(nav_bot, destination, far_pathing_allowed)

		self._is_computing_path = true
		self._is_computing_path_due_to_crowd_dispersion = true
	elseif action == TOO_CLOSE_TO_SMART_OBJECT_TO_DIVERT then
		local is_computing_path_due_to_crowd_dispersion = self._is_computing_path_due_to_crowd_dispersion

		if is_computing_path and is_computing_path_due_to_crowd_dispersion then
			GwNavBot.cancel_async_path_computation(nav_bot)

			self._is_computing_path = false
			self._is_computing_path_due_to_crowd_dispersion = false
		end
	end
end

MinionNavigationExtension.update_position = function (self, unit)
	local nav_bot = self._nav_bot
	local position = Unit.local_position(unit, 1)

	GwNavBot.update_position(nav_bot, position)
end

MinionNavigationExtension.traverse_logic = function (self)
	return self._traverse_logic
end

MinionNavigationExtension.nav_world = function (self)
	return self._nav_world
end

MinionNavigationExtension.set_enabled = function (self, enabled, max_speed)
	local old_status, unit = self._enabled, self._unit

	self._enabled = enabled

	if enabled then
		self:set_max_speed(max_speed)

		if not old_status then
			local nav_bot = self._nav_bot
			local has_path = GwNavBot.has_path(nav_bot)
			local is_following_path = GwNavBot.is_following_path(nav_bot)

			self._has_path, self._is_following_path = has_path, is_following_path

			local behavior_component = self._behavior_component
			local move_state = behavior_component.move_state

			if has_path and move_state ~= "moving" then
				self:stop()
			end

			self._waiting_on_getting_to_nav_mesh = self._locomotion_extension:is_getting_back_to_nav_mesh()

			self:update_position(unit)
		end
	else
		self._has_path, self._is_following_path, self._waiting_on_getting_to_nav_mesh = false, false, false
	end

	self._navigation_system:set_enabled_unit(unit, enabled)
end

MinionNavigationExtension.set_avoidance_enabled = function (self, enabled)
	self._avoidance_enabled = enabled

	GwNavBot.set_use_avoidance(self._nav_bot, enabled)
end

MinionNavigationExtension.add_movement_modifier = function (self, new_modifier)
	local size = self._movement_modifier_table_size
	local current_amount = self._num_movement_modifiers

	if size <= current_amount then
		size = size * 2

		Log.warning("MinionNavigationExtension, Doubled size of movement modifiers for %q to %i.", self._unit, size)

		self._movement_modifier_table_size = size
	end

	local modifiers = self._movement_modifiers
	local id = self._last_movement_modifier_index

	while modifiers[id] do
		id = id % size + 1
	end

	modifiers[id] = new_modifier
	self._num_movement_modifiers = current_amount + 1
	self._last_movement_modifier_index = id

	self:_recalculate_max_speed()

	return id
end

MinionNavigationExtension.remove_movement_modifier = function (self, id)
	local modifiers = self._movement_modifiers

	modifiers[id] = nil
	self._num_movement_modifiers = self._num_movement_modifiers - 1

	self:_recalculate_max_speed()
end

MinionNavigationExtension._recalculate_max_speed = function (self)
	local aggregate_mod = 1
	local modifiers = self._movement_modifiers

	for i = 1, self._movement_modifier_table_size do
		local mod = modifiers[i]

		if mod then
			aggregate_mod = mod * aggregate_mod
		end
	end

	local max_speed_with_modifiers = self._max_speed * aggregate_mod

	GwNavBot.set_max_desired_linear_speed(self._nav_bot, max_speed_with_modifiers)

	self._max_speed_with_modifiers = max_speed_with_modifiers
end

MinionNavigationExtension.set_max_speed = function (self, speed)
	if self._max_speed == speed then
		return
	end

	self._max_speed = speed

	self:_recalculate_max_speed()
end

MinionNavigationExtension.max_speed = function (self)
	return self._max_speed, self._max_speed_with_modifiers
end

MinionNavigationExtension.set_nav_bot_position = function (self, position)
	GwNavBot.update_position(self._nav_bot, position)
end

MinionNavigationExtension.move_to = function (self, position)
	self._wanted_destination:store(position)
end

MinionNavigationExtension.stop = function (self)
	if self._is_using_smart_object then
		local exit_position = self._nav_smart_object_component.exit_position:unbox()

		self._wanted_destination:store(exit_position)
		self._destination:store(exit_position)
	else
		local position = POSITION_LOOKUP[self._unit]

		self._wanted_destination:store(position)
		self._destination:store(position)

		self._nav_smart_object_component.id = -1
	end

	self._failed_move_attempts = 0
	self._has_started_pathfind = false

	local nav_bot = self._nav_bot

	if self._is_computing_path then
		GwNavBot.cancel_async_path_computation(nav_bot)

		self._is_computing_path = false
		self._is_computing_path_due_to_crowd_dispersion = false
	end

	GwNavBot.clear_followed_path(nav_bot)

	self._has_path, self._is_following_path = false, false
end

MinionNavigationExtension.enabled = function (self)
	return self._enabled
end

MinionNavigationExtension.failed_move_attempts = function (self)
	return self._failed_move_attempts
end

MinionNavigationExtension.is_on_wait_time = function (self)
	local t = self._time_manager:time("gameplay")

	return t <= self._wait_timer
end

MinionNavigationExtension.has_path = function (self)
	return self._has_path
end

MinionNavigationExtension.is_computing_path = function (self)
	return self._is_computing_path
end

MinionNavigationExtension.is_following_path = function (self)
	return self._is_following_path
end

MinionNavigationExtension.destination = function (self)
	return self._wanted_destination:unbox()
end

MinionNavigationExtension.distance_to_destination = function (self, optional_position)
	local position = optional_position or Unit.local_position(self._unit, 1)
	local destination = self:destination()

	return Vector3.distance(position, destination)
end

MinionNavigationExtension.distance_to_destination_sq = function (self, optional_position)
	local position = optional_position or Unit.local_position(self._unit, 1)
	local destination = self:destination()

	return Vector3.distance_squared(position, destination)
end

MinionNavigationExtension.has_reached_destination = function (self)
	local nav_bot = self._nav_bot

	return GwNavBot.has_reached_destination(nav_bot)
end

MinionNavigationExtension.current_smart_object_data = function (self)
	return self._smart_object_data
end

local NUM_SMART_OBJECT_FAILS_FOR_DESPAWN = 5
local TOTAL_NUM_SMART_OBJECT_DESPAWNS = 0

MinionNavigationExtension.use_smart_object = function (self, do_use)
	local nav_bot, unit = self._nav_bot, self._unit
	local nav_smart_object_component = self._nav_smart_object_component
	local success

	if do_use then
		local smart_object_id = nav_smart_object_component.id

		success = GwNavBot.enter_manual_control(nav_bot, self._next_smart_object_interval)

		if success then
			TEMP_SMART_OBJECT_FAILING_MINIONS[unit] = 0
		else
			local position = POSITION_LOOKUP[unit]
			local entrance_position, exit_position = nav_smart_object_component.entrance_position:unbox(), nav_smart_object_component.exit_position:unbox()
			local smart_object_type = nav_smart_object_component.type
			local breed_name = self._breed.name

			GwNavBot.clear_followed_path(nav_bot)

			self._has_path, self._is_following_path = false, false
			nav_smart_object_component.id = -1

			local num_fails = (TEMP_SMART_OBJECT_FAILING_MINIONS[unit] or 0) + 1

			TEMP_SMART_OBJECT_FAILING_MINIONS[unit] = num_fails

			if num_fails == 1 then
				Log.info("MinionNavigationExtension", "%s can't get smart object control(smart object id=%d, %s). Unit: %s (green) Entrance: %s (blue) Exit:%s (yellow)", breed_name, smart_object_id, smart_object_type, position, entrance_position, exit_position)
			end

			if num_fails >= NUM_SMART_OBJECT_FAILS_FOR_DESPAWN then
				TOTAL_NUM_SMART_OBJECT_DESPAWNS = TOTAL_NUM_SMART_OBJECT_DESPAWNS + 1

				Log.warning("MINION STUCK DESPAWN", "Minion %s is stuck when trying to get smartobject %s to %s, despawning it. %d has despawned this session", breed_name, entrance_position, exit_position, TOTAL_NUM_SMART_OBJECT_DESPAWNS)
				Managers.state.minion_spawn:despawn_minion(unit)
				Managers.server_metrics:add_annotation("minion_got_stuck_using_smartobject")
			end
		end
	else
		success = GwNavBot.exit_manual_control(nav_bot)

		if success then
			TEMP_SMART_OBJECT_FAILING_MINIONS[unit] = 0
		else
			local position = POSITION_LOOKUP[unit]
			local entrance_position, exit_position = nav_smart_object_component.entrance_position:unbox(), nav_smart_object_component.exit_position:unbox()
			local smart_object_type = nav_smart_object_component.type
			local breed_name = self._breed.name

			GwNavBot.clear_followed_path(nav_bot)

			self._has_path, self._is_following_path = false, false

			local num_fails = (TEMP_SMART_OBJECT_FAILING_MINIONS[unit] or 0) + 1

			TEMP_SMART_OBJECT_FAILING_MINIONS[unit] = num_fails

			if num_fails == 1 then
				Log.info("MinionNavigationExtension", "%s can't release smart object control(%s). Unit: %s (green) Entrance: %s (blue) Exit:%s (yellow)", breed_name, smart_object_type, position, entrance_position, exit_position)
			end

			if num_fails >= NUM_SMART_OBJECT_FAILS_FOR_DESPAWN then
				TOTAL_NUM_SMART_OBJECT_DESPAWNS = TOTAL_NUM_SMART_OBJECT_DESPAWNS + 1

				Log.warning("MINION STUCK DESPAWN", "Minion %s is stuck when trying to release smartobject %s to %s, despawning it. %d has despawned this session", breed_name, entrance_position, exit_position, TOTAL_NUM_SMART_OBJECT_DESPAWNS)
				Managers.state.minion_spawn:despawn_minion(unit)
				Managers.server_metrics:add_annotation("minion_got_stuck_using_smartobject")
			end
		end

		self:_update_next_smart_object(nav_bot)
	end

	local using_smart_object = do_use and success

	self._is_using_smart_object = using_smart_object

	return success
end

MinionNavigationExtension.is_using_smart_object = function (self)
	return self._is_using_smart_object
end

MinionNavigationExtension.path_distance_to_next_smart_object = function (self, optional_max_distance)
	local has_upcoming_smart_object, path_distance = GwNavBot.distance_to_next_smartobject(self._nav_bot, optional_max_distance)

	return has_upcoming_smart_object, path_distance
end

MinionNavigationExtension.allow_nav_tag_layers = function (self, layer_names, layer_allowed)
	local nav_tag_cost_table = self._nav_tag_cost_table

	for i = 1, #layer_names do
		local layer_name = layer_names[i]
		local layer_id = self._nav_mesh_manager:nav_tag_layer_id(layer_name)

		if layer_allowed then
			GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
		else
			GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
		end
	end
end

MinionNavigationExtension.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = self._nav_mesh_manager:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end
end

MinionNavigationExtension.set_nav_tag_layer_cost = function (self, layer_name, layer_cost)
	local layer_id = self._nav_mesh_manager:nav_tag_layer_id(layer_name)

	GwNavTagLayerCostTable.set_layer_cost_multiplier(self._nav_tag_cost_table, layer_id, layer_cost)
end

MinionNavigationExtension.current_and_next_node_positions_in_path = function (self)
	local nav_bot = self._nav_bot
	local node_count = GwNavBot.get_path_nodes_count(nav_bot)
	local current_node_index = GwNavBot.get_path_current_node_index(nav_bot)
	local current_node_position = GwNavBot.get_path_node_pos(nav_bot, current_node_index)
	local next_node_1_index = current_node_index + 1

	if node_count < next_node_1_index then
		return current_node_position, nil, nil
	end

	local next_node_1_position = GwNavBot.get_path_node_pos(nav_bot, next_node_1_index)
	local next_node_2_index = current_node_index + 2

	if node_count < next_node_2_index then
		return current_node_position, next_node_1_position, nil
	end

	local next_node_2_position = GwNavBot.get_path_node_pos(nav_bot, next_node_2_index)

	return current_node_position, next_node_1_position, next_node_2_position
end

MinionNavigationExtension.current_and_wanted_node_position_in_path = function (self, wanted_node_offset_index)
	local nav_bot = self._nav_bot
	local node_count = GwNavBot.get_path_nodes_count(nav_bot)
	local current_node_index = GwNavBot.get_path_current_node_index(nav_bot)
	local current_node_position = GwNavBot.get_path_node_pos(nav_bot, current_node_index)
	local wanted_node_index = current_node_index + wanted_node_offset_index

	if node_count < wanted_node_index then
		return current_node_position, nil
	end

	local wanted_node_position = GwNavBot.get_path_node_pos(nav_bot, wanted_node_index)

	return current_node_position, wanted_node_position
end

MinionNavigationExtension.remaining_distance_from_progress_to_end_of_path = function (self)
	local distance = GwNavBot.get_remaining_distance_from_progress_to_end_of_path(self._nav_bot)

	return distance
end

return MinionNavigationExtension
