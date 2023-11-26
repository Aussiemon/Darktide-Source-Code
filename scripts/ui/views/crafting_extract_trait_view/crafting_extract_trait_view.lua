-- chunkname: @scripts/ui/views/crafting_extract_trait_view/crafting_extract_trait_view.lua

local CraftingExtractTraitViewDefinitions = require("scripts/ui/views/crafting_extract_trait_view/crafting_extract_trait_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local InputDevice = require("scripts/managers/input/input_device")
local ItemUtils = require("scripts/utilities/items")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local CraftingExtractTraitView = class("CraftingExtractTraitView", "BaseView")

CraftingExtractTraitView.init = function (self, settings, context)
	CraftingExtractTraitView.super.init(self, CraftingExtractTraitViewDefinitions, settings, context)

	self._pass_input = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.extract_trait
	self._ingredients = {
		item = self._item
	}
end

CraftingExtractTraitView.on_enter = function (self)
	CraftingExtractTraitView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 10, CraftingSettings.weapon_stats_context, "weapon_stats_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, CraftingSettings.crafting_recipe_context, "crafting_recipe_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self._crafting_recipe:disable_price_prasentation()
	self:_present_crafting(self._item)

	local trait_category = ItemUtils.trait_category(self._item)
	local traits_promises = Managers.data_service.crafting:trait_sticker_book(trait_category)

	self._traits_promises = traits_promises

	traits_promises:next(callback(self, "_cb_fetch_trait_data")):catch(function (err)
		error(err)
	end)

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets, self)
	self._resync_can_craft = true
end

CraftingExtractTraitView._cb_fetch_trait_data = function (self, seen_traits)
	self._traits_promises = nil
	self._seen_traits = seen_traits
	self._resync_can_craft = true
end

CraftingExtractTraitView._present_crafting = function (self)
	local function on_present_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not Managers.ui:using_cursor_navigation() and not self._crafting_recipe:selected_grid_index() then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, callback(self, "cb_on_trait_selected"), on_present_callback)
	self._crafting_recipe:set_continue_button_callback(callback(self, "cb_on_main_button_pressed"))

	local item = self._item

	if item then
		self._weapon_stats:present_item(item, nil, callback(self, "_update_element_position", "weapon_stats_pivot", self._weapon_stats))
	else
		self._weapon_stats:stop_presenting()
	end
end

CraftingExtractTraitView.on_back_pressed = function (self)
	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingExtractTraitView.cb_on_main_button_pressed = function (self)
	if self._craft_promise then
		return
	end

	self._should_perform_crafting = true
end

CraftingExtractTraitView._perform_crafting = function (self)
	if self._craft_promise then
		return
	end

	self._crafting_recipe:play_craft_animation()

	local recipe = self._recipe

	if recipe then
		self:_play_sound(recipe.sound_event)
	end

	local item = self._item

	self._crafting_recipe:set_continue_button_force_disabled(true)

	local craft_promise = self._parent:craft(recipe, self._ingredients)

	self._craft_promise = craft_promise

	craft_promise:next(function (results)
		self._craft_promise = nil
		self._item = nil
		self._ingredients.item = nil

		self._parent:go_to_crafting_view("select_item", item)
	end, function ()
		self._craft_promise = nil
	end)
end

CraftingExtractTraitView._handle_input = function (self, input_service)
	if not self._craft_promise then
		local crafting_recipe = self._crafting_recipe

		if crafting_recipe:can_craft() and InputDevice.gamepad_active and input_service:get("hotkey_menu_special_2_released") then
			self._should_perform_crafting = true
		end
	end

	CraftingExtractTraitView.super._handle_input(self, input_service)
end

CraftingExtractTraitView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

CraftingExtractTraitView.cb_on_trait_selected = function (self, widget, config)
	local index = config.index
	local existing_trait_index = self._ingredients.existing_trait_index
	local already_active = existing_trait_index == index

	if already_active then
		index = nil
	end

	self._ingredients.existing_trait_index = index

	self._weapon_stats:select_trait(index)

	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_widget(not already_active and widget or nil)
	end

	local recipe_widgets = self._crafting_recipe:widgets()

	for i = 1, #recipe_widgets do
		local recipe_widget = recipe_widgets[i]
		local content = recipe_widget.content

		content.marked = index and recipe_widget == widget or false
	end

	self._resync_can_craft = true
end

CraftingExtractTraitView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

CraftingExtractTraitView._on_navigation_input_changed = function (self)
	if not self._using_cursor_navigation and not self._crafting_recipe:selected_grid_index() then
		self._crafting_recipe:select_first_index()
	elseif self._using_cursor_navigation and not self._ingredients.existing_trait_index then
		self._crafting_recipe:select_grid_index(nil)
	end
end

CraftingExtractTraitView.update = function (self, dt, t, input_service)
	if self._resync_can_craft then
		self._crafting_recipe:refresh_can_craft(self._seen_traits)

		self._resync_can_craft = nil
	end

	if self._should_perform_crafting then
		self._should_perform_crafting = nil

		self:_perform_crafting()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	return CraftingExtractTraitView.super.update(self, dt, t, input_service)
end

return CraftingExtractTraitView
