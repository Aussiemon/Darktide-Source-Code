-- chunkname: @scripts/ui/views/class_selection_view/class_selection_view.lua

local CharacterSheet = require("scripts/utilities/character_sheet")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local ClassSelectionViewTestify = GameParameters.testify and require("scripts/ui/views/class_selection_view/class_selection_view_testify")
local ContentBlueprints = require("scripts/ui/views/class_selection_view/class_selection_view_blueprints")
local Definitions = require("scripts/ui/views/class_selection_view/class_selection_view_definitions")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ClassSelectionView = class("ClassSelectionView", "BaseView")
local temp_archetype_to_specialization_lookup = {
	adamant = "adamant",
	ogryn = "ogryn_2",
	psyker = "psyker_2",
	veteran = "veteran_2",
	zealot = "zealot_2",
}

ClassSelectionView.init = function (self, settings, context)
	ClassSelectionView.super.init(self, Definitions, settings, context)

	self._character_create = context.character_create
	self._pass_draw = false
	self._allow_close_hotkey = false
	self._force_character_creation = context.force_character_creation
	self._promise_container = PromiseContainer:new()
end

ClassSelectionView.on_enter = function (self)
	ClassSelectionView.super.on_enter(self)

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	self:_setup_input_legend()
	self:_register_button_callbacks()

	self._archetype_options = self._character_create:archetype_options()

	local profile = self._character_create:profile()

	self._archetype_details_visible = false

	self:_create_archetype_option_widgets()
	self:_show_archetypes_widgets(false, profile.archetype)

	self._setup_complete = true
end

ClassSelectionView.ui_renderer = function (self)
	return self._ui_renderer
end

ClassSelectionView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

ClassSelectionView._register_button_callbacks = function (self)
	self._widgets_by_name.details_button.content.hotspot.pressed_callback = function ()
		self:_on_details_pressed()
	end

	self._widgets_by_name.details_button.content.hotspot.on_pressed_sound = UISoundEvents.character_create_toggle_class_description
	self._widgets_by_name.continue_button.content.hotspot.on_pressed_sound = UISoundEvents.character_create_class_confirm
end

ClassSelectionView._setup_background_world = function (self, level_name)
	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_register_event("event_register_character_camera")
	self:_register_event("event_register_character_spawn_point")

	local world_name = ClassSelectionViewSettings.world_name
	local world_layer = ClassSelectionViewSettings.world_layer
	local world_timer_name = ClassSelectionViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	self._world_spawner:spawn_level(level_name)
end

ClassSelectionView.event_register_character_camera = function (self, camera_unit)
	self:_unregister_event("event_register_character_camera")

	local viewport_name = ClassSelectionViewSettings.viewport_name
	local viewport_type = ClassSelectionViewSettings.viewport_type
	local viewport_layer = ClassSelectionViewSettings.viewport_layer
	local shading_environment = ClassSelectionViewSettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)

	self._fade_animation_id = self:_start_animation("fade_in", nil, self._render_settings)
end

ClassSelectionView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit
end

ClassSelectionView._enable_blur = function (self, enable)
	local world_spawner = self._world_spawner

	if world_spawner then
		if enable then
			self._world_spawner:set_camera_blur(0.9, 0.1)
		else
			self._world_spawner:set_camera_blur(0, 0.1)
		end
	end
end

ClassSelectionView.draw = function (self, dt, t, input_service, layer)
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local render_settings = self._render_settings
	local archetype_options_widgets = self._archetype_options_widgets
	local archetype_options_frame_widgets = self._archetype_options_frame_widgets
	local class_details_widgets = self._class_details_widgets
	local class_options_widgets = self._class_options_widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if archetype_options_widgets then
		for i = 1, #archetype_options_widgets do
			local widget = archetype_options_widgets[i]

			if self._using_cursor_navigation then
				widget.content.hotspot.is_focused = widget.content.hotspot.is_hover
			end

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if archetype_options_frame_widgets then
		for i = 1, #archetype_options_frame_widgets do
			local widget = archetype_options_frame_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if class_details_widgets then
		for i = 1, #class_details_widgets do
			local background_widget = class_details_widgets[i].background
			local info_widget = class_details_widgets[i].info

			UIWidget.draw(background_widget, ui_renderer)
			UIWidget.draw(info_widget, ui_renderer)
		end
	end

	if class_options_widgets then
		for i = 1, #class_options_widgets do
			local widget = class_options_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
	ClassSelectionView.super.draw(self, dt, t, input_service, layer)
