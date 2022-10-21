local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local DialogueCategoryConfig = require("scripts/settings/dialogue/dialogue_category_config")
local DialogueEventQueue = class("DialogueEventQueue")

DialogueEventQueue.init = function (self, unit_extension_data, dialogues, query_database)
	self._dialogues = dialogues
	self._query_database = query_database
	self._unit_extension_data = unit_extension_data
	self._input_event_queue = {}
	self._input_event_queue_n = 0
	self._index_input_event_queue = 1
	self._current_time = 0
	self._filtering_end_time = 0
	self._filter_category = nil
	self._query_temp_array = {}
end

DialogueEventQueue.update_new_events = function (self, dt, t)
	self._current_time = self._current_time + dt

	if self:is_category_filtered() then
		return
	end

	local total_events_to_process = self._input_event_queue_n
	local ALIVE = ALIVE

	for i = 1, total_events_to_process do
		repeat
			local unit, event_name, identifier = self:_pop_event(self._query_temp_array)

			if not ALIVE[unit] then
				break
			end

			local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
			local breed_data = unit_data_extension and unit_data_extension:breed() or Unit.get_data(unit, "breed")
			local source_name = nil

			if breed_data and not breed_data.is_player then
				source_name = DialogueBreedSettings[breed_data.name].vo_class_name
			else
				local extension_data = self._unit_extension_data[unit]

				if extension_data == nil then
					break
				end

				source_name = extension_data:get_context().player_profile
			end

			local query = self._query_database:create_query()

			query:add("concept", event_name, "source", unit, "source_name", source_name, "identifier", identifier, unpack(self._query_temp_array))
			query:finalize()
		until true
	end
end

DialogueEventQueue.append_event = function (self, unit, event_name, event_data, identifier)
	if self:is_category_filtered() then
		if self._filter_category and event_data.dialogue_name then
			local incoming_category = self._dialogues[event_data.dialogue_name].category

			if self._filter_category.interrupted_by[incoming_category] then
				self._filtering_end_time = 0

				self:_append_event_implementation(unit, event_name, event_data, identifier)
			end
		end

		return
	end

	self:_append_event_implementation(unit, event_name, event_data, identifier)
end

DialogueEventQueue.filter_events_under = function (self, category, duration)
	if self:is_category_filtered() then
		Log.warning("DialogueEventQueue", "filter events received when another filter is in place (%d, %s)", self._filtering_end_time, self._filter_category)

		return
	end

	self:_purge_events()

	self._filtering_end_time = self._current_time + duration
	self._filter_category = nil

	if DialogueCategoryConfig[category] then
		self._filter_category = DialogueCategoryConfig[category]
	end
end

DialogueEventQueue._append_event_implementation = function (self, unit, event_name, event_data, identifier)
	local base_index = self._index_input_event_queue
	self._input_event_queue[base_index + 0] = unit
	self._input_event_queue[base_index + 1] = event_name
	self._input_event_queue[base_index + 2] = identifier or ""
	self._input_event_queue[base_index + 3] = table.size(event_data)
	local base_index_event_data = base_index + 4

	for key, value in pairs(event_data) do
		self._input_event_queue[base_index_event_data + 0] = key
		self._input_event_queue[base_index_event_data + 1] = value
		base_index_event_data = base_index_event_data + 2
	end

	self._index_input_event_queue = self._index_input_event_queue + 4 + 2 * table.size(event_data)
	self._input_event_queue_n = self._input_event_queue_n + 1
end

DialogueEventQueue._pop_event = function (self, event_data_target)
	table.clear(event_data_target)

	local unit = table.remove(self._input_event_queue, 1)
	local event_name = table.remove(self._input_event_queue, 1)
	local identifier = table.remove(self._input_event_queue, 1)
	local number_of_arguments = table.remove(self._input_event_queue, 1)
	local index = 0

	for i = 1, number_of_arguments do
		event_data_target[index + 1] = table.remove(self._input_event_queue, 1)
		event_data_target[index + 2] = table.remove(self._input_event_queue, 1)
		index = index + 2
	end

	self._input_event_queue_n = self._input_event_queue_n - 1
	self._index_input_event_queue = self._index_input_event_queue - 4 - 2 * number_of_arguments

	return unit, event_name, identifier
end

DialogueEventQueue._purge_events = function (self)
	table.clear(self._input_event_queue)

	self._index_input_event_queue = 1
	self._input_event_queue_n = 0
end

DialogueEventQueue.is_category_filtered = function (self)
	return self._current_time < self._filtering_end_time
end

DialogueEventQueue.filtering_end_time = function (self)
	return self._filtering_end_time
end

return DialogueEventQueue
