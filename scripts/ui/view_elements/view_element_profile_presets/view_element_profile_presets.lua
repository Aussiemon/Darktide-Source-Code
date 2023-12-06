local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/view_elements/view_element_profile_presets/view_element_profile_presets_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementProfilePresetsSettings = require("scripts/ui/view_elements/view_element_profile_presets/view_element_profile_presets_settings")
local ViewElementProfilePresets = class("ViewElementProfilePresets", "ViewElementBase")

ViewElementProfilePresets.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementProfilePresets.super.init(self, parent, draw_layer, start_scale, Definitions)

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementProfilePresetsSettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementProfilePresetsSettings
	end

	self._is_inventory_ready = false
	self._release_input_frame_delay = 0
	self._is_handling_navigation_input = false
	self._pivot_offset = {
		0,
		0
	}
	self._costumization_open = false
	self._tooltip_visibility = true
	self._presets_id_warning = {}
	self._presets_id_modified = {}

	self:_setup_tooltip_grid()
	self:_setup_preset_buttons()

	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local character_id = player and player:character_id()
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)
	local profile_presets = character_data and character_data.profile_presets
	local account_data = save_manager and save_manager:account_data()
	local intro_presented = account_data and account_data.profile_preset_intro_presented
	local pulse_tooltip = true

	if character_data and not intro_presented then
		self:_setup_intro_grid()
		self:_set_tooltip_visibility(true, pulse_tooltip)

		local trigger_save = false

		if not profile_presets then
			local default_character_data = SaveData.default_character_data
			local default_profile_presets = default_character_data.profile_presets
			profile_presets = table.clone(default_profile_presets)
			character_data.profile_presets = profile_presets
			trigger_save = true
		end

		if profile_presets then
			account_data.profile_preset_intro_presented = true
			trigger_save = true
		end

		if trigger_save then
			Managers.save:queue_save()
		end
	else
		if not profile_presets or #profile_presets > 0 then
			pulse_tooltip = false
		end

		self:_setup_custom_icons_grid()
		self:_set_tooltip_visibility(false, pulse_tooltip)
	end

	local widgets_by_name = self._widgets_by_name
	local add_button_widget = widgets_by_name.profile_preset_add_button
	add_button_widget.content.hotspot.pressed_callback = callback(self, "cb_add_new_profile_preset")
end

ViewElementProfilePresets.sync_profiles_states = function (self)
	self:_sync_profile_buttons_items_status()
end

ViewElementProfilePresets._setup_tooltip_grid = function (self)
	local grid_scenegraph_id = "profile_preset_tooltip_grid"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size
	local mask_padding_size = 40
	local grid_settings = {
		scrollbar_width = 7,
		widget_icon_load_margin = 0,
		use_select_on_focused = false,
		edge_padding = 0,
		hide_dividers = true,
		use_is_focused_for_navigation = false,
		use_terminal_background = false,
		title_height = 0,
		hide_background = true,
		grid_spacing = {
			0,
			0
		},
		grid_size = grid_size,
		mask_size = {
			grid_size[1] + mask_padding_size,
			grid_size[2] + mask_padding_size
		}
	}
	local reference_name = "profile_preset_tooltip_grid"
	local layer = self._draw_layer + 10
	local scale = self._render_scale or RESOLUTION_LOOKUP.scale
	local grid = ViewElementGrid:new(self, layer, scale, grid_settings)
	self._profile_preset_tooltip_grid = grid
end

