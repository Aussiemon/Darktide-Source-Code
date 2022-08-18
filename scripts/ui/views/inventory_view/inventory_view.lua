local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ContentBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_view/inventory_view_definitions")
local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local MasterItems = require("scripts/backend/master_items")
local Personalities = require("scripts/settings/character/personalities")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local Vo = require("scripts/utilities/vo")
local WalletSettings = require("scripts/settings/wallet_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local VIEW_BY_SLOT = {
	slot_gear_lowerbody = "inventory_cosmetics_view",
	slot_primary = "inventory_weapons_view",
	slot_secondary = "inventory_weapons_view",
	slot_gear_extra_cosmetic = "inventory_cosmetics_view",
	slot_animation_end_of_round = "inventory_cosmetics_view",
	slot_insignia = "inventory_cosmetics_view",
	slot_attachment_1 = "inventory_weapons_view",
	slot_animation_emote_3 = "inventory_cosmetics_view",
	slot_attachment_3 = "inventory_weapons_view",
	slot_gear_upperbody = "inventory_cosmetics_view",
	slot_attachment_2 = "inventory_weapons_view",
	slot_animation_emote_4 = "inventory_cosmetics_view",
	slot_animation_emote_1 = "inventory_cosmetics_view",
	slot_gear_head = "inventory_cosmetics_view",
	slot_animation_emote_5 = "inventory_cosmetics_view",
	slot_portrait_frame = "inventory_cosmetics_view",
	slot_animation_emote_2 = "inventory_cosmetics_view"
}
local InventoryView = class("InventoryView", "BaseView")

InventoryView.init = function (self, settings, context)
	self._context = context
	self._preview_player = context.debug and Managers.player:local_player(1) or context.player
	self._preview_profile_equipped_items = context.preview_profile_equipped_items or {}
	self._is_own_player = self._preview_player == Managers.player:local_player(1)
	self._is_readonly = context and context.is_readonly
	self._loaded_item_icons_info = {}

	InventoryView.super.init(self, Definitions, settings)

	self._allow_close_hotkey = false
	self._pass_input = true
end

InventoryView.on_enter = function (self)
	InventoryView.super.on_enter(self)

	self._item_definitions = MasterItems.get_cached()
	self._inventory_items = {}

	self:_fetch_inventory_items()
	self:_setup_offscreen_gui()

	local tab_menu_back_button_widget = self._widgets_by_name.tab_menu_back_button
	tab_menu_back_button_widget.content.hotspot.pressed_callback = callback(self, "on_back_pressed")

	self:_update_wallets_presentation(nil, not self._is_own_player)

	if self._is_own_player then
		self:_request_wallets_update()
	end

	self:_register_event("event_inventory_view_set_camera_focus")
end

InventoryView._display_title_text = function (self, text)
	local widgets_by_name = self._widgets_by_name
	local title_text_widget = widgets_by_name.tab_menu_title_text
	local tab_menu_back_button_widget = widgets_by_name.tab_menu_back_button
	local visible_title_text = text ~= nil
	title_text_widget.content.visible = visible_title_text
	tab_menu_back_button_widget.content.visible = visible_title_text
	tab_menu_back_button_widget.content.hotspot.anim_hover_progress = 0

	if visible_title_text then
		title_text_widget.content.text = self:_localize(text)
	end
end

InventoryView._set_active_layout_by_index = function (self, index)
	local active_context_tabs = self._active_context_tabs

	if not active_context_tabs then
		return
	end

	local tab_context = active_context_tabs[index]
	local tab_layout = tab_context.layout
	local is_grid_layout = tab_context.is_grid_layout
	local camera_settings = tab_context.camera_settings

	self:_switch_active_layout(tab_layout, is_grid_layout, camera_settings)

	self._selected_tab_index = index

	if self._tab_menu_element then
		self._tab_menu_element:set_selected_index(index)
	end
end

