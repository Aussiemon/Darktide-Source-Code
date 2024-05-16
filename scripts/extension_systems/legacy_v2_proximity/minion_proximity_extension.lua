-- chunkname: @scripts/extension_systems/legacy_v2_proximity/minion_proximity_extension.lua

local MinionProximityExtension = class("MinionProximityExtension")

MinionProximityExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local breed = extension_init_data.breed

	self.breed = breed

	if not DEDICATED_SERVER then
		local is_server = extension_init_context.is_server

		if is_server then
			self._unit = unit
		else
			local culling_weight = breed.fx_proximity_culling_weight

			FxProximityCulling.register_unit(unit, nil_or_game_object_id, culling_weight)
		end
	end
end

MinionProximityExtension.destroy = function (self, unit)
	if not DEDICATED_SERVER then
		FxProximityCulling.unregister_unit(unit)
	end
end

MinionProximityExtension.game_object_initialized = function (self, game_session, game_object_id)
	if not DEDICATED_SERVER then
		local culling_weight = self.breed.fx_proximity_culling_weight

		FxProximityCulling.register_unit(self._unit, game_object_id, culling_weight)
	end
end

return MinionProximityExtension
