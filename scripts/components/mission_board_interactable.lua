local MissionBoardInteractable = component("MissionBoardInteractable")

MissionBoardInteractable.init = function (self, unit)
	local mission_board_interactable_extension = ScriptUnit.fetch_component_extension(unit, "mission_board_system")

	if mission_board_interactable_extension then
		local button_name = self:get_data(unit, "button_name")
		local mission_board_name = self:get_data(unit, "mission_board_name")

		mission_board_interactable_extension:setup_from_component(button_name, mission_board_name)
	end
end

MissionBoardInteractable.editor_init = function (self, unit)
	return
end

MissionBoardInteractable.enable = function (self, unit)
	return
end

MissionBoardInteractable.disable = function (self, unit)
	return
end

MissionBoardInteractable.destroy = function (self, unit)
	return
end

MissionBoardInteractable.component_data = {
	button_name = {
		value = "button 1",
		ui_type = "combo_box",
		ui_name = "Button name",
		options_keys = {
			"button 1",
			"button 2",
			"button 3",
			"button 4",
			"button 5",
			"button 6"
		},
		options_values = {
			"button_1",
			"button_2",
			"button_3",
			"button_4",
			"button_5",
			"button_6"
		}
	},
	mission_board_name = {
		value = "mission_board_hub",
		ui_type = "combo_box",
		ui_name = "Mission Board Name",
		options_keys = {
			"mission_board_hub"
		},
		options_values = {
			"mission_board_hub"
		}
	},
	extensions = {
		"MissionBoardInteractableExtension"
	}
}

return MissionBoardInteractable
