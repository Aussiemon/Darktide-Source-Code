local CraftingModifyViewDefinitions = require("scripts/ui/views/crafting_modify_view/crafting_modify_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ItemUtils = require("scripts/utilities/items")

require("scripts/ui/views/item_grid_view_base/item_grid_view_base")

local CraftingModifyView = class("CraftingModifyView", "ItemGridViewBase")

CraftingModifyView.init = function (self, settings, context)
	self._parent = context.parent
	self._preselected_item = context.item
	self._selected_grid = "item_grid"
	self._wanted_grid = self._preselected_item and "crafting_recipe"

	CraftingModifyView.super.init(self, CraftingModifyViewDefinitions, settings, context)
end

CraftingModifyView.on_enter = function (self)
	CraftingModifyView.super.on_enter(self)
	self._parent:set_active_view_instance(self)
	self._item_grid:update_dividers("content/ui/materials/frames/item_list_top_hollow", {
		652,
		118
	}, {
		0,
		-88,
		200
	}, "content/ui/materials/frames/item_info_lower", nil, nil)

	self._crafting_recipe = self:_setup_crafting_recipe("crafting_recipe", "crafting_recipe_pivot")

	if self._preselected_item then
		self._crafting_recipe:present_recipe_navigation_with_item(CraftingSettings.recipes_ui_order, callback(self, "cb_on_recipe_button_pressed"), callback(self, "_update_weapon_stats_position", "crafting_recipe_pivot", self._crafting_recipe), self._preselected_item)
	else
		self._crafting_recipe:present_recipe_navigation(CraftingSettings.recipes_ui_order, callback(self, "cb_on_recipe_button_pressed"), callback(self, "_update_weapon_stats_position", "crafting_recipe_pivot", self._crafting_recipe))
	end

	local character_id = self:_player():character_id()
	local item_type_filter_list = {
		"WEAPON_MELEE",
		"WEAPON_RANGED",
		"GADGET"
	}
	self._inventory_promise = Managers.data_service.gear:fetch_inventory(character_id, nil, item_type_filter_list)

	self._inventory_promise:next(callback(self, "_cb_fetch_inventory_items"))
end

CraftingModifyView._setup_crafting_recipe = function (self, reference_name, scenegraph_id)
	local layer = 10
	local edge_padding = 30
	local grid_width = 430
	local grid_height = 600
	local context = {
		scrollbar_width = 7,
		hide_continue_button = true,
		top_padding = 10,
		title_height = 0,
		use_parent_ui_renderer = true,
		grid_spacing = {
			0,
			10
		},
		grid_size = {
			grid_width,
			grid_height
		},
		mask_size = {
			grid_width + edge_padding,
			grid_height
		},
		edge_padding = edge_padding
	}

	return self:_add_element(ViewElementCraftingRecipe, reference_name, layer, context)
end

CraftingModifyView._setup_sort_options = function (self)
	if not self._sort_options then
		self._sort_options = {
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_rarity")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					">",
					"item",
					ItemUtils.compare_item_rarity,
					">",
					"item",
					ItemUtils.compare_item_level,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_rarity")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"<",
					"item",
					ItemUtils.compare_item_rarity,
					">",
					"item",
					ItemUtils.compare_item_level,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_item_power")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					">",
					"item",
					ItemUtils.compare_item_level,
					">",
					"item",
					ItemUtils.compare_item_rarity,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_item_power")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"<",
					"item",
					ItemUtils.compare_item_level,
					">",
					"item",
					ItemUtils.compare_item_rarity,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_increasing_letters", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_name")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"<",
					"item",
					ItemUtils.compare_item_name,
					">",
					"item",
					ItemUtils.compare_item_level,
					">",
					"item",
					ItemUtils.compare_item_rarity
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_decreasing_letters", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_name")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					">",
					"item",
					ItemUtils.compare_item_name,
					">",
					"item",
					ItemUtils.compare_item_level,
					">",
					"item",
					ItemUtils.compare_item_rarity
				})
			}
		}
	end

	local sort_callback = callback(self, "cb_on_sort_button_pressed")

	self._item_grid:setup_sort_button(self._sort_options, sort_callback)
end

