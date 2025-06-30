-- chunkname: @scripts/ui/view_elements/view_element_weapon_info/view_element_weapon_info.lua

local Definitions = require("scripts/ui/view_elements/view_element_weapon_info/view_element_weapon_info_definitions")
local MasterItems = require("scripts/backend/master_items")
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Item = require("scripts/utilities/items")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local ItemUtils = require("scripts/utilities/items")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementWeaponInfo = class("ViewElementWeaponInfo", "ViewElementGrid")
local EMPTY_TABLE = {}

ViewElementWeaponInfo.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	ViewElementWeaponInfo.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, Definitions)

	local menu_settings = self._menu_settings

	self._default_grid_size = table.clone(menu_settings.grid_size)
	self._default_mask_size = table.clone(menu_settings.mask_size)

	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size

	self._bar_breakdown_widgets = {}
	self._bar_breakdown_widgets_by_name = {}
	self._ui_animations = {}
	self._alpha_multiplier = 1
	self._active = true

	self:_hide_dividers()
end

ViewElementWeaponInfo.set_pivot_offset = function (self, x, y)
	ViewElementWeaponInfo.super.set_pivot_offset(self, x, y)
	self:_start_animation()
end

ViewElementWeaponInfo.activate = function (self, activate)
	self._active = activate

	local widget = self._widgets_by_name.overlay
	local content = widget.content

	content.disabled = not activate
end

ViewElementWeaponInfo.set_alpha_multiplier = function (self, alpha_multiplier)
	self._alpha_multiplier = alpha_multiplier
end

ViewElementWeaponInfo.is_active = function (self)
	return self._active
end

ViewElementWeaponInfo._start_animation = function (self)
	if self._start_animation_done then
		return
	end

	local ui_scenegraph = self._ui_scenegraph
	local func = UIAnimation.function_by_time
	local target = ui_scenegraph.pivot.local_position
	local target_index = 1
	local from = self._pivot_offset[1] - 200
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
	self._start_animation_done = true
end

ViewElementWeaponInfo._hide_dividers = function (self)
	local grid_divider_top = self:widget_by_name("grid_divider_top")

	grid_divider_top.style.texture.color[1] = 0

	local grid_divider_bottom = self:widget_by_name("grid_divider_bottom")

	grid_divider_bottom.style.texture.color[1] = 0

	local grid_divider_title = self:widget_by_name("grid_divider_title")

	grid_divider_title.style.texture.color[1] = 0
end

local function add_presentation_perks(item, layout, grid_size)
	local item_type = item.item_type
	local perks = item.perks
	local num_perks = perks and #perks or 0
	local add_end_margin = false

	if num_perks > 0 then
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				15,
			},
		}
		add_end_margin = true
	end

	for i = 1, num_perks do
		local perk = perks[i]
		local perk_id = perk.id
		local perk_value = perk.value
		local perk_rarity = perk.rarity
		local perk_item = MasterItems.get_item(perk_id)

		if perk_item then
			layout[#layout + 1] = {
				add_background = true,
				show_rating = false,
				widget_type = "weapon_perk",
				perk_item = perk_item,
				perk_value = perk_value,
				perk_rarity = perk_rarity,
				description_size = {
					400,
				},
			}

			if i < num_perks then
				layout[#layout + 1] = {
					add_background = true,
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						15,
					},
				}
			end
		end

		if i < num_perks then
			-- Nothing
		end
	end

	return add_end_margin
end

local function add_presentation_traits(item, layout, grid_size)
	local item_type = item.item_type
	local add_end_margin = false
	local traits = item.traits
	local num_traits = traits and #traits or 0

	if num_traits > 0 then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				20,
			},
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

			layout[#layout + 1] = {
				show_rating = false,
				widget_type = widget_type,
				trait_item = trait_item,
				trait_value = trait_value,
				trait_rarity = trait_rarity,
				description_size = {
					400,
				},
				trait_category = trait_category,
			}

			if i < num_traits then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						16,
					},
				}
			end
		end
	end

	if num_traits > 0 and item_type == "GADGET" then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				20,
			},
		}
	end

	return add_end_margin
end

