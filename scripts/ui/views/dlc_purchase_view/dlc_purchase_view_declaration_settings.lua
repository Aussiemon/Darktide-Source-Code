-- chunkname: @scripts/ui/views/dlc_purchase_view/dlc_purchase_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local dummy_dlc_settings = {
	dlc_id = "test_dlc",
	loc_name_generic = "loc_test_dlc",
	steam_dlc_target = 3710910,
	standard = {
		image = "content/ui/textures/dlc/adamant/dt_adamant_standard_store_large",
		loc_name = "loc_dlc_test",
		ids = {
			[Backend.AUTH_METHOD_NONE] = {
				id = 3710910,
			},
			[Backend.AUTH_METHOD_STEAM] = {
				id = 3710910,
			},
			[Backend.AUTH_METHOD_XBOXLIVE] = {
				id = "TESTXBOXID",
			},
			[Backend.AUTH_METHOD_PSN] = {
				id = "TESTPSNID",
			},
			[Backend.AUTH_METHOD_DEV_USER] = {
				id = 3710910,
			},
			[Backend.AUTH_METHOD_AWS] = {
				id = 3710910,
			},
		},
	},
	deluxe = {
		image = "content/ui/textures/dlc/adamant/dt_adamant_deluxe_store_large",
		loc_name = "loc_dlc_test_deluxe",
		ids = {
			[Backend.AUTH_METHOD_NONE] = {
				id = 3710950,
			},
			[Backend.AUTH_METHOD_STEAM] = {
				id = 3710950,
			},
			[Backend.AUTH_METHOD_XBOXLIVE] = {
				id = "TESTXBOXIDBUNDLE",
				is_bundle = true,
			},
			[Backend.AUTH_METHOD_PSN] = {
				id = "TESTPSNIDBUNDLE",
				is_bundle = true,
			},
			[Backend.AUTH_METHOD_DEV_USER] = {
				id = 3710950,
			},
			[Backend.AUTH_METHOD_AWS] = {
				id = 3710950,
			},
		},
	},
}
local view_settings = {
	class = "DLCPurchaseView",
	disable_game_world = false,
	display_name = "loc_term_glossary_dlc",
	game_world_blur = 1.1,
	package = "packages/ui/views/dlc_purchase_view/dlc_purchase_view",
	path = "scripts/ui/views/dlc_purchase_view/dlc_purchase_view",
	use_transition_ui = false,
	enter_sound_events = {
		UISoundEvents.aquilas_vendor_on_enter,
	},
	exit_sound_events = {
		UISoundEvents.aquilas_vendor_on_exit,
	},
	dummy_data = {
		dlc_settings = dummy_dlc_settings,
	},
}

return settings("DLCPurchaseViewDeclarationSettings", view_settings)
