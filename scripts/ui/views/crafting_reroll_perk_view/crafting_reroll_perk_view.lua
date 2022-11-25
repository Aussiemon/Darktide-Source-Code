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
	local reroll_perk_costs = self._parent:crafting_costs().rerollPerk
	self._reroll_start_costs = reroll_perk_costs.startCost[tostring(self._item.rarity)]
	self._reroll_cost_increase = reroll_perk_costs.costIncrease
	self._crafting_costs = table.clone(self._reroll_start_costs)
	self._selected_grid = "weapon_stats"
end

CraftingRerollPerkView._update_reroll_costs = function (self, reroll_count)
	local start_costs = self._reroll_start_costs
	local cost_increase_factor = self._reroll_cost_increase^(reroll_count or 0)
	local crafting_costs = self._crafting_costs

	for i = 1, #start_costs do
		crafting_costs[i].amount = math.round(start_costs[i].amount * cost_increase_factor)
	end
end

CraftingRerollPerkView.on_enter = function (self)
	CraftingRerollPerkView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats = self:_setup_weapon_stats("weapon_stats", "weapon_stats_pivot")
	self._crafting_recipe = self:_setup_crafting_recipe("crafting_recipe", "crafting_recipe_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self:_present_item_upgrade(self._item)
	self._weapon_stats:select_first_index()
end

CraftingRerollPerkView._present_item_upgrade = function (self, item)
	self:_update_reroll_costs(self._item.reroll_count)

	local function on_present_callback()
		self:_update_weapon_stats_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._crafting_costs, callback(self, "cb_on_main_button_pressed"), on_present_callback)
	self._weapon_stats:present_item(item, nil, callback(self, "_update_weapon_stats_position", "weapon_stats_pivot", self._weapon_stats))
end

CraftingRerollPerkView._update_weapon_stats_position = function (self, scenegraph_id, weapon_stats)
	local position = self:_scenegraph_world_position(scenegraph_id)

	weapon_stats:set_pivot_offset(position[1], position[2])
	self:_set_scenegraph_size(scenegraph_id, nil, weapon_stats:grid_height())
end

CraftingRerollPerkView.on_resolution_modified = function (self, scale)
	CraftingRerollPerkView.super.on_resolution_modified(self, scale)
	self:_update_weapon_stats_position("crafting_recipe_pivot", self._crafting_recipe)
	self:_update_weapon_stats_position("weapon_stats_pivot", self._weapon_stats)
end

CraftingRerollPerkView.on_back_pressed = function (self)
	if self._craft_promise then
		return true
	end

	if not self._using_cursor_navigation and self._selected_grid == "crafting_recipe" then
		return true
	end

	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingRerollPerkView._set_selected_grid = function (self, new_selected_grid)
	self._selected_grid = new_selected_grid

	if self._using_cursor_navigation then
		return
	end

	if new_selected_grid == "weapon_stats" then
		self._crafting_recipe:disable_input(true)
		self._crafting_recipe:select_grid_index(nil)
		self._weapon_stats:disable_input(false)
	elseif new_selected_grid == "crafting_recipe" then
		self._crafting_recipe:disable_input(false)
		self._crafting_recipe:select_first_index()
		self._weapon_stats:disable_input(true)
	else
		ferror("Unknown grid: %s", new_selected_grid)
	end

	self._selected_grid = new_selected_grid
end

CraftingRerollPerkView.update = function (self, dt, t, input_service)
	local wanted_grid = self._wanted_grid

	if wanted_grid then
		self:_set_selected_grid(wanted_grid)

		self._wanted_grid = nil
	end

	return CraftingRerollPerkView.super.update(self, dt, t, input_service)
end

CraftingRerollPerkView._handle_input = function (self, input_service)
	if self._selected_grid == "weapon_stats" then
		if input_service:get("confirm_pressed") then
			local widget_index = self._weapon_stats:selected_grid_index()

			if widget_index then
				local widget = self._weapon_stats:widgets()[widget_index]
				local widget_content = widget.content
				self._ingredients.existing_perk_index = widget_content.perk_index
			end

			local item_rarity_minus_one = self._item.rarity
			local costs = self._crafting_costs[tostring(item_rarity_minus_one)]

			self._crafting_recipe:present_recipe(self._recipe, costs, callback(self, "cb_on_main_button_pressed"), callback(self, "_update_weapon_stats_position", "crafting_recipe_pivot", self._crafting_recipe))

			self._wanted_grid = "crafting_recipe"
		end
	elseif self._selected_grid == "crafting_recipe" and input_service:get("back") then
		self._wanted_grid = "weapon_stats"
	end
end

CraftingRerollPerkView.get_warning = function (self)
	return "BLAHBLAH"
end

CraftingRerollPerkView.cb_on_main_button_pressed = function (self, recipe)
	local craft_promise = self._recipe.craft(self._ingredients)
	self._craft_promise = craft_promise

	self._crafting_recipe:play_craft_animation()
	craft_promise:next(function (new_item)
		self._craft_promise = nil

		Managers.event:trigger("event_vendor_view_purchased_item")
		self._parent:play_vo_events({
			"crafting_complete"
		}, "tech_priest_a", nil, 1.4)

		local new_perk = new_item.perks[self._ingredients.existing_perk_index]
		local perk_id = new_perk.id
		local perk_value = new_perk.value
		local perk_rarity = new_perk.rarity
		local perk_item = MasterItems.get_item(perk_id)
		self._perk_display_name = ItemUtils.perk_description(perk_item, perk_rarity, perk_value)
		self._item = new_item
		self._ingredients.item = new_item

		self:_present_item_upgrade(new_item)
		Managers.event:trigger("event_add_notification_message", "default", Localize("loc_crafting_reroll_success"))
	end):catch(function (err)
		self._craft_promise = nil

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_crafting_failure")
		})
	end)
end

CraftingRerollPerkView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:disable_input(false)
		self._crafting_recipe:select_grid_index(nil)
		self._weapon_stats:disable_input(false)
		self._weapon_stats:select_grid_index(nil)
	else
		self:_set_selected_grid(self._selected_grid)
	end
end

CraftingRerollPerkView._setup_crafting_recipe = function (self, reference_name, scenegraph_id)
	local layer = 10
	local edge_padding = 30
	local grid_width = 430
	local grid_height = 800
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

CraftingRerollPerkView._setup_weapon_stats = function (self, reference_name, scenegraph_id)
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
		perks_selectable = true,
		grid_spacing = grid_spacing,
		grid_size = grid_size,
		mask_size = mask_size,
		title_height = title_height,
		edge_padding = edge_padding
	}

	return self:_add_element(ViewElementWeaponStats, reference_name, layer, context)
end

CraftingRerollPerkView.on_perk_selected = function (self, perk_index, perk_display_name)
	self._perk_display_name = perk_display_name
	self._ingredients.existing_perk_index = perk_index
end

CraftingRerollPerkView.can_afford = function (self, amount, currency)
	return self._parent:can_afford(amount, currency)
end

CraftingRerollPerkView.can_craft = function (self)
	if self._craft_promise then
		return false, "loc_crafting_loading"
	end

	local ingredients = self._ingredients

	if not ingredients.existing_perk_index then
		return false, "loc_crafting_no_perk_selected"
	end

	if not self._recipe.can_craft(ingredients) then
		return false, "loc_crafting_failure"
	end

	for _, cost in pairs(self._crafting_costs) do
		if not self:can_afford(cost.amount, cost.type) then
			return false, "loc_not_enough_resources"
		end
	end

	return true
end

CraftingRerollPerkView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingRerollPerkView
