-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_teleport_to_ally_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerMovement = require("scripts/utilities/player_movement")
local BtBotTeleportToAllyAction = class("BtBotTeleportToAllyAction", "BtNode")

local function _debug_draw_cant_reach_ally(unit, follow_component)
	local bot_position = POSITION_LOOKUP[unit]
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local duration = 60
	local destination = follow_component.destination:unbox()
	local between_position = Vector3.lerp(bot_position, destination, 0.5)

	QuickTimedDrawer:sphere(bot_position, 0.5, duration, Color.red())
	QuickTimedDrawer:sphere(destination, 0.5, duration, Color.red())
	QuickTimedDrawer:line(bot_position, destination, duration, Color.red())
	QuickTimedDrawer:line(between_position, between_position + Vector3(0, 0, 3), duration, Color.red())

	local debug_text_1 = string.format("LD Warning! (%s)", player:name())
	local debug_text_2 = "Bot Pathing Between Navmeshes Failed!"
	local debug_text_3 = string.format("pos(%.2f, %.2f, %.2f)", bot_position.x, bot_position.y, bot_position.z)
	local debug_text_4 = string.format("pos(%.2f, %.2f, %.2f)", destination.x, destination.y, destination.z)
	local options = {
		time = duration,
		color = Color.red(),
		rotation = Quaternion.identity(),
	}

	Debug:world_text(debug_text_1, between_position + Vector3(0, 0, 3), options)
	Debug:world_text(debug_text_2, between_position + Vector3(0, 0, 2.5), options)
	Debug:world_text(debug_text_3, between_position + Vector3(0, 0, 2), options)
	Debug:world_text(debug_text_4, between_position + Vector3(0, 0, 1.5), options)
end

BtBotTeleportToAllyAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local group_extension = ScriptUnit.extension(unit, "group_system")
	local follow_component = Blackboard.write_component(blackboard, "follow")

	scratchpad.follow_component = follow_component
	scratchpad.bot_group_data = group_extension:bot_group_data()
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.behavior_extension = ScriptUnit.extension(unit, "behavior_system")

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)

	scratchpad.player = player
end

BtBotTeleportToAllyAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local bot_group_data = scratchpad.bot_group_data
	local follow_unit = bot_group_data.follow_unit
	local follow_component = scratchpad.follow_component
	local navigation_extension = scratchpad.navigation_extension
	local teleport_position

	if follow_component.level_forced_teleport then
		follow_component.level_forced_teleport = false

		local level_force_teleport_position = follow_component.level_forced_teleport_position:unbox()

		if Vector3.length_squared(level_force_teleport_position) ~= 0 then
			teleport_position = level_force_teleport_position

			follow_component.level_forced_teleport_position:store(Vector3.zero())
		end
	end

	if not teleport_position then
		local follow_unit_data_extension = ScriptUnit.extension(follow_unit, "unit_data_system")
		local follow_unit_first_person_component = follow_unit_data_extension:read_component("first_person")
		local follow_unit_rotation = follow_unit_first_person_component.rotation
		local check_direction = -Quaternion.forward(follow_unit_rotation)
		local follow_unit_navigation_extension = ScriptUnit.extension(follow_unit, "navigation_system")
		local from_position = follow_unit_navigation_extension:latest_position_on_nav_mesh()
		local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()

		teleport_position = NavQueries.position_near_nav_position(from_position, check_direction, nav_world, traverse_logic)
	end

	local player = scratchpad.player

	PlayerMovement.teleport(player, teleport_position, Quaternion.identity())

	follow_component.has_teleported = true
	follow_component.needs_destination_refresh = true

	return "done"
end

return BtBotTeleportToAllyAction
