-- chunkname: @scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view.lua

local Definitions = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_definitions")
local InventoryWeaponDetailsViewSettings = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_settings")
local ItemStatSettings = require("scripts/settings/item/item_stat_settings")
local ItemUtils = require("scripts/utilities/items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local WeaponStats = require("scripts/utilities/weapon_stats")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local InputDevice = require("scripts/managers/input/input_device")
local ViewElementWeaponInfo = require("scripts/ui/view_elements/view_element_weapon_info/view_element_weapon_info")
local ViewElementWeaponActionsExtended = require("scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions_extended")
local ViewElementWeaponPatterns = require("scripts/ui/view_elements/view_element_weapon_patterns/view_element_weapon_patterns")
local InventoryWeaponDetailsView = class("InventoryWeaponDetailsView", "BaseView")

InventoryWeaponDetailsView.init = function (self, settings, context)
	self._context = context or {}
	self._visibility_toggled_on = true

	InventoryWeaponDetailsView.super.init(self, Definitions, settings)

	self._always_visible_widget_names = Definitions.always_visible_widget_names
	self._pass_input = false
	self._pass_draw = false
	self._togglable_views_index = nil
	self._togglable_views = {}
	self._weapon_zoom_fraction = 1
	self._weapon_zoom_target = 1
	self._min_zoom = 0.1
	self._max_zoom = 4
	self._attack_stats_idx = 1
end

InventoryWeaponDetailsView.on_enter = function (self)
	InventoryWeaponDetailsView.super.on_enter(self)
	self:_setup_weapon_preview()
	self:_setup_default_gui()
	self:_setup_input_legend()
	self:_setup_offscreen_gui()
	self:_setup_weapon_info()
	self:_setup_weapon_actions_extended()
	self:_setup_attack_patterns()
	self:_toggle_view(nil, true)

	local item = self._context.preview_item

	if item then
		self:_preview_item(item)
	end
end

InventoryWeaponDetailsView._setup_debug_weapon_stats = function (self, item)
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)

	if weapon_template then
		self._weapon_statistics = WeaponStats:new(item)
	end
end

InventoryWeaponDetailsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 50)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponDetailsView._toggle_view = function (self, id, force_update)
	local old_view_index = self._togglable_views_index or 1
	local new_view_index = 1 + (self._togglable_views_index or 0) % #self._togglable_views
	local togglable_views = self._togglable_views

	if old_view_index ~= new_view_index or force_update then
		local old_view = togglable_views[old_view_index]

		if old_view then
			old_view.class:set_active(false)
		end

		local new_view = togglable_views[new_view_index]

		if new_view then
			new_view.class:set_active(true)
		end

		local on_activate = new_view.on_activate

		if on_activate then
			on_activate()
		end

		if self._weapon_preview then
			self._weapon_preview:set_force_allow_rotation(new_view.allow_weapon_preview_rotation)
		end

		if id then
			local next_view_index = 1 + new_view_index % #self._togglable_views
			local next_view = togglable_views[next_view_index]

			if next_view then
				self._input_legend_element:set_display_name(id, next_view.legend)
			end
		end
	end

	self._togglable_views_index = new_view_index
end

InventoryWeaponDetailsView._setup_weapon_info = function (self)
	if not self._weapon_info then
		local reference_name = "weapon_info"
		local layer = 30
		local title_height = 70
		local edge_padding = 40
		local grid_width = 600
		local grid_height = 1000
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

		self._weapon_info = self:_add_element(ViewElementWeaponInfo, reference_name, layer, context)

		self:_update_weapon_info_position()
	end
end

InventoryWeaponDetailsView._update_weapon_info_position = function (self)
	if not self._weapon_info then
		return
	end

	local position = self:_scenegraph_world_position("weapon_info_pivot")

	self._weapon_info:set_pivot_offset(position[1], position[2])
end

