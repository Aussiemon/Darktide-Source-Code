-- chunkname: @scripts/extension_systems/navigation/minion_husk_navigation_extension.lua

local MinionHuskNavigationExtension = class("MinionHuskNavigationExtension")

MinionHuskNavigationExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
end

MinionHuskNavigationExtension.max_speed = function (self)
	local max_speed = GameSession.game_object_field(self._game_session, self._game_object_id, "max_speed")
	local max_speed_with_modifiers = GameSession.game_object_field(self._game_session, self._game_object_id, "max_speed_with_modifiers")

	return max_speed, max_speed_with_modifiers
end

return MinionHuskNavigationExtension
