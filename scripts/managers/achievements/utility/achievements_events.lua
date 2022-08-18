local events = {
	{
		name = "player_unit_spawned",
		response = function (self, player)
			local valid_account_id = player.account_id and math.is_uuid(player:account_id())
			local valid_character_id = player.character_id and math.is_uuid(player:character_id())

			if valid_account_id and valid_character_id then
				Managers.stats:record_player_spawned(player)
			end
		end
	}
}
local AchievementsEvents = {
	install = function (target)
		for i = 1, #events, 1 do
			local call_back_name = "_on_" .. events[i].name
			target[call_back_name] = events[i].response

			Managers.event:register(target, events[i].name, call_back_name)
		end
	end,
	uninstall = function (target)
		for i = 1, #events, 1 do
			local call_back_name = "_on_" .. events[i].name

			Managers.event:unregister(target, events[i].name)

			target[call_back_name] = nil
		end
	end
}

return settings("AchievementsEvents", AchievementsEvents)
