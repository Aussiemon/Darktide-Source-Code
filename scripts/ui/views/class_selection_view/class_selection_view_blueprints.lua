-- chunkname: @scripts/ui/views/class_selection_view/class_selection_view_blueprints.lua

local ClassSelectionViewFontStyle = require("scripts/ui/views/class_selection_view/class_selection_view_font_style")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	if widget.content.visible then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 1
	material_values.render_target = nil
end

local function get_style_text_height(text, style, ui_renderer)
	local text_font_data = UIFonts.data_by_type(style.font_type)
	local text_font = text_font_data.path
	local text_size = style.size
	local text_options = UIFonts.get_font_options_by_style(style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, text_size, text_options)

	return text_height
end

local max_width = ClassSelectionViewSettings.class_details_size[1] - 5
local talent_blueprint_description_style = table.clone(UIFontSettings.body)

talent_blueprint_description_style.offset = {
	98,
	25,
	8
}
talent_blueprint_description_style.size = {
	max_width - 106,
	500
}
talent_blueprint_description_style.font_size = 20
talent_blueprint_description_style.text_horizontal_alignment = "left"
talent_blueprint_description_style.text_vertical_alignment = "top"
talent_blueprint_description_style.text_color = Color.terminal_text_body(255, true)

local talent_blueprint_title_style = table.clone(UIFontSettings.header_3)

talent_blueprint_title_style.offset = {
	98,
	0,
	8
}
talent_blueprint_title_style.size = {
	max_width - 106
}
talent_blueprint_title_style.font_size = 20
talent_blueprint_title_style.text_horizontal_alignment = "left"
talent_blueprint_title_style.text_vertical_alignment = "top"
talent_blueprint_title_style.text_color = Color.terminal_text_header(255, true)

local weapon_description_style = table.clone(UIFontSettings.body)

weapon_description_style.offset = {
	47,
	0,
	8
}
weapon_description_style.size = {
	222,
	0
}
weapon_description_style.font_size = 20
weapon_description_style.text_horizontal_alignment = "left"
weapon_description_style.text_vertical_alignment = "center"
weapon_description_style.text_color = Color.terminal_text_header(255, true)

