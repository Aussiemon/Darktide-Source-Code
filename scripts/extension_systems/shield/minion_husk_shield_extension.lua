local Breed = require("scripts/utilities/breed")
local MinionHuskShieldExtension = class("MinionHuskShieldExtension")

MinionHuskShieldExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local breed = extension_init_data.breed
	self._template = breed.shield_template
	self._unit = unit
	self._game_session = game_session
	self._game_object_id = game_object_id
end

MinionHuskShieldExtension.add_damage = function (self, damage_amount, damage_profile, attacking_unit)
	local remaining_damage = damage_amount
	local absorbed_attack = false
	local can_block_attack = self:can_block_attack(damage_profile, attacking_unit)

	if can_block_attack then
		absorbed_attack = true
		remaining_damage = 0
	end

	return remaining_damage, absorbed_attack
end

MinionHuskShieldExtension.can_block_attack = function (self, damage_profile, attacking_unit, attacking_unit_owner_unit)
	if damage_profile.ignore_shield or not attacking_unit then
		return false
	end

	local attacking_owner_unit_data_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "unit_data_system")

	if attacking_owner_unit_data_extension == nil then
		return false
	end

	local breed = attacking_owner_unit_data_extension:breed()

	if Breed.is_minion(breed) then
		return true
	end

	local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
	local can_block_from_position = self:can_block_from_position(attacking_unit_position)

	return can_block_from_position
end

MinionHuskShieldExtension.can_block_from_position = function (self, attacking_unit_position)
	local is_blocking = GameSession.game_object_field(self._game_session, self._game_object_id, "is_blocking")

	if not is_blocking then
		return false
	end

	local blocking_angle = self._template.blocking_angle
	local unit = self._unit
	local unit_rotation = Unit.local_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local unit_position = POSITION_LOOKUP[unit]
	local to_attacking_unit = Vector3.normalize(attacking_unit_position - unit_position)
	local angle = Vector3.angle(unit_forward, to_attacking_unit)
	local is_within_blocking_angle = angle < blocking_angle

	return is_within_blocking_angle
end

return MinionHuskShieldExtension
