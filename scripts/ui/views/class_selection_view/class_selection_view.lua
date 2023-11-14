local Definitions = require("scripts/ui/views/class_selection_view/class_selection_view_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local TextUtils = require("scripts/utilities/ui/text")
local MasterItems = require("scripts/backend/master_items")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ContentBlueprints = require("scripts/ui/views/class_selection_view/class_selection_view_blueprints")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local InputUtils = require("scripts/managers/input/input_utils")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local UISettings = require("scripts/settings/ui/ui_settings")
local CharacterSheet = require("scripts/utilities/character_sheet")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local ClassSelectionViewTestify = GameParameters.testify and require("scripts/ui/views/class_selection_view/class_selection_view_testify")
local PACKAGE_BASE_PATH = "packages/ui/views/talents_view/"
local ClassSelectionView = class("ClassSelectionView", "BaseView")
local default_classes = {
	veteran = "veteran_2",
	psyker = "psyker_2",
	zealot = "zealot_2",
	ogryn = "ogryn_2"
}

ClassSelectionView.init = function (self, settings, context)
	ClassSelectionView.super.init(self, Definitions, settings)

	self._character_create = context.character_create
	self._pass_draw = false
	self._allow_close_hotkey = false
	self._force_character_creation = context.force_character_creation
end

ClassSelectionView.on_enter = function (self)
	ClassSelectionView.super.on_enter(self)

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	self:_setup_input_legend()
	self:_register_button_callbacks()

	self._archetype_options = self._character_create:archetype_options()
	local profile = self._character_create:profile()
	self._classes_visible = false

	self:_create_archetype_option_widgets()
	self:_show_classes_widgets(false, profile.archetype)

	self._setup_complete = true
end

ClassSelectionView._start_loading_talent_icons = function (self)
	local all_specializations = {}

	for i = 1, #self._archetype_options do
		local archetype = self._archetype_options[i]

		for class_name, class_data in pairs(archetype.specializations) do
			if class_data.title and not class_data.disabled then
				all_specializations[#all_specializations + 1] = class_data.name
			end
		end

		all_specializations[#all_specializations + 1] = archetype.name
	end

	self._talents_load_id = {}
	self._loaded_icons = {
		count = 0,
		all_loaded = false
	}

	for i = 1, #all_specializations do
		local specialization_name = all_specializations[i]
		local package_name = PACKAGE_BASE_PATH .. specialization_name
		self._talents_load_id[#self._talents_load_id + 1] = Managers.package:load(package_name, "ClassSelectionView", callback(self, "_should_load_icons"))
	end
end

ClassSelectionView._should_load_icons = function (self)
	self._loaded_icons.count = self._loaded_icons.count + 1
	self._loaded_icons.all_loaded = #self._talents_load_id == self._loaded_icons.count

	if self._loaded_icons.all_loaded then
		local class_abilities_info_widgets = self._class_abilities_info_widgets

		if self._class_abilities_info_widgets and class_abilities_info_widgets then
			for i = 1, #class_abilities_info_widgets do
				local widget = class_abilities_info_widgets[i]

				if widget.type == "ability" then
					local template = ContentBlueprints[widget.type]

					template.load_icon(widget, widget.element)
				end
			end
		end
	end
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
	self._widgets_by_name.continue_button.content.hotspot.pressed_callback = function ()
		self:_on_continue_pressed()
	end

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
	if self._present_detailed_class_info then
		self._present_detailed_class_info = false

		self:_create_class_abilities_info()
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

ClassSelectionView._on_choose_pressed = function (self)
	if self._classes_visible then
		self._character_create:set_specialization(self._selected_specialization.name)
		self:_play_sound(UISoundEvents.character_create_class_confirm)
		Managers.event:trigger("event_create_new_character_continue")
	else
		self:_on_class_pressed(self._selected_specialization.name)
	end
end

ClassSelectionView._on_continue_pressed = function (self)
	self._character_create:set_specialization(self._selected_specialization.name)

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

	if self._classes_visible then
		self:_show_classes_widgets(false)
	else
		self:_show_classes_widgets(true)
	end
end

ClassSelectionView._on_back_pressed = function (self)
	Managers.event:trigger("event_create_new_character_back")
	self:_play_sound(UISoundEvents.character_create_abort)
end

ClassSelectionView._on_quit_pressed = function (self)
	local context = {
		title_text = "loc_popup_header_quit_game",
		description_text = "loc_popup_description_quit_game",
		options = {
			{
				text = "loc_popup_button_continue_game",
				close_on_pressed = true,
				hotkey = "back"
			},
			{
				text = "loc_popup_button_quit_game",
				close_on_pressed = true,
				callback = callback(function ()
					Application.quit()
				end)
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

ClassSelectionView.on_exit = function (self)
	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ClassSelectionView.super.on_exit(self)

	if self._talents_load_id then
		for i = 1, #self._talents_load_id do
			local load_id = self._talents_load_id[i]

			Managers.package:release(load_id)
		end
	end
end

ClassSelectionView._handle_input = function (self, input_service)
	local input_handled = false

	if not self._using_cursor_navigation then
		if input_service:get("secondary_action_pressed") then
			self:_on_details_pressed()

			input_handled = true
		elseif input_service:get("confirm_pressed") then
			self:_on_continue_pressed()

			input_handled = true
		end
	end

	local archetype_options = self._archetype_options
	local num_options = nil

	if not input_handled then
		local new_selection_index, current_selection_index = nil
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

	local archetype_option_definition = Definitions.archetype_option_definition
	local archetype_selection_definition = Definitions.archetype_selection_definition
	local size = archetype_option_definition.size
	local widgets = {}
	local options = self._archetype_options
	local num_options = #options
	local widget_width = size[1]
	local spacing = ClassSelectionViewSettings.archetype_option_spacing
	local start_offset_x = 0
	local widget_left = self:_create_widget("archetype_select_left", archetype_selection_definition.left)
	widget_left.offset[1] = -ClassSelectionViewSettings.archetype_select_spacing

	for i = 1, num_options do
		local option = options[i]
		local name = "archetype_option_" .. i
		local widget = self:_create_widget(name, archetype_option_definition)
		local content = widget.content
		content.icon_highlight = option.archetype_class_selection_icon

		content.hotspot.pressed_callback = function ()
			if self._using_cursor_navigation then
				self:_on_archetype_pressed(option)
			end
		end

		content.archetype_title = option.archetype_title
		widgets[#widgets + 1] = widget
		widget.offset[1] = start_offset_x
		start_offset_x = start_offset_x + widget_width + spacing
	end

	local widget_right = self:_create_widget("archetype_select_right", archetype_selection_definition.right)
	widget_right.offset[1] = start_offset_x
	self._archetype_options_widgets = widgets

	self:_set_scenegraph_size("archetype_options", start_offset_x - spacing, nil)

	self._archetype_options_select_widget = {
		widget_left,
		widget_right
	}
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
		content.hotspot.is_selected = selected_archetype.archetype_title == content.archetype_title
		content.hotspot.is_focused = selected_archetype.archetype_title == content.archetype_title
	end

	if self._classes_visible then
		self:_show_class_details(false)

		self._widgets_by_name.class_background.content.visible = false

		self:_enable_blur(false)

		self._classes_visible = false

		self:_handle_details_button_text()
	end

	local selected_specialization_name = nil

	for class_name, class in pairs(self._selected_archetype.specializations) do
		if class.title and not class.disabled and class.name == default_classes[self._selected_archetype.name] then
			selected_specialization_name = class_name

			break
		end
	end

	self._selected_specialization = self._selected_archetype.specializations[selected_specialization_name]

	self:_update_archetype_info()
end

local archetype_titles = {
	psyker = "loc_class_psyker-psykinetic_title",
	veteran = "loc_class_veteran-sharpshooter_title",
	zealot = "loc_class_zealot-preacher_title",
	ogryn = "loc_class_ogryn-skullbreaker_title",
	psyker = "loc_class_psyker_title",
	ogryn = "loc_class_ogryn_title",
	veteran = "loc_class_veteran_title",
	zealot = "loc_class_zealot_title"
}

ClassSelectionView._update_archetype_info = function (self)
	local widgets_by_name = self._widgets_by_name
	local selected_archetype = self._selected_archetype
	local widget = widgets_by_name.archetype_info
	local title_margin = 100
	local vertical_margin = 20
	local max_width = self._ui_scenegraph.archetype_info.size[1] - title_margin
	local title = Localize(archetype_titles[selected_archetype.name])
	local title_style = widget.style.title
	local title_style_options = UIFonts.get_font_options_by_style(title_style)
	local title_width, title_height = self:_text_size(title, title_style.font_type, title_style.font_size, {
		max_width,
		2000
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
	local title = nil

	if self._classes_visible then
		title = choose_button_display_name
	else
		title = details_button_display_name
	end

	widgets_by_name.choose_button.content.text = title
end

ClassSelectionView._show_classes_widgets = function (self, show, force_archetype)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.class_background.content.visible = show
	local selected_archetype = nil

	if force_archetype ~= nil then
		selected_archetype = force_archetype
	else
		selected_archetype = self._selected_archetype
	end

	self:_enable_blur(show)

	if show then
		self:_show_class_details(true)

		if self._fade_animation_id and self:_is_animation_active(self._fade_animation_id) then
			self:_stop_animation(self._fade_animation_id)
		end

		self._widgets_by_name.transition_fade.alpha_multiplier = 0.5
	else
		widgets_by_name.main_title.content.visible = true
		widgets_by_name.main_title.content.text = Utf8.upper(Localize("loc_class_selection_choose_class"))

		self:_show_class_details(false)

		self._widgets_by_name.transition_fade.alpha_multiplier = 0

		self:_on_archetype_pressed(selected_archetype)
	end

	self._classes_visible = show

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

ClassSelectionView._create_class_option_widgets = function (self)
	self:_destroy_class_option_widgets()

	local definitions = self._definitions
	local class_option_definition = definitions.class_option_definition
	local option = self._selected_archetype
	local widgets = {}
	local size = ClassSelectionViewSettings.class_option_icon_size
	local spacing = ClassSelectionViewSettings.class_select_spacing
	local start_offset_x = 0
	local count = 0

	for class_name, class in pairs(option.specializations) do
		if class.title and not class.disabled then
			count = count + 1
			local name = "option_" .. count
			local widget = self:_create_widget(name, class_option_definition)
			local content = widget.content
			content.hotspot.pressed_callback = callback(self, "_on_class_pressed", class_name)
			widgets[#widgets + 1] = widget
			widget.offset[1] = start_offset_x
			start_offset_x = start_offset_x + size[1] + spacing
			content.hotspot.is_selected = class.title == self._selected_specialization.title
			content.hotspot.is_focused = class.title == self._selected_specialization.title
			content.class_name = class_name
			content.title = Utf8.upper(Localize(class.title))
			widget.style.icon.material_values.main_texture = class.specialization_banner
		end
	end

	self._class_options_widgets = widgets
end

ClassSelectionView._on_class_pressed = function (self, class_name)
	if not self._classes_visible or not self._selected_specialization or class_name ~= self._selected_specialization.name then
		self._selected_specialization = self._selected_archetype.specializations[class_name]

		self:_show_classes_widgets(true)
	end

	self:_play_sound(UISoundEvents.character_create_class_select)
end

ClassSelectionView._destroy_archetype_option_widgets = function (self)
	if self._archetype_options_widgets then
		for i = 1, #self._archetype_options_widgets do
			local widget = self._archetype_options_widgets[i]

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
	self._archetype_options_select_widget = nil
end

ClassSelectionView._destroy_class_abilities_info = function (self)
	self._present_detailed_class_info = false

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

ClassSelectionView._show_class_details = function (self, show)
	local widgets_by_name = self._widgets_by_name

	if show then
		widgets_by_name.class_background.content.class_background = self._selected_archetype.archetype_icon_large
		self._present_detailed_class_info = true
	else
		self:_destroy_class_abilities_info()
	end
end

ClassSelectionView._create_class_abilities_info = function (self)
	self:_destroy_class_abilities_info()

	local definitions = self._definitions
	local max_width = ClassSelectionViewSettings.class_details_size[1]

	if not self._details_grid then
		local grid_scenegraph_id = "class_details_mask"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			scrollbar_width = 7,
			hide_dividers = true,
			enable_gamepad_scrolling = true,
			use_parent_ui_renderer = false,
			widget_icon_load_margin = 5000,
			title_height = 0,
			scrollbar_horizontal_offset = 22,
			hide_background = true,
			grid_spacing = {
				0,
				0
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 40,
				grid_size[2] + mask_padding_size
			}
		}
		local layer = (self._draw_layer or 0) + 10
		self._details_grid = self:_add_element(ViewElementGrid, "class_details_mask", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("class_details_mask", self._details_grid)
		self._details_grid:set_empty_message("")
	end

	local grid = self._details_grid
	local selected_specialization = self._selected_specialization
	local class_name = selected_specialization.name
	local selected_archetype = self._selected_archetype
	local archetype_name = selected_archetype.name
	local specialization_info = selected_archetype.specializations[class_name]
	local layout = {
		[#layout + 1] = {
			widget_type = "video",
			video_path = selected_specialization.video
		},
		[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				max_width,
				25
			}
		}
	}
	local archetype = self._selected_archetype

	if archetype then
		local nodes_to_present = {}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				max_width,
				25
			}
		}
		local base_class_loadout = {
			ability = {},
			blitz = {},
			aura = {},
			iconics = {}
		}
		local profile = self._character_create:profile()
		local force_base_talents = true

		CharacterSheet.class_loadout(profile, base_class_loadout, force_base_talents)

		local ability_talent = base_class_loadout.ability.talent
		nodes_to_present[#nodes_to_present + 1] = {
			type = "ability",
			widget_type = "talent_info",
			talent = ability_talent,
			icon = base_class_loadout.ability.icon
		}
		local blitz_talent = base_class_loadout.blitz.talent
		nodes_to_present[#nodes_to_present + 1] = {
			type = "tactical",
			widget_type = "talent_info",
			talent = blitz_talent,
			icon = base_class_loadout.blitz.icon
		}
		local aura_talent = base_class_loadout.aura.talent
		nodes_to_present[#nodes_to_present + 1] = {
			type = "aura",
			widget_type = "talent_info",
			talent = aura_talent,
			icon = base_class_loadout.aura.icon
		}
		local iconics = base_class_loadout.iconics

		for i = 1, #iconics do
			local iconic = iconics[i]
			nodes_to_present[#nodes_to_present + 1] = {
				type = "iconic",
				widget_type = "stat",
				talent = iconic
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

			local description, display_name = nil
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
				local gradient_map, frame, icon_mask = nil
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
						text = Localize(settings_by_node_type.display_name)
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							max_width,
							10
						}
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
					node_type = node_type
				}

				if node_type ~= "iconic" then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							max_width,
							25
						}
					}
				end
			end
		end

		local unique_weapons = {}

		if selected_specialization.unique_weapons then
			for i = 1, #selected_specialization.unique_weapons do
				local weapon = selected_specialization.unique_weapons[i]
				local item = MasterItems.get_item(weapon.item)

				if item then
					unique_weapons[#unique_weapons + 1] = {
						item = table.clone_instance(item),
						display_name = weapon.display_name
					}
				end
			end
		end

		if #unique_weapons > 0 then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					max_width,
					20
				}
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize("loc_class_selection_specialization_class_unique_weapons_title")
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					max_width,
					25
				}
			}

			for i = 1, #unique_weapons do
				local unique_weapon = unique_weapons[i]
				layout[#layout + 1] = {
					widget_type = "weapon",
					display_name = unique_weapon.display_name,
					item = unique_weapon.item
				}

				if i < #unique_weapons then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							max_width,
							15
						}
					}
				end
			end
		end

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				max_width,
				25
			}
		}
	end

	grid:present_grid_layout(layout, ContentBlueprints)
	grid:set_handle_grid_navigation(true)
end

ClassSelectionView.on_choose_pressed = function (self)
	self:_on_choose_pressed()
end

ClassSelectionView.archetype_options = function (self)
	return self._archetype_options
end

ClassSelectionView.on_archetype_pressed = function (self, target_option)
	self:_on_archetype_pressed(target_option)
end

ClassSelectionView._cb_on_open_options_pressed = function (self)
	Managers.ui:open_view("options_view")
end

ClassSelectionView._handle_details_button_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local service_type = DefaultViewInputSettings.service_type
	local show_class_info_button_action = "confirm_pressed"
	local details_button_text = nil

	if self._classes_visible then
		details_button_text = Localize("loc_mission_voting_view_hide_details")
	else
		details_button_text = Localize("loc_mission_voting_view_show_details")
	end

	widgets_by_name.details_button.content.original_text = Utf8.upper(details_button_text)
end

return ClassSelectionView
