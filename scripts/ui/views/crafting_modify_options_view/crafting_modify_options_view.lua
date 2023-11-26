-- chunkname: @scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view.lua

local Definitions = require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_definitions")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemUtils = require("scripts/utilities/items")
local WalletSettings = require("scripts/settings/wallet_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local ContentBlueprints = require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_blueprints")
local RaritySettings = require("scripts/settings/item/rarity_settings")

require("scripts/ui/views/item_grid_view_base/item_grid_view_base")

local crafting_options = {
	{
		type = "upgrade"
	},
	{
		type = "replace"
	},
	{
		type = "extract"
	}
}
local CraftingModifyOptionsView = class("CraftingModifyOptionsView", "ItemGridViewBase")

CraftingModifyOptionsView.init = function (self, settings, context)
	CraftingModifyOptionsView.super.init(self, Definitions, settings, context)

	self._preview_item = context and context.item
	self._parent = context and context.parent
	self._wallet_type = self._parent._wallet_type
	self._crafting_backend = Managers.backend.interfaces.crafting
	self._wanted_tab_index = 1
end

CraftingModifyOptionsView.upgrade_item = function (self)
	self._wanted_tab_index = 1
end

CraftingModifyOptionsView.extract_trait = function (self)
	self._wanted_tab_index = 3
end

CraftingModifyOptionsView.replace_trait = function (self)
	self._wanted_tab_index = 2
end

CraftingModifyOptionsView.on_enter = function (self)
	CraftingModifyOptionsView.super.on_enter(self)
	self:_setup_weapon_preview()
	self._weapon_preview:center_align(0, {
		0,
		0,
		0
	})
	self._parent:set_active_view_instance(self)
	self._parent:set_is_handling_navigation_input(true)

	self._crafting_promise = self._crafting_backend:get_crafting_costs():next(function (costs)
		if self._destroyed then
			return
		end

		self._costs = costs

		self:_fetch_inventory():next(function ()
			if self._destroyed then
				return
			end

			self._selected_tab_index = nil

			local local_player_id = 1
			local local_player = Managers.player:local_player(local_player_id)
			local profile = local_player:profile()
			local search_slot = {
				"slot_primary",
				"slot_secondary"
			}
			local weapon_equipped = false
			local weapon_slot

			for i = 1, #search_slot do
				local slot = search_slot[i]
				local loadout = profile.loadout[slot]

				if loadout and loadout.gear_id == self._preview_item.gear_id then
					weapon_equipped = true
					weapon_slot = slot

					break
				end
			end

			self._weapon_equipped = weapon_equipped
			self._weapon_slot = weapon_slot
			self._crafting_promise = nil
		end)
	end):catch(function (error)
		self._crafting_promise = nil
	end)

	Definitions.modify_arrow_animation.init(self)
end

CraftingModifyOptionsView._fetch_inventory = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()

	return Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		local traits = {}

		for item_id, item in pairs(items) do
			if item_id == self._preview_item.gear_id then
				self._preview_item = item
			elseif item.item_type == "TRAIT" then
				local trait_name = item.name
				local trait_exists = MasterItems.item_exists(trait_name)

				if trait_exists then
					local trait_item = MasterItems.get_item(trait_name)

					traits[#traits + 1] = {
						rarity = item.rarity,
						trait_categories = trait_item.weapon_type_restriction,
						name = trait_item.display_name and Localize(trait_item.display_name) or "",
						description = trait_item.description and Localize(trait_item.description) or "",
						icon = trait_item.icon,
						trait_category = trait_item.weapon_type_restriction[1],
						item_id = item.gear_id,
						trait_id = trait_item.name,
						trait_index = #traits + 1
					}
				end
			end
		end

		self._inventory_traits = traits
		self._weapon_traits = self:_generate_weapon_traits()
	end):catch(function (error)
		return
	end)
end

CraftingModifyOptionsView._get_wallet = function (self)
	local store_service = Managers.data_service.store
	local promise = Promise:new()

	store_service:combined_wallets():next(function (wallets_data)
		if wallets_data and wallets_data.wallets then
			local wallets_values = {}

			for i = 1, #wallets_data.wallets do
				local currency = wallets_data.wallets[i].balance
				local type = currency.type
				local amount = currency.amount

				wallets_values[type] = amount
			end

			self._wallet = wallets_values

			return promise:resolve()
		end
	end)

	return promise
end

