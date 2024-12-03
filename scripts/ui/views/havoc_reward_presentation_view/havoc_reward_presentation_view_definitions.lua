-- chunkname: @scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local ColorUtilities = require("scripts/utilities/ui/colors")
local badge_size = {
	210,
	168,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			112,
			230,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			112,
			230,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			78,
			212,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			78,
			212,
		},
		position = {
			0,
			0,
			62,
		},
	},
	display_name = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1700,
			200,
		},
		position = {
			0,
			120,
			3,
		},
	},
	divider = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			936,
			44,
		},
		position = {
			0,
			0,
			4,
		},
	},
	sub_display_name = {
		horizontal_alignment = "center",
		parent = "divider",
		vertical_alignment = "center",
		size = {
			1700,
			132,
		},
		position = {
			0,
			60,
			4,
		},
	},
	rewards = {
		horizontal_alignment = "center",
		parent = "sub_display_name",
		vertical_alignment = "top",
		size = {
			1700,
			100,
		},
		position = {
			0,
			120,
			4,
		},
	},
	badge = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = badge_size,
		position = {
			0,
			250,
			4,
		},
	},
}
local rank_badges = {
	{
		level = 1,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_1",
	},
	{
		level = 5,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_2",
	},
	{
		level = 10,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_3",
	},
	{
		level = 15,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_4",
	},
	{
		level = 20,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_5",
	},
	{
		level = 25,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_6",
	},
	{
		level = 30,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_7",
	},
	{
		level = 35,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_8",
	},
}
local sub_title_style = table.clone(UIFontSettings.terminal_header_2)

sub_title_style.text_horizontal_alignment = "center"
sub_title_style.horizontal_alignment = "center"
sub_title_style.text_vertical_alignment = "top"
sub_title_style.vertical_alignment = "top"
sub_title_style.offset = {
	0,
	0,
	1,
}
sub_title_style.font_size = 24
sub_title_style.text_color = Color.terminal_text_body_sub_header(255, true)

local sub_display_name_style = table.clone(sub_title_style)

sub_display_name_style.text_color = Color.terminal_text_body(255, true)
sub_display_name_style.text_horizontal_alignment = "center"
sub_display_name_style.text_vertical_alignment = "center"
sub_display_name_style.font_size = 36

local display_name_style = table.clone(UIFontSettings.header_1)

display_name_style.offset = {
	0,
	0,
	1,
}
display_name_style.text_horizontal_alignment = "center"
display_name_style.text_vertical_alignment = "center"
display_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"

