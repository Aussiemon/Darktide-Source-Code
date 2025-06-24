-- chunkname: @scripts/extension_systems/dialogue/dialogue_system_subtitle.lua

local DialogueCategoryConfig = require("scripts/settings/dialogue/dialogue_category_config")
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
	local dialogue = {
		is_audible = true,
		currently_playing_subtitle = currently_playing_subtitle,
		speaker_name = speaker_name,
		duration = duration,
	}

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

		if is_localized and dialogue.dialogue_timer ~= 3.45678 then
			table.insert(self._playing_localized_dialogues_array, 1, dialogue)
		end
	end
end

DialogueSystemSubtitle.remove_localized_dialogue = function (self, dialogue)
	local localized_index = table.index_of(self._playing_localized_dialogues_array, dialogue)
	local localized_audible_index = table.index_of(self._playing_audible_localized_dialogues_array, dialogue)

	table.remove(self._playing_localized_dialogues_array, localized_index)
	table.remove(self._playing_audible_localized_dialogues_array, localized_audible_index)
end

DialogueSystemSubtitle.add_audible_playing_localized_dialogue = function (self, dialogue)
	local index = self:subtitle_prio(dialogue)

	table.insert(self._playing_audible_localized_dialogues_array, index, dialogue)
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

DialogueSystemSubtitle.subtitle_prio = function (self, dialogue)
	local index = 1
	local category = dialogue.category

	if not category then
		return index
	end

	local category_setting = DialogueCategoryConfig[category]
	local query_score = category_setting.query_score
	local playing_audible_localized_dialogues_array = self._playing_audible_localized_dialogues_array
	local playing_prio_dialogue = playing_audible_localized_dialogues_array[#playing_audible_localized_dialogues_array]
	local highest_prio_vo = -1

	if playing_prio_dialogue then
		local playing_category = playing_prio_dialogue.category

		if playing_category then
			local playing_category_setting = DialogueCategoryConfig[playing_category]
			local playing_query_score = playing_category_setting.query_score

			highest_prio_vo = playing_query_score
		end
	end

	if highest_prio_vo < query_score then
		index = #playing_audible_localized_dialogues_array + 1
	end

	return index
end

return DialogueSystemSubtitle
