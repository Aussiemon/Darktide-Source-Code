-- chunkname: @scripts/settings/impact_fx/impact_fx_shock_stuck.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker",
}
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact_died",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact_died",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/armor_penetrate",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		shield_blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		dead = {},
		shove = {
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
	},
	blood_ball = {
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact_died",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		shield_blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		blocked = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		dead = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
		shove = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_powermaul_1h_stuck_impact",
			},
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_weakspot_blood",
			},
		},
	},
	vfx = {
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/weapons/shock_maul/shock_stuck",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
	},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
		weakspot_damage = disgusting_blood_ball,
		damage = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored,
	},
}