end

ClassSelectionView.update = function (self, dt, t, input_service)
	if self._show_archetype_abilities_info then
		self._show_archetype_abilities_info = false

		self:_create_archetype_abilities_info()
	end

	if self._new_level_name then
		self:_setup_background_world(self._new_level_name)

		self._new_level_name = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	local grid = self._class_abilities_info_grid

	if grid then
		grid:update(dt, t, input_service)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(ClassSelectionViewTestify, self)
	end

	return ClassSelectionView.super.update(self, dt, t, input_service)
end

ClassSelectionView._on_continue_pressed = function (self)
	local selected_specialization_name = temp_archetype_to_specialization_lookup[self._selected_archetype.name]

	self._character_create:set_specialization(selected_specialization_name)

	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.character_create_class_confirm)
	end

	Managers.event:trigger("event_create_new_character_continue")
end

ClassSelectionView._on_details_pressed = function (self)
	self:_handle_details_button_text()

	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.character_create_toggle_class_description)
	end

	if self._archetype_details_visible then
		self:_show_archetypes_widgets(false)
	else
		self:_show_archetypes_widgets(true)
	end
end

ClassSelectionView._on_back_pressed = function (self)
	Managers.event:trigger("event_create_new_character_back")
	self:_play_sound(UISoundEvents.character_create_abort)
end

