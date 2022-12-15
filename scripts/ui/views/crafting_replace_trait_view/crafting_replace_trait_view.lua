local CraftingReplaceTraitViewDefinitions = require("scripts/ui/views/crafting_replace_trait_view/crafting_replace_trait_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local Promise = require("scripts/foundation/utilities/promise")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementTraitInventory = require("scripts/ui/view_elements/view_element_trait_inventory/view_element_trait_inventory")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local CraftingReplaceTraitView = class("CraftingReplaceTraitView", "BaseView")

CraftingReplaceTraitView.init = function (self, settings, context)
	CraftingReplaceTraitView.super.init(self, CraftingReplaceTraitViewDefinitions, settings, context)

	self._pass_input = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.replace_trait
	self._ingredients = {
		item = self._item
	}
end

CraftingReplaceTraitView.on_enter = function (self)
	CraftingReplaceTraitView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 10, CraftingSettings.weapon_stats_context, "weapon_stats_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, CraftingSettings.crafting_recipe_context, "crafting_recipe_pivot")
	self._trait_inventory = self:_add_element(ViewElementTraitInventory, "trait_inventory", 10, nil, "trait_inventory_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)

	local character_id = self:_player():character_id()
	local item_type_filter_list = {
		"TRAIT"
	}
	local inventory_promise = Managers.data_service.gear:fetch_inventory(character_id, nil, item_type_filter_list)
	local hack = "bespoke_" .. self._item.weapon_template:gsub("_m%d$", "")
	local sticker_book_promise = Managers.backend.interfaces.crafting:trait_sticker_book(hack)
	self._trait_data_promise = Promise.all(inventory_promise, sticker_book_promise):next(callback(self, "_cb_fetch_trait_data"))

	self:_present_crafting()
end

CraftingReplaceTraitView.on_exit = function (self)
	if self._trait_data_promise then
		self._trait_data_promise:cancel()

		self._trait_data_promise = nil
	end

	CraftingReplaceTraitView.super.on_exit(self)
end

CraftingReplaceTraitView._cb_fetch_trait_data = function (self, trait_data)
	local owned_traits = trait_data[1]
	local seen_traits = trait_data[2]

	self._trait_inventory:present_inventory(owned_traits, seen_traits, self._item)
	self._trait_inventory:select_first_index()
end

CraftingReplaceTraitView._present_crafting = function (self)
	local function on_present_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, callback(self, "cb_on_main_button_pressed"), callback(self, "cb_on_trait_selected"), on_present_callback)
	self._weapon_stats:present_item(self._item, nil, callback(self, "_update_element_position", "weapon_stats_pivot", self._weapon_stats))
end

CraftingReplaceTraitView.on_back_pressed = function (self)
	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingReplaceTraitView.cb_on_main_button_pressed = function (self, widget, config)
	if self._craft_promise then
		return
	end

	widget.content.hotspot.disabled = true

	self._crafting_recipe:play_craft_animation()

	local craft_promise = self._parent:craft(self._recipe, self._ingredients)
	self._craft_promise = craft_promise

	craft_promise:next(function (new_item)
		self._craft_promise = nil
		self._item = new_item
		self._ingredients.item = new_item

		self:_present_crafting(new_item)
	end, function ()
		self._craft_promise = nil
	end)
end

CraftingReplaceTraitView.cb_on_trait_selected = function (self, widget, config)
	local index = config.index
	self._ingredients.existing_trait_index = index

	self._weapon_stats:select_trait(index)
end

CraftingReplaceTraitView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

CraftingReplaceTraitView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingReplaceTraitView
