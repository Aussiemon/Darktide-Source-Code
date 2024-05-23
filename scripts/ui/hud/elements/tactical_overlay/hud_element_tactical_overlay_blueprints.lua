-- chunkname: @scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_blueprints.lua

local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local ContractCriteriaParser = require("scripts/utilities/contract_criteria_parser")
local ElementSettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local WalletSettings = require("scripts/settings/wallet_settings")
local Blueprints = {}
local internal_buffer = ElementSettings.internal_buffer
local buffer = ElementSettings.buffer
local icon_size = ElementSettings.right_header_height
local line_width = ElementSettings.line_width
local _math_round = math.round
local _text_extra_options = {}

local function _text_height(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local height = UIRenderer.text_height(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return _math_round(height)
end

local _disabled_color = Color.terminal_text_body_sub_header(255, true)
local _dark_text_color = Color.terminal_text_body_sub_header(255, true)

local function _format_progress(current, goal, use_complete_text)
	local is_complete = goal <= current

	if is_complete and use_complete_text then
		return Localize("loc_contracts_task_completed")
	end

	return string.format("%s/%s", current, TextUtils.apply_color_to_text(goal, _dark_text_color))
end

local _achievement_completed_color = Color.termianl_icon_dark(255, true)
local content_width = ElementSettings.right_grid_width - 2 * buffer
local text_width = content_width - icon_size - buffer
local base_text_style = {
	font_size = 19,
	horizontal_alignment = "right",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	offset = {
		-buffer,
		buffer,
		1,
	},
	size = {
		text_width,
		100,
	},
	text_color = Color.terminal_text_body(255, true),
}
local right_content_description_style = table.add_missing({
	font_size = 19,
	text_color = Color.terminal_text_body(255, true),
}, base_text_style)
local right_content_header_style = table.add_missing({
	font_size = 16,
	text_color = Color.terminal_text_body_sub_header(255, true),
}, base_text_style)
local right_content_title_style = table.add_missing({
	font_size = 21,
	text_color = Color.terminal_text_header(255, true),
}, base_text_style)
local right_content_progression_style = table.add_missing({
	font_size = 21,
	text_color = Color.terminal_text_body(255, true),
}, base_text_style)
local right_content_reward_style = table.add_missing({
	font_size = 22,
	text_horizontal_alignment = "right",
	text_color = Color.terminal_text_body(255, true),
}, base_text_style)
local base_bar_style = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		text_width,
		line_width,
		1,
	},
}
local right_content_progress_border = table.add_missing({
	offset = {
		2 * buffer + icon_size,
		buffer,
		1,
	},
	color = Color.terminal_frame(255, true),
}, base_bar_style)
local right_content_progress_background = table.add_missing({
	offset = {
		2 * buffer + icon_size + 1,
		buffer + 1,
		2,
	},
	size = {
		text_width - 2,
		line_width - 2,
		1,
	},
	color = Color.ui_hud_green_dark(255, true),
}, base_bar_style)
local right_content_progress_bar = table.add_missing({
	offset = {
		2 * buffer + icon_size,
		buffer,
		3,
	},
	color = Color.terminal_text_body(255, true),
}, base_bar_style)
local right_full_progress_border = table.add_missing({
	offset = {
		buffer,
		buffer,
		1,
	},
	size = {
		content_width,
		line_width,
		1,
	},
}, right_content_progress_border)
local right_full_progress_background = table.add_missing({
	offset = {
		buffer + 1,
		buffer,
		2,
	},
	size = {
		content_width - 2,
		line_width - 2,
		1,
	},
}, right_content_progress_background)
local right_full_progress_bar = table.add_missing({
	offset = {
		buffer,
		buffer,
		3,
	},
	size = {
		content_width,
		line_width,
		1,
	},
}, right_content_progress_bar)