InventoryView._switch_active_layout = function (self, layout, is_grid_layout, camera_settings)
	self._active_category_layout = layout
	self._active_category_camera_settings = camera_settings
	self._is_grid_layout = is_grid_layout

	if is_grid_layout then
		self:_destroy_loadout_widgets()
		self:_setup_grid_layout(layout)
	else
		self:_reset_grid_layout()
		self:_setup_individual_layout(layout)
	end

	self:_set_camera_focus_by_slot_name(nil, camera_settings)
	self:_display_title_text(nil)
end

InventoryView.on_back_pressed = function (self)
	if self._active_category_layout ~= self._visible_grid_layout then
		self:_setup_grid_layout(self._active_category_layout)
		self:_switch_active_layout(self._active_category_layout, self._is_grid_layout, self._active_category_camera_settings)
		self:_display_title_text(nil)

		return true
	end

	return false
end

InventoryView.on_exit = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_loadout_widgets()

	if Managers.ui:view_active("inventory_weapons_view") then
		Managers.ui:close_view("inventory_weapons_view")
	end

	self:_destroy_offscreen_gui()
	InventoryView.super.on_exit(self)
end

InventoryView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 10
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name
	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._world)
end

InventoryView._destroy_offscreen_gui = function (self)
	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_offscreen_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

InventoryView._fetch_inventory_items = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()

	Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		if self._destroyed then
			return
		end

		if self._destroyed then
			return
		end

		self._inventory_items = items
	end)
end

InventoryView._item_valid_by_current_profile = function (self, item)
	local player = self:_player()
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid then
		return true
	end

	return false
end

InventoryView._get_items_layout_by_slot = function (self, slot)
	local slot_name = slot.name
	local layout = {}
	local inventory_items = self._inventory_items

	for item_name, item in pairs(inventory_items) do
		if self:_item_valid_by_current_profile(item) then
			local slots = item.slots
			local widget_type = "item"

			if slot.slot_type == "gear" or slot.slot_type == "ui" then
				widget_type = "cosmetic_item"
			end

			if slots then
				for j = 1, #slots do
					if slots[j] == slot_name then
						layout[#layout + 1] = {
							item = item,
							slot = slot,
							widget_type = widget_type
						}
					end
				end
			end
		end
	end

	return layout
end

InventoryView.event_inventory_view_set_camera_focus = function (self, slot_name)
	self:_set_camera_focus_by_slot_name(slot_name)
end

InventoryView._set_camera_focus_by_slot_name = function (self, slot_name, optional_camera_settings)
	local func_ptr = math.easeCubic

	if slot_name then
		Managers.event:trigger("event_inventory_set_camera_item_slot_focus", slot_name, 1.5, func_ptr)
	elseif optional_camera_settings then
		for i = 1, #optional_camera_settings do
			local camera_settings = optional_camera_settings[i]

			Managers.event:trigger(camera_settings[1], camera_settings[2], camera_settings[3], camera_settings[4], camera_settings[5])
		end
	else
		Managers.event:trigger("event_inventory_set_camera_position_axis_offset", "x", 0, 1, func_ptr)
		Managers.event:trigger("event_inventory_set_camera_position_axis_offset", "y", 0, 1, func_ptr)
		Managers.event:trigger("event_inventory_set_camera_position_axis_offset", "z", 0, 1, func_ptr)
		Managers.event:trigger("event_inventory_set_camera_rotation_axis_offset", "x", 0, 1, func_ptr)
		Managers.event:trigger("event_inventory_set_camera_rotation_axis_offset", "y", 0, 1, func_ptr)
		Managers.event:trigger("event_inventory_set_camera_rotation_axis_offset", "z", 0, 1, func_ptr)
	end
end

InventoryView.cb_on_grid_entry_right_pressed = function (self, widget, element)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local item = element.item

	if item then
		local slots = item.slots

		if slots and not table.contains(slots, "slot_primary") and table.contains(slots, "slot_secondary") then
			-- Nothing
		end
	end
