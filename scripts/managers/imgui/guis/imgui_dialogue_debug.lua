local ImguiDialogueDebug = class("ImguiDialogueDebug")

ImguiDialogueDebug.init = function (self)
	self._window_width = 1600
	self._window_height = 800
	self._selected_unit_index = -1
	self._dialogue_system = Managers.state.extension:system_by_extension("DialogueActorExtension")
	self._filter_by_unit = false
	self._filter_include_vce = true
end

local function _short_unit_name(unit_name)
	local splut_name = string.split(unit_name, "/")

	if splut_name[#splut_name] == "base" and #splut_name >= 3 then
		return splut_name[#splut_name - 2]
	else
		return splut_name[#splut_name]
	end
end

ImguiDialogueDebug.update = function (self, dt, t)
	Imgui.set_window_size(self._window_width, self._window_height, "once")

	if not self._dialogue_system then
		return
	end

	self._dialogue_system._dialogue_system_debug._dialogue_log_enabled = Imgui.checkbox("Enable log", self._dialogue_system._dialogue_system_debug._dialogue_log_enabled)

	if Imgui.button("Clear log") then
		self._dialogue_system._dialogue_system_debug:clear_dialogue_log_events()
	end

	self._filter_by_unit = Imgui.checkbox("Filter by unit", self._filter_by_unit)

	Imgui.same_line()

	self._filter_include_vce = Imgui.checkbox("Show VCE", self._filter_include_vce)
	local filter_unit = nil

	if self._filter_by_unit then
		local sorted_available_units = {}

		for i = 1, #self._dialogue_system._dialogue_system_debug._dialogue_log_events do
			local event = self._dialogue_system._dialogue_system_debug._dialogue_log_events[i]
			local unit_name = event.unit_name
			local unit_id = event.unit_id
			local already_added = false

			for _, u in ipairs(sorted_available_units) do
				if u.name == unit_name and u.id == unit_id then
					already_added = true

					break
				end
			end

			if not already_added then
				table.insert(sorted_available_units, {
					name = event.unit_name,
					id = event.unit_id
				})
			end
		end

		table.sort(sorted_available_units, function (a, b)
			return a.name .. a.id < b.name .. b.id
		end)

		local left_pane_width = 150

		Imgui.begin_child_window("left_pane", left_pane_width, 0, true)

		for i = 1, #sorted_available_units do
			local unit_name = sorted_available_units[i].name
			local unit_id = sorted_available_units[i].id

			Imgui.push_id(unit_id)

			local short_unit_name = _short_unit_name(unit_name)

			if Imgui.selectable(short_unit_name, i == self._selected_unit_index) then
				self._selected_unit_index = i
			end

			if Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("%s (%s)", unit_name, unit_id))
				Imgui.end_tool_tip()
			end
		end

		if self._selected_unit_index > 0 then
			filter_unit = sorted_available_units[self._selected_unit_index]
		else
			filter_unit = nil
		end

		Imgui.end_child_window()
		Imgui.same_line()
	end

	Imgui.begin_child_window("right_pane", 0, 0, true)
	Imgui.columns(8, true)
	Imgui.text("Time")
	Imgui.set_column_width(80)
	Imgui.next_column()
	Imgui.text("Type")
	Imgui.set_column_width(60)
	Imgui.next_column()
	Imgui.text("Unit")
	Imgui.set_column_width(200)
	Imgui.next_column()
	Imgui.text("Voice")
	Imgui.set_column_width(300)
	Imgui.next_column()
	Imgui.text("Event")
	Imgui.set_column_width(400)
	Imgui.next_column()
	Imgui.text("Event ID")
	Imgui.set_column_width(80)
	Imgui.next_column()
	Imgui.text("Dialogue")
	Imgui.set_column_width(300)
	Imgui.next_column()
	Imgui.text("Interrupted")
	Imgui.set_column_width(100)
	Imgui.next_column()
	Imgui.separator()

	local events = self._dialogue_system._dialogue_system_debug._dialogue_log_events

	for i = 1, events and #events or 0 do
		local event = events[i]
		local unit_name = event.unit_name
		local unit_id = event.unit_id
		local filter_pass_unit = not filter_unit or unit_name == filter_unit.name and unit_id == filter_unit.id
		local filter_pass_vce = self._filter_include_vce or event.type ~= "VCE"

		if filter_pass_unit and filter_pass_vce then
			Imgui.text(string.format("%.2f", event.timestamp))

			if Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Timestamp: %.2f", event.timestamp))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
			Imgui.text(event.type)

			if Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Type: %s", event.type))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()

			local short_unit_name = _short_unit_name(unit_name)

			Imgui.text(short_unit_name)

			if Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Unit: %s (%s)", unit_name, unit_id))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
			Imgui.text(event.voice and event.voice or "unavailable")

			if event.voice and Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Voice: %s", event.voice))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
			Imgui.text(event.sound_event and event.sound_event or "unavailable")

			if event.sound_event and Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Event: %s", event.sound_event))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
			Imgui.text(event.event_id and event.event_id or "unavailable")

			if Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Event ID: %d", event.event_id))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
			Imgui.text(event.dialogue_name and event.dialogue_name or "")

			if event.dialogue_name and Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Dialogue: %s", event.dialogue_name))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
			Imgui.text(event.interrupted and "true" or "")

			if Imgui.is_item_hovered() then
				Imgui.begin_tool_tip()
				Imgui.text(string.format("Interrupted: %s", event.interrupted and "true" or "false"))
				Imgui.end_tool_tip()
			end

			Imgui.next_column()
		end
	end

	Imgui.end_child_window()
end

return ImguiDialogueDebug
