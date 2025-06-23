-- chunkname: @scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local TextUtilities = require("scripts/utilities/ui/text")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local WeaponStats = require("scripts/utilities/weapon_stats")
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

	local menu_settings = self._menu_settings

	self._default_grid_size = table.clone(menu_settings.grid_size)
	self._default_mask_size = table.clone(menu_settings.mask_size)

	self:present_grid_layout({}, ViewElementCraftingRecipeBlueprints)
	self:_set_scenegraph_position("grid_content_pivot", nil, nil, 100)

	self.content = {}

	local hide_continue_button = menu_settings.hide_continue_button

	self._hide_continue_button = hide_continue_button

	if hide_continue_button then
		self:disable_price_prasentation()

		self._widgets_by_name.continue_button.content.visible = false
		self._widgets_by_name.continue_button_background.content.visible = false
		self._widgets_by_name.continue_button_hold.content.visible = false
		self._widgets_by_name.grid_divider_bottom.content.texture = "content/ui/materials/dividers/horizontal_frame_big_lower"

		local grid_size = menu_settings.grid_size
		local mask_size = menu_settings.mask_size

		self:_set_scenegraph_size("grid_divider_bottom", mask_size[1], 36)
		self:_set_scenegraph_position("grid_divider_bottom", nil, 12)
	end

	local ui_renderer = self._ui_resource_renderer or self._parent:ui_renderer()

	self._widgets_by_name.continue_button_hold.content.size = {
		420,
		50
	}

	self:set_empty_message("")
	ButtonPassTemplates.terminal_button_hold_small.init(self, self._widgets_by_name.continue_button_hold, ui_renderer, {
		timer = 0.5,
		input_action = "hotkey_menu_special_2_hold",
		start_input_action = "hotkey_menu_special_2",
		keep_hold_active = true,
		text = Utf8.upper(Localize("loc_crafting_upgrade_button")),
		complete_function = callback(self, "_cb_on_continue_pressed")
	})
end

ViewElementCraftingRecipe.disable_price_prasentation = function (self)
	self._cost_presentation_disabled = true
	self._widgets_by_name.cost_background.content.visible = false
end

ViewElementCraftingRecipe.set_selected_item = function (self, item)
	self.content.item = item
end

ViewElementCraftingRecipe.set_navigation_button_color_intensity = function (self, multiplier)
	local widgets = self:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget.content.hotspot then
			widget.color_intensity_multiplier = multiplier
		end
	end
end

ViewElementCraftingRecipe.present_recipe_navigation = function (self, recipes, left_click_callback, optional_on_present_callback, type, additional_data)
	local layout = {
		{
			widget_type = "spacing_vertical"
		}
	}
	local active_recipes = {}

	for i, recipe in ipairs(recipes) do
		if not recipe.ui_hidden and not recipe.ui_show_in_vendor_view then
			local show_navigation = not recipe.validation_function or recipe.validation_function and recipe.validation_function()

			if show_navigation then
				layout[#layout + 1] = {
					widget_type = "navigation_button",
					recipe = recipe
				}
				active_recipes[#active_recipes + 1] = recipe
			end
		end
	end

	if #active_recipes == 0 then
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_large"
		}
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}
	self.content.recipes = active_recipes
	self.content.insufficient_funds = {}

	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, ViewElementCraftingRecipeBlueprints, left_click_callback, nil, nil, nil, optional_on_present_callback)
end

ViewElementCraftingRecipe.present_recipe_navigation_with_item = function (self, recipes, left_click_callback, optional_on_present_callback, item, type, additional_data)
	local layout = {}
	local active_recipes = {}

	if item and Items.is_weapon(item.item_type) then
		-- Nothing
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}

	local item_pattern = item and item.parent_pattern
	local mastery_data = additional_data and additional_data.masteries_data and item_pattern and additional_data.masteries_data[item_pattern]
	local expertise_data

	if item and mastery_data then
		local start_expertise = Items.expertise_level(item, true)
		local start_value = tonumber(start_expertise)
		local max_available_value = Mastery.get_current_expertise_cap(mastery_data) or 0
		local max_value = Mastery.get_max_expertise_cap(mastery_data) or 0

		expertise_data = {
			start = start_value,
			max_available = max_available_value,
			max = max_value
		}
	end

	for i, recipe in ipairs(recipes) do
		if not recipe.ui_hidden and not recipe.ui_show_in_vendor_view then
			local show_navigation = not recipe.validation_function or recipe.validation_function and recipe.validation_function(item)

			if show_navigation then
				layout[#layout + 1] = {
					widget_type = "navigation_button",
					recipe = recipe,
					expertise_data = expertise_data
				}
				active_recipes[#active_recipes + 1] = recipe
			end
		end
	end

	if #active_recipes == 0 then
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_large"
		}
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}
	self.content.recipes = active_recipes

	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, ViewElementCraftingRecipeBlueprints, left_click_callback, nil, nil, nil, function ()
		optional_on_present_callback()
		self:set_selected_item(item)
	end)
