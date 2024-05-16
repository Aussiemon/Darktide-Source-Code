-- chunkname: @scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view.lua

local CraftingReplacePerkViewDefinitions = require("scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local InputDevice = require("scripts/managers/input/input_device")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local ViewElementPerksItem = require("scripts/ui/view_elements/view_element_perks_item/view_element_perks_item")
local CraftingReplacePerkView = class("CraftingReplacePerkView", "BaseView")

CraftingReplacePerkView.init = function (self, settings, context)
	CraftingReplacePerkView.super.init(self, CraftingReplacePerkViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.replace_perk
	self._ingredients = {
		item = self._item,
		perk_ids = {},
		perk_master_ids = {},
		tiers = {},
	}
	self._can_craft_context = {
		perk_items = {},
	}
end

CraftingReplacePerkView.on_enter = function (self)
	CraftingReplacePerkView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	local crafting_recipe_context = table.clone_instance(CraftingSettings.crafting_recipe_context)

	crafting_recipe_context.refresh_on_grid_pressed = false
	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 10, CraftingSettings.weapon_stats_context, "weapon_stats_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, CraftingSettings.crafting_recipe_context, "crafting_recipe_pivot")
	self._perks_item = self:_add_element(ViewElementPerksItem, "perks_item", 10, nil, "perks_item_pivot")

	self._perks_item:set_handle_grid_navigation(false)
	self._crafting_recipe:set_handle_grid_navigation(true)
	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self:_cb_fetch_perks_data()
	self:_get_wallet()
	self:_present_crafting()

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets, self)
end

CraftingReplacePerkView.on_exit = function (self)
	if self._craft_promise then
		self._craft_promise:cancel()

		self._craft_promise = nil
	end

	CraftingReplacePerkView.super.on_exit(self)
end

CraftingReplacePerkView._cb_fetch_perks_data = function (self)
	local item_master_id = self._item and self._item.name

	self._perks_item:present_perks(item_master_id, self._ingredients, callback(self, "cb_on_new_perk_selected")):next(function ()
		self._perks_item:set_color_intensity_multiplier(0.5)
		self._perks_item:disable()
	end)
end

CraftingReplacePerkView._get_wallet = function (self)
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

CraftingReplacePerkView._present_crafting = function (self, optional_present_callback)
	if not self._item then
		return
	end

	local function on_present_recipe_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if optional_present_callback then
			optional_present_callback()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, callback(self, "cb_on_perk_selected"), on_present_recipe_callback, self._can_craft_context)
	self._crafting_recipe:set_continue_button_callback(callback(self, "cb_on_main_button_pressed"))
	self._weapon_stats:present_item(self._item, nil, callback(self, "_update_element_position", "weapon_stats_pivot", self._weapon_stats))
end

CraftingReplacePerkView._set_perks_item_focused = function (self, focus)
	local crafting_recipe = self._crafting_recipe
	local perks_item = self._perks_item

	self._perks_item_focused = focus

	if focus then
		perks_item:enable()
		perks_item:set_handle_grid_navigation(true)
		perks_item:set_color_intensity_multiplier(1)
		crafting_recipe:set_handle_grid_navigation(false)
		crafting_recipe:set_navigation_button_color_intensity(0.7)
	else
		perks_item:disable()
		perks_item:clear_marks()
		perks_item:select_grid_index(nil)
		perks_item:set_handle_grid_navigation(false)
		perks_item:set_color_intensity_multiplier(0.5)
		crafting_recipe:set_handle_grid_navigation(true)
		crafting_recipe:set_navigation_button_color_intensity(1)
	end
end

CraftingReplacePerkView.on_back_pressed = function (self)
	if self._perks_item_focused then
		self:_set_perks_item_focused(false)
		self:_on_perk_selected()

		self._resync_can_craft = true
	else
		self._parent:go_to_crafting_view("select_item", self._item)
	end

	return true
end

CraftingReplacePerkView.cb_on_main_button_pressed = function (self)
	if self._craft_promise then
		return
	end

	self._should_perform_crafting = true
end

