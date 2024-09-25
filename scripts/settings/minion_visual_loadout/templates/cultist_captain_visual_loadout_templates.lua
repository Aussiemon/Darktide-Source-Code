-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist_captain_visual_loadout_templates.lua

local templates = {
	cultist_captain = {},
}
local cultist_captain_default = {
	slots = {
		slot_hellgun = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_01",
			},
		},
		slot_bolt_pistol = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01",
			},
		},
		slot_plasma_pistol = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01",
			},
		},
		slot_shotgun = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_elite_shotgun",
			},
		},
		slot_netgun = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_netgun",
			},
		},
		slot_powermaul = {
			drop_on_death = true,
			is_weapon = true,
			spawn_with_extensions = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_maul",
			},
		},
		slot_power_sword = {
			drop_on_death = true,
			is_weapon = true,
			spawn_with_extensions = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_sword",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02",
			},
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01_color_var_03",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b_color_var_03",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/cultist_captain",
			},
		},
		slot_fx_void_shield = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_fx_bubble",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/traitor_guard_flesh",
			},
		},
	},
}
local default_1 = table.clone(cultist_captain_default)

templates.cultist_captain.default = {
	default_1,
}

return templates
