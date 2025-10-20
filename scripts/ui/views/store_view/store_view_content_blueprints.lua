-- chunkname: @scripts/ui/views/store_view/store_view_content_blueprints.lua

local Colors = require("scripts/utilities/ui/colors")
local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local Items = require("scripts/utilities/items")
local Text = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local grid_size = InventoryViewSettings.grid_size
local grid_width = grid_size[1]
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

local function _apply_package_item_icon_cb_func(widget, item)
	local icon = item.icon

	widget.style.icon.material_values.texture_icon = icon
	widget.style.icon.material_values.use_placeholder_texture = 0
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)

	local material_values = widget.style.icon.material_values

	widget.style.icon.material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)

	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 1
end

local blueprints = {
	dynamic_spacing = {
		size = {
			0,
			0,
		},
		size_function = function (parent, config)
			return config.size
		end,
	},
	group_header = {
		size = {
			grid_width,
			70,
		},
		pass_template = {
			{
				pass_type = "text",
				value = "",
				value_id = "text",
				style = group_header_font_style,
			},
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local display_name = element.display_name
			local text = Utf8.upper(Localize(display_name))

			content.element = element
			content.localized_display_name = text
			content.text = text
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local display_name = element.display_name
			local group_header = content.group_header
			local suffix_text
			local text = content.localized_display_name

			if suffix_text then
				text = "{#color(194,154,116)}" .. text .. " {#color(255,242,230)}" .. Localize(suffix_text)
			end

			content.text = text
		end,
	},
	sub_header = {
		size = {
			grid_width,
			20,
		},
		pass_template = {
			{
				pass_type = "text",
				value = "",
				value_id = "text",
				style = sub_header_font_style,
			},
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local display_name = element.display_name
			local text = Utf8.upper(Localize(display_name))

			content.element = element
			content.localized_display_name = text
			content.text = text
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local display_name = element.display_name
			local group_header = content.group_header
			local suffix_text
			local text = content.localized_display_name

			if suffix_text then
				text = "{#color(194,154,116)}" .. text .. " {#color(255,242,230)}" .. Localize(suffix_text)
			end

			content.text = text
		end,
	},
	button = {
		pass_template = {
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
				pass_type = "texture",
				style_id = "title_background",
				value = "content/ui/materials/masks/gradient_horizontal",
				value_id = "title_background",
				style = {
					horizontal_alignment = "top",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.black(153, true),
					size = {
						nil,
						0,
					},
					offset = {
						0,
						20,
						3,
					},
				},
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
				pass_type = "texture",
				style_id = "divider_top",
				value = "content/ui/materials/frames/premium_store/offer_card_upper_regular",
				value_id = "divider_top",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						nil,
						30,
					},
					offset = {
						0,
						-15,
						6,
					},
					size_addition = {
						20,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_bottom",
				value = "content/ui/materials/frames/premium_store/offer_card_lower_regular",
				value_id = "divider_bottom",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "bottom",
					size = {
						nil,
						30,
					},
					offset = {
						0,
						15,
						6,
					},
					size_addition = {
						20,
						0,
					},
				},
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
					return not content.has_media
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
				change_function = function (content, style)
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
					local min_uv = 0.95
					local max_uv = 1
					local start_uv = 0
					local end_uv = 1
					local current_uv = (max_uv - min_uv) * progress * 0.5

					style.uvs[1][1] = start_uv + current_uv
					style.uvs[1][2] = start_uv + current_uv
					style.uvs[2][1] = end_uv - current_uv
					style.uvs[2][2] = end_uv - current_uv
				end,
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
				style_id = "discount_percent_1",
				value = "content/ui/materials/frames/premium_store/sale_banner",
				value_id = "discount_percent_1",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-35,
						-67,
						6,
					},
					size = {
						28,
						44,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.show_discount_percent_1
				end,
			},
			{
				pass_type = "texture",
				style_id = "discount_percent_2",
				value = "content/ui/materials/frames/premium_store/sale_banner",
				value_id = "discount_percent_2",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-55,
						-67,
						6,
					},
					size = {
						28,
						44,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.show_discount_percent_2
				end,
			},
			{
				pass_type = "texture",
				style_id = "discount_percent_3",
				value = "content/ui/materials/frames/premium_store/sale_banner",
				value_id = "discount_percent_3",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-75,
						-67,
						6,
					},
					size = {
						28,
						44,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.show_discount_percent_3
				end,
			},
			{
				pass_type = "texture",
				style_id = "discount_percent_background",
				value = "content/ui/materials/frames/premium_store/sale_banner_03",
				value_id = "discount_percent_background",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						20,
						-20,
						5,
					},
					size = {
						256,
						128,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.discount_banner
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
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.widget_type = "button"
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			content.title = element.title or "<empty>"
			content.sub_title = element.sub_title or "<empty>"
			content.description = element.description or "<empty>"

			local title_style = style.title
			local title_width = content.size[1] + style.title.size_addition[1]
			local title_options = UIFonts.get_font_options_by_style(title_style)
			local _, title_height = parent:_text_size(content.title, title_style.font_type, title_style.font_size, {
				title_width,
				math.huge,
			}, title_options)
			local title_background_margin = 20

			style.title_background.size = {
				[2] = title_height + title_background_margin,
			}
			style.title_background.offset[2] = style.title.offset[2]
			style.title_background.offset[2] = style.title_background.offset[2] - title_background_margin * 0.25
			content.price = element.owned and string.format("%s ", Localize("loc_item_owned")) or element.formattedPrice and element.formattedPrice or Text.format_currency(element.price)

			local wallet_settings = WalletSettings.aquilas
			local font_gradient_material = wallet_settings.font_gradient_material
			local icon_texture_small = wallet_settings.icon_texture_small

			style.price.material = not element.owned and font_gradient_material
			style.price.text_color = element.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
			content.price_icon = icon_texture_small
			content.has_media = not not element.texture_map
			content.has_aquila_texture = not not element.aquila_texture
			style.texture.material_values.main_texture = element.aquila_texture or element.texture_map

			if element.aquila_texture then
				style.texture.size = {
					215,
					215,
				}
			end

			local icon_margin = 10

			style.icon.size_addition[1] = content.size[1] - style.icon.size[1] - icon_margin * 2
			style.icon.size_addition[2] = content.size[1] / style.icon.size[1] * style.icon.size[2] - style.icon.size[2] - icon_margin * 2

			local icon_margin = 0
			local price_style = style.price
			local price_options = UIFonts.get_font_options_by_style(price_style)
			local price_width, price_height = parent:_text_size(content.price, price_style.font_type, price_style.font_size, {
				title_width,
				math.huge,
			}, price_options)

			style.price.offset[1] = element.owned and style.price_icon.offset[1] or style.price_icon.offset[1] - icon_margin - style.price_icon.size[1]

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

			local discount_percent = element.discount_percent

			if element.discount then
				local text_width, _ = parent:_text_size(content.price, price_style.font_type, price_style.font_size)
				local discount_margin = 20
				local price_style = style.price

				content.discount_price = string.format("{#strike(true)}%s{#strike(false)}", Text.format_currency(element.discount))
				style.discount_price.text_color = Color.terminal_text_body(255, true)

				local discount_style = style.discount_price
				local discount_options = UIFonts.get_font_options_by_style(discount_style)
				local discount_width, discount_height = parent:_text_size(content.discount_price, discount_style.font_type, discount_style.font_size, {
					title_width,
					math.huge,
				}, discount_options)

				style.discount_price.offset[1] = style.price.offset[1] - discount_margin - price_width
			end

			if discount_percent then
				content.discount_banner = true

				local index = 1
				local value_to_string = tostring(discount_percent)
				local num_digits = #value_to_string

				for i = num_digits, 1, -1 do
					local string_digit = string.sub(value_to_string, i - 1, 1)

					if string_digit and string_digit ~= "" then
						local pass_name = string.format("discount_percent_%d", index)
						local show_pass_name = string.format("show_%s", pass_name)

						content[show_pass_name] = true
						content[pass_name] = string.format("content/ui/materials/frames/premium_store/sale_banner_number_%s", string_digit)
					end

					index = index + 1
				end
			end
		end,
		load_icon = function (parent, widget, element)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local slot_name = element.slot
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				local item_state_machine = item.state_machine
				local item_animation_event = item.animation_event
				local companion_item_state_machine = item.companion_state_machine ~= nil and item.companion_state_machine ~= "" and item.companion_state_machine or nil
				local companion_item_animation_event = item.companion_animation_event ~= nil and item.companion_animation_event ~= "" and item.companion_animation_event or nil
				local render_context = {
					camera_focus_slot_name = slot_name,
					state_machine = item_state_machine,
					animation_event = item_animation_event,
					companion_state_machine = companion_item_state_machine,
					companion_animation_event = companion_item_animation_event,
				}

				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
	aquila_button = {
		pass_template = {
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
				pass_type = "texture",
				style_id = "price_icon",
				value = "content/ui/materials/masks/gradient_horizontal",
				value_id = "price_icon",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						30,
						30,
					},
					offset = {
						-30,
						-10,
						4,
					},
				},
				visibility_function = function (content, style)
					return content.element and not content.element.owned and not content.element.formattedPrice
				end,
			},
			{
				pass_type = "text",
				style_id = "price",
				value = "??? ",
				value_id = "price",
				style = aquila_price_text_style,
			},
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
				visibility_function = function (content, style)
					return content.bonus_description ~= ""
				end,
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
				visibility_function = function (content, style)
					return content.bonus_description ~= ""
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
			{
				pass_type = "texture",
				style_id = "divider_top",
				value = "content/ui/materials/frames/premium_store/offer_card_upper_regular",
				value_id = "divider_top",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						nil,
						30,
					},
					offset = {
						0,
						-15,
						6,
					},
					size_addition = {
						20,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_bottom",
				value = "content/ui/materials/frames/premium_store/offer_card_lower_regular",
				value_id = "divider_bottom",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "bottom",
					size = {
						nil,
						30,
					},
					offset = {
						0,
						15,
						6,
					},
					size_addition = {
						20,
						0,
					},
				},
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
					size = {
						196,
						230.99999999999997,
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
				change_function = function (content, style)
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
					local min_uv = 0.95
					local max_uv = 1
					local start_uv = 0
					local end_uv = 1
					local current_uv = (max_uv - min_uv) * progress * 0.5

					style.uvs[1][1] = start_uv + current_uv
					style.uvs[1][2] = start_uv + current_uv
					style.uvs[2][1] = end_uv - current_uv
					style.uvs[2][2] = end_uv - current_uv
				end,
			},
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			content.title = element.title or "<empty>"
			content.bonus_description = element.description or ""

			local title_style = style.title
			local max_width = content.size[1] + style.title.size_addition[1]
			local title_options = UIFonts.get_font_options_by_style(title_style)
			local title_width, title_height = parent:_text_size(content.title, title_style.font_type, title_style.font_size, {
				max_width,
				200,
			}, title_options)
			local icon_margin = 10
			local price_text = element.owned and string.format("%s ", Localize("loc_item_owned")) or element.formattedPrice and element.formattedPrice or Text.format_currency(element.price)

			price_text = string.gsub(price_text, "￥", "¥")
			content.price = price_text

			local wallet_settings = WalletSettings.aquilas
			local font_gradient_material = wallet_settings.font_gradient_material
			local icon_texture_small = wallet_settings.icon_texture_small

			style.price.material = not element.owned and font_gradient_material
			style.price.text_color = element.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
			style.texture.material_values.main_texture = element.texture_map
			content.icon = icon_texture_small
			style.title_background.size = {
				[2] = title_height,
			}
			style.icon.offset[1] = (title_width + style.icon.size[1] + icon_margin) * 0.5

			if content.bonus_description ~= "" then
				content.divider_top = "content/ui/materials/frames/premium_store/offer_card_upper_sale"
				content.divider_bottom = "content/ui/materials/frames/premium_store/offer_card_lower_sale"
			end

			if element.description ~= "" then
				style.texture.offset[2] = -40
				style.texture.size = {
					168,
					198,
				}
			else
				style.texture.offset[2] = -10
			end
		end,
	},
	button_special_offer_1 = {
		pass_template = {
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
				style = item_header_premium_text_style,
			},
			{
				pass_type = "text",
				style_id = "sub_title",
				value = "<Sub Title>",
				value_id = "sub_title",
				style = item_sub_header_text_style,
			},
			{
				pass_type = "texture",
				style_id = "divider_top",
				value = "content/ui/materials/frames/premium_store/offer_card_upper_special_1",
				value_id = "divider_top",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						nil,
						46.199999999999996,
					},
					offset = {
						0,
						-20,
						6,
					},
					size_addition = {
						8,
						0,
					},
					material_values = {
						gunge_size = {
							147,
							46.199999999999996,
						},
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "divider_bottom",
				value = "content/ui/materials/frames/premium_store/offer_card_lower_special_1",
				value_id = "divider_bottom",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "bottom",
					size = {
						nil,
						42,
					},
					offset = {
						0,
						14,
						6,
					},
					size_addition = {
						8,
						0,
					},
				},
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
					return not content.has_media
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
				change_function = function (content, style)
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
					local min_uv = 0.95
					local max_uv = 1
					local start_uv = 0
					local end_uv = 1
					local current_uv = (max_uv - min_uv) * progress * 0.5

					style.uvs[1][1] = start_uv + current_uv
					style.uvs[1][2] = start_uv + current_uv
					style.uvs[2][1] = end_uv - current_uv
					style.uvs[2][2] = end_uv - current_uv
				end,
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
				style_id = "discount_percent_1",
				value = "content/ui/materials/frames/premium_store/sale_banner",
				value_id = "discount_percent_1",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-35,
						-67,
						6,
					},
					size = {
						28,
						44,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.show_discount_percent_1
				end,
			},
			{
				pass_type = "texture",
				style_id = "discount_percent_2",
				value = "content/ui/materials/frames/premium_store/sale_banner",
				value_id = "discount_percent_2",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-55,
						-67,
						6,
					},
					size = {
						28,
						44,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.show_discount_percent_2
				end,
			},
			{
				pass_type = "texture",
				style_id = "discount_percent_3",
				value = "content/ui/materials/frames/premium_store/sale_banner",
				value_id = "discount_percent_3",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-75,
						-67,
						6,
					},
					size = {
						28,
						44,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.show_discount_percent_3
				end,
			},
			{
				pass_type = "texture",
				style_id = "discount_percent_background",
				value = "content/ui/materials/frames/premium_store/sale_banner_03",
				value_id = "discount_percent_background",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						20,
						-20,
						5,
					},
					size = {
						256,
						128,
					},
					size_addition = {
						0,
						0,
					},
				},
				visibility_function = function (content, style)
					return content.discount_banner
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
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.widget_type = "button_hightier"
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			content.title = element.title or "<empty>"
			content.sub_title = element.sub_title or "<empty>"
			content.description = element.description or "<empty>"

			local title_style = style.title
			local title_width = content.size[1] + style.title.size_addition[1]
			local title_options = UIFonts.get_font_options_by_style(title_style)
			local _, title_height = parent:_text_size(content.title, title_style.font_type, title_style.font_size, {
				title_width,
				math.huge,
			}, title_options)

			content.price = element.owned and string.format("%s ", Localize("loc_item_owned")) or element.formattedPrice and element.formattedPrice or Text.format_currency(element.price)

			local wallet_settings = WalletSettings.aquilas
			local font_gradient_material = wallet_settings.font_gradient_material
			local icon_texture_small = wallet_settings.icon_texture_small

			style.price.material = not element.owned and font_gradient_material
			style.price.text_color = element.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
			content.price_icon = icon_texture_small
			content.has_media = not not element.texture_map
			content.has_aquila_texture = not not element.aquila_texture
			style.texture.material_values.main_texture = element.aquila_texture or element.texture_map

			if element.aquila_texture then
				style.texture.size = {
					215,
					215,
				}
			end

			local icon_margin = 10

			style.icon.size_addition[1] = content.size[1] - style.icon.size[1] - icon_margin * 2
			style.icon.size_addition[2] = content.size[1] / style.icon.size[1] * style.icon.size[2] - style.icon.size[2] - icon_margin * 2

			local icon_margin = 0
			local price_style = style.price
			local price_options = UIFonts.get_font_options_by_style(price_style)
			local price_width, price_height = parent:_text_size(content.price, price_style.font_type, price_style.font_size, {
				title_width,
				math.huge,
			}, price_options)

			style.price.offset[1] = element.owned and style.price_icon.offset[1] or style.price_icon.offset[1] - icon_margin - style.price_icon.size[1]

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

			local discount_percent = element.discount_percent

			if element.discount then
				local text_width, _ = parent:_text_size(content.price, price_style.font_type, price_style.font_size)
				local discount_margin = 20
				local price_style = style.price

				content.discount_price = string.format("{#strike(true)}%s{#strike(false)}", Text.format_currency(element.discount))
				style.discount_price.text_color = Color.terminal_text_body(255, true)

				local discount_style = style.discount_price
				local discount_options = UIFonts.get_font_options_by_style(discount_style)
				local discount_width, discount_height = parent:_text_size(content.discount_price, discount_style.font_type, discount_style.font_size, {
					title_width,
					math.huge,
				}, discount_options)

				style.discount_price.offset[1] = style.price.offset[1] - discount_margin - price_width
			end

			if discount_percent then
				content.discount_banner = true

				local index = 1
				local value_to_string = tostring(discount_percent)
				local num_digits = #value_to_string

				for i = num_digits, 1, -1 do
					local string_digit = string.sub(value_to_string, i - 1, 1)

					if string_digit and string_digit ~= "" then
						local pass_name = string.format("discount_percent_%d", index)
						local show_pass_name = string.format("show_%s", pass_name)

						content[show_pass_name] = true
						content[pass_name] = string.format("content/ui/materials/frames/premium_store/sale_banner_number_%s", string_digit)
					end

					index = index + 1
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local ui_scale = ui_renderer.scale

			widget.style.divider_bottom.material_values = widget.style.divider_bottom.material_values or {}
			widget.style.divider_bottom.material_values.ui_scale = ui_scale
		end,
		load_icon = function (parent, widget, element)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local slot_name = element.slot
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				local item_state_machine = item.state_machine
				local item_animation_event = item.animation_event
				local companion_item_state_machine = item.companion_state_machine ~= nil and item.companion_state_machine ~= "" and item.companion_state_machine or nil
				local companion_item_animation_event = item.companion_animation_event ~= nil and item.companion_animation_event ~= "" and item.companion_animation_event or nil
				local render_context = {
					camera_focus_slot_name = slot_name,
					state_machine = item_state_machine,
					animation_event = item_animation_event,
					companion_state_machine = companion_item_state_machine,
					companion_animation_event = companion_item_animation_event,
				}

				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
}

return blueprints
