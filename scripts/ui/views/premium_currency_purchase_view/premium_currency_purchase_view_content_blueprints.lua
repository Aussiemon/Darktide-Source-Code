-- chunkname: @scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view_content_blueprints.lua

local Colors = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WalletSettings = require("scripts/settings/wallet_settings")
local group_header_font_style = table.clone(UIFontSettings.header_3)

group_header_font_style.offset = {
	0,
	0,
	3,
}
group_header_font_style.text_horizontal_alignment = "center"
group_header_font_style.text_vertical_alignment = "center"
group_header_font_style.text_color = Color.ui_grey_light(255, true)

local sub_header_font_style = table.clone(UIFontSettings.header_3)

sub_header_font_style.offset = {
	0,
	0,
	3,
}
sub_header_font_style.font_size = 18
sub_header_font_style.text_horizontal_alignment = "center"
sub_header_font_style.text_vertical_alignment = "center"
sub_header_font_style.text_color = Color.ui_grey_medium(255, true)

local item_header_text_style = table.clone(UIFontSettings.body)

item_header_text_style.text_horizontal_alignment = "left"
item_header_text_style.text_vertical_alignment = "bottom"
item_header_text_style.horizontal_alignment = "center"
item_header_text_style.vertical_alignment = "center"
item_header_text_style.offset = {
	10,
	-55,
	4,
}
item_header_text_style.size_addition = {
	-20,
	0,
}
item_header_text_style.text_color = Color.terminal_text_header(255, true)
item_header_text_style.font_size = 24

local aquila_header_text_style = table.clone(item_header_text_style)

aquila_header_text_style.text_vertical_alignment = "top"
aquila_header_text_style.text_horizontal_alignment = "center"
aquila_header_text_style.vertical_alignment = "top"
aquila_header_text_style.font_size = 36
aquila_header_text_style.offset = {
	0,
	3,
	4,
}
aquila_header_text_style.size_addition = {
	0,
	0,
}

local item_header_premium_text_style = table.clone(item_header_text_style)

item_header_premium_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"
item_header_premium_text_style.text_color = Color.white(255, true)

local item_sub_header_text_style = table.clone(UIFontSettings.body_small)

item_sub_header_text_style.text_horizontal_alignment = "left"
item_sub_header_text_style.text_vertical_alignment = "bottom"
item_sub_header_text_style.horizontal_alignment = "center"
item_sub_header_text_style.vertical_alignment = "center"
item_sub_header_text_style.offset = {
	10,
	-10,
	4,
}
item_sub_header_text_style.size_addition = {
	-20,
	0,
}
item_sub_header_text_style.text_color = Color.terminal_text_body(255, true)
item_sub_header_text_style.font_size = 24

local item_description_text_style = table.clone(UIFontSettings.body)

item_description_text_style.text_horizontal_alignment = "center"
item_description_text_style.text_vertical_alignment = "bottom"
item_description_text_style.horizontal_alignment = "center"
item_description_text_style.vertical_alignment = "bottom"
item_description_text_style.offset = {
	0,
	-60,
	5,
}
item_description_text_style.size_addition = {
	-30,
	-30,
}
item_description_text_style.text_color = Color.terminal_text_body(255, true)

local item_price_text_style = table.clone(UIFontSettings.body)

item_price_text_style.text_horizontal_alignment = "right"
item_price_text_style.text_vertical_alignment = "bottom"
item_price_text_style.horizontal_alignment = "center"
item_price_text_style.vertical_alignment = "center"
item_price_text_style.offset = {
	-30,
	-10,
	4,
}
item_price_text_style.text_color = Color.white(255, true)

local aquila_price_text_style = table.clone(item_price_text_style)

aquila_price_text_style.text_horizontal_alignment = "center"
aquila_price_text_style.offset = {
	0,
	-10,
	4,
}

local aquila_price_discounted_text_style = table.clone(aquila_price_text_style)

aquila_price_discounted_text_style.text_color = Color.terminal_text_body(255, true)
aquila_price_discounted_text_style.text_horizontal_alignment = "left"
aquila_price_discounted_text_style.offset = {
	10,
	-10,
	4,
}
aquila_price_discounted_text_style.font_size = 20

local timer_text_style = table.clone(UIFontSettings.body_small)

