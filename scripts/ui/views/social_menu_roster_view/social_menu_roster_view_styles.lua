local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local DefaultPassStyles = require("scripts/ui/default_pass_styles")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local PerlinNoise = require("scripts/utilities/perlin_noise")
local ColorUtilities = require("scripts/utilities/ui/colors")
local social_menu_roster_view_styles = {
	default_frame_material = "content/ui/textures/nameplates/portrait_frames/default",
	roster_grid_mask_expansion = 20,
	default_insignia_material = "content/ui/textures/nameplates/insignias/default",
	panel_header_height = 58,
	roster_panel_size = {
		1030,
		680
	},
	grid_margin = {
		20,
		20
	},
	grid_spacing = {
		30,
		20
	},
	player_panel_size = {
		480,
		80
	},
	portrait_size = {
		72,
		80
	},
	insignia_size = {
		32,
		80
	}
}
local flicker_min_time_between = 1.5
local flicker_max_time_between = 5
local flicker_min_time = 0.05
local flicker_max_time = 0.5
social_menu_roster_view_styles.party_panel = {}
local party_panel_style = social_menu_roster_view_styles.party_panel
party_panel_style.background = {
	scale_to_material = true,
	color = Color.terminal_grid_background(255, true),
	size_addition = {
		18,
		26
	},
	offset = {
		-9,
		-13,
		0
	}
}
party_panel_style.header = table.clone(UIFontSettings.header_3)
party_panel_header_style = party_panel_style.header
party_panel_header_style.offset = {
	0,
	-40,
	0
}
party_panel_header_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
party_panel_header_style.text_color = Color.white(255, true)
local player_panel_size = social_menu_roster_view_styles.player_panel_size
local grid_spacing = social_menu_roster_view_styles.grid_spacing
local empty_slot_prefix = "party_slot_"

for i = 1, SocialMenuSettings.max_num_party_members do
	local key = empty_slot_prefix .. i
	local party_panel_vertical_offset = (i - 1) * (grid_spacing[2] + player_panel_size[2])
	party_panel_style[key] = {
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		offset = {
			0,
			party_panel_vertical_offset,
			10
		},
		size = player_panel_size,
		color = Color.black(255, true),
		text_color = Color.ui_grey_medium(255, true),
		font_type = UIFontSettings.body.font_type,
		font_size = UIFontSettings.body.font_size,
		content_key = i
	}
end

