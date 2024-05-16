-- chunkname: @scripts/foundation/managers/player/player_manager_testify.lua

local MainPathQueries = require("scripts/utilities/main_path_queries")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerManagerTestify = {
	character_state_component = function (_, unit_data_extension)
		return unit_data_extension:read_component("character_state")
	end,
	unit_data_extension = function (_, player_unit)
		return ScriptUnit.extension(player_unit, "unit_data_system")
	end,
	has_local_profile = function (_, player)
		return player:has_local_profile()
	end,
	is_party_full = function (player_manager)
		return player_manager._num_players >= 4
	end,
	local_player = function (player_manager, id)
		local local_player_id = id
		local local_player = player_manager:local_player(local_player_id)

		return local_player
	end,
	local_player_archetype_name = function (player_manager, id)
		local local_player_id = id
		local local_player = player_manager:local_player(local_player_id)

		return local_player:archetype_name()
	end,
	make_players_invulnerable = function (player_manager)
		for _, player in pairs(player_manager._players) do
			if player:unit_is_alive() then
				local player_unit = player.player_unit
				local health_extension = ScriptUnit.extension(player_unit, "health_system")

				health_extension:set_invulnerable(true)
			end
		end
	end,
	make_players_unkillable = function (player_manager)
		for _, player in pairs(player_manager._players) do
			if player:unit_is_alive() then
				local player_unit = player.player_unit
				local health_extension = ScriptUnit.extension(player_unit, "health_system")

				health_extension:set_unkillable(true)
			end
		end
	end,
	move_bots_to_position = function (player_manager, position)
		local pos = position:unbox()
		local players = player_manager:players()
		local bots = table.filter(players, function (player)
			return not player:is_human_controlled()
		end)

		for _, bot in pairs(bots) do
			if bot:unit_is_alive() then
				local bot_unit = bot.player_unit
				local behavior_extension = ScriptUnit.extension(bot_unit, "behavior_system")

				behavior_extension:set_hold_position(pos, 0.1)
			end
		end
	end,
	num_bots = function (player_manager)
		local num_bots = player_manager:num_players() - player_manager:num_human_players()

		return num_bots
	end,
	player_current_position = function (player_manager)
		local _, player = next(player_manager._human_players)

		return POSITION_LOOKUP[player.player_unit]
	end,
	player_unit = function (player_manager)
		local players = player_manager:players()
		local human_players = table.filter(players, function (player)
			return player:is_human_controlled()
		end)
		local _, player = next(human_players)
		local player_unit = player.player_unit

		return player_unit
	end,
	players_are_alive = function (player_manager)
		local human_players = player_manager:human_players()

		for _, human_player in pairs(human_players) do
			if not human_player:unit_is_alive() then
				return false
			end
		end

		return true
	end,
	teleport_bots_forward_on_main_path_if_blocked = function (player_manager, bots_data)
		local bots_stuck_data = bots_data.bots_stuck_data
		local main_path_point = bots_data.main_path_point
		local bots_blocked_time_before_teleportation = bots_data.bots_blocked_time_before_teleportation or 6
		local players = player_manager:players()
		local bots = table.filter(players, function (player)
			return not player:is_human_controlled()
		end)

		for _, bot in pairs(bots) do
			if bot:unit_is_alive() then
				local bot_id = bot:local_player_id() - 1
				local bot_stuck_data = bots_stuck_data[bot_id]
				local bot_pos = POSITION_LOOKUP[bot.player_unit]
				local stored_bot_position = bot_stuck_data[1]:unbox()
				local bot_distance_from_stored_position = Vector3.distance_squared(stored_bot_position, bot_pos)
				local bots_blocked_distance = bots_data.bots_blocked_distance or 2

				if bot_distance_from_stored_position < bots_blocked_distance then
					local stored_time = bot_stuck_data[2]
					local time_interval_since_stored_time = os.time() - stored_time

					if bots_blocked_time_before_teleportation < time_interval_since_stored_time then
						local tp_pos = MainPathQueries.position_from_distance(main_path_point)

						if tp_pos then
							tp_pos.z = tp_pos.z + 1

							Log.info("Testify", "The bot %s has almost not moved since %ss. Teleporting bot to x:%s, y:%s, z:%s", bot:local_player_id(), bots_blocked_time_before_teleportation, tp_pos.x, tp_pos.y, tp_pos.z)
							PlayerMovement.teleport(bot, tp_pos, Quaternion.identity())
						end
					end
				else
					bot_stuck_data[1]:store(bot_pos)

					bot_stuck_data[2] = os.time()
				end
			else
				Log.info("Testify", "Bot unit has been removed. Cannot teleport it.")
			end
		end
	end,
	teleport_players_to_main_path_point = function (player_manager, main_path_point)
		local players = player_manager:players()
		local human_players = table.filter(players, function (player)
			return player:is_human_controlled()
		end)
		local target_position = MainPathQueries.position_from_distance(main_path_point)

		if target_position then
			target_position.z = target_position.z + 0.5

			for _, player in pairs(human_players) do
				if not player or not player:unit_is_alive() then
					Log.info("Testify", "Player unit has been removed. Cannot teleport it.")

					return
				end

				local player_position = POSITION_LOOKUP[player.player_unit]
				local distance = Vector3.distance(target_position, player_position)

				if distance > 0.01 then
					local rotation = Quaternion.look(target_position - player_position)

					PlayerMovement.teleport(player, target_position, rotation)

					if GameParameters.debug_testify then
						Log.info("Testify", "Teleporting player to x:%s, y:%s, z:%s", target_position.x, target_position.y, target_position.z)
					end
				end
			end
		end
	end,
	teleport_player_to_position = function (player_manager, position)
		local players = player_manager:players()
		local human_players = table.filter(players, function (player)
			return player:is_human_controlled()
		end)
		local _, human_player = next(human_players)

		if human_player then
			local pos = position:unbox()

			PlayerMovement.teleport(human_player, pos, Quaternion.identity())
		end
	end,
	wait_for_bots_to_reach_position = function (player_manager, wait_for_bots_position_data)
		local position_boxed = wait_for_bots_position_data.position
		local radius = wait_for_bots_position_data.radius
		local position = position_boxed:unbox()
		local players = player_manager:players()
		local bots = table.filter(players, function (player)
			return not player:is_human_controlled()
		end)

		for _, bot in pairs(bots) do
			if bot:unit_is_alive() then
				local bot_unit = bot.player_unit
				local bot_position = Unit.world_position(bot_unit, 1)
				local delta_squared = Vector3.length_squared(Vector3.subtract(position, bot_position))
				local is_within_range = delta_squared < radius * radius

				if not is_within_range then
					return Testify.RETRY
				end
			end
		end
	end,
	wait_for_item_equipped = function (_, data, time, timeout)
		local TIMEOUT = type(timeout) == "number" and timeout or 0.4

		if type(time) == "number" and TIMEOUT < os.clock() - time then
			return
		end

		local visual_loadout_extension = ScriptUnit.extension(data.player.player_unit, "visual_loadout_system")
		local current_item = visual_loadout_extension:item_in_slot(data.slot)

		if current_item == nil or current_item.name ~= data.item.name then
			return Testify.RETRY
		end
	end,
}

return PlayerManagerTestify
