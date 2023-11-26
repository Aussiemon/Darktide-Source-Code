-- chunkname: @scripts/ui/default_pass_styles.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local DefaultPassStyles = {}

DefaultPassStyles.texture = {
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
}
DefaultPassStyles.texture_uv = {
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
}
DefaultPassStyles.rotated_texture = {
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
}
DefaultPassStyles.multi_texture = {
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
}
DefaultPassStyles.rotated_rect = {
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
}
DefaultPassStyles.rect = {
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
}
DefaultPassStyles.triangle = {
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
}
DefaultPassStyles.circle = {
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
}
DefaultPassStyles.logic = {}
DefaultPassStyles.hotspot = {
	anim_select_speed = 8,
	anim_input_speed = 8,
	anim_hover_speed = 8,
	anim_focus_speed = 8,
	offset = {
		0,
		0,
		0
	}
}
DefaultPassStyles.slug_icon = {
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
}
DefaultPassStyles.rotated_slug_icon = {
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
}
DefaultPassStyles.rotated_slug_picture = {
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
}
DefaultPassStyles.slug_picture = {
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
}
DefaultPassStyles.multi_slug_icon = {
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
}
DefaultPassStyles.video = {
	uv_slot_name = "normal_map",
	y_slot_name = "diffuse_map",
	color = {
		255,
		255,
		255,
		255
	}
}
DefaultPassStyles.text = table.clone(UIFontSettings.body)

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