CraftingModifyOptionsView._on_panel_option_pressed = function (self, index)
	if self._wallet_promise then
		self._wallet_promise:cancel()
	end

	local item = self._preview_item
	local display_name = ItemUtils.display_name(item)
	local sub_display_name = ItemUtils.sub_display_name(item)
	local rarity_color = ItemUtils.rarity_color(item)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.modify_sub_display_name.content.text = sub_display_name
	widgets_by_name.modify_display_name.content.text = display_name
	widgets_by_name.modify_divider_glow.style.texture.color = table.clone(rarity_color)

	self:_remove_selected_widget()

	self._wallet_promise = self:_get_wallet()

	self._wallet_promise:next(function ()
		if self._destroyed then
			return
		end

		self._wallet_promise = nil

		local disable_auto_spin = true

		self._weapon_preview:present_item(item, disable_auto_spin)

		local options_type = crafting_options[index].type

		self._widgets_by_name.modify_divider.content.visible = true
		self._widgets_by_name.modify_divider_glow.content.visible = true
		self._widgets_by_name.modify_display_name.content.visible = true
		self._widgets_by_name.modify_sub_display_name.content.visible = true

		if options_type == "upgrade" then
			local upgrade_count = item.upgrade_count or 0

			if not item.rarity then
				self._widgets_by_name.upgrade_unavailable_text.content.text = Localize("loc_crafting_upgrade_locked")
				self._widgets_by_name.upgrade_unavailable_text.content.visible = true
			else
				local costs = self._costs.upgradeWeaponRarity[tostring(item.rarity)]
				local next_rarity = item.rarity and item.rarity + 1

				if upgrade_count > 4 or not RaritySettings[next_rarity] or not costs then
					self._widgets_by_name.upgrade_unavailable_text.content.text = Localize("loc_crafting_upgrade_max")
					self._widgets_by_name.upgrade_unavailable_text.content.visible = true
				else
					local next_rarity = item.rarity + 1
					local currrent_rarity_name = ItemUtils.rarity_display_name({
						rarity = item.rarity
					})
					local current_rarity_color = ItemUtils.rarity_color({
						rarity = item.rarity
					})
					local next_rarity_name = ItemUtils.rarity_display_name({
						rarity = next_rarity
					})
					local next_rarity_color = ItemUtils.rarity_color({
						rarity = next_rarity
					})
					local current_rarity_localization_context = {
						rarity_color_b = 0,
						rarity_name = "n/a",
						rarity_color_g = 0,
						rarity_color_r = 0
					}

					current_rarity_localization_context.rarity_color_r = current_rarity_color[2]
					current_rarity_localization_context.rarity_color_g = current_rarity_color[3]
					current_rarity_localization_context.rarity_color_b = current_rarity_color[4]
					current_rarity_localization_context.rarity_name = currrent_rarity_name

					local next_rarity_localization_context = {
						rarity_color_b = 0,
						rarity_name = "n/a",
						rarity_color_g = 0,
						rarity_color_r = 0
					}

					next_rarity_localization_context.rarity_color_r = next_rarity_color[2]
					next_rarity_localization_context.rarity_color_g = next_rarity_color[3]
					next_rarity_localization_context.rarity_color_b = next_rarity_color[4]
					next_rarity_localization_context.rarity_name = next_rarity_name

					local no_cache = true
					local current_rarity_text = Localize("loc_crafting_upgrade_rarity", no_cache, current_rarity_localization_context)
					local next_rarity_text = Localize("loc_crafting_upgrade_rarity", no_cache, next_rarity_localization_context)

					self._widgets_by_name.upgrade_next_rarity_text.content.text = string.format("%s  %s", current_rarity_text, next_rarity_text)
					self._widgets_by_name.upgrade_item_button.content.visible = true
					self._widgets_by_name.upgrade_next_rarity_text.content.visible = true

					self:_can_afford(costs):next(function (cost_data)
						local afford_by_type = cost_data.afford_by_type
						local can_afford = cost_data.can_afford

						self:setup_prices_widget(costs, afford_by_type)

						self._widgets_by_name.upgrade_item_button.content.hotspot.disabled = not can_afford
					end)

					self._widgets_by_name.upgrade_item_button.content.hotspot.pressed_callback = function ()
						local gear_id = self._preview_item.gear_id

						self._crafting_promise = self._crafting_backend:upgrade_weapon_rarity(gear_id):next(function ()
							if self._weapon_equipped then
								ItemUtils.equip_item_in_slot(self._weapon_slot, self._preview_item)
							end

							local notification_string = Localize("loc_crafting_upgrade_success")

							Managers.event:trigger("event_add_notification_message", "default", notification_string)
							Managers.event:trigger("event_vendor_view_purchased_item")
							self:_fetch_inventory():next(function ()
								if self._destroyed then
									return
								end

								self:_on_panel_option_pressed(index)

								self._crafting_promise = nil
							end)
						end):catch(function (error)
							local notification_string = Localize("loc_crafting_failure")

							Managers.event:trigger("event_add_notification_message", "alert", {
								text = notification_string
							})
							self:_on_panel_option_pressed(index)

							self._crafting_promise = nil
						end)
					end
				end
			end

			self._widgets_by_name.modify_title.content.text = Localize("loc_crafting_upgrade_title")
			self._widgets_by_name.modify_text.content.text = Localize("loc_crafting_upgrade_description")
			self._widgets_by_name.modify_title.content.visible = true
			self._widgets_by_name.modify_text.content.visible = true
		elseif options_type == "replace" then
			local traits = {}
			local num_traits = #self._weapon_traits
			local scenegraph_name = "modify_pivot"
			local template = ContentBlueprints.trait

			if num_traits == 0 then
				self._widgets_by_name.upgrade_unavailable_text.content.text = Localize("loc_crafting_replace_locked")
				self._widgets_by_name.upgrade_unavailable_text.content.visible = true
			else
				for i = 1, num_traits do
					local trait = self._weapon_traits[i]
					local trait_definition = UIWidget.create_definition(template.pass_template, scenegraph_name, nil, template.size)
					local name = "trait_" .. i
					local widget = self:_create_widget(name, trait_definition)
					local widget_data = {
						interactable = true,
						trait = trait,
						wallet_type = self._wallet_type
					}

					local function callback()
						self:_select_trait_modify(widget)
					end

					template.init(self, widget, widget_data, i, callback)

					traits[#traits + 1] = {
						widget = widget,
						widget_data = widget_data
					}
				end

				self._traits = traits

				self:_set_scenegraph_size(scenegraph_name, template.size[1] * num_traits, template.size[2])
			end

			self._widgets_by_name.modify_title.content.text = Localize("loc_crafting_replace_title")
			self._widgets_by_name.modify_text.content.text = Localize("loc_crafting_replace_description")
			self._widgets_by_name.modify_title.content.visible = true
			self._widgets_by_name.modify_text.content.visible = true
		elseif options_type == "extract" then
			if self._weapon_equipped == true then
				self._widgets_by_name.upgrade_unavailable_text.content.text = Localize("loc_crafting_extract_equipped")
				self._widgets_by_name.upgrade_unavailable_text.content.visible = true
			elseif #self._weapon_traits == 0 then
				self._widgets_by_name.upgrade_unavailable_text.content.text = Localize("loc_crafting_extract_locked")
				self._widgets_by_name.upgrade_unavailable_text.content.visible = true
			else
				local num_traits = #self._weapon_traits
				local scenegraph_name = "modify_pivot"
				local template = ContentBlueprints.trait
				local widgets_promise = {}

				for i = 1, num_traits do
					local trait = self._weapon_traits[i]
					local costs = self._costs.extractTrait[tostring(trait.rarity)]

					widgets_promise[#widgets_promise + 1] = self:_can_afford(costs)
				end

				Promise.all(unpack(widgets_promise)):next(function (costs)
					local traits = {}

					for i = 1, #costs do
						local cost = costs[i]
						local can_afford = cost.can_afford
						local trait = self._weapon_traits[i]
						local operation_cost = self._costs.extractTrait[tostring(trait.rarity)]
						local trait_definition = UIWidget.create_definition(template.pass_template, scenegraph_name, nil, template.size)
						local name = "trait_" .. i
						local widget = self:_create_widget(name, trait_definition)
						local widget_data = {
							interactable = true,
							costs = operation_cost or nil,
							cost_data = cost,
							trait = trait,
							wallet_type = self._wallet_type
						}

						template.init(self, widget, widget_data, i)

						local avaialable = can_afford

						widget.content.hotspot.pressed_callback = function ()
							if avaialable then
								self:_select_trait_extract(widget)
							end
						end

						traits[#traits + 1] = {
							widget = widget,
							widget_data = widget_data
						}
					end

					self._traits = traits

					self:_set_scenegraph_size(scenegraph_name, template.size[1] * num_traits, template.size[2])
				end)
			end

			self._widgets_by_name.modify_title.content.text = Localize("loc_crafting_extract_title")
			self._widgets_by_name.modify_text.content.text = Localize("loc_crafting_extract_description")
			self._widgets_by_name.modify_title.content.visible = true
			self._widgets_by_name.modify_text.content.visible = true
		end
	end)
end

CraftingModifyOptionsView.setup_prices_widget = function (self, costs, afford_by_type)
	local price_widget_definition = Definitions.price_definition
	local widgets = {}

	if self._price_widgets then
		for i = 1, #self._price_widgets do
			local widget = self._price_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._price_widgets = nil
	end

	local previous_width = 0
	local scenegraph_name = "action_cost"
	local currency_order = {
		"diamantine",
		"plasteel"
	}
	local ordered_currency = {}
	local currency = {}

	for i = 1, #costs do
		local replace_cost = costs[i]
		local price = replace_cost.amount

		if price and price > 0 then
			currency[#currency + 1] = replace_cost
		end
	end

	for i = 1, #currency_order do
		for f = 1, #currency do
			if currency_order[i] == currency[f].type then
				ordered_currency[#ordered_currency + 1] = currency[f]
			end
		end
	end

	for i = 1, #ordered_currency do
		local upgrade_cost = ordered_currency[i]
		local price = upgrade_cost.amount
		local currency_name = upgrade_cost.type
		local can_afford = afford_by_type[currency_name]
		local name = "price_" .. currency_name
		local definition = UIWidget.create_definition(price_widget_definition, scenegraph_name)
		local widget = self:_create_widget(name, definition)
		local wallet_settings = WalletSettings[currency_name]
		local font_gradient_material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
		local icon_texture_big = wallet_settings.icon_texture_small
		local text = tostring(price)

		widget.style.text.material = font_gradient_material
		widget.content.texture = icon_texture_big
		widget.content.text = text

		local text_style = widget.style.text
		local text_width, _ = self:_text_size(text, text_style.font_type, text_style.font_size)
		local texture_width = widget.style.texture.size[1]
		local text_offset = widget.style.text.offset
		local texture_offset = widget.style.texture.offset
		local text_margin = 5
		local price_margin = i < #ordered_currency and 30 or 0

		texture_offset[1] = texture_offset[1] + previous_width
		text_offset[1] = text_offset[1] + text_margin + texture_width + previous_width
		previous_width = text_width + texture_width + text_margin + previous_width + price_margin
		widgets[#widgets + 1] = widget
	end

	self:_set_scenegraph_size(scenegraph_name, previous_width, nil)

	self._price_widgets = widgets
end

CraftingModifyOptionsView._can_afford = function (self, costs)
	local afford_by_type = {}
	local can_afford = true
	local wallets = self._wallet

	for i = 1, #costs do
		local cost = costs[i]
		local type = cost.type
		local amount = cost.amount
		local wallet_amount = wallets[type]

		afford_by_type[type] = amount <= wallet_amount

		if can_afford == true then
			can_afford = afford_by_type[type]
		end
	end

	return Promise.resolved({
		can_afford = can_afford,
		afford_by_type = afford_by_type
	})
end

CraftingModifyOptionsView._remove_traits_widgets = function (self)
	if self._traits then
		for i = 1, #self._traits do
			local widget = self._traits[i].widget

			self:_unregister_widget_name(widget.name)
		end

		self._traits = nil
	end
end

CraftingModifyOptionsView._reset_state = function (self)
	self:_remove_traits_widgets()

	if self._price_widgets then
		for i = 1, #self._price_widgets do
			local widget = self._price_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._price_widgets = nil
	end

	if self._inventory_traits_grid then
		local reference_name = "inventory_traits_grid"

		self:_remove_element(reference_name)

		self._inventory_traits_grid = nil
	end

	if self._tab_menu_element then
		local reference_name = "traits_tab_menu"

		self:_remove_element(reference_name)

		self._tab_menu_element = nil
	end

	self._widgets_by_name.upgrade_unavailable_text.content.visible = false
	self._widgets_by_name.upgrade_next_rarity_text.content.visible = false
	self._widgets_by_name.modify_title.content.visible = false
	self._widgets_by_name.modify_text.content.visible = false
	self._widgets_by_name.modify_arrow_widget.content.visible = false
	self._widgets_by_name.upgrade_item_button.content.visible = false
	self._widgets_by_name.extract_trait_button.content.visible = false
	self._widgets_by_name.modify_divider.content.visible = false
	self._widgets_by_name.modify_divider_glow.content.visible = false
	self._widgets_by_name.modify_display_name.content.visible = false
	self._widgets_by_name.modify_sub_display_name.content.visible = false

	self._weapon_preview:stop_presenting()
end

CraftingModifyOptionsView._remove_trait_tooltip = function (self)
	if self._tooltip_widget then
		local widget = self._tooltip_widget

		self:_unregister_widget_name(widget.name)

		self._tooltip_widget = nil
	end
end

CraftingModifyOptionsView._set_trait_tooltip = function (self, trait_info, direction)
	self:_remove_trait_tooltip()

	local scenegraph_name = "trait_tooltip"
	local template = ContentBlueprints.tooltip
	local widget_data = trait_info.widget_data
	local size = template.size_function and template.size_function(self, widget_data) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, widget_data) or template.pass_template
	local optional_style = template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_name, nil, size, optional_style)
	local name = scenegraph_name
	local widget = self:_create_widget(name, widget_definition)

	template.init(self, widget, widget_data, self._ui_renderer)
	self:_set_scenegraph_size(scenegraph_name, nil, widget.content.size[2])

	self._tooltip_widget = widget

	self:_set_tooltip_position(trait_info.widget, direction)
end

CraftingModifyOptionsView._set_tooltip_position = function (self, parent_widget, direction)
	local margin_value = 15
	local margin_horizontal = 0
	local margin_vertical = 0
	local scenegraph_id = "trait_tooltip"
	local parent_widget_offset = parent_widget.offset or {
		0,
		0,
		0
	}
	local parent_scenegraph_id = parent_widget.scenegraph_id
	local parent_scenegraph_position = self:_scenegraph_world_position(parent_scenegraph_id)
	local parent_scenegraph_width, parent_scenegraph_height = self:_scenegraph_size(parent_scenegraph_id)
	local parent_scenegraph_size = parent_widget.content.size

	if direction == "down" then
		self._ui_scenegraph[scenegraph_id].horizontal_alignment = "center"
		self._ui_scenegraph[scenegraph_id].vertical_alignment = "top"
		margin_vertical = margin_value

		local pivot_x = parent_scenegraph_position[1] + parent_widget_offset[1] + parent_scenegraph_size[1] * 0.5
		local pivot_y = parent_scenegraph_position[2] + parent_scenegraph_size[2] + parent_widget_offset[2] + margin_vertical

		self:_set_scenegraph_position("trait_tooltip_pivot", pivot_x, pivot_y)
	elseif direction == "up" then
		self._ui_scenegraph[scenegraph_id].horizontal_alignment = "center"
		self._ui_scenegraph[scenegraph_id].vertical_alignment = "bottom"
		margin_vertical = margin_value

		local pivot_x = parent_scenegraph_position[1] + parent_widget_offset[1] + parent_scenegraph_size[1] * 0.5
		local pivot_y = parent_scenegraph_position[2] + parent_widget_offset[2] - margin_vertical

		self:_set_scenegraph_position("trait_tooltip_pivot", pivot_x, pivot_y)
	elseif direction == "right" then
		self._ui_scenegraph[scenegraph_id].horizontal_alignment = "left"
		self._ui_scenegraph[scenegraph_id].vertical_alignment = "center"
		margin_horizontal = margin_value

		local pivot_x = parent_scenegraph_position[1] + parent_widget_offset[1] + parent_scenegraph_size[1] + margin_horizontal
		local pivot_y = parent_scenegraph_position[2] + parent_widget_offset[2] + parent_scenegraph_size[2] * 0.5

		self:_set_scenegraph_position("trait_tooltip_pivot", pivot_x, pivot_y)
	elseif direction == "left" then
		self._ui_scenegraph[scenegraph_id].horizontal_alignment = "right"
		self._ui_scenegraph[scenegraph_id].vertical_alignment = "center"
		margin_horizontal = margin_value

		local pivot_x = parent_scenegraph_position[1] + parent_widget_offset[1] - margin_horizontal
		local pivot_y = parent_scenegraph_position[2] + parent_widget_offset[2] + parent_scenegraph_size[2] * 0.5

		self:_set_scenegraph_position("trait_tooltip_pivot", pivot_x, pivot_y)
	end

	UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)
end

CraftingModifyOptionsView._select_trait_extract = function (self, selected_widget)
	self:_remove_selected_widget()
	self:_remove_traits_widgets()

	local scenegraph_name = "selected_trait"
	local target_scenegraph = "extract_trait_pivot"
	local target_pos_x, target_pos_y = self:_scenegraph_position(target_scenegraph)

	self._ui_scenegraph[scenegraph_name].horizontal_alignment = self._ui_scenegraph[target_scenegraph].horizontal_alignment
	self._ui_scenegraph[scenegraph_name].vertical_alignment = self._ui_scenegraph[target_scenegraph].vertical_alignment

	self:_set_scenegraph_position(scenegraph_name, target_pos_x, target_pos_y)
	UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)

	local template = ContentBlueprints.trait
	local trait_definition = UIWidget.create_definition(template.pass_template, scenegraph_name, nil, template.size)
	local name = scenegraph_name
	local widget = self:_create_widget(name, trait_definition)
	local trait = selected_widget.content.trait
	local widget_data = {
		interactable = false,
		trait = trait,
		wallet_type = self._wallet_type
	}

	template.init(self, widget, widget_data)

	self._selected_trait = {
		widget = widget,
		widget_data = widget_data
	}

	self:_set_trait_tooltip(self._selected_trait, "down")

	self._widgets_by_name.extract_trait_button.content.visible = true
	self._widgets_by_name.modify_title.content.visible = false
	self._widgets_by_name.modify_text.content.visible = false
	self._widgets_by_name.modify_divider.content.visible = false
	self._widgets_by_name.modify_divider_glow.content.visible = false
	self._widgets_by_name.modify_display_name.content.visible = false
	self._widgets_by_name.modify_sub_display_name.content.visible = false

	self._weapon_preview:stop_presenting()

	self._widgets_by_name.extract_trait_button.content.hotspot.pressed_callback = function ()
		local context = {
			title_text = "loc_popup_header_destroy_weapon",
			description_text = "loc_popup_description_destroy_weapon",
			type = "warning",
			options = {
				{
					text = "loc_popup_button_destroy_weapon",
					close_on_pressed = true,
					callback = callback(function ()
						local gear_id = self._preview_item.gear_id

						self._crafting_promise = self._crafting_backend:extract_trait_from_weapon(gear_id, trait.trait_index):next(function ()
							if self._destroyed then
								return
							end

							local trait_item = MasterItems.get_item(trait.trait_id)

							Managers.event:trigger("event_add_notification_message", "item_granted", trait_item)
							Managers.event:trigger("event_vendor_view_purchased_item")
							self:on_back_pressed(true)

							self._crafting_promise = nil
						end):catch(function (error)
							local notification_string = Localize("loc_crafting_failure")

							Managers.event:trigger("event_add_notification_message", "alert", {
								text = notification_string
							})
							self:on_back_pressed()

							self._crafting_promise = nil
						end)
					end)
				},
				{
					text = "loc_popup_button_cancel_destroy_weapon",
					template_type = "terminal_button_small",
					close_on_pressed = true,
					hotkey = "back"
				}
			}
		}

		Managers.event:trigger("event_show_ui_popup", context)
	end
