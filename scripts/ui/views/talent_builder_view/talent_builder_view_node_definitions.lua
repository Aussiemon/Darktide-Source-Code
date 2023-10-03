local ColorUtilities = require("scripts/utilities/ui/colors")
local UIWidget = require("scripts/managers/ui/ui_widget")

local function node_highligt_change_function(content, style, _, dt)
	local alpha_anim_progress = content.alpha_anim_progress or 0
	local alpha_fraction = nil

	if content.highlighted and content.has_points_spent then
		local alpha_speed = 2
		alpha_anim_progress = math.min(alpha_anim_progress + dt * alpha_speed, 1)
		local bounce_amount = 3.14
		local bounce_value = math.abs(math.sin(bounce_amount * (alpha_anim_progress + 1) * (alpha_anim_progress + 1)) * (1 - alpha_anim_progress))
		alpha_fraction = 1 - bounce_value
	else
		local alpha_speed = 8
		alpha_anim_progress = math.max(alpha_anim_progress - dt * alpha_speed, 0)
		alpha_fraction = alpha_anim_progress
	end

	content.alpha_anim_progress = alpha_anim_progress
	style.color[1] = 255 * alpha_fraction
end

local function node_icon_change_function(content, style, _, dt)
	local node_data = content.node_data

	if node_data then
		local material_values = style.material_values
		material_values.saturation = content.locked and 1 or 1
		local intensity_speed = 8

		if intensity_speed then
			local intensity_anim_progress = content.intensity_anim_progress or 0

			if content.has_points_spent or content.hotspot.is_hover or content.hotspot.is_selected then
				intensity_anim_progress = math.min(intensity_anim_progress + dt * intensity_speed, 1)
			else
				intensity_anim_progress = math.max(intensity_anim_progress - dt * intensity_speed, 0)
			end

			content.intensity_anim_progress = intensity_anim_progress
			local highlight_intensity_anim_progress = content.highlight_intensity_anim_progress or 0
			local highlight_intensity_speed = 0.8
			local highlight_intensity = 0

			if content.highlighted then
				highlight_intensity_anim_progress = math.min(highlight_intensity_anim_progress + dt * highlight_intensity_speed, 1)
				highlight_intensity = (1 - math.ease_out_quad(highlight_intensity_anim_progress)) * 0.5
			else
				highlight_intensity_anim_progress = 0
			end

			content.highlight_intensity_anim_progress = highlight_intensity_anim_progress

			if content.locked then
				material_values.intensity = -0.65 + highlight_intensity + 0.65 * intensity_anim_progress
			else
				local pulse_speed = 3.5
				local pulse_progress = 0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5
				local pulse_intensity = 0.2
				material_values.intensity = -0.25 + highlight_intensity + math.max(pulse_intensity * pulse_progress, 0.25 * intensity_anim_progress)
			end

			local frame_intensity = content.frame_intensity or 1
			local frame_intensity_speed = 3
			local max_frame_intensity = nil

			if not content.locked then
				if content.has_points_spent then
					max_frame_intensity = 1
				else
					max_frame_intensity = 1.5
				end
			else
				max_frame_intensity = 0.7
			end

			if frame_intensity > max_frame_intensity then
				frame_intensity = math.max(frame_intensity - dt * frame_intensity_speed, max_frame_intensity)
			else
				frame_intensity = math.min(frame_intensity + dt * frame_intensity_speed, max_frame_intensity)
			end

			content.frame_intensity = frame_intensity
			material_values.frame_intensity = frame_intensity
		end

		if not style.ignore_icon then
			local icon = node_data.icon

			if icon and icon ~= content.icon_texture then
				content.icon_texture = icon
				material_values.icon = icon
			end
		end
	end
end

