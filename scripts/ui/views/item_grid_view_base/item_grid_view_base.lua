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

	local merged_definitions = table.clone(Definitions)

	if definitions then
		table.merge_recursive(merged_definitions, definitions)
	end

	self._definitions = merged_definitions
	self._context = context

	ItemGridViewBase.super.init(self, merged_definitions, settings)

	self._pass_input = true
	self._pass_draw = true
	self._render_settings = self._render_settings or {}
end

ItemGridViewBase.on_enter = function (self)
	ItemGridViewBase.super.on_enter(self)
	self:_setup_weapon_preview()
	self:_setup_weapon_stats()
	self:_setup_item_grid()
	self:_stop_previewing()

	self._item_definitions = MasterItems.get_cached()
	self._inventory_items = {}

	self:_setup_default_gui()
end

ItemGridViewBase._setup_sort_options = function (self)
	self._sort_options = {
		{
			display_name = "loc_inventory_item_grid_sort_title_rarity",
			sort_function = function (a, b)
				local a_item = a.item
				local b_item = b.item

				return ItemUtils.sort_items_by_rarity_low_first(a_item, b_item)
			end
		},
		{
			display_name = "loc_inventory_item_grid_sort_title_rarity",
			sort_function = function (a, b)
				local a_item = a.item
				local b_item = b.item

				return ItemUtils.sort_items_by_rarity_high_first(a_item, b_item)
			end
		},
		{
			display_name = "loc_inventory_item_grid_sort_title_name",
			sort_function = function (a, b)
				local a_item = a.item
				local b_item = b.item

				return ItemUtils.sort_items_by_name_low_first(a_item, b_item)
			end
		},
		{
			display_name = "loc_inventory_item_grid_sort_title_name",
			sort_function = function (a, b)
				local a_item = a.item
				local b_item = b.item

				return ItemUtils.sort_items_by_name_high_first(a_item, b_item)
			end
		}
	}
	local sort_callback = callback(self, "cb_on_sort_button_pressed")

	self._item_grid:setup_sort_button(self._sort_options, sort_callback, 1)
end

ItemGridViewBase._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = "ItemGridViewBase"
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
	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)

	local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button_icon)
	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
	}
	local tab_ids = {}

	for i = 1, #content, 1 do
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
	self._tab_menu_element:set_selected_index(index)

	local tabs_content = self._tabs_content
	local tab_content = tabs_content[index]
	local slot_types = tab_content.slot_types
	local display_name = tab_content.display_name

	self:_present_layout_by_slot_filter(slot_types, display_name)
end

ItemGridViewBase._present_layout_by_slot_filter = function (self, slot_filter, optional_display_name)
	local layout = self._offer_items_layout

	if layout then
		local filtered_layout = {}

		for i = #layout, 1, -1 do
			local entry = layout[i]
			local item = entry.item
			local add_item = false
			local slots = item.slots

			if slots then
				for _, slot_name in ipairs(slots) do
					if not slot_filter or table.find(slot_filter, slot_name) then
						add_item = true

						break
					end
				end
			end

			if add_item then
				filtered_layout[#filtered_layout + 1] = entry
			end
		end

		self._filtered_offer_items_layout = filtered_layout
		self._grid_display_name = optional_display_name

		self._item_grid:trigger_sort_index(1)
	end
end

ItemGridViewBase.grid_widgets = function (self)
	return self._item_grid:widgets()
end

ItemGridViewBase.selected_grid_index = function (self)
	return self._item_grid:selected_grid_index()
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
	self:_stop_previewing()

	local item = element.item
	local item_display_name = item.display_name

	if string.match(item_display_name, "unarmed") then
		return
	end

	self._previewed_item = item
	local slots = item.slots or {}
	local item_name = item.name
	local gear_id = item.gear_id or item_name

	if (table.find(slots, "slot_primary") or table.find(slots, "slot_secondary")) and self._weapon_stats then
		self._weapon_stats:present_item(item)
	end

	if self._weapon_preview then
		local disable_auto_spin = true

		self._weapon_preview:present_item(item, disable_auto_spin)
	end

	local display_name = ItemUtils.display_name(item)
	local sub_display_name = ItemUtils.sub_display_name(item)
	local rarity_color = ItemUtils.rarity_color(item)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.sub_display_name.content.text = sub_display_name
	widgets_by_name.display_name.content.text = display_name
	widgets_by_name.display_name_divider_glow.style.texture.color = table.clone(rarity_color)
	local visible = true

	self:_set_preview_widgets_visibility(visible)
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
			ignore_blur = true
		}
		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, context)
	end