CraftingModifyView.on_resolution_modified = function (self, scale)
	CraftingModifyView.super.on_resolution_modified(self, scale)

	if self._crafting_recipe then
		self:_update_weapon_stats_position("crafting_recipe_pivot", self._crafting_recipe)
	end
end

CraftingModifyView._update_weapon_stats_position = function (self, scenegraph_id, weapon_stats)
	local position = self:_scenegraph_world_position(scenegraph_id)

	weapon_stats:set_pivot_offset(position[1], position[2])
	self:_set_scenegraph_size(scenegraph_id, nil, weapon_stats:grid_height())
end

CraftingModifyView._cb_on_present = function (self)
	CraftingModifyView.super._cb_on_present(self)

	local index = self._item_grid:selected_grid_index()

	self:scroll_to_grid_index(index, true)
end

CraftingModifyView.on_back_pressed = function (self)
	return not self._using_cursor_navigation and self._selected_grid == "crafting_recipe"
end

CraftingModifyView._set_trait_inventory_focused = function (self, focus)
	local crafting_recipe = self._crafting_recipe
	local trait_inventory = self._trait_inventory
	self._trait_inventory_focused = focus

	if focus then
		trait_inventory:enable()
		trait_inventory:set_handle_grid_navigation(true)
		trait_inventory:set_color_intensity_multiplier(1)
		crafting_recipe:set_handle_grid_navigation(false)
		crafting_recipe:set_navigation_button_color_intensity(0.7)
	else
		trait_inventory:disable()
		trait_inventory:clear_marks()
		trait_inventory:select_grid_index(nil)
		trait_inventory:set_handle_grid_navigation(false)
		trait_inventory:set_color_intensity_multiplier(0.5)
		crafting_recipe:set_handle_grid_navigation(true)
		crafting_recipe:set_navigation_button_color_intensity(1)
	end
end

CraftingModifyView._set_selected_grid = function (self, new_selected_grid)
	self._selected_grid = new_selected_grid

	if self._using_cursor_navigation then
		return
	end

	local crafting_recipe = self._crafting_recipe
	local item_grid = self._item_grid

	if new_selected_grid == "item_grid" then
		crafting_recipe:disable_input(true)
		crafting_recipe:select_grid_index(nil)
		crafting_recipe:set_navigation_button_color_intensity(0.7)
		item_grid:disable_input(false)
		item_grid:set_color_intensity_multiplier(1)
	elseif new_selected_grid == "crafting_recipe" then
		local previously_active_view_name = self._parent:previously_active_view_name()
		local widgets = crafting_recipe:widgets()
		local selection_index = nil

		for i = 1, #widgets do
			local widget = widgets[i]
			local content = widget.content
			local entry = content.entry
			local recipe = entry and entry.recipe

			if recipe and recipe.view_name == previously_active_view_name then
				selection_index = i

				break
			end
		end

		crafting_recipe:disable_input(false)

		if selection_index then
			crafting_recipe:select_grid_index(selection_index)
		else
			crafting_recipe:select_first_index()
		end

		crafting_recipe:set_navigation_button_color_intensity(1)
		item_grid:disable_input(true)
		item_grid:set_color_intensity_multiplier(0.5)
	else
		ferror("Unknown grid: %s", new_selected_grid)
	end

	self._selected_grid = new_selected_grid
end

CraftingModifyView.update = function (self, dt, t, input_service)
	local wanted_grid = self._wanted_grid

	if wanted_grid then
		self:_set_selected_grid(wanted_grid)

		self._wanted_grid = nil
	end

	return CraftingModifyView.super.update(self, dt, t, input_service)
end

CraftingModifyView._handle_input = function (self, input_service)
	if self._using_cursor_navigation then
		return
	end

	if self._selected_grid == "item_grid" then
		if input_service:get("confirm_pressed") and self._previewed_item then
			self._wanted_grid = "crafting_recipe"
		else
			local grid = self._item_grid
			local selected_index = grid:selected_grid_index()

			if self._current_select_grid_index ~= selected_index then
				self._current_select_grid_index = selected_index
				local widgets = self._item_grid:widgets()
				local widget = widgets[selected_index]

				if widget and widget.content.hotspot.pressed_callback then
					widget.content.hotspot.pressed_callback()
				end
			end
		end
	elseif self._selected_grid == "crafting_recipe" and input_service:get("back") then
		self._wanted_grid = "item_grid"
	end
