-- chunkname: @scripts/settings/fx/player_character_fx_source_names.lua

local Breed = require("scripts/utilities/breed")
local Breeds = require("scripts/settings/breed/breeds")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local player_character_fx_source_names = {}

do
	local wieldable_slots = {}
	local slot_configuration = PlayerCharacterConstants.slot_configuration

	for slot_name, config in pairs(slot_configuration) do
		if config.wieldable and config.slot_type ~= "unarmed" then
			wieldable_slots[#wieldable_slots + 1] = slot_name
		end
	end

	local num_wieldable_slots = #wieldable_slots

	for name, template in pairs(WeaponTemplates) do
		local fx_sources = template.fx_sources

		if fx_sources then
			for source_ending, _ in pairs(fx_sources) do
				for i = 1, num_wieldable_slots do
					local slot_name = wieldable_slots[i]
					local source_name = string.format("%s%s", slot_name, source_ending)

					player_character_fx_source_names[source_name] = true
				end
			end
		end
	end

	for name, breed in pairs(Breeds) do
		local base_unit_sound_sources = breed.base_unit_sound_sources

		if Breed.is_player(breed) and base_unit_sound_sources then
			for source_name, _ in pairs(base_unit_sound_sources) do
				player_character_fx_source_names[source_name] = true
			end
		end
	end

	for name, breed in pairs(Breeds) do
		local base_unit_fx_sources = breed.base_unit_fx_sources

		if Breed.is_player(breed) and base_unit_fx_sources then
			for source_name, _ in pairs(base_unit_fx_sources) do
				player_character_fx_source_names[source_name] = true
			end
		end
	end

	player_character_fx_source_names[PlayerVoiceGrunts.SOURCE_NAME] = true
end

return player_character_fx_source_names
