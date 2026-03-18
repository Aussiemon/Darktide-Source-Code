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
local Auspex = require("scripts/utilities/weapon/auspex")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

local function get_alpha_progress(position_x, area_width)
	local progress = math.ilerp(0, area_width, position_x)

	return 255 * math.smoothstep(progress, 1, 0.8) * math.smoothstep(progress, 0, 0.2)
end

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
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._hud_objectives = {}
	self._hud_objectives_by_id = {}
	self._marked_animations = {}
end

HudElementPlayerCompass._register_world_markers = function (self)
	self._registered_world_markers = true

	local cb = callback(self, "_cb_register_world_markers_list")

	Managers.event:trigger("request_world_markers_list", cb)
end

HudElementPlayerCompass._cb_register_world_markers_list = function (self, world_markers)
	self._world_markers_list = world_markers
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
					angle = math.radians_to_degrees(angle),
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
				angle = math.radians_to_degrees(angle),
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

local temp_expedition_oppertunity_marker_render_data = {}

HudElementPlayerCompass._get_expedition_navigation_icons = function (self, dt, t, ui_renderer)
	local navigation_handler = self._navigation_handler
	local objectives_handler = self._objectives_handler
	local collectibles_handler = self._collectibles_handler
	local level_indices = {}
	local get_registered_opportunities = self._navigation_handler:get_registered_opportunities()
	local location_id = 1

	for id, position_box in pairs(get_registered_opportunities) do
		if position_box then
			if not self._navigation_handler:is_level_completed(id) then
				level_indices[#level_indices + 1] = {
					icon_type = "opportunity",
					text = "",
					position = position_box:unbox(),
					icon = string.format("content/ui/materials/backgrounds/scanner/scanner_map_greek_%02d", 1 + id % 24),
					title_icon = string.format("content/ui/materials/backgrounds/scanner/scanner_map_%d", location_id % 9),
					size = {
						20,
						20,
					},
					marked_by_player_slot = self._navigation_handler:player_slot_by_level_marked(id),
					opportunity_id = id,
				}
			end

			location_id = location_id + 1
		end
	end

	if DevParameters and not DevParameters.ui_hide_unselected_expedition_exits or not DevParameters then
		local exits = self._navigation_handler:get_registered_exits()

		for id, position_box in pairs(exits) do
			if position_box then
				level_indices[#level_indices + 1] = {
					icon = "content/ui/materials/backgrounds/scanner/scanner_map_exit",
					icon_type = "exit",
					text = "",
					position = position_box:unbox(),
					size = {
						20,
						20,
					},
					marked_by_player_slot = self._navigation_handler:player_slot_by_level_marked(id),
				}
			end
		end
	end

	if DevParameters and not DevParameters.ui_hide_unselected_expedition_extractions or not DevParameters then
		local extractions = self._navigation_handler:get_registered_extractions()

		for id, position_box in pairs(extractions) do
			if position_box then
				level_indices[#level_indices + 1] = {
					icon = "content/ui/materials/backgrounds/scanner/scanner_map_extract",
					icon_type = "extraction",
					text = "",
					position = position_box:unbox(),
					size = {
						20,
						20,
					},
					marked_by_player_slot = self._navigation_handler:player_slot_by_level_marked(id),
				}
			end
		end
	end

	table.clear(temp_expedition_oppertunity_marker_render_data)

	local party_icons = self:_get_party_icons(dt, t, ui_renderer)

	table.append(temp_expedition_oppertunity_marker_render_data, party_icons)

	local icon_color = {
		255,
		114,
		247,
		119,
	}
	local visible_marked_animation = {}

	for index, icon_data in ipairs(level_indices) do
		local position = icon_data.position
		local icon = icon_data.icon
		local title_icon = icon_data.title_icon
		local text = icon_data.text
		local size = icon_data.size
		local opportunity_id = icon_data.opportunity_id
		local icon_type = icon_data.icon_type
		local angle = self:_get_position_direction_angle(position)
		local marked_by_player_slot = icon_data.marked_by_player_slot
		local at_opportunity = opportunity_id and self._hud_objectives_by_id[opportunity_id]
		local is_marked = not not marked_by_player_slot
		local distance = self:_get_distance_to_objective(position)

		if distance <= 100 then
			local size_lerp = math.ilerp(100, 25, distance)

			size[1] = math.lerp(size[1], size[1] * 1.5, size_lerp)
			size[2] = math.lerp(size[2], size[2] * 1.5, size_lerp)
		end

		local is_icon_shown = icon_type ~= "opportunity" or icon_type == "opportunity" and (at_opportunity or is_marked)
		local should_icon_animate = is_marked and not at_opportunity

		if should_icon_animate then
			visible_marked_animation[index] = true
		end

		if is_icon_shown then
			temp_expedition_oppertunity_marker_render_data[#temp_expedition_oppertunity_marker_render_data + 1] = {
				angle = math.radians_to_degrees(angle),
				widget = self._default_compass_icon_widget,
				text = text,
				text_color = marked_by_player_slot and Color["player_slot_" .. marked_by_player_slot](255, true) or icon_color,
				icon_color = marked_by_player_slot and Color["player_slot_" .. marked_by_player_slot](255, true) or icon_color,
				icon = icon,
				title_icon = title_icon,
				size = size,
				at_opportunity = at_opportunity,
				marked = is_marked,
				level_index = index,
			}
		end
	end

	for index in pairs(self._marked_animations) do
		if not visible_marked_animation[index] then
			self._marked_animations[index] = nil
		end
	end

	for index in pairs(visible_marked_animation) do
		self._marked_animations[index] = self._marked_animations[index] or {
			timer = 0,
		}
	end

	table.sort(temp_expedition_oppertunity_marker_render_data, function (a, b)
		return not a.marked and b.marked
	end)

	return temp_expedition_oppertunity_marker_render_data
