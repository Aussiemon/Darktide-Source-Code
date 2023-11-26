-- chunkname: @scripts/ui/views/item_grid_view_base/item_grid_view_base.lua

local Breeds = require("scripts/settings/breed/breeds")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/views/item_grid_view_base/item_grid_view_base_definitions")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ItemGridViewBase = class("ItemGridViewBase", "BaseView")

ItemGridViewBase.init = function (self, definitions, settings, context)
	if context and context.wallet_type then
		self._wallet_type = context.wallet_type
	end

	local player = context.preview_player or self:_player()

	self._preview_player = player
	self._presentation_profile = table.clone_instance(self._preview_player:profile())

	if context.preview_loadout then
		self._presentation_profile.loadout = table.clone_instance(context.preview_loadout)
	end

	if context.character_id then
		self._presentation_profile.character_id = context.character_id
	end

	self._is_own_player = self._preview_player == Managers.player:local_player(1)

	local merged_definitions = table.clone(Definitions)

	if definitions then
		table.merge_recursive(merged_definitions, definitions)
	end

	self._definitions = merged_definitions
	self._grow_direction = "down"
	self._context = context

	ItemGridViewBase.super.init(self, merged_definitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
	self._render_settings = self._render_settings or {}
end

ItemGridViewBase.on_enter = function (self)
	ItemGridViewBase.super.on_enter(self)

	self._weapon_stats = self:_setup_weapon_stats("weapon_stats", "weapon_stats_pivot")
	self._weapon_compare_stats = self:_setup_weapon_stats("weapon_compare_stats", "weapon_compare_stats_pivot")

	self:_setup_item_grid()
	self:_stop_previewing()

	self._item_definitions = MasterItems.get_cached()
	self._inventory_items = {}

	local context = self._context
	local ui_renderer = context and context.ui_renderer

	if ui_renderer then
		self._ui_default_renderer = ui_renderer
		self._ui_default_renderer_is_external = true
	else
		self:_setup_default_gui()
	end

	local use_weapon_preview = context and context.use_weapon_preview

	if use_weapon_preview then
		self:_setup_weapon_preview()
	end

	self._disable_item_presentation = context and context.disable_item_presentation
end

ItemGridViewBase._setup_sort_options = function (self)
	if not self._sort_options then
		self._sort_options = {
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_item_power"),
				sort_function = ItemUtils.sort_comparator({
					">",
					ItemUtils.compare_item_level,
					">",
					ItemUtils.compare_item_type,
					"<",
					ItemUtils.compare_item_name,
					"<",
					ItemUtils.compare_item_rarity
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_item_type"),
				sort_function = ItemUtils.sort_comparator({
					">",
					ItemUtils.compare_item_type,
					"<",
					ItemUtils.compare_item_name,
					">",
					ItemUtils.compare_item_level,
					"<",
					ItemUtils.compare_item_rarity
				})
			}
		}
	end

	if self._sort_options and #self._sort_options > 0 then
		local sort_callback = callback(self, "cb_on_sort_button_pressed")

		self._item_grid:setup_sort_button(self._sort_options, sort_callback, 1)
	end
end

ItemGridViewBase._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 100
	local world_name = reference_name .. "_ui_default_world"
	local view_name = self.view_name

	self._gui_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = reference_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._gui_viewport = ui_manager:create_viewport(self._gui_world, viewport_name, viewport_type, viewport_layer)
	self._gui_viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(reference_name .. "_ui_default_renderer", self._gui_world)
end

ItemGridViewBase._setup_menu_tabs = function (self, content)
	local tab_menu_settings = self._definitions.tab_menu_settings
	local id = "tab_menu"
	local layer = tab_menu_settings.layer or 10
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)

	self._tab_menu_element = tab_menu_element

	local input_action_left = "navigate_primary_left_pressed"
	local input_action_right = "navigate_primary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)

	local tab_button_template = table.clone(tab_menu_settings.button_template or ButtonPassTemplates.tab_menu_button_icon)

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

	tab_menu_element:set_is_handling_navigation_input(true)

	self._tabs_content = content
	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

ItemGridViewBase.cb_switch_tab = function (self, index)
	if index ~= self._tab_menu_element:selected_index() then
		self._tab_menu_element:set_selected_index(index)

		local tabs_content = self._tabs_content
		local tab_content = tabs_content[index]
		local slot_types = tab_content.slot_types
		local display_name = tab_content.display_name

		self:_present_layout_by_slot_filter(slot_types, nil, not tab_content.hide_display_name and display_name or nil)
	end
end

ItemGridViewBase._present_layout_by_slot_filter = function (self, slot_filter, item_type_filter, optional_display_name)
	local layout = self._offer_items_layout

	if layout then
		local filtered_layout = {}

		for i = #layout, 1, -1 do
			local entry = layout[i]
			local item = entry.item
			local add_item = true

			if item then
				local entry_filter_slots = entry.filter_slots
				local slots = entry_filter_slots or item.slots
				local item_type = item.item_type

				if slot_filter and not table.is_empty(slot_filter) then
					local slot_name_found = false

					if slots then
						for _, slot_name in ipairs(slots) do
							if table.find(slot_filter, slot_name) then
								slot_name_found = true

								break
							end
						end
					end

					add_item = slot_name_found
				end

				if item_type_filter and not table.is_empty(item_type_filter) and not table.find(item_type_filter, item_type) then
					add_item = false
				end
			else
				add_item = true
			end

			if add_item then
				filtered_layout[#filtered_layout + 1] = entry
			end
		end

		self._filtered_offer_items_layout = filtered_layout
		self._grid_display_name = optional_display_name

		local sort_options = self._sort_options

		if sort_options then
			local sort_index = self._selected_sort_option_index or 1
			local selected_sort_option = sort_options[sort_index]
			local selected_sort_function = selected_sort_option.sort_function

			self:_sort_grid_layout(selected_sort_function)
		else
			self:_sort_grid_layout()
		end
	end
end

ItemGridViewBase.grid_widgets = function (self)
	return self._item_grid:widgets()
end

ItemGridViewBase.selected_grid_index = function (self)
	return self._item_grid:selected_grid_index()
end

ItemGridViewBase.selected_grid_widget = function (self)
	return self._item_grid:selected_grid_widget()
end

ItemGridViewBase.update_grid_widgets_visibility = function (self)
	return self._item_grid:update_grid_widgets_visibility()
end

ItemGridViewBase._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("grid_tab_panel")

	self._tab_menu_element:set_pivot_offset(position[1], position[2])
end

ItemGridViewBase._set_preview_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.display_name.content.visible = visible
	widgets_by_name.display_name_divider.content.visible = visible
	widgets_by_name.display_name_divider_glow.content.visible = visible
	widgets_by_name.sub_display_name.content.visible = visible
end

ItemGridViewBase._stop_previewing = function (self)
	self._previewed_item = nil

	if self._weapon_preview then
		self._weapon_preview:stop_presenting()
	end

	if self._weapon_stats then
		self._weapon_stats:stop_presenting()
	end

	local visible = false

	self:_set_preview_widgets_visibility(visible)
end

ItemGridViewBase._preview_element = function (self, element)
	local item = element and (element.real_item or element.item)

	self:_preview_item(item)
end

ItemGridViewBase._preview_item = function (self, item)
	self:_stop_previewing()

	local item_stats_context = {
		hide_source = self._hide_item_source_in_tooltip
	}

	if item and item.display_name and string.match(item.display_name, "unarmed") then
		item = nil
	end

	local visible = item ~= nil

	self:_set_preview_widgets_visibility(visible)

	self._previewed_item = item

	if not item or self._disable_item_presentation then
		return
	end

	local item_type = item.item_type
	local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"
	local can_compare = is_weapon or item_type == "GADGET"

	if is_weapon or item_type == "GADGET" or item_type == "PORTRAIT_FRAME" or item_type == "CHARACTER_INSIGNIA" then
		if self._weapon_preview then
			local disable_auto_spin = true

			self._weapon_preview:present_item(item, disable_auto_spin)
		else
			if self._weapon_stats then
				self._weapon_stats:present_item(item, item_stats_context)
			end

			if self._weapon_compare_stats then
				local slot_name = self:_fetch_item_compare_slot_name(item)
				local equipped_item = slot_name and self.equipped_item_in_slot and self:equipped_item_in_slot(slot_name)

				if equipped_item and can_compare then
					if not self._previewed_equipped_item or self._previewed_equipped_item.gear_id ~= equipped_item.gear_id then
						self._previewed_equipped_item = equipped_item

						local is_equipped = true

						item_stats_context.present_equip_label_equipped = is_equipped

						self._weapon_compare_stats:present_item(equipped_item, item_stats_context)
					end
				else
					self._previewed_equipped_item = nil
				end

				local compare_stats_visible = can_compare and equipped_item and self._item_compare_toggled or false

				self._weapon_compare_stats:set_visibility(compare_stats_visible)
			end
		end
	elseif item_type == "WEAPON_SKIN" then
		local visual_item = ItemUtils.weapon_skin_preview_item(item)

		if visual_item then
			if self._weapon_preview then
				local disable_auto_spin = true

				self._weapon_preview:present_item(visual_item, disable_auto_spin)
			elseif self._weapon_stats then
				self._weapon_stats:present_item(item, item_stats_context)
			end
		end
	elseif (item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_HEAD" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND") and self._weapon_stats then
		self._weapon_stats:present_item(item, item_stats_context)
	end

	local display_name = ItemUtils.display_name(item)
	local sub_display_name = ItemUtils.sub_display_name(item)
	local rarity_color = ItemUtils.rarity_color(item)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.sub_display_name.content.text = sub_display_name
	widgets_by_name.display_name.content.text = display_name
	widgets_by_name.display_name_divider_glow.style.texture.color = table.clone(rarity_color)
end

ItemGridViewBase._fetch_item_compare_slot_name = function (self, item)
	local slots = item and item.slots
	local slot_name = slots and slots[1]

	return slot_name
end

ItemGridViewBase.is_previewing_item = function (self)
	return self._previewed_item ~= nil
end

ItemGridViewBase.previewed_item = function (self)
	return self._previewed_item
end

ItemGridViewBase._destroy_weapon_preview = function (self)
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

ItemGridViewBase._setup_weapon_preview = function (self)
	if not self._weapon_preview then
		local reference_name = "weapon_preview"
		local layer = 10
		local context = {
			ignore_blur = true,
			draw_background = false
		}

		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, context)
		self._weapon_zoom_fraction = -3
		self._weapon_zoom_target = 1
		self._min_zoom = -3
		self._max_zoom = 1

		self._weapon_preview:center_align(0, {
			-0.6,
			-2,
			-0.2
		})
		self._weapon_preview:set_force_allow_rotation(true)
		self:_update_weapon_preview_viewport()
	end
end

ItemGridViewBase._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if weapon_preview then
		local width_scale, height_scale = 1, 1
		local x_scale, y_scale = 0, 0

		weapon_preview:set_viewport_position_normalized(x_scale, y_scale)
		weapon_preview:set_viewport_size_normalized(width_scale, height_scale)

		local weapon_x_scale, weapon_y_scale = self:_get_weapon_spawn_position_normalized()

		weapon_preview:set_weapon_position_normalized(weapon_x_scale, weapon_y_scale)

		local weapon_zoom_fraction = self._weapon_zoom_fraction or 1
		local use_custom_zoom = true
		local optional_node_name = "p_zoom"
		local optional_pos
		local min_zoom = self._min_zoom
		local max_zoom = self._max_zoom

		weapon_preview:set_weapon_zoom(weapon_zoom_fraction, use_custom_zoom, optional_node_name, optional_pos, min_zoom, max_zoom)
	end
end

ItemGridViewBase._set_weapon_zoom = function (self, fraction)
	self._weapon_zoom_fraction = fraction

	self:_update_weapon_preview_viewport()
end

ItemGridViewBase._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

ItemGridViewBase.ui_renderer = function (self)
	return self._ui_renderer
end

ItemGridViewBase._setup_weapon_stats = function (self, reference_name, scenegraph_id)
	local layer = 1
	local context = self._definitions.weapon_stats_grid_settings
	local weapon_stats = self:_add_element(ViewElementWeaponStats, reference_name, layer, context)

	self:_update_weapon_stats_position(scenegraph_id, weapon_stats)

	return weapon_stats
end

ItemGridViewBase._update_weapon_stats_position = function (self, scenegraph_id, weapon_stats)
	local position = self:_scenegraph_world_position(scenegraph_id)

	weapon_stats:set_pivot_offset(position[1], position[2])
end

ItemGridViewBase._setup_item_grid = function (self, optional_grid_settings)
	if self._item_grid then
		self._item_grid = nil

		self:_remove_element("item_grid")
	end

	local context = optional_grid_settings or self._definitions.grid_settings
	local reference_name = "item_grid"
	local layer = 10

	self._item_grid = self:_add_element(ViewElementGrid, reference_name, layer, context)

	local preview_player = self._preview_player

	if preview_player then
		local profile = preview_player.profile and preview_player:profile()

		self._item_grid:set_default_item_icon_profile(profile)
	end

	self:present_grid_layout({})
	self:_update_item_grid_position()
	self:_setup_sort_options()
end

ItemGridViewBase.set_loading_state = function (self, is_loading)
	if self._item_grid then
		self._item_grid:set_loading_state(is_loading)
	end
end

ItemGridViewBase._update_item_grid_position = function (self)
	if not self._item_grid then
		return
	end

	local position = self:_scenegraph_world_position("item_grid_pivot")

	self._item_grid:set_pivot_offset(position[1], position[2])
end

ItemGridViewBase._grid_widget_by_name = function (self, widget_name)
	if not self._item_grid then
		return
	end

	return self._item_grid:widget_by_name(widget_name)
end

ItemGridViewBase.on_exit = function (self)
	if self._inpect_view_opened then
		if Managers.ui:view_active(self._inpect_view_opened) then
			Managers.ui:close_view(self._inpect_view_opened)
		end

		self._inpect_view_opened = nil
	end

	local elements_array = self._elements_array

	for _, element in ipairs(elements_array) do
		element:destroy(self._ui_default_renderer)
	end

	self._elements = nil
	self._elements_array = nil
	self._weapon_stats = nil
	self._weapon_compare_stats = nil
	self._item_grid = nil
	self._weapon_preview = nil

	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		if not self._ui_default_renderer_is_external then
			Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")
		end

		if self._gui_world then
			local world = self._gui_world
			local viewport_name = self._gui_viewport_name

			ScriptWorld.destroy_viewport(world, viewport_name)
			Managers.ui:destroy_world(world)

			self._gui_viewport_name = nil
			self._gui_viewport = nil
			self._gui_world = nil
		end
	end

	self:_unregister_events()

	if Managers.telemetry_events then
		Managers.telemetry_events:close_view(self.view_name)
	end

	if self._cursor_pushed then
		local input_manager = Managers.input
		local name = self.__class_name

		input_manager:pop_cursor(name)

		self._cursor_pushed = nil
	end

	if self._should_unload then
		self._should_unload = nil

		local frame_delay_count = 1

		Managers.ui:unload_view(self.view_name, self.__class_name, frame_delay_count)
	end

	self._ui_renderer = nil

	if not self._ui_renderer_is_external then
		Managers.ui:destroy_renderer(self.__class_name .. "_ui_renderer")
	end

	self._destroyed = true
end

ItemGridViewBase.cb_on_sort_button_pressed = function (self, option)
	local option_sort_index
	local sort_options = self._sort_options

	for i = 1, #sort_options do
		if sort_options[i] == option then
			option_sort_index = i

			break
		end
	end

	if option_sort_index ~= self._selected_sort_option_index then
		self._selected_sort_option_index = option_sort_index
		self._selected_sort_option = option

		local sort_function = option.sort_function

		self:_sort_grid_layout(sort_function)
	end
end

ItemGridViewBase._cb_on_present = function (self)
	local new_selection_index
	local grid_widgets = self._item_grid:widgets()
	local selected_gear_id = self._selected_gear_id

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]
		local content = widget.content
		local element = content.element

		if element then
			local item = element.item

			if item then
				if item.gear_id == selected_gear_id then
					new_selection_index = i

					break
				elseif not new_selection_index then
					new_selection_index = i

					if not selected_gear_id then
						break
					end
				end
			end
		end
	end

	self._selected_gear_id = nil

	if new_selection_index then
		self._item_grid:focus_grid_index(new_selection_index)
	else
		self._item_grid:select_first_index()
	end

	self._synced_grid_index = nil
