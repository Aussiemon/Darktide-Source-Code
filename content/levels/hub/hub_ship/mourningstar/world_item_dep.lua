﻿-- chunkname: @content/levels/hub/hub_ship/mourningstar/world_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/eye_colors/eye_color_blue_01"] = 1,
		["content/items/characters/player/hair_colors/hair_color_black_01"] = 1,
		["content/items/characters/player/hair_colors/hair_color_red_04"] = 1,
		["content/items/characters/player/human/attachment_base/female_arms"] = 6,
		["content/items/characters/player/human/attachment_base/male_arms"] = 9,
		["content/items/characters/player/human/attachment_base/male_torso"] = 3,
		["content/items/characters/player/human/attachment_base/training_grounds_psyker_female_arms"] = 2,
		["content/items/characters/player/human/attachment_base/training_grounds_psyker_female_legs"] = 1,
		["content/items/characters/player/human/attachment_base/training_grounds_psyker_female_torso"] = 1,
		["content/items/characters/player/human/cine_props/arms_02_hand_01_cine_left"] = 1,
		["content/items/characters/player/human/cine_props/bonesaw_01"] = 1,
		["content/items/characters/player/human/cine_props/dataslate_01_left"] = 1,
		["content/items/characters/player/human/cine_props/quill_01"] = 1,
		["content/items/characters/player/human/cine_props/servo_skull_01"] = 1,
		["content/items/characters/player/human/face_hair/facial_hair_a_eyebrows"] = 3,
		["content/items/characters/player/human/face_hair/facial_hair_b_eyebrows"] = 3,
		["content/items/characters/player/human/face_hair/facial_hair_b_fullbeard"] = 1,
		["content/items/characters/player/human/face_hair/facial_hair_b_mustache"] = 1,
		["content/items/characters/player/human/face_hair/facial_hair_c_eyebrows"] = 2,
		["content/items/characters/player/human/face_hair/facial_hair_c_fullbeard"] = 1,
		["content/items/characters/player/human/face_hair/facial_hair_fullgoatee_a"] = 2,
		["content/items/characters/player/human/face_hair/female_facial_hair_a"] = 1,
		["content/items/characters/player/human/face_hair/female_facial_hair_b"] = 1,
		["content/items/characters/player/human/face_hair/female_facial_hair_base"] = 3,
		["content/items/characters/player/human/face_hair/female_facial_hair_e"] = 1,
		["content/items/characters/player/human/face_hair/female_facial_hair_f"] = 1,
		["content/items/characters/player/human/face_implants/bioniceye_b"] = 2,
		["content/items/characters/player/human/face_implants/bioniceye_g"] = 1,
		["content/items/characters/player/human/face_implants/temple_cables_c"] = 1,
		["content/items/characters/player/human/face_scars/scar_face_02"] = 1,
		["content/items/characters/player/human/face_scars/scar_face_07"] = 1,
		["content/items/characters/player/human/face_scars/scar_face_30"] = 1,
		["content/items/characters/player/human/face_tattoo/face_tattoo_psyker_01"] = 1,
		["content/items/characters/player/human/face_tattoo/face_tattoo_traitor"] = 1,
		["content/items/characters/player/human/face_tattoo/face_tattoo_traitor_servitor"] = 1,
		["content/items/characters/player/human/faces/face_hestia_prine"] = 1,
		["content/items/characters/player/human/faces/face_iven_rannick"] = 1,
		["content/items/characters/player/human/faces/female_african_face_01"] = 1,
		["content/items/characters/player/human/faces/female_african_face_04"] = 1,
		["content/items/characters/player/human/faces/female_asian_face_04"] = 3,
		["content/items/characters/player/human/faces/female_middle_eastern_face_02"] = 1,
		["content/items/characters/player/human/faces/male_african_face_01"] = 2,
		["content/items/characters/player/human/faces/male_asian_face_01"] = 2,
		["content/items/characters/player/human/faces/male_caucasian_face_01"] = 5,
		["content/items/characters/player/human/faces/male_caucasian_face_03"] = 5,
		["content/items/characters/player/human/faces/npc_hadron_seven_three_face"] = 1,
		["content/items/characters/player/human/gear_arms/frateris_militia_upperbody_career_01_arms"] = 1,
		["content/items/characters/player/human/gear_arms/imperial_guard_upperbody_a_01_arms"] = 10,
		["content/items/characters/player/human/gear_arms/imperial_guard_upperbody_arms_01"] = 1,
		["content/items/characters/player/human/gear_arms/npc_hadron_seven_three_arms"] = 1,
		["content/items/characters/player/human/gear_arms/npc_hadron_seven_three_hand_left"] = 1,
		["content/items/characters/player/human/gear_arms/npc_iven_rannick_arms"] = 1,
		["content/items/characters/player/human/gear_arms/npc_upperbody_f_arms"] = 1,
		["content/items/characters/player/human/gear_arms/npc_upperbody_i_arms"] = 1,
		["content/items/characters/player/human/gear_arms/npc_upperbody_j_arms"] = 2,
		["content/items/characters/player/human/gear_arms/npc_upperbody_k_arms"] = 2,
		["content/items/characters/player/human/gear_arms/npc_upperbody_m_arms"] = 1,
		["content/items/characters/player/human/gear_arms/servitor_arms_01"] = 7,
		["content/items/characters/player/human/gear_arms/servitor_arms_02"] = 8,
		["content/items/characters/player/human/gear_arms/servitor_arms_02_hand_01"] = 8,
		["content/items/characters/player/human/gear_arms/welder_servitor_arms_01"] = 6,
		["content/items/characters/player/human/gear_attachments/barber_surgeon_blood_decal_01"] = 1,
		["content/items/characters/player/human/gear_attachments/imperial_guard_attachment_belt_01_a"] = 1,
		["content/items/characters/player/human/gear_attachments/imperial_guard_attachment_shoulderpad_01"] = 6,
		["content/items/characters/player/human/gear_attachments/imperial_guard_attachment_shoulderpad_01_b"] = 4,
		["content/items/characters/player/human/gear_attachments/npc_hadron_seven_three_backpack_arm"] = 1,
		["content/items/characters/player/human/gear_attachments/npc_iven_rannick_accessories"] = 1,
		["content/items/characters/player/human/gear_attachments/servitor_arm_attachment_01"] = 1,
		["content/items/characters/player/human/gear_attachments/servitor_chestplate_01"] = 1,
		["content/items/characters/player/human/gear_attachments/servitor_chestplate_01_attach_01"] = 1,
		["content/items/characters/player/human/gear_attachments/training_ground_psyker_attachment"] = 1,
		["content/items/characters/player/human/gear_feet/astra_shoes_d"] = 1,
		["content/items/characters/player/human/gear_feet/astra_shoes_e"] = 8,
		["content/items/characters/player/human/gear_feet/astra_shoes_f"] = 1,
		["content/items/characters/player/human/gear_feet/frateris_militia_shoes_d"] = 1,
		["content/items/characters/player/human/gear_feet/imperial_guard_shoes_b"] = 7,
		["content/items/characters/player/human/gear_feet/militarum_lowerbody_b_boots"] = 2,
		["content/items/characters/player/human/gear_feet/npc_hestia_boots"] = 1,
		["content/items/characters/player/human/gear_feet/npc_iven_rannick_boots"] = 1,
		["content/items/characters/player/human/gear_hands/astra_gloves_d"] = 4,
		["content/items/characters/player/human/gear_hands/hmn_gloves_a"] = 1,
		["content/items/characters/player/human/gear_hands/hmn_gloves_f"] = 1,
		["content/items/characters/player/human/gear_hands/imperial_guard_gloves_d"] = 4,
		["content/items/characters/player/human/gear_hands/imperial_guard_gloves_f"] = 4,
		["content/items/characters/player/human/gear_hands/npc_hestia_gloves"] = 1,
		["content/items/characters/player/human/gear_hands/npc_iven_rannick_gloves"] = 1,
		["content/items/characters/player/human/gear_hands/npc_upperbody_m_gloves"] = 1,
		["content/items/characters/player/human/gear_head/cadian_command_02_a"] = 6,
		["content/items/characters/player/human/gear_head/cadian_command_02_b"] = 2,
		["content/items/characters/player/human/gear_head/cadian_command_02_c"] = 1,
		["content/items/characters/player/human/gear_head/genestealer_cults_04_a"] = 1,
		["content/items/characters/player/human/gear_head/imperial_guard_helmet_01"] = 10,
		["content/items/characters/player/human/gear_head/inquisition_rebreather_01_b_var_01"] = 1,
		["content/items/characters/player/human/gear_head/inquisition_rebreather_01_b_var_02"] = 1,
		["content/items/characters/player/human/gear_head/rebreather_02_c"] = 1,
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 18,
		["content/items/characters/player/human/gear_head/servitor_head_02"] = 2,
		["content/items/characters/player/human/gear_head/servitor_head_03"] = 1,
		["content/items/characters/player/human/gear_head/welder_servitor_helmet_01"] = 1,
		["content/items/characters/player/human/gear_legs/astra_pants_a"] = 2,
		["content/items/characters/player/human/gear_legs/frateris_militia_pants_a"] = 1,
		["content/items/characters/player/human/gear_legs/imperial_guard_lowerbody_01"] = 8,
		["content/items/characters/player/human/gear_legs/imperial_guard_pants_c"] = 4,
		["content/items/characters/player/human/gear_legs/militarum_lowerbody_a_pants"] = 2,
		["content/items/characters/player/human/gear_legs/militarum_lowerbody_b_pants"] = 2,
		["content/items/characters/player/human/gear_legs/npc_hadron_seven_three_lowerbody"] = 1,
		["content/items/characters/player/human/gear_legs/npc_hestia_lowerbody"] = 1,
		["content/items/characters/player/human/gear_legs/npc_iven_rannick_pants"] = 1,
		["content/items/characters/player/human/gear_legs/servitor_lowerbody_01"] = 14,
		["content/items/characters/player/human/gear_torso/frateris_militia_upperbody_career_01_lvl_03"] = 1,
		["content/items/characters/player/human/gear_torso/imperial_guard_upperbody_01"] = 10,
		["content/items/characters/player/human/gear_torso/imperial_guard_upperbody_01_attachment"] = 1,
		["content/items/characters/player/human/gear_torso/npc_hadron_seven_three_upperbody"] = 1,
		["content/items/characters/player/human/gear_torso/npc_hestia_upperbody"] = 1,
		["content/items/characters/player/human/gear_torso/npc_iven_rannick_upperbody"] = 1,
		["content/items/characters/player/human/gear_torso/npc_upperbody_f"] = 1,
		["content/items/characters/player/human/gear_torso/npc_upperbody_f_02"] = 1,
		["content/items/characters/player/human/gear_torso/npc_upperbody_i"] = 1,
		["content/items/characters/player/human/gear_torso/npc_upperbody_j"] = 2,
		["content/items/characters/player/human/gear_torso/npc_upperbody_k"] = 2,
		["content/items/characters/player/human/gear_torso/npc_upperbody_m"] = 1,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 19,
		["content/items/characters/player/human/gear_torso/servitor_torso_02"] = 2,
		["content/items/characters/player/human/gear_torso/servitor_torso_02_upperbody_01"] = 2,
		["content/items/characters/player/human/gear_torso/servitor_torso_02_upperbody_02"] = 2,
		["content/items/characters/player/human/gear_torso/servitor_upperbody_01"] = 12,
		["content/items/characters/player/human/hair/hair_medium_canoness_a"] = 1,
		["content/items/characters/player/human/hair/hair_medium_side_swept_afro_a"] = 1,
		["content/items/characters/player/human/hair/hair_medium_undercut_a"] = 4,
		["content/items/characters/player/human/hair/hair_short_c_02"] = 1,
		["content/items/characters/player/human/hair/hair_short_c_02_servitor"] = 1,
		["content/items/characters/player/human/hair/hair_short_e"] = 1,
		["content/items/characters/player/human/hair/hair_short_modular_a_02"] = 1,
		["content/items/characters/player/human/hair/hair_short_modular_a_03"] = 1,
		["content/items/characters/player/human/hair/hair_short_shira_a"] = 1,
		["content/items/weapons/npc/lasgun_npc_01"] = 10,
	},
	weapon_items = {},
}

return item_dependencies
