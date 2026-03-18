-- chunkname: @scripts/loading/async_expedition_level_spawner.lua

local ScriptWorld = require("scripts/foundation/utilities/script_world")
local AsyncExpeditionLevelSpawner = class("AsyncExpeditionLevelSpawner")

AsyncExpeditionLevelSpawner.init = function (self, world, level_name, position, rotation, frame_time_budget, included_object_sets, excluded_object_sets)
	self._level_name = level_name
	self._world = world
	self._level_spawn_time_budget = frame_time_budget
	position = position or Vector3.zero()
	rotation = rotation or Quaternion.identity()

	local scale = Vector3(1, 1, 1)
	local ignore_level_background = false
	local spawn_units = false
	local level = World.spawn_level_time_sliced(world, level_name, position, rotation, scale, included_object_sets, excluded_object_sets)

	Level.set_data(level, "runtime_loaded_level", true)

	self._level = level
end

AsyncExpeditionLevelSpawner.destroy = function (self)
	if self._level then
		World.destroy_level(self._world, self._level)

		self._level = nil
	end
end

AsyncExpeditionLevelSpawner.update = function (self)
	local level_spawn_time_budget = self._level_spawn_time_budget
	local done = Level.update_spawn_time_sliced(self._level, level_spawn_time_budget)

	if done then
		local world, level

		world, self._world = self._world, world
		level, self._level = self._level, level

		return done, world, level
	end

	return done
end

AsyncExpeditionLevelSpawner.level_name = function (self)
	return self._level_name
end

return AsyncExpeditionLevelSpawner