end

CraftingModifyOptionsView._select_trait_modify = function (self, selected_widget)
	self:_remove_selected_widget()
	self:_remove_traits_widgets()

	local scenegraph_name = "selected_trait"
	local target_scenegraph = "replace_trait_pivot"

	if not self._inventory_traits_grid then
		local context = Definitions.grid_settings
		local reference_name = "inventory_traits_grid"
		local layer = 10

		self._inventory_traits_grid = self:_add_element(ViewElementGrid, reference_name, layer, context)
	end

	self._ui_scenegraph.inventory_traits_grid.horizontal_alignment = "left"
	self._ui_scenegraph.inventory_traits_grid.vertical_alignment = "bottom"

	self:_set_scenegraph_position("inventory_traits_grid", 960, -120)

	self._ui_scenegraph[scenegraph_name].vertical_alignment = self._ui_scenegraph[target_scenegraph].vertical_alignment
	self._ui_scenegraph[scenegraph_name].horizontal_alignment = self._ui_scenegraph[target_scenegraph].horizontal_alignment

	local target_pos_x, target_pos_y = self:_scenegraph_position(target_scenegraph)

	self:_set_scenegraph_position(scenegraph_name, target_pos_x, target_pos_y)
	UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)

	local template = ContentBlueprints.trait
	local trait_definition = UIWidget.create_definition(template.pass_template, scenegraph_name, nil, template.size)
	local name = scenegraph_name
	local widget = self:_create_widget(name, trait_definition)
	local trait = selected_widget.content.trait
	local widget_data = {
		interactable = false,
		trait = trait,
		wallet_type = self._wallet_type
	}

	template.init(self, widget, widget_data)

	self._selected_trait = {
		widget = widget,
		widget_data = widget_data
	}

	self:_set_trait_tooltip(self._selected_trait, "left")

	self._widgets_by_name.modify_arrow_widget.content.visible = true
	self._widgets_by_name.modify_title.content.visible = false
	self._widgets_by_name.modify_text.content.visible = false
	self._widgets_by_name.modify_divider.content.visible = false
	self._widgets_by_name.modify_divider_glow.content.visible = false
	self._widgets_by_name.modify_display_name.content.visible = false
	self._widgets_by_name.modify_sub_display_name.content.visible = false

	self._weapon_preview:stop_presenting()
	self:_update_item_grid_position()
	self:_setup_trait_tabs()
	self:cb_switch_trait_tab(1)
