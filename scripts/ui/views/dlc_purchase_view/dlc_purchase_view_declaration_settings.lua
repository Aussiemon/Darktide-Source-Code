-- chunkname: @scripts/ui/views/dlc_purchase_view/dlc_purchase_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local dummy_dlc_settings = {
	dlc_id = "test_dlc",
	image = "content/ui/textures/dlc/adamant/dt_adamant_standard_store_large",
	loc_name = "loc_dlc_test",
	steam_dlc_target = 3710910,
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
}
local dummy_dlc_settings_deluxe = {
	dlc_id = "test_dlc_deluxe",
	image = "content/ui/textures/dlc/adamant/dt_adamant_deluxe_store_large",
	loc_name = "loc_dlc_test_deluxe",
	steam_dlc_target = 3710950,
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = 3710950,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = 3710950,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = "TESTXBOXIDBUNDLE",
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = "TESTPSNIDBUNDLE",
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = 3710950,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = 3710950,
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
		dlc_settings_deluxe = dummy_dlc_settings_deluxe,
	},
}

return settings("DLCPurchaseViewDeclarationSettings", view_settings)
