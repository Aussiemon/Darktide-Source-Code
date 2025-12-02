-- chunkname: @scripts/ui/views/store_view/store_view_blueprint_factory.lua

local Colors = require("scripts/utilities/ui/colors")
local Items = require("scripts/utilities/items")
local Text = require("scripts/utilities/ui/text")
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

local _button_base_passes = {
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
		pass_type = "texture_uv",
		style_id = "texture",
		value = "content/ui/materials/icons/offer_cards/offer_card_container",
		value_id = "texture",
		style = {
			hdr = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				1,
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
			material_values = {
				shine = 0,
			},
		},
		visibility_function = function (content, style)
			return not not style.material_values and not not style.material_values.main_texture
		end,
		change_function = _icon_change_function,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
		value_id = "icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			material_values = {
				use_placeholder_texture = 1,
			},
			offset = {
				0,
				0,
				1,
			},
			size = {
				192,
				128,
			},
			size_addition = {
				0,
				0,
			},
		},
		visibility_function = function (content, style)
			return content.item
		end,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/terminal_basic",
		value_id = "background",
		style = {
			hdr = false,
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			offset = {
				0,
				0,
				0,
			},
			color = Color.terminal_frame(255, true),
			size_addition = {
				25,
				20,
			},
		},
		visibility_function = function (content, style)
			return not content.element._is_image_loaded
		end,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
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
		style_id = "discount_price",
		value = "",
		value_id = "discount_price",
		style = item_price_text_style,
		visibility_function = function (content, style)
			return not content.element.owned and content.element.discount
		end,
	},
	{
		pass_type = "texture",
		style_id = "price_icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "price_icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				40,
				28,
			},
			offset = {
				-5,
				-10,
				4,
			},
		},
		visibility_function = function (content, style)
			return not content.element.owned and not content.element.formattedPrice
		end,
	},
	{
		pass_type = "text",
		style_id = "price",
		value = "??? ",
		value_id = "price",
		style = item_price_text_style,
	},
	{
		pass_type = "text",
		style_id = "title",
		value = "<Title>",
		value_id = "title",
		style = item_header_text_style,
	},
	{
		pass_type = "text",
		style_id = "sub_title",
		value = "<Sub Title>",
		value_id = "sub_title",
		style = item_sub_header_text_style,
	},
	{
		pass_type = "rotated_texture",
		style_id = "loading",
		value = "content/ui/materials/loading/loading_small",
		style = {
			angle = 0,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
			color = {
				60,
				160,
				160,
				160,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content, style)
			return not content.element._is_image_loaded
		end,
		change_function = function (content, style, _, dt)
			local add = -0.5 * dt

			style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
			style.angle = style.rotation_progress * math.pi * 2
		end,
	},
	{
		pass_type = "text",
		value = "",
		value_id = "timer_text",
		style = timer_text_style,
		visibility_function = function (content, style)
			return content.timer_text
		end,
	},
}

local function _base_init(parent, widget, element, callback_name)
	local content = widget.content
	local style = widget.style

	content.widget_type = "button"
	content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
	content.element = element
	content.title = element.title or "<empty>"
	content.sub_title = element.sub_title or "<empty>"
	content.description = element.description or "<empty>"

	local title_width = content.size[1] + style.title.size_addition[1]

	content.price = element.owned and string.format("%s ", Localize("loc_item_owned")) or element.formattedPrice and element.formattedPrice or Text.format_currency(element.price)

	local wallet_settings = WalletSettings.aquilas
	local font_gradient_material = wallet_settings.font_gradient_material
	local icon_texture_small = wallet_settings.icon_texture_small

	style.price.material = not element.owned and font_gradient_material
	style.price.text_color = element.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
	content.price_icon = icon_texture_small

	if element.offer.description.type == "platform_purchase" then
		style.price.material = nil
		style.price_icon.visible = false
		style.price.text_color = Color.white(255, true)
		content.price = Localize("loc_dlc_store_popup_confirm")
	end

	content.has_media = not not element.texture_map
	content.has_aquila_texture = not not element.aquila_texture

	local price_style = style.price
	local price_width, price_height = parent:_text_size(content.price, price_style, {
		title_width,
		1080,
	})

	style.price.offset[1] = element.owned and style.price_icon.offset[1] or style.price_icon.offset[1] - style.price_icon.size[1]

	local slot = element.slot

	if slot then
		local item = element.item

		content.item = item

		local display_name = item and item.display_name

		if display_name then
			content.display_name = Items.display_name(item)
			content.sub_display_name = Items.sub_display_name(item)
		end
	end

	if element.discount then
		local text_width, _ = parent:_text_size(content.price, price_style, {
			title_width,
			1080,
		})
		local discount_margin = 20
		local price_style = style.price

		content.discount_price = string.format("{#strike(true)}%s{#strike(false)}", Text.format_currency(element.discount))
		style.discount_price.text_color = Color.terminal_text_body(255, true)

		local discount_style = style.discount_price
		local discount_width, discount_height = parent:_text_size(content.discount_price, discount_style, {
			title_width,
			1080,
		})

		style.discount_price.offset[1] = style.price.offset[1] - discount_margin - price_width
	end
