require("scripts/foundation/utilities/color")

local ui_font_settings = {
	header_1 = {
		font_size = 55,
		material = "content/ui/materials/font_gradients/slug_font_gradient_gold",
		text_vertical_alignment = "center",
		font_type = "machine_medium",
		text_horizontal_alignment = "left",
		text_color = Color.white(255, true),
		offset = {
			0,
			0,
			0
		}
	},
	header_2 = {
		font_size = 36,
		font_type = "proxima_nova_bold",
		text_color = Color.terminal_text_header(255, true),
		default_color = Color.terminal_text_header(255, true),
		hover_color = Color.terminal_text_header_selected(255, true),
		disabled_color = Color.ui_grey_light(255, true)
	},
	header_3 = {
		font_size = 26,
		font_type = "proxima_nova_bold",
		text_color = Color.terminal_text_header(255, true),
		default_color = Color.terminal_text_header(255, true),
		hover_color = Color.terminal_text_header_selected(255, true),
		disabled_color = Color.ui_grey_light(255, true)
	},
	header_4 = {
		text_horizontal_alignment = "left",
		font_size = 24,
		text_vertical_alignment = "center",
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		default_color = Color.ui_grey_light(255, true),
		text_color = Color.ui_grey_light(255, true),
		hover_color = Color.ui_brown_super_light(255, true),
		offset = {
			30,
			0,
			1
		}
	},
	header_5 = {
		font_size = 20,
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		default_color = Color.ui_grey_medium(255, true),
		text_color = Color.ui_grey_medium(255, true),
		hover_color = Color.ui_brown_super_light(255, true)
	},
	currency_title = {
		font_size = 28,
		text_horizontal_alignment = "center",
		drop_shadow = true,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		default_color = Color.white(255, true),
		text_color = Color.white(255, true),
		offset = {
			0,
			0,
			1
		}
	},
	grid_title = {
		font_size = 26,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		offset = {
			0,
			0,
			3
		},
		text_color = Color.terminal_text_header(255, true),
		default_color = Color.terminal_text_header(255, true),
		disabled_color = Color.terminal_text_header_disabled(255, true)
	},
	item_info_big = {
		font_size = 36,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_brown_light(255, true),
		default_color = Color.ui_brown_light(255, true),
		hover_color = Color.ui_brown_super_light(255, true),
		disabled_color = Color.ui_grey_light(255, true)
	},
	item_info_small = {
		font_size = 24,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_brown_light(255, true),
		default_color = Color.ui_brown_light(255, true),
		hover_color = Color.ui_brown_super_light(255, true),
		disabled_color = Color.ui_grey_light(255, true)
	},
	terminal_header_1 = {
		font_size = 55,
		text_vertical_alignment = "center",
		font_type = "itc_novarese_medium",
		text_horizontal_alignment = "center",
		text_color = Color.ui_orange_light(255, true),
		offset = {
			0,
			2,
			1
		}
	},
	terminal_header_2 = {
		font_size = 36,
		font_type = "proxima_nova_bold",
		text_color = Color.white(255, true),
		default_color = Color.white(255, true),
		hover_color = Color.terminal_text_header_selected(255, true),
		disabled_color = Color.ui_grey_light(255, true)
	},
	terminal_header_3 = {
		font_size = 30,
		font_type = "proxima_nova_bold",
		text_color = Color.terminal_text_header(255, true),
		default_color = Color.terminal_text_header(255, true),
		hover_color = Color.terminal_text_header_selected(255, true),
		disabled_color = Color.ui_grey_medium(255, true)
	},
	body = {
		line_spacing = 1.2,
		font_size = 24,
		font_type = "proxima_nova_bold",
		text_color = Color.text_default(255, true),
		default_color = Color.text_default(255, true)
	},
	body_medium = {
		line_spacing = 1.2,
		font_size = 22,
		font_type = "proxima_nova_bold",
		text_color = Color.text_default(255, true),
		default_color = Color.text_default(255, true)
	},
	body_small = {
		font_size = 18,
		line_spacing = 1.2,
		font_type = "proxima_nova_bold",
		text_color = Color.terminal_text_body(255, true)
	},
	symbol = {
		line_spacing = 1.2,
		font_size = 48,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_grey_light(255, true),
		default_color = Color.ui_grey_light(255, true)
	},
	button_1 = {
		font_size = 36,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_brown_light(255, true),
		hover_color = Color.ui_grey_light(255, true)
	},
	button_2 = {
		font_size = 24,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_brown_light(255, true),
		hover_color = Color.ui_grey_light(255, true)
	},
	button_primary = {
		text_horizontal_alignment = "center",
		font_size = 24,
		text_vertical_alignment = "center",
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		default_color = Color.terminal_text_header(255, true),
		text_color = Color.terminal_text_header(255, true),
		hover_color = Color.white(255, true),
		disabled_color = Color.ui_grey_light(255, true),
		offset = {
			0,
			-2,
			1
		}
	},
	button_medium = {
		font_size = 24,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_color = Color.text_default(255, true)
	},
	nameplates = {
		drop_shadow = true,
		font_size = 20,
		text_vertical_alignment = "bottom",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_color = {
			255,
			255,
			255,
			255
		}
	},
	end_of_round_nameplates_guild = {
		font_size = 24,
		font_type = "proxima_nova_bold",
		drop_shadow = true,
		text_color = {
			255,
			167,
			163,
			163
		}
	},
	button_legend_description = {
		line_spacing = 1.2,
		font_size = 24,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_grey_medium(255, true),
		default_color = Color.ui_grey_medium(255, true)
	},
	hud_body = {
		line_spacing = 1.2,
		font_size = 20,
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		text_color = Color.ui_hud_green_super_light(255, true)
	},
	chat_notification = {
		line_spacing = 1.3,
		font_size = 16,
		drop_shadow = false,
		font_type = "proxima_nova_bold_masked",
		text_color = Color.ui_orange_medium(255, true),
		offset = {
			0,
			0,
			0
		}
	},
	chat_input = {
		font_size = 16,
		drop_shadow = false,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold_no_render_flags",
		text_color = Color.ui_brown_super_light(255, true),
		offset = {
			0,
			0,
			0
		}
	},
	chat_message = {
		line_spacing = 1.3,
		font_size = 16,
		drop_shadow = true,
		font_type = "proxima_nova_bold_masked",
		text_color = Color.ui_brown_super_light(255, true),
		offset = {
			0,
			0,
			0
		}
	},
	input_legend_button = {
		font_size = 22,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_color = Color.legend_button_text(255, true),
		default_text_color = Color.legend_button_text(255, true),
		hover_color = Color.legend_button_text_hover(255, true)
	},
	list_button = {
		text_horizontal_alignment = "left",
		font_size = 24,
		text_vertical_alignment = "center",
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		default_color = Color.terminal_text_header(255, true),
		text_color = Color.terminal_text_header(255, true),
		hover_color = Color.terminal_text_header_selected(255, true),
		selected_color = Color.terminal_text_header_selected(255, true),
		disabled_color = Color.ui_grey_light(255, true),
		offset = {
			50,
			0,
			3
		}
	},
	list_button_second_row = {
		text_horizontal_alignment = "left",
		font_size = 18,
		text_vertical_alignment = "center",
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		default_color = Color.ui_brown_light(255, true),
		text_color = Color.ui_brown_light(255, true),
		hover_color = Color.ui_brown_super_light(255, true),
		disabled_color = Color.ui_grey_medium(255, true),
		offset = {
			64,
			12,
			1
		}
	},
	mission_board_header = {
		drop_shadow = true,
		font_size = 38,
		text_vertical_alignment = "center",
		font_type = "itc_novarese_bold",
		text_horizontal_alignment = "left",
		text_color = Color.ui_green_super_light(255, true)
	},
	mission_board_sub_header = {
		drop_shadow = true,
		font_size = 16,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_color = Color.ui_grey_light(255, true)
	},
	mission_board_event_header = {
		drop_shadow = true,
		font_size = 16,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_color = Color.ui_terminal(255, true)
	},
	mission_detail_sub_header = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		drop_shadow = true,
		text_color = Color.ui_grey_light(255, true)
	},
	mission_board_icon_info = {
		drop_shadow = true,
		font_size = 20,
		text_vertical_alignment = "top",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_color = Color.ui_green_super_light(255, true)
	},
	mission_detail_header_1 = {
		font_size = 24,
		font_type = "itc_novarese_bold",
		drop_shadow = true,
		text_color = Color.ui_green_light(255, true)
	},
	mission_detail_header_2 = {
		font_size = 24,
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_color = Color.ui_grey_light(255, true)
	},
	mission_detail_header_3 = {
		font_size = 24,
		font_type = "itc_novarese_bold",
		drop_shadow = true,
		text_color = Color.ui_green_light(255, true)
	},
	mission_detail_label = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		drop_shadow = true,
		text_color = Color.ui_green_medium(255, true)
	},
	mission_voting_sub_header = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_color = Color.ui_grey_medium(255, true)
	},
	mission_voting_body = {
		font_size = 24,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_color = Color.ui_brown_super_light(255, true)
	},
	mission_voting_details = {
		font_size = 24,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_medium",
		text_horizontal_alignment = "left",
		text_color = Color.ui_grey_medium(255, true)
	},
	tab_menu_button = {
		text_horizontal_alignment = "center",
		font_size = 26,
		text_vertical_alignment = "center",
		material = "content/ui/materials/font_gradients/slug_font_gradient_header",
		font_type = "itc_novarese_bold",
		text_color = Color.white(255, true),
		default_color = Color.white(255, true),
		disabled_color = Color.ui_grey_light(255, true),
		offset = {
			0,
			0,
			0
		}
	},
	tab_menu_button_hover = {
		font_type = "itc_novarese_bold",
		font_size = 26,
		text_vertical_alignment = "center",
		material = "content/ui/materials/font_gradients/slug_font_gradient_header_highlighted",
		text_horizontal_alignment = "center",
		text_color = Color.white(0, true),
		offset = {
			0,
			0,
			2
		}
	}
}

for _, settings in pairs(ui_font_settings) do
	settings.default_font_size = settings.font_size
	settings.default_text_color = table.clone(settings.text_color)
	settings.disabled_text_color = Color.ui_disabled_text_color(255, true)
end

return settings("UIFontSettings", ui_font_settings)
