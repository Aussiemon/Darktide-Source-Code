local Definitions = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_definitions")
local InventoryWeaponDetailsViewSettings = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_settings")
local ItemStatSettings = require("scripts/settings/item/item_stat_settings")
local ItemUtils = require("scripts/utilities/items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local ViewElementWeaponActions = require("scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
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
	self:_setup_offscreen_gui()
	self:_setup_weapon_stats()
	self:_setup_weapon_actions()

	local item = self._context.preview_item

	if item then
		self:_preview_item(item)
	end
end

InventoryWeaponDetailsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponDetailsView._setup_weapon_stats = function (self)
	if not self._weapon_stats then
		local reference_name = "weapon_stats"
		local layer = 30
		local title_height = 70
		local edge_padding = 4
		local grid_width = 530
		local grid_height = 840
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
			ignore_blur = true,
			grid_spacing = grid_spacing,
			grid_size = grid_size,
			mask_size = mask_size,
			title_height = title_height,
			edge_padding = edge_padding
		}
		self._weapon_stats = self:_add_element(ViewElementWeaponStats, reference_name, layer, context)

		self:_update_weapon_stats_position()
	end
end

InventoryWeaponDetailsView._update_weapon_stats_position = function (self)
	if not self._weapon_stats then
		return
	end

	local position = self:_scenegraph_world_position("weapon_stats_pivot")

	self._weapon_stats:set_pivot_offset(position[1], position[2])
end

InventoryWeaponDetailsView._setup_weapon_actions = function (self)
	if not self._weapon_actions then
		local reference_name = "weapon_actions"
		local layer = 30
		local title_height = 70
		local edge_padding = 4
		local grid_width = 420
		local grid_height = 840
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
			ignore_blur = true,
			grid_spacing = grid_spacing,
			grid_size = grid_size,
			mask_size = mask_size,
			title_height = title_height,
			edge_padding = edge_padding
		}
		self._weapon_actions = self:_add_element(ViewElementWeaponActions, reference_name, layer, context)

		self:_update_weapon_actions_position()
	end
end

InventoryWeaponDetailsView._update_weapon_actions_position = function (self)
	if not self._weapon_actions then
		return
	end

	local position = self:_scenegraph_world_position("weapon_actions_pivot")

	self._weapon_actions:set_pivot_offset(position[1], position[2])
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

InventoryWeaponDetailsView._preview_item = function (self, item)
	self._weapon_preview:present_item(item)
	self._weapon_preview:center_align(0, {
		-0.1,
		0.3,
		-0.2
	})

	self._previewed_item = item
	local slots = item.slots

	if slots and (table.find(slots, "slot_primary") or table.find(slots, "slot_secondary")) then
		if self._weapon_actions then
			self._weapon_actions:present_item(item)

			local menu_settings = self._weapon_actions._menu_settings
			local grid_size = menu_settings.grid_size

			self:_set_scenegraph_position("weapon_actions_pivot", nil, -(grid_size[2] + 100))
			self:_update_weapon_actions_position()
		end

		if self._weapon_stats then
			self._weapon_stats:present_item(item)

			local menu_settings = self._weapon_stats._menu_settings
			local grid_size = menu_settings.grid_size

			self:_set_scenegraph_position("weapon_stats_pivot", nil, -(grid_size[2] + 100))
			self:_update_weapon_stats_position()
		end
	end

	self._widgets_by_name.background.style.rarity_background.color = table.clone(ItemUtils.rarity_color(item))
	self._widgets_by_name.background.style.rarity_background.color[1] = 70
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
		local layer = 1
		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, {
			draw_background = false
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

InventoryWeaponDetailsView._is_trait_slot_unlocked = function (self, slot_index)
	local item = self._previewed_item
	local progression_manager = Managers.progression
	local unlocked = progression_manager:is_trait_slot_unlocked(item, slot_index)

	return unlocked
end

InventoryWeaponDetailsView._cb_on_ui_visibility_toggled = function (self, id)
	self._visibility_toggled_on = not self._visibility_toggled_on
	local display_name = self._visibility_toggled_on and "loc_menu_toggle_ui_visibility_off" or "loc_menu_toggle_ui_visibility_on"

	self._input_legend_element:set_display_name(id, display_name)
end

InventoryWeaponDetailsView._handle_input = function (self, input_service)
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
	return InventoryWeaponDetailsView.super.update(self, dt, t, input_service)
end

InventoryWeaponDetailsView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

InventoryWeaponDetailsView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local old_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._alpha_multiplier or 1
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name

			if element_name ~= "ViewElementInventoryWeaponPreview" or element_name ~= "ViewElementInputLegend" then
				ui_renderer = self._ui_default_renderer or ui_renderer
			end

			render_settings.alpha_multiplier = element_name ~= "ViewElementInputLegend" and alpha_multiplier or 1

			element:draw(dt, t, ui_renderer, render_settings, input_service)
		end
	end

	render_settings.alpha_multiplier = old_alpha_multiplier
end

InventoryWeaponDetailsView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local alpha_multiplier = self._alpha_multiplier or 1
	local anim_alpha_speed = 3

	if self._visibility_toggled_on then
		alpha_multiplier = math.min(alpha_multiplier + dt * anim_alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * anim_alpha_speed, 0)
	end

	local always_visible_widget_names = self._always_visible_widget_names
	self._alpha_multiplier = alpha_multiplier
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]
		local widget_name = widget.name
		render_settings.alpha_multiplier = always_visible_widget_names[widget_name] and 1 or alpha_multiplier

		UIWidget.draw(widget, ui_renderer)
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
	self:_update_weapon_actions_position()
	self:_update_weapon_stats_position()
end

return InventoryWeaponDetailsView
