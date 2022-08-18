local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local Backstab = {}
local BACKSTAB_DOT = 0

Backstab.is_attack_backstab = function (attacked_unit, attacking_unit, attack_type, attack_direction, override_dot_check)
	local is_melee = attack_type == attack_types.melee
	local is_ranged = attack_type == attack_types.ranged

	if not is_melee and not is_ranged then
		return false
	end

	local attacking_unit_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")
	local can_melee_backstab = is_melee and attacking_unit_buff_extension and attacking_unit_buff_extension:has_keyword(keywords.melee_backstab_enabled)
	local can_ranged_backstab = is_ranged and attacking_unit_buff_extension and attacking_unit_buff_extension:has_keyword(keywords.ranged_backstab_enabled)
	local can_backstab = can_melee_backstab or can_ranged_backstab

	if not can_backstab then
		return false
	end

	local attacked_unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")

	if not attacked_unit_data_extension then
		return false
	end

	local attacked_unit_breed = attacked_unit_data_extension:breed()

	if not attacked_unit_breed then
		return false
	end

	if attack_type == attack_types.melee then
		local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
		local attacker_unit_position = POSITION_LOOKUP[attacked_unit]
		attack_direction = Vector3.normalize(Vector3.flat(attacker_unit_position - attacking_unit_position))
	end

	local attacked_unit_forward = nil

	if Breed.is_player(attacked_unit_breed) then
		local first_person_component = attacked_unit_data_extension:read_component("first_person")
		local look_rotation = first_person_component.rotation
		attacked_unit_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))
	else
		local attacked_unit_rotation = Unit.world_rotation(attacked_unit, 1)
		attacked_unit_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(attacked_unit_rotation)))
	end

	local dot = Vector3.dot(attack_direction, attacked_unit_forward)
	local dot_threshold = override_dot_check or BACKSTAB_DOT
	local is_backstab = dot_threshold < dot

	return is_backstab
end

return Backstab
