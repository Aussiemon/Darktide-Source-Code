local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local WeaponStats = require("scripts/utilities/weapon_stats")
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Item = require("scripts/utilities/items")
local DEBUG_BACKGROUNDS = false
local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select
}

local function get_style_text_height(text, style, ui_renderer)
	local text_font_data = UIFonts.data_by_type(style.font_type)
	local text_font = text_font_data.path
	local text_size = style.size
	local text_options = UIFonts.get_font_options_by_style(style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, text_size, text_options)

	return text_height
end

local function get_style_text_width(text, style, ui_renderer)
	local text_font_data = UIFonts.data_by_type(style.font_type)
	local text_font = text_font_data.path
	local text_size = style.size
	local text_options = UIFonts.get_font_options_by_style(style)
	local text_width, _ = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, text_size, text_options)

	return text_width
end

local function generate_blueprints_function(grid_size, optional_item)
	local grid_width = grid_size[1]
	local equipped_display_name_style = table.clone(UIFontSettings.header_3)
	equipped_display_name_style.font_size = 24
	equipped_display_name_style.offset = {
		0,
		5,
		3
	}
	equipped_display_name_style.text_horizontal_alignment = "center"
	equipped_display_name_style.text_vertical_alignment = "top"
	equipped_display_name_style.text_color = Color.terminal_text_header(255, true)
	local weapon_display_name_style = table.clone(UIFontSettings.header_3)
	weapon_display_name_style.font_size = 24
	weapon_display_name_style.offset = {
		0,
		15,
		4
	}
	weapon_display_name_style.size = {
		grid_width,
		500
	}
	weapon_display_name_style.text_horizontal_alignment = "center"
	weapon_display_name_style.text_vertical_alignment = "top"
	weapon_display_name_style.text_color = Color.terminal_text_header(255, true)
	local weapon_type_name_style = table.clone(UIFontSettings.header_3)
	weapon_type_name_style.offset = {
		0,
		24,
		4
	}
	weapon_type_name_style.font_size = 20
	weapon_type_name_style.size = {
		grid_width,
		500
	}
	weapon_type_name_style.text_horizontal_alignment = "center"
	weapon_type_name_style.text_vertical_alignment = "top"
	weapon_type_name_style.text_color = Color.terminal_text_body_sub_header(255, true)
	local weapon_keyword_style = table.clone(UIFontSettings.header_3)
	weapon_keyword_style.offset = {
		0,
		0,
		3
	}
	weapon_keyword_style.font_size = 18
	weapon_keyword_style.text_horizontal_alignment = "center"
	weapon_keyword_style.text_vertical_alignment = "center"
	weapon_keyword_style.text_color = Color.terminal_text_header(255, true)
	local weapon_skin_requirement_header_style = table.clone(UIFontSettings.header_3)
	weapon_skin_requirement_header_style.offset = {
		10,
		0,
		3
	}
	weapon_skin_requirement_header_style.size = {
		grid_width - 20,
		30
	}
	weapon_skin_requirement_header_style.font_size = 22
	weapon_skin_requirement_header_style.text_horizontal_alignment = "left"
	weapon_skin_requirement_header_style.text_vertical_alignment = "top"
	weapon_skin_requirement_header_style.text_color = Color.terminal_corner_selected(255, true)
	local weapon_skin_requirement_style = table.clone(UIFontSettings.body)
	weapon_skin_requirement_style.offset = {
		10,
		0,
		3
	}
	weapon_skin_requirement_style.size = {
		grid_width - 20,
		500
	}
	weapon_skin_requirement_style.font_size = 20
	weapon_skin_requirement_style.text_horizontal_alignment = "left"
	weapon_skin_requirement_style.text_vertical_alignment = "top"
	weapon_skin_requirement_style.text_color = Color.terminal_text_body(255, true)
	local weapon_stat_text_style = table.clone(UIFontSettings.body)
	weapon_stat_text_style.offset = {
		0,
		0,
		4
	}
	weapon_stat_text_style.size = {
		160
	}
	weapon_stat_text_style.font_size = 16
	weapon_stat_text_style.text_horizontal_alignment = "left"
	weapon_stat_text_style.text_vertical_alignment = "top"
	weapon_stat_text_style.text_color = Color.terminal_text_body(255, true)
	local weapon_value_style = table.clone(UIFontSettings.body)
	weapon_value_style.offset = {
		0,
		0,
		4
	}
	weapon_value_style.size = {
		200
	}
	weapon_value_style.font_size = 32
	weapon_value_style.text_horizontal_alignment = "left"
	weapon_value_style.text_vertical_alignment = "top"
	weapon_value_style.text_color = Color.white(255, true)
	weapon_value_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"
	local stamina_value_style = table.clone(UIFontSettings.body)
	stamina_value_style.offset = {
		0,
		0,
		4
	}
	stamina_value_style.size = {
		150
	}
	stamina_value_style.font_size = 20
	stamina_value_style.text_horizontal_alignment = "left"
	stamina_value_style.text_vertical_alignment = "top"
	stamina_value_style.text_color = Color.terminal_text_body(255, true)
	local weapon_perk_style = table.clone(UIFontSettings.body)
	weapon_perk_style.offset = {
		98,
		0,
		3
	}
	weapon_perk_style.size = {
		grid_width - 106
	}
	weapon_perk_style.font_size = 18
	weapon_perk_style.text_horizontal_alignment = "left"
	weapon_perk_style.text_vertical_alignment = "center"
	weapon_perk_style.text_color = Color.terminal_text_body(255, true)
	local gadget_trait_style = table.clone(UIFontSettings.body)
	gadget_trait_style.offset = {
		98,
		0,
		3
	}
	gadget_trait_style.size = {
		grid_width - 106
	}
	gadget_trait_style.font_size = 18
	gadget_trait_style.text_horizontal_alignment = "left"
	gadget_trait_style.text_vertical_alignment = "center"
	gadget_trait_style.text_color = Color.terminal_text_header(255, true)
	local weapon_traits_style = table.clone(UIFontSettings.header_3)
	weapon_traits_style.offset = {
		98,
		0,
		3
	}
	weapon_traits_style.size = {
		grid_width - 106
	}
	weapon_traits_style.font_size = 18
	weapon_traits_style.text_horizontal_alignment = "left"
	weapon_traits_style.text_vertical_alignment = "top"
	weapon_traits_style.text_color = Color.terminal_text_header(255, true)
	local weapon_traits_description_style = table.clone(UIFontSettings.body)
	weapon_traits_description_style.offset = {
		98,
		20,
		3
	}
	weapon_traits_description_style.size = {
		grid_width - 106,
		500
	}
	weapon_traits_description_style.font_size = 18
	weapon_traits_description_style.text_horizontal_alignment = "left"
	weapon_traits_description_style.text_vertical_alignment = "top"
	weapon_traits_description_style.text_color = Color.terminal_text_body(255, true)
	local description_style = table.clone(UIFontSettings.body)
	description_style.offset = {
		10,
		0,
		3
	}
	description_style.size = {
		grid_width - 20,
		500
	}
	description_style.font_size = 18
	description_style.line_spacing = 1.4
	description_style.text_horizontal_alignment = "left"
	description_style.text_vertical_alignment = "top"
	description_style.text_color = Color.terminal_text_header(255, true)
	local weapon_attack_info_style = table.clone(UIFontSettings.body)
	weapon_attack_info_style.offset = {
		52,
		0,
		4
	}
	weapon_attack_info_style.size = {
		grid_width - 62
	}
	weapon_attack_info_style.font_size = 20
	weapon_attack_info_style.text_horizontal_alignment = "left"
	weapon_attack_info_style.text_vertical_alignment = "center"
	weapon_attack_info_style.text_color = Color.terminal_text_body(255, true)
	local weapon_attack_header_style = table.clone(UIFontSettings.body)
	weapon_attack_header_style.offset = {
		10,
		0,
		4
	}
	weapon_attack_header_style.size = {
		grid_width - 20
	}
	weapon_attack_header_style.font_size = 18
	weapon_attack_header_style.text_horizontal_alignment = "left"
	weapon_attack_header_style.text_vertical_alignment = "center"
	weapon_attack_header_style.text_color = Color.terminal_text_header(255, true)

	local function _apply_package_item_icon_cb_func(widget, item, optional_texture_id)
		local icon = item.icon
		local material_values = widget.style.icon.material_values
		material_values[optional_texture_id or "texture_icon"] = icon
		material_values.use_placeholder_texture = 0
	end

	local function _remove_package_item_icon_cb_func(widget, ui_renderer, optional_texture_id)
		if widget.content.visible then
			UIWidget.set_visible(widget, ui_renderer, false)
			UIWidget.set_visible(widget, ui_renderer, true)
		end

		local material_values = widget.style.icon.material_values
		material_values[optional_texture_id or "texture_icon"] = nil
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

	local function _remove_live_item_icon_cb_func(widget)
		local material_values = widget.style.icon.material_values
		material_values.use_placeholder_texture = 1
		material_values.texture_icon = nil
	end

	local blueprints = {
		equipped = {
			size = {
				grid_width,
				50
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.terminal_frame(50, true)
					}
				},
				{
					value_id = "display_name",
					pass_type = "text",
					style_id = "display_name",
					style = equipped_display_name_style,
					value = Localize("loc_item_information_equipped_label")
				}
			}
		},
		weapon_header = {
			size = {
				grid_width,
				240
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.black(255, true)
					}
				},
				{
					value_id = "left_divider",
					style_id = "left_divider",
					pass_type = "texture_uv",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							-12,
							-18,
							3
						},
						size = {
							18
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						},
						uvs = {
							{
								1,
								0
							},
							{
								0,
								1
							}
						}
					}
				},
				{
					value_id = "right_divider",
					style_id = "right_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							12,
							-18,
							3
						},
						size = {
							18
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						}
					}
				},
				{
					value_id = "bottom_divider",
					style_id = "bottom_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/horizontal_frame_big_middle",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						offset = {
							0,
							22,
							4
						},
						size = {
							nil,
							44
						},
						size_addition = {
							12,
							0
						},
						color = Color.white(255, true)
					}
				},
				{
					value_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						size = {
							grid_width,
							190
						},
						offset = {
							0,
							0,
							3
						},
						color = Color.white(255, true),
						material_values = {}
					}
				},
				{
					value_id = "background",
					style_id = "background",
					pass_type = "texture",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							1
						},
						color = Color.white(255, true)
					}
				},
				{
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							2
						},
						color = Color.black(140, true)
					}
				},
				{
					value_id = "display_name",
					pass_type = "text",
					style_id = "display_name",
					value = "n/a",
					style = weapon_display_name_style
				},
				{
					value_id = "type_name",
					pass_type = "text",
					style_id = "type_name",
					value = "n/a",
					style = weapon_type_name_style
				},
				{
					style_id = "text_extra_title",
					value_id = "text_extra_title",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						text_vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							20,
							-48,
							5
						},
						text_color = Color.text_default(255, true)
					})
				},
				{
					style_id = "text_extra_value",
					value_id = "text_extra_value",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_value_style), {
						text_vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							20,
							-8,
							6
						},
						text_color = Color.white(255, true)
					})
				},
				{
					value_id = "attack_icon_3",
					style_id = "attack_icon_3",
					pass_type = "texture",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							-20,
							-18,
							5
						},
						size = {
							32,
							32
						},
						color = Color.text_default(255, true)
					}
				},
				{
					value_id = "attack_icon_2",
					style_id = "attack_icon_2",
					pass_type = "texture",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							-67,
							-18,
							5
						},
						size = {
							32,
							32
						},
						color = Color.text_default(255, true)
					}
				},
				{
					value_id = "attack_icon_1",
					style_id = "attack_icon_1",
					pass_type = "texture",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							-114,
							-18,
							5
						},
						size = {
							32,
							32
						},
						color = Color.text_default(255, true)
					}
				},
				{
					style_id = "fire_mode_icon_3",
					value_id = "fire_mode_icon_3",
					pass_type = "texture",
					value = "content/ui/materials/icons/weapons/actions/burst",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							-20,
							-8,
							5
						},
						size = {
							32,
							10
						},
						color = Color.text_default(255, true)
					},
					visibility_function = function (content, style)
						return content.fire_mode_icon_3
					end
				},
				{
					style_id = "fire_mode_icon_2",
					value_id = "fire_mode_icon_2",
					pass_type = "texture",
					value = "content/ui/materials/icons/weapons/actions/burst",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							-67,
							-8,
							5
						},
						size = {
							32,
							10
						},
						color = Color.text_default(255, true)
					},
					visibility_function = function (content, style)
						return content.fire_mode_icon_2
					end
				},
				{
					style_id = "fire_mode_icon_1",
					value_id = "fire_mode_icon_1",
					pass_type = "texture",
					value = "content/ui/materials/icons/weapons/actions/burst",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							-114,
							-8,
							5
						},
						size = {
							32,
							10
						},
						color = Color.text_default(255, true)
					},
					visibility_function = function (content, style)
						return content.fire_mode_icon_1
					end
				},
				{
					value = "/",
					style_id = "attack_icon_divider_2",
					pass_type = "text",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						vertical_alignment = "bottom",
						text_vertical_alignment = "center",
						font_size = 32,
						horizontal_alignment = "right",
						text_horizontal_alignment = "center",
						offset = {
							-43.5,
							-18,
							5
						},
						size = {
							32,
							32
						},
						text_color = Color.white(50, true)
					})
				},
				{
					value = "/",
					style_id = "attack_icon_divider_1",
					pass_type = "text",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						vertical_alignment = "bottom",
						text_vertical_alignment = "center",
						font_size = 32,
						horizontal_alignment = "right",
						text_horizontal_alignment = "center",
						offset = {
							-90.5,
							-18,
							5
						},
						size = {
							32,
							32
						},
						text_color = Color.white(50, true)
					})
				}
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				local display_name = ItemUtils.display_name(item)
				local type_name = ItemUtils.sub_display_name(item)
				content.display_name = display_name
				content.type_name = type_name
				local type_name_style = style.type_name
				local display_name_text_height = get_style_text_height(display_name, weapon_display_name_style, ui_renderer)
				type_name_style.offset[2] = type_name_style.offset[2] + display_name_text_height
				style.background.color = table.clone(ItemUtils.rarity_color(item))
				style.background.material_values = {
					direction = 1
				}
				local rarity_color = ItemUtils.rarity_color(item)
				style.display_name.text_color = rarity_color
				style.type_name.text_color = rarity_color
				local weapon_template = WeaponTemplate.weapon_template_from_item(item)
				local displayed_attacks = weapon_template.displayed_attacks
				local is_ranged_weapon = ItemUtils.is_weapon_template_ranged(item)

				if displayed_attacks then
					local weapon_action_display_order_array = UISettings.weapon_action_display_order_array
					local weapon_action_type_icons = UISettings.weapon_action_type_icons

					for index, key in ipairs(weapon_action_display_order_array) do
						local data = displayed_attacks[key]
						local pass_id = "attack_icon_" .. index
						local fire_mode_pass_id = "fire_mode_icon_" .. index

						if data then
							local attack_type = data.type
							local attack_icon = weapon_action_type_icons[attack_type]
							content[pass_id] = attack_icon
							style[pass_id].offset[2] = is_ranged_weapon and -18 or -8
							style[fire_mode_pass_id].color[1] = is_ranged_weapon and 255 or 0

							if is_ranged_weapon then
								local attack_fire_mode = data.fire_mode
								local fire_mode_icon = UISettings.weapon_fire_type_icons[attack_fire_mode]
								content[fire_mode_pass_id] = fire_mode_icon
							end
						elseif is_ranged_weapon then
							content[fire_mode_pass_id] = nil
						end
					end

					style.attack_icon_divider_1.offset[2] = is_ranged_weapon and -18 or -8
					style.attack_icon_divider_2.offset[2] = is_ranged_weapon and -18 or -8
				end

				local item_level = ItemUtils.item_level(item)
				content.text_extra_title = Localize("loc_item_information_item_level")
				content.text_extra_value = item_level
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					content.icon_load_id = parent:load_item_icon(item, cb)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end
		},
		skin_header = {
			size = {
				grid_width,
				100
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = ItemUtils.display_name(item) .. "\n" .. ItemUtils.sub_display_name(item)
				local text_height = get_style_text_height(text, weapon_display_name_style, ui_renderer)
				local entry_height = math.max(0, text_height + 40)

				return {
					grid_width,
					entry_height
				}
			end,
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.black(255, true)
					}
				},
				{
					value_id = "left_divider",
					style_id = "left_divider",
					pass_type = "texture_uv",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							-9,
							-12,
							3
						},
						size = {
							18,
							100
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						},
						uvs = {
							{
								1,
								0
							},
							{
								0,
								1
							}
						}
					}
				},
				{
					value_id = "right_divider",
					style_id = "right_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							9,
							-12,
							3
						},
						size = {
							18,
							100
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						}
					}
				},
				{
					value_id = "bottom_divider",
					style_id = "bottom_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/horizontal_frame_big_middle",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						offset = {
							0,
							22,
							4
						},
						size = {
							nil,
							44
						},
						size_addition = {
							8,
							0
						},
						color = Color.white(255, true)
					}
				},
				{
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							2
						},
						color = Color.black(140, true)
					}
				},
				{
					style_id = "display_name",
					pass_type = "text",
					value_id = "display_name",
					value = "n/a",
					style = weapon_display_name_style
				},
				{
					style_id = "type_name",
					pass_type = "text",
					value_id = "type_name",
					value = "n/a",
					style = weapon_type_name_style
				}
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				local display_name = ItemUtils.display_name(item)
				local type_name = ItemUtils.sub_display_name(item)
				content.display_name = display_name
				content.type_name = type_name
				local type_name_style = style.type_name
				local display_name_text_height = get_style_text_height(display_name, weapon_display_name_style, ui_renderer)
				type_name_style.offset[2] = type_name_style.offset[2] + display_name_text_height
				style.left_divider.size[2] = style.left_divider.size[2] + display_name_text_height
				style.right_divider.size[2] = style.right_divider.size[2] + display_name_text_height
			end
		},
		weapon_skin_icon = {
			size = {
				grid_width,
				200
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.black(255, true)
					}
				},
				{
					value_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						size = {
							grid_width,
							200
						},
						offset = {
							0,
							0,
							3
						},
						color = Color.white(255, true),
						material_values = {}
					}
				},
				{
					value_id = "left_divider",
					style_id = "left_divider",
					pass_type = "texture_uv",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							-9,
							-12,
							3
						},
						size = {
							18,
							200
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						},
						uvs = {
							{
								1,
								0
							},
							{
								0,
								1
							}
						}
					}
				},
				{
					value_id = "right_divider",
					style_id = "right_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							9,
							-12,
							3
						},
						size = {
							18,
							200
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						}
					}
				},
				{
					value_id = "bottom_divider",
					style_id = "bottom_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/horizontal_frame_big_middle",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						offset = {
							0,
							22,
							4
						},
						size = {
							nil,
							44
						},
						size_addition = {
							8,
							0
						},
						color = Color.white(255, true)
					}
				},
				{
					value_id = "background",
					style_id = "background",
					pass_type = "texture",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							1
						},
						color = Color.terminal_corner_hover(255, true)
					}
				},
				{
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							2
						},
						color = Color.black(140, true)
					}
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				content.element = element
				style.background.material_values = {
					direction = 1
				}
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local visual_item = element.visual_item
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					content.icon_load_id = parent:load_item_icon(visual_item, cb)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end
		},
		cosmetic_gear_icon = {
			size = {
				grid_width,
				UISettings.weapon_icon_size[2] * 2
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.black(255, true)
					}
				},
				{
					value_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						size = {
							grid_width,
							UISettings.weapon_icon_size[2] * 2
						},
						offset = {
							0,
							0,
							3
						},
						color = Color.white(255, true),
						material_values = {}
					}
				},
				{
					value_id = "left_divider",
					style_id = "left_divider",
					pass_type = "texture_uv",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							-9,
							-12,
							3
						},
						size = {
							18,
							UISettings.weapon_icon_size[2] * 2
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						},
						uvs = {
							{
								1,
								0
							},
							{
								0,
								1
							}
						}
					}
				},
				{
					value_id = "right_divider",
					style_id = "right_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							9,
							-12,
							3
						},
						size = {
							18,
							UISettings.weapon_icon_size[2] * 2
						},
						size_addition = {
							0,
							-24
						},
						color = {
							255,
							255,
							255,
							255
						}
					}
				},
				{
					value_id = "bottom_divider",
					style_id = "bottom_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/horizontal_frame_big_middle",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						offset = {
							0,
							22,
							4
						},
						size = {
							nil,
							44
						},
						size_addition = {
							8,
							0
						},
						color = Color.white(255, true)
					}
				},
				{
					value_id = "background",
					style_id = "background",
					pass_type = "texture",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							1
						},
						color = Color.terminal_corner_hover(255, true)
					}
				},
				{
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							2
						},
						color = Color.black(140, true)
					}
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				content.display_name = ItemUtils.display_name(item)
				content.type_name = ItemUtils.sub_display_name(item)
				style.background.material_values = {
					direction = 1
				}
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local slots = item.slots
					local slot_name = slots[1]
					local item_state_machine = item.state_machine
					local item_animation_event = item.animation_event
					local render_context = {
						camera_focus_slot_name = slot_name,
						state_machine = item_state_machine,
						animation_event = item_animation_event
					}
					content.icon_load_id = parent:load_item_icon(item, cb, render_context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end
		},
		gadget_header = {
			size = {
				grid_width,
				300
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.black(255, true)
					}
				},
				{
					value_id = "left_divider",
					style_id = "left_divider",
					pass_type = "texture_uv",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							-12,
							-10,
							3
						},
						size = {
							18
						},
						size_addition = {
							0,
							-25
						},
						color = {
							255,
							255,
							255,
							255
						},
						uvs = {
							{
								1,
								0
							},
							{
								0,
								1
							}
						}
					}
				},
				{
					value_id = "right_divider",
					style_id = "right_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/vertical_dynamic_01",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						offset = {
							12,
							-10,
							3
						},
						size = {
							18
						},
						size_addition = {
							0,
							-25
						},
						color = {
							255,
							255,
							255,
							255
						}
					}
				},
				{
					value_id = "bottom_divider",
					style_id = "bottom_divider",
					pass_type = "texture",
					value = "content/ui/materials/dividers/horizontal_frame_big_middle",
					style = {
						vertical_alignment = "bottom",
						horizontal_alignment = "center",
						offset = {
							0,
							22,
							4
						},
						size = {
							nil,
							44
						},
						size_addition = {
							12,
							0
						},
						color = Color.white(255, true)
					}
				},
				{
					value_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					value = "content/ui/materials/icons/items/containers/item_container_tooltip_no_rarity",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						size = {
							grid_width,
							200
						},
						offset = {
							0,
							0,
							3
						},
						color = Color.white(255, true),
						material_values = {}
					}
				},
				{
					value_id = "background",
					style_id = "background",
					pass_type = "texture",
					value = "content/ui/materials/gradients/gradient_vertical",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							1
						},
						color = Color.terminal_corner_hover(255, true)
					}
				},
				{
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							2
						},
						color = Color.black(140, true)
					}
				},
				{
					style_id = "text_extra_title",
					value_id = "text_extra_title",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						text_vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							20,
							-48,
							5
						},
						text_color = Color.text_default(255, true)
					})
				},
				{
					style_id = "text_extra_value",
					value_id = "text_extra_value",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_value_style), {
						text_vertical_alignment = "bottom",
						horizontal_alignment = "left",
						offset = {
							20,
							-8,
							6
						},
						text_color = Color.white(255, true)
					})
				},
				{
					style_id = "display_name",
					pass_type = "text",
					value_id = "display_name",
					value = "n/a",
					style = weapon_display_name_style
				},
				{
					style_id = "type_name",
					pass_type = "text",
					value_id = "type_name",
					value = "n/a",
					style = weapon_type_name_style
				}
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				local display_name = ItemUtils.display_name(item)
				local type_name = ItemUtils.sub_display_name(item)
				content.display_name = display_name
				content.type_name = type_name
				local type_name_style = style.type_name
				local display_name_text_height = get_style_text_height(display_name, weapon_display_name_style, ui_renderer)
				type_name_style.offset[2] = type_name_style.offset[2] + display_name_text_height
				local item_rarity = item.rarity

				if item_rarity then
					local rarity_color = ItemUtils.rarity_color(item)
					style.background.color = table.clone(rarity_color)
					style.display_name.text_color = table.clone(rarity_color)
					style.type_name.text_color = table.clone(rarity_color)
				end

				style.background.material_values = {
					direction = 1
				}
				local item_level = ItemUtils.item_level(item)
				content.text_extra_title = Localize("loc_item_information_item_level")
				content.text_extra_value = item_level
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					content.icon_load_id = parent:load_item_icon(item, cb)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_live_item_icon_cb_func(widget)
					parent:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end
		},
		portrait_frame_header = {
			size = {
				grid_width,
				280
			},
			pass_template = {
				{
					value_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					value = "content/ui/materials/base/ui_portrait_frame_base",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						size = {
							140,
							160
						},
						offset = {
							0,
							35,
							2
						},
						color = Color.white(255, true),
						material_values = {
							use_placeholder_texture = 1
						}
					}
				},
				{
					style_id = "display_name",
					pass_type = "text",
					value_id = "display_name",
					value = "n/a",
					style = weapon_display_name_style
				},
				{
					style_id = "type_name",
					pass_type = "text",
					value_id = "type_name",
					value = "n/a",
					style = weapon_type_name_style
				}
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				local display_name = ItemUtils.display_name(item)
				local type_name = ItemUtils.sub_display_name(item)
				content.display_name = display_name
				content.type_name = type_name
				local type_name_style = style.type_name
				local display_name_text_height = get_style_text_height(display_name, weapon_display_name_style, ui_renderer)
				type_name_style.offset[2] = type_name_style.offset[2] + display_name_text_height
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local slots = item.slots
					local slot_name = slots[1]
					local cb = callback(_apply_package_item_icon_cb_func, widget, item, "portrait_frame_texture")
					local render_context = {
						camera_focus_slot_name = slot_name
					}
					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "portrait_frame_texture")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "portrait_frame_texture")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end
		},
		insignia_header = {
			size = {
				grid_width,
				280
			},
			pass_template = {
				{
					value_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						size = {
							60,
							160
						},
						offset = {
							0,
							30,
							2
						},
						color = Color.white(255, true),
						material_values = {
							use_placeholder_texture = 1
						}
					}
				},
				{
					style_id = "display_name",
					pass_type = "text",
					value_id = "display_name",
					value = "n/a",
					style = weapon_display_name_style
				},
				{
					style_id = "type_name",
					pass_type = "text",
					value_id = "type_name",
					value = "n/a",
					style = weapon_type_name_style
				}
			},
			init = function (parent, widget, element, callback_name, _, ui_renderer)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				local display_name = ItemUtils.display_name(item)
				local type_name = ItemUtils.sub_display_name(item)
				content.display_name = display_name
				content.type_name = type_name
				local type_name_style = style.type_name
				local display_name_text_height = get_style_text_height(display_name, weapon_display_name_style, ui_renderer)
				type_name_style.offset[2] = type_name_style.offset[2] + display_name_text_height
			end,
			load_icon = function (parent, widget, element)
				local content = widget.content

				if not content.icon_load_id then
					local item = element.item
					local slots = item.slots
					local slot_name = slots[1]
					local cb = callback(_apply_package_item_icon_cb_func, widget, item, "texture_map")
					local render_context = {
						camera_focus_slot_name = slot_name
					}
					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
				end
			end,
			unload_icon = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "texture_map")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				local content = widget.content

				if content.icon_load_id then
					_remove_package_item_icon_cb_func(widget, ui_renderer, "texture_map")
					Managers.ui:unload_item_icon(content.icon_load_id)

					content.icon_load_id = nil
				end
			end
		},
		weapon_keywords = {
			size = {
				grid_width,
				36
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.terminal_frame(50, true)
					}
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "text",
					style = weapon_keyword_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local item = element.item
				content.text = ItemUtils.keywords_text(item)
			end
		},
		weapon_stats = {
			size = {
				grid_width,
				114
			},
			pass_template = {
				{
					style_id = "text_1",
					value_id = "text_1",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						horizontal_alignment = "left",
						offset = {
							20,
							10,
							3
						}
					})
				},
				{
					style_id = "background_1",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							20,
							38,
							3
						},
						size = {
							150,
							8
						},
						color = Color.black(200, true)
					}
				},
				{
					style_id = "frame_1",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							18,
							36,
							2
						},
						size = {
							154,
							12
						},
						color = Color.terminal_frame(200, true)
					}
				},
				{
					value = "content/ui/materials/backgrounds/default_square",
					style_id = "bar_1",
					pass_type = "texture",
					style = {
						horizontal_alignment = "left",
						offset = {
							20,
							38,
							4
						},
						size = {
							150,
							8
						},
						color = Color.terminal_corner_selected(255, true)
					}
				},
				{
					pass_type = "hotspot",
					content_id = "hotspot_1",
					content = default_button_content,
					style = {
						offset = {
							20,
							0,
							0
						},
						size = {
							150,
							60
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_frame_1",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						hdr = false,
						offset = {
							15,
							8,
							0
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true),
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_1",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							15,
							8,
							1
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_1",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							15,
							8,
							2
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					style_id = "text_2",
					value_id = "text_2",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						horizontal_alignment = "left",
						offset = {
							190,
							10,
							3
						}
					})
				},
				{
					style_id = "background_2",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							190,
							38,
							3
						},
						size = {
							150,
							8
						},
						color = Color.black(200, true)
					}
				},
				{
					style_id = "frame_2",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							188,
							36,
							2
						},
						size = {
							154,
							12
						},
						color = Color.terminal_frame(200, true)
					}
				},
				{
					value = "content/ui/materials/backgrounds/default_square",
					style_id = "bar_2",
					pass_type = "texture",
					style = {
						horizontal_alignment = "left",
						offset = {
							190,
							38,
							4
						},
						size = {
							150,
							8
						},
						color = Color.terminal_corner_selected(255, true)
					}
				},
				{
					pass_type = "hotspot",
					content_id = "hotspot_2",
					content = default_button_content,
					style = {
						offset = {
							190,
							0,
							0
						},
						size = {
							150,
							60
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_frame_2",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						hdr = false,
						offset = {
							185,
							8,
							0
						},
						size = {
							160,
							45
						},
						color = Color.ui_terminal(0, true),
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_2",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							185,
							8,
							1
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_2",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							185,
							8,
							2
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					style_id = "text_3",
					value_id = "text_3",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						horizontal_alignment = "left",
						offset = {
							360,
							10,
							3
						}
					})
				},
				{
					style_id = "background_3",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							360,
							38,
							3
						},
						size = {
							150,
							8
						},
						color = Color.black(200, true)
					}
				},
				{
					style_id = "frame_3",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							357,
							36,
							2
						},
						size = {
							154,
							12
						},
						color = Color.terminal_frame(200, true)
					}
				},
				{
					value = "content/ui/materials/backgrounds/default_square",
					style_id = "bar_3",
					pass_type = "texture",
					style = {
						horizontal_alignment = "left",
						offset = {
							360,
							38,
							4
						},
						size = {
							150,
							8
						},
						color = Color.terminal_corner_selected(255, true)
					}
				},
				{
					pass_type = "hotspot",
					content_id = "hotspot_3",
					content = default_button_content,
					style = {
						offset = {
							360,
							0,
							0
						},
						size = {
							150,
							60
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_frame_3",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						hdr = false,
						offset = {
							355,
							8,
							0
						},
						size = {
							160,
							45
						},
						color = Color.ui_terminal(0, true),
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_3",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							355,
							8,
							1
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_3",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							355,
							8,
							2
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					style_id = "text_4",
					value_id = "text_4",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						horizontal_alignment = "left",
						offset = {
							20,
							60,
							3
						}
					})
				},
				{
					style_id = "background_4",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							20,
							88,
							3
						},
						size = {
							150,
							8
						},
						color = Color.black(200, true)
					}
				},
				{
					style_id = "frame_4",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							19,
							86,
							2
						},
						size = {
							154,
							12
						},
						color = Color.terminal_frame(200, true)
					}
				},
				{
					value = "content/ui/materials/backgrounds/default_square",
					style_id = "bar_4",
					pass_type = "texture",
					style = {
						horizontal_alignment = "left",
						offset = {
							20,
							88,
							4
						},
						size = {
							150,
							8
						},
						color = Color.terminal_corner_selected(255, true)
					}
				},
				{
					pass_type = "hotspot",
					content_id = "hotspot_4",
					content = default_button_content,
					style = {
						offset = {
							20,
							60,
							0
						},
						size = {
							150,
							60
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_frame_4",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						hdr = false,
						offset = {
							15,
							58,
							0
						},
						size = {
							160,
							45
						},
						color = Color.ui_terminal(0, true),
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_4",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							15,
							58,
							1
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_4",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							15,
							58,
							2
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					style_id = "text_5",
					value_id = "text_5",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						horizontal_alignment = "left",
						offset = {
							190,
							60,
							3
						}
					})
				},
				{
					style_id = "background_5",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							190,
							88,
							3
						},
						size = {
							150,
							8
						},
						color = Color.black(200, true)
					}
				},
				{
					style_id = "frame_5",
					pass_type = "rect",
					style = {
						horizontal_alignment = "left",
						offset = {
							188,
							86,
							2
						},
						size = {
							154,
							12
						},
						color = Color.terminal_frame(200, true)
					}
				},
				{
					value = "content/ui/materials/backgrounds/default_square",
					style_id = "bar_5",
					pass_type = "texture",
					style = {
						horizontal_alignment = "left",
						offset = {
							190,
							88,
							4
						},
						size = {
							150,
							8
						},
						color = Color.terminal_corner_selected(255, true)
					}
				},
				{
					pass_type = "hotspot",
					content_id = "hotspot_5",
					content = default_button_content,
					style = {
						offset = {
							190,
							60,
							0
						},
						size = {
							150,
							60
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_frame_5",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						hdr = false,
						offset = {
							185,
							58,
							0
						},
						size = {
							160,
							45
						},
						color = Color.ui_terminal(0, true),
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_5",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							185,
							58,
							1
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_5",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							185,
							58,
							2
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					style_id = "text_extra_title",
					value_id = "text_extra_title",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(weapon_stat_text_style), {
						horizontal_alignment = "left",
						offset = {
							360,
							60,
							3
						}
					})
				},
				{
					style_id = "text_extra_value",
					value_id = "text_extra_value",
					pass_type = "text",
					value = "n/a",
					style = table.merge_recursive(table.clone(stamina_value_style), {
						horizontal_alignment = "left",
						offset = {
							360,
							80,
							3
						}
					})
				},
				{
					pass_type = "hotspot",
					content_id = "hotspot_6",
					content = default_button_content,
					style = {
						offset = {
							360,
							60,
							0
						},
						size = {
							150,
							60
						}
					}
				},
				{
					value = "content/ui/materials/gradients/gradient_vertical",
					style_id = "hover_frame_6",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						hdr = false,
						offset = {
							355,
							58,
							0
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true),
						size_addition = {
							0,
							0
						}
					}
				},
				{
					value = "content/ui/materials/frames/frame_tile_1px",
					style_id = "hover_frame_border_6",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							355,
							58,
							1
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				},
				{
					value = "content/ui/materials/frames/frame_corner_2px",
					style_id = "hover_frame_corner_6",
					pass_type = "texture",
					style = {
						vertical_alignment = "top",
						scale_to_material = true,
						horizontal_alignment = "left",
						offset = {
							355,
							58,
							2
						},
						size = {
							160,
							45
						},
						color = Color.terminal_corner_selected(0, true)
					}
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				content.element = element
				local item = element.item
				local weapon_stats = WeaponStats:new(item)
				local compairing_stats = weapon_stats:get_compairing_stats()
				local num_stats = table.size(compairing_stats)
				local compairing_stats_array = {}

				for key, stat in pairs(compairing_stats) do
					compairing_stats_array[#compairing_stats_array + 1] = stat
				end

				local weapon_stats_sort_order = {
					rate_of_fire = 2,
					attack_speed = 2,
					damage = 1,
					stamina_block_cost = 4,
					reload_speed = 4,
					stagger = 3
				}

				local function sort_function(a, b)
					local a_sort_order = weapon_stats_sort_order[a.type] or math.huge
					local b_sort_order = weapon_stats_sort_order[b.type] or math.huge

					return a_sort_order < b_sort_order
				end

				table.sort(compairing_stats_array, sort_function)

				for i = 1, num_stats do
					local stat_data = compairing_stats_array[i]
					local text_id = "text_" .. i
					local background_id = "background_" .. i
					local bar_id = "bar_" .. i
					widget.content.text = Localize(stat_data.display_name)
					local anim_duration = 1
					local value = stat_data.fraction
					local current_progress = content.progress or 0
					local start_value = current_progress
					local end_value = value
					local bar_style = style[bar_id]
					bar_style.size[1] = 150 * value
					local display_name = Localize(stat_data.display_name)
					content[text_id] = display_name
				end

				local main_stats = weapon_stats:get_main_stats()
				local is_ranged_weapon = weapon_stats:is_ranged_weapon()
				local uses_overheat = weapon_stats:uses_overheat()

				if is_ranged_weapon then
					local magazine = main_stats.magazine

					if magazine then
						local ammo = magazine.ammo
						local reserve = magazine.reserve

						if ammo then
							local text = string.format("%.0f", math.floor(ammo))

							if reserve then
								text = text .. "/" .. string.format("%.0f", math.floor(reserve))
							end

							content.text_extra_title = Localize("loc_weapon_stat_title_ammo")
							content.text_extra_value = text
						end
					elseif uses_overheat then
						content.text_extra_title = ""
						content.text_extra_value = ""
					else
						content.text_extra_title = ""
						content.text_extra_value = ""
					end
				else
					local stamina = main_stats.stamina or 0
					content.text_extra_title = Localize("loc_hud_display_name_stamina")
					content.text_extra_value = "+ " .. tostring(stamina)
				end
			end
		},
		weapon_perk = {
			size = {
				grid_width,
				54
			},
			pass_template = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content = {
						disabled = true,
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_select
					}
				},
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.terminal_frame(50, true)
					}
				},
				{
					value = "content/ui/materials/icons/perks/perk_level_01",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						size = {
							20,
							20
						},
						offset = {
							42,
							0,
							0
						},
						color = Color.terminal_icon(255, true)
					}
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "text",
					style = weapon_perk_style
				},
				{
					value = "content/ui/materials/backgrounds/default_square",
					pass_type = "texture",
					style = {
						default_color = Color.terminal_background(nil, true),
						hover_color = Color.ui_grey_light(255, true),
						selected_color = Color.terminal_background_selected(nil, true)
					},
					change_function = function (content, style)
						local hotspot = content.hotspot
						local wanted_color = style.default_color

						if hotspot.is_selected then
							wanted_color = style.selected_color
						elseif hotspot.is_hover then
							wanted_color = style.hover_color
						end

						ColorUtilities.color_copy(wanted_color, style.color)
					end
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local perk_item = element.perk_item
				local perk_value = element.perk_value
				local perk_rarity = element.perk_rarity
				local description = ItemUtils.perk_description(perk_item, perk_rarity, perk_value)
				content.text = description

				if element.is_selectable then
					content.perk_index = element.perk_index
					local hotspot = content.hotspot
					hotspot.disabled = false
					local view_instance = parent._parent

					if view_instance and view_instance.on_perk_selected then
						hotspot.pressed_callback = callback(view_instance, "on_perk_selected", element.perk_index, description)
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end
		},
		weapon_trait = {
			size = {
				grid_width,
				114
			},
			size_function = function (parent, element, ui_renderer)
				local trait_item = element.trait_item
				local description = trait_item.description
				local description_height = get_style_text_height(Localize(description), weapon_traits_description_style, ui_renderer)
				local entry_height = math.max(68, description_height + 25)

				return {
					grid_width,
					entry_height
				}
			end,
			pass_template = {
				{
					value = "content/ui/materials/icons/traits/traits_container",
					style_id = "icon",
					pass_type = "texture",
					style = {
						material_values = {},
						size = {
							64,
							64
						},
						offset = {
							20,
							0,
							0
						},
						color = Color.terminal_icon(255, true)
					}
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "display_name",
					style = weapon_traits_style
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "description",
					style = weapon_traits_description_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				content.element = element
				local trait_item = element.trait_item
				local trait_value = element.trait_value
				local trait_rarity = element.trait_rarity
				local display_name = trait_item.display_name
				content.display_name = Localize(display_name)
				local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, trait_rarity)
				local icon_material_values = style.icon.material_values
				icon_material_values.icon = texture_icon
				icon_material_values.frame = texture_frame
				local description = ItemUtils.trait_description(trait_item, trait_rarity, trait_value)
				content.description = description
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end
		},
		gadget_trait = {
			size = {
				grid_width,
				54
			},
			pass_template = {
				{
					value = "content/ui/materials/icons/perks/perk_level_05",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						size = {
							20,
							20
						},
						offset = {
							42,
							0,
							0
						},
						color = Color.terminal_icon(255, true)
					}
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "text",
					style = gadget_trait_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local trait_item = element.trait_item
				local trait_value = element.trait_value or 0
				local trait_rarity = element.trait_rarity
				local description = ItemUtils.trait_description(trait_item, trait_rarity, trait_value)
				content.text = description
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end
		},
		description = {
			size = {
				grid_width,
				114
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local description = item.description
				local description_localized = description and Localize(description) or ""
				local description_height = get_style_text_height(description_localized, description_style, ui_renderer)
				local entry_height = math.max(0, description_height + 8)

				return {
					grid_width,
					entry_height
				}
			end,
			pass_template = {
				{
					value = "n/a",
					pass_type = "text",
					value_id = "description",
					style = description_style
				},
				{
					pass_type = "rect",
					style = {
						offset = {
							0,
							0,
							0
						},
						color = Color.terminal_frame(50, true)
					}
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local item = element.item
				local description = item.description
				local description_localized = description and Localize(description) or ""
				content.description = description_localized
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end
		},
		weapon_skin_requirements = {
			size = {
				grid_width,
				114
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = ItemUtils.weapon_skin_requirement_text(item)
				local text_height = get_style_text_height(text, weapon_skin_requirement_style, ui_renderer)
				local entry_height = math.max(0, text_height + 10)

				return {
					grid_width,
					entry_height
				}
			end,
			pass_template = {
				{
					value = "n/a",
					pass_type = "text",
					value_id = "description",
					style = weapon_skin_requirement_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local item = element.item
				local text = ItemUtils.weapon_skin_requirement_text(item)
				content.description = text
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end
		},
		weapon_skin_requirement_header = {
			size = {
				grid_width,
				36
			},
			size_function = function (parent, element, ui_renderer)
				local item = element.item
				local text = Localize("loc_item_equippable_on_header")
				local text_height = get_style_text_height(text, weapon_skin_requirement_header_style, ui_renderer)
				local entry_height = math.max(0, text_height + 10)
				weapon_skin_requirement_header_style.size[2] = entry_height

				return {
					grid_width,
					entry_height
				}
			end,
			pass_template = {
				{
					value = "n/a",
					pass_type = "text",
					value_id = "text",
					style = weapon_skin_requirement_header_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local item = element.item
				content.text = Localize("loc_item_equippable_on_header")
			end
		},
		weapon_attack_info = {
			size = {
				grid_width,
				32
			},
			pass_template = {
				{
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						size = {
							32,
							32
						},
						offset = {
							10,
							0,
							0
						},
						color = Color.ui_brown_light(255, true)
					}
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "text",
					style = weapon_attack_info_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local data = element.data
				local display_name = data.display_name
				content.text = Localize(display_name)
				local attack_type = data.type
				local icon = UISettings.weapon_action_type_icons[attack_type]

				if icon then
					content.icon = icon
				end
			end
		},
		weapon_attack_info_ranged = {
			size = {
				grid_width,
				42
			},
			pass_template = {
				{
					value = "content/ui/materials/icons/traits/empty",
					value_id = "icon",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						size = {
							32,
							32
						},
						offset = {
							10,
							0,
							0
						},
						color = Color.ui_brown_light(255, true)
					}
				},
				{
					value = "content/ui/materials/base/ui_default_base",
					value_id = "icon2",
					pass_type = "texture",
					style = {
						vertical_alignment = "center",
						size = {
							32,
							10
						},
						offset = {
							10,
							20,
							0
						},
						color = Color.ui_brown_light(255, true)
					}
				},
				{
					value = "n/a",
					pass_type = "text",
					value_id = "text",
					style = table.merge_recursive(table.clone(weapon_attack_info_style), {
						offset = {
							nil,
							4
						}
					})
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				content.element = element
				local data = element.data
				local attack_type = data.type
				local icon = UISettings.weapon_action_type_icons[attack_type] or "content/ui/materials/base/ui_default_base"

				if icon then
					content.icon = icon
				end

				local attack_fire_mode = data.fire_mode
				local icon2 = UISettings.weapon_fire_type_icons[attack_fire_mode]
				local fire_mode_prefix_key = UISettings.weapon_fire_type_display_text[attack_fire_mode]

				if icon2 then
					content.icon2 = icon2
				end

				local display_name = data.display_name
				local text = Localize(display_name)

				if fire_mode_prefix_key then
					text = text .. " • " .. Localize(fire_mode_prefix_key)
				end

				content.text = text
			end
		},
		weapon_attack_header = {
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
					style = weapon_attack_header_style
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				content.element = element
				local display_name = element.display_name
				content.text = Localize(display_name)
				local text_color = element.text_color
				style.text.text_color = text_color or style.text.text_color
			end
		},
		weapon_attack_chain = {
			size = {
				grid_width,
				50
			},
			pass_template = {
				{
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							0
						},
						color = Color.ui_brown_light(20, true),
						size_addition = {
							-20,
							-10
						}
					}
				},
				{
					style_id = "icon_bg",
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							5
						},
						color = Color.white(0, true),
						size = {
							102,
							22
						}
					}
				},
				{
					style_id = "icon_fg",
					pass_type = "rect",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							6
						},
						color = Color.black(0, true),
						size = {
							100,
							20
						}
					}
				},
				{
					style_id = "icon_name",
					value_id = "icon_name",
					pass_type = "text",
					value = "N/A",
					style = table.merge_recursive(table.clone(weapon_perk_style), {
						vertical_alignment = "center",
						text_vertical_alignment = "center",
						horizontal_alignment = "center",
						text_horizontal_alignment = "center",
						offset = {
							0,
							0,
							7
						},
						size = {
							1920,
							50
						},
						text_color = Color.terminal_text_body_dark(0, true)
					})
				},
				{
					style_id = "hotspot_icon_1",
					pass_type = "hotspot",
					content_id = "hotspot_icon_1",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0
						},
						size = {
							32,
							32
						}
					}
				},
				{
					value_id = "icon_1",
					style_id = "icon_1",
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							32,
							32
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.ui_brown_light(255, true)
					},
					visibility_function = function (content, style)
						return content.icon_1
					end
				},
				{
					style_id = "hotspot_icon_2",
					pass_type = "hotspot",
					content_id = "hotspot_icon_2",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0
						},
						size = {
							32,
							32
						}
					}
				},
				{
					value_id = "icon_2",
					style_id = "icon_2",
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							32,
							32
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.ui_brown_light(255, true)
					},
					visibility_function = function (content, style)
						return content.icon_2
					end
				},
				{
					style_id = "hotspot_icon_3",
					pass_type = "hotspot",
					content_id = "hotspot_icon_3",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0
						},
						size = {
							32,
							32
						}
					}
				},
				{
					value_id = "icon_3",
					style_id = "icon_3",
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							32,
							32
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.ui_brown_light(255, true)
					},
					visibility_function = function (content, style)
						return content.icon_3
					end
				},
				{
					style_id = "hotspot_icon_4",
					pass_type = "hotspot",
					content_id = "hotspot_icon_4",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0
						},
						size = {
							32,
							32
						}
					}
				},
				{
					value_id = "icon_4",
					style_id = "icon_4",
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							32,
							32
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.ui_brown_light(255, true)
					},
					visibility_function = function (content, style)
						return content.icon_4
					end
				},
				{
					style_id = "hotspot_icon_5",
					pass_type = "hotspot",
					content_id = "hotspot_icon_5",
					content = default_button_content,
					style = {
						vertical_alignment = "center",
						offset = {
							0,
							0,
							0
						},
						size = {
							32,
							32
						}
					}
				},
				{
					value_id = "icon_5",
					style_id = "icon_5",
					pass_type = "texture",
					value = "content/ui/materials/icons/traits/empty",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							32,
							32
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.ui_brown_light(255, true)
					},
					visibility_function = function (content, style)
						return content.icon_5
					end
				},
				{
					value_id = "spacing_icon_1",
					style_id = "spacing_icon_1",
					pass_type = "texture",
					value = "content/ui/materials/icons/generic/light_arrow",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							8,
							14
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.white(80, true)
					},
					visibility_function = function (content, style)
						return content.icon_2
					end
				},
				{
					value_id = "spacing_icon_2",
					style_id = "spacing_icon_2",
					pass_type = "texture",
					value = "content/ui/materials/icons/generic/light_arrow",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							8,
							14
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.white(80, true)
					},
					visibility_function = function (content, style)
						return content.icon_3
					end
				},
				{
					value_id = "spacing_icon_3",
					style_id = "spacing_icon_3",
					pass_type = "texture",
					value = "content/ui/materials/icons/generic/light_arrow",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							8,
							14
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.white(80, true)
					},
					visibility_function = function (content, style)
						return content.icon_4
					end
				},
				{
					value_id = "spacing_icon_4",
					style_id = "spacing_icon_4",
					pass_type = "texture",
					value = "content/ui/materials/icons/generic/light_arrow",
					style = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						size = {
							8,
							14
						},
						offset = {
							0,
							0,
							1
						},
						color = Color.white(80, true)
					},
					visibility_function = function (content, style)
						return content.icon_5
					end
				}
			},
			init = function (parent, widget, element, callback_name)
				local content = widget.content
				local style = widget.style
				content.element = element
				local attack_chain = element.attack_chain
				local num_attacks = #attack_chain
				local width_offset = 0
				local spacing = 50
				local icon_width = 32
				local spacing_icon_width = 8
				local start_width_offset = grid_width * 0.5 - ((num_attacks - 1) * spacing + num_attacks * icon_width) * 0.5

				for i = 1, 5 do
					local attack_type = attack_chain[i]
					local attack_icon = attack_type and UISettings.weapon_action_type_icons[attack_type]
					local hotspot_pass_id = "hotspot_icon_" .. i
					local pass_id = "icon_" .. i
					content[pass_id] = attack_icon

					if attack_icon then
						local pass_style = style[pass_id]
						local hotstpot_pass_style = style[hotspot_pass_id]
						pass_style.offset[1] = start_width_offset + width_offset
						hotstpot_pass_style.offset[1] = start_width_offset + width_offset
						width_offset = width_offset + icon_width + spacing

						if i < 5 then
							local spacing_pass_id = "spacing_icon_" .. i
							style[spacing_pass_id].offset[1] = pass_style.offset[1] + (icon_width * 2 + spacing) * 0.5 - spacing_icon_width * 0.5
						end
					end
				end
			end
		},
		dynamic_spacing = {
			size = {
				0,
				0
			},
			size_function = function (parent, config)
				return config.size
			end
		},
		spacing_vertical = {
			size = {
				grid_width,
				20
			}
		},
		spacing_vertical_small = {
			size = {
				grid_width,
				10
			}
		}
	}

	return blueprints
end

return generate_blueprints_function
