local Definitions = require("scripts/ui/views/mission_voting_view/mission_voting_view_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local GlobalMissionSettings = require("scripts/settings/mission/mission_templates")
local GlobalZoneSettings = require("scripts/settings/zones/zones")
local GlobalCircumstanceTemplate = require("scripts/settings/circumstance/circumstance_templates")
local MissionDetailsBlueprints = require("scripts/ui/views/mission_voting_view/mission_voting_view_blueprints")
local ViewStyles = require("scripts/ui/views/mission_voting_view/mission_voting_view_styles")
local MissionBoardSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local MissionVotingViewTestify = GameParameters.testify and require("scripts/ui/views/mission_voting_view/mission_voting_view_testify")
local MissionVotingView = class("MissionVotingView", "BaseView")

MissionVotingView.init = function (self, settings, context)
	if context then
		self._voting_id = context.voting_id
		self._mission_data = context.mission_data
	end

	MissionVotingView.super.init(self, Definitions, settings)
end

MissionVotingView.on_enter = function (self)
	MissionVotingView.super.on_enter(self)

	self._allow_close_hotkey = false

	self:_setup_main_page_widgets()
	self:_setup_details_page_static_widgets()
	self:_create_offscreen_renderer()
	self:_populate_data(self._mission_data)
	self:toggle_details(false)
end

MissionVotingView.on_exit = function (self)
	MissionVotingView.super.on_exit(self)
	self:_destroy_renderer()
end

MissionVotingView.update = function (self, dt, t, input_service)
	self:_update_timer_bar(dt)
	self._details_list_grid:update(dt, t, input_service)

	if input_service:get("confirm_pressed") then
		self:cb_on_accept_mission_pressed()
	elseif input_service:get("back") then
		if not self._has_voted then
			self:cb_on_decline_mission_pressed()
		end
	elseif input_service:get("next") then
		self:cb_on_toggle_details_pressed()
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MissionVotingViewTestify, self)
	end

	local pass_input, pass_draw = MissionVotingView.super.update(self, dt, t, input_service)

	return false, false
end

MissionVotingView.draw = function (self, dt, t, input_service, layer)
	MissionVotingView.super.draw(self, dt, t, input_service, layer)

	if self._is_showing_details and self._offscreen_renderer then
		local offscreen_renderer = self._offscreen_renderer

		UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

		local offscreen_widgets = self._mission_details_widgets
		local grid = self._details_list_grid

		for i = 1, #offscreen_widgets, 1 do
			local widget = offscreen_widgets[i]

			if grid:is_widget_visible(widget) then
				UIWidget.draw(widget, offscreen_renderer)
			end
		end

		UIRenderer.end_pass(offscreen_renderer)
	end
end

MissionVotingView.on_resolution_modified = function (self)
	MissionVotingView.super.on_resolution_modified(self)
	self._details_list_grid:on_resolution_modified()
end

MissionVotingView.cb_on_accept_mission_pressed = function (self)
	self:_play_sound(UISoundEvents.mission_vote_popup_accept)

	local success, fail_reason = Managers.voting:cast_vote(self._voting_id, "yes")

	if not success then
	end

	self:_show_confirmed_message()

	self._has_voted = true

	if true then
		Log.info("MissionVotingView", "Failed casting vote in voting %s, reason: %s", self._voting_id, fail_reason)
		self:_close_view()
	end
end

MissionVotingView.cb_on_decline_mission_pressed = function (self)
	self:_play_sound(UISoundEvents.mission_vote_popup_decline)

	local success, fail_reason = Managers.voting:cast_vote(self._voting_id, "no")

	if not success then
		Log.info("MissionVotingView", "Failed casting vote in voting %s, reason: %s", self._voting_id, fail_reason)
		self:_close_view()
	end

	self._has_voted = true
end

MissionVotingView.cb_on_toggle_details_pressed = function (self)
	if not self:_is_animation_active(self._toggle_details_page_animation_id) then
		local show_details_flag = not self._is_showing_details
		local params = {
			show_details_flag = show_details_flag,
			source_heights = (show_details_flag and self._main_page_heights) or self._details_page_heights,
			target_heights = (show_details_flag and self._details_page_heights) or self._main_page_heights
		}
		self._toggle_details_page_animation_id = self:_start_animation("switch_page", nil, params)
	end
end

