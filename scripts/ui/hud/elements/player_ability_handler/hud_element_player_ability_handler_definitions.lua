local HudElementPlayerAbilityHandlerSettings = require("scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local setup_settings_by_slot = HudElementPlayerAbilityHandlerSettings.setup_settings_by_slot

for slot_name, setup_settings in pairs(setup_settings_by_slot) do
	scenegraph_definition[slot_name] = setup_settings.scenegraph_definition
end

local widget_definitions = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
