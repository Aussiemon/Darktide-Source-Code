-- chunkname: @scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup.lua

local Definitions = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_definitions")
local ViewElementTutorialPopupSettings = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_settings")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local TalentBuilderViewTutorialBlueprints = require("scripts/ui/views/talent_builder_view/talent_builder_view_tutorial_blueprints")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementTutorialPopup = class("ViewElementTutorialPopup", "ViewElementBase")

ViewElementTutorialPopup.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementTutorialPopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	local view_name = self._parent.view_name

	self.view_name = view_name
	self._close_callback = context and context.close_callback
	self._popup_pages = context and context.popup_pages or ViewElementTutorialPopupSettings.tutorial_popup_pages

	self:_setup_default_gui()
	self:_setup_tutorial_grid()
	self:_present_tutorial_popup_page(1)
end

ViewElementTutorialPopup._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = self._draw_layer
	local world_name = class_name .. "_ui_default_world"
	local view_name = self._parent.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = class_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(class_name .. "_ui_default_renderer", self._world)
end

ViewElementTutorialPopup._setup_tutorial_grid = function (self)
	local definitions = self._definitions

	if not self._tutorial_grid then
		local grid_scenegraph_id = "tutorial_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 18,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._tutorial_grid = ViewElementGrid:new(self, layer, self._render_scale, grid_settings)

		self._tutorial_grid:set_empty_message("")
	end

	self._widgets_by_name.tutorial_button_1.content.hotspot.pressed_callback = callback(self, "cb_on_tutorial_button_1_pressed")
	self._widgets_by_name.tutorial_button_2.content.hotspot.pressed_callback = callback(self, "cb_on_tutorial_button_2_pressed")
	self._tutorial_window_open_animation_id = self:_start_animation("tutorial_window_open", self._widgets_by_name, self)

	self:_play_sound(UISoundEvents.tutorial_popup_enter)
end

ViewElementTutorialPopup.ui_renderer = function (self)
	return self._ui_default_renderer
end

ViewElementTutorialPopup._update_grid_position = function (self)
	local scenegraph_id = "tutorial_grid"
	local position = self:scenegraph_world_position(scenegraph_id, 1)
	local horizontal_alignment = self._ui_scenegraph[scenegraph_id].horizontal_alignment
	local vertical_alignment = self._ui_scenegraph[scenegraph_id].vertical_alignment

	self._tutorial_grid:set_pivot_offset(position[1], position[2], horizontal_alignment, vertical_alignment)
end

ViewElementTutorialPopup._present_tutorial_popup_page = function (self, page_index)
	local tutorial_popup_pages = self._popup_pages
	local page_content = tutorial_popup_pages[page_index]
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.tutorial_window.content.page_counter = tostring(page_index) .. "/" .. tostring(#tutorial_popup_pages)
	widgets_by_name.tutorial_window.content.title = Localize(page_content.header)
	widgets_by_name.tutorial_window.content.image = page_content.image

	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}
	layout[#layout + 1] = {
		widget_type = "text",
		text = Localize(page_content.text),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			25,
		},
	}

	local grid = self._tutorial_grid

	grid:present_grid_layout(layout, TalentBuilderViewTutorialBlueprints)
	grid:set_handle_grid_navigation(true)

	self._active_tutorial_popup_page = page_index

	self:_update_tutorial_button_texts()
end

ViewElementTutorialPopup._handle_tutorial_button_gamepad_navigation = function (self, input_service)
	local widgets_by_name = self._widgets_by_name

	if input_service:get("navigate_left_continuous") then
		if not widgets_by_name.tutorial_button_1.content.hotspot.is_selected then
			widgets_by_name.tutorial_button_1.content.hotspot.is_selected = true
			widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false

			self:_play_sound(UISoundEvents.default_mouse_hover)
		end
	elseif input_service:get("navigate_right_continuous") and not widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
		widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true

		self:_play_sound(UISoundEvents.default_mouse_hover)
	end
end

