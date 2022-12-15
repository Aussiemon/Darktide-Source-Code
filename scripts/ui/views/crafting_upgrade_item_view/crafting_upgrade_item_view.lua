local CraftingUpgradeItemViewDefinitions = require("scripts/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local CraftingUpgradeItemView = class("CraftingUpgradeItemView", "BaseView")

CraftingUpgradeItemView.init = function (self, settings, context)
	CraftingUpgradeItemView.super.init(self, CraftingUpgradeItemViewDefinitions, settings, context)

	self._pass_input = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.upgrade_item
	self._ingredients = {
		item = self._item
	}
end

CraftingUpgradeItemView.on_enter = function (self)
	CraftingUpgradeItemView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats_1 = self:_add_element(ViewElementWeaponStats, "weapon_stats_1", 10, CraftingSettings.weapon_stats_context, "weapon_stats_1_pivot")
	self._weapon_stats_2 = self:_add_element(ViewElementWeaponStats, "weapon_stats_2", 10, CraftingSettings.weapon_stats_context, "weapon_stats_2_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, CraftingSettings.crafting_recipe_context, "crafting_recipe_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self:_present_crafting(self._item)
end

CraftingUpgradeItemView.on_exit = function (self)
	if self._craft_promise then
		self._craft_promise:cancel()

		self._craft_promise = nil
	end

	CraftingUpgradeItemView.super.on_exit(self)
end

CraftingUpgradeItemView.on_back_pressed = function (self)
	if self._craft_promise then
		return true
	end

	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingUpgradeItemView._present_crafting = function (self)
	local function on_present_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, callback(self, "cb_on_main_button_pressed"), nil, on_present_callback)
	self._weapon_stats_1:present_item(self._item, nil, callback(self, "_update_element_position", "weapon_stats_1_pivot", self._weapon_stats_1))

	local can_craft = self._recipe.can_craft(self._ingredients)

	if can_craft then
		local bogus_item = self._recipe.get_bogus_result(self._ingredients)

		self._weapon_stats_2:present_item(bogus_item, nil, callback(self, "_update_element_position", "weapon_stats_2_pivot", self._weapon_stats_2))
	else
		self._weapon_stats_2:stop_presenting()
	end

	self._widgets_by_name.progression_arrows.visible = can_craft
end

CraftingUpgradeItemView.cb_on_main_button_pressed = function (self, widget, config)
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

CraftingUpgradeItemView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

CraftingUpgradeItemView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingUpgradeItemView
