-- chunkname: @scripts/settings/minion_attack_selection/templates/cultist_captain_attack_selection_templates.lua

local ALL_CATEGORIES = {
	aoe = {
		{
			attack_names = {
				"void_shield_explosion",
			},
		},
	},
	charge = {
		{
			attack_names = {
				"charge",
			},
		},
	},
	disabling = {
		{
			required_weapon_slot_name = "slot_netgun",
			attack_names = {
				"shoot_net",
			},
		},
	},
	grenade = {
		{
			attack_names = {
				"frag_grenade",
				"fire_grenade",
			},
		},
	},
	melee = {
		{
			required_weapon_slot_name = "slot_powermaul",
			attack_names = {
				"powermaul_ground_slam_attack",
			},
		},
	},
	punch = {
		{
			attack_names = {
				"punch",
			},
		},
	},
	kick = {
		{
			attack_names = {
				"kick",
			},
		},
	},
	ranged = {
		{
			required_weapon_slot_name = "slot_shotgun",
			attack_names = {
				"shotgun_shoot",
			},
		},
	},
}
local ALL_AMOUNT_FROM_CATEGORY = {}

for category, entries in pairs(ALL_CATEGORIES) do
	local total_attacks = 0

	for i = 1, #entries do
		local data = entries[i]
		local num_attacks = #data.attack_names

		total_attacks = total_attacks + num_attacks
	end

	ALL_AMOUNT_FROM_CATEGORY[category] = total_attacks
end

local cultist_captain_all = {
	combat_range_multi_config_key = "default",
	categories = ALL_CATEGORIES,
	amount_from_category = ALL_AMOUNT_FROM_CATEGORY,
}
local cultist_captain_default = {
	combat_range_multi_config_key = "default",
	tag = "default",
	categories = ALL_CATEGORIES,
	amount_from_category = {
		aoe = 1,
		melee = 1,
		ranged = 1,
	},
	multi_selection = {
		amount = 2,
		categories = {
			"charge",
			"kick",
		},
	},
}
local cultist_captain_melee = {
	combat_range_multi_config_key = "melee",
	tag = "melee",
	categories = ALL_CATEGORIES,
	amount_from_category = {
		aoe = 1,
		melee = 1,
	},
	multi_selection = {
		amount = 2,
		categories = {
			"charge",
			"kick",
		},
	},
}
local cultist_captain_ranged = {
	combat_range_multi_config_key = "ranged",
	tag = "ranged",
	categories = ALL_CATEGORIES,
	amount_from_category = {
		aoe = 1,
		ranged = 1,
	},
	multi_selection = {
		amount = 2,
		categories = {
			"grenade",
			"kick",
		},
	},
}
local templates = {
	cultist_captain_all = cultist_captain_all,
	cultist_captain_default = cultist_captain_default,
	cultist_captain_melee = cultist_captain_melee,
	cultist_captain_ranged = cultist_captain_ranged,
}

return templates
