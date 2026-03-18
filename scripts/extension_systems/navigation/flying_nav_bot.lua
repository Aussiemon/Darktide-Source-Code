-- chunkname: @scripts/extension_systems/navigation/flying_nav_bot.lua

local FlyingNavBot = {}

local function _flying_navigation_system()
	return Managers.state.extension:system("flying_navigation_system")
end

FlyingNavBot.create = function (nav_bot, position, radius, max_speed)
	Managers.state.extension:system("flying_navigation_system"):register(nav_bot, position, radius, max_speed)
end

FlyingNavBot.set_use_avoidance = function (nav_bot, value)
	Managers.state.extension:system("flying_navigation_system"):set_use_avoidance(nav_bot, value)
end

FlyingNavBot.is_computing_new_path = function (nav_bot)
	return _flying_navigation_system():is_computing_new_path(nav_bot)
end

FlyingNavBot.has_path = function (nav_bot)
	return _flying_navigation_system():has_path(nav_bot)
end

FlyingNavBot.is_following_path = function (nav_bot)
	return _flying_navigation_system():is_following_path(nav_bot)
end

FlyingNavBot.clear_followed_path = function (nav_bot)
	return _flying_navigation_system():clear_followed_path(nav_bot)
end

FlyingNavBot.is_path_recomputation_needed = function (nav_bot)
	return _flying_navigation_system():is_path_recomputation_needed(nav_bot)
end

FlyingNavBot.compute_new_path = function (nav_bot, wanted_destination, far_pathing_allowed)
	_flying_navigation_system():compute_new_path(nav_bot, wanted_destination, far_pathing_allowed)
end

FlyingNavBot.output_velocity = function (nav_bot)
	return _flying_navigation_system():output_velocity(nav_bot)
end

FlyingNavBot.current_or_next_smartobject_interval = function (nav_bot, next_smart_object_interval, next_smart_object_distance)
	return nil
end

FlyingNavBot.update_position = function (nav_bot, position)
	_flying_navigation_system():update_position(nav_bot, position)
end

FlyingNavBot.cancel_async_path_computation = function (nav_bot)
	_flying_navigation_system():cancel_async_path_computation(nav_bot)
end

FlyingNavBot.has_reached_destination = function (nav_bot)
	return _flying_navigation_system():has_reached_destination(nav_bot)
end

FlyingNavBot.enter_manual_control = function (nav_bot, smart_object_interval)
	return nil
end

FlyingNavBot.exit_manual_control = function (nav_bot)
	return nil
end

FlyingNavBot.distance_to_next_smartobject = function (nav_bot, optional_max_distance)
	return _flying_navigation_system():distance_to_next_smartobject(nav_bot, optional_max_distance)
end

FlyingNavBot.get_path_nodes_count = function (nav_bot)
	return _flying_navigation_system():get_path_nodes_count(nav_bot)
end

FlyingNavBot.get_path_current_node_index = function (nav_bot)
	return _flying_navigation_system():get_path_current_node_index(nav_bot)
end

FlyingNavBot.get_path_node_pos = function (nav_bot, node_index)
	return _flying_navigation_system():get_path_node_pos(nav_bot, node_index)
end

FlyingNavBot.get_remaining_distance_from_progress_to_end_of_path = function (nav_bot)
	return _flying_navigation_system():get_remaining_distance_from_progress_to_end_of_path(nav_bot)
end

FlyingNavBot.remaining_distance_to_position = function (nav_bot, position)
	return _flying_navigation_system():remaining_distance_to_position(nav_bot, position)
end

FlyingNavBot.velocity = function (nav_bot)
	return _flying_navigation_system():velocity(nav_bot)
end

FlyingNavBot.get_far_path_nodes_count = function (nav_bot)
	return _flying_navigation_system():get_far_path_nodes_count(nav_bot)
end

FlyingNavBot.get_far_path_node_pos = function (nav_bot)
	return _flying_navigation_system():get_far_path_node_pos(nav_bot)
end

FlyingNavBot.destroy = function (nav_bot)
	return _flying_navigation_system():unregister(nav_bot)
end

FlyingNavBot.set_max_desired_linear_speed = function (nav_bot, max_speed)
	_flying_navigation_system():set_max_desired_linear_speed(nav_bot, max_speed)
end

FlyingNavBot.position_ahead_on_path = function (nav_bot, distance)
	return _flying_navigation_system():position_ahead_on_path(nav_bot, distance)
end

FlyingNavBot.position_ahead_on_path_from_position = function (nav_bot, position, distance)
	return _flying_navigation_system():position_ahead_on_path_from_position(nav_bot, position, distance)
end

FlyingNavBot.distance_to_progress_on_path = function (nav_bot)
	return _flying_navigation_system():distance_to_progress_on_path(nav_bot)
end

FlyingNavBot.cut_path_at_distance_from_current = function (nav_bot, distance)
	return _flying_navigation_system():cut_path_at_distance_from_current(nav_bot, distance)
end

return FlyingNavBot
