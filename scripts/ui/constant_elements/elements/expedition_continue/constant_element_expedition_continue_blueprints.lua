-- chunkname: @scripts/ui/constant_elements/elements/expedition_continue/constant_element_expedition_continue_blueprints.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local card_size = {
	450,
	335,
}

local function bottom_particle_change_function(content, style, animations, dt)
	local material_values = style.material_values
	local progress = material_values.progress
	local progress_speed = material_values.progress_speed or 0.7
	local new_progress = (progress + dt * progress_speed) % 1

	if new_progress < progress then
		material_values.rotation = math.random_range(0, 0.5)
		material_values.intensity = math.random_range(0, 1)
		material_values.progress_speed = math.random_range(0.25, 1)
	end

	material_values.progress = new_progress
end

local function top_particle_change_function(content, style, animations, dt)
	local material_values = style.material_values
	local progress = material_values.progress
	local progress_speed = material_values.progress_speed or 0.7
	local new_progress = (progress + dt * progress_speed) % 1

	if new_progress < progress then
		material_values.rotation = math.random_range(0.5, 1)
		material_values.intensity = math.random_range(0, 1)
		material_values.progress_speed = math.random_range(0.25, 1)
	end

	material_values.progress = new_progress
end

local blueprints = {}

blueprints.option_card = {
	size = card_size,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_released_sound = nil,
				on_hover_sound = UISoundEvents.expedition_menu_select,
				on_pressed_sound = UISoundEvents.default_select,
			},
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "",
			value_id = "title",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					70,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "sub_title",
			value = "",
			value_id = "sub_title",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					20,
					100,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					20,
					140,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "vote_count",
			value = "",
			value_id = "vote_count",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					-70,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				scale_to_material = true,
				color = Color.terminal_grid_background(nil, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_upper",
			style = {
				vertical_alignment = "top",
				size = {
					470,
					37,
				},
				offset = {
					-10,
					-5,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			style = {
				vertical_alignment = "bottom",
				size = {
					470,
					37,
				},
				offset = {
					-10,
					5,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "glow",
			value = "content/ui/materials/effects/item_aquisition/glow_rarity_01",
			value_id = "glow",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return is_selected or is_focused or is_hover
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_1",
			value = "content/ui/materials/effects/item_aquisition/particles_rarity_01",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = bottom_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_2",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = bottom_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_3",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = bottom_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_4",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = bottom_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_5",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = top_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_6",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = top_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_7",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = top_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "particle_8",
			value_id = "particle",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					340,
					350,
				},
				material_values = {
					intensity = 0,
					progress = 1,
				},
			},
			change_function = top_particle_change_function,
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover

				return not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
	},
	init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		local style = widget.style

		content.element = element

		if element.icon then
			content.icon.amterial_values.icon = element.icon
		end

		content.title = element.title or content.title
		content.sub_title = element.sub_title or content.sub_title
		content.description = element.description or content.description
		content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
	end,
	update = function (parent, widget, voting_id, ui_renderer)
		local content = widget.content
		local element = content.element
		local vote_value = element.vote_value
		local voting_manager = Managers.voting
		local votes = voting_manager:votes(voting_id)
		local num_option_votes = 0
		local num_total_votes = 0

		for _, option in pairs(votes) do
			if option == vote_value then
				num_option_votes = num_option_votes + 1
			end

			num_total_votes = num_total_votes + 1
		end

		local vote_count = num_option_votes or 0

		content.vote_count = tostring(vote_count) .. "/" .. tostring(num_total_votes)
	end,
}

return blueprints
