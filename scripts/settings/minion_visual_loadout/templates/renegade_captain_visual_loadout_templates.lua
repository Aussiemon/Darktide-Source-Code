local templates = {
	renegade_captain = {}
}
local renegade_captain_default = {
	slots = {
		slot_hellgun = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_01"
			}
		},
		slot_bolt_pistol = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01"
			}
		},
		slot_plasma_pistol = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01"
			}
		},
		slot_shotgun = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_elite_shotgun"
			}
		},
		slot_netgun = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_netgun"
			}
		},
		slot_powermaul = {
			use_outline = true,
			drop_on_death = true,
			spawn_with_extensions = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_maul"
			}
		},
		slot_power_sword = {
			use_outline = true,
			drop_on_death = true,
			spawn_with_extensions = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_sword"
			}
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01"
			}
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_01_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04"
			}
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_captain"
			}
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_captain"
			}
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e"
			}
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_05"
			}
		},
		slot_fx_void_shield = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_fx_bubble"
			}
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/traitor_guard_flesh"
			}
		}
	}
}
local default_1 = table.clone(renegade_captain_default)
templates.renegade_captain.default = {
	default_1
}

return templates
