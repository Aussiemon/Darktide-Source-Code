-- chunkname: @scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "InventoryWeaponMarksView",
	disable_game_world = true,
	display_name = "loc_inventory_weapon_marks_view_display_name",
	package = "packages/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view",
	path = "scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view",
	preload_in_hub = "not_ps5",
	state_bound = true,
	use_transition_ui = true,
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
	},
	enter_sound_events = {
		UISoundEvents.default_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit,
	},
	dummy_data = {
		debug_preview = true,
	},
}

return settings("InventoryWeaponMarksViewDeclarationSettings", view_settings)
