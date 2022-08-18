local WwiseRoomVolume = component("WwiseRoomVolume")

WwiseRoomVolume.init = function (self, unit)
	self._unit = unit
	self._wwise_world = Wwise.wwise_world(Unit.world(unit))
	self._room_id = -1

	if Unit.has_volume(unit, "room_volume") == false then
		return false
	end

	if Managers then
		Managers.state.rooms_and_portals:register_room(self)
	end

	return true
end

WwiseRoomVolume.editor_init = function (self, unit)
	self._unit = unit
	self._wwise_world = Wwise.wwise_world(Unit.world(unit))
	self._room_id = -1

	if Unit.has_volume(unit, "room_volume") == false then
		return false
	end

	if Managers then
		Managers.state.rooms_and_portals:register_room(self)
	end
end

WwiseRoomVolume.enable = function (self, unit)
	return
end

WwiseRoomVolume.get_unit = function (self)
	return self._unit
end

WwiseRoomVolume.disable = function (self, unit)
	return
end

WwiseRoomVolume.destroy = function (self, unit)
	if Managers then
		Managers.state.rooms_and_portals:remove_room(self)
	end
end

WwiseRoomVolume.component_data = {
	priority = {
		ui_type = "number",
		min = 1,
		step = 1,
		decimals = 0,
		value = 1,
		ui_name = "Priority",
		max = 1024
	},
	wall_occlusion = {
		ui_type = "number",
		min = 0,
		step = 1,
		decimals = 2,
		value = 1,
		ui_name = "Wall Occlusion",
		max = 1
	},
	aux_send_to_self = {
		ui_type = "number",
		min = 0,
		step = 1,
		decimals = 2,
		value = 0.25,
		ui_name = "Aux send to self",
		max = 1
	},
	reverb_aux_bus = {
		ui_type = "combo_box",
		value = "indoor_medium_3d",
		ui_name = "Reverb aux bus",
		options = {
			"indoor_large_3d",
			"indoor_medium_3d",
			"indoor_small_3d",
			"indoor_tiny_3d",
			"urban_large_3d",
			"urban_medium_3d",
			"urban_small_3d",
			"indoor_small_tunnel_3d",
			"indoor_large_echo_3d",
			"indoor_medium_hallway_3d",
			"indoor_huge_cylinder_3d",
			"indoor_small_hallway_3d"
		}
	},
	ambient_event = {
		ui_type = "resource",
		preview = true,
		thumbnails = false,
		value = "",
		ui_name = "Ambient event",
		filter = "wwise_event"
	},
	environment_state = {
		ui_type = "combo_box",
		value = "indoor_medium",
		ui_name = "Environment state",
		options = {
			"indoor_huge",
			"indoor_large",
			"indoor_medium",
			"indoor_small",
			"indoor_tiny",
			"urban_large",
			"urban_medium",
			"urban_small"
		}
	}
}

return WwiseRoomVolume
