﻿-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_player_assistance.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local ColorUtilities = require("scripts/utilities/ui/colors")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	100,
	100
}
local icon_size = {
	10,
	32
}
local background_size = {
	58,
	48
}
local frame_size = {
	66,
	54
}
local glow_size = {
	108,
	100
}
local indicator_size = {
	16,
	28
}
local icon_height_offset = -60

template.size = size
template.name = "player_assistance"
template.unit_node = "ui_interaction_marker"
template.position_offset = {
	0,
	0,
	0.3
}
template.using_smart_tag_system = false
template.max_distance = 200
template.screen_clamp = true
template.screen_margins = {
	down = 0.23148148148148148,
	up = 0.23148148148148148,
	left = 0.234375,
	right = 0.234375
}
template.scale_settings = {
	scale_to = 1,
	scale_from = 0.5,
	distance_max = 20,
	distance_min = 10
}

local function _show_warning_state(unit_data_extension)
	if not unit_data_extension then
		return false
	end

	local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
	local is_mutant_charged = PlayerUnitStatus.is_mutant_charged(disabled_character_state_component)
	local is_grabbed = PlayerUnitStatus.is_grabbed(disabled_character_state_component)

	return is_mutant_charged or is_grabbed
end

local chaos_daemonhost_action_data = BreedActions.chaos_daemonhost
local DAEMONHOST_EXECUTE_TIMING = chaos_daemonhost_action_data.warp_grab.execute_timing
local TIME_UNTIL_FALL_DOWN_FROM_HANG_LEDGE = PlayerCharacterConstants.time_until_fall_down_from_hang_ledge

local function _progress_bar_fraction(unit, unit_data_extension)
	local progress_bar_fraction = 1

	if not HEALTH_ALIVE[unit] then
		return progress_bar_fraction
	end

	local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
	local is_warp_grabbed = PlayerUnitStatus.is_warp_grabbed(disabled_character_state_component)

	if is_warp_grabbed then
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local game_session = Managers.state.game_session:game_session()
		local warp_grabbed_execution_time = GameSession.game_object_field(game_session, game_object_id, "warp_grabbed_execution_time")
		local t = Managers.time:time("gameplay")

		progress_bar_fraction = math.clamp((warp_grabbed_execution_time - t) / DAEMONHOST_EXECUTE_TIMING, 0, 1)

		return progress_bar_fraction
	end

	local character_state_component = unit_data_extension:read_component("character_state")
	local is_ledge_hanging = PlayerUnitStatus.is_ledge_hanging(character_state_component)

	if is_ledge_hanging then
		local ledge_hanging_character_state_component = unit_data_extension:read_component("ledge_hanging_character_state")
		local time_to_fall_down = ledge_hanging_character_state_component.time_to_fall_down
		local t = Managers.time:time("gameplay")

		progress_bar_fraction = math.clamp((time_to_fall_down - t) / TIME_UNTIL_FALL_DOWN_FROM_HANG_LEDGE, 0, 1)

		return progress_bar_fraction
	end

	local health_extension = ScriptUnit.extension(unit, "health_system")

	progress_bar_fraction = health_extension:current_health_percent()

	return progress_bar_fraction
end

local template_visual_definitions = {
	critical = {
		colors = {
			progress_bar = {
				230,
				164,
				26,
				26
			},
			glow = {
				255,
				236,
				50,
				50
			},
			frame = {
				255,
				236,
				50,
				50
			},
			indicator = {
				255,
				236,
				50,
				50
			}
		},
		textures = {}
	},
	warning = {
		template_settings_overrides = {
			position_offset = {
				0,
				0,
				0.8
			}
		},
		colors = {
			progress_bar = {
				230,
				189,
				118,
				38
			},
			glow = {
				255,
				236,
				165,
				50
			},
			frame = {
				255,
				236,
				165,
				50
			},
			indicator = {
				255,
				236,
				165,
				50
			}
		},
		textures = {}
	}
}

local function _setup_marker_by_visual_type(widget, marker, visual_type)
	local content = widget.content
	local style = widget.style
	local visual_definition = template_visual_definitions[visual_type]
	local default_color = visual_definition.colors
	local default_textures = visual_definition.textures
	local template_settings_overrides = visual_definition.template_settings_overrides

	if template_settings_overrides then
		local new_template = table.clone(marker.template)

		marker.template = table.merge_recursive(new_template, template_settings_overrides)
	end

	for style_id, pass_style in pairs(style) do
		local color = default_color[style_id]

		if color then
			ColorUtilities.color_copy(color, pass_style.color or pass_style.text_color)
		end
	end

	for content_id, value in pairs(default_textures) do
		content[content_id] = value ~= StrictNil and value or nil
	end

	marker.template.default_position_offset = marker.template.position_offset
end

