-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_party_hud.lua

local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UiSettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	400,
	20,
}

template.size = size
template.name = "nameplate_party_hud"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.4,
}
template.check_line_of_sight = false
template.max_distance = 100
template.screen_clamp = false
template.start_layer = 300
template.scale_settings = {
	distance_max = 20,
	distance_min = 10,
	scale_from = 0.8,
	scale_to = 1,
}
template.fade_settings = {
	default_fade = 1,
	fade_from = 0,
	fade_to = 1,
	distance_max = template.max_distance,
	distance_min = template.max_distance * 0.5,
	easing_function = math.ease_exp,
}

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = Color.terminal_text_header(255, true)

	return UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "header_text",
			value = "<header_text>",
			value_id = "header_text",
			style = {
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				default_font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = size,
			},
		},
	}, scenegraph_id)
end

template.on_exit = function (widget, marker)
	Managers.event:unregister(marker, "event_player_profile_updated")

	if marker.rank_promise then
		if marker.rank_promise:is_pending() then
			marker.rank_promise:cancel()
		end

		marker.rank_promise = nil
	end
end

template.on_enter = function (widget, marker)
	local data = marker.data
	local content = widget.content
	local profile = data:profile()
	local character_level = profile and profile.current_level or 1

	local function cb_event_player_profile_updated(self, synced_peer_id, synced_local_player_id, new_profile, force_update)
		local my_player = marker.my_player

		if not my_player then
			return
		end

		local valid = force_update or my_player.peer_id and my_player:peer_id() == synced_peer_id

		if valid then
			local player_profile = data:profile()
			local title = player_profile and ProfileUtils.character_title(player_profile)
			local archetype = profile and profile.archetype
			local archetype_name = archetype and archetype.name
			local string_symbol = archetype_name and UiSettings.archetype_font_icon[archetype_name] or ""
			local text = string_symbol .. " " .. data:name() .. " - " .. tostring(character_level) .. " "

			if title then
				text = text .. "\n" .. title
			end

			marker.widget.content.header_text = text

			if character_level >= 30 then
				local rank_promise = Managers.data_service.havoc:havoc_rank_cadence_high(data:account_id())

				rank_promise:next(function (rank)
					marker.rank_promise = nil

					if rank then
						text = string_symbol .. " " .. data:name() .. " - " .. tostring(rank) .. " "

						if title then
							text = text .. "\n" .. title
						end

						marker.widget.content.header_text = text
					end
				end)

				marker.rank_promise = rank_promise
			end
		end
	end

	marker.cb_event_player_profile_updated = cb_event_player_profile_updated

	Managers.event:register(marker, "event_player_profile_updated", "cb_event_player_profile_updated")

	local archetype = profile and profile.archetype
	local archetype_name = archetype and archetype.name
	local string_symbol = archetype_name and UiSettings.archetype_font_icon[archetype_name] or ""
	local text = string_symbol .. " " .. data:name() .. " - " .. tostring(character_level) .. " "

	content.header_text = text

	local force_update = true

	cb_event_player_profile_updated(nil, nil, nil, nil, force_update)
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local style = widget.style
	local draw = marker.draw

	if draw then
		local scale = marker.scale
		local header_text_id = "header_text"
		local header_style = style[header_text_id]

		header_style.font_size = header_style.default_font_size * scale
	end
end

return template
