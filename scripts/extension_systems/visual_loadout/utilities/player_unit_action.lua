-- chunkname: @scripts/extension_systems/visual_loadout/utilities/player_unit_action.lua

local Action = require("scripts/utilities/action/action")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local PlayerUnitAction = {}

PlayerUnitAction.has_current_action_keyword = function (weapon_action_component, keyword)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local _, current_action_settings = Action.current_action(weapon_action_component, weapon_template)

	if not current_action_settings then
		_, current_action_settings = Action.previous_action(weapon_action_component, weapon_template)
	end

	local keywords = current_action_settings and current_action_settings.action_keywords
	local has_keyword = keywords and table.index_of(keywords, keyword) > 0

	return has_keyword
end

return PlayerUnitAction
