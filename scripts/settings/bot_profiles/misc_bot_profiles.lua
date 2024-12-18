﻿-- chunkname: @scripts/settings/bot_profiles/misc_bot_profiles.lua

local BotSettings = require("scripts/settings/bot/bot_settings")
local behavior_gestalts = BotSettings.behavior_gestalts

local function misc_bot_profiles(all_profiles)
	all_profiles.darktide_seven_01 = {
		archetype = "veteran",
		current_level = 1,
		gender = "male",
		selected_voice = "veteran_male_a",
		loadout = {
			slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_01",
			slot_body_face = "content/items/characters/player/human/faces/male_middle_eastern_face_01",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo",
			slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_gear_head = "content/items/characters/player/human/gear_head/d7_veteran_m_headgear",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_veteran_m_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_veteran_m_upperbody",
			slot_primary = "content/items/weapons/player/melee/chainsword_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
		},
		bot_gestalts = {
			melee = behavior_gestalts.linesman,
			ranged = behavior_gestalts.killshot,
		},
		talents = {},
	}
	all_profiles.darktide_seven_02 = {
		archetype = "ogryn",
		current_level = 1,
		gender = "male",
		selected_voice = "ogryn_a",
		loadout = {
			slot_body_arms = "content/items/characters/player/ogryn/attachment_base/male_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_green_02",
			slot_body_face = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02",
			slot_body_face_hair = "content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_a_eyebrows",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face_tattoo = "content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01",
			slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_02",
			slot_body_tattoo = "content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03",
			slot_body_torso = "content/items/characters/player/ogryn/attachment_base/male_torso",
			slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
			slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody",
			slot_primary = "content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
		},
		talents = {},
	}
	all_profiles.darktide_seven_03 = {
		archetype = "zealot",
		current_level = 1,
		gender = "female",
		selected_voice = "zealot_female_c",
		loadout = {
			slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02",
			slot_body_face = "content/items/characters/player/human/faces/female_asian_face_02",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_base",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo",
			slot_body_hair = "content/items/characters/player/human/hair/hair_short_bobcut_a",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_02",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_asian_01",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_zealot_f_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_zealot_f_upperbody",
			slot_primary = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/autogun_p1_m1",
		},
		talents = {},
	}
	all_profiles.darktide_seven_04 = {
		archetype = "psyker",
		current_level = 1,
		gender = "male",
		selected_voice = "psyker_male_a",
		loadout = {
			slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_psyker_02",
			slot_body_face = "content/items/characters/player/human/faces/male_african_face_01",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_psyker_05",
			slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_african_02",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_gear_head = "content/items/characters/player/human/gear_head/d7_psyker_m_headgear",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_psyker_m_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_psyker_m_upperbody",
			slot_primary = "content/items/weapons/player/melee/forcesword_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/forcestaff_p1_m1",
		},
		talents = {},
	}
	all_profiles.darktide_seven_05 = {
		archetype = "veteran",
		current_level = 1,
		gender = "female",
		selected_voice = "veteran_female_b",
		loadout = {
			slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_01",
			slot_body_face = "content/items/characters/player/human/faces/female_caucasian_face_01",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_veteran_06",
			slot_body_hair = "content/items/characters/player/human/hair/hair_short_e",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_02",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_gear_head = "content/items/characters/player/human/gear_head/d7_veteran_f_headgear",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_veteran_f_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_veteran_f_upperbody",
			slot_primary = "content/items/weapons/player/melee/powersword_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
		},
		talents = {},
	}
	all_profiles.darktide_seven_06 = {
		archetype = "zealot",
		current_level = 1,
		gender = "male",
		selected_voice = "zealot_male_b",
		loadout = {
			slot_body_arms = "content/items/characters/player/human/attachment_base/male_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_02",
			slot_body_face = "content/items/characters/player/human/faces/male_caucasian_face_01",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_a_goattee_sideburns",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_05",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/face_tattoo_zealot_01",
			slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_01",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/backpack_book_a",
			slot_gear_head = "content/items/characters/player/human/gear_head/d7_zealot_m_headgear",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_zealot_m_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_zealot_m_upperbody",
			slot_primary = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/autogun_p1_m1",
		},
		talents = {},
	}
	all_profiles.darktide_seven_07 = {
		archetype = "psyker",
		current_level = 1,
		gender = "female",
		selected_voice = "psyker_female_a",
		loadout = {
			slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_psyker_02",
			slot_body_face = "content/items/characters/player/human/faces/female_asian_face_01",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo",
			slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_01",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_pale_01",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_gear_head = "content/items/characters/player/human/gear_head/d7_psyker_f_headgear",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_psyker_f_lowerbody",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_psyker_f_upperbody",
			slot_primary = "content/items/weapons/player/melee/forcesword_p1_m1",
			slot_secondary = "content/items/weapons/player/ranged/forcestaff_p1_m1",
		},
		talents = {},
	}
end

return misc_bot_profiles
