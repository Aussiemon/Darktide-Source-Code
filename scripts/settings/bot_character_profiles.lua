local Archetypes = require("scripts/settings/archetype/archetypes")
local BotSettings = require("scripts/settings/bot/bot_settings")
local LocalProfileBackendParser = require("scripts/utilities/local_profile_backend_parser")
local MasterItems = require("scripts/backend/master_items")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local behavior_gestalts = BotSettings.behavior_gestalts
local bot_profiles_cached = {}

local function bot_profiles(item_definitions)
	if bot_profiles_cached[item_definitions] then
		return bot_profiles_cached[item_definitions]
	end

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
				slot_body_hair = "content/items/characters/player/human/hair/hair_medium_undercut_a",
				slot_secondary = "content/items/weapons/player/ranged/bot_zola_laspistol",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_red_02",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_hispanic_02",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_07",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02_blind_right",
				slot_body_face = "content/items/characters/player/human/faces/female_middle_eastern_face_02",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
				slot_primary = "content/items/weapons/player/melee/chainsword_p1_m1",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/zola_lowerbody_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/zola_upperbody_01",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_b"
			},
			abilities = {
				combat_ability = PlayerAbilities.veteran_ranger_ranged_stance,
				grenade_ability = PlayerAbilities.veteran_ranger_frag_grenade
			},
			talents = {}
		},
		tutorial_guide_zealot = {
			selected_voice = "zealot_female_a",
			display_name = "Jilande",
			archetype = "zealot",
			current_level = 1,
			hair_color = "hair_black_01",
			skin_color = "skin_asian_02",
			specialization = "none",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_bobcut_a",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_a_eyebrows",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_02",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02",
				slot_body_torso = "content/items/characters/player/human/attachment_base/female_torso",
				slot_primary = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_zealot_f_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_asian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/female_asian_face_02",
				slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_zealot_f_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo"
			},
			abilities = {
				combat_ability = PlayerAbilities.zealot_targeted_dash,
				grenade_ability = PlayerAbilities.veteran_ranger_frag_grenade
			},
			talents = {}
		},
		tutorial_guide_ogryn = {
			selected_voice = "ogryn_a",
			display_name = "Kreft",
			archetype = "ogryn",
			current_level = 1,
			hair_color = "hair_brown_01",
			skin_color = "skin_caucasian_01",
			specialization = "none",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_face_hair = "content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_b_eyebrows",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_green_02",
				slot_body_torso = "content/items/characters/player/ogryn/attachment_base/male_torso",
				slot_primary = "content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02",
				slot_body_arms = "content/items/characters/player/ogryn/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01"
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
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
				slot_gear_head = "content/items/characters/player/human/gear_head/d7_veteran_m_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_01",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/chainsword_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_veteran_m_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/male_middle_eastern_face_01",
				slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_veteran_m_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo"
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
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_face_hair = "content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_a_eyebrows",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_green_02",
				slot_body_torso = "content/items/characters/player/ogryn/attachment_base/male_torso",
				slot_primary = "content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02",
				slot_body_arms = "content/items/characters/player/ogryn/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01"
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
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_bobcut_a",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_base",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/autogun_p1_m1",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_02",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_zealot_f_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_asian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/female_asian_face_02",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_zealot_f_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo"
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
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
				slot_gear_head = "content/items/characters/player/human/gear_head/d7_psyker_m_headgear",
				slot_secondary = "content/items/weapons/player/ranged/forcestaff_p1_m1",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_psyker_02",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/forcesword_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_psyker_m_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_african_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/male_african_face_01",
				slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_psyker_m_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_psyker_05"
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
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_e",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_02",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
				slot_gear_head = "content/items/characters/player/human/gear_head/d7_veteran_f_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_01",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/powersword_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_veteran_f_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/female_caucasian_face_01",
				slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_veteran_f_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_veteran_06"
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
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_gear_head = "content/items/characters/player/human/gear_head/d7_zealot_m_headgear",
				slot_secondary = "content/items/weapons/player/ranged/autogun_p1_m1",
				slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/backpack_book_a",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_02",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_zealot_m_upperbody",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_a_goattee_sideburns",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_05",
				slot_body_face = "content/items/characters/player/human/faces/male_caucasian_face_01",
				slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_zealot_m_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_zealot_01"
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
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
				slot_gear_head = "content/items/characters/player/human/gear_head/d7_psyker_f_headgear",
				slot_secondary = "content/items/weapons/player/ranged/forcestaff_p1_m1",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_psyker_02",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/forcesword_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_psyker_f_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_pale_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/female_asian_face_01",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_psyker_f_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo"
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
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_face_hair = "content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_a_eyebrows",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_green_02",
				slot_body_torso = "content/items/characters/player/ogryn/attachment_base/male_torso",
				slot_primary = "content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02",
				slot_body_arms = "content/items/characters/player/ogryn/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01"
			},
			talents = {}
		},
		bot_1 = {
			gender = "male",
			selected_voice = "veteran_male_a",
			planet = "option_1",
			archetype = "veteran",
			name_list_id = "male_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_c_02",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_blonde_02",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_b_mustache_sideburns",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_green_01",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/bot_combatsword_linesman_p1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/body_tattoo_04",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_23",
				slot_body_face = "content/items/characters/player/human/faces/male_caucasian_face_01",
				slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_05"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_2 = {
			gender = "male",
			selected_voice = "veteran_male_b",
			planet = "option_2",
			archetype = "veteran",
			name_list_id = "male_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_modular_a_03",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_c_goattee_mustache",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_autogun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02_blind_left",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/bot_combatsword_linesman_p1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_african_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/body_tattoo_10",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_28",
				slot_body_face = "content/items/characters/player/human/faces/male_african_face_02",
				slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_09"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_3 = {
			gender = "male",
			selected_voice = "veteran_male_c",
			planet = "option_3",
			archetype = "veteran",
			name_list_id = "male_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_buzzcut_c",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_a_goattee",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_autogun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_01_blind_left",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/bot_combatsword_linesman_p2",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_hispanic_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/body_tattoo_10",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_25",
				slot_body_face = "content/items/characters/player/human/faces/male_south_american_face_02",
				slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_01"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_4 = {
			gender = "female",
			selected_voice = "veteran_female_a",
			planet = "option_4",
			archetype = "veteran",
			name_list_id = "female_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_e",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_02",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_c",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_laspistol_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/bot_combatsword_linesman_p2",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/body_tattoo_01",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/female_caucasian_face_01",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_01"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_5 = {
			gender = "female",
			selected_voice = "veteran_female_b",
			planet = "option_5",
			archetype = "veteran",
			name_list_id = "female_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_c_02",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_gray_03",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_a",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_laspistol_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02_blind_left",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/bot_combataxe_linesman",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_african_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_22",
				slot_body_face = "content/items/characters/player/human/faces/female_african_face_04",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_04"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_6 = {
			gender = "female",
			selected_voice = "veteran_female_c",
			planet = "option_6",
			archetype = "veteran",
			name_list_id = "female_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/hair_short_modular_b",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_red_02",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_d",
				slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_01",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/bot_combataxe_linesman",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_pale_02",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/female_caucasian_face_04",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_05"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		},
		bot_training_grounds = {
			gender = "male",
			selected_voice = "veteran_male_a",
			archetype = "veteran",
			name_list_id = "male_names_1",
			current_level = 1,
			specialization = "veteran_2",
			loadout = {
				slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
				slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
				slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
				slot_gear_head = "content/items/characters/player/human/gear_head/d7_veteran_m_headgear",
				slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
				slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_01",
				slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
				slot_primary = "content/items/weapons/player/melee/chainsword_p1_m1",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_veteran_m_upperbody",
				slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
				slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
				slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
				slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
				slot_body_face = "content/items/characters/player/human/faces/male_middle_eastern_face_01",
				slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_veteran_m_lowerbody",
				slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo"
			},
			bot_gestalts = {
				melee = behavior_gestalts.linesman,
				ranged = behavior_gestalts.killshot
			},
			talents = {}
		}
	}

	for profile_name, profile in pairs(profiles) do
		local loadout = profile.loadout

		for slot_name, item_id in pairs(loadout) do
			local item = MasterItems.get_item_or_fallback(item_id, slot_name, item_definitions)
			loadout[slot_name] = item
		end

		LocalProfileBackendParser.parse_profile(profile, profile_name)
	end

	bot_profiles_cached[item_definitions] = profiles

	return profiles
end

return bot_profiles
