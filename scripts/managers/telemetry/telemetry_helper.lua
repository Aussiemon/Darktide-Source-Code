-- chunkname: @scripts/managers/telemetry/telemetry_helper.lua

local TelemetryHelper = class("TelemetryHelper")

TelemetryHelper.unit_position = function (unit)
	return POSITION_LOOKUP[unit]
end

TelemetryHelper.unit_coherency = function (unit)
	local coherency_ext = ScriptUnit.has_extension(unit, "coherency_system")

	if coherency_ext then
		return coherency_ext:num_units_in_coherency()
	end
end

TelemetryHelper.chunk_at_unit = function (unit)
	local world = Unit.world(unit)
	local physics_world = World.physics_world(world)
	local found_collision, _, _, _, floor_actor = PhysicsWorld.raycast(physics_world, TelemetryHelper.unit_position(unit), Vector3.down(), "closest", "types", "statics", "collision_filter", "filter_player_mover")

	if found_collision then
		local floor_unit = Actor.unit(floor_actor)
		local level = Unit.level(floor_unit)

		return level and Level.name(level)
	end
end

return TelemetryHelper
