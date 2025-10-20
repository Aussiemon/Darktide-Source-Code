-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions.lua

local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local Text = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local header_size = HudElementMissionObjectiveFeedSettings.header_size
local icon_size = {
	32,
	32,
}
local live_event_text_width = header_size[1] - icon_size[1] - 20 - 18
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			header_size[1],
			200,
		},
		position = {
			-50,
			50,
			1,
		},
	},
	background = {
		horizontal_alignment = "right",
		parent = "area",
		vertical_alignment = "top",
		size = {
			header_size[1],
			50,
		},
		position = {
			0,
			0,
			1,
		},
	},
	pivot = {
		horizontal_alignment = "right",
		parent = "background",
		vertical_alignment = "top",
		size = {
			header_size[1],
			50,
		},
		position = {
			10,
			0,
			1,
		},
	},
	live_event_background = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "top",
		size = {
			header_size[1],
			200,
		},
		position = {
			0,
			0,
			1,
		},
	},
	live_event_text_area = {
		horizontal_alignment = "right",
		parent = "live_event_background",
		vertical_alignment = "top",
		size = {
			live_event_text_width,
			200,
		},
		position = {
			-8,
			4,
			1,
		},
	},
}

local function text_height(ui_renderer, text, style, optional_size, use_max_extents)
	local text_options = UIFonts.get_font_options_by_style(style, {})

	return UIRenderer.text_height(ui_renderer, text, style.font_type, style.font_size, optional_size, text_options)
end

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local alert_size = {
	header_size[1] - 10,
	30,
}
local alert_text_style = table.clone(UIFontSettings.hud_body)

alert_text_style.horizontal_alignment = "left"
alert_text_style.vertical_alignment = "bottom"
alert_text_style.text_horizontal_alignment = "center"
alert_text_style.text_vertical_alignment = "center"
alert_text_style.font_size = 20
alert_text_style.offset = {
	0,
	-1,
	7,
}
alert_text_style.size = alert_size
alert_text_style.text_color = {
	255,
	70,
	38,
	0,
}
alert_text_style.drop_shadow = true

local function create_mission_objective(scenegraph_id)
	local header_font_settings = UIFontSettings.hud_body
	local drop_shadow = true
	local header_font_color = HudElementMissionObjectiveFeedSettings.base_color
	local bar_icon_size = {
		24,
		24,
	}
	local icon_offset = 10
	local side_offset = 10
	local bar_offset = {
		icon_size[1] + side_offset + icon_offset,
		1,
		0,
	}
	local bar_size = {
		header_size[1] - (bar_offset[1] + icon_offset + side_offset * 2),
		10,
	}
	local pass_definitions = {
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = icon_size,
				offset = {
					icon_offset,
					0,
					6,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "text",
			style_id = "header_text",
			value = "<header_text>",
			value_id = "header_text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6,
				},
				default_offset = {
					bar_offset[1],
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1] - (side_offset * 2 + icon_size[1] * 2),
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				size = bar_size,
				color = {
					150,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				size = bar_size,
				default_length = bar_size[1],
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar_icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "bar_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				size = bar_icon_size,
				color = UIHudSettings.color_tint_main_1,
			},
			visibility_function = function (content)
				return content.bar_icon and content.show_bar
			end,
		},
		{
			pass_type = "text",
			style_id = "counter_text",
			value = "",
			value_id = "counter_text",
			style = {
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					-(side_offset * 2),
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1],
				},
			},
		},
		{
			pass_type = "text",
			style_id = "timer_text",
			value = "",
			value_id = "timer_text",
			style = {
				font_size = 26,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					6,
				},
				default_offset = {
					header_size[1] - side_offset * 2,
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1],
				},
			},
		},
	}

	return UIWidget.create_definition(pass_definitions, scenegraph_id, nil, header_size)
end