InventoryWeaponDetailsView._setup_weapon_actions_extended = function (self)
	if not self._weapon_actions_extended then
		local reference_name = "weapon_actions_extended"
		local layer = 30
		local title_height = 70
		local edge_padding = 4
		local grid_width = 460
		local grid_height = 1000
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

		self._weapon_actions_extended = self:_add_element(ViewElementWeaponActionsExtended, reference_name, layer, context)

		self:_update_weapon_actions_extended_position()

		self._togglable_views[#self._togglable_views + 1] = {
			allow_weapon_preview_rotation = true,
			legend = "loc_menu_show_weapon_actions_extended",
			class = self._weapon_actions_extended,
			on_activate = callback(self, "cb_activate_weapon_info", true)
		}
	end
end

InventoryWeaponDetailsView._update_weapon_actions_extended_position = function (self)
	if not self._weapon_actions_extended then
		return
	end

	local position = self:_scenegraph_world_position("weapon_actions_extended_pivot")

	self._weapon_actions_extended:set_pivot_offset(position[1], position[2])
end

InventoryWeaponDetailsView._setup_attack_patterns = function (self)
	if not self._attack_patterns then
		local reference_name = "attack_patterns"
		local layer = 300
		local title_height = 70
		local edge_padding = 4
		local grid_width = 850
		local grid_height = 1000
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

		self._attack_patterns = self:_add_element(ViewElementWeaponPatterns, reference_name, layer, context)

		self:_update_weapon_actions_extended_position()

		self._togglable_views[#self._togglable_views + 1] = {
			legend = "loc_menu_show_attack_patterns",
			class = self._attack_patterns,
			on_activate = callback(self, "cb_activate_weapon_info", false)
		}
	end
end

InventoryWeaponDetailsView._update_attack_patterns_position = function (self)
	if not self._attack_patterns then
		return
	end

	local position = self:_scenegraph_world_position("attack_patterns_pivot")

	self._attack_patterns:set_pivot_offset(position[1], position[2])
end

InventoryWeaponDetailsView.cb_activate_weapon_info = function (self, activate)
	self._weapon_info:activate(activate)
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
		if self._weapon_actions_extended then
			self._weapon_actions_extended:present_item(item)
			self:_update_weapon_actions_extended_position()
		end

		if self._weapon_info then
			self._weapon_info:present_item(item)
			self:_update_weapon_info_position()
		end

		if self._attack_patterns then
			self._attack_patterns:present_item(item)
			self:_update_attack_patterns_position()
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
			draw_background = true
		})
		self._weapon_zoom_fraction = 0.95

		self:_update_weapon_preview_viewport()
	end
end

InventoryWeaponDetailsView._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if weapon_preview then
		local width_scale, height_scale = 1, 1
		local x_scale, y_scale = 0, 0

		weapon_preview:set_viewport_position_normalized(x_scale, y_scale)
		weapon_preview:set_viewport_size_normalized(width_scale, height_scale)

		local weapon_x_scale, weapon_y_scale = self:_get_weapon_spawn_position_normalized()

		weapon_preview:set_weapon_position_normalized(weapon_x_scale, weapon_y_scale)

		local weapon_zoom_fraction = self._weapon_zoom_fraction or 1
		local use_custom_zoom = true
		local optional_node_name = "p_zoom"
		local optional_pos
		local min_zoom = self._min_zoom
		local max_zoom = self._max_zoom

		weapon_preview:set_weapon_zoom(weapon_zoom_fraction, use_custom_zoom, optional_node_name, optional_pos, min_zoom, max_zoom)
	end
end

InventoryWeaponDetailsView.on_back_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_details_view")
end

InventoryWeaponDetailsView.on_exit = function (self)
	self:_destroy_weapon_preview()
	self:_remove_element("weapon_info")
	self:_remove_element("weapon_actions_extended")
	self:_remove_element("attack_patterns")

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

	self:_destroy_offscreen_gui()
	InventoryWeaponDetailsView.super.on_exit(self)
end

