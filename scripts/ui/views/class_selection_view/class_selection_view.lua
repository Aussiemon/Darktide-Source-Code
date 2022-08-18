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
local ClassSelectionViewTestify = GameParameters.testify and require("scripts/ui/views/class_selection_view/class_selection_view_testify")
local ClassSelectionView = class("ClassSelectionView", "BaseView")

ClassSelectionView.init = function (self, settings, context)
	ClassSelectionView.super.init(self, Definitions, settings)

	self._character_create = context.character_create
	self._pass_draw = false
	self._allow_close_hotkey = false
	self._force_character_creation = context.force_character_creation
end

ClassSelectionView.on_enter = function (self)
	ClassSelectionView.super.on_enter(self)
	self:_create_offscreen_renderer()
	self:_setup_input_legend()
	self:_register_button_callbacks()

	self._domain_options = self._character_create:archetype_options()
	local profile = self._character_create:profile()
	self._classes_visible = false

	self:_show_classes_widgets(false, profile.archetype)
end

ClassSelectionView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
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

ClassSelectionView._destroy_offscreen_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

ClassSelectionView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs, 1 do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

ClassSelectionView._register_button_callbacks = function (self)
	self._widgets_by_name.choose_button.content.hotspot.pressed_callback = function ()
		self:_on_choose_pressed()
	end
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

ClassSelectionView._show_classes_widgets = function (self, show, force_domain)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.domain_info.content.visible = not show
	widgets_by_name.domain_info.content.visible = not show
	local selected_domain = nil

	if force_domain ~= nil then
		selected_domain = force_domain
	else
		selected_domain = self._selected_domain
	end

	widgets_by_name.main_title.content.text = string.upper(Localize("loc_class_selection_domain"))

	self:_create_domain_option_widgets()

	self._widgets_by_name.transition_fade.alpha_multiplier = 0

	self:_on_domain_pressed(selected_domain)
end

ClassSelectionView.draw = function (self, dt, t, input_service, layer)
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local render_settings = self._render_settings
	local domain_options_widgets = self._domain_options_widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if domain_options_widgets then
		for i = 1, #domain_options_widgets, 1 do
			local widget = domain_options_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
	ClassSelectionView.super.draw(self, dt, t, input_service, layer)
end

ClassSelectionView.update = function (self, dt, t, input_service)
	if self._new_level_name then
		self:_setup_background_world(self._new_level_name)

		self._new_level_name = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(ClassSelectionViewTestify, self)
	end

	return ClassSelectionView.super.update(self, dt, t, input_service)
end

ClassSelectionView._on_choose_pressed = function (self)
	self:_play_sound(UISoundEvents.character_create_confirm)
	Managers.event:trigger("event_create_new_character_continue")
end

ClassSelectionView._on_back_pressed = function (self)
	self:_play_sound(UISoundEvents.character_create_abort)
	Managers.event:trigger("event_create_new_character_back")
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

	self:_destroy_offscreen_renderer()
	ClassSelectionView.super.on_exit(self)
end

ClassSelectionView._handle_input = function (self, input_service)
	local input_handled = false

	if input_service:get("confirm_pressed") then
		self:_on_choose_pressed()

		input_handled = true
	end

	local domain_options = self._domain_options
	local num_options = nil

	if not input_handled then
		local new_selection_index, current_selection_index = nil
		current_selection_index = (self._selected_domain and table.index_of(domain_options, self._selected_domain)) or 1
		num_options = #domain_options

		if input_service:get("navigate_left_continuous") or input_service:get("navigate_primary_left_pressed") then
			if current_selection_index > 1 then
				new_selection_index = current_selection_index - 1
			end
		elseif (input_service:get("navigate_right_continuous") or input_service:get("navigate_primary_right_pressed")) and current_selection_index < num_options then
			new_selection_index = current_selection_index + 1
		end

		if new_selection_index then
			local target_option = self._domain_options[new_selection_index]

			self:_on_domain_pressed(target_option)
		end
	end
end

ClassSelectionView._on_navigation_input_changed = function (self)
	ClassSelectionView.super._on_navigation_input_changed(self)
