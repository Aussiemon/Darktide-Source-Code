-- chunkname: @scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_definitions.lua

local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local Settings = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_settings")
local Styles = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_styles")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Circumstances = require("scripts/settings/circumstance/circumstance_templates")
local Mutators = require("scripts/settings/mutator/mutator_templates")
local MinorModifiers = require("scripts/settings/expeditions/expedition_mission_flags")
local TextUtilities = require("scripts/utilities/ui/text")
local Definitions = {}
local UNLOCK_TYPE = ExpeditionService.UNLOCK_TYPE
local Dimensions = Settings.dimensions
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1870,
			995,
		},
		position = {
			0,
			25,
			3,
		},
	},
	_sidebar = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			483,
			995,
		},
		position = {
			0,
			0,
			4,
		},
	},
	_mission_info = {
		horizontal_alignment = "center",
		parent = "_sidebar",
		vertical_alignment = "top",
		size = {
			483,
			415,
		},
		position = {
			0,
			155,
			5,
		},
	},
	_mission_info_tabs = {
		horizontal_alignment = "center",
		parent = "_mission_info",
		vertical_alignment = "top",
		size = {
			483,
			34,
		},
		position = {
			0,
			1,
			10,
		},
	},
	_mission_info_page = {
		horizontal_alignment = "center",
		parent = "_mission_info",
		vertical_alignment = "top",
		size = {
			483,
			250,
		},
		position = {
			0,
			34,
			1,
		},
	},
	_mission_info_stats = {
		horizontal_alignment = "center",
		parent = "_mission_info",
		vertical_alignment = "top",
		size = {
			483,
			80,
		},
		position = {
			0,
			34,
			1,
		},
	},
}
local widget_definitions = {}

local function _create_checkbox(y_offset, text_size)
	local style = table.clone(Styles.mission_info_page.unlock_requirements.checkbox)
	local height_diff = text_size[2] - style.size[2]

	if height_diff > 0 then
		local offset_to_text_center = height_diff / 2

		style.offset[2] = y_offset + offset_to_text_center + -style.size_addition[2] / 2
	else
		style.offset[2] = y_offset + -style.size_addition[2] / 2
	end

	return {
		pass_type = "texture",
		value = Settings.checkbox_border,
		style = style,
	}, style.size
end

local function _create_checkmark(y_offset, text_size)
	local style = table.clone(Styles.mission_info_page.unlock_requirements.checkmark)
	local height_diff = text_size[2] - style.size[2]

	if height_diff > 0 then
		local offset_to_text_center = height_diff / 2

		style.offset[2] = y_offset + offset_to_text_center
	else
		style.offset[2] = y_offset
	end

	return {
		pass_type = "texture",
		value = Settings.checkbox_filling,
		style = style,
	}, style.size
end

local function _create_checkbox_text(y_offset, localized_string, ui_renderer)
	local style = table.clone(Styles.mission_info_page.unlock_requirements.text)

	style.offset[2] = y_offset

	local text_height = TextUtilities.text_height(ui_renderer, localized_string, style, style.size, true)

	text_height = text_height + style.extra_y_margin
	style.size = {
		style.size[1],
		text_height,
	}

	return {
		pass_type = "text",
		value = localized_string or "<missing text>",
		style = style,
	}, style.size
end

