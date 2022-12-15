local CraftingRerollPerkViewDefinitions = require("scripts/ui/views/crafting_reroll_perk_view/crafting_reroll_perk_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
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
end

CraftingRerollPerkView._present_crafting = function (self)
	local function on_present_recipe_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation and not self._crafting_recipe:selected_grid_index() then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, callback(self, "cb_on_main_button_pressed"), callback(self, "cb_on_perk_selected"), on_present_recipe_callback)

	local function on_present_stats_callback()
		self._weapon_stats:select_perk(self._ingredients.existing_perk_index)
		self:_update_element_position("weapon_stats_pivot", self._weapon_stats)
	end

	self._weapon_stats:present_item(self._item, nil, on_present_stats_callback)
end

CraftingRerollPerkView.on_back_pressed = function (self)
	if self._craft_promise then
		return true
	end

	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingRerollPerkView.cb_on_main_button_pressed = function (self, widget, config)
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

		self:_present_crafting()

		local new_perk = new_item.perks[self._ingredients.existing_perk_index]
		local new_perk_id = new_perk.id
		local perk_item = MasterItems.get_item(new_perk_id)
		self._perk_display_name = ItemUtils.perk_description(perk_item, new_perk.rarity, new_perk.value)
	end, function ()
		self._craft_promise = nil
	end)
end

CraftingRerollPerkView.cb_on_perk_selected = function (self, widget, config)
	local index = config.index
	self._ingredients.existing_perk_index = index

	self._weapon_stats:select_perk(index)
end

CraftingRerollPerkView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

CraftingRerollPerkView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingRerollPerkView
