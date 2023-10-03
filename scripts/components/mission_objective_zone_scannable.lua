local MissionObjectiveZoneScannable = component("MissionObjectiveZoneScannable")

MissionObjectiveZoneScannable.init = function (self, unit)
	return
end

MissionObjectiveZoneScannable.editor_validate = function (self, unit)
	return true, ""
end

MissionObjectiveZoneScannable.enable = function (self, unit)
	return
end

MissionObjectiveZoneScannable.disable = function (self, unit)
	return
end

MissionObjectiveZoneScannable.destroy = function (self, unit)
	return
end

MissionObjectiveZoneScannable.component_data = {
	extensions = {
		"MissionObjectiveZoneScannableExtension"
	}
}

return MissionObjectiveZoneScannable