end

local function _push_traitlike_items(layout, widget_type, traits, item_is_locked)
	if not traits then
		return
	end

	for i, trait in ipairs(traits) do
		if trait.modified or not item_is_locked then
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

ViewElementCraftingRecipe.present_recipe = function (self, recipe, ingredients, main_action_callback, select_trait_callback, optional_on_present_callback, additional_data, update_callback, type)
	local item = ingredients.item

	self.content.item = item
	self.content.recipe = recipe
	self.content.ingredients = ingredients
	self.content.additional_data = additional_data

	local layout = {}

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}
	layout[#layout + 1] = {
		widget_type = "title",
		text = recipe.display_name,
		unlocalized_text = recipe.unlocalized_display_name
	}

	local extra_elements = recipe.extra_elements

	if extra_elements then
		for i = 1, #extra_elements do
			local element = extra_elements[i]

			layout[#layout + 1] = {
				widget_type = "spacing_vertical_small"
			}
			layout[#layout + 1] = {
				widget_type = element.widget_type,
				element = element,
				ingredients = ingredients,
				recipe = recipe,
				additional_data = additional_data
			}
		end
	end

	if type ~= "crafting_mechanicus" and item and recipe.view_name ~= "crafting_extract_trait_view" and recipe.view_name ~= "crafting_upgrade_item_view" and item.item_type ~= "WEAPON_RANGED" and item.item_type == "WEAPON_MELEE" then
		-- Nothing
	end

	layout[#layout + 1] = {
		widget_type = "description",
		text = recipe.description_text,
		unlocalized_text = recipe.unlocalized_description_text
	}

	if item and recipe.requires_perk_selection then
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_small"
		}

		_push_traitlike_items(layout, "perk_button", item and item.perks)
	end

	if item and recipe.requires_trait_selection then
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_small"
		}

		_push_traitlike_items(layout, "trait_button", item and item.traits)
	end

	if item and recipe.view_name == "crafting_mechanicus_upgrade_expertise_view" then
		local start_value = additional_data.expertise_data.start
		local max_available = math.max(start_value, additional_data.expertise_data.max_available)

		if start_value == max_available then
			layout[#layout + 1] = {
				widget_type = "expertise_value_max",
				additional_data = additional_data,
				item = item
			}
		else
			layout[#layout + 1] = {
				widget_type = "expertise_value",
				additional_data = additional_data,
				item = item
			}
		end

		self:_add_stats_to_layout(item, layout, additional_data)

		self._use_continue_hold = true
	else
		self._use_continue_hold = nil
	end

	local costs = recipe.get_costs(ingredients, additional_data) or {}

	table.sort(costs, sort_wallet_currencies)

	self.content.costs = costs
	layout[#layout + 1] = {
		widget_type = "spacing_vertical_small"
	}
	layout[#layout + 1] = {
		widget_type = "warning"
	}
	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}

	local widgets_by_name = self._widgets_by_name
	local continue_button_widget = widgets_by_name.continue_button
	local continue_button_widget_content = continue_button_widget.content
	local continue_button_widget_hotspot = continue_button_widget_content.hotspot

	continue_button_widget_hotspot.pressed_callback = callback(self, "_cb_on_continue_pressed")
	continue_button_widget_hotspot.on_pressed_sound = nil

	local button_text = recipe.unlocalized_button_text or recipe.button_text and Utf8.upper(Localize(recipe.button_text)) or "n/a"

	continue_button_widget_content.original_text = button_text
	widgets_by_name.continue_button_hold.content.original_text = button_text

	if self._use_continue_hold then
		continue_button_widget.content.visible = false
		widgets_by_name.continue_button_hold.content.visible = true
	else
		continue_button_widget.content.visible = true
		widgets_by_name.continue_button_hold.content.visible = false
	end

	self:refresh_can_craft(additional_data)
	self:_pre_present_height_adjust()
	self:present_grid_layout(layout, ViewElementCraftingRecipeBlueprints, main_action_callback, select_trait_callback, nil, nil, optional_on_present_callback)

	self._update_costs = true
end

