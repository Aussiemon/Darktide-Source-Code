local BotSettings = require("scripts/settings/bot/bot_settings")
local behavior_gestalts = BotSettings.behavior_gestalts

local function tutorial_bot_profiles(all_profiles)
	all_profiles.tutorial_guide = {
		selected_voice = "explicator_a",
		display_name = "Zola",
		gender = "female",
		archetype = "veteran",
		current_level = 1,
		specialization = "none",
		loadout = {
			slot_body_hair = "content/items/characters/player/human/hair/hair_medium_undercut_a",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_hispanic_02",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02_blind_right",
			slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/gear_torso/empty_torso",
			slot_primary = "content/items/weapons/player/melee/chainsword_p1_m1",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/zola_upperbody_01",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/female_facial_hair_b",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_secondary = "content/items/weapons/player/ranged/bot_zola_laspistol",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/scar_face_07",
			slot_body_face = "content/items/characters/player/human/faces/female_middle_eastern_face_02",
			slot_body_arms = "content/items/characters/player/human/attachment_base/female_arms",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/zola_lowerbody_01",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_red_02"
		},
		bot_gestalts = {
			melee = behavior_gestalts.linesman,
			ranged = behavior_gestalts.killshot
		},
		talents = {}
	}
	all_profiles.tutorial_guide_zealot = {
		selected_voice = "zealot_female_a",
		display_name = "Jilande",
		gender = "female",
		archetype = "zealot",
		current_level = 1,
		specialization = "none",
		loadout = {
			slot_body_hair = "content/items/characters/player/human/hair/hair_short_bobcut_a",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_asian_01",
			slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_brown_02",
			slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
			slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
			slot_body_torso = "content/items/characters/player/human/attachment_base/female_torso",
			slot_primary = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/d7_zealot_f_upperbody",
			slot_body_face_hair = "content/items/characters/player/human/face_hair/facial_hair_a_eyebrows",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_secondary = "content/items/weapons/player/ranged/bot_lasgun_killshot",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face = "content/items/characters/player/human/faces/female_asian_face_02",
			slot_body_arms = "content/items/characters/player/human/gear_arms/empty_arms",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/d7_zealot_f_lowerbody",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_black_02"
		},
		bot_gestalts = {
			melee = behavior_gestalts.linesman,
			ranged = behavior_gestalts.killshot
		},
		talents = {}
	}
	all_profiles.tutorial_guide_ogryn = {
		selected_voice = "ogryn_a",
		display_name = "Kreft",
		gender = "male",
		archetype = "ogryn",
		current_level = 1,
		specialization = "none",
		loadout = {
			slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
			slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_caucasian_02",
			slot_body_face_tattoo = "content/items/characters/player/ogryn/face_tattoo/face_tattoo_ogryn_01",
			slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_green_02",
			slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
			slot_body_tattoo = "content/items/characters/player/ogryn/body_tattoo/body_tattoo_ogryn_03",
			slot_body_torso = "content/items/characters/player/ogryn/attachment_base/male_torso",
			slot_primary = "content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
			slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/d7_ogryn_upperbody",
			slot_body_face_hair = "content/items/characters/player/ogryn/face_hair/ogryn_facial_hair_b_eyebrows",
			slot_body_legs = "content/items/characters/player/human/gear_legs/empty_legs",
			slot_secondary = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
			slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
			slot_body_face = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_02",
			slot_body_arms = "content/items/characters/player/ogryn/attachment_base/male_arms",
			slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/d7_ogryn_lowerbody",
			slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01"
		},
		bot_gestalts = {
			melee = behavior_gestalts.linesman,
			ranged = behavior_gestalts.killshot
		},
		talents = {}
	}
end

return tutorial_bot_profiles