return {
	node_definition = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/circular_frame",
					icon_mask = "content/ui/textures/frames/talents/circular_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/circular_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/circular_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/circular_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_ability = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/hex_frame",
					icon_mask = "content/ui/textures/frames/talents/hex_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/hex_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/talents/hex_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/hex_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/hex_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/hex_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/hex_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_ability_modifier = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/hex_frame",
					icon_mask = "content/ui/textures/frames/talents/hex_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/hex_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/talents/hex_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/hex_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/hex_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/hex_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/hex_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_stat = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/circular_small_bg",
			style_id = "icon",
			style = {
				ignore_icon = true,
				material_values = {
					intensity = -0.5,
					saturation = 1
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/circular_small_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					-24,
					-24
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/circular_small_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/circular_small_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/circular_small_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_keystone = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/circular_frame",
					icon_mask = "content/ui/textures/frames/talents/circular_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/circular_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/circular_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/circular_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_tactical = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/square_frame",
					icon_mask = "content/ui/textures/frames/talents/square_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/square_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/square_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/square_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/square_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/square_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_tactical_modifier = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/square_frame",
					icon_mask = "content/ui/textures/frames/talents/square_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/square_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/square_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/square_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/square_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/square_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_aura = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "chosen_effect",
			value = "content/ui/materials/frames/talents/effects/node_selection",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					151.2,
					240.79999999999998
				},
				offset = {
					0,
					0,
					0
				},
				color = Color.white(255, true),
				material_values = {
					progress = 1
				}
			},
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress

				if content.play_select_anim then
					content.play_select_anim = false
					progress = 0
				end

				if progress < 1 then
					local selection_anim_speed = 1
					progress = progress + dt * selection_anim_speed
					material_values.progress = math.min(progress, 1)
				end
			end
		},
		{
			pass_type = "hotspot",
			style_id = "hotspot",
			content_id = "hotspot",
			content = {
				hover_type = "circle"
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style_id = "icon",
			style = {
				material_values = {
					intensity = -0.5,
					saturation = 1,
					frame = "content/ui/textures/frames/talents/circular_frame",
					icon_mask = "content/ui/textures/frames/talents/circular_frame_mask"
				},
				offset = {
					0,
					0,
					1
				}
			},
			change_function = node_icon_change_function
		},
		{
			value = "content/ui/materials/frames/talents/circular_frame_glow",
			style_id = "frame_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-11
				},
				size_addition = {
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "frame_selected",
			value = "content/ui/materials/frames/talents/circular_filled",
			style = {
				offset = {
					0,
					0,
					5
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			change_function = node_highligt_change_function
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true)
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local hover_alpha = anim_progress * 255
				style.color[1] = hover_alpha
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked",
			value = "content/ui/materials/frames/talents/circular_blocked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					saturation = 1
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style, _, dt)
				local anim_block_speed = 5
				local anim_blocked_progress = content.anim_blocked_progress or 0

				if content.is_blocked then
					anim_blocked_progress = math.min(anim_blocked_progress + dt * anim_block_speed, 1)
				else
					anim_blocked_progress = math.max(anim_blocked_progress - dt * anim_block_speed, 0)
				end

				content.anim_blocked_progress = anim_blocked_progress
				style.color[1] = anim_blocked_progress * 255
			end
		},
		{
			pass_type = "texture",
			style_id = "blocked_highlight",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					246,
					69,
					69
				}
			},
			change_function = function (content, style)
				local draw_blocked_highlight = content.draw_blocked_highlight
				local block_speed = 5
				local block_anim_progress = 0.5 + math.sin(Application.time_since_launch() * block_speed) * 0.5
				local anim_blocked_progress = content.anim_blocked_progress or 0
				style.color[1] = draw_blocked_highlight and anim_blocked_progress * (155 + 100 * block_anim_progress) or 0
			end
		}
	}, "talent", nil, nil),
	node_definition_start = UIWidget.create_definition({
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/starting_points/starting_point_veteran",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					-104,
					2
				},
				size = {
					134,
					134
				},
				color = Color.white(255, true),
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						224,
						250,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						99,
						167,
						176
					})
				}
			}
		}
	}, "talent", nil, nil),
	node_connection_definition = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/talents/path_empty",
			style_id = "line_empty",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.white(255, true),
				angle = -math.pi / 4,
				pivot = {
					0,
					9
				},
				offset = {
					55,
					0,
					0
				},
				size = {
					60,
					18
				}
			}
		},
		{
			style_id = "line",
			pass_type = "rotated_texture",
			value = "content/ui/materials/frames/talents/path_filled",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.white(255, true),
				angle = -math.pi / 4,
				pivot = {
					0,
					9
				},
				offset = {
					55,
					0,
					2
				},
				size = {
					60,
					18
				},
				material_values = {
					fill_color = ColorUtilities.format_color_to_material({
						255,
						234,
						255,
						255
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						73,
						161,
						242
					})
				}
			},
			visibility_function = function (content, style)
				return content.has_progressed or content.progressing
			end
		},
		{
			pass_type = "rotated_texture",
			value = "content/ui/materials/frames/talents/path_filled_available",
			style_id = "line_available",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.white(255, true),
				angle = -math.pi / 4,
				pivot = {
					0,
					6
				},
				offset = {
					55,
					0,
					2
				},
				size = {
					60,
					12
				},
				material_values = {
					effect_amount = 1,
					effect_speed = -0.8,
					fill_color = ColorUtilities.format_color_to_material({
						255,
						42,
						91,
						137
					}),
					blur_color = ColorUtilities.format_color_to_material({
						255,
						33,
						62,
						89
					})
				}
			},
			visibility_function = function (content)
				return content.can_progress or content.progressing
			end,
			change_function = function (content, style, _, dt)
				local material_values = style.material_values
				local progress = material_values.progress
			end
		}
	}, "talent")
}
