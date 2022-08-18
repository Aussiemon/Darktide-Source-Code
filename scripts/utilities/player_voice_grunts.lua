local PlayerVoiceGrunts = {
	SOURCE_NAME = "voice"
}
local SOURCE_NAME = PlayerVoiceGrunts.SOURCE_NAME

PlayerVoiceGrunts.create_voice = function (fx_extension, unit, node_name)
	local attachments = {
		unit
	}

	fx_extension:register_sound_source(SOURCE_NAME, unit, attachments, node_name)
end

PlayerVoiceGrunts.destroy_voice = function (fx_extension)
	fx_extension:unregister_sound_source(SOURCE_NAME)
end

PlayerVoiceGrunts.voice_source = function (fx_extension)
	return fx_extension:sound_source(PlayerVoiceGrunts.SOURCE_NAME)
end

PlayerVoiceGrunts.set_voice = function (wwise_world, source, switch_group, selected_voice, selected_fx_preset)
	WwiseWorld.set_switch(wwise_world, switch_group, selected_voice, source)

	if selected_fx_preset then
		WwiseWorld.set_source_parameter(wwise_world, source, "voice_fx_preset", selected_fx_preset)
	end
end

PlayerVoiceGrunts.trigger_sound = function (sound_alias, visual_loadout_extension, fx_extension)
	local resolved, event_name, append_husk_to_event_name = visual_loadout_extension:resolve_gear_sound(sound_alias)

	if resolved then
		fx_extension:trigger_voice_wwise_event_with_source(event_name, SOURCE_NAME, append_husk_to_event_name)
	end
end

local temp_voice_data = {}

PlayerVoiceGrunts.voice_data = function (unit)
	local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
	local wwise_switch_group, selected_voice, voice_fx_preset = dialogue_extension:voice_data()
	temp_voice_data.switch_group = wwise_switch_group
	temp_voice_data.selected_voice = selected_voice
	temp_voice_data.selected_voice_fx_preset = voice_fx_preset

	return temp_voice_data
end

return PlayerVoiceGrunts
