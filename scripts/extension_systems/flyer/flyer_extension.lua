-- chunkname: @scripts/extension_systems/flyer/flyer_extension.lua

local FlyerExtension = class("FlyerExtension")

FlyerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._owner_system = extension_init_context.owner_system
	self._world = Unit.world(unit)
	self._physics_world = World.physics_world(self._world)
	self._active = false
end

FlyerExtension.setup_from_component = function (self, start_free_flight_enabled)
	self._active = start_free_flight_enabled
end

local function _distance(start_unit, end_unit)
	local start_position = Unit.world_position(start_unit, 1)
	local end_position = Unit.world_position(end_unit, 1)

	return Vector3.distance(start_position, end_position)
end

FlyerExtension.set_active = function (self, active)
	self._active = active
end

FlyerExtension.get_target_player = function (self)
	local player_manager = Managers.player
	local players = player_manager:players()
	local tracked_units = {}

	for unique_id, player in pairs(players) do
		if player:unit_is_alive() then
			tracked_units[#tracked_units + 1] = player.player_unit
		end
	end

	local lowest_distance = math.huge
	local playet_unit

	for i = 1, #tracked_units do
		local distance = _distance(tracked_units[i], self._unit)

		if distance < lowest_distance then
			lowest_distance = distance
			playet_unit = tracked_units[i]
		end
	end

	return playet_unit
end

FlyerExtension.update = function (self, unit, dt, t)
	if not self._active then
		return
	end

	local target_unit = self:get_target_player()

	if target_unit then
		local self_position = Unit.world_position(self._unit, 1)
		local self_rotation = Unit.local_rotation(unit, 1)
		local target_position = Unit.world_position(target_unit, 1)
		local to_target_vector = self_position - target_position
		local new_rotation = Quaternion.lerp(self_rotation, Quaternion.look(to_target_vector), dt * 2)

		Unit.set_local_rotation(unit, 1, new_rotation)

		local wanted_location = target_position + Vector3.normalize(Vector3.flat(to_target_vector)) * 16 + Vector3.up() * (4 + math.sin(t))
		local new_position = Vector3.lerp(self_position, wanted_location, dt)

		Unit.set_local_position(unit, 1, new_position)
	end
end

return FlyerExtension
