-- chunkname: @scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats.lua

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local _create_definitions_function = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats_definitions")
local ViewElementWeaponStats = class("ViewElementWeaponStats", "ViewElementGrid")

ViewElementWeaponStats.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	local definitions = _create_definitions_function(optional_menu_settings)

	ViewElementWeaponStats.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, definitions)

	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size

	self._default_grid_size = table.clone(grid_size)
	self._default_mask_size = table.clone(mask_size)
end

ViewElementWeaponStats.destroy = function (self, ui_renderer)
	ViewElementWeaponStats.super.destroy(self, ui_renderer)
end

local function _add_presentation_perks(item, layout, grid_size)
	local item_type = item.item_type
	local perks = item.perks
	local num_perks = perks and #perks or 0
	local add_end_margin = false

	if num_perks > 0 then
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}
		add_end_margin = true

		local rating = item.override_perk_rating_string or Items.item_perk_rating(item)

		layout[#layout + 1] = {
			widget_type = "rating_info",
			rating = rating,
			header = Localize("loc_item_type_perk"),
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				40,
			},
		}
	end

	for ii = 1, num_perks do
		local perk = perks[ii]
		local perk_id = perk.id
		local perk_value = perk.value
		local perk_rarity = perk.rarity
		local perk_item = MasterItems.get_item(perk_id)

		if perk_item then
			local is_locked = false
			local is_modified = false
			local show_glow = perk.is_fake
			local is_gadget = item_type == "GADGET"

			layout[#layout + 1] = {
				widget_type = "weapon_perk",
				is_gadget = is_gadget,
				perk_item = perk_item,
				perk_value = perk_value,
				perk_rarity = perk_rarity,
				perk_index = ii,
				show_glow = show_glow,
				is_locked = is_locked,
				is_modified = is_modified,
			}

			if ii < num_perks then
				layout[#layout + 1] = {
					add_background = false,
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						8,
					},
				}
			end
		end
	end

	if num_perks > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
	end

	return add_end_margin
end

local function _add_presentation_traits(item, layout, grid_size)
	local item_type = item.item_type
	local is_gadget = item_type == "GADGET"
	local add_end_margin = false
	local traits = item.traits
	local num_traits = traits and #traits or 0

	if num_traits > 0 then
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}

		local rating = item.override_trait_rating_string or Items.item_trait_rating(item)

		layout[#layout + 1] = {
			widget_type = "rating_info",
			rating = rating,
			header = Localize("loc_weapon_inventory_traits_title_text"),
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				40,
			},
		}
		add_end_margin = true
	end

	for ii = 1, num_traits do
		local trait = traits[ii]
		local trait_id = trait.id
		local trait_value = trait.value
		local trait_rarity = trait.rarity
		local trait_category = (item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED") and Items.trait_category(item)
		local trait_item = MasterItems.get_item(trait_id)

		if trait_item then
			local widget_type = is_gadget and "gadget_trait" or "weapon_trait"
			local is_locked = false
			local is_modified = false
			local show_glow = trait.is_fake

			layout[#layout + 1] = {
				add_background = true,
				widget_type = widget_type,
				trait_item = trait_item,
				trait_value = trait_value,
				trait_rarity = trait_rarity,
				trait_index = ii,
				show_glow = show_glow,
				is_locked = is_locked,
				is_modified = is_modified,
				trait_category = trait_category,
			}

			if ii < num_traits then
				layout[#layout + 1] = {
					add_background = true,
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						8,
					},
				}
			end
		end
	end

	if num_traits > 0 then
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
	end

	return add_end_margin
end

ViewElementWeaponStats._verify_weapon = function (self, item)
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