timer_text_style.text_horizontal_alignment = "left"
timer_text_style.text_vertical_alignment = "bottom"
timer_text_style.text_color = Color.ui_grey_light(255, true)
timer_text_style.default_text_color = Color.ui_grey_light(255, true)
timer_text_style.hover_color = {
	255,
	255,
	255,
	255,
}
timer_text_style.offset = {
	30,
	-15,
	5,
}
timer_text_style.horizontal_alignment = "center"
timer_text_style.vertical_alignment = "center"

local best_offer_text_style = table.clone(item_header_text_style)

best_offer_text_style.text_color = Color.white(255, true)
best_offer_text_style.offset = {
	-20,
	-35,
	3,
}
best_offer_text_style.size = {
	200,
	100,
}
best_offer_text_style.horizontal_alignment = "right"
best_offer_text_style.vertical_alignment = "top"
best_offer_text_style.text_horizontal_alignment = "right"
best_offer_text_style.text_vertical_alignment = "top"

local _colors = {
	default_background_color = Color.terminal_frame(255, true),
	mtx_pack_background_color = {
		255,
		172,
		136,
		84,
	},
}

local function _icon_change_function(content, style)
	local min_uv = 0.95
	local max_uv = 1
	local start_uv = 0
	local end_uv = 1
	local hotspot = content.hotspot
	local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local current_uv = (max_uv - min_uv) * progress

	style.uvs[1][1] = start_uv + current_uv
	style.uvs[1][2] = start_uv + current_uv
	style.uvs[2][1] = end_uv - current_uv
	style.uvs[2][2] = end_uv - current_uv
end

local function _base_blueprint()
	local button_base_passes = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				use_is_focused = true,
			},
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					20,
					20,
				},
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)

				style.color[1] = 255 * math.easeOutCubic(progress)

				local style_size_additon = style.size_addition

				style_size_additon[1] = 20 + 20 * math.easeInCubic(1 - progress)
				style_size_additon[2] = 20 + 20 * math.easeInCubic(1 - progress)
			end,
		},
		{
			pass_type = "texture",
			style_id = "line",
			value = "content/ui/materials/frames/line_medium",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.black(0, true),
				color = Color.black(255, true),
				hover_color = Color.terminal_corner_selected(255, true),
				offset = {
					0,
					0,
					5,
				},
				size_addition = {
					0,
					-8,
				},
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
				local default_color = style.default_color
				local hover_color = style.hover_color
				local color = style.color

				Colors.color_lerp(default_color, hover_color, progress, color)
			end,
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size_addition = {
					-2,
					0,
				},
				size = {
					nil,
					50,
				},
				offset = {
					0,
					0,
					3,
				},
				color = {
					180,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "price",
			value = "??? ",
			value_id = "formatted_price",
			style = aquila_price_text_style,
		},
		{
			pass_type = "text",
			style_id = "formatted_original_price",
			value_id = "formatted_original_price",
			style = aquila_price_discounted_text_style,
			visibility_function = function (content, style)
				return content.formatted_original_price and content.formatted_original_price
			end,
		},
		{
			pass_type = "texture",
			style_id = "title_background",
			value = "content/ui/materials/masks/gradient_horizontal",
			value_id = "title_background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				size_addition = {
					-2,
					20,
				},
				color = Color.black(153, true),
				size = {
					nil,
					0,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "<Title>",
			value_id = "title",
			style = aquila_header_text_style,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = nil,
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					48,
					33.6,
				},
				offset = {
					0,
					10,
					5,
				},
				size_addition = {
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.icon
			end,
		},
	}

	local function base_init(parent, widget, element, callback_name)
		local content = widget.content
		local style = widget.style

		content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
		content.element = element
		content.title = element.title or "<empty>"
		content.bonus_description = element.description or ""

		local title_style = style.title
		local max_width = content.size[1] + style.title.size_addition[1]
		local title_width, title_height = parent:_text_size(content.title, title_style, {
			max_width,
			200,
		})
		local icon_margin = 10
		local wallet_settings = WalletSettings.aquilas
		local font_gradient_material = wallet_settings.font_gradient_material
		local icon_texture_small = wallet_settings.icon_texture_small

		style.price.material = not element.owned and font_gradient_material
		style.price.text_color = element.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
		content.icon = icon_texture_small
		style.title_background.size = {
			[2] = title_height,
		}
		style.icon.offset[1] = (title_width + style.icon.size[1] + icon_margin) * 0.5
	end

	return {
		pass_template = button_base_passes,
		init_functions = {
			base_init,
		},
	}
