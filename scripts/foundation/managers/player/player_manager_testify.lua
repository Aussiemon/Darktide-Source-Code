local PlayerMovement = require("scripts/utilities/player_movement")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local PlayerManagerTestify = {
	has_placeholder_profile = function (player, _)
		return player:has_placeholder_profile()
	end,
	is_party_full = function (_, player_manager)
		return player_manager._num_players >= 4
	end,
	local_player = function (id, player_manager)
		local local_player_id = id
		local local_player = player_manager:local_player(local_player_id)

		return local_player
	end,
	local_player_archetype_name = function (id, player_manager)
		local local_player_id = id
		local local_player = player_manager:local_player(local_player_id)

		return local_player:archetype_name()
	end,
	make_players_invulnerable = function (_, player_manager)
		for _, player in pairs(player_manager._players) do
			if player:unit_is_alive() then
				local player_unit = player.player_unit
				local health_extension = ScriptUnit.extension(player_unit, "health_system")

				health_extension:set_invulnerable(true)
			end
		end
	end,
	make_players_unkillable = function (_, player_manager)
		for _, player in pairs(player_manager._players) do
			if player:unit_is_alive() then
				local player_unit = player.player_unit
				local health_extension = ScriptUnit.extension(player_unit, "health_system")

				health_extension:set_unkillable(true)
			end
		end
	end,
	move_bots_to_position = function (position, player_manager)
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
	num_bots = function (_, player_manager)
		local players = player_manager:players()
		local bots = table.filter(players, function (player)
			return not player:is_human_controlled()
		end)
		local num_bots = table.size(bots)

		return num_bots
	end,
	player_current_position = function (_, player_manager)
		local _, player = next(player_manager._human_players)

		return POSITION_LOOKUP[player.player_unit]
	end,
	player_unit = function (_, player_manager)
		local players = player_manager:players()
		local human_players = table.filter(players, function (player)
			return player:is_human_controlled()
		end)
		local _, player = next(human_players)
		local player_unit = player.player_unit

		return player_unit
	end,
	players_are_alive = function (_, player_manager)
		local human_players = player_manager:human_players()

		for _, human_player in pairs(human_players) do
			if not human_player:unit_is_alive() then
				return false
			end
		end

		return true
	end
}

PlayerManagerTestify.teleport_bots_forward_on_main_path_if_blocked = function (bots_data, player_manager)
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
end

PlayerManagerTestify.teleport_players_to_main_path_point = function (main_path_point, player_manager)
	local players = player_manager:players()
	local human_players = table.filter(players, function (player)
		return player:is_human_controlled()
	end)
	local target_position = MainPathQueries.position_from_distance(main_path_point)

	if target_position then
		target_position.z = target_position.z

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
end

PlayerManagerTestify.teleport_player_to_position = function (position, player_manager)
	local players = player_manager:players()
	local human_players = table.filter(players, function (player)
		return player:is_human_controlled()
	end)
	local _, human_player = next(human_players)

	if human_player then
		local pos = position:unbox()

		PlayerMovement.teleport(human_player, pos, Quaternion.identity())
	end
end

PlayerManagerTestify.wait_for_bots_to_reach_position = function (wait_for_bots_position_data, player_manager)
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
end

PlayerManagerTestify.wait_for_item_equipped = function (data, time, timeout)
	local TIMEOUT = type(timeout) == "number" and timeout or 0.4

	if type(time) == "number" and TIMEOUT < os.clock() - time then
		return
	end

	local inventory_component = ScriptUnit.extension(data.player.player_unit, "unit_data_system"):read_component("inventory")
	local current_item = inventory_component[data.slot]

	if data.item.name ~= current_item then
		return Testify.RETRY
	end
end

return PlayerManagerTestify
