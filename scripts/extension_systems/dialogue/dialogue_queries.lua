-- chunkname: @scripts/extension_systems/dialogue/dialogue_queries.lua

local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")

local function record_telemetry(dialogue)
	if DEDICATED_SERVER then
		local sound_event = dialogue.sound_events[1]
		local p1, p2 = sound_event:find("__")
		local bank_name = sound_event:sub(p2 + 1, sound_event:len() - 3)

		Managers.telemetry_reporters:reporter("voice_over_bank_reshuffled"):register_event(bank_name)
	end
end

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
		if not dialogue.randomize_indexes[1] then
			local i = 1

			while i <= dialogue.sound_events_n do
				dialogue.randomize_indexes[i] = i
				i = i + 1
			end
		end

		table.shuffle(dialogue.randomize_indexes)

		dialogue.randomize_indexes_n = dialogue.sound_events_n
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
		local current_variation = dialogue.randomize_indexes[current_index]

		if current_variation == dialogue.last_variation then
			dialogue.randomize_indexes_n = dialogue.randomize_indexes_n - 1
			current_index = dialogue.randomize_indexes_n
		end

		dialogue.randomize_indexes_n = dialogue.randomize_indexes_n - 1
		dialogue.last_variation = dialogue.randomize_indexes[current_index]

		return dialogue.randomize_indexes[current_index]
	end
}

return DialogueQueries
