-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_valkyrie_shoot_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local MasterItems = require("scripts/backend/master_items")
local NAV_TAG_LAYER_COSTS = {}
local BtValkyrieShootAction = class("BtValkyrieShootAction", "BtNode")

BtValkyrieShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local strafe_component = Blackboard.write_component(blackboard, "strafe")

	scratchpad.strafe_component = strafe_component
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.navigation_extension = navigation_extension
	scratchpad.unit = unit
	scratchpad.action_data = action_data
	scratchpad.nav_radius = breed.flying_navmesh_radius + 1e-06
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.lean_limit = breed.scripted_animation_settings and breed.scripted_animation_settings.hover_lean_limit
	scratchpad.transition_friction = action_data.transition_speed_friction

	if t - strafe_component.last_update_strafe_t > 1 then
		self:_start_strafe_timer(scratchpad, t)
	end

	scratchpad.weapon_nodes = {
		Unit.node(unit, "fx_wpn_node_1"),
		Unit.node(unit, "fx_wpn_node_2"),
	}
	scratchpad.next_weapon_node = 1

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]

	scratchpad.side_name = side:name()

	local move_medium = behavior_component.move_medium
	local strafe_speed, acceleration

	if move_medium == "air" then
		strafe_speed = breed.fly_fast_speed or breed.fly_speed
		acceleration = breed.fly_fast_acceleration or breed.fly_acceleration
	else
		strafe_speed = breed.run_speed
		acceleration = breed.run_acceleration
	end

	scratchpad.strafe_speed = strafe_speed
	scratchpad.shooting_settings = action_data.shooting_settings
	scratchpad.shooting_data = {
		next_salvo_time = 0,
		next_shot_time = 0,
		num_salvo_shots_fired = 0,
		ready_sfx_played = false,
	}

	navigation_extension:set_acceleration(acceleration)
	self:_start_moving(scratchpad)

	scratchpad.wants_stop = true

	for nav_tag_name, cost in pairs(NAV_TAG_LAYER_COSTS) do
		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
	end

	local current_rotation_speed = locomotion_extension:rotation_speed()

	scratchpad.original_rotation_speed = current_rotation_speed

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	scratchpad.slowdown_distance_from_goal = action_data.slowdown_distance_from_goal or 0
	scratchpad.stop_distance = action_data.stop_distance or 0
	scratchpad.movement_modifier_id = nil
	scratchpad.previous_goal = Vector3Box()
end

BtValkyrieShootAction.init_values = function (self, blackboard)
	local strafe_component = Blackboard.write_component(blackboard, "strafe")

	strafe_component.strafe_timer_started_t = 0
	strafe_component.last_update_strafe_t = 0
	strafe_component.strafe_delay = 0
end

BtValkyrieShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)
	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

	scratchpad.behavior_component.move_state = "idle"

	local default_nav_tag_layers_minions = NavigationCostSettings.default_nav_tag_layers_minions

	for nav_tag_name, _ in pairs(NAV_TAG_LAYER_COSTS) do
		local default_cost = default_nav_tag_layers_minions[nav_tag_name]

		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, default_cost)
	end

	local breed_nav_tag_allowed_layers = breed.nav_tag_allowed_layers

	if breed_nav_tag_allowed_layers then
		for nav_tag_name, cost in pairs(breed_nav_tag_allowed_layers) do
			navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
		end
	end

	self:_update_movement_modifier(scratchpad, nil)
end

BtValkyrieShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_update_stopping(unit, blackboard, scratchpad)
	self:_update_shooting(unit, blackboard, scratchpad, action_data, dt)
	self:_update_strafing(unit, blackboard, scratchpad, action_data, t)
	self:_update_repositioning(unit, blackboard, scratchpad, dt)
	self:_update_speed(scratchpad, dt)

	local is_done = self:_is_done(scratchpad, blackboard)

	return is_done and "done" or "running"
end

