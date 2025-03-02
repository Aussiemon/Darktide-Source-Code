﻿-- chunkname: @scripts/ui/views/havoc_lore_view/havoc_lore_view.lua

local HavocLoreViewDefinitions = require("scripts/ui/views/havoc_lore_view/havoc_lore_view_definitions")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local HavocLoreView = class("HavocLoreView", "BaseView")

HavocLoreView.init = function (self, settings, context)
	HavocLoreView.super.init(self, HavocLoreViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
end

HavocLoreView.on_enter = function (self)
	HavocLoreView.super.on_enter(self)
	self:_setup_lore_grid()

	self._widgets_by_name.trailer_button.content.hotspot.pressed_callback = callback(self, "_cb_on_trailer_button_pressed")
	self._enter_animation_id = self:_start_animation("on_enter", self._widgets_by_name, self)
end

HavocLoreView._handle_input = function (self, input_service, dt, t)
	local gamepad_action = self._widgets_by_name.trailer_button.content.gamepad_action

	if gamepad_action and not Managers.ui:using_cursor_navigation() and input_service:get(gamepad_action) then
		self:_cb_on_trailer_button_pressed()
	end
end

HavocLoreView.draw = function (self, dt, t, input_service, layer)
	local render_settings = self._render_settings
	local alpha_multiplier = render_settings.alpha_multiplier
	local animation_alpha_multiplier = self.animation_alpha_multiplier or 0

	render_settings.alpha_multiplier = animation_alpha_multiplier

	HavocLoreView.super.draw(self, dt, t, input_service, layer)

	render_settings.alpha_multiplier = alpha_multiplier
end

HavocLoreView.on_resolution_modified = function (self, scale)
	HavocLoreView.super.on_resolution_modified(self, scale)
end

HavocLoreView.on_back_pressed = function (self)
	Managers.event:trigger("event_reset_havoc_background_view")

	return true
end

HavocLoreView._cb_on_trailer_button_pressed = function (self)
	if Managers.ui:view_active("video_view") then
		return
	end

	self:_play_sound(UISoundEvents.story_mission_lore_screen_play_video)
	Managers.ui:open_view("video_view", nil, nil, nil, nil, {
		allow_skip_input = true,
		template = "s1_intro",
	})
end

HavocLoreView.update = function (self, dt, t, input_service)
	return HavocLoreView.super.update(self, dt, t, input_service)
end

HavocLoreView.on_exit = function (self)
	if self._enter_animation_id then
		self:_stop_animation(self._enter_animation_id)

		self._enter_animation_id = nil
	end

	HavocLoreView.super.on_exit(self)
end

HavocLoreView.ui_renderer = function (self)
	return self._ui_renderer
end

HavocLoreView._setup_lore_grid = function (self)
	local definitions = self._definitions

	if not self._lore_grid then
		local grid_scenegraph_id = "lore_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 25,
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

		self._lore_grid = self:_add_element(ViewElementGrid, "lore_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("lore_grid", self._lore_grid)
		self._lore_grid:set_empty_message("")
	end

	local grid = self._lore_grid
	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			25,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_1"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			50,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body_centered",
		text = Localize("loc_story_mission_lore_menu_body_text_2"),
		text_color = Color.terminal_text_body(255, true),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			40,
		},
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			25,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_3"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			50,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_4"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			50,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_5"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			50,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_6"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_7"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}
	layout[#layout + 1] = {
		widget_type = "body",
		text = Localize("loc_story_mission_lore_menu_body_text_8"),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			25,
		},
	}

	grid:present_grid_layout(layout, HavocLoreViewDefinitions.grid_blueprints)
	grid:set_handle_grid_navigation(true)
end

return HavocLoreView
