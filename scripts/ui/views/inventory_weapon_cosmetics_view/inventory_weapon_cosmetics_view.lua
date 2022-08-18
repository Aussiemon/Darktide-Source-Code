local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ContentBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_definitions")
local InventoryWeaponCosmeticsViewSettings = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local link_attachment_item_to_slot = nil

function link_attachment_item_to_slot(target_table, slot_id, item)
	for k, t in pairs(target_table) do
		if type(t) == "table" then
			if k == slot_id then
				t.item = item

				return true
			else
				link_attachment_item_to_slot(t, slot_id, item)
			end
		end
	end

	return false
end

local InventoryWeaponCosmeticsView = class("InventoryWeaponCosmeticsView", "BaseView")

InventoryWeaponCosmeticsView.init = function (self, settings, context)
	self._context = context
	self._visibility_toggled_on = true
	self._preview_player = context.player or Managers.player:local_player(1)

	InventoryWeaponCosmeticsView.super.init(self, Definitions, settings)

	self._always_visible_widget_names = Definitions.always_visible_widget_names
	self._pass_input = false
	self._pass_draw = false
end

InventoryWeaponCosmeticsView.on_enter = function (self)
	InventoryWeaponCosmeticsView.super.on_enter(self)
	self:_setup_weapon_preview()
	self:_setup_default_gui()
	self:_setup_input_legend()
	self:_fetch_items()
	self:_setup_offscreen_gui()

	local tabs_content = {
		{
			display_name = "display_name",
			icon = "content/ui/materials/icons/cosmetics/categories/upper_body"
		},
		{
			display_name = "display_name",
			icon = "content/ui/materials/icons/cosmetics/categories/upper_body"
		}
	}

	self:_setup_menu_tabs(tabs_content)
end

InventoryWeaponCosmeticsView._setup_menu_tabs = function (self, content)
	local id = "tab_menu"
	local layer = 10
	local tab_menu_settings = {
		fixed_button_size = true,
		horizontal_alignment = "center",
		button_spacing = 20,
		button_size = {
			200,
			50
		}
	}
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)
	self._tab_menu_element = tab_menu_element
	local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button_icon)
	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
	}
	local tab_ids = {}

	for i = 1, #content, 1 do
		local tab_content = content[i]
		local display_name = tab_content.display_name
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(display_name, pressed_callback, tab_button_template, display_icon)
		tab_ids[i] = tab_id
	end

	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

InventoryWeaponCosmeticsView._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("grid_tab_panel")

	self._tab_menu_element:set_pivot_offset(position[1], position[2])
end

InventoryWeaponCosmeticsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 40)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs, 1 do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponCosmeticsView._fetch_items = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local num_items = 100
	local filter = {
		"slot_gear_extra_cosmetic"
	}

	Managers.data_service.gear:fetch_inventory_paged(character_id, num_items, filter):next(function (items)
		if self._destroyed then
			return
		end

		local temp_item = require("scripts/backend/master_items"):get_cached()["content/items/weapons/player/trinkets/debug_trinket"]
		local temp_items = {}

		for i = 1, 10, 1 do
			temp_items[i] = temp_item
		end

		self._inventory_items = temp_items

		self:_populate_grid()
	end)
end

InventoryWeaponCosmeticsView._get_items_layout_by_slot = function (self, slot)
	local layout = {
		{
			widget_type = "dynamic_spacing",
			size = {
				20,
				128
			}
		}
	}
	local inventory_items = self._inventory_items

	for item_name, item in pairs(inventory_items) do
		if self:_item_valid_by_current_profile(item) then
			layout[#layout + 1] = {
				widget_type = "item",
				item = item,
				slot = slot
			}
		end
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			20,
			128
		}
	}

	return layout
end

InventoryWeaponCosmeticsView._item_valid_by_current_profile = function (self, item)
	local player = self._preview_player
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

InventoryWeaponCosmeticsView._selected_slot = function (self)
	local key = "slot_trinket_1"

	return ItemSlotSettings[key]
end

