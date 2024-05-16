-- chunkname: @scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup_settings.lua

local hud_element_mission_speaker_popup_settings = {
	animation_in_duration = 0.5,
	animation_out_duration = 0.3,
	bar_amount = 7,
	bar_spacing = 10,
	bar_size = {
		12,
		30,
	},
	bar_offset = {
		-65,
		0,
		0,
	},
	portrait_size = {
		80,
		90,
	},
}

return settings("HudElementMissionSpeakerPopupSettings", hud_element_mission_speaker_popup_settings)
