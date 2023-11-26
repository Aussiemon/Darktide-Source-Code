-- chunkname: @scripts/managers/terror_event/terror_trickle_templates/default_terror_trickle_templates.lua

local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local MIXED_COMPOSITIONS = {
	renegade = {
		HordeCompositions.renegade_melee_terror_trickle,
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.renegade_close_terror_trickle,
		HordeCompositions.renegade_close_terror_trickle_elite,
		HordeCompositions.renegade_melee_terror_trickle_elite
	},
	cultist = {
		HordeCompositions.cultist_melee_terror_trickle,
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.cultist_close_terror_trickle,
		HordeCompositions.cultist_close_terror_trickle_elite,
		HordeCompositions.cultist_melee_terror_trickle_elite
	}
}
local MELEE_COMPOSITIONS = {
	renegade = {
		HordeCompositions.renegade_melee_terror_trickle,
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.renegade_terror_trickle_elite
	},
	cultist = {
		HordeCompositions.cultist_melee_terror_trickle,
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.cultist_melee_terror_trickle_elite
	}
}
local RANGED_COMPOSITIONS = {
	renegade = {
		HordeCompositions.renegade_close_terror_trickle,
		HordeCompositions.renegade_close_terror_trickle,
		HordeCompositions.renegade_close_terror_trickle_elite,
		HordeCompositions.infected_terror_trickle
	},
	cultist = {
		HordeCompositions.cultist_close_terror_trickle,
		HordeCompositions.cultist_close_terror_trickle,
		HordeCompositions.cultist_close_terror_trickle_elite,
		HordeCompositions.infected_terror_trickle
	}
}
local LOW_MIXED_COMPOSITIONS = {
	renegade = {
		HordeCompositions.renegade_melee_terror_trickle,
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.renegade_close_terror_trickle
	},
	cultist = {
		HordeCompositions.cultist_melee_terror_trickle,
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.cultist_close_terror_trickle
	}
}
local LOW_MELEE_COMPOSITIONS = {
	renegade = {
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle
	},
	cultist = {
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle
	}
}
local STANDARD_MELEE_COMPOSITIONS = {
	renegade = {
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.renegade_melee_low_terror_trickle
	},
	cultist = {
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle,
		HordeCompositions.cultist_melee_low_terror_trickle
	}
}
local LOW_RANGED_COMPOSITIONS = {
	renegade = {
		HordeCompositions.renegade_close_terror_trickle,
		HordeCompositions.renegade_close_terror_trickle,
		HordeCompositions.infected_terror_trickle
	},
	cultist = {
		HordeCompositions.cultist_close_terror_trickle,
		HordeCompositions.cultist_close_terror_trickle,
		HordeCompositions.infected_terror_trickle
	}
}
local FLOOD_MELEE_COMPOSITIONS = {
	renegade = {
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle
	},
	cultist = {
		HordeCompositions.infected_terror_trickle,
		HordeCompositions.poxwalker_terror_trickle
	}
}
local terror_trickle_templates = {
	low_mixed = {
		{
			challenge_rating_stop_threshold = 5,
			tension_stop_threshold = 60,
			compositions = LOW_MIXED_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 5,
			tension_stop_threshold = 80,
			compositions = LOW_MIXED_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 5,
			tension_stop_threshold = 100,
			compositions = LOW_MIXED_COMPOSITIONS,
			num_waves = {
				1,
				2
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 10,
			tension_stop_threshold = 120,
			compositions = LOW_MIXED_COMPOSITIONS,
			num_waves = {
				2,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 10,
			tension_stop_threshold = 140,
			compositions = LOW_MIXED_COMPOSITIONS,
			num_waves = {
				2,
				3
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				50,
				60
			}
		}
	},
	medium_mixed = {
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 80,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 100,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 120,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 140,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				50,
				60
			}
		}
	},
	high_mixed = {
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 60,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				5,
				6
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 80,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				6,
				7
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 100,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				7,
				8
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 120,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				8,
				9
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 140,
			compositions = MIXED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		}
	},
	low_melee = {
		{
			challenge_rating_stop_threshold = 10,
			tension_stop_threshold = 60,
			compositions = LOW_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 10,
			tension_stop_threshold = 80,
			compositions = LOW_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				40,
				50
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 100,
			compositions = LOW_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				25,
				30
			}
		},
		{
			challenge_rating_stop_threshold = 30,
			tension_stop_threshold = 120,
			compositions = LOW_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				12,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 40,
			tension_stop_threshold = 140,
			compositions = LOW_MELEE_COMPOSITIONS,
			num_waves = {
				2,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		}
	},
	standard_melee = {
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				25,
				30
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				25,
				30
			}
		},
		{
			challenge_rating_stop_threshold = 30,
			tension_stop_threshold = 80,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 40,
			tension_stop_threshold = 80,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				8,
				13
			}
		},
		{
			challenge_rating_stop_threshold = 50,
			tension_stop_threshold = 100,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				2,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				7,
				11
			}
		}
	},
	medium_melee = {
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				25,
				30
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				25,
				30
			}
		},
		{
			challenge_rating_stop_threshold = 30,
			tension_stop_threshold = 80,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 40,
			tension_stop_threshold = 80,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				1,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				8,
				13
			}
		},
		{
			challenge_rating_stop_threshold = 50,
			tension_stop_threshold = 100,
			compositions = STANDARD_MELEE_COMPOSITIONS,
			num_waves = {
				2,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				7,
				11
			}
		}
	},
	high_melee = {
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 60,
			compositions = MELEE_COMPOSITIONS,
			num_waves = {
				5,
				6
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 80,
			compositions = MELEE_COMPOSITIONS,
			num_waves = {
				6,
				7
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 100,
			compositions = MELEE_COMPOSITIONS,
			num_waves = {
				7,
				8
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 120,
			compositions = MELEE_COMPOSITIONS,
			num_waves = {
				8,
				9
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 140,
			compositions = MELEE_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		}
	},
	flood_melee = {
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = FLOOD_MELEE_COMPOSITIONS,
			num_waves = {
				2,
				2
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				10,
				15
			}
		},
		{
			challenge_rating_stop_threshold = 25,
			tension_stop_threshold = 80,
			compositions = FLOOD_MELEE_COMPOSITIONS,
			num_waves = {
				3,
				3
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				10,
				15
			}
		},
		{
			challenge_rating_stop_threshold = 30,
			tension_stop_threshold = 100,
			compositions = FLOOD_MELEE_COMPOSITIONS,
			num_waves = {
				3,
				3
			},
			time_between_waves = {
				4,
				7
			},
			cooldown = {
				8,
				12
			}
		},
		{
			challenge_rating_stop_threshold = 30,
			tension_stop_threshold = 120,
			compositions = FLOOD_MELEE_COMPOSITIONS,
			num_waves = {
				3,
				3
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				8,
				12
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 140,
			compositions = FLOOD_MELEE_COMPOSITIONS,
			num_waves = {
				4,
				4
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				8,
				12
			}
		}
	},
	low_ranged = {
		{
			challenge_rating_stop_threshold = 5,
			tension_stop_threshold = 60,
			compositions = LOW_RANGED_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				50,
				60
			}
		},
		{
			challenge_rating_stop_threshold = 5,
			tension_stop_threshold = 80,
			compositions = LOW_RANGED_COMPOSITIONS,
			num_waves = {
				1,
				1
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				40,
				50
			}
		},
		{
			challenge_rating_stop_threshold = 10,
			tension_stop_threshold = 100,
			compositions = LOW_RANGED_COMPOSITIONS,
			num_waves = {
				1,
				2
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				30,
				40
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 120,
			compositions = LOW_RANGED_COMPOSITIONS,
			num_waves = {
				2,
				2
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				20,
				30
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 140,
			compositions = LOW_RANGED_COMPOSITIONS,
			num_waves = {
				2,
				3
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		}
	},
	medium_ranged = {
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 60,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				30,
				35
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 80,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				30,
				35
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 100,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				30,
				35
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 120,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				30,
				35
			}
		},
		{
			challenge_rating_stop_threshold = 20,
			tension_stop_threshold = 140,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				30,
				35
			}
		}
	},
	high_ranged = {
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 60,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				5,
				6
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 80,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				6,
				7
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 100,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				7,
				8
			},
			time_between_waves = {
				6,
				10
			},
			cooldown = {
				15,
				20
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 120,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				8,
				9
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		},
		{
			challenge_rating_stop_threshold = 35,
			tension_stop_threshold = 140,
			compositions = RANGED_COMPOSITIONS,
			num_waves = {
				4,
				5
			},
			time_between_waves = {
				3,
				6
			},
			cooldown = {
				10,
				15
			}
		}
	}
}

return terror_trickle_templates
