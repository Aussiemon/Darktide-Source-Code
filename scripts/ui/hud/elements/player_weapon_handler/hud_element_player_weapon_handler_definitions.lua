-- chunkname: @scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_definitions.lua

local HudElementPlayerWeaponHandlerSettings = require("scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local slots_settings = HudElementPlayerWeaponHandlerSettings.slots_settings
local size_size = HudElementPlayerWeaponHandlerSettings.size
local weapon_spacing = HudElementPlayerWeaponHandlerSettings.weapon_spacing
local screen_offset = HudElementPlayerWeaponHandlerSettings.screen_offset
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	weapon_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = size_size,
		position = screen_offset,
	},
}
local widget_definitions = {}
local position_x = 0
local position_y = 0
local max_slots = table.size(slots_settings)

for i = 1, max_slots do
	local scenegraph_id = "weapon_slot_" .. i
	local position = {
		screen_offset[1] + position_x,
		screen_offset[2] + position_y,
		0,
	}

	scenegraph_definition[scenegraph_id] = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = size_size,
		position = position,
	}
	position_x = position_x + weapon_spacing[1]
	position_y = position_y - (size_size[2] + weapon_spacing[2])
end

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