local widget_definitions = {
	rank_display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Localize("loc_havoc_reset_Highest_order"),
			style = display_name_style,
		},
	}, "display_name", {
		visible = false,
	}),
	reward_display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Localize("loc_havoc_reset_rewards"),
			style = sub_display_name_style,
		},
	}, "sub_display_name", {
		visible = false,
	}),
	divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "divivder",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divivder",
			style = {
				scale_to_material = true,
			},
		},
	}, "divider", {
		visible = false,
	}),
}
local reward_defintions = {
	size = {
		200,
		66,
	},
	passes = {
		{
			pass_type = "texture",
			value = "",
			value_id = "currency",
			style = {
				horizontal_alignment = "center",
				size = {
					78,
					66,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "1000",
			value_id = "text",
			style = {
				font_site = 24,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				vertical_alignment = "bottom",
				offset = {
					0,
					80,
					1,
				},
				text_color = Color.white(255, true),
			},
		},
	},
	init = function (widget, config)
		local currency_data = WalletSettings[config.currency]

		widget.content.currency = currency_data.icon_texture_big
		widget.content.text = TextUtilities.format_currency(config.value)
	end,
}
local havoc_info = Managers.data_service.havoc:get_settings()
local min_rank = 1
local max_rank = havoc_info.max_rank
local max_charges = havoc_info.max_charges
local badge_definitions = {
	size = badge_size,
	pass_template_function = function (parent, config)
		local icon_size = {
			75,
			75,
		}
		local letter_size = {
			43,
			43,
		}
		local letter_margin = 9
		local current_charges = config.current and config.current.charges
		local previous_charges = config.previous and config.previous.charges
		local previous_rank = config.previous and config.previous.rank
		local current_rank = config.current and config.current.rank
		local are_ranks_equal = previous_rank == current_rank
		local use_charges = current_charges and previous_charges
		local is_min = are_ranks_equal and previous_rank == min_rank
		local previous_rank_badge = rank_badges[#rank_badges]
		local current_rank_badge = rank_badges[#rank_badges]
		local found_prev_badge = false
		local found_current_badge = false

		for i = 1, #rank_badges do
			local rank_badge = rank_badges[i]
			local badge_level = rank_badge.level

			if previous_rank and not found_prev_badge and previous_rank < badge_level then
				previous_rank_badge = rank_badges[i - 1]
				found_prev_badge = true
			end

			if current_rank and not found_current_badge and current_rank < badge_level then
				current_rank_badge = rank_badges[i - 1]
				found_current_badge = true
			end

			if found_prev_badge and found_current_badge then
				break
			end
		end

		if not previous_rank and current_rank then
			previous_rank_badge = current_rank_badge
		elseif not current_rank and previous_rank then
			current_rank_badge = previous_rank_badge
		end

		local pass_templates = {
			{
				pass_type = "circle",
				style_id = "havoc_badge_background",
				value_id = "havoc_badge_background",
				style = {
					horizontal_alignment = "center",
					offset = {
						0,
						74,
						4,
					},
					size = {
						icon_size[1],
						icon_size[2],
					},
					color = Color.black(0, true),
					start_color = Color.black(0, true),
					in_focus_color = Color.black(255, true),
				},
			},
		}

		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "havoc_rank_badge",
			value = "content/ui/materials/effects/screen/havoc_01_rank_anim",
			value_id = "havoc_rank_badge",
			style = {
				horizontal_alignment = "center",
				color = Color.white(0, true),
				start_color = Color.white(0, true),
				in_focus_color = Color.white(255, true),
				offset = {
					0,
					40,
					10,
				},
				size = {
					badge_size[1],
					badge_size[2],
				},
				material_values = {
					AnimationSpeedFireAmountt = {
						0,
						0.045,
					},
					beforeTexure = previous_rank_badge.texture,
					afterTexture = current_rank_badge.texture,
				},
			},
		}

		if use_charges and not is_min then
			local start_x_offset = 0
			local x_offset = badge_size[1] / max_charges + 10

			for i = 1, max_charges do
				local current_x_offset = start_x_offset + x_offset * (i - 1)

				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "havoc_charge_" .. i,
					style_id = "havoc_charge_" .. i,
					style = {
						horizontal_alignment = "left",
						vertical_alignment = "top",
						color = Color.terminal_text_header(0, true),
						start_color = Color.terminal_text_header(0, true),
						in_focus_color = Color.terminal_text_header(255, true),
						offset = {
							current_x_offset,
							badge_size[2] + 90,
							1,
						},
						size = {
							62,
							62,
						},
						material_values = {
							texture_map = "content/ui/textures/icons/generic/havoc_strike",
						},
					},
				}
			end
		end

		if previous_rank then
			local previous_rank_to_string = tostring(previous_rank)
			local previous_rank_width = (letter_size[1] - letter_margin * 2) * #previous_rank_to_string
			local start_current_offset = (badge_size[1] - previous_rank_width) * 0.5 - letter_margin

			for i = 1, #previous_rank_to_string do
				local rank_number = tonumber(string.sub(previous_rank_to_string, i, i))
				local x_offset = start_current_offset + (letter_size[1] - letter_margin * 2) * (i - 1)

				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/frames/havoc_numbers",
					value_id = "previous_havoc_rank_value_" .. i,
					style_id = "previous_havoc_rank_value_" .. i,
					style = {
						horizontal_alignment = "left",
						start_offset_y = 90,
						color = Color.white(0, true),
						start_color = Color.white(0, true),
						in_focus_color = Color.white(255, true),
						size = {
							letter_size[1],
							letter_size[2],
						},
						offset = {
							x_offset,
							90,
							5,
						},
						material_values = {
							number = rank_number,
						},
					},
				}
			end
		end

		if current_rank then
			local current_rank_to_string = tostring(current_rank)
			local current_rank_width = (letter_size[1] - letter_margin * 2) * #current_rank_to_string
			local start_next_offset = (badge_size[1] - current_rank_width) * 0.5 - letter_margin

			for i = 1, #current_rank_to_string do
				local rank_number = tonumber(string.sub(current_rank_to_string, i, i))
				local x_offset = start_next_offset + (letter_size[1] - letter_margin * 2) * (i - 1)

				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/frames/havoc_numbers",
					value_id = "current_havoc_rank_value_" .. i,
					style_id = "current_havoc_rank_value_" .. i,
					style = {
						horizontal_alignment = "left",
						start_offset_y = 90,
						size = {
							letter_size[1],
							letter_size[2],
						},
						color = Color.white(0, true),
						start_color = Color.white(0, true),
						in_focus_color = Color.white(255, true),
						offset = {
							x_offset,
							90,
							6,
						},
						material_values = {
							number = rank_number,
						},
					},
				}
			end
		end

		return pass_templates
	end,
	init = function (parent, widget, config)
		local content = widget.content
		local style = widget.style

		content.current_charges = config.current and config.current.charges
		content.previous_charges = config.previous and config.previous.charges
		content.previous_rank = config.previous and config.previous.rank
		content.current_rank = config.current and config.current.rank

		for i = 1, max_charges do
			local charge_style = style["havoc_charge_" .. i]

			if charge_style then
				style["havoc_charge_" .. i].in_focus_color[1] = i <= content.previous_charges and 255 or 128
			end
		end

		local previous_rank_to_string = content.previous_rank and tostring(content.previous_rank)
		local current_rank_to_string = content.current_rank and tostring(content.current_rank)

		content.previous_rank_size = previous_rank_to_string and #previous_rank_to_string
		content.current_rank_size = current_rank_to_string and #current_rank_to_string
	end,
}

