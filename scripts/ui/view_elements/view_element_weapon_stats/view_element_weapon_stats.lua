local create_definitions_function = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats_definitions")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementWeaponStatsSettings = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats_settings")
local WeaponDetailsPassTemplates = require("scripts/ui/pass_templates/weapon_details_pass_templates")
local WeaponStats = require("scripts/utilities/weapon_stats")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local MasterItems = require("scripts/backend/master_items")

local function _apply_color_to_text(text, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
end

local ViewElementWeaponStats = class("ViewElementWeaponStats", "ViewElementBase")

ViewElementWeaponStats.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name
	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementWeaponStatsSettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementWeaponStatsSettings
	end

	self._pivot_offset = {
		0,
		0
	}
	self._stats_animation_progress = {}
	local definitions = create_definitions_function(self._menu_settings)

	ViewElementWeaponStats.super.init(self, parent, draw_layer, start_scale, definitions)
	self:_set_preview_widgets_visibility(false)
end

ViewElementWeaponStats.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementWeaponStats.update = function (self, dt, t, input_service)
	self:_update_stat_bar_animations(dt)

	return ViewElementWeaponStats.super.update(self, dt, t, input_service)
end

ViewElementWeaponStats.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	ViewElementWeaponStats.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementWeaponStats._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local action_texts_widgets = self._action_texts_widgets

	if action_texts_widgets then
		for i = 1, #action_texts_widgets do
			local widget = action_texts_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local keyword_texts_widgets = self._keyword_texts_widgets

	if keyword_texts_widgets then
		for i = 1, #keyword_texts_widgets do
			local widget = keyword_texts_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local hovered_trait = nil
	local trait_widgets = self._trait_widgets

	if trait_widgets then
		for i = 1, #trait_widgets do
			local widget = trait_widgets[i]

			UIWidget.draw(widget, ui_renderer)

			local content = widget.content

			if content.hotspot.is_hover then
				hovered_trait = content.trait
			end
		end
	end

	if hovered_trait ~= self._hovered_trait then
		self._hovered_trait = hovered_trait

		if hovered_trait then
			self:_set_trait_tooltip_text(ui_renderer, hovered_trait)
		end
	end

	self._widgets_by_name.trait_tooltip.content.visible = hovered_trait ~= nil
	self._widgets_by_name.trait_tooltip_text.content.visible = hovered_trait ~= nil

	ViewElementWeaponStats.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementWeaponStats.destroy = function (self)
	self._weapon_stats = nil

	ViewElementWeaponStats.super.destroy(self)
end

ViewElementWeaponStats.stop_presenting = function (self)
	self:_set_preview_widgets_visibility(false)
end

ViewElementWeaponStats._get_traits = function (self, item)
	local traits = {}

	if item.trait_slots then
		for i = 1, #item.trait_slots do
			local slot = item.trait_slots[i]
			local trait = item.traits[i]

			if trait then
				local trait_id = trait.id
				local trait_exists = MasterItems.item_exists(trait_id)

				if trait_exists then
					local trait_item = MasterItems.get_item(trait_id)
					traits[#traits + 1] = {
						rarity = trait.rarity,
						slot_rarity = tonumber(slot.maxRank),
						locked = slot.locked,
						slot_categories = slot.traitCategories,
						name = trait_item.display_name and Localize(trait_item.display_name) or "",
						description = trait_item.description and Localize(trait_item.description) or "",
						icon = trait_item.icon,
						category = trait_item.weapon_type_restriction[1],
						trait_id = trait_id,
						trait_index = #traits + 1
					}
				end
			end
		end
	end

	return traits
end

ViewElementWeaponStats.present_item = function (self, item)
	self._previewed_item = item
	self._weapon_stats = nil
	self._weapon_traits = self:_get_traits(item)

	if item then
		self._weapon_stats = WeaponStats:new(item)
		local compairing_stats = self._weapon_stats:get_compairing_stats()
		local main_stats = self._weapon_stats:get_main_stats()
		local is_ranged_weapon = self._weapon_stats:is_ranged_weapon()

		if is_ranged_weapon then
			local magazine = main_stats.magazine

			if magazine then
				local ammo = magazine.ammo
				local reserve = magazine.reserve

				if ammo then
					local text = string.format("%.0f", math.floor(ammo))

					if reserve then
						text = text .. "/" .. string.format("%.0f", math.floor(reserve))
					end

					self:_set_widget_text("resource_value", text)
					self:_set_widget_text("resource_title", Localize("loc_weapon_stat_title_ammo"))
				end
			else
				self:_set_widget_text("resource_value", "")
				self:_set_widget_text("resource_title", "")
			end
		else
			local stamina_push_cost = main_stats.stamina_push_cost or 0
			local push_cost_color = stamina_push_cost == 1 and Color.ui_brown_light(255, true) or stamina_push_cost > 1 and Color.ui_hud_red_light(255, true) or stamina_push_cost < 1 and Color.green(255, true)
			local push_cost_text = _apply_color_to_text(string.format("%.0f%%", stamina_push_cost * 100), push_cost_color)

			self:_set_widget_text("resource_value", push_cost_text)
			self:_set_widget_text("resource_title", Localize("loc_weapon_stat_title_push_cost"))
		end

		self:_setup_stats_widgets(compairing_stats)
		self:_setup_action_text_widgets(item)
		self:_setup_keyword_widgets(item)
		self:_setup_trait_slot_widgets(item)
	end

	self:_set_preview_widgets_visibility(item ~= nil)
end

ViewElementWeaponStats._set_widget_text = function (self, widget_name, text)
	self._widgets_by_name[widget_name].content.text = text
end

ViewElementWeaponStats._setup_trait_slot_widgets = function (self, item)
	local traits = self._weapon_traits
	local trait_widgets = self._trait_widgets

	if trait_widgets then
		for i = 1, #trait_widgets do
			local widget = trait_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end

		self._trait_widgets = nil
	end

	if traits then
		local num_traits = table.size(traits)
		local trait_size = WeaponDetailsPassTemplates.trait_slot_size
		local spacing = 15
		local trait_widget_definition = UIWidget.create_definition(WeaponDetailsPassTemplates.trait_slot, "trait_pivot", nil)
		local widgets = {}
		local trait_index = 1
		local offset_x = trait_size[1] * 0.5
		local total_length = trait_size[1] * num_traits + spacing * (num_traits - 1)

		for i = 1, num_traits do
			local trait = traits[i]
			local widget_name = "trait_" .. trait_index
			local widget = self:_create_widget(widget_name, trait_widget_definition)
			local offset = widget.offset
			offset[1] = offset_x - total_length * 0.5
			widgets[#widgets + 1] = widget
			local item_rarity_color_lookup = UISettings.item_rarity_color_lookup
			local trait_rarity_color = item_rarity_color_lookup[trait.rarity]
			local slot_rarity_color = item_rarity_color_lookup[trait.slot_rarity]
			widget.style.trait_used.material_values = {
				texture_category = "content/ui/textures/icons/traits/categories/default",
				texture_glow = "content/ui/textures/icons/traits/effects/default",
				texture_frame = "content/ui/textures/icons/traits/frames/slot_type_passive",
				texture_background = "content/ui/textures/icons/traits/frames/slot_type_passive_background",
				texture_effect = "content/ui/textures/icons/traits/effects/default",
				trait_rarity_color = trait_rarity_color,
				slot_rarity_color = slot_rarity_color
			}
			local widget_content = widget.content
			widget_content.trait = trait
			widget_content.hotspot.anim_focus_progress = 1
			trait_index = trait_index + 1
			offset_x = offset_x + trait_size[1] + spacing
		end

		self._trait_widgets = widgets
	end
end

ViewElementWeaponStats._setup_keyword_widgets = function (self, item)
	if self._keyword_texts_widgets then
		for i = 1, #self._keyword_texts_widgets do
			local widget = self._keyword_texts_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end

		self._keyword_texts_widgets = nil
	end

	local widgets = {}
	self._keyword_texts_widgets = widgets
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local displayed_keywords = weapon_template.displayed_keywords

	if displayed_keywords then
		local text_style = table.clone(UIFontSettings.body_small)
		text_style.text_horizontal_alignment = "right"
		text_style.text_vertical_alignment = "center"
		text_style.line_spacing = 1
		local widget_definition = UIWidget.create_definition({
			{
				value_id = "text",
				pass_type = "text",
				value = Localize("loc_weapon_stat_title_dps"),
				style = text_style
			}
		}, "keyword_pivot")
		local spacing = 0
		local widget_size = {
			250,
			25
		}
		local max_rows = 10

		for i = 1, #displayed_keywords do
			local name = "keyword_text_" .. i
			local widget = self:_create_widget(name, widget_definition)
			widgets[i] = widget
			local keyword = displayed_keywords[i]
			local display_name = keyword.display_name
			local title_text = Localize(display_name) .. " •"
			widget.content.text = title_text
			local column = (i - 1) % max_rows + 1
			local row = math.ceil(i / max_rows)
			local offset = widget.offset
			offset[2] = -((column - 1) * widget_size[2] + (column - 1) * spacing)
			offset[1] = (row - 1) * widget_size[1]
		end
	end
end

ViewElementWeaponStats._setup_action_text_widgets = function (self, item)
	if self._action_texts_widgets then
		for i = 1, #self._action_texts_widgets do
			local widget = self._action_texts_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end

		self._action_texts_widgets = nil
	end

	local widgets = {}
	self._action_texts_widgets = widgets
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local displayed_attacks = weapon_template.displayed_attacks

	if displayed_attacks then
		local text_style = table.clone(UIFontSettings.body_small)
		text_style.text_horizontal_alignment = "left"
		text_style.text_vertical_alignment = "top"
		text_style.line_spacing = 1
		local widget_definition = UIWidget.create_definition({
			{
				value_id = "text",
				pass_type = "text",
				value = Localize("loc_weapon_stat_title_dps"),
				style = text_style
			}
		}, "action_text_pivot")
		local spacing = 0
		local widget_size = {
			250,
			40
		}
		local max_rows = 2
		local header_color = Color.ui_grey_medium(255, true)
		local weapon_action_title_display_names = UISettings.weapon_action_title_display_names
		local weapon_action_display_order = UISettings.weapon_action_display_order

		for key, data in pairs(displayed_attacks) do
			local display_order = weapon_action_display_order[key] or 0
			local name = "action_text_" .. display_order
			local widget = self:_create_widget(name, widget_definition)
			widgets[#widgets + 1] = widget
			local title_loc_key = weapon_action_title_display_names[key]
			local display_name = data.display_name
			local title_text = Localize(title_loc_key)
			local value_text = Localize(display_name)
			local text = "{#color(" .. header_color[2] .. "," .. header_color[3] .. "," .. header_color[4] .. ")}" .. title_text .. "{#reset()}\n" .. value_text
			widget.content.text = text
			local column = (display_order - 1) % max_rows + 1
			local row = math.ceil(display_order / max_rows)
			local offset = widget.offset
			offset[2] = (column - 1) * widget_size[2] + (column - 1) * spacing
			offset[1] = (row - 1) * widget_size[1]
		end
	end
end

local _temp_trait_tooltip_localization_values = {
	slot_tier = "slot_tier",
	category_icon = "category_icon",
	description_text = "description_text",
	trait_tier = "trait_tier"
}
local temp_text_size = {}

ViewElementWeaponStats._set_trait_tooltip_text = function (self, ui_renderer, trait)
	local trait_rarity = trait.rarity
	local slot_rarity = trait.slot_rarity
	local item_rarity_color_lookup = UISettings.item_rarity_color_lookup
	local trait_rarity_color = item_rarity_color_lookup[trait_rarity]
	local slot_rarity_color = item_rarity_color_lookup[slot_rarity]
	local slot_categories_text = ""
	local value_text = trait.description
	local description_text_color = Color.ui_grey_light(255, true)
	_temp_trait_tooltip_localization_values.description_text = _apply_color_to_text(value_text, description_text_color)
	_temp_trait_tooltip_localization_values.trait_tier = _apply_color_to_text(TextUtilities.convert_to_roman_numerals(trait_rarity), trait_rarity_color)

	if trait.slot_categories then
		for i = 1, #trait.slot_categories do
			local category = trait.slot_categories[i]
			local category_icon = UISettings.trait_category_icon[category]
			slot_categories_text = slot_categories_text == "" and category_icon or slot_categories_text .. " / " .. category_icon
		end

		_temp_trait_tooltip_localization_values.slot_tier = _apply_color_to_text(TextUtilities.convert_to_roman_numerals(slot_rarity), slot_rarity_color)
	end

	_temp_trait_tooltip_localization_values.category_icon = _apply_color_to_text(slot_categories_text, description_text_color)
	local localized_text = Localize("loc_trait_tooltip_format_key", true, _temp_trait_tooltip_localization_values)
	local widget = self._widgets_by_name.trait_tooltip_text
	widget.content.text = localized_text
	local text_style = widget.style.text
	local text_size_addition = text_style.size_addition
	local scenegraph_id = widget.scenegraph_id
	local scenegraph_width = self:_scenegraph_size(scenegraph_id)
	local max_width = scenegraph_width - math.abs(text_size_addition[2])
	temp_text_size[1] = max_width
	temp_text_size[2] = math.huge
	local height = self:_text_size(ui_renderer, localized_text, text_style, temp_text_size)
	height = height + math.abs(text_size_addition[2])

	self:_set_scenegraph_size(scenegraph_id, nil, height)
end

ViewElementWeaponStats._text_size = function (self, ui_renderer, text, text_style, optional_size)
	local text_options = UIFonts.get_font_options_by_style(text_style)

	return UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, optional_size, text_options)
end

local weapon_stats_sort_order = {
	rate_of_fire = 2,
	attack_speed = 2,
	damage = 1,
	stamina_block_cost = 4,
	reload_speed = 4,
	stagger = 3
}

ViewElementWeaponStats._setup_stats_widgets = function (self, compairing_stats)
	table.clear(self._stats_animation_progress)

	if self._stat_widgets then
		for i = 1, #self._stat_widgets do
			local widget = self._stat_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end

		self._stat_widgets = nil
	end

	local num_stats = table.size(compairing_stats)
	local max_rows = num_stats
	local compairing_stats_array = {}

	for key, stat in pairs(compairing_stats) do
		compairing_stats_array[#compairing_stats_array + 1] = stat
	end

	local function sort_function(a, b)
		local a_sort_order = weapon_stats_sort_order[a.type] or math.huge
		local b_sort_order = weapon_stats_sort_order[b.type] or math.huge

		return a_sort_order < b_sort_order
	end

	table.sort(compairing_stats_array, sort_function)

	local stats_size = {
		350,
		10
	}
	local widget_definition = UIWidget.create_definition(BarPassTemplates.weapon_stats_bar, "stat_pivot")
	local widgets = {}
	local spacing = 15
	local anim_duration = 1

	for i = 1, num_stats do
		local stat_data = compairing_stats_array[i]
		local name = "stat_" .. i
		local widget = self:_create_widget(name, widget_definition)
		local column = (i - 1) % max_rows + 1
		local row = math.ceil(i / max_rows)
		local offset = widget.offset
		offset[2] = (column - 1) * stats_size[2] + (column - 1) * spacing
		offset[1] = (row - 1) * stats_size[1]
		widgets[#widgets + 1] = widget
		widget.content.text = Localize(stat_data.display_name)
		local value = stat_data.fraction

		self:_set_stat_bar_value(i, value, anim_duration)
	end

	self._stat_widgets = widgets
end

ViewElementWeaponStats._get_item_stats = function (self, item)
	local context = {
		{
			display_name = "loc_weapon_stats_title_damage",
			progress = math.random_range(0, 1)
		},
		{
			display_name = "loc_weapon_stats_title_rate_of_fire",
			progress = math.random_range(0, 1)
		},
		{
			display_name = "loc_weapon_stats_title_reload_speed",
			progress = math.random_range(0, 1)
		},
		{
			display_name = "loc_weapon_stats_title_suppress",
			progress = math.random_range(0, 1)
		}
	}

	return context
end

ViewElementWeaponStats._set_stat_bar_value = function (self, stat_index, value, duration, should_reset)
	local stats_animation_progress = self._stats_animation_progress
	local name = "stat_" .. stat_index
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name[name]
	local content = widget.content
	local current_progress = content.progress or 0
	local anim_data = {
		time = 0,
		start_value = should_reset and 0 or current_progress,
		end_value = value,
		duration = duration,
		widget = widget
	}
	stats_animation_progress[#stats_animation_progress + 1] = anim_data
end

ViewElementWeaponStats._update_stat_bar_animations = function (self, dt)
	local stats_animation_progress = self._stats_animation_progress

	if not stats_animation_progress or #stats_animation_progress < 1 then
		return
	end

	for i = #stats_animation_progress, 1, -1 do
		local data = stats_animation_progress[i]
		local duration = data.duration
		local end_value = data.end_value
		local start_value = data.start_value
		local time = data.time
		local widget = data.widget
		time = time + dt
		local time_progress = math.clamp(time / duration, 0, 1)
		local anim_progress = math.ease_out_exp(time_progress)
		local target_value = end_value - start_value
		local anim_fraction = start_value + target_value * anim_progress
		widget.content.progress = anim_fraction

		if time_progress < 1 then
			data.time = time
		else
			stats_animation_progress[i] = nil
		end
	end
end

ViewElementWeaponStats._set_preview_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.stat_divider.content.visible = visible
	widgets_by_name.action_divider.content.visible = visible
	widgets_by_name.resource_title.content.visible = visible
	widgets_by_name.resource_value.content.visible = visible
	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]
			widget.content.visible = visible
		end
	end

	local action_texts_widgets = self._action_texts_widgets

	if action_texts_widgets then
		for i = 1, #action_texts_widgets do
			local widget = action_texts_widgets[i]
			widget.content.visible = visible
		end
	end

	local keyword_texts_widgets = self._keyword_texts_widgets

	if keyword_texts_widgets then
		for i = 1, #keyword_texts_widgets do
			local widget = keyword_texts_widgets[i]
			widget.content.visible = visible
		end
	end

	local trait_widgets = self._trait_widgets

	if trait_widgets then
		for i = 1, #trait_widgets do
			local widget = trait_widgets[i]
			widget.content.visible = visible
		end
	end
end

return ViewElementWeaponStats
