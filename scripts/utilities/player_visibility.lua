-- chunkname: @scripts/utilities/player_visibility.lua

local PlayerVisibility = {}

PlayerVisibility.show_players = function ()
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local unit = player.player_unit
		local player_visibility = ScriptUnit.has_extension(unit, "player_visibility_system")

		if player_visibility then
			player_visibility:show()
		end
	end
end

PlayerVisibility.hide_players = function ()
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local unit = player.player_unit
		local player_visibility = ScriptUnit.has_extension(unit, "player_visibility_system")

		if player_visibility then
			player_visibility:hide()
		end
	end
end

PlayerVisibility.restore_remote_players = function ()
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		if player.remote then
			local unit = player.player_unit
			local player_visibility_ext = ScriptUnit.has_extension(unit, "player_visibility_system")

			if player_visibility_ext then
				player_visibility_ext:show()
			end
		end
	end
end

PlayerVisibility.store_and_hide_remote_players = function ()
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		if player.remote then
			local unit = player.player_unit
			local player_visibility_ext = ScriptUnit.has_extension(unit, "player_visibility_system")

			if player_visibility_ext then
				player_visibility_ext:hide()
			end
		end
	end
end

return PlayerVisibility