ClassSelectionView._on_quit_pressed = function (self)
	local context = {
		description_text = "loc_popup_description_quit_game",
		title_text = "loc_popup_header_quit_game",
		options = {
			{
				close_on_pressed = true,
				hotkey = "back",
				text = "loc_popup_button_continue_game",
			},
			{
				close_on_pressed = true,
				text = "loc_popup_button_quit_game",
				callback = callback(function ()
					Application.quit()
				end),
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

ClassSelectionView.on_exit = function (self)
	self._promise_container:delete()

	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ClassSelectionView.super.on_exit(self)
end

ClassSelectionView._handle_input = function (self, input_service)
	local input_handled = false

	if not self._using_cursor_navigation then
		if input_service:get("secondary_action_pressed") then
			self:_on_details_pressed()

			input_handled = true
		elseif input_service:get("confirm_pressed") then
			if not self._widgets_by_name.continue_button.disabled then
				self._widgets_by_name.continue_button.content.hotspot.pressed_callback()
			end

			input_handled = true
		end
	end

	local archetype_options = self._archetype_options
	local num_options

	if not input_handled then
		local new_selection_index, current_selection_index

		current_selection_index = self._selected_archetype and table.index_of(archetype_options, self._selected_archetype) or 1
		num_options = #archetype_options

		if input_service:get("navigate_left_continuous") or input_service:get("navigate_primary_left_pressed") then
			if current_selection_index > 1 then
				new_selection_index = current_selection_index - 1
			end
		elseif (input_service:get("navigate_right_continuous") or input_service:get("navigate_primary_right_pressed")) and current_selection_index < num_options then
			new_selection_index = current_selection_index + 1
		end

		if new_selection_index then
			local target_option = self._archetype_options[new_selection_index]

			for i = 1, #self._archetype_options_widgets do
				local widget = self._archetype_options_widgets[i]

				widget.content.hotspot.is_focused = i == new_selection_index
			end

			self:_on_archetype_pressed(target_option)
		end
	end
end

ClassSelectionView._on_navigation_input_changed = function (self)
	ClassSelectionView.super._on_navigation_input_changed(self)
end

ClassSelectionView._create_archetype_option_widgets = function (self)
	self:_destroy_archetype_option_widgets()

	local archetype_option_frame_definition = Definitions.archetype_option_frame_definition
	local archetype_option_definition = Definitions.archetype_option_definition
	local archetype_selection_definition = Definitions.archetype_selection_definition
	local frame_widgets = {}
	local icon_widgets = {}
	local options = self._archetype_options
	local num_options = #options
	local spacing = ClassSelectionViewSettings.archetype_option_spacing
	local widget_left = self:_create_widget("archetype_select_left", archetype_selection_definition.left)

	widget_left.offset[1] = -ClassSelectionViewSettings.archetype_select_spacing

	local max_frame_height = 0
	local min_frame_width = math.huge
	local max_frame_width = 0
	local options_data = {}

	for i = 1, num_options do
		local option = options[i]
		local frame_data

		if i == 1 then
			frame_data = ClassSelectionViewSettings.archetype_frames_textures.left
		elseif i == num_options then
			frame_data = ClassSelectionViewSettings.archetype_frames_textures.right
		else
			local random_value = math.random(1, 3)

			frame_data = ClassSelectionViewSettings.archetype_frames_textures["mid_" .. random_value]
		end

		max_frame_height = math.max(frame_data.size[2], max_frame_height)
		min_frame_width = math.min(frame_data.size[1], min_frame_width)
		max_frame_width = math.max(frame_data.size[1], max_frame_width)

		local data = {
			frame = frame_data,
			option = option,
		}

		options_data[#options_data + 1] = data
	end

	local start_margin = max_frame_width - min_frame_width
	local archetype_info_width, archetype_info_height = self:_scenegraph_size("archetype_info")
	local archetypes_total_size = (min_frame_width + spacing) * num_options - spacing
	local size_ratio = archetypes_total_size and archetypes_total_size > 0 and archetype_info_width / archetypes_total_size or 1
	local start_offset_x = 0

	for i = 1, #options_data do
		local option = options_data[i].option
		local frame_data = options_data[i].frame
		local frame_name = "archetype_option_frame_" .. i
		local frame_widget = self:_create_widget(frame_name, archetype_option_frame_definition)
		local frame_content = frame_widget.content
		local frame_style = frame_widget.style
		local frame_size = {
			frame_data.size[1] * size_ratio,
			frame_data.size[2] * size_ratio,
		}
		local frame_texture = frame_data.texture
		local frame_offset = {
			frame_data.offset[1] * size_ratio,
			frame_data.offset[2] * size_ratio,
		}
		local icon_offset = {
			frame_data.icon_offset[1] * size_ratio,
			frame_data.icon_offset[2] * size_ratio,
		}
		local icon_size = {
			ClassSelectionViewSettings.archetype_option_icon_size[1] * size_ratio,
			ClassSelectionViewSettings.archetype_option_icon_size[2] * size_ratio,
		}

		frame_style.frame.material_values.texture_map = frame_texture
		frame_widget.content.size = frame_size
		frame_widget.offset[1] = start_offset_x + frame_offset[1]
		frame_widget.offset[2] = frame_offset[2]
		frame_widgets[#frame_widgets + 1] = frame_widget
		start_offset_x = start_offset_x + frame_widget.content.size[1] + spacing

		local icon_name = "archetype_option_icon_" .. i
		local icon_widget = self:_create_widget(icon_name, archetype_option_definition)

		icon_widget.content.size = icon_size

		local icon_content = icon_widget.content
		local icon_style = icon_widget.style

		icon_content.archetype_title = option.archetype_title

		icon_content.hotspot.pressed_callback = function ()
			if self._using_cursor_navigation then
				self:_on_archetype_pressed(option)
			end
		end

		icon_style.icon.material_values.texture_map = option.archetype_selection_icon
		icon_style.icon_highlight.material_values.texture_map = option.archetype_selection_highlight_icon
		icon_widget.offset[1] = frame_widget.offset[1] + icon_offset[1]
		icon_widget.offset[2] = frame_widget.offset[2] + icon_offset[2]
		icon_widgets[#icon_widgets + 1] = icon_widget
	end

	local widget_right = self:_create_widget("archetype_select_right", archetype_selection_definition.right)

	widget_right.offset[1] = start_offset_x
	self._archetype_options_widgets = icon_widgets
	self._archetype_options_frame_widgets = frame_widgets
	self._archetype_options_select_widget = {
		widget_left,
		widget_right,
	}

	local archetype_width, archetype_height = self:_scenegraph_size("archetype_info")
	local added_height_margin = 60

	self:_set_scenegraph_position("archetype_options", -start_margin * size_ratio, (-max_frame_height + added_height_margin) * size_ratio)
end

ClassSelectionView._on_archetype_pressed = function (self, selected_archetype)
	if selected_archetype ~= self._selected_archetype then
		self._selected_archetype = selected_archetype

		self._character_create:set_archetype(selected_archetype)

		local selection_sound_event = self._selected_archetype.selection_sound_event

		self:_play_sound(selection_sound_event)

		if self._setup_complete then
			self:_play_sound(UISoundEvents.character_create_archetype_pressed)
		end

		if self._fade_animation_id and self:_is_animation_active(self._fade_animation_id) then
			self:_stop_animation(self._fade_animation_id)
		end

		self._widgets_by_name.transition_fade.alpha_multiplier = 1
		self._new_level_name = selected_archetype.archetype_selection_level
	else
		self._widgets_by_name.transition_fade.alpha_multiplier = 0
	end

	local archetype_options_widgets = self._archetype_options_widgets

	for i = 1, #archetype_options_widgets do
		local widget = archetype_options_widgets[i]
		local content = widget.content
		local is_selected = selected_archetype.archetype_title == content.archetype_title

		content.hotspot.is_selected = is_selected
		content.hotspot.is_focused = is_selected
	end

	if self._archetype_details_visible then
		self:_show_archetype_details(false)

		self._widgets_by_name.class_background.content.visible = false

		self:_enable_blur(false)

		self._archetype_details_visible = false

		self:_handle_details_button_text()
	end

	local selected_specialization_name = temp_archetype_to_specialization_lookup[self._selected_archetype.name]

	if self._current_archetype_available_promise and not self._current_archetype_available_promise:is_fulfilled() then
		self._current_archetype_available_promise:cancel()
	end

	local is_archetype_available_promise = Promise:resolved(false)

	if selected_archetype.is_available then
		is_archetype_available_promise = selected_archetype:is_available()
	end

	if not is_archetype_available_promise:is_fulfilled() then
		self._widgets_by_name.continue_button.visible = false
		self._widgets_by_name.continue_button.disabled = true
	end

	self._current_archetype_available_promise = is_archetype_available_promise

	self._promise_container:cancel_on_destroy(is_archetype_available_promise):next(function (result)
		self._widgets_by_name.continue_button.visible = true
		self._widgets_by_name.continue_button.content.original_text = result.available and Utf8.upper(Localize("loc_character_creator_continue")) or Utf8.upper(Localize("loc_dlc_cta"))
		self._widgets_by_name.continue_button.disabled = false

		self._widgets_by_name.continue_button.content.hotspot.pressed_callback = function ()
			if result.available then
				self:_on_continue_pressed()
			else
				selected_archetype:acquire_callback(function (is_success)
					if is_success then
						self:_on_archetype_pressed(selected_archetype)
					end
				end)
			end
		end
	end)
	self:_update_archetype_info()
end

ClassSelectionView._update_archetype_info = function (self)
	local widgets_by_name = self._widgets_by_name
	local selected_archetype = self._selected_archetype
	local widget = widgets_by_name.archetype_info
	local title_margin = 100
	local vertical_margin = 20
	local max_width = self._ui_scenegraph.archetype_info.size[1] - title_margin
	local title = Localize(selected_archetype.archetype_title)
	local title_style = widget.style.title
	local title_style_options = UIFonts.get_font_options_by_style(title_style)
	local title_width, title_height = self:_text_size(title, title_style.font_type, title_style.font_size, {
		max_width,
		2000,
	}, title_style_options)
	local initial_offset = widget.style.title.offset[2]

	widget.style.divider.offset[2] = initial_offset + title_height + vertical_margin
	widget.style.description.offset[2] = widget.style.divider.offset[2] + widget.style.divider.size[2] + vertical_margin
	widget.content.title = title
	widget.content.description = Localize(selected_archetype.archetype_description)
	widgets_by_name.corners.content.left_upper = UISettings.inventory_frames_by_archetype[selected_archetype.name].right_upper
	widgets_by_name.corners.content.right_upper = UISettings.inventory_frames_by_archetype[selected_archetype.name].right_upper
	widgets_by_name.corners.content.left_lower = UISettings.inventory_frames_by_archetype[selected_archetype.name].left_lower
	widgets_by_name.corners.content.right_lower = UISettings.inventory_frames_by_archetype[selected_archetype.name].right_lower
end

ClassSelectionView._update_choose_button_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local details_button_display_name = Utf8.upper(Localize("loc_character_create_button_details"))
	local choose_button_display_name = Utf8.upper(Localize("loc_character_backstory_selection"))
	local title

	if self._archetype_details_visible then
		title = choose_button_display_name
	else
		title = details_button_display_name
	end

	widgets_by_name.choose_button.content.text = title
end

ClassSelectionView._show_archetypes_widgets = function (self, show_details, force_archetype)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.class_background.content.visible = show_details

	local selected_archetype

	if force_archetype ~= nil then
		selected_archetype = force_archetype
	else
		selected_archetype = self._selected_archetype
	end

	self:_enable_blur(show_details)

	if show_details then
		self:_show_archetype_details(true)

		if self._fade_animation_id and self:_is_animation_active(self._fade_animation_id) then
			self:_stop_animation(self._fade_animation_id)
		end

		self._widgets_by_name.transition_fade.alpha_multiplier = 0.5
	else
		widgets_by_name.main_title.content.visible = true
		widgets_by_name.main_title.content.text = Utf8.upper(Localize("loc_class_selection_choose_class"))

		self:_show_archetype_details(false)

		self._widgets_by_name.transition_fade.alpha_multiplier = 0

		self:_on_archetype_pressed(selected_archetype)
	end

	self._archetype_details_visible = show_details

	self:_handle_details_button_text()
end

ClassSelectionView._destroy_class_option_widgets = function (self)
	if self._class_options_widgets then
		for i = 1, #self._class_options_widgets do
			local widget = self._class_options_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._class_options_widgets = nil
	end
end

ClassSelectionView._destroy_archetype_option_widgets = function (self)
	if self._archetype_options_widgets then
		for i = 1, #self._archetype_options_widgets do
			local widget = self._archetype_options_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	if self._archetype_options_frame_widgets then
		for i = 1, #self._archetype_options_frame_widgets do
			local widget = self._archetype_options_frame_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	if self._archetype_options_select_widget then
		for i = 1, #self._archetype_options_select_widget do
			local widget = self._archetype_options_select_widget[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	self._archetype_options_widgets = nil
	self._archetype_options_frame_widgets = nil
	self._archetype_options_select_widget = nil
end

ClassSelectionView._destroy_archetype_abilities_info = function (self)
	self._show_archetype_abilities_info = false

	if self._class_abilities_info_widgets then
		for i = 1, #self._class_abilities_info_widgets do
			local widget = self._class_abilities_info_widgets[i]
			local template = ContentBlueprints[widget.element.type]

			if template and template.destroy then
				template.destroy(self, widget, self._ui_renderer)
			end

			self:_unregister_widget_name(widget.name)
		end

		self._class_abilities_info_widgets = nil

		self._class_abilities_info_grid:destroy()

		self._class_abilities_info_grid = nil

		local scrollbar_widget = self._widgets_by_name.class_details_scrollbar

		scrollbar_widget.content.visible = false
	end

	if self._details_grid then
		self._details_grid:present_grid_layout({}, ContentBlueprints)
	end
end

ClassSelectionView._show_archetype_details = function (self, show)
	local widgets_by_name = self._widgets_by_name

	if show then
		widgets_by_name.class_background.content.class_background = self._selected_archetype.archetype_icon_large
		self._show_archetype_abilities_info = true
	else
		self:_destroy_archetype_abilities_info()
	end
end

ClassSelectionView._create_archetype_abilities_info = function (self)
	self:_destroy_archetype_abilities_info()

	local definitions = self._definitions
	local max_width = ClassSelectionViewSettings.class_details_size[1]

	if not self._details_grid then
		local grid_scenegraph_id = "class_details_mask"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 22,
			scrollbar_width = 7,
			title_height = 0,
			use_parent_ui_renderer = false,
			widget_icon_load_margin = 5000,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 40,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._details_grid = self:_add_element(ViewElementGrid, "class_details_mask", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("class_details_mask", self._details_grid)
		self._details_grid:set_empty_message("")
	end

	local grid = self._details_grid
	local archetype = self._selected_archetype
	local layout = {}

	if archetype then
		layout[#layout + 1] = {
			widget_type = "video",
			video_path = archetype.archetype_video,
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				max_width,
				25,
			},
		}

		local nodes_to_present = {}

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				max_width,
				25,
			},
		}

		local base_class_loadout = {
			ability = {},
			blitz = {},
			aura = {},
			iconics = {},
		}
		local profile = self._character_create:profile()
		local force_base_talents = true

		CharacterSheet.class_loadout(profile, base_class_loadout, force_base_talents)

		local ability_talent = base_class_loadout.ability.talent

		nodes_to_present[#nodes_to_present + 1] = {
			type = "ability",
			widget_type = "talent_info",
			talent = ability_talent,
			icon = base_class_loadout.ability.icon,
		}

		local blitz_talent = base_class_loadout.blitz.talent

		nodes_to_present[#nodes_to_present + 1] = {
			type = "tactical",
			widget_type = "talent_info",
			talent = blitz_talent,
			icon = base_class_loadout.blitz.icon,
		}

		local aura_talent = base_class_loadout.aura.talent

		nodes_to_present[#nodes_to_present + 1] = {
			type = "aura",
			widget_type = "talent_info",
			talent = aura_talent,
			icon = base_class_loadout.aura.icon,
		}

		local iconics = base_class_loadout.iconics

		for i = 1, #iconics do
			local iconic = iconics[i]

			nodes_to_present[#nodes_to_present + 1] = {
				type = "iconic",
				widget_type = "stat",
				talent = iconic,
			}
		end

		table.sort(nodes_to_present, function (a, b)
			local a_type = a.type
			local b_type = b.type
			local a_type_settings = a_type and TalentBuilderViewSettings.settings_by_node_type[a_type]
			local b_type_settings = b_type and TalentBuilderViewSettings.settings_by_node_type[b_type]
			local has_same_sort_order = (a_type_settings and a_type_settings.sort_order or math.huge) == (b_type_settings and b_type_settings.sort_order or math.huge)
			local a_talent = a.talent
			local b_talent = b.talent

			if has_same_sort_order and a_talent and b_talent then
				return Localize(a_talent.display_name) < Localize(b_talent.display_name)
			end

			return (a_type_settings and a_type_settings.sort_order or math.huge) < (b_type_settings and b_type_settings.sort_order or math.huge)
		end)

		local presented_node_type_headers = {}

		for index, data in ipairs(nodes_to_present) do
			local talent = type(data.talent) == "table" and data.talent

			if not talent then
				local talent_name = data.talent

				talent = talent_name and archetype.talents[talent_name]
			end

			local description, display_name
			local add = false

			if talent then
				display_name = talent.display_name
				description = TalentLayoutParser.talent_description(talent, 1, Color.ui_terminal(255, true))
				add = true
			elseif data.base_talent then
				description = data.description
				display_name = data.display_name
				add = true
			end

			if add then
				local node_type = data.type
				local icon = data.icon
				local gradient_map, frame, icon_mask
				local settings_by_node_type = TalentBuilderViewSettings.settings_by_node_type[node_type]

				if settings_by_node_type then
					local node_gradient_color = data.gradient_color or "not_selected"

					if not node_gradient_color or node_gradient_color == "not_selected" then
						gradient_map = settings_by_node_type.gradient_map
					else
						gradient_map = node_gradient_color
					end

					frame = settings_by_node_type.frame
					icon_mask = settings_by_node_type.icon_mask
				end

				if not presented_node_type_headers[node_type] then
					layout[#layout + 1] = {
						widget_type = "header",
						text = Localize(settings_by_node_type.display_name),
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							max_width,
							10,
						},
					}
					presented_node_type_headers[node_type] = true
				end

				layout[#layout + 1] = {
					widget_type = data.widget_type,
					talent = talent,
					display_name = display_name,
					description = description,
					gradient_map = gradient_map,
					icon = icon,
					frame = frame,
					icon_mask = icon_mask,
					node_type = node_type,
				}

				if node_type ~= "iconic" then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							max_width,
							25,
						},
					}
				end
			end
		end

		local unique_weapons = {}

		if archetype.unique_weapons then
			for i = 1, #archetype.unique_weapons do
				local weapon = archetype.unique_weapons[i]
				local item = MasterItems.get_item(weapon.item)

				if item then
					unique_weapons[#unique_weapons + 1] = {
						item = table.clone_instance(item),
						display_name = weapon.display_name,
					}
				end
			end
		end

		if #unique_weapons > 0 then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					max_width,
					20,
				},
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize("loc_class_selection_specialization_class_unique_weapons_title"),
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					max_width,
					25,
				},
			}

			for i = 1, #unique_weapons do
				local unique_weapon = unique_weapons[i]

				layout[#layout + 1] = {
					widget_type = "weapon",
					display_name = unique_weapon.display_name,
					item = unique_weapon.item,
				}

				if i < #unique_weapons then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							max_width,
							15,
						},
					}
				end
			end
		end

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				max_width,
				25,
			},
		}
	end

	grid:present_grid_layout(layout, ContentBlueprints)
	grid:set_handle_grid_navigation(true)