end

ItemGridViewBase._sort_grid_layout = function (self, sort_function)
	if not self._filtered_offer_items_layout then
		return
	end

	local layout = table.append({}, self._filtered_offer_items_layout)

	if sort_function and #layout > 1 then
		table.sort(layout, sort_function)
	end

	local item_grid = self._item_grid
	local widget_index = item_grid:selected_grid_index()
	local selected_element = widget_index and item_grid:element_by_index(widget_index)
	local selected_item = selected_element and selected_element.item

	self._selected_gear_id = self._selected_gear_id or selected_item and selected_item.gear_id

	local on_present_callback = callback(self, "_cb_on_present")

	self:present_grid_layout(layout, on_present_callback)
end

ItemGridViewBase.present_grid_layout = function (self, layout, on_present_callback)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local left_double_click_callback = callback(self, "cb_on_grid_entry_left_double_click")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local grid_settings = self._definitions.grid_settings
	local grid_size = grid_settings.grid_size
	local ContentBlueprints = generate_blueprints_function(grid_size)
	local spacing_entry = {
		widget_type = "spacing_vertical"
	}

	table.insert(layout, 1, spacing_entry)
	table.insert(layout, #layout + 1, spacing_entry)

	local grow_direction = self._grow_direction or "down"

	self._item_grid:present_grid_layout(layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction, on_present_callback, left_double_click_callback)
end

ItemGridViewBase.cb_on_grid_entry_right_pressed = function (self, widget, element)
	local function cb_func()
		if self._destroyed then
			return
		end
	end

	self._update_callback_on_grid_entry_right_pressed = callback(cb_func)
end

ItemGridViewBase.cb_on_grid_entry_left_double_click = function (self, widget, element)
	local function cb_func()
		if self._destroyed then
			return
		end

		self:_on_double_click(widget, element)
	end

	self._update_callback_on_grid_entry_left_double_click = callback(cb_func)
end

ItemGridViewBase._on_double_click = function (self, widget, element)
	return
end

ItemGridViewBase.cb_on_grid_entry_left_pressed = function (self, widget, element)
	local function cb_func()
		if self._destroyed then
			return
		end

		local item = element.item

		if Managers.ui:using_cursor_navigation() and item and item ~= self._previewed_item then
			local widget_index = self._item_grid:widget_index(widget) or 1

			self._item_grid:focus_grid_index(widget_index)
		end
	end

	self._update_callback_on_grid_entry_left_pressed = callback(cb_func)
end

ItemGridViewBase._handle_input = function (self, input_service, dt, t)
	return ItemGridViewBase.super._handle_input(self, input_service, dt, t)
end

ItemGridViewBase.update = function (self, dt, t, input_service)
	if self._update_callback_on_grid_entry_left_pressed then
		self._update_callback_on_grid_entry_left_pressed()

		self._update_callback_on_grid_entry_left_pressed = nil
	end

	if self._update_callback_on_grid_entry_right_pressed then
		self._update_callback_on_grid_entry_right_pressed()

		self._update_callback_on_grid_entry_right_pressed = nil
	end

	if self._update_callback_on_grid_entry_left_double_click then
		self._update_callback_on_grid_entry_left_double_click()

		self._update_callback_on_grid_entry_left_double_click = nil
	end

	local synced_grid_index = self._synced_grid_index
	local item_grid = self._item_grid
	local grid_index = item_grid and item_grid:selected_grid_index() or nil
	local grid_index_changed = not synced_grid_index or grid_index and synced_grid_index ~= grid_index

	if grid_index_changed then
		local grid_element = grid_index and item_grid:element_by_index(grid_index)
		local item = grid_element and grid_element.item
		local offer = grid_element and grid_element.offer

		if item ~= self._previewed_item or offer ~= self._previewed_offer then
			self:_preview_element(grid_element)
		end

		self._synced_grid_index = grid_index
	end

	if not Managers.ui:using_cursor_navigation() then
		local item_grid = self._item_grid
		local selected_grid_widget = item_grid and item_grid:selected_grid_widget()

		if not selected_grid_widget then
			self._item_grid:select_first_index()

			selected_grid_widget = item_grid:selected_grid_widget()

			local selected_grid_element = selected_grid_widget and selected_grid_widget.content.element
			local selected_grid_item = selected_grid_element and selected_grid_element.item

			if selected_grid_item and selected_grid_item ~= self._previewed_item then
				local widget_index = item_grid:widget_index(selected_grid_widget) or 1

				self:_preview_element(selected_grid_element)
			end
		end
	end

	return ItemGridViewBase.super.update(self, dt, t, input_service)
end

ItemGridViewBase.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_default_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

ItemGridViewBase._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ItemGridViewBase.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ItemGridViewBase.on_resolution_modified = function (self, scale)
	ItemGridViewBase.super.on_resolution_modified(self, scale)
	self:_update_weapon_preview_viewport()
	self:_update_item_grid_position()

	if self._weapon_stats then
		self:_update_weapon_stats_position("weapon_stats_pivot", self._weapon_stats)
	end

	if self._weapon_compare_stats then
		self:_update_weapon_stats_position("weapon_compare_stats_pivot", self._weapon_compare_stats)
	end

	self:_update_tab_bar_position()
end

ItemGridViewBase.select_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	self._item_grid:select_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ItemGridViewBase.focus_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	self._item_grid:focus_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ItemGridViewBase.scroll_to_grid_index = function (self, index, is_instant)
	self._item_grid:scroll_to_grid_index(index, is_instant)
end

ItemGridViewBase.focus_on_offer = function (self, offer)
	if not offer then
		return
	end

	local item_grid = self._item_grid
	local widgets = item_grid:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_offer = element.offer

		if element_offer and element_offer.offerId == offer.offerId then
			local widget_index = item_grid:widget_index(widget) or 1
			local scrollbar_animation_progress = item_grid:get_scrollbar_percentage_by_index(widget_index)
			local instant_scroll = true

			item_grid:focus_grid_index(widget_index, scrollbar_animation_progress, instant_scroll)

			if not Managers.ui:using_cursor_navigation() then
				item_grid:select_grid_index(widget_index)
			end

			self:_preview_element(element)

			break
		end
	end
end

ItemGridViewBase.focus_on_item = function (self, item)
	if not item then
		return
	end

	local item_grid = self._item_grid
	local widgets = item_grid:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_item = element.item

		if element_item and element_item.gear_id == item.gear_id then
			local widget_index = item_grid:widget_index(widget) or 1
			local scrollbar_animation_progress = item_grid:get_scrollbar_percentage_by_index(widget_index)
			local instant_scroll = true

			item_grid:focus_grid_index(widget_index, scrollbar_animation_progress, instant_scroll)

			if not Managers.ui:using_cursor_navigation() then
				item_grid:select_grid_index(widget_index)
			end

			self:_preview_element(element)

			break
		end
	end
end

ItemGridViewBase.item_grid_index = function (self, item)
	if not item then
		return
	end

	local item_grid = self._item_grid
	local widgets = item_grid:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_item = element.item

		if element_item and element_item.gear_id == item.gear_id then
			local widget_index = item_grid:widget_index(widget) or 1

			return widget_index
		end
	end
end

ItemGridViewBase.first_grid_item = function (self)
	local item_grid = self._item_grid
	local widgets = item_grid:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_item = element.item

		if element_item then
			return element_item
		end
	end
end

ItemGridViewBase.element_by_index = function (self, index)
	return self._item_grid:element_by_index(index)
end

ItemGridViewBase.trigger_sort_index = function (self, index)
	if self._item_grid then
		self._item_grid:trigger_sort_index(index)
	end
end

ItemGridViewBase.cb_on_inspect_pressed = function (self)
	local previewed_item = self._previewed_item

	if previewed_item then
		local item_type = previewed_item.item_type
		local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"
		local view_name = "cosmetics_inspect_view"

		if is_weapon or item_type == "GADGET" then
			view_name = "inventory_weapon_details_view"
		end

		if not Managers.ui:view_active(view_name) then
			local context

			if item_type == "WEAPON_SKIN" then
				local include_skin_item_texts = true
				local visual_item = ItemUtils.weapon_skin_preview_item(previewed_item, include_skin_item_texts)
				local player_profile = self._presentation_profile
				local is_item_supported_on_played_character = false

				if visual_item.archetypes and not table.is_empty(visual_item.archetypes) then
					for i = 1, #visual_item.archetypes do
						local archetype = visual_item.archetypes[i]

						if archetype == player_profile.archetype.name then
							is_item_supported_on_played_character = true

							break
						end
					end
				else
					is_item_supported_on_played_character = true
				end

				local preffered_gender = player_profile and player_profile.gender
				local profile = is_item_supported_on_played_character and player_profile or ItemUtils.create_mannequin_profile_by_item(visual_item, preffered_gender)
				local slots = visual_item.slots
				local slot_name = slots[1]

				profile.loadout[slot_name] = visual_item

				local archetype = profile.archetype
				local breed_name = archetype.breed
				local breed = Breeds[breed_name]
				local state_machine = breed.inventory_state_machine
				local animation_event = visual_item.inventory_animation_event or "inventory_idle_default"

				context = {
					disable_zoom = true,
					profile = profile,
					state_machine = state_machine,
					animation_event = animation_event,
					wield_slot = slot_name,
					preview_with_gear = is_item_supported_on_played_character,
					preview_item = visual_item
				}
			else
				local profile = self._presentation_profile
				local is_item_supported_on_played_character = false

				if previewed_item.archetypes and not table.is_empty(previewed_item.archetypes) then
					for i = 1, #previewed_item.archetypes do
						local archetype = previewed_item.archetypes[i]

						if archetype == profile.archetype.name then
							is_item_supported_on_played_character = true

							break
						end
					end
				else
					is_item_supported_on_played_character = true
				end

				context = {
					profile = profile,
					preview_with_gear = is_item_supported_on_played_character,
					preview_item = previewed_item
				}
			end

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)

			self._inpect_view_opened = view_name
		end
	end
end

ItemGridViewBase.can_inspect_item = function (self)
	if self._previewed_item then
		return true
	end

	return false
end

ItemGridViewBase.cb_on_toggle_item_compare = function (self)
	self._item_compare_toggled = not self._item_compare_toggled

	if self._weapon_compare_stats then
		self._weapon_compare_stats:set_visibility(self._item_compare_toggled)
	end
end

ItemGridViewBase.sort_button_widget = function (self)
	if self._item_grid then
		return self._item_grid:sort_button_widget()
	end
end

ItemGridViewBase.sort_button_scenegraph = function (self)
	if self._item_grid then
		return self._item_grid:sort_button_scenegpraph()
	end
end

ItemGridViewBase.get_sort_button_world_position = function (self)
	if self._item_grid then
		return self._item_grid:get_sort_button_world_position()
	end
end

return ItemGridViewBase
