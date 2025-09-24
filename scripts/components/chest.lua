-- chunkname: @scripts/components/chest.lua

local Chest = component("Chest")

Chest.init = function (self, unit)
	local chest_extension = ScriptUnit.fetch_component_extension(unit, "chest_system")

	if chest_extension then
		local locked = self:get_data(unit, "locked")
		local interaction_delay = self:get_data(unit, "interaction_delay")

		chest_extension:setup_from_component(locked, interaction_delay)

		self._chest_extension = chest_extension
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

Chest.chest_lock = function (self, unit)
	local chest_extension = self._chest_extension

	if chest_extension then
		chest_extension:lock()
	end
end

Chest.chest_unlock = function (self, unit)
	local chest_extension = self._chest_extension

	if chest_extension then
		chest_extension:unlock()
	end
end

Chest.component_data = {
	interaction_delay = {
		ui_name = "Interaction delay (in sec.)",
		ui_type = "number",
		value = 0.5,
	},
	locked = {
		ui_name = "Locked",
		ui_type = "check_box",
		value = false,
	},
	inputs = {
		chest_lock = {
			accessibility = "public",
			type = "event",
		},
		chest_unlock = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"ChestExtension",
	},
}

return Chest
