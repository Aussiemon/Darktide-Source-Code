-- chunkname: @scripts/settings/ui/ui_workspace_settings.lua

local ui_workspace_settings = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	},
	top_panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			0,
			100
		},
		position = {
			0,
			100,
			0
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			0,
			60
		},
		position = {
			0,
			0,
			0
		}
	},
	background_left = {
		scale = "fit_height",
		horizontal_alignment = "left",
		size = {
			1100,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			640,
			840
		},
		position = {
			180,
			35,
			2
		}
	},
	area_wide = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			820,
			840
		},
		position = {
			85,
			0,
			2
		}
	},
	area_wide_column_left = {
		vertical_alignment = "center",
		parent = "area_wide",
		horizontal_alignment = "left",
		size = {
			375,
			840
		},
		position = {
			0,
			0,
			0
		}
	},
	area_wide_column_right = {
		vertical_alignment = "center",
		parent = "area_wide",
		horizontal_alignment = "right",
		size = {
			375,
			840
		},
		position = {
			0,
			0,
			0
		}
	}
}

return settings("UIWorkspaceSettings", ui_workspace_settings)