ViewElementProfilePresets._setup_intro_grid = function (self)
	local layout = {
		{
			widget_type = "dynamic_spacing",
			size = {
				225,
				25
			}
		},
		{
			widget_type = "header",
			text = Localize("loc_inventory_menu_profile_preset_intro_text_1")
		},
		{
			widget_type = "dynamic_spacing",
			size = {
				225,
				20
			}
		},
		{
			widget_type = "header",
			text = Localize("loc_inventory_menu_profile_preset_intro_text_2")
		},
		{
			widget_type = "dynamic_spacing",
			size = {
				225,
				25
			}
		},
		{
			widget_type = "dynamic_spacing",
			size = {
				86,
				40
			}
		},
		{
			texture = "content/ui/materials/icons/generic/aquila",
			widget_type = "texture",
			size = {
				52,
				20
			},
			color = Color.terminal_icon(255, true)
		},
		{
			widget_type = "dynamic_spacing",
			size = {
				86,
				40
			}
		}
	}

	self:_present_tooltip_grid_layout(layout)

	self._intro_active = true
end

ViewElementProfilePresets._setup_custom_icons_grid = function (self)
	self._custom_icons_initialized = true
	local definitions = self._definitions
	local layout = {
		{
			widget_type = "dynamic_spacing",
			size = {
				225,
				10
			}
		},
		{
			widget_type = "header",
			text = Localize("loc_inventory_menu_profile_preset_customize_text")
		},
		{
			widget_type = "dynamic_spacing",
			size = {
				225,
				10
			}
		}
	}
	local optional_preset_icon_reference_keys = ViewElementProfilePresetsSettings.optional_preset_icon_reference_keys
	local optional_preset_icons_lookup = ViewElementProfilePresetsSettings.optional_preset_icons_lookup

	for i = 1, #optional_preset_icon_reference_keys do
		local icon_key = optional_preset_icon_reference_keys[i]
		local icon_texture = optional_preset_icons_lookup[icon_key]
		layout[#layout + 1] = {
			widget_type = "icon",
			icon = icon_texture,
			icon_key = icon_key
		}
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			225,
			10
		}
	}
	layout[#layout + 1] = {
		delete_button = true,
		widget_type = "dynamic_button",
		text = Localize("loc_inventory_menu_profile_preset_delete")
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			225,
			10
		}
	}

	self:_present_tooltip_grid_layout(layout)
end

ViewElementProfilePresets._present_tooltip_grid_layout = function (self, layout)
	local definitions = self._definitions
	local profile_preset_grid_blueprints = definitions.profile_preset_grid_blueprints
	local grid = self._profile_preset_tooltip_grid

	grid:present_grid_layout(layout, profile_preset_grid_blueprints, callback(self, "cb_on_profile_preset_icon_grid_left_pressed"), nil, nil, nil, callback(self, "cb_on_profile_preset_icon_grid_layout_changed"), nil)
end

