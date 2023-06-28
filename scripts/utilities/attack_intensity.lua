local AttackIntensity = {
	add_intensity = function (target_unit, attack_intensities)
		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return
		end

		for type, intensity in pairs(attack_intensities) do
			target_attack_intensity_extension:add_intensity(type, intensity)
		end
	end,
	set_attacked = function (target_unit)
		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return
		end

		target_attack_intensity_extension:set_attacked()
	end,
	set_attacked_melee = function (target_unit)
		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return
		end

		target_attack_intensity_extension:set_attacked_melee()
	end,
	remove_attacked_melee = function (target_unit)
		if not ALIVE[target_unit] then
			return
		end

		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return
		end

		target_attack_intensity_extension:remove_attacked_melee()
	end,
	minion_can_attack = function (unit, type, target_unit)
		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return true
		end

		local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

		if not attack_intensity_extension then
			return true
		end

		local target_allowed_attack = target_attack_intensity_extension:attack_allowed(type)

		if target_allowed_attack and attack_intensity_extension then
			local attack_allowed = attack_intensity_extension:can_attack(type)

			return attack_allowed
		end
	end,
	set_monster_attacker = function (target_unit, attacker_unit)
		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return
		end

		target_attack_intensity_extension:set_monster_attacker(attacker_unit)
	end,
	monster_attacker = function (target_unit)
		local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

		if not target_attack_intensity_extension then
			return
		end

		return target_attack_intensity_extension:monster_attacker()
	end,
	player_can_be_attacked = function (player_unit, type)
		local attack_intensity_extension = ScriptUnit.extension(player_unit, "attack_intensity_system")

		return attack_intensity_extension:attack_allowed(type)
	end,
	player_is_locked_in_melee = function (player_unit)
		local attack_intensity_extension = ScriptUnit.extension(player_unit, "attack_intensity_system")

		return attack_intensity_extension:locked_in_melee()
	end
}

return AttackIntensity
