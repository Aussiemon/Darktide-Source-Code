-- chunkname: @scripts/ui/views/inventory_view/inventory_view.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ContentBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_view/inventory_view_definitions")
local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Personalities = require("scripts/settings/character/personalities")
local ProfileUtils = require("scripts/utilities/profile_utils")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtilities = require("scripts/utilities/ui/text")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local Vo = require("scripts/utilities/vo")
local WalletSettings = require("scripts/settings/wallet_settings")
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
local DIRECTION = {
	RIGHT = "right",
	UP = "up",
	LEFT = "left",
	DOWN = "down"
}
local InventoryView = class("InventoryView", "BaseView")

InventoryView.init = function (self, settings, context)
	self._context = context
	self._parent = context and context.parent
	self._preview_player = context.debug and Managers.player:local_player(1) or context.player
	self._preview_profile_equipped_items = context.preview_profile_equipped_items or {}
	self._current_profile_equipped_items = context.current_profile_equipped_items or table.clone(self._preview_profile_equipped_items)
	self._is_own_player = self._preview_player == Managers.player:local_player(1)
	self._is_readonly = context and context.is_readonly
	self._loaded_item_icons_info = {}
	self._num_active_wallet_widgets = 0
	self._wallet_widgets = {}
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	InventoryView.super.init(self, Definitions, settings, context)

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

	self._item_stats = self:_setup_item_stats("item_stats", "item_stats_pivot")

	if self._using_cursor_navigation then
		self:on_item_stats_toggled(true)
	else
		local character_data = self:_character_save_data()

		if character_data and character_data.view_settings and character_data.view_settings.inventory_view_item_stats_toggled then
			self:on_item_stats_toggled(true)
		else
			self:on_item_stats_toggled(false)
		end
	end

	self:_register_event("event_inventory_view_set_camera_focus")
	self:_register_event("event_force_wallet_update")
end

InventoryView._get_inventory_item_by_id = function (self, gear_id)
	if not gear_id then
		return
	end

	local inventory_items = self._inventory_items

	for _, item in pairs(inventory_items) do
		if item.gear_id == gear_id then
			return item
		end
	end
end

InventoryView._character_save_data = function (self)
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local character_id = player and player:character_id()
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)

	return character_data
end

InventoryView._setup_item_stats = function (self, reference_name, scenegraph_id)
	local layer = 10
	local context = self._definitions.item_stats_grid_settings
	local item_stats = self:_add_element(ViewElementWeaponStats, reference_name, layer, context)

	self:_update_item_stats_position(scenegraph_id, item_stats)

	return item_stats
end

InventoryView._update_item_stats_position = function (self, scenegraph_id, item_stats)
	local position = self:_scenegraph_world_position(scenegraph_id)

	item_stats:set_pivot_offset(position[1], position[2])
end

InventoryView._on_item_hover_start = function (self, item)
	if self._currently_hovered_item then
		if self._item_stats then
			self._item_stats:stop_presenting()
		end

		self._currently_hovered_item = nil
	end

	self._currently_hovered_item = item

	if self._item_stats and item then
		local profile = self._preview_player:profile()
		local context = {
			inventory_items = self._inventory_items,
			profile = profile
		}

		self._item_stats:present_item(item, context)
	end
end

InventoryView._on_item_hover_stop = function (self)
	self._currently_hovered_item = nil

	if self._item_stats then
		self._item_stats:stop_presenting()
	end
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

	self:_switch_active_layout(tab_context)

	self._selected_tab_index = index

	if self._tab_menu_element then
		self._tab_menu_element:set_selected_index(index)
	end
end

InventoryView._switch_active_layout = function (self, tab_context)
	local layout = tab_context.layout
	local is_grid_layout = tab_context.is_grid_layout
	local camera_settings = tab_context.camera_settings
	local ui_animation = tab_context.ui_animation
	local draw_wallet = tab_context.draw_wallet
	local allow_item_hover_information = tab_context.allow_item_hover_information
	local item_hover_information_offset = tab_context.item_hover_information_offset

	self._active_category_tab_context = tab_context
	self._allow_item_hover_information = allow_item_hover_information

	if is_grid_layout then
		self:_destroy_loadout_widgets(self._ui_renderer)
		self:_setup_grid_layout(layout)
		self:_on_navigation_input_changed()
	else
		self:_reset_grid_layout(self._ui_offscreen_renderer)
		self:_setup_individual_layout(layout)

		self._current_selected_loadout_index = nil
	end

	self:_set_camera_focus_by_slot_name(nil, camera_settings)
	self:_display_title_text(nil)

	if self._entry_animation_id then
		self:_stop_animation(self._entry_animation_id)

		self._entry_animation_id = nil
	end

	local definitions = self._definitions
	local default_scenegraph_definition = definitions.scenegraph_definition
	local scenegraph_id = "item_stats_pivot"
	local default_scenegraph = default_scenegraph_definition[scenegraph_id]
	local default_scenegraph_position = default_scenegraph.position

	if item_hover_information_offset then
		self:_set_scenegraph_position("item_stats_pivot", item_hover_information_offset[1] or default_scenegraph_position[1], item_hover_information_offset[2] or default_scenegraph_position[2], item_hover_information_offset[3] or default_scenegraph_position[3])
	else
		self:_set_scenegraph_position("item_stats_pivot", default_scenegraph_position[1], default_scenegraph_position[2], default_scenegraph_position[3])
	end

	if ui_animation then
		self._entry_animation_id = self:_start_animation(ui_animation, self._widgets, self)
	end

	if self._draw_wallet ~= draw_wallet then
		if self._wallet_animation_id then
			self:_stop_animation(self._wallet_animation_id)

			self._wallet_animation_id = nil
		end

		if draw_wallet then
			self._wallet_animation_id = self:_start_animation("wallet_on_enter", self._wallet_widgets, self)
		else
			self._wallet_animation_id = self:_start_animation("wallet_on_exit", self._wallet_widgets, self)
		end
	end

	self._draw_wallet = draw_wallet
end

InventoryView.on_back_pressed = function (self)
	local active_category_tab_context = self._active_category_tab_context
	local active_category_layout = active_category_tab_context and active_category_tab_context.layout

	if active_category_layout ~= self._visible_grid_layout then
		self:_setup_grid_layout(active_category_layout)
		self:_switch_active_layout(active_category_tab_context)
		self:_display_title_text(nil)

		return true
	end

	return false
end

InventoryView.on_exit = function (self)
	if self._item_stats then
		self._item_stats:stop_presenting()
		self:_remove_element("item_stats")

		self._item_stats = nil
	end

	self:_destroy_loadout_widgets(self._ui_renderer)
	self:_destroy_grid_widgets(self._ui_offscreen_renderer)

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

	for _, item in pairs(inventory_items) do
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
							player = self._preview_player,
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

InventoryView.event_force_wallet_update = function (self)
	self:_request_wallets_update()
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

InventoryView.player = function (self)
	return self._preview_player
end

InventoryView.equipped_item_in_slot = function (self, slot_name)
	return self._preview_profile_equipped_items[slot_name]
end

InventoryView.cb_on_grid_entry_pressed = function (self, widget, element)
	if not self._is_own_player or self._is_readonly then
		return
	end

	local slot = element.slot
	local slots = element.slots
	local initial_rotation = element.initial_rotation
	local disable_rotation_input = element.disable_rotation_input
	local animation_event_name_suffix = element.animation_event_name_suffix
	local animation_event_variable_data = element.animation_event_variable_data
	local item_type = element.item_type
	local view_name = element.view_name

	if slot then
		local slot_name = slot.name

		if element.loadout_slot then
			view_name = view_name or VIEW_BY_SLOT[slot_name]

			if view_name then
				local context = {
					player = self._preview_player,
					player_specialization = self._chosen_specialization,
					preview_profile_equipped_items = self._preview_profile_equipped_items,
					current_profile_equipped_items = self._current_profile_equipped_items,
					selected_slot = slot,
					initial_rotation = initial_rotation,
					disable_rotation_input = disable_rotation_input,
					animation_event_name_suffix = animation_event_name_suffix,
					animation_event_variable_data = animation_event_variable_data,
					item_type = item_type,
					parent = self._parent,
					new_items_gear_ids = self._parent and self._parent._new_items_gear_ids
				}

				Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
			else
				local layout = self:_get_items_layout_by_slot(slot)

				self:_setup_grid_layout(layout)
				self:_set_camera_focus_by_slot_name(slot_name)
				self:_display_title_text(element.slot_title)
			end
		elseif view_name then
			local context = {
				player = self._preview_player,
				player_specialization = self._chosen_specialization,
				preview_profile_equipped_items = self._preview_profile_equipped_items,
				selected_slot = slot,
				initial_rotation = initial_rotation,
				parent = self._parent,
				new_items_gear_ids = self._parent and self._parent._new_items_gear_ids
			}

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		else
			local item = element.item
			local item_gear_id = item.gear_id
			local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

			if active_profile_preset_id then
				ProfileUtils.save_item_id_for_profile_preset(active_profile_preset_id, slot_name, item_gear_id)
			end

			Managers.event:trigger("event_inventory_view_equip_item", slot_name, item)
			self:_play_voice_preview(slot_name, item)
		end
	elseif slots and element.loadout_slot and view_name then
		local context = {
			player = self._preview_player,
			player_specialization = self._chosen_specialization,
			preview_profile_equipped_items = self._preview_profile_equipped_items,
			selected_slots = slots,
			parent = self._parent,
			new_items_gear_ids = self._parent and self._parent._new_items_gear_ids
		}

		Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
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

