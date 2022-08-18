local Armor = require("scripts/utilities/attack/armor")
local HitMass = {}
local _target_breed, _hit_mass_from_character, _hit_mass_from_object = nil

HitMass.target_hit_mass = function (unit)
	local hit_mass = nil
	local breed = _target_breed(unit)

	if breed then
		hit_mass = _hit_mass_from_character(unit, breed)
	else
		hit_mass = _hit_mass_from_object(unit)
	end

	return hit_mass
end

HitMass.consume_hit_mass = function (unit, hit_mass_budget_attack, hit_mass_budget_impact)
	local target_hit_mass = HitMass.target_hit_mass(unit)
	local new_hit_mass_budget_attack = math.max(0, hit_mass_budget_attack - target_hit_mass)
	local new_hit_mass_budget_impact = math.max(0, hit_mass_budget_impact - target_hit_mass)

	return new_hit_mass_budget_attack, new_hit_mass_budget_impact
end

HitMass.hit_mass_limit_reached = function (hit_mass_budget_attack, hit_mass_budget_impact)
	local attack_limit_reached = hit_mass_budget_attack <= 0
	local impact_limit_reached = hit_mass_budget_impact <= 0

	return attack_limit_reached and impact_limit_reached
end

HitMass.stopped_attack = function (hit_unit, hit_zone_name_or_nil, hit_mass_budget_attack, hit_mass_budget_impact, impact_config)
	if impact_config.destroy_on_impact then
		return true
	end

	if not HEALTH_ALIVE[hit_unit] then
		return false
	end

	local max_hit_mass_reached = HitMass.hit_mass_limit_reached(hit_mass_budget_attack, hit_mass_budget_impact)

	if max_hit_mass_reached then
		return true
	end

	local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local armor_aborts_attack = Armor.aborts_attack(hit_unit, breed_or_nil, hit_zone_name_or_nil)

	if armor_aborts_attack then
		return true
	end

	return false
end

function _target_breed(unit)
	local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_ext then
		return nil
	end

	return unit_data_ext:breed()
end

function _hit_mass_from_character(unit, breed)
	if not HEALTH_ALIVE[unit] then
		return 0
	end

	local hit_mass = breed.hit_mass

	return hit_mass
end

function _hit_mass_from_object(unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if health_extension and not health_extension:is_alive() then
		return 0
	end

	local hit_mass = Unit.get_data(unit, "hit_mass") or 0

	return hit_mass
end

return HitMass