end

CraftingModifyOptionsView._remove_selected_widget = function (self)
	if self._selected_trait then
		local widget = self._selected_trait.widget

		self:_unregister_widget_name(widget.name)

		self._selected_trait = nil
	end
end

CraftingModifyOptionsView._update_item_grid_position = function (self)
	if not self._inventory_traits_grid then
		return
	end

	local position = self:_scenegraph_world_position("inventory_traits_grid_pivot")

	self._inventory_traits_grid:set_pivot_offset(position[1], position[2])
end

CraftingModifyOptionsView._generate_weapon_traits = function (self)
	local traits = {}
	local current_traits = self._preview_item.traits

	if current_traits then
		for i = 1, #current_traits do
			local trait = current_traits[i]

			if trait then
				local trait_id = trait.id
				local trait_exists = MasterItems.item_exists(trait_id)

				if trait_exists then
					local trait_item = MasterItems.get_item(trait_id)

					traits[#traits + 1] = {
						rarity = trait.rarity,
						trait_categories = trait_item.weapon_type_restriction,
						name = trait_item.display_name and Localize(trait_item.display_name) or "",
						description = trait_item.description and Localize(trait_item.description) or "",
						icon = trait_item.icon,
						trait_category = trait_item.weapon_type_restriction[1],
						trait_id = trait_id,
						trait_index = #traits + 1
					}
				end
			end
		end
	end

	return traits