local function create_mission_objective_overarching(scenegraph_id)
	local header_font_settings = UIFontSettings.hud_body
	local drop_shadow = false
	local header_font_color = HudElementMissionObjectiveFeedSettings.base_color
	local icon_size = {
		32,
		32,
	}
	local bar_icon_size = {
		24,
		24,
	}
	local icon_offset = 10
	local side_offset = 10
	local bar_offset = {
		icon_size[1] + side_offset + icon_offset,
		1,
		0,
	}
	local bar_size = {
		header_size[1] - (bar_offset[1] + icon_offset + side_offset * 2),
		10,
	}
	local pass_definitions = {
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = icon_size,
				offset = {
					icon_offset,
					0,
					6,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "text",
			style_id = "header_text",
			value = "<header_text>",
			value_id = "header_text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6,
				},
				default_offset = {
					bar_offset[1],
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1] - (side_offset * 2 + icon_size[1] * 2),
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				size = bar_size,
				color = {
					150,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				size = bar_size,
				default_length = bar_size[1],
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar_icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "bar_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				size = bar_icon_size,
				color = UIHudSettings.color_tint_main_1,
			},
			visibility_function = function (content)
				return content.bar_icon and content.show_bar
			end,
		},
		{
			pass_type = "text",
			style_id = "counter_text",
			value = "",
			value_id = "counter_text",
			style = {
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1],
				},
			},
		},
		{
			pass_type = "text",
			style_id = "timer_text",
			value = "",
			value_id = "timer_text",
			style = {
				font_size = 26,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					6,
				},
				default_offset = {
					header_size[1] - side_offset * 2,
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1],
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "alert_text",
			value = Utf8.upper(Localize("loc_objective_op_train_alert_header")),
			style = alert_text_style,
			visibility_function = function (content)
				return content.show_alert
			end,
		},
		{
			pass_type = "rect",
			style_id = "alert_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					1,
				},
				size = alert_size,
				color = {
					230,
					255,
					151,
					29,
				},
			},
			visibility_function = function (content)
				return content.show_alert
			end,
		},
		{
			pass_type = "texture",
			style_id = "hazard_above",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				offset = {
					0,
					0,
					1,
				},
				size = {
					alert_size[1],
					15,
				},
				base_color = UIHudSettings.color_tint_main_2,
			},
		},
		{
			pass_type = "texture",
			style_id = "hazard_below",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					1,
				},
				size = {
					alert_size[1],
					15,
				},
				color = UIHudSettings.color_tint_main_2,
			},
			visibility_function = function (content)
				return content.category == "overarching" and not content.show_alert
			end,
		},
		{
			pass_type = "texture",
			style_id = "overarching_background",
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style = {
				size = {
					alert_size[1],
				},
				color = UIHudSettings.color_tint_main_2,
				offset = {
					0,
					0,
					0,
				},
			},
		},
	}

	return UIWidget.create_definition(pass_definitions, scenegraph_id, nil, header_size)
end

local function create_mission_objective_warning(scenegraph_id)
	local pass_definitions = {
		{
			pass_type = "texture",
			style_id = "hazard_above",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				offset = {
					0,
					0,
					1,
				},
				size = {
					alert_size[1],
				},
				color = UIHudSettings.color_tint_main_2,
			},
		},
	}

	return UIWidget.create_definition(pass_definitions, scenegraph_id, nil, {
		header_size[1],
		15,
	})
end

