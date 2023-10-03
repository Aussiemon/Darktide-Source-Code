local BreedSettings = require("scripts/settings/breed/breed_settings")
local breed_types = BreedSettings.types
local type_player = breed_types.player
local type_minion = breed_types.minion
local type_living_prop = breed_types.living_prop
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
	end,
	is_living_prop = function (breed_or_nil)
		return breed_or_nil and breed_or_nil.breed_type == type_living_prop
	end
}

Breed.count_as_character = function (breed_or_nil)
	if Breed.is_character(breed_or_nil) then
		return true
	end

	return breed_or_nil and breed_or_nil.breed_type == type_living_prop
end

Breed.enemy_type = function (breed_or_nil)
	local enemy_type = nil
	local attack_breed_tags = breed_or_nil and breed_or_nil.tags

	if attack_breed_tags and attack_breed_tags.elite then
		enemy_type = "elite"
	elseif attack_breed_tags and attack_breed_tags.special then
		enemy_type = "special"
	elseif attack_breed_tags and attack_breed_tags.monster then
		enemy_type = "monster"
	elseif attack_breed_tags and attack_breed_tags.captain then
		enemy_type = "captain"
	end

	return enemy_type
end

Breed.unit_breed_or_nil = function (unit)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_extension then
		return nil
	end

	return unit_data_extension:breed()
end

return Breed
