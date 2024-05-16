-- chunkname: @scripts/settings/dialogue/voice_fx_preset_settings.lua

local voice_fx_preset_settings = {
	Voice_fx_rtpc_voice_box_b = 6,
	voice_fx_rtpc_common = 1,
	voice_fx_rtpc_epic = 3,
	voice_fx_rtpc_none = 0,
	voice_fx_rtpc_rare = 2,
	voice_fx_rtpc_robo_a = 5,
	voice_fx_rtpc_voice_box_a = 4,
}

return settings("VoiceFxPresetSettings", voice_fx_preset_settings)
