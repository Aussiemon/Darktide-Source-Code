local Archetypes = require("scripts/settings/archetype/archetypes")
local BotSettings = require("scripts/settings/bot/bot_settings")
local LocalProfileBackendParser = require("scripts/utilities/local_profile_backend_parser")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local behavior_gestalts = BotSettings.behavior_gestalts

local function bot_profiles(item_definitions)
	local profiles = {
		tutorial_guide = {
			selected_voice = "explicator_a",
			display_name = "Zola",
			archetype = "veteran",
			current_level = 1,
			hair_color = "hair_red_02",
			skin_color = "skin_hispanic_02",
			specialization = "none",
			loadout = {
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/female_arms"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_middle_eastern_face_02"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_medium_undercut_a"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/female_facial_hair_b"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/zola_lowerbody_01"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/zola_upperbody_01"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/laspistol_p1_m1"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/scar_face_07"]
			},
			abilities = {
				combat_ability = PlayerAbilities.veteran_ranger_ranged_stance,
				grenade_ability = PlayerAbilities.veteran_ranger_frag_grenade
			},
			talents = {}
		},
		tutorial_guide_zealot = {
			skin_color = "skin_asian_02",
			selected_voice = "zealot_female_a",
			archetype = "zealot",
			current_level = 1,
			hair_color = "hair_black_01",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/gear_arms/empty_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/attachment_base/female_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_asian_face_02"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_bobcut_a"],
				slot_primary = item_definitions["content/items/weapons/player/melee/thunderhammer_2h_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_zealot_f_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_zealot_f_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/empty_face_tattoo"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/facial_hair_a_eyebrows"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_02"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_asian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_02"]
			},
			abilities = {
				combat_ability = PlayerAbilities.zealot_targeted_dash,
				grenade_ability = PlayerAbilities.veteran_ranger_frag_grenade
			},
			talents = {}
		},
		tutorial_guide_ogryn = {
			skin_color = "skin_caucasian_01",
			selected_voice = "ogryn_a",
			archetype = "ogryn",
			current_level = 1,
			hair_color = "hair_brown_01",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/ogryn/attachment_base/male_arms"],
				slot_body_face = item_definitions["content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02"],
				slot_body_torso = item_definitions["content/items/characters/player/ogryn/attachment_base/male_torso"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_primary = item_definitions["content/items/weapons/player/melee/ogryn_combatblade_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/ogryn_rippergun_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_b_eyebrows"],
				slot_body_tattoo = item_definitions["content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_brown_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_green_02"]
			},
			abilities = {
				combat_ability = PlayerAbilities.ogryn_charge,
				grenade_ability = PlayerAbilities.ogryn_grenade
			},
			talents = {}
		},
		darktide_seven_01 = {
			current_level = 1,
			selected_voice = "veteran_male_a",
			gender = "male",
			archetype = "veteran",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/gear_arms/empty_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_middle_eastern_face_01"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_veteran_m_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_veteran_m_upperbody"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/d7_veteran_m_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/empty_face_tattoo"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/empty_face_hair"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_01"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		darktide_seven_02 = {
			current_level = 1,
			selected_voice = "ogryn_a",
			gender = "male",
			archetype = "ogryn",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/ogryn/attachment_base/male_arms"],
				slot_body_face = item_definitions["content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02"],
				slot_body_torso = item_definitions["content/items/characters/player/ogryn/attachment_base/male_torso"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_primary = item_definitions["content/items/weapons/player/melee/ogryn_combatblade_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/ogryn_rippergun_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_a_eyebrows"],
				slot_body_tattoo = item_definitions["content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_brown_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_green_02"]
			},
			talents = {}
		},
		darktide_seven_03 = {
			current_level = 1,
			selected_voice = "zealot_female_c",
			gender = "female",
			archetype = "zealot",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/female_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_asian_face_02"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_bobcut_a"],
				slot_primary = item_definitions["content/items/weapons/player/melee/thunderhammer_2h_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_zealot_f_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_zealot_f_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/empty_face_tattoo"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/female_facial_hair_base"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_02"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_asian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_02"]
			},
			talents = {}
		},
		darktide_seven_04 = {
			current_level = 1,
			selected_voice = "psyker_male_a",
			gender = "male",
			archetype = "psyker",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/male_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_african_face_01"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_primary = item_definitions["content/items/weapons/player/melee/forcesword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/forcestaff_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/d7_psyker_m_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_psyker_m_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_psyker_m_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_psyker_05"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/empty_face_hair"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_african_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_psyker_02"]
			},
			talents = {}
		},
		darktide_seven_05 = {
			current_level = 1,
			selected_voice = "veteran_female_b",
			gender = "female",
			archetype = "veteran",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/gear_arms/empty_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_caucasian_face_01"],
				slot_primary = item_definitions["content/items/weapons/player/melee/powersword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_veteran_f_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_veteran_f_upperbody"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/d7_veteran_f_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_veteran_06"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/empty_face_hair"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_e"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_brown_02"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_blue_01"]
			},
			talents = {}
		},
		darktide_seven_06 = {
			current_level = 1,
			selected_voice = "zealot_male_b",
			gender = "male",
			archetype = "zealot",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/male_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_caucasian_face_01"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_primary = item_definitions["content/items/weapons/player/melee/thunderhammer_2h_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/autogun_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/d7_zealot_m_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_zealot_m_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_zealot_m_upperbody"],
				slot_gear_extra_cosmetic = item_definitions["content/items/characters/player/human/backpacks/backpack_book_a"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_zealot_01"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/scar_face_05"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/facial_hair_a_goattee_sideburns"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_brown_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_blue_02"]
			},
			talents = {}
		},
		darktide_seven_07 = {
			current_level = 1,
			selected_voice = "psyker_female_a",
			gender = "female",
			archetype = "psyker",
			specialization = "none",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/female_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_asian_face_01"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_primary = item_definitions["content/items/weapons/player/melee/forcesword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/forcestaff_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/d7_psyker_f_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_psyker_f_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_psyker_f_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/empty_face_tattoo"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/empty_face_hair"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_pale_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_psyker_02"]
			},
			talents = {}
		},
		ogryn_c_the_brawler = {
			current_level = 1,
			selected_voice = "ogryn_c",
			gender = "male",
			specialization = "none",
			archetype = Archetypes.ogryn,
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/ogryn/attachment_base/male_arms"],
				slot_body_face = item_definitions["content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02"],
				slot_body_torso = item_definitions["content/items/characters/player/ogryn/attachment_base/male_torso"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_primary = item_definitions["content/items/weapons/player/melee/ogryn_combatblade_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/ogryn_rippergun_p1_m1"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_a_eyebrows"],
				slot_body_tattoo = item_definitions["content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_brown_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_green_02"]
			},
			talents = {}
		},
		bot_1 = {
			current_level = 1,
			selected_voice = "veteran_male_a",
			gender = "male",
			archetype = "veteran",
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/male_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_caucasian_face_01"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_05"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/scar_face_23"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/facial_hair_b_mustache_sideburns"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_c_02"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/body_tattoo_04"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_blonde_02"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_green_01"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_2 = {
			current_level = 1,
			selected_voice = "veteran_male_b",
			gender = "male",
			archetype = "veteran",
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/male_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_african_face_02"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_09"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/scar_face_28"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/facial_hair_c_goattee_mustache"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_modular_a_03"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/body_tattoo_10"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_african_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_02_blind_left"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_3 = {
			current_level = 1,
			selected_voice = "veteran_male_c",
			gender = "male",
			archetype = "veteran",
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/male_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_south_american_face_02"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_01"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/scar_face_25"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/facial_hair_a_goattee"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_buzzcut_c"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/body_tattoo_10"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_hispanic_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_01_blind_left"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_4 = {
			current_level = 1,
			selected_voice = "veteran_female_a",
			gender = "female",
			archetype = "veteran",
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/female_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_caucasian_face_01"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_01"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/female_facial_hair_c"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_e"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/body_tattoo_01"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_brown_02"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_02"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_5 = {
			current_level = 1,
			selected_voice = "veteran_female_b",
			gender = "female",
			archetype = "veteran",
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/female_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_african_face_04"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_04"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/scar_face_22"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/female_facial_hair_a"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_c_02"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_gray_03"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_african_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_02_blind_left"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_6 = {
			current_level = 1,
			selected_voice = "veteran_female_c",
			gender = "female",
			archetype = "veteran",
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/attachment_base/female_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/female_caucasian_face_04"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/empty_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/face_tattoo_05"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/female_facial_hair_d"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/hair_short_modular_b"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_red_02"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_pale_02"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_blue_01"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_training_grounds = {
			selected_voice = "veteran_male_a",
			display_name = "Brandt",
			gender = "male",
			archetype = "veteran",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_legs = item_definitions["content/items/characters/player/human/gear_legs/empty_legs"],
				slot_body_arms = item_definitions["content/items/characters/player/human/gear_arms/empty_arms"],
				slot_body_torso = item_definitions["content/items/characters/player/human/gear_torso/empty_torso"],
				slot_body_face = item_definitions["content/items/characters/player/human/faces/male_middle_eastern_face_01"],
				slot_primary = item_definitions["content/items/weapons/player/melee/chainsword_p1_m1"],
				slot_secondary = item_definitions["content/items/weapons/player/ranged/bot_lasgun_killshot"],
				slot_gear_lowerbody = item_definitions["content/items/characters/player/human/gear_lowerbody/d7_veteran_m_lowerbody"],
				slot_gear_upperbody = item_definitions["content/items/characters/player/human/gear_upperbody/d7_veteran_m_upperbody"],
				slot_gear_head = item_definitions["content/items/characters/player/human/gear_head/d7_veteran_m_headgear"],
				slot_body_face_tattoo = item_definitions["content/items/characters/player/human/face_tattoo/empty_face_tattoo"],
				slot_body_face_scar = item_definitions["content/items/characters/player/human/face_scars/empty_face_scar"],
				slot_body_face_hair = item_definitions["content/items/characters/player/human/face_hair/empty_face_hair"],
				slot_body_hair = item_definitions["content/items/characters/player/human/hair/empty_hair"],
				slot_body_tattoo = item_definitions["content/items/characters/player/human/body_tattoo/empty_body_tattoo"],
				slot_body_hair_color = item_definitions["content/items/characters/player/hair_colors/hair_color_black_01"],
				slot_body_skin_color = item_definitions["content/items/characters/player/skin_colors/skin_color_caucasian_01"],
				slot_body_eye_color = item_definitions["content/items/characters/player/eye_colors/eye_color_brown_01"]
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		}
	}

	for profile_name, profile in pairs(profiles) do
		LocalProfileBackendParser.parse_profile(profile, profile_name)
	end

	return profiles
end

return bot_profiles
