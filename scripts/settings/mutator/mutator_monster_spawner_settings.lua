-- chunkname: @scripts/settings/mutator/mutator_monster_spawner_settings.lua

local MutatorMonsterSpawnerSettings = {}

MutatorMonsterSpawnerSettings.default_locations = {
	lm_rails = {
		{
			section = 1,
			position = Vector3Box(186, -101, -15),
		},
		{
			section = 1,
			position = Vector3Box(139, -44, -11),
		},
		{
			section = 1,
			position = Vector3Box(39, -19, -7),
		},
		{
			section = 2,
			position = Vector3Box(37, 11, -13),
		},
		{
			section = 2,
			position = Vector3Box(21, 51, -35),
		},
		{
			section = 3,
			position = Vector3Box(40, 83, -38),
		},
		{
			section = 3,
			position = Vector3Box(-172, 269, -62),
		},
		{
			section = 3,
			position = Vector3Box(-193, 311, -59),
		},
	},
	cm_archives = {
		{
			section = 1,
			position = Vector3Box(168, 92, -4),
		},
		{
			section = 1,
			position = Vector3Box(112, 72, -11),
		},
		{
			section = 1,
			position = Vector3Box(163, 15, 0),
		},
		{
			section = 1,
			position = Vector3Box(83, 77, -14),
		},
		{
			section = 2,
			position = Vector3Box(-23, 96, -5),
		},
		{
			section = 2,
			position = Vector3Box(-149, 33, 2),
		},
		{
			section = 2,
			position = Vector3Box(-201, 37, 6),
		},
		{
			section = 3,
			position = Vector3Box(-273, -74, 6),
		},
		{
			section = 3,
			position = Vector3Box(-280, -115, -19),
		},
		{
			section = 3,
			position = Vector3Box(-290, -90, -46),
		},
	},
	core_research = {
		{
			section = 1,
			position = Vector3Box(-87, -227, 20),
		},
		{
			section = 1,
			position = Vector3Box(-56, -182, 19),
		},
		{
			section = 1,
			position = Vector3Box(-1.5, -126, 2),
		},
		{
			section = 2,
			position = Vector3Box(-2.5, 208, 11),
		},
		{
			section = 2,
			position = Vector3Box(2, 262, 12),
		},
		{
			section = 2,
			position = Vector3Box(24, 315, 17),
		},
		{
			section = 3,
			position = Vector3Box(-2, 362, 87),
		},
		{
			section = 3,
			position = Vector3Box(-13, 322, 92),
		},
	},
	hm_cartel = {
		{
			section = 1,
			position = Vector3Box(-93, -227, -6),
		},
		{
			section = 1,
			position = Vector3Box(-1.6, -134, 10),
		},
		{
			section = 1,
			position = Vector3Box(-90, -44, 18),
		},
		{
			section = 1,
			position = Vector3Box(-40, -236, 12),
		},
		{
			section = 2,
			position = Vector3Box(1, -87, 10),
		},
		{
			section = 2,
			position = Vector3Box(-57, -98, 10),
		},
		{
			section = 2,
			position = Vector3Box(7, -25, 13),
		},
		{
			section = 2,
			position = Vector3Box(17, 7, 11),
		},
		{
			section = 3,
			position = Vector3Box(144, 37, 32),
		},
		{
			section = 3,
			position = Vector3Box(298, 69, 37),
		},
	},
	cm_raid = {
		{
			section = 1,
			position = Vector3Box(-57, -136, -6),
		},
		{
			section = 1,
			position = Vector3Box(-135, -142, -8),
		},
		{
			section = 2,
			position = Vector3Box(-189, -207, -19),
		},
		{
			section = 2,
			position = Vector3Box(-246, -207, -19),
		},
		{
			section = 2,
			position = Vector3Box(-304, -257, -27),
		},
		{
			section = 2,
			position = Vector3Box(-334, -249, -102),
		},
		{
			section = 3,
			position = Vector3Box(-268, -180, -110),
		},
		{
			section = 3,
			position = Vector3Box(-226, -225, -108),
		},
	},
	dm_forge = {
		{
			section = 1,
			position = Vector3Box(-17, 208, 13),
		},
		{
			section = 1,
			position = Vector3Box(-17, 98, 7),
		},
		{
			section = 1,
			position = Vector3Box(11, 72, 5),
		},
		{
			section = 2,
			position = Vector3Box(48, -27, -13),
		},
		{
			section = 2,
			position = Vector3Box(7, -80, -12),
		},
		{
			section = 2,
			position = Vector3Box(41, -41, -24),
		},
		{
			section = 2,
			position = Vector3Box(64, -171, -24),
		},
		{
			section = 2,
			position = Vector3Box(30, -211, -24),
		},
		{
			section = 3,
			position = Vector3Box(109, -199, -30),
		},
		{
			section = 3,
			position = Vector3Box(140, -190, -30),
		},
		{
			section = 3,
			position = Vector3Box(157, -132, -30),
		},
	},
	dm_stockpile = {
		{
			section = 1,
			position = Vector3Box(198, 209, 35),
		},
		{
			section = 1,
			position = Vector3Box(212, 179, 34),
		},
		{
			section = 1,
			position = Vector3Box(212, 131, 32),
		},
		{
			section = 1,
			position = Vector3Box(167, 29, 33),
		},
		{
			section = 2,
			position = Vector3Box(104, 47, 32),
		},
		{
			section = 2,
			position = Vector3Box(37, 87, 5),
		},
		{
			section = 2,
			position = Vector3Box(15, 7, 11),
		},
		{
			section = 2,
			position = Vector3Box(14, 33, 10),
		},
		{
			section = 2,
			position = Vector3Box(-35, 89, 9),
		},
		{
			section = 3,
			position = Vector3Box(-69, 128, 9),
		},
		{
			section = 3,
			position = Vector3Box(-96, 172, 9),
		},
		{
			section = 3,
			position = Vector3Box(-179, 248, 5),
		},
	},
	hm_strain = {
		{
			section = 1,
			position = Vector3Box(-30, -47, -139),
		},
		{
			section = 1,
			position = Vector3Box(-37, -59, -103),
		},
		{
			section = 1,
			position = Vector3Box(-72, -54, -112),
		},
		{
			section = 2,
			position = Vector3Box(-114, 40, -102),
		},
		{
			section = 2,
			position = Vector3Box(-57, 55, -40),
		},
		{
			section = 3,
			position = Vector3Box(-50, 107, -48),
		},
		{
			section = 3,
			position = Vector3Box(-4, 169, -55),
		},
	},
	km_heresy = {
		{
			section = 1,
			position = Vector3Box(-76, -213, 4),
		},
		{
			section = 1,
			position = Vector3Box(-124, -132, -8),
		},
		{
			section = 1,
			position = Vector3Box(-46, -140, -7),
		},
		{
			section = 1,
			position = Vector3Box(-123, -190, -4),
		},
		{
			section = 2,
			position = Vector3Box(-53, -50, 2),
		},
		{
			section = 2,
			position = Vector3Box(-118, -65, -19),
		},
		{
			section = 2,
			position = Vector3Box(-43, -102, 2),
		},
		{
			section = 2,
			position = Vector3Box(-81, -82, -2),
		},
		{
			section = 2,
			position = Vector3Box(-55, -131, -24),
		},
		{
			section = 2,
			position = Vector3Box(-64, -89, -20),
		},
		{
			section = 3,
			position = Vector3Box(-33, -15, -19),
		},
		{
			section = 3,
			position = Vector3Box(14, 4, 0),
		},
		{
			section = 3,
			position = Vector3Box(75, 41, 10),
		},
		{
			section = 3,
			position = Vector3Box(133, 64, 15),
		},
		{
			section = 3,
			position = Vector3Box(114, 120, 19),
		},
	},
	fm_armoury = {
		{
			section = 1,
			position = Vector3Box(-223, -362, 1),
		},
		{
			section = 1,
			position = Vector3Box(-205, -320, -18),
		},
		{
			section = 1,
			position = Vector3Box(-240, -232, -19),
		},
		{
			section = 2,
			position = Vector3Box(-196, -196, -19),
		},
		{
			section = 2,
			position = Vector3Box(-261, -105, -13),
		},
		{
			section = 2,
			position = Vector3Box(-214, -63, -11),
		},
		{
			section = 2,
			position = Vector3Box(-156, -72, -13),
		},
		{
			section = 3,
			position = Vector3Box(-121, 7, -19),
		},
		{
			section = 3,
			position = Vector3Box(-55, -61, -11),
		},
		{
			section = 3,
			position = Vector3Box(-27, -72, -21),
		},
		{
			section = 3,
			position = Vector3Box(-67, -134, -24),
		},
		{
			section = 3,
			position = Vector3Box(54, -152, -32),
		},
	},
	dm_propaganda = {
		{
			section = 1,
			position = Vector3Box(26, 93, -0.5),
		},
		{
			section = 1,
			position = Vector3Box(4, 9, 2),
		},
		{
			section = 1,
			position = Vector3Box(50, 3, -0.9),
		},
		{
			section = 2,
			position = Vector3Box(-80, -2, -35),
		},
		{
			section = 2,
			position = Vector3Box(-114, 29, -12),
		},
		{
			section = 2,
			position = Vector3Box(-56, 56, -40),
		},
		{
			section = 3,
			position = Vector3Box(-150, 100, 1),
		},
		{
			section = 3,
			position = Vector3Box(-220, 103, -1),
		},
	},
	lm_scavenge = {
		{
			section = 1,
			position = Vector3Box(-21, 79, -0.8),
		},
		{
			section = 1,
			position = Vector3Box(82, 143, -11),
		},
		{
			section = 1,
			position = Vector3Box(89, 80, -38),
		},
		{
			section = 1,
			position = Vector3Box(78, 13, -46),
		},
		{
			section = 2,
			position = Vector3Box(27, -53, -61),
		},
		{
			section = 2,
			position = Vector3Box(-8, -68, -112),
		},
		{
			section = 2,
			position = Vector3Box(-31, -54, -111),
		},
		{
			section = 3,
			position = Vector3Box(-40, -85, -110),
		},
		{
			section = 3,
			position = Vector3Box(-52, -27, -112),
		},
		{
			section = 3,
			position = Vector3Box(-81, -59, -116),
		},
	},
	fm_resurgence = {
		{
			section = 1,
			position = Vector3Box(-208, 195, -16),
		},
		{
			section = 1,
			position = Vector3Box(-172, 234, -15),
		},
		{
			section = 1,
			position = Vector3Box(-82, 248, -7),
		},
		{
			section = 1,
			position = Vector3Box(-80, 156, -11),
		},
		{
			section = 1,
			position = Vector3Box(-28, 221, -2),
		},
		{
			section = 1,
			position = Vector3Box(-25, 181, -2),
		},
		{
			section = 2,
			position = Vector3Box(124, 142, -7),
		},
		{
			section = 2,
			position = Vector3Box(138, 118, -11),
		},
		{
			section = 2,
			position = Vector3Box(167, 92, -5),
		},
		{
			section = 2,
			position = Vector3Box(54, 228, -2),
		},
		{
			section = 2,
			position = Vector3Box(139, 201, -11),
		},
		{
			section = 2,
			position = Vector3Box(86, 233, -11),
		},
		{
			section = 3,
			position = Vector3Box(233, -10, 4),
		},
		{
			section = 3,
			position = Vector3Box(258, -72, -0.5),
		},
		{
			section = 3,
			position = Vector3Box(338, -156, 2),
		},
		{
			section = 3,
			position = Vector3Box(314, -202, 11),
		},
	},
	hm_complex = {
		{
			section = 1,
			position = Vector3Box(142, 200, -11),
		},
		{
			section = 1,
			position = Vector3Box(38, 173, -2),
		},
		{
			section = 1,
			position = Vector3Box(35, 221, -2),
		},
		{
			section = 1,
			position = Vector3Box(-81, 157, -11),
		},
		{
			section = 2,
			position = Vector3Box(-194.5, 239.4, -16),
		},
		{
			section = 2,
			position = Vector3Box(-200, 165, -16),
		},
		{
			section = 2,
			position = Vector3Box(-274, 137, -29),
		},
		{
			section = 3,
			position = Vector3Box(-231, 11, 2),
		},
		{
			section = 3,
			position = Vector3Box(-165, 32, 0.5),
		},
		{
			section = 3,
			position = Vector3Box(-149, -3, 4),
		},
	},
	km_station = {
		{
			section = 1,
			position = Vector3Box(-3, -225, -3),
		},
		{
			section = 1,
			position = Vector3Box(2, -200, -11),
		},
		{
			section = 1,
			position = Vector3Box(29, -198, -3),
		},
		{
			section = 2,
			position = Vector3Box(76, -105, -1),
		},
		{
			section = 2,
			position = Vector3Box(66, -83, -5),
		},
		{
			section = 2,
			position = Vector3Box(84, -17, -8),
		},
		{
			section = 2,
			position = Vector3Box(30, -49, -8),
		},
		{
			section = 3,
			position = Vector3Box(-6, -32, -5),
		},
		{
			section = 3,
			position = Vector3Box(-44, -12, -4),
		},
		{
			section = 3,
			position = Vector3Box(-68, 30, -4),
		},
		{
			section = 3,
			position = Vector3Box(-43, -6, 7),
		},
		{
			section = 3,
			position = Vector3Box(-86, -3, 7),
		},
		{
			section = 3,
			position = Vector3Box(-87, -118, -3),
		},
	},
	cm_habs = {
		{
			section = 1,
			position = Vector3Box(186, -101, -15),
		},
		{
			section = 1,
			position = Vector3Box(119, -159, -14),
		},
		{
			section = 1,
			position = Vector3Box(128, -169, -5),
		},
		{
			section = 2,
			position = Vector3Box(128, -238, -5),
		},
		{
			section = 2,
			position = Vector3Box(111, -148, 4),
		},
		{
			section = 3,
			position = Vector3Box(111, -230, 18),
		},
		{
			section = 3,
			position = Vector3Box(176, -311, 9),
		},
		{
			section = 3,
			position = Vector3Box(283, -350, 7),
		},
	},
	km_enforcer = {
		{
			section = 1,
			position = Vector3Box(216, -83, -1),
		},
		{
			section = 1,
			position = Vector3Box(68, -114, -3),
		},
		{
			section = 1,
			position = Vector3Box(68, -127, -3),
		},
		{
			section = 1,
			position = Vector3Box(29, -91, 16),
		},
		{
			section = 2,
			position = Vector3Box(-60, -65, 14),
		},
		{
			section = 2,
			position = Vector3Box(-73, -36, 16),
		},
		{
			section = 2,
			position = Vector3Box(-109, -72, 12),
		},
		{
			section = 2,
			position = Vector3Box(-129, -38, 15),
		},
		{
			section = 3,
			position = Vector3Box(-178, -35, 22),
		},
		{
			section = 3,
			position = Vector3Box(-231, -20, 28),
		},
		{
			section = 3,
			position = Vector3Box(-295, -52, 23),
		},
		{
			section = 3,
			position = Vector3Box(-396.378, -59.0339, 17.65),
		},
	},
	lm_cooling = {
		{
			section = 1,
			position = Vector3Box(168, -323, -17),
		},
		{
			section = 1,
			position = Vector3Box(122, -258, -18),
		},
		{
			section = 1,
			position = Vector3Box(119, -238, -16),
		},
		{
			section = 1,
			position = Vector3Box(61, -214, -24),
		},
		{
			section = 2,
			position = Vector3Box(66, -177, -24),
		},
		{
			section = 2,
			position = Vector3Box(-1, -209, -30),
		},
		{
			section = 2,
			position = Vector3Box(-46, -179, -22),
		},
		{
			section = 3,
			position = Vector3Box(-46, -94, -12),
		},
		{
			section = 3,
			position = Vector3Box(-48, -160, -6),
		},
		{
			section = 3,
			position = Vector3Box(-88, -51, -27),
		},
	},
	fm_cargo = {
		{
			section = 1,
			position = Vector3Box(135, 60, -8),
		},
		{
			section = 1,
			position = Vector3Box(117, 63, -8),
		},
		{
			section = 1,
			position = Vector3Box(86, 36, -7),
		},
		{
			section = 1,
			position = Vector3Box(103, 22, -8),
		},
		{
			section = 2,
			position = Vector3Box(30, 37, 8),
		},
		{
			section = 2,
			position = Vector3Box(-24, 36, 5),
		},
		{
			section = 2,
			position = Vector3Box(9, 15, 5),
		},
		{
			section = 2,
			position = Vector3Box(-105, 6, 1),
		},
		{
			section = 2,
			position = Vector3Box(-141, -34, 0),
		},
		{
			section = 3,
			position = Vector3Box(-150, -98, -8),
		},
		{
			section = 3,
			position = Vector3Box(-78, -158, -13),
		},
		{
			section = 3,
			position = Vector3Box(-86, -182, -13),
		},
	},
	dm_rise = {
		{
			section = 1,
			position = Vector3Box(167, -30, -8),
		},
		{
			section = 1,
			position = Vector3Box(120, -24, -10),
		},
		{
			section = 2,
			position = Vector3Box(89, -80, -13),
		},
		{
			section = 2,
			position = Vector3Box(-51, -73, -22),
		},
		{
			section = 2,
			position = Vector3Box(-101, -71, -22),
		},
		{
			section = 3,
			position = Vector3Box(-118, -88, -22),
		},
		{
			section = 3,
			position = Vector3Box(-111, -82, -35),
		},
		{
			section = 3,
			position = Vector3Box(-73, 74, -38),
		},
		{
			section = 3,
			position = Vector3Box(-125, -5, -38),
		},
		{
			section = 3,
			position = Vector3Box(-113, 37, -38),
		},
		{
			section = 3,
			position = Vector3Box(44, 228, -38),
		},
	},
}
MutatorMonsterSpawnerSettings.skulls_locations = {
	lm_rails = {
		{
			section = 1,
			position = Vector3Box(176, -101, -16),
		},
		{
			section = 1,
			position = Vector3Box(139, -44, -11),
		},
		{
			section = 1,
			position = Vector3Box(39, -19, -7),
		},
		{
			section = 2,
			position = Vector3Box(37, 11, -13),
		},
		{
			section = 2,
			position = Vector3Box(21, 51, -35),
		},
		{
			section = 3,
			position = Vector3Box(40, 83, -38),
		},
		{
			section = 3,
			position = Vector3Box(-172, 269, -62),
		},
		{
			section = 3,
			position = Vector3Box(-195, 311, -58),
		},
	},
	cm_archives = {
		{
			section = 1,
			position = Vector3Box(168, 92, -4),
		},
		{
			section = 1,
			position = Vector3Box(112, 72, -11),
		},
		{
			section = 1,
			position = Vector3Box(163, 15, 0),
		},
		{
			section = 1,
			position = Vector3Box(83, 77, -14),
		},
		{
			section = 2,
			position = Vector3Box(-23, 96, -5),
		},
		{
			section = 2,
			position = Vector3Box(-149, 33, 2),
		},
		{
			section = 2,
			position = Vector3Box(-201, 37, 6),
		},
		{
			section = 3,
			position = Vector3Box(-273, -74, 6),
		},
		{
			section = 3,
			position = Vector3Box(-280, -115, -19),
		},
		{
			section = 3,
			position = Vector3Box(-292, -90, -46),
		},
	},
	core_research = {
		{
			section = 1,
			position = Vector3Box(-124, -247, 27),
		},
		{
			section = 1,
			position = Vector3Box(-56, -182, 19),
		},
		{
			section = 1,
			position = Vector3Box(-1.5, -126, 2),
		},
		{
			section = 2,
			position = Vector3Box(-0.8, 234, 12),
		},
		{
			section = 2,
			position = Vector3Box(2, 262, 12),
		},
		{
			section = 2,
			position = Vector3Box(24, 315, 17),
		},
		{
			section = 3,
			position = Vector3Box(-2, 362, 87),
		},
		{
			section = 3,
			position = Vector3Box(-13, 322, 92),
		},
	},
	hm_cartel = {
		{
			section = 1,
			position = Vector3Box(-93, -227, -6),
		},
		{
			section = 1,
			position = Vector3Box(-1.6, -134, 10),
		},
		{
			section = 1,
			position = Vector3Box(-90, -44, 18),
		},
		{
			section = 1,
			position = Vector3Box(-40, -236, 12),
		},
		{
			section = 2,
			position = Vector3Box(1, -87, 10),
		},
		{
			section = 2,
			position = Vector3Box(-57, -98, 10),
		},
		{
			section = 2,
			position = Vector3Box(7, -25, 13),
		},
		{
			section = 2,
			position = Vector3Box(17, 7, 11),
		},
		{
			section = 3,
			position = Vector3Box(144, 37, 32),
		},
		{
			section = 3,
			position = Vector3Box(298, 69, 37),
		},
	},
	cm_raid = {
		{
			section = 1,
			position = Vector3Box(-57, -136, -6),
		},
		{
			section = 1,
			position = Vector3Box(-135, -142, -8),
		},
		{
			section = 2,
			position = Vector3Box(-189, -207, -19),
		},
		{
			section = 2,
			position = Vector3Box(-246, -207, -19),
		},
		{
			section = 2,
			position = Vector3Box(-304, -257, -27),
		},
		{
			section = 2,
			position = Vector3Box(-306, -245, -107),
		},
		{
			section = 3,
			position = Vector3Box(-268, -180, -110),
		},
		{
			section = 3,
			position = Vector3Box(-226, -225, -108),
		},
	},
	dm_forge = {
		{
			section = 1,
			position = Vector3Box(-17, 208, 13),
		},
		{
			section = 1,
			position = Vector3Box(-17, 98, 7),
		},
		{
			section = 1,
			position = Vector3Box(11, 72, 5),
		},
		{
			section = 2,
			position = Vector3Box(48, -27, -13),
		},
		{
			section = 2,
			position = Vector3Box(7, -80, -12),
		},
		{
			section = 2,
			position = Vector3Box(41, -41, -24),
		},
		{
			section = 2,
			position = Vector3Box(64, -175, -24),
		},
		{
			section = 2,
			position = Vector3Box(30, -211, -24),
		},
		{
			section = 3,
			position = Vector3Box(109, -199, -30),
		},
		{
			section = 3,
			position = Vector3Box(140, -190, -30),
		},
		{
			section = 3,
			position = Vector3Box(157, -132, -30),
		},
	},
	dm_stockpile = {
		{
			section = 1,
			position = Vector3Box(198, 209, 35),
		},
		{
			section = 1,
			position = Vector3Box(212, 179, 34),
		},
		{
			section = 1,
			position = Vector3Box(212, 131, 32),
		},
		{
			section = 1,
			position = Vector3Box(167, 29, 33),
		},
		{
			section = 2,
			position = Vector3Box(104, 47, 32),
		},
		{
			section = 2,
			position = Vector3Box(37, 87, 5),
		},
		{
			section = 2,
			position = Vector3Box(15, 7, 11),
		},
		{
			section = 2,
			position = Vector3Box(14, 33, 10),
		},
		{
			section = 2,
			position = Vector3Box(-35, 89, 9),
		},
		{
			section = 3,
			position = Vector3Box(-69, 128, 9),
		},
		{
			section = 3,
			position = Vector3Box(-96, 172, 9),
		},
		{
			section = 3,
			position = Vector3Box(-179, 248, 5),
		},
	},
	hm_strain = {
		{
			section = 1,
			position = Vector3Box(-30, -47, -139),
		},
		{
			section = 1,
			position = Vector3Box(-37, -59, -103),
		},
		{
			section = 1,
			position = Vector3Box(-72, -54, -112),
		},
		{
			section = 2,
			position = Vector3Box(-114, 40, -102),
		},
		{
			section = 2,
			position = Vector3Box(-97, 59, -29),
		},
		{
			section = 2,
			position = Vector3Box(-57, 55, -40),
		},
		{
			section = 3,
			position = Vector3Box(-50, 107, -48),
		},
		{
			section = 3,
			position = Vector3Box(-12.5, 88, -49),
		},
		{
			section = 3,
			position = Vector3Box(-4, 169, -55),
		},
	},
	km_heresy = {
		{
			section = 1,
			position = Vector3Box(-76, -213, 4),
		},
		{
			section = 1,
			position = Vector3Box(-124, -132, -8),
		},
		{
			section = 1,
			position = Vector3Box(-46, -140, -7),
		},
		{
			section = 2,
			position = Vector3Box(-53, -50, 2),
		},
		{
			section = 2,
			position = Vector3Box(-118, -65, -19),
		},
		{
			section = 2,
			position = Vector3Box(-43, -102, 2),
		},
		{
			section = 2,
			position = Vector3Box(-81, -82, -2),
		},
		{
			section = 2,
			position = Vector3Box(-55, -131, -24),
		},
		{
			section = 2,
			position = Vector3Box(-64, -89, -20),
		},
		{
			section = 3,
			position = Vector3Box(-33, -15, -19),
		},
		{
			section = 3,
			position = Vector3Box(14, 4, 0),
		},
		{
			section = 3,
			position = Vector3Box(75, 41, 10),
		},
		{
			section = 3,
			position = Vector3Box(133, 64, 15),
		},
		{
			section = 3,
			position = Vector3Box(114, 120, 19),
		},
	},
	fm_armoury = {
		{
			section = 1,
			position = Vector3Box(-205, -320, -18),
		},
		{
			section = 1,
			position = Vector3Box(-240, -232, -19),
		},
		{
			section = 2,
			position = Vector3Box(-196, -196, -19),
		},
		{
			section = 2,
			position = Vector3Box(-261, -105, -13),
		},
		{
			section = 2,
			position = Vector3Box(-214, -63, -11),
		},
		{
			section = 2,
			position = Vector3Box(-179, -45, -16),
		},
		{
			section = 3,
			position = Vector3Box(-121, 7, -19),
		},
		{
			section = 3,
			position = Vector3Box(-55, -61, -11),
		},
		{
			section = 3,
			position = Vector3Box(-27, -72, -21),
		},
		{
			section = 3,
			position = Vector3Box(-67, -134, -24),
		},
		{
			section = 3,
			position = Vector3Box(54, -152, -32),
		},
	},
	dm_propaganda = {
		{
			section = 1,
			position = Vector3Box(26, 93, -0.5),
		},
		{
			section = 1,
			position = Vector3Box(4, 9, 2),
		},
		{
			section = 2,
			position = Vector3Box(-97, 59, -29),
		},
		{
			section = 2,
			position = Vector3Box(-73, 60, -40),
		},
		{
			section = 2,
			position = Vector3Box(-56, 56, -40),
		},
		{
			section = 3,
			position = Vector3Box(-150, 100, 1),
		},
		{
			section = 3,
			position = Vector3Box(-220, 103, -1),
		},
	},
	lm_scavenge = {
		{
			section = 1,
			position = Vector3Box(-21, 79, -0.8),
		},
		{
			section = 1,
			position = Vector3Box(78, 128, -11),
		},
		{
			section = 1,
			position = Vector3Box(89, 80, -38),
		},
		{
			section = 1,
			position = Vector3Box(78, 13, -46),
		},
		{
			section = 2,
			position = Vector3Box(27, -53, -61),
		},
		{
			section = 2,
			position = Vector3Box(-8, -68, -112),
		},
		{
			section = 2,
			position = Vector3Box(-31, -54, -111),
		},
		{
			section = 3,
			position = Vector3Box(-40, -85, -110),
		},
		{
			section = 3,
			position = Vector3Box(-51, -24, -111),
		},
		{
			section = 3,
			position = Vector3Box(-76, -69, -112),
		},
	},
	fm_resurgence = {
		{
			section = 1,
			position = Vector3Box(-208, 195, -16),
		},
		{
			section = 1,
			position = Vector3Box(-172, 234, -15),
		},
		{
			section = 1,
			position = Vector3Box(-82, 248, -7),
		},
		{
			section = 1,
			position = Vector3Box(-80, 156, -11),
		},
		{
			section = 1,
			position = Vector3Box(-28, 221, -2),
		},
		{
			section = 1,
			position = Vector3Box(-31, 170, -2),
		},
		{
			section = 2,
			position = Vector3Box(124, 142, -7),
		},
		{
			section = 2,
			position = Vector3Box(138, 118, -11),
		},
		{
			section = 2,
			position = Vector3Box(167, 92, -5),
		},
		{
			section = 2,
			position = Vector3Box(54, 228, -2),
		},
		{
			section = 2,
			position = Vector3Box(139, 201, -11),
		},
		{
			section = 2,
			position = Vector3Box(86, 233, -11),
		},
		{
			section = 3,
			position = Vector3Box(233, -10, 4),
		},
		{
			section = 3,
			position = Vector3Box(277, -87, -0.4),
		},
		{
			section = 3,
			position = Vector3Box(338, -156, 2),
		},
		{
			section = 3,
			position = Vector3Box(314, -202, 11),
		},
	},
	hm_complex = {
		{
			section = 1,
			position = Vector3Box(142, 200, -11),
		},
		{
			section = 1,
			position = Vector3Box(38, 173, -2),
		},
		{
			section = 1,
			position = Vector3Box(35, 221, -2),
		},
		{
			section = 1,
			position = Vector3Box(-81, 157, -11),
		},
		{
			section = 2,
			position = Vector3Box(-140, 220, -11),
		},
		{
			section = 2,
			position = Vector3Box(-200, 165, -16),
		},
		{
			section = 2,
			position = Vector3Box(-274, 137, -29),
		},
		{
			section = 3,
			position = Vector3Box(-231, 11, 2),
		},
		{
			section = 3,
			position = Vector3Box(-165, 32, 0.5),
		},
		{
			section = 3,
			position = Vector3Box(-149, -3, 4),
		},
	},
	km_station = {
		{
			section = 1,
			position = Vector3Box(-3, -225, -3),
		},
		{
			section = 1,
			position = Vector3Box(2, -200, -11),
		},
		{
			section = 1,
			position = Vector3Box(16, -209, -7),
		},
		{
			section = 2,
			position = Vector3Box(76, -105, -1),
		},
		{
			section = 2,
			position = Vector3Box(66, -83, -5),
		},
		{
			section = 2,
			position = Vector3Box(84, -17, -8),
		},
		{
			section = 2,
			position = Vector3Box(30, -49, -8),
		},
		{
			section = 3,
			position = Vector3Box(-6, -32, -5),
		},
		{
			section = 3,
			position = Vector3Box(-44, -12, -4),
		},
		{
			section = 3,
			position = Vector3Box(-68, 30, -4),
		},
		{
			section = 3,
			position = Vector3Box(-43, -6, 7),
		},
		{
			section = 3,
			position = Vector3Box(-86, -3, 7),
		},
		{
			section = 3,
			position = Vector3Box(-87, -118, -3),
		},
	},
	cm_habs = {
		{
			section = 1,
			position = Vector3Box(161, -113, -16),
		},
		{
			section = 1,
			position = Vector3Box(119, -159, -14),
		},
		{
			section = 1,
			position = Vector3Box(128, -169, -5),
		},
		{
			section = 2,
			position = Vector3Box(128, -238, -5),
		},
		{
			section = 2,
			position = Vector3Box(113, -146, 3),
		},
		{
			section = 3,
			position = Vector3Box(111, -230, 18),
		},
		{
			section = 3,
			position = Vector3Box(173, -331, 9),
		},
		{
			section = 3,
			position = Vector3Box(283, -350, 7),
		},
	},
	km_enforcer = {
		{
			section = 1,
			position = Vector3Box(213, -82, -1),
		},
		{
			section = 1,
			position = Vector3Box(68, -114, -3),
		},
		{
			section = 1,
			position = Vector3Box(68, -127, -3),
		},
		{
			section = 1,
			position = Vector3Box(29, -91, 16),
		},
		{
			section = 2,
			position = Vector3Box(-60, -65, 14),
		},
		{
			section = 2,
			position = Vector3Box(-73, -36, 16),
		},
		{
			section = 2,
			position = Vector3Box(-107, -71, 12),
		},
		{
			section = 2,
			position = Vector3Box(-129, -38, 15),
		},
		{
			section = 3,
			position = Vector3Box(-178, -35, 22),
		},
		{
			section = 3,
			position = Vector3Box(-231, -20, 28),
		},
		{
			section = 3,
			position = Vector3Box(-295, -52, 23),
		},
		{
			section = 3,
			position = Vector3Box(-396.378, -59.0339, 17.65),
		},
	},
	lm_cooling = {
		{
			section = 1,
			position = Vector3Box(168, -323, -17),
		},
		{
			section = 1,
			position = Vector3Box(122, -258, -18),
		},
		{
			section = 1,
			position = Vector3Box(61, -214, -24),
		},
		{
			section = 2,
			position = Vector3Box(66, -177, -24),
		},
		{
			section = 2,
			position = Vector3Box(-1, -209, -30),
		},
		{
			section = 2,
			position = Vector3Box(-46, -179, -22),
		},
		{
			section = 3,
			position = Vector3Box(-44, -88, -18),
		},
		{
			section = 3,
			position = Vector3Box(-48, -160, -6),
		},
		{
			section = 3,
			position = Vector3Box(-88, -51, -27),
		},
	},
	fm_cargo = {
		{
			section = 1,
			position = Vector3Box(135, 60, -8),
		},
		{
			section = 1,
			position = Vector3Box(86, 36, -7),
		},
		{
			section = 1,
			position = Vector3Box(103, 22, -8),
		},
		{
			section = 2,
			position = Vector3Box(30, 37, 8),
		},
		{
			section = 2,
			position = Vector3Box(-24, 36, 5),
		},
		{
			section = 2,
			position = Vector3Box(9, 15, 5),
		},
		{
			section = 2,
			position = Vector3Box(-105, 6, 1),
		},
		{
			section = 2,
			position = Vector3Box(-141, -34, 0),
		},
		{
			section = 3,
			position = Vector3Box(-150, -98, -8),
		},
		{
			section = 3,
			position = Vector3Box(-78, -158, -13),
		},
		{
			section = 3,
			position = Vector3Box(-86, -182, -13),
		},
	},
	dm_rise = {
		{
			section = 1,
			position = Vector3Box(167, -30, -8),
		},
		{
			section = 1,
			position = Vector3Box(120, -24, -10),
		},
		{
			section = 2,
			position = Vector3Box(89, -80, -13),
		},
		{
			section = 2,
			position = Vector3Box(-51, -73, -22),
		},
		{
			section = 2,
			position = Vector3Box(-101, -71, -22),
		},
		{
			section = 3,
			position = Vector3Box(-118, -88, -22),
		},
		{
			section = 3,
			position = Vector3Box(-111, -82, -35),
		},
		{
			section = 3,
			position = Vector3Box(-73, 74, -38),
		},
		{
			section = 3,
			position = Vector3Box(-125, -5, -38),
		},
		{
			section = 3,
			position = Vector3Box(-113, 37, -38),
		},
		{
			section = 3,
			position = Vector3Box(44, 228, -38),
		},
	},
}

return MutatorMonsterSpawnerSettings
