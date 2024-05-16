-- chunkname: @scripts/ui/hud/elements/beacon/hud_element_beacon.lua

local HudElementBeaconSettings = require("scripts/ui/hud/elements/beacon/hud_element_beacon_settings")
local HudElementBeacon = class("HudElementBeacon")

HudElementBeacon.init = function (self, parent, draw_layer, start_scale, definitions)
	self._parent = parent
	self._marked_beacon_unit = nil
	self._beacon_marker_id = nil
	self._respawn_beacon_system = Managers.state.extension:system("respawn_beacon_system")
	self._scan_delay = HudElementBeaconSettings.scan_delay
	self._scan_delay_duration = 0
end

HudElementBeacon.update = function (self, dt, t)
	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_beacon_extension_scan()

		self._scan_delay_duration = self._scan_delay
	end
end

HudElementBeacon._beacon_extension_scan = function (self)
	local marked_beacon_unit = self._respawn_beacon_system:marked_beacon_unit()

	if self._marked_beacon_unit ~= marked_beacon_unit then
		local event_manager = Managers.event
		local current_marker_id = self._beacon_marker_id

		if current_marker_id then
			event_manager:trigger("remove_world_marker", current_marker_id)
		end

		local marker_callback = callback(self, "_on_beacon_marker_spawned", marked_beacon_unit)
		local marker_type = "beacon"

		event_manager:trigger("add_world_marker_unit", marker_type, marked_beacon_unit, marker_callback)

		self._marked_beacon_unit = marked_beacon_unit
	end
end

HudElementBeacon._on_beacon_marker_spawned = function (self, unit, id)
	self._beacon_marker_id = id
end

HudElementBeacon.destroy = function (self)
	local event_manager = Managers.event
	local marker_id = self._beacon_marker_id

	if marker_id then
		event_manager:trigger("remove_world_marker", marker_id)
	end

	self._marked_beacon_unit = nil
end

return HudElementBeacon
