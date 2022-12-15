local CraftingExtractTraitViewDefinitions = require("scripts/ui/views/crafting_extract_trait_view/crafting_extract_trait_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
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
	self:_present_crafting(self._item)
end

CraftingExtractTraitView._present_crafting = function (self)
	local function on_present_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, callback(self, "cb_on_main_button_pressed"), callback(self, "cb_on_trait_selected"), on_present_callback)

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

CraftingExtractTraitView.cb_on_main_button_pressed = function (self, widget, config)
	if self._craft_promise then
		return
	end

	widget.content.hotspot.disabled = true

	self._crafting_recipe:play_craft_animation()

	local craft_promise = self._parent:craft(self._recipe, self._ingredients)
	self._craft_promise = craft_promise

	craft_promise:next(function (trait)
		self._craft_promise = nil
		self._item = nil
		self._ingredients.item = nil

		self:_present_crafting()
	end, function ()
		self._craft_promise = nil
	end)
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
	self._ingredients.existing_trait_index = index

	self._weapon_stats:select_trait(index)
end

CraftingExtractTraitView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

CraftingExtractTraitView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

return CraftingExtractTraitView
