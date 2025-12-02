-- chunkname: @scripts/ui/hud/elements/player_compass/hud_element_player_compass.lua

local Definitions = require("scripts/ui/hud/elements/player_compass/hud_element_player_compass_definitions")
local HudElementPlayerCompassSettings = require("scripts/ui/hud/elements/player_compass/hud_element_player_compass_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local HudElementPlayerCompass = class("HudElementPlayerCompass", "HudElementBase")

HudElementPlayerCompass.init = function (self, parent, draw_layer, start_scale)
	HudElementPlayerCompass.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._registered_world_markers = false

	local my_player = parent:player()

	self._my_player = my_player

	local game_mode_manager = Managers.state.game_mode
	local hud_settings = game_mode_manager:hud_settings()

	self._player_composition_name = hud_settings.player_composition
	self._default_compass_icon_widget = self:_create_widget("default_compass_icon", Definitions.default_widget_icon_definition)
end

HudElementPlayerCompass._register_world_markers = function (self)
	self._registered_world_markers = true

	local cb = callback(self, "_cb_register_world_markers_list")

	Managers.event:trigger("request_world_markers_list", cb)
end

HudElementPlayerCompass._cb_register_world_markers_list = function (self, world_markers)
	self._world_markers_list = world_markers

	local active_presentation_data = self._active_presentation_data

	if active_presentation_data then
		local marker_id = active_presentation_data.marker_id

		for i = 1, #world_markers do
			local marker = world_markers[i]

			if marker.id == marker_id then
				active_presentation_data.marker = marker

				break
			end
		end
	end
end

HudElementPlayerCompass._find_party_nameplate_by_unit = function (self, unit)
	local world_markers_list = self._world_markers_list

	for i = 1, #world_markers_list do
		local marker = world_markers_list[i]
		local template = marker.template
		local template_name = template.name

		if template_name == "nameplate_party" and marker.unit == unit then
			return marker
		end
	end
end

local temp_team_players = {}
local temp_team_player_render_data = {}

HudElementPlayerCompass._get_party_icons = function (self, dt, t, ui_renderer)
	table.clear(temp_team_player_render_data)

	local player_manager = Managers.player
	local players = player_manager:players()

	for unique_id, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local marker = self:_find_party_nameplate_by_unit(player_unit)

			if marker then
				local widget = marker.widget
				local widget_content = widget.content
				local widget_style = widget.style
				local player_slot = player and player.slot and player:slot()
				local player_slot_colors = UISettings.player_slot_colors
				local player_slot_color = player_slot and player_slot_colors[player_slot]
				local angle = self:_get_marker_direction_angle(marker)

				temp_team_player_render_data[#temp_team_player_render_data + 1] = {
					font_size = 26,
					angle = angle,
					widget = self._default_compass_icon_widget,
					text = widget_content.icon_text,
					text_color = player_slot_color,
					size = {
						50,
						50,
					},
				}
			end
		end
	end

	return temp_team_player_render_data
end

local temp_marker_render_data = {}

HudElementPlayerCompass._get_world_icons_render_buffer = function (self, dt, t, ui_renderer)
	table.clear(temp_marker_render_data)

	local world_markers_list = self._world_markers_list

	for i = 1, #world_markers_list do
		local marker = world_markers_list[i]
		local distance = marker.distance

		if distance and distance < 10 then
			local widget = marker.widget
			local widget_content = widget.content
			local widget_style = widget.style
			local angle = self:_get_marker_direction_angle(marker)

			temp_marker_render_data[#temp_marker_render_data + 1] = {
				angle = angle,
				widget = self._default_compass_icon_widget,
				icon = widget_content.icon,
				text = widget_content.icon_text,
				text_color = widget_style.icon_text and widget_style.icon_text.text_color,
				icon_color = widget_style.icon and widget_style.icon.color,
			}
		end
	end

	return temp_marker_render_data
end

HudElementPlayerCompass.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerCompass.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if not self._registered_world_markers then
		self:_register_world_markers()
	end
end

HudElementPlayerCompass._get_camera_direction_angle = function (self)
	local camera = self._parent:player_camera()

	if not camera then
		return
	end

	local camera_rotation = Camera.local_rotation(camera)
	local camera_forward = Quaternion.forward(camera_rotation)

	camera_forward.z = 0
	camera_forward = Vector3.normalize(camera_forward)

	local camera_right = Vector3.cross(camera_forward, Vector3.up())
	local direction = Vector3.forward()
	local forward_dot_dir = Vector3.dot(camera_forward, direction)
	local right_dot_dir = Vector3.dot(camera_right, direction)
	local angle = math.atan2(right_dot_dir, forward_dot_dir)

	return angle
end

HudElementPlayerCompass._get_marker_direction_angle = function (self, marker)
	local marker_position = marker.position and marker.position:unbox()

	if marker_position then
		return self:_get_position_direction_angle(marker_position)
	end

	return 0
end

HudElementPlayerCompass._get_position_direction_angle = function (self, position)
	local camera = self._parent:player_camera()

	if not camera then
		return 0
	end

	local camera_position = ScriptCamera.position(camera)
	local diff_vector = position - camera_position

	diff_vector.z = 0
	diff_vector = Vector3.normalize(diff_vector)

	local diff_right = Vector3.cross(diff_vector, Vector3.up())
	local direction = Vector3.forward()
	local forward_dot_dir = Vector3.dot(diff_vector, direction)
	local right_dot_dir = Vector3.dot(diff_right, direction)
	local angle = -math.atan2(right_dot_dir, forward_dot_dir) % (math.pi * 2)

	return angle
end

local step_color_table = {}
local _empty_table = {}
local header_font_setting_name = "hud_body"
local header_font_settings = UIFontSettings[header_font_setting_name]
local _compass_text_options = {}

UIFonts.get_font_options_by_style(header_font_settings, _compass_text_options)

HudElementPlayerCompass._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	HudElementPlayerCompass.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local ui_scenegraph = self._ui_scenegraph
	local scale = ui_renderer.scale
	local inverse_scale = ui_renderer.inverse_scale
	local step_color = HudElementPlayerCompassSettings.step_color

	step_color_table[2] = step_color[2]
	step_color_table[3] = step_color[3]
	step_color_table[4] = step_color[4]

	local area_scenegraph = ui_scenegraph.area
	local area_size = area_scenegraph.size
	local area_position = area_scenegraph.world_position
	local draw_layer = area_position[3] + 1
	local num_steps = HudElementPlayerCompassSettings.steps
	local degrees = 360
	local degrees_per_step = degrees / num_steps
	local step_width = HudElementPlayerCompassSettings.step_width
	local size = Vector2(step_width, 20)
	local step_width_offset = -step_width * 0.5
	local visible_steps = HudElementPlayerCompassSettings.visible_steps
	local marker_spacing = area_size[1] / (visible_steps - 1)
	local total_length = marker_spacing * num_steps
	local player_direction_angle = self:_get_camera_direction_angle()
	local player_direction_degree = degrees - (0 + math.radians_to_degrees(player_direction_angle))
	local rotation_progress = player_direction_degree / degrees
	local start_offset = -total_length * rotation_progress
	local start_index = math.floor(math.abs(start_offset) / marker_spacing)

	start_offset = start_offset + area_size[1] * 0.5 + marker_spacing

	local step_height_small = HudElementPlayerCompassSettings.step_height_small
	local step_height_large = HudElementPlayerCompassSettings.step_height_large
	local font_type = HudElementPlayerCompassSettings.step_font_type
	local font_size_small = math.ceil(HudElementPlayerCompassSettings.font_size_small * scale)
	local font_size_big = math.ceil(HudElementPlayerCompassSettings.font_size_big * scale)
	local step_fade_start = HudElementPlayerCompassSettings.step_fade_start
	local area_middle_x = area_position[1] + area_size[1] * 0.5
	local position = Vector3(0, area_position[2], draw_layer)
	local degree_direction_abbreviations = HudElementPlayerCompassSettings.degree_direction_abbreviations

	for i = -visible_steps, visible_steps do
		local draw_index = start_index + i
		local read_index = (draw_index - 1) % num_steps + 1
		local local_x = start_offset + (draw_index - 1) * marker_spacing + area_position[1]

		if local_x + size[1] >= area_position[1] and local_x <= area_position[1] + area_size[1] then
			local distance_from_center = math.abs(local_x - area_middle_x)
			local distance_from_center_norm = distance_from_center / (area_size[1] * 0.5)
			local alpha_fraction = step_fade_start <= distance_from_center_norm and 1 - math.min((distance_from_center_norm - step_fade_start) / (1 - step_fade_start), 1) or 1
			local alpha = 255 * alpha_fraction

			step_color_table[1] = alpha

			local current_degree = read_index * degrees_per_step
			local degree_icon
			local degree_abbreviation = not degree_icon and degree_direction_abbreviations[current_degree]
			local font_size = degree_abbreviation and font_size_big or font_size_small

			size[2] = degree_abbreviation and step_height_large or step_height_small
			position[1] = local_x + step_width_offset
			position[2] = area_position[2]

			UIRenderer.draw_rect(ui_renderer, position, size, step_color_table)

			if read_index % 2 == 0 then
				local text = degree_abbreviation or tostring(current_degree)
				local text_width = UIRenderer.text_size(ui_renderer, text, font_type, font_size)

				position[2] = position[2] + size[2] + 5
				position[1] = local_x - text_width * inverse_scale * 0.5 - 1
				size[1] = text_width + 20

				UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, step_color_table, _compass_text_options)
			end

			size[1] = step_width

			local party_icons = self:_get_party_icons(dt, t, ui_renderer)

			if #party_icons > 0 then
				draw_layer = self:_draw_compass_icons(dt, t, ui_renderer, party_icons, local_x, current_degree, draw_layer)

				table.clear(party_icons)
			end
		end
	end
