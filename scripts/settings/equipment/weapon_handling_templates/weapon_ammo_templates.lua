-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_ammo_templates.lua

local weapon_ammo_templates = {
	no_ammo = {
		ammunition_reserve = 0,
		ammunition_clips = {
			0,
		},
	},
	grenade = {
		ammunition_reserve = 0,
		ammunition_clips = {
			1,
		},
	},
	bolter_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 10,
				lerp_perfect = 20,
			},
		},
		ammunition_reserve = {
			lerp_basic = 75,
			lerp_perfect = 105,
		},
	},
	bolter_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 12,
				lerp_perfect = 12,
			},
		},
		ammunition_reserve = {
			lerp_basic = 72,
			lerp_perfect = 96,
		},
	},
	autogun_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 25,
				lerp_perfect = 40,
			},
		},
		ammunition_reserve = {
			lerp_basic = 250,
			lerp_perfect = 400,
		},
	},
	autogun_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 50,
				lerp_perfect = 60,
			},
		},
		ammunition_reserve = {
			lerp_basic = 500,
			lerp_perfect = 600,
		},
	},
	autogun_p1_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 40,
				lerp_perfect = 60,
			},
		},
		ammunition_reserve = {
			lerp_basic = 320,
			lerp_perfect = 480,
		},
	},
	autogun_p2_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 50,
				lerp_perfect = 80,
			},
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 600,
		},
	},
	autogun_p2_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 50,
				lerp_perfect = 80,
			},
		},
		ammunition_reserve = {
			lerp_basic = 500,
			lerp_perfect = 800,
		},
	},
	autogun_p2_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 30,
				lerp_perfect = 50,
			},
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 500,
		},
	},
	autogun_p3_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 36,
				lerp_perfect = 49,
			},
		},
		ammunition_reserve = {
			lerp_basic = 270,
			lerp_perfect = 405,
		},
	},
	autogun_p3_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 15,
				lerp_perfect = 21,
			},
		},
		ammunition_reserve = {
			lerp_basic = 150,
			lerp_perfect = 180,
		},
	},
	autogun_p3_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 22,
				lerp_perfect = 35,
			},
		},
		ammunition_reserve = {
			lerp_basic = 162,
			lerp_perfect = 270,
		},
	},
	autopistol_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 40,
				lerp_perfect = 60,
			},
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 600,
		},
	},
	dual_autopistols_p1_m1 = {
		force_even_numbers = true,
		ammunition_clips = {
			{
				lerp_basic = 40,
				lerp_perfect = 64,
			},
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 660,
		},
	},
	dual_shivs_p1_m1 = {
		ammunition_reserve = 0,
		force_even_numbers = true,
		ammunition_clips = {
			3,
		},
	},
	dual_stubpistols_p1_m1 = {
		force_even_numbers = true,
		ammunition_clips = {
			{
				lerp_basic = 10,
				lerp_perfect = 18,
			},
		},
		ammunition_reserve = {
			lerp_basic = 220,
			lerp_perfect = 280,
		},
	},
	needle_pistol_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 7,
			},
		},
		ammunition_reserve = {
			lerp_basic = 70,
			lerp_perfect = 110,
		},
	},
	flamer_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 20,
				lerp_perfect = 40,
			},
		},
		ammunition_reserve = {
			lerp_basic = 80,
			lerp_perfect = 200,
		},
	},
	ogryn_gauntlet_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 4,
				lerp_perfect = 6,
			},
		},
		ammunition_reserve = {
			lerp_basic = 32,
			lerp_perfect = 55,
		},
	},
	lasgun_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 800,
		},
	},
	lasgun_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 160,
			},
		},
		ammunition_reserve = {
			lerp_basic = 480,
			lerp_perfect = 1000,
		},
	},
	lasgun_p1_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p2_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p2_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p2_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p3_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 300,
			lerp_perfect = 720,
		},
	},
	lasgun_p3_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 100,
				lerp_perfect = 200,
			},
		},
		ammunition_reserve = {
			lerp_basic = 400,
			lerp_perfect = 1000,
		},
	},
	lasgun_p3_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 60,
				lerp_perfect = 120,
			},
		},
		ammunition_reserve = {
			lerp_basic = 420,
			lerp_perfect = 960,
		},
	},
	laspistol_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 40,
				lerp_perfect = 80,
			},
		},
		ammunition_reserve = {
			lerp_basic = 280,
			lerp_perfect = 560,
		},
	},
	laspistol_p1_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 45,
				lerp_perfect = 90,
			},
		},
		ammunition_reserve = {
			lerp_basic = 270,
			lerp_perfect = 540,
		},
	},
	plasmagun_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 75,
				lerp_perfect = 150,
			},
		},
		ammunition_reserve = {
			lerp_basic = 75,
			lerp_perfect = 150,
		},
	},
	ogryn_rippergun_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 12,
				lerp_perfect = 24,
			},
		},
		ammunition_reserve = {
			lerp_basic = 72,
			lerp_perfect = 192,
		},
	},
	ogryn_rippergun_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 10,
				lerp_perfect = 20,
			},
		},
		ammunition_reserve = {
			lerp_basic = 60,
			lerp_perfect = 140,
		},
	},
	ogryn_thumper_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 1,
				lerp_perfect = 1,
			},
		},
		ammunition_reserve = {
			lerp_basic = 32,
			lerp_perfect = 62,
		},
	},
	ogryn_thumper_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 1,
				lerp_perfect = 1,
			},
		},
		ammunition_reserve = {
			lerp_basic = 15,
			lerp_perfect = 30,
		},
	},
	shotgun_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 8,
				lerp_perfect = 12,
			},
		},
		ammunition_reserve = {
			lerp_basic = 70,
			lerp_perfect = 95,
		},
	},
	shotgun_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 10,
				lerp_perfect = 14,
			},
		},
		ammunition_reserve = {
			lerp_basic = 80,
			lerp_perfect = 105,
		},
	},
	shotgun_p1_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 6,
				lerp_perfect = 10,
			},
		},
		ammunition_reserve = {
			lerp_basic = 55,
			lerp_perfect = 85,
		},
	},
	shotgun_p2_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 2,
				lerp_perfect = 2,
			},
		},
		ammunition_reserve = {
			lerp_basic = 50,
			lerp_perfect = 90,
		},
	},
	shotgun_p4_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 7,
			},
		},
		ammunition_reserve = {
			lerp_basic = 45,
			lerp_perfect = 75,
		},
	},
	shotgun_p4_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 4,
				lerp_perfect = 4,
			},
		},
		ammunition_reserve = {
			lerp_basic = 40,
			lerp_perfect = 70,
		},
	},
	stubrevolver_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 5,
			},
		},
		ammunition_reserve = {
			lerp_basic = 35,
			lerp_perfect = 70,
		},
	},
	stubrevolver_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 5,
			},
		},
		ammunition_reserve = {
			lerp_basic = 55,
			lerp_perfect = 110,
		},
	},
	stubrevolver_p1_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 5,
			},
		},
		ammunition_reserve = {
			lerp_basic = 35,
			lerp_perfect = 70,
		},
	},
	ogryn_heavystubber_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 80,
				lerp_perfect = 130,
			},
		},
		ammunition_reserve = {
			lerp_basic = 240,
			lerp_perfect = 520,
		},
	},
	ogryn_heavystubber_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 50,
				lerp_perfect = 90,
			},
		},
		ammunition_reserve = {
			lerp_basic = 150,
			lerp_perfect = 360,
		},
	},
	ogryn_heavystubber_p1_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 95,
				lerp_perfect = 150,
			},
		},
		ammunition_reserve = {
			lerp_basic = 285,
			lerp_perfect = 600,
		},
	},
	ogryn_heavystubber_p2_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 40,
				lerp_perfect = 40,
			},
		},
		ammunition_reserve = {
			lerp_basic = 160,
			lerp_perfect = 240,
		},
	},
	ogryn_heavystubber_p2_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 30,
				lerp_perfect = 30,
			},
		},
		ammunition_reserve = {
			lerp_basic = 150,
			lerp_perfect = 150,
		},
	},
	ogryn_heavystubber_p2_m3 = {
		ammunition_clips = {
			{
				lerp_basic = 20,
				lerp_perfect = 20,
			},
		},
		ammunition_reserve = {
			lerp_basic = 100,
			lerp_perfect = 100,
		},
	},
	boltpistol_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 6,
				lerp_perfect = 10,
			},
		},
		ammunition_reserve = {
			lerp_basic = 80,
			lerp_perfect = 80,
		},
	},
	boltpistol_p1_m2 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 9,
			},
		},
		ammunition_reserve = {
			lerp_basic = 70,
			lerp_perfect = 70,
		},
	},
	shotpistol_shield_p1_m1 = {
		ammunition_clips = {
			{
				lerp_basic = 5,
				lerp_perfect = 5,
			},
		},
		ammunition_reserve = {
			lerp_basic = 45,
			lerp_perfect = 85,
		},
	},
}

return settings("WeaponAmmoTemplates", weapon_ammo_templates)
