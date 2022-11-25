local Definitions = require("scripts/ui/views/crafting_fuse_view/crafting_fuse_view_definitions")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local ContentBlueprints = require("scripts/ui/views/crafting_fuse_view/crafting_fuse_view_blueprints")
local MasterItems = require("scripts/backend/master_items")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local WalletSettings = require("scripts/settings/wallet_settings")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local CraftingFuseView = class("CraftingFuseView", "BaseView")

CraftingFuseView.init = function (self, settings, context)
	self._crafting_backend = Managers.backend.interfaces.crafting
	self._parent = context and context.parent

	CraftingFuseView.super.init(self, Definitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
end

CraftingFuseView.on_enter = function (self)
	CraftingFuseView.super.on_enter(self)

	self._trait_slots = {
		{},
		{},
		{}
	}
	self._can_fuse = false

	self._parent:set_active_view_instance(self)

	self._crafting_promise = self._crafting_backend:get_crafting_costs():next(function (costs)
		if self._destroyed then
			return
		end

		self._costs = costs

		self:_fetch_inventory_traits():next(function ()
			if self._destroyed then
				return
			end

			self._crafting_promise = nil
		end)
	end):catch(function (error)
		self._crafting_promise = nil
	end)

	self:_generate_arrows()
	self:_register_button_callbacks()
end

CraftingFuseView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local fuse_item_button = widgets_by_name.fuse_item_button
	fuse_item_button.content.hotspot.pressed_callback = callback(self, "_fuse_action")
end

CraftingFuseView._generate_arrows = function (self)
	local template_type = "arrow"
	local template = ContentBlueprints[template_type]
	local arrows_start_scenegraphs = {
		"fuse_1",
		"fuse_2",
		"fuse_3"
	}
	local arrows_end_scenegraph = "fuse_end"
	local widgets = {}

	for i = 1, #arrows_start_scenegraphs do
		local start_scenegraph = arrows_start_scenegraphs[i]
		local arrow_element = {
			amount = 4,
			start = start_scenegraph,
			finish = arrows_end_scenegraph,
			type = template_type
		}
		local size = template.size_function and template.size_function() or template.size
		local pass_template_function = template.pass_template_function
		local pass_template = pass_template_function and pass_template_function(self, arrow_element) or template.pass_template
		local optional_style = template.style
		local widget_definition = pass_template and UIWidget.create_definition(pass_template, start_scenegraph, nil, size, optional_style)
		local name = "fuse_arrow_" .. i
		local widget = self:_create_widget(name, widget_definition)

		template.init(self, widget, arrow_element, self._ui_renderer)

		widgets[#widgets + 1] = widget
	end

	self._arrows_widgets = widgets
end

CraftingFuseView.can_exit = function (self)
	return self._can_exit
end

CraftingFuseView.on_back_pressed = function (self, force_close)
	self._pressed_back = true
	self._should_force_close = force_close == true or false

	return true
end

CraftingFuseView._fetch_inventory_traits = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()

	return Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		local traits = {}

		for item_id, item in pairs(items) do
			if item.item_type == "TRAIT" then
				local trait_name = item.name
				local trait_exists = MasterItems.item_exists(trait_name)

				if trait_exists then
					local trait_item = MasterItems.get_item(trait_name)
					traits[#traits + 1] = {
						hovered = false,
						rarity = item.rarity,
						trait_categories = trait_item.weapon_type_restriction,
						name = trait_item.display_name and Localize(trait_item.display_name) or "",
						description = trait_item.description and Localize(trait_item.description) or "",
						icon = trait_item.icon,
						item_id = item.gear_id,
						trait_id = trait_item.name
					}
				end
			end
		end

		self._inventory_traits = traits
	end):catch(function (error)
		return
	end)
end

CraftingFuseView.update = function (self, dt, t, input_service)
	local show_loading = not not self._crafting_promise

	if self._loading_view ~= show_loading then
		self._loading_view = show_loading
		self._widgets_by_name.fuse_description.content.visible = not self._loading_view
		self._widgets_by_name.fuse_tiers.content.visible = not self._loading_view
		self._widgets_by_name.fuse_item_button.content.visible = not self._loading_view
		self._widgets_by_name.fuse_background.content.visible = not self._loading_view
		self._widgets_by_name.fuse_1.content.visible = not self._loading_view
		self._widgets_by_name.fuse_2.content.visible = not self._loading_view
		self._widgets_by_name.fuse_3.content.visible = not self._loading_view
		self._widgets_by_name.fuse_end.content.visible = not self._loading_view
		self._widgets_by_name.loading_info.content.visible = self._loading_view

		if self._arrows_widgets then
			for i = 1, #self._arrows_widgets do
				local widget = self._arrows_widgets[i]
				widget.content.visible = not self._loading_view
			end
		end
	end

	if (self._can_fuse == true or self._loading_view == true) and self._inventory_traits_grid and self._inventory_traits then
		self:_destroy_menu_tabs()
		self:_destroy_item_grid()
	elseif self._can_fuse == false and self._loading_view == false and self._inventory_traits and not self._inventory_traits_grid then
		self:_setup_item_grid()
		self:_setup_menu_tabs()
		self:cb_switch_tab(1)
	end

	local fuse_button_content = self._widgets_by_name.fuse_item_button.content

	if not self._can_fuse ~= fuse_button_content.hotspot.disabled then
		fuse_button_content.hotspot.disabled = not self._can_fuse
	end

	if self._pressed_back then
		if self._selected_trait and self._should_force_close ~= true then
			self:_remove_all_trait_from_fuse()
		else
			self._parent:set_active_view_instance(nil)
			self._parent:_handle_back_pressed()
		end

		self._pressed_back = nil
		self._should_force_close = nil
	end

	if self._upadte_grid_next_frame then
		self._upadte_grid_next_frame()

		self._upadte_grid_next_frame = nil
	end

	return CraftingFuseView.super.update(self, dt, t, input_service)
end

CraftingFuseView.draw = function (self, dt, t, input_service, layer)
	CraftingFuseView.super.draw(self, dt, t, input_service, layer)

	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local price_widgets = self._price_widgets
	local arrows_widgets = self._arrows_widgets
	local tooltip_widget = self._tooltip_widget
	local hovered_trait = nil

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if price_widgets then
		for i = 1, #price_widgets do
			local widget = price_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	self._current_progress = self._current_progress or 0

	if arrows_widgets then
		for i = 1, #arrows_widgets do
			local widget = arrows_widgets[i]

			UIWidget.draw(widget, ui_renderer)

			local template_type = widget.element.type
			local template = ContentBlueprints[template_type]

			template.update(self, widget, dt, self._current_progress)
		end
	end

	self._current_progress = self._current_progress + dt

	if tooltip_widget then
		local widget = tooltip_widget

		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)

	local available_slot = false

	for i = 1, #self._trait_slots do
		local trait_slot = self._trait_slots[i]

		if not table.is_empty(trait_slot) then
			local widget_name = "fuse_" .. i
			local widget = self._widgets_by_name[widget_name]

			if widget.content.hotspot.is_hover then
				hovered_trait = widget
			end
		elseif available_slot == false then
			available_slot = true
		end
	end

	if hovered_trait ~= self._hovered_trait then
		self._hovered_trait = hovered_trait

		if hovered_trait then
			self:_set_trait_tooltip(hovered_trait, "up")
		else
			self:_remove_trait_tooltip()
		end
	end

	if self._can_fuse == false and available_slot == false then
		self._can_fuse = true
	elseif self._can_fuse == true and available_slot == true then
		self._can_fuse = false
	end