local function _create_unlocked_by_default(y_offset, ui_renderer, requirement)
	local passes = {}
	local y_sizes = {}
	local text_pass, text_size = _create_checkbox_text(y_offset, Localize("loc_unlocked_by_default"), ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

	passes[#passes + 1] = checkmark_pass
	y_sizes[#y_sizes + 1] = checkmark_size[2]

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_personal_total_loot(y_offset, ui_renderer, requirement, all_nodes)
	local passes = {}
	local y_sizes = {}
	local clamped_gathered_amount = math.clamp(requirement.gathered_amount, 0, requirement.goal_amount)
	local required_node_name = all_nodes[requirement.node].ui.display_name
	local string = Localize("loc_personal_total_loot", true, {
		node_name = Localize(required_node_name),
		gathered = clamped_gathered_amount,
		goal = requirement.goal_amount,
	})
	local text_pass, text_size = _create_checkbox_text(y_offset, string, ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	if requirement.requirements_met then
		local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

		passes[#passes + 1] = checkmark_pass
		y_sizes[#y_sizes + 1] = checkmark_size[2]
	end

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_personal_total_loot_mapwide(y_offset, ui_renderer, requirement)
	local passes = {}
	local y_sizes = {}
	local clamped_gathered_amount = math.clamp(requirement.gathered_amount, 0, requirement.goal_amount)
	local string = Localize("loc_personal_total_loot_mapwide", true, {
		gathered = clamped_gathered_amount,
		goal = requirement.goal_amount,
	})
	local text_pass, text_size = _create_checkbox_text(y_offset, string, ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	if requirement.requirements_met then
		local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

		passes[#passes + 1] = checkmark_pass
		y_sizes[#y_sizes + 1] = checkmark_size[2]
	end

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_personal_best_loot(y_offset, ui_renderer, requirement, all_nodes)
	local passes = {}
	local y_sizes = {}
	local clamped_gathered_amount = math.clamp(requirement.gathered_amount, 0, requirement.goal_amount)
	local required_node_name = all_nodes[requirement.node].ui.display_name
	local string = Localize("loc_personal_best_loot", true, {
		node_name = Localize(required_node_name),
		gathered = clamped_gathered_amount,
		goal = requirement.goal_amount,
	})
	local text_pass, text_size = _create_checkbox_text(y_offset, string, ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	if requirement.requirements_met then
		local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

		passes[#passes + 1] = checkmark_pass
		y_sizes[#y_sizes + 1] = checkmark_size[2]
	end

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_global_stat_node(y_offset, ui_renderer, requirement, all_nodes)
	local passes = {}
	local y_sizes = {}
	local clamped_gathered_amount = math.clamp(requirement.gathered_amount, 0, requirement.goal_amount)
	local required_node_name = all_nodes[requirement.node].ui.display_name
	local string = Localize("loc_global_stat_node", true, {
		node_name = Localize(required_node_name),
		gathered = clamped_gathered_amount,
		goal = requirement.goal_amount,
	})
	local text_pass, text_size = _create_checkbox_text(y_offset, string, ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	if requirement.requirements_met then
		local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

		passes[#passes + 1] = checkmark_pass
		y_sizes[#y_sizes + 1] = checkmark_size[2]
	end

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_global_stat_mapwide(y_offset, ui_renderer, requirement)
	local passes = {}
	local y_sizes = {}
	local clamped_gathered_amount = math.clamp(requirement.gathered_amount, 0, requirement.goal_amount)
	local string = Localize("loc_global_stat_map", true, {
		gathered = clamped_gathered_amount,
		goal = requirement.goal_amount,
	})
	local text_pass, text_size = _create_checkbox_text(y_offset, string, ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	if requirement.requirements_met then
		local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

		passes[#passes + 1] = checkmark_pass
		y_sizes[#y_sizes + 1] = checkmark_size[2]
	end

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_global_timer(y_offset, ui_renderer, requirement)
	local passes = {}
	local y_sizes = {}
	local time_string = os.date(nil, requirement.goal_amount)
	local string = Localize("loc_global_timer", true, {
		time_remaining = time_string,
	})
	local text_pass, text_size = _create_checkbox_text(y_offset, string, ui_renderer)

	passes[#passes + 1] = text_pass
	y_sizes[#y_sizes + 1] = text_size[2]

	local checkbox_pass, checkbox_size = _create_checkbox(y_offset, text_size)

	passes[#passes + 1] = checkbox_pass
	y_sizes[#y_sizes + 1] = checkbox_size[2]

	if requirement.requirements_met then
		local checkmark_pass, checkmark_size = _create_checkmark(y_offset, text_size)

		passes[#passes + 1] = checkmark_pass
		y_sizes[#y_sizes + 1] = checkmark_size[2]
	end

	local largest_y_size = math.max(unpack(y_sizes))

	if largest_y_size > text_size[2] then
		text_size[2] = largest_y_size
		text_pass.style.size[2] = largest_y_size
	end

	return passes, largest_y_size
end

local function _create_requirement_list_divider(y_offset)
	local passes = {}
	local y_sizes = {}
	local center_text_style = table.clone(Styles.mission_info_page.unlock_requirements.divider_center_text)

	center_text_style.offset[2] = y_offset

	local center_text_pass = {
		pass_type = "text",
		style_id = "divider_center_text",
		value_id = "divider_center_text",
		value = Localize("loc_or_capitalized"),
		style = center_text_style,
	}
	local center_text_y_size = center_text_style.size[2]

	passes[#passes + 1] = center_text_pass
	y_sizes[#y_sizes + 1] = center_text_y_size

	local left_line_style = table.clone(Styles.mission_info_page.unlock_requirements.divider_left_line)
	local left_offset_for_text = center_text_y_size / 2 - left_line_style.size[2] / 2

	left_line_style.offset[2] = y_offset + left_offset_for_text

	local left_line_pass = {
		pass_type = "rect",
		style_id = "divider_left_line",
		style = left_line_style,
	}
	local left_line_y_size = left_line_style.size[2]

	passes[#passes + 1] = left_line_pass
	y_sizes[#y_sizes + 1] = left_line_y_size

	local right_line_style = table.clone(Styles.mission_info_page.unlock_requirements.divider_right_line)
	local right_offset_for_text = center_text_y_size / 2 - right_line_style.size[2] / 2

	right_line_style.offset[2] = y_offset + right_offset_for_text

	local right_line_pass = {
		pass_type = "rect",
		style_id = "divider_right_line",
		style = right_line_style,
	}
	local right_line_y_size = right_line_style.size[2]

	passes[#passes + 1] = right_line_pass
	y_sizes[#y_sizes + 1] = right_line_y_size

	return passes, math.max(unpack(y_sizes))
end

Definitions.create_unlock_requirements_page = function (node, all_nodes, ui_renderer)
	local passes = {}
	local y_offset = 70

	for i = 1, #node.to_unlock do
		for j = 1, #node.to_unlock[i] do
			local requirement = node.to_unlock[i][j]

			if requirement.type == UNLOCK_TYPE.unlocked_by_default then
				local requirement_passes, y_increment = _create_unlocked_by_default(y_offset, ui_renderer, requirement)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			elseif requirement.type == UNLOCK_TYPE.personal_best_loot then
				local requirement_passes, y_increment = _create_personal_best_loot(y_offset, ui_renderer, requirement, all_nodes)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			elseif requirement.type == UNLOCK_TYPE.personal_total_loot then
				local requirement_passes, y_increment = _create_personal_total_loot(y_offset, ui_renderer, requirement, all_nodes)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			elseif requirement.type == UNLOCK_TYPE.personal_total_loot_mapwide then
				local requirement_passes, y_increment = _create_personal_total_loot_mapwide(y_offset, ui_renderer, requirement, all_nodes)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			elseif requirement.type == UNLOCK_TYPE.global_stat_node then
				local requirement_passes, y_increment = _create_global_stat_node(y_offset, ui_renderer, requirement, all_nodes)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			elseif requirement.type == UNLOCK_TYPE.global_stat_mapwide then
				local requirement_passes, y_increment = _create_global_stat_mapwide(y_offset, ui_renderer, requirement, all_nodes)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			elseif requirement.type == UNLOCK_TYPE.global_timer then
				local requirement_passes, y_increment = _create_global_timer(y_offset, ui_renderer, requirement)

				table.append(passes, requirement_passes)

				y_offset = y_offset + y_increment
			end
		end

		if i + 1 <= #node.to_unlock then
			local divider_passes, y_increment = _create_requirement_list_divider(y_offset)

			table.append(passes, divider_passes)

			y_offset = y_offset + y_increment
		end
	end

	y_offset = y_offset + 10
	y_offset = math.clamp(y_offset, Dimensions.page_min_size[2], Dimensions.page_max_size[2])

	local frame_style = table.clone(Styles.mission_info_page.frame)

	frame_style.size[2] = y_offset

	local background_style = table.clone(Styles.mission_info_page.background)

	background_style.size[2] = y_offset

	local background_fade_style = table.clone(Styles.mission_info_page.background_fade)

	background_fade_style.offset[2] = y_offset

	local icon_style = table.clone(Styles.mission_info_page.icon)

	icon_style.material_values.symbol_atlas_index = node.ui.display_name_atlas_index or 24

	table.append(passes, {
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = frame_style,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = background_style,
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			value = Localize("loc_grid_point"),
			style = Styles.mission_info_page.title,
		},
		{
			pass_type = "text",
			style_id = "subtitle",
			value_id = "subtitle",
			value = node and node.ui and node.ui.display_name and Localize(node.ui.display_name) or "<missing node name>",
			style = Styles.mission_info_page.subtitle,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/mission_types/expedition_node_symbol",
			value_id = "icon",
			style = icon_style,
		},
		{
			pass_type = "text",
			style_id = "unlock_status",
			value = "<missing unlock status data>",
			value_id = "unlock_status",
			style = Styles.mission_info_page.unlock_requirements.unlock_status,
		},
		{
			pass_type = "texture",
			style_id = "icon_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_info_page.icon_frame,
		},
		{
			pass_type = "rect",
			style_id = "footer_line",
			style = Styles.mission_info_page.footer_line,
		},
		{
			pass_type = "rotated_texture",
			style_id = "background_fade",
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			value_id = "background_fade",
			style = background_fade_style,
		},
	})

	return UIWidget.create_definition(passes, "_mission_info_page"), y_offset
end

local function _create_composite_minor_modifiers_string(modifiers_data, ui_renderer, style)
	local composite_string = ""

	for i = 1, #modifiers_data do
		local data = modifiers_data[i]
		local string = Localize(data.ui.display_string)

		if i + 1 <= #modifiers_data then
			string = string .. "\n\n"
		end

		composite_string = composite_string .. string
	end

	local height = TextUtilities.text_height(ui_renderer, composite_string, style, style.size, true)

	return composite_string, height
end

local function _get_minor_modifiers_data(modifiers)
	local data = {}

	for i = 1, #modifiers do
		local modifier_data = MinorModifiers[modifiers[i]]

		if modifier_data then
			data[#data + 1] = modifier_data
		end
	end

	return data
end

Definitions.create_minor_modifiers_page = function (modifier_names, node, ui_renderer)
	local data = _get_minor_modifiers_data(modifier_names)

	if #data < 1 then
		return
	end

	local modifiers_style = table.clone(Styles.mission_info_page.minor_modifiers.modifiers)
	local modifiers_string, modifiers_height = _create_composite_minor_modifiers_string(data, ui_renderer, modifiers_style)

	modifiers_style.size[2] = modifiers_height

	local y_offset = modifiers_style.offset[2] + modifiers_height

	y_offset = y_offset + 10
	y_offset = math.clamp(y_offset, Dimensions.page_min_size[2], Dimensions.page_max_size[2])

	local frame_style = table.clone(Styles.mission_info_page.frame)

	frame_style.size[2] = y_offset

	local background_style = table.clone(Styles.mission_info_page.background)

	background_style.size[2] = y_offset

	local background_fade_style = table.clone(Styles.mission_info_page.background_fade)

	background_fade_style.offset[2] = y_offset

	local icon_style = table.clone(Styles.mission_info_page.icon)

	icon_style.material_values.symbol_atlas_index = node.ui.display_name_atlas_index or 24

	local passes = {
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = frame_style,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = background_style,
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			value = Localize("loc_grid_point"),
			style = Styles.mission_info_page.title,
		},
		{
			pass_type = "text",
			style_id = "subtitle",
			value_id = "subtitle",
			value = node and node.ui and node.ui.display_name and Localize(node.ui.display_name) or "<missing node name>",
			style = Styles.mission_info_page.subtitle,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/mission_types/expedition_node_symbol",
			value_id = "icon",
			style = icon_style,
		},
		{
			pass_type = "texture",
			style_id = "icon_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_info_page.icon_frame,
		},
		{
			pass_type = "rect",
			style_id = "footer_line",
			style = Styles.mission_info_page.footer_line,
		},
		{
			pass_type = "rotated_texture",
			style_id = "background_fade",
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			value_id = "background_fade",
			style = background_fade_style,
		},
		{
			pass_type = "text",
			style_id = "modifiers",
			value_id = "modifiers",
			value = modifiers_string or "<missing minor modifier data>",
			style = modifiers_style,
		},
	}

	return UIWidget.create_definition(passes, "_mission_info_page"), y_offset
end

Definitions.create_page_tab = function (icon)
	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_info_tab.frame,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = Styles.mission_info_tab.background,
		},
		{
			pass_type = "rect",
			style_id = "background_bottom_edge",
			style = Styles.mission_info_tab.background_bottom_edge,
		},
		{
			pass_type = "texture",
			style_id = "gradient",
			value = "content/ui/materials/gradients/gradient_horizontal",
			style = Styles.mission_info_tab.gradient,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			value = icon or Settings.default_tab_icon,
			style = Styles.mission_info_tab.icon,
		},
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
			style = Styles.mission_info_tab.hotspot,
		},
	}, "_mission_info_tabs", nil, Dimensions.tab_size)
end

local function _get_major_modifier_data(modifier_name)
	local ui_info = Mutators[modifier_name] and Mutators[modifier_name].ui

	if ui_info and ui_info.icon and ui_info.display_name and ui_info.description then
		return Mutators[modifier_name]
	end

	ui_info = Circumstances[modifier_name] and Circumstances[modifier_name].ui

	if ui_info and ui_info.icon and ui_info.display_name and ui_info.description then
		return Circumstances[modifier_name]
	end

	return nil
end

Definitions.create_major_modifier_page = function (modifier_name, node, ui_renderer)
	local modifier_data = _get_major_modifier_data(modifier_name)

	if not modifier_data or not modifier_data.ui then
		return nil
	end

	local category_name = modifier_data.ui.category_name and Localize(modifier_data.ui.category_name) or ""
	local display_name = modifier_data.ui.display_name and Localize(modifier_data.ui.display_name) or "<missing display name>"
	local description = modifier_data.ui.description and Localize(modifier_data.ui.description) or "<missing description>"
	local description_style = table.clone(Styles.mission_info_page.major_modifier.description)
	local description_height = TextUtilities.text_height(ui_renderer, description, description_style, description_style.size, true)

	description_style.size[2] = description_height

	local y_offset = description_style.offset[2] + description_height

	y_offset = y_offset + 10
	y_offset = math.clamp(y_offset, Dimensions.page_min_size[2], Dimensions.page_max_size[2])

	local frame_style = table.clone(Styles.mission_info_page.frame)

	frame_style.size[2] = y_offset

	local background_style = table.clone(Styles.mission_info_page.background)

	background_style.size[2] = y_offset

	local background_fade_style = table.clone(Styles.mission_info_page.background_fade)

	background_fade_style.offset[2] = y_offset

	local icon_style = table.clone(Styles.mission_info_page.icon)

	icon_style.material_values.symbol_atlas_index = node.ui.display_name_atlas_index or 24

	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = frame_style,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = background_style,
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			value = category_name,
			style = Styles.mission_info_page.title,
		},
		{
			pass_type = "text",
			style_id = "subtitle",
			value_id = "subtitle",
			value = display_name,
			style = Styles.mission_info_page.subtitle,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/mission_types/expedition_node_symbol",
			value_id = "icon",
			style = icon_style,
		},
		{
			pass_type = "texture",
			style_id = "icon_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_info_page.icon_frame,
		},
		{
			pass_type = "rect",
			style_id = "footer_line",
			style = Styles.mission_info_page.footer_line,
		},
		{
			pass_type = "text",
			style_id = "description",
			value_id = "description",
			value = description,
			style = description_style,
		},
		{
			pass_type = "rotated_texture",
			style_id = "background_fade",
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			value_id = "background_fade",
			style = background_fade_style,
		},
	}, "_mission_info_page"), y_offset
end

Definitions.create_quickplay_page = function ()
	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_info_page.frame,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = Styles.mission_info_page.background,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/mission_types_pj/mission_type_quick",
			style = Styles.mission_info_page.quickplay_page.icon,
		},
		{
			pass_type = "text",
			style_id = "title",
			value_id = "title",
			value = Localize("loc_mission_board_quickplay_header") .. " - " .. Localize("loc_mission_name_exp_wastes"),
			style = Styles.mission_info_page.quickplay_page.title,
		},
		{
			pass_type = "rect",
			style_id = "footer_line",
			style = Styles.mission_info_page.footer_line,
		},
		{
			pass_type = "text",
			style_id = "description",
			value_id = "description",
			value = Localize("loc_mission_board_quickplay_description"),
			style = Styles.mission_info_page.quickplay_page.description,
		},
		{
			pass_type = "rotated_texture",
			style_id = "background_fade",
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			value_id = "background_fade",
			style = Styles.mission_info_page.background_fade,
		},
	}, "_mission_info_page")
end

Definitions.create_mission_info_stats = function (node)
	if not node then
		return nil
	end

	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = Styles.mission_info_stats.frame,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = Styles.mission_info_stats.background,
		},
		{
			pass_type = "text",
			style_id = "personal_best_text",
			value_id = "personal_best_text",
			value = Localize("loc_expeditions_personal_best_node"),
			style = Styles.mission_info_stats.personal_best_text,
		},
		{
			pass_type = "text",
			style_id = "personal_best_number",
			value_id = "personal_best_number",
			value = node.stats and node.stats.best_loot or 0,
			style = Styles.mission_info_stats.personal_best_number,
		},
		{
			pass_type = "texture",
			style_id = "personal_best_icon",
			value_id = "personal_best_icon",
			value = Settings.loot_icon,
			style = Styles.mission_info_stats.personal_best_icon,
		},
		{
			pass_type = "rect",
			value_id = "divider_line",
			style = Styles.mission_info_stats.divider_line,
		},
		{
			pass_type = "text",
			style_id = "personal_total_text",
			value_id = "personal_total_text",
			value = Localize("loc_expeditions_personal_total_node"),
			style = Styles.mission_info_stats.personal_total_text,
		},
		{
			pass_type = "text",
			style_id = "personal_total_number",
			value_id = "personal_total_number",
			value = node.stats and node.stats.total_loot or 0,
			style = Styles.mission_info_stats.personal_total_number,
		},
		{
			pass_type = "texture",
			style_id = "personal_total_icon",
			value_id = "personal_total_icon",
			value = Settings.loot_icon,
			style = Styles.mission_info_stats.personal_total_icon,
		},
	}, "_mission_info_stats")
end

Definitions.scenegraph_definition = scenegraph_definition
Definitions.widget_definitions = widget_definitions

return settings("ViewElementExpeditionViewMissionInfoDefinitions", Definitions)
