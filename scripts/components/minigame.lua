local Minigame = component("Minigame")

Minigame.init = function (self, unit)
	self:enable(unit)

	local minigame_extension = ScriptUnit.fetch_component_extension(unit, "minigame_system")

	if minigame_extension then
		local minigame_type = self:get_data(unit, "minigame_type")

		minigame_extension:setup_from_component(minigame_type)
	end
end

Minigame.editor_init = function (self, unit)
	self:enable(unit)
end

Minigame.editor_validate = function (self, unit)
	return true, ""
end

Minigame.enable = function (self, unit)
	return
end

Minigame.disable = function (self, unit)
	return
end

Minigame.destroy = function (self, unit)
	return
end

Minigame.component_data = {
	minigame_type = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Minigame Type",
		options_keys = {
			"None",
			"Default",
			"Scan",
			"Decode Symbols",
			"Drill"
		},
		options_values = {
			"none",
			"default",
			"scan",
			"decode_symbols",
			"drill"
		}
	},
	extensions = {
		"MinigameExtension"
	}
}

return Minigame