BtValkyrieShootAction._update_shooting = function (self, unit, blackboard, scratchpad, action_data, dt)
	local perception_component = blackboard.perception
	local target_unit = perception_component.target_unit

	if not ALIVE[target_unit] then
		return
	end

	local shooting_data = scratchpad.shooting_data
	local shooting_settings = scratchpad.shooting_settings
	local forward_rotation = Unit.local_rotation(unit, 1)
	local target_pos

	if Unit.has_node(target_unit, "j_spine") then
		target_pos = Unit.world_position(target_unit, Unit.node(target_unit, "j_spine"))
	else
		target_pos = POSITION_LOOKUP[unit] + Vector3.up()
	end

	local own_pos = POSITION_LOOKUP[unit]
	local to_target = target_pos - own_pos

	shooting_data.next_salvo_time = shooting_data.next_salvo_time - dt

	if shooting_data.next_salvo_time < 0 and Quaternion.angle(Quaternion.look(to_target), forward_rotation) < math.degrees_to_radians(10) then
		shooting_data.next_shot_time = shooting_data.next_shot_time - dt

		if shooting_data.next_shot_time < 0 then
			shooting_data.next_shot_time = shooting_data.next_shot_time + shooting_settings.time_between_shots

			self:_shoot(scratchpad, target_pos)
		end
	elseif shooting_data.num_salvo_shots_fired > shooting_settings.num_shots_in_salvo then
		shooting_data.num_salvo_shots_fired = 0
		shooting_data.next_salvo_time = shooting_settings.time_between_salvos
		shooting_data.ready_sfx_played = false
	elseif not shooting_data.ready_sfx_played and shooting_data.next_salvo_time < shooting_settings.sfx.ready_delay then
		shooting_data.ready_sfx_played = true

		scratchpad.fx_system:trigger_wwise_event(shooting_settings.sfx.ready, nil, unit)
	end
end

BtValkyrieShootAction._shoot = function (self, scratchpad, target_position)
	local unit = scratchpad.unit
	local item_definitions = MasterItems.get_cached()
	local next_node = scratchpad.next_weapon_node
	local node = scratchpad.weapon_nodes[next_node]

	scratchpad.next_weapon_node = math.index_wrapper(next_node + 1, #scratchpad.weapon_nodes)

	local position = Unit.world_position(unit, node)
	local direction = Vector3.normalize(target_position - position)
	local rotation = Quaternion.look(direction)
	local action_data = scratchpad.action_data
	local speed = 70
	local starting_state = ProjectileLocomotionSettings.states.manual_physics
	local item = item_definitions[action_data.projectile_item]
	local projectile_template = action_data.projectile_template

	scratchpad.fx_system:trigger_wwise_event(scratchpad.shooting_settings.sfx.shoot, nil, unit, node)

	local unit_template_name = projectile_template.unit_template_name or "item_projectile"

	Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, rotation, nil, item, projectile_template, starting_state, direction, speed, Vector3.zero(), unit, false, nil, nil, nil, nil, nil, nil, scratchpad.side_name)
end

BtValkyrieShootAction._update_stopping = function (self, unit, blackboard, scratchpad)
	if scratchpad.wants_stop then
		if scratchpad.navigation_extension:is_following_path() then
			scratchpad.navigation_extension:cut_path_at_distance_from_current(scratchpad.stop_distance)
		end

		scratchpad.stopping = true
		scratchpad.wants_stop = nil
	end

	if scratchpad.stopping and scratchpad.navigation_extension:has_reached_destination() then
		scratchpad.stopping = false

		scratchpad.navigation_extension:stop()
		scratchpad.navigation_extension:set_max_speed(scratchpad.strafe_speed)
	end
end

BtValkyrieShootAction._update_strafing = function (self, unit, blackboard, scratchpad, action_data, t)
	local navigation_extension = scratchpad.navigation_extension

	if not navigation_extension:is_following_path() then
		local strafe_component = scratchpad.strafe_component

		if navigation_extension:is_computing_path() then
			strafe_component.strafe_timer_started_t = t
			strafe_component.last_update_strafe_t = t

			return
		end

		local strafe_time_left = strafe_component.strafe_delay - (t - strafe_component.strafe_timer_started_t)

		strafe_component.last_update_strafe_t = t

		if strafe_time_left < 0 then
			self:_find_strafe_point(unit, blackboard, scratchpad, action_data)
			self:_start_strafe_timer(scratchpad, t + strafe_time_left)
		end

		return
	end
end

local strafe_distances = {
	3.5,
	2.5,
	1.75,
}

