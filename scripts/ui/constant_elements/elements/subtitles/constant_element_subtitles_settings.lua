-- chunkname: @scripts/ui/constant_elements/elements/subtitles/constant_element_subtitles_settings.lua

local constant_element_subtitles_settings = {
	events = {
		{
			"event_player_authenticated",
			"event_player_authenticated",
		},
		{
			"event_update_subtitles_enabled",
			"event_update_subtitles_enabled",
		},
		{
			"event_update_subtitles_font_size",
			"event_update_subtitles_font_size",
		},
		{
			"event_update_secondary_subtitles_enabled",
			"event_update_secondary_subtitles_enabled",
		},
		{
			"event_update_secondary_subtitles_font_size",
			"event_update_secondary_subtitles_font_size",
		},
		{
			"event_update_subtitle_text_opacity",
			"event_update_subtitle_text_opacity",
		},
		{
			"event_update_subtitle_speaker_enabled",
			"event_update_subtitle_speaker_enabled",
		},
		{
			"event_update_subtitles_background_opacity",
			"event_update_subtitles_background_opacity",
		},
	},
}

return settings("ConstantElementSubtitlesSettings", constant_element_subtitles_settings)
