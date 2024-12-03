-- chunkname: @scripts/extension_systems/shield/minion_husk_shield_extension.lua

local Breed = require("scripts/utilities/breed")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionHuskShieldExtension = class("MinionHuskShieldExtension")

MinionHuskShieldExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local breed = extension_init_data.breed

	self._template = breed.shield_template
	self._unit = unit
	self._game_session = game_session
	self._game_object_id = game_object_id
end

MinionHuskShieldExtension.add_damage = function (self, damage_amount, damage_profile, attacking_unit)
	local remaining_damage, absorbed_attack = damage_amount, false
	local can_block_attack = self:can_block_attack(damage_profile, attacking_unit)

	if can_block_attack then
		remaining_damage, absorbed_attack = 0, true
	end

	return remaining_damage, absorbed_attack
end

MinionHuskShieldExtension.can_block_attack = function (self, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor)
	if damage_profile.ignore_shield or not attacking_unit then
		return false
	end

	local attacking_owner_unit_data_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "unit_data_system")

	if attacking_owner_unit_data_extension == nil then
		return false
	end

	local unit, attacking_owner_breed = self._unit, attacking_owner_unit_data_extension:breed()
	local side_system = Managers.state.extension:system("side_system")

	if Breed.is_minion(attacking_owner_breed) and side_system:is_ally(unit, attacking_unit_owner_unit) then
		return true
	end

	local hit_zone = hit_actor and HitZone.get(unit, hit_actor)
	local hit_zone_name = hit_zone and hit_zone.name
	local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
	local can_block_from_position = self:can_block_from_position(attacking_unit_position, hit_zone_name)

	return can_block_from_position
end

MinionHuskShieldExtension.can_block_from_position = function (self, attacking_unit_position, hit_zone_name)
	local is_blocking = GameSession.game_object_field(self._game_session, self._game_object_id, "is_blocking")

	if not is_blocking then
		return false
	end

	if hit_zone_name and hit_zone_name == "shield" then
		return true
	end

	return false
end

MinionHuskShieldExtension.is_blocking = function (self)
	local is_blocking = GameSession.game_object_field(self._game_session, self._game_object_id, "is_blocking")

	return is_blocking
end

return MinionHuskShieldExtension