ViewElementProfilePresets._setup_preset_buttons = function (self)
	local profile_buttons_widgets = self._profile_buttons_widgets

	if profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[i]
			local name = widget.name

			self:_unregister_widget_name(name)
		end

		table.clear(profile_buttons_widgets)
	else
		profile_buttons_widgets = {}
	end

	local button_width = 44
	local button_spacing = 6
	local total_width = 0
	local optional_preset_icon_reference_keys = ViewElementProfilePresetsSettings.optional_preset_icon_reference_keys
	local optional_preset_icons_lookup = ViewElementProfilePresetsSettings.optional_preset_icons_lookup
	local definitions = self._definitions
	local profile_preset_button = definitions.profile_preset_button
	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = profile_presets and #profile_presets or 0

	for i = num_profile_presets, 1, -1 do
		local profile_preset = profile_presets[i]
		local profile_preset_id = profile_preset and profile_preset.id
		local custom_icon_key = profile_preset and profile_preset.custom_icon_key
		local widget_name = "profile_button_" .. i
		local widget = self:_create_widget(widget_name, profile_preset_button)
		profile_buttons_widgets[i] = widget
		local offset = widget.offset
		offset[1] = -total_width
		local content = widget.content
		local hotspot = content.hotspot
		hotspot.pressed_callback = callback(self, "on_profile_preset_index_change", i)
		hotspot.right_pressed_callback = callback(self, "on_profile_preset_index_customize", i)
		local is_selected = profile_preset_id == active_profile_preset_id

		if is_selected then
			self._active_profile_preset_id = profile_preset_id
		end

		hotspot.is_selected = is_selected
		local default_icon_index = math.index_wrapper(i, #optional_preset_icon_reference_keys)
		local default_icon_key = optional_preset_icon_reference_keys[default_icon_index]
		local default_icon = optional_preset_icons_lookup[custom_icon_key or default_icon_key]
		content.icon = default_icon
		content.profile_preset_id = profile_preset_id
		total_width = total_width + button_width

		if i > 1 then
			total_width = total_width + button_spacing
		end
	end

	self._profile_buttons_widgets = profile_buttons_widgets
	local panel_width = total_width + button_width + 45

	self:_set_scenegraph_size("profile_preset_button_panel", panel_width)
	self:_force_update_scenegraph()
	self:_sync_profile_buttons_items_status()
end

ViewElementProfilePresets._sync_profile_buttons_items_status = function (self)
	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = profile_presets and #profile_presets or 0
	local profile_buttons_widgets = self._profile_buttons_widgets

	if num_profile_presets > 0 and profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[i]
			local content = widget.content
			local profile_preset_id = content.profile_preset_id
			content.missing_content = self._presets_id_warning[profile_preset_id]
			content.modified_content = self._presets_id_modified[profile_preset_id]
		end
	end
end

ViewElementProfilePresets.set_current_profile_loadout_status = function (self, show_warning, show_modified)
	self._current_profile_loadout_warning = show_warning
	self._current_profile_loadout_modified = show_modified
end

ViewElementProfilePresets.show_profile_preset_missing_items_warning = function (self, is_missing_content, is_modified_content, optional_preset_id)
	local preset_id = optional_preset_id or self._active_profile_preset_id

	if not preset_id then
		return
	end

	local profile_buttons_widgets = self._profile_buttons_widgets

	for i = 1, #profile_buttons_widgets do
		local widget = profile_buttons_widgets[i]
		local content = widget.content
		local profile_preset_id = content.profile_preset_id

		if profile_preset_id == preset_id then
			content.missing_content = is_missing_content
			content.modified_content = is_modified_content
			self._presets_id_warning[preset_id] = is_missing_content
			self._presets_id_modified[preset_id] = is_modified_content

			break
		end
	end
end

ViewElementProfilePresets.can_add_profile_preset = function (self)
	local profile_presets = ProfileUtils.get_profile_presets()
	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

	if profile_presets and ViewElementProfilePresetsSettings.max_profile_presets <= #profile_presets or self._current_profile_loadout_warning then
		return false
	end

	local active_profile_button_widget = active_profile_preset_id and self:_get_widget_by_preset_id(active_profile_preset_id)

	if active_profile_button_widget and active_profile_button_widget.content.missing_content then
		return false
	end

	return true
end

ViewElementProfilePresets.cb_add_new_profile_preset = function (self)
	if self._intro_active then
		self:_set_tooltip_visibility(false)

		self._intro_active = nil
		self._close_intro_popup = nil
	end

	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = profile_presets and #profile_presets

	if not profile_presets or ViewElementProfilePresetsSettings.max_profile_presets <= num_profile_presets then
		return
	end

	Managers.event:trigger("event_player_save_changes_to_current_preset")

	local profile_preset_id = ProfileUtils.add_profile_preset()

	self:_play_sound(UISoundEvents.add_profile_preset)
	Managers.event:trigger("event_on_player_preset_created", profile_preset_id)
	self:_setup_preset_buttons()

	self._active_profile_preset_id = nil
	local _, profile_preset_widget_index = self:_get_widget_by_preset_id(profile_preset_id)

	self:on_profile_preset_index_change(profile_preset_widget_index)
	Managers.save:queue_save()
	self:_set_tooltip_visibility(self._tooltip_visibility, false)
end

ViewElementProfilePresets._remove_profile_preset = function (self, widget, element)
	local active_customize_preset_index = self._active_customize_preset_index

	if not active_customize_preset_index then
		return
	end

	local profile_preset_id = self:_get_profile_preset_id_by_widget_index(active_customize_preset_index)
	local widget_content = widget.content
	local widget_hotspot = widget_content.hotspot
	widget_hotspot.anim_hover_progress = 0
	widget_hotspot.anim_input_progress = 0
	widget_hotspot.anim_focus_progress = 0
	widget_hotspot.anim_select_progress = 0
	local previously_active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	self._active_profile_preset_id = nil

	ProfileUtils.remove_profile_preset(profile_preset_id)

	if previously_active_profile_preset_id then
		self._presets_id_warning[previously_active_profile_preset_id] = nil
		self._presets_id_modified[previously_active_profile_preset_id] = nil
	end

	self:on_profile_preset_index_customize()
	self:_setup_preset_buttons()

	local next_widget_index = math.max(active_customize_preset_index - 1, 1)
	local new_active_profile_preset_id = self:_get_profile_preset_id_by_widget_index(next_widget_index)

	if new_active_profile_preset_id and not ProfileUtils.get_profile_preset(new_active_profile_preset_id) then
		new_active_profile_preset_id = nil
		next_widget_index = nil
	end

	local on_preset_deleted = true

	self:on_profile_preset_index_change(next_widget_index, nil, on_preset_deleted)
	self:_play_sound(UISoundEvents.remove_profile_preset)

	self._costumization_open = false

	self:_set_tooltip_visibility(self._tooltip_visibility, not new_active_profile_preset_id)
end

ViewElementProfilePresets.cb_on_profile_preset_icon_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	local grid = self._profile_preset_tooltip_grid
	local grid_length = grid:grid_length()
	local menu_settings = grid:menu_settings()
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length + 10, 0, 700)
	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:_set_scenegraph_size("profile_preset_tooltip_grid", nil, new_grid_height + 30)
	self:_set_scenegraph_size("profile_preset_tooltip", nil, new_grid_height + 30)
	self:_update_profile_preset_tooltip_grid_position()
	grid:force_update_list_size()
