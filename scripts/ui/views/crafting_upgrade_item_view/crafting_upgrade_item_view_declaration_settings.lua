local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local CraftingUpgradeItemViewDeclarationSettings = {
	state_bound = true,
	display_name = "loc_crafting_view_display_name",
	path = "scripts/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view",
	package = "packages/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view",
	class = "CraftingUpgradeItemView",
	disable_game_world = true,
	levels = {
		"content/levels/ui/crafting_view/crafting_view"
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

return settings("CraftingUpgradeItemViewDeclarationSettings", CraftingUpgradeItemViewDeclarationSettings)
