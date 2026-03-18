-- chunkname: @scripts/settings/horde/horde_settings.lua

local horde_settings = {}

horde_settings.horde_types = table.enum("far_vector_horde", "flood_horde", "trickle_horde", "ambush_horde", "far_distance_horde", "mutator_trickle_horde")
horde_settings.coordinated_horde_strike_types = table.enum("long_horde", "coordinated_special_attack", "push_from_behind", "ranged_push_from_behind", "elite_roamer_mix_vector", "spread_ambush", "sandwich", "elite_sandwich_waves", "elite_coordinated_special_attack", "ranged_trickle_forward_horde_push_from_behind", "elite_spread_ambush", "blockade_push_sandwich", "elite_captain_ambush", "houndmaster_strike", "twins_surprise")

return settings("HordeSettings", horde_settings)
