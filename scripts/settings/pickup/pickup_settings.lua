-- chunkname: @scripts/settings/pickup/pickup_settings.lua

local pickup_settings = {}

pickup_settings.distribution_types = table.enum("end_event", "mid_event", "primary", "secondary", "reward", "bonus_reward", "guaranteed", "manual", "flow", "side_mission")
pickup_settings.pool_types = {
	bonus_reward_distribution = "bonus_reward",
	end_event_distribution = "end_event",
	mid_event_distribution = "mid_event",
	primary_distribution = "primary",
	reward_distribution = "reward",
	secondary_distribution = "secondary",
}
pickup_settings.event_types = {
	flow_spawn = "flow",
	guaranteed_spawn = "guaranteed",
	manual_spawn = "manual",
}
pickup_settings.min_chest_spawner_ratios = {
	[pickup_settings.distribution_types.primary] = 0.25,
	[pickup_settings.distribution_types.secondary] = 0.25,
	[pickup_settings.distribution_types.reward] = 1,
}
pickup_settings.pickup_pool_value = {
	ammo_cache_pocketable = 5,
	large_clip = 2.5,
	medical_crate_pocketable = 4,
	small_clip = 1.5,
	small_grenade = 2,
	syringe_corruption_pocketable = 2,
}
pickup_settings.rubberband = {
	base_spawn_rate = 0.85,
	special_block_distance = 0.2,
	special_block_distance_short = 0.05,
	pocketable_weight = {
		max = 1,
		min = 0.4,
	},
	pocketable_small_weight = {
		max = 1,
		min = 0.4,
	},
	status_weight = {
		[pickup_settings.distribution_types.mid_event] = {
			0.4,
			1,
		},
		[pickup_settings.distribution_types.end_event] = {
			0.4,
			1,
		},
		[pickup_settings.distribution_types.primary] = {
			0.05,
			1,
		},
		[pickup_settings.distribution_types.secondary] = {
			0.05,
			1,
		},
	},
	distribution_type_weight = {
		ammo = {
			[pickup_settings.distribution_types.mid_event] = 1.8,
			[pickup_settings.distribution_types.end_event] = 2.4,
		},
		grenade = {
			[pickup_settings.distribution_types.mid_event] = 1.2,
			[pickup_settings.distribution_types.end_event] = 2.5,
		},
		health = {
			[pickup_settings.distribution_types.mid_event] = 2.5,
			[pickup_settings.distribution_types.end_event] = 4,
		},
		wounds = {
			[pickup_settings.distribution_types.mid_event] = 2,
			[pickup_settings.distribution_types.end_event] = 3,
		},
		stimms = {},
	},
}
pickup_settings.animation_settings = {
	animation_time = 0.15,
	end_scale = 0.2,
	placement_arch_height = 0.2,
	target_height_offset = -0.2,
}

local function _syringe_selector(seed)
	local new_seed, rnd = math.next_random(seed)
	local weight = rnd * 5

	if weight < 1 then
		return "syringe_ability_boost_pocketable", new_seed
	elseif weight < 3 then
		return "syringe_power_boost_pocketable", new_seed
	else
		return "syringe_speed_boost_pocketable", new_seed
	end
end

pickup_settings.pickup_selector = {
	syringe_generic_pocketable = _syringe_selector,
}
pickup_settings.skip_group = {
	hard_cap = 24,
	soft_cap = 16,
}

return settings("PickupSettings", pickup_settings)
