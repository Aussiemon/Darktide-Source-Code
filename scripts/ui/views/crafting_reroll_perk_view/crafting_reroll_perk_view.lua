local CraftingRerollPerkViewDefinitions = require("scripts/ui/views/crafting_reroll_perk_view/crafting_reroll_perk_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local InputDevice = require("scripts/managers/input/input_device")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local CraftingRerollPerkView = class("CraftingRerollPerkView", "BaseView")

CraftingRerollPerkView.init = function (self, settings, context)
	CraftingRerollPerkView.super.init(self, CraftingRerollPerkViewDefinitions, settings, context)

	self._pass_input = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.reroll_perk
	self._ingredients = {
		item = self._item
	}
end

CraftingRerollPerkView.on_enter = function (self)
	CraftingRerollPerkView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 10, CraftingSettings.weapon_stats_context, "weapon_stats_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, CraftingSettings.crafting_recipe_context, "crafting_recipe_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self:_present_crafting()

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets, self)
end

CraftingRerollPerkView._present_crafting = function (self, optional_present_callback)
	local function on_present_recipe_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not Managers.ui:using_cursor_navigation() and not self._crafting_recipe:selected_grid_index() then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, callback(self, "cb_on_perk_selected"), on_present_recipe_callback)
	self._crafting_recipe:set_continue_button_callback(callback(self, "cb_on_main_button_pressed"))

	local function on_present_stats_callback()
		self._weapon_stats:select_perk(self._ingredients.existing_perk_index)
		self:_update_element_position("weapon_stats_pivot", self._weapon_stats)

		if optional_present_callback then
			optional_present_callback()
		end
	end

	self._weapon_stats:present_item(self._item, nil, on_present_stats_callback)
end

CraftingRerollPerkView._handle_input = function (self, input_service)
	if not self._craft_promise then
		local crafting_recipe = self._crafting_recipe

		if crafting_recipe:can_craft() and InputDevice.gamepad_active and input_service:get("hotkey_menu_special_2_released") then
			self._should_perform_crafting = true
		end
	end

	CraftingRerollPerkView.super._handle_input(self, input_service)
end

CraftingRerollPerkView.update = function (self, dt, t, input_service)
	local pass_input, pass_draw = CraftingRerollPerkView.super.update(self, dt, t, input_service)

	if self._should_perform_crafting then
		self._should_perform_crafting = nil

		self:_perform_crafting()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	return pass_input, pass_draw
end

CraftingRerollPerkView.on_back_pressed = function (self)
	if self._craft_promise then
		return true
	end

	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingRerollPerkView.cb_on_main_button_pressed = function (self)
	if self._craft_promise then
		return
	end

	self._should_perform_crafting = true
end

CraftingRerollPerkView._perform_crafting = function (self)
	if self._craft_promise then
		return
	end

	self._crafting_recipe:play_craft_animation()

	local recipe = self._recipe

	if recipe then
		self:_play_sound(recipe.sound_event)
	end

	self._crafting_recipe:set_continue_button_force_disabled(true)

	local existing_perk_index = self._ingredients.existing_perk_index
	local craft_promise = self._parent:craft(recipe, self._ingredients)
	self._craft_promise = craft_promise

	craft_promise:next(function (results)
		self._craft_promise = nil
		local new_item = results.items[1]
		self._item = new_item
		self._ingredients.item = new_item
		local optional_present_callback = callback(function ()
			local marked_widget = nil
			local recipe_widgets = self._crafting_recipe:widgets()
			local perk_widget_index_counter = 0

			for i = 1, #recipe_widgets do
				local recipe_widget = recipe_widgets[i]
				local content = recipe_widget.content

				if content.rank then
					perk_widget_index_counter = perk_widget_index_counter + 1

					if perk_widget_index_counter == existing_perk_index then
						marked_widget = recipe_widget

						break
					end
				end
			end

			self:cb_on_perk_selected(nil, nil)
		end)

		self:_present_crafting(optional_present_callback)

		local new_perk = new_item.perks[existing_perk_index]
		local new_perk_id = new_perk.id
		local perk_item = MasterItems.get_item(new_perk_id)
		self._perk_display_name = ItemUtils.perk_description(perk_item, new_perk.rarity, new_perk.value)
	end, function ()
		self._craft_promise = nil
	end)
end

CraftingRerollPerkView.cb_on_perk_selected = function (self, widget, config)
	local index = config and config.index
	local existing_perk_index = self._ingredients.existing_perk_index
	local already_active = existing_perk_index == index

	if already_active then
		index = nil
	end

	self._ingredients.existing_perk_index = index

	self._weapon_stats:select_perk(index)

	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_widget(not already_active and widget or nil)
	end

	local recipe_widgets = self._crafting_recipe:widgets()

	for i = 1, #recipe_widgets do
		local recipe_widget = recipe_widgets[i]
		local content = recipe_widget.content
		content.marked = index and recipe_widget == widget or false
	end

	self._crafting_recipe:set_continue_button_force_disabled(index == nil)
end

CraftingRerollPerkView._on_navigation_input_changed = function (self)
	if not self._using_cursor_navigation and not self._crafting_recipe:selected_grid_index() then
		self._crafting_recipe:select_first_index()
	end
end

CraftingRerollPerkView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingRerollPerkView
