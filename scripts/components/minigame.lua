local Minigame = component("Minigame")

Minigame.init = function (self, unit)
	self:enable(unit)

	local minigame_extension = ScriptUnit.fetch_component_extension(unit, "minigame_system")

	if minigame_extension then
		local minigame_type = self:get_data(unit, "minigame_type")
		local decode_symbols_sweep_duration = self:get_data(unit, "decode_symbols_sweep_duration")

		minigame_extension:setup_from_component(minigame_type, decode_symbols_sweep_duration)
	end
end

Minigame.editor_init = function (self, unit)
	self:enable(unit)
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
			"Scan",
			"Decode Symbols"
		},
		options_values = {
			"none",
			"scan",
			"decode_symbols"
		}
	},
	decode_symbols_sweep_duration = {
		ui_type = "number",
		min = 0.5,
		decimals = 1,
		category = "Decode Symbols",
		value = 2,
		ui_name = "Highlight Sweep Duration (in sec)",
		step = 0.1
	},
	extensions = {
		"MinigameExtension"
	}
}

return Minigame