end

local function _add_bonus_description()
	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "text",
				style_id = "bonus_description",
				value = "",
				value_id = "bonus_description",
				style = item_description_text_style,
			},
			{
				pass_type = "texture",
				style_id = "bonus_description_background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "bonus_description_background",
				style = {
					size_addition = {
						60,
						20,
					},
					color = Color.terminal_corner(178.5, true),
					offset = {
						item_description_text_style.offset[1],
						item_description_text_style.offset[2],
						item_description_text_style.offset[3] - 1,
					},
					horizontal_alignment = item_description_text_style.horizontal_alignment,
					vertical_alignment = item_description_text_style.vertical_alignment,
				},
			},
			{
				pass_type = "texture",
				style_id = "bonus_description_background_line",
				value = "content/ui/materials/frames/frame_tile_2px",
				value_id = "bonus_description_background_line",
				style = {
					size_addition = {
						60,
						20,
					},
					color = Color.terminal_corner(178.5, true),
					offset = {
						item_description_text_style.offset[1],
						item_description_text_style.offset[2],
						item_description_text_style.offset[3],
					},
					horizontal_alignment = item_description_text_style.horizontal_alignment,
					vertical_alignment = item_description_text_style.vertical_alignment,
				},
			},
		})

		table.insert(blueprint.init_functions, function (parent, widget, element, callback_name)
			local description_width, description_height = parent:_text_size(widget.content.bonus_description, widget.style.bonus_description, {
				1920,
				1080,
			})

			widget.style.bonus_description_background.size = {
				description_width,
				description_height,
			}
			widget.style.bonus_description_background_line.size = {
				description_width,
				description_height,
			}
		end)

		return blueprint
	end
end

local _original_banner_size = {
	352,
	572,
}

local function _add_platform_banner(icon_size, horizontal_alignment)
	local is_flipped = horizontal_alignment ~= "left"
	local is_component_wide = icon_size[1] > _original_banner_size[1]
	local ratio = _original_banner_size[1] / _original_banner_size[2]
	local wanted_height = is_component_wide and icon_size[2] or icon_size[2] * 0.66
	local wanted_size = {
		ratio * wanted_height,
		wanted_height,
	}
	local base_x_offset = is_component_wide and 48 or icon_size[1] * 0.15
	local base_y_offset = is_component_wide and -23 or -icon_size[2] * 0.073
	local offset = {
		is_flipped and base_x_offset or -base_x_offset,
		base_y_offset,
		8,
	}
	local style = {
		vertical_alignment = "top",
		offset = offset,
		size = wanted_size,
		size_addition = {
			0,
			0,
		},
		horizontal_alignment = horizontal_alignment,
		uvs = horizontal_alignment == "left" and {
			{
				0,
				0,
			},
			{
				1,
				1,
			},
		} or {
			{
				1,
				0,
			},
			{
				0,
				1,
			},
		},
	}

	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture_uv",
				value = "content/ui/materials/frames/premium_store/offer_card_best_value_banner",
				style = style,
			},
		})

		return blueprint
	end
end

local function _add_decorator_line(component_size, vertical_alignment, offset)
	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/line_glow_tinted",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					size = {
						component_size[1],
						30,
					},
					vertical_alignment = vertical_alignment,
					offset = offset,
				},
			},
		})

		return blueprint
	end
end

local function _add_frame(component_size, has_bonus, is_pack)
	local top_frame_material = "content/ui/materials/frames/premium_store/offer_card_upper_regular"
	local bottom_frame_material = "content/ui/materials/frames/premium_store/offer_card_lower_regular"
	local offset_top = {
		0,
		-15,
		6,
	}
	local offset_bottom = {
		0,
		15,
		6,
	}

	if is_pack then
		top_frame_material = "content/ui/materials/frames/premium_store/offer_card_upper_golden_1"
		bottom_frame_material = "content/ui/materials/frames/premium_store/offer_card_lower_golden_1"
		offset_top[2] = -10
		offset_bottom[2] = 10
	end

	if has_bonus then
		top_frame_material = "content/ui/materials/frames/premium_store/offer_card_upper_sale"
		bottom_frame_material = "content/ui/materials/frames/premium_store/offer_card_lower_sale"
		offset_top[2] = -15
		offset_bottom[2] = 15
	end

	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture",
				style_id = "divider_top",
				value_id = "divider_top",
				value = top_frame_material,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						nil,
						30,
					},
					offset = offset_top,
					size_addition = {
						20,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_bottom",
				value_id = "divider_bottom",
				value = bottom_frame_material,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "bottom",
					size = {
						nil,
						30,
					},
					offset = offset_bottom,
					size_addition = {
						20,
						0,
					},
				},
			},
		})

		if is_pack then
			offset_top = table.clone(offset_top)
			offset_bottom = table.clone(offset_bottom)
			offset_top[2] = offset_top[2] + 2
			offset_top[3] = offset_top[3] - 1
			offset_bottom[3] = offset_bottom[3] - 1
			offset_bottom[2] = offset_bottom[2] + 2
		end

		return blueprint
	end
