-- chunkname: @scripts/managers/bot/bot_manager_testify.lua

local BotSpawning = require("scripts/managers/bot/bot_spawning")
local MasterItems = require("scripts/backend/master_items")
local BotManagerTestify = {
	spawn_random_bot = function ()
		local is_server = Managers.state.game_session:is_server()
		local profile_id = math.random(1, 6)
		local profile_name = "bot_" .. profile_id

		BotSpawning.spawn_bot_character(profile_name)
	end,
	wait_for_bot_synchronizer_ready = function ()
		local package_synchronizer_host = Managers.package_synchronization:synchronizer_host()
		local peer_id = Network.peer_id()

		if not package_synchronizer_host:is_peer_synced(peer_id) then
			return Testify.RETRY
		end
	end,
	wait_for_master_items_data = function ()
		if not MasterItems.has_data() then
			return Testify.RETRY
		end
	end,
}

return BotManagerTestify