end

HudElementPlayerCompass._show_element = function (self, dt, t, ui_renderer, render_settings, input_service)
	local show = true
	local navigation_handler = self._navigation_handler

	if navigation_handler and navigation_handler.is_active then
		show = navigation_handler:is_active()
	end

	self._alpha_multiplier = show and 1 or 0

	return show
end

HudElementPlayerCompass.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerCompass.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local navigation_handler = self._navigation_handler
	local objectives_handler = self._objectives_handler

	if not navigation_handler or not objectives_handler then
		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()

		if game_mode.get_navigation_handler then
			navigation_handler = game_mode:get_navigation_handler()
			objectives_handler = game_mode:get_objectives_handler()
			self._minigame = navigation_handler:minigame()
			self._navigation_handler = navigation_handler
			self._objectives_handler = objectives_handler
		end
	end

	local collectibles_handler = self._collectibles_handler

	if not collectibles_handler then
		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()

		if game_mode.get_collectibles_handler then
			collectibles_handler = game_mode:get_collectibles_handler()
			self._collectibles_handler = collectibles_handler
		end
	end

	self._show_compass = self:_show_element()

	if not self._show_compass then
		return
	end

	if not self._registered_world_markers then
		self:_register_world_markers()
	end

	local hud_objectives = self._hud_objectives
	local hud_objectives_by_id = self._hud_objectives_by_id

	for objective, group_id in pairs(hud_objectives) do
		local should_show = objective and not objective.__deleted and objective:use_hud()

		if not should_show then
			hud_objectives[objective] = nil
			hud_objectives_by_id[group_id] = nil
		end
	end

	local active_objectives = self._mission_objective_system:active_objectives()

	for objective, objective_data in pairs(active_objectives) do
		local hud_objective_exists = hud_objectives[objective] ~= nil

		if not hud_objective_exists and objective:use_hud() and self._objectives_handler then
			local group_id = objective:group_id()
			local level_data = self._objectives_handler:level_data_by_level_id(group_id)

			if level_data then
				hud_objectives[objective] = group_id
				hud_objectives_by_id[group_id] = true
			end
		end
	end
end

HudElementPlayerCompass.is_auspex_in_focus = function (self)
	local player = Managers.player:local_player(1)

	return Auspex.in_focus(player.player_unit)
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
	local angle = math.atan2(right_dot_dir, forward_dot_dir) % (math.pi * 2)

	return angle
end

HudElementPlayerCompass._get_distance_to_objective = function (self, position)
	local camera = self._parent:player_camera()

	if not camera then
		return 0
	end

	local camera_position = ScriptCamera.position(camera)
	local diff_vector = position - camera_position
	local distance = math.sqrt(math.pow(diff_vector.x, 2) + math.pow(diff_vector.y, 2) + math.pow(diff_vector.z, 2))

	return distance
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
local header_font_setting_name = "hud_body"
local header_font_settings = UIFontSettings[header_font_setting_name]

header_font_settings.text_horizontal_alignment = "center"

local _compass_text_options = {}

UIFonts.get_font_options_by_style(header_font_settings, _compass_text_options)

HudElementPlayerCompass.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._show_compass then
		HudElementPlayerCompass.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	end