local live_event_title = UIWidget.create_definition({
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = {
			drop_shadow = true,
			font_size = 20,
			text_horizontal_alignment = "left",
			text_vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
}, "live_event_text_area", nil, {
	live_event_text_width,
	32,
}, nil, {
	init = function (self, context, ui_renderer)
		self.content.text = Localize(context.text)
		self.content.size[2] = 8 + text_height(ui_renderer, self.content.text, self.style.text, {
			live_event_text_width,
			9999,
		})
	end,
	destroy = function (self)
		return
	end,
})
local live_event_dynamic_description = UIWidget.create_definition({
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "left",
			text_vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar,
		},
	},
}, "live_event_text_area", nil, {
	live_event_text_width,
	32,
}, nil, {
	init = function (self, context, ui_renderer)
		local context_count = #context

		self._ui_renderer = ui_renderer
		self.content.context = context
		self.content.stats = {}

		for i = 1, context_count do
			local condition = context[i].condition

			if condition and not self.content.stats[condition[1]] and type(condition[1]) == "string" then
				self.content.stats[condition[1]] = Managers.data_service.global_stats:subscribe(self, "cb_on_stat_update", "lw-mb", condition[1])
			end

			if condition and not self.content.stats[condition[3]] and type(condition[3]) == "string" then
				self.content.stats[condition[3]] = Managers.data_service.global_stats:subscribe(self, "cb_on_stat_update", "lw-mb", condition[3])
			end
		end

		self:_update_description()
	end,
	destroy = function (self)
		self._ui_renderer = nil

		for stat_name, _ in pairs(self.content.stats) do
			Managers.data_service.global_stats:unsubscribe(self, "lw-mb", stat_name)
		end
	end,
	cb_on_stat_update = function (self, stat_name, new_value)
		self.content.stats[stat_name] = new_value

		self:_update_description()
	end,
	_evaluate = function (self, condition)
		local left = self.content.stats[condition[1]] or tonumber(condition[1])
		local right = self.content.stats[condition[3]] or tonumber(condition[3])
		local operator = condition[2]

		if operator == ">" then
			return right < left
		elseif operator == "<" then
			return left < right
		elseif operator == "==" then
			return left == right
		end

		return false
	end,
	_update_description = function (self)
		local context = self.content.context

		for _, entry in ipairs(context) do
			local condition = entry.condition

			if not condition or self:_evaluate(condition) then
				self.content.text = Localize(entry.text)
				self.content.size[2] = text_height(self._ui_renderer, self.content.text, self.style.text, {
					live_event_text_width,
					9999,
				})

				return
			end
		end
	end,
})
local live_event_counter = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "bar_background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				6,
			},
			default_offset = {
				0,
				0,
				6,
			},
			size = {
				nil,
				10,
			},
			color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar_background,
		},
	},
	{
		pass_type = "texture",
		style_id = "bar",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				7,
			},
			default_offset = {
				0,
				0,
				7,
			},
			size = {
				nil,
				10,
			},
			color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar,
		},
	},
	{
		pass_type = "text",
		style_id = "title",
		value = "",
		value_id = "title",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "left",
			text_vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
	{
		pass_type = "text",
		style_id = "counter",
		value = "",
		value_id = "counter",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "right",
			text_vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar,
		},
	},
}, "live_event_text_area", nil, {
	nil,
	34,
}, nil, {
	init = function (self, context)
		self.content.stat_name = context.stat_name
		self.content.stat_names = context.stat_names
		self.content.stat_values = {}
		self.content.title = Localize(context.team_name)

		for _, stat_name in ipairs(self.content.stat_names) do
			self.content.stat_values[stat_name] = Managers.data_service.global_stats:subscribe(self, "cb_on_stat_update", "lw-mb", stat_name)
		end

		self:_update_progress()
	end,
	destroy = function (self)
		for _, stat_name in ipairs(self.content.stat_names) do
			Managers.data_service.global_stats:unsubscribe(self, "lw-mb", stat_name)
		end
	end,
	cb_on_stat_update = function (self, stat_name, new_value)
		self.content.stat_values[stat_name] = new_value

		self:_update_progress()
	end,
	_update_progress = function (self)
		local sum, largest, second_largest = 1, 0, 0

		for _, stat_value in pairs(self.content.stat_values) do
			sum = sum + stat_value

			if largest < stat_value then
				second_largest = largest
				largest = stat_value
			elseif second_largest < stat_value then
				second_largest = stat_value
			end
		end

		local my_value = self.content.stat_values[self.content.stat_name]
		local percentage = my_value / sum

		self.style.bar.scale = {
			percentage,
			1,
		}
		self.content.counter = ""

		if my_value == largest then
			self.content.counter = string.format("(+%d)", largest - second_largest)
		end
	end,
})
local tug_o_war = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "bar_background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				-24,
				6,
			},
			default_offset = {
				0,
				0,
				6,
			},
			size = {
				nil,
				10,
			},
			color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar_background,
		},
	},
	{
		pass_type = "texture",
		style_id = "bar",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			vertical_alignment = "bottom",
			offset = {
				0,
				-24,
				7,
			},
			default_offset = {
				0,
				0,
				7,
			},
			size = {
				nil,
				10,
			},
			color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar,
		},
	},
	{
		pass_type = "texture",
		style_id = "bar_divider",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			offset = {
				-1,
				-21,
				8,
			},
			size = {
				2,
				16,
			},
			color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
	{
		pass_type = "texture",
		style_id = "bar_cap",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			offset = {
				0,
				-23,
				8,
			},
			size = {
				4,
				12,
			},
			color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
	{
		pass_type = "text",
		style_id = "left_team",
		value = "",
		value_id = "left_team",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "left",
			text_vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
	{
		pass_type = "text",
		style_id = "right_team",
		value = "",
		value_id = "right_team",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "right",
			text_vertical_alignment = "top",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
	{
		pass_type = "text",
		style_id = "left_number",
		value = "",
		value_id = "left_number",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "left",
			text_vertical_alignment = "bottom",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
	{
		pass_type = "text",
		style_id = "right_number",
		value = "",
		value_id = "right_number",
		style = {
			drop_shadow = false,
			font_size = 20,
			text_horizontal_alignment = "right",
			text_vertical_alignment = "bottom",
			offset = {
				0,
				0,
				6,
			},
			font_type = UIFontSettings.hud_body.font_type,
			text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
		},
	},
}, "live_event_text_area", nil, {
	nil,
	58,
}, nil, {
	init = function (self, context)
		self.content.left_team = Localize(context.left_name)
		self.content.right_team = Localize(context.right_name)
		self.content.left_stat = context.left_stat
		self.content.right_stat = context.right_stat
		self.content.left_value = Managers.data_service.global_stats:subscribe(self, "cb_on_stat_update", "lw-mb", context.left_stat)
		self.content.right_value = Managers.data_service.global_stats:subscribe(self, "cb_on_stat_update", "lw-mb", context.right_stat)

		self:_update_progress()
	end,
	destroy = function (self)
		Managers.data_service.global_stats:unsubscribe(self, "lw-mb", self.content.left_stat)
		Managers.data_service.global_stats:unsubscribe(self, "lw-mb", self.content.right_stat)
	end,
	cb_on_stat_update = function (self, stat_name, new_value)
		if stat_name == self.content.left_stat then
			self.content.left_value = new_value
		elseif stat_name == self.content.right_stat then
			self.content.right_value = new_value
		end

		self:_update_progress()
	end,
	_update_progress = function (self)
		self.content.left_number = tostring(self.content.left_value)
		self.content.right_number = tostring(self.content.right_value)

		local left_value = self.content.left_value
		local right_value = self.content.right_value

		if left_value == 0 and right_value == 0 then
			left_value, right_value = 1, 1
		end

		local percent = left_value / (left_value + right_value)

		self.style.bar.scale = {
			percent,
			1,
		}

		local cap_width = self.style.bar_cap.size[1]

		self.style.bar_cap.offset[1] = percent * (live_event_text_width - cap_width)

		if percent > 0.5 then
			self.style.left_team.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text
			self.style.right_team.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar
			self.style.left_number.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text
			self.style.right_number.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar
			self.style.bar.color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar
			self.style.bar_background.color = HudElementMissionObjectiveFeedSettings.darkened_color
		else
			self.style.left_team.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar
			self.style.right_team.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text
			self.style.left_number.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar
			self.style.right_number.text_color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text
			self.style.bar.color = HudElementMissionObjectiveFeedSettings.darkened_color
			self.style.bar_background.color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.bar
		end
	end,
})
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style = {
				vertical_alignment = "top",
				color = Color.terminal_background_gradient(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "ground_emitter",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					4,
				},
				offset = {
					0,
					0,
					5,
				},
				color = Color.terminal_corner_hover(nil, true),
			},
		},
	}, "background"),
	live_event_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style = {
				vertical_alignment = "top",
				color = Color.terminal_background_gradient(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "ground_emitter",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					4,
				},
				offset = {
					0,
					0,
					5,
				},
				color = Color.terminal_corner_hover(nil, true),
			},
		},
	}, "live_event_background"),
	live_event_icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/circumstances/live_event_01",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					32,
					32,
				},
				offset = {
					20,
					0,
					6,
				},
				color = HudElementMissionObjectiveFeedSettings.colors_by_category.overarching.header_text,
			},
		},
	}, "live_event_background"),
}
local animations = {}
local objective_definition_default = create_mission_objective("pivot")
local objective_definition_overarching = create_mission_objective_overarching("pivot")
local objective_definition_warning = create_mission_objective_warning("pivot")

return {
	animations = animations,
	objective_definitions = {
		default = objective_definition_default,
		side_mission = objective_definition_default,
		overarching = objective_definition_overarching,
		warning = objective_definition_warning,
	},
	live_event_definition = {
		counter = live_event_counter,
		dynamic_description = live_event_dynamic_description,
		title = live_event_title,
		tug_o_war = tug_o_war,
	},
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
