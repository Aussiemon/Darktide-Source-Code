-- chunkname: @scripts/ui/view_elements/view_element_wintrack_mastery/view_element_wintrack_mastery.lua

local Definitions = require("scripts/ui/view_elements/view_element_wintrack_mastery/view_element_wintrack_mastery_definitions")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementWintrackMasterySettings = require("scripts/ui/view_elements/view_element_wintrack_mastery/view_element_wintrack_mastery_settings")
local MasteryContentBlueprints = require("scripts/ui/views/mastery_view/mastery_view_blueprints")
local ViewElementWintrack = require("scripts/ui/view_elements/view_element_wintrack/view_element_wintrack")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ViewElementWintrackMastery = class("ViewElementWintrackMastery", "ViewElementWintrack")

ViewElementWintrackMastery.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementWintrackMastery.super.init(self, parent, draw_layer, start_scale, optional_menu_settings, Definitions)
end

ViewElementWintrackMastery._create_reward_widgets = function (self, rewards, ui_renderer)
	local widgets = {}
	local item_widgets = {}
	local item_size = ViewElementWintrackMasterySettings.item_size
	local amount = #rewards
	local bar_width = self:_get_progress_bars_width()
	local distance_between_reward = bar_width / self._num_rewards_per_bar
	local pass_template = self._definitions.reward_base_pass_template
	local scenegraph_id = "reward"
	local reward_width, reward_height = self:_scenegraph_size(scenegraph_id)
	local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id)
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local ContentBlueprints, blueprint_widget_type_by_slot = generate_blueprints_function(item_size)

	self._content_blueprints = ContentBlueprints
	self._blueprint_widget_type_by_slot = blueprint_widget_type_by_slot

	local offset_x = -(reward_width * 0.5)
	local reward_item_scenegraph_id = "reward_item"
	local reward_item_width, reward_item_height = self:_scenegraph_size(reward_item_scenegraph_id)

	for i = 1, amount do
		local reward = rewards[i]
		local items = reward.items
		local filtered_items = {}

		for ii = 1, #items do
			local item = items[ii]
			local type = item.type

			if not type or type and (not string.find(type, "mark_unlock") or type == "mark_unlock") then
				filtered_items[#filtered_items + 1] = item
			end
		end

		if not table.is_empty(filtered_items) then
			local first_item = filtered_items[1]
			local index = #item_widgets + 1
			local reward_item_widget_name = "reward_item_widget_" .. index
			local required_points = reward.points_required
			local mastery_item_widget_element = {
				hide_tooltip = false,
				show_icon = true,
				item = first_item,
				items = filtered_items,
				required_points = required_points,
				size = {
					reward_item_width,
					reward_item_height,
				},
				icon = first_item.icon,
				display_name = first_item.display_name,
				text = first_item.text,
				icon_size = first_item.icon_size,
				icon_color = first_item.icon_color,
				icon_material_values = first_item.icon_material_values,
				type = reward.type,
			}
			local template = MasteryContentBlueprints[first_item.widget_type]
			local mastery_item_pass_template = template and template.pass_template
			local mastery_item_size = template.size_function and template.size_function(self, mastery_item_widget_element, ui_renderer) or mastery_item_pass_template.size
			local mastery_item_widget_definition = UIWidget.create_definition(mastery_item_pass_template, "reward_item", nil, mastery_item_size)
			local mastery_item_widget = self:_create_widget(reward_item_widget_name, mastery_item_widget_definition)

			item_widgets[index] = mastery_item_widget
			mastery_item_widget.type = first_item.widget_type

			local callback_name, secondary_callback_name, double_click_callback

			template.init(self, mastery_item_widget, mastery_item_widget_element)

			local name = "reward_widget_" .. index
			local widget = self:_create_widget(name, widget_definition)

			widget.offset[1] = offset_x
			widget.content.required_points = required_points
			mastery_item_widget.style.style_id_1.on_pressed_sound = nil

			if #filtered_items > 1 then
				widget.content.reward_count = "+" .. tostring(#filtered_items - 1)
			end

			widgets[index] = widget
			offset_x = offset_x + distance_between_reward
		end
	end

	self._total_reward_track_length = distance_between_reward * self._num_rewards_per_bar
	self._current_reward_page_index = 1
	self._reward_widgets = widgets
	self._reward_item_widgets = item_widgets
end

ViewElementWintrackMastery._on_reward_items_hover_start = function (self, items, index, widget)
	index = index or 1

	if self._currently_hovered_item then
		self:_on_reward_items_hover_stop()
	end

	local item = items[index]

	self._currently_hovered_item = item
	self._currently_hovered_items = items
	self._currently_hovered_items_index = index
	self._currently_hovered_widget = widget

	local no_tooltip = widget and widget.content.element and widget.content.element.hide_tooltip

	if item and not no_tooltip then
		local description = ""
		local icon
		local title = ""
		local icon_size = {
			0,
			0,
		}

		if item.type == "perk_unlock" then
			title = item.display_name or ""
			description = Localize("loc_mastery_reward_perk_tooltip")
		elseif string.find(item.type, "mark_unlock") then
			description = Localize("loc_mastery_reward_mark_tooltip")
			icon = item.icon
			title = item.display_name or ""
			icon_size = item.icon_size and table.clone(item.icon_size) or {
				0,
				0,
			}
		elseif item.type == "mastery_points" then
			title = item.display_name or ""
			description = Localize("loc_mastery_reward_blessingpoints_tooltip")
		elseif item.type == "expertise_point" then
			title = item.display_name or ""
			description = Localize("loc_mastery_reward_power_tooltip")
		else
			return
		end

		local title_font_style = self._widgets_by_name.tooltip.style.title
		local description_font_style = self._widgets_by_name.tooltip.style.description
		local icon_style = self._widgets_by_name.tooltip.style.icon

		self._widgets_by_name.tooltip.content.description = description
		self._widgets_by_name.tooltip.content.icon = icon
		self._widgets_by_name.tooltip.content.title = title
		self._widgets_by_name.tooltip.content.visible = description ~= "" or title ~= "" or icon
		icon_style.size = icon_size

		local title_font_style_options = UIFonts.get_font_options_by_style(title_font_style)
		local description_font_style_options = UIFonts.get_font_options_by_style(description_font_style)
		local tooltip_size = self._ui_scenegraph.tooltip.size
		local _, title_height = UIRenderer.text_size(self._ui_resource_renderer, title, title_font_style.font_type, title_font_style.font_size, {
			tooltip_size[1] - 40,
			0,
		}, title_font_style_options)
		local _, description_height = UIRenderer.text_size(self._ui_resource_renderer, description, description_font_style.font_type, description_font_style.font_size, {
			tooltip_size[1] - 40,
			0,
		}, description_font_style_options)
		local added_margin = 40

		title_font_style.offset[2] = added_margin * 0.5
		icon_style.offset[2] = title_font_style.offset[2] + title_height + 10
		description_font_style.offset[2] = icon_style.offset[2] + (icon and icon_size[2] + 10 or 20)
		added_margin = added_margin + (icon and 10 or 0)
		added_margin = added_margin + (icon and description ~= "" and 10 or description ~= "" and 30 or 0)

		local total_size = (title_height or 0) + (description_height or 0) + (icon and icon_size[2] or 0) + added_margin

		self:_set_scenegraph_size("tooltip", nil, total_size)
	end

	self:_update_reward_tooltip_hint()
end

ViewElementWintrackMastery.tooltip_visible = function (self)
	return self._widgets_by_name.tooltip.content.visible
end

ViewElementWintrackMastery._on_reward_items_hover_stop = function (self)
	self._currently_hovered_item = nil
	self._currently_hovered_items = nil
	self._currently_hovered_items_index = nil
	self._currently_hovered_widget = nil

	self:_update_reward_tooltip_hint()

	self._widgets_by_name.tooltip.content.visible = false
end

return ViewElementWintrackMastery
