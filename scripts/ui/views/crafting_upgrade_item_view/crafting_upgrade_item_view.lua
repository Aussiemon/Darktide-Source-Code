local CraftingUpgradeItemViewDefinitions = require("scripts/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local Promise = require("scripts/foundation/utilities/promise")
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
	local crafting_costs = self._parent:crafting_costs()
	local item_type = self._item.item_type

	if item_type == "GADGET" then
		self._crafting_costs = crafting_costs.upgradeGadgetRarity
	else
		self._crafting_costs = crafting_costs.upgradeWeaponRarity
	end
end

CraftingUpgradeItemView.on_enter = function (self)
	CraftingUpgradeItemView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats_1 = self:_setup_weapon_stats("weapon_stats_1", "weapon_stats_1_pivot")
	self._weapon_stats_2 = self:_setup_weapon_stats("weapon_stats_2", "weapon_stats_2_pivot")
	self._crafting_recipe = self:_setup_crafting_recipe("crafting_recipe", "crafting_recipe_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self:_present_item_upgrade(self._item)
end

CraftingUpgradeItemView._update_weapon_stats_position = function (self, scenegraph_id, weapon_stats)
	local position = self:_scenegraph_world_position(scenegraph_id)

	weapon_stats:set_pivot_offset(position[1], position[2])
	self:_set_scenegraph_size(scenegraph_id, nil, weapon_stats:grid_height())
end

CraftingUpgradeItemView.on_resolution_modified = function (self, scale)
	CraftingUpgradeItemView.super.on_resolution_modified(self, scale)
	self:_update_weapon_stats_position("crafting_recipe_pivot", self._crafting_recipe)
	self:_update_weapon_stats_position("weapon_stats_1_pivot", self._weapon_stats_1)
	self:_update_weapon_stats_position("weapon_stats_2_pivot", self._weapon_stats_2)
end

CraftingUpgradeItemView.on_back_pressed = function (self)
	if self._craft_promise then
		return true
	end

	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingUpgradeItemView._present_item_upgrade = function (self, item)
	local costs = self._crafting_costs[tostring(item.rarity)]

	local function on_present_callback()
		self:_update_weapon_stats_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, costs, callback(self, "cb_on_main_button_pressed"), on_present_callback)
	self._weapon_stats_1:present_item(self._item, nil, callback(self, "_update_weapon_stats_position", "weapon_stats_1_pivot", self._weapon_stats_1))

	local can_craft = self._recipe.can_craft(self._ingredients)

	if can_craft then
		local bogus_item = self._recipe.get_bogus_result(self._ingredients)

		self._weapon_stats_2:present_item(bogus_item, nil, callback(self, "_update_weapon_stats_position", "weapon_stats_2_pivot", self._weapon_stats_2))
	else
		self._weapon_stats_2:stop_presenting()
	end

	self._widgets_by_name.progression_arrows.visible = can_craft
end

CraftingUpgradeItemView.cb_on_main_button_pressed = function (self, recipe)
	local craft_promise = self._recipe.craft(self._ingredients)
	self._craft_promise = craft_promise

	self._crafting_recipe:play_craft_animation()
	craft_promise:next(function (craft_result)
		return self._parent:update_wallets():next(function ()
			return craft_result
		end)
	end):next(function (new_item)
		self._craft_promise = nil

		Managers.event:trigger("event_vendor_view_purchased_item")
		self._parent:play_vo_events({
			"crafting_complete"
		}, "tech_priest_a", nil, 1.4)

		self._item = new_item
		self._ingredients.item = new_item

		self:_present_item_upgrade(new_item)
		Managers.event:trigger("event_add_notification_message", "default", Localize("loc_crafting_upgrade_success"))
	end):catch(function (err)
		self._craft_promise = nil

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_crafting_failure")
		})
	end)
end

CraftingUpgradeItemView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

CraftingUpgradeItemView._setup_crafting_recipe = function (self, reference_name, scenegraph_id)
	local layer = 10
	local edge_padding = 30
	local grid_width = 430
	local grid_height = 400
	local context = {
		scrollbar_width = 7,
		reset_selection_on_navigation_change = true,
		title_height = 0,
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

CraftingUpgradeItemView._setup_weapon_stats = function (self, reference_name, scenegraph_id)
	local layer = 10
	local title_height = 70
	local edge_padding = 12
	local grid_width = 530
	local grid_height = 920
	local grid_size = {
		grid_width - edge_padding,
		grid_height
	}
	local grid_spacing = {
		0,
		0
	}
	local mask_size = {
		grid_width + 40,
		grid_height
	}
	local context = {
		scrollbar_width = 7,
		grid_spacing = grid_spacing,
		grid_size = grid_size,
		mask_size = mask_size,
		title_height = title_height,
		edge_padding = edge_padding
	}

	return self:_add_element(ViewElementWeaponStats, reference_name, layer, context)
end

CraftingUpgradeItemView.can_afford = function (self, amount, currency)
	return self._parent:can_afford(amount, currency)
end

CraftingUpgradeItemView.can_craft = function (self)
	if self._craft_promise then
		return false, "loc_crafting_loading"
	end

	if not self._recipe.can_craft(self._ingredients) then
		return false, "loc_crafting_upgrade_max"
	end

	local item = self._item
	local costs = self._crafting_costs[item.rarity] or self._crafting_costs[tostring(item.rarity)]

	for _, cost in pairs(costs) do
		if not self:can_afford(cost.amount, cost.type) then
			return false, "loc_not_enough_resources"
		end
	end

	return true
end

CraftingUpgradeItemView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingUpgradeItemView
