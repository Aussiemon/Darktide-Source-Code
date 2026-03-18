-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_flee_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local NAV_TAG_LAYER_COSTS = {}
local BtFleeAction = class("BtFleeAction", "BtNode")

BtFleeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local move_medium = behavior_component.move_medium
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.navigation_extension = navigation_extension
	scratchpad.unit = unit
	scratchpad.action_data = action_data
	scratchpad.animation_extension = ScriptUnit.has_extension(unit, "scripted_animation_system")

	local flee_speed, acceleration

	if move_medium == "air" then
		flee_speed = breed.fly_fast_speed or breed.fly_speed
		acceleration = breed.fly_fast_acceleration or breed.fly_acceleration
	else
		flee_speed = breed.run_speed
		acceleration = breed.run_acceleration
	end

	scratchpad.animation_extension:set_ignore_poi_reason("BtFleeAction", true)

	scratchpad.flee_speed = flee_speed
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

	local flee_component = Blackboard.write_component(blackboard, "flee")

	scratchpad.flee_component = flee_component
end

BtFleeAction.init_values = function (self, blackboard)
	local flee_component = Blackboard.write_component(blackboard, "flee")

	flee_component.wants_flee = false

	flee_component.flee_position:store(0, 0, 0)
end

BtFleeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
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

BtFleeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.dying then
		return "running"
	end

	self:_update_stopping(scratchpad)
	self:_update_speed(scratchpad)
	self:_update_path(unit, blackboard, scratchpad, action_data, dt)

	local is_done = self:_is_done(scratchpad)

	if is_done then
		scratchpad.dying = true

		local damage_profile = DamageProfileTemplates.minion_instakill

		Attack.execute(unit, damage_profile, "instakill", true)
	end

	return "running"
end

BtFleeAction._update_stopping = function (self, scratchpad)
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
		scratchpad.navigation_extension:set_max_speed(scratchpad.flee_speed)
	end
end

BtFleeAction._is_done = function (self, scratchpad)
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

BtFleeAction._update_path = function (self, unit, blackboard, scratchpad, action_data, dt)
	if scratchpad.stopping then
		return
	end

	local initiated_move = scratchpad.initiated_move

	if initiated_move then
		return
	end

	scratchpad.initiated_move = true

	local flee_component = scratchpad.flee_component
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:move_to(flee_component.flee_position:unbox())
end

BtFleeAction._update_speed = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension

	if not self:_is_following_path(scratchpad) then
		self:_update_movement_modifier(scratchpad, 0)

		return
	end

	local goal_pos = navigation_extension:goal_position()

	if Vector3.distance_squared(goal_pos, scratchpad.previous_goal:unbox()) > 1e-06 then
		self:_update_movement_modifier(scratchpad, nil)
		scratchpad.previous_goal:store(goal_pos)
	end

	local modifier = 1

	if scratchpad.slowdown_distance_from_goal > 0 then
		local _, is_goal = navigation_extension:position_ahead_on_path(scratchpad.slowdown_distance_from_goal)

		if is_goal then
			local distance_left = navigation_extension:remaining_distance_from_progress_to_end_of_path()

			modifier = modifier * math.remap(0, 1, 0.02, 1, math.clamp01(distance_left / scratchpad.slowdown_distance_from_goal))
		end
	end

	local track_pos = navigation_extension:position_ahead_on_path(30)
	local in_front_pos = navigation_extension:position_ahead_on_path(1)
	local own_pos = POSITION_LOOKUP[scratchpad.unit]
	local dot = Vector3.dot(Vector3.normalize(track_pos - own_pos), Vector3.normalize(in_front_pos - own_pos))
	local dot_modifier = math.remap(0, 1, 0.1, 1, dot)

	modifier = modifier * dot_modifier

	self:_update_movement_modifier(scratchpad, modifier ~= 1 and modifier or nil)
end

BtFleeAction._update_movement_modifier = function (self, scratchpad, new_modifier_or_nil)
	if scratchpad.movement_modifier_id then
		scratchpad.navigation_extension:remove_movement_modifier(scratchpad.movement_modifier_id)
	end

	if new_modifier_or_nil then
		scratchpad.movement_modifier_id = scratchpad.navigation_extension:add_movement_modifier(new_modifier_or_nil)
	else
		scratchpad.movement_modifier_id = nil
	end
end

BtFleeAction._start_moving = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local behavior_component = scratchpad.behavior_component
	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		behavior_component.move_state = "moving"
	end

	local speed = scratchpad.flee_speed

	if scratchpad.stopping then
		speed = Vector3.length(scratchpad.locomotion_extension:current_velocity())
	end

	navigation_extension:set_enabled(true, speed)
end

BtFleeAction._is_following_path = function (self, scratchpad)
	local navigation_extension = scratchpad.navigation_extension

	return navigation_extension:has_path() and navigation_extension:is_following_path()
end

return BtFleeAction