end

ItemGridViewBase._setup_weapon_stats = function (self)
	if not self._weapon_stats then
		local reference_name = "weapon_stats"
		local layer = 10
		local context = {
			ignore_blur = true
		}
		self._weapon_stats = self:_add_element(ViewElementWeaponStats, reference_name, layer, context)

		self:_update_weapon_stats_position()
	end
end

ItemGridViewBase._update_weapon_stats_position = function (self)
	if not self._weapon_stats then
		return
	end

	local position = self:_scenegraph_world_position("weapon_stats_pivot")

	self._weapon_stats:set_pivot_offset(position[1], position[2])
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

	self:_update_item_grid_position()
	self:_setup_sort_options()
end

ItemGridViewBase._update_item_grid_position = function (self)
	if not self._item_grid then
		return
	end

	local position = self:_scenegraph_world_position("item_grid_pivot")

	self._item_grid:set_pivot_offset(position[1], position[2])
end

ItemGridViewBase.on_exit = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer("ItemGridViewBase" .. "_ui_default_renderer")

		local world = self._gui_world
		local viewport_name = self._gui_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._gui_viewport_name = nil
		self._gui_viewport = nil
		self._gui_world = nil
	end

	self:_destroy_weapon_preview()
	ItemGridViewBase.super.on_exit(self)
end

ItemGridViewBase.cb_on_sort_button_pressed = function (self, option)
	if not self._filtered_offer_items_layout then
		return
	end

	local layout = table.clone_instance(self._filtered_offer_items_layout)

	if #layout > 1 then
		local sort_function = option.sort_function

		table.sort(layout, sort_function)
	end

	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local grid_settings = self._definitions.grid_settings
	local grid_size = grid_settings.grid_size
	local ContentBlueprints = generate_blueprints_function(grid_size)
	local spacing_entry = {
		widget_type = "spacing_vertical_small"
	}

	table.insert(layout, 1, spacing_entry)
	table.insert(layout, #layout + 1, spacing_entry)
	self._item_grid:present_grid_layout(layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name)
end

ItemGridViewBase.cb_on_grid_entry_right_pressed = function (self, widget, element)
	return
end

ItemGridViewBase.cb_on_grid_entry_left_pressed = function (self, widget, element)
	local item = element.item

	if Managers.ui:using_cursor_navigation() and item and item ~= self._previewed_item then
		local widget_index = element.widget_index or 1

		self._item_grid:focus_grid_index(widget_index)
		self:_preview_element(element)
	end
end

ItemGridViewBase._handle_input = function (self, input_service)
	return
end

ItemGridViewBase.update = function (self, dt, t, input_service)
	if not Managers.ui:using_cursor_navigation() then
		local item_grid = self._item_grid
		local selected_grid_widget = item_grid and item_grid:selected_grid_widget()
		local selected_grid_element = selected_grid_widget and selected_grid_widget.content.element
		local selected_grid_item = selected_grid_element and selected_grid_element.item

		if selected_grid_item and selected_grid_item ~= self._previewed_item then
			local widget_index = selected_grid_element.widget_index or 1

			self._item_grid:focus_grid_index(widget_index)
			self:_preview_element(selected_grid_element)
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
	self:_update_item_grid_position()
	self:_update_weapon_stats_position()
	self:_update_tab_bar_position()
end

ItemGridViewBase.select_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	self._item_grid:select_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ItemGridViewBase.focus_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	self._item_grid:focus_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ItemGridViewBase.selected_grid_index = function (self)
	return self._item_grid:selected_grid_index()
end

ItemGridViewBase.scroll_to_grid_index = function (self, index)
	self._item_grid:scroll_to_grid_index(index)
end

ItemGridViewBase.focus_on_offer = function (self, offer)
	if not offer then
		return
	end

	local item_grid = self._item_grid
	local widgets = item_grid:widgets()

	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_offer = element.offer

		if element_offer and element_offer.offerId == offer.offerId then
			local widget_index = element.widget_index or 1
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

	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_item = element.item

		if element_item and element_item.gear_id == item.gear_id then
			local widget_index = element.widget_index or 1
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

	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		local content = widget.content
		local element = content.element
		local element_item = element.item

		if element_item and element_item.gear_id == item.gear_id then
			local widget_index = element.widget_index or 1

			return widget_index
		end
	end
end

ItemGridViewBase.element_by_index = function (self, index)
	return self._item_grid:element_by_index(index)
end

return ItemGridViewBase
