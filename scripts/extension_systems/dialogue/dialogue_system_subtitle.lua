-- chunkname: @scripts/extension_systems/dialogue/dialogue_system_subtitle.lua

local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local DialogueSystemSubtitle = class("DialogueSystemSubtitle")

DialogueSystemSubtitle.init = function (self, world, wwise_world)
	self._playing_localized_dialogues_array = {}
	self._playing_audible_localized_dialogues_array = {}
	self._cached_dialogue = nil
	self._subtitle_delay = 0
end

DialogueSystemSubtitle.update = function (self, dt)
	for i = 1, #self._playing_localized_dialogues_array do
		local dialogue = self._playing_localized_dialogues_array[i]
		local duration = dialogue.duration

		if duration then
			duration = duration - dt

			if duration <= 0 then
				self:remove_localized_dialogue(dialogue)

				return
			end

			dialogue.duration = duration
		end

		local is_audible = dialogue.is_audible
		local last_audible = dialogue.last_audible

		if last_audible ~= nil then
			if is_audible == false and last_audible == true then
				self:remove_silent_localized_dialogue(dialogue)
			elseif is_audible == true and last_audible == false then
				self:add_audible_playing_localized_dialogue(dialogue)
			end
		elseif is_audible == true then
			self:add_audible_playing_localized_dialogue(dialogue)
		end

		dialogue.last_audible = is_audible
	end

	if self._cached_dialogue then
		self._subtitle_delay = self._subtitle_delay - dt

		if self._subtitle_delay <= 0 then
			local dialogue = self._cached_dialogue

			self:add_playing_localized_dialogue(dialogue.speaker_name, dialogue)

			self._cached_dialogue = nil
		end
	end
end

DialogueSystemSubtitle.create_subtitle = function (self, currently_playing_subtitle, speaker_name, duration, optional_delay)
	local dialogue = {}

	dialogue.currently_playing_subtitle = currently_playing_subtitle
	dialogue.speaker_name = speaker_name
	dialogue.duration = duration
	dialogue.is_audible = true

	if optional_delay then
		self._subtitle_delay = optional_delay
		self._cached_dialogue = dialogue
	else
		self:add_playing_localized_dialogue(speaker_name, dialogue)
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
