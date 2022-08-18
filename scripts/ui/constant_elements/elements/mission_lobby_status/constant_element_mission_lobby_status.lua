local definition_path = "scripts/ui/constant_elements/elements/mission_lobby_status/constant_element_mission_lobby_status_definitions"
local ConstantMissionLobbyStatusSettings = require("scripts/ui/constant_elements/elements/mission_lobby_status/constant_element_mission_lobby_status_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local ConstantMissionLobbyStatus = class("ConstantMissionLobbyStatus", "ConstantElementBase")

ConstantMissionLobbyStatus.init = function (self, parent, draw_layer, start_scale, definitions)
	local definitions = require(definition_path)

	ConstantMissionLobbyStatus.super.init(self, parent, draw_layer, start_scale, definitions)

	self._active = false
	local number_of_slots = 4

	self:_setup_ready_slots(number_of_slots)
	Managers.event:register(self, "event_lobby_ready_voting_started", "_event_voting_started")
	Managers.event:register(self, "event_lobby_ready_voting_completed", "_event_voting_completed")
	Managers.event:register(self, "event_lobby_ready_voting_aborted", "_event_voting_aborted")
	Managers.event:register(self, "event_lobby_ready_slot_sync", "_event_slot_sync")
	Managers.event:register(self, "event_lobby_ready_started", "_event_ready_started")
	Managers.event:register(self, "event_lobby_ready_completed", "_event_ready_completed")
end

ConstantMissionLobbyStatus._event_voting_started = function (self, voting_id)
	local widget = self._widgets_by_name.timer_text
	widget.style.text.text_color = Color.ui_terminal(255, true)
	widget.style.text.color = Color.ui_terminal(255, true)
	self._active = true
	self._voting_id = voting_id

	self._timer_function = function ()
		return Managers.voting:time_left(voting_id)
	end
end

ConstantMissionLobbyStatus._event_voting_completed = function (self)
	self._voting_id = nil

	self:_event_ready_completed()
end

ConstantMissionLobbyStatus._event_voting_aborted = function (self)
	self._voting_id = nil

	self:_event_ready_completed()
end

ConstantMissionLobbyStatus._event_ready_started = function (self, timer_update_function)
	local widget = self._widgets_by_name.timer_text
	widget.style.text.text_color = Color.ui_red_light(255, true)
	widget.style.text.color = Color.ui_red_light(255, true)
	self._timer_function = timer_update_function
	self._active = true
end

ConstantMissionLobbyStatus._event_ready_completed = function (self)
	local widget = self._widgets_by_name.timer_text
	widget.style.text.text_color = Color.ui_terminal(255, true)
	widget.style.text.color = Color.ui_terminal(255, true)
	self._active = false
	self._timer_function = nil
end

ConstantMissionLobbyStatus._event_slot_sync = function (self, slots)
	self:_sync_votes(slots)
end

ConstantMissionLobbyStatus._sync_votes = function (self, slots)
	for _, slot in pairs(slots) do
		local ready = slot.ready
		local occupied = slot.occupied
		local index = slot.index

		self:_set_slot_status_by_index(index, occupied, ready)
	end
end

ConstantMissionLobbyStatus._setup_ready_slots = function (self, amount)
	local widget_definition = self._definitions.ready_status_definition
	local widgets = {}
	local ready_slot_size = ConstantMissionLobbyStatusSettings.ready_slot_size
	local x_offset = -amount * ready_slot_size[1]

	for i = 1, amount, 1 do
		local widget_name = "slot_" .. i
		local widget = self:_create_widget(widget_name, widget_definition)
		widgets[#widgets + 1] = widget
		x_offset = x_offset + ready_slot_size[1]
		widget.offset[1] = x_offset
	end

	self._slot_widgets = widgets
end

ConstantMissionLobbyStatus._set_start_time = function (self, time)
	local widget = self._widgets_by_name.timer_text
	local time_to_string = tostring(math.ceil(time))
	local time_string_to_array = {}

	for mem in string.gmatch(time_to_string, "%w") do
		table.insert(time_string_to_array, mem)
	end

	local symbols_text = ""

	for i = 1, #time_string_to_array, 1 do
		local number = tonumber(time_string_to_array[i])
		local symbol = UISettings.digital_clock_numbers[number]
		symbols_text = symbols_text .. symbol
	end

	widget.content.text = symbols_text
end

ConstantMissionLobbyStatus._set_slot_status_by_index = function (self, index, occupied, ready)
	local widget = self._slot_widgets[index]
	widget.content.selected = ready
	widget.content.occupied = occupied
end

ConstantMissionLobbyStatus.destroy = function (self)
	Managers.event:unregister(self, "event_lobby_ready_voting_started")
	Managers.event:unregister(self, "event_lobby_ready_voting_completed")
	Managers.event:unregister(self, "event_lobby_ready_voting_aborted")
	Managers.event:unregister(self, "event_lobby_ready_slot_sync")
	Managers.event:unregister(self, "event_lobby_ready_started")
	Managers.event:unregister(self, "event_lobby_ready_completed")
	ConstantMissionLobbyStatus.super.destroy(self)
end

ConstantMissionLobbyStatus.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._active then
		return
	end

	ConstantMissionLobbyStatus.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local time_left = self._timer_function and self:_timer_function()

	if time_left then
		self:_set_start_time(time_left)
	end
end

ConstantMissionLobbyStatus._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ConstantMissionLobbyStatus.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local slot_widgets = self._slot_widgets

	for i = 1, #slot_widgets, 1 do
		local widget = slot_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

ConstantMissionLobbyStatus.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._active then
		return
	end

	ConstantMissionLobbyStatus.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

return ConstantMissionLobbyStatus
