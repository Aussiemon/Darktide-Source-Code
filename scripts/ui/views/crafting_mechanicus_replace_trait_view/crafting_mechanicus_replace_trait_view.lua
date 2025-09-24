-- chunkname: @scripts/ui/views/crafting_mechanicus_replace_trait_view/crafting_mechanicus_replace_trait_view.lua

local CraftingMechanicusReplaceTraitViewDefinitions = require("scripts/ui/views/crafting_mechanicus_replace_trait_view/crafting_mechanicus_replace_trait_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_mechanicus_settings")
local InputDevice = require("scripts/managers/input/input_device")
local ItemUtils = require("scripts/utilities/items")
local Promise = require("scripts/foundation/utilities/promise")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementTraitInventory = require("scripts/ui/view_elements/view_element_trait_inventory/view_element_trait_inventory")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local CraftingMechanicusReplaceTraitView = class("CraftingMechanicusReplaceTraitView", "BaseView")

CraftingMechanicusReplaceTraitView.init = function (self, settings, context)
	CraftingMechanicusReplaceTraitView.super.init(self, CraftingMechanicusReplaceTraitViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.replace_trait
	self._ingredients = {
		item = self._item,
		trait_ids = {},
		trait_master_ids = {},
		tiers = {},
	}
	self._can_craft_context = {
		trait_items = {},
	}
end

CraftingMechanicusReplaceTraitView.on_enter = function (self)
	CraftingMechanicusReplaceTraitView.super.on_enter(self)

	if not self._item then
		Managers.ui:close_view(self.view_name)
		self._parent:go_to_crafting_view("select_item_mechanicus")

		return
	end

	self._parent:set_active_view_instance(self)

	local crafting_recipe_context = table.clone_instance(CraftingSettings.crafting_recipe_context)

	crafting_recipe_context.refresh_on_grid_pressed = false
	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 10, CraftingSettings.weapon_stats_context, "weapon_stats_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, crafting_recipe_context, "crafting_recipe_pivot")
	self._trait_inventory = self:_add_element(ViewElementTraitInventory, "trait_inventory", 10, nil, "trait_inventory_pivot")

	self._trait_inventory:set_handle_grid_navigation(false)
	self._crafting_recipe:set_handle_grid_navigation(true)
	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)

	local trait_category = ItemUtils.trait_category(self._item)
	local seen_traits = Managers.data_service.crafting:cached_trait_sticker_book(trait_category)

	self:_cb_fetch_trait_data(seen_traits)
	self:_get_wallet()
	self:_present_crafting()

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets, self)
end

CraftingMechanicusReplaceTraitView.on_exit = function (self)
	if self._traits_promises then
		self._traits_promises:cancel()

		self._traits_promises = nil
	end

	if self._craft_promise then
		self._craft_promise:cancel()

		self._craft_promise = nil
	end

	CraftingMechanicusReplaceTraitView.super.on_exit(self)
end

CraftingMechanicusReplaceTraitView._cb_fetch_trait_data = function (self, seen_traits)
	self._trait_inventory:present_inventory(seen_traits, self._ingredients, callback(self, "cb_on_new_trait_selected"))
	self._trait_inventory:set_color_intensity_multiplier(0.5)
	self._trait_inventory:disable()

	self._trait_data_promise = nil
end

CraftingMechanicusReplaceTraitView._get_wallet = function (self)
	local store_service = Managers.data_service.store

	self._crafting_recipe:set_loading_state(true)

	return store_service:combined_wallets():next(function (wallets_data)
		if wallets_data and wallets_data.wallets then
			local wallets_values = {}

			for i = 1, #wallets_data.wallets do
				local currency = wallets_data.wallets[i].balance
				local type = currency.type
				local amount = currency.amount

				wallets_values[type] = amount
			end

			self._wallet = wallets_values
			self._can_craft_context.wallet = self._wallet

			self._crafting_recipe:set_loading_state(false)

			return true
		end
	end)
