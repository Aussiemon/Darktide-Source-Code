-- chunkname: @scripts/ui/constant_elements/elements/mission_buffs/constant_element_mission_buffs_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			3
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			100,
			0
		}
	},
	sub_title = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			160,
			0
		}
	},
	buffs_area = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	buff = {
		vertical_alignment = "center",
		parent = "buffs_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	}
}
local title_style = {
	horizontal_alignment = "center",
	font_size = 46,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "machine_medium",
	text_color = Color.terminal_text_header(255, true),
	offset = {
		0,
		0,
		1
	},
	size_addition = {
		20,
		20
	}
}
local sub_title_style = table.clone(title_style)

sub_title_style.font_size = 28

local widget_definitions = {
	title = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = title_style
		},
		{
			value_id = "text_background",
			style_id = "text_background",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.white(153, true),
				size_addition = {
					0,
					0
				},
				material_values = {
					texture_map = "content/ui/textures/masks/gradient_radial_invert"
				}
			},
			visibility_function = function (content, style)
				return not content.show_background and content.text and content.text ~= ""
			end
		},
		{
			style_id = "text_background_terminal",
			value_id = "text_background_terminal",
			pass_type = "texture",
			value = "content/ui/materials/hud/backgrounds/location_update",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				size = {
					650,
					90
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.terminal_text_body(255, true),
				material_values = {
					distortion = 1
				}
			},
			visibility_function = function (content, style)
				return content.show_background and content.text and content.text ~= ""
			end
		}
	}, "title"),
	sub_title = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = sub_title_style
		},
		{
			value_id = "text_background",
			style_id = "text_background",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.white(153, true),
				size_addition = {
					0,
					0
				},
				material_values = {
					texture_map = "content/ui/textures/masks/gradient_radial_invert"
				}
			},
			visibility_function = function (content, style)
				return content.text and content.text ~= ""
			end
		}
	}, "sub_title")
}
local animations = {
	on_buff_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					params.start_buff_height = {}
					params.end_buff_height = {}
					params.start_buff_offset = {}
					params.end_buff_offset = {}

					local buffs_size = #params.buff_widgets

					for i = 1, buffs_size do
						local widget = params.buff_widgets[i]

						params.start_buff_height[i] = 0
						params.end_buff_height[i] = widget.content.size[2]
						params.start_buff_offset[i] = widget.offset[2] + widget.content.size[2] * 0.5
						widget.content.size[2] = params.start_buff_height[i]
						params.end_buff_offset[i] = widget.offset[2]
						widget.offset[2] = params.start_buff_offset[i]

						local style = widget.style

						style.icon.color[1] = 0
						style.title.text_color[1] = 0
						style.sub_title.text_color[1] = 0
						style.description.text_color[1] = 0
						widget.alpha_multiplier = 0
					end

					Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_enter)

					if buffs_size == 1 then
						parent:_play_buff_acquired_sounds()
					end
				end
			end
		},
		{
			name = "open",
			end_time = 0.4,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]
						local offset_diff = params.start_buff_offset[i] - params.end_buff_offset[i]

						widget.offset[2] = params.start_buff_offset[i] - anim_progress * offset_diff

						local height_diff = params.start_buff_height[i] - params.end_buff_height[i]

						widget.content.size[2] = params.start_buff_height[i] - anim_progress * height_diff
						widget.alpha_multiplier = anim_progress
					end
				end
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]
						local offset_diff = params.start_buff_offset[i] - params.end_buff_offset[i]

						widget.offset[2] = params.start_buff_offset[i] - offset_diff

						local height_diff = params.start_buff_height[i] - params.end_buff_height[i]

						widget.content.size[2] = params.start_buff_height[i] - height_diff
						widget.alpha_multiplier = 1
					end
				end
			end
		},
		{
			name = "fade_in_text",
			end_time = 0.4,
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				if params.buff_widgets then
					local anim_progress = math.easeOutCubic(progress)

					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]
						local style = widget.style

						style.icon.color[1] = anim_progress * 255
						style.title.text_color[1] = anim_progress * 255
						style.sub_title.text_color[1] = anim_progress * 255
						style.description.text_color[1] = anim_progress * 255
					end
				end
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]
						local style = widget.style

						style.icon.color[1] = 255
						style.title.text_color[1] = 255
						style.sub_title.text_color[1] = 255
						style.description.text_color[1] = 255
					end
				end
			end
		}
	},
	on_buff_exit = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					params.start_buff_height = {}
					params.end_buff_height = {}
					params.start_buff_offset = {}
					params.end_buff_offset = {}

					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						params.start_buff_height[i] = widget.content.size[2]
						params.end_buff_height[i] = 0
						params.start_buff_offset[i] = widget.offset[2]
						params.end_buff_offset[i] = widget.offset[2] + widget.content.size[2] * 0.5

						local style = widget.style

						style.icon.color[1] = 255
						style.title.text_color[1] = 255
						style.sub_title.text_color[1] = 255
						style.description.text_color[1] = 255
					end

					Managers.ui:play_2d_sound(UISoundEvents.mission_buffs_exit)
				end
			end
		},
		{
			name = "fade_out_text",
			end_time = 0.4,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						if not widget.content.is_chosen_buff then
							local style = widget.style

							style.icon.color[1] = (1 - anim_progress) * 255
							style.title.text_color[1] = (1 - anim_progress) * 255
							style.sub_title.text_color[1] = (1 - anim_progress) * 255
							style.description.text_color[1] = (1 - anim_progress) * 255
						end
					end
				end
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						if not widget.content.is_chosen_buff then
							local style = widget.style

							style.icon.color[1] = 0
							style.title.text_color[1] = 0
							style.sub_title.text_color[1] = 0
							style.description.text_color[1] = 0
						end
					end
				end
			end
		},
		{
			name = "close_buff",
			end_time = 0.4,
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				if params.buff_widgets then
					local anim_progress = math.easeOutCubic(progress)

					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						if not widget.content.is_chosen_buff then
							local offset_diff = params.start_buff_offset[i] - params.end_buff_offset[i]

							widget.offset[2] = params.start_buff_offset[i] - anim_progress * offset_diff

							local height_diff = params.start_buff_height[i] - params.end_buff_height[i]

							widget.content.size[2] = params.start_buff_height[i] - anim_progress * height_diff
							widget.alpha_multiplier = 1 - anim_progress
						end
					end
				end
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						if not widget.content.is_chosen_buff then
							local offset_diff = params.start_buff_offset[i] - params.end_buff_offset[i]

							widget.offset[2] = params.start_buff_offset[i] - offset_diff

							local height_diff = params.start_buff_height[i] - params.end_buff_height[i]

							widget.content.size[2] = 0
							widget.alpha_multiplier = 0
						end
					end
				end
			end
		},
		{
			name = "fade_selected_buff",
			end_time = 0.8,
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				if params.buff_widgets then
					local anim_progress = math.easeOutCubic(progress)

					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						if widget.content.is_chosen_buff then
							widget.alpha_multiplier = 1 - anim_progress

							break
						end
					end
				end
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if params.buff_widgets then
					for i = 1, #params.buff_widgets do
						local widget = params.buff_widgets[i]

						if widget.content.is_chosen_buff then
							widget.alpha_multiplier = 0

							break
						end
					end
				end
			end
		}
	},
	on_text_enter = {
		{
			name = "open",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.title.alpha_multiplier = 0
				widgets.sub_title.style.alpha_multiplier = 0

				if parent._context and parent._context.state and parent._context.state == "completed" and not parent._context.buffs and parent._context.is_wave_title then
					Managers.ui:play_2d_sound(UISoundEvents.horde_wave_completed)
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.title.alpha_multiplier = anim_progress
				widgets.sub_title.alpha_multiplier = anim_progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.title.alpha_multiplier = 1
				widgets.sub_title.alpha_multiplier = 1
			end
		},
		{
			name = "animate_background",
			end_time = 1,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local widget = widgets.title

				widget.style.text_background_terminal.material_values.distortion = 1
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.clamp(math.ease_out_exp(math.bounce(progress)), 0, 1)
				local widget = widgets.title

				widget.style.text_background_terminal.material_values.distortion = 0.1 + (1 - progress) * 0.9
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local widget = widgets.title

				widget.style.text_background_terminal.material_values.distortion = 0.1
			end
		}
	},
	on_text_exit = {
		{
			name = "animate_background",
			end_time = 1,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local widget = widgets.title

				widget.style.text_background_terminal.material_values.distortion = 0.1
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.clamp(math.ease_out_exp(math.bounce(progress)), 0, 1)
				local widget = widgets.title

				widget.style.text_background_terminal.material_values.distortion = 0.1 + progress * 0.9
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local widget = widgets.title

				widget.style.text_background_terminal.material_values.distortion = 1
			end
		},
		{
			name = "close",
			end_time = 1,
			start_time = 0.7,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.title.alpha_multiplier = 1
				widgets.sub_title.alpha_multiplier = 1
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.title.alpha_multiplier = 1 - progress
				widgets.sub_title.alpha_multiplier = 1 - progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.title.alpha_multiplier = 0
				widgets.sub_title.alpha_multiplier = 0
			end
		}
	}
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	animations = animations
}