end

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
	local degrees = 360
	local step_width = HudElementPlayerCompassSettings.step_width
	local size = Vector2(step_width, 20)
	local player_direction_angle = self:_get_camera_direction_angle()
	local player_direction_degree = math.radians_to_degrees(player_direction_angle)
	local rotation_progress = player_direction_degree / degrees
	local font_type = HudElementPlayerCompassSettings.step_font_type
	local font_size_small = math.ceil(HudElementPlayerCompassSettings.font_size_small * scale)
	local font_size_big = math.ceil(HudElementPlayerCompassSettings.font_size_big * scale)
	local position = Vector3(0, 0, draw_layer)
	local degree_direction_abbreviations = HudElementPlayerCompassSettings.degree_direction_abbreviations
	local steps = 12
	local INVERT_ROTATION = true
	local visible_steps = steps * 0.5
	local inverse_animation_scale = steps
	local index_value = visible_steps * 0.5
	local visible_size = area_size[1]
	local center_x = visible_size * 0.5
	local degrees_per_step = 360 / steps
	local offset_per_step = visible_size / visible_steps
	local px_per_degree = visible_size / (visible_steps * degrees_per_step)
	local effective_rot = player_direction_degree

	if INVERT_ROTATION then
		effective_rot = -player_direction_degree
	end

	local anchor_index = math.floor(effective_rot / degrees_per_step + 0.5)
	local half_steps = visible_steps

	for i = -index_value, index_value do
		local current_index = anchor_index + i
		local linear_angle = current_index * degrees_per_step
		local angle_diff = linear_angle - effective_rot
		local local_x = center_x + angle_diff * px_per_degree
		local wrapped_index = (current_index % steps + steps) % steps
		local current_degree = wrapped_index * degrees_per_step

		if local_x >= 0 and local_x <= visible_size then
			local degree_abbreviation = degree_direction_abbreviations[current_degree]
			local text = degree_abbreviation or string.format("%d°", current_degree)
			local font_size = font_size_small * inverse_scale
			local text_width, text_height = UIRenderer.text_size(ui_renderer, text, font_type, font_size)

			position[1] = area_position[1] + local_x - offset_per_step * 0.5
			position[2] = area_position[2] + (area_size[2] - text_height) * 0.5
			size[1] = offset_per_step
			size[2] = text_height

			local alpha = get_alpha_progress(local_x, area_size[1])

			step_color_table[1] = alpha

			local icon_data = {
				angle = current_degree,
				widget = self._default_compass_icon_widget,
				text = text,
				font_size = font_size,
				text_color = step_color_table,
				size = size,
			}

			draw_layer = self:_draw_compass_icon(dt, t, ui_renderer, icon_data, position[1], position[2], alpha, draw_layer)
		end
	end

	local player_at_opportunity = false

	local function prepare_and_draw_icons(icons)
		for i = 1, #icons do
			local icon_data = icons[i]
			local angle = icon_data.angle
			local size = icon_data.size
			local at_opportunity = icon_data.at_opportunity
			local marked = icon_data.marked
			local icon_x, icon_y, alpha
			local raw_diff = angle - effective_rot
			local angle_diff = (raw_diff + 540) % 360 - 180
			local local_x = center_x + angle_diff * px_per_degree
			local icon_visible = false

			if marked then
				local_x = math.clamp(local_x, 0, area_size[1])
			end

			if not at_opportunity then
				if local_x >= 0 and local_x <= visible_size then
					icon_x = area_position[1] + local_x
					icon_y = area_position[2] + area_size[2] * 0.5
					alpha = marked and 255 or get_alpha_progress(local_x, area_size[1])
					icon_visible = true
				end
			else
				if not player_at_opportunity then
					player_at_opportunity = true
				end

				icon_x = area_position[1] + 0.5 * area_size[1]
				icon_y = area_position[2]
				alpha = 255
				icon_visible = true
			end

			if icon_visible then
				position[1] = icon_x - size[1] * 0.5
				position[2] = icon_y - size[2] * 0.5
				draw_layer = self:_draw_compass_icon(dt, t, ui_renderer, icon_data, position[1], position[2], alpha, draw_layer)
			end
		end
	end

	local expedition_navigation_icons = self:_get_expedition_navigation_icons(dt, t, ui_renderer)

	prepare_and_draw_icons(expedition_navigation_icons)

	local zoom_multiplier = steps / visible_steps
	local background_progress = 1 - player_direction_degree / degrees * zoom_multiplier
	local uv_tiling = 4 / zoom_multiplier

	self._widgets_by_name.navigation_lines.style.lines.material_values.uv_offset = background_progress
	self._widgets_by_name.navigation_lines.style.lines.material_values.uv_tiling = uv_tiling
	self._widgets_by_name.background.style.compass_background.material_values.state = self:is_auspex_in_focus() and 1 or 0
	self._widgets_by_name.background.style.compass_aquila.material_values.state = self:is_auspex_in_focus() and not player_at_opportunity and 1 or 0