local function badge_fade_in(widget, progress)
	local style_ids = {
		"havoc_badge_background",
		"background_havoc_rank_badge",
		"previous_havoc_rank_value_1",
		"previous_havoc_rank_value_2",
		"havoc_charge_1",
		"havoc_charge_2",
		"havoc_charge_3",
		"havoc_rank_badge",
	}
	local anim_progress = math.easeInCubic(progress)

	for i = 1, #style_ids do
		local style_id = style_ids[i]
		local style = widget.style[style_id]

		if style then
			ColorUtilities.color_lerp(style.start_color, style.in_focus_color, anim_progress, style.color)
		end
	end
end

local y_anim_offset = 20

local function charge_update_anim(parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
	local content = widget.content
	local style = widget.style
	local current_charges = content.current_charges
	local previous_charges = content.previous_charges

	if current_charges and previous_charges then
		local decrease_charges = current_charges < previous_charges
		local increase_charges = previous_charges < current_charges
		local anim_charge_progress = math.easeInCubic(progress)

		for i = 1, max_charges do
			local charge_style = style["havoc_charge_" .. i]

			if charge_style then
				if decrease_charges and current_charges < i then
					charge_style.color[1] = style["havoc_charge_" .. i].in_focus_color[1] - anim_charge_progress * 128
				elseif increase_charges and previous_charges < i and i <= current_charges then
					charge_style.color[1] = style["havoc_charge_" .. i].in_focus_color[1] + anim_charge_progress * 127
				end
			end
		end
	end
end

local function badge_update_anim(parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
	local content = widget.content
	local style = widget.style

	if style.havoc_rank_badge.material_values.afterTexture ~= style.havoc_rank_badge.material_values.beforeTexure then
		style.havoc_rank_badge.material_values.AnimationSpeedFireAmountt[1] = progress
	end
end

local animations = {
	weekly = {
		{
			end_time = 1,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				badge_fade_in(widget, progress)
			end,
		},
	},
	rank_increase = {
		{
			end_time = 1,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				badge_fade_in(widget, progress)
			end,
		},
		{
			end_time = 2,
			name = "change_current",
			start_time = 1,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local content = widget.content
				local style = widget.style

				for i = 1, content.previous_rank_size do
					style["previous_havoc_rank_value_" .. i].color[1] = 255 - anim_progress * 255
					style["previous_havoc_rank_value_" .. i].offset[2] = style["previous_havoc_rank_value_" .. i].start_offset_y - y_anim_offset * anim_progress
				end
			end,
		},
		{
			end_time = 2.2,
			name = "change_next",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local content = widget.content
				local style = widget.style

				for i = 1, content.current_rank_size do
					style["current_havoc_rank_value_" .. i].color[1] = anim_progress * 255
					style["current_havoc_rank_value_" .. i].offset[2] = style["current_havoc_rank_value_" .. i].start_offset_y + y_anim_offset - y_anim_offset * anim_progress
				end
			end,
		},
		{
			end_time = 1.8,
			name = "change_charge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = charge_update_anim,
		},
		{
			end_time = 3,
			name = "change_badge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = badge_update_anim,
		},
	},
	rank_decrease = {
		{
			end_time = 1,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				badge_fade_in(widget, progress)
			end,
		},
		{
			end_time = 2,
			name = "change_current",
			start_time = 1,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local content = widget.content
				local style = widget.style

				for i = 1, content.previous_rank_size do
					style["previous_havoc_rank_value_" .. i].color[1] = 255 - anim_progress * 255
					style["previous_havoc_rank_value_" .. i].offset[2] = style["previous_havoc_rank_value_" .. i].start_offset_y + y_anim_offset * anim_progress
				end
			end,
		},
		{
			end_time = 2.2,
			name = "change_next",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local content = widget.content
				local style = widget.style

				for i = 1, content.current_rank_size do
					style["current_havoc_rank_value_" .. i].color[1] = anim_progress * 255
					style["current_havoc_rank_value_" .. i].offset[2] = style["current_havoc_rank_value_" .. i].start_offset_y - y_anim_offset + y_anim_offset * anim_progress
				end
			end,
		},
		{
			end_time = 1.8,
			name = "change_charge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = charge_update_anim,
		},
		{
			end_time = 3,
			name = "change_badge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = badge_update_anim,
		},
	},
	charge_change = {
		{
			end_time = 1,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				badge_fade_in(widget, progress)
			end,
		},
		{
			end_time = 1.8,
			name = "change_charge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = charge_update_anim,
		},
		{
			end_time = 3,
			name = "change_badge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				return
			end,
			update = badge_update_anim,
		},
	},
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	reward_defintions = reward_defintions,
	badge_definitions = badge_definitions,
	animations = animations,
}
