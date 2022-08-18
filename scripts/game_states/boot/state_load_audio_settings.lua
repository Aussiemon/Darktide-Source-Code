require("scripts/game_states/boot/state_boot_sub_state_base")

local sound_settings = require("scripts/settings/options/sound_settings")
local StateLoadAudioSettings = class("StateLoadAudioSettings", "StateBootSubStateBase")

StateLoadAudioSettings._state_update = function (self, dt)
	local settings = sound_settings.settings

	self:_apply_audio_settings(settings)

	local error = false
	local done = true

	return done, error
end

StateLoadAudioSettings._apply_audio_settings = function (self, settings)
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

return StateLoadAudioSettings
