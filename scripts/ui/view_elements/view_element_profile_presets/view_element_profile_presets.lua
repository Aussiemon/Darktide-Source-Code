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

	self:_setup_tooltip_grid()
	self:_setup_preset_buttons()

	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local character_id = player and player:character_id()
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)
	local profile_presets = character_data and character_data.profile_presets
	local intro_presented = profile_presets and profile_presets.intro_presented

	if not intro_presented then
		self:_setup_intro_grid()

		local pulse_tooltip = true

		self:_set_tooltip_visibility(true, pulse_tooltip)

		if not profile_presets and character_data then
			local default_character_data = SaveData.default_character_data
			local default_profile_presets = default_character_data.profile_presets
			profile_presets = table.clone(default_profile_presets)
			character_data.profile_presets = profile_presets

			Managers.save:queue_save()
		end

		if profile_presets then
			profile_presets.intro_presented = true
		end
	else
		self:_setup_custom_icons_grid()
		self:_set_tooltip_visibility(false)
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
		local is_selected = i == active_profile_preset_id

		if is_selected then
			self._active_profile_preset_id = i
		end

		hotspot.is_selected = is_selected
		local default_icon_index = math.index_wrapper(i, #optional_preset_icon_reference_keys)
		local default_icon_key = optional_preset_icon_reference_keys[default_icon_index]
		local default_icon = optional_preset_icons_lookup[custom_icon_key or default_icon_key]
		content.icon = default_icon
		total_width = total_width + button_width

		if i > 1 then
			total_width = total_width + button_spacing
		end
	end

	self._profile_buttons_widgets = profile_buttons_widgets
	local panel_width = total_width + button_width + 45

	self:_set_scenegraph_size("profile_preset_button_panel", panel_width)
	self:_force_update_scenegraph()

	local widgets_by_name = self._widgets_by_name
	local add_button_widget = widgets_by_name.profile_preset_add_button
	add_button_widget.content.hotspot.disabled = ViewElementProfilePresetsSettings.max_profile_presets <= num_profile_presets

	self:_sync_profile_buttons_items_status()
end

ViewElementProfilePresets._sync_profile_buttons_items_status = function (self)
	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = profile_presets and #profile_presets or 0
	local profile_buttons_widgets = self._profile_buttons_widgets

	if num_profile_presets > 0 and profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local profile_preset = profile_presets[i]
			local widget = profile_buttons_widgets[i]
			local content = widget.content
			content.missing_content = self:is_profile_preset_missing_items(profile_preset)
		end
	end
end

ViewElementProfilePresets.is_profile_preset_missing_items = function (self, profile_preset)
	local parent = self._parent
	local loadout = profile_preset.loadout
	local missing_slots = {}

	if loadout then
		for slot_id, gear_id in pairs(loadout) do
			local item = parent:_get_inventory_item_by_id(gear_id)

			if not item then
				missing_slots[slot_id] = true
			end
		end
	end

	return not table.is_empty(missing_slots), missing_slots
end

ViewElementProfilePresets.can_add_profile_preset = function (self)
	local profile_presets = ProfileUtils.get_profile_presets()

	if #profile_presets < ViewElementProfilePresetsSettings.max_profile_presets then
		return true
	end

	return false
end

ViewElementProfilePresets.cb_add_new_profile_preset = function (self)
	if self._intro_active then
		self:_set_tooltip_visibility(false)

		self._intro_active = nil
	end

	local profile_presets = ProfileUtils.get_profile_presets()
	local num_profile_presets = #profile_presets

	if ViewElementProfilePresetsSettings.max_profile_presets <= num_profile_presets then
		return
	end

	self:_play_sound(UISoundEvents.add_profile_preset)

	local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	local active_profile_preset = active_profile_preset_id and ProfileUtils.get_profile_preset(active_profile_preset_id)
	local new_loadout = {}
	local new_talents = nil
	local parent = self._parent

	if active_profile_preset then
		local loadout = active_profile_preset.loadout
		local talents = active_profile_preset.talents
		new_loadout = table.create_copy(nil, loadout)
		new_talents = table.create_copy(nil, talents)
	else
		local player = parent:_player()
		local profile = player:profile()
		local loadout = profile.loadout
		local talents = profile.talents
		new_talents = table.create_copy(nil, talents)

		for slot_id, item in pairs(loadout) do
			local slot = ItemSlotSettings[slot_id]

			if slot.equipped_in_inventory and item.gear_id then
				new_loadout[slot_id] = item.gear_id
			end
		end

		local presentation_loadout = parent._preview_profile_equipped_items

		for slot_id, item in pairs(presentation_loadout) do
			local slot = ItemSlotSettings[slot_id]

			if slot.equipped_in_inventory and item.gear_id then
				new_loadout[slot_id] = item.gear_id
			end
		end
	end

	local optional_preset_icon_reference_keys = ViewElementProfilePresetsSettings.optional_preset_icon_reference_keys
	local icon_index = math.index_wrapper(num_profile_presets + 1, #optional_preset_icon_reference_keys)
	local icon_key = optional_preset_icon_reference_keys[icon_index]
	local profile_preset_id = ProfileUtils.add_profile_preset(new_loadout, new_talents, icon_key)

	if profile_preset_id == 1 then
		ProfileUtils.save_active_profile_preset_id(profile_preset_id)
	end

	self:_setup_preset_buttons()
	self:on_profile_preset_index_change(profile_preset_id)
end

ViewElementProfilePresets._remove_profile_preset = function (self, widget, element)
	local active_customize_preset_index = self._active_customize_preset_index

	if not active_customize_preset_index then
		return
	end

	local widget_content = widget.content
	local widget_hotspot = widget_content.hotspot
	widget_hotspot.anim_hover_progress = 0
	widget_hotspot.anim_input_progress = 0
	widget_hotspot.anim_focus_progress = 0
	widget_hotspot.anim_select_progress = 0
	local previously_active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()
	self._active_profile_preset_id = nil

	ProfileUtils.remove_profile_preset(active_customize_preset_index)

	local new_active_profile_preset_id = previously_active_profile_preset_id and math.max(previously_active_profile_preset_id - 1, 1)

	if new_active_profile_preset_id and not ProfileUtils.get_profile_preset(new_active_profile_preset_id) then
		new_active_profile_preset_id = nil
	end

	self:on_profile_preset_index_customize()
	self:_setup_preset_buttons()

	if new_active_profile_preset_id then
		self:on_profile_preset_index_change(new_active_profile_preset_id)
	else
		ProfileUtils.save_active_profile_preset_id(nil)
	end

	self:_play_sound(UISoundEvents.remove_profile_preset)

	self._costumization_open = false
end

ViewElementProfilePresets.cb_on_profile_preset_icon_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	local grid = self._profile_preset_tooltip_grid
	local grid_length = grid:grid_length()
	local menu_settings = grid:menu_settings()
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, 700)
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

	local profile_preset = ProfileUtils.get_profile_preset(active_customize_preset_index)

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
	local index = self._active_profile_preset_id

	if index then
		self:on_profile_preset_index_customize(index)
	end
end

ViewElementProfilePresets.on_profile_preset_index_customize = function (self, index)
	if index and index == self._active_customize_preset_index then
		return
	end

	if index then
		local profile_preset = ProfileUtils.get_profile_preset(index)

		if not profile_preset then
			return
		end

		if not self._custom_icons_initialized then
			self:_setup_custom_icons_grid()
		end

		self:_play_sound(UISoundEvents.default_click)
	end

	local profile_buttons_widgets = self._profile_buttons_widgets

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
	if self._active_customize_preset_index ~= nil then
		return true
	elseif self._release_input_frame_delay and self._release_input_frame_delay > 0 then
		return true
	end

	return false
end

ViewElementProfilePresets._set_tooltip_visibility = function (self, visible, pulse_tooltip)
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

	local next_profile_preset_index = math.index_wrapper(active_profile_preset_id + 1, #profile_buttons_widgets)

	self:on_profile_preset_index_change(next_profile_preset_index)
end

ViewElementProfilePresets.on_profile_preset_index_change = function (self, index, ignore_activation, ignore_sound)
	local profile_buttons_widgets = self._profile_buttons_widgets

	if profile_buttons_widgets then
		for i = 1, #profile_buttons_widgets do
			local widget = profile_buttons_widgets[i]
			local content = widget.content
			local hotspot = content.hotspot
			hotspot.is_selected = i == index
		end
	end

	if index then
		if self._intro_active then
			self:_set_tooltip_visibility(false)

			self._intro_active = nil
		end

		if not ignore_sound then
			self:_play_sound(UISoundEvents.default_click)
		end
	end

	if not ignore_activation and index ~= self._active_profile_preset_id then
		self._active_profile_preset_id = index

		ProfileUtils.save_active_profile_preset_id(index)

		local parent = self._parent
		local profile_preset = ProfileUtils.get_profile_preset(index)

		if profile_preset then
			local profile_preset_loadout = profile_preset.loadout

			for slot_id, gear_id in pairs(profile_preset_loadout) do
				local item = parent:_get_inventory_item_by_id(gear_id)

				if item then
					parent:_equip_slot_item(slot_id, item)
				end
			end

			local profile_preset_talents = profile_preset.talents
			local player = parent:_player()
			local profile = player:profile()
			local talents = profile.talents
			local combined_talents = table.create_copy(table.clone(talents), profile_preset_talents)

			Managers.event:trigger("event_on_profile_preset_changed", profile_preset_talents)

			local talent_service = Managers.data_service.talents

			talent_service:set_talents(player, combined_talents)
		end
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

ViewElementProfilePresets.update = function (self, dt, t, input_service)
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
