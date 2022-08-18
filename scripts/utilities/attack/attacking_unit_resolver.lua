local AttackingUnitResolver = {}
local PROJECTILE_EXTENSION = "ProjectileUnitLocomotionExtension"

AttackingUnitResolver.resolve = function (attacking_unit)
	local projectile_entities = Managers.state.extension:get_entities(PROJECTILE_EXTENSION)
	local projectile_extension = projectile_entities[attacking_unit]
	local is_projectile = projectile_extension ~= nil
	local ALIVE = ALIVE

	if is_projectile then
		local owner_unit = projectile_extension:owner_unit()

		if ALIVE[owner_unit] then
			return owner_unit
		end
	end

	local owner = Managers.state.player_unit_spawn:owner(attacking_unit)

	if owner then
		local player_unit = owner.player_unit

		if ALIVE[player_unit] then
			return player_unit
		end
	end

	return attacking_unit
end

AttackingUnitResolver.resolve_item_slot = function (attacking_unit, attack_owner_unit)
	local is_instegator_alive = attacking_unit and ALIVE[attacking_unit]
	local projetile_damage_extension = is_instegator_alive and ScriptUnit.has_extension(attacking_unit, "projectile_damage_system")

	if projetile_damage_extension then
		local projectile_origin_item_slot = projetile_damage_extension:get_origin_item_slot()

		return projectile_origin_item_slot
	end

	local side_extension = ScriptUnit.has_extension(attack_owner_unit, "side_system")
	local is_player_unit = side_extension.is_player_unit

	if is_player_unit then
		local unit_data_extension = ScriptUnit.has_extension(attack_owner_unit, "unit_data_system")
		local inventory_component = unit_data_extension and unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component and inventory_component.wielded_slot

		return wielded_slot
	end

	return nil
end

return AttackingUnitResolver