end

CraftingModifyOptionsView._setup_trait_tabs = function (self)
	local id = "traits_tab_menu"
	local layer = 1
	local tab_menu_settings = {
		fixed_button_size = true,
		horizontal_alignment = "center",
		button_spacing = 20,
		button_size = {
			100,
			50
		}
	}
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)

	self._tab_menu_element = tab_menu_element

	local input_action_left = "navigate_primary_left_pressed"
	local input_action_right = "navigate_primary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)

	local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button)

	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
	}

	local tab_ids = {}

	for i = 1, 4 do
		local pressed_callback = callback(self, "cb_switch_trait_tab", i)
		local name = TextUtilities.convert_to_roman_numerals(i)
		local tab_id = tab_menu_element:add_entry(name, pressed_callback, tab_button_template, nil, nil, true)

		tab_ids[i] = tab_id
	end

	tab_menu_element:set_is_handling_navigation_input(true)

	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

CraftingModifyOptionsView._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("inventory_traits_tab_pivot")

	self._tab_menu_element:set_pivot_offset(position[1], position[2])
end

CraftingModifyOptionsView.cb_switch_trait_tab = function (self, index)
	self._tab_menu_element:set_selected_index(index)
	self:_present_layout_by_trait_rarity(index)

	self._current_select_grid_index = nil
	self._tab_index = index
