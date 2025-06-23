-- chunkname: @scripts/ui/constant_elements/elements/group_finder_status/constant_element_group_finder_status.lua

local Definitions = require("scripts/ui/constant_elements/elements/group_finder_status/constant_element_group_finder_status_definitions")
local ConstantGroupFinderStatusSettings = require("scripts/ui/constant_elements/elements/group_finder_status/constant_element_group_finder_status_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ConstantGroupFinderStatus = class("ConstantGroupFinderStatus", "ConstantElementBase")

ConstantGroupFinderStatus.init = function (self, parent, draw_layer, start_scale)
	ConstantGroupFinderStatus.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active = false
	self._active_top_view = nil
	self._advertisement_join_requests_version = -1
	self._original_position = {
		self._ui_scenegraph.pivot.position[1],
		self._ui_scenegraph.pivot.position[2]
	}
	self._num_requests = 0

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.request_text.alpha_multiplier = 0
	widgets_by_name.request_panel.alpha_multiplier = 0
end

ConstantGroupFinderStatus._cancel_active_request_anims = function (self)
	if self._request_enter_anim_id then
		self:_stop_animation(self._request_enter_anim_id)

		self._request_enter_anim_id = nil
	end

	if self._request_exit_anim_id then
		self:_stop_animation(self._request_exit_anim_id)

		self._request_exit_anim_id = nil
	end
end

ConstantGroupFinderStatus.start_player_request_anim_enter = function (self)
	self:_cancel_active_request_anims()

	local anim_callback = callback(self, "on_player_request_anim_enter_complete")

	self._request_enter_anim_id = self:_start_animation("player_request_enter", self._widgets_by_name, {}, anim_callback, 1)
end

ConstantGroupFinderStatus.start_player_request_anim_exit = function (self)
	self:_cancel_active_request_anims()

	local anim_callback = callback(self, "on_player_request_anim_exit_complete")

	self._request_exit_anim_id = self:_start_animation("player_request_exit", self._widgets_by_name, {}, anim_callback, 1)
end

ConstantGroupFinderStatus.on_player_request_anim_enter_complete = function (self)
	return
end

ConstantGroupFinderStatus.on_player_request_anim_exit_complete = function (self)
	self._request_exit_anim_id = nil
end

ConstantGroupFinderStatus._sync_votes = function (self, slots)
	for _, slot in pairs(slots) do
		local ready = slot.ready
		local occupied = slot.occupied
		local index = slot.index

		self:_set_slot_status_by_index(index, occupied, ready)
	end
end

ConstantGroupFinderStatus._setup_ready_slots = function (self, amount)
	local widget_definition = self._definitions.ready_status_definition
	local widgets = {}
	local ready_slot_size = ConstantGroupFinderStatusSettings.ready_slot_size
	local x_offset = -amount * ready_slot_size[1]

	for i = 1, amount do
		local widget_name = "slot_" .. i
		local widget = self:_create_widget(widget_name, widget_definition)

		widgets[#widgets + 1] = widget
		x_offset = x_offset + ready_slot_size[1]
		widget.offset[1] = x_offset
	end

	self._slot_widgets = widgets
end

local filled_slot_color = Color.terminal_text_body(255, true)
local empty_slot_color = Color.terminal_text_body_dark(255, true)
local temp_team_players = {}

ConstantGroupFinderStatus._update_party_size = function (self)
	local game_mode_manager = Managers.state.game_mode

	if not game_mode_manager then
		return
	end

	local hud_settings = game_mode_manager:hud_settings()
	local player_composition_name = hud_settings.player_composition
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.party_panel
	local content = widget.content
	local style = widget.style
	local players = PlayerCompositions.players(player_composition_name, temp_team_players)
	local team_counter = 0
	local total_team_size = 4

	local function update_slot_info(index, player)
		local player_color = style["team_member_icon_" .. index].text_color

		if player then
			local archetype_name = player:archetype_name()
			local archetype_font_icon = archetype_name and UISettings.archetype_font_icon_simple[archetype_name]

			team_counter = team_counter + 1
			content["team_member_icon_" .. index] = archetype_font_icon or ""
			player_color[2] = filled_slot_color[2]
			player_color[3] = filled_slot_color[3]
			player_color[4] = filled_slot_color[4]
		else
			content["team_member_icon_" .. index] = ""
			player_color[2] = empty_slot_color[2]
			player_color[3] = empty_slot_color[3]
			player_color[4] = empty_slot_color[4]
		end
	end

	local index = 1

	for unique_id, player in pairs(players) do
		update_slot_info(index, player)

		index = index + 1
	end

	for i = index, total_team_size do
		update_slot_info(i, nil)
	end

	content.team_counter = "Players: " .. team_counter .. "/" .. total_team_size
end

ConstantGroupFinderStatus._set_start_time = function (self, time)
	local widget = self._widgets_by_name.timer_text
	local time_to_string = tostring(math.ceil(time))
	local time_string_to_array = {}

	for mem in string.gmatch(time_to_string, "%w") do
		table.insert(time_string_to_array, mem)
	end

	local symbols_text = ""

	for i = 1, #time_string_to_array do
		local number = tonumber(time_string_to_array[i])
		local symbol = UISettings.digital_clock_numbers[number]

		symbols_text = symbols_text .. symbol
	end

	widget.content.text = symbols_text
end

ConstantGroupFinderStatus._set_slot_status_by_index = function (self, index, occupied, ready)
	local widget = self._slot_widgets[index]

	widget.content.selected = ready
	widget.content.occupied = occupied
end

ConstantGroupFinderStatus.destroy = function (self)
	Managers.event:unregister(self, "event_lobby_ready_voting_started")
	Managers.event:unregister(self, "event_lobby_ready_voting_completed")
	Managers.event:unregister(self, "event_lobby_ready_voting_aborted")
	Managers.event:unregister(self, "event_lobby_ready_slot_sync")
	Managers.event:unregister(self, "event_lobby_ready_started")
	Managers.event:unregister(self, "event_lobby_ready_completed")
	ConstantGroupFinderStatus.super.destroy(self)
end

ConstantGroupFinderStatus._update_incoming_join_requests = function (self)
	local party_immaterium = Managers.party_immaterium
	local join_requests, version

	if party_immaterium then
		join_requests, version = party_immaterium:advertisement_request_to_join_list()
	end

	if join_requests then
		if version >= self._advertisement_join_requests_version then
			self._advertisement_join_requests_version = version

			local num_join_requests = table.size(join_requests)
			local current_request_amount = num_join_requests

			if self._num_requests ~= current_request_amount then
				self._num_requests = current_request_amount
				self._widgets_by_name.request_text.content.text = Localize("loc_group_finder_status_panel_player_request", true, {
					num_requests = current_request_amount
				})

				if current_request_amount > 0 then
					self:_play_sound(UISoundEvents.group_finder_incoming_request)
					self:start_player_request_anim_enter()

					self._widgets_by_name.party_panel.content.has_requests = true
				else
					self:start_player_request_anim_exit()

					self._widgets_by_name.party_panel.content.has_requests = false
				end
			end
		end
	elseif self._num_requests > 0 then
		self._num_requests = 0
		self._widgets_by_name.party_panel.content.has_requests = false

		self:start_player_request_anim_exit()
	end
end

ConstantGroupFinderStatus.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_incoming_join_requests()

	local party_immaterium = Managers.party_immaterium
	local advertisement_active = party_immaterium and party_immaterium:is_party_advertisement_active()
	local active = advertisement_active

	if self._active ~= active then
		self._active = active

		if not active then
			self:_cancel_active_request_anims()

			local widgets_by_name = self._widgets_by_name

			widgets_by_name.request_text.alpha_multiplier = 0
			widgets_by_name.request_panel.alpha_multiplier = 0
			self._advertisement_join_requests_version = -1
		end
	end

	local new_view = Managers.ui:active_top_view()

	if Managers.ui:view_active_data(new_view) and Managers.ui:view_active_data(new_view).fade_in or Managers.ui:view_active_data(self._active_top_view) and Managers.ui:view_active_data(self._active_top_view).fade_out then
		self._hide_element = true
	elseif new_view and not ConstantGroupFinderStatusSettings.allowed_views[new_view] then
		self._hide_element = true
		self._active_top_view = new_view
	else
		self._hide_element = false
	end

	if not active then
		return
	end

	ConstantGroupFinderStatus.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_party_size()

	if self._active_top_view ~= Managers.ui:active_top_view() then
		-- Nothing
	end
end

ConstantGroupFinderStatus._check_element_position = function (self)
	local new_view = Managers.ui:active_top_view()

	if self._hide_element then
		return
	end

	local current_position_data = ConstantGroupFinderStatusSettings.active_view_position[self._active_top_view]
	local position_data = ConstantGroupFinderStatusSettings.active_view_position[new_view]

	if position_data then
		-- Nothing
	elseif current_position_data then
		-- Nothing
	end

	self._active_top_view = new_view
end

ConstantGroupFinderStatus._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ConstantGroupFinderStatus.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ConstantGroupFinderStatus._change_lobby_status_position = function (self, x, y)
	local original_x = self._original_position[1]
	local original_y = self._original_position[2]

	x = x or original_x
	y = y or original_y

	self:set_scenegraph_position("pivot", x, y)

	self._updated_position = true
end

ConstantGroupFinderStatus.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._active then
		return
	end

	if Managers.ui:view_active("blank_view") then
		return
	end

	if self._hide_element then
		if self._updated_position then
			self._updated_position = false
		end

		return
	elseif not self._hide_element and self._updated_position then
		self._updated_position = false

		return
	end

	ConstantGroupFinderStatus.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

return ConstantGroupFinderStatus
