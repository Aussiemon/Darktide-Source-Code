local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local DefaultPassStyles = {
	texture = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	texture_uv = {
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	rotated_texture = {
		angle = 0,
		color = {
			255,
			255,
			255,
			255
		},
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		},
		offset = {
			0,
			0,
			0
		},
		pivot = {}
	},
	multi_texture = {
		spacing = 0,
		direction = 1,
		axis = 1,
		amount = 1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	rotated_rect = {
		angle = 0,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		},
		pivot = {}
	},
	rect = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	triangle = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	circle = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	logic = {},
	hotspot = {
		anim_select_speed = 8,
		anim_input_speed = 8,
		anim_hover_speed = 8,
		anim_focus_speed = 8,
		offset = {
			0,
			0,
			0
		}
	},
	slug_icon = {
		draw_index = 1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	rotated_slug_icon = {
		angle = 0,
		draw_index = 1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		},
		pivot = {}
	},
	rotated_slug_picture = {
		angle = 0,
		draw_index = 1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		},
		pivot = {}
	},
	slug_picture = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	multi_slug_icon = {
		amount = 1,
		spacing = 0,
		direction = 1,
		axis = 1,
		draw_index = 1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	},
	video = {
		uv_slot_name = "normal_map",
		y_slot_name = "diffuse_map",
		color = {
			255,
			255,
			255,
			255
		}
	},
	text = table.clone(UIFontSettings.body)
}
local text_style = DefaultPassStyles.text
text_style.drop_shadow = true
text_style.text_horizontal_alignment = "left"
text_style.text_vertical_alignment = "top"
text_style.text_color = {
	255,
	255,
	0,
	255
}
text_style.default_text_color = {
	255,
	255,
	0,
	255
}
text_style.debug_draw_box = false
text_style.offset = {
	0,
	0,
	0
}

return DefaultPassStyles
