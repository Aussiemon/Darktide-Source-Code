local CinematicScene = component("CinematicScene")

CinematicScene.init = function (self, unit)
	self:enable(unit)

	local cinematic_name = self:get_data(unit, "cinematic_name")
	local cinematic_category = self:get_data(unit, "cinematic_category")
	self._origin_level_name = self:get_data(unit, "origin_level_name")
	self._unit_type = self:get_data(unit, "unit_type")
	self._cinematic_name = self:get_data(unit, "cinematic_name")
	self._cinematic_category = cinematic_category
	local origin_level_name = nil

	if self._unit_type == "destination" and self._origin_level_name ~= "" then
		origin_level_name = self._origin_level_name
	end

	local cinematic_scene_extension = ScriptUnit.extension(unit, "cinematic_scene_system")

	cinematic_scene_extension:setup_from_component(cinematic_name, cinematic_category, origin_level_name)

	self._cinematic_scene_extension = cinematic_scene_extension
end

CinematicScene.enable = function (self, unit)
	return
end

CinematicScene.disable = function (self, unit)
	return
end

CinematicScene.destroy = function (self, unit)
	return
end

CinematicScene.editor_init = function (self, unit)
	return
end

CinematicScene.editor_destroy = function (self, unit)
	return
end

CinematicScene.unit_type = function (self)
	return self._unit_type
end

CinematicScene.cinematic_category = function (self)
	return self._cinematic_category
end

CinematicScene.cinematic_name = function (self)
	return self._cinematic_name
end

CinematicScene.origin_level_name = function (self)
	if self._unit_type == "destination" and self._origin_level_name ~= "" then
		return self._origin_level_name
	end

	return nil
end

CinematicScene.play_cutscene = function (self)
	local cinematic_scene_extension = self._cinematic_scene_extension

	cinematic_scene_extension:play_cutscene()
end

CinematicScene.component_data = {
	name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Name:"
	},
	unit_type = {
		value = "origin",
		ui_type = "combo_box",
		ui_name = "Type",
		options_keys = {
			"Origin",
			"Destination"
		},
		options_values = {
			"origin",
			"destination"
		}
	},
	cinematic_name = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Cinematic Name",
		options_keys = {
			"None",
			"Intro ABC",
			"Outro Win",
			"Outro Fail",
			"Cutscene 01",
			"Cutscene 02",
			"Cutscene 03",
			"Cutscene 04",
			"Cutscene 05",
			"Cutscene 05 Hub",
			"Cutscene 6",
			"Cutscene 7",
			"Cutscene 8",
			"Cutscene 9",
			"Cutscene 10",
			"Path of Trust 01",
			"Path of Trust 02",
			"Path of Trust 03",
			"Path of Trust 04",
			"Path of Trust 05",
			"Path of Trust 06",
			"Path of Trust 07",
			"Path of Trust 08",
			"Path of Trust 09",
			"Traitor Captain Intro"
		},
		options_values = {
			"none",
			"intro_abc",
			"outro_win",
			"outro_fail",
			"cutscene_1",
			"cutscene_2",
			"cutscene_3",
			"cutscene_4",
			"cutscene_5",
			"cutscene_5_hub",
			"cutscene_6",
			"cutscene_7",
			"cutscene_8",
			"cutscene_9",
			"cutscene_10",
			"path_of_trust_01",
			"path_of_trust_02",
			"path_of_trust_03",
			"path_of_trust_04",
			"path_of_trust_05",
			"path_of_trust_06",
			"path_of_trust_07",
			"path_of_trust_08",
			"path_of_trust_09",
			"traitor_captain_intro"
		}
	},
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
			"Traitor Captain Intro"
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
			"traitor_captain_intro"
		}
	},
	origin_level_name = {
		ui_type = "text_box",
		validator = "ContentPathsAllowed",
		category = "Level",
		value = "",
		ui_name = "Origin Level Name"
	},
	inputs = {
		play_cutscene = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"CinematicSceneExtension"
	}
}

return CinematicScene