end

CraftingModifyView.cb_on_recipe_button_pressed = function (self, _, config)
	self._parent:previously_active_view_name()
	self._parent:go_to_crafting_view(config.recipe.view_name, self._previewed_item)
end

CraftingModifyView._preview_item = function (self, item)
	CraftingModifyView.super._preview_item(self, item)

	if not self._current_item and not self._preselected_item then
		self._current_item = item

		self._crafting_recipe:present_recipe_navigation_with_item(CraftingSettings.recipes_ui_order, callback(self, "cb_on_recipe_button_pressed"), callback(self, "_update_weapon_stats_position", "crafting_recipe_pivot", self._crafting_recipe), item)
	elseif self._current_item ~= item then
		self._current_item = item

		self._crafting_recipe:set_selected_item(item)
	end

	local weapon_stats = self:_element("weapon_stats")
	local grid_height = weapon_stats:grid_height()

	self:_set_scenegraph_size("weapon_stats_pivot", nil, grid_height)
	self:_set_preview_widgets_visibility(false)
end

CraftingModifyView.on_exit = function (self)
	if self._inventory_promise then
		self._inventory_promise:cancel()

		self._inventory_promise = nil
	end

	CraftingModifyView.super.on_exit(self)
end

CraftingModifyView._cb_fetch_inventory_items = function (self, items)
	if self._destroyed then
		return
	end

	self._inventory_items = items
	local layout = {}

	for item_id, item in pairs(items) do
		local slots = item.slots

		if not item.no_crafting and slots then
			local slot_name = slots[1]
			layout[#layout + 1] = {
				widget_type = "item",
				item = item,
				slot = ItemSlotSettings[slot_name]
			}
		end
	end

	self._offer_items_layout = layout
	local tabs_content = CraftingModifyViewDefinitions.item_category_tabs_content

	self:_setup_menu_tabs(tabs_content)

	local preselected_item = self._preselected_item
	local tab_index = 1

	if preselected_item then
		self._selected_gear_id = preselected_item.gear_id
		local item_slots = preselected_item.slots

		for i = 1, #tabs_content do
			local tab_slots = tabs_content[i].slot_types

			if table.has_intersection(tab_slots, item_slots) then
				tab_index = i

				break
			end
		end
	end

	self:cb_switch_tab(tab_index)
end

CraftingModifyView.equipped_item_in_slot = function (self, slot_name)
	local player = self:_player()
	local profile = player:profile()
	local loadout = profile.loadout
	local slot_item = loadout[slot_name]

	return slot_item
end

CraftingModifyView._setup_menu_tabs = function (self, content)
	local id = "tab_menu"
	local layer = 10
	local tab_menu_settings = {
		button_spacing = 10,
		fixed_button_size = true,
		horizontal_alignment = "center",
		button_size = {
			132,
			38
		},
		input_label_offset = {
			10,
			5
		}
	}
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)
	self._tab_menu_element = tab_menu_element
	local input_action_left = "navigate_primary_left_pressed"
	local input_action_right = "navigate_primary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)

	local tab_button_template = ButtonPassTemplates.item_category_tab_menu_button
	local tab_ids = {}

	for i = 1, #content do
		local tab_content = content[i]
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(i, pressed_callback, tab_button_template, display_icon, nil, true)
		tab_ids[i] = tab_id
	end

	tab_menu_element:set_is_handling_navigation_input(true)

	self._tabs_content = content
	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

CraftingModifyView._on_navigation_input_changed = function (self)
	if self._item_grid then
		self._item_grid:_on_navigation_input_changed()
		self._item_grid:set_color_intensity_multiplier(1)
		self._crafting_recipe:set_navigation_button_color_intensity(1)
	end

	if self._using_cursor_navigation then
		self._crafting_recipe:disable_input(false)
		self._crafting_recipe:select_grid_index(nil)
		self._item_grid:disable_input(false)
		self._item_grid:select_grid_index(nil)
	else
		self:_set_selected_grid(self._selected_grid)
	end
end

CraftingModifyView.character_level = function (self)
	local player = self:_player()
	local profile = player:profile()

	return profile.current_level
end

CraftingModifyView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

CraftingModifyView.ui_renderer = function (self)
	return self._ui_renderer
end

return CraftingModifyView
