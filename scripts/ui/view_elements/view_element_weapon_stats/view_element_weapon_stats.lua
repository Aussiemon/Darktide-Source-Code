local Definitions = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats_definitions")
local MasterItems = require("scripts/backend/master_items")
local WeaponIconUI = require("scripts/ui/weapon_icon_ui")
local ItemUtils = require("scripts/utilities/items")
local PortraitUI = require("scripts/ui/portrait_ui")
local UISettings = require("scripts/settings/ui/ui_settings")
local Archetypes = require("scripts/settings/archetype/archetypes")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local WeaponStats = require("scripts/utilities/weapon_stats")
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
	local icon_render_type = "weapon"
	self._weapon_icon_renderer_id = "ViewElementWeaponStats_weapons_" .. math.uuid()
	self._weapon_icon_renderer = Managers.ui:create_single_icon_renderer(icon_render_type, self._weapon_icon_renderer_id, weapons_render_settings)
	local weapon_icon_size = UISettings.weapon_icon_size
	local cosmetics_render_settings = {
		viewport_layer = 900,
		world_layer = 900,
		viewport_type = "default_with_alpha",
		viewport_name = "cosmetics_portrait_viewport",
		shading_environment = "content/shading_environments/ui/portrait",
		level_name = "content/levels/ui/portrait/portrait",
		timer_name = "ui",
		portrait_width = weapon_icon_size[1] * 4,
		portrait_height = weapon_icon_size[2] * 4,
		target_resolution_width = weapon_icon_size[1] * 4 * 10,
		target_resolution_height = weapon_icon_size[2] * 4 * 10,
		world_name = self._unique_id .. "_cosmetics_portrait_world"
	}
	local cosmetics_icon_render_type = "portrait"
	self._cosmetics_icon_renderer_id = "ViewElementWeaponStats_cosmetics_" .. math.uuid()
	self._cosmetics_icon_renderer = Managers.ui:create_single_icon_renderer(cosmetics_icon_render_type, self._cosmetics_icon_renderer_id, cosmetics_render_settings)

	self:_register_event("event_item_icon_updated", "item_icon_updated")
end

ViewElementWeaponStats._replace_border = function (self)
	local grid_divider_top = self:widget_by_name("grid_divider_top")
	grid_divider_top.content.texture = "content/ui/materials/frames/item_info_upper_slots"
	local style = grid_divider_top.style.texture
	local scale = self._default_grid_size[1] / 1060
	style.size = {
		[2] = 116 * scale
	}
end

ViewElementWeaponStats.destroy = function (self)
	ViewElementWeaponStats.super.destroy(self)

	if self._weapon_icon_renderer then
		self._weapon_icon_renderer = nil

		Managers.ui:destroy_single_icon_renderer(self._weapon_icon_renderer_id)

		self._weapon_icon_renderer_id = nil
	end

	if self._cosmetics_icon_renderer then
		self._cosmetics_icon_renderer = nil

		Managers.ui:destroy_single_icon_renderer(self._cosmetics_icon_renderer_id)

		self._cosmetics_icon_renderer_id = nil
	end
end

local function add_base_rating(item, layout, grid_size)
	local base_stats_rating = ItemUtils.calculate_stats_rating(item)
	layout[#layout + 1] = {
		header = "Modifiers",
		widget_type = "rating_info",
		rating = base_stats_rating
	}
end

local function add_presentation_perks(item, layout, grid_size, perks_selectable)
	local item_type = item.item_type
	local perks = item.perks
	local num_perks = perks and #perks or 0
	local add_end_margin = false
	local has_modification = nil

	if num_perks > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				5
			}
		}
		add_end_margin = true
		local rating = 0
		local rating_per_perk_rank = CraftingSettings.rating_per_perk_rank

		for i = 1, num_perks do
			local perk = perks[i]
			rating = rating + (rating_per_perk_rank[perk.rarity] or 0)
		end

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
			local is_locked = has_modification and not perk.modified
			layout[#layout + 1] = {
				widget_type = "weapon_perk",
				perk_item = perk_item,
				perk_value = perk_value,
				perk_rarity = perk_rarity,
				perk_index = i,
				is_selectable = perks_selectable,
				is_locked = is_locked
			}
		end

		if i < num_perks then
			-- Nothing
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

