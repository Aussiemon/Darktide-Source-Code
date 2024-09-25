-- chunkname: @scripts/ui/view_elements/view_element_expertise_stats/view_element_expertise_stats.lua

local ViewElementExpertiseStatsBlueprints = require("scripts/ui/view_elements/view_element_expertise_stats/view_element_expertise_stats_blueprints")
local ViewElementExpertiseStatsDefinitions = require("scripts/ui/view_elements/view_element_expertise_stats/view_element_expertise_stats_definitions")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local WeaponStats = require("scripts/utilities/weapon_stats")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local ItemUtils = require("scripts/utilities/items")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementExpertiseStats = class("ViewElementExpertiseStats", "ViewElementGrid")

ViewElementExpertiseStats.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	self._reference_name = "ViewElementExpertiseStats_" .. tostring(self)

	local definitions = ViewElementExpertiseStatsDefinitions

	ViewElementExpertiseStats.super.init(self, parent, draw_layer, start_scale, definitions.menu_settings, definitions)
	self:present_grid_layout({}, ViewElementExpertiseStatsBlueprints)

	self._ui_animations = {}
	self._alpha_multiplier = optional_menu_settings and optional_menu_settings.do_animations and 0 or 1
	self._do_animations = optional_menu_settings and optional_menu_settings.do_animations
	self._active = not self._do_animations
end

ViewElementExpertiseStats.destroy = function (self, ui_renderer)
	ViewElementExpertiseStats.super.destroy(self, ui_renderer)
end

ViewElementExpertiseStats.show_overlay = function (self, show)
	local widget = self._widgets_by_name.overlay
	local style = widget.style
	local color = style.overlay.color
	local ui_scenegraph = self._ui_scenegraph
	local func = UIAnimation.function_by_time
	local target = color
	local target_index = 1
	local from = color[1]
	local to = show and 128 or 0
	local duration = 0.5
	local easing = math.easeOutCubic

	self._ui_animations.pivot = UIAnimation.init(func, target, target_index, from, to, duration, easing)
end

ViewElementExpertiseStats.start_animation = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local func = UIAnimation.function_by_time
	local target = ui_scenegraph.pivot.local_position
	local target_index = 1
	local from = self._pivot_offset[1] - 500
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

ViewElementExpertiseStats.set_alpha_multiplier = function (self, alpha_multiplier)
	self._alpha_multiplier = alpha_multiplier or 0
end

ViewElementExpertiseStats.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local old_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._active and self._alpha_multiplier or 0

	render_settings.alpha_multiplier = render_settings.alpha_multiplier * alpha_multiplier

	ViewElementExpertiseStats.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = old_alpha_multiplier

	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer
end

ViewElementExpertiseStats._update_animations = function (self, dt, t)
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

ViewElementExpertiseStats.update = function (self, dt, t, input_service)
	ViewElementExpertiseStats.super.update(self, dt, t, input_service)
end

ViewElementExpertiseStats._handle_input = function (self, dt, t, input_service)
	return
end

ViewElementExpertiseStats._verify_weapon = function (self, item)
	if not item then
		return false
	end

	local weapon_template = WeaponTemplate.weapon_template_from_item(item)

	if not weapon_template then
		return false
	end

	local displayed_attacks = weapon_template.displayed_attacks

	if not displayed_attacks then
		return false
	end

	return true
end

ViewElementExpertiseStats.present = function (self, item, expertise_data)
	local item_type = item.item_type
	local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"

	if is_weapon and not self:_verify_weapon(item) then
		return
	end

	self:_present(item, expertise_data)
end

ViewElementExpertiseStats._present = function (self, item, expertise_data)
	self._expertise_data = expertise_data
	self._selected_item = item

	local layout = {}

	self:_add_stats_to_layout(item, layout)

	local on_present_callback = callback(self, "_cb_present_grid_layout")

	self:present_grid_layout(layout, ViewElementExpertiseStatsBlueprints, nil, nil, nil, nil, on_present_callback)
	self:_update_modification_cap(true)
end

ViewElementExpertiseStats._add_stats_to_layout = function (self, item, layout)
	local weapon_stats = WeaponStats:new(item)
	local comparing_stats = weapon_stats:get_comparing_stats()
	local item_base_stats = item.base_stats
	local num_stats = table.size(comparing_stats)
	local comparing_stats_array = {}
	local index = 0

	for key, stat in pairs(comparing_stats) do
		index = index + 1
		comparing_stats_array[index] = stat
	end

	local budget = self._expertise_data.max - self._expertise_data.start
	local stats = comparing_stats_array
	local stats_result = ItemUtils.preview_stats_change(item, budget, stats)
	local sort_order = {
		1,
		5,
		3,
		4,
		2,
	}

	for i = 1, num_stats do
		local order = sort_order[i]
		local stat_data = comparing_stats_array[order]
		local max_stat = stats_result[stat_data.display_name]

		layout[#layout + 1] = {
			widget_type = "stat",
			item = item,
			stat_data = stat_data,
			max_stat = max_stat,
		}
		layout[#layout + 1] = {
			widget_type = "spacing_vertical_small",
		}
	end
end

ViewElementExpertiseStats._cb_present_grid_layout = function (self)
	return
end

ViewElementExpertiseStats._on_navigation_input_changed = function (self)
	ViewElementExpertiseStats.super._on_navigation_input_changed(self)
end

ViewElementExpertiseStats.update_preview_values = function (self, expertise_data)
	local value = expertise_data and expertise_data.current

	if not value or value < 0 then
		return
	end

	self._expertise_data = expertise_data

	self:_update_modification_cap()
end

ViewElementExpertiseStats._update_modification_cap = function (self, use_start)
	local expertise_value = use_start and self._expertise_data.start or self._expertise_data.current
	local new_modification_value = ItemUtils.get_weapon_modification_cap(expertise_value)
	local item_modifications = ItemUtils.modifications_by_item(self._selected_item)

	if item_modifications.max_modifications == new_modification_value then
		self._widgets_by_name.trait_info_box_contents.content.modification_cap = string.format(" %d", item_modifications.max_modifications)
	else
		self._widgets_by_name.trait_info_box_contents.content.modification_cap = string.format(" %d to %d", item_modifications.max_modifications, new_modification_value)
	end
end

return ViewElementExpertiseStats
