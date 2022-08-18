local BreedSettings = require("scripts/settings/breed/breed_settings")
local breed_types = BreedSettings.types
local type_player = breed_types.player
local type_minion = breed_types.minion
local type_prop = breed_types.prop
local Breed = {
	height = function (unit, breed)
		if breed.breed_type == type_player then
			return breed.heights.default
		else
			local base_height = breed.base_height
			local scale = Unit.local_scale(unit, 1)
			local vertical_scale = scale.z
			local height = vertical_scale * base_height

			return height
		end
	end,
	is_character = function (breed_or_nil)
		if not breed_or_nil then
			return false
		end

		local breed_type = breed_or_nil.breed_type

		return breed_type == type_player or breed_type == type_minion
	end,
	is_player = function (breed_or_nil)
		return breed_or_nil and breed_or_nil.breed_type == type_player
	end,
	is_minion = function (breed_or_nil)
		return breed_or_nil and breed_or_nil.breed_type == type_minion
	end,
	is_prop = function (breed_or_nil)
		return breed_or_nil and breed_or_nil.breed_type == type_prop
	end
}

return Breed
