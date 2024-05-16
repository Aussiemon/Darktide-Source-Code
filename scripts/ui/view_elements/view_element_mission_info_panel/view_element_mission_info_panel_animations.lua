-- chunkname: @scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_animations.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local animations = {}

animations.sequence_animations = {}

local _mission_info_panel_widgets = {
	"panel",
	"panel_scrollbar",
	"list_interaction",
	"list_mask",
	"mission_header",
}

animations.sequence_animations.resize_mission_window = {
	{
		end_time = 0.2,
		name = "fade_in_panel",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local panel_widget = widgets_by_name.panel

			params.original_alpha = panel_widget.alpha_multiplier or 0

			local fade_in_widgets = params.fade_in_widgets

			if not fade_in_widgets then
				fade_in_widgets = {}

				local widget_names = _mission_info_panel_widgets

				for i = 1, #widget_names do
					local name = widget_names[i]
					local widget = widgets_by_name[name]

					fade_in_widgets[#fade_in_widgets + 1] = widget
				end

				params.fade_in_widgets = fade_in_widgets
			end

			for i = 1, #fade_in_widgets do
				fade_in_widgets[i].visible = true
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local eased_progress = math.ease_exp(progress)
			local alpha_multiplier = math.lerp(params.original_alpha, 1, eased_progress)
			local widgets = params.fade_in_widgets

			for i = 1, #widgets do
				widgets[i].alpha_multiplier = alpha_multiplier
			end
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local widgets = params.fade_in_widgets

			for i = 1, #widgets do
				widgets[i].alpha_multiplier = 1
			end
		end,
	},
	{
		end_time = 0.3,
		name = "change_background_color",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local color_copy = ColorUtilities.color_copy

			if not params.start_background_color then
				params.start_background_color = {}
				params.start_frame_color = {}
				params.target_frame_color = {}
			end

			local panel_widget = widgets_by_name.panel

			panel_widget.content.can_flash = false

			local panel_style = panel_widget.style
			local background_style = panel_style.background

			color_copy(background_style.color, params.start_background_color)

			local frame_style = panel_style.event_frame

			color_copy(frame_style.color, params.start_frame_color)

			local frame_top_regular_style = panel_style.frame_top_regular
			local frame_top_event_style = panel_style.frame_top_event
			local frame_top_red_style = panel_style.frame_top_red

			params.start_regular_divider_alpha = panel_style.frame_top_regular.color[1]
			params.start_event_divider_alpha = panel_style.frame_top_event.color[1]
			params.start_red_divider_alpha = panel_style.frame_top_red.color[1]

			local target_background_color
			local target_frame_color = params.target_frame_color
			local flags = params.flags

			if flags.locked then
				target_background_color = background_style.color_locked

				color_copy(target_background_color, target_frame_color)

				target_frame_color[1] = 0
				panel_style.frame_top_red.visible = true
				params.target_event_divider_alpha = 0
				params.target_red_divider_alpha = frame_top_red_style.anim_lower_alpha
				params.target_regular_divider_alpha = 0
			elseif flags.flash then
				panel_style.event_frame.visible = true
				panel_style.frame_top_red.visible = true
				target_background_color = background_style.color_flash

				color_copy(frame_style.color_flash, target_frame_color)

				params.target_event_divider_alpha = 0
				params.target_red_divider_alpha = frame_top_red_style.anim_lower_alpha
				params.target_regular_divider_alpha = 0
			elseif flags.happening_mission then
				panel_style.frame_top_event.visible = true
				target_background_color = background_style.color_event

				color_copy(frame_style.color_event, target_frame_color)

				params.target_event_divider_alpha = frame_top_event_style.anim_lower_alpha
				params.target_red_divider_alpha = 0
				params.target_regular_divider_alpha = 0
			elseif flags.circumstance then
				target_background_color = background_style.color_circumstance

				color_copy(target_background_color, target_frame_color)

				target_frame_color[1] = 0
				params.target_event_divider_alpha = 0
				params.target_red_divider_alpha = 0
				params.target_regular_divider_alpha = frame_top_regular_style.anim_lower_alpha
			else
				target_background_color = background_style.color_normal

				color_copy(target_background_color, target_frame_color)

				target_frame_color[1] = 0
				params.target_event_divider_alpha = 0
				params.target_red_divider_alpha = 0
				params.target_regular_divider_alpha = frame_top_regular_style.anim_lower_alpha
			end

			params.target_background_color = target_background_color
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local lerp = math.lerp
			local color_lerp = ColorUtilities.color_lerp
			local eased_progress = math.ease_exp(progress)
			local panel_widget = widgets_by_name.panel
			local panel_style = panel_widget.style
			local background_style = panel_style.background
			local start_background_color = params.start_background_color
			local target_background_color = params.target_background_color

			color_lerp(start_background_color, target_background_color, eased_progress, background_style.color, true)

			local frame_style = panel_style.event_frame
			local start_frame_color = params.start_frame_color
			local target_frame_color = params.target_frame_color

			color_lerp(start_frame_color, target_frame_color, eased_progress, frame_style.color)

			panel_style.frame_top_event.color[1] = lerp(params.start_event_divider_alpha, params.target_event_divider_alpha, eased_progress)
			panel_style.frame_top_red.color[1] = lerp(params.start_red_divider_alpha, params.target_red_divider_alpha, eased_progress)
			panel_style.frame_top_regular.color[1] = lerp(params.start_regular_divider_alpha, params.target_regular_divider_alpha, eased_progress)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local flags = params.flags
			local flag_locked = flags.locked or false
			local flag_flash = flags.flash or false
			local flag_happening = flags.happening_mission or false
			local panel_widget = widgets_by_name.panel
			local panel_content = panel_widget.content

			panel_content.flash_mission = flag_flash and not flag_locked
			panel_content.can_flash = true

			local panel_style = panel_widget.style

			panel_style.event_frame.visible = flag_happening or flag_flash and not flag_locked
			panel_style.frame_top_red.visible = flag_flash or flag_locked
			panel_style.frame_top_event.visible = flag_happening and not flag_flash and not flag_locked
			panel_style.frame_top_regular.visible = not flag_flash and not flag_locked and not flag_happening
		end,
	},
	{
		end_time = 0.4,
		name = "resize",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			params.start_heights = params.start_heights or {}

			table.clear(params.start_heights)

			local start_heights = params.start_heights
			local target_heights = params.target_heights

			for scenegraph_id, target_height in pairs(target_heights) do
				local start_height = ui_scenegraph[scenegraph_id].size[2]

				if start_height ~= target_height then
					start_heights[scenegraph_id] = start_height
				end
			end

			Managers.ui:play_2d_sound(UISoundEvents.mission_board_show_details)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local start_heights = params.start_heights
			local target_heights = params.target_heights
			local anim_progress = math.easeCubic(progress)

			for scenegraph_id, start_height in pairs(start_heights) do
				local target_height = target_heights[scenegraph_id]
				local height = math.lerp(start_height, target_height, anim_progress)

				ui_scenegraph[scenegraph_id].size[2] = height
			end

			local mission_header_widget = widgets_by_name.mission_header
			local mission_header_style = mission_header_widget.style
			local image_style = mission_header_style.zone_image
			local mission_header_target_height = mission_header_style.size[2]
			local mission_header_height = ui_scenegraph.panel_header.size[2]
			local old_mission_header_widget = widgets_by_name.mission_header
			local old_header_image_style = old_mission_header_widget.style.zone_image

			if mission_header_height < mission_header_target_height then
				local normalized_height = mission_header_height / mission_header_target_height

				image_style.uvs[2][2] = normalized_height
				old_header_image_style.uvs[2][2] = normalized_height
			else
				image_style.uvs[2][2] = 1
				old_header_image_style.uvs[2][2] = 1
			end

			ui_scenegraph.info_area.position[2] = mission_header_height

			return true
		end,
	},
	{
		end_time = 0.4,
		name = "fade_content",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local widgets_to_fade = params._widgets_to_fade
			local start_alphas = params._widgets_to_fade_start_alphas
			local target_alphas = params._widgets_to_fade_target_alphas

			if not widgets_to_fade then
				widgets_to_fade = {}
				params._widgets_to_fade = widgets_to_fade
				start_alphas = {}
				params._widgets_to_fade_start_alphas = start_alphas
				target_alphas = {}
				params._widgets_to_fade_target_alphas = target_alphas
			end

			local flags = params.flags
			local last_index = 0
			local old_widgets = params.old_details_list_widgets

			for i = 1, #old_widgets do
				last_index = last_index + 1

				local widget = old_widgets[i]

				widgets_to_fade[last_index] = widget
				start_alphas[last_index] = widget.alpha_multiplier
				target_alphas[last_index] = 0
			end

			local new_widgets = params.new_details_list_widgets

			for i = 1, #new_widgets do
				last_index = last_index + 1

				local widget = new_widgets[i]

				widget.visible = true
				widgets_to_fade[last_index] = widget
				start_alphas[last_index] = 0
				target_alphas[last_index] = 1
			end

			local old_header_widget = params.old_header_widget

			if old_header_widget then
				last_index = last_index + 1
				widgets_to_fade[last_index] = old_header_widget
				start_alphas[last_index] = old_header_widget.alpha_multiplier
				target_alphas[last_index] = 0
			end

			local button_widget = widgets_by_name.play_button

			button_widget.visible = true

			local button_orig_alpha = button_widget.alpha_multiplier or 0
			local button_target_alpha = flags.locked and 0 or 1

			if button_orig_alpha ~= button_target_alpha then
				last_index = last_index + 1
				widgets_to_fade[last_index] = button_widget
				start_alphas[last_index] = button_orig_alpha
				target_alphas[last_index] = button_target_alpha
			end

			local banner_widget = widgets_by_name.header_banner

			banner_widget.visible = true

			local banner_orig_alpha = banner_widget.alpha_multiplier or 0
			local banner_target_alpha = flags.locked and 1 or 0

			if banner_orig_alpha ~= banner_target_alpha then
				last_index = last_index + 1
				widgets_to_fade[last_index] = banner_widget
				start_alphas[last_index] = banner_orig_alpha
				target_alphas[last_index] = banner_target_alpha
			end

			params._num_widgets_to_fade = last_index
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local ease_exp = math.ease_exp
			local lerp = math.lerp
			local widgets_to_fade = params._widgets_to_fade
			local start_alphas = params._widgets_to_fade_start_alphas
			local target_alphas = params._widgets_to_fade_target_alphas
			local num_widgets_to_fade = params._num_widgets_to_fade

			for i = 1, num_widgets_to_fade do
				local widget = widgets_to_fade[i]

				widget.alpha_multiplier = ease_exp(lerp(start_alphas[i], target_alphas[i], progress))
			end
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local widgets_to_fade = params._widgets_to_fade
			local target_alphas = params._widgets_to_fade_target_alphas
			local num_widgets_to_fade = params._num_widgets_to_fade

			for i = 1, num_widgets_to_fade do
				local widget = widgets_to_fade[i]
				local target_alpha = target_alphas[i]

				widget.alpha_multiplier = target_alpha
				widget.visible = target_alpha > 0
			end
		end,
	},
}

local _status_report_panel_widgets = {
	"panel",
	"panel_scrollbar",
	"list_interaction",
	"list_mask",
	"report_background",
}

animations.sequence_animations.resize_report_window = {
	{
		end_time = 0.2,
		name = "fade_in_panel",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local panel_widget = widgets_by_name.report_background

			params.original_alpha = panel_widget.alpha_multiplier or 0

			local fade_in_widgets = params.fade_in_widgets

			if not fade_in_widgets then
				fade_in_widgets = {}

				local widget_names = _status_report_panel_widgets

				for i = 1, #widget_names do
					local name = widget_names[i]
					local widget = widgets_by_name[name]

					fade_in_widgets[#fade_in_widgets + 1] = widget
				end

				params.fade_in_widgets = fade_in_widgets
			end

			for i = 1, #fade_in_widgets do
				fade_in_widgets[i].visible = true
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local eased_progress = math.ease_exp(progress)
			local alpha_multiplier = math.lerp(params.original_alpha, 1, eased_progress)
			local widgets = params.fade_in_widgets

			for i = 1, #widgets do
				widgets[i].alpha_multiplier = alpha_multiplier
			end
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local widgets = params.fade_in_widgets

			for i = 1, #widgets do
				widgets[i].alpha_multiplier = 1
			end
		end,
	},
	{
		end_time = 0.3,
		name = "change_background_color",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local color_copy = ColorUtilities.color_copy
			local panel_widget = widgets_by_name.panel

			panel_widget.content.can_flash = false

			local panel_style = panel_widget.style
			local background_style = panel_style.background

			if not params.start_background_color then
				params.start_background_color = {}
				params.start_frame_color = {}
			end

			color_copy(background_style.color, params.start_background_color)

			local frame_style = panel_style.event_frame

			color_copy(frame_style.color, params.start_frame_color)

			local report_background_widget = widgets_by_name.report_background
			local insignia_style = report_background_widget.style.insignia

			if not params.start_insignia_color then
				params.start_insignia_color = {}
			end

			color_copy(insignia_style.color, params.start_insignia_color)

			local target_insignia_color, target_frame_color

			if params.is_event then
				target_insignia_color = insignia_style.color_event
				target_frame_color = frame_style.color_event
				frame_style.visible = true

				local frame_top_event_style = panel_style.frame_top_event

				frame_top_event_style.visible = true
				frame_top_event_style.color[1] = frame_top_event_style.anim_lower_alpha
				panel_style.frame_top_regular.visible = false
			else
				target_insignia_color = insignia_style.color_normal
				target_frame_color = frame_style.color_default
			end

			params.target_insignia_color = target_insignia_color
			params.target_frame_color = target_frame_color
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local color_lerp = ColorUtilities.color_lerp
			local eased_progress = math.ease_exp(progress)
			local panel_widget = widgets_by_name.panel
			local panel_style = panel_widget.style
			local background_style = panel_style.background
			local start_background_color = params.start_background_color
			local target_background_color = background_style.color_normal

			color_lerp(start_background_color, target_background_color, eased_progress, background_style.color, true)

			local frame_style = panel_style.event_frame
			local start_frame_color = params.start_frame_color
			local target_frame_color = params.target_frame_color

			color_lerp(start_frame_color, target_frame_color, eased_progress, frame_style.color)

			local report_background_widget = widgets_by_name.report_background
			local insignia_style = report_background_widget.style.insignia
			local insignia_start_color = params.start_insignia_color
			local insignia_target_color = params.target_insignia_color

			color_lerp(insignia_start_color, insignia_target_color, eased_progress, insignia_style.color, true)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local panel_widget_content = widgets_by_name.panel.content

			panel_widget_content.can_flash = true
			panel_widget_content.anim_time = 0
		end,
	},
	{
		end_time = 0.4,
		name = "resize",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local target_height_params = params.target_heights

			target_height_params.panel_header = 0

			local scenegraph_ids = params._scnengraph_ids
			local start_heights = params._start_heights
			local target_heights = params._target_heights

			if not scenegraph_ids then
				scenegraph_ids = {}
				params._scnengraph_ids = scenegraph_ids
				start_heights = {}
				params._start_heights = start_heights
				target_heights = {}
				params._target_heights = target_heights
			end

			local i = 0

			for scenegraph_id, node_definition in pairs(scenegraph_definition) do
				local start_height = ui_scenegraph[scenegraph_id].size[2]
				local target_height = target_height_params[scenegraph_id] or node_definition.size[2]

				if start_height ~= target_height then
					i = i + 1
					start_heights[i] = start_height
					target_heights[i] = target_height
					scenegraph_ids[i] = scenegraph_id
				end
			end

			params._num_scenegraph_ids = i
			ui_scenegraph.info_area.position[2] = 0

			Managers.ui:play_2d_sound(UISoundEvents.mission_board_show_details)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local scenegraph_ids = params._scnengraph_ids
			local start_heights = params._start_heights
			local target_heights = params._target_heights
			local num_scenegraph_ids = params._num_scenegraph_ids
			local anim_progress = math.easeCubic(progress)

			for i = 1, num_scenegraph_ids do
				local scenegraph_id = scenegraph_ids[i]
				local target_height = target_heights[i]
				local start_height = start_heights[i]
				local height = math.lerp(start_height, target_height, anim_progress)

				ui_scenegraph[scenegraph_id].size[2] = height
			end

			local report_background_widget = widgets_by_name.report_background
			local background_style = report_background_widget.style
			local insignia_style = report_background_widget.style.insignia
			local insignia_target_height = background_style.size[2]
			local current_background_height = ui_scenegraph.panel.size[2]

			if current_background_height < insignia_target_height then
				insignia_style.size[2] = current_background_height

				local normalized_height = current_background_height / insignia_target_height

				insignia_style.uvs[2][2] = normalized_height
			else
				insignia_style.size[2] = insignia_target_height
				insignia_style.uvs[2][2] = 1
			end

			return true
		end,
	},
}
animations.sequence_animations.retract_window = {
	{
		end_time = 0.4,
		name = "resize_window",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local scenegraph_ids = params.scnengraph_ids
			local start_heights = params.start_heights
			local target_heights = params.target_heights

			if not scenegraph_ids then
				scenegraph_ids = {}
				params.scnengraph_ids = scenegraph_ids
				start_heights = {}
				params.start_heights = start_heights
				target_heights = {}
				params.target_heights = target_heights
			end

			local i = 0

			for scenegraph_id, node_definition in pairs(scenegraph_definition) do
				local start_height = ui_scenegraph[scenegraph_id].size[2]
				local target_height = node_definition.size[2]

				if start_height ~= target_height then
					i = i + 1
					start_heights[i] = start_height
					target_heights[i] = target_height
					scenegraph_ids[i] = scenegraph_id
				end
			end

			Managers.ui:play_2d_sound(UISoundEvents.mission_board_show_details)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local scnengraph_ids = params.scnengraph_ids
			local start_heights = params.start_heights
			local target_heights = params.target_heights
			local anim_progress = math.easeCubic(progress)

			for i = 1, #scnengraph_ids do
				local scenegraph_id = scnengraph_ids[i]
				local start_height = start_heights[i]
				local target_height = target_heights[i]
				local height = math.lerp(start_height, target_height, anim_progress)

				ui_scenegraph[scenegraph_id].size[2] = height
			end

			if params.from_state == "status_report" then
				local report_background_widget = widgets_by_name.report_background
				local background_style = report_background_widget.style
				local insignia_style = report_background_widget.style.insignia
				local insignia_target_height = background_style.size[2]
				local current_background_height = ui_scenegraph.panel.size[2]

				if current_background_height < insignia_target_height then
					insignia_style.size[2] = current_background_height

					local normalized_height = current_background_height / insignia_target_height

					insignia_style.uvs[2][2] = normalized_height
				else
					insignia_style.size[2] = insignia_target_height
					insignia_style.uvs[2][2] = 1
				end
			else
				local mission_header_widget = widgets_by_name.mission_header
				local mission_header_style = mission_header_widget.style
				local image_style = mission_header_style.zone_image
				local mission_header_target_height = mission_header_style.size[2]
				local mission_header_height = ui_scenegraph.panel_header.size[2]

				if mission_header_height < mission_header_target_height then
					local normalized_height = mission_header_height / mission_header_target_height

					image_style.uvs[2][2] = normalized_height
				else
					image_style.uvs[2][2] = 1
				end

				ui_scenegraph.info_area.position[2] = mission_header_height
			end

			return true
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local scnengraph_ids = params.scnengraph_ids

			for i = 1, #scnengraph_ids do
				local scenegraph_id = scnengraph_ids[i]

				ui_scenegraph[scenegraph_id].size[2] = scenegraph_definition[scenegraph_id].size[2]
			end

			ui_scenegraph.info_area.position[2] = ui_scenegraph.panel_header.size[2]
		end,
	},
	{
		end_time = 0.4,
		name = "change_background_color",
		start_time = 0.1,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local panel_widget = widgets_by_name.panel

			panel_widget.content.can_flash = false

			if not params.start_background_color then
				params.start_background_color = {}
			end

			ColorUtilities.color_copy(panel_widget.style.background.color, params.start_background_color)

			local report_background_widget = widgets_by_name.report_background

			if not params.start_insignia_color then
				params.start_insignia_color = {}
			end

			ColorUtilities.color_copy(report_background_widget.style.insignia.color, params.start_insignia_color)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local widget = widgets_by_name.panel
			local background_style = widget.style.background
			local start_background_color = params.start_background_color
			local target_color = background_style.color_default
			local eased_progress = math.ease_exp(progress)

			ColorUtilities.color_lerp(start_background_color, target_color, eased_progress, background_style.color, true)

			local report_background_widget = widgets_by_name.report_background
			local insignia_style = report_background_widget.style.insignia
			local insignia_start_color = params.start_insignia_color
			local insignia_target_color = insignia_style.color_default

			ColorUtilities.color_lerp(insignia_start_color, insignia_target_color, eased_progress, insignia_style.color, true)
		end,
	},
	{
		end_time = 0.4,
		name = "fade_out",
		start_time = 0.1,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local panel_widget = widgets_by_name.panel
			local original_alpha = panel_widget.alpha_multiplier or 0

			params.original_alpha = original_alpha

			local widgets = {}

			for name, widget in pairs(widgets_by_name) do
				widgets[#widgets + 1] = widget
			end

			params.widgets = widgets
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			local alpha_multiplier = math.lerp(params.original_alpha, 0, math.easeCubic(progress))
			local widgets = params.widgets

			for i = 1, #widgets do
				local widget = widgets[i]

				if alpha_multiplier < widget.alpha_multiplier then
					widget.alpha_multiplier = alpha_multiplier
				end
			end
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			local widgets = params.widgets

			for i = 1, #widgets do
				local widget = widgets[i]

				widget.alpha_multiplier = 0
				widget.visible = false
			end

			local panel_widget = widgets_by_name.panel
			local panel_style = panel_widget.style

			panel_style.event_frame.visible = false

			local frame_top_regular_style = panel_style.frame_top_regular

			frame_top_regular_style.visible = true
			frame_top_regular_style.color[1] = frame_top_regular_style.anim_lower_alpha
			panel_style.frame_top_event.visible = false
			panel_style.frame_top_red.visible = false
		end,
	},
}
animations.change_functions = {}

local _ease_function = math.ease_pulse

animations.change_functions.event_frame = function (content, style, animations, dt)
	if not content.flash_mission or not content.can_flash then
		return
	end

	style.color[1] = math.lerp(style.color_flash[1], style.anim_lower_alpha, _ease_function(content.anim_time))
end

animations.change_functions.frame_lights = function (content, style, animations, dt)
	if not content.can_flash then
		content.anim_time = 0

		return
	end

	local speed = content.flash_mission and style.anim_flash_speed or style.anim_speed
	local anim_time = (content.anim_time + dt * speed) % 1

	content.anim_time = anim_time
	style.color[1] = math.lerp(255, style.anim_lower_alpha, _ease_function(anim_time))
end

return settings("ViewElementMissionInfoPanelAnimations", animations)