BtValkyrieShootAction._find_strafe_point = function (self, unit, blackboard, scratchpad, action_data, force_move)
	scratchpad.wants_stop = false

	local perception_component = blackboard.perception
	local target_unit = perception_component.target_unit

	if not ALIVE[target_unit] then
		return
	end

	local target_pos = POSITION_LOOKUP[target_unit]
	local own_pos = POSITION_LOOKUP[unit]
	local to_target = target_pos - own_pos
	local direction = (math.random(0, 1) - 0.5) * 2
	local perp_vec = Vector3.cross(to_target, Vector3.up())

	if Vector3.length_squared(perp_vec) < 1e-06 then
		scratchpad.wants_reposition = true

		return
	end

	perp_vec = Vector3.normalize(perp_vec)

	local radius = scratchpad.nav_radius
	local perception_extension = scratchpad.perception_extension
	local target_point

	for dir_i = 1, -1, -2 do
		direction = direction * dir_i

		local strafe_dir = perp_vec * direction

		for strafe_i = 1, #strafe_distances do
			local test_point = own_pos + strafe_dir * strafe_distances[strafe_i] * radius

			if perception_extension:validate_line_of_sight_from_position(target_unit, test_point, Quaternion.look(target_pos - test_point)) then
				local can_go = FlyingNavQueries.ray_can_go(own_pos, test_point, radius)

				if can_go then
					target_point = test_point

					break
				end
			end
		end

		if target_point then
			break
		end
	end

	if not target_point then
		return
	end

	self:_move_to(scratchpad, target_point)
end

BtValkyrieShootAction._move_to = function (self, scratchpad, position)
	local behavior_component = scratchpad.behavior_component
	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		behavior_component.move_state = "moving"
	end

	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:cancel_computation()
	navigation_extension:move_to(position)
	self:_start_moving(scratchpad)
	self:_update_movement_modifier(scratchpad, nil)
end

BtValkyrieShootAction._update_repositioning = function (self, unit, blackboard, scratchpad, dt)
	local timer = (scratchpad.update_repositioning_timer or 0) - dt

	scratchpad.update_repositioning_timer = timer

	if timer > 0 then
		return
	end

	scratchpad.update_repositioning_timer = 1

	local perception_component = blackboard.perception
	local target_unit = perception_component.target_unit

	if not ALIVE[target_unit] then
		return
	end

	local navigation_extension = scratchpad.navigation_extension

	if not navigation_extension:is_following_path() then
		if navigation_extension:is_computing_path() then
			return
		end

		local target_pos = POSITION_LOOKUP[target_unit]
		local own_pos = POSITION_LOOKUP[unit]
		local to_target = target_pos - own_pos
		local to_target_flat = Vector3.flat(to_target)

		if Vector3.length_squared(to_target_flat) < 1e-06 then
			self:_seek_valid_position(scratchpad, target_pos, nil)
		else
			local perception_extension = scratchpad.perception_extension
			local to_target_rot = Quaternion.look(to_target)
			local to_target_flat_rot = Quaternion.look(to_target_flat)
			local angle = Quaternion.angle(to_target_rot, to_target_flat_rot)

			if angle > scratchpad.lean_limit or not perception_extension:has_line_of_sight(target_unit) then
				self:_seek_valid_position(scratchpad, target_unit, -Vector3.normalize(to_target_flat))
			end
		end
	end
end

BtValkyrieShootAction._seek_valid_position = function (self, scratchpad, target_unit, optional_query_direction)
	if not optional_query_direction then
		local forward_rotation = Unit.local_rotation(scratchpad.unit, 1)
		local back = Vector3.flat(-Quaternion.forward(forward_rotation))

		if Vector3.length_squared(back) < 1e-06 then
			optional_query_direction = Quaternion.forward(Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), math.random() * math.pi * 2), Vector3.forward()))
		else
			optional_query_direction = Vector3.normalize(back)
		end
	end

	local directions = 5
	local angle_per_query = math.pi / directions
	local own_pos = POSITION_LOOKUP[scratchpad.unit]
	local target_pos = POSITION_LOOKUP[target_unit]
	local wanted_height = own_pos[3] - target_pos[3]
	local lean_limit = scratchpad.lean_limit
	local distance = wanted_height / math.tan(lean_limit) * 1.1
	local offset = optional_query_direction * distance
	local perception_extension = scratchpad.perception_extension
	local radius = scratchpad.nav_radius

	for query_i = 1, directions + 1 do
		for dir_i = -1, 1, 2 do
			local rotation = Quaternion.axis_angle(Vector3.up(), angle_per_query * dir_i * (query_i - 1))
			local rotated_offset = Quaternion.rotate(rotation, offset)
			local query_pos = target_pos + rotated_offset

			query_pos[3] = query_pos[3] + wanted_height

			local query_rot = Quaternion.look(target_pos - own_pos)

			if perception_extension:validate_line_of_sight_from_position(target_unit, query_pos, query_rot) and FlyingNavQueries.ray_can_go(query_pos, query_pos, radius) then
				self:_move_to(scratchpad, query_pos)

				return
			end

			if query_i == 1 then
				break
			end
		end
	end
