-- chunkname: @scripts/components/cutscene_camera.lua

local CutsceneCamera = component("CutsceneCamera")

CutsceneCamera.init = function (self, unit)
	self._data = {}
	self._data.dof_enabled = math.ceil(Unit.local_position(unit, Unit.node(unit, "Enabled")).y)
	self._data.focal_distance = Unit.local_position(unit, Unit.node(unit, "Distance")).y
	self._data.focal_region = Unit.local_position(unit, Unit.node(unit, "Region")).y
	self._data.focal_padding = Unit.local_position(unit, Unit.node(unit, "Padding")).y
	self._data.focal_scale = Unit.local_position(unit, Unit.node(unit, "Scale")).y

	if rawget(_G, "LevelEditor") and Unit.has_data(unit, "dof_planes") and not Unit.get_data(unit, "dof_planes") then
		Unit.set_visibility(unit, "dof_planes", false)
	end

	Unit.set_data(unit, "dof_data", self._data)

	self._cinematic_category = self:get_data(unit, "cinematic_category")
end

CutsceneCamera.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if not Unit.has_node(unit, "Enabled") then
		error_message = error_message .. "\nmissing unit node 'Enabled'"
		success = false
	end

	if not Unit.has_node(unit, "Distance") then
		error_message = error_message .. "\nmissing unit node 'Distance'"
		success = false
	end

	if not Unit.has_node(unit, "Region") then
		error_message = error_message .. "\nmissing unit node 'Region'"
		success = false
	end

	if not Unit.has_node(unit, "Padding") then
		error_message = error_message .. "\nmissing unit node 'Padding'"
		success = false
	end

	if not Unit.has_node(unit, "Scale") then
		error_message = error_message .. "\nmissing unit node 'Scale'"
		success = false
	end

	return success, error_message
end

CutsceneCamera.editor_world_transform_modified = function (self, unit)
	local dof_enabled = math.ceil(Unit.local_position(unit, Unit.node(unit, "Enabled")).y)

	if dof_enabled ~= self._data.dof_enabled or dof_enabled > 0 then
		self._data.dof_enabled = math.ceil(Unit.local_position(unit, Unit.node(unit, "Enabled")).y)
		self._data.focal_distance = Unit.local_position(unit, Unit.node(unit, "Distance")).y
		self._data.focal_region = Unit.local_position(unit, Unit.node(unit, "Region")).y
		self._data.focal_padding = Unit.local_position(unit, Unit.node(unit, "Padding")).y
		self._data.focal_scale = Unit.local_position(unit, Unit.node(unit, "Scale")).y

		Unit.set_data(unit, "dof_data", self._data)
	end
end

CutsceneCamera.enable = function (self, unit)
	return
end

CutsceneCamera.disable = function (self, unit)
	return
end

CutsceneCamera.destroy = function (self, unit)
	return
end

CutsceneCamera.cinematic_category = function (self)
	return self._cinematic_category
end

CutsceneCamera.component_data = {
	cinematic_category = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Cinematic Category",
		options_keys = {
			"None",
			"Camera A",
			"Camera B",
			"Camera C",
			"Outro Win",
			"Outro Fail",
			"Cutscene Intro",
			"Cutscene 02, PART 1",
			"Cutscene 02, PART 2",
			"Cutscene 02, PART 3",
			"Cutscene 03",
			"Cutscene 04",
			"Cutscene 05",
			"Cutscene 05 Exterior",
			"Cutscene 05 Hub",
			"Cutscene 06",
			"Cutscene 07",
			"Cutscene 08",
			"Cutscene 09",
			"Cutscene 10",
			"Path of Trust 01 Part 01",
			"Path of Trust 01 Corridor 01",
			"Path of Trust 01 Part 02",
			"Path of Trust 02 Part 01",
			"Path of Trust 02 Barracks",
			"Path of Trust 02 Part 02",
			"Path of Trust 03 Part 01",
			"Path of Trust 03 Crafting Station",
			"Path of Trust 03 Part 02",
			"Path of Trust 04 Part 01",
			"Path of Trust 04 Corridor 02",
			"Path of Trust 04 Part 02",
			"Path of Trust 05 Part 01",
			"Path of Trust 05 Bar",
			"Path of Trust 05 Part 02",
			"Path of Trust 06 Hangar",
			"Path of Trust 07 Part 01",
			"Path of Trust 07 Barracks",
			"Path of Trust 07 Part 02",
			"Path of Trust 08 Part 01",
			"Path of Trust 08 Corridor 01",
			"Path of Trust 08 Part 02",
			"Path of Trust 09 Office",
			"Traitor Captain Intro",
			"Hub Location Intro Barber",
			"Hub Location Intro Mission Board Part 01",
			"Hub Location Intro Mission Board Part 02",
			"Hub Location Intro Training Grounds",
			"Hub Location Intro Contracts",
			"Hub Location Intro Crafting",
			"Hub Location Intro Gun Shop"
		},
		options_values = {
			"none",
			"a_cam",
			"b_cam",
			"c_cam",
			"outro_win",
			"outro_fail",
			"cs_intro",
			"cs_02_part_1",
			"cs_02_part_2",
			"cs_02_part_3",
			"cs_03",
			"cs_04",
			"cs_05",
			"cs_05_exterior",
			"cs_05_hub",
			"cs_06",
			"cs_07",
			"cs_08",
			"cs_09",
			"cs_10",
			"path_of_trust_01_part_01",
			"path_of_trust_01_corridor_01",
			"path_of_trust_01_part_02",
			"path_of_trust_02_part_01",
			"path_of_trust_02_barracks",
			"path_of_trust_02_part_02",
			"path_of_trust_03_part_01",
			"path_of_trust_03_crafting_station",
			"path_of_trust_03_part_02",
			"path_of_trust_04_part_01",
			"path_of_trust_04_corridor_02",
			"path_of_trust_04_part_02",
			"path_of_trust_05_part_01",
			"path_of_trust_05_bar",
			"path_of_trust_05_part_02",
			"path_of_trust_06_hangar",
			"path_of_trust_07_part_01",
			"path_of_trust_07_barracks",
			"path_of_trust_07_part_02",
			"path_of_trust_08_part_01",
			"path_of_trust_08_corridor_01",
			"path_of_trust_08_part_02",
			"path_of_trust_09_office",
			"traitor_captain_intro",
			"hub_location_intro_barber",
			"hub_location_intro_mission_board_part_01",
			"hub_location_intro_mission_board_part_02",
			"hub_location_intro_training_grounds",
			"hub_location_intro_contracts",
			"hub_location_intro_crafting",
			"hub_location_intro_gun_shop"
		}
	}
}

return CutsceneCamera
