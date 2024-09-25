-- chunkname: @scripts/managers/telemetry/telemetry_settings.lua

local Crashify = require("scripts/settings/crashify/crashify")
local settings = {
	enabled = true,
	source = {
		id = "bishop",
		platform = PLATFORM,
		environment = BUILD,
		version = {
			game = APPLICATION_SETTINGS.game_version,
			engine_revision = string.value_or_nil(BUILD_IDENTIFIER),
			content_revision = string.value_or_nil(APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION),
		},
		data = {
			server = string.value_or_nil(DEDICATED_SERVER),
			testify = string.value_or_nil(GameParameters.testify),
			testify_test_suite_id = string.value_or_nil(DevParameters.testify_test_suite_id),
			steam_branch = string.value_or_nil(GameParameters.steam_branch),
			svn_branch = string.value_or_nil(GameParameters.svn_branch),
		},
		crashify = {
			project_branch = string.value_or_nil(Crashify.branch),
		},
	},
	batch = {
		full_post_interval = 30,
		max_size = 16000,
		post_interval = 300,
		size = 2000,
	},
	heartbeat = {
		interval = 300,
	},
	blacklisted_views = {
		"inventory_view",
		"mission_board_view",
		"news_view",
		"store_view",
		"blank_view",
		"custom_settings_view",
		"cutscene_view",
		"debug_vendor_view",
		"debug_view",
		"inventory_background_view",
		"main_menu_background_view",
		"splash_video_view",
		"splash_view",
		"title_view",
		"scanner_display_view",
	},
}

return settings
