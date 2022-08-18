local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local ContentBlueprints = require("scripts/ui/views/premium_vendor_view/premium_vendor_view_content_blueprints")
local Definitions = require("scripts/ui/views/premium_vendor_view/premium_vendor_view_definitions")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local PremiumVendorViewSettings = require("scripts/ui/views/premium_vendor_view/premium_vendor_view_settings")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local WalletSettings = require("scripts/settings/wallet_settings")
local DETAILS_VIEW_NAME = "inventory_weapon_details_view"
local PremiumVendorView = class("PremiumVendorView", "BaseView")

PremiumVendorView.init = function (self, settings, context)
	self._context = context
	self._stats_animation_progress = {}

	PremiumVendorView.super.init(self, Definitions, settings)

	self._pass_input = false
	self._pass_draw = true
end

PremiumVendorView.on_enter = function (self)
	PremiumVendorView.super.on_enter(self)

	self._current_balance = {}

	self:_setup_stats_preview_widgets()
	self:_setup_weapon_preview()
	self:_stop_previewing()

	self._item_definitions = MasterItems.get_cached()
	self._inventory_items = {}

	self:_display_title_text("loc_premium_vendor_view_title")
	self:_fetch_store_items()
	self:_setup_offscreen_gui()
	self:_setup_default_gui()
	self:_register_button_callbacks()
	self:_setup_input_legend()
	self:_update_wallets_presentation(nil)
	self:_update_wallets()
end

PremiumVendorView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

PremiumVendorView._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = "PremiumVendorView"
	local timer_name = "ui"
	local world_layer = 100
	local world_name = reference_name .. "_ui_default_world"
	local view_name = self.view_name
	self._gui_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = reference_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1
	self._gui_viewport = ui_manager:create_viewport(self._gui_world, viewport_name, viewport_type, viewport_layer)
	self._gui_viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(reference_name .. "_ui_default_renderer", self._gui_world)
end

