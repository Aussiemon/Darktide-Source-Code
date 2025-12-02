-- chunkname: @scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local Text = require("scripts/utilities/ui/text")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local badge_size = {
	420,
	336,
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
			100,
			3,
		},
	},
	divider = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			306,
			48,
		},
		position = {
			0,
			55,
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
			-70,
			4,
		},
	},
	rewards = {
		horizontal_alignment = "center",
		parent = "divider",
		vertical_alignment = "top",
		size = {
			1700,
			100,
		},
		position = {
			0,
			60,
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
			140,
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
local sub_title_style = table.clone(UIFontSettings.header_1)

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
sub_title_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"

local sub_display_name_style = table.clone(sub_title_style)

sub_display_name_style.text_color = Color.white(255, true)
sub_display_name_style.text_horizontal_alignment = "center"
sub_display_name_style.text_vertical_alignment = "center"
sub_display_name_style.font_size = 48

local display_name_style = table.clone(UIFontSettings.header_1)

display_name_style.offset = {
	0,
	0,
	1,
}
display_name_style.text_horizontal_alignment = "center"
display_name_style.text_vertical_alignment = "center"
display_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"

local widget_definitions = {
	screen = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/hud/tactical_overlay_background",
			style = {
				vertical_alignment = "top",
				color = {
					255,
					0,
					0,
					0,
				},
				size_addition = {
					0,
					-60,
				},
			},
		},
	}, "screen"),
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
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			value_id = "divivder",
			style = {
				scale_to_material = true,
				color = Color.white(255, true),
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
			style_id = "currency",
			value = "",
			value_id = "currency",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_size = {
					78,
					66,
				},
				size = {
					78,
					66,
				},
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				font_size = 32,
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
		widget.content.text = Text.format_currency(config.value)
		widget.style.text.material = currency_data.font_gradient_material
		widget.content.value = config.value
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
			150,
			150,
		}
		local letter_size = {
			86,
			86,
		}
		local letter_margin = 18
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
				pass_type = "texture",
				style_id = "havoc_badge_glow",
				value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.black(0, true),
					start_color = Color.black(0, true),
					in_focus_color = Color.terminal_corner_selected(255, true),
					size = {
						400,
						400,
					},
					offset = {
						0,
						50,
						0,
					},
				},
			},
			{
				pass_type = "circle",
				style_id = "havoc_badge_background",
				value_id = "havoc_badge_background",
				style = {
					horizontal_alignment = "center",
					offset = {
						0,
						148,
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
					80,
					10,
				},
				size = {
					badge_size[1],
					badge_size[2],
				},
				material_values = {
					AnimationSpeedFireAmountt = {
						previous_rank and current_rank and current_rank < previous_rank and 1 or 0,
						0.045,
					},
					beforeTexure = previous_rank and current_rank and current_rank < previous_rank and current_rank_badge.texture or previous_rank_badge.texture,
					afterTexture = previous_rank and current_rank and current_rank < previous_rank and previous_rank_badge.texture or current_rank_badge.texture,
				},
			},
		}

		if use_charges and not is_min then
			local spacing = 10
			local x_offset = badge_size[1] / max_charges
			local start_x_offset = -((x_offset + spacing) * (max_charges - 1)) * 0.5

			for i = 1, max_charges do
				local current_x_offset = start_x_offset + (x_offset + spacing) * (i - 1)

				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "havoc_charge_" .. i,
					style_id = "havoc_charge_" .. i,
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						color = Color.terminal_text_header(0, true),
						start_color = Color.terminal_text_header(0, true),
						in_focus_color = Color.terminal_text_header(255, true),
						charges_color = Color.terminal_text_header(255, true),
						no_charges_color = {
							255,
							74,
							21,
							21,
						},
						offset = {
							current_x_offset,
							badge_size[2] + 50,
							1,
						},
						size = {
							124,
							124,
						},
						default_size = {
							124,
							124,
						},
						material_values = {
							texture_map = "content/ui/textures/icons/generic/havoc_strike",
						},
					},
				}
				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "havoc_charge_ghost_" .. i,
					style_id = "havoc_charge_ghost_" .. i,
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						color = Color.terminal_text_header(0, true),
						offset = {
							current_x_offset,
							badge_size[2] + 50,
							0,
						},
						size = {
							124,
							124,
						},
						default_size = {
							124,
							124,
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
						start_offset_y = 180,
						color = Color.white(0, true),
						start_color = Color.white(0, true),
						in_focus_color = Color.white(255, true),
						size = {
							letter_size[1],
							letter_size[2],
						},
						offset = {
							x_offset,
							180,
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
						start_offset_y = 180,
						size = {
							letter_size[1],
							letter_size[2],
						},
						color = Color.white(0, true),
						start_color = Color.white(0, true),
						in_focus_color = Color.white(255, true),
						offset = {
							x_offset,
							180,
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
				local no_charges_color = charge_style.no_charges_color

				if no_charges_color and i > content.previous_charges then
					ColorUtilities.color_copy(no_charges_color, charge_style.start_color, true)
					ColorUtilities.color_copy(no_charges_color, charge_style.in_focus_color)
				end
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
			local charge_ghost_style = style["havoc_charge_ghost_" .. i]

			if charge_style then
				local in_focus_color = charge_style.in_focus_color
				local charges_color = charge_style.charges_color
				local no_charges_color = charge_style.no_charges_color

				if decrease_charges and current_charges < i and i <= previous_charges then
					ColorUtilities.color_lerp(charges_color, no_charges_color, anim_charge_progress, charge_style.color)

					if charge_ghost_style then
						charge_ghost_style.color[1] = 255 - 255 * anim_charge_progress

						local charge_size = charge_ghost_style.size
						local charge_default_size = charge_ghost_style.default_size
						local size_add = 50 * anim_charge_progress

						charge_size[1] = charge_default_size[1] + size_add
						charge_size[2] = charge_default_size[2] + size_add
					end
				elseif increase_charges and previous_charges < i and i <= current_charges then
					ColorUtilities.color_lerp(no_charges_color, charges_color, anim_charge_progress, charge_style.color)

					if charge_ghost_style then
						charge_ghost_style.color[1] = 255 * anim_charge_progress

						local charge_size = charge_ghost_style.size
						local charge_default_size = charge_ghost_style.default_size
						local size_add = 50 - 50 * anim_charge_progress

						charge_size[1] = charge_default_size[1] + size_add
						charge_size[2] = charge_default_size[2] + size_add
					end
				end
			end
		end
	end
end

local function badge_init_anim(parent, ui_scenegraph, scenegraph_definition, widget, params)
	local content = widget.content
	local style = widget.style
	local previous_rank = content.previous_rank
	local current_rank = content.current_rank
	local rank_up = current_rank ~= nil and (not previous_rank or previous_rank <= current_rank)

	style.havoc_rank_badge.material_values.RankupRankdown = rank_up and 0 or 1
end

local function badge_update_anim(parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
	local style = widget.style

	if style.havoc_rank_badge.material_values.afterTexture ~= style.havoc_rank_badge.material_values.beforeTexure then
		style.havoc_rank_badge.material_values.AnimationSpeedFireAmountt[1] = progress
	end
end

local weekly_anim_start_delay = 1

local function weekly_anim_reward_entry(start_time, end_time, widget_index)
	return {
		start_time = weekly_anim_start_delay + start_time,
		end_time = weekly_anim_start_delay + end_time,
		name = "rewards_fade_in_" .. widget_index,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local anim_progress = math.easeOutCubic(progress)
			local reward_widgets = parent.reward_widgets
			local reward_widget = reward_widgets and reward_widgets[widget_index]

			if reward_widget then
				reward_widget.alpha_multiplier = anim_progress

				local style = reward_widget.style
				local style_currency = style.currency

				if style_currency then
					local default_size = style_currency.default_size
					local size = style_currency.size
					local size_add = 50 * (1 - anim_progress)

					size[1] = default_size[1] + size_add
					size[2] = default_size[2] + size_add
				end

				local content = reward_widget.content
				local final_value = content.value

				if final_value then
					local anim_value = math.ceil(final_value * anim_progress)

					content.text = Text.format_currency(anim_value)

					if not content.value_sound_played then
						parent:_play_sound(UISoundEvents.end_screen_summary_currency_summation)

						content.value_sound_played = true
					end
				end
			end
		end,
	}
end

local animations = {
	weekly = {
		{
			end_time = 0,
			name = "reset",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				parent:set_alpha_multiplier(0)

				local reward_widgets = parent.reward_widgets

				if reward_widgets then
					for i = 1, #reward_widgets do
						local reward_widget = reward_widgets[i]

						reward_widget.alpha_multiplier = 0
					end
				end
			end,
		},
		{
			name = "fade_in",
			start_time = weekly_anim_start_delay + 0,
			end_time = weekly_anim_start_delay + 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent:set_alpha_multiplier(anim_progress)
			end,
		},
		{
			name = "badge_fade_in",
			start_time = weekly_anim_start_delay + 0.3,
			end_time = weekly_anim_start_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				badge_fade_in(widget, anim_progress)
			end,
		},
		{
			name = "badge_move_in",
			start_time = weekly_anim_start_delay + 0.3,
			end_time = weekly_anim_start_delay + 1.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = 50 - anim_progress * 50

				parent:_set_scenegraph_position("badge", nil, scenegraph_definition.badge.position[2] - y_anim_distance)
			end,
		},
		{
			name = "badge_glow_fade_in",
			start_time = weekly_anim_start_delay + 0.3,
			end_time = weekly_anim_start_delay + 0.9,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local style_id = "havoc_badge_glow"
				local style = widget.style[style_id]

				if style then
					ColorUtilities.color_lerp(style.start_color, style.in_focus_color, anim_progress, style.color)
				end
			end,
		},
		{
			name = "title_move_in",
			start_time = weekly_anim_start_delay + 0,
			end_time = weekly_anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = anim_progress * 50

				parent:_set_scenegraph_position("display_name", nil, scenegraph_definition.display_name.position[2] - y_anim_distance)
			end,
		},
		{
			name = "sub_title_move_in",
			start_time = weekly_anim_start_delay + 0,
			end_time = weekly_anim_start_delay + 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = anim_progress * -50

				parent:_set_scenegraph_position("divider", nil, scenegraph_definition.divider.position[2] - y_anim_distance)
			end,
		},
		weekly_anim_reward_entry(0.5, 1.5, 1),
		weekly_anim_reward_entry(1.5, 2.5, 2),
		weekly_anim_reward_entry(2.5, 3.5, 3),
		weekly_anim_reward_entry(3.5, 4.5, 4),
		weekly_anim_reward_entry(4.5, 5.5, 5),
		weekly_anim_reward_entry(5.5, 6.5, 6),
	},
	rank_increase = {
		{
			end_time = 1,
			name = "reset",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				parent:set_alpha_multiplier(0)

				local style = widget.style

				if style.havoc_rank_badge.material_values.afterTexture ~= style.havoc_rank_badge.material_values.beforeTexure then
					parent:_play_sound(UISoundEvents.havoc_terminal_rank_up_next_tier)
				else
					parent:_play_sound(UISoundEvents.havoc_terminal_rank_up)
				end
			end,
		},
		{
			end_time = 2,
			name = "fade_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent:set_alpha_multiplier(anim_progress)
			end,
		},
		{
			end_time = 1.4,
			name = "title_move_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = anim_progress * 50

				parent:_set_scenegraph_position("display_name", nil, scenegraph_definition.display_name.position[2] - y_anim_distance)
			end,
		},
		{
			end_time = 1,
			name = "badge_fade_in",
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				badge_fade_in(widget, progress)
			end,
		},
		{
			end_time = 1.5,
			name = "badge_move_in",
			start_time = 0.9,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = 50 - anim_progress * 50

				parent:_set_scenegraph_position("badge", nil, scenegraph_definition.badge.position[2] - y_anim_distance)
			end,
		},
		{
			end_time = 2.2,
			name = "change_current",
			start_time = 1.2,
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
			end_time = 2.4,
			name = "change_next",
			start_time = 1.4,
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
			end_time = 2.6,
			name = "change_charge",
			start_time = 2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				local content = widget.content
				local current_charges = content.current_charges
				local previous_charges = content.previous_charges

				if current_charges ~= previous_charges then
					parent:_play_sound(UISoundEvents.havoc_charge_change)
				end
			end,
			update = charge_update_anim,
		},
		{
			end_time = 4.2,
			name = "change_badge",
			start_time = 2.4,
			init = badge_init_anim,
			update = badge_update_anim,
		},
	},
	rank_decrease = {
		{
			end_time = 1,
			name = "reset",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				parent:set_alpha_multiplier(0)
				parent:_play_sound(UISoundEvents.havoc_terminal_rank_down)
			end,
		},
		{
			end_time = 2,
			name = "fade_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent:set_alpha_multiplier(anim_progress)
			end,
		},
		{
			end_time = 1.4,
			name = "title_move_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = anim_progress * 50

				parent:_set_scenegraph_position("display_name", nil, scenegraph_definition.display_name.position[2] - y_anim_distance)
			end,
		},
		{
			end_time = 1,
			name = "badge_fade_in",
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				badge_fade_in(widget, anim_progress)
			end,
		},
		{
			end_time = 1.5,
			name = "badge_move_in",
			start_time = 0.9,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = 50 - anim_progress * 50

				parent:_set_scenegraph_position("badge", nil, scenegraph_definition.badge.position[2] - y_anim_distance)
			end,
		},
		{
			end_time = 2.2,
			name = "change_current",
			start_time = 1.2,
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
			end_time = 2.4,
			name = "change_next",
			start_time = 1.4,
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
			end_time = 3,
			name = "change_charge",
			start_time = 2.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				local content = widget.content
				local current_charges = content.current_charges
				local previous_charges = content.previous_charges

				if current_charges ~= previous_charges then
					parent:_play_sound(UISoundEvents.havoc_charge_change)
				end
			end,
			update = charge_update_anim,
		},
		{
			end_time = 3.8,
			name = "change_badge",
			start_time = 2,
			init = badge_init_anim,
			update = badge_update_anim,
		},
	},
	charge_change = {
		{
			end_time = 1,
			name = "reset",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				parent:set_alpha_multiplier(0)
			end,
		},
		{
			end_time = 2,
			name = "fade_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent:set_alpha_multiplier(anim_progress)
			end,
		},
		{
			end_time = 1.4,
			name = "title_move_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = anim_progress * 50

				parent:_set_scenegraph_position("display_name", nil, scenegraph_definition.display_name.position[2] - y_anim_distance)
			end,
		},
		{
			end_time = 1,
			name = "badge_fade_in",
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				badge_fade_in(widget, anim_progress)
			end,
		},
		{
			end_time = 1.5,
			name = "badge_move_in",
			start_time = 0.9,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local y_anim_distance = 50 - anim_progress * 50

				parent:_set_scenegraph_position("badge", nil, scenegraph_definition.badge.position[2] - y_anim_distance)
			end,
		},
		{
			end_time = 1.8,
			name = "change_charge",
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				parent:_play_sound(UISoundEvents.havoc_charge_change)
			end,
			update = charge_update_anim,
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