MissionVotingView.set_player_name = function (self)
	local title_text = self:_localize("loc_mission_voting_view_title_format", true, self.view_data)
	local title_widget = self._widgets_by_name.title_text
	title_widget.content.text = title_text
end

MissionVotingView.toggle_details = function (self, show_details_flag)
	local toggle_details_button = self._widgets_by_name.toggle_details_button
	local button_content = toggle_details_button.content

	if show_details_flag then
		self._additional_widgets = self._details_static_widgets
		button_content.text = self:_localize("loc_mission_voting_view_hide_details")
	else
		self._additional_widgets = self._mission_info_widgets
		button_content.text = self:_localize("loc_mission_voting_view_show_details")
	end

	self._is_showing_details = show_details_flag
end

MissionVotingView._close_view = function (self)
	Managers.ui:close_view(self.view_name)
end

MissionVotingView._update_timer_bar = function (self, dt)
	local timer_bar_widget = self._widgets_by_name.timer_bar
	local _, time_left_normalized = Managers.voting:time_left(self._voting_id)
	local style = timer_bar_widget.style.timer_bar
	local bar_width, _ = self:_scenegraph_size(timer_bar_widget.scenegraph_id)
	style.size[1] = bar_width * time_left_normalized
	style.color[1] = 255 * math.min(1, time_left_normalized * time_left_normalized * 1000)
end

MissionVotingView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	MissionVotingView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local additional_widgets = self._additional_widgets
	local num_widgets = #additional_widgets

	for i = 1, num_widgets, 1 do
		local widget = additional_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

MissionVotingView._create_offscreen_renderer = function (self)
	local new_world_layer_id = 10
	local view_name = self.view_name
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, new_world_layer_id, nil, view_name)
	local viewport_name = "offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "offscreen_renderer"
	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name
	}
end

MissionVotingView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		self._offscreen_world = nil
	end
end

MissionVotingView._setup_main_page_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.mission_info_widget_definitions
	}
	self._mission_info_widgets = {}

	self:_create_widgets(definitions, self._mission_info_widgets, self._widgets_by_name)
end

MissionVotingView._setup_details_page_static_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.details_static_widgets_definitions
	}
	self._details_static_widgets = {}

	self:_create_widgets(definitions, self._details_static_widgets, self._widgets_by_name)
end

MissionVotingView._populate_data = function (self, mission_data)
	local player_portrait = self:_add_dummy_portrait()

	self:_set_requester_portrait(player_portrait)
	self:_set_mission_data(mission_data)

	local details_widgets_total_height = self:_set_details_data(mission_data)

	self:_calculate_page_heights(details_widgets_total_height)
	self:_resize_dialog_heights(self._main_page_heights)
end

MissionVotingView._set_requester_portrait = function (self, portrait)
	local portrait_widget = self._widgets_by_name.player_portrait
	portrait_widget.content.portrait = portrait
end

MissionVotingView._set_mission_data = function (self, mission_data)
	local mission_settings = GlobalMissionSettings[mission_data.map]
	local zone_settings = GlobalZoneSettings[mission_settings.zone_id]
	local zone_image_widget = self._widgets_by_name.zone_image
	local zone_images = zone_settings.images

	if zone_images then
		zone_image_widget.content.texture = zone_images.mission_vote
	end

	local mission_info_widget = self._widgets_by_name.mission_info
	local mission_info_widget_content = mission_info_widget.content
	local mission_title = (mission_settings.mission_name and self:_localize(mission_settings.mission_name)) or mission_data.map
	mission_info_widget_content.mission_title = mission_title

	self:_set_salary(mission_data)

	local challenge_widget = self._widgets_by_name.mission_info_challenge

	self:_set_difficulty_icons(challenge_widget.style, mission_data.challenge)
	self:_set_circumstance(mission_data)

	local accept_button_widget = self._widgets_by_name.accept_button
	accept_button_widget.content.hotspot.pressed_callback = callback(self, "cb_on_accept_mission_pressed")
	local decline_button_widget = self._widgets_by_name.decline_button
	decline_button_widget.content.hotspot.pressed_callback = callback(self, "cb_on_decline_mission_pressed")
	local toggle_details_button_widget = self._widgets_by_name.toggle_details_button
	toggle_details_button_widget.content.hotspot.pressed_callback = callback(self, "cb_on_toggle_details_pressed")
	local accept_confirmation_widget = self._widgets_by_name.accept_confirmation
	accept_confirmation_widget.visible = false
