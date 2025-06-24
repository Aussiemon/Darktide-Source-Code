-- chunkname: @scripts/components/area_buff_drone.lua

local RESOURCES = {
	vfx = {},
	sfx = {
		idle_loop = {
			start = "wwise/events/player/play_buff_drone_engine_loop",
			stop = "wwise/events/player/stop_buff_drone_engine_loop",
		},
		deployed_loop = {
			start = "wwise/events/player/play_buff_drone_buff_loop",
			stop = "wwise/events/player/stop_buff_drone_buff_loop",
		},
	},
}
local CENTER_NODE_NAME = "fx_center"
local AreaBuffDrone = component("AreaBuffDrone")

AreaBuffDrone.init = function (self, unit)
	self._unit = unit
	self._has_setup = false
end

AreaBuffDrone.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

AreaBuffDrone.enable = function (self, unit)
	return
end

AreaBuffDrone.disable = function (self, unit)
	return
end

AreaBuffDrone.destroy = function (self, unit)
	if not self._has_setup then
		return
	end

	local source_id = self._source_id

	if self._source_id ~= nil and not WwiseWorld.has_source(self._wwise_world, source_id) then
		source_id = nil
	end

	if self._arming_playing_id then
		self:_stop_looping_sound(source_id, self._arming_playing_id, RESOURCES.sfx.idle_loop.stop)

		self._arming_playing_id = nil
	end

	if self._idle_playing_id then
		self:_stop_looping_sound(source_id, self._idle_playing_id, RESOURCES.sfx.deployed_loop.stop)

		self._idle_playing_id = nil
	end

	if source_id then
		WwiseWorld.destroy_manual_source(self._wwise_world, source_id)

		self._source_id = nil
	end
end

AreaBuffDrone.update = function (self, unit, dt, t)
	return
end

AreaBuffDrone._setup = function (self)
	if self._has_setup then
		return
	end

	local unit = self._unit
	local world = Unit.world(unit)
	local wwise_world = Wwise.wwise_world(world)

	self._world = world
	self._wwise_world = wwise_world

	local source_id = WwiseWorld.make_manual_source(wwise_world, unit, Unit.node(unit, CENTER_NODE_NAME))

	self._source_id = source_id
	self._has_setup = true
end

AreaBuffDrone._set_active = function (self)
	self:_setup()

	if not self._arming_playing_id then
		local playing_id = self:_start_looping_sound(self._source_id, RESOURCES.sfx.idle_loop.start)

		self._arming_playing_id = playing_id
	end

	Unit.animation_event(self._unit, "hover_fwd")
end

AreaBuffDrone._deploy = function (self)
	self:_setup()

	local source_id = self._source_id

	if self._arming_playing_id then
		self:_stop_looping_sound(source_id, self._arming_playing_id, RESOURCES.sfx.idle_loop.stop)

		self._arming_playing_id = nil
	end

	local unit = self._unit

	Unit.animation_event(unit, "idle")

	local playing_id = self:_start_looping_sound(source_id, RESOURCES.sfx.deployed_loop.start)

	self._idle_playing_id = playing_id
end

AreaBuffDrone._start_looping_sound = function (self, source_id, event_name)
	local playing_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name, source_id)

	return playing_id
end

AreaBuffDrone._stop_looping_sound = function (self, source_id, playing_id, event_name)
	local wwise_world = self._wwise_world

	if event_name and source_id and WwiseWorld.has_source(wwise_world, source_id) then
		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif playing_id then
		WwiseWorld.stop_event(wwise_world, playing_id)
	end
end

AreaBuffDrone._stop_idle_vfx_loop = function (self)
	local world = self._world
	local idle_particle_ids = self._idle_particle_ids

	if self._idle_particle_ids then
		for ii = 1, #idle_particle_ids do
			World.destroy_particles(world, idle_particle_ids[ii])
		end

		table.clear(idle_particle_ids)
	end
end

AreaBuffDrone.events.area_buff_drone_set_active = function (self)
	self:_set_active()
end

AreaBuffDrone.events.area_buff_drone_deploy = function (self)
	self:_deploy()
end

AreaBuffDrone.component_data = {}

return AreaBuffDrone
