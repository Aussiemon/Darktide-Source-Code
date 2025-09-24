-- chunkname: @scripts/components/wwise_room_volume.lua

local WwiseRoomVolume = component("WwiseRoomVolume")

WwiseRoomVolume.init = function (self, unit)
	self._wwise_world = Wwise.wwise_world(Unit.world(unit))
	self._added = false

	if not Unit.has_volume(unit, "room_volume") then
		return false
	end

	local rooms_and_portals_manager = Managers and Managers.state and Managers.state.rooms_and_portals

	if rooms_and_portals_manager then
		self._added = true

		rooms_and_portals_manager:register_room(self)

		return true
	end

	return false
end

WwiseRoomVolume.destroy = function (self, unit)
	local rooms_and_portals_manager = Managers and Managers.state and Managers.state.rooms_and_portals

	if rooms_and_portals_manager and self._added then
		Managers.state.rooms_and_portals:remove_room(self)
	end
end

WwiseRoomVolume.enable = function (self, unit)
	return
end

WwiseRoomVolume.disable = function (self, unit)
	return
end

WwiseRoomVolume.editor_init = function (self, unit)
	return
end

WwiseRoomVolume.editor_destroy = function (self, unit)
	return
end

WwiseRoomVolume.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "room_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'room_volume'"
	end

	return success, error_message
end

WwiseRoomVolume.component_data = {
	priority = {
		decimals = 0,
		max = 1024,
		min = 1,
		step = 1,
		ui_name = "Priority",
		ui_type = "number",
		value = 1,
	},
	wall_occlusion = {
		decimals = 2,
		max = 1,
		min = 0,
		step = 1,
		ui_name = "Wall Occlusion",
		ui_type = "number",
		value = 1,
	},
	aux_send_to_self = {
		decimals = 2,
		max = 1,
		min = 0,
		step = 1,
		ui_name = "Aux send to self",
		ui_type = "number",
		value = 0.25,
	},
	reverb_aux_bus = {
		ui_name = "Reverb aux bus",
		ui_type = "combo_box",
		value = "indoor_medium_3d",
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
			"indoor_small_hallway_3d",
			"outside_huge_canyon_3d",
		},
	},
	ambient_event = {
		filter = "wwise_event",
		preview = true,
		thumbnails = false,
		ui_name = "Ambient event",
		ui_type = "resource",
		value = "",
	},
	environment_state = {
		ui_name = "Environment state",
		ui_type = "combo_box",
		value = "indoor_medium",
		options = {
			"indoor_huge",
			"indoor_large",
			"indoor_medium",
			"indoor_small",
			"indoor_tiny",
			"urban_large",
			"urban_medium",
			"urban_small",
		},
	},
}

return WwiseRoomVolume
