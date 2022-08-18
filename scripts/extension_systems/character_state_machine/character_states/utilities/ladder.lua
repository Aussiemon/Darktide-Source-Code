local Ladder = {}

Ladder.started_climbing = function (ladder_character_state_component, ladder_unit, is_server, game_session, player_unit_game_object_id, player, player_unit)
	local ladder_unit_level_id = Managers.state.unit_spawner:level_index(ladder_unit)
	ladder_character_state_component.ladder_unit_id = ladder_unit_level_id

	if is_server then
		GameSession.set_game_object_field(game_session, player_unit_game_object_id, "ladder_unit_id", ladder_unit_level_id)
	end
end

Ladder.stopped_climbing = function (ladder_character_state_component, ladder_cooldown, is_server, game_session, player_unit_game_object_id, player, player_unit)
	local invalid_ladder_unit_id = NetworkConstants.invalid_level_unit_id
	ladder_character_state_component.ladder_unit_id = invalid_ladder_unit_id
	ladder_character_state_component.ladder_cooldown = ladder_cooldown

	if is_server then
		GameSession.set_game_object_field(game_session, player_unit_game_object_id, "ladder_unit_id", invalid_ladder_unit_id)
	end
end

Ladder.time_in_ladder_anim = function (unit, ladder_unit, breed)
	local bottom_node = Unit.node(ladder_unit, "node_bottom")
	local bottom_pos = Unit.world_position(ladder_unit, bottom_node)
	local unit_pos = Unit.world_position(unit, 1)
	local above_ladder_position = unit_pos.z - bottom_pos.z
	local whole_movement_anim_distance = breed.ladder_whole_movement_anim_distance
	local percentage_in_move_animation = above_ladder_position % whole_movement_anim_distance / whole_movement_anim_distance
	local movement_anim_length = breed.ladder_movement_anim_length

	return movement_anim_length * percentage_in_move_animation
end

return Ladder