end

MissionVotingView._set_details_data = function (self, mission_data)
	local scenegraph_id = "details_panel_content"
	local include_mission_header = true
	local details_data = MissionDetailsBlueprints.utility_functions.prepare_details_data(mission_data, include_mission_header)
	local details_widgets = self:_create_details_widgets(details_data, scenegraph_id)
	local total_height = self:_layout_details_widgets(details_widgets, scenegraph_id)
	self._mission_details_widgets = details_widgets

	return total_height
end

MissionVotingView._set_salary = function (self, mission_data)
	local salary_widget = self._widgets_by_name.mission_info_salary
	local base_xp = mission_data.xp
	local content = salary_widget.content
	content.experience_text = tostring(base_xp)
	content.credits_text = mission_data.credits

	self:_horizontally_layout_salary_passes(salary_widget)
end

MissionVotingView._horizontally_layout_salary_passes = function (self, salary_widget)
	local style = salary_widget.style
	local xp_text_width = self:_calc_text_size(salary_widget, "experience_text")
	local xp_text_style = style.experience_text
	local credits_icon_style = style.credits_icon
	credits_icon_style.offset[1] = xp_text_style.offset[1] + xp_text_width + credits_icon_style.base_margin_left
	local credits_text_width = self:_calc_text_size(salary_widget, "credits_text")
	local credits_text_style = style.credits_text
	credits_text_style.offset[1] = credits_icon_style.offset[1] + credits_icon_style.size[1]
	local total_width = credits_text_style.offset[1] + credits_text_width

	self:_set_scenegraph_size("mission_salary", total_width)
end

MissionVotingView._set_difficulty_icons = function (self, style, difficulty_value)
	local difficulty_icon_style = style.difficulty_icon
	difficulty_icon_style.amount = difficulty_value
end

MissionVotingView._set_circumstance = function (self, mission_data)
	local circumstance_id = mission_data.circumstance
	local circumstance_widget = self._widgets_by_name.mission_info_circumstance

	if circumstance_id == MissionBoardSettings.default_circumstance then
		circumstance_widget.visible = false
		local _, mission_info_height = self:_scenegraph_size("mission_info")

		self:_set_scenegraph_size("mission_info_panel", nil, mission_info_height)
	else
		local circumstance_template = GlobalCircumstanceTemplate[circumstance_id]
		local content = circumstance_widget.content
		content.text = self:_localize(circumstance_template.ui.display_name)
		content.icon = circumstance_template.ui.icon
		local text_width = self:_calc_text_size(circumstance_widget, "text")

		self:_set_scenegraph_size("mission_circumstance", text_width + ViewStyles.mission_info_circumstance.icon.size[1])

		local circumstance_height_addition = ViewStyles.circumstance_height_addition
		local _, outer_panel_height = self:_scenegraph_size("outer_panel")

		self:_set_scenegraph_size("outer_panel", nil, outer_panel_height + circumstance_height_addition)

		local _, inner_panel_height = self:_scenegraph_size("inner_panel")

		self:_set_scenegraph_size("inner_panel", nil, inner_panel_height + circumstance_height_addition)

		local _, body_panel_height = self:_scenegraph_size("body_panel")

		self:_set_scenegraph_size("body_panel", nil, body_panel_height + circumstance_height_addition)
	end
end

