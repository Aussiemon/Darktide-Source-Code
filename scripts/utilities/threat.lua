local Threat = {
	add_threat = function (unit, threat_unit, damage_dealt_threat, damage_absorbed_threat, optional_damage_profile)
		local threat_multiplier = (optional_damage_profile and optional_damage_profile.threat_multiplier) or 1
		local damage_threat = damage_dealt_threat * threat_multiplier
		local absorbed_damage_threat_multiplier = (optional_damage_profile and optional_damage_profile.absorbed_damage_threat_multiplier) or 1
		local absorbed_threat = damage_absorbed_threat * absorbed_damage_threat_multiplier
		local threat = damage_threat + absorbed_threat
		local perception_extension = ScriptUnit.extension(unit, "perception_system")

		perception_extension:add_threat(threat_unit, threat)
	end,
	add_flat_threat = function (unit, threat_unit, threat)
		local perception_extension = ScriptUnit.extension(unit, "perception_system")

		perception_extension:add_threat(threat_unit, threat)
	end,
	set_threat_decay_enabled = function (unit, enabled)
		local perception_extension = ScriptUnit.extension(unit, "perception_system")

		perception_extension:set_threat_decay_enabled(enabled)
	end
}

return Threat
