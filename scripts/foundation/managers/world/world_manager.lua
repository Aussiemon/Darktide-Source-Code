local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldManager = class("WorldManager")

WorldManager.init = function (self)
	self._worlds = {}
	self._disabled_worlds = {}
	self._update_queue = {}
	self._anim_update_callbacks = {}
	self._scene_update_callbacks = {}
	self._queued_worlds_to_release = {}
	self._wwise_worlds = {}
	self._dlss_reset_by_world = {}
	self._scale = 1
end

WorldManager.create_world = function (self, name, parameters, ...)
	Profiler.start("create_world")
	fassert(self._worlds[name] == nil, "World %q already exists", name)

	local has_physics_world = true
	local n_varargs = select("#", ...)

	for i = 1, n_varargs do
		if select(i, ...) == Application.DISABLE_PHYSICS then
			has_physics_world = false
		end
	end

	local world = Application.new_world(name, ...)

	World.set_data(world, "name", name)
	World.set_data(world, "layer", parameters.layer or 1)
	World.set_data(world, "active", true)
	World.set_data(world, "has_physics_world", has_physics_world)
	World.set_data(world, "timer_name", parameters.timer_name)
	World.set_data(world, "levels", {})
	World.set_data(world, "spawned_level_count", 0)
	World.set_data(world, "viewports", {})
	World.set_data(world, "free_flight_viewports", {})
	World.set_data(world, "render_queue", {})

	self._worlds[name] = world
	self._wwise_worlds[world] = Wwise.wwise_world(world)

	self:_sort_update_queue()
	Profiler.stop("create_world")

	return world
end

WorldManager.set_world_layer = function (self, world_name, layer)
	local world = self:world(world_name)

	World.set_data(world, "layer", layer or 1)
	self:_sort_update_queue()
end

WorldManager.wwise_world = function (self, world)
	return self._wwise_worlds[world]
end

WorldManager.destroy_world = function (self, world_or_name)
	if self.locked then
		self._queued_worlds_to_release[world_or_name] = true

		return
	end

	local name = nil

	if type(world_or_name) == "string" then
		name = world_or_name
	else
		name = World.get_data(world_or_name, "name")
	end

	local world = self._worlds[name]

	if world == nil then
		world = self._disabled_worlds[name]
	end

	assert(world, "World %q doesn't exist", name)

	local free_overlaps = PhysicsWorld.free_overlaps

	if free_overlaps and World.get_data(world, "has_physics_world") then
		local physics_world = World.physics_world(world)

		free_overlaps(physics_world)
	end

	Application.release_world(world)

	self._worlds[name] = nil
	self._disabled_worlds[name] = nil
	self._anim_update_callbacks[world] = nil
	self._scene_update_callbacks[world] = nil
	self._wwise_worlds[world] = nil

	self:_sort_update_queue()
end

WorldManager.world_name = function (self, world)
	local world_name = table.find(self._worlds, world)
	world_name = world_name or table.find(self._disabled_worlds, world)

	fassert(world_name, "World %s hasn't been registered", tostring(world))

	return world_name
end

WorldManager.has_world = function (self, name)
	return self._worlds[name] ~= nil or self._disabled_worlds[name] ~= nil
end

WorldManager.world = function (self, name)
	local world = self._worlds[name] or self._disabled_worlds[name]

	fassert(world, "World %q doesn't exist", name)

	return world
end

WorldManager.is_world_enabled = function (self, name)
	if self._worlds[name] then
		return true
	elseif self._disabled_worlds[name] then
		return false
	end

	fassert(false, "World %q doesn't exist", name)
end

WorldManager.update = function (self, dt, t)
	self.locked = true
	local time_manager = Managers.time
	local update_queue = self._update_queue

	for i = 1, #update_queue do
		local world = update_queue[i]
		local timer_name = World.get_data(world, "timer_name")

		if timer_name then
			local has_timer = time_manager:has_timer(timer_name)

			if has_timer then
				local delta_time = time_manager:delta_time(timer_name)
				delta_time = delta_time * self._scale

				ScriptWorld.update(world, delta_time, self._anim_update_callbacks[world], self._scene_update_callbacks[world])
			else
				ScriptWorld.update(world, 0, self._anim_update_callbacks[world], self._scene_update_callbacks[world])
			end
		else
			dt = dt * self._scale

			ScriptWorld.update(world, dt, self._anim_update_callbacks[world], self._scene_update_callbacks[world])
		end
	end

	self.locked = false

	for world_or_name, _ in pairs(self._queued_worlds_to_release) do
		self:destroy_world(world_or_name)

		self._queued_worlds_to_release[world_or_name] = nil
	end
end

WorldManager.set_world_update_time_scale = function (self, scale)
	fassert(not Managers.state.game_session:is_server(), "Client only function")
	fassert(scale == 1 or Managers.state.cinematic:is_playing(), "Only allowed change while cinematic playing")

	self._scale = scale
end

WorldManager.render = function (self)
	local dlss_reset_by_world = self._dlss_reset_by_world
	local update_queue = self._update_queue
	local ScriptWorld_render = ScriptWorld.render

	for i = 1, #update_queue do
		local world = update_queue[i]

		if dlss_reset_by_world[world] then
			dlss_reset_by_world[world] = nil

			Application.reset_dlss()
		end

		ScriptWorld_render(world)
	end
end

WorldManager.world_reset_dlss = function (self, world_name)
	local world = self:world(world_name)
	self._dlss_reset_by_world[world] = true
end

WorldManager.enable_world = function (self, name, enabled)
	if enabled then
		local world = self._disabled_worlds[name]

		assert(world, "Tried to enable world %q that wasn't disabled", name)

		self._worlds[name] = world
		self._disabled_worlds[name] = nil
	else
		local world = self._worlds[name]

		assert(world, "Tried to disable world %q that wasn't enabled", name)

		self._disabled_worlds[name] = world
		self._worlds[name] = nil
	end

	self:_sort_update_queue()
end

WorldManager.destroy = function (self)
	for name, _ in pairs(self._worlds) do
		self:destroy_world(name)
	end

	for name, _ in pairs(self._disabled_worlds) do
		self:destroy_world(name)
	end
end

WorldManager._sort_update_queue = function (self)
	self._update_queue = {}

	for name, world in pairs(self._worlds) do
		self._update_queue[#self._update_queue + 1] = world
	end

	local function comparator(w1, w2)
		return World.get_data(w1, "layer") < World.get_data(w2, "layer")
	end

	table.sort(self._update_queue, comparator)
end

WorldManager.set_anim_update_callback = function (self, world, callback)
	self._anim_update_callbacks[world] = callback
end

WorldManager.set_scene_update_callback = function (self, world, callback)
	self._scene_update_callbacks[world] = callback
end

return WorldManager