ViewElementWeaponStats.present_item = function (self, item, context, on_present_callback)
	local present_equip_label_equipped = context and context.present_equip_label_equipped
	local inventory_items = context and context.inventory_items
	local hide_source = context and context.hide_source
	local profile = context and context.profile
	local hide_description = context and context.hide_description
	local show_requirement = context and context.show_requirement
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local item_name = item.name
	local item_type = item.item_type
	local is_weapon = Items.is_weapon(item_type)
	local is_gadget = Items.is_gadget(item_type)

	if is_weapon and not self:_verify_weapon(item) then
		return
	end

	local add_end_margin = true
	local layout = {}

	local function is_inventory_item()
		if inventory_items then
			for _, inventory_item in pairs(inventory_items) do
				if item.name == inventory_item.name then
					return true
				end
			end
		end

		return false
	end

	local function add_unlock_reason()
		if hide_source then
			return
		end

		local obtained_display_name = Items.obtained_display_name(item)

		if obtained_display_name then
			local unlocked = is_inventory_item()

			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20,
				},
			}
			layout[#layout + 1] = {
				widget_type = "obtained_header",
			}
			layout[#layout + 1] = {
				widget_type = "obtained_label",
				label = obtained_display_name,
				unlocked = unlocked,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20,
				},
			}
		end
	end

	if is_weapon then
		layout[#layout + 1] = {
			widget_type = "weapon_header",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "weapon_attack_data",
			item = item,
			size = {
				grid_size[1],
				75,
			},
		}
		layout[#layout + 1] = {
			widget_type = "weapon_keywords",
			item = item,
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				15,
			},
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "weapon_stats",
			item = item,
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				15,
			},
		}
		add_end_margin = false

		if _add_presentation_perks(item, layout, grid_size) then
			add_end_margin = false
		end

		if _add_presentation_traits(item, layout, grid_size) then
			add_end_margin = false
		end
	elseif item_type == "GADGET" then
		layout[#layout + 1] = {
			widget_type = "gadget_header",
			item = item,
		}

		if _add_presentation_traits(item, layout, grid_size) then
			add_end_margin = false
		end

		if _add_presentation_perks(item, layout, grid_size) then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					5,
				},
			}
			add_end_margin = false
		end
	elseif item_type == "WEAPON_SKIN" then
		local visual_item = Items.weapon_skin_preview_item(item)

		if visual_item then
			layout[#layout + 1] = {
				widget_type = "item_header",
				item = item,
				visual_item = visual_item,
			}
			layout[#layout + 1] = {
				widget_type = "divider_line",
			}
			layout[#layout + 1] = {
				widget_type = "weapon_skin_icon",
				item = item,
				visual_item = visual_item,
			}
			layout[#layout + 1] = {
				widget_type = "divider_line",
			}

			if show_requirement and Items.weapon_skin_requirement_text(item) ~= "" then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						20,
					},
				}
				layout[#layout + 1] = {
					widget_type = "weapon_skin_requirement_header",
					item = item,
					visual_item = visual_item,
				}
				layout[#layout + 1] = {
					widget_type = "weapon_skin_requirements",
					item = item,
					visual_item = visual_item,
				}
			end

			if item.description and item.description ~= "" and not hide_description then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						30,
					},
				}
				layout[#layout + 1] = {
					widget_type = "description",
					item = item,
				}
			end

			layout[#layout + 1] = {
				add_background = false,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30,
				},
			}

			add_unlock_reason()

			add_end_margin = false
		else
			add_end_margin = false
		end
	elseif item_type == "WEAPON_TRINKET" then
		local visual_item = Items.weapon_trinket_preview_item(item)

		if visual_item then
			layout[#layout + 1] = {
				widget_type = "item_header",
				item = item,
				visual_item = visual_item,
			}
			layout[#layout + 1] = {
				widget_type = "divider_line",
			}
			layout[#layout + 1] = {
				widget_type = "weapon_skin_icon",
				item = item,
				visual_item = visual_item,
			}

			if item.description and item.description ~= "" and not hide_description then
				layout[#layout + 1] = {
					widget_type = "description",
					item = item,
				}
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						30,
					},
				}
				layout[#layout + 1] = {
					widget_type = "divider_line",
				}
			end

			add_unlock_reason()

			add_end_margin = false
		else
			add_end_margin = false
		end
	elseif item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_HEAD" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND" or item_type == "COMPANION_GEAR_FULL" then
		layout[#layout + 1] = {
			add_background_shadow = true,
			widget_type = "item_header",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "cosmetic_gear_icon",
			item = item,
			profile = profile,
		}
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}

		if show_requirement and Items.class_requirement_text(item) ~= "" then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20,
				},
			}
			layout[#layout + 1] = {
				widget_type = "gear_requirement_header",
				item = item,
			}
			layout[#layout + 1] = {
				widget_type = "gear_requirements",
				item = item,
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20,
				},
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "PORTRAIT_FRAME" then
		layout[#layout + 1] = {
			add_background_shadow = true,
			widget_type = "item_header",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "portrait_frame",
			item = item,
		}

		if item.description and item.description ~= "" and not hide_description then
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "description",
				item = item,
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "divider_line",
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "CHARACTER_INSIGNIA" then
		layout[#layout + 1] = {
			add_background_shadow = true,
			widget_type = "item_header",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "insignia",
			item = item,
			profile = profile,
		}

		if item.description and item.description ~= "" and not hide_description then
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "description",
				item = item,
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "divider_line",
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "EMOTE" then
		layout[#layout + 1] = {
			add_background_shadow = true,
			widget_type = "item_header",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "emote",
			item = item,
			profile = profile,
		}

		if item.description and item.description ~= "" and not hide_description then
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "description",
				item = item,
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "divider_line",
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "CHARACTER_TITLE" then
		layout[#layout + 1] = {
			widget_type = "character_title_header",
			item = item,
			profile = profile,
		}
		layout[#layout + 1] = {
			widget_type = "divider_line",
		}

		if item.description and item.description ~= "" and not hide_description then
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "description",
				item = item,
			}
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "divider_line",
			}
		end

		add_unlock_reason()

		add_end_margin = false
	end

	if add_end_margin then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30,
			},
		}
	end

	if present_equip_label_equipped then
		layout[#layout + 1] = {
			widget_type = "equipped",
			item = item,
		}
	end

	local widgets_by_name = self._widgets_by_name
	local grid_divider_top = widgets_by_name.grid_divider_top
	local grid_divider_bottom = widgets_by_name.grid_divider_bottom

	grid_divider_top.visible = not is_weapon and not is_gadget
	grid_divider_bottom.visible = not is_weapon and not is_gadget

	local grid_divider_top_weapon = widgets_by_name.grid_divider_top_weapon
	local grid_divider_bottom_weapon = widgets_by_name.grid_divider_bottom_weapon

	grid_divider_top_weapon.visible = is_weapon or is_gadget
	grid_divider_bottom_weapon.visible = is_weapon or is_gadget

	if is_weapon then
		local rating_value, has_rating = Items.expertise_level(item)

		grid_divider_top_weapon.content.rating_value = has_rating and rating_value or ""

		local display_name = Items.weapon_card_display_name(item)

		grid_divider_top_weapon.content.weapon_display_name = display_name
	end

	if is_gadget then
		local rating_value, has_rating = Items.expertise_level(item)

		grid_divider_top_weapon.content.rating_value = has_rating and rating_value or ""

		local display_name = Items.display_name(item)

		grid_divider_top_weapon.content.weapon_display_name = display_name
	end

	self._item = item

	self:present_grid_layout(layout, on_present_callback, item)
