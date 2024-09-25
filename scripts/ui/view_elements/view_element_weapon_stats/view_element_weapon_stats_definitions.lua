-- chunkname: @scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")

local function create_definitions(settings)
	local grid_size = settings.grid_size
	local edge_padding = settings.edge_padding or 0
	local hide_dividers = settings.hide_dividers
	local background_size = {
		grid_size[1] + edge_padding,
		grid_size[2],
	}
	local scenegraph_definition = {
		screen = UIWorkspaceSettings.screen,
		pivot = {
			horizontal_alignment = "left",
			parent = "screen",
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
	}

	if not hide_dividers then
		scenegraph_definition.shine_overlay = {
			horizontal_alignment = "top",
			parent = "pivot",
			vertical_alignment = "left",
			size = {
				background_size[1],
				150,
			},
			position = {
				0,
				0,
				0,
			},
		}
		scenegraph_definition.grid_divider_top_weapon = {
			horizontal_alignment = "center",
			parent = "grid_divider_top",
			vertical_alignment = "center",
			size = {
				background_size[1],
				58,
			},
			position = {
				0,
				10,
				5,
			},
		}
		scenegraph_definition.grid_divider_bottom_weapon = {
			horizontal_alignment = "center",
			parent = "grid_divider_bottom",
			vertical_alignment = "center",
			size = {
				background_size[1],
				36,
			},
			position = {
				0,
				0,
				5,
			},
		}
	end

	local widget_definitions = {
		grid_background = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						100,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						-1,
					},
					size_addition = {
						-8,
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
					vertical_alignment = "center",
					size_addition = {
						18,
						16,
					},
					color = Color.terminal_grid_background(255, true),
				},
			},
		}, "grid_background"),
		shine_overlay = UIWidget.create_definition({
			{
				pass_type = "texture_uv",
				style_id = "texture",
				value = "content/ui/materials/effects/button_attention",
				value_id = "texture",
				style = {
					hdr = false,
					horizontal_alignment = "top",
					scale_to_material = true,
					show_overlay = false,
					vertical_alignment = "left",
					offset = {
						edge_padding * 0.25,
						0,
						5,
					},
					size = {
						grid_size[1] + edge_padding * 0.5,
						250,
					},
					material_values = {
						full_color = 1,
						grid = "content/ui/textures/patterns/rasters/raster_screen_06",
						grid_scale = 0.75,
						intensity = 0,
					},
				},
				visibility_function = function (content, style)
					return style.show_overlay
				end,
			},
		}, "shine_overlay"),
	}

	if not hide_dividers then
		widget_definitions.grid_divider_top = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/frames/item_info_upper",
				value_id = "texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
				},
			},
		}, "grid_divider_top")
		widget_definitions.grid_divider_bottom = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/frames/item_info_lower",
				value_id = "texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
				},
			},
		}, "grid_divider_bottom")

		local divider_top_widget_name = "grid_divider_top_weapon"

		widget_definitions[divider_top_widget_name] = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/frames/item_info_upper_slots_2",
				value_id = "texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
				},
			},
			{
				pass_type = "text",
				style_id = "weapon_display_name",
				value = "n/a",
				value_id = "weapon_display_name",
				style = table.merge_recursive(table.clone(UIFontSettings.body), {
					font_size = 24,
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					vertical_alignment = "top",
					offset = {
						15,
						6,
						51,
					},
					size = {
						600,
						25,
					},
					text_color = Color.terminal_icon(255, true),
				}),
			},
			{
				pass_type = "text",
				style_id = "rating_value",
				value = "n/a",
				value_id = "rating_value",
				style = table.merge_recursive(table.clone(UIFontSettings.body), {
					font_size = 24,
					horizontal_alignment = "right",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					vertical_alignment = "top",
					offset = {
						50,
						6,
						51,
					},
					size = {
						200,
						25,
					},
					text_color = Color.terminal_icon(255, true),
				}),
			},
			{
				pass_type = "texture",
				style_id = "glow",
				value = "content/ui/materials/frames/frame_glow_01",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						3,
						-6,
						52,
					},
					size = {
						105,
						50,
					},
					color = Color.terminal_corner_selected(nil, true),
				},
				change_function = function (content, style)
					style.color[1] = 200 + 55 * math.cos(3 * Application.time_since_launch())
				end,
				visibility_function = function (content, style)
					return not not content.show_glow
				end,
			},
			{
				pass_type = "texture",
				style_id = "glow_background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					offset = {
						-8,
						5,
						52,
					},
					size = {
						84,
						30,
					},
					color = Color.terminal_corner_selected(nil, true),
				},
				change_function = function (content, style)
					style.color[1] = 50 + 5 * math.cos(3 * Application.time_since_launch())
				end,
				visibility_function = function (content, style)
					return not not content.show_glow
				end,
			},
		}, divider_top_widget_name)

		local divider_bottom_widget_name = "grid_divider_bottom_weapon"

		widget_definitions[divider_bottom_widget_name] = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/frames/item_info_lower",
				value_id = "texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
				},
			},
		}, divider_bottom_widget_name)
	end

	local animations = {
		on_expertise_upgrade = {
			{
				end_time = 0.3,
				name = "fade_in",
				start_time = 0,
				init = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
					widgets.shine_overlay.style.texture.show_overlay = true
				end,
				update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
					widgets.shine_overlay.style.texture.color[1] = 255 * progress
				end,
			},
			{
				end_time = 0.8,
				name = "intensity",
				start_time = 0,
				update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
					widgets.shine_overlay.style.texture.material_values.intensity = 1 - math.ease_sine(progress)
				end,
			},
			{
				end_time = 0.8,
				name = "fade_out",
				start_time = 0.3,
				update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
					widgets.shine_overlay.style.texture.color[1] = 255 - 255 * math.easeOutCubic(progress)

					if progress >= 1 and widgets.shine_overlay.style.texture.show_overlay then
						widgets.shine_overlay.style.texture.show_overlay = false
					end
				end,
			},
		},
	}

	return {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
		animations = animations,
	}
end

return create_definitions
