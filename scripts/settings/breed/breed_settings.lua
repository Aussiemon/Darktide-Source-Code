local breed_settings = {
	types = table.enum("minion", "player", "living_prop", "prop")
}

return settings("BreedSettings", breed_settings)