ViewElementCraftingRecipe._add_stats_to_layout = function (self, item, layout, additional_data)
	local weapon_stats = WeaponStats:new(item)
	local comparing_stats = weapon_stats:get_comparing_stats()
	local num_stats = table.size(comparing_stats)
	local start_value = additional_data.expertise_data.start
	local max_available = math.max(start_value, additional_data.expertise_data.max_available)
	local start_stats = Items.preview_stats_change(item, 0, comparing_stats)
	local end_stats = Items.preview_stats_change(item, additional_data.expertise_data.current - additional_data.expertise_data.start, comparing_stats)
	local max_stats = Items.preview_stats_change(item, additional_data.expertise_data.max - additional_data.expertise_data.start, comparing_stats)
	local sort_order = {
		1,
		5,
		3,
		4,
		2
	}

	if start_value == max_available then
		layout[#layout + 1] = {
			widget_type = "stat_title_max"
		}

		for i = 1, num_stats do
			local sorted_i = sort_order[i]
			local display_name = comparing_stats[sorted_i].display_name
			local start_stat = start_stats[display_name]
			local max_stat = max_stats[display_name]

			layout[#layout + 1] = {
				widget_type = "stat_max",
				start_stat = start_stat,
				max_stat = max_stat,
				display_name = display_name
			}

			if i < num_stats then
				layout[#layout + 1] = {
					widget_type = "spacing_vertical_small"
				}
			end
		end
	else
		layout[#layout + 1] = {
			widget_type = "stat_title"
		}

		for i = 1, num_stats do
			local sorted_i = sort_order[i]
			local display_name = comparing_stats[sorted_i].display_name
			local start_stat = start_stats[display_name]
			local end_stat = end_stats[display_name]
			local max_stat = max_stats[display_name]

			layout[#layout + 1] = {
				widget_type = "stat",
				start_stat = start_stat,
				end_stat = end_stat,
				max_stat = max_stat,
				display_name = display_name
			}

			if i < num_stats then
				layout[#layout + 1] = {
					widget_type = "spacing_vertical_small"
				}
			end
		end
	end
end