local class_selection_view_blueprints = {
	talent_info = {
		size = {
			max_width,
			114
		},
		size_function = function (parent, element, ui_renderer)
			local description = element.description
			local description_height = get_style_text_height(description, talent_blueprint_description_style, ui_renderer)
			local entry_height = math.max(68, description_height + 25 + 5)

			return {
				max_width,
				entry_height
			}
		end,
		pass_template = {
			{
				value = "n/a",
				pass_type = "text",
				value_id = "display_name",
				style = talent_blueprint_title_style
			},
			{
				style_id = "description",
				value_id = "description",
				pass_type = "text",
				value = "n/a",
				style = talent_blueprint_description_style
			},
			{
				style_id = "icon",
				value_id = "icon",
				pass_type = "texture",
				value = "content/ui/materials/frames/talents/talent_icon_container",
				style = {
					size = {
						74,
						74
					},
					material_values = {
						intensity = 0,
						saturation = 1
					},
					offset = {
						16,
						-4,
						8
					}
				}
			},
			{
				style_id = "frame_default",
				pass_type = "texture",
				value = "content/ui/materials/frames/talents/circular_small_frame",
				style = {
					size = {
						74,
						74
					},
					offset = {
						16,
						-4,
						9
					},
					color = Color.white(255, true)
				},
				visibility_function = function (content, style)
					return not content.icon_texture
				end
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.element = element

			local description = element.description

			content.description = description

			local display_name = element.display_name
			local localized_title = Localize(display_name)

			content.display_name = localized_title

			local icon = element.icon
			local gradient_map = element.gradient_map
			local frame = element.frame
			local icon_mask = element.icon_mask
			local node_type = element.node_type

			if node_type == "stat" then
				content.icon = "content/ui/materials/frames/talents/circular_small_bg"
				style.icon.offset[2] = -14
				style.frame_default.offset[2] = -14
			else
				content.icon_texture = icon
				style.icon.material_values.icon_mask = icon_mask
				style.icon.material_values.icon = icon
				style.icon.material_values.frame = frame
				style.icon.material_values.gradient_map = gradient_map
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			return
		end
	},
	stat = {
		size = {
			max_width,
			114
		},
		size_function = function (parent, element, ui_renderer)
			local description = element.description
			local description_height = get_style_text_height(description, talent_blueprint_description_style, ui_renderer)
			local entry_height = math.max(68, description_height + 25)

			return {
				max_width,
				entry_height
			}
		end,
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_type = "proxima_nova_bold",
					font_size = 20,
					text_vertical_alignment = "top",
					text_horizontal_alignment = "left",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						98,
						0,
						8
					},
					size = {
						max_width - 106
					}
				}
			},
			{
				value = "•",
				pass_type = "text",
				style = {
					font_type = "proxima_nova_bold",
					font_size = 24,
					text_vertical_alignment = "top",
					text_horizontal_alignment = "left",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						72,
						-3,
						3
					}
				}
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local description = element.description

			content.element = element
			content.text = description

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	},
	header = {
		size = {
			max_width,
			100
		},
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_type = "proxima_nova_bold",
					font_size = 20,
					text_vertical_alignment = "center",
					text_horizontal_alignment = "left",
					text_color = Color.terminal_text_body_sub_header(255, true),
					offset = {
						27,
						0,
						3
					}
				}
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	},
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2]
			} or {
				225,
				20
			}
		end
	},
	title = {
		pass_template = {
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "",
				style = ClassSelectionViewFontStyle.class_abilities_group
			}
		},
		init = function (parent, widget, element)
			widget.element = element

			local text = element.text

			widget.content.text = text

			local title_style = widget.style.text
			local _, title_text_height = UIRenderer.text_size(parent._ui_renderer, text, title_style.font_type, title_style.font_size, {
				ClassSelectionViewSettings.class_details_size[1],
				math.huge
			})

			widget.content.size = {
				max_width,
				title_text_height
			}
		end
	},
	ability = {
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				style = {
					vertical_alignment = "top",
					size = {
						110,
						110
					},
					offset = {
						0,
						0,
						1
					},
					material_values = {}
				}
			},
			{
				value_id = "title",
				style_id = "title",
				pass_type = "text",
				value = "content/ui/materials/base/ui_default_base",
				style = ClassSelectionViewFontStyle.class_abilities_title
			},
			{
				value_id = "description",
				style_id = "description",
				pass_type = "text",
				value = "",
				style = ClassSelectionViewFontStyle.class_abilities_description
			}
		},
		init = function (parent, widget, element, _, _, ui_renderer)
			widget.content.element = element

			local ability = element.ability

			if element.icon_size then
				widget.style.texture.size = element.icon_size
			end

			widget.style.texture.offset[2] = widget.style.texture.offset[2] - widget.style.texture.size[2] * 0.15

			if element.ability_type == "combat_ability" then
				widget.content.texture = "content/ui/materials/icons/talents/combat_talent_icon_container"
			else
				widget.content.texture = "content/ui/materials/icons/talents/talent_icon_container"
				widget.style.texture.material_values.frame_texture = "content/ui/textures/icons/talents/menu/frame_active"
			end

			widget.content.title = Localize(ability.display_name)

			local format_values = ability.format_values
			local localized_description = Localize(ability.description, false, format_values)

			widget.content.description = localized_description

			local title_style = widget.style.title
			local description_style = widget.style.description
			local title_width = max_width - title_style.offset[1]
			local description_width = max_width - description_style.offset[1]
			local title_style_options = UIFonts.get_font_options_by_style(title_style)
			local description_style_options = UIFonts.get_font_options_by_style(description_style)
			local _, title_text_height = UIRenderer.text_size(ui_renderer, widget.content.title, title_style.font_type, title_style.font_size, {
				title_width,
				math.huge
			}, title_style_options)
			local _, description_text_height = UIRenderer.text_size(ui_renderer, widget.content.description, description_style.font_type, description_style.font_size, {
				description_width,
				math.huge
			}, description_style_options)

			title_style.size = {
				title_width,
				title_text_height
			}
			description_style.size = {
				description_width,
				description_text_height
			}
			description_style.offset[2] = description_style.offset[2] + title_style.size[2]

			local total_text_size = description_text_height + description_style.offset[2]
			local total_height = math.max(widget.style.texture.size[2], total_text_size)

			if total_height == total_text_size then
				local bottom_margin = 20

				total_height = total_height + bottom_margin
			end

			widget.content.size = {
				max_width,
				total_height
			}
		end,
		load_icon = function (self, widget, element)
			local ability = element.ability

			widget.style.texture.material_values.icon_texture = ability.large_icon or ability.icon
		end
	},
	weapon = {
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/frames/inner_shadow_medium",
				style_id = "texture",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					scale_to_material = true,
					color = Color.terminal_frame(255, true),
					size = {
						535,
						128
					},
					size_addition = {
						0,
						0
					},
					offset = {
						27,
						0,
						3
					}
				}
			},
			{
				value = "content/ui/materials/frames/frame_tile_2px",
				style_id = "frame",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "left",
					size_addition = {
						0,
						0
					},
					color = Color.terminal_frame(255, true),
					offset = {
						27,
						0,
						5
					},
					size = {
						535,
						128
					}
				}
			},
			{
				value_id = "icon",
				style_id = "icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/items/containers/item_container_landscape",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					material_values = {
						use_placeholder_texture = 1
					},
					offset = {
						296,
						0,
						2
					},
					size = {
						256,
						128
					},
					size_addition = {
						0,
						0
					}
				}
			},
			{
				value_id = "title",
				style_id = "title",
				pass_type = "text",
				value = "",
				style = weapon_description_style
			}
		},
		init = function (parent, widget, element)
			widget.content.element = element
			widget.content.title = Localize(element.display_name)

			local title_style = widget.style.title
			local right_margin = 10
			local title_width = max_width - title_style.offset[1] - right_margin
			local total_height = UISettings.weapon_icon_size[2]

			title_style.size = {
				title_width - UISettings.weapon_icon_size[1],
				total_height
			}
			widget.content.size = {
				max_width,
				total_height
			}
		end,
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local slot_name = element.item.slots[1]
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				local item_state_machine = item.state_machine
				local item_animation_event = item.animation_event
				local render_context = {
					camera_focus_slot_name = slot_name,
					state_machine = item_state_machine,
					animation_event = item_animation_event
				}

				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, dummy_profile)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	description = {
		pass_template = {
			{
				value_id = "description",
				pass_type = "text",
				style_id = "description",
				value = "",
				style = ClassSelectionViewFontStyle.class_description_style
			}
		},
		init = function (parent, widget, element, _, _, ui_renderer)
			widget.element = element
			widget.content.description = element.text and Localize(element.text) or ""

			local description_style = widget.style.description
			local _, description_text_height = UIRenderer.text_size(ui_renderer, widget.content.description, description_style.font_type, description_style.font_size, {
				max_width,
				math.huge
			})

			widget.content.size = {
				max_width,
				description_text_height
			}
		end
	},
	video = {
		pass_template = {
			{
				value = "content/videos/class_selection/class_selection",
				value_id = "video",
				pass_type = "video",
				style = {
					size = {
						ClassSelectionViewSettings.class_size[1],
						360
					},
					offset = {
						-20,
						0,
						1
					}
				}
			}
		},
		init = function (parent, widget, element, _, _, ui_renderer)
			widget.element = element

			if element.video_path then
				local video_player_reference = "class_selcetion_video_" .. math.uuid()

				UIRenderer.create_video_player(ui_renderer, video_player_reference, nil, element.video_path, true)

				widget.content.video_player_reference = video_player_reference
				widget.content.size = {
					ClassSelectionViewSettings.class_size[1],
					360
				}
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			if widget.content.video_player_reference then
				UIRenderer.destroy_video_player(ui_renderer, widget.content.video_player_reference)

				widget.content.video_player_reference = nil
			end
		end
	},
	description_short = {
		pass_template = {
			{
				value_id = "class_attributes",
				pass_type = "text",
				style_id = "class_attributes",
				value = "",
				style = ClassSelectionViewFontStyle.class_attributes_style
			}
		},
		init = function (parent, widget, element, _, _, ui_renderer)
			widget.element = element

			local attributes = ""

			if element.text then
				local localized_attributes = Localize(element.text)
				local attributes_list = string.split(localized_attributes, ",")

				for i = 1, #attributes_list do
					local attribute = attributes_list[i]

					attribute = attribute:match("^%s*(.-)%s*$")
					attributes = i == 1 and attribute or attributes .. " · " .. attribute
				end
			end

			widget.content.class_attributes = attributes

			local attributes_style = widget.style.class_attributes
			local _, attributes_text_height = UIRenderer.text_size(ui_renderer, widget.content.class_attributes, attributes_style.font_type, attributes_style.font_size, {
				max_width,
				math.huge
			})

			widget.content.size = {
				max_width,
				attributes_text_height
			}
		end
	}
}

return class_selection_view_blueprints