end

InventoryView.equipped_item_in_slot = function (self, slot_name)
	return self._preview_profile_equipped_items[slot_name]
end

InventoryView.cb_on_grid_entry_pressed = function (self, widget, element)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local slot = element.slot

	if slot then
		local slot_name = slot.name

		if element.loadout_slot then
			local view_name = VIEW_BY_SLOT[slot_name]

			if view_name then
				local context = {
					player = self._preview_player,
					player_specialization = self._chosen_specialization,
					preview_profile_equipped_items = self._preview_profile_equipped_items,
					selected_slot = slot
				}

				Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
			else
				local layout = self:_get_items_layout_by_slot(slot)

				self:_setup_grid_layout(layout)
				self:_set_camera_focus_by_slot_name(slot_name)
				self:_display_title_text(element.slot_title)
			end
		else
			local item = element.item

			Managers.event:trigger("event_inventory_view_equip_item", slot_name, item)
			self:_play_voice_preview(slot_name, item)
		end
	end
end

InventoryView._play_voice_preview = function (self, slot_name, item)
	local player = self._preview_player
	local profile = player:profile()
	local voice_fx_preset = item.voice_fx_preset

	if voice_fx_preset then
		local profile_lore = profile.lore

		if slot_name == "slot_gear_head" and profile_lore and Managers.state.voice_over_spawn then
			local personality_key = profile_lore.backstory.personality
			local personality_settings = Personalities[personality_key]
			local sound_event = personality_settings.sample_sound_event

			Vo.play_voice_fx_preset_preview(self._world, voice_fx_preset, sound_event)
		end
	end
end

InventoryView._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		widgets = {}
	end
end

InventoryView._set_group_header_highlight = function (self, group_header, text)
	self._highlighted_group_header = group_header
	self._highlighted_group_header_text = text
end

InventoryView.get_group_header_highlight_text = function (self, group_header)
	if self._highlighted_group_header and self._highlighted_group_header == group_header then
		return self._highlighted_group_header_text
	end
end

InventoryView._reset_grid_layout = function (self)
	self:_destroy_grid_widgets()

	self._visible_grid_layout = nil

	if self._grid_widgets then
		self:_clear_widgets(self._grid_widgets)

		self._grid_widgets = nil
	end

	if self._grid_alignment_widgets then
		self:_clear_widgets(self._grid_alignment_widgets)

		self._grid_alignment_widgets = nil
	end

	if self._grid then
		self._grid:destroy()

		self._grid = nil
	end
end

InventoryView._setup_individual_layout = function (self, layout)
	self._widgets_by_name.grid_background.content.visible = false

	self:_destroy_loadout_widgets()

	local widgets = {}
	local loadout_widget_navigation_grid = {}
	local left_click_callback_name = "cb_on_grid_entry_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local scenegraph_id = entry.scenegraph_id
		local widget, _ = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name, scenegraph_id)
		widgets[#widgets + 1] = widget
		local navigation_grid_indices = entry.navigation_grid_indices

		if navigation_grid_indices then
			local row = navigation_grid_indices[1]
			local column = navigation_grid_indices[2]

			if not loadout_widget_navigation_grid[row] then
				loadout_widget_navigation_grid[row] = {}
			end

			loadout_widget_navigation_grid[row][column] = widget
		end

		widget.content.index = index
	end

	self._loadout_widgets = widgets
	self._loadout_widget_navigation_grid = loadout_widget_navigation_grid

	if not Managers.ui:using_cursor_navigation() then
		self:_select_individual_widget_index(1)
	end
end

InventoryView._setup_grid_layout = function (self, layout)
	self._widgets_by_name.grid_background.content.visible = true

	self:_reset_grid_layout()

	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"
	local previous_group_header_name = nil
	local group_header_index = 0

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local widget, alignment_widget = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name)
		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = alignment_widget

		if widget then
			if entry.widget_type == "group_header" then
				group_header_index = group_header_index + 1
				previous_group_header_name = "group_header_" .. group_header_index
			end

			widget.content.group_header = previous_group_header_name
		end
	end

	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets
	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = InventoryViewSettings.grid_spacing
	local grid = self:_setup_grid(self._grid_widgets, self._grid_alignment_widgets, grid_scenegraph_id, grid_spacing)
	self._grid = grid
	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
	self:_on_navigation_input_changed()
