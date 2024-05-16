-- chunkname: @scripts/settings/bot_profiles/training_ground_bot_profiles.lua

local BotSettings = require("scripts/settings/bot/bot_settings")
local behavior_gestalts = BotSettings.behavior_gestalts

local function training_ground_bot_profiles(all_profiles)
	all_profiles.bot_training_grounds = {
		archetype = "veteran",
		current_level = 1,
		gender = "male",
		name_list_id = "male_names_1",
		selected_voice = "veteran_male_a",
		specialization = "veteran_2",
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
end

return training_ground_bot_profiles