end

ViewElementProfilePresets.cb_on_profile_preset_icon_grid_left_pressed = function (self, widget, element)
	if element.delete_button then
		self:_remove_profile_preset(widget, element)

		return
	end

	local active_customize_preset_index = self._active_customize_preset_index

	if not active_customize_preset_index then
		return
	end

	local profile_preset_id = self:_get_profile_preset_id_by_widget_index(active_customize_preset_index)
	local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

	if not profile_preset then
		return
	end

	local grid = self._profile_preset_tooltip_grid
	local grid_widgets = grid:widgets()

	for i = 1, #grid_widgets do
		local grid_widget = grid_widgets[i]
		local equipped = grid_widget == widget
		local content = grid_widget.content
		content.equipped = equipped
	end

	local icon_key = element.icon_key

	if icon_key then
		local optional_preset_icons_lookup = ViewElementProfilePresetsSettings.optional_preset_icons_lookup
		local default_icon = optional_preset_icons_lookup[icon_key]

		if default_icon then
			local profile_buttons_widgets = self._profile_buttons_widgets
			local button_widget = profile_buttons_widgets[active_customize_preset_index]

			if button_widget then
				local content = button_widget.content
				content.icon = default_icon
				profile_preset.custom_icon_key = icon_key

				Managers.save:queue_save()
			end
		end
	end
end

ViewElementProfilePresets._update_profile_preset_tooltip_grid_position = function (self)
	if not self._profile_preset_tooltip_grid then
		return
	end

	self:_force_update_scenegraph()

	local position = self:scenegraph_world_position("profile_preset_tooltip_grid")

	self._profile_preset_tooltip_grid:set_pivot_offset(position[1], position[2])
end

ViewElementProfilePresets.has_active_profile_preset = function (self)
	return self._active_profile_preset_id ~= nil
end

