local ContentBlueprints = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_content_blueprints")
local Definitions = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_definitions")
local InventoryWeaponDetailsViewSettings = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_settings")
local ItemStatSettings = require("scripts/settings/item/item_stat_settings")
local ItemUtils = require("scripts/utilities/items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local WeaponDetailsPassTemplates = require("scripts/ui/pass_templates/weapon_details_pass_templates")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local TraitSettings = require("scripts/settings/traits/traits_settings")
local InventoryWeaponDetailsView = class("InventoryWeaponDetailsView", "BaseView")

InventoryWeaponDetailsView.init = function (self, settings, context)
	self._context = context or {}
	self._visibility_toggled_on = true

	InventoryWeaponDetailsView.super.init(self, Definitions, settings)

	self._always_visible_widget_names = Definitions.always_visible_widget_names
	self._pass_input = false
	self._pass_draw = false
end

InventoryWeaponDetailsView.on_enter = function (self)
	InventoryWeaponDetailsView.super.on_enter(self)
	self:_setup_weapon_preview()
	self:_setup_default_gui()
	self:_setup_input_legend()

	local item = self._context.preview_item

	if item then
		self:_preview_item(item)
	end

	self:_setup_offscreen_gui()
end

InventoryWeaponDetailsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 40)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponDetailsView._cb_on_close_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_details_view")
end

InventoryWeaponDetailsView._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local reference_name = "InventoryWeaponDetailsView"
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

InventoryWeaponDetailsView._get_item_stats_values = function (self, item)
	local base_stats = item.base_stats

	if not base_stats then
		return
	end

	local context = {
		{
			title = "loc_weapon_stats_title_damage",
			value = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_rate_of_fire",
			value = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_handling",
			value = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_range",
			value = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_reload_speed",
			value = math.random_range(0, 1)
		}
	}

	return context
end