end

InventoryView.cb_switch_tab = function (self, index)
	if index ~= self._selected_tab_index then
		self:_set_active_layout_by_index(index)
	end
end

InventoryView._destroy_previous_tab = function (self)
	if self._tab_menu_element then
		self._tab_menu_element = nil
		local id = "tab_menu"

		self:_remove_element(id)

		self._previous_selected_tab_index = self._selected_tab_index
	end
end

InventoryView._setup_menu_tabs = function (self, content)
	local id = "tab_menu"
	local layer = 10
	local tab_menu_settings = {
		fixed_button_size = true,
		horizontal_alignment = "center",
		button_spacing = 20,
		button_size = {
			200,
			50
		}
	}
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)
	self._tab_menu_element = tab_menu_element
	local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button_icon)
	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
	}
	local tab_ids = {}

	for i = 1, #content do
		local tab_content = content[i]
		local display_name = tab_content.display_name
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(display_name, pressed_callback, tab_button_template, display_icon)
		tab_ids[i] = tab_id
	end

	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

InventoryView._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("grid_tab_panel")

	self._tab_menu_element:set_pivot_offset(position[1], position[2])
end

InventoryView._setup_grid = function (self, widgets, alignment_list, grid_scenegraph_id, spacing)
	local direction = "down"

	return UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, direction, spacing)
end

InventoryView._create_entry_widget_from_config = function (self, config, suffix, callback_name, secondary_callback_name, optional_scenegraph_id)
	local scenegraph_id = optional_scenegraph_id or "grid_content_pivot"
	local widget_type = config.widget_type
	local widget = nil
	local template = ContentBlueprints[widget_type]

	fassert(template, "[InventoryView] - Could not find content blueprint for type: %s", widget_type)

	local size = template.size_function and template.size_function(self, config) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, config) or template.pass_template
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size)

	if widget_definition then
		local name = "widget_" .. suffix
		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type
		local init = template.init

		if init then
			init(self, widget, config, callback_name, secondary_callback_name)
		end

		if widget.content.hotspot then
			widget.content.hotspot.disabled = not self._is_own_player or self._is_readonly
		end
	end

	if widget then
		return widget, widget
	else
		return nil, {
			size = size
		}
	end
end

InventoryView._draw_loadout_widgets = function (self, dt, t, input_service)
	local widgets = self._loadout_widgets
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
end

InventoryView._draw_grid = function (self, dt, t, input_service)
	local grid = self._grid

	if not grid then
		return
	end

	local widgets = self._grid_widgets
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	local render_settings = self._render_settings
	local ui_renderer = self._ui_offscreen_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		if grid:is_widget_visible(widget) then
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_hovered
			end

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

InventoryView._destroy_loadout_widgets = function (self)
	local widgets = self._loadout_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local destroy = template and template.destroy
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end

			if destroy then
				local element = widget.element

				destroy(self, widget, element)
			end
		end
	end

	self._loadout_widgets = nil
	self._loadout_widget_navigation_grid = nil
end

InventoryView._destroy_grid_widgets = function (self)
	local widgets = self._grid_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local destroy = template and template.destroy

			if destroy then
				local element = widget.element

				destroy(self, widget, element)
			end
		end
	end
end