end

CraftingFuseView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._crafting_promise then
		self._crafting_promise:cancel()
	end

	CraftingFuseView.super.on_exit(self)
end

CraftingFuseView._destroy_item_grid = function (self)
	if self._inventory_traits_grid then
		local reference_name = "item_grid"

		self:_remove_element(reference_name)

		self._inventory_traits_grid = nil
	end
end

CraftingFuseView._destroy_menu_tabs = function (self)
	local reference_name = "tab_menu"

	self:_remove_element(reference_name)

	self._tab_menu_element = nil
	self._tab_ids = nil
end

CraftingFuseView._setup_item_grid = function (self)
	if not self._inventory_traits_grid then
		local context = Definitions.grid_settings
		local reference_name = "item_grid"
		local layer = 10
		self._inventory_traits_grid = self:_add_element(ViewElementGrid, reference_name, layer, context)

		self:_update_item_grid_position()
	end
end

CraftingFuseView._update_item_grid_position = function (self)
	if not self._inventory_traits_grid then
		return
	end

	local position = self:_scenegraph_world_position("grid_content_pivot")

	self._inventory_traits_grid:set_pivot_offset(position[1], position[2])
end

CraftingFuseView._setup_menu_tabs = function (self)
	local id = "tab_menu"
	local layer = 10
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
	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)
	tab_menu_element:set_is_handling_navigation_input(true)

	local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button)
	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
	}
	local tab_ids = {}

	for i = 1, 4 do
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local name = TextUtilities.convert_to_roman_numerals(i)
		local tab_id = tab_menu_element:add_entry(name, pressed_callback, tab_button_template, nil, nil, true)
		tab_ids[i] = tab_id
	end

	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

CraftingFuseView.cb_switch_tab = function (self, index)
	if index ~= self._tab_index then
		self._current_select_grid_index = nil

		for i = 1, #self._inventory_traits do
			local trait = self._inventory_traits[i]
		end
	end

	self._tab_menu_element:set_selected_index(index)
	self:_present_layout_by_trait_level(index)

	self._tab_index = index
end

CraftingFuseView._present_layout_by_trait_level = function (self, trait_rarity)
	local traits = {}

	for i = 1, #self._inventory_traits do
		local trait = self._inventory_traits[i]
		local trait_in_use = false

		for g = 1, #self._trait_slots do
			local fuse_slot = self._trait_slots[g]

			if fuse_slot == trait then
				trait_in_use = true

				break
			end
		end

		if trait.rarity == trait_rarity and not trait_in_use then
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
					trait = trait
				}
			end
		end
	end

	local max_rarity = #RaritySettings

	for i = 1, #traits do
		local trait = traits[i]

		if trait.count < #self._trait_slots or trait.trait.rarity == max_rarity then
			trait.disabled = true
		end
	end

	local grid_display_name = "loc_crafting_available_traits"
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	self._upadte_grid_next_frame = callback(function ()
		if self._inventory_traits_grid then
			self._inventory_traits_grid:present_grid_layout(traits, ContentBlueprints, left_click_callback, nil, grid_display_name)
		end
	end)
end

CraftingFuseView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if element.disabled == true then
		return
	end

	local num_avaialable_slots = 0
	local next_available_slot = nil

	for i = 1, #self._trait_slots do
		local trait_slot = self._trait_slots[i]

		if table.is_empty(trait_slot) then
			num_avaialable_slots = num_avaialable_slots + 1
			next_available_slot = next_available_slot or i
		end
	end

	if widget.content.hotspot.is_selected == true then
		local traits_to_slots = {}

		for i = 1, #self._trait_slots do
			for f = 1, #self._inventory_traits do
				local trait = self._inventory_traits[f]
				local trait_in_use = false

				for g = 1, #traits_to_slots do
					local used_trait = traits_to_slots[g]

					if used_trait == trait then
						trait_in_use = true

						break
					end
				end

				if trait.rarity == element.trait.rarity and trait.trait_id == element.trait.trait_id and not trait_in_use then
					traits_to_slots[#traits_to_slots + 1] = trait

					break
				end
			end
		end

		self:_add_all_trait_to_fuse(traits_to_slots)
	else
		local index = self._tab_index

		self:_present_layout_by_trait_level(index)
	end
end

CraftingFuseView._add_all_trait_to_fuse = function (self, elements)
	for i = 1, #elements do
		local element = elements[i]
		local widget_name = "fuse_" .. i
		local widget = self._widgets_by_name[widget_name]
		local trait_rarity_color = RaritySettings[element.rarity].color
		widget.style.trait_used.material_values = {
			texture_category = "content/ui/textures/icons/traits/categories/default",
			texture_glow = "content/ui/textures/icons/traits/effects/default",
			texture_frame = "content/ui/textures/icons/traits/frames/slot_type_passive",
			texture_background = "content/ui/textures/icons/traits/frames/slot_type_passive_background",
			texture_effect = "content/ui/textures/icons/traits/effects/default",
			trait_rarity_color = trait_rarity_color
		}
		widget.content.trait = element
		self._trait_slots[i] = element

		widget.content.hotspot.pressed_callback = function ()
			self:_remove_all_trait_from_fuse()
		end
	end

	local end_fuse_widget = self._widgets_by_name.fuse_end
	local next_rarity = elements[1].rarity + 1
	local next_trait_rarity_color = RaritySettings[next_rarity].color
	end_fuse_widget.content.trait = elements[1]
	end_fuse_widget.content.interactable = false
	end_fuse_widget.style.trait_used.material_values = {
		texture_category = "content/ui/textures/icons/traits/categories/default",
		texture_glow = "content/ui/textures/icons/traits/effects/default",
		texture_frame = "content/ui/textures/icons/traits/frames/slot_type_passive",
		texture_background = "content/ui/textures/icons/traits/frames/slot_type_passive_background",
		texture_effect = "content/ui/textures/icons/traits/effects/default",
		trait_rarity_color = next_trait_rarity_color
	}
	self._selected_trait = true
	local tab_index = self._tab_index

	self:_present_layout_by_trait_level(tab_index)
end

CraftingFuseView._reset_state = function (self)
	for i = 1, #self._trait_slots do
		local trait_slot = self._trait_slots[i]
		local widget_name = "fuse_" .. i
		local widget = self._widgets_by_name[widget_name]
		widget.content.trait = nil
		self._trait_slots[i] = {}
		widget.content.hotspot.pressed_callback = nil
	end

	local end_fuse_widget = self._widgets_by_name.fuse_end
	end_fuse_widget.content.trait = nil
	self._selected_trait = false
end

CraftingFuseView._remove_all_trait_from_fuse = function (self)
	self:_reset_state()
end

CraftingFuseView._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("grid_tab_panel")

	self._tab_menu_element:set_pivot_offset(position[1], position[2])
end

CraftingFuseView._show_fuse_button = function (self)
	local costs = self._costs.fuseTraits

	if self._price_widgets then
		for i = 1, #self._price_widgets do
			local widget = self._price_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._price_widgets = nil
	end

	self._widgets_by_name.fuse_item_button.content.hotspot.disabled = false
	local price_widget_definition = Definitions.price_definition
	local widgets = {}
	local previous_width = 0

	for i = 1, #costs do
		local cost = costs[i]
		local currency_name = cost.type
		local price = cost.amount
		local name = "price_" .. currency_name
		local widget = self:_create_widget(name, price_widget_definition)
		local wallet_settings = WalletSettings[currency_name]
		local font_gradient_material = wallet_settings.font_gradient_material
		local icon_texture_big = wallet_settings.icon_texture_big
		local amount = price
		local text = tostring(amount)
		widget.style.text.material = font_gradient_material
		widget.content.texture = icon_texture_big
		widget.content.text = text
		local text_style = widget.style.text
		local text_width, _ = self:_text_size(text, text_style.font_type, text_style.font_size)
		local texture_width = widget.style.texture.size[1]
		local text_offset = widget.style.text.offset
		local texture_offset = widget.style.texture.offset
		local text_margin = 5
		local price_margin = i < #costs and 30 or 0
		texture_offset[1] = texture_offset[1] + previous_width
		text_offset[1] = text_offset[1] + text_margin + previous_width
		previous_width = text_width + texture_width + text_margin + previous_width + price_margin
		widgets[#widgets + 1] = widget
	end

	self._price_widgets = widgets
end

CraftingFuseView._fuse_action = function (self)
	self._widgets_by_name.fuse_item_button.content.disabled = true
	local traits_id = {}

	for i = 1, #self._trait_slots do
		local trait_slot = self._trait_slots[i]
		traits_id[#traits_id + 1] = trait_slot.item_id
	end

	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	self._crafting_promise = self._crafting_backend:fuse_traits(character_id, traits_id):next(function (response)
		if self._destroyed then
			return
		end

		self:_fetch_inventory_traits():next(function ()
			if self._destroyed then
				return
			end

			for i = 1, #self._inventory_traits do
				local trait = self._inventory_traits[i]

				if trait.item_id == response.traits[1].uuid then
					local trait_item = MasterItems.get_item(trait.trait_id)

					Managers.event:trigger("event_add_notification_message", "item_granted", trait_item)

					break
				end
			end

			self:_reset_state()

			self._crafting_promise = nil
		end)
	end):catch(function (error)
		local notification_string = Localize("loc_crafting_failure")

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = notification_string
		})

		self._crafting_promise = nil
	end)
end

CraftingFuseView._set_trait_tooltip = function (self, trait_widget, direction)
	self:_remove_trait_tooltip()

	local scenegraph_name = "trait_tooltip"
	local template = ContentBlueprints.tooltip
	local trait = trait_widget.content.trait
	local size = template.size_function and template.size_function(self, trait) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, trait) or template.pass_template
	local optional_style = template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_name, nil, size, optional_style)
	local name = scenegraph_name
	local widget = self:_create_widget(name, widget_definition)

	template.init(self, widget, trait, self._ui_renderer)
	self:_set_scenegraph_size(scenegraph_name, nil, widget.content.size[2])

	self._tooltip_widget = widget

	self:_set_tooltip_position(trait_widget, direction)
end

CraftingFuseView._set_tooltip_position = function (self, parent_widget, direction)
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

CraftingFuseView._remove_trait_tooltip = function (self)
	if self._tooltip_widget then
		local widget = self._tooltip_widget

		self:_unregister_widget_name(widget.name)

		self._tooltip_widget = nil
	end
end

CraftingFuseView._handle_input = function (self, input_service)
	local is_mouse = self._using_cursor_navigation
	local fuse_button_content = self._widgets_by_name.fuse_item_button.content

	if not is_mouse then
		local is_fuse_available = fuse_button_content.visible and not fuse_button_content.hotspot.disabled

		if is_fuse_available ~= fuse_button_content.hotspot.is_focused then
			fuse_button_content.hotspot.is_focused = is_fuse_available
		end
	end

	if self._inventory_traits_grid then
		local grid = self._inventory_traits_grid
		local widgets = self._inventory_traits_grid:widgets()

		if self._can_fuse and grid:selected_grid_index() and not is_mouse then
			grid:select_grid_index(nil)
		elseif not self._can_fuse and not grid:selected_grid_index() and not is_mouse and #widgets > 0 then
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

return CraftingFuseView
