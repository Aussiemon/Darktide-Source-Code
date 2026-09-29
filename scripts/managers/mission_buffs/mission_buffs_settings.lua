-- chunkname: @scripts/managers/mission_buffs/mission_buffs_settings.lua

local mission_buffs_settings = {}

mission_buffs_settings.filtering_categories = table.enum("regular", "jackpot", "ability", "grenade")
mission_buffs_settings.filtering_categories_pick_rate_per_wave = {
	wave_3 = {
		ability = 5,
		grenade = 3,
		jackpot = 1,
		regular = 1
	},
	wave_6 = {
		ability = 3,
		grenade = 3,
		jackpot = 3,
		regular = 3
	},
	wave_9 = {
		ability = 5,
		grenade = 5,
		jackpot = 2,
		regular = 0
	}
}
mission_buffs_settings.buff_choice_compositions = {
	legendary_and_family = {
		num_options = 3,
		categories = {
			{
				max = 2,
				name = "legendary"
			},
			{
				max = 2,
				name = "family"
			}
		}
	},
	two_legendary_one_family = {
		num_options = 3,
		categories = {
			{
				max = 2,
				min = 2,
				name = "legendary"
			},
			{
				max = 1,
				min = 1,
				name = "family"
			}
		}
	},
	legendary_leaning = {
		num_options = 3,
		categories = {
			{
				max = 2,
				min = 1,
				name = "legendary",
				weight = 3
			},
			{
				max = 2,
				min = 1,
				name = "family",
				weight = 1
			}
		}
	},
	family_granted = {
		num_options = 1,
		categories = {
			{
				name = "family"
			}
		}
	},
	family_triple = {
		num_option = 3,
		categories = {
			{
				name = "family"
			}
		}
	},
	basic_triple = {
		num_options = 3,
		categories = {
			{
				name = "basic"
			}
		}
	},
	basic_granted = {
		num_options = 1,
		categories = {
			{
				name = "basic"
			}
		}
	}
}

return mission_buffs_settings
