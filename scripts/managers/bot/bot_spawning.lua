local BotSpawning = {}
local ProfileUtils = require("scripts/utilities/profile_utils")

BotSpawning.spawn_bot_character = function (profile_name)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local bot_manager = Managers.bot
		local bot_synchronizer_host = bot_manager:synchronizer_host()
		local player_manager = Managers.player
		local peer_id = Network.peer_id()
		local local_player_id = player_manager:next_available_local_player_id(peer_id)

		while bot_synchronizer_host:spawn_group_contains(local_player_id) do
			local_player_id = player_manager:next_available_local_player_id(peer_id, local_player_id + 1)
		end

		local profile = ProfileUtils.get_bot_profile(profile_name)

		bot_synchronizer_host:add_bot(local_player_id, profile)

		return local_player_id
	end
end

BotSpawning.despawn_bot_character = function (local_player_id, despawn_safe)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local bot_synchronizer_host = Managers.bot:synchronizer_host()

		if despawn_safe then
			bot_synchronizer_host:remove_bot_safe(local_player_id)
		else
			bot_synchronizer_host:remove_bot(local_player_id)
		end
	end
end

BotSpawning.despawn_best_bot = function ()
	local bot_synchronizer_host = Managers.bot:synchronizer_host()
	local bot_ids = bot_synchronizer_host:active_bot_ids()
	local local_player_id = next(bot_ids)

	if not local_player_id then
		Log.warning("BotSpawning", "Despawning bot attempted while no bot is present.")

		return
	end

	BotSpawning.despawn_bot_character(local_player_id)
end

return BotSpawning
