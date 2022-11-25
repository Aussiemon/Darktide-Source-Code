local WalletSettings = require("scripts/settings/wallet_settings")
local CraftingRecipeBlueprints = require("scripts/ui/view_content_blueprints/crafting_recipe_blueprints")
local ViewElementCraftingRecipeDefinitions = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe_definitions")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementCraftingRecipe = class("ViewElementCraftingRecipe", "ViewElementGrid")

ViewElementCraftingRecipe.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementCraftingRecipe.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, ViewElementCraftingRecipeDefinitions)

	self._default_grid_size = table.clone(self._menu_settings.grid_size)
	self._default_mask_size = table.clone(self._menu_settings.mask_size)

	self:present_grid_layout({}, CraftingRecipeBlueprints)
end

ViewElementCraftingRecipe.set_selected_item = function (self, item)
	local widgets = self:widgets()

	for i = 1, #widgets do
		local content = widgets[i].content
		local recipe = content.entry.recipe
		local validation_function = recipe and recipe.is_valid_item

		if validation_function then
			content.hotspot.disabled = recipe.ui_disabled or not item or not validation_function(item)
		end
	end
end

ViewElementCraftingRecipe.present_recipe_navigation = function (self, recipes, left_click_callback, optional_on_present_callback)
	local layout = {
		{
			widget_type = "spacing_vertical"
		}
	}

	for i, recipe in ipairs(recipes) do
		if not recipe.ui_hidden and not recipe.ui_show_in_vendor_view then
			layout[#layout + 1] = {
				widget_type = "navigation_button",
				display_name = recipe.display_name,
				icon = recipe.icon,
				recipe = recipe
			}
		end
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}

	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, CraftingRecipeBlueprints, left_click_callback, nil, nil, nil, optional_on_present_callback)
end

ViewElementCraftingRecipe.present_recipe = function (self, recipe, raw_costs, left_click_callback, optional_on_present_callback)
	local layout = {
		[#layout + 1] = {
			widget_type = "spacing_vertical"
		},
		[#layout + 1] = {
			widget_type = "title",
			text = recipe.display_name
		},
		[#layout + 1] = {
			widget_type = "description",
			text = recipe.description_text
		}
	}

	if recipe.requires_perk_selection then
		layout[#layout + 1] = {
			widget_type = "selected_perk"
		}
	end

	if raw_costs then
		local view_instance = self._parent
		local costs = {}

		for i = 1, #raw_costs do
			local cost = raw_costs[i]
			local amount = cost.amount
			local cost_type = cost.type
			costs[i] = {
				amount = amount,
				type = cost_type,
				can_afford = view_instance:can_afford(amount, cost_type)
			}
		end

		table.sort(costs, function (cost1, cost2)
			local type1 = WalletSettings[cost1.type].sort_order
			local type2 = WalletSettings[cost2.type].sort_order

			return type1 < type2
		end)

		layout[#layout + 1] = {
			widget_type = "recipe_costs",
			costs = costs
		}
	end

	local can_craft, can_craft_fail_reason = self._parent:can_craft()

	if not can_craft then
		layout[#layout + 1] = {
			widget_type = "warning",
			text = can_craft_fail_reason
		}
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical_small"
	}
	layout[#layout + 1] = {
		disabled = true,
		widget_type = "craft_button",
		sound_event = recipe.sound_event
	}
	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}

	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, CraftingRecipeBlueprints, left_click_callback, nil, nil, nil, optional_on_present_callback)
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
