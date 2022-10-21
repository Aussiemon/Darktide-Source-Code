local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local _is_outmanoeuvring = nil
local BACKSTAB_DOT_THRESHOLD = 0.5
local FLANK_DOT_THRESHOLD = 0
local AttackPositioning = {
	is_backstabbing = function (attacked_unit, attacking_unit, attack_type)
		if attack_type ~= attack_types.melee then
			return
		end

		local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
		local attacker_unit_position = POSITION_LOOKUP[attacked_unit]
		local attack_direction = Vector3.normalize(Vector3.flat(attacker_unit_position - attacking_unit_position))

		return _is_outmanoeuvring(attacked_unit, attacking_unit, keywords.allow_backstabbing, attack_direction, BACKSTAB_DOT_THRESHOLD)
	end,
	is_flanking = function (attacked_unit, attacking_unit, attack_type, attack_direction)
		if attack_type ~= attack_types.ranged then
			return
		end

		return _is_outmanoeuvring(attacked_unit, attacking_unit, keywords.allow_flanking, attack_direction, FLANK_DOT_THRESHOLD)
	end
}

function _is_outmanoeuvring(attacked_unit, attacking_unit, allowed_buff_keyword, attack_direction, dot_threshold)
	local attacking_unit_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")
	local can_outmanoeuvre = attacking_unit_buff_extension and attacking_unit_buff_extension:has_keyword(allowed_buff_keyword)

	if not can_outmanoeuvre then
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
	local is_flanking = dot_threshold < dot

	return is_flanking
end

return AttackPositioning
