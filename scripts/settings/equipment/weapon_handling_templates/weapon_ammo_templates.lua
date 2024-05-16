-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_ammo_templates.lua

local weapon_ammo_templates = {
	no_ammo = {
		ammunition_clip = 0,
		ammunition_reserve = 0,
	},
	bolter_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 10,
			lerp_perfect = 20,
		},
		ammunition_reserve = {
			lerp_basic = 40,
			lerp_perfect = 120,
		},
	},
	autogun_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 25,
			lerp_perfect = 40,
		},
		ammunition_reserve = {
			lerp_basic = 250,
			lerp_perfect = 400,
		},
	},
	autogun_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 50,
			lerp_perfect = 60,
		},
		ammunition_reserve = {
			lerp_basic = 500,
			lerp_perfect = 600,
		},
	},
	autogun_p1_m3 = {
		ammunition_clip = {
			lerp_basic = 40,
			lerp_perfect = 60,
		},
		ammunition_reserve = {
			lerp_basic = 320,
			lerp_perfect = 480,
		},
	},
	autogun_p2_m1 = {
		ammunition_clip = {
			lerp_basic = 50,
			lerp_perfect = 80,
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 600,
		},
	},
	autogun_p2_m2 = {
		ammunition_clip = {
			lerp_basic = 50,
			lerp_perfect = 80,
		},
		ammunition_reserve = {
			lerp_basic = 500,
			lerp_perfect = 800,
		},
	},
	autogun_p2_m3 = {
		ammunition_clip = {
			lerp_basic = 30,
			lerp_perfect = 50,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 500,
		},
	},
	autogun_p3_m1 = {
		ammunition_clip = {
			lerp_basic = 30,
			lerp_perfect = 50,
		},
		ammunition_reserve = {
			lerp_basic = 240,
			lerp_perfect = 400,
		},
	},
	autogun_p3_m2 = {
		ammunition_clip = {
			lerp_basic = 15,
			lerp_perfect = 25,
		},
		ammunition_reserve = {
			lerp_basic = 120,
			lerp_perfect = 200,
		},
	},
	autopistol_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 40,
			lerp_perfect = 60,
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 600,
		},
	},
	flamer_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 20,
			lerp_perfect = 40,
		},
		ammunition_reserve = {
			lerp_basic = 80,
			lerp_perfect = 200,
		},
	},
	ogryn_gauntlet_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 3,
			lerp_perfect = 5,
		},
		ammunition_reserve = {
			lerp_basic = 18,
			lerp_perfect = 40,
		},
	},
	lasgun_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 800,
		},
	},
	lasgun_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 160,
		},
		ammunition_reserve = {
			lerp_basic = 480,
			lerp_perfect = 1000,
		},
	},
	lasgun_p1_m3 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p2_m1 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p2_m2 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p2_m3 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p3_m1 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p3_m2 = {
		ammunition_clip = {
			lerp_basic = 60,
			lerp_perfect = 120,
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	laspistol_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 40,
			lerp_perfect = 80,
		},
		ammunition_reserve = {
			lerp_basic = 280,
			lerp_perfect = 560,
		},
	},
	laspistol_p1_m3 = {
		ammunition_clip = {
			lerp_basic = 45,
			lerp_perfect = 90,
		},
		ammunition_reserve = {
			lerp_basic = 270,
			lerp_perfect = 540,
		},
	},
	plasmagun_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 75,
			lerp_perfect = 150,
		},
		ammunition_reserve = {
			lerp_basic = 75,
			lerp_perfect = 150,
		},
	},
	ogryn_rippergun_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 12,
			lerp_perfect = 24,
		},
		ammunition_reserve = {
			lerp_basic = 72,
			lerp_perfect = 168,
		},
	},
	ogryn_rippergun_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 10,
			lerp_perfect = 20,
		},
		ammunition_reserve = {
			lerp_basic = 60,
			lerp_perfect = 140,
		},
	},
	ogryn_thumper_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 1,
			lerp_perfect = 1,
		},
		ammunition_reserve = {
			lerp_basic = 32,
			lerp_perfect = 62,
		},
	},
	ogryn_thumper_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 1,
			lerp_perfect = 1,
		},
		ammunition_reserve = {
			lerp_basic = 15,
			lerp_perfect = 30,
		},
	},
	shotgun_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 8,
			lerp_perfect = 12,
		},
		ammunition_reserve = {
			lerp_basic = 60,
			lerp_perfect = 80,
		},
	},
	shotgun_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 10,
			lerp_perfect = 14,
		},
		ammunition_reserve = {
			lerp_basic = 75,
			lerp_perfect = 95,
		},
	},
	shotgun_p1_m3 = {
		ammunition_clip = {
			lerp_basic = 6,
			lerp_perfect = 10,
		},
		ammunition_reserve = {
			lerp_basic = 45,
			lerp_perfect = 65,
		},
	},
	stubrevolver_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 5,
			lerp_perfect = 5,
		},
		ammunition_reserve = {
			lerp_basic = 35,
			lerp_perfect = 70,
		},
	},
	stubrevolver_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 5,
			lerp_perfect = 5,
		},
		ammunition_reserve = {
			lerp_basic = 55,
			lerp_perfect = 110,
		},
	},
	stubrevolver_p1_m3 = {
		ammunition_clip = {
			lerp_basic = 5,
			lerp_perfect = 5,
		},
		ammunition_reserve = {
			lerp_basic = 35,
			lerp_perfect = 70,
		},
	},
	stubrifle_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 8,
			lerp_perfect = 12,
		},
		ammunition_reserve = {
			lerp_basic = 80,
			lerp_perfect = 144,
		},
	},
	ogryn_heavystubber_p1_m1 = {
		ammunition_clip = {
			lerp_basic = 80,
			lerp_perfect = 130,
		},
		ammunition_reserve = {
			lerp_basic = 240,
			lerp_perfect = 520,
		},
	},
	ogryn_heavystubber_p1_m2 = {
		ammunition_clip = {
			lerp_basic = 50,
			lerp_perfect = 90,
		},
		ammunition_reserve = {
			lerp_basic = 150,
			lerp_perfect = 360,
		},
	},
	ogryn_heavystubber_p1_m3 = {
		ammunition_clip = {
			lerp_basic = 95,
			lerp_perfect = 150,
		},
		ammunition_reserve = {
			lerp_basic = 285,
			lerp_perfect = 600,
		},
	},
}

return settings("WeaponAmmoTemplates", weapon_ammo_templates)