InventoryWeaponDetailsView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale
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

InventoryWeaponDetailsView._handle_input = function (self, input_service, dt, t)
	local scroll_axis = input_service:get("scroll_axis")

	if scroll_axis then
		local scroll = scroll_axis[2]
		local scroll_speed = 0.25

		if InputDevice.gamepad_active then
			scroll = math.abs(scroll) > math.abs(scroll_axis[1]) and scroll or 0
			scroll_speed = 0.1
		end

		self._weapon_zoom_target = math.clamp(self._weapon_zoom_target + scroll * scroll_speed, self._min_zoom, self._max_zoom)

		if math.abs(self._weapon_zoom_target - self._weapon_zoom_fraction) > 0.01 then
			local weapon_zoom_fraction = math.lerp(self._weapon_zoom_fraction, self._weapon_zoom_target, dt * 2)

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

			ui_renderer = not (element_name == "ViewElementInventoryWeaponPreview" and element_name == "ViewElementInputLegend") and self._ui_default_renderer or ui_renderer
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
	self:_update_weapon_actions_extended_position()
	self:_update_weapon_info_position()
	self:_update_attack_patterns_position()
end

local EMPTY_TABLE = {}

function _scale_value_by_type(value, display_type)
	if display_type == "multiplier" then
		value = (value - 1) * 100
	elseif display_type == "inverse_multiplier" then
		value = (1 - 1 / value) * 100
	elseif display_type == "percentage" then
		value = value * 100
	end

	return value
end

function _value_to_text(value, is_signed)
	if is_signed and value >= 0 then
		return string.format("+%0.2f", value)
	end

	return string.format("%0.2f", value)
end

function _get_stats_text(stat)
	local override_data = stat.override_data or EMPTY_TABLE
	local type_data = stat.type_data
	local display_type = override_data.display_type or type_data.display_type
	local is_signed = type_data.signed
	local value = _scale_value_by_type(stat.value, display_type)
	local value_text = _value_to_text(value, is_signed)
	local min, max = stat.min, stat.max

	if min and max then
		min = _scale_value_by_type(min, display_type)
		max = _scale_value_by_type(max, display_type)
		value_text = string.format("%s [%s ; %s]", value_text, _value_to_text(min, is_signed), _value_to_text(max, is_signed))
	end

	local name = override_data.display_name or type_data.display_name
	local group_type_data = stat.group_type_data
	local prefix = group_type_data and group_type_data.prefix or ""
	local postfix = group_type_data and group_type_data.postfix or ""
	local display_units = override_data.display_units or type_data.display_units or ""
	local stat_text = string.format("%s %s %s: %s %s", prefix, name, postfix, value_text, display_units)

	return stat_text
end

