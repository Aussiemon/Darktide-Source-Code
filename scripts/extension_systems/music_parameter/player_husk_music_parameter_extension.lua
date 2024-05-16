﻿-- chunkname: @scripts/extension_systems/music_parameter/player_husk_music_parameter_extension.lua

local PlayerHuskMusicParameterExtension = class("PlayerHuskMusicParameterExtension")

PlayerHuskMusicParameterExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._vector_horde_near = false
	self._ambush_horde_near = false
	self._last_man_standing = false
	self._boss_near = false
	self._health_percent = 0
	self._intensity_percent = 0
	self._tension_percent = 0
	self._locked_in_melee = false
	self._update_timer = 0
end

PlayerHuskMusicParameterExtension.on_game_object_created = function (self, game_session, game_object_id)
	self._game_session, self._game_object_id = game_session, game_object_id
end

PlayerHuskMusicParameterExtension.on_game_object_destroyed = function (self, game_session, game_object_id)
	self._game_session, self._game_object_id = nil
end

PlayerHuskMusicParameterExtension.update = function (self, unit, dt, t)
	local game_session, game_object_id = self._game_session, self._game_object_id

	if not game_session or not game_object_id or t < self._update_timer then
		return
	end

	self._vector_horde_near = GameSession.game_object_field(game_session, game_object_id, "vector_horde_near")
	self._ambush_horde_near = GameSession.game_object_field(game_session, game_object_id, "ambush_horde_near")
	self._last_man_standing = GameSession.game_object_field(game_session, game_object_id, "last_man_standing")
	self._boss_near = GameSession.game_object_field(game_session, game_object_id, "boss_near")
	self._health_percent = self._health_extension:current_health_percent()
	self._intensity_percent = GameSession.game_object_field(game_session, game_object_id, "intensity_percent")
	self._tension_percent = GameSession.game_object_field(game_session, game_object_id, "tension_percent")
	self._num_aggroed_minions_near = GameSession.game_object_field(game_session, game_object_id, "num_aggroed_minions_near")
	self._locked_in_melee = GameSession.game_object_field(game_session, game_object_id, "locked_in_melee")
	self._num_aggroed_minions = GameSession.game_object_field(game_session, game_object_id, "num_aggroed_minions")
	self._update_timer = t + 0.5
end

PlayerHuskMusicParameterExtension.num_aggroed_minions_near = function (self)
	return self._num_aggroed_minions_near
end

PlayerHuskMusicParameterExtension.tension_percent = function (self)
	return self._tension_percent
end

PlayerHuskMusicParameterExtension.vector_horde_near = function (self)
	return self._vector_horde_near
end

PlayerHuskMusicParameterExtension.ambush_horde_near = function (self)
	return self._ambush_horde_near
end

PlayerHuskMusicParameterExtension.last_man_standing = function (self)
	return self._last_man_standing
end

PlayerHuskMusicParameterExtension.boss_near = function (self)
	return self._boss_near
end

PlayerHuskMusicParameterExtension.health_percent = function (self)
	return self._health_percent
end

PlayerHuskMusicParameterExtension.intensity_percent = function (self)
	return self._intensity_percent
end

PlayerHuskMusicParameterExtension.locked_in_melee = function (self)
	return self._locked_in_melee
end

PlayerHuskMusicParameterExtension.num_aggroed_minions = function (self)
	return self._num_aggroed_minions
end

return PlayerHuskMusicParameterExtension
