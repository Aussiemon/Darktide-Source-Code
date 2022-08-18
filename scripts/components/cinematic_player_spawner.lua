local CinematicPlayerSpawner = component("CinematicPlayerSpawner")

CinematicPlayerSpawner.init = function (self, unit)
	self:enable(unit)

	self._cinematic_name = self:get_data(unit, "cinematic_name")
end

CinematicPlayerSpawner.editor_init = function (self, unit)
	self:enable(unit)
end

CinematicPlayerSpawner.enable = function (self, unit)
	return
end

CinematicPlayerSpawner.disable = function (self, unit)
	return
end

CinematicPlayerSpawner.destroy = function (self, unit)
	return
end

CinematicPlayerSpawner.cinematic_name = function (self)
	return self._cinematic_name
end

CinematicPlayerSpawner.component_data = {
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
			"Path of Trust 10",
			"Path of Trust 11",
			"Path of Trust 12",
			"Path of Trust 13",
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
			"path_of_trust_10",
			"path_of_trust_11",
			"path_of_trust_12",
			"path_of_trust_13",
			"traitor_captain_intro"
		}
	}
}

return CinematicPlayerSpawner
