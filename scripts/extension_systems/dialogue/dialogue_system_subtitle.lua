local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local DialogueSystemSubtitle = class("DialogueSystemSubtitle")

DialogueSystemSubtitle.init = function (self, world, wwise_world)
	self._playing_localized_dialogues_array = {}
	self._playing_audible_localized_dialogues_array = {}
end

DialogueSystemSubtitle.update = function (self)
	for i = 1, #self._playing_localized_dialogues_array do
		local dialogue = self._playing_localized_dialogues_array[i]
		local is_audible = dialogue.is_audible
		local last_audible = dialogue.last_audible

		if last_audible ~= nil then
			if is_audible == last_audible then
				return
			elseif is_audible == false and last_audible == true then
				self:remove_silent_localized_dialogue(dialogue)
			elseif is_audible == true and last_audible == false then
				self:add_audible_playing_localized_dialogue(dialogue)
			end
		elseif is_audible == true then
			self:add_audible_playing_localized_dialogue(dialogue)
		end

		dialogue.last_audible = is_audible
	end
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
	local localized_audible_index = table.index_of(self._playing_audible_localized_dialogues_array, dialogue)
	dialogue.last_audible = nil

	table.remove(self._playing_localized_dialogues_array, localized_index)
	table.remove(self._playing_audible_localized_dialogues_array, localized_audible_index)
end

DialogueSystemSubtitle.add_audible_playing_localized_dialogue = function (self, dialogue)
	table.insert(self._playing_audible_localized_dialogues_array, 1, dialogue)
end

DialogueSystemSubtitle.remove_silent_localized_dialogue = function (self, dialogue)
	local localized_index = table.index_of(self._playing_audible_localized_dialogues_array, dialogue)

	table.remove(self._playing_audible_localized_dialogues_array, localized_index)
end

DialogueSystemSubtitle.is_localized_dialogue_playing = function (self)
	return #self._playing_localized_dialogues_array > 0
end

DialogueSystemSubtitle.playing_localized_dialogues_array = function (self)
	return self._playing_localized_dialogues_array
end

DialogueSystemSubtitle.is_audible_localized_dialogue_playing = function (self)
	return #self._playing_audible_localized_dialogues_array > 0
end

DialogueSystemSubtitle.playing_audible_localized_dialogues_array = function (self)
	return self._playing_audible_localized_dialogues_array
end

return DialogueSystemSubtitle
