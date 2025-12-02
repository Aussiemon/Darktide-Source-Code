-- chunkname: @scripts/settings/decal/player_character_decal_aliases.lua

local DEFAULT_HUMAN_FOOTSTEP_EXTENTS = {
	boot = {
		0.35,
		0.35,
		0.5,
	},
	pegleg = {
		0.35,
		0.35,
		0.5,
	},
	mech = {
		0.35,
		0.35,
		0.5,
	},
}
local DEFAULT_OGRYN_FOOTSTEP_EXTENTS = {
	boot = {
		0.8,
		0.8,
		0.5,
	},
	pegleg = {
		0.8,
		0.8,
		0.5,
	},
	barefoot = {
		0.8,
		0.8,
		0.5,
	},
}
local DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS = {
	organic = {
		0.28,
		0.28,
		0.5,
	},
	mech = {
		0.28,
		0.28,
		0.5,
	},
	mech_claw = {
		0.28,
		0.28,
		0.5,
	},
}
local HUMAN_FOOT_LEFT_DIRT = {
	boot = "content/fx/units/player/footprints/footprint_snow_01",
	mech = "content/fx/units/player/footprints/snow_footprints_03",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local HUMAN_FOOT_RIGHT_DIRT = {
	boot = "content/fx/units/player/footprints/footprint_r_snow_01",
	mech = "content/fx/units/player/footprints/snow_footprints_03",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local OGRYN_FOOT_LEFT_DIRT = {
	barefoot = "content/fx/units/player/footprints/snow_footprints_ogryn_l_01",
	boot = "content/fx/units/player/footprints/footprint_snow_01",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local OGRYN_FOOT_RIGHT_DIRT = {
	barefoot = "content/fx/units/player/footprints/snow_footprints_ogryn_r_01",
	boot = "content/fx/units/player/footprints/footprint_r_snow_01",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local COMPANION_DOG_FOOT_LEFT_DIRT = {
	mech = "content/fx/units/player/footprints/snow_footprints_companion_l_01",
	mech_claw = "content/fx/units/player/footprints/snow_footprints_companion_03",
	organic = "content/fx/units/player/footprints/snow_footprints_companion_l_02",
}
local COMPANION_DOG_FOOT_RIGHT_DIRT = {
	mech = "content/fx/units/player/footprints/snow_footprints_companion_r_01",
	mech_claw = "content/fx/units/player/footprints/snow_footprints_companion_03",
	organic = "content/fx/units/player/footprints/snow_footprints_companion_r_02",
}
local HUMAN_FOOT_LEFT_SNOW = {
	boot = "content/fx/units/player/footprints/footprint_snow_01",
	mech = "content/fx/units/player/footprints/snow_footprints_03",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local HUMAN_FOOT_RIGHT_SNOW = {
	boot = "content/fx/units/player/footprints/footprint_r_snow_01",
	mech = "content/fx/units/player/footprints/snow_footprints_03",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local OGRYN_FOOT_LEFT_SNOW = {
	barefoot = "content/fx/units/player/footprints/snow_footprints_ogryn_l_01",
	boot = "content/fx/units/player/footprints/footprint_snow_01",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local OGRYN_FOOT_RIGHT_SNOW = {
	barefoot = "content/fx/units/player/footprints/snow_footprints_ogryn_r_01",
	boot = "content/fx/units/player/footprints/footprint_r_snow_01",
	pegleg = "content/fx/units/player/footprints/snow_footprints_02",
}
local COMPANION_DOG_FOOT_LEFT_SNOW = {
	mech = "content/fx/units/player/footprints/snow_footprints_companion_l_01",
	mech_claw = "content/fx/units/player/footprints/snow_footprints_companion_03",
	organic = "content/fx/units/player/footprints/snow_footprints_companion_l_02",
}
local COMPANION_DOG_FOOT_RIGHT_SNOW = {
	mech = "content/fx/units/player/footprints/snow_footprints_companion_r_01",
	mech_claw = "content/fx/units/player/footprints/snow_footprints_companion_03",
	organic = "content/fx/units/player/footprints/snow_footprints_companion_r_02",
}
local decals = {
	footstep_left = {
		no_default = true,
		switch = {
			"breed",
			"material",
			"footstep_type_left",
		},
		default_switch_properties = {
			breed = nil,
			footstep_type_left = "boot",
			material = nil,
		},
		decals = {
			human = {
				dirt_gravel = HUMAN_FOOT_LEFT_DIRT,
				dirt_mud = HUMAN_FOOT_LEFT_DIRT,
				dirt_sand = HUMAN_FOOT_LEFT_DIRT,
				dirt_soil = HUMAN_FOOT_LEFT_DIRT,
				snow = HUMAN_FOOT_LEFT_SNOW,
				snow_frosty = HUMAN_FOOT_LEFT_SNOW,
			},
			ogryn = {
				dirt_gravel = OGRYN_FOOT_LEFT_DIRT,
				dirt_mud = OGRYN_FOOT_LEFT_DIRT,
				dirt_sand = OGRYN_FOOT_LEFT_DIRT,
				dirt_soil = OGRYN_FOOT_LEFT_DIRT,
				snow = OGRYN_FOOT_LEFT_SNOW,
				snow_frosty = OGRYN_FOOT_LEFT_SNOW,
			},
		},
		extents = {
			human = {
				dirt_gravel = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				snow = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
			},
			ogryn = {
				dirt_gravel = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				snow = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
			},
		},
	},
	footstep_right = {
		no_default = true,
		switch = {
			"breed",
			"material",
			"footstep_type_right",
		},
		default_switch_properties = {
			breed = nil,
			footstep_type_right = "boot",
			material = nil,
		},
		decals = {
			human = {
				dirt_gravel = HUMAN_FOOT_RIGHT_DIRT,
				dirt_mud = HUMAN_FOOT_RIGHT_DIRT,
				dirt_sand = HUMAN_FOOT_RIGHT_DIRT,
				dirt_soil = HUMAN_FOOT_RIGHT_DIRT,
				snow = HUMAN_FOOT_RIGHT_SNOW,
				snow_frosty = HUMAN_FOOT_RIGHT_SNOW,
			},
			ogryn = {
				dirt_gravel = OGRYN_FOOT_RIGHT_DIRT,
				dirt_mud = OGRYN_FOOT_RIGHT_DIRT,
				dirt_sand = OGRYN_FOOT_RIGHT_DIRT,
				dirt_soil = OGRYN_FOOT_RIGHT_DIRT,
				snow = OGRYN_FOOT_RIGHT_SNOW,
				snow_frosty = OGRYN_FOOT_RIGHT_SNOW,
			},
		},
		extents = {
			human = {
				dirt_gravel = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				snow = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_HUMAN_FOOTSTEP_EXTENTS,
			},
			ogryn = {
				dirt_gravel = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				snow = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_OGRYN_FOOTSTEP_EXTENTS,
			},
		},
	},
	footstep_companion_left_front = {
		no_default = true,
		switch = {
			"companion_breed",
			"material",
			"companion_footstep_type_front_left",
		},
		default_switch_properties = {
			breed = nil,
			companion_footstep_type_front_left = "organic",
			material = nil,
		},
		decals = {
			companion_dog = {
				dirt_gravel = COMPANION_DOG_FOOT_LEFT_DIRT,
				dirt_mud = COMPANION_DOG_FOOT_LEFT_DIRT,
				dirt_sand = COMPANION_DOG_FOOT_LEFT_DIRT,
				dirt_soil = COMPANION_DOG_FOOT_LEFT_DIRT,
				snow = COMPANION_DOG_FOOT_LEFT_SNOW,
				snow_frosty = COMPANION_DOG_FOOT_LEFT_SNOW,
			},
		},
		extents = {
			companion_dog = {
				dirt_gravel = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
			},
		},
	},
	footstep_companion_right_front = {
		no_default = true,
		switch = {
			"companion_breed",
			"material",
			"companion_footstep_type_front_right",
		},
		default_switch_properties = {
			breed = nil,
			companion_footstep_type_front_right = "organic",
			material = nil,
		},
		decals = {
			companion_dog = {
				dirt_gravel = COMPANION_DOG_FOOT_RIGHT_DIRT,
				dirt_mud = COMPANION_DOG_FOOT_RIGHT_DIRT,
				dirt_sand = COMPANION_DOG_FOOT_RIGHT_DIRT,
				dirt_soil = COMPANION_DOG_FOOT_RIGHT_DIRT,
				snow = COMPANION_DOG_FOOT_RIGHT_SNOW,
				snow_frosty = COMPANION_DOG_FOOT_RIGHT_SNOW,
			},
		},
		extents = {
			companion_dog = {
				dirt_gravel = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
			},
		},
	},
	footstep_companion_left_back = {
		no_default = true,
		switch = {
			"companion_breed",
			"material",
			"companion_footstep_type_rear_left",
		},
		default_switch_properties = {
			breed = nil,
			companion_footstep_type_rear_left = "organic",
			material = nil,
		},
		decals = {
			companion_dog = {
				dirt_gravel = COMPANION_DOG_FOOT_LEFT_DIRT,
				dirt_mud = COMPANION_DOG_FOOT_LEFT_DIRT,
				dirt_sand = COMPANION_DOG_FOOT_LEFT_DIRT,
				dirt_soil = COMPANION_DOG_FOOT_LEFT_DIRT,
				snow = COMPANION_DOG_FOOT_LEFT_SNOW,
				snow_frosty = COMPANION_DOG_FOOT_LEFT_SNOW,
			},
		},
		extents = {
			companion_dog = {
				dirt_gravel = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
			},
		},
	},
	footstep_companion_right_back = {
		no_default = true,
		switch = {
			"companion_breed",
			"material",
			"companion_footstep_type_rear_right",
		},
		default_switch_properties = {
			breed = nil,
			companion_footstep_type_rear_right = "organic",
			material = nil,
		},
		decals = {
			companion_dog = {
				dirt_gravel = COMPANION_DOG_FOOT_RIGHT_DIRT,
				dirt_mud = COMPANION_DOG_FOOT_RIGHT_DIRT,
				dirt_sand = COMPANION_DOG_FOOT_RIGHT_DIRT,
				dirt_soil = COMPANION_DOG_FOOT_RIGHT_DIRT,
				snow = COMPANION_DOG_FOOT_RIGHT_SNOW,
				snow_frosty = COMPANION_DOG_FOOT_RIGHT_SNOW,
			},
		},
		extents = {
			companion_dog = {
				dirt_gravel = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_mud = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_sand = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				dirt_soil = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
				snow_frosty = DEFAULT_COMPANION_DOG_FOOTSTEP_EXTENTS,
			},
		},
	},
}

local function _verify_extents_matches_decals(alias_name, alias_decals, alias_extents)
	for switch, settings in pairs(alias_decals) do
		if type(settings) == "table" then
			_verify_extents_matches_decals(alias_name, alias_decals[switch], alias_extents[switch])
		end
	end
end

for alias_name, alias_data in pairs(decals) do
	local alias_decals = alias_data.decals
	local alias_extents = alias_data.extents

	if alias_extents then
		_verify_extents_matches_decals(alias_name, alias_decals, alias_extents)
	end
end

return decals