party_panel_style.window_1 = {}
local party_window_1 = party_panel_style.window_1
party_window_1.size = {
	78,
	122
}
party_window_1.offset = {
	111,
	20,
	1
}
party_window_1.content_key = 1
party_panel_style.window_2 = table.clone(party_window_1)
local party_window_2 = party_panel_style.window_2
party_window_2.offset[1] = 185
party_window_2.content_key = 2
party_panel_style.window_3 = table.clone(party_window_1)
local party_window_3 = party_panel_style.window_3
party_window_3.offset[1] = 261
party_window_3.content_key = 3
party_panel_style.window_4 = table.clone(party_window_1)
local party_window_4 = party_panel_style.window_4
party_window_4.offset[1] = 336
party_window_4.content_key = 4
social_menu_roster_view_styles.roster_panel = {}
local roster_panel_style = social_menu_roster_view_styles.roster_panel
roster_panel_style.background = {
	scale_to_material = true,
	offset = {
		-9,
		-13,
		0
	},
	color = Color.terminal_grid_background(255, true),
	size_addition = {
		18,
		26
	}
}
social_menu_roster_view_styles.roster_grid = {
	mask_expansion = {
		18,
		18
	}
}
social_menu_roster_view_styles.blueprints = {}
local blueprint_styles = social_menu_roster_view_styles.blueprints
blueprint_styles.player_plaque = {}
local player_plaque_style = blueprint_styles.player_plaque
player_plaque_style.size = player_panel_size
player_plaque_style.hotspot = DefaultPassStyles.hotspot
player_plaque_style.background = {
	offset = {
		0,
		0,
		0
	},
	color = Color.terminal_corner_hover(120, true),
	default_color = Color.terminal_corner_hover(120, true),
	hover_color = Color.terminal_corner_hover(255, true)
}
player_plaque_style.portrait = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		1
	},
	material_values = {
		use_placeholder_texture = 1,
		rows = 1,
		columns = 1,
		grid_index = 1
	}
}
player_plaque_style.portrait_overlay = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		5
	},
	color = Color.terminal_corner_hover(255, true)
}
player_plaque_style.character_insignia = {
	horizontal_alignment = "left",
	size = social_menu_roster_view_styles.insignia_size,
	offset = {
		-40,
		0,
		1
	},
	material_values = {}
}
player_plaque_style.name_or_activity = table.clone(UIFontSettings.body)
local player_name_style = player_plaque_style.name_or_activity
player_name_style.default_color = Color.terminal_text_header(255, true)
player_name_style.not_in_party_color = Color.ui_grey_light(255, true)
player_name_style.party_member_color = Color.ui_brown_light(255, true)
player_name_style.own_player_color = Color.white(255, true)
player_name_style.own_player_material = "content/ui/materials/font_gradients/slug_font_gradient_header"
player_name_style.hover_color = Color.terminal_text_header_selected(255, true)
player_name_style.font_size_default = player_name_style.font_size
player_name_style.font_size_small = UIFontSettings.body_small.font_size
player_name_style.offset = {
	85,
	14,
	1
}
player_plaque_style.account_name = table.clone(UIFontSettings.body_small)
local account_name_style = player_plaque_style.account_name
account_name_style.default_color_default = Color.terminal_text_body_dark(255, true)
account_name_style.default_color_large = Color.terminal_text_body(255, true)
account_name_style.hover_color = Color.terminal_text_header_selected(255, true)
account_name_style.font_size_default = account_name_style.font_size
account_name_style.font_size_large = UIFontSettings.body.font_size
account_name_style.offset = {
	85,
	48,
	1
}
account_name_style.vertical_offset_default = 47
account_name_style.vertical_offset_large = 40
player_plaque_style.party_membership = table.clone(UIFontSettings.body)
local party_membership_style = player_plaque_style.party_membership
party_membership_style.default_color = Color.terminal_text_header(255, true)
party_membership_style.hover_color = Color.terminal_text_header_selected(255, true)
party_membership_style.text_horizontal_alignment = "right"
party_membership_style.offset = {
	-16,
	14,
	1
}
player_plaque_style.highlight = {
	highlight_size_addition = 10,
	color = Color.terminal_corner_hover(0, true),
	size_addition = {
		0,
		0
	},
	offset = {
		0,
		0,
		3
	}
}
blueprint_styles.player_plaque_platform_online = {}
local player_plaque_platform_online_style = blueprint_styles.player_plaque_platform_online
player_plaque_platform_online_style.background = {
	offset = {
		0,
		0,
		0
	},
	color = Color.black(255, true),
	default_color = Color.black(255, true),
	hover_color = Color.terminal_frame_hover(255, true)
}
player_plaque_platform_online_style.portrait = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		1
	}
}
player_plaque_platform_online_style.portrait_overlay = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		5
	}
}
player_plaque_platform_online_style.account_name = table.clone(UIFontSettings.body)
local platform_online_account_name_style = player_plaque_platform_online_style.account_name
platform_online_account_name_style.default_color = Color.terminal_text_header(255, true)
platform_online_account_name_style.hover_color = Color.terminal_text_header_selected(255, true)
platform_online_account_name_style.offset = {
	85,
	40,
	2
}
player_plaque_platform_online_style.status = table.clone(UIFontSettings.body_small)
local platform_online_status_style = player_plaque_platform_online_style.status
platform_online_status_style.default_color = Color.terminal_text_body_sub_header(255, true)
platform_online_status_style.hover_color = Color.terminal_text_body(255, true)
platform_online_status_style.offset = {
	85,
	14,
	2
}
player_plaque_platform_online_style.highlight = table.clone(player_plaque_style.highlight)
blueprint_styles.player_plaque_offline = {}
local player_plaque_offline_style = blueprint_styles.player_plaque_offline
player_plaque_offline_style.background = {
	offset = {
		0,
		0,
		0
	},
	color = Color.black(255, true),
	default_color = Color.black(255, true),
	hover_color = Color.terminal_corner_hover(255, true)
}
player_plaque_offline_style.icon_background = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		1
	},
	color = Color.black(255, true)
}
player_plaque_offline_style.account_name = table.clone(UIFontSettings.body)
local offline_account_name_style = player_plaque_offline_style.account_name
offline_account_name_style.default_color = Color.ui_grey_medium(255, true)
offline_account_name_style.hover_color = Color.ui_brown_super_light(255, true)
offline_account_name_style.offset = {
	85,
	40,
	2
}
player_plaque_offline_style.status = table.clone(UIFontSettings.body_small)
local offline_status_style = player_plaque_offline_style.status
offline_status_style.default_color = Color.ui_grey_medium(255, true)
offline_status_style.hover_color = Color.ui_brown_super_light(255, true)
offline_status_style.offset = {
	85,
	14,
	2
}
player_plaque_offline_style.highlight = table.clone(player_plaque_style.highlight)
blueprint_styles.player_plaque_blocked = table.clone(blueprint_styles.player_plaque_offline)
local player_plaque_blocked_style = blueprint_styles.player_plaque_blocked
player_plaque_blocked_style.icon_blocked = {
	size = social_menu_roster_view_styles.portrait_size
}
blueprint_styles.group_header = {}
local group_header_style = blueprint_styles.group_header
group_header_style.size = {
	social_menu_roster_view_styles.roster_panel_size[1],
	12
}
group_header_style.text = table.clone(UIFontSettings.body_small)
local group_header_text_style = group_header_style.text
group_header_text_style.text_color = Color.terminal_text_header(255, true)
group_header_text_style.offset = {
	0,
	-5,
	1
}
blueprint_styles.list_divider = {}
local list_divider_style = blueprint_styles.list_divider
list_divider_style.width_without_scrollbar = social_menu_roster_view_styles.roster_panel_size[1] - 6
list_divider_style.width_with_scrollbar = social_menu_roster_view_styles.roster_panel_size[1] - 11
list_divider_style.size = {
	social_menu_roster_view_styles.roster_panel_size[1],
	2
}
list_divider_style.divider = {
	offset = {
		-17,
		-21,
		1
	},
	size = {
		list_divider_style.width_without_scrollbar,
		44
	}
}
social_menu_roster_view_styles.change_functions = {}
local change_functions = social_menu_roster_view_styles.change_functions