end

ClassSelectionView._create_domain_option_widgets = function (self)
	local domain_option_definition = Definitions.domain_option_definition
	local domain_selection_definition = Definitions.domain_selection_definition
	local size = domain_option_definition.size
	local widgets = {}
	local options = self._domain_options
	local num_options = #options
	local widget_width = size[1]
	local spacing = ClassSelectionViewSettings.domain_option_spacing
	local start_offset_x = 0
	local widget_left = self:_create_widget("domain_select_left", domain_selection_definition.left)
	widget_left.offset[1] = -ClassSelectionViewSettings.domain_select_spacing

	for i = 1, num_options, 1 do
		local option = options[i]
		local name = "domain_option_" .. i
		local widget = self:_create_widget(name, domain_option_definition)
		local content = widget.content
		content.icon = option.archetype_icon_selection_large_unselected
		content.icon_highlight = option.archetype_icon_selection_large
		content.hotspot.pressed_callback = callback(self, "_on_domain_pressed", option)
		content.archetype_title = option.archetype_title
		widgets[#widgets + 1] = widget
		widget.offset[1] = start_offset_x
		start_offset_x = start_offset_x + widget_width + spacing
	end

	local widget_right = self:_create_widget("domain_select_right", domain_selection_definition.right)
	widget_right.offset[1] = start_offset_x
	self._domain_options_widgets = widgets

	self:_set_scenegraph_size("domain_options", start_offset_x, nil)

	self._domain_options_select_widget = {
		widget_left,
		widget_right
	}
end

ClassSelectionView._on_domain_pressed = function (self, selected_domain)
	if selected_domain ~= self._selected_domain then
		self._selected_domain = selected_domain

		self._character_create:set_archetype(selected_domain)

		local selected_class = nil

		for class_name, class in pairs(selected_domain.specializations) do
			if class.title and not class.disabled then
				selected_class = self._selected_domain.specializations[class_name]

				break
			end
		end

		self._character_create:set_specialization(selected_class.name)
		self:_play_sound(UISoundEvents.character_create_archetype_pressed)

		local selection_sound_event = selected_domain.selection_sound_event

		self:_play_sound(selection_sound_event)

		if self._fade_animation_id and self:_is_animation_active(self._fade_animation_id) then
			self:_stop_animation(self._fade_animation_id)
		end

		self._widgets_by_name.transition_fade.alpha_multiplier = 1
		self._new_level_name = selected_domain.archetype_selection_level
	end

	local domain_options_widgets = self._domain_options_widgets

	for i = 1, #domain_options_widgets, 1 do
		local widget = domain_options_widgets[i]
		local content = widget.content
		content.hotspot.is_focused = selected_domain.archetype_title == content.archetype_title
	end

	self:_update_domain_info()
end

ClassSelectionView._update_domain_info = function (self)
	local widgets_by_name = self._widgets_by_name
	local selected_domain = self._selected_domain
	widgets_by_name.domain_info.content.title = Localize(selected_domain.archetype_title)
	widgets_by_name.domain_info.content.description = Localize(selected_domain.archetype_description)

	for i = 1, #self._domain_options, 1 do
		local domain_name = self._domain_options[i].name
		widgets_by_name[domain_name .. "_corners"].content.visible = domain_name == selected_domain.name
	end
end

ClassSelectionView._destroy_domain_option_widgets = function (self)
	if self._domain_options_widgets then
		for i = 1, #self._domain_options_widgets, 1 do
			local widget = self._domain_options_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	if self._domain_options_select_widget then
		for i = 1, #self._domain_options_select_widget, 1 do
			local widget = self._domain_options_select_widget[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	self._domain_options_widgets = nil
	self._domain_options_select_widget = nil
end

ClassSelectionView.on_choose_pressed = function (self)
	self:_on_choose_pressed()
end

ClassSelectionView.archetype_options = function (self)
	return self._domain_options
end

ClassSelectionView.on_domain_pressed = function (self, target_option)
	self:_on_domain_pressed(target_option)
end

return ClassSelectionView
