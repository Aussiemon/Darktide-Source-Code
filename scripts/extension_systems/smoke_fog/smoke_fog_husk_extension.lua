-- chunkname: @scripts/extension_systems/smoke_fog/smoke_fog_husk_extension.lua

local SmokeFogHuskExtension = class("SmokeFogHuskExtension")

SmokeFogHuskExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id

	local smoke_fade_frame = GameSession.game_object_field(game_session, game_object_id, "smoke_fade_frame")

	self._smoke_fade_frame = smoke_fade_frame
	self._smoke_fade_t = smoke_fade_frame * Managers.state.game_session.fixed_time_step
end

SmokeFogHuskExtension.update = function (self, unit, dt, t)
	local game_session, game_object_id = self._game_session, self._game_object_id
	local smoke_fade_frame = GameSession.game_object_field(game_session, game_object_id, "smoke_fade_frame")

	if smoke_fade_frame ~= self._smoke_fade_frame then
		self._smoke_fade_frame = smoke_fade_frame
		self._smoke_fade_t = smoke_fade_frame * Managers.state.game_session.fixed_time_step
	end
end

SmokeFogHuskExtension.remaining_duration = function (self, t)
	return self._smoke_fade_t - t
end

return SmokeFogHuskExtension