PremiumVendorView._setup_stats_preview_widgets = function (self)
	local num_stats = 6
	local max_rows = 6
	local stats_size = PremiumVendorViewSettings.stats_size
	local widget_definition = UIWidget.create_definition(BarPassTemplates.weapon_stats_bar, "stat_pivot")
	local widgets = {}
	local spacing = PremiumVendorViewSettings.stats_spacing

	for i = 1, num_stats do
		local name = "stat_" .. i
		local widget = self:_create_widget(name, widget_definition)
		local column = (i - 1) % max_rows + 1
		local row = math.ceil(i / max_rows)
		local offset = widget.offset
		offset[2] = (column - 1) * stats_size[2] + (column - 1) * spacing
		offset[1] = (row - 1) * stats_size[1]
		widgets[#widgets + 1] = widget
	end

	self._stat_widgets = widgets
end

PremiumVendorView._setup_item_stats = function (self, item)
	table.clear(self._stats_animation_progress)

	local context = {
		{
			title = "loc_weapon_stats_title_damage",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_rate_of_fire",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_handling",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_range",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_reload_speed",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_area_damage",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_mobility",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_suppress",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_ammo",
			progress = math.random_range(0, 1)
		}
	}
	local widgets_by_name = self._widgets_by_name
	local anim_duration = PremiumVendorViewSettings.stats_anim_duration

	for i = 1, #context do
		local data = context[i]
		local name = "stat_" .. i
		local widget = widgets_by_name[name]

		if widget then
			widget.content.text = Localize(data.title)
			local value = data.progress

			self:_set_stat_bar_value(i, value, anim_duration)
		end
	end
end

PremiumVendorView._set_stat_bar_value = function (self, stat_index, value, duration, should_reset)
	local stats_animation_progress = self._stats_animation_progress
	local name = "stat_" .. stat_index
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name[name]
	local content = widget.content
	local current_progress = content.progress or 0
	local anim_data = {
		time = 0,
		start_value = should_reset and 0 or current_progress,
		end_value = value,
		duration = duration,
		widget = widget
	}
	stats_animation_progress[#stats_animation_progress + 1] = anim_data
end

PremiumVendorView._update_stat_bar_animations = function (self, dt)
	local stats_animation_progress = self._stats_animation_progress

	if not stats_animation_progress or #stats_animation_progress < 1 then
		return
	end

	for i = #stats_animation_progress, 1, -1 do
		local data = stats_animation_progress[i]
		local duration = data.duration
		local end_value = data.end_value
		local start_value = data.start_value
		local time = data.time
		local widget = data.widget
		time = time + dt
		local time_progress = math.clamp(time / duration, 0, 1)
		local anim_progress = math.ease_out_exp(time_progress)
		local target_value = end_value - start_value
		local anim_fraction = start_value + target_value * anim_progress
		widget.content.progress = anim_fraction

		if time_progress < 1 then
			data.time = time
		else
			stats_animation_progress[i] = nil
		end
	end
end

PremiumVendorView._set_preview_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.display_name.content.visible = visible
	widgets_by_name.info_box_divider.content.visible = visible
	widgets_by_name.info_divider_glow.content.visible = visible
	widgets_by_name.inspect_button.content.visible = visible
	widgets_by_name.price_text.content.visible = visible
	widgets_by_name.purchase_button.content.visible = visible
	widgets_by_name.sub_display_name.content.visible = visible
	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]
			widget.content.visible = visible
		end
	end
end

PremiumVendorView._stop_previewing = function (self)
	self._previewed_item = nil

	if self._weapon_preview then
		self._weapon_preview:stop_presenting()
	end

	local visible = false

	self:_set_preview_widgets_visibility(visible)
end

PremiumVendorView._set_display_price = function (self, price, type)
	local can_afford = self:_can_afford(price, type)
	local price_text = nil

	if price and type then
		local wallet_settings = WalletSettings[type]
		local string_symbol = wallet_settings.string_symbol
		price_text = tostring(price) .. " " .. string_symbol .. "\n"
	else
		price_text = ""
	end

	local widgets_by_name = self._widgets_by_name
	local text_widget = widgets_by_name.price_text
	local button_widget = widgets_by_name.purchase_button
	text_widget.content.text = price_text
	text_widget.style.text.text_color = can_afford and Color.ui_grey_light(255, true) or Color.ui_hud_red_light(255, true)
	button_widget.content.hotspot.disabled = not can_afford
end

PremiumVendorView._preview_element = function (self, element)
	local item = element.item
	local offer = element.offer
	local price_data = offer.price
	local price = price_data.amount.amount
	local type = price_data.amount.type

	self:_set_display_price(price, type)

	self._previewed_item = item
	self._previewed_offer = offer

	self._weapon_preview:present_item(item)
	self:_setup_item_stats(item)

	local display_name = ItemUtils.display_name(item)
	local sub_display_name = ItemUtils.sub_display_name(item)
	local rarity_color = ItemUtils.rarity_color(item)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.sub_display_name.content.text = sub_display_name
	widgets_by_name.display_name.content.text = display_name
	widgets_by_name.info_divider_glow.style.texture.color = table.clone(rarity_color)
	local visible = true

	self:_set_preview_widgets_visibility(visible)
end

PremiumVendorView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.inspect_button.content.hotspot.pressed_callback = callback(self, "_cb_on_inspect_pressed")
	widgets_by_name.purchase_button.content.hotspot.pressed_callback = callback(self, "_cb_on_purchase_pressed")
end

PremiumVendorView._cb_on_inspect_pressed = function (self)
	Managers.ui:open_view(DETAILS_VIEW_NAME, nil, nil, nil, nil, {
		player = self:_player(),
		preview_item = self._previewed_item
	})
end

PremiumVendorView._cb_on_purchase_pressed = function (self)
	local offer = self._previewed_offer

	if not offer then
		return
	end

	local price_data = offer.price.amount
	local price = price_data.price
	local type = price_data.type
	local can_afford = self:_can_afford(price, type)

	if can_afford.can_afford then
		self:_purchase_item(offer)
	end
end

PremiumVendorView._handle_weapon_preview_rendering = function (self)
	local weapon_preview = self._weapon_preview

	if not weapon_preview then
		return
	end
end

PremiumVendorView._destroy_weapon_preview = function (self)
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

PremiumVendorView._setup_weapon_preview = function (self)
	if not self._weapon_preview then
		local reference_name = "weapon_preview"
		local layer = 10
		local context = {
			shading_environment = PremiumVendorViewSettings.shading_environment
		}
		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, context)

		self:_update_weapon_preview_viewport()
	end
end

PremiumVendorView._display_title_text = function (self, text)
	local widgets_by_name = self._widgets_by_name
	local title_text_widget = widgets_by_name.title_text
	local visible_title_text = text ~= nil
	title_text_widget.content.visible = visible_title_text

	if visible_title_text then
		title_text_widget.content.text = Utf8.upper(Localize(text))
	end
end