end

BtValkyrieShootAction._update_speed = function (self, scratchpad, dt)
	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.transition_speed then
		local max_speed = math.max(navigation_extension:max_speed(), Vector3.length(scratchpad.locomotion_extension:current_velocity()))

		max_speed = max_speed - dt * scratchpad.transition_friction

		local hit_max = max_speed <= scratchpad.strafe_speed

		navigation_extension:set_max_speed(math.max(max_speed, scratchpad.strafe_speed))

		if hit_max then
			scratchpad.transition_speed = false
		end
	end

	if not navigation_extension:has_path() then
		self:_update_movement_modifier(scratchpad, nil)

		return
	end

	local goal_pos = navigation_extension:goal_position()

	if Vector3.distance_squared(goal_pos, scratchpad.previous_goal:unbox()) > 1e-06 then
		self:_update_movement_modifier(scratchpad, nil)
		scratchpad.previous_goal:store(goal_pos)
	end

	local brake_dist_left, total_dist
	local _, is_goal = navigation_extension:position_ahead_on_path(scratchpad.slowdown_distance_from_goal)

	if is_goal then
		brake_dist_left = navigation_extension:remaining_distance_from_progress_to_end_of_path()
		total_dist = scratchpad.slowdown_distance_from_goal
	end

	if brake_dist_left then
		if navigation_extension:has_reached_destination() then
			self:_stop_moving(scratchpad)
		else
			local modifier = total_dist > 0 and math.clamp01(brake_dist_left / total_dist) or nil

			self:_update_movement_modifier(scratchpad, math.remap(0, 1, 0.02, 1, modifier))
		end
	end
end

BtValkyrieShootAction._update_movement_modifier = function (self, scratchpad, new_modifier_or_nil)
	if scratchpad.movement_modifier_id then
		scratchpad.navigation_extension:remove_movement_modifier(scratchpad.movement_modifier_id)
	end

	if new_modifier_or_nil then
		scratchpad.movement_modifier_id = scratchpad.navigation_extension:add_movement_modifier(new_modifier_or_nil)
	else
		scratchpad.movement_modifier_id = nil
	end
end

BtValkyrieShootAction._start_moving = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local behavior_component = scratchpad.behavior_component
	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		behavior_component.move_state = "moving"
	end

	local strafe_speed = scratchpad.strafe_speed
	local current_speed = Vector3.length(scratchpad.locomotion_extension:current_velocity())

	scratchpad.transition_speed = strafe_speed < current_speed

	navigation_extension:set_enabled(true, math.max(strafe_speed, current_speed))

	return true
end

BtValkyrieShootAction._stop_moving = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension

	if not navigation_extension:is_computing_path() then
		navigation_extension:stop()
		self:_update_movement_modifier(scratchpad, nil)
	end

	navigation_extension:set_enabled(false)

	scratchpad.behavior_component.move_state = "idle"
end

BtValkyrieShootAction._start_strafe_timer = function (self, scratchpad, t)
	local strafe_component = scratchpad.strafe_component

	strafe_component.strafe_timer_started_t = t
	strafe_component.strafe_delay = 4 + math.random() * 3
end

BtValkyrieShootAction._is_done = function (self, scratchpad, blackboard)
	local perception_component = blackboard.perception
	local target_unit = perception_component.target_unit

	if HEALTH_ALIVE[target_unit] then
		return false
	end

	if scratchpad.stopping or scratchpad.wants_stop then
		return false
	end

	return scratchpad.behavior_component.move_state ~= "moving"
end

return BtValkyrieShootAction