ViewElementWeaponInfo.present_item = function (self, item, on_present_callback, ignore_list)
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size

	ignore_list = ignore_list or {}

	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	local weapon_template = WeaponTemplate.weapon_template_from_item(item)

	if not ignore_list.ignore_header then
		layout[#layout + 1] = {
			widget_type = "extended_weapon_stats_header",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "divider",
		}
	end

	if not ignore_list.ignore_keywords then
		layout[#layout + 1] = {
			widget_type = "extended_weapon_keywords",
			item = item,
		}
		layout[#layout + 1] = {
			widget_type = "divider",
		}
	end

	if not ignore_list.ignore_extended_stats then
		layout[#layout + 1] = {
			widget_type = "extended_weapon_stats",
			item = item,
		}
	end

	local add_end_margin = false

	if not ignore_list.ignore_perks and add_presentation_perks(item, layout, grid_size) then
		add_end_margin = true
		layout[#layout + 1] = {
			add_background = true,
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
		layout[#layout + 1] = {
			widget_type = "divider",
		}
	end

	if not ignore_list.ignore_traits and add_presentation_traits(item, layout, grid_size) then
		add_end_margin = true
		layout[#layout + 1] = {
			widget_type = "divider",
		}
	end

	if not ignore_list.ignore_stats then
		layout[#layout + 1] = {
			interactive = true,
			widget_type = "weapon_stats",
			item = item,
		}
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	self:present_grid_layout(layout, on_present_callback)
end

ViewElementWeaponInfo.stop_presenting = function (self)
	self:_destroy_grid_widgets()
	self:_destroy_grid()
end

ViewElementWeaponInfo.present_grid_layout = function (self, layout, on_present_callback)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_stats_blueprints")
	local menu_settings = self._menu_settings
	local grid_size = menu_settings.grid_size
	local ContentBlueprints = generate_blueprints_function(grid_size)
	local grow_direction = self._grow_direction or "down"

	ViewElementWeaponInfo.super.present_grid_layout(self, layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction, on_present_callback)

	local area_length = self:grid_area_length()
	local length = self:grid_length()
	local grid_length = math.min(length, area_length)

	self._ui_scenegraph.grid_background.size[2] = grid_length
end

ViewElementWeaponInfo.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	render_settings.alpha_multiplier = render_settings.alpha_multiplier * self._alpha_multiplier

	self:_draw_bar_breakdown_widgets(dt, t, input_service, render_settings)
	ViewElementWeaponInfo.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementWeaponInfo.update = function (self, dt, t, input_service)
	self:_update_animations(dt, t)

	return ViewElementWeaponInfo.super.update(self, dt, t, input_service)
end

ViewElementWeaponInfo._update_animations = function (self, dt, t)
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

ViewElementWeaponInfo._draw_bar_breakdown_widgets = function (self, dt, t, input_service, render_settings)
	local ui_scenegraph = self._ui_scenegraph
	local ui_renderer = self._ui_grid_renderer

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local bar_breakdown_widgets = self._bar_breakdown_widgets

	for _, widget in ipairs(bar_breakdown_widgets) do
		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
end

ViewElementWeaponInfo.update_bar_breakdown_data = function (self, bar_data)
	if not bar_data then
		self:_destroy_bar_breakdown_widgets()

		return
	end

	local bar_breakdown_name = bar_data.name

	if bar_breakdown_name == self._bar_breakdown_name then
		return
	end

	self:_create_bar_breakdown_widgets(bar_data)
end

ViewElementWeaponInfo._destroy_bar_breakdown_widgets = function (self)
	table.clear(self._bar_breakdown_widgets)
	table.clear(self._bar_breakdown_widgets_by_name)

	self._bar_breakdown_name = nil
end

ViewElementWeaponInfo._scale_value_by_type = function (self, value, display_type)
	if display_type == "multiplier" then
		value = (value - 1) * 100
	elseif display_type == "inverse_multiplier" then
		value = (1 - 1 / value) * 100
	elseif display_type == "inverse_percentage" then
		value = (1 / value - 1) * 100
	elseif display_type == "percentage" then
		value = value * 100
	end

	return value
end

ViewElementWeaponInfo._value_to_text = function (self, value, is_signed)
	if value >= math.huge then
		return Localize("loc_weapon_stats_display_unlimited")
	end

	if is_signed and value >= 0 then
		return string.format("+%0.2f", value)
	end

	return string.format("%0.2f", value)
end

ViewElementWeaponInfo._get_stats_text = function (self, stat)
	local override_data = stat.override_data or EMPTY_TABLE
	local type_data = stat.type_data
	local display_type = override_data.display_type or type_data.display_type
	local is_signed = type_data.signed
	local value = self:_scale_value_by_type(stat.value, display_type)
	local value_text = self:_value_to_text(value, is_signed)
	local range = ""
	local min, max = stat.min, stat.max

	if min and max then
		min = self:_scale_value_by_type(min, display_type)
		max = self:_scale_value_by_type(max, display_type)
		range = string.format("{#color(90,90,90)}[%s | %s]", self:_value_to_text(min, is_signed), self:_value_to_text(max, is_signed))
	end

	local name = Localize(override_data.display_name or type_data.display_name)
	local group_type_data = stat.group_type_data
	local group_prefix = group_type_data and group_type_data.prefix and Localize(group_type_data.prefix) or ""
	local prefix = override_data.prefix or type_data.prefix

	prefix = prefix and Localize(prefix) .. " " or ""

	local postfix = group_type_data and group_type_data.postfix and Localize(group_type_data.postfix) .. " " or ""
	local display_units = override_data.display_units or type_data.display_units or ""
	local suffix = (override_data.suffix or type_data.suffix) and Localize(override_data.suffix or type_data.suffix) or ""
	local prefix_display_units = override_data.prefix_display_units or type_data.prefix_display_units or ""
	local stat_text = string.format("%s %s%s%s%s:  {#color(250,189,73)}%s%s%s   %s", group_prefix, prefix, name, suffix, postfix, prefix_display_units, value_text, display_units, range)

	return stat_text
end

local STRIPPED_BAR_DATA = {}

ViewElementWeaponInfo._strip_redundant_stats = function (self, bar_data)
	table.clear(STRIPPED_BAR_DATA)

	for i = 1, #bar_data do
		local stat = bar_data[i]
		local override_data = stat.override_data or EMPTY_TABLE
		local type_data = stat.type_data
		local display_type = override_data.display_type or type_data.display_type
		local min, max = stat.min, stat.max

		if min and max then
			local min = self:_scale_value_by_type(min, display_type)
			local max = self:_scale_value_by_type(max, display_type)

			if min ~= 0 or max ~= 0 then
				STRIPPED_BAR_DATA[#STRIPPED_BAR_DATA + 1] = stat
			end
		end
	end

	return STRIPPED_BAR_DATA
end

ViewElementWeaponInfo._create_bar_breakdown_widgets = function (self, bar_data)
	table.clear(self._bar_breakdown_widgets)
	table.clear(self._bar_breakdown_widgets_by_name)

	local bar_breakdown_widgets = self._bar_breakdown_widgets
	local bar_breakdown_widgets_by_name = self._bar_breakdown_widgets_by_name
	local bar_breakdown_widgets_definitions = Definitions.bar_breakdown_widgets_definitions
	local widget = UIWidget.init("bar_breakdown_slate", bar_breakdown_widgets_definitions.bar_breakdown_slate)
	local content = widget.content
	local style = widget.style
	local display_name = bar_data.display_name

	content.header = Localize(display_name)
	bar_breakdown_widgets[#bar_breakdown_widgets + 1] = widget
	bar_breakdown_widgets_by_name.bar_breakdown_slate = widget

	local description_offset = 0
	local entry_size = 40
	local stripped_bar_data = self:_strip_redundant_stats(bar_data)
	local num_entries = #stripped_bar_data
	local old_desc = content.description
	local new_desc = Localize(bar_data.description or display_name .. "_desc")
	local ui_renderer = self._ui_grid_renderer
	local text_style = style.description
	local text_font_data = UIFonts.data_by_type(text_style.font_type)
	local text_font = text_font_data.path
	local text_size = text_style.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, old_text_height = UIRenderer.text_size(ui_renderer, old_desc, text_style.font_type, text_style.font_size, text_size, text_options)
	local _, new_text_height = UIRenderer.text_size(ui_renderer, new_desc, text_style.font_type, text_style.font_size, text_size, text_options)

	description_offset = math.max(new_text_height - old_text_height, 0) + 20
	content.description = new_desc

	if bar_data.name ~= "base_rating" then
		for i = 1, num_entries do
			local bar_entry = stripped_bar_data[i]
			local widget = UIWidget.init("entry", bar_breakdown_widgets_definitions.entry)
			local content = widget.content
			local stat_text = self:_get_stats_text(bar_entry)

			content.text = stat_text
			bar_breakdown_widgets[#bar_breakdown_widgets + 1] = widget
			bar_breakdown_widgets_by_name["entry_" .. i] = widget
			widget.offset[2] = (num_entries - i) * -entry_size
		end
	end

	local area_length = self:grid_area_length()
	local length = self:grid_length()
	local grid_length = math.min(length, area_length)
	local offset = 65
	local base_size = 50
	local size = base_size + num_entries * entry_size + description_offset

	self._ui_scenegraph.bar_breakdown_slate.size[2] = size
	self._ui_scenegraph.bar_breakdown_slate.world_position[2] = grid_length - size + offset
	self._ui_scenegraph.entry.world_position[2] = grid_length - base_size + offset - description_offset
	self._bar_breakdown_name = stripped_bar_data.name
end

return ViewElementWeaponInfo