PremiumVendorView.on_exit = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer("PremiumVendorView" .. "_ui_default_renderer")

		local world = self._gui_world
		local viewport_name = self._gui_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._gui_viewport_name = nil
		self._gui_viewport = nil
		self._gui_world = nil
	end

	if Managers.ui:view_active(DETAILS_VIEW_NAME) then
		Managers.ui:close_view(DETAILS_VIEW_NAME)
	end

	self:_destroy_weapon_preview()
	PremiumVendorView.super.on_exit(self)
	self:_destroy_offscreen_gui()
	Managers.event:trigger("event_equip_local_changes")
end

PremiumVendorView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 1
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name
	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._world)
end

PremiumVendorView._destroy_offscreen_gui = function (self)
	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_offscreen_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

PremiumVendorView._fetch_store_items = function (self)
	local store_service = Managers.data_service.store
	local store_promise = store_service:get_premium_store("premium_store_featured")

	if not store_promise then
		return
	end

	store_promise:next(function (data)
		if self._destroyed then
			return
		end

		local offers = data.offers
		local layout = self:_create_grid_layout(offers)

		self:_present_grid_layout(layout)
	end)
end

PremiumVendorView._item_valid_by_current_profile = function (self, item)
	local player = self:_player()
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid then
		return true
	end

	return false
end

PremiumVendorView._get_items_layout_by_slot = function (self, slot)
	local slot_name = slot.name
	local layout = {}
	local inventory_items = self._inventory_items

	for item_name, item in pairs(inventory_items) do
		if self:_item_valid_by_current_profile(item) then
			local slots = item.slots
			local valid = true

			if valid and slots then
				for j = 1, #slots do
					if slots[j] == slot_name then
						layout[#layout + 1] = {
							widget_type = "item",
							item = item,
							slot = slot
						}
					end
				end
			end
		end
	end

	return layout
end

PremiumVendorView._create_grid_layout = function (self, item_offers)
	local layout = {}

	for i = 1, #item_offers do
		local offer = item_offers[i]
		local offer_id = offer.offerId
		local sku = offer.sku
		local category = sku.category

		if category == "item_instance" then
			local item = MasterItems.get_store_item_instance(offer.description)
			layout[#layout + 1] = {
				widget_type = "item",
				item = item,
				offer = offer,
				offer_id = offer_id
			}
		end
	end

	return layout
end

PremiumVendorView.cb_on_grid_entry_right_pressed = function (self, widget, element)
	local item = element.item

	if item then
		local slots = item.slots

		if slots and not table.contains(slots, "slot_primary") and table.contains(slots, "slot_secondary") then
			-- Nothing
		end
	end
end

PremiumVendorView.cb_on_grid_entry_pressed = function (self, widget, element)
	local item = element.item

	if item and item ~= self._previewed_item then
		self:_preview_element(element)
	end
end

PremiumVendorView._purchase_item = function (self, offer)
	local store_service = Managers.data_service.store
	local promise = store_service:purchase_item(offer)

	promise:next(function (result)
		if self._destroyed then
			return
		end

		for i, item_data in ipairs(result.items) do
			local item = MasterItems.get_store_item_instance(item_data)
			local gear_id = item.gear_id

			ItemUtils.mark_item_id_as_new(gear_id)
			self:_update_wallets()
		end
	end)
end

PremiumVendorView._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		table.clear(widgets)
	end
end

PremiumVendorView._present_grid_layout = function (self, layout)
	self._visible_grid_layout = layout

	self:_clear_widgets(self._grid_widgets)
	self:_clear_widgets(self._grid_alignment_widgets)

	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"
	local previous_group_header_name = nil
	local group_header_index = 0

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local widget, alignment_widget = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name)
		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = alignment_widget

		if entry.widget_type == "group_header" then
			group_header_index = group_header_index + 1
			previous_group_header_name = "group_header_" .. group_header_index
		end

		widget.content.group_header = previous_group_header_name
	end

	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets
	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = PremiumVendorViewSettings.grid_spacing
	local grid = self:_setup_grid(self._grid_widgets, self._grid_alignment_widgets, grid_scenegraph_id, grid_spacing)
	self._grid = grid
	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
	self:_on_navigation_input_changed()
end

PremiumVendorView._setup_grid = function (self, widgets, alignment_list, grid_scenegraph_id, spacing)
	local direction = "down"

	return UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, direction, spacing)
end