end

ClassSelectionView._cb_on_open_options_pressed = function (self)
	Managers.ui:open_view("options_view")
end

ClassSelectionView._handle_details_button_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local details_button_text

	if self._archetype_details_visible then
		details_button_text = Localize("loc_mission_voting_view_hide_details")
	else
		details_button_text = Localize("loc_mission_voting_view_show_details")
	end

	widgets_by_name.details_button.content.original_text = Utf8.upper(details_button_text)
end

ClassSelectionView.archetype_options = function (self)
	return self._archetype_options
end

ClassSelectionView.on_archetype_pressed = function (self, target_option)
	self:_on_archetype_pressed(target_option)
end

ClassSelectionView.on_continue_pressed = function (self)
	local selected_specialization_name = temp_archetype_to_specialization_lookup[self._selected_archetype.name]

	self._character_create:set_specialization(self._selected_specialization.name)

	if self._archetype_details_visible then
		self:_play_sound(UISoundEvents.character_create_class_confirm)
		Managers.event:trigger("event_create_new_character_continue")
	else
		if not self._archetype_details_visible or not self._selected_specialization or selected_specialization_name ~= self._selected_specialization.name then
			self._selected_specialization = self._selected_archetype.specializations[selected_specialization_name]

			self:_show_archetypes_widgets(true)
		end

		self:_play_sound(UISoundEvents.character_create_class_select)
	end
end

return ClassSelectionView
