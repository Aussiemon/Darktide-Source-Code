-- chunkname: @scripts/settings/phases/templates/cultist_captain_phase_templates.lua

local cultist_captain_templates = {
	cultist_captain_default = {
		melee = {
			entry_phase = {
				"melee_powermaul"
			},
			phases = {
				melee_powermaul = {
					wanted_weapon_slot = "slot_powermaul"
				}
			}
		},
		close = {
			entry_phase = {
				"shotgun",
				"melee_powermaul"
			},
			phases = {
				shotgun = {
					wanted_weapon_slot = "slot_shotgun",
					duration = {
						10,
						15
					}
				},
				melee_powermaul = {
					wanted_weapon_slot = "slot_powermaul"
				}
			}
		},
		far = {
			entry_phase = {
				"shotgun"
			},
			phases = {
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

return cultist_captain_templates