end

CraftingModifyOptionsView._present_layout_by_trait_rarity = function (self, trait_rarity)
	local traits = {}
	local slot_category = self._selected_trait.widget_data.trait.slot_category
	local selected_slot_rarity = self._selected_trait.widget_data.trait.rarity
	local selected_trait_id = self._selected_trait.widget_data.trait.trait_id
	local costs = self._costs.replaceTrait[tostring(trait_rarity)]
	local wallet_promise = {}

	for i = 1, #self._inventory_traits do
		local trait = self._inventory_traits[i]

		if trait.rarity == trait_rarity then
			local already_available = false

			for h = 1, #self._weapon_traits do
				local weapon_trait = self._weapon_traits[h]

				if selected_trait_id ~= weapon_trait.trait_id and weapon_trait.trait_id == trait.trait_id or selected_trait_id == trait.trait_id and trait_rarity <= selected_slot_rarity then
					already_available = true

					break
				end
			end

			if trait.rarity == trait_rarity and not trait.selected then
				local found = false

				for g = 1, #traits do
					local trait_check_counter = traits[g]

					if trait_check_counter.trait.trait_id == trait.trait_id then
						trait_check_counter.count = trait_check_counter.count + 1
						found = true

						break
					end
				end

				if found == false then
					traits[#traits + 1] = {
						count = 1,
						widget_type = "trait_list",
						trait = trait,
						disabled = already_available or selected_slot_rarity < trait_rarity or slot_category ~= trait.trait_category,
						costs = costs,
						wallet_type = self._wallet_type
					}
					wallet_promise[#wallet_promise + 1] = self:_can_afford(costs)
				end
			end
		end
	end

	Promise.all(unpack(wallet_promise)):next(function (cost_data)
		for i = 1, #cost_data do
			local trait = traits[i]

			trait.cost_data = cost_data[i]
		end

		local grid_display_name = "loc_crafting_available_traits"
		local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")

		self._inventory_traits_grid:present_grid_layout(traits, ContentBlueprints, left_click_callback, nil, grid_display_name)
	end)
end

CraftingModifyOptionsView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if element.disabled then
		return
	end

	local costs = self._costs.replaceTrait[tostring(element.rarity)]
	local gear_id = self._preview_item.gear_id
	local existing_trait_index = self._selected_trait.widget_data.trait.trait_index
	local new_trait_id = widget.content.trait.item_id
	local can_afford = widget.content.cost_data.can_afford

	if widget.content.hotspot.is_focused == true and not widget.content.hotspot.disabled and can_afford then
		self._crafting_promise = self._crafting_backend:replace_trait_in_weapon(gear_id, existing_trait_index, new_trait_id):next(function ()
			if self._weapon_equipped then
				ItemUtils.equip_item_in_slot(self._weapon_slot, self._preview_item)
			end

			local notification_string = Localize("loc_crafting_replace_success")

			Managers.event:trigger("event_add_notification_message", "default", notification_string)
			Managers.event:trigger("event_vendor_view_purchased_item")
			self:_fetch_inventory():next(function ()
				self:on_back_pressed()

				self._crafting_promise = nil
			end)
		end):catch(function (error)
			local notification_string = Localize("loc_crafting_failure")

			Managers.event:trigger("event_add_notification_message", "alert", {
				text = notification_string
			})
			self:on_back_pressed()

			self._crafting_promise = nil
		end)
	end
end

CraftingModifyOptionsView._destroy_weapon_preview = function (self)
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

CraftingModifyOptionsView._set_preview_widgets_visibility = function (self, visible)
	CraftingModifyOptionsView.super._set_preview_widgets_visibility(self, visible)
end

CraftingModifyOptionsView.update = function (self, dt, t, input_service)
	local show_loading = not not self._wallet_promise or not not self._crafting_promise

	if self._loading_view ~= show_loading then
		self._loading_view = show_loading

		if self._loading_view == true then
			self:_reset_state()
		end

		self._widgets_by_name.loading_info.content.visible = self._loading_view
	end

	self._current_progress = self._current_progress or 0

	Definitions.modify_arrow_animation.update(self, dt, self._current_progress)

	self._current_progress = self._current_progress + dt

	local wanted_tab_index = self._wanted_tab_index

	if self._selected_tab_index ~= wanted_tab_index and not show_loading then
		self._selected_tab_index = wanted_tab_index

		self:_on_panel_option_pressed(wanted_tab_index)
	end

	if self._pressed_back then
		if self._selected_trait and self._should_force_close ~= true then
			self:_remove_trait_tooltip()
			self:_on_panel_option_pressed(wanted_tab_index)
		else
			Managers.ui:close_view(self.view_name)
		end

		self._pressed_back = nil
		self._should_force_close = nil
	end

	return CraftingModifyOptionsView.super.update(self, dt, t, input_service)
end

CraftingModifyOptionsView.on_back_pressed = function (self, force_close)
	self._pressed_back = true
	self._should_force_close = force_close == true or false

	return true
end

CraftingModifyOptionsView.on_exit = function (self)
	CraftingModifyOptionsView.super.on_exit(self)

	if self._weapon_preview then
		self:_destroy_weapon_preview()
	end

	if self._wallet_promise then
		self._wallet_promise:cancel()
	end

	if self._crafting_promise then
		self._crafting_promise:cancel()
	end

	self._parent:go_to_crafting_view("select_item", self._preview_item)
end

CraftingModifyOptionsView.draw = function (self, dt, t, input_service, layer)
	local render_settings = self._render_settings
	local ui_renderer = self._ui_default_renderer
	local ui_scenegraph = self._ui_scenegraph
	local render_scale = self._render_scale

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local price_widgets = self._price_widgets
	local traits = self._traits
	local selected_trait = self._selected_trait
	local tooltip_widget = self._tooltip_widget
	local focused_trait

	CraftingModifyOptionsView.super._draw_elements(self, dt, t, ui_renderer, render_settings, input_service)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	CraftingModifyOptionsView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	if price_widgets then
		for i = 1, #price_widgets do
			local widget = price_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if traits then
		for i = 1, #traits do
			local widget = traits[i].widget

			UIWidget.draw(widget, ui_renderer)

			local content = widget.content

			if content.hotspot.is_hover or content.hotspot.is_focused then
				focused_trait = i
			end
		end
	end

	if selected_trait then
		local widget = selected_trait.widget

		UIWidget.draw(widget, ui_renderer)
	end

	if tooltip_widget then
		local widget = tooltip_widget

		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)

	if not self._selected_trait and focused_trait ~= self._focused_trait then
		self._focused_trait = focused_trait

		local index = self._wanted_tab_index
		local options_type = crafting_options[index].type

		if focused_trait then
			for i = 1, #traits do
				local widget = traits[i].widget
				local content = widget.content
				local is_trait_focused = i == focused_trait

				if options_type == "extract" then
					content.removed = not is_trait_focused
				end

				content.dim = not is_trait_focused
			end

			self:_set_trait_tooltip(traits[focused_trait], "up")
		elseif traits then
			for i = 1, #traits do
				local widget = traits[i].widget
				local content = widget.content

				if options_type == "extract" then
					content.removed = false
				end

				content.dim = false
			end

			self:_remove_trait_tooltip()
		else
			self:_remove_trait_tooltip()
		end
	end
