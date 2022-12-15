local OptionsUtilities = require("scripts/utilities/ui/options")

local function get_user_setting(location, key)
	if location then
		return Application.user_setting(location, key)
	else
		return Application.user_setting(key)
	end
end

local function set_user_setting(location, key, value)
	if location then
		Application.set_user_setting(location, key, value)
	else
		Application.set_user_setting(key, value)
	end
end

local function _is_same(current, new)
	if current == new then
		return true
	elseif type(current) == "table" and type(new) == "table" then
		for k, v in pairs(current) do
			if new[k] ~= v then
				return false
			end
		end

		for k, v in pairs(new) do
			if current[k] ~= v then
				return false
			end
		end

		return true
	else
		return false
	end
end

local function construct_audio_settings_dropdown(template)
	local entry = {
		default_value = template.default_value,
		display_name = template.display_name,
		options = template.options,
		commit = template.commit,
		indentation_level = template.indentation_level,
		tooltip_text = template.tooltip_text,
		disable_rules = template.disable_rules
	}
	local id = template.id
	local save_location = template.save_location
	local default_value = template.default_value

	entry.on_activated = function (new_value)
		local current_value = get_user_setting(save_location, id)

		if current_value == nil then
			current_value = default_value
		end

		if not _is_same(current_value, new_value) then
			entry.commit(new_value)
			set_user_setting(save_location, id, new_value)
			Application.save_user_settings()
		end
	end

	entry.get_function = function ()
		local old_value = get_user_setting(save_location, id)

		if old_value == nil then
			return default_value
		else
			return old_value
		end
	end

	return entry
end

local function construct_audio_settings_boolean(template)
	local entry = {
		default_value = template.default_value,
		display_name = template.display_name,
		indentation_level = template.indentation_level,
		tooltip_text = template.tooltip_text,
		disable_rules = template.disable_rules,
		commit = template.commit
	}
	local id = template.id
	local save_location = template.save_location
	local default_value = template.default_value

	entry.get_function = function ()
		local old_value = get_user_setting(save_location, id)

		if old_value == nil then
			return default_value
		else
			return old_value
		end
	end

	entry.on_activated = function (new_value)
		local current_value = get_user_setting(save_location, id)

		if current_value == nil then
			current_value = default_value
		end

		if not _is_same(current_value, new_value) then
			entry.commit(new_value)
			set_user_setting(save_location, id, new_value)
			Application.save_user_settings()
		end
	end

	return entry
end

local settings = {
	[#settings + 1] = {
		group_name = "sound_volume",
		display_name = "loc_settings_menu_group_volume",
		widget_type = "group_header"
	}
}
local default_sound_volume = 100
local default_sound_chat_volume = 70
local master_volume_value_name = "option_master_slider"
local master_volume_display_name = "loc_settings_master_volume"

local function master_volume_value_change_function(value)
	Wwise.set_parameter(master_volume_value_name, value)
	Application.set_user_setting("sound_settings", master_volume_value_name, value)
	Application.save_user_settings()
end

local function master_volume_value_get_function()
	return Application.user_setting("sound_settings", master_volume_value_name) or default_sound_volume
end

local master_volume_slider_params = {
	apply_on_drag = true,
	display_name = master_volume_display_name,
	default_value = default_sound_volume,
	value_get_function = master_volume_value_get_function,
	on_value_changed_function = master_volume_value_change_function
}
local master_volume_template = OptionsUtilities.create_percent_slider_template(master_volume_slider_params)

master_volume_template.commit = function (value)
	Wwise.set_parameter(master_volume_value_name, value)
end