end

HudElementPlayerCompass._draw_compass_icons = function (self, dt, t, ui_renderer, icons_array, local_x_offset, current_degree, draw_layer)
	local ui_scenegraph = self._ui_scenegraph
	local area_scenegraph = ui_scenegraph.area
	local area_size = area_scenegraph.size
	local area_position = area_scenegraph.world_position
	local area_middle_x = area_position[1] + area_size[1] * 0.5
	local num_steps = HudElementPlayerCompassSettings.steps
	local degrees = 360
	local degrees_per_step = degrees / num_steps
	local visible_steps = HudElementPlayerCompassSettings.visible_steps
	local marker_spacing = area_size[1] / (visible_steps - 1)
	local step_fade_start = HudElementPlayerCompassSettings.step_fade_start

	for j = #icons_array, 1, -1 do
		local icon_data = icons_array[j]
		local marker_angle = icon_data.angle
		local marker_degrees = math.radians_to_degrees(marker_angle)

		current_degree = current_degree % degrees

		local degree_difference = marker_degrees - current_degree

		if degree_difference >= 0 and degree_difference <= degrees_per_step then
			local degree_difference_fraction = degree_difference / degrees_per_step
			local icon_x = local_x_offset + marker_spacing * degree_difference_fraction
			local icon_distance_from_center = math.abs(icon_x - area_middle_x)
			local icon_distance_from_center_norm = icon_distance_from_center / (area_size[1] * 0.5)
			local icon_alpha_fraction = step_fade_start <= icon_distance_from_center_norm and 1 - math.min((icon_distance_from_center_norm - step_fade_start) / (1 - step_fade_start), 1) or 1
			local icon_alpha = 255 * icon_alpha_fraction

			self:_draw_compass_icon(dt, t, ui_renderer, icon_data, icon_x, area_position[2], icon_alpha, draw_layer)

			draw_layer = draw_layer + 10
		end
	end

	return draw_layer