InventoryWeaponCosmeticsView._populate_grid = function (self, optional_grid_index, optional_sort_index)
	local grid_index = optional_grid_index
	local selected_slot = self:_selected_slot()
	local layout = self:_get_items_layout_by_slot(selected_slot)

	self:_setup_grid_layout(layout)

	local equipped_item_grid_index = nil

	if not grid_index then
		if equipped_item_grid_index then
			grid_index = equipped_item_grid_index
		elseif #self._grid_widgets > 0 then
			grid_index = 1
		end
	end

	local instant_scroll = true
	local scroll_progress = grid_index and self._grid:get_scrollbar_percentage_by_index(grid_index)

	self._grid:focus_grid_index(grid_index, scroll_progress, instant_scroll)

	self._focused_grid_index = grid_index
	local using_cursor_navigation = Managers.ui:using_cursor_navigation()
	self._using_cursor_navigation = using_cursor_navigation

	if not using_cursor_navigation then
		self._grid:select_grid_index(grid_index, scroll_progress, instant_scroll)
	end
end

InventoryWeaponCosmeticsView._cb_on_close_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_cosmetics_view")
end

InventoryWeaponCosmeticsView._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = "InventoryWeaponCosmeticsView"
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

InventoryWeaponCosmeticsView._preview_item = function (self, item, attachment_item)
	item = table.clone_instance(item)

	if attachment_item then
		link_attachment_item_to_slot(item, "slot_trinket_1", attachment_item)
		link_attachment_item_to_slot(item, "slot_trinket_2", attachment_item)
	end

	local disable_auto_spin = true

	self._weapon_preview:present_item(item, disable_auto_spin)

	self._previewed_item = item
	local display_name = ItemUtils.display_name(item)
	local sub_display_name = ItemUtils.sub_display_name(item)
	local rarity_color = ItemUtils.rarity_color(item)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.sub_title_text.content.text = sub_display_name
	widgets_by_name.title_text.content.text = display_name
	widgets_by_name.title_divider_glow.style.texture.color = table.clone(rarity_color)
end

InventoryWeaponCosmeticsView._destroy_weapon_preview = function (self)
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

InventoryWeaponCosmeticsView._setup_weapon_preview = function (self)
	if not self._weapon_preview then
		local reference_name = "weapon_preview"
		local layer = 10
		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, {
			draw_background = true
		})
		self._weapon_zoom_fraction = 0.95

		self:_update_weapon_preview_viewport()
	end
end

InventoryWeaponCosmeticsView._update_weapon_preview_viewport = function (self)
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

InventoryWeaponCosmeticsView.on_back_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_cosmetics_view")
end

InventoryWeaponCosmeticsView.on_exit = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer("InventoryWeaponCosmeticsView" .. "_ui_default_renderer")

		local world = self._gui_world
		local viewport_name = self._gui_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._gui_viewport_name = nil
		self._gui_viewport = nil
		self._gui_world = nil
	end

	self:_destroy_weapon_preview()
	self:_destroy_offscreen_gui()
	InventoryWeaponCosmeticsView.super.on_exit(self)
end

InventoryWeaponCosmeticsView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale = nil
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

InventoryWeaponCosmeticsView._set_weapon_zoom = function (self, fraction)
	self._weapon_zoom_fraction = fraction

	self:_update_weapon_preview_viewport()
end

InventoryWeaponCosmeticsView._cb_on_ui_visibility_toggled = function (self, id)
	self._visibility_toggled_on = not self._visibility_toggled_on
	local display_name = (self._visibility_toggled_on and "loc_menu_toggle_ui_visibility_off") or "loc_menu_toggle_ui_visibility_on"

	self._input_legend_element:set_display_name(id, display_name)
end

InventoryWeaponCosmeticsView._handle_input = function (self, input_service)
	local scroll_axis = input_service:get("scroll_axis")

	if scroll_axis then
		local scroll = scroll_axis[2]

		if scroll_axis ~= 0 then
			local weapon_zoom_fraction = (self._weapon_zoom_fraction or 1) + scroll * 0.01

			self:_set_weapon_zoom(weapon_zoom_fraction)
		end
	end
end

InventoryWeaponCosmeticsView.update = function (self, dt, t, input_service)
	if self._grid then
		self._grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)
	end

	return InventoryWeaponCosmeticsView.super.update(self, dt, t, input_service)
end

