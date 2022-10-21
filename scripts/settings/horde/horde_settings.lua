local horde_settings = {
	horde_types = table.enum("far_vector_horde", "flood_horde", "trickle_horde", "ambush_horde")
}

return settings("HordeSettings", horde_settings)
