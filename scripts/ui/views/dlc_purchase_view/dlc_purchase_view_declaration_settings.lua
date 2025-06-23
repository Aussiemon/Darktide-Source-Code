-- chunkname: @scripts/ui/views/dlc_purchase_view/dlc_purchase_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	display_name = "loc_term_glossary_dlc",
	use_transition_ui = false,
	path = "scripts/ui/views/dlc_purchase_view/dlc_purchase_view",
	package = "packages/ui/views/dlc_purchase_view/dlc_purchase_view",
	class = "DLCPurchaseView",
	disable_game_world = false,
	game_world_blur = 1.1,
	enter_sound_events = {
		UISoundEvents.aquilas_vendor_on_enter
	},
	exit_sound_events = {
		UISoundEvents.aquilas_vendor_on_exit
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("DLCPurchaseViewDeclarationSettings", view_settings)
