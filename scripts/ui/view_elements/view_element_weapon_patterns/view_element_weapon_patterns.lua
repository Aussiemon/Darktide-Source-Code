-- chunkname: @scripts/ui/view_elements/view_element_weapon_patterns/view_element_weapon_patterns.lua

local Definitions = require("scripts/ui/view_elements/view_element_weapon_patterns/view_element_weapon_patterns_definitions")
local MasterItems = require("scripts/backend/master_items")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Item = require("scripts/utilities/items")
local UIAnimation = require("scripts/managers/ui/ui_animation")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementWeaponPatterns = class("ViewElementWeaponPatterns", "ViewElementGrid")

ViewElementWeaponPatterns.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	ViewElementWeaponPatterns.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, Definitions)

	local menu_settings = self._menu_settings

	self._default_grid_size = table.clone(menu_settings.grid_size)
	self._default_mask_size = table.clone(menu_settings.mask_size)
	self._current_attack_index = 1
	self._chain_index = 1
	self._ui_animations = {}
	self._alpha_multiplier = 1

	self:_hide_dividers()
end

ViewElementWeaponPatterns._hide_dividers = function (self)
	local grid_divider_top = self:widget_by_name("grid_divider_top")

	grid_divider_top.style.texture.color[1] = 0

	local grid_divider_bottom = self:widget_by_name("grid_divider_bottom")

	grid_divider_bottom.style.texture.color[1] = 0

	local grid_divider_title = self:widget_by_name("grid_divider_title")

	grid_divider_title.style.texture.color[1] = 0
end

ViewElementWeaponPatterns.present_item = function (self, item)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local layout = {
		{
			widget_type = "attack_pattern_header",
			item = item
		},
		{
			widget_type = "pattern_type_breakdown",
			item = item
		},
		{
			widget_type = "damage_grid",
			item = item
		}
	}

	self:present_grid_layout(layout, item)
end

ViewElementWeaponPatterns.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()
end

ViewElementWeaponPatterns.present_grid_layout = function (self, layout, item)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_stats_blueprints")
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local ContentBlueprints = generate_blueprints_function(grid_size, item)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local default_grid_height = self._default_grid_size[2]

	grid_size[2] = default_grid_height
	mask_size[2] = default_grid_height

	self:force_update_list_size()

	local grow_direction = self._grow_direction or "down"

	ViewElementWeaponPatterns.super.present_grid_layout(self, layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction)
end

ViewElementWeaponPatterns._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementWeaponPatterns.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 40
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])

	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
end

ViewElementWeaponPatterns.current_attack_index = function (self)
	return self._current_attack_index, self._chain_index
end

ViewElementWeaponPatterns.set_current_attack_index = function (self, attack_index, chain_index)
	self._current_attack_index = attack_index
	self._chain_index = chain_index
end

ViewElementWeaponPatterns.is_active = function (self)
	return self._active
end

ViewElementWeaponPatterns.set_active = function (self, active)
	self._active = active

	if active then
		local ui_scenegraph = self._ui_scenegraph
		local func = UIAnimation.function_by_time
		local target = ui_scenegraph.pivot.local_position
		local target_index = 1
		local from = self._pivot_offset[1] + 200
		local to = self._pivot_offset[1]
		local duration = 0.5
		local easing = math.easeOutCubic

		self._ui_animations.pivot = UIAnimation.init(func, target, target_index, from, to, duration, easing)

		local func = UIAnimation.function_by_time
		local target = self
		local target_index = "_alpha_multiplier"
		local from = 0
		local to = 1
		local duration = 0.5
		local easing = math.easeInCubic

		self._ui_animations.alpha_multiplier = UIAnimation.init(func, target, target_index, from, to, duration, easing)
	end
end

ViewElementWeaponPatterns.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._active then
		render_settings.alpha_multiplier = render_settings.alpha_multiplier * self._alpha_multiplier

		ViewElementWeaponPatterns.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	end
end

ViewElementWeaponPatterns.update = function (self, dt, t, input_service)
	self:_update_animations(dt, t)

	return ViewElementWeaponPatterns.super.update(self, dt, t, input_service)
end

ViewElementWeaponPatterns._update_animations = function (self, dt, t)
	local ui_animations = self._ui_animations

	for key, ui_animation in pairs(ui_animations) do
		UIAnimation.update(ui_animation, dt)

		if UIAnimation.completed(ui_animation) then
			ui_animations[key] = nil
		end
	end

	if self._ui_animations.pivot then
		self._update_scenegraph = true
	end
end

return ViewElementWeaponPatterns
