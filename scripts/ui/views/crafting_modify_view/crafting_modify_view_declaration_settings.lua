-- chunkname: @scripts/ui/views/crafting_modify_view/crafting_modify_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_settings = {
	class = "CraftingModifyView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	load_in_hub = true,
	package = "packages/ui/views/crafting_modify_view/crafting_modify_view",
	path = "scripts/ui/views/crafting_modify_view/crafting_modify_view",
	state_bound = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	},
	enter_sound_events = {
		UISoundEvents.default_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit,
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("CraftingModifyViewDeclarationSettings", view_settings)
