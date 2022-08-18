local ClassSelectionViewFontStyle = require("scripts/ui/views/class_selection_view/class_selection_view_font_style")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local class_selection_view_blueprints = {}
class_selection_view_blueprints.title = {
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
		local text = element.text
		widget.content.text = text
		local title_style = widget.style.text
		local _, title_text_height = UIRenderer.text_size(parent._ui_renderer, text, title_style.font_type, title_style.font_size, {
			ClassSelectionViewSettings.class_details_size[1],
			0
		})
		widget.content.size = {
			ClassSelectionViewSettings.class_details_size[1],
			title_text_height
		}
		widget.style.text.size = {
			ClassSelectionViewSettings.class_details_size[1],
			title_text_height
		}
	end
}
class_selection_view_blueprints.ability = {
	pass_definitions = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "",
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
				}
			}
		},
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = "",
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
		local ability = element.ability

		if ability.player_ability and ability.player_ability.ability_type == "grenade_ability" then
			widget.content.texture = ability.hud_icon or "content/ui/materials/base/ui_default_base"
		else
			widget.content.texture = ability.large_icon or ability.icon or "content/ui/materials/base/ui_default_base"
		end

		if element.icon_size then
			widget.style.texture.size = element.icon_size
		end

		widget.content.title = Localize(ability.display_name)
		widget.content.description = Localize(ability.description)
		local title_style = widget.style.title
		local description_style = widget.style.description
		local title_width = ClassSelectionViewSettings.class_details_size[1] - title_style.offset[1]
		local description_width = ClassSelectionViewSettings.class_details_size[1] - description_style.offset[1]
		local _, title_text_height = UIRenderer.text_size(parent._offscreen_renderer, widget.content.title, title_style.font_type, title_style.font_size, {
			title_width,
			0
		})
		local _, description_text_height = UIRenderer.text_size(parent._offscreen_renderer, widget.content.description, description_style.font_type, description_style.font_size, {
			description_width,
			0
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
	end
}
class_selection_view_blueprints.weapon = {
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
					192,
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
			value = "content/ui/materials/icons/items/containers/item_container_landscape_no_rarity",
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
					192,
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
		widget.content.title = Localize(element.item.description)
		local title_style = widget.style.title
		local right_margin = 10
		local title_width = ClassSelectionViewSettings.class_details_size[1] - title_style.offset[1] - right_margin
		local total_height = ItemPassTemplates.item_size[2]
		title_style.size = {
			title_width,
			total_height
		}
		widget.content.size = {
			ClassSelectionViewSettings.class_details_size[1],
			total_height
		}
	end,
	load_icon = function (self, widget, element)
		local content = widget.content

		if not content.icon_load_id then
			local item = element.item
			local slot_name = element.slot

			local function cb(grid_index, rows, columns, render_target)
				local material_values = widget.style.icon.material_values
				material_values.use_placeholder_texture = 0
				material_values.rows = rows
				material_values.columns = columns
				material_values.grid_index = grid_index - 1
				material_values.texture_icon = render_target
			end

			local item_state_machine = item.state_machine
			local item_animation_event = item.animation_event
			local render_context = {
				camera_focus_slot_name = slot_name,
				state_machine = item_state_machine,
				animation_event = item_animation_event
			}
			content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
		end
	end
}

return class_selection_view_blueprints