local function add_presentation_traits(item, layout, grid_size)
	local item_type = item.item_type
	local add_end_margin = false
	local traits = item.traits
	local num_traits = traits and #traits or 0
	local has_modification = nil

	if num_traits > 0 then
		local rating = 0
		local rating_per_trait_rank = CraftingSettings.rating_per_trait_rank

		if item_type == "GADGET" then
			local rating_value = 100

			for i = 1, num_traits do
				local trait = traits[i]
				rating = rating + math.floor(trait.value * rating_value + 0.5)
			end
		else
			for i = 1, num_traits do
				local trait = traits[i]
				rating = rating + (rating_per_trait_rank[trait.rarity] or 0)
			end
		end

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
		local trait_item = MasterItems.get_item(trait_id)

		if trait_item then
			local widget_type = item_type == "GADGET" and "gadget_trait" or "weapon_trait"
			local is_locked = has_modification and not trait.modified
			layout[#layout + 1] = {
				add_background = true,
				widget_type = widget_type,
				trait_item = trait_item,
				trait_value = trait_value,
				trait_rarity = trait_rarity,
				is_locked = is_locked
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

ViewElementWeaponStats.present_item = function (self, item, is_equipped, on_present_callback)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local perks_selectable = menu_settings.perks_selectable
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

		add_base_rating(item, layout, grid_size)

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

		if add_presentation_perks(item, layout, grid_size, perks_selectable) then
			add_end_margin = true
		end

		if add_presentation_traits(item, layout, grid_size) then
			layout[#layout + 1] = {
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30
				}
			}
			add_end_margin = false
		end
	elseif item_type == "GADGET" then
		layout[#layout + 1] = {
			widget_type = "gadget_header",
			item = item
		}

		if add_presentation_traits(item, layout, grid_size) then
			add_end_margin = false
		end

		if add_presentation_perks(item, layout, grid_size, perks_selectable) then
			add_end_margin = true
		end
	elseif item_type == "WEAPON_SKIN" then
		local visual_item = ItemUtils.weapon_skin_preview_item(item)

		if visual_item then
			layout[#layout + 1] = {
				widget_type = "skin_header",
				item = item,
				visual_item = visual_item
			}
			layout[#layout + 1] = {
				widget_type = "weapon_skin_icon",
				item = item,
				visual_item = visual_item
			}
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
				add_background = true,
				widget_type = "dynamic_spacing",
				size = {
					grid_size[1],
					30
				}
			}
			add_end_margin = false
		else
			add_end_margin = false
		end
	elseif item_type == "WEAPON_TRINKET" then
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
		add_end_margin = true
	elseif item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_HEAD" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND" then
		layout[#layout + 1] = {
			widget_type = "skin_header",
			item = item
		}
		layout[#layout + 1] = {
			widget_type = "cosmetic_gear_icon",
			item = item
		}

		if item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND" then
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
			add_end_margin = true
		else
			add_end_margin = false
		end
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

	if add_end_margin then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30
			}
		}
	end

	if is_equipped then
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

	if self._cosmetics_icon_renderer then
		self._cosmetics_icon_renderer:update(dt, t)
	end

	return ViewElementWeaponStats.super.update(self, dt, t, input_service)
end

