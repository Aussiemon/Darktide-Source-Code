-- chunkname: @scripts/utilities/breed.lua

local BreedSettings = require("scripts/settings/breed/breed_settings")
local breed_types = BreedSettings.types
local TYPE_COMPANION = breed_types.companion
local TYPE_LIVING_PROP = breed_types.living_prop
local TYPE_MINION = breed_types.minion
local TYPE_OBJECTIVE_PROP = breed_types.objective_prop
local TYPE_PLAYER = breed_types.player
local TYPE_PROP = breed_types.prop
local Breed = {}

Breed.height = function (unit, breed)
	if breed.breed_type == TYPE_PLAYER then
		local first_person_extension = ScriptUnit.has_extension(unit, "first_person_system")

		if first_person_extension then
			return first_person_extension:extrapolated_character_height()
		end

		return breed.heights.default
	else
		local base_height = breed.base_height
		local scale = Unit.local_scale(unit, 1)
		local vertical_scale = scale.z
		local height = vertical_scale * base_height

		return height
	end
end

Breed.is_character = function (breed_or_nil)
	if not breed_or_nil then
		return false
	end

	local breed_type = breed_or_nil.breed_type

	return breed_type == TYPE_PLAYER or breed_type == TYPE_MINION
end

Breed.is_player = function (breed_or_nil)
	return breed_or_nil and breed_or_nil.breed_type == TYPE_PLAYER
end

Breed.is_minion = function (breed_or_nil)
	return breed_or_nil and breed_or_nil.breed_type == TYPE_MINION
end

Breed.is_companion = function (breed_or_nil)
	return breed_or_nil and breed_or_nil.breed_type and breed_or_nil.breed_type == TYPE_COMPANION
end

Breed.is_prop = function (breed_or_nil)
	local breed_type = breed_or_nil and breed_or_nil.breed_type

	return breed_type == TYPE_PROP or breed_type == TYPE_OBJECTIVE_PROP
end

Breed.is_living_prop = function (breed_or_nil)
	return breed_or_nil and breed_or_nil.breed_type == TYPE_LIVING_PROP
end

Breed.is_objective_prop = function (breed_or_nil)
	return breed_or_nil and breed_or_nil.breed_type == TYPE_OBJECTIVE_PROP
end

Breed.count_as_character = function (breed_or_nil)
	if Breed.is_character(breed_or_nil) then
		return true
	end

	local breed_type = breed_or_nil and breed_or_nil.breed_type

	return breed_type == TYPE_LIVING_PROP or breed_type == TYPE_OBJECTIVE_PROP
end

Breed.enemy_type = function (breed_or_nil)
	local enemy_type
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

Breed.human_sized = function (breed_or_nil)
	if not breed_or_nil then
		return false
	end

	local attack_breed_tags = breed_or_nil.tags

	if attack_breed_tags and (attack_breed_tags.ogryn or attack_breed_tags.monster) then
		return false
	end

	return true
end

Breed.unit_breed_or_nil = function (unit)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_extension then
		return nil
	end

	return unit_data_extension:breed()
end

return Breed
