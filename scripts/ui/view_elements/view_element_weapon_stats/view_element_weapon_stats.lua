require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ItemUtils = require("scripts/utilities/items")
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

local function _add_base_rating(item, layout, grid_size)
	local base_stats_rating = ItemUtils.calculate_stats_rating(item)
	layout[#layout + 1] = {
		widget_type = "rating_info",
		rating = base_stats_rating,
		header = Localize("loc_item_information_stats_title_modifiers")
	}
end

local function _add_presentation_perks(item, layout, grid_size)
	local item_type = item.item_type
	local perks = item.perks
	local num_perks = perks and #perks or 0
	local add_end_margin = false
	local num_modifications, max_modifications = ItemUtils.modifications_by_rarity(item)
	local item_locked = num_modifications == max_modifications

	if num_perks > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				5
			}
		}
		add_end_margin = true
		local rating = item.override_perk_rating_string or ItemUtils.item_perk_rating(item)
		layout[#layout + 1] = {
			widget_type = "rating_info",
			rating = rating,
			header = Localize("loc_item_type_perk")
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				40
			}
		}
	end

	for i = 1, num_perks do
		local perk = perks[i]
		local perk_id = perk.id
		local perk_value = perk.value
		local perk_rarity = perk.rarity
		local perk_item = MasterItems.get_item(perk_id)

		if perk_item then
			local is_locked = item_locked and not perk.modified
			local is_modified = perk.modified
			local show_glow = perk.is_fake
			layout[#layout + 1] = {
				widget_type = "weapon_perk",
				perk_item = perk_item,
				perk_value = perk_value,
				perk_rarity = perk_rarity,
				perk_index = i,
				show_glow = show_glow,
				is_locked = is_locked,
				is_modified = is_modified
			}
		end
	end

	if num_perks > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10
			}
		}
	end

	return add_end_margin
end

local function _add_presentation_traits(item, layout, grid_size)
	local item_type = item.item_type
	local add_end_margin = false
	local traits = item.traits
	local num_traits = traits and #traits or 0
	local num_modifications, max_modifications = ItemUtils.modifications_by_rarity(item)
	local item_locked = num_modifications == max_modifications

	if num_traits > 0 then
		local rating = item.override_trait_rating_string or ItemUtils.item_trait_rating(item)
		layout[#layout + 1] = {
			widget_type = "rating_info",
			rating = rating,
			header = Localize("loc_weapon_inventory_traits_title_text")
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30
			}
		}
		layout[#layout + 1] = {
			add_background = true,
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
		local trait_category = (item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED") and ItemUtils.trait_category(item)
		local trait_item = MasterItems.get_item(trait_id)

		if trait_item then
			local widget_type = item_type == "GADGET" and "gadget_trait" or "weapon_trait"
			local is_locked = item_locked and not trait.modified
			local is_modified = trait.modified
			local show_glow = trait.is_fake
			layout[#layout + 1] = {
				add_background = true,
				widget_type = widget_type,
				trait_item = trait_item,
				trait_value = trait_value,
				trait_rarity = trait_rarity,
				trait_index = i,
				show_glow = show_glow,
				is_locked = is_locked,
				is_modified = is_modified,
				trait_category = trait_category
			}

			if i < num_traits then
				layout[#layout + 1] = {
					add_background = true,
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						16
					}
				}
			end
		end
	end

	if num_traits > 0 and item_type == "GADGET" then
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				20
			}
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
	local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"

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

		local obtained_display_name = ItemUtils.obtained_display_name(item)

		if obtained_display_name then
			local unlocked = is_inventory_item()
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20
				}
			}
			layout[#layout + 1] = {
				widget_type = "obtained_header"
			}
			layout[#layout + 1] = {
				widget_type = "obtained_label",
				label = obtained_display_name,
				unlocked = unlocked
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20
				}
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
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				20
			}
		}
		layout[#layout + 1] = {
			widget_type = "weapon_attack_data",
			item = item,
			size = {
				grid_size[1],
				60
			}
		}

		_add_base_rating(item, layout, grid_size)

		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30
			}
		}
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "weapon_stats",
			item = item
		}

		if _add_presentation_perks(item, layout, grid_size) then
			add_end_margin = true
		end

		if _add_presentation_traits(item, layout, grid_size) then
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20
				}
			}
			add_end_margin = false
		end
	elseif item_type == "GADGET" then
		layout[#layout + 1] = {
			widget_type = "gadget_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "divider_line"
		}

		if _add_presentation_traits(item, layout, grid_size) then
			add_end_margin = false
		end

		if _add_presentation_perks(item, layout, grid_size) then
			add_end_margin = true
		end
	elseif item_type == "WEAPON_SKIN" then
		local visual_item = ItemUtils.weapon_skin_preview_item(item)

		if visual_item then
			layout[#layout + 1] = {
				widget_type = "item_header",
				item = item,
				visual_item = visual_item
			}
			layout[#layout + 1] = {
				widget_type = "divider_line"
			}
			layout[#layout + 1] = {
				widget_type = "weapon_skin_icon",
				item = item,
				visual_item = visual_item
			}
			layout[#layout + 1] = {
				widget_type = "divider_line"
			}

			if show_requirement and ItemUtils.weapon_skin_requirement_text(item) ~= "" then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						20
					}
				}
				layout[#layout + 1] = {
					widget_type = "weapon_skin_requirement_header",
					item = item,
					visual_item = visual_item
				}
				layout[#layout + 1] = {
					widget_type = "weapon_skin_requirements",
					item = item,
					visual_item = visual_item
				}
			end

			if item.description and item.description ~= "" and not hide_description then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						30
					}
				}
				layout[#layout + 1] = {
					widget_type = "description",
					item = item
				}
			end

			layout[#layout + 1] = {
				add_background = false,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30
				}
			}

			add_unlock_reason()

			add_end_margin = false
		else
			add_end_margin = false
		end
	elseif item_type == "WEAPON_TRINKET" then
		local visual_item = ItemUtils.weapon_trinket_preview_item(item)

		if visual_item then
			layout[#layout + 1] = {
				widget_type = "item_header",
				item = item,
				visual_item = visual_item
			}
			layout[#layout + 1] = {
				widget_type = "divider_line"
			}
			layout[#layout + 1] = {
				widget_type = "weapon_skin_icon",
				item = item,
				visual_item = visual_item
			}

			if item.description and item.description ~= "" and not hide_description then
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
				layout[#layout + 1] = {
					widget_type = "divider_line"
				}
			end

			add_unlock_reason()

			add_end_margin = false
		else
			add_end_margin = false
		end
	elseif item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_HEAD" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND" then
		layout[#layout + 1] = {
			widget_type = "item_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "cosmetic_gear_icon",
			item = item,
			profile = profile
		}

		if show_requirement and ItemUtils.class_requirement_text(item) ~= "" then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20
				}
			}
			layout[#layout + 1] = {
				widget_type = "gear_requirement_header",
				item = item
			}
			layout[#layout + 1] = {
				widget_type = "gear_requirements",
				item = item
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					20
				}
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "PORTRAIT_FRAME" then
		layout[#layout + 1] = {
			widget_type = "item_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "divider_line"
		}
		layout[#layout + 1] = {
			widget_type = "portrait_frame",
			item = item
		}

		if item.description and item.description ~= "" and not hide_description then
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
			layout[#layout + 1] = {
				widget_type = "divider_line"
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "CHARACTER_INSIGNIA" then
		layout[#layout + 1] = {
			widget_type = "item_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "divider_line"
		}
		layout[#layout + 1] = {
			widget_type = "insignia",
			item = item
		}

		if item.description and item.description ~= "" and not hide_description then
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
			layout[#layout + 1] = {
				widget_type = "divider_line"
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "EMOTE" then
		layout[#layout + 1] = {
			widget_type = "item_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "divider_line"
		}
		layout[#layout + 1] = {
			widget_type = "emote",
			item = item,
			profile = profile
		}

		if item.description and item.description ~= "" and not hide_description then
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
			layout[#layout + 1] = {
				widget_type = "divider_line"
			}
		end

		add_unlock_reason()

		add_end_margin = false
	elseif item_type == "CHARACTER_TITLE" then
		layout[#layout + 1] = {
			widget_type = "character_title_header",
			item = item,
			profile = profile
		}
		layout[#layout + 1] = {
			widget_type = "divider_line"
		}

		if item.description and item.description ~= "" and not hide_description then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30
				}
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
			layout[#layout + 1] = {
				widget_type = "divider_line"
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
				30
			}
		}
	end

	if present_equip_label_equipped then
		layout[#layout + 1] = {
			widget_type = "equipped",
			item = item
		}
	end

	self:present_grid_layout(layout, on_present_callback, item)
end

ViewElementWeaponStats.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()
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

ViewElementWeaponStats._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	ViewElementWeaponStats.super._on_present_grid_layout_changed(self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)

	local grid_length = self:grid_length() + 35
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length, 0, self._default_grid_size[2])
	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:force_update_list_size()
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

return ViewElementWeaponStats