template.create_widget_defintion = function (template, scenegraph_id)
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = Color.ui_hud_green_super_light(255, true)
	local size = template.size

	return UIWidget.create_definition({
		{
			style_id = "background",
			value_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/player_assistance/player_assistance_background",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = background_size,
				default_size = background_size,
				offset = {
					0,
					icon_height_offset,
					0
				},
				default_offset = {
					0,
					icon_height_offset,
					0
				},
				color = {
					230,
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.background ~= nil
			end
		},
		{
			value_id = "progress_bar",
			pass_type = "texture_uv",
			value = "content/ui/materials/hud/icons/player_assistance/player_assistance_background",
			style_id = "progress_bar",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				texture_size = background_size,
				size = background_size,
				default_size = background_size,
				offset = {
					0,
					icon_height_offset,
					1
				},
				default_offset = {
					0,
					icon_height_offset,
					1
				},
				color = {
					230,
					164,
					26,
					26
				}
			},
			visibility_function = function (content, style)
				return content.progress_bar_fraction ~= nil
			end,
			change_function = function (content, style)
				local progress_bar_fraction = content.progress_bar_fraction

				if progress_bar_fraction then
					local scale = content.scale or 1
					local texture_size = style.texture_size

					style.size[1] = texture_size[1]
					style.size[2] = texture_size[2] * progress_bar_fraction
					style.offset[2] = style.default_offset[2] * scale + (texture_size[2] - style.size[2]) * 0.5
					style.uvs[1][2] = 1 - progress_bar_fraction
				end
			end
		},
		{
			style_id = "glow",
			value_id = "glow",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/player_assistance/player_assistance_glow",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = glow_size,
				default_size = glow_size,
				offset = {
					0,
					icon_height_offset,
					2
				},
				default_offset = {
					0,
					icon_height_offset,
					2
				},
				color = {
					255,
					236,
					50,
					50
				}
			},
			visibility_function = function (content, style)
				return content.glow ~= nil
			end
		},
		{
			style_id = "frame",
			value_id = "frame",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/player_assistance/player_assistance_frame",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = frame_size,
				default_size = frame_size,
				offset = {
					0,
					icon_height_offset,
					3
				},
				default_offset = {
					0,
					icon_height_offset,
					3
				},
				color = {
					255,
					236,
					50,
					50
				}
			},
			visibility_function = function (content, style)
				return content.frame ~= nil
			end
		},
		{
			style_id = "icon",
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/player_assistance/player_assistance_icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = icon_size,
				default_size = icon_size,
				offset = {
					0,
					icon_height_offset + 2,
					4
				},
				default_offset = {
					0,
					icon_height_offset + 2,
					4
				},
				color = Color.ui_hud_green_super_light(255, true)
			},
			visibility_function = function (content, style)
				return content.icon ~= nil
			end
		},
		{
			style_id = "indicator",
			value_id = "indicator",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/player_assistance/player_assistance_arrow",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = indicator_size,
				default_size = indicator_size,
				offset = {
					0,
					-indicator_size[2] * 0.5,
					4
				},
				color = {
					255,
					236,
					50,
					50
				}
			},
			visibility_function = function (content, style)
				return not (content.distance >= 10) and not content.is_clamped
			end
		},
		{
			value_id = "arrow",
			pass_type = "rotated_texture",
			value = "content/ui/materials/hud/interactions/frames/direction",
			style_id = "arrow",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = size,
				offset = {
					0,
					icon_height_offset,
					1
				},
				color = Color.ui_hud_green_super_light(255, true)
			},
			visibility_function = function (content, style)
				return content.is_clamped
			end,
			change_function = function (content, style)
				style.angle = content.angle
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "MMM",
			style = {
				horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					40 + icon_height_offset,
					2
				},
				default_offset = {
					0,
					40 + icon_height_offset,
					2
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = {
					200,
					20
				}
			},
			visibility_function = function (content, style)
				return content.distance >= 10 or content.is_clamped
			end
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, template)
	local content = widget.content

	content.spawn_progress_timer = 0
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local animating = false
	local content = widget.content
	local style = widget.style
	local distance = content.distance
	local data = marker.data

	if data then
		data.distance = distance
	end

	local marker_unit = marker.unit
	local unit_data_extension = ScriptUnit.has_extension(marker_unit, "unit_data_system")
	local visual_type = _show_warning_state(unit_data_extension) and "warning" or "critical"

	if visual_type and marker.visual_type ~= visual_type then
		_setup_marker_by_visual_type(widget, marker, visual_type)

		marker.visual_type = visual_type
	end

	local progress_bar_fraction = _progress_bar_fraction(marker_unit, unit_data_extension)

	content.progress_bar_fraction = progress_bar_fraction

	local is_hovered = data.is_hovered
	local anim_hover_speed = 3

	if anim_hover_speed then
		local anim_hover_progress = content.anim_hover_progress or 0

		if is_hovered then
			anim_hover_progress = math.min(anim_hover_progress + dt * anim_hover_speed, 1)
		else
			anim_hover_progress = math.max(anim_hover_progress - dt * anim_hover_speed, 0)
		end

		content.anim_hover_progress = anim_hover_progress
	end

	local spawn_progress_timer = content.spawn_progress_timer

	if spawn_progress_timer then
		spawn_progress_timer = spawn_progress_timer + dt

		local duration = 1
		local progress = math.min(spawn_progress_timer / duration, 1)
		local anim_out_progress = math.ease_out_quad(progress)
		local anim_in_progress = math.ease_out_exp(progress)

		content.spawn_progress_timer = progress ~= 1 and spawn_progress_timer or nil
		style.icon.color[1] = 255 * anim_in_progress
		style.arrow.color[1] = 255 * anim_in_progress
		style.text.text_color[1] = 255 * anim_in_progress

		if anim_out_progress == 1 then
			content.spawn_progress_timer = nil
		end
	end

	local speed = 1 + (progress_bar_fraction < 0.25 and 2 or 0)
	local pulse_progress = Application.time_since_launch() * speed % 1
	local pulse_anim_progress = math.clamp((pulse_progress * 3 - 1)^2, 0, 1)
	local alpha_multiplier = 0.7 + pulse_anim_progress * 0.3

	widget.alpha_multiplier = alpha_multiplier

	local distance_text = tostring(math.floor(distance)) .. "m"

	content.text = distance > 1 and distance_text or ""
	data.distance_text = distance_text
	marker.ignore_scale = content.is_clamped
	content.is_hovered = is_hovered
	content.scale = content.is_clamped and 1 or marker.scale

	return animating
end

return template