end

local function _add_icon_glow(icon_horizontal_alignment, icon_offset, icon_size)
	local size = math.max(icon_size[1], icon_size[2])
	local size_addition = size * 0.8
	local glow_offset = table.clone(icon_offset)

	glow_offset[3] = glow_offset[3] - 1

	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture_uv",
				value = "content/ui/materials/effects/premium_store/circular_glow_tinted",
				style = {
					hdr = false,
					vertical_alignment = "center",
					size_addition = {
						size_addition,
						size_addition,
					},
					horizontal_alignment = icon_horizontal_alignment,
					offset = glow_offset,
					size = {
						size,
						size,
					},
					uvs = {
						{
							0,
							0,
						},
						{
							1,
							1,
						},
					},
				},
				change_function = _icon_change_function,
			},
		})

		return blueprint
	end
end

local function _add_main_icon(component_size, texture_data, has_bonus, is_golden)
	local icon_size = has_bonus and {
		168,
		198,
	} or {
		196,
		230.99999999999997,
	}

	icon_size = is_golden and {
		308,
		363.00000000000006,
	} or icon_size

	local offset = {
		0,
		has_bonus and -40 or -10,
		1,
	}
	local icon_horizontal_alignment = "center"

	return function (blueprint)
		local icon_id = "icon_texture_main"

		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture_uv",
				value = "content/ui/materials/icons/offer_cards/offer_card_container",
				value_id = icon_id,
				style_id = icon_id,
				style = {
					hdr = false,
					vertical_alignment = "center",
					horizontal_alignment = icon_horizontal_alignment,
					offset = offset,
					size = icon_size,
					uvs = {
						{
							0,
							0,
						},
						{
							1,
							1,
						},
					},
					material_values = {
						shine = 0,
						main_texture = texture_data.main.texture,
					},
				},
				change_function = _icon_change_function,
			},
		})

		if is_golden then
			_add_icon_glow(icon_horizontal_alignment, offset, icon_size)(blueprint)
		end

		return blueprint
	end
end

local function _add_decorations(component_size, is_pack)
	local background_color = is_pack and _colors.mtx_pack_background_color or _colors.default_background_color

	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = background_color,
					size_addition = {
						25,
						20,
					},
				},
			},
		})

		if is_pack then
			blueprint = _add_decorator_line(component_size, "top", {
				0,
				30,
				6,
			})(blueprint)
			blueprint = _add_decorator_line(component_size, "bottom", {
				0,
				-35,
				6,
			})(blueprint)
		end

		return blueprint
	end
end

local function aquila_button_template_factory(component_size, texture_data, has_bonus, is_golden)
	local blueprint = _base_blueprint()
	local button_components = {}

	if has_bonus then
		button_components[#button_components + 1] = _add_bonus_description()
	end

	if is_golden then
		button_components[#button_components + 1] = _add_platform_banner(component_size, "left")
	end

	table.append(button_components, {
		_add_decorations(component_size, is_golden),
		_add_main_icon(component_size, texture_data, has_bonus, is_golden),
		_add_frame(component_size, has_bonus, is_golden),
	})

	for i = 1, #button_components do
		if button_components[i] then
			blueprint = button_components[i](blueprint)
		end
	end

	blueprint.init = function (parent, widget, element, callback_name)
		for i = 1, #blueprint.init_functions do
			blueprint.init_functions[i](parent, widget, element, callback_name)
		end
	end

	return blueprint
end

return {
	create_blueprint = aquila_button_template_factory,
}
