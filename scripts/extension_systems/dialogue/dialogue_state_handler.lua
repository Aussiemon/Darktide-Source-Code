-- chunkname: @scripts/extension_systems/dialogue/dialogue_state_handler.lua

local DialogueStateHandler = class("DialogueStateHandler")

DialogueStateHandler.init = function (self, world, wwise_world)
	self._world = world
	self._wwise_world = wwise_world
	self._playing_dialogues = {}
	self._current_index = 1
	self._max_dialogue_checks_per_frame = 10
	self._dialogues_to_remove = {}
end

DialogueStateHandler.add_playing_dialogue = function (self, identifier, event_id, t, dialogue_duration)
	self._playing_dialogues[#self._playing_dialogues + 1] = {
		identifier = identifier,
		event_id = event_id,
		start_time = t,
		expected_end = t + dialogue_duration
	}
end

DialogueStateHandler.update = function (self, t)
	if #self._playing_dialogues == 0 then
		return
	end

	table.clear(self._dialogues_to_remove)

	local num_checks = 0
	local start_index = self._current_index
	local level = Managers.state.mission:mission_level()

	while true do
		local dialogue_data = self._playing_dialogues[self._current_index]

		if level and t > dialogue_data.expected_end then
			Level.set_flow_variable(level, "dialogue_identifier", dialogue_data.identifier)
			Level.trigger_event(level, "dialogue_ended")

			self._dialogues_to_remove[#self._dialogues_to_remove + 1] = self._current_index
		end

		self._current_index = 1 + self._current_index % #self._playing_dialogues
		num_checks = num_checks + 1

		if self._current_index == start_index or num_checks >= self._max_dialogue_checks_per_frame then
			break
		end
	end

	if #self._dialogues_to_remove > 0 then
		table.sort(self._dialogues_to_remove)

		for i = #self._dialogues_to_remove, 1, -1 do
			local index = self._dialogues_to_remove[i]

			table.remove(self._playing_dialogues, index)
		end
	end
end

return DialogueStateHandler