end

ViewElementWeaponStats.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()

	self._item = nil
end

ViewElementWeaponStats.is_presenting = function (self)
	return not not self._item
end

ViewElementWeaponStats.present_grid_layout = function (self, layout, on_present_callback, item)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_stats_blueprints")
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local ContentBlueprints = generate_blueprints_function(grid_size, item)
	local default_grid_height = self._default_grid_size[2]

	grid_size[2] = default_grid_height
	mask_size[2] = default_grid_height

	self:force_update_list_size()

	local grow_direction = self._grow_direction or "down"

	ViewElementWeaponStats.super.present_grid_layout(self, layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction, on_present_callback)
end

ViewElementWeaponStats.play_expertise_upgrade_animation = function (self, callback)
	return self:_start_animation("on_expertise_upgrade", self._widgets_by_name, nil, callback)
end

ViewElementWeaponStats._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementWeaponStats.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 35
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])

	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	local shine_overlay_widget = self._widgets_by_name.shine_overlay

	shine_overlay_widget.style.texture.size[2] = new_grid_height - 25

	self:force_update_list_size()
end

ViewElementWeaponStats.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	self._stored_ui_renderer = ui_renderer

	ViewElementWeaponStats.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementWeaponStats.update = function (self, dt, t, input_service)
	return ViewElementWeaponStats.super.update(self, dt, t, input_service)