InventoryWeaponDetailsView._generate_fake_progression_info = function (self, traits, num_progression_steps)
	local fake_progression_info = {}
	local traits_added = 0
	local traits_table_size = table.size(traits)

	while traits_added <= num_progression_steps do
		local random_index = math.random(1, #traits_table_size)
		local index_counter = 1

		for trait_key, trait in pairs(traits) do
			if index_counter == random_index then
				fake_progression_info[#fake_progression_info + 1] = {
					trait_key
				}

				break
			end

			index_counter = index_counter + 1
		end

		traits_added = traits_added + 1
	end

	return fake_progression_info
end

InventoryWeaponDetailsView._preview_item = function (self, item)
	self._trait_widgets = self:_create_trait_slot_widgets(item)
	local perks = item.perks
	local traits = item.traits
	local overclocking = item.overclocking

	self._weapon_preview:present_item(item)

	self._previewed_item = item
	local variant_display_name = ItemUtils.variant_display_name(item)
	local progress_title = string.format(variant_display_name)
	local rank_text = ItemUtils.rank_display_text(item)
	local loadout = {
		{
			widget_type = "spacing_vertical_edge_margin"
		},
		{
			widget_type = "item_header",
			item = item
		},
		{
			widget_type = "spacing_vertical"
		},
		{
			text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
			widget_type = "item_description"
		},
		{
			widget_type = "spacing_vertical"
		}
	}
	local base_stats = item.base_stats

	if base_stats then
		local num_stats = #base_stats

		for i = 1, num_stats do
			local stat = base_stats[i]
			local stat_name = stat.name
			local title = stat.title
			local value = stat.value
			local stat_settings = ItemStatSettings[stat_name]
			local display_name = stat_settings.display_name
			local localized_display_name = Localize(display_name)
			loadout[#loadout + 1] = {
				widget_type = "stats_meter",
				text = display_name,
				value = value
			}

			if i < num_stats then
				loadout[#loadout + 1] = {
					widget_type = "stats_meter_spacing_vertical"
				}
			end
		end
	end

	local stat_traits = {}

	if stat_traits then
		loadout[#loadout + 1] = {
			widget_type = "spacing_vertical"
		}
		loadout[#loadout + 1] = {
			text = "loc_item_property_title",
			widget_type = "item_category_header"
		}
		loadout[#loadout + 1] = {
			text = "placeholder_text",
			widget_type = "item_property_value"
		}
		loadout[#loadout + 1] = {
			text = "placeholder_text",
			widget_type = "item_property_value"
		}
		loadout[#loadout + 1] = {
			text = "placeholder_text",
			widget_type = "item_property_value"
		}
	end

	loadout[#loadout + 1] = {
		widget_type = "spacing_vertical_edge_margin"
	}

	self:_setup_grid_layout(loadout)
end

InventoryWeaponDetailsView._create_trait_slot_widgets = function (self, item)
	local traits = item.traits

	if not traits then
		return
	end

	local num_trait_slots = table.size(traits)
	local widgets = {}
	local trait_widget_definition = self._definitions.trait_widget_definition
	local total_widgets_height = 20

	for i = 1, num_trait_slots do
		local trait_id = traits[i]
		local trait_settings = TraitSettings[trait_id]
		local trait_display_name = trait_settings and trait_settings.display_name or "<Trait Name Missing>"
		local trait_description_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
		local widget_name = "trait_" .. i
		local widget = self:_create_widget(widget_name, trait_widget_definition, nil)
		widgets[#widgets + 1] = widget
		local content = widget.content
		local style = widget.style
		content.display_name = trait_display_name
		content.description_text = trait_description_text
		local description_text_style = style.description_text
		local ui_renderer = self._ui_renderer
		local widget_size = content.size
		local description_text_style_size = description_text_style.size
		local description_text_style_offset = description_text_style.offset
		description_text_style_size[1] = widget_size[1] - description_text_style_offset[1]
		local text_options = UIFonts.get_font_options_by_style(description_text_style)
		local _, text_height = UIRenderer.text_size(ui_renderer, trait_description_text, description_text_style.font_type, description_text_style.font_size, widget_size, text_options)
		local icon_size = style.icon.size
		local widget_height = math.max(text_height + description_text_style_offset[2] + icon_size[2], icon_size[2] * 2)
		widget_size[2] = widget_height
		description_text_style_size[2] = text_height
		widget.offset[2] = total_widgets_height
		total_widgets_height = total_widgets_height + widget_height
	end

	self:_set_scenegraph_size("info_box", nil, total_widgets_height)

	return widgets
end

InventoryWeaponDetailsView._destroy_weapon_preview = function (self)
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

InventoryWeaponDetailsView._setup_weapon_preview = function (self)
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

InventoryWeaponDetailsView._update_weapon_preview_viewport = function (self)
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

InventoryWeaponDetailsView.on_back_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_details_view")
end

InventoryWeaponDetailsView.on_exit = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer("InventoryWeaponDetailsView" .. "_ui_default_renderer")

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
	InventoryWeaponDetailsView.super.on_exit(self)
end

InventoryWeaponDetailsView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale = nil
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

InventoryWeaponDetailsView._set_weapon_zoom = function (self, fraction)
	self._weapon_zoom_fraction = fraction

	self:_update_weapon_preview_viewport()
end

InventoryWeaponDetailsView.cb_on_trait_pressed = function (self, widget)
	local widget_content = widget.content
	local trait_slot_index = widget_content.trait_slot_index
	local trait_id = widget_content.trait_id
	local is_equipped = self:_is_trait_equipped(trait_id, trait_slot_index)

	if widget_content.unlocked and widget_content.equippable and not is_equipped then
		self:_locally_equip_trait(trait_slot_index, trait_id)
	end
end

InventoryWeaponDetailsView._locally_equip_trait = function (self, trait_id, slot_index)
	self._equipped_traits_cache[slot_index] = trait_id
end

InventoryWeaponDetailsView._is_trait_slot_unlocked = function (self, slot_index)
	local item = self._previewed_item
	local progression_manager = Managers.progression
	local unlocked = progression_manager:is_trait_slot_unlocked(item, slot_index)

	return unlocked
end

InventoryWeaponDetailsView._is_trait_equipped = function (self, trait_id, slot_index)
	return self._equipped_traits_cache[slot_index] == trait_id
end

InventoryWeaponDetailsView._update_trait_presentation = function (self, dt)
	local widgets = self._trait_widgets

	if not widgets then
		return
	end

	local hover_index = nil

	for i = 1, #widgets do
		local widget = widgets[i]
		local widget_content = widget.content

		if widget_content.hotspot.is_hover then
			hover_index = i
		end

		local trait_slot_index = widget_content.trait_slot_index
		local trait_id = widget_content.trait_id
		local is_equipped = self:_is_trait_equipped(trait_id, trait_slot_index)
		widget_content.hotspot.is_focused = is_equipped
		local is_unlocked = self:_is_trait_slot_unlocked(trait_slot_index)
		widget_content.unlocked = is_unlocked
	end
end

InventoryWeaponDetailsView._handle_trait_navigation = function (self, input_service)
	return
end

InventoryWeaponDetailsView._trait_widget_by_row_and_column = function (self, row, column)
	local trait_widget_navigation = self._trait_widget_navigation
	local row_array = trait_widget_navigation[row]

	return row_array and row_array[column]
end

InventoryWeaponDetailsView._trait_widget_row_and_column = function (self, widget)
	local trait_widget_navigation = self._trait_widget_navigation

	for i = 1, #trait_widget_navigation do
		local row_array = trait_widget_navigation[i]

		for j = 1, #row_array do
			if row_array[j] == widget then
				return i, j
			end
		end
	end
end

InventoryWeaponDetailsView._cb_on_ui_visibility_toggled = function (self, id)
	self._visibility_toggled_on = not self._visibility_toggled_on
	local display_name = self._visibility_toggled_on and "loc_menu_toggle_ui_visibility_off" or "loc_menu_toggle_ui_visibility_on"

	self._input_legend_element:set_display_name(id, display_name)
end

InventoryWeaponDetailsView._handle_input = function (self, input_service)
	self:_handle_trait_navigation(input_service)

	local scroll_axis = input_service:get("scroll_axis")

	if scroll_axis then
		local scroll = scroll_axis[2]

		if scroll_axis ~= 0 then
			local weapon_zoom_fraction = (self._weapon_zoom_fraction or 1) + scroll * 0.01

			self:_set_weapon_zoom(weapon_zoom_fraction)
		end
	end
end

InventoryWeaponDetailsView.update = function (self, dt, t, input_service)
	if self._grid then
		self._grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)
	end

	return InventoryWeaponDetailsView.super.update(self, dt, t, input_service)
end

InventoryWeaponDetailsView.draw = function (self, dt, t, input_service, layer)
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

InventoryWeaponDetailsView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local always_visible_widget_names = self._always_visible_widget_names
	local alpha_multiplier = render_settings.alpha_multiplier
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]
		local widget_name = widget.name
		render_settings.alpha_multiplier = always_visible_widget_names[widget_name] and 1 or alpha_multiplier

		UIWidget.draw(widget, ui_renderer)
	end

	render_settings.alpha_multiplier = alpha_multiplier
	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local trait_widgets = self._trait_widgets

	if trait_widgets then
		for i = 1, #trait_widgets do
			local widget = trait_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