end

local temp_icon_color = Color.ui_hud_green_light(255, true)
local temp_size = {
	0,
	0,
}
local temp_text_options = {}
local temp_position = {}

HudElementPlayerCompass._draw_compass_icon = function (self, dt, t, ui_renderer, icon_data, x, y, alpha, draw_layer)
	local size = icon_data.size

	size = Vector2(size and size[1] or 25, size and size[2] or 25)

	local position = Vector3(x, y, draw_layer)

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
	local animation_timer = self._marked_animations[icon_data.level_index] and self._marked_animations[icon_data.level_index].timer
	local animation_duration = 1
	local marked = icon_data.marked
	local marked_texture = widget_content.frame
	local at_opportunity = icon_data.at_opportunity
	local should_trigger_sound = false

	if animation_timer and animation_timer < animation_duration then
		if animation_timer == 0 then
			should_trigger_sound = true
		end

		local animation_current_time = math.min(animation_timer + dt, animation_duration)

		self._marked_animations[icon_data.level_index].timer = animation_current_time

		local progress = math.min(animation_current_time / animation_duration, 1)
		local anim_out_progress = math.ease_out_quad(progress)
		local anim_in_progress = math.ease_out_exp(progress)
		local anim_ease_in_progress = math.easeOutCubic(progress)
		local text = icon_data.text

		if text then
			table.clear(temp_text_options)

			local text_style = widget_style.icon_text or widget_style.text
			local font_type = text_style.font_type
			local font_size = icon_data.font_size or text_style.font_size

			font_size = math.ceil(font_size * scale)

			UIFonts.get_font_options_by_style(text_style, temp_text_options)

			temp_text_options.shadow = nil

			local icon_color = icon_data.text_color

			if icon_color then
				temp_icon_color[1] = alpha - alpha * anim_out_progress
				temp_icon_color[2] = icon_color[2]
				temp_icon_color[3] = icon_color[3]
				temp_icon_color[4] = icon_color[4]
			end

			local temp_font_size = font_size + font_size * anim_out_progress

			UIRenderer.draw_text(ui_renderer, text, temp_font_size, font_type, position, size, temp_icon_color, temp_text_options)

			if icon_color then
				temp_icon_color[1] = alpha - alpha * anim_in_progress
			end

			temp_font_size = font_size + font_size * anim_in_progress

			UIRenderer.draw_text(ui_renderer, text, temp_font_size, font_type, position, size, temp_icon_color, temp_text_options)

			if icon_color then
				temp_icon_color[1] = alpha * 0.7 + alpha * 0.3 * anim_ease_in_progress
			end

			temp_font_size = font_size * 0.7 + font_size * 0.3 * anim_ease_in_progress

			UIRenderer.draw_text(ui_renderer, text, temp_font_size, font_type, position, size, temp_icon_color, temp_text_options)
		end

		local icon = icon_data.icon

		if icon then
			local icon_color = icon_data.icon_color

			if icon_color then
				temp_icon_color[1] = alpha - alpha * anim_out_progress
				temp_icon_color[2] = icon_color[2]
				temp_icon_color[3] = icon_color[3]
				temp_icon_color[4] = icon_color[4]
			end

			temp_size[1] = size[1] + size[1] * anim_out_progress
			temp_size[2] = size[2] + size[2] * anim_out_progress
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3]

			UIRenderer.draw_texture(ui_renderer, icon, temp_position, temp_size, temp_icon_color)

			if icon_color then
				temp_icon_color[1] = alpha - alpha * anim_in_progress
			end

			temp_size[1] = size[1] + size[1] * anim_in_progress
			temp_size[2] = size[2] + size[2] * anim_in_progress
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3] + 1

			UIRenderer.draw_texture(ui_renderer, icon, temp_position, temp_size, temp_icon_color)

			if icon_color then
				temp_icon_color[1] = alpha * 0.7 + alpha * 0.3 * anim_ease_in_progress
			end

			temp_size[1] = size[1] * 0.7 + size[1] * 0.3 * anim_ease_in_progress
			temp_size[2] = size[2] * 0.7 + size[2] * 0.3 * anim_ease_in_progress
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3] + 2

			UIRenderer.draw_texture(ui_renderer, icon, temp_position, temp_size, temp_icon_color)
		end

		local title_icon = icon_data.title_icon

		if title_icon then
			local icon_color = icon_data.icon_color

			if icon_color then
				temp_icon_color[1] = alpha - alpha * anim_out_progress
				temp_icon_color[2] = icon_color[2]
				temp_icon_color[3] = icon_color[3]
				temp_icon_color[4] = icon_color[4]
			end

			temp_size[1] = size[1] + size[1] * anim_out_progress
			temp_size[2] = size[2] + size[2] * anim_out_progress
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3]

			UIRenderer.draw_texture(ui_renderer, title_icon, temp_position, temp_size, temp_icon_color)

			if icon_color then
				temp_icon_color[1] = alpha - alpha * anim_in_progress
			end

			temp_size[1] = size[1] + size[1] * anim_in_progress
			temp_size[2] = size[2] + size[2] * anim_in_progress
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3] + 1

			UIRenderer.draw_texture(ui_renderer, title_icon, temp_position, temp_size, temp_icon_color)

			if icon_color then
				temp_icon_color[1] = alpha * 0.7 + alpha * 0.3 * anim_ease_in_progress
			end

			temp_size[1] = size[1] * 0.7 + size[1] * 0.3 * anim_ease_in_progress
			temp_size[2] = size[2] * 0.7 + size[2] * 0.3 * anim_ease_in_progress
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3] + 2

			UIRenderer.draw_texture(ui_renderer, title_icon, temp_position, temp_size, temp_icon_color)
		end

		if marked and marked_texture and not at_opportunity then
			local icon_color = icon_data.icon_color

			if icon_color then
				temp_icon_color[1] = alpha * anim_ease_in_progress
				temp_icon_color[2] = icon_color[2]
				temp_icon_color[3] = icon_color[3]
				temp_icon_color[4] = icon_color[4]
			end

			temp_size[1] = size[1] * 2 - size[1] * anim_ease_in_progress + 10
			temp_size[2] = size[2] * 2 - size[2] * anim_ease_in_progress + 10
			temp_position[1] = position[1] - (temp_size[1] - size[1]) * 0.5
			temp_position[2] = position[2] - (temp_size[2] - size[2]) * 0.5
			temp_position[3] = position[3] + 2

			UIRenderer.draw_texture(ui_renderer, marked_texture, temp_position, temp_size, temp_icon_color)
		end
	else
		local text = icon_data.text

		if text then
			table.clear(temp_text_options)

			local text_style = widget_style.icon_text or widget_style.text
			local font_type = text_style.font_type
			local font_size = icon_data.font_size or text_style.font_size

			font_size = math.ceil(font_size * scale)

			UIFonts.get_font_options_by_style(text_style, temp_text_options)

			temp_text_options.shadow = nil
			temp_icon_color[1] = alpha

			local text_color = icon_data.text_color

			if text_color then
				temp_icon_color[2] = text_color[2]
				temp_icon_color[3] = text_color[3]
				temp_icon_color[4] = text_color[4]
			end

			UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, temp_icon_color, temp_text_options)
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

		local title_icon = icon_data.title_icon

		if title_icon then
			temp_icon_color[1] = alpha

			local icon_color = icon_data.icon_color

			if icon_color then
				temp_icon_color[2] = icon_color[2]
				temp_icon_color[3] = icon_color[3]
				temp_icon_color[4] = icon_color[4]
			end

			UIRenderer.draw_texture(ui_renderer, title_icon, position, size, temp_icon_color)
		end

		if marked and marked_texture and not at_opportunity then
			temp_icon_color[1] = alpha

			local icon_color = icon_data.icon_color

			if icon_color then
				temp_icon_color[2] = icon_color[2]
				temp_icon_color[3] = icon_color[3]
				temp_icon_color[4] = icon_color[4]
			end

			local marked_position = {
				position[1] - 5,
				position[2] - 5,
				position[3],
			}
			local marked_size = {
				size[1] + 10,
				size[2] + 10,
			}

			UIRenderer.draw_texture(ui_renderer, marked_texture, marked_position, marked_size, temp_icon_color)
		end
	end

	if should_trigger_sound then
		self:_play_sound(UISoundEvents.expedition_compass_marker)
	end

	return draw_layer + 1
end

return HudElementPlayerCompass
