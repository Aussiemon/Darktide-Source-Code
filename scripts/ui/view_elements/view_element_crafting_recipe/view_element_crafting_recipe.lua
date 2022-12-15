local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local WalletSettings = require("scripts/settings/wallet_settings")
local ViewElementCraftingRecipeBlueprints = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe_blueprints")
local ViewElementCraftingRecipeDefinitions = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe_definitions")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementCraftingRecipe = class("ViewElementCraftingRecipe", "ViewElementGrid")

local function sort_wallet_currencies(cost1, cost2)
	local order1 = WalletSettings[cost1.type].sort_order
	local order2 = WalletSettings[cost2.type].sort_order

	return order1 < order2
end

ViewElementCraftingRecipe.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementCraftingRecipe.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, ViewElementCraftingRecipeDefinitions)

	self._default_grid_size = table.clone(self._menu_settings.grid_size)
	self._default_mask_size = table.clone(self._menu_settings.mask_size)

	self:present_grid_layout({}, ViewElementCraftingRecipeBlueprints)

	self.content = {}
end

ViewElementCraftingRecipe.set_selected_item = function (self, item)
	self.content.item = item
	local insufficient_funds = self.content.insufficient_funds or {}
	local dummy_ingredients = {
		item = item
	}

	for i, recipe in pairs(self.content.recipes) do
		local costs = item and recipe.get_costs(dummy_ingredients)
		local cost_string = ""

		if costs then
			table.sort(costs, sort_wallet_currencies)

			for j, cost in pairs(costs) do
				local can_afford = self._parent._parent:can_afford(cost.amount, cost.type)

				if not can_afford then
					cost_string = ""

					break
				end
			end
		end

		insufficient_funds[recipe.name] = cost_string
	end

	self.content.insufficient_funds = insufficient_funds
end

ViewElementCraftingRecipe.present_recipe_navigation = function (self, recipes, left_click_callback, optional_on_present_callback)
	local layout = {
		{
			widget_type = "spacing_vertical"
		}
	}
	local active_recipes = {}

	for i, recipe in ipairs(recipes) do
		if not recipe.ui_hidden and not recipe.ui_show_in_vendor_view then
			layout[#layout + 1] = {
				widget_type = "navigation_button",
				recipe = recipe
			}
			active_recipes[#active_recipes + 1] = recipe
		end
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}
	self.content.recipes = active_recipes
	self.content.insufficient_funds = {}

	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, ViewElementCraftingRecipeBlueprints, left_click_callback, nil, nil, nil, optional_on_present_callback)
end

local function _push_traitlike_items(layout, widget_type, traits, has_crafting_modification)
	if not traits then
		return
	end

	for i, trait in ipairs(traits) do
		if trait.modified or not has_crafting_modification then
			layout[#layout + 1] = {
				widget_type = widget_type,
				item = MasterItems.get_item(trait.id),
				rarity = trait.rarity,
				value = trait.value,
				index = i
			}
		end
	end
end

ViewElementCraftingRecipe.present_recipe = function (self, recipe, ingredients, main_action_callback, select_trait_callback, optional_on_present_callback)
	local item = ingredients.item
	local has_perk_modification = false
	local has_trait_modification = false

	if item then
		has_perk_modification, has_trait_modification = ItemUtils.has_crafting_modification(item)
	end

	local has_any_modification = has_perk_modification or has_trait_modification
	self.content.recipe = recipe
	self.content.ingredients = ingredients
	local layout = {
		[#layout + 1] = {
			widget_type = "spacing_vertical"
		},
		[#layout + 1] = {
			widget_type = "title",
			text = recipe.display_name
		},
		[#layout + 1] = {
			widget_type = "spacing_vertical_small"
		},
		[#layout + 1] = {
			widget_type = "description",
			text = recipe.description_text
		}
	}

	if recipe.modification_warning and not has_any_modification then
		layout[#layout + 1] = {
			widget_type = "description",
			text = recipe.modification_warning,
			color = Color.ui_red_super_light(nil, true)
		}
	end

	if item and recipe.requires_perk_selection then
		local filter_modified = recipe.requires_perk_selection ~= "all"
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_small"
		}

		_push_traitlike_items(layout, "perk_button", item and item.perks, filter_modified and has_perk_modification)
	end

	if item and recipe.requires_trait_selection then
		local filter_modified = recipe.requires_trait_selection ~= "all"
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_small"
		}

		_push_traitlike_items(layout, "trait_button", item and item.traits, filter_modified and has_trait_modification)
	end

	local costs = recipe.get_costs(ingredients)

	if costs then
		for i = #costs, 1, -1 do
			if costs[i].amount == 0 then
				table.remove(costs, i)
			end
		end

		if costs[1] then
			table.sort(costs, sort_wallet_currencies)

			self.content.costs = costs
			layout[#layout + 1] = {
				widget_type = "spacing_vertical_small"
			}
			layout[#layout + 1] = {
				widget_type = "recipe_costs",
				costs = costs
			}
		end
	end

	layout[#layout + 1] = {
		widget_type = "warning"
	}
	layout[#layout + 1] = {
		widget_type = "spacing_vertical_small"
	}
	layout[#layout + 1] = {
		widget_type = "craft_button",
		sound_event = recipe.sound_event,
		text = recipe.button_text
	}
	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}

	self:_refresh_can_craft()
	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, ViewElementCraftingRecipeBlueprints, main_action_callback, select_trait_callback, nil, nil, optional_on_present_callback)
end

ViewElementCraftingRecipe.cb_on_grid_entry_right_pressed = function (self, widget, element)
	ViewElementCraftingRecipe.super.cb_on_grid_entry_right_pressed(self, widget, element)
	self:_refresh_can_craft()
end

ViewElementCraftingRecipe._refresh_can_craft = function (self)
	local content = self.content
	local can_craft, fail_reason = content.recipe.can_craft(content.ingredients)
	local costs = content.costs

	if costs then
		local can_afford_all = true

		for i = 1, #costs do
			local cost = costs[i]
			local can_afford = self._parent._parent:can_afford(cost.amount, cost.type)
			cost.can_afford = can_afford

			if not can_afford then
				can_afford_all = false
			end
		end

		if not can_afford_all then
			fail_reason = "loc_not_enough_resources"
			can_craft = false
		end
	end

	content.can_craft = can_craft
	content.fail_reason = fail_reason and Localize(fail_reason)
end

ViewElementCraftingRecipe._pre_present_height_adjust = function (self)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local default_grid_height = self._default_grid_size[2]
	grid_size[2] = default_grid_height
	mask_size[2] = default_grid_height

	self:force_update_list_size()
end

ViewElementCraftingRecipe.set_overlay_texture = function (self, texture)
	local grid_background_widget = self._widgets_by_name.grid_background
	local material_values = grid_background_widget.style.crafting_recipe_background.material_values
	material_values.overlay_texture = texture

	return self:_start_animation("on_enter", self._widgets_by_name)
end

ViewElementCraftingRecipe.play_craft_animation = function (self, callback)
	return self:_start_animation("on_craft", self._widgets_by_name, nil, callback)
end

ViewElementCraftingRecipe._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementCraftingRecipe.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 30
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])
	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
end

return ViewElementCraftingRecipe