ViewElementWeaponStats.load_item_icon = function (self, item, cb, render_context, dummy_profile)
	local item_name = item.name
	local gear_id = item.gear_id or item_name
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		local weapon_icon_renderer = self._weapon_icon_renderer

		return weapon_icon_renderer and weapon_icon_renderer:load_weapon_icon(item, cb, render_context)
	elseif item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_HEAD" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND" then
		local cosmetics_icon_renderer = self._cosmetics_icon_renderer
		local slots = item.slots or {}

		if item.gear then
			item = MasterItems.create_preview_item_instance(item)
		else
			item = table.clone_instance(item)
		end

		if not dummy_profile then
			local player = Managers.player:local_player(1)
			local profile = player:profile()
			local item_gender, item_breed, item_archetype = nil

			if item.genders then
				for i = 1, #item.genders do
					local gender = item.genders[i]

					if gender == profile.gender then
						item_gender = true

						break
					end
				end
			else
				item_gender = profile.gender
			end

			if item.breeds then
				for i = 1, #item.breeds do
					local breed = item.breeds[i]

					if breed == profile.breed then
						item_breed = profile.breed

						break
					end
				end
			else
				item_breed = profile.breed
			end

			if item.archetypes then
				for i = 1, #item.archetypes do
					local archetype = item.archetypes[i]

					if archetype == profile.archetype.name then
						item_archetype = profile.archetype

						break
					end
				end
			else
				item_archetype = profile.archetype.name
			end

			local compatible_profile = item_gender and item_breed and item_archetype

			if compatible_profile then
				dummy_profile = table.clone_instance(profile)
			else
				local gender = item_gender or item.genders and item.genders[1] or "male"
				local breed = item_breed or item.breeds and item.breeds[1] or "human"
				local archetype = item_archetype or item.archetypes and item.archetypes[1] and Archetypes[item.archetypes[1]] or Archetypes.veteran
				dummy_profile = {
					loadout = {},
					archetype = archetype,
					breed = breed,
					gender = gender
				}
			end
		end

		local gender_name = dummy_profile.gender
		local archetype = dummy_profile.archetype
		local breed_name = archetype.breed
		local first_slot_name = slots[1]
		local loadout = dummy_profile.loadout
		local required_slots_to_keep = UISettings.item_preview_required_slots_per_slot[first_slot_name]

		if required_slots_to_keep then
			for slot_name, slot_item in pairs(loadout) do
				if not table.contains(required_slots_to_keep, slot_name) then
					loadout[slot_name] = nil
				end
			end
		end

		for i = 1, #slots do
			local slot_name = slots[i]
			loadout[slot_name] = item
		end

		local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed_name]
		local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]

		if required_gender_item_names_per_slot then
			local required_items = required_gender_item_names_per_slot[first_slot_name]

			if required_items then
				for slot_name, slot_item_name in pairs(required_items) do
					local item_definition = MasterItems.get_item(slot_item_name)

					if item_definition then
						local slot_item = table.clone(item_definition)
						dummy_profile.loadout[slot_name] = slot_item
					end
				end
			end
		end

		local slots_to_hide = UISettings.item_preview_hide_slots_per_slot[first_slot_name]

		if slots_to_hide then
			local hide_slots = table.clone(item.hide_slots or {})
			item.hide_slots = hide_slots

			for i = 1, #slots_to_hide do
				hide_slots[#hide_slots + 1] = slots_to_hide[i]
			end
		end

		dummy_profile.character_id = gear_id
		local prop_item_key = item.prop_item
		local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

		if prop_item then
			local prop_item_slot = prop_item.slots[1]
			dummy_profile.loadout[prop_item_slot] = prop_item
			render_context.wield_slot = prop_item_slot
		end

		if cosmetics_icon_renderer then
			cosmetics_icon_renderer:load_profile_portrait(dummy_profile, cb, render_context)
		end
	end
end

ViewElementWeaponStats.unload_item_icon = function (self, id)
	local weapon_icon_renderer = self._weapon_icon_renderer
	local cosmetics_icon_renderer = self._cosmetics_icon_renderer

	if weapon_icon_renderer and weapon_icon_renderer:has_request(id) then
		weapon_icon_renderer:unload_weapon_icon(id)
	elseif cosmetics_icon_renderer and cosmetics_icon_renderer:has_request(id) then
		cosmetics_icon_renderer:unload_profile_portrait(id)
	end
end

ViewElementWeaponStats.item_icon_updated = function (self, item)
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" then
		local weapon_icon_renderer = self._weapon_icon_renderer

		if weapon_icon_renderer then
			weapon_icon_renderer:weapon_icon_updated(item)
		end
	else
		local player = Managers.player:local_player(1)
		local profile = player:profile()
		local cosmetics_icon_renderer = self._cosmetics_icon_renderer

		if cosmetics_icon_renderer then
			cosmetics_icon_renderer:profile_updated(profile)
		end
	end
end

return ViewElementWeaponStats