CraftingReplacePerkView._perform_crafting = function (self)
	if self._craft_promise then
		return
	end

	self._crafting_recipe:play_craft_animation()

	local recipe = self._recipe

	if recipe then
		self:_play_sound(recipe.sound_event)
	end

	self._crafting_recipe:set_continue_button_force_disabled(true)

	local craft_promise = self._parent:craft(recipe, self._ingredients)

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
		self:_on_perk_selected(nil, nil)

		self._perform_perk_selection_data = nil

		self._crafting_recipe:set_continue_button_force_disabled(false)
		self:_set_perks_item_focused(false)
	end, function ()
		self._craft_promise = nil
	end)
end

CraftingReplacePerkView.cb_on_perk_selected = function (self, widget, config)
	if self._using_cursor_navigation or not self._perks_item_focused then
		local remove_perks_focus = self._using_cursor_navigation and self._perks_item_focused

		self._perform_perk_selection_data = {
			widget = widget,
			config = config,
			remove_perk_items_focus = remove_perks_focus,
		}
	end
end

CraftingReplacePerkView._on_perk_selected = function (self, widget, config)
	local index = config and config.index

	if self._ingredients.existing_perk_index == index then
		index = nil
	end

	local previous_existing_perk_index = self._ingredients.existing_perk_index

	self._ingredients.existing_perk_index = index

	self._weapon_stats:select_perk(index)

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
		self:remove_ingredient(previous_existing_perk_index)
	end

	return selected
end

CraftingReplacePerkView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local existing_perk_index = self._ingredients.existing_perk_index
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name
			local element_input_service = input_service

			if existing_perk_index and element_name == "perks_item" then
				element_input_service = input_service:null_service()
			end

			element:draw(dt, t, ui_renderer, render_settings, element_input_service)
		end
	end
end

CraftingReplacePerkView._update_elements = function (self, dt, t, input_service)
	local existing_perk_index = self._ingredients.existing_perk_index
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name
			local element_input_service = input_service

			if existing_perk_index and element_name == "perks_item" then
				element_input_service = input_service:null_service()
			end

			element:update(dt, t, element_input_service)
		end
	end

	if self._perform_perk_selection_data then
		local widget = self._perform_perk_selection_data.widget
		local config = self._perform_perk_selection_data.config
		local remove_perk_items_focus = self._perform_perk_selection_data.remove_perk_items_focus

		self._perform_perk_selection_data = nil

		local selected_successful = self:_on_perk_selected(widget, config)

		if selected_successful then
			self:_set_perks_item_focused(true)
		elseif remove_perk_items_focus then
			self:_set_perks_item_focused(false)
		end
	end
end

CraftingReplacePerkView.remove_ingredient = function (self, ingredient_index)
	local perk_ids = self._ingredients.perk_ids

	if perk_ids and perk_ids[ingredient_index] then
		perk_ids[ingredient_index] = nil
	end

	self._resync_can_craft = true
end

CraftingReplacePerkView.update = function (self, dt, t, input_service)
	if self._resync_can_craft then
		local marked_perk_item = self._perks_item:marked_perk_item()

		self._ingredients.perk_ids[1] = marked_perk_item and marked_perk_item.name
		self._ingredients.perk_master_ids[1] = marked_perk_item and marked_perk_item.name
		self._ingredients.tiers[1] = marked_perk_item and marked_perk_item.rarity
		self._can_craft_context.perk_items[1] = marked_perk_item

		self._crafting_recipe:refresh_cost(self._can_craft_context)
		self._crafting_recipe:refresh_can_craft(self._can_craft_context)

		self._resync_can_craft = nil
	end

	if self._should_perform_crafting then
		self._should_perform_crafting = nil

		self:_perform_crafting()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	return CraftingReplacePerkView.super.update(self, dt, t, input_service)
end

CraftingReplacePerkView.cb_on_new_perk_selected = function (self, widget, config)
	self._resync_can_craft = true
end

CraftingReplacePerkView._handle_input = function (self, input_service)
	if not self._craft_promise then
		local crafting_recipe = self._crafting_recipe

		if crafting_recipe:can_craft() and InputDevice.gamepad_active and input_service:get("hotkey_menu_special_2_released") then
			self._should_perform_crafting = true
		end
	end

	CraftingReplacePerkView.super._handle_input(self, input_service)
end

CraftingReplacePerkView._on_navigation_input_changed = function (self)
	if not self._using_cursor_navigation and not self._crafting_recipe:selected_grid_index() then
		self._crafting_recipe:select_first_index()
	end
end

CraftingReplacePerkView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingReplacePerkView
