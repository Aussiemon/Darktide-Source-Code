local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local BaseInteraction = class("BaseInteraction")

BaseInteraction.init = function (self, template)
	self._template = template
end

BaseInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	return
end

BaseInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	return
end

BaseInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	return not self:_interactor_disabled(interactor_unit)
end

BaseInteraction.interactee_condition_func = function (self, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	if interactee_extension:block_text() then
		return false
	end

	return true
end

BaseInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return not self:_interactor_disabled(interactor_unit)
end

BaseInteraction.hud_description = function (self, interactor_unit, interactee_unit, target_node)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	return interactee_extension:description()
end

BaseInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, target_node)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	return interactee_extension:block_text()
end

BaseInteraction.marker_offset = function (self)
	return nil
end

BaseInteraction.type = function (self)
	return self._template.type
end

BaseInteraction.duration = function (self)
	return self._template.duration
end

BaseInteraction.ui_interaction_type = function (self)
	return self._template.ui_interaction_type
end

BaseInteraction.interaction_icon = function (self)
	return self._template.interaction_icon
end

BaseInteraction.description = function (self)
	return self._template.description
end

BaseInteraction.action_text = function (self)
	return self._template.action_text
end

BaseInteraction.ui_view_name = function (self)
	return self._template.ui_view_name
end

BaseInteraction.only_once = function (self)
	return self._template.only_once
end

BaseInteraction._interactor_disabled = function (self, interactor_unit)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")

	return PlayerUnitStatus.is_disabled(character_state_component)
end

return BaseInteraction
