local Threat = {
	add_threat = function (unit, threat_unit, damage_dealt_threat, damage_absorbed_threat, optional_damage_profile, optional_attack_type)
		local threat_multiplier = optional_damage_profile and optional_damage_profile.threat_multiplier or 1
		local damage_threat = damage_dealt_threat * threat_multiplier
		local absorbed_damage_threat_multiplier = optional_damage_profile and optional_damage_profile.absorbed_damage_threat_multiplier or 1
		local absorbed_threat = damage_absorbed_threat * absorbed_damage_threat_multiplier
		local threat = damage_threat + absorbed_threat
		local perception_extension = ScriptUnit.has_extension(unit, "perception_system")

		if perception_extension then
			perception_extension:add_threat(threat_unit, threat, optional_attack_type)
		end
	end,
	add_flat_threat = function (unit, threat_unit, threat)
		local perception_extension = ScriptUnit.has_extension(unit, "perception_system")

		if perception_extension then
			perception_extension:add_threat(threat_unit, threat)
		end
	end,
	set_threat_decay_enabled = function (unit, enabled)
		local perception_extension = ScriptUnit.has_extension(unit, "perception_system")

		if perception_extension then
			perception_extension:set_threat_decay_enabled(enabled)
		end
	end
}

return Threat
