local ScriptWorld = require("scripts/foundation/utilities/script_world")
local AsyncLevelSpawner = class("AsyncLevelSpawner")

AsyncLevelSpawner.init = function (self, world_name, level_name, parameters, frame_time_budget, optional_world, excluded_object_sets)
	local world = optional_world or self.setup_world(world_name, parameters)
	self._is_world_owner = not optional_world
	self._level_name = level_name
	self._world = world
	self._level_spawn_time_budget = frame_time_budget
	local position = Vector3(0, 0, 0)
	local rotation = Quaternion.identity()
	self._level = ScriptWorld.spawn_level(world, level_name, position, rotation, false, false, nil, excluded_object_sets)
end

AsyncLevelSpawner.destroy = function (self)
	if self._level then
		ScriptWorld.destroy_level(self._world, self._level_name)

		self._level = nil
	end

	if self._world then
		if self._is_world_owner then
			Managers.world:destroy_world(self._world)
		end

		self._world = nil
	end
end

AsyncLevelSpawner.update = function (self)
	local done = Level.update_spawn_time_sliced(self._level, self._level_spawn_time_budget)

	if done then
		local world, level = nil
		self._world = world
		world = self._world
		self._level = level
		level = self._level

		return done, world, level
	end

	return done
end

AsyncLevelSpawner.setup_world = function (world_name, parameters)
	local flags = {
		Application.ENABLE_MOC,
		Application.ENABLE_VOLUMETRICS,
		Application.ENABLE_RAY_TRACING
	}
	local world_manager = Managers.world
	local world = world_manager:create_world(world_name, parameters, unpack(flags))

	return world
end

AsyncLevelSpawner.level_name = function (self)
	return self._level_name
end

return AsyncLevelSpawner
