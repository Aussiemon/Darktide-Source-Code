-- chunkname: @scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	state_bound = true,
	display_name = "loc_inventory_weapon_marks_view_display_name",
	use_transition_ui = true,
	path = "scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view",
	package = "packages/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view",
	class = "InventoryWeaponMarksView",
	disable_game_world = true,
	load_in_hub = true,
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.ingame_menu
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

return settings("InventoryWeaponMarksViewDeclarationSettings", view_settings)
