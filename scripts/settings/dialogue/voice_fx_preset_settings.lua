-- chunkname: @scripts/settings/dialogue/voice_fx_preset_settings.lua

local voice_fx_preset_settings = {
	voice_fx_rtpc_common = 10,
	voice_fx_rtpc_common_cloth_filter = 11,
	voice_fx_rtpc_common_filter = 10,
	voice_fx_rtpc_common_filter_metal = 10,
	voice_fx_rtpc_common_krieg = 10,
	voice_fx_rtpc_common_metal = 10,
	voice_fx_rtpc_common_tubes = 10,
	voice_fx_rtpc_epic = 30,
	voice_fx_rtpc_epic_cloth_filter = 11,
	voice_fx_rtpc_epic_enforcer = 30,
	voice_fx_rtpc_epic_filter = 30,
	voice_fx_rtpc_epic_metal = 30,
	voice_fx_rtpc_epic_psyker_collar = 35,
	voice_fx_rtpc_epic_speaker_robo = 50,
	voice_fx_rtpc_epic_tubes = 30,
	voice_fx_rtpc_epic_voice_box_pitch = 40,
	voice_fx_rtpc_none = 0,
	voice_fx_rtpc_rare = 20,
	voice_fx_rtpc_rare_cloth_filter = 11,
	voice_fx_rtpc_rare_ecclesiarchy_metal = 20,
	voice_fx_rtpc_rare_filter = 20,
	voice_fx_rtpc_rare_filter_metal = 20,
	voice_fx_rtpc_rare_genstealer_metal = 20,
	voice_fx_rtpc_rare_tubes = 20,
	voice_fx_rtpc_robo_a = 50,
	voice_fx_rtpc_voice_box_a = 40,
}

return settings("VoiceFxPresetSettings", voice_fx_preset_settings)
