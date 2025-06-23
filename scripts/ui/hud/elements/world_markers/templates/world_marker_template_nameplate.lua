-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate.lua

local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UiSettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local _event_update_player_name, _create_character_text
local template = {}
local size = {
	400,
	20
}

template.size = size
template.name = "nameplate"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.4
}
template.check_line_of_sight = true
template.max_distance = 15
template.screen_clamp = false
template.start_layer = 300
template.scale_settings = {
	scale_to = 1,
	scale_from = 0.5,
	distance_max = 20,
	distance_min = 10
}
template.fade_settings = {
	fade_to = 1,
	fade_from = 0,
	default_fade = 1,
	distance_max = template.max_distance,
	distance_min = template.max_distance * 0.5,
	easing_function = math.ease_exp
}

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = Color.terminal_text_body(255, true)

	return UIWidget.create_definition({
		{
			style_id = "header_text",
			pass_type = "text",
			value_id = "header_text",
			value = "<header_text>",
			style = {
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				default_font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = size
			}
		}
	}, scenegraph_id)
end

template.on_exit = function (widget, marker)
	Managers.event:unregister(marker, "event_player_profile_updated")
	Managers.event:unregister(marker, "event_update_player_name")

	if marker.rank_promise then
		if marker.rank_promise:is_pending() then
			marker.rank_promise:cancel()
		end

		marker.rank_promise = nil
	end
end

template.on_enter = function (widget, marker)
	local function cb_event_player_profile_updated(self, synced_peer_id, synced_local_player_id, new_profile, force_update)
		local valid = force_update or self.peer_id and self.peer_id == synced_peer_id

		if not valid then
			return
		end

		local updated_title = new_profile and ProfileUtils.character_title(new_profile)

		if not updated_title then
			return
		end

		local player_manager = Managers.player
		local player = marker.data
		local is_player_valid = player_manager:player_from_unique_id(marker.player_unique_id) ~= nil

		if is_player_valid and player then
			player:set_profile(new_profile)
			_create_character_text(marker)
		end
	end

	local player = marker.data

	marker.player_unique_id = player:unique_id()
	marker.cb_event_player_profile_updated = cb_event_player_profile_updated
	marker._event_update_player_name = _event_update_player_name

	Managers.event:register(marker, "event_player_profile_updated", "cb_event_player_profile_updated")
	Managers.event:register(marker, "event_update_player_name", "_event_update_player_name")
	_create_character_text(marker)
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local content = widget.content
	local style = widget.style
	local is_inside_frustum = content.is_inside_frustum
	local distance = content.distance
	local line_of_sight_progress = content.line_of_sight_progress or 0

	if marker.raycast_initialized then
		local raycast_result = marker.raycast_result
		local line_of_sight_speed = 3

		if raycast_result then
			line_of_sight_progress = math.max(line_of_sight_progress - dt * line_of_sight_speed, 0)
		else
			line_of_sight_progress = math.min(line_of_sight_progress + dt * line_of_sight_speed, 1)
		end
	end

	local draw = marker.draw

	if draw then
		local scale = marker.scale
		local header_text_id = "header_text"
		local header_style = style[header_text_id]
		local header_default_font_size = header_style.default_font_size

		header_style.font_size = header_style.default_font_size * scale
		content.line_of_sight_progress = line_of_sight_progress
		widget.alpha_multiplier = line_of_sight_progress
	end
end

function _event_update_player_name(self)
	_create_character_text(self)
end

function _create_character_text(marker)
	local player = marker.data
	local player_manager = Managers.player
	local is_player_valid = player_manager:player_from_unique_id(marker.player_unique_id) ~= nil

	if not is_player_valid or not player then
		return
	end

	local profile = player:profile()
	local peer_id = player:peer_id()

	marker.peer_id = peer_id

	local character_level = profile and profile.current_level or 1
	local title = ProfileUtils.character_title(profile)
	local archetype = profile and profile.archetype
	local archetype_name = archetype and archetype.name
	local string_symbol = archetype_name and UiSettings.archetype_font_icon[archetype_name] or ""
	local text = string_symbol .. " " .. player:name() .. " - " .. tostring(character_level) .. " "

	if title then
		text = text .. " \n " .. title
	end

	marker.widget.content.header_text = text

	if character_level >= 30 then
		local rank_promise = Managers.data_service.havoc:havoc_rank_cadence_high(player:account_id())

		rank_promise:next(function (rank)
			marker.rank_promise = nil

			if rank then
				text = string_symbol .. " " .. player:name() .. " - " .. tostring(rank) .. " "

				if title then
					text = text .. "\n" .. title
				end

				marker.widget.content.header_text = text
			end
		end)

		marker.rank_promise = rank_promise
	end
end

return template
