local SplineGroup = component("SplineGroup")

SplineGroup.init = function (self, unit)
	local spline_group_extension = ScriptUnit.fetch_component_extension(unit, "spline_group_system")

	if spline_group_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local spline_names = self:get_data(unit, "spline_names")

		spline_group_extension:setup_from_component(objective_name, spline_names)
	end
end

SplineGroup.editor_init = function (self, unit)
	return
end

SplineGroup.enable = function (self, unit)
	return
end

SplineGroup.disable = function (self, unit)
	return
end

SplineGroup.destroy = function (self, unit)
	return
end

SplineGroup.component_data = {
	objective_name = {
		ui_type = "text_box",
		value = "None",
		ui_name = "Objective Name"
	},
	spline_names = {
		ui_type = "text_box_array",
		ui_name = "Spline Name",
		values = {}
	},
	extensions = {
		"SplineGroupExtension"
	}
}

return SplineGroup
