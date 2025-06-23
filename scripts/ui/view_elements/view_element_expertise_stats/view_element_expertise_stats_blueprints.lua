-- chunkname: @scripts/ui/view_elements/view_element_expertise_stats/view_element_expertise_stats_blueprints.lua

local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local InputDevice = require("scripts/managers/input/input_device")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local WeaponStats = require("scripts/utilities/weapon_stats")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponUIStatsTemplates = require("scripts/settings/equipment/weapon_ui_stats_templates")
local ViewElementTraitInventoryBlueprints = {}
local grid_width = 530

ViewElementTraitInventoryBlueprints.spacing_vertical_small = {
	size = {
		grid_width,
		5
	}
}
ViewElementTraitInventoryBlueprints.spacing_vertical = {
	size = {
		grid_width,
		20
	}
}

local stat_title_size = 150
local max_value_size = 60
local stats_value_size = 50
local content_margin = 20
local weapon_stat_text_style = table.clone(UIFontSettings.body)

weapon_stat_text_style.offset = {
	0,
	0,
	4
}
weapon_stat_text_style.size = {
	stat_title_size
}
weapon_stat_text_style.font_size = 16
weapon_stat_text_style.text_horizontal_alignment = "left"
weapon_stat_text_style.vertical_alignment = "center"
weapon_stat_text_style.text_vertical_alignment = "center"
weapon_stat_text_style.text_color = Color.terminal_text_body(255, true)

local max_value_style = table.clone(UIFontSettings.body)

max_value_style.offset = {
	0,
	0,
	4
}
max_value_style.size = {
	max_value_size
}
max_value_style.font_size = 20
max_value_style.text_horizontal_alignment = "right"
max_value_style.horizontal_alignment = "right"
max_value_style.text_vertical_alignment = "center"
max_value_style.vertical_alignment = "center"
max_value_style.text_color = Color.terminal_text_body_sub_header(255, true)

local stat_value_style = table.clone(max_value_style)

stat_value_style.text_color = Color.white(255, true)
stat_value_style.size = {
	stats_value_size
}
stat_value_style.offset = {
	-(max_value_size + content_margin),
	0,
	4
}

local bar_size = grid_width - stat_title_size - max_value_size - stats_value_size
local bar_offset = (grid_width - bar_size - content_margin * 2) * 0.5

ViewElementTraitInventoryBlueprints.stat = {
	size = {
		grid_width,
		30
	},
	pass_template = {
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "n/a",
			style = weapon_stat_text_style
		},
		{
			style_id = "percentage",
			value_id = "percentage",
			pass_type = "text",
			value = "100%",
			style = stat_value_style
		},
		{
			style_id = "max_percentage",
			value_id = "max_percentage",
			pass_type = "text",
			value = "[100%]",
			style = max_value_style
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					18 + bar_offset,
					0,
					3
				},
				size = {
					bar_size,
					8
				},
				color = Color.black(255, true)
			}
		},
		{
			style_id = "frame",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					18 + bar_offset - 2,
					0,
					2
				},
				size = {
					bar_size + 4,
					12
				},
				color = Color.terminal_frame(200, true)
			}
		},
		{
			style_id = "max",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					18 + bar_offset,
					0,
					3
				},
				size = {
					bar_size,
					8
				},
				color = Color.terminal_text_header_disabled(255, true)
			}
		},
		{
			style_id = "current",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					18 + bar_offset,
					0,
					3
				},
				size = {
					bar_size,
					8
				},
				color = Color.terminal_text_body(255, true)
			},
			change_function = function (content, style, animations, dt)
				local pulse_frequency = 5
				local pulse = 0.5 * (1 + math.sin(Application.time_since_launch() * pulse_frequency))

				style.color[1] = pulse * 255
			end
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "bar",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					20 + bar_offset,
					0,
					4
				},
				size = {
					bar_size,
					8
				},
				color = Color.terminal_corner_selected(255, true)
			}
		}
	},
	init = function (parent, widget, element, callback_name)
		local content = widget.content
		local style = widget.style

		content.element = element

		local item = element.item
		local weapon_stats = WeaponStats:new(item)
		local stat_data = element.stat_data
		local max_stat = element.max_stat
		local text_id = "text"
		local background_id = "background"
		local bar_id = "bar"
		local max_bar_id = "max"
		local current_bar_id = "current"
		local percentage_id = "percentage"
		local max_percentage_id = "max_percentage"

		widget.content.text = Localize(stat_data.display_name)

		local anim_duration = 1
		local start_value = stat_data.fraction
		local end_value = max_stat
		local added_start_value
		local bar_style = style[bar_id]

		bar_style.size[1] = bar_size * start_value

		local max_bar_style = style[max_bar_id]

		max_bar_style.size[1] = bar_size * end_value

		local current_bar_style = style[current_bar_id]

		current_bar_style.size[1] = bar_style.size[1]

		local display_name = Localize(stat_data.display_name)

		content[text_id] = display_name
		content[percentage_id] = math.floor(start_value * 100 + 0.5) .. "%"
		content[max_percentage_id] = string.format("[%s]", math.floor(end_value * 100 + 0.5) .. "%")
		content.percent_start = start_value
		content.percent_end = end_value
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content
		local style = widget.style
		local background_id = "background"
		local current_bar_id = "current"
		local percentage_id = "percentage"
		local max_bar_id = "max"
		local bar_id = "bar"
		local current_value = parent._expertise_data.current
		local max = parent._expertise_data.max
		local start = parent._expertise_data.start
		local expertise_progress

		expertise_progress = current_value == max and 1 or math.ilerp(0, max - start, current_value - start)

		local start_width = style[bar_id].size[1]
		local end_width = style[max_bar_id].size[1]
		local bar_initial_width = bar_size * content.percent_start
		local diff_size = end_width - bar_initial_width
		local current_bar_style = style[current_bar_id]

		current_bar_style.size[1] = bar_initial_width + diff_size * expertise_progress

		local current_value_percent = math.lerp(content.percent_start, content.percent_end, expertise_progress)

		content[percentage_id] = math.floor(current_value_percent * 100 + 0.5) .. "%"
	end
}

return ViewElementTraitInventoryBlueprints
