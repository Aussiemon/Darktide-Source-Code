local AttackingUnitResolver = {}
local PROJECTILE_EXTENSION = "ProjectileUnitLocomotionExtension"

AttackingUnitResolver.resolve = function (attacking_unit)
	local alive = ALIVE
	local projectile_entities = Managers.state.extension:get_entities(PROJECTILE_EXTENSION)
	local projectile_extension = projectile_entities[attacking_unit]
	local is_projectile = projectile_extension ~= nil

	if is_projectile then
		local owner_unit = projectile_extension:owner_unit()

		if alive[owner_unit] then
			return owner_unit
		end
	end

	local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local is_prop_hazard = breed_or_nil and breed_or_nil.name == "hazard_prop"

	if is_prop_hazard then
		local health_extension = ScriptUnit.has_extension(attacking_unit, "health_system")
		local last_damaging_unit = health_extension.last_damaging_unit and health_extension:last_damaging_unit()

		if alive[last_damaging_unit] then
			return last_damaging_unit
		end
	end

	local owner = Managers.state.player_unit_spawn:owner(attacking_unit)

	if owner then
		local player_unit = owner.player_unit

		if alive[player_unit] then
			return player_unit
		end
	end

	return attacking_unit
end

return AttackingUnitResolver