InventoryWeaponDetailsView._draw_weapon_stats = function (self, ui_renderer, input_service)
	local weapon_stats = self._weapon_statistics
	local advanced_stats = weapon_stats and weapon_stats._weapon_statistics

	if not advanced_stats then
		return
	end

	local color = {
		255,
		255,
		255,
		255
	}
	local font_size = 18
	local font_type = "proxima_nova_bold"
	local text_options = {
		line_spacing = 1.2,
		horizontal_alignemt = 1,
		vertical_alignemnt = 1,
		shaodw = true
	}
	local box_size = {
		900,
		100
	}
	local position = Vector3(100, 100, 100)
	local row_height = 25
	local power_stats = advanced_stats.power_stats

	if power_stats then
		local attack_stats_y_offset = 50

		for i = 1, #power_stats do
			local stat = power_stats[i]

			position.y = attack_stats_y_offset + row_height * i

			local name = stat.type_data.display_name
			local attack_power = stat.attack
			local attack_power_text = string.format("%s: %.0f", name, attack_power)

			UIRenderer.draw_text(ui_renderer, attack_power_text, font_size, font_type, position, box_size, color, text_options)
		end
	end

	local damage_stats = advanced_stats.damage
	local hit_types = advanced_stats.hit_types

	if damage_stats then
		local damage_start_x = 100
		local armor_text_len = 200
		local damage_field_len = 150
		local damage_start_y = 150

		position.y = damage_start_y

		local num_attacks = #damage_stats
		local input = input_service:get("navigation_keys_virtual_axis")
		local attack_idx = math.clamp(self._attack_stats_idx + input[1], 1, num_attacks)

		self._attack_stats_idx = attack_idx

		local attack_data = damage_stats[attack_idx]

		if attack_data then
			local attack_type_data = attack_data.type_data
			local action_selector = string.format("%s (%d/%d)", attack_type_data.display_name, attack_idx, num_attacks)

			UIRenderer.draw_text(ui_renderer, action_selector, font_size, font_type, position, box_size, color, text_options)

			local attack_damage = attack_data.attack
			local impact_damage = attack_data.impact
			local attack_data_def = attack_type_data.attack
			local num_armor_types = #attack_data_def / 3
			local armor_idx = 1
			local damage_idx = 1

			position.x = damage_start_x + armor_text_len + damage_field_len

			UIRenderer.draw_text(ui_renderer, Localize(hit_types[1].display_name), font_size, font_type, position, box_size, color, text_options)

			position.x = damage_start_x + armor_text_len + damage_field_len * 2

			UIRenderer.draw_text(ui_renderer, Localize(hit_types[2].display_name), font_size, font_type, position, box_size, color, text_options)

			position.x = damage_start_x + armor_text_len + damage_field_len * 3

			UIRenderer.draw_text(ui_renderer, Localize(hit_types[3].display_name), font_size, font_type, position, box_size, color, text_options)

			position.x = damage_start_x + armor_text_len + damage_field_len * 4

			UIRenderer.draw_text(ui_renderer, Localize(hit_types[4].display_name), font_size, font_type, position, box_size, color, text_options)

			local idx = 1

			for i = 1, num_armor_types do
				local armor_type = attack_data_def[armor_idx]
				local body_dmg = attack_damage[damage_idx]
				local weakpoint_dmg = attack_damage[damage_idx + 1]
				local crit_dmg = attack_damage[damage_idx + 2]
				local weakpoint_crit_dmg = attack_damage[damage_idx + 3]
				local body_imp = impact_damage[damage_idx]
				local weakpoint_imp = impact_damage[damage_idx + 1]
				local crit_imp = impact_damage[damage_idx + 2]
				local weakpoint_crit_imp = impact_damage[damage_idx + 3]

				position.y = damage_start_y + i * row_height
				position.x = damage_start_x

				local armor_type_text = armor_type

				UIRenderer.draw_text(ui_renderer, armor_type_text, font_size, font_type, position, box_size, color, text_options)

				local x_offset = damage_start_x + armor_text_len

				position.x = x_offset + damage_field_len

				local body_hit_text = string.format("%.0f / %.0f" .. ": " .. idx, body_dmg, body_imp)

				UIRenderer.draw_text(ui_renderer, body_hit_text, font_size, font_type, position, box_size, color, text_options)

				idx = idx + 1
				position.x = x_offset + damage_field_len * 2

				local weakpoint_hit_text = string.format("%.0f / %.0f" .. ": " .. idx, weakpoint_dmg, weakpoint_imp)

				UIRenderer.draw_text(ui_renderer, weakpoint_hit_text, font_size, font_type, position, box_size, color, text_options)

				idx = idx + 1
				position.x = x_offset + damage_field_len * 3

				local crit_hit_text = string.format("%.0f / %.0f" .. ": " .. idx, crit_dmg, crit_imp)

				UIRenderer.draw_text(ui_renderer, crit_hit_text, font_size, font_type, position, box_size, color, text_options)

				idx = idx + 1
				position.x = x_offset + damage_field_len * 4

				local weakpoint_crit_hit_text = string.format("%.0f / %.0f" .. ": " .. idx, weakpoint_crit_dmg, weakpoint_crit_imp)

				UIRenderer.draw_text(ui_renderer, weakpoint_crit_hit_text, font_size, font_type, position, box_size, color, text_options)

				idx = idx + 1
				armor_idx = armor_idx + 3
				damage_idx = damage_idx + 4
			end

			local attack_stats = attack_data.action_stats

			position.x = damage_start_x

			local attack_stats_y_offset = position.y + row_height * 2

			position.y = attack_stats_y_offset

			UIRenderer.draw_text(ui_renderer, "Attack Stats", font_size, font_type, position, box_size, color, text_options)

			attack_stats_y_offset = position.y + row_height
			position.y = attack_stats_y_offset

			local attack_power = attack_damage.base_power
			local attack_power_text = string.format("attack power: %.0f", attack_power)

			UIRenderer.draw_text(ui_renderer, attack_power_text, font_size, font_type, position, box_size, color, text_options)

			attack_stats_y_offset = position.y + row_height
			position.y = attack_stats_y_offset

			local impact_power = impact_damage.base_power
			local impact_power_text = string.format("impact power: %.0f", impact_power)

			UIRenderer.draw_text(ui_renderer, impact_power_text, font_size, font_type, position, box_size, color, text_options)

			for i = 1, #attack_stats do
				local stat_field = attack_stats[i]
				local stat_text = _get_stats_text(stat_field)

				position.y = attack_stats_y_offset + row_height * i

				UIRenderer.draw_text(ui_renderer, stat_text, font_size, font_type, position, box_size, color, text_options)
			end
		end
	end

	local general_stats = advanced_stats.stats

	if general_stats then
		local stats_start_x = 1500
		local stats_start_y = 100

		position.x = stats_start_x
		position.y = stats_start_y

		UIRenderer.draw_text(ui_renderer, "Stats", font_size, font_type, position, box_size, color, text_options)

		for i = 1, #general_stats do
			local stat_field = general_stats[i]
			local stat_text = _get_stats_text(stat_field)

			position.y = stats_start_y + row_height * i

			UIRenderer.draw_text(ui_renderer, stat_text, font_size, font_type, position, box_size, color, text_options)
		end
	end

	local bar_stats_start_x = 700
	local bar_stats_start_y = 400

	position.x = bar_stats_start_x

	local bar_stat_y_offset = bar_stats_start_y

	position.y = bar_stat_y_offset

	local bar_breakdown_stats = advanced_stats.bar_breakdown

	if bar_breakdown_stats then
		for bar_idx = 1, #bar_breakdown_stats do
			local bar_data = bar_breakdown_stats[bar_idx]

			position.y = bar_stat_y_offset

			local bar_text = string.format("%s: %.0f%%", bar_data.display_name, bar_data.value * 100)

			UIRenderer.draw_text(ui_renderer, bar_text, font_size, font_type, position, box_size, color, text_options)

			for bar_affected_stat_idx = 1, #bar_data do
				local sub_stat = bar_data[bar_affected_stat_idx]
				local stat_text = _get_stats_text(sub_stat)

				bar_stat_y_offset = bar_stat_y_offset + row_height
				position.y = bar_stat_y_offset

				UIRenderer.draw_text(ui_renderer, stat_text, font_size, font_type, position, box_size, color, text_options)
			end

			bar_stat_y_offset = bar_stat_y_offset + row_height * 2
		end
	end
end

InventoryWeaponDetailsView._remove_element = function (self, reference_name)
	local elements = self._elements
	local element = elements[reference_name]
	local element_name = element.__class_name
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		if elements_array[i] == element then
			table.remove(elements_array, i)

			break
		end
	end

	local ui_renderer = not (element_name == "ViewElementInventoryWeaponPreview" and element_name == "ViewElementInputLegend") and self._ui_default_renderer or self._ui_renderer

	element:destroy(ui_renderer)

	elements[reference_name] = nil
end

return InventoryWeaponDetailsView