end

CraftingMechanicusReplaceTraitView._present_crafting = function (self, optional_present_callback)
	local function on_present_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if optional_present_callback then
			optional_present_callback()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, callback(self, "cb_on_trait_selected"), on_present_callback, self._can_craft_context, CraftingSettings.type)
	self._crafting_recipe:set_continue_button_callback(callback(self, "cb_on_main_button_pressed"))
	self._weapon_stats:present_item(self._item, nil, callback(self, "_update_element_position", "weapon_stats_pivot", self._weapon_stats))
end

CraftingMechanicusReplaceTraitView._set_trait_inventory_focused = function (self, focus)
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

CraftingMechanicusReplaceTraitView.on_back_pressed = function (self)
	if self._trait_inventory_focused then
		self:_set_trait_inventory_focused(false)
		self:_on_trait_selected()

		self._resync_can_craft = true
	else
		self._parent:go_to_crafting_view("select_item_mechanicus", self._item)
	end

	return true
end

CraftingMechanicusReplaceTraitView.cb_on_main_button_pressed = function (self)
	if self._craft_promise then
		return
	end

	self._should_perform_crafting = true
end

CraftingMechanicusReplaceTraitView._perform_crafting = function (self)
	if self._craft_promise then
		return
	end

	self._crafting_recipe:play_craft_animation()

	local recipe = self._recipe

	if recipe then
		self:_play_sound(recipe.sound_event)
	end

	self._crafting_recipe:set_continue_button_force_disabled(true)

	local craft_promise = self._parent:craft(self._recipe, self._ingredients)

	self._craft_promise = craft_promise

	craft_promise:next(function (results)
		self._craft_promise = nil

		local new_item = results.items[1]

		self._item = new_item
		self._ingredients.item = new_item

		local optional_present_callback = callback(function ()
			self:_on_navigation_input_changed()
		end)

		self:_present_crafting(optional_present_callback)
		self:_on_trait_selected(nil, nil)

		self._perform_trait_selection_data = nil

		self._crafting_recipe:set_continue_button_force_disabled(false)
		self:_set_trait_inventory_focused(false)
	end, function ()
		self._craft_promise = nil

		self._crafting_recipe:set_continue_button_force_disabled(false)
	end)
end

CraftingMechanicusReplaceTraitView.cb_on_trait_selected = function (self, widget, config)
	if self._using_cursor_navigation or not self._trait_inventory_focused then
		local remove_inventory_focus = self._using_cursor_navigation and self._trait_inventory_focused

		self._perform_trait_selection_data = {
			widget = widget,
			config = config,
			remove_inventory_focus = remove_inventory_focus,
		}
	end
end

CraftingMechanicusReplaceTraitView._on_trait_selected = function (self, widget, config)
	local index = config and config.index

	if self._ingredients.existing_trait_index == index then
		index = nil
	end

	local previous_existing_trait_index = self._ingredients.existing_trait_index

	self._ingredients.existing_trait_index = index

	self._weapon_stats:preview_trait(index)
	self._weapon_stats:select_trait(index)

	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_widget(index and widget or nil)
	end

	local recipe_widgets = self._crafting_recipe:widgets()

	for i = 1, #recipe_widgets do
		local recipe_widget = recipe_widgets[i]
		local content = recipe_widget.content

		content.marked = index and recipe_widget == widget or false
	end

	local selected = index ~= nil

	if not selected then
		self._weapon_stats:preview_trait(previous_existing_trait_index)
		self:remove_ingredient(previous_existing_trait_index)
	end

	self._resync_can_craft = true

	return selected
end

CraftingMechanicusReplaceTraitView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local existing_trait_index = self._ingredients.existing_trait_index
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name
			local element_input_service = input_service

			if existing_trait_index and element_name == "trait_inventory" then
				element_input_service = input_service:null_service()
			end

			element:draw(dt, t, ui_renderer, render_settings, element_input_service)
		end
	end
