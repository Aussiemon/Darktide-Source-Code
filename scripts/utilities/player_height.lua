-- chunkname: @scripts/utilities/player_height.lua

local BreedSettings = require("scripts/settings/breed/breed_settings")
local BASE_BODY_SIZE_HEIGHTS = BreedSettings.base_player_body_size_heights
local PlayerHeight = {}

local function _random_seeded_size_scale(seed, size_variation_range)
	local _, random_percentage = math.next_random(seed)
	local scale = math.lerp(size_variation_range[1], size_variation_range[2], random_percentage)

	return scale
end

PlayerHeight.player_character_third_person_scale = function (breed, profile, random_seed)
	local profile_character_height = profile.personal and profile.personal.character_height
	local size_variation_range = breed.size_variation_range
	local scale = 1

	if profile_character_height then
		local heights = breed.heights
		local default_height = heights.default
		local scaled_default_height = default_height * profile_character_height
		local body_size = breed.body_size
		local is_ogryn_sized = body_size == "ogryn_sized"
		local wanted_body_size_height = is_ogryn_sized and BASE_BODY_SIZE_HEIGHTS.ogryn_sized or BASE_BODY_SIZE_HEIGHTS.human_sized
		local scale_relative_to_body_size_height = scaled_default_height / wanted_body_size_height

		scale = scale_relative_to_body_size_height
	elseif size_variation_range and random_seed then
		scale = _random_seeded_size_scale(random_seed, size_variation_range)
	end

	return scale
end

PlayerHeight.player_character_first_person_heights = function (breed, profile, random_seed)
	local third_person_scale = PlayerHeight.player_character_third_person_scale(breed, profile, random_seed)
	local heights = breed.heights
	local num_heights = table.size(heights)
	local first_person_heights = Script.new_map(num_heights)

	for name, height in pairs(heights) do
		first_person_heights[name] = height * third_person_scale
	end

	return first_person_heights
end

return PlayerHeight