settings[#settings + 1] = master_volume_template
local sfx_volume_value_name = "options_sfx_slider"
local sfx_volume_display_name = "loc_settings_sfx_volume"

local function sfx_volume_value_change_function(value)
	Wwise.set_parameter(sfx_volume_value_name, value)
	Application.set_user_setting("sound_settings", sfx_volume_value_name, value)
	Application.save_user_settings()
end

local function sfx_volume_value_get_function()
	return Application.user_setting("sound_settings", sfx_volume_value_name) or default_sound_volume
end

local sfx_volume_slider_params = {
	apply_on_drag = true,
	display_name = sfx_volume_display_name,
	default_value = default_sound_volume,
	value_get_function = sfx_volume_value_get_function,
	on_value_changed_function = sfx_volume_value_change_function
}
local sfx_volume_template = OptionsUtilities.create_percent_slider_template(sfx_volume_slider_params)

sfx_volume_template.commit = function (value)
	Wwise.set_parameter(sfx_volume_value_name, value)
end

settings[#settings + 1] = sfx_volume_template
local music_volume_value_name = "options_music_slider"
local music_volume_display_name = "loc_settings_music_volume"

local function music_volume_value_change_function(value)
	Wwise.set_parameter(music_volume_value_name, value)
	Application.set_user_setting("sound_settings", music_volume_value_name, value)
	Application.save_user_settings()
end

local function music_volume_value_get_function()
	return Application.user_setting("sound_settings", music_volume_value_name) or default_sound_volume
end

local music_volume_slider_params = {
	apply_on_drag = true,
	display_name = music_volume_display_name,
	default_value = default_sound_volume,
	value_get_function = music_volume_value_get_function,
	on_value_changed_function = music_volume_value_change_function
}
local music_volume_template = OptionsUtilities.create_percent_slider_template(music_volume_slider_params)

music_volume_template.commit = function (value)
	Wwise.set_parameter(music_volume_value_name, value)
end

settings[#settings + 1] = music_volume_template
local speaker_settings = {
	display_name = "loc_setting_speaker_settings",
	id = "speaker_settings",
	default_value = 3,
	save_location = "sound_settings",
	options = {
		{
			id = 0,
			display_name = "loc_setting_speaker_auto_detect",
			values = {
				audio_settings = {
					speaker_settings = 0
				}
			}
		},
		{
			id = 1,
			display_name = "loc_setting_speaker_five_one",
			values = {
				audio_settings = {
					speaker_settings = 1
				}
			}
		},
		{
			id = 2,
			display_name = "loc_setting_speaker_stereo",
			values = {
				audio_settings = {
					speaker_settings = 2
				}
			}
		},
		{
			id = 3,
			display_name = "loc_setting_speaker_stereo_headphones",
			values = {
				audio_settings = {
					speaker_settings = 3
				}
			}
		},
		{
			id = 4,
			display_name = "loc_setting_speaker_mono",
			values = {
				audio_settings = {
					speaker_settings = 4
				}
			}
		}
	},
	commit = function (value)
		local PANNING_RULE_SPEAKERS = 0
		local PANNING_RULE_HEADPHONES = 1
		local mastering_bus_name = "MIX_BUS"

		if value == 0 then
			Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
			Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_AUTO)
		elseif value == 1 then
			Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
			Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_5POINT1)
		elseif value == 2 then
			Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
			Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_STEREO)
		elseif value == 3 then
			Wwise.set_panning_rule(PANNING_RULE_HEADPHONES)
			Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_STEREO)
		elseif value == 4 then
			Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
			Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_MONO)
		end
	end
}
local mix_presets_settings = {
	display_name = "loc_setting_mix_presets",
	id = "mix_preset",
	default_value = 1,
	save_location = "sound_settings",
	options = {
		{
			id = 0,
			display_name = "loc_setting_mix_preset_hi_fi",
			values = {
				sound_settings = {
					mix_preset = 0
				}
			}
		},
		{
			id = 1,
			display_name = "loc_setting_mix_preset_flat",
			values = {
				sound_settings = {
					mix_preset = 1
				}
			}
		},
		{
			id = 2,
			display_name = "loc_setting_mix_preset_nightmode",
			values = {
				sound_settings = {
					mix_preset = 2
				}
			}
		},
		{
			id = 3,
			display_name = "loc_setting_mix_preset_dakka_dakka",
			values = {
				sound_settings = {
					mix_preset = 3
				}
			}
		}
	},
	commit = function (value)
		local parameter_name = "dynamic_range"

		Wwise.set_parameter(parameter_name, value)
	end
}

local function get_dialogue_wwise_value(value)
	local setting_value = "neutral"

	if value > 0 then
		setting_value = string.format("plus_%d", value)
	elseif value < 0 then
		setting_value = string.format("minus_%d", math.abs(value))
	end

	return setting_value
end

local dialogue_volume_value_name = "options_vo_trim"
local dialogue_volume_display_name = "loc_audio_volume_settings_dialogue"
local default_volume_default_value = 0

local function dialogue_volume_value_change_function(value)
	local setting_value = get_dialogue_wwise_value(value)

	Wwise.set_state(dialogue_volume_value_name, setting_value)
	Application.set_user_setting("sound_settings", dialogue_volume_value_name, value)
	Application.save_user_settings()
end

local function dialogue_volume_value_get_function()
	return Application.user_setting("sound_settings", dialogue_volume_value_name) or default_volume_default_value
end

local dialogue_volume_slider_params = {
	min_value = -5,
	step_size_value = 1,
	max_value = 5,
	apply_on_drag = true,
	display_name = dialogue_volume_display_name,
	default_value = default_volume_default_value,
	value_get_function = dialogue_volume_value_get_function,
	on_value_changed_function = dialogue_volume_value_change_function,
	format_value_function = function (value)
		return string.format("%d dB", value)
	end
}
local dialogue_volume_template = OptionsUtilities.create_value_slider_template(dialogue_volume_slider_params)

dialogue_volume_template.commit = function (value)
	local setting_value = get_dialogue_wwise_value(value)

	Wwise.set_state(dialogue_volume_value_name, setting_value)
end

