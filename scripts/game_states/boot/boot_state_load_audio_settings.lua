-- chunkname: @scripts/game_states/boot/boot_state_load_audio_settings.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateLoadAudioSettings = class("BootStateLoadAudioSettings", "StateBootSubStateBase")

BootStateLoadAudioSettings._state_update = function (self, dt)
	local sound_settings = require("scripts/settings/options/sound_settings")
	local settings = sound_settings.settings

	self:_apply_audio_settings(settings)

	return true
end

BootStateLoadAudioSettings._apply_audio_settings = function (self, settings)
	if not DEDICATED_SERVER then
		for _, setting in ipairs(settings) do
			local get_function = setting.get_function

			if get_function then
				local value = get_function()

				if value ~= nil then
					local commit = setting.commit

					if commit then
						commit(value)
					end
				end
			end
		end
	end
end

return BootStateLoadAudioSettings
