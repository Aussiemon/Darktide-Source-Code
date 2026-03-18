-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_rendezvous_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local Utility = require("scripts/extension_systems/behavior/utilities/utility")
local NAV_TAG_LAYER_COSTS = {}
local BtRendezvousAction = class("BtRendezvousAction", "BtNode")

BtRendezvousAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local move_medium = behavior_component.move_medium
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.navigation_extension = navigation_extension
	scratchpad.unit = unit
	scratchpad.action_data = action_data
	scratchpad.animation_extension = ScriptUnit.has_extension(unit, "scripted_animation_system")

	local rendezvous_speed, acceleration

	if move_medium == "air" then
		rendezvous_speed = breed.fly_fast_speed or breed.fly_speed
		acceleration = breed.fly_fast_acceleration or breed.fly_acceleration
	else
		rendezvous_speed = breed.run_speed
		acceleration = breed.run_acceleration
	end

	scratchpad.rendezvous_speed = rendezvous_speed
	scratchpad.stop_distance = action_data.stop_distance

	navigation_extension:set_acceleration(acceleration)

	scratchpad.wants_stop = true

	self:_start_moving(scratchpad)

	for nav_tag_name, cost in pairs(NAV_TAG_LAYER_COSTS) do
		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
	end

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	local current_rotation_speed = locomotion_extension:rotation_speed()

	scratchpad.original_rotation_speed = current_rotation_speed

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	scratchpad.slowdown_distance_from_goal = action_data.slowdown_distance_from_goal or 0
	scratchpad.movement_modifier_id = nil
	scratchpad.previous_goal = Vector3Box()

	local rendezvous_component = Blackboard.write_component(blackboard, "rendezvous")

	scratchpad.rendezvous_component = rendezvous_component
	scratchpad.force_new_rendezvous_position = true
end

BtRendezvousAction.init_values = function (self, blackboard)
	local rendezvous_component = Blackboard.write_component(blackboard, "rendezvous")

	rendezvous_component.has_randezvous_position = false

	rendezvous_component.rendezvous_position:store(0, 0, 0)
	rendezvous_component.rendezvous_reference:store(0, 0, 0)
end

BtRendezvousAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

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

	scratchpad.had_path = false
end

BtRendezvousAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_update_stopping(scratchpad)
	self:_update_speed(scratchpad)
	self:_update_path(unit, blackboard, scratchpad, action_data, dt)

	local is_done = self:_is_done(scratchpad)

	return is_done and "done" or "running"
end

BtRendezvousAction._update_stopping = function (self, scratchpad)
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
		scratchpad.navigation_extension:set_max_speed(scratchpad.rendezvous_speed)
	end
end

BtRendezvousAction._is_done = function (self, scratchpad)
	if scratchpad.stopping or scratchpad.wants_stop then
		return false
	end

	local navigation_extension = scratchpad.navigation_extension

	if navigation_extension:is_computing_path() then
		return false
	end

	local has_path = navigation_extension:has_path()

	scratchpad.had_path = scratchpad.had_path or navigation_extension:has_path()

	if scratchpad.had_path and not has_path then
		return true
	end

	if has_path and navigation_extension:has_reached_destination() then
		return true
	end

	return false
end

BtRendezvousAction._update_path = function (self, unit, blackboard, scratchpad, action_data, dt)
	if scratchpad.stopping then
		return
	end

	local force_move = scratchpad.force_new_rendezvous_position

	if not force_move then
		local timer = scratchpad.update_path_timer - dt

		scratchpad.update_path_timer = timer

		if timer > 0 then
			return
		end
	end

	scratchpad.force_new_rendezvous_position = false

	local rendezvous_component = scratchpad.rendezvous_component
	local current_reference = rendezvous_component.rendezvous_reference:unbox()
	local rendezvous_position, rendezvous_reference = Utility.find_rendezvous_position(unit, action_data, blackboard)
	local radius = action_data.rendezvous_radius

	if not rendezvous_component.has_randezvous_position or Vector3.distance_squared(current_reference, rendezvous_reference) > radius * radius then
		rendezvous_component.rendezvous_position:store(rendezvous_position)
		rendezvous_component.rendezvous_reference:store(rendezvous_reference)

		rendezvous_component.has_randezvous_position = true
		force_move = true
	end

	if force_move then
		local navigation_extension = scratchpad.navigation_extension

		if navigation_extension:is_following_path() then
			scratchpad.wants_stop = true
			scratchpad.force_new_rendezvous_position = true

			return
		end

		scratchpad.had_path = false

		navigation_extension:cancel_computation()
		navigation_extension:move_to(rendezvous_component.rendezvous_position:unbox())
		self:_update_movement_modifier(scratchpad, nil)
	end

	scratchpad.update_path_timer = 0.5
end

BtRendezvousAction._update_speed = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension

	if not self:_is_following_path(scratchpad) then
		self:_update_movement_modifier(scratchpad, 0)
		scratchpad.animation_extension:set_ignore_poi_reason("BtRendezvousAction", false)

		return
	end

	local goal_pos = navigation_extension:goal_position()

	if Vector3.distance_squared(goal_pos, scratchpad.previous_goal:unbox()) > 1e-06 then
		self:_update_movement_modifier(scratchpad, nil)
		scratchpad.previous_goal:store(goal_pos)
	end

	local modifier = 1
	local _, is_goal = navigation_extension:position_ahead_on_path(scratchpad.slowdown_distance_from_goal)

	if is_goal then
		local distance_left = navigation_extension:remaining_distance_from_progress_to_end_of_path()

		modifier = modifier * math.remap(0, 1, 0.02, 1, math.clamp01(distance_left / scratchpad.slowdown_distance_from_goal))
	end

	scratchpad.animation_extension:set_ignore_poi_reason("BtRendezvousAction", not is_goal)

	local track_pos = navigation_extension:position_ahead_on_path(30)
	local in_front_pos = navigation_extension:position_ahead_on_path(1)
	local own_pos = POSITION_LOOKUP[scratchpad.unit]
	local dot = Vector3.dot(Vector3.normalize(track_pos - own_pos), Vector3.normalize(in_front_pos - own_pos))
	local dot_modifier = math.remap(0, 1, 0.1, 1, dot)

	modifier = modifier * dot_modifier

	self:_update_movement_modifier(scratchpad, modifier ~= 1 and modifier or nil)
end

BtRendezvousAction._update_movement_modifier = function (self, scratchpad, new_modifier_or_nil)
	if scratchpad.movement_modifier_id then
		scratchpad.navigation_extension:remove_movement_modifier(scratchpad.movement_modifier_id)
	end

	if new_modifier_or_nil then
		scratchpad.movement_modifier_id = scratchpad.navigation_extension:add_movement_modifier(new_modifier_or_nil)
	else
		scratchpad.movement_modifier_id = nil
	end
end

BtRendezvousAction._start_moving = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local behavior_component = scratchpad.behavior_component
	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		behavior_component.move_state = "moving"
	end

	local speed = scratchpad.rendezvous_speed

	if scratchpad.stopping then
		speed = Vector3.length(scratchpad.locomotion_extension:current_velocity())
	end

	navigation_extension:set_enabled(true, speed)
end

BtRendezvousAction._is_following_path = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension

	return navigation_extension:has_path() and navigation_extension:is_following_path()
end

return BtRendezvousAction
