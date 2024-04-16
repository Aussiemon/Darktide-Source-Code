local SmartTagTarget = component("SmartTagTarget")

SmartTagTarget.init = function (self, unit)
	self:enable(unit)

	local smart_tag_extension = ScriptUnit.fetch_component_extension(unit, "smart_tag_system")

	if smart_tag_extension then
		local target_type = self:get_data(unit, "target_type")

		smart_tag_extension:setup_from_component(target_type)
	end
end

SmartTagTarget.editor_init = function (self, unit)
	self:enable(unit)
end

SmartTagTarget.editor_validate = function (self, unit)
	return true, ""
end

SmartTagTarget.enable = function (self, unit)
	return
end

SmartTagTarget.disable = function (self, unit)
	return
end

SmartTagTarget.destroy = function (self, unit)
	return
end

SmartTagTarget.component_data = {
	target_type = {
		value = "health_station",
		ui_type = "combo_box",
		ui_name = "Target Type",
		options_keys = {
			"health_station",
			"pickup"
		},
		options_values = {
			"health_station",
			"pickup"
		}
	},
	extensions = {
		"SmartTagExtension"
	}
}

return SmartTagTarget
