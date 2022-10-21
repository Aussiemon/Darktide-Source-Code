local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local DialogueSystemSubtitle = class("DialogueSystemSubtitle")

DialogueSystemSubtitle.init = function (self, world, wwise_world)
	self._playing_localized_dialogues_array = {}
end

DialogueSystemSubtitle.add_playing_localized_dialogue = function (self, speaker_name, dialogue)
	local speaker_setting = DialogueSpeakerVoiceSettings[speaker_name]

	if speaker_setting then
		local is_localized = speaker_setting.subtitles_enabled

		if is_localized then
			table.insert(self._playing_localized_dialogues_array, 1, dialogue)
		end
	end
end

DialogueSystemSubtitle.remove_localized_dialogue = function (self, dialogue)
	local localized_index = table.index_of(self._playing_localized_dialogues_array, dialogue)

	table.remove(self._playing_localized_dialogues_array, localized_index)
end

DialogueSystemSubtitle.is_localized_dialogue_playing = function (self)
	return #self._playing_localized_dialogues_array > 0
end

DialogueSystemSubtitle.playing_localized_dialogues_array = function (self)
	return self._playing_localized_dialogues_array
end

return DialogueSystemSubtitle
