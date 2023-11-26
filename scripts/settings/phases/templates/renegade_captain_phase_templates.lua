-- chunkname: @scripts/settings/phases/templates/renegade_captain_phase_templates.lua

local renegade_captain_templates = {
	renegade_captain_default = {
		melee = {
			entry_phase = {
				"melee_power_sword",
				"melee_powermaul"
			},
			phases = {
				melee_power_sword = {
					wanted_weapon_slot = "slot_power_sword"
				},
				melee_powermaul = {
					wanted_weapon_slot = "slot_powermaul"
				}
			}
		},
		close = {
			entry_phase = {
				"hellgun",
				"netgun",
				"bolt_pistol",
				"plasma_pistol",
				"shotgun",
				"melee_power_sword",
				"melee_powermaul"
			},
			phases = {
				hellgun = {
					wanted_weapon_slot = "slot_hellgun",
					duration = {
						20,
						25
					}
				},
				netgun = {
					wanted_weapon_slot = "slot_netgun",
					duration = {
						10,
						20
					}
				},
				bolt_pistol = {
					wanted_weapon_slot = "slot_bolt_pistol",
					duration = {
						20,
						25
					}
				},
				plasma_pistol = {
					wanted_weapon_slot = "slot_plasma_pistol",
					duration = {
						20,
						25
					}
				},
				shotgun = {
					wanted_weapon_slot = "slot_shotgun",
					duration = {
						10,
						15
					}
				},
				melee_power_sword = {
					wanted_weapon_slot = "slot_power_sword"
				},
				melee_powermaul = {
					wanted_weapon_slot = "slot_powermaul"
				}
			}
		},
		far = {
			entry_phase = {
				"hellgun",
				"netgun",
				"bolt_pistol",
				"plasma_pistol",
				"shotgun"
			},
			phases = {
				hellgun = {
					wanted_weapon_slot = "slot_hellgun",
					duration = {
						10,
						20
					}
				},
				netgun = {
					wanted_weapon_slot = "slot_netgun",
					duration = {
						10,
						20
					}
				},
				bolt_pistol = {
					wanted_weapon_slot = "slot_bolt_pistol",
					duration = {
						10,
						15
					}
				},
				plasma_pistol = {
					wanted_weapon_slot = "slot_plasma_pistol",
					duration = {
						10,
						15
					}
				},
				shotgun = {
					wanted_weapon_slot = "slot_shotgun",
					duration = {
						10,
						15
					}
				}
			}
		}
	}
}

return renegade_captain_templates
