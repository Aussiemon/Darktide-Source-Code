local Component = require("scripts/utilities/component")
local RoomsAndPortalsManager = class("RoomsAndPortalsManager")

RoomsAndPortalsManager.init = function (self, world)
	self._wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.init_rooms(self._wwise_world)

	self._rooms = {}
	self._portals = {}
	self._is_connected = false
	self._portal_toggle_queue = {}
end

RoomsAndPortalsManager.update = function (self, dt, t)
	if not self._is_connected then
		local any_room_added = false

		for room, _ in pairs(self._rooms) do
			local unit = room:get_unit()
			local priority = room:get_data(unit, "priority")
			local wall_occlusion = room:get_data(unit, "wall_occlusion")
			local aux_send_to_self = 0
			local reverb_aux_bus = room:get_data(unit, "reverb_aux_bus")
			local environment_state = room:get_data(unit, "environment_state")
			local room_id = WwiseWorld.add_room_unit(self._wwise_world, unit, priority, wall_occlusion, aux_send_to_self, reverb_aux_bus, environment_state)
			self._rooms[room] = room_id
			local ambient_event = room:get_data(unit, "ambient_event")

			if ambient_event ~= "" then
				WwiseWorld.trigger_room_resource_event(self._wwise_world, ambient_event, room_id)
			end

			any_room_added = true
		end

		for portal, _ in pairs(self._portals) do
			local portal_unit = portal:get_unit()
			local portal_id = WwiseWorld.add_portal_unit(self._wwise_world, portal_unit)

			if self:_check_portal_id(portal_id) then
				self._portals[portal] = portal_id

				Component.event(portal_unit, "portal_added")
			else
				self._portals[portal] = nil
			end
		end

		self._is_connected = any_room_added
	elseif #self._portal_toggle_queue > 0 then
		for _, portal_info in ipairs(self._portal_toggle_queue) do
			local portal = portal_info.wwise_portal_component
			local enabled = portal_info.enabled

			self:toggle_portal(portal, enabled)
		end

		table.clear(self._portal_toggle_queue)
	end
end

RoomsAndPortalsManager.register_room = function (self, room)
	self._rooms[room] = -1
end

RoomsAndPortalsManager.remove_room = function (self, room)
	local room_id = self._rooms[room]

	if room_id >= 0 then
		WwiseWorld.remove_room_unit(self._wwise_world, room_id)
	end

	self._rooms[room] = nil
end

RoomsAndPortalsManager.register_portal = function (self, portal)
	self._portals[portal] = -1
end

RoomsAndPortalsManager.remove_portal = function (self, portal)
	local portal_id = self._portals[portal]

	if self:_check_portal_id(portal_id) then
		WwiseWorld.remove_portal_unit(self._wwise_world, portal_id)

		self._portals[portal] = -1
	end
end

RoomsAndPortalsManager.toggle_portal = function (self, portal, enabled)
	if self._is_connected then
		local portal_id = self._portals[portal]

		if self:_check_portal_id(portal_id) then
			WwiseWorld.toggle_portal_unit(self._wwise_world, portal_id, enabled)
		end
	else
		self._portal_toggle_queue[#self._portal_toggle_queue + 1] = {
			wwise_portal_component = portal,
			enabled = enabled
		}
	end
end

RoomsAndPortalsManager.set_portal_obstruction_and_occlusion = function (self, portal, obstruction, occlusion)
	if self._is_connected then
		local portal_id = self._portals[portal]

		if self:_check_portal_id(portal_id) then
			WwiseWorld.set_portal_obstruction_and_occlusion(self._wwise_world, portal_id, obstruction, occlusion)
		end
	end
end

RoomsAndPortalsManager.destroy = function (self)
	self:_cleanup()
end

RoomsAndPortalsManager._cleanup = function (self)
	return
end

RoomsAndPortalsManager._check_portal_id = function (self, portal_id)
	local INT32_MAX = 4294967295.0

	if portal_id == nil or portal_id == -1 or portal_id == INT32_MAX then
		return false
	end

	return true
end

return RoomsAndPortalsManager
