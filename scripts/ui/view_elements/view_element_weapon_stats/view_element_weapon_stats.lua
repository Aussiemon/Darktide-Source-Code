local Definitions = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats_definitions")
local MasterItems = require("scripts/backend/master_items")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local ViewElementWeaponStats = class("ViewElementWeaponStats", "ViewElementGrid")

ViewElementWeaponStats.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name
	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	ViewElementWeaponStats.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, Definitions)

	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local world_layer = menu_settings.world_layer
	local viewport_layer = menu_settings.viewport_layer
	self._default_grid_size = table.clone(grid_size)
	self._default_mask_size = table.clone(mask_size)
	local weapons_render_settings = {
		viewport_type = "default_with_alpha",
		weapon_height = 200,
		target_resolution_height = 800,
		viewport_name = "weapon_viewport",
		level_name = "content/levels/ui/weapon_icon/weapon_icon",
		shading_environment = "content/shading_environments/ui/weapon_icons",
		timer_name = "ui",
		weapon_width = grid_size[1],
		target_resolution_width = grid_size[1] * 4,
		world_name = self._unique_id .. "_stat_icon_world",
		world_layer = world_layer or 800,
		viewport_layer = viewport_layer or 900
	}
	self._weapon_icon_renderer = WeaponIconUI:new(weapons_render_settings)
end

ViewElementWeaponStats.destroy = function (self)
	ViewElementWeaponStats.super.destroy(self)

	if self._weapon_icon_renderer then
		self._weapon_icon_renderer:destroy()

		self._weapon_icon_renderer = nil
	end
end

ViewElementWeaponStats.present_item = function (self, item)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local item_name = item.name
	local item_type = item.item_type
	local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"
	local add_end_margin = true
	local layout = {
		[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10
			}
		}
	}

	if is_weapon then
		layout[#layout + 1] = {
			widget_type = "weapon_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "weapon_keywords",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "weapon_stats",
			item = item
		}
	elseif item_type == "GADGET" then
		layout[#layout + 1] = {
			widget_type = "gadget_header",
			item = item
		}
	elseif item_type == "PORTRAIT_FRAME" then
		layout[#layout + 1] = {
			widget_type = "portrait_frame_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "description",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30
			}
		}
	elseif item_type == "CHARACTER_INSIGNIA" then
		layout[#layout + 1] = {
			widget_type = "insignia_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "description",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30
			}
		}
	end

	local perks = item.perks
	local num_perks = perks and #perks or 0

	if num_perks > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				5
			}
		}
		add_end_margin = true
	end

	for i = 1, num_perks do
		local perk = perks[i]
		local perk_id = perk.id
		local perk_value = perk.value
		local perk_rarity = perk.rarity
		local perk_item = MasterItems.get_item(perk_id)
		layout[#layout + 1] = {
			widget_type = "weapon_perk",
			perk_item = perk_item,
			perk_value = perk_value,
			perk_rarity = perk_rarity
		}

		if i < num_perks then
			-- Nothing
		end
	end

	local traits = item.traits
	local num_traits = traits and #traits or 0

	if num_traits > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				20
			}
		}
		add_end_margin = true
	end

	for i = 1, num_traits do
		local trait = traits[i]
		local trait_id = trait.id
		local trait_value = trait.value
		local trait_rarity = trait.rarity
		local trait_item = MasterItems.get_item(trait_id)

		if trait_item then
			layout[#layout + 1] = {
				widget_type = "weapon_trait",
				trait_item = trait_item,
				trait_value = trait_value,
				trait_rarity = trait_rarity
			}

			if i < num_traits then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						16
					}
				}
			end
		end
	end

	if add_end_margin then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30
			}
		}
	end

	self:present_grid_layout(layout)
end

ViewElementWeaponStats.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()
end

ViewElementWeaponStats.present_grid_layout = function (self, layout)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_stats_blueprints")
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local ContentBlueprints = generate_blueprints_function(grid_size)
	local default_grid_height = self._default_grid_size[2]
	grid_size[2] = default_grid_height
	mask_size[2] = default_grid_height

	self:force_update_list_size()

	local grow_direction = self._grow_direction or "down"

	ViewElementWeaponStats.super.present_grid_layout(self, layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction)
end

ViewElementWeaponStats._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementWeaponStats.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 30
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])
	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
end

ViewElementWeaponStats.update = function (self, dt, t, input_service)
	if self._weapon_icon_renderer then
		self._weapon_icon_renderer:update(dt, t)
	end

	return ViewElementWeaponStats.super.update(self, dt, t, input_service)
end

ViewElementWeaponStats.load_item_icon = function (self, item, cb, render_context)
	local item_name = item.name
	local gear_id = item.gear_id or item_name
	local item_type = item.item_type
	local weapon_icon_renderer = self._weapon_icon_renderer

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		return weapon_icon_renderer:load_weapon_icon(item, cb, render_context)
	end
end

ViewElementWeaponStats.unload_item_icon = function (self, id)
	local weapon_icon_renderer = self._weapon_icon_renderer

	if weapon_icon_renderer:has_request(id) then
		weapon_icon_renderer:unload_weapon_icon(id)
	end
end

ViewElementWeaponStats.item_icon_updated = function (self, peer_id, local_player_id, item)
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		local weapon_icon_renderer = self._weapon_icon_renderer

		weapon_icon_renderer:weapon_icon_updated(item)
	end
end

return ViewElementWeaponStats