ViewElementProfilePresets.customize_active_profile_presets = function (self)
	local active_profile_preset_id = self._active_profile_preset_id
	local profile_preset_widget, profile_preset_widget_index = self:_get_widget_by_preset_id(active_profile_preset_id)

	if profile_preset_widget_index then
		self:on_profile_preset_index_customize(profile_preset_widget_index)
	end
end

ViewElementProfilePresets.on_profile_preset_index_customize = function (self, index)
	if index and index == self._active_customize_preset_index then
		return
	end

	local profile_buttons_widgets = self._profile_buttons_widgets

	if index then
		local widget = profile_buttons_widgets[index]
		local content = widget and widget.content
		local profile_preset_id = content and content.profile_preset_id
		local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

		if not profile_preset then
			return
		end

		if not self._custom_icons_initialized then
			self:_setup_custom_icons_grid()
		end

		self:_play_sound(UISoundEvents.default_click)
	end

	if profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[i]
			local content = widget.content
			local hotspot = content.hotspot
			hotspot.is_focused = i == index
		end
	end

	if not index and self._active_customize_preset_index then
		self._release_input_frame_delay = 1
	end

	self._active_customize_preset_index = index
	local tooltip_visible = index ~= nil

	self:_set_tooltip_visibility(tooltip_visible)

	local profile_preset_button_widget = profile_buttons_widgets and profile_buttons_widgets[index]
	local equipped_icon_texture = profile_preset_button_widget and profile_preset_button_widget.content.icon
	local grid = self._profile_preset_tooltip_grid
	local grid_widgets = grid:widgets()
	local equipped_widget = nil

	for i = 1, #grid_widgets do
		local grid_widget = grid_widgets[i]
		local content = grid_widget.content
		local equipped = content.icon == equipped_icon_texture
		content.equipped = equipped

		if equipped then
			equipped_widget = grid_widget
		end
	end

	if equipped_widget then
		grid:select_grid_widget(equipped_widget)
	end

	self._costumization_open = true
end

ViewElementProfilePresets.handling_input = function (self)
	if self._intro_active then
		return true
	end

	if self._active_customize_preset_index ~= nil then
		return true
	elseif self._release_input_frame_delay and self._release_input_frame_delay > 0 then
		return true
	end

	return false
end

ViewElementProfilePresets._set_tooltip_visibility = function (self, visible, pulse_tooltip)
	self._tooltip_visibility = visible
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.profile_preset_tooltip.content.visible = visible
	widgets_by_name.profile_preset_tooltip.content.pulse = visible and pulse_tooltip
	local add_button_widget = widgets_by_name.profile_preset_add_button
	add_button_widget.content.pulse = pulse_tooltip
	local grid = self._profile_preset_tooltip_grid

	grid:set_visibility(visible)
end