InventoryView._reset_grid_layout = function (self, ui_renderer)
	self:_destroy_grid_widgets(ui_renderer)

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

	self:_destroy_loadout_widgets(self._ui_renderer)
	self:_clear_widgets(self._exclamation_widgets)

	local widgets = {}
	local excalamation_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local scenegraph_id = entry.scenegraph_id
		local widget, _ = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name, scenegraph_id)

		widgets[#widgets + 1] = widget

		if entry.loadout_slot then
			local exclamation_widget = self:_create_exclamation_widget_from_config(entry, widget_suffix, scenegraph_id)

			exclamation_widget.content.slot = entry.slot
			excalamation_widgets[#excalamation_widgets + 1] = exclamation_widget
		end

		local content = widget.content

		content.index = index
	end

	self._loadout_widgets = widgets
	self._exclamation_widgets = excalamation_widgets

	if not Managers.ui:using_cursor_navigation() then
		self:_select_individual_widget_index(1)
	end
end

InventoryView._setup_grid_layout = function (self, layout)
	self._widgets_by_name.grid_background.content.visible = true

	self:_reset_grid_layout(self._ui_offscreen_renderer)

	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"
	local previous_group_header_name
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
end

InventoryView.cb_switch_tab = function (self, index)
	if index ~= self._selected_tab_index then
		self:_set_active_layout_by_index(index)
	end
end

InventoryView._destroy_previous_tab = function (self)
	if self._wallet_animation_id then
		self:_stop_animation(self._wallet_animation_id)

		self._wallet_animation_id = nil
	end

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
	local widget
	local template = ContentBlueprints[widget_type]
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
	end

	if widget then
		return widget, widget
	else
		return nil, {
			size = size
		}
	end
end

InventoryView._create_exclamation_widget_from_config = function (self, config, suffix, scenegraph_id)
	local widget_type = config.widget_type
	local template = ContentBlueprints[widget_type]
	local size = template.size_function and template.size_function(self, config) or template.size
	local pass_template = ContentBlueprints.exclamation_mark.pass_template
	local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
	local name = "widget_exclamation_mark_" .. suffix
	local widget = self:_create_widget(name, widget_definition)

	return widget
end

InventoryView._draw_loadout_widgets = function (self, dt, t, input_service, ui_renderer)
	local widgets = self._loadout_widgets
	local render_settings = self._render_settings
	local ui_scenegraph = self._ui_scenegraph
	local exclamation_widgets = self._exclamation_widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	local invalid_slots = self._parent and self._parent._invalid_slots
	local modified_slots = self._parent and self._parent._modified_slots
	local duplicated_slots = self._parent and self._parent._duplicated_slots

	if exclamation_widgets and (invalid_slots or modified_slots or duplicated_slots) and self._entry_animation_id and not self:_is_animation_active(self._entry_animation_id) then
		for i = 1, #exclamation_widgets do
			local widget = exclamation_widgets[i]
			local slot_name = widget.content.slot.name

			if invalid_slots[slot_name] or duplicated_slots[slot_name] then
				widget.content.modified_content = false

				UIWidget.draw(widget, ui_renderer)
			elseif modified_slots[slot_name] then
				widget.content.modified_content = true

				UIWidget.draw(widget, ui_renderer)
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

InventoryView._draw_wallet_widgets = function (self, dt, t, input_service, ui_renderer)
	if not self._wallet_initialized then
		return
	end

	local widgets = self._wallet_widgets
	local render_settings = self._render_settings
	local ui_scenegraph = self._ui_scenegraph
	local num_active_wallet_widgets = self._num_active_wallet_widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, num_active_wallet_widgets do
		local widget = widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
end

InventoryView._draw_grid = function (self, dt, t, input_service, ui_renderer)
	local grid = self._grid

	if not grid then
		return
	end

	local widgets = self._grid_widgets
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	local render_settings = self._render_settings
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

InventoryView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local previous_alpha_multiplier = render_settings.alpha_multiplier
	local loadout_alpha_multiplier = self.loadout_alpha_multiplier

	render_settings.alpha_multiplier = loadout_alpha_multiplier or 0

	InventoryView.super._draw_elements(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

InventoryView._destroy_loadout_widgets = function (self, ui_renderer)
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

				destroy(self, widget, element, ui_renderer)
			end
		end
	end

	self._loadout_widgets = nil
end

InventoryView._destroy_grid_widgets = function (self, ui_renderer)
	local widgets = self._grid_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local destroy = template and template.destroy

			if destroy then
				local element = widget.element

				destroy(self, widget, element, ui_renderer)
			end
		end
	end
end

InventoryView._update_blueprint_widgets = function (self, widgets, dt, t, input_service, ui_renderer)
	if widgets then
		local allow_item_hover_information = self._allow_item_hover_information

		if self._parent and self._parent.is_inventory_synced and not self._parent:is_inventory_synced() then
			allow_item_hover_information = false
		end

		local handle_input = false
		local hovered_item

		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local update = template and template.update

			if update then
				update(self, widget, input_service, dt, t, ui_renderer)
			end

			if allow_item_hover_information and not hovered_item then
				local content = widget.content
				local hotspot = content.hotspot
				local is_hover = hotspot and hotspot.is_hover
				local is_selected = hotspot and hotspot.is_selected

				if is_hover or is_selected then
					local item = content.item

					hovered_item = item
				end
			end
		end

		if hovered_item then
			if not self._currently_hovered_item or hovered_item.gear_id ~= self._currently_hovered_item.gear_id then
				self:_on_item_hover_start(hovered_item)
			end
		else
			self:_on_item_hover_stop()
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
		local new_highlighted_group_header, new_highlighted_group_header_text

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

	if self._loadout_widgets then
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

InventoryView._first_interactable_loadout_widget_index = function (self)
	for i = 1, #self._loadout_widgets do
		local widget = self._loadout_widgets[i]

		if widget.content.hotspot then
			return i
		end
	end
end

InventoryView._find_closest_widget_node_neighbour = function (self, direction)
	local start_index = self._current_selected_loadout_index or self:_first_interactable_loadout_widget_index()
	local selected_widget = self._loadout_widgets[start_index]

	if selected_widget then
		local start_coordinates = self:_get_coordinates_from_widget(selected_widget)

		return self:_find_closest_value(self._loadout_widgets, start_coordinates, direction)
	end
end

InventoryView._get_coordinates_from_widget = function (self, widget)
	local scenegraph_position = self:_scenegraph_world_position(widget.scenegraph_id)
	local start_x = scenegraph_position[1] + widget.offset[1]
	local end_x = start_x + widget.content.size[1]
	local start_y = scenegraph_position[2] + widget.offset[2]
	local end_y = start_y + widget.content.size[2]
	local center_x = widget.content.size[1] * 0.5 + start_x
	local center_y = widget.content.size[2] * 0.5 + start_y

	return {
		start_x = start_x,
		end_x = end_x,
		center_x = center_x,
		start_y = start_y,
		end_y = end_y,
		center_y = center_y,
		size_x = end_x - start_x,
		size_y = end_y - start_y
	}
end

InventoryView._find_closest_value = function (self, list, start_coordinates, direction, threshold, current_index, result_index)
	threshold = threshold or 5
	current_index = current_index or 1

	local next_index = current_index + 1
	local current_hotspot = list[current_index].content.hotspot

	if not current_hotspot or current_hotspot and current_hotspot.disabled == true then
		if list[next_index] then
			return self:_find_closest_value(list, start_coordinates, direction, threshold, next_index, result_index)
		end

		return result_index
	end

	local widget_coordinates_current = self:_get_coordinates_from_widget(list[current_index])
	local widget_coordinates_evaluated = result_index and self:_get_coordinates_from_widget(list[result_index])
	local use_lower = false
	local start_coordinate_name, start_edge_coordinate_name, end_edge_coordinate_name, center_coordinate_name

	if direction == DIRECTION.UP then
		start_coordinate_name = "end_y"
		start_edge_coordinate_name = "start_x"
		end_edge_coordinate_name = "end_x"
		center_coordinate_name = "center_x"
		use_lower = true
	elseif direction == DIRECTION.DOWN then
		start_coordinate_name = "start_y"
		start_edge_coordinate_name = "start_x"
		end_edge_coordinate_name = "end_x"
		center_coordinate_name = "center_x"
	elseif direction == DIRECTION.LEFT then
		start_coordinate_name = "end_x"
		start_edge_coordinate_name = "start_y"
		end_edge_coordinate_name = "end_y"
		center_coordinate_name = "center_y"
		use_lower = true
	elseif direction == DIRECTION.RIGHT then
		start_coordinate_name = "start_x"
		start_edge_coordinate_name = "start_y"
		end_edge_coordinate_name = "end_y"
		center_coordinate_name = "center_y"
	end

	local value_current = widget_coordinates_current[start_coordinate_name]
	local value_current_edge_start = widget_coordinates_current[start_edge_coordinate_name]
	local value_current_edge_end = widget_coordinates_current[end_edge_coordinate_name]
	local value_current_center = widget_coordinates_current[center_coordinate_name]
	local value_evaluated = widget_coordinates_evaluated and widget_coordinates_evaluated[start_coordinate_name] or use_lower and -math.huge or math.huge
	local value_start = start_coordinates[start_coordinate_name]
	local value_start_edge_start = start_coordinates[start_edge_coordinate_name]
	local value_start_edge_end = start_coordinates[end_edge_coordinate_name]
	local value_start_center = start_coordinates[center_coordinate_name]

	if value_current ~= value_start and (use_lower and value_current < value_start and value_evaluated < value_current or value_start < value_current and value_current < value_evaluated) and (value_current_edge_start >= value_start_edge_start - threshold and value_current_edge_start <= value_start_edge_end + threshold or value_current_edge_end >= value_start_edge_start - threshold and value_current_edge_end <= value_start_edge_end + threshold or value_current_center >= value_start_edge_start - threshold and value_current_center <= value_start_edge_end + threshold or value_start_center >= value_current_edge_start - threshold and value_start_center <= value_current_edge_end + threshold) then
		result_index = current_index
	end

	if list[next_index] then
		return self:_find_closest_value(list, start_coordinates, direction, threshold, next_index, result_index)
	end

	return result_index
end

InventoryView._handle_individual_widget_selection = function (self, input_service)
	local widget_index

	if input_service:get("navigate_up_continuous") then
		widget_index = self:_find_closest_widget_node_neighbour(DIRECTION.UP)
	elseif input_service:get("navigate_down_continuous") then
		widget_index = self:_find_closest_widget_node_neighbour(DIRECTION.DOWN)
	elseif input_service:get("navigate_left_continuous") then
		widget_index = self:_find_closest_widget_node_neighbour(DIRECTION.LEFT)
	elseif input_service:get("navigate_right_continuous") then
		widget_index = self:_find_closest_widget_node_neighbour(DIRECTION.RIGHT)
	end

	if widget_index then
		self._current_selected_loadout_index = widget_index

		local widget = self._loadout_widgets[self._current_selected_loadout_index]
		local new_selection_index = widget.content.index

		self:_select_individual_widget_index(new_selection_index)
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
	elseif self._loadout_widgets then
		if not self._using_cursor_navigation then
			if not self._current_selected_loadout_index then
				local first_widget_index = self:_first_interactable_loadout_widget_index()
				local first_widget = self._loadout_widgets[first_widget_index]

				self:_select_individual_widget_index(first_widget.content.index)
			end
		else
			self:_select_individual_widget_index(nil)
		end
	end

	if self._using_cursor_navigation then
		local reference_name = "item_stats"
		local element = self:_element(reference_name)

		element:set_visibility(true)
		self:_on_item_hover_stop()
	else
		self:on_item_stats_toggled(self._item_stats_presentation_enabled)
	end
end

InventoryView._select_individual_widget_index = function (self, index)
	local loadout_widgets = self._loadout_widgets

	if loadout_widgets then
		for i = 1, #loadout_widgets do
			local is_selected = i == index
			local widget = loadout_widgets[i]
			local content = widget.content
			local hotspot = content.hotspot

			if hotspot then
				hotspot.is_selected = is_selected
			end
		end
	end

	self._selected_individual_widget_index = index
end

InventoryView.profile_preset_handling_input = function (self)
	local view_name = "inventory_background_view"
	local ui_manager = Managers.ui

	if ui_manager:view_active(view_name) then
		local view_instance = ui_manager:view_instance(view_name)

		return view_instance:profile_preset_handling_input()
	end
end

InventoryView.on_resolution_modified = function (self, scale)
	InventoryView.super.on_resolution_modified(self, scale)

	local grid = self._grid

	if grid then
		grid:on_resolution_modified(scale)
	end

	self:_update_tab_bar_position()

	if self._item_stats then
		self:_update_item_stats_position("item_stats_pivot", self._item_stats)
	end
end

InventoryView.update = function (self, dt, t, input_service)
	if self:profile_preset_handling_input() or self._parent and self._parent.is_inventory_synced and not self._parent:is_inventory_synced() then
		input_service = input_service:null_service()
	end

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

		self:_update_blueprint_widgets(widgets, dt, t, input_service, self._ui_offscreen_renderer)
	end

	local loadout_widgets = self._loadout_widgets

	if loadout_widgets then
		self:_update_blueprint_widgets(loadout_widgets, dt, t, input_service, self._ui_renderer)
	end

	return InventoryView.super.update(self, dt, t, input_service)
end

InventoryView.draw = function (self, dt, t, input_service, layer)
	if self:profile_preset_handling_input() or self._parent and self._parent.is_inventory_synced and not self._parent:is_inventory_synced() then
		input_service = input_service:null_service()
	end

	InventoryView.super.draw(self, dt, t, input_service, layer)
	self:_draw_grid(dt, t, input_service, self._ui_offscreen_renderer)

	if self._loadout_widgets then
		self:_draw_loadout_widgets(dt, t, input_service, self._ui_renderer)
	end

	if self._num_active_wallet_widgets > 0 then
		self:_draw_wallet_widgets(dt, t, input_service, self._ui_renderer)
	end
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
	local num_active_widgets = 0

	if not hide_presentation then
		local sorted_wallet_settings = {}

		table.append_non_indexed(sorted_wallet_settings, WalletSettings)
		table.sort(sorted_wallet_settings, function (a, b)
			return a.sort_order < b.sort_order
		end)

		local widgets = self._wallet_widgets
		local wallet_entry_definition = self._definitions.wallet_entry_definition

		for i = #sorted_wallet_settings, 1, -1 do
			local wallet_settings = sorted_wallet_settings[i]

			if wallet_settings.show_in_character_menu then
				num_active_widgets = num_active_widgets + 1

				local widget = widgets[num_active_widgets]

				if not widget then
					widget = self:_create_widget("wallet_entry_" .. tostring(#widgets + 1), wallet_entry_definition)
					widgets[#widgets + 1] = widget
				end

				local wallet_type = wallet_settings.type
				local backend_index = wallet_settings.backend_index
				local wallet = wallets_data and wallets_data:by_type(wallet_type)
				local string_symbol = wallet_settings.string_symbol
				local balance = wallet and wallet.balance
				local amount = balance and balance.amount or 0
				local text = TextUtilities.format_currency(amount)

				widget.content.text = text
				widget.content.icon = wallet_settings.icon_texture_small
				widget.offset[2] = -((num_active_widgets - 1) * 50)
			end
		end

		self._wallet_initialized = true
	end

	self._num_active_wallet_widgets = num_active_widgets
end

InventoryView.profile_level = function (self)
	local preview_player = self._preview_player
	local profile = preview_player:profile()
	local current_level = profile.current_level

	return current_level
end

InventoryView.on_item_stats_toggled = function (self, force_value, do_save)
	if force_value == nil then
		self._item_stats_presentation_enabled = not self._item_stats_presentation_enabled
	else
		self._item_stats_presentation_enabled = force_value
	end

	local reference_name = "item_stats"
	local element = self:_element(reference_name)

	element:set_visibility(self._item_stats_presentation_enabled)

	if do_save then
		local character_data = self:_character_save_data()

		if character_data then
			character_data.view_settings.inventory_view_item_stats_toggled = self._item_stats_presentation_enabled

			Managers.save:queue_save()
		end
	end
end

InventoryView.is_item_stats_toggled = function (self)
	return self._item_stats_presentation_enabled
end

return InventoryView