end

local function _base_button_blueprint()
	return {
		pass_template = table.clone(_button_base_passes),
		init_functions = {
			_base_init,
		},
		destroy_functions = {},
	}
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

local function _add_decorator_line(vertical_alignment, offset)
	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/line_glow_tinted",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					size = {
						nil,
						30,
					},
					vertical_alignment = vertical_alignment,
					offset = offset,
					size_addition = {
						40,
						0,
					},
				},
			},
		})

		return blueprint
	end
end

local _frame_mapping = {
	default = {
		bottom = "content/ui/materials/frames/premium_store/offer_card_lower_regular",
		top = "content/ui/materials/frames/premium_store/offer_card_upper_regular",
		offset_top = {
			0,
			-15,
			6,
		},
		offset_bottom = {
			0,
			15,
			6,
		},
	},
	special_offer_1 = {
		bottom = "content/ui/materials/frames/premium_store/offer_card_lower_special_1",
		top = "content/ui/materials/frames/premium_store/offer_card_upper_special_1",
		offset_top = {
			0,
			-10,
			6,
		},
		offset_bottom = {
			0,
			10,
			6,
		},
	},
	special_offer_2 = {
		bottom = "content/ui/materials/frames/premium_store/offer_card_lower_golden_1",
		has_decorations = true,
		top = "content/ui/materials/frames/premium_store/offer_card_upper_golden_1",
		offset_top = {
			0,
			-10,
			6,
		},
		offset_bottom = {
			0,
			10,
			6,
		},
	},
}

local function _add_frame(offer_presentation_type)
	local frame = _frame_mapping[offer_presentation_type] or _frame_mapping.default

	return function (blueprint)
		blueprint.pass_template = table.append(blueprint.pass_template, {
			{
				pass_type = "texture",
				style_id = "divider_top",
				value_id = "divider_top",
				value = frame.top,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						nil,
						30,
					},
					offset = frame.offset_top,
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
				value = frame.bottom,
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "bottom",
					size = {
						nil,
						30,
					},
					offset = frame.offset_bottom,
					size_addition = {
						20,
						0,
					},
				},
			},
		})

		if frame.has_decorations then
			local offset_top = table.clone(frame.offset_top)
			local offset_bottom = table.clone(frame.offset_bottom)

			offset_top[2] = offset_top[2] + 2
			offset_top[3] = offset_top[3] - 1
			offset_bottom[3] = offset_bottom[3] - 1
			offset_bottom[2] = offset_bottom[2] + 2
			blueprint = _add_decorator_line("top", offset_top)(blueprint)
			blueprint = _add_decorator_line("bottom", offset_bottom)(blueprint)
		end

		return blueprint
	end
end

local function _add_image(image_url)
	return function (blueprint)
		table.insert(blueprint.init_functions, function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			element._is_image_loaded = false
			content.hotspot.disabled = true
			element._texture_load_promise = Managers.url_loader:load_texture(image_url, nil, "store_view")

			element._texture_load_promise:next(function (data)
				content.hotspot.disabled = false
				element._is_image_loaded = true
				style.texture.material_values.main_texture = data.texture
			end, function (error)
				content.hotspot.disabled = false

				Log.error("StoreView", "fetching item image", error)
			end)
		end)
		table.insert(blueprint.destroy_functions, function (parent, widget, element, ui_renderer)
			if element._texture_load_promise then
				Managers.url_loader:unload_texture(element.image_url)

				widget.style.texture.material_values.main_texture = nil
			end
		end)

		return blueprint
	end
end

local function offer_button_template_factory(component_size, offer_config)
	local blueprint = _base_button_blueprint()
	local button_components = {}
	local metadata_presentation_data = offer_config.offer.sku.metadata and offer_config.offer.sku.metadata.customPresentation

	if metadata_presentation_data == "special_offer_2" then
		button_components[#button_components + 1] = _add_platform_banner(component_size, "left")
	end

	if offer_config.image_url then
		button_components[#button_components + 1] = _add_image(offer_config.image_url)
	end

	table.append(button_components, {
		_add_frame(metadata_presentation_data),
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

	blueprint.destroy = function (parent, widget, element, ui_renderer)
		for i = 1, #blueprint.destroy_functions do
			blueprint.destroy_functions[i](parent, widget, element, ui_renderer)
		end
	end

	return blueprint
end

return {
	create_blueprint = offer_button_template_factory,
}
