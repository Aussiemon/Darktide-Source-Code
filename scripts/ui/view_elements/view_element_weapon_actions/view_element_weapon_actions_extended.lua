-- chunkname: @scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions_extended.lua

local Definitions = require("scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions_extended_definitions")
local MasterItems = require("scripts/backend/master_items")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Item = require("scripts/utilities/items")
local WeaponStats = require("scripts/utilities/weapon_stats")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local ViewElementWeaponActionsExtended = class("ViewElementWeaponActionsExtended", "ViewElementGrid")

ViewElementWeaponActionsExtended.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	ViewElementWeaponActionsExtended.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, Definitions)

	local menu_settings = self._menu_settings

	self._default_grid_size = table.clone(menu_settings.grid_size)
	self._default_mask_size = table.clone(menu_settings.mask_size)

	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size

	self._ui_animations = {}
	self._alpha_multiplier = 1

	self:_hide_dividers()
end

ViewElementWeaponActionsExtended._hide_dividers = function (self)
	local grid_divider_top = self:widget_by_name("grid_divider_top")

	grid_divider_top.style.texture.color[1] = 0

	local grid_divider_bottom = self:widget_by_name("grid_divider_bottom")

	grid_divider_bottom.style.texture.color[1] = 0

	local grid_divider_title = self:widget_by_name("grid_divider_title")

	grid_divider_title.style.texture.color[1] = 0
end

local EMPTY_TABLE = {}

ViewElementWeaponActionsExtended.present_item = function (self, item)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local layout = {
		{
			widget_type = "header",
			header = Localize("loc_item_information_actions")
		},
		{
			widget_type = "divider"
		},
		{
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10
			}
		}
	}
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local displayed_attacks = weapon_template.displayed_attacks
	local is_ranged_weapon = Item.is_weapon_template_ranged(item)

	if displayed_attacks then
		local weapon_action_title_display_names = is_ranged_weapon and UISettings.weapon_action_title_display_names or UISettings.weapon_action_title_display_names_melee
		local weapon_action_extended_display_order_array = UISettings.weapon_action_extended_display_order_array
		local add_start_spacing = false

		for index, key in ipairs(weapon_action_extended_display_order_array) do
			local data = displayed_attacks[key]

			if data then
				if add_start_spacing then
					add_start_spacing = false
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							30
						}
					}
				end

				local title_loc_key = weapon_action_title_display_names[key]

				layout[#layout + 1] = {
					widget_type = "weapon_attack_header",
					display_name = title_loc_key,
					text_color = key ~= "special" and Color.terminal_text_body_dark(255, true)
				}

				if is_ranged_weapon then
					layout[#layout + 1] = {
						widget_type = "weapon_attack_info_ranged",
						data = data
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							10
						}
					}

					if key == "special" then
						layout[#layout + 1] = {
							widget_type = "special_description",
							data = data,
							item = item
						}
						layout[#layout + 1] = {
							widget_type = "dynamic_spacing",
							size = {
								grid_size[1],
								20
							}
						}
						layout[#layout + 1] = {
							widget_type = "divider"
						}
						layout[#layout + 1] = {
							display_name = "loc_weapon_stats_display_attack_chains",
							widget_type = "weapon_attack_header"
						}
					end
				elseif key == "special" then
					layout[#layout + 1] = {
						widget_type = "weapon_attack_info",
						data = data
					}
					layout[#layout + 1] = {
						widget_type = "special_description",
						data = data,
						item = item
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							20
						}
					}
					layout[#layout + 1] = {
						widget_type = "divider"
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							10
						}
					}
					layout[#layout + 1] = {
						display_name = "loc_weapon_stats_display_attack_chains",
						widget_type = "weapon_attack_header"
					}
				end

				if data.attack_chain and not data.skipp_display then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							10
						}
					}
					layout[#layout + 1] = {
						widget_type = "weapon_attack_chain",
						attack_chain = data.attack_chain
					}
				end

				if index < #weapon_action_extended_display_order_array then
					-- Nothing
				end
			end
		end
	end

	layout[#layout + 1] = {
		widget_type = "divider"
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10
		}
	}
	layout[#layout + 1] = {
		display_name = "loc_item_weapon_description_additional_data_name",
		widget_type = "weapon_attack_header"
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10
		}
	}

	local weapon_stats = WeaponStats:new(item)
	local advanced_weapon_stats = weapon_stats._weapon_statistics
	local stats = advanced_weapon_stats.stats or EMPTY_TABLE

	for i = 1, #stats do
		local stat = stats[i]

		if stat.value ~= 0 then
			layout[#layout + 1] = {
				widget_type = "weapon_stat",
				stat = stat
			}
		end
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10
		}
	}

	self:present_grid_layout(layout)
end

ViewElementWeaponActionsExtended.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()
end

ViewElementWeaponActionsExtended.present_grid_layout = function (self, layout)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_stats_blueprints")
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local ContentBlueprints = generate_blueprints_function(grid_size)
	local spacing_entry = {
		widget_type = "spacing_vertical_small"
	}
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local default_grid_height = self._default_grid_size[2]

	grid_size[2] = default_grid_height
	mask_size[2] = default_grid_height

	self:force_update_list_size()

	local grow_direction = self._grow_direction or "down"

	ViewElementWeaponActionsExtended.super.present_grid_layout(self, layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction)
end

ViewElementWeaponActionsExtended._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementWeaponActionsExtended.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 40
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])

	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
end

ViewElementWeaponActionsExtended.set_active = function (self, active)
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

ViewElementWeaponActionsExtended.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._active then
		render_settings.alpha_multiplier = render_settings.alpha_multiplier * self._alpha_multiplier

		ViewElementWeaponActionsExtended.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	end
end

ViewElementWeaponActionsExtended.update = function (self, dt, t, input_service)
	self:_update_animations(dt, t)

	return ViewElementWeaponActionsExtended.super.update(self, dt, t, input_service)
end

ViewElementWeaponActionsExtended._update_animations = function (self, dt, t)
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

return ViewElementWeaponActionsExtended
