-- chunkname: @scripts/ui/view_elements/view_element_perks_item/view_element_perks_item_blueprints.lua

local Items = require("scripts/utilities/items")
local Colors = require("scripts/utilities/ui/colors")
local InputDevice = require("scripts/managers/input/input_device")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local amount_style = table.clone(UIFontSettings.body_small)

amount_style.text_color = Color.terminal_icon(nil, true)
amount_style.offset = {
	0,
	-1,
	3
}
amount_style.text_horizontal_alignment = "center"
amount_style.text_vertical_alignment = "bottom"

local unknown_style = table.clone(amount_style)

unknown_style.offset = {
	0,
	-5,
	3
}
unknown_style.font_size = 10
unknown_style.text_color[1] = 60

local ViewElementPerksItemBlueprints = {}

ViewElementPerksItemBlueprints.spacing_vertical_small = {
	size = {
		430,
		5
	}
}
ViewElementPerksItemBlueprints.spacing_vertical = {
	size = {
		430,
		20
	}
}

local weapon_perk_style = table.clone(UIFontSettings.body)

weapon_perk_style.offset = {
	45,
	0,
	10
}
weapon_perk_style.size_addition = {
	-105,
	0
}
weapon_perk_style.font_size = 18
weapon_perk_style.text_horizontal_alignment = "left"
weapon_perk_style.text_vertical_alignment = "center"
weapon_perk_style.text_color = {
	255,
	216,
	229,
	207
}
weapon_perk_style.default_color = {
	255,
	216,
	229,
	207
}
weapon_perk_style.hover_color = Color.white(255, true)
weapon_perk_style.disabled_color = {
	255,
	60,
	60,
	60
}

local function item_selection_button_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local disabled = hotspot.disabled
	local default_color = style.default_color
	local hover_color = style.hover_color
	local selected_color = style.selected_color
	local disabled_color = style.disabled_color
	local color

	if disabled and disabled_color then
		color = disabled_color
	elseif is_selected and selected_color then
		color = selected_color
	elseif is_hover and hover_color then
		color = hover_color
	elseif default_color then
		color = default_color
	end

	if color then
		Colors.color_copy(color, style.color)
	end
end

local function item_selection_button_hover_change_function(content, style)
	local hotspot = content.hotspot

	style.color[1] = 100 + math.max(hotspot.anim_hover_progress, content.hotspot.anim_select_progress) * 155
end

ViewElementPerksItemBlueprints.perk = {
	size = {
		390,
		48
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click
			},
			change_function = function (content, style, animations, dt)
				local parent_content = content.parent
				local perk_amount = parent_content.perk_amount or 0

				parent_content.hover_multiplier = perk_amount > 0 and 1 or 0.25

				local is_hover = content.is_hover

				if InputDevice.gamepad_active then
					local parent = parent_content.parent
					local selected_grid_widget = parent:selected_grid_widget()

					if selected_grid_widget then
						local selected_grid_widget_content = selected_grid_widget.content
						local selected_grid_widget_config = selected_grid_widget_content.config
						local selected_perk_item = selected_grid_widget_config.perk_item
						local selected_perk_id = selected_perk_item.name
						local my_config = content.parent.config
						local my_perk_item = my_config.perk_item
						local my_perk_id = my_perk_item.name

						is_hover = my_perk_id == selected_perk_id
					end
				end

				local lerp_direction = is_hover and 1 or -1

				content.parent.progress = math.clamp((content.parent.progress or 0) + dt * lerp_direction * 6, 0, 1)
			end
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(100, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/line_thin_dashed_animated",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					8
				},
				color = Color.terminal_corner_selected(nil, true),
				default_color = Color.terminal_corner_selected(0, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			visibility_function = function (content, style)
				return content.marked
			end
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					0
				},
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					2
				},
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true)
			},
			change_function = function (content, style)
				item_selection_button_change_function(content, style)
				item_selection_button_hover_change_function(content, style)
			end
		},
		{
			pass_type = "texture",
			style_id = "button_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					3
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "button_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					4
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			value = "content/ui/materials/icons/perks/perk_level_01",
			value_id = "rank",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				size = {
					20,
					20
				},
				offset = {
					14,
					0,
					10
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			value_id = "description",
			pass_type = "text",
			value = "n/a",
			style = weapon_perk_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = (hotspot.disabled or content.is_wasteful or content.is_locked) and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				Colors.color_lerp(default_color, hover_color, progress, text_color)
			end
		},
		{
			value_id = "expertise_cost",
			style_id = "expertise_cost",
			pass_type = "text",
			value = "",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				font_size = 18,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
				offset = {
					-20,
					0,
					6
				},
				text_color = Color.terminal_corner(255, true)
			}
		}
	},
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		local style = widget.style

		content.config = config
		content.parent = parent

		local perk_item = config.perk_item
		local perk_rarity = config.perk_rarity
		local content = widget.content

		content.description = Items.trait_description(perk_item, perk_rarity, 1)
		content.rank = Items.perk_textures(perk_item, perk_rarity)
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, config)
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content
		local ingredients = parent:ingredients()
		local selected_perk_ids = ingredients.perk_ids
		local config = content.config
		local perk_item = config.perk_item
		local content = widget.content
		local hotspot = content.hotspot
		local is_hover = hotspot.is_hover

		if InputDevice.gamepad_active then
			local parent = content.parent
			local selected_grid_widget = parent:selected_grid_widget()

			if selected_grid_widget then
				local selected_grid_widget_content = selected_grid_widget.content
				local selected_grid_widget_config = selected_grid_widget_content.config
				local selected_perk_item = selected_grid_widget_config.perk_item
				local selected_perk_id = selected_perk_item.name
				local my_config = content.config
				local my_perk_item = my_config.perk_item
				local my_perk_id = my_perk_item.name

				is_hover = my_perk_id == selected_perk_id
			end
		end

		if is_hover then
			parent:_on_perk_hover(content.config)
		end

		content.is_wasteful = false

		local item_perks = ingredients.item.perks

		for i = 1, #item_perks do
			local item_perk = item_perks[i]
			local selected_index = ingredients.existing_perk_index

			if i == selected_index and item_perk.id == perk_item.name and perk_item.rarity <= item_perk.rarity or i ~= selected_index and item_perk.id == perk_item.name then
				content.is_wasteful = true
			end
		end

		content.is_locked = parent._max_unlocked and perk_item.rarity > parent._max_unlocked
	end
}

return ViewElementPerksItemBlueprints