PremiumVendorView._create_entry_widget_from_config = function (self, config, suffix, callback_name, secondary_callback_name)
	local scenegraph_id = "grid_content_pivot"
	local widget_type = config.widget_type
	local widget = nil
	local template = ContentBlueprints[widget_type]

	fassert(template, "[PremiumVendorView] - Could not find content blueprint for type: %s", widget_type)

	local size = template.size_function and template.size_function(self, config) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, config) or template.pass_template
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size)

	if widget_definition then
		local name = "widget_" .. suffix
		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type
		local init = template.init

		if init then
			init(self, widget, config, callback_name, secondary_callback_name)
		end
	end

	if widget then
		return widget, widget
	else
		return nil, {
			size = size
		}
	end
end

PremiumVendorView._draw_grid = function (self, dt, t, input_service)
	local grid = self._grid

	if not grid then
		return
	end

	local widgets = self._grid_widgets
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	local render_settings = self._render_settings
	local ui_renderer = self._ui_offscreen_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		if grid:is_widget_visible(widget) then
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_hovered
			end

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

PremiumVendorView._update_grid_widgets = function (self, dt, t, input_service)
	local widgets = self._grid_widgets

	if widgets then
		local handle_input = false

		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local update = template and template.update

			if update then
				update(self, widget, input_service, dt, t)
			end
		end

		if handle_input and self._focused_settings_widget and self._close_focused_setting then
			self._focused_settings_widget.offset[3] = 0

			self:_set_focused_grid_widget(self._settings_content_widgets, nil)

			self._focused_settings_widget = nil
			self._close_focused_setting = nil

			self:_enable_settings_overlay(false)
			self:set_can_exit(true, true)
		end
	end
end

PremiumVendorView._handle_input = function (self, input_service)
	return
end

PremiumVendorView._handle_back_pressed = function (self)
	local view_name = "premium_vendor_view"

	Managers.ui:close_view(view_name)
end

PremiumVendorView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

PremiumVendorView._on_navigation_input_changed = function (self)
	PremiumVendorView.super._on_navigation_input_changed(self)

	local grid = self._grid

	if grid then
		if not self._using_cursor_navigation then
			if not grid:selected_grid_index() then
				grid:select_first_index()
			end
		elseif grid:selected_grid_index() then
			grid:select_grid_index(nil)
		end
	end
end

PremiumVendorView.update = function (self, dt, t, input_service)
	if self._grid then
		self._grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)
	end

	self:_handle_weapon_preview_rendering()
	self:_update_stat_bar_animations(dt)

	return PremiumVendorView.super.update(self, dt, t, input_service)
end

PremiumVendorView.draw = function (self, dt, t, input_service, layer)
	self:_draw_grid(dt, t, input_service)

	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_default_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

PremiumVendorView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	PremiumVendorView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

PremiumVendorView._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if weapon_preview then
		local width_scale = 1
		local height_scale = 1
		local x_scale = 0
		local y_scale = 0

		weapon_preview:set_viewport_position_normalized(x_scale, y_scale)
		weapon_preview:set_viewport_size_normalized(width_scale, height_scale)

		local weapon_x_scale, weapon_y_scale = self:_get_weapon_spawn_position_normalized()

		weapon_preview:set_weapon_position_normalized(weapon_x_scale, weapon_y_scale)

		local weapon_zoom_fraction = self._weapon_zoom_fraction or 1

		weapon_preview:set_weapon_zoom(weapon_zoom_fraction)
	end
end

PremiumVendorView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale = nil
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

PremiumVendorView._set_weapon_zoom = function (self, fraction)
	self._weapon_zoom_fraction = fraction

	self:_update_weapon_preview_viewport()
end

PremiumVendorView.on_resolution_modified = function (self, scale)
	PremiumVendorView.super.on_resolution_modified(self, scale)
	self:_update_weapon_preview_viewport()
end

PremiumVendorView._update_wallets = function (self)
	local store_service = Managers.data_service.store
	local promise = store_service:account_wallets()

	promise:next(function (wallets_data)
		if self._destroyed then
			return
		end

		self:_update_wallets_presentation(wallets_data)
	end)
end

PremiumVendorView._update_wallets_presentation = function (self, wallets_data)
	local wallet_type = "aquilas"
	local wallet_settings = WalletSettings[wallet_type]
	local string_symbol = wallet_settings.string_symbol
	local amount = 0

	if wallets_data then
		local wallet = wallets_data:by_type(wallet_type)

		if wallet then
			local balance = wallet.balance
			amount = balance.amount
		end
	end

	local text = tostring(amount) .. " " .. string_symbol .. "\n"
	self._widgets_by_name.wallet_text.content.text = text
	self._current_balance[wallet_type] = amount
end

PremiumVendorView._can_afford = function (self, price, type)
	return price <= (self._current_balance[type] or 0)
end

return PremiumVendorView