Blueprints.achievement = {
	size = {
		ElementSettings.right_grid_width,
		0,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "title",
			value = "<UNDEFINED>",
			value_id = "title",
			style = right_content_title_style,
		},
		{
			pass_type = "rect",
			style_id = "progress_border",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_content_progress_border,
		},
		{
			pass_type = "rect",
			style_id = "progress_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_content_progress_background,
		},
		{
			pass_type = "rect",
			style_id = "progress_bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_content_progress_bar,
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "<UNDEFINED>",
			value_id = "description",
			style = right_content_description_style,
		},
		{
			pass_type = "text",
			style_id = "progress",
			value = "<UNDEFINED>",
			value_id = "progress",
			style = right_content_progression_style,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/achievements/achievement_icon_container",
			value_id = "icon",
			style = {
				size = {
					icon_size,
					icon_size,
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					buffer,
					buffer,
					1,
				},
				material_values = {
					frame = "content/ui/textures/icons/achievements/frames/default_frame",
					icon_color = Color.white(255, true),
					background_color = Color.white(0, true),
				},
			},
		},
	},
	complete = function (widget)
		widget.is_complete = true

		local _, style = widget.content, widget.style

		style.progress_bar.color = _disabled_color
		style.title.text_color = _disabled_color
		style.description.text_color = _disabled_color
		style.progress.text_color = _disabled_color
		style.icon.color = _achievement_completed_color
	end,
	init = function (parent, widget, config, ui_renderer)
		local achievement_id = config.id
		local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
		local content, style = widget.content, widget.style
		local size = widget.content.size[2]
		local player = Managers.player:local_player(1)
		local is_complete = Managers.achievements:achievement_completed(player, achievement_definition.id)

		style.icon.material_values.icon = achievement_definition.icon
		content.title = AchievementUIHelper.localized_title(achievement_definition)
		style.title.offset[2] = size
		size = size + _text_height(ui_renderer, content.title, style.title) + internal_buffer
		content.description = AchievementUIHelper.localized_description(achievement_definition)
		style.description.offset[2] = size

		local description_height = _text_height(ui_renderer, content.description, style.description)

		while description_height > ElementSettings.max_penance_description_height do
			local string_length = Utf8.string_length(content.description)

			content.description = string.format("%s...", Utf8.sub_string(content.description, 1, math.max(0, string_length - 8)))
			description_height = _text_height(ui_renderer, content.description, style.description)
		end

		size = size + description_height + internal_buffer

		local achievement_type = AchievementTypes[achievement_definition.type]
		local has_progress = not achievement_definition.flags[AchievementFlags.hide_progress] and achievement_type.get_progress ~= nil

		if has_progress then
			local local_player = Managers.player:local_player(1)
			local at, target = achievement_type.get_progress(achievement_definition, local_player, true)

			if is_complete then
				at = target
			end

			local percent_done = at / target

			style.progress_border.offset[2] = size
			style.progress_background.offset[2] = size + 1
			style.progress_bar.offset[2] = size
			style.progress_bar.size[1] = text_width * percent_done
			size = size + style.progress_bar.size[2] + internal_buffer
			content.progress = _format_progress(at, target)
			style.progress.offset[2] = size
			size = size + _text_height(ui_renderer, content.progress, style.progress) + internal_buffer
		else
			style.progress_border.visible = false
			style.progress_background.visible = false
			style.progress_bar.visible = false
			content.progress = ""
			style.progress.visible = false
		end

		size = size + buffer - internal_buffer
		content.size[2] = math.max(2 * buffer + icon_size, size)
		widget.achievement_id = achievement_id

		if is_complete and not widget.is_complete then
			Blueprints.achievement.complete(widget)
		end
	end,
	update = function (parent, widget, ui_renderer)
		local achievement_id = widget.achievement_id
		local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
		local content, style = widget.content, widget.style
		local was_complete = widget.is_complete
		local achievement_type = AchievementTypes[achievement_definition.type]
		local has_progress = not achievement_definition.flags[AchievementFlags.hide_progress] and achievement_type.get_progress ~= nil

		if has_progress then
			local local_player = Managers.player:local_player(1)
			local at, target = achievement_type.get_progress(achievement_definition, local_player, true)

			if was_complete then
				at = target
			end

			content.progress = _format_progress(at, target, true)

			local percent_done = math.min(at / target, 1)

			style.progress_bar.size[1] = text_width * percent_done
		end

		local player = Managers.player:local_player(1)
		local is_complete = Managers.achievements:achievement_completed(player, achievement_definition.id)

		if is_complete and not was_complete then
			Blueprints.achievement.complete(widget)
		end
	end,
}
Blueprints.contract = {
	size = {
		ElementSettings.right_grid_width,
		0,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "title",
			value = "<UNDEFINED>",
			value_id = "title",
			style = right_content_description_style,
		},
		{
			pass_type = "text",
			style_id = "progress",
			value = "<UNDEFINED>",
			value_id = "progress",
			style = right_content_progression_style,
		},
		{
			pass_type = "rect",
			style_id = "progress_border",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_content_progress_border,
		},
		{
			pass_type = "rect",
			style_id = "progress_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_content_progress_background,
		},
		{
			pass_type = "rect",
			style_id = "progress_bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_content_progress_bar,
		},
		{
			pass_type = "text",
			style_id = "reward",
			value = "<UNDEFINED>",
			value_id = "reward",
			style = right_content_reward_style,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/contracts/contract_task",
			value_id = "icon",
			style = {
				size = {
					icon_size,
					icon_size,
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					buffer,
					buffer,
					1,
				},
				material_values = {
					checkmark_color = Color.terminal_text_body_sub_header(255, true),
				},
			},
		},
	},
	complete = function (widget)
		widget.is_complete = true

		local _, style = widget.content, widget.style

		style.progress_bar.color = _disabled_color
		style.title.text_color = _disabled_color
		style.progress.text_color = _disabled_color
		style.reward.visible = false

		local icon_style = style.icon

		icon_style.color = _achievement_completed_color
		icon_style.material_values.checkbox = 1
	end,
	init = function (parent, widget, config, ui_renderer)
		local task = config.task
		local criteria = task.criteria
		local title, _ = ContractCriteriaParser.localize_criteria(criteria)
		local content, style = widget.content, widget.style
		local size = widget.content.size[2]
		local parsed_criteria = ContractCriteriaParser.parse_backend_criteria(criteria)
		local at, target = parsed_criteria.at, parsed_criteria.target

		at = math.min(at, target)
		style.icon.material_values.contract_type = ContractCriteriaParser.icon(criteria)
		style.icon.material_values.checkbox = 0
		content.title = title
		style.title.offset[2] = size
		size = size + _text_height(ui_renderer, content.title, style.title) + internal_buffer

		local percent_done = at / target

		style.progress_border.offset[2] = size
		style.progress_background.offset[2] = size + 1
		style.progress_bar.offset[2] = size
		style.progress_bar.size[1] = text_width * percent_done
		size = size + style.progress_bar.size[2] + internal_buffer
		content.progress = _format_progress(at, target, true)
		content.reward = string.format("%d %s", config.reward or 0, WalletSettings.marks.string_symbol)
		style.progress.offset[2] = size
		style.reward.offset[2] = size
		size = size + _text_height(ui_renderer, content.progress, style.progress) + internal_buffer
		size = size + buffer - internal_buffer
		content.size[2] = math.max(2 * buffer + icon_size, size)
		widget.contract_criteria = parsed_criteria

		local is_complete = at == target

		if is_complete and not widget.is_complete then
			Blueprints.contract.complete(widget)
		end
	end,
	update = function (parent, widget, ui_renderer)
		local style = widget.style
		local content = widget.content
		local contract_criteria = widget.contract_criteria
		local at, target = contract_criteria.at, contract_criteria.target
		local stat_name = contract_criteria.stat_name

		if stat_name then
			at = at + Managers.stats:read_user_stat(1, stat_name)
		end

		at = math.min(at, target)

		local percent_done = math.min(at / target, 1)

		content.progress = _format_progress(at, target, true)
		style.progress_bar.size[1] = text_width * percent_done

		local is_complete = at == target

		if is_complete and not widget.is_complete then
			Blueprints.contract.complete(widget)
		end
	end,
}
Blueprints.event_tier = {
	size = {
		ElementSettings.right_grid_width,
		0,
	},
	pass_template = {
		{
			pass_type = "rect",
			style_id = "progress_border",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_full_progress_border,
		},
		{
			pass_type = "rect",
			style_id = "progress_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_full_progress_background,
		},
		{
			pass_type = "rect",
			style_id = "progress_bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = right_full_progress_bar,
		},
		{
			pass_type = "text",
			style_id = "reward",
			value = "<UNDEFINED>",
			value_id = "reward",
			style = right_content_reward_style,
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "<UNDEFINED>",
			value_id = "title",
			style = table.add_missing({
				size = {
					content_width,
					100,
				},
			}, right_content_description_style),
		},
		{
			pass_type = "text",
			style_id = "progress",
			value = "<UNDEFINED>",
			value_id = "progress",
			style = table.add_missing({
				size = {
					content_width,
					100,
				},
			}, right_content_progression_style),
		},
	},
	complete = function (widget)
		widget.is_complete = true

		local _, style = widget.content, widget.style

		style.progress_bar.color = _disabled_color
		style.title.text_color = _disabled_color
		style.progress.text_color = _disabled_color
		style.reward.visible = false
	end,
	init = function (parent, widget, config, ui_renderer)
		local target = config.target
		local at = math.min(Managers.live_event:active_progress(), target)
		local template = Managers.live_event:active_template()
		local content, style = widget.content, widget.style
		local size = widget.content.size[2]
		local title = Localize(template.condition, true, {
			target = target,
		})

		content.title = title
		style.title.offset[2] = size
		size = size + _text_height(ui_renderer, content.title, style.title) + internal_buffer

		local percent_done = at / target

		style.progress_border.offset[2] = size
		style.progress_background.offset[2] = size + 1
		style.progress_bar.offset[2] = size
		style.progress_bar.size[1] = content_width * percent_done
		size = size + style.progress_bar.size[2] + internal_buffer

		local rewards = config.rewards
		local reward_strings = {}

		for i = 1, #rewards do
			local reward = rewards[i]

			if reward.type == "currency" and WalletSettings[reward.currency] then
				reward_strings[#reward_strings + 1] = string.format("%d %s", reward.amount or 0, WalletSettings[reward.currency].string_symbol)
			end
		end

		content.reward = table.concat(reward_strings, " ")
		content.progress = _format_progress(at, target, true)
		style.reward.offset[2] = size
		style.progress.offset[2] = size
		size = size + _text_height(ui_renderer, content.progress, style.progress) + internal_buffer
		widget.target = target
		content.size[2] = size

		local is_complete = at == target

		if is_complete and not widget.is_complete then
			Blueprints.event_tier.complete(widget)
		end
	end,
	update = function (parent, widget, ui_renderer)
		local content, style = widget.content, widget.style
		local target = widget.target
		local at = math.min(Managers.live_event:active_progress(), target)
		local percent_done = math.min(at / target, 1)

		content.progress = _format_progress(at, target, true)
		style.progress_bar.size[1] = content_width * percent_done

		local is_complete = at == target

		if is_complete and not widget.is_complete then
			Blueprints.event_tier.complete(widget)
		end
	end,
}

do
	local function init_text(parent, widget, config, ui_renderer)
		local text = config.text
		local size = widget.content.size[2]
		local content = widget.content
		local style = widget.style

		content.text = text
		style.text.offset[2] = size
		style.text.size[1] = ElementSettings.right_grid_width - 2 * buffer
		size = size + _text_height(ui_renderer, content.text, style.text)
		content.size[2] = size
	end

	Blueprints.body = {
		size = {
			ElementSettings.right_grid_width,
			0,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "<UNDEFINED>",
				value_id = "text",
				style = right_content_description_style,
			},
		},
		init = init_text,
	}
	Blueprints.header = {
		size = {
			ElementSettings.right_grid_width,
			ElementSettings.section_buffer,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "<UNDEFINED>",
				value_id = "text",
				style = right_content_header_style,
			},
		},
		init = init_text,
	}
	Blueprints.title = {
		size = {
			ElementSettings.right_grid_width,
			ElementSettings.internal_buffer,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "<UNDEFINED>",
				value_id = "text",
				style = right_content_title_style,
			},
		},
		init = init_text,
	}