end

CraftingMechanicusReplaceTraitView._update_elements = function (self, dt, t, input_service)
	local existing_trait_index = self._ingredients.existing_trait_index
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name
			local element_input_service = input_service

			if existing_trait_index and element_name == "trait_inventory" then
				element_input_service = input_service:null_service()
			end

			element:update(dt, t, element_input_service)
		end
	end

	if self._perform_trait_selection_data then
		local widget = self._perform_trait_selection_data.widget
		local config = self._perform_trait_selection_data.config
		local remove_inventory_focus = self._perform_trait_selection_data.remove_inventory_focus

		self._perform_trait_selection_data = nil

		local selected_successful = self:_on_trait_selected(widget, config)

		if selected_successful then
			self:_set_trait_inventory_focused(true)
		elseif remove_inventory_focus then
			self:_set_trait_inventory_focused(false)
		end
	end
end

CraftingMechanicusReplaceTraitView.remove_ingredient = function (self, ingredient_index)
	local trait_ids = self._ingredients.trait_ids

	trait_ids[ingredient_index] = nil
	self._resync_can_craft = true
end

CraftingMechanicusReplaceTraitView.update = function (self, dt, t, input_service)
	if self._resync_can_craft then
		local marked_trait_item = self._trait_inventory:marked_trait_item()
		local marked_cost = self._trait_inventory:marked_trait_cost() or 0

		self._ingredients.trait_ids[1] = marked_trait_item and marked_trait_item.gear_id
		self._ingredients.trait_master_ids[1] = marked_trait_item and marked_trait_item.name
		self._ingredients.tiers[1] = marked_trait_item and marked_trait_item.rarity
		self._can_craft_context.trait_items[1] = marked_trait_item
		self._can_craft_context.marked_trait_cost = marked_cost

		local trait_widget = self._crafting_recipe:selected_grid_widget()

		self._can_craft_context.current_trait_cost = trait_widget and trait_widget.content.cost or 0

		self._crafting_recipe:refresh_cost(self._can_craft_context)
		self._crafting_recipe:refresh_can_craft(self._can_craft_context)

		if marked_trait_item then
			local preview_trait = {
				id = marked_trait_item and marked_trait_item.name,
				value = marked_trait_item and marked_trait_item.value,
				rarity = marked_trait_item and marked_trait_item.rarity,
			}

			self._weapon_stats:preview_trait(self._ingredients.existing_trait_index, preview_trait)
		else
			self._weapon_stats:preview_trait(self._ingredients.existing_trait_index)
		end

		self:_update_element_position("weapon_stats_pivot", self._weapon_stats)

		self._resync_can_craft = nil
	end

	if self._should_perform_crafting then
		self._should_perform_crafting = nil

		self:_perform_crafting()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	return CraftingMechanicusReplaceTraitView.super.update(self, dt, t, input_service)
end

CraftingMechanicusReplaceTraitView.cb_on_new_trait_selected = function (self, widget, config)
	self._resync_can_craft = true
end

CraftingMechanicusReplaceTraitView._handle_input = function (self, input_service)
	if not self._craft_promise then
		local crafting_recipe = self._crafting_recipe

		if crafting_recipe:can_craft() and InputDevice.gamepad_active and input_service:get("hotkey_menu_special_2_released") then
			self._should_perform_crafting = true
		end
	end

	CraftingMechanicusReplaceTraitView.super._handle_input(self, input_service)
end

CraftingMechanicusReplaceTraitView._on_navigation_input_changed = function (self)
	if not self._using_cursor_navigation and not self._crafting_recipe:selected_grid_index() then
		self._crafting_recipe:select_first_index()
	end
end

CraftingMechanicusReplaceTraitView.dialogue_system = function (self)
	return self._parent and self._parent:dialogue_system()
end

return CraftingMechanicusReplaceTraitView