change_functions.party_visibility = function (content, style)
	local content_key = style.content_key
	local is_visible = content_key <= content.num_party_members

	if not is_visible then
		content.times_til_next_flicker[content_key] = 0
		content.flicker_data[content_key].fade_in = 0
	end

	return is_visible
end

change_functions.party_inverted_visibility = function (content, style)
	local content_key = style.content_key
	local is_visible = content.num_party_members < content_key

	return is_visible
end

change_functions.flickering_windows = function (content, style, animations, dt)
	local content_key = style.content_key
	local time_left_til_next_flicker = content.times_til_next_flicker[content_key]

	if time_left_til_next_flicker < 0 then
		local math_min = math.min
		local calculate_perlin_value = PerlinNoise.calculate_perlin_value
		local flicker_data = content.flicker_data[content_key]
		local progress = math_min(flicker_data.progress + dt * flicker_data.progress_multiplier, 1)
		flicker_data.progress = progress
		local persistance = 3
		local octaves = 8
		local intensity_scale = calculate_perlin_value(progress, persistance, octaves, flicker_data.seed)
		local base_intensity = 240

		if flicker_data.fade_in < 1 then
			local fade_in = math_min(flicker_data.fade_in + dt * 2, 1)
			local base_intensity_scale = calculate_perlin_value(fade_in, persistance, octaves, flicker_data.seed)
			base_intensity = base_intensity * base_intensity_scale
			flicker_data.fade_in = fade_in
		end

		style.color[1] = base_intensity + 15 * intensity_scale

		if progress == 1 and flicker_data.fade_in == 1 then
			content.times_til_next_flicker[content_key] = flicker_min_time_between + math.random() * (flicker_max_time_between - flicker_min_time_between)
		end
	else
		style.color[1] = 255 * (content.flicker_data[content_key].fade_in or 0)
		time_left_til_next_flicker = time_left_til_next_flicker - dt

		if time_left_til_next_flicker < 0 then
			local flicker_data = content.flicker_data[content_key]
			local flicker_time = flicker_min_time + math.random() * (flicker_max_time - flicker_min_time)
			flicker_data.progress_multiplier = 1 / flicker_time
			flicker_data.progress = 0
			flicker_data.seed = math.random_seed()
		end

		content.times_til_next_flicker[content_key] = time_left_til_next_flicker
	end
end

change_functions.player_plaque_background = function (content, style)
	local math_max = math.max
	local hotspot = content.hotspot
	local progress = math_max(hotspot.anim_hover_progress, math_max(hotspot.anim_select_progress, hotspot.anim_focus_progress))
	progress = math.ease_sine(progress)
	local color = style.color or style.text_color
	local default_color = style.default_color
	local hover_color = style.hover_color

	ColorUtilities.color_lerp(default_color, hover_color, progress, color)
end

return settings("SocialMenuRosterViewStyles", social_menu_roster_view_styles)
