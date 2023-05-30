local Definitions = require("scripts/ui/view_elements/view_element_weapon_actions/view_element_weapon_actions_definitions")
local MasterItems = require("scripts/backend/master_items")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Item = require("scripts/utilities/items")
local ViewElementWeaponActions = class("ViewElementWeaponActions", "ViewElementGrid")

ViewElementWeaponActions.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name
	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	ViewElementWeaponActions.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, Definitions)

	local menu_settings = self._menu_settings
	self._default_grid_size = table.clone(menu_settings.grid_size)
	self._default_mask_size = table.clone(menu_settings.mask_size)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local weapons_render_settings = {
		timer_name = "ui",
		height = 800,
		world_layer = 800,
		shading_environment = "content/shading_environments/ui/weapon_icons",
		viewport_type = "default_with_alpha",
		viewport_name = "weapon_viewport",
		viewport_layer = 900,
		level_name = "content/levels/ui/weapon_icon/weapon_icon",
		width = grid_size[1] * 4,
		world_name = self._unique_id
	}
	local icon_render_type = "weapon"
	self._weapon_icon_renderer_id = "ViewElementWeaponActions_" .. math.uuid()
	self._weapon_icon_renderer = Managers.ui:create_single_icon_renderer(icon_render_type, self._weapon_icon_renderer_id, weapons_render_settings)

	self:_hide_dividers()
end

ViewElementWeaponActions._hide_dividers = function (self)
	local grid_divider_top = self:widget_by_name("grid_divider_top")
	grid_divider_top.style.texture.color[1] = 0
	local grid_divider_bottom = self:widget_by_name("grid_divider_bottom")
	grid_divider_bottom.style.texture.color[1] = 0
	local grid_divider_title = self:widget_by_name("grid_divider_title")
	grid_divider_title.style.texture.color[1] = 0
end

ViewElementWeaponActions.destroy = function (self)
	ViewElementWeaponActions.super.destroy(self)

	if self._weapon_icon_renderer then
		self._weapon_icon_renderer = nil

		Managers.ui:destroy_single_icon_renderer(self._weapon_icon_renderer_id)

		self._weapon_icon_renderer_id = nil
	end
end

ViewElementWeaponActions.present_item = function (self, item)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local layout = {
		{
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10
			}
		},
		{
			widget_type = "description",
			item = item
		}
	}
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local displayed_attacks = weapon_template.displayed_attacks
	local is_ranged_weapon = Item.is_weapon_template_ranged(item)

	if displayed_attacks then
		local weapon_action_title_display_names = is_ranged_weapon and UISettings.weapon_action_title_display_names or UISettings.weapon_action_title_display_names_melee
		local weapon_action_display_order_array = UISettings.weapon_action_display_order_array
		local add_start_spacing = true

		for index, key in ipairs(weapon_action_display_order_array) do
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
					display_name = title_loc_key
				}

				if is_ranged_weapon then
					layout[#layout + 1] = {
						widget_type = "weapon_attack_info_ranged",
						data = data
					}
				else
					layout[#layout + 1] = {
						widget_type = "weapon_attack_info",
						data = data
					}
				end

				if data.attack_chain then
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

				if index < #weapon_action_display_order_array then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							30
						}
					}
				end
			end
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

ViewElementWeaponActions.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()
end

ViewElementWeaponActions.present_grid_layout = function (self, layout)
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

	ViewElementWeaponActions.super.present_grid_layout(self, layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction)
end

ViewElementWeaponActions._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementWeaponActions.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 40
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])
	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
end

ViewElementWeaponActions.update = function (self, dt, t, input_service)
	if self._weapon_icon_renderer then
		self._weapon_icon_renderer:update(dt, t)
	end

	return ViewElementWeaponActions.super.update(self, dt, t, input_service)
end

ViewElementWeaponActions.load_item_icon = function (self, item, cb, render_context)
	local item_name = item.name
	local gear_id = item.gear_id or item_name
	local item_type = item.item_type
	local weapon_icon_renderer = self._weapon_icon_renderer

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		return weapon_icon_renderer:load_weapon_icon(item, cb, render_context)
	end
end

ViewElementWeaponActions.unload_item_icon = function (self, id)
	local weapon_icon_renderer = self._weapon_icon_renderer

	if weapon_icon_renderer:has_request(id) then
		weapon_icon_renderer:unload_weapon_icon(id)
	end
end

ViewElementWeaponActions.item_icon_updated = function (self, peer_id, local_player_id, item)
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		local weapon_icon_renderer = self._weapon_icon_renderer

		weapon_icon_renderer:weapon_icon_updated(item)
	end
end

return ViewElementWeaponActions
