-- chunkname: @scripts/settings/dialogue/dialogue_lookup_voice_profiles.lua

local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local VoiceProfileLookup = {}

for _, breed in pairs(DialogueBreedSettings) do
	local wwise_voices = type(breed) ~= "function" and breed.wwise_voices or nil

	if wwise_voices ~= nil then
		for _, voice in pairs(wwise_voices) do
			VoiceProfileLookup[voice] = true
		end
	end
end

return VoiceProfileLookup