ViewElementProfilePresets.cycle_next_profile_preset = function (self)
	local profile_buttons_widgets = self._profile_buttons_widgets
	local active_profile_preset_id = self._active_profile_preset_id

	if not active_profile_preset_id or not profile_buttons_widgets then
		return
	end

	local _, index = self:_get_widget_by_preset_id(active_profile_preset_id)
	local next_profile_preset_index = math.index_wrapper(index + 1, #profile_buttons_widgets)

	self:on_profile_preset_index_change(next_profile_preset_index)
end

ViewElementProfilePresets._get_widget_by_preset_id = function (self, id)
	local profile_buttons_widgets = self._profile_buttons_widgets

	if profile_buttons_widgets then
		for index = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[index]

			if widget.content.profile_preset_id == id then
				return widget, index
			end
		end
	end
end

ViewElementProfilePresets._get_profile_preset_id_by_widget_index = function (self, index)
	local profile_buttons_widgets = self._profile_buttons_widgets

	if profile_buttons_widgets then
		local widget = profile_buttons_widgets[index]
		local content = widget and widget.content
		local profile_preset_id = content and content.profile_preset_id

		return profile_preset_id
	end
end

ViewElementProfilePresets.on_profile_preset_index_change = function (self, index, ignore_activation, on_preset_deleted, ignore_sound)
	local profile_preset_id = nil
	local profile_buttons_widgets = self._profile_buttons_widgets

	if profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[i]
			local content = widget.content
			local hotspot = content.hotspot
			local is_selected = i == index
			hotspot.is_selected = is_selected

			if is_selected then
				profile_preset_id = content.profile_preset_id
			end
		end
	end

	if index then
		if self._intro_active then
			local pulse_tooltip = not profile_buttons_widgets or #profile_buttons_widgets == 0

			self:_set_tooltip_visibility(false, pulse_tooltip)

			self._intro_active = nil
		end

		if not ignore_sound then
			self:_play_sound(UISoundEvents.profile_preset_clicked)
			self:_play_sound(UISoundEvents.switch_profile_preset)
		end
	end

	if not ignore_activation and (on_preset_deleted or profile_preset_id ~= self._active_profile_preset_id) then
		self._active_profile_preset_id = profile_preset_id

		ProfileUtils.save_active_profile_preset_id(profile_preset_id)

		local profile_preset = ProfileUtils.get_profile_preset(profile_preset_id)

		Managers.event:trigger("event_on_profile_preset_changed", profile_preset, on_preset_deleted)
	end
end

ViewElementProfilePresets._update_profile_presets = function (self, input_service, dt, t)
	if self._active_customize_preset_index then
		local hovering_profile_buttons = false
		local profile_buttons_widgets = self._profile_buttons_widgets

		if profile_buttons_widgets then
			for i = 1, #profile_buttons_widgets do
				local widget = profile_buttons_widgets[i]
				local content = widget.content
				local hotspot = content.hotspot

				if hotspot.is_hover then
					hovering_profile_buttons = false

					break
				end
			end
		end

		local confirm_pressed = input_service:get("confirm_released")
		local left_pressed = input_service:get("left_pressed")
		local right_pressed = input_service:get("right_pressed")
		local close_customization = false

		if (left_pressed or right_pressed) and not hovering_profile_buttons and not self._widgets_by_name.profile_preset_tooltip.content.hotspot.is_hover then
			close_customization = true
		elseif confirm_pressed or input_service:get("back_released") then
			close_customization = true
		end

		if close_customization then
			self:on_profile_preset_index_customize(nil)

			self._costumization_open = false
		end
	end

	if not self._profile_buttons_widgets then
		return false
	end

	local using_gamepad = not self._using_cursor_navigation
	local focused = false

	if focused and self:can_exit() then
		self:set_can_exit(false)
	end
end

ViewElementProfilePresets._on_navigation_input_changed = function (self)
	ViewElementProfilePresets.super._on_navigation_input_changed(self)
end

ViewElementProfilePresets.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("entry_pivot", x, y)
end

ViewElementProfilePresets.on_resolution_modified = function (self, scale)
	ViewElementProfilePresets.super.on_resolution_modified(self, scale)
	self:_update_profile_preset_tooltip_grid_position()
	self._profile_preset_tooltip_grid:set_render_scale(scale)
end

local _device_list = {
	Pad1,
	Keyboard,
	Mouse
}

ViewElementProfilePresets.update = function (self, dt, t, input_service)
	if self._close_intro_popup then
		self:_set_tooltip_visibility(false)

		self._intro_active = nil
		self._close_intro_popup = nil
	end

	if self._intro_active and not self._close_intro_popup then
		local any_input_pressed = false

		if IS_XBS then
			local input_device_list = InputUtils.input_device_list
			local xbox_controllers = input_device_list.xbox_controller

			for i = 1, #xbox_controllers do
				local xbox_controller = xbox_controllers[i]

				if xbox_controller.active() and xbox_controller.any_pressed() then
					any_input_pressed = true

					break
				end
			end
		end

		if not any_input_pressed then
			for _, device in pairs(_device_list) do
				if device and device.active and device.any_pressed() then
					any_input_pressed = true

					break
				end
			end
		end

		if any_input_pressed then
			self._close_intro_popup = true
		end
	end

	if not self._is_inventory_ready then
		local parent = self._parent

		if parent:is_inventory_synced() then
			self._is_inventory_ready = true
		end

		input_service = input_service:null_service()
	end

	if self._release_input_frame_delay then
		self._release_input_frame_delay = self._release_input_frame_delay - 1

		if self._release_input_frame_delay == 0 then
			self._release_input_frame_delay = nil
		end
	end

	self:_update_profile_presets(input_service, dt, t)

	local grid = self._profile_preset_tooltip_grid

	if grid then
		grid:update(dt, t, input_service)

		if self._active_customize_preset_index then
			local equipped_grid_index = nil
			local grid_widgets = grid:widgets()

			for i = 1, #grid_widgets do
				local grid_widget = grid_widgets[i]
				local content = grid_widget.content

				if content.equipped then
					equipped_grid_index = i

					break
				end
			end

			local gamepad_active = InputDevice.gamepad_active

			if not grid:selected_grid_index() then
				if gamepad_active and equipped_grid_index then
					grid:select_grid_index(equipped_grid_index)
				end
			elseif not gamepad_active then
				grid:select_grid_widget(nil)
			end

			local selected_grid_index = grid:selected_grid_index()

			if selected_grid_index and equipped_grid_index and selected_grid_index ~= equipped_grid_index then
				local grid_widget = grid_widgets[selected_grid_index]
				local grid_widget_element = grid_widget and grid_widget.content.element

				if grid_widget_element and not grid_widget_element.delete_button then
					self:cb_on_profile_preset_icon_grid_left_pressed(grid_widget, grid_widget_element)
				end
			end

			input_service = input_service:null_service()
		end
	end

	local add_button_widget = self._widgets_by_name.profile_preset_add_button

	if add_button_widget then
		add_button_widget.content.hotspot.disabled = not self:can_add_profile_preset()
		local index = self._active_profile_preset_id
		local widget = self._profile_buttons_widgets[index]

		if widget then
			add_button_widget.content.missing_content = widget.content.missing_content or self._current_profile_loadout_warning
		else
			add_button_widget.content.missing_content = self._current_profile_loadout_warning
		end
	end

	return ViewElementProfilePresets.super.update(self, dt, t, input_service)
end

ViewElementProfilePresets.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._is_inventory_ready then
		input_service = input_service:null_service()
	end

	local grid = self._profile_preset_tooltip_grid

	if grid then
		grid:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	return ViewElementProfilePresets.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementProfilePresets._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local profile_buttons_widgets = self._profile_buttons_widgets

	if profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	ViewElementProfilePresets.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementProfilePresets._get_input_text = function (self, input_action)
	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(input_action)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

	return tostring(input_text)
end

ViewElementProfilePresets.set_input_actions = function (self, input_action_left, input_action_right)
	self._input_action_left = input_action_left
	self._input_action_right = input_action_right

	self:_update_input_action_texts()
end

ViewElementProfilePresets.set_is_handling_navigation_input = function (self, is_enabled)
	self._is_handling_navigation_input = is_enabled
end

ViewElementProfilePresets._update_input_action_texts = function (self)
	local using_cursor_navigation = self._using_cursor_navigation
	local input_action_left = self._input_action_left
	local input_action_right = self._input_action_right
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.input_text_left.content.text = not using_cursor_navigation and input_action_left and self:_get_input_text(input_action_left) or ""
	widgets_by_name.input_text_right.content.text = not using_cursor_navigation and input_action_right and self:_get_input_text(input_action_right) or ""
end

ViewElementProfilePresets.destroy = function (self, ui_renderer)
	self._profile_preset_tooltip_grid:destroy(ui_renderer)

	self._profile_preset_tooltip_grid = nil

	ViewElementProfilePresets.super.destroy(self, ui_renderer)
end

ViewElementProfilePresets.is_costumization_open = function (self)
	return self._costumization_open
end

return ViewElementProfilePresets
