local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")

local function record_telemetry(dialogue)
	local sound_event = dialogue.sound_events[1]
	local p1, p2 = sound_event:find("__")
	local character_name = sound_event:sub(0, p1 - 1)
	local bank_name = sound_event:sub(p2 + 1, sound_event:len() - 3)

	Managers.telemetry_events:vo_bank_reshuffled(character_name, bank_name)
end

local temp_weight_table = {}
local temp_indexes = {}
DialogueQueries = {
	get_sound_event_duration = function (dialogue, index)
		if dialogue.sound_events_duration then
			return dialogue.sound_events_duration[index] or DialogueSettings.sound_event_default_length
		else
			return DialogueSettings.sound_event_default_length
		end
	end,
	get_dialogue_event = function (dialogue, index)
		return dialogue.sound_events[index], dialogue.localization_strings[index], dialogue.face_animations[index], dialogue.dialogue_animations[index]
	end,
	build_randomized_indexes = function (dialogue)
		if dialogue.sound_event_weights then
			table.clear(temp_weight_table)
			table.clear(temp_indexes)

			local accumulator = 0

			for i = 1, dialogue.sound_events_n, 1 do
				temp_weight_table[i] = dialogue.sound_event_weights[i] + accumulator
				temp_indexes[i] = i
				accumulator = accumulator + dialogue.sound_event_weights[i]
			end

			local temp_weight_table_n = dialogue.sound_events_n

			for i = 1, dialogue.sound_events_n, 1 do
				if temp_weight_table_n == 1 then
					dialogue.randomize_indexes[i] = temp_indexes[1]

					break
				end

				local rand = math.random()
				local selected_index = 1

				for temp_index = 1, temp_weight_table_n, 1 do
					if rand <= temp_weight_table[temp_index] then
						selected_index = temp_index

						break
					end
				end

				dialogue.randomize_indexes[i] = temp_indexes[selected_index]
				local length_selected = temp_weight_table[selected_index] - ((selected_index == 1 and 0) or temp_weight_table[selected_index - 1])

				table.remove(temp_weight_table, selected_index)
				table.remove(temp_indexes, selected_index)

				temp_weight_table_n = temp_weight_table_n - 1
				local weight_adjustement = length_selected / temp_weight_table_n

				for key, value in pairs(temp_weight_table) do
					temp_weight_table[key] = value + weight_adjustement
				end
			end

			dialogue.randomize_indexes_n = dialogue.sound_events_n
		else
			dialogue.randomize_indexes = table.get_random_array_indices(dialogue.sound_events_n, dialogue.sound_events_n)
			dialogue.randomize_indexes_n = dialogue.sound_events_n
		end
	end,
	get_dialogue_event_index = function (dialogue)
		if dialogue.sound_events_n == 1 then
			return 1
		end

		if dialogue.randomize_indexes_n == 0 then
			record_telemetry(dialogue)
			DialogueQueries.build_randomized_indexes(dialogue)
		end

		local current_index = dialogue.randomize_indexes_n
		dialogue.randomize_indexes_n = dialogue.randomize_indexes_n - 1

		return dialogue.randomize_indexes[current_index]
	end
}

return DialogueQueries