end

CraftingModifyOptionsView._on_navigation_input_changed = function (self)
	CraftingModifyOptionsView.super._on_navigation_input_changed(self)
end

CraftingModifyOptionsView._handle_input = function (self, input_service)
	local selected_trait = self._selected_trait
	local is_mouse = self._using_cursor_navigation

	if not is_mouse then
		local traits = self._traits

		if traits and not self._focused_trait then
			traits[1].widget.content.hotspot.is_focused = true
		elseif traits and not selected_trait then
			local total_traits = #traits
			local current_index = self._focused_trait

			if input_service:get("navigate_right_continuous") and current_index < total_traits then
				traits[current_index].widget.content.hotspot.is_focused = false
				traits[current_index + 1].widget.content.hotspot.is_focused = true
			end

			if input_service:get("navigate_left_continuous") and current_index > 1 then
				traits[current_index].widget.content.hotspot.is_focused = false
				traits[current_index - 1].widget.content.hotspot.is_focused = true
			end
		end

		local upgrade_button_content = self._widgets_by_name.upgrade_item_button.content
		local extract_button_content = self._widgets_by_name.extract_trait_button.content
		local is_upgrade_available = upgrade_button_content.visible and not upgrade_button_content.hotspot.disabled
		local is_extract_avaialble = extract_button_content.visible and not extract_button_content.hotspot.disabled

		if is_upgrade_available ~= upgrade_button_content.hotspot.is_focused then
			upgrade_button_content.hotspot.is_focused = is_upgrade_available
		end

		if is_extract_avaialble ~= extract_button_content.hotspot.is_focused then
			extract_button_content.hotspot.is_focused = is_extract_avaialble
		end
	end

	if self._inventory_traits_grid then
		local grid = self._inventory_traits_grid
		local widgets = self._inventory_traits_grid:widgets()

		if not grid:selected_grid_index() and not is_mouse then
			grid:select_grid_index(1)
		elseif is_mouse then
			local found = false

			for i = 1, #widgets do
				local widget = widgets[i]

				if widget.content.hotspot.is_hover == true then
					found = true

					grid:select_grid_index(i)

					break
				end
			end

			if found == false then
				grid:select_grid_index(nil)
			end
		end

		local selected_index = grid:selected_grid_index()
		local current_index = self._current_select_grid_index

		if selected_index ~= current_index then
			local unfocused_widget = current_index and widgets[current_index]
			local focused_widget = selected_index and widgets[selected_index]
			local widgets_changed = {
				unfocused_widget,
				focused_widget
			}

			if unfocused_widget then
				unfocused_widget.content.hotspot.is_focused = false
			end

			if focused_widget then
				focused_widget.content.hotspot.is_focused = true
			end

			for i = 1, #widgets_changed do
				local widget = widgets_changed[i]

				if widget then
					local widget_type = widget.type
					local template = ContentBlueprints[widget_type]
					local update_size = template and template.update_size

					if update_size then
						update_size(self._inventory_traits_grid, widget)
					end
				end
			end

			self._current_select_grid_index = selected_index

			self._inventory_traits_grid:force_update_list_size()
		end
	end
end

CraftingModifyOptionsView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingModifyOptionsView
