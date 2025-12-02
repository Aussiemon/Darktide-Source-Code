-- chunkname: @scripts/ui/views/broker_stimm_builder_view/broker_stimm_builder_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
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
	layout_background = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			256,
			256,
		},
		position = {
			0,
			0,
			1,
		},
	},
	talent = {
		horizontal_alignment = "left",
		parent = "layout_background",
		vertical_alignment = "top",
		size = {
			110,
			110,
		},
		position = {
			0,
			0,
			5,
		},
	},
	gamepad_cursor_pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1,
			1,
		},
		position = {
			0,
			0,
			500,
		},
	},
	gamepad_cursor = {
		horizontal_alignment = "center",
		parent = "gamepad_cursor_pivot",
		vertical_alignment = "center",
		size = {
			80,
			125,
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local overlay_scenegraph_definition = {
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
	scroll_background = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			256,
			256,
		},
		position = {
			0,
			0,
			0,
		},
	},
	tooltip = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			400,
			400,
		},
		position = {
			0,
			0,
			130,
		},
	},
	info_banner = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			402,
			658,
		},
		position = {
			60,
			270,
			10,
		},
	},
	specialization_talents_resource = {
		horizontal_alignment = "center",
		parent = "info_banner",
		vertical_alignment = "top",
		size = {
			400,
			50,
		},
		position = {
			0,
			130,
			10,
		},
	},
	summary_header = {
		horizontal_alignment = "center",
		parent = "info_banner",
		vertical_alignment = "top",
		size = {
			300,
			50,
		},
		position = {
			0,
			320,
			10,
		},
	},
}
local widget_definitions = {
	input_surface = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size_addition = {
					0,
					-160,
				},
				offset = {
					0,
					100,
					10,
				},
			},
		},
	}, "screen"),
	tooltip = UIWidget.create_definition({
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
		{
			pass_type = "text",
			style_id = "level_counter",
			value = "",
			value_id = "level_counter",
			style = {
				font_size = 16,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "right",
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
		{
			pass_type = "text",
			style_id = "next_level_title",
			value = "",
			value_id = "next_level_title",
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
				color = {
					100,
					0,
					0,
					255,
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
			style_id = "next_level_description",
			value = "",
			value_id = "next_level_description",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = Color.terminal_text_body(200, true),
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
			style_id = "exculsive_group_description",
			value = "",
			value_id = "exculsive_group_description",
			style = {
				font_size = 18,
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
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "requirement_title",
			value = "n/a",
			value_id = "requirement_title",
			style = {
				font_size = 16,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = {
					255,
					142,
					60,
					60,
				},
				size = {
					nil,
					0,
				},
				color = {
					100,
					0,
					0,
					255,
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
			style_id = "requirement_description",
			value = "n/a",
			value_id = "requirement_description",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = {
					255,
					198,
					83,
					83,
				},
				size = {
					nil,
					0,
				},
				color = {
					255,
					159,
					67,
					67,
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
			style_id = "input_text",
			value = "",
			value_id = "input_text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				original_text_color = Color.text_default(255, true),
				cant_interact_color = Color.text_cant_afford(255, true),
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
			style_id = "cost_text",
			value = "",
			value_id = "cost_text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				text_color = Color.text_default(255, true),
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
			pass_type = "rect",
			style_id = "requirement_background",
			style = {
				vertical_alignment = "top",
				size = {
					nil,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
				color = {
					150,
					35,
					0,
					0,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "input_background",
			style = {
				vertical_alignment = "top",
				size = {
					nil,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
	}, "tooltip"),
	scroll_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talents_bg",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "scroll_background", nil, nil),
	screen_effects = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/masks/gradient_vignette",
			style = {
				horizontal_alignment = "center",
				scenegraph_scale = "fit",
				vertical_alignment = "top",
				size = {
					1920,
				},
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/base/ui_gradient_base",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					130,
				},
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					0,
					-20,
					25,
				},
				material_values = {
					offset = 0.8,
					uv_rotation = 0.25,
					color_2 = {
						0,
						0,
						0,
						0,
					},
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/base/ui_gradient_base",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					60,
				},
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					25,
				},
				material_values = {
					offset = 0.8,
					uv_rotation = 0.75,
					color_2 = {
						0,
						0,
						0,
						0,
					},
				},
			},
		},
	}, "screen"),
	info_banner = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "badge",
			value = "content/ui/materials/icons/class_badges/container",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {
					badge = "content/ui/textures/icons/class_badges/broker_01_01",
					effect_progress = 0,
				},
				size = {
					380,
					228,
				},
				offset = {
					0,
					-300,
					5,
				},
				size_addition = {
					0,
					0,
				},
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local effect_progress = material_values.effect_progress

				if content.play_badge_effect_anim then
					content.play_badge_effect_anim = false
					effect_progress = 0
				end

				if effect_progress < 1 then
					local selection_anim_speed = 1.5

					effect_progress = effect_progress + dt * selection_anim_speed
					material_values.effect_progress = math.min(effect_progress, 1)

					local size_addition = style.size_addition
					local size_increase_value = 5
					local size_anim_value = -size_increase_value + math.min(math.ease_pulse(effect_progress), 1) * size_increase_value

					size_addition[1] = size_anim_value
					size_addition[2] = size_anim_value
				end
			end,
		},
		{
			pass_type = "texture",
			style_id = "background_2",
			value = "content/ui/materials/frames/talents/stimm_info_banner",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				offset = {
					0,
					0,
					1,
				},
				color = Color.white(255, true),
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				size = {
					310,
					560,
				},
				offset = {
					0,
					40,
					0,
				},
				size_addition = {
					24,
					24,
				},
				color = Color.terminal_grid_background(nil, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "separator",
			value = "content/ui/materials/frames/talents/info_banner_separator",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				size = {
					254,
					14,
				},
				offset = {
					0,
					280,
					0,
				},
				color = Color.white(255, true),
				size_addition = {
					0,
					0,
				},
			},
		},
	}, "info_banner"),
	summary_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "viscocity_title",
			value_id = "viscocity_title",
			style = {
				font_size = 22,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					10,
					1,
				},
			},
			value = Localize("loc_stimm_lab_viscosity"),
		},
		{
			pass_type = "text",
			style_id = "viscocity_text",
			value = "0%",
			value_id = "viscocity_text",
			style = {
				font_size = 30,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header_selected(255, true),
				offset = {
					0,
					60,
					1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "cooldown_title",
			value_id = "cooldown_title",
			style = {
				font_size = 22,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					110,
					1,
				},
			},
			value = Localize("loc_stimm_lab_cooldown"),
		},
		{
			pass_type = "text",
			style_id = "cooldown_text",
			value = "0s",
			value_id = "cooldown_text",
			style = {
				font_size = 30,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header_selected(255, true),
				offset = {
					0,
					160,
					1,
				},
			},
		},
	}, "summary_header"),
	specialization_talents_resource = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title_text",
			value_id = "title_text",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			value = Localize("loc_stimm_lab_volume"),
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "0/0",
			value_id = "text",
			style = {
				font_size = 62,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header_selected(255, true),
				offset = {
					0,
					50,
					1,
				},
			},
		},
	}, "specialization_talents_resource"),
}
local color_cursor = {
	255,
	255,
	255,
	255,
}
local layout_widget_definitions = {
	layout_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/stimm_bg",
			value_id = "image",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					1696,
					1074,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					138,
					0,
					0,
				},
			},
		},
	}, "layout_background"),
	gamepad_cursor = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "glow",
			value = "content/ui/materials/cursors/talent_tree_gamepad_cursor",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = color_cursor,
				offset = {
					0,
					0,
					5,
				},
				size_addition = {
					20,
					20,
				},
			},
		},
	}, "gamepad_cursor"),
}
local animations = {}
local definitions = {
	animations = animations,
	widget_definitions = widget_definitions,
	layout_widget_definitions = layout_widget_definitions,
	scenegraph_definition = scenegraph_definition,
	overlay_scenegraph_definition = overlay_scenegraph_definition,
}
local node_definitions = require("scripts/ui/views/talent_builder_view/talent_builder_view_node_definitions")

table.merge(definitions, node_definitions)

return definitions