InventoryView._update_blueprint_widgets = function (self, widgets, dt, t, input_service)
	if widgets then
		local handle_input = false

		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local update = template and template.update

			if update then
				update(self, widget, input_service, dt, t)
			end
		end

		if handle_input and self._focused_settings_widget and self._close_focused_setting then
			self._focused_settings_widget.offset[3] = 0

			self:_set_focused_grid_widget(self._settings_content_widgets, nil)

			self._focused_settings_widget = nil
			self._close_focused_setting = nil

			self:_enable_settings_overlay(false)
		end
	end
end

InventoryView._handle_input = function (self, input_service)
	local grid_widgets = self._grid_widgets

	if grid_widgets then
		local new_highlighted_group_header, new_highlighted_group_header_text = nil

		for i = 1, #grid_widgets do
			local widget = grid_widgets[i]
			local content = widget.content
			local hotspot = content.hotspot

			if hotspot and hotspot.is_hover then
				local group_header = content.group_header
				local element = content.element
				local slot_title = element.slot_title
				new_highlighted_group_header_text = slot_title
				new_highlighted_group_header = group_header

				break
			end
		end

		self:_set_group_header_highlight(new_highlighted_group_header, new_highlighted_group_header_text)
	end

	local loadout_widget_navigation_grid = self._loadout_widget_navigation_grid

	if loadout_widget_navigation_grid then
		self:_handle_individual_widget_selection(input_service)
	end
end

InventoryView._get_next_array_index = function (self, direction, start_index, array)
	local array_length = table.size(array)

	if direction > 0 then
		for i = start_index, array_length do
			local value = array[i]

			if value then
				return i
			end
		end
	else
		for i = start_index, 1, -1 do
			local value = array[i]

			if value then
				return i
			end
		end
	end
end

InventoryView._handle_individual_widget_selection = function (self, input_service)
	local current_index = self._selected_individual_widget_index

	if not current_index then
		return
	end

	local loadout_widget_navigation_grid = self._loadout_widget_navigation_grid
	local widgets = self._loadout_widgets
	local selected_widget = widgets[current_index]
	local element = selected_widget and selected_widget.content.element
	local selected_navigation_grid_indices = element.navigation_grid_indices
	local selected_row_index = selected_navigation_grid_indices[1]
	local selected_column_index = selected_navigation_grid_indices[2]
	local new_row_index, new_column_index = nil

	if input_service:get("navigate_up_continuous") then
		new_row_index = self:_get_next_array_index(-1, selected_row_index - 1, loadout_widget_navigation_grid)
	elseif input_service:get("navigate_down_continuous") then
		new_row_index = self:_get_next_array_index(1, selected_row_index + 1, loadout_widget_navigation_grid)
	elseif input_service:get("navigate_left_continuous") then
		new_column_index = self:_get_next_array_index(-1, selected_column_index - 1, loadout_widget_navigation_grid[selected_row_index])
	elseif input_service:get("navigate_right_continuous") then
		new_column_index = self:_get_next_array_index(1, selected_column_index + 1, loadout_widget_navigation_grid[selected_row_index])
	end

	local new_selection_index = nil

	if new_row_index or new_column_index then
		local row = new_row_index or selected_row_index
		local column = new_column_index or selected_column_index
		local widget = loadout_widget_navigation_grid[row][column]

		if widget then
			new_selection_index = widget.content.index

			self:_select_individual_widget_index(new_selection_index)
		end
	end
end

InventoryView._on_navigation_input_changed = function (self)
	InventoryView.super._on_navigation_input_changed(self)

	local grid = self._grid

	if grid then
		if not self._using_cursor_navigation then
			if not grid:selected_grid_index() then
				grid:select_first_index()
			end
		elseif grid:selected_grid_index() then
			grid:select_grid_index(nil)
		end
	elseif self._loadout_widget_navigation_grid then
		if not self._using_cursor_navigation then
			if not self._selected_individual_widget_index then
				self:_select_individual_widget_index(1)
			end
		elseif self._selected_individual_widget_index then
			self:_select_individual_widget_index(nil)
		end
	end
end

