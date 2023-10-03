local Chest = component("Chest")

Chest.init = function (self, unit)
	local chest_extension = ScriptUnit.fetch_component_extension(unit, "chest_system")

	if chest_extension then
		local locked = self:get_data(unit, "locked")

		chest_extension:setup_from_component(locked)
	end
end

Chest.editor_init = function (self, unit)
	return
end

Chest.editor_validate = function (self, unit)
	return true, ""
end

Chest.enable = function (self, unit)
	return
end

Chest.disable = function (self, unit)
	return
end

Chest.destroy = function (self, unit)
	return
end

Chest.component_data = {
	locked = {
		ui_type = "check_box",
		value = false,
		ui_name = "Locked"
	},
	extensions = {
		"ChestExtension"
	}
}

return Chest