local game_interface_setting = {
	display_name = "loc_settings_audio_headshot_sound",
	id = "interface_setting",
	default_value = true,
	save_location = "sound_settings",
	commit = function (value)
		local options_audio_parameter_name = "options_headshot"

		if value then
			Wwise.set_state(options_audio_parameter_name, "on")
		else
			Wwise.set_state(options_audio_parameter_name, "off")
		end
	end
}
local audio_backstab_sound_setting = {
	display_name = "loc_settings_audio_backstab_sound",
	id = "backstab_setting",
	default_value = true,
	save_location = "sound_settings",
	commit = function (value)
		local options_audio_parameter_name = "options_backstab"

		if value then
			Wwise.set_state(options_audio_parameter_name, "on")
		else
			Wwise.set_state(options_audio_parameter_name, "off")
		end
	end
}
local audio_teammate_ping_setting = {
	display_name = "loc_settings_audio_teammate_ping",
	id = "teammate_ping_setting",
	default_value = true,
	save_location = "sound_settings",
	commit = function (value)
		local options_audio_parameter_name = "options_teammate_ping"

		if value then
			Wwise.set_state(options_audio_parameter_name, "on")
		else
			Wwise.set_state(options_audio_parameter_name, "off")
		end
	end
}
local audio_voice_fx_setting = {
	display_name = "loc_settings_audio_headgear_voice_effect",
	id = "voice_fx_setting",
	default_value = true,
	save_location = "sound_settings",
	commit = function (value)
		local options_audio_parameter_name = "options_voice_fx"

		if value then
			Wwise.set_state(options_audio_parameter_name, "on")
		else
			Wwise.set_state(options_audio_parameter_name, "off")
		end
	end
}
settings[#settings + 1] = {
	group_name = "audio_settings",
	display_name = "loc_settings_menu_group_audio_settings",
	widget_type = "group_header"
}
settings[#settings + 1] = construct_audio_settings_dropdown(speaker_settings)
settings[#settings + 1] = construct_audio_settings_dropdown(mix_presets_settings)
settings[#settings + 1] = dialogue_volume_template
settings[#settings + 1] = construct_audio_settings_boolean(game_interface_setting)
settings[#settings + 1] = construct_audio_settings_boolean(audio_backstab_sound_setting)
settings[#settings + 1] = construct_audio_settings_boolean(audio_teammate_ping_setting)
settings[#settings + 1] = construct_audio_settings_boolean(audio_voice_fx_setting)
settings[#settings + 1] = {
	group_name = "voice_chat_settings",
	display_name = "loc_settings_menu_group_voice_chat_settings",
	widget_type = "group_header"
}
local chat_volume_value_name = "options_voip_volume_slider"
local chat_volume_display_name = "loc_settings_audio_voice_chat_volume"

local function chat_volume_value_change_function(value)
	Wwise.set_parameter(chat_volume_value_name, value)
	Application.set_user_setting("sound_settings", chat_volume_value_name, value)
	Application.save_user_settings()

	if Managers.chat then
		Managers.chat:mic_volume_changed()
	end
end

local function chat_volume_value_get_function()
	return Application.user_setting("sound_settings", chat_volume_value_name) or default_sound_volume
end

local chat_volume_slider_params = {
	apply_on_drag = false,
	display_name = chat_volume_display_name,
	default_value = default_sound_chat_volume,
	value_get_function = chat_volume_value_get_function,
	on_value_changed_function = chat_volume_value_change_function
}
local chat_volume_template = OptionsUtilities.create_percent_slider_template(chat_volume_slider_params)

chat_volume_template.commit = function (value)
	Wwise.set_parameter(chat_volume_value_name, value)

	if Managers.chat then
		Managers.chat:mic_volume_changed()
	end
end

settings[#settings + 1] = chat_volume_template
local voice_chat_settings = {
	display_name = "loc_setting_voice_chat_presets",
	id = "voice_chat",
	default_value = 2,
	save_location = "sound_settings",
	options = {
		{
			id = 0,
			display_name = "loc_setting_voice_chat_presets_mic_muted",
			values = {
				sound_settings = {
					voice_chat_preset = 0
				}
			}
		},
		{
			id = 1,
			display_name = "loc_setting_voice_chat_presets_mic_voice_activated",
			values = {
				sound_settings = {
					voice_chat_preset = 1
				}
			}
		},
		{
			id = 2,
			display_name = "loc_setting_voice_chat_presets_mic_push_to_talk",
			values = {
				sound_settings = {
					voice_chat_preset = 2
				}
			}
		}
	},
	commit = function (value)
		if Managers.chat then
			local mute = value == 0 or value == 2

			Managers.chat:mute_local_mic(mute)
		end
	end
}
settings[#settings + 1] = construct_audio_settings_dropdown(voice_chat_settings)

return {
	icon = "content/ui/materials/icons/system/settings/category_audio",
	display_name = "loc_settings_menu_category_sound",
	settings = settings
}
