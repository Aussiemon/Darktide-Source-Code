local NavQueries = require("scripts/utilities/nav_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local fall_damage_settings = PlayerCharacterConstants.fall_damage
local BotNavTransition = {}
local NAV_MESH_ABOVE = 0.3
local NAV_MESH_BELOW = 0.3
local NAV_MESH_LATERAL = 0.9
local NAV_MESH_DISTANCE = 1

BotNavTransition.check_nav_mesh = function (wanted_from, wanted_to, nav_world, traverse_logic, drawer)
	local from = NavQueries.position_on_mesh(nav_world, wanted_from, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

	if not from then
		return false, nil, nil
	end

	local to = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_to, NAV_MESH_ABOVE, NAV_MESH_BELOW, NAV_MESH_LATERAL, NAV_MESH_DISTANCE)

	if not to then
		return false, from, nil
	end

	if GwNavQueries.raycango(nav_world, from, to, traverse_logic) then
		return false, from, to
	end

	return true, from, to
end

local BOT_DROP_HEIGHT = 0.5
local BOT_JUMP_HEIGHT = 0.3

BotNavTransition.calculate_nav_tag_layer = function (from, to, player_jumped)
	if player_jumped then
		return "bot_leap_of_faith"
	end

	local damage_multiplier = 140
	local min_fall_damage_height = fall_damage_settings.min_damage_height
	local max_health = 1000
	local diff = to - from
	local height = diff.z

	if height < -(min_fall_damage_height + max_health * 0.5 / damage_multiplier) then
		return nil
	elseif height < -min_fall_damage_height then
		return "bot_damage_drops"
	elseif height < -BOT_DROP_HEIGHT then
		return "bot_drops"
	elseif BOT_JUMP_HEIGHT < height then
		return "bot_jumps"
	end

	return nil
end

local EXTRA_FALL_TRANSITION_WAYPOINT_DISTANCE = 0.1

BotNavTransition.resolve_waypoint_position = function (from, via, player_jumped, physics_world)
	local waypoint = nil

	if player_jumped then
		waypoint = via
	else
		local from_to_via_flat_direction = Vector3.normalize(Vector3.flat(via - from))

		if Vector3.length_squared(from_to_via_flat_direction) > 0.001 then
			local test_position = via + from_to_via_flat_direction * EXTRA_FALL_TRANSITION_WAYPOINT_DISTANCE
			local hit, hit_position = PhysicsWorld.raycast(physics_world, via, from_to_via_flat_direction, EXTRA_FALL_TRANSITION_WAYPOINT_DISTANCE, "closest", "collision_filter", "filter_player_mover")

			if hit then
				waypoint = hit_position
			else
				waypoint = test_position
			end
		else
			waypoint = via
		end
	end

	return waypoint
end

return BotNavTransition
