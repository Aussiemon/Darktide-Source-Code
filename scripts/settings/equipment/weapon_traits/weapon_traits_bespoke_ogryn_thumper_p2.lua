-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

templates.weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = {
	weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.2
		},
		{
			toughness_fixed_percentage = 0.25
		},
		{
			toughness_fixed_percentage = 0.3
		},
		{
			toughness_fixed_percentage = 0.35
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = {
	weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = {
		{}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = {
	weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = {
		{
			target_buff_data = {
				num_stacks_on_proc = 1
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 3
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = {
	weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = {
		{}
	}
}

return templates