end

ViewElementWeaponStats.select_perk = function (self, index)
	local widgets = self:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget.type == "weapon_perk" then
			widget.style.glow.visible = widget.content.entry.perk_index == index
			widget.style.glow_background.visible = widget.content.entry.perk_index == index
		end
	end
end

ViewElementWeaponStats.select_trait = function (self, index)
	local widgets = self:widgets()

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget.type == "weapon_trait" then
			widget.style.glow.visible = widget.content.entry.trait_index == index
			widget.style.glow_background.visible = widget.content.entry.trait_index == index
		end
	end
end

ViewElementWeaponStats.preview_perk = function (self, index, new_perk)
	local widgets = self:widgets()
	local update_list_size = false

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget.type == "weapon_perk" and widget.content.entry.perk_index == index then
			local perk_id = new_perk and new_perk.id
			local perk_value = new_perk and new_perk.value
			local perk_rarity = new_perk and new_perk.rarity
			local perk_item = perk_id and MasterItems.get_item(perk_id)
			local preview_perk = {
				preview_perk_item = perk_item and perk_item,
				preview_perk_value = perk_item and perk_value,
				preview_perk_rarity = perk_item and perk_rarity,
			}

			if widget.update_item then
				widget.update_item(widget, preview_perk, self._stored_ui_renderer)

				update_list_size = true
			end

			break
		end
	end

	if update_list_size then
		self:force_update_list_size()

		local grid_length = self:grid_length() + 35
		local menu_settings = self._menu_settings
		local grid_size = menu_settings.grid_size
		local mask_size = menu_settings.mask_size

		grid_size[2] = grid_length
		mask_size[2] = grid_length

		self:force_update_list_size()
	end
end

ViewElementWeaponStats.preview_trait = function (self, index, new_trait)
	local widgets = self:widgets()
	local update_list_size = false

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget.type == "weapon_trait" and widget.content.entry.trait_index == index then
			local trait_id = new_trait and new_trait.id
			local trait_value = new_trait and new_trait.value
			local trait_rarity = new_trait and new_trait.rarity
			local trait_item = trait_id and MasterItems.get_item(trait_id)
			local preview_trait = {
				preview_trait_item = trait_item and trait_item,
				preview_trait_value = trait_item and trait_value,
				preview_trait_rarity = trait_item and trait_rarity,
			}

			if widget.update_item then
				widget.update_item(widget, preview_trait, self._stored_ui_renderer)

				update_list_size = true
			end

			break
		end
	end

	if update_list_size then
		self:force_update_list_size()

		local grid_length = self:grid_length() + 35
		local menu_settings = self._menu_settings
		local grid_size = menu_settings.grid_size
		local mask_size = menu_settings.mask_size

		grid_size[2] = grid_length
		mask_size[2] = grid_length

		self:force_update_list_size()
	end
end

ViewElementWeaponStats.update_expertise_value = function (self, start_value, override_value)
	local item = self._item
	local grid_divider_bottom_weapon = self._widgets_by_name.grid_divider_top_weapon

	if item and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") then
		grid_divider_bottom_weapon.content.rating_value = string.format(" %i", override_value or start_value)
		grid_divider_bottom_weapon.content.show_glow = override_value and override_value ~= start_value

		local max_expertise_level = Items.max_expertise_level()
		local widgets = self:widgets()

		for i = 1, #widgets do
			local widget = widgets[i]

			if widget.type == "weapon_stats" then
				widget.content.start_expertise_value = start_value
				widget.content.new_preview_expertise_value = override_value and math.min(max_expertise_level, override_value) or nil
			end
		end
	end
end

return ViewElementWeaponStats
