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
	}
}

return settings
