-- chunkname: @scripts/extension_systems/dialogue/dialogue_system_testify.lua

local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local DialogueSystemTestify = {
	all_dialogue_sound_events = function (_, dialogue_extension)
		local vo_sources = dialogue_extension._vo_sources_cache._vo_sources
		local sound_events = {}

		for _, sound_event_types in pairs(vo_sources) do
			for _, sound_event_type in pairs(sound_event_types) do
				local events_of_type = sound_event_type.sound_events

				for _, sound_event in pairs(events_of_type) do
					table.insert(sound_events, sound_event)
				end
			end
		end

		return sound_events
	end,
	all_wwise_voices = function ()
		local voices = {}

		for _, breed in pairs(DialogueBreedSettings) do
			local wwise_voices = type(breed) ~= "function" and breed.wwise_voices or nil

			if wwise_voices ~= nil then
				for _, voice in pairs(wwise_voices) do
					table.insert(voices, voice)
				end
			end
		end

		voices = table.unique_array_values(voices)

		return voices
	end,
	dialogue_extension = function (_, unit)
		local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

		return dialogue_extension
	end,
	play_dialogue_event = function (_, vo_settings)
		local dialogue_extension = vo_settings.dialogue_extension
		local event = vo_settings.event

		dialogue_extension:play_event(event)
	end,
	set_vo_profile = function (_, vo_settings)
		local dialogue_extension = vo_settings.dialogue_extension
		local voice = vo_settings.voice

		dialogue_extension:set_vo_profile(voice)
	end
}

return DialogueSystemTestify
