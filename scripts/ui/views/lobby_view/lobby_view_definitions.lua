-- chunkname: @scripts/ui/views/lobby_view/lobby_view_definitions.lua

local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local LobbyViewFontStyle = require("scripts/ui/views/lobby_view/lobby_view_font_style")
local ColorUtilities = require("scripts/utilities/ui/colors")
local item_stats_grid_settings

do
	local padding = 12
	local width, height = 530, 920

	item_stats_grid_settings = {
		ignore_blur = true,
		scrollbar_width = 7,
		title_height = 70,
		grid_spacing = {
			0,
			0,
		},
		grid_size = {
			width - padding,
			height,
		},
		mask_size = {
			width + 40,
			height,
		},
		edge_padding = padding,
	}
end

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	canvas_height = {
		horizontal_alignment = "center",
		scale = "fit_height",
		size = {
			1920,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	grid_background = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = LobbyViewSettings.grid_size,
		position = {
			-275,
			-170,
			1,
		},
	},
	grid_start = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "right",
		parent = "grid_start",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	mission_title = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1200,
			100,
		},
		position = {
			100,
			65,
			1,
		},
	},
	havoc_title = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1200,
			100,
		},
		position = {
			700,
			-200,
			1,
		},
	},
	havoc_pivot = {
		horizontal_alignment = "center",
		parent = "havoc_title",
		vertical_alignment = "bottom",
		size = LobbyViewSettings.panel_size,
		position = {
			0,
			0,
			1,
		},
	},
	panel_pivot = {
		horizontal_alignment = "left",
		parent = "canvas_height",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			-120,
			1,
		},
	},
	panel = {
		horizontal_alignment = "center",
		parent = "panel_pivot",
		vertical_alignment = "bottom",
		size = LobbyViewSettings.panel_size,
		position = {
			0,
			0,
			1,
		},
	},
	loading_pivot = {
		horizontal_alignment = "left",
		parent = "canvas_height",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			-250,
			1,
		},
	},
	loading = {
		horizontal_alignment = "center",
		parent = "loading_pivot",
		vertical_alignment = "center",
		size = LobbyViewSettings.loading_size,
		position = {
			0,
			0,
			1,
		},
	},
	loadout_pivot = {
		horizontal_alignment = "left",
		parent = "canvas_height",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			-120,
			1,
		},
	},
	loadout = {
		horizontal_alignment = "center",
		parent = "loadout_pivot",
		vertical_alignment = "bottom",
		size = LobbyViewSettings.loadout_size,
		position = {
			0,
			180,
			1,
		},
	},
	inspect_button_pivot = {
		horizontal_alignment = "left",
		parent = "canvas_height",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			-120,
			1,
		},
	},
	inspect_button = {
		horizontal_alignment = "center",
		parent = "inspect_button_pivot",
		vertical_alignment = "center",
		size = LobbyViewSettings.inspect_button_size,
		position = {
			0,
			0,
			1,
		},
	},
	talent_tooltip = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			400,
			110,
		},
		position = {
			0,
			0,
			63,
		},
	},
	item_stats_pivot = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			3,
		},
	},
}
local widget_definitions = {
	talent_tooltip = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					220,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = Color.terminal_background(nil, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_background_gradient(180, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(nil, true),
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "n/a",
			value_id = "title",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				color = {
					100,
					255,
					200,
					50,
				},
				size = {
					nil,
					0,
				},
				offset = {
					0,
					0,
					5,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "n/a",
			value_id = "description",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = Color.terminal_text_body(255, true),
				size = {
					nil,
					0,
				},
				offset = {
					0,
					0,
					5,
				},
				color = {
					100,
					100,
					255,
					0,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "talent_type_title",
			value = "",
			value_id = "talent_type_title",
			style = {
				font_size = 16,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = Color.terminal_text_body_sub_header(255, true),
				size = {
					nil,
					0,
				},
				offset = {
					0,
					0,
					5,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
	}, "talent_tooltip", {
		visible = false,
	}),
	mission_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title",
			value = "n/a",
			value_id = "title",
			style = LobbyViewFontStyle.title_text_style,
		},
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style = {
				vertical_alignment = "center",
				size = {
					1200,
					18,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "sub_title",
			value = "n/a",
			value_id = "sub_title",
			style = LobbyViewFontStyle.sub_title_text_style,
		},
	}, "mission_title"),
	havoc_title = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "havoc_icon",
			value = "content/ui/materials/icons/generic/havoc",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				color = Color.golden_rod(255, true),
				offset = {
					143,
					16,
					11,
				},
				size = {
					50,
					50,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "havoc_icon_drop_shadow",
			value = "content/ui/materials/icons/generic/havoc",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				color = Color.black(255, true),
				offset = {
					144,
					16,
					10,
				},
				size = {
					50,
					50,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "havoc_rank",
			value = "~",
			value_id = "havoc_rank",
			style = {
				font_size = 40,
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				offset = {
					203,
					21,
					10,
				},
				text_color = Color.golden_rod(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style = {
				vertical_alignment = "center",
				size = {
					430,
					20,
				},
				offset = {
					11,
					-44,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "divider_02",
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			style = {
				vertical_alignment = "center",
				size = {
					200,
					30,
				},
				offset = {
					125,
					-50,
					4,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "divider_03",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				scale_to_material = true,
				color = Color.terminal_grid_background_gradient(255, true),
				size = {
					440,
					510,
				},
				offset = {
					5,
					-5,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "divider_04",
			value = "content/ui/materials/frames/dropshadow_heavy",
			style = {
				color = {
					255,
					169,
					191,
					153,
				},
				size = {
					425,
					500,
				},
				offset = {
					13,
					0,
					2,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				color = {
					84,
					169,
					191,
					153,
				},
				offset = {
					20,
					0,
					1,
				},
				size = {
					410,
					500,
				},
			},
		},
	}, "havoc_title"),
	grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "grid_background"),
	metal_corners = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/lobby_01_lower",
			style = {
				vertical_alignment = "bottom",
				size = {
					120,
					240,
				},
				offset = {
					0,
					0,
					62,
				},
				color = Color.white(255, true),
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/lobby_01_lower",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				size = {
					120,
					240,
				},
				offset = {
					0,
					0,
					62,
				},
				color = Color.white(255, true),
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/lobby_01_upper",
			style = {
				vertical_alignment = "top",
				size = {
					210,
					390,
				},
				offset = {
					0,
					0,
					62,
				},
				color = Color.white(255, true),
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/lobby_01_upper",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					210,
					390,
				},
				offset = {
					0,
					0,
					62,
				},
				color = Color.white(255, true),
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
	}, "screen"),
}

for i = 1, 4 do
	local name = "havoc_circumstance_0" .. i

	widget_definitions[name] = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/generic/danger",
			value_id = "icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				color = Color.golden_rod(255, true),
				offset = {
					29,
					82,
					5,
				},
				size = {
					30,
					30,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "circumstance_name",
			value_id = "circumstance_name",
			style = {
				font_size = 20,
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				size = {
					355,
					20,
				},
				offset = {
					63,
					87,
					10,
				},
				text_color = Color.golden_rod(255, true),
			},
		},
		{
			pass_type = "text",
			style_id = "circumstance_description",
			value_id = "circumstance_description",
			style = {
				font_size = 17,
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				size = {
					393,
					52,
				},
				offset = {
					29,
					120,
					10,
				},
				text_color = {
					255,
					169,
					191,
					153,
				},
			},
		},
	}, "havoc_title")
end

local panel_definition = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = {
			disabled = true,
			use_is_focused = true,
		},
	},
	{
		pass_type = "texture",
		style_id = "character_portrait",
		value = "content/ui/materials/base/ui_portrait_frame_base",
		value_id = "character_portrait",
		style = {
			horizontal_alignment = "center",
			material_values = {
				texture_icon = "content/ui/textures/icons/items/frames/default",
				use_placeholder_texture = 1,
			},
			size = {
				90,
				100,
			},
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/checkmark",
		style = {
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			size = {
				24,
				24,
			},
			offset = {
				0,
				35,
				2,
			},
			color = Color.ui_terminal(255, true),
		},
		visibility_function = function (content, style)
			return content.is_ready
		end,
	},
	{
		pass_type = "texture",
		style_id = "character_insignia",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "character_insignia",
		style = {
			horizontal_alignment = "center",
			size = {
				40,
				100,
			},
			offset = {
				-65,
				0,
				2,
			},
			material_values = {},
			color = {
				0,
				255,
				255,
				255,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "character_name",
		value = "",
		value_id = "character_name",
		style = LobbyViewFontStyle.character_name_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
	},
	{
		pass_type = "text",
		style_id = "character_archetype_title",
		value = "",
		value_id = "character_archetype_title",
		style = LobbyViewFontStyle.character_archetype_title_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
	},
	{
		pass_type = "text",
		style_id = "character_title",
		value = "",
		value_id = "character_title",
		style = LobbyViewFontStyle.character_title_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
	},
	{
		pass_type = "texture",
		style_id = "guild_divider",
		value = "content/ui/materials/dividers/skull_rendered_center_01",
		style = {
			horizontal_alignment = "center",
			size = {
				140,
				18,
			},
			offset = {
				0,
				165,
				0,
			},
		},
		visibility_function = function (content, style)
			return content.has_guild
		end,
	},
	{
		pass_type = "text",
		style_id = "guild_name",
		value = "",
		value_id = "guild_name",
		style = LobbyViewFontStyle.guild_name_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
		visibility_function = function (content, style)
			return content.has_guild
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/frames/hover",
		style = {
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.ui_terminal(255, true),
			size_addition = {
				30,
				15,
			},
			offset = {
				0,
				0,
				0,
			},
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_focus_progress, content.hotspot.anim_select_progress)

			style.color[1] = anim_progress * 255

			local size_addition = style.size_addition
			local size_padding = 30 - math.easeInCubic(anim_progress) * 15

			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end,
	},
	{
		pass_type = "texture",
		style_id = "background_selected",
		value = "content/ui/materials/buttons/background_selected",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				0,
			},
			size_addition = {
				10,
				5,
			},
		},
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end,
	},
	{
		pass_type = "text",
		style_id = "character_inspect",
		value = "",
		value_id = "character_inspect",
		style = LobbyViewFontStyle.inspect_text_style,
		change_function = function (content, style)
			local text_color = style.text_color
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local highlight_color = style.hover_color
			local hover_progress = math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress)
			local ignore_alpha = true

			ColorUtilities.color_lerp(default_color, highlight_color, hover_progress, text_color, ignore_alpha)
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end,
	},
}, "panel")
local loading_definition = UIWidget.create_definition({
	{
		pass_type = "rotated_texture",
		value = "content/ui/materials/symbols/cog_big",
		style = {
			color = Color.ui_chalk_grey(255, true),
		},
		change_function = function (content, style)
			local progress = -(Application.time_since_launch() * 0.3) % 1

			style.angle = math.pi * 2 * progress
		end,
	},
	{
		pass_type = "rotated_texture",
		value = "content/ui/materials/symbols/cog_small",
		style = {
			size = {
				51,
				51,
			},
			offset = {
				43,
				-40,
				0,
			},
			color = Color.ui_chalk_grey(255, true),
		},
		change_function = function (content, style)
			local progress = Application.time_since_launch() * 0.45 % 1

			style.angle = math.pi * 2 * progress
		end,
	},
	{
		pass_type = "text",
		style_id = "loading_text",
		value_id = "loading_text",
		value = Managers.localization:localize("loc_lobby_finding_player"),
		style = LobbyViewFontStyle.loading_text_style,
	},
}, "loading")
local tooltip_visibility_on = "loc_lobby_legend_tooltip_visibility_on"
local tooltip_visibility_off = "loc_lobby_legend_tooltip_visibility_off"
local show_weapon = "loc_lobby_legend_weapons_show"
local hide_weapon = "loc_lobby_legend_talents_show"
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_main_menu",
		input_action = "close_view",
		on_pressed_callback = "cb_on_open_main_menu_pressed",
		visibility_function = function (parent)
			return not parent._is_main_menu_open
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_input_legend_inventory",
		input_action = "lobby_open_inventory",
		on_pressed_callback = "cb_on_inventory_pressed",
	},
	{
		alignment = "right_alignment",
		input_action = "lobby_switch_loadout",
		on_pressed_callback = "cb_on_loadout_pressed",
		display_name = show_weapon,
		visibility_function = function (parent, id)
			local display_name = parent._show_weapons and hide_weapon or show_weapon

			parent._input_legend_element:set_display_name(id, display_name)

			return true
		end,
	},
	{
		alignment = "right_alignment",
		input_action = "talents_summery_overview_pressed",
		on_pressed_callback = "cb_on_trigger_gamepad_tooltip_navigation_pressed",
		display_name = tooltip_visibility_on,
		visibility_function = function (parent, id)
			local display_name = parent._use_gamepad_tooltip_navigation and tooltip_visibility_off or tooltip_visibility_on

			parent._input_legend_element:set_display_name(id, display_name)

			return not parent._using_cursor_navigation
		end,
	},
}

return {
	legend_inputs = legend_inputs,
	loading_definition = loading_definition,
	panel_definition = panel_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	item_stats_grid_settings = item_stats_grid_settings,
	havoc_circumstance = widget_definitions.havoc_circumstance,
}