ViewElementCraftingRecipe._update_costs_presentation = function (self, costs, ui_renderer)
	local corner_right = self._widgets_by_name.corner_top_right

	if self._cost_widgets then
		for i = 1, #self._cost_widgets do
			local widget = self._cost_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._cost_widgets = nil
	end

	local total_width = 0
	local widgets = {}
	local text_margin = 3
	local price_margin = 10
	local index = 0

	if costs then
		local wallet_definition = self._definitions.cost_definitions

		for i = 1, #costs do
			local cost = costs[i]
			local amount = cost.amount
			local has_cost = amount > 0

			if has_cost then
				index = index + 1

				local wallet_type = cost.type
				local wallet_settings = WalletSettings[wallet_type]
				local font_gradient_material = cost.can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				local icon_texture_small = wallet_settings.icon_texture_small
				local widget = self:_create_widget("cost_" .. index, wallet_definition)

				widget.style.text.material = font_gradient_material
				widget.content.texture = icon_texture_small

				local text = TextUtilities.format_currency(amount)

				widget.content.text = text

				local style = widget.style
				local text_style = style.text
				local text_width, _ = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size)
				local icon_size = widget.style.texture.size

				widget.offset[1] = total_width
				widget.content.size = {
					text_width + icon_size[1] + text_margin,
					icon_size[2]
				}
				total_width = total_width + text_width + icon_size[1] + text_margin + price_margin
				widgets[#widgets + 1] = widget
			end
		end
	end

	local corner_width = corner_right and corner_right.content.original_size[1] or 0
	local corner_texture_size_minus_wallet = 100
	local icon_height = widgets[1] and widgets[1].content.size[2]
	local total_corner_width = math.max(total_width + corner_width - corner_texture_size_minus_wallet, 40)

	self:_set_scenegraph_size("cost_pivot", total_width - price_margin, icon_height)
	self:_set_scenegraph_size("cost_background", total_corner_width, nil)
	self:_force_update_scenegraph()

	self._cost_widgets = widgets
end

ViewElementCraftingRecipe.set_continue_button_force_disabled = function (self, is_disabled, force_effect)
	self._continue_button_force_disabled = is_disabled

	self:_update_continue_button_state(force_effect)
end

ViewElementCraftingRecipe.set_continue_button_callback = function (self, button_callback)
	self._continue_button_callback = button_callback
end

ViewElementCraftingRecipe._update_continue_button_state = function (self, force_effect)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.continue_button
	local widget_content = widget.content
	local widget_hotspot = widget_content.hotspot
	local disabled = not self:can_craft()

	if disabled and not widget_hotspot.disabled and not force_effect then
		self:stop_continue_button_animation()
	elseif (widget_hotspot.disabled or force_effect) and not disabled then
		self:play_continue_button_animation()
	end

	widget_hotspot.disabled = disabled
	widgets_by_name.continue_button_hold.content.hotspot.disabled = disabled
end

ViewElementCraftingRecipe._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementCraftingRecipe.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local cost_widgets = self._cost_widgets

	if cost_widgets then
		for i = 1, #cost_widgets do
			local widget = cost_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._update_costs then
		if not self._cost_presentation_disabled then
			local costs = self.content.costs

			self:_update_costs_presentation(costs, ui_renderer)
		end

		self._update_costs = nil
	end
end

ViewElementCraftingRecipe.update = function (self, dt, t, input_service)
	self:_update_continue_button_state()

	local ui_renderer = self._ui_resource_renderer or self._parent:ui_renderer()

	ButtonPassTemplates.terminal_button_hold_small.update(self, self._widgets_by_name.continue_button_hold, ui_renderer, dt)

	return ViewElementCraftingRecipe.super.update(self, dt, t, input_service)
end

ViewElementCraftingRecipe._cb_on_continue_pressed = function (self)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.continue_button

	if self._continue_button_callback then
		self._continue_button_callback(widget)
	end
end

ViewElementCraftingRecipe.cb_on_grid_entry_right_pressed = function (self, widget, element)
	ViewElementCraftingRecipe.super.cb_on_grid_entry_right_pressed(self, widget, element)

	local menu_settings = self._menu_settings

	if menu_settings.refresh_on_grid_pressed then
		self:refresh_cost(self.content.additional_data)
		self:refresh_can_craft(self.content.additional_data)
	end

	self:_play_sound(UISoundEvents.default_click)
end

ViewElementCraftingRecipe.remove_ingredient = function (self, ingredient)
	if self._parent and self._parent.remove_ingredient then
		self._parent:remove_ingredient(ingredient)
	end
end

ViewElementCraftingRecipe.refresh_can_craft = function (self, additional_data)
	local content = self.content
	local can_craft, fail_reason, error_type = content.recipe.can_craft(content.ingredients, additional_data)
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
			can_craft, fail_reason = false, Localize("loc_not_enough_resources")
		end
	end

	content.can_craft = can_craft
	content.fail_reason = fail_reason
	content.error_type = error_type
end

ViewElementCraftingRecipe.can_craft = function (self)
	local content = self.content

	return content.can_craft and not self._continue_button_force_disabled or false
end

ViewElementCraftingRecipe._is_costs_free_of_charge = function (self, costs)
	local is_free = true

	for i = 1, #costs do
		local cost = costs[i]

		if cost.amount > 0 then
			is_free = false

			break
		end
	end

	return is_free
end

ViewElementCraftingRecipe.refresh_cost = function (self, additional_data)
	local content = self.content

	content.costs = nil

	if not additional_data then
		return
	end

	local ingredients = content.ingredients
	local recipe = content.recipe
	local wallet = additional_data.wallet

	if not wallet then
		return
	end

	local costs = recipe.get_costs(ingredients, additional_data)

	content.costs = costs

	local cost_string = ""

	if costs then
		table.sort(costs, sort_wallet_currencies)

		for j, cost in pairs(costs) do
			local currency = cost.type
			local amount = cost.amount
			local wallet_amount = wallet[currency]

			if wallet_amount < amount then
				cost_string = ""

				break
			end
		end
	end

	self.content.insufficient_funds = cost_string
	self._update_costs = true
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

ViewElementCraftingRecipe.play_continue_button_animation = function (self)
	if self._activate_continue_button_anim_id then
		self:_stop_animation(self._activate_continue_button_anim_id)

		self._activate_continue_button_anim_id = nil
	end

	if self._deactivate_continue_button_anim_id then
		self:_stop_animation(self._deactivate_continue_button_anim_id)

		self._deactivate_continue_button_anim_id = nil
	end

	if not self._hide_continue_button then
		self._activate_continue_button_anim_id = self:_start_animation("activate_continue_button", self._widgets_by_name, nil)

		self:_play_sound(UISoundEvents.crafting_craft_button_activation)
	end
end

ViewElementCraftingRecipe.stop_continue_button_animation = function (self)
	if self._continue_button_anim_id then
		self:_stop_animation(self._continue_button_anim_id)

		self._continue_button_anim_id = nil
	end

	if self._deactivate_continue_button_anim_id then
		self:_stop_animation(self._deactivate_continue_button_anim_id)

		self._deactivate_continue_button_anim_id = nil
	end

	if not self._hide_continue_button then
		self._deactivate_continue_button_anim_id = self:_start_animation("deactivate_continue_button", self._widgets_by_name)

		self:_play_sound(UISoundEvents.crafting_craft_button_deactivation)
	end
end

ViewElementCraftingRecipe.play_craft_animation = function (self, callback)
	return self:_start_animation("on_craft", self._widgets_by_name, nil, callback)
end

ViewElementCraftingRecipe._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementCraftingRecipe.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 35
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])

	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
end

return ViewElementCraftingRecipe
