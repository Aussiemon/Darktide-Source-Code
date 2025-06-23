-- chunkname: @scripts/ui/views/crafting_mechanicus_upgrade_item_view/crafting_mechanicus_upgrade_item_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_settings = {
	state_bound = true,
	display_name = "loc_crafting_view_display_name",
	load_in_hub = true,
	path = "scripts/ui/views/crafting_mechanicus_upgrade_item_view/crafting_mechanicus_upgrade_item_view",
	package = "packages/ui/views/crafting_mechanicus_upgrade_item_view/crafting_mechanicus_upgrade_item_view",
	class = "CraftingUpgradeItemView",
	disable_game_world = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization"
	},
	enter_sound_events = {
		UISoundEvents.default_menu_enter
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("CraftingMechanicusUpgradeItemViewDeclarationSettings", view_settings)
