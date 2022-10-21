local toughness_settings = {
	template_types = table.enum("player", "minion"),
	replenish_types = table.enum("melee_kill", "melee_kill_reduced", "ranged_kill", "suppression", "assisted_ally", "ogryn_braced_regen", "bonebreaker_heavy_hit")
}

return settings("ToughnessSettings", toughness_settings)