InventoryView._select_individual_widget_index = function (self, index)
	local loadout_widgets = self._loadout_widgets

	if loadout_widgets then
		for i = 1, #loadout_widgets do
			local is_selected = i == index
			local widget = loadout_widgets[i]
			widget.content.hotspot.is_selected = is_selected
		end
	end

	self._selected_individual_widget_index = index
end

InventoryView.on_resolution_modified = function (self, scale)
	InventoryView.super.on_resolution_modified(self, scale)

	local grid = self._grid

	if grid then
		grid:on_resolution_modified(scale)
	end

	self:_update_tab_bar_position()
end

InventoryView.update = function (self, dt, t, input_service)
	if self._next_wallet_update_duration then
		self._next_wallet_update_duration = self._next_wallet_update_duration - dt

		if self._next_wallet_update_duration <= 0 then
			self:_request_wallets_update()
		end
	end

	local context = self._context
	local changeable_context = context and context.changeable_context
	local context_tabs = changeable_context and changeable_context.tabs

	if context_tabs ~= self._active_context_tabs then
		self._active_context_tabs = context_tabs

		self:_destroy_previous_tab()

		if #context_tabs > 1 then
			self:_setup_menu_tabs(context_tabs)
		end

		local tab_index = self._previous_selected_tab_index and math.min(self._previous_selected_tab_index, #context_tabs) or 1

		self:_set_active_layout_by_index(tab_index)
	end

	self._weapon_view_open = Managers.ui:view_active("inventory_weapons_view")

	if self._grid then
		self._grid:update(dt, t, input_service)

		local widgets = self._grid_widgets

		self:_update_blueprint_widgets(widgets, dt, t, input_service)
	end

	local loadout_widgets = self._loadout_widgets

	if loadout_widgets then
		self:_update_blueprint_widgets(loadout_widgets, dt, t, input_service)
	end

	return InventoryView.super.update(self, dt, t, input_service)
end

InventoryView.draw = function (self, dt, t, input_service, layer)
	self:_draw_grid(dt, t, input_service)

	if self._loadout_widgets then
		self:_draw_loadout_widgets(dt, t, input_service)
	end

	InventoryView.super.draw(self, dt, t, input_service, layer)
end

InventoryView._request_wallets_update = function (self)
	self._next_wallet_update_duration = nil
	local local_player = self:_player()
	local preview_player = self._preview_player
	local character_id = preview_player:character_id()

	if preview_player and preview_player == local_player then
		local store_service = Managers.data_service.store
		local promise = store_service:combined_wallets()

		promise:next(function (wallets_data)
			self:_update_wallets_presentation(wallets_data)

			self._next_wallet_update_duration = InventoryViewSettings.wallet_sync_delay
		end):catch(function (errors)
			Log.error("InventoryView", "Failed to fetch player wallets")

			self._next_wallet_update_duration = InventoryViewSettings.wallet_sync_delay
		end)
	else
		self:_update_wallets_presentation(nil)
	end
end

InventoryView._update_wallets_presentation = function (self, wallets_data, hide_presentation)
	local text = ""

	if not hide_presentation then
		local sorted_wallet_settings = {}

		table.append_non_indexed(sorted_wallet_settings, WalletSettings)
		table.sort(sorted_wallet_settings, function (a, b)
			return a.sort_order < b.sort_order
		end)

		for i = 1, #sorted_wallet_settings do
			local wallet_settings = sorted_wallet_settings[i]
			local wallet_type = wallet_settings.type
			local backend_index = wallet_settings.backend_index
			local wallet = wallets_data and wallets_data:by_type(wallet_type)
			local string_symbol = wallet_settings.string_symbol
			local balance = wallet and wallet.balance
			local amount = balance and balance.amount or 0
			text = text .. tostring(amount) .. " " .. string_symbol .. "\n"
		end
	end

	self._widgets_by_name.wallet_text.content.text = text
end

return InventoryView
