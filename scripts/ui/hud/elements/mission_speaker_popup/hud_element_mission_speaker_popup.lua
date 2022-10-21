local Definitions = require("scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup_definitions")
local HudElementMissionSpeakerPopupSettings = require("scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local dialogue_breed_settings = require("scripts/settings/dialogue/dialogue_breed_settings")
local HudElementMissionSpeakerPopup = class("HudElementMissionSpeakerPopup", "HudElementBase")

HudElementMissionSpeakerPopup.init = function (self, parent, draw_layer, start_scale)
	HudElementMissionSpeakerPopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	local num_bars = HudElementMissionSpeakerPopupSettings.bar_amount
	local bar_offset = HudElementMissionSpeakerPopupSettings.bar_offset
	local bar_size = HudElementMissionSpeakerPopupSettings.bar_size
	local bar_spacing = HudElementMissionSpeakerPopupSettings.bar_spacing
	local bar_widgets = {}

	for i = 1, num_bars do
		local name = "bar_" .. i
		local widget = self._widgets_by_name[name]
		widget.offset = {
			bar_offset[1] - (bar_size[1] + bar_spacing) * (i - 1),
			bar_offset[2],
			bar_offset[3]
		}
		bar_widgets[i] = widget
	end

	self._bar_widgets = bar_widgets
end

HudElementMissionSpeakerPopup.destroy = function (self)
	HudElementMissionSpeakerPopup.super.destroy(self)
end

HudElementMissionSpeakerPopup.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	self:_sync_active_speaker(dt, t, ui_renderer, render_settings, input_service)
	HudElementMissionSpeakerPopup.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._popup_animation_id and not self:_is_animation_active(self._popup_animation_id) then
		self._popup_animation_id = nil
	end

	local bar_timer = self._bar_timer or 0

	if bar_timer <= 0 then
		self:_update_bar_value(dt)

		bar_timer = 0.1
	else
		bar_timer = bar_timer - dt
	end

	self._bar_timer = bar_timer
end

HudElementMissionSpeakerPopup._update_bar_value = function (self, dt)
	local bar_widgets = self._bar_widgets
	local num_bars = #bar_widgets
	local next_bar_index = math.index_wrapper((self._previous_bar_index or 0) + 1, num_bars)
	local anim_progress = math.min((1 + math.sin(Application.time_since_launch() * 6) * 0.5) * math.random_range(0.3, 0.8), 1)
	local bar_size = HudElementMissionSpeakerPopupSettings.bar_size
	local bar_height = bar_size[2]

	for i = num_bars, 1, -1 do
		local new_bar_height = nil

		if i > 1 then
			new_bar_height = bar_widgets[i - 1].style.bar.size[2]
		else
			new_bar_height = bar_height * anim_progress
		end

		local widget = bar_widgets[i]
		widget.style.bar.size[2] = new_bar_height
	end

	self._previous_bar_index = next_bar_index
end

HudElementMissionSpeakerPopup._sync_active_speaker = function (self, dt, t, ui_renderer, render_settings, input_service)
	local dialogue_system = Managers.state.extension:system("dialogue_system")

	if not dialogue_system then
		return
	end

	local is_dialogue_playing = true
	local mission_giver_speaker_name = nil

	if is_dialogue_playing then
		local playing_dialogues_array = dialogue_system:playing_dialogues_array()
		local mission_givers_settings = dialogue_breed_settings.mission_giver
		local mission_giver_voices = mission_givers_settings.wwise_voices

		for i = 1, #playing_dialogues_array do
			local currently_playing = playing_dialogues_array[i]
			local current_speaker_name = currently_playing.speaker_name

			if currently_playing.speaker_name == self._speaker_name then
				mission_giver_speaker_name = self._speaker_name

				break
			end

			if table.contains(mission_giver_voices, current_speaker_name) then
				mission_giver_speaker_name = currently_playing.speaker_name
			end
		end
	end

	if mission_giver_speaker_name ~= self._speaker_name then
		self._speaker_name = mission_giver_speaker_name

		self:_mission_speaker_stop()

		self._is_speaking = false
	else
		return
	end

	if not mission_giver_speaker_name then
		return
	end

	local speaker_voice_settings = DialogueSpeakerVoiceSettings[mission_giver_speaker_name]
	local mission_giver_icon = speaker_voice_settings and speaker_voice_settings.icon
	local mission_giver_full_name = speaker_voice_settings and speaker_voice_settings.full_name
	local mission_giver_full_name_localized = self:_localize(mission_giver_full_name)

	self:_mission_speaker_start(mission_giver_full_name_localized, mission_giver_icon)

	self._is_speaking = true
end

HudElementMissionSpeakerPopup._mission_speaker_stop = function (self)
	if self._popup_animation_id then
		self:_stop_animation(self._popup_animation_id)

		self._popup_animation_id = nil
	end

	local popup_animation_id = self:_start_animation("popup_exit", self._widgets_by_name)
	self._popup_animation_id = popup_animation_id
end

HudElementMissionSpeakerPopup._mission_speaker_start = function (self, name_text, icon)
	if self._popup_animation_id then
		self:_stop_animation(self._popup_animation_id)

		self._popup_animation_id = nil
	end

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.name_text.content.name_text = name_text

	if icon then
		widgets_by_name.popup.style.portrait.material_values.main_texture = icon or "content/ui/textures/icons/npc_portraits/mission_givers/default"
	end

	local popup_animation_id = self:_start_animation("popup_enter", self._widgets_by_name)
	self._popup_animation_id = popup_animation_id
end

HudElementMissionSpeakerPopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._popup_animation_id and not self._is_speaking then
		return
	end

	HudElementMissionSpeakerPopup.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

return HudElementMissionSpeakerPopup
