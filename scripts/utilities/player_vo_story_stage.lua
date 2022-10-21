local PlayerVOStoryStage = {
	set_story_stage = function (stage)
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)

		if player and player:unit_is_alive() then
			local player_unit = player.player_unit
			local dialogue_extension = ScriptUnit.has_extension(player_unit, "dialogue_system")

			if dialogue_extension then
				dialogue_extension:set_story_stage(stage)
			end
		end
	end
}

PlayerVOStoryStage.refresh_hub_story_stage = function ()
	local mission_board = Managers.narrative:event_is_complete(Managers.narrative.EVENTS.mission_board)

	if not mission_board then
		PlayerVOStoryStage.set_story_stage("mission_board")

		return
	end

	PlayerVOStoryStage.set_story_stage("missions")
end

return PlayerVOStoryStage