InventoryWeaponCosmeticsView.draw = function (self, dt, t, input_service, layer)
	self:_draw_grid(dt, t, input_service)

	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_default_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local alpha_multiplier = render_settings.alpha_multiplier or 1
	render_settings.alpha_multiplier = 1

	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)

	local anim_alpha_speed = 3

	if self._visibility_toggled_on then
		alpha_multiplier = math.min(alpha_multiplier + dt * anim_alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * anim_alpha_speed, 0)
	end

	render_settings.alpha_multiplier = alpha_multiplier
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
end

InventoryWeaponCosmeticsView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local always_visible_widget_names = self._always_visible_widget_names
	local alpha_multiplier = render_settings.alpha_multiplier
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets, 1 do
		local widget = widgets[i]
		local widget_name = widget.name
		render_settings.alpha_multiplier = (always_visible_widget_names[widget_name] and 1) or alpha_multiplier

		UIWidget.draw(widget, ui_renderer)
	end

	render_settings.alpha_multiplier = alpha_multiplier
	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets, 1 do
			local widget = stat_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

InventoryWeaponCosmeticsView._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets, 1 do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		table.clear(widgets)
	end
end

InventoryWeaponCosmeticsView._setup_grid_layout = function (self, layout)
	self._current_scrollbar_progress = nil
	self._visible_grid_layout = layout

	self:_clear_widgets(self._grid_widgets)
	self:_clear_widgets(self._grid_alignment_widgets)

	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_left_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local widget, alignment_widget = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name)
		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = alignment_widget
	end

	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets
	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = InventoryWeaponCosmeticsViewSettings.grid_spacing
	local grid = self:_setup_grid(self._grid_widgets, self._grid_alignment_widgets, grid_scenegraph_id, grid_spacing)
	self._grid = grid
	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
	grid:set_scroll_step_length(100)
	self:_on_navigation_input_changed()
end

InventoryWeaponCosmeticsView._setup_grid = function (self, widgets, alignment_list, grid_scenegraph_id, spacing)
	local direction = "right"

	return UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, direction, spacing)
end

InventoryWeaponCosmeticsView._create_entry_widget_from_config = function (self, config, suffix, callback_name, secondary_callback_name)
	local scenegraph_id = "grid_content_pivot"
	local widget_type = config.widget_type
	local widget = nil
	local template = ContentBlueprints[widget_type]

	fassert(template, "[InventoryWeaponCosmeticsView] - Could not find content blueprint for type: %s", widget_type)

	local size = (template.size_function and template.size_function(self, config)) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = (pass_template_function and pass_template_function(self, config)) or template.pass_template
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

InventoryWeaponCosmeticsView._draw_grid = function (self, dt, t, input_service)
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

	for i = 1, #widgets, 1 do
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

InventoryWeaponCosmeticsView._update_grid_widgets = function (self, dt, t, input_service)
	local widgets = self._grid_widgets

	if widgets then
		for i = 1, #widgets, 1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local update = template and template.update

			if update then
				update(self, widget, input_service, dt, t)
			end
		end
	end
end

InventoryWeaponCosmeticsView._setup_offscreen_gui = function (self)
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

InventoryWeaponCosmeticsView._destroy_offscreen_gui = function (self)
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

InventoryWeaponCosmeticsView.on_resolution_modified = function (self, scale)
	InventoryWeaponCosmeticsView.super.on_resolution_modified(self, scale)
	self:_update_weapon_preview_viewport()
end

InventoryWeaponCosmeticsView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	local view_context = self._context
	local item = view_context and view_context.preview_item

	if item then
		local attachment_item = require("scripts/backend/master_items"):get_cached()["content/items/weapons/player/trinkets/debug_trinket"]

		self:_preview_item(item, attachment_item)
	end
end

InventoryWeaponCosmeticsView.cb_on_grid_entry_right_pressed = function (self, widget, element)
	return
end

InventoryWeaponCosmeticsView.cb_switch_tab = function (self, index)
	return
end

InventoryWeaponCosmeticsView.on_resolution_modified = function (self, scale)
	InventoryWeaponCosmeticsView.super.on_resolution_modified(self, scale)

	local grid = self._grid

	if grid then
		grid:on_resolution_modified(scale)
	end

	self:_update_tab_bar_position()
end

return InventoryWeaponCosmeticsView