InventoryWeaponDetailsView._clear_widgets = function (self, widgets)
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

InventoryWeaponDetailsView._setup_grid_layout = function (self, layout)
	self._visible_grid_layout = layout

	self:_clear_widgets(self._grid_widgets)
	self:_clear_widgets(self._grid_alignment_widgets)

	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_pressed"
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
	local grid_spacing = InventoryWeaponDetailsViewSettings.grid_spacing
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

InventoryWeaponDetailsView._setup_grid = function (self, widgets, alignment_list, grid_scenegraph_id, spacing)
	local direction = "down"

	return UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, direction, spacing)
end

InventoryWeaponDetailsView._create_entry_widget_from_config = function (self, config, suffix, callback_name, secondary_callback_name)
	local scenegraph_id = "grid_content_pivot"
	local widget_type = config.widget_type
	local widget = nil
	local template = ContentBlueprints[widget_type]

	fassert(template, "[InventoryWeaponDetailsView] - Could not find content blueprint for type: %s", widget_type)

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

InventoryWeaponDetailsView._draw_grid = function (self, dt, t, input_service)
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

InventoryWeaponDetailsView._update_grid_widgets = function (self, dt, t, input_service)
	local widgets = self._grid_widgets

	if widgets then
		for i = 1, #widgets do
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

InventoryWeaponDetailsView._setup_offscreen_gui = function (self)
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

InventoryWeaponDetailsView._destroy_offscreen_gui = function (self)
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

InventoryWeaponDetailsView.on_resolution_modified = function (self, scale)
	InventoryWeaponDetailsView.super.on_resolution_modified(self, scale)
	self:_update_weapon_preview_viewport()
end

return InventoryWeaponDetailsView
