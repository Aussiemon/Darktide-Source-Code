-- chunkname: @scripts/settings/ui/ui_workspace_settings.lua

local ui_workspace_settings = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			2,
		},
	},
	top_panel = {
		scale = "fit_width",
		vertical_alignment = "top",
		size = {
			0,
			100,
		},
		position = {
			0,
			100,
			0,
		},
	},
	bottom_panel = {
		scale = "fit_width",
		vertical_alignment = "bottom",
		size = {
			0,
			60,
		},
		position = {
			0,
			0,
			0,
		},
	},
	background_left = {
		horizontal_alignment = "left",
		scale = "fit_height",
		size = {
			1100,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	area = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			640,
			840,
		},
		position = {
			180,
			35,
			2,
		},
	},
	area_wide = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			820,
			840,
		},
		position = {
			85,
			0,
			2,
		},
	},
	area_wide_column_left = {
		horizontal_alignment = "left",
		parent = "area_wide",
		vertical_alignment = "center",
		size = {
			375,
			840,
		},
		position = {
			0,
			0,
			0,
		},
	},
	area_wide_column_right = {
		horizontal_alignment = "right",
		parent = "area_wide",
		vertical_alignment = "center",
		size = {
			375,
			840,
		},
		position = {
			0,
			0,
			0,
		},
	},
}

return settings("UIWorkspaceSettings", ui_workspace_settings)
