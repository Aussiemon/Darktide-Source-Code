local Crashify = require("scripts/settings/crashify/crashify")
local settings = {
	enabled = true,
	source = {
		id = "bishop",
		platform = PLATFORM,
		environment = BUILD,
		version = {
			engine_revision = string.value_or_nil(BUILD_IDENTIFIER),
			content_revision = string.value_or_nil(APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION)
		},
		data = {
			server = string.value_or_nil(DEDICATED_SERVER),
			testify = string.value_or_nil(GameParameters.testify),
			steam_branch = string.value_or_nil(GameParameters.steam_branch),
			svn_branch = string.value_or_nil(GameParameters.svn_branch)
		},
		crashify = {
			project_branch = string.value_or_nil(Crashify.branch)
		}
	},
	batch = {
		size = 2000,
		max_size = 16000,
		full_post_interval = 30,
		post_interval = 300
	},
	heartbeat = {
		interval = 300
	},
	blacklisted_views = {
		"contracts_background_view",
		"splash_video_view",
		"title_view",
		"video_view",
		"loading_view",
		"system_view",
		"main_menu_view",
		"custom_settings_view",
		"scanner_display_view",
		"credits_vendor_background_view",
		"blank_view",
		"debug_vendor_view",
		"end_player_view",
		"inventory_background_view",
		"debug_view",
		"splash_view",
		"cutscene_view",
		"main_menu_background_view"
	}
}

return settings
