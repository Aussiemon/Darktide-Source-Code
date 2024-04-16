local PlayerProximityExtension = class("PlayerProximityExtension")

PlayerProximityExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self.breed = extension_init_data.breed
	self._side_id = extension_init_data.side_id
end

PlayerProximityExtension.extensions_ready = function (self, world, unit)
	self.side = Managers.state.extension:system("side_system"):get_side(self._side_id)
end

return PlayerProximityExtension