ViewElementTutorialPopup._update_tutorial_button_texts = function (self)
	local page_index = self._active_tutorial_popup_page

	if not page_index then
		return
	end

	local tutorial_popup_pages = self._popup_pages
	local page_content = tutorial_popup_pages[page_index]
	local using_cursor_navigation = self._using_cursor_navigation
	local widgets_by_name = self._widgets_by_name
	local button_1_default_text = page_content.button_1 and Localize(page_content.button_1)
	local button_2_default_text = page_content.button_2 and Localize(page_content.button_2)

	widgets_by_name.tutorial_button_1.content.original_text = button_1_default_text or "n/a"
	widgets_by_name.tutorial_button_2.content.original_text = button_2_default_text or "n/a"
	widgets_by_name.tutorial_button_1.content.visible = button_1_default_text ~= nil
	widgets_by_name.tutorial_button_2.content.visible = button_2_default_text ~= nil

	local center_align_buttons = page_content.center_align_buttons or false

	if center_align_buttons then
		self:_set_scenegraph_position("tutorial_button_1", 0)
		self:_set_scenegraph_position("tutorial_button_2", 0)
	else
		local definitions = self._definitions
		local defalault_scenegraph_definition = definitions.scenegraph_definition
		local tutorial_button_1_scenegraph_position = defalault_scenegraph_definition.tutorial_button_1.position

		self:_set_scenegraph_position("tutorial_button_1", tutorial_button_1_scenegraph_position[1])

		local tutorial_button_2_scenegraph_position = defalault_scenegraph_definition.tutorial_button_2.position

		self:_set_scenegraph_position("tutorial_button_2", tutorial_button_2_scenegraph_position[1])
	end

	if using_cursor_navigation then
		widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false
	elseif not widgets_by_name.tutorial_button_1.content.hotspot.is_selected or widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
		widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true
	end

	if not using_cursor_navigation then
		if not widgets_by_name.tutorial_button_1.content.visible then
			widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
			widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true
		elseif not widgets_by_name.tutorial_button_2.content.visible then
			widgets_by_name.tutorial_button_1.content.hotspot.is_selected = true
			widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false
		end
	end
end

ViewElementTutorialPopup.cb_on_tutorial_button_1_pressed = function (self)
	local current_page_index = self._active_tutorial_popup_page or 1

	if current_page_index > 1 then
		local next_page_index = math.max(current_page_index - 1, 1)

		self:_present_tutorial_popup_page(next_page_index)
		self:_play_sound(UISoundEvents.tutorial_popup_slide_previous)
	elseif self._close_callback then
		self._close_callback()
	end
end

ViewElementTutorialPopup.cb_on_tutorial_button_2_pressed = function (self)
	local current_page_index = self._active_tutorial_popup_page or 1

	if current_page_index < #self._popup_pages then
		local next_page_index = math.min(current_page_index + 1, #self._popup_pages)

		self:_present_tutorial_popup_page(next_page_index)
		self:_play_sound(UISoundEvents.tutorial_popup_slide_next)
	elseif self._close_callback then
		self._close_callback()
	end
end

ViewElementTutorialPopup._on_navigation_input_changed = function (self)
	ViewElementTutorialPopup.super._on_navigation_input_changed(self)
	self:_update_tutorial_button_texts()
end

ViewElementTutorialPopup.destroy = function (self, ui_renderer)
	self:_play_sound(UISoundEvents.tutorial_popup_exit)
	self._tutorial_grid:destroy(self._ui_default_renderer)

	self._tutorial_grid = nil
	self._ui_default_renderer = nil

	Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")

	local world = self._world
	local viewport_name = self._viewport_name

	ScriptWorld.destroy_viewport(world, viewport_name)
	Managers.ui:destroy_world(world)

	self._viewport_name = nil
	self._world = nil

	ViewElementTutorialPopup.super.destroy(self, ui_renderer)
end

ViewElementTutorialPopup.update = function (self, dt, t, input_service)
	if not self._tutorial_window_open_animation_id then
		self:_handle_tutorial_button_gamepad_navigation(input_service)

		if input_service:get("back") then
			self:cb_on_tutorial_button_1_pressed()
		end
	end

	if self._tutorial_window_open_animation_id and self:_is_animation_completed(self._tutorial_window_open_animation_id) then
		self._tutorial_window_open_animation_id = nil
	end

	self._tutorial_grid:update(dt, t, input_service)
	self:_update_grid_position()

	return ViewElementTutorialPopup.super.update(self, dt, t, input_service)
end

ViewElementTutorialPopup.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local ui_default_renderer = self._ui_default_renderer

	self._tutorial_grid:draw(dt, t, ui_renderer, render_settings, input_service)
	ViewElementTutorialPopup.super.draw(self, dt, t, ui_default_renderer, render_settings, input_service)
end

ViewElementTutorialPopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementTutorialPopup.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementTutorialPopup.on_resolution_modified = function (self, scale)
	self._tutorial_grid:on_resolution_modified(scale)
	ViewElementTutorialPopup.super.on_resolution_modified(self, scale)
	self:_update_grid_position()
end

ViewElementTutorialPopup.set_render_scale = function (self, scale)
	self._tutorial_grid:set_render_scale(scale)
	ViewElementTutorialPopup.super.set_render_scale(self, scale)
end

ViewElementTutorialPopup.set_draw_layer = function (self, draw_layer)
	self._tutorial_grid:set_draw_layer(draw_layer)

	if self._world then
		local world_name = self._unique_id .. "_ui_default_world"
		local world_layer = draw_layer

		Managers.world:set_world_layer(world_name, world_layer)
	end

	ViewElementGrid.super.set_draw_layer(self, draw_layer)
end

return ViewElementTutorialPopup
