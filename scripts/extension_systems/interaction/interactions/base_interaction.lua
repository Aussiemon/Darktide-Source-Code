-- chunkname: @scripts/extension_systems/interaction/interactions/base_interaction.lua

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
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
	return true
end

BaseInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return not self:_interactor_disabled(interactor_unit)
end

BaseInteraction.hud_description = function (self, interactor_unit, interactee_unit, target_node)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	return interactee_extension:description()
end

BaseInteraction.hud_block_text = function (self, interactor_unit, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	return interactee_extension:block_text(interactor_unit)
end

BaseInteraction.type = function (self)
	return self._template.type
end

BaseInteraction.duration = function (self)
	return self._template.duration
end

BaseInteraction.interaction_input = function (self)
	return self._template.interaction_input or "interact_pressed"
end

BaseInteraction.interaction_priority = function (self)
	return self._template.interaction_priority or 1
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

BaseInteraction._unequip_slot = function (self, t, interactor_unit, slot_name)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")

	if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, slot_name) then
		PlayerUnitVisualLoadout.unequip_item_from_slot(interactor_unit, slot_name, t)
	end
end

return BaseInteraction
