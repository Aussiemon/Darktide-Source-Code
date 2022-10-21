local ClassSelectionViewFontStyle = require("scripts/ui/views/class_selection_view/class_selection_view_font_style")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
end

local function _remove_live_item_icon_cb_func(widget)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 1
	material_values.render_target = nil
end

local class_selection_view_blueprints = {
	title = {
		pass_definitions = {
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
				ClassSelectionViewSettings.class_details_size[1],
				title_text_height
			}
		end
	},
	ability = {
		pass_definitions = {
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
						0
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
		init = function (parent, widget, element)
			widget.element = element
			local ability = element.ability

			if element.icon_size then
				widget.style.texture.size = element.icon_size
			end

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
			local title_width = ClassSelectionViewSettings.class_details_size[1] - title_style.offset[1]
			local description_width = ClassSelectionViewSettings.class_details_size[1] - description_style.offset[1]
			local _, title_text_height = UIRenderer.text_size(parent._offscreen_renderer, widget.content.title, title_style.font_type, title_style.font_size, {
				title_width,
				math.huge
			})
			local _, description_text_height = UIRenderer.text_size(parent._offscreen_renderer, widget.content.description, description_style.font_type, description_style.font_size, {
				description_width,
				math.huge
			})
			title_style.size = {
				title_width,
				title_text_height
			}
			description_style.size = {
				description_width,
				description_text_height
			}
			local total_text_size = title_text_height + description_text_height + description_style.offset[2]
			local total_height = math.max(widget.style.texture.size[2], total_text_size)
			local offset_text = (total_height - total_text_size) * 0.5
			local offset_icon = (total_height - widget.style.texture.size[2]) * 0.5
			title_style.offset[2] = title_style.offset[2] + offset_text
			description_style.offset[2] = description_style.offset[2] + title_style.size[2] + offset_text
			widget.style.texture.offset[2] = offset_icon
			widget.content.size = {
				ClassSelectionViewSettings.class_details_size[1],
				total_height
			}
		end,
		load_icon = function (self, widget, element)
			local ability = element.ability
			widget.style.texture.material_values.icon_texture = ability.large_icon or ability.icon
		end
	},
	weapon = {
		pass_definitions = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/frames/line_medium_inner_shadow",
				style_id = "texture",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					color = Color.black(255, true),
					size = {
						256,
						128
					},
					offset = {
						10,
						0,
						3
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
						10,
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
				style = ClassSelectionViewFontStyle.class_weapon_title
			}
		},
		init = function (parent, widget, element)
			widget.element = element
			widget.content.title = Localize(element.display_name)
			local title_style = widget.style.title
			local right_margin = 10
			local title_width = ClassSelectionViewSettings.class_details_size[1] - title_style.offset[1] - right_margin
			local total_height = UISettings.weapon_icon_size[2]
			title_style.size = {
				title_width,
				total_height
			}
			widget.content.size = {
				ClassSelectionViewSettings.class_details_size[1],
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
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	description = {
		pass_definitions = {
			{
				value_id = "description",
				pass_type = "text",
				style_id = "description",
				value = "",
				style = ClassSelectionViewFontStyle.class_description_style
			}
		},
		init = function (parent, widget, element)
			widget.element = element
			widget.content.description = element.text and Localize(element.text) or ""
			local description_style = widget.style.description
			local _, description_text_height = UIRenderer.text_size(parent._offscreen_renderer, widget.content.description, description_style.font_type, description_style.font_size, {
				ClassSelectionViewSettings.class_details_size[1],
				math.huge
			})
			widget.content.size = {
				ClassSelectionViewSettings.class_details_size[1],
				description_text_height
			}
		end
	},
	video = {
		pass_definitions = {
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
						0,
						0,
						1
					}
				}
			}
		},
		init = function (parent, widget, element)
			widget.element = element

			if element.video_path then
				local video_player_reference = parent.__class_name
				local ui_renderer = parent._offscreen_renderer

				UIRenderer.create_video_player(ui_renderer, video_player_reference, nil, element.video_path, true)

				widget.content.video_player_reference = video_player_reference
				widget.content.size = {
					ClassSelectionViewSettings.class_size[1],
					360
				}
			end
		end,
		destroy = function (parent, widget)
			local video_player_reference = parent.__class_name
			local ui_renderer = parent._offscreen_renderer

			if widget.content.video_player_reference == video_player_reference then
				UIRenderer.destroy_video_player(ui_renderer, video_player_reference)

				widget.content.video_player_reference = nil
			end
		end
	},
	description_short = {
		pass_definitions = {
			{
				value_id = "class_attributes",
				pass_type = "text",
				style_id = "class_attributes",
				value = "",
				style = ClassSelectionViewFontStyle.class_attributes_style
			}
		},
		init = function (parent, widget, element)
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
			local _, attributes_text_height = UIRenderer.text_size(parent._offscreen_renderer, widget.content.class_attributes, attributes_style.font_type, attributes_style.font_size, {
				ClassSelectionViewSettings.class_details_size[1],
				math.huge
			})
			widget.content.size = {
				ClassSelectionViewSettings.class_details_size[1],
				attributes_text_height
			}
		end
	}
}

return class_selection_view_blueprints