end

Blueprints.text_icon = {
	size = {
		icon_size,
		icon_size,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "icon",
			value = "<UNDEFINED>",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				vertical_alignment = "top",
				offset = {
					0,
					-1,
					1,
				},
				size = {
					icon_size,
					icon_size - (3 + internal_buffer),
				},
				text_color = Color.terminal_text_header(255, true),
				font_size = icon_size - 8,
			},
		},
		{
			pass_type = "rect",
			style_id = "rect",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					icon_size - 2 * internal_buffer,
					3,
				},
				offset = {
					0,
					0,
					1,
				},
				color = Color.terminal_text_header(255, true),
			},
		},
	},
	init = function (parent, widget, config, ui_renderer)
		local value = config.value
		local selected = config.selected
		local is_left = config.is_left
		local content = widget.content
		local style = widget.style

		content.icon = value

		if not selected then
			style.icon.text_color = _disabled_color
		end

		if not selected or is_left then
			style.rect.size[1] = 0
			style.icon.offset[2] = style.icon.offset[2] + (3 + internal_buffer) / 2
		end
	end,
}
Blueprints.texture_icon = {
	size = {
		icon_size,
		icon_size,
	},
	pass_template = {
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/backgrounds/default_square",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					1,
					1,
				},
				size = {
					icon_size - (3 + internal_buffer),
					icon_size - (3 + internal_buffer),
				},
				color = Color.terminal_text_header(255, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "rect",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					icon_size - 2 * internal_buffer,
					3,
				},
				offset = {
					0,
					0,
					1,
				},
				color = Color.terminal_text_header(255, true),
			},
		},
	},
	init = function (parent, widget, config, ui_renderer)
		local value = config.value
		local selected = config.selected
		local is_left = config.is_left
		local content = widget.content
		local style = widget.style

		content.icon = value

		if not selected then
			style.icon.color = _disabled_color
		end

		if not selected or is_left then
			style.rect.size[1] = 0
			style.icon.offset[2] = style.icon.offset[2] + (3 + internal_buffer) / 2
		end
	end,
}

return Blueprints