end

local temp_icon_color = Color.ui_hud_green_light(255, true)

HudElementPlayerCompass._draw_compass_icon = function (self, dt, t, ui_renderer, icon_data, x, y, alpha, draw_layer)
	local size = icon_data.size

	size = Vector2(size and size[1] or 50, size and size[2] or 50)

	local position = Vector3(x - size[1] * 0.5, y, draw_layer + 5)

	if icon_data.draw_background then
		local background_alpha_fraction = alpha / 255

		UIRenderer.draw_texture(ui_renderer, "content/ui/materials/masks/gradient_radial_invert", position, size, {
			150 * background_alpha_fraction,
			0,
			0,
			0,
		})

		position[3] = position[3] + 1
	end

	local widget = icon_data.widget
	local widget_content = widget.content
	local widget_style = widget.style
	local scale = ui_renderer.scale
	local text = icon_data.text

	if text then
		local text_style = widget_style.icon_text or widget_style.text
		local font_type = text_style.font_type
		local font_size = icon_data.font_size or text_style.font_size

		font_size = math.ceil(font_size * scale)

		local text_options = UIFonts.get_font_options_by_style(text_style)

		temp_icon_color[1] = alpha

		local text_color = icon_data.text_color

		if text_color then
			temp_icon_color[2] = text_color[2]
			temp_icon_color[3] = text_color[3]
			temp_icon_color[4] = text_color[4]
		end

		UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, temp_icon_color, text_options)
	end

	local icon = icon_data.icon

	if icon then
		temp_icon_color[1] = alpha

		local icon_color = icon_data.icon_color

		if icon_color then
			temp_icon_color[2] = icon_color[2]
			temp_icon_color[3] = icon_color[3]
			temp_icon_color[4] = icon_color[4]
		end

		UIRenderer.draw_texture(ui_renderer, icon, position, size, temp_icon_color)
	end
end

return HudElementPlayerCompass