MissionVotingView._create_details_widgets = function (self, content, scenegraph_id)
	local templates = MissionDetailsBlueprints.templates
	local widget_definitions = {}
	local created_widgets = {}

	for i = 1, #content, 1 do
		local entry = content[i]
		local template_name = entry.template
		local template = templates[template_name]

		fassert(template, "[MissionVotingView] - Could not find content blueprint for: %s", template_name)

		local widget_definition = widget_definitions[template_name]

		if not widget_definition then
			fassert(template.pass_template, "[MissionVotingView] - Could not find pass_template in the blueprint for: %s", template_name)

			widget_definition = UIWidget.create_definition(template.pass_template, scenegraph_id, nil, template.size, template.style)
			widget_definitions[template_name] = widget_definition
		end

		fassert(widget_definition, "[MissionVotingView] - Could not find widget definition for type: %s", template_name)

		local widget_name = scenegraph_id .. "_widget_" .. i
		local widget = self:_create_widget(widget_name, widget_definition)

		if template.init then
			template.init(widget, entry.widget_data, self._ui_renderer)
		end

		created_widgets[#created_widgets + 1] = widget
	end

	return created_widgets
end

MissionVotingView._layout_details_widgets = function (self, widgets, grid_scenegraph_id)
	local interaction_scenegraph_id = "details_panel"
	local view_definitions = self._definitions
	local list_end_margin = {
		size = view_definitions.details_panel_end_padding
	}
	local alignment_list = {
		list_end_margin
	}

	for i = 1, #widgets, 1 do
		alignment_list[#alignment_list + 1] = widgets[i]
	end

	alignment_list[#alignment_list + 1] = list_end_margin
	local widget_spacing = view_definitions.details_widget_spacing
	local grid_direction = "down"
	local scrollbar_widget = self._widgets_by_name.details_scrollbar
	local details_list_grid = UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, grid_direction, widget_spacing)

	details_list_grid:assign_scrollbar(scrollbar_widget, grid_scenegraph_id, interaction_scenegraph_id)

	self._details_list_grid = details_list_grid

	return details_list_grid:length()
end

MissionVotingView._resize_dialog_heights = function (self, heights)
	self:_set_scenegraph_size("mission_info", nil, heights.mission_info_height)
	self:_set_scenegraph_size("mission_info_panel", nil, heights.mission_info_panel_height)
	self:_set_scenegraph_size("zone_image", nil, heights.zone_image_height)
	self:_set_scenegraph_size("body_panel", nil, heights.body_height)
	self:_set_scenegraph_size("inner_panel", nil, heights.inner_panel_height)
	self:_set_scenegraph_size("outer_panel", nil, heights.outer_panel_height)
end

MissionVotingView._calculate_page_heights = function (self, details_page_needed_height)
	local _, outer_panel_height = self:_scenegraph_size("outer_panel")
	local _, inner_panel_height = self:_scenegraph_size("inner_panel")
	local _, body_height = self:_scenegraph_size("body_panel")
	local _, zone_image_height = self:_scenegraph_size("zone_image")
	local _, mission_info_panel_height = self:_scenegraph_size("mission_info_panel")
	local _, details_page_expanded_height = self:_scenegraph_size("details_panel_content")
	local _, outer_panel_y_offset = self:_scenegraph_position("outer_panel")
	local _, zone_image_y_offset = self:_scenegraph_position("zone_image")
	local body_y_offset = zone_image_y_offset + zone_image_height
	self._main_page_heights = {
		outer_panel_height = outer_panel_height,
		inner_panel_height = inner_panel_height,
		body_height = body_height,
		zone_image_height = zone_image_height,
		mission_info_panel_height = mission_info_panel_height,
		outer_panel_y_offset = outer_panel_y_offset,
		body_y_offset = body_y_offset
	}
	local details_page_overhang = 0
	local details_page_height = body_height + zone_image_height

	if details_page_needed_height > details_page_height and details_page_height < details_page_expanded_height then
		details_page_overhang = math.min(details_page_needed_height, details_page_expanded_height) - details_page_height
		details_page_height = details_page_height + details_page_overhang
	end

	local acceptable_overflow = 20

	if details_page_needed_height > details_page_expanded_height + acceptable_overflow then
		self._use_details_scrollbar = true
	end

	self._details_page_heights = {
		zone_image_height = 0,
		outer_panel_height = outer_panel_height + details_page_overhang,
		inner_panel_height = inner_panel_height + details_page_overhang,
		body_height = details_page_height,
		mission_info_panel_height = details_page_height,
		outer_panel_y_offset = outer_panel_y_offset + details_page_overhang / 2,
		body_y_offset = zone_image_y_offset
	}
end

MissionVotingView._show_confirmed_message = function (self)
	local accept_button = self._widgets_by_name.accept_button
	accept_button.visible = false
	local decline_button = self._widgets_by_name.decline_button
	decline_button.visible = false
	local accept_confirmation_widget = self._widgets_by_name.accept_confirmation
	accept_confirmation_widget.visible = true
end

MissionVotingView._calc_text_size = function (self, widget, text_and_style_id)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)

	if not text_style.size and not widget.content.size then
		local size = {
			self:_scenegraph_size(widget.scenegraph_id)
		}
	end

	return UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

MissionVotingView._add_dummy_portrait = function (self)
	return "content/ui/materials/icons/portraits/default"
end

return MissionVotingView
