require("scripts/foundation/utilities/color")

local ui_settings = {
	insignia_default_texture = "content/ui/textures/nameplates/insignias/default",
	double_click_threshold = 0.2,
	portrait_frame_default_texture = "content/ui/textures/nameplates/portrait_frames/default",
	item_icon_size = {
		128,
		128
	},
	cosmetics_item_size = {
		128,
		128
	},
	cosmetics_bundle_item_size = {
		128,
		266
	},
	ui_item_size = {
		128,
		128
	},
	weapon_item_size = {
		600,
		112
	},
	weapon_icon_size = {
		256,
		128
	},
	gadget_item_size = {
		193,
		250
	},
	gadget_icon_size = {
		256,
		128
	},
	sizes = {
		header_1 = {
			nil,
			84
		},
		spacing_header_1 = {
			nil,
			20
		}
	},
	menu_navigation = {
		view_fast_cooldown = 0,
		gamepad_view_fast_cooldown = 0.1,
		view_min_speed_multiplier = 0.5,
		view_speed_multiplier_decrease = 1.3,
		view_cooldown = 0.15,
		view_speed_multiplier_frame_decrease = 0.025,
		button_navigation_cooldown = 0.25,
		gamepad_view_cooldown = 0.2,
		view_min_fast_speed_multiplier = 0.1,
		view_analog_deadzone = 0.5
	},
	cutscenes_skip = {
		hold_time = 0.5,
		fade_inactivity_time = 5
	},
	bonus_aquila_values = {
		0,
		0,
		100,
		500,
		1000,
		2000
	},
	ITEM_TYPES = table.enum("BODY_TATTOO", "BOON", "CHARACTER_INSIGNIA", "DEVICE", "EMOTE", "END_OF_ROUND", "EYE_COLOR", "FACE", "FACE_HAIR", "FACE_SCAR", "FACE_TATTOO", "GADGET", "GEAR_EXTRA_COSMETIC", "GEAR_HEAD", "GEAR_LOWERBODY", "GEAR_UPPERBODY", "HAIR", "HAIR_COLOR", "LUGGABLE", "PERK", "POCKETABLE", "PORTRAIT_FRAME", "SET", "SKIN_COLOR", "TRAIT", "WEAPON_MELEE", "WEAPON_RANGED", "WEAPON_SKIN", "WEAPON_TRINKET"),
	item_type_group_lookup = {
		GEAR_LOWERBODY = "outfits",
		BOON = "boons",
		EMOTE = "emotes",
		GEAR_EXTRA_COSMETIC = "outfits",
		SET = "outfits",
		WEAPON_RANGED = "weapons",
		END_OF_ROUND = "engrams",
		WEAPON_MELEE = "weapons",
		GEAR_HEAD = "outfits",
		GADGET = "devices",
		PORTRAIT_FRAME = "nameplates",
		WEAPON_SKIN = "weapon_skin",
		DEVICE = "devices",
		CHARACTER_INSIGNIA = "nameplates",
		WEAPON_TRINKET = "weapon_trinket",
		GEAR_UPPERBODY = "outfits"
	},
	item_variant_localization_lookup = {
		bfg = "loc_item_weapon_variant_bfg",
		assault = "loc_item_weapon_variant_assault",
		ninjafencer = "loc_item_weapon_variant_ninjafencer",
		killshot = "loc_item_weapon_variant_killshot",
		tank = "loc_item_weapon_variant_tank",
		demolition = "loc_item_weapon_variant_demolition",
		linesman = "loc_item_weapon_variant_linesman",
		smiter = "loc_item_weapon_variant_smiter"
	},
	set_item_parts_presentation_order = {
		GEAR_LOWERBODY = 4,
		BOON = 0,
		EMOTE = 0,
		FACE = 0,
		END_OF_ROUND = 0,
		WEAPON_RANGED = 0,
		PORTRAIT_FRAME = 0,
		BODY_TATTOO = 0,
		GEAR_EXTRA_COSMETIC = 5,
		SET = 1,
		TRAIT = 0,
		BUNDLE = 0,
		DEVICE = 0,
		POCKETABLE = 0,
		FACE_HAIR = 0,
		GEAR_UPPERBODY = 3,
		HAIR_COLOR = 0,
		WEAPON_MELEE = 0,
		EYE_COLOR = 0,
		HAIR = 0,
		PERK = 0,
		SKIN = 0,
		FACE_SCAR = 0,
		SKIN_COLOR = 0,
		GEAR_HEAD = 2,
		GADGET = 0,
		WEAPON_TRINKET = 0,
		WEAPON_SKIN = 0,
		FACE_TATTOO = 0,
		CHARACTER_INSIGNIA = 0,
		LUGGABLE = 0
	},
	item_type_localization_lookup = {
		GEAR_LOWERBODY = "loc_item_type_gear_lowerbody",
		BOON = "loc_item_type_boon",
		EMOTE = "loc_item_type_emote",
		FACE = "loc_item_type_face",
		END_OF_ROUND = "loc_item_type_end_of_round",
		WEAPON_RANGED = "loc_item_type_weapon_ranged",
		PORTRAIT_FRAME = "loc_item_type_portrait_frame",
		BODY_TATTOO = "loc_item_type_body_tattoo",
		GEAR_EXTRA_COSMETIC = "loc_item_type_gear_extra_cosmetic",
		SET = "loc_item_type_set",
		TRAIT = "loc_item_type_trait",
		BUNDLE = "loc_item_type_bundle",
		DEVICE = "loc_item_type_device",
		POCKETABLE = "loc_item_type_pocketable",
		FACE_HAIR = "loc_item_type_face_hair",
		GEAR_UPPERBODY = "loc_item_type_gear_upperbody",
		HAIR_COLOR = "loc_item_type_hair_color",
		WEAPON_MELEE = "loc_item_type_weapon_melee",
		EYE_COLOR = "loc_item_type_eye_color",
		HAIR = "loc_item_type_hair",
		PERK = "loc_item_type_perk",
		SKIN = "loc_item_type_skin",
		FACE_SCAR = "loc_item_type_face_scar",
		SKIN_COLOR = "loc_item_type_skin_color",
		GEAR_HEAD = "loc_item_type_gear_head",
		GADGET = "loc_item_type_gadget",
		WEAPON_TRINKET = "loc_item_type_trinket",
		WEAPON_SKIN = "loc_item_type_weapon_skin",
		FACE_TATTOO = "loc_item_type_face_tattoo",
		CHARACTER_INSIGNIA = "loc_item_type_character_insignia",
		LUGGABLE = "loc_item_type_luggable"
	},
	item_type_texture_lookup = {
		GEAR_LOWERBODY = "content/ui/textures/icons/item_types/lower_bodies",
		BODY_TATTOO = "content/ui/textures/icons/item_types/body_tattoos",
		GEAR_HEAD = "content/ui/textures/icons/item_types/headgears",
		END_OF_ROUND = "content/ui/textures/icons/item_types/poses",
		PORTRAIT_FRAME = "content/ui/textures/icons/item_types/nameplates",
		WEAPON_RANGED = "content/ui/textures/icons/item_types/ranged_weapons",
		WEAPON_MELEE = "content/ui/textures/icons/item_types/melee_weapons",
		HAIR = "content/ui/textures/icons/item_types/hair_styles",
		GEAR_EXTRA_COSMETIC = "content/ui/textures/icons/item_types/outfits",
		SKIN_COLOR = "content/ui/textures/icons/item_types/outfits",
		WEAPON_TRINKET = "content/ui/textures/icons/item_types/weapon_trinkets",
		DEVICE = "content/ui/textures/icons/item_types/devices",
		FACE_HAIR = "content/ui/textures/icons/item_types/facial_hair_styles",
		GEAR_UPPERBODY = "content/ui/textures/icons/item_types/upper_bodies",
		HAIR_COLOR = "content/ui/textures/icons/item_types/hair_styles",
		EYE_COLOR = "content/ui/textures/icons/item_types/eye_colors",
		SET = "content/ui/textures/icons/item_types/outfits",
		FACE_SCAR = "content/ui/textures/icons/item_types/scars",
		FACE = "content/ui/textures/icons/item_types/face_types",
		GADGET = "content/ui/textures/icons/item_types/devices",
		WEAPON_SKIN = "content/ui/textures/icons/item_types/weapons",
		FACE_TATTOO = "content/ui/textures/icons/item_types/face_tattoos",
		CHARACTER_INSIGNIA = "content/ui/textures/icons/item_types/nameplates"
	},
	item_type_material_lookup = {
		GEAR_LOWERBODY = "content/ui/materials/icons/item_types/lower_bodies",
		BODY_TATTOO = "content/ui/materials/icons/item_types/body_tattoos",
		GEAR_HEAD = "content/ui/materials/icons/item_types/headgears",
		END_OF_ROUND = "content/ui/materials/icons/item_types/poses",
		PORTRAIT_FRAME = "content/ui/textures/icons/item_types/nameplates",
		WEAPON_RANGED = "content/ui/textures/icons/item_types/ranged_weapons",
		WEAPON_MELEE = "content/ui/textures/icons/item_types/melee_weapons",
		HAIR = "content/ui/materials/icons/item_types/hair_styles",
		GEAR_EXTRA_COSMETIC = "content/ui/materials/icons/item_types/outfits",
		SKIN_COLOR = "content/ui/textures/icons/item_types/outfits",
		WEAPON_TRINKET = "content/ui/textures/icons/item_types/weapon_trinkets",
		DEVICE = "content/ui/materials/icons/item_types/devices",
		FACE_HAIR = "content/ui/materials/icons/item_types/facial_hair_styles",
		GEAR_UPPERBODY = "content/ui/materials/icons/item_types/upper_bodies",
		HAIR_COLOR = "content/ui/materials/icons/item_types/hair_styles",
		EYE_COLOR = "content/ui/materials/icons/item_types/eye_color",
		SET = "content/ui/textures/icons/item_types/outfits",
		FACE_SCAR = "content/ui/materials/icons/item_types/scars",
		FACE = "content/ui/materials/icons/item_types/face_types",
		GADGET = "content/ui/materials/icons/item_types/devices",
		WEAPON_SKIN = "content/ui/textures/icons/item_types/weapons",
		FACE_TATTOO = "content/ui/materials/icons/item_types/face_tattoos",
		CHARACTER_INSIGNIA = "content/ui/materials/icons/item_types/nameplates"
	},
	item_pattern_localization_lookup = {
		lucius = "loc_item_pattern_lucius",
		mars = "loc_item_pattern_mars",
		cadia = "loc_item_pattern_cadia",
		graia = "loc_item_pattern_graia"
	},
	item_store_categories = {
		"outfits",
		"nameplates",
		"weapons",
		"devices",
		"poses",
		"emotes",
		"boons"
	},
	texture_by_store_category = {
		emotes = "content/ui/materials/icons/item_types/emotes",
		weapons = "content/ui/materials/icons/item_types/weapons",
		nameplates = "content/ui/materials/icons/item_types/nameplates",
		devices = "content/ui/materials/icons/item_types/devices",
		outfits = "content/ui/materials/icons/item_types/outfits",
		poses = "content/ui/materials/icons/item_types/poses",
		boons = "content/ui/materials/icons/item_types/boons"
	},
	display_name_by_store_category = {
		emotes = "loc_store_category_display_name_emotes",
		weapons = "loc_store_category_display_name_weapons",
		nameplates = "loc_store_category_display_name_nameplates",
		devices = "loc_store_category_display_name_devices",
		outfits = "loc_store_category_display_name_outfits",
		poses = "loc_store_category_display_name_poses",
		boons = "loc_store_category_display_name_boons"
	},
	store_category_sort_order = {
		emotes = 6,
		weapons = 1,
		nameplates = 4,
		devices = 2,
		outfits = 3,
		poses = 5,
		boons = 7
	},
	player_slot_colors = {
		Color.player_slot_1(255, true),
		Color.player_slot_2(255, true),
		Color.player_slot_3(255, true),
		Color.player_slot_4(255, true)
	},
	weapon_action_title_display_names = {
		secondary = "loc_weapon_action_title_secondary",
		primary = "loc_weapon_action_title_primary",
		special = "loc_weapon_action_title_special",
		extra = "loc_glossary_term_ranged_attacks"
	},
	weapon_action_title_display_names_melee = {
		secondary = "loc_weapon_action_title_heavy",
		primary = "loc_weapon_action_title_light",
		special = "loc_weapon_action_title_special",
		extra = "loc_weapon_action_title_secondary"
	},
	weapon_action_display_order = {
		secondary = 2,
		primary = 1,
		special = 3,
		extra = 4
	},
	weapon_action_display_order_array = {
		"primary",
		"secondary",
		"special",
		"extra"
	},
	weapon_stats_armor_types = {
		disgustingly_resilient = "loc_weapon_stats_display_disgustingly_resilient",
		super_armor = "loc_weapon_stats_display_super_armor",
		armored = "loc_weapon_stats_display_armored",
		resistant = "loc_glossary_armour_type_resistant",
		berserker = "loc_weapon_stats_display_berzerker",
		unarmored = "loc_weapon_stats_display_unarmored"
	},
	weapon_action_extended_display_order_array = {
		"special",
		"primary",
		"secondary",
		"extra"
	},
	attack_type_lookup = {
		ninja_fencer = "loc_gestalt_ninja_fencer",
		linesman = "loc_gestalt_linesman",
		tank = "loc_gestalt_tank",
		smiter = "loc_gestalt_smiter"
	},
	attack_type_desc_lookup = {
		brace = "loc_stats_fire_mode_brace_desc",
		vent = "loc_stats_special_action_venting_desc",
		ninja_fencer = "loc_stats_gestalt_ninjafencer_desc",
		tank = "loc_stats_gestalt_tank_desc",
		linesman = "loc_stats_gestalt_linesman_desc",
		charge = "loc_stats_fire_mode_chargeup_desc",
		smiter = "loc_stats_gestalt_smite_desc",
		hipfire = "loc_stats_fire_mode_hip_fire_desc",
		ads = "loc_stats_fire_mode_ads_desc"
	},
	weapon_action_type_icons = {
		tank = "content/ui/materials/icons/weapons/actions/tank",
		vent = "content/ui/materials/icons/weapons/actions/vent",
		melee = "content/ui/materials/icons/weapons/actions/melee",
		special_bullet = "content/ui/materials/icons/weapons/actions/special_bullet",
		quick_grenade = "content/ui/materials/icons/weapons/actions/quick_grenade",
		brace = "content/ui/materials/icons/weapons/actions/brace",
		charge = "content/ui/materials/icons/weapons/actions/charge",
		melee_hand = "content/ui/materials/icons/weapons/actions/melee_hand",
		ninja_fencer = "content/ui/materials/icons/weapons/actions/ninjafencer",
		activate = "content/ui/materials/icons/weapons/actions/activate",
		defence = "content/ui/materials/icons/weapons/actions/defence",
		special_attack = "content/ui/materials/icons/weapons/actions/special_attack",
		flashlight = "content/ui/materials/icons/weapons/actions/flashlight",
		linesman = "content/ui/materials/icons/weapons/actions/linesman",
		smiter = "content/ui/materials/icons/weapons/actions/smiter",
		hipfire = "content/ui/materials/icons/weapons/actions/hipfire",
		ads = "content/ui/materials/icons/weapons/actions/ads"
	},
	weapon_fire_type_icons = {
		projectile = "content/ui/materials/icons/weapons/actions/projectile",
		shotgun = "content/ui/materials/icons/weapons/actions/shotgun",
		full_auto = "content/ui/materials/icons/weapons/actions/full_auto",
		semi_auto = "content/ui/materials/icons/weapons/actions/semi_auto",
		burst = "content/ui/materials/icons/weapons/actions/burst"
	},
	weapon_fire_type_display_text = {
		projectile = "loc_weapon_stats_fire_mode_projectile",
		shotgun = "loc_weapon_stats_fire_mode_shotgun",
		full_auto = "loc_weapon_stats_fire_mode_full_auto",
		semi_auto = "loc_weapon_stats_fire_mode_semi_auto",
		burst = "loc_weapon_stats_fire_mode_burst"
	},
	trait_category_icon = {
		ranged_aimed = "",
		ranged_common = "",
		melee_activated = "",
		ranged_explosive = "",
		ranged_overheat = "",
		ranged_warpcharge = "",
		melee_common = ""
	},
	contracts_icons_by_type = {
		default = "content/ui/textures/icons/contracts/contracts_type_03",
		CompleteMissionsByName = "content/ui/textures/icons/contracts/contracts_type_07",
		CompleteMissionsNoDeath = "content/ui/textures/icons/contracts/contracts_type_05",
		CollectPickup = "content/ui/textures/icons/contracts/contracts_type_04",
		CollectResource = "content/ui/textures/icons/contracts/contracts_type_04",
		KillMinions = "content/ui/textures/icons/contracts/contracts_type_02",
		BlockDamage = "content/ui/textures/icons/contracts/contracts_type_01",
		CompleteMissions = "content/ui/textures/icons/contracts/contracts_type_07",
		KillBosses = "content/ui/textures/icons/contracts/contracts_type_02"
	},
	digital_clock_numbers = {
		[0] = "",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},
	archetype_font_icon = {
		veteran = "",
		psyker = "",
		zealot = "",
		ogryn = ""
	},
	inventory_frames_by_archetype = {
		psyker = {
			right_upper = "content/ui/materials/frames/screen/class_psyker_01_upper_right",
			left_lower = "content/ui/materials/frames/screen/class_psyker_01_lower_left",
			right_lower = "content/ui/materials/frames/screen/class_psyker_01_lower_right",
			left_upper = "content/ui/materials/frames/screen/class_psyker_01_upper_left"
		},
		veteran = {
			right_upper = "content/ui/materials/frames/screen/class_veteran_01_upper_right",
			left_lower = "content/ui/materials/frames/screen/class_veteran_01_lower_left",
			right_lower = "content/ui/materials/frames/screen/class_veteran_01_lower_right",
			left_upper = "content/ui/materials/frames/screen/class_veteran_01_upper_left"
		},
		zealot = {
			right_upper = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
			left_lower = "content/ui/materials/frames/screen/class_zealot_01_lower_left",
			right_lower = "content/ui/materials/frames/screen/class_zealot_01_lower_right",
			left_upper = "content/ui/materials/frames/screen/class_zealot_01_upper_left"
		},
		ogryn = {
			right_upper = "content/ui/materials/frames/screen/class_ogryn_01_upper_right",
			left_lower = "content/ui/materials/frames/screen/class_ogryn_01_lower_left",
			right_lower = "content/ui/materials/frames/screen/class_ogryn_01_lower_right",
			left_upper = "content/ui/materials/frames/screen/class_ogryn_01_upper_left"
		}
	},
	item_preview_required_slots_per_slot = {
		slot_gear_head = {
			"slot_body_torso",
			"slot_body_arms",
			"slot_body_face",
			"slot_body_face_tattoo",
			"slot_body_face_scar",
			"slot_body_face_hair",
			"slot_body_hair_color",
			"slot_body_skin_color",
			"slot_body_eye_color",
			"slot_body_hair"
		},
		slot_gear_upperbody = {
			"slot_body_torso",
			"slot_body_arms",
			"slot_body_legs"
		},
		slot_gear_lowerbody = {
			"slot_body_torso",
			"slot_body_arms",
			"slot_body_legs"
		},
		slot_gear_extra_cosmetic = {
			"slot_body_torso",
			"slot_body_arms",
			"slot_body_legs"
		}
	},
	item_preview_hide_slots_per_slot = {
		slot_gear_head = {
			"slot_body_legs",
			"slot_body_face_tattoo",
			"slot_body_face_scar",
			"slot_body_face_hair",
			"slot_body_hair_color",
			"slot_body_skin_color",
			"slot_body_eye_color",
			"slot_body_hair"
		},
		slot_gear_upperbody = {
			"slot_body_hair"
		},
		slot_gear_lowerbody = {
			"slot_body_face",
			"slot_body_hair"
		},
		slot_gear_extra_cosmetic = {
			"slot_body_hair"
		}
	},
	item_preview_required_slot_items_set_per_slot_by_breed_and_gender = {
		human = {
			male = {
				slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
				slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
				slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
				slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
			},
			female = {
				slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
				slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
				slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
				slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
			}
		},
		ogryn = {
			male = {
				slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
				slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
				slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
				slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
			}
		}
	},
	item_preview_required_slot_items_per_slot_by_breed_and_gender = {
		human = {
			male = {
				slot_gear_head = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
				},
				slot_gear_upperbody = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
				},
				slot_gear_lowerbody = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
				},
				slot_gear_extra_cosmetic = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
				},
				slot_animation_end_of_round = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
				}
			},
			female = {
				slot_gear_head = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
				},
				slot_gear_upperbody = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
				},
				slot_gear_lowerbody = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
				},
				slot_gear_extra_cosmetic = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
				},
				slot_animation_end_of_round = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
					slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
				}
			}
		},
		ogryn = {
			male = {
				slot_gear_head = {
					slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
					slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
					slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
					slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
				},
				slot_gear_upperbody = {
					slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
					slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
					slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
					slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
				},
				slot_gear_lowerbody = {
					slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
					slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
					slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
					slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
				},
				slot_gear_extra_cosmetic = {
					slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
					slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
					slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
					slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
				},
				slot_animation_end_of_round = {
					slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
					slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
					slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
					slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
				}
			}
		}
	},
	item_preview_required_slot_items_per_slot_by_specializations = {
		ogryn_1 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_lowerbody_career_01_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_upperbody_career_01_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_lowerbody_career_01_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_upperbody_career_01_lvl_01_set_01"
			}
		},
		ogryn_2 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_upperbody_career_02_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_upperbody_career_02_lvl_01_set_01"
			}
		},
		zealot_2 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/zealot_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/zealot_upperbody_career_02_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/zealot_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/zealot_upperbody_career_02_lvl_01_set_01"
			}
		},
		zealot_3 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/zealot_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/zealot_upperbody_career_03_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/zealot_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/zealot_upperbody_career_03_lvl_01_set_01"
			}
		},
		veteran_2 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/veteran_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/veteran_upperbody_career_02_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/veteran_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/veteran_upperbody_career_02_lvl_01_set_01"
			},
			slot_animation_end_of_round = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/veteran_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/veteran_upperbody_career_02_lvl_01_set_01"
			}
		},
		veteran_3 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/veteran_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/veteran_upperbody_career_03_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/veteran_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/veteran_upperbody_career_03_lvl_01_set_01"
			},
			slot_animation_end_of_round = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/veteran_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/veteran_upperbody_career_03_lvl_01_set_01"
			}
		},
		psyker_2 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/psyker_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/psyker_upperbody_career_02_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/psyker_lowerbody_career_02_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/psyker_upperbody_career_02_lvl_01_set_01"
			}
		},
		psyker_3 = {
			slot_gear_head = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/psyker_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/psyker_upperbody_career_03_lvl_01_set_01"
			},
			slot_gear_extra_cosmetic = {
				slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/psyker_lowerbody_career_03_lvl_01_set_01",
				slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/psyker_upperbody_career_03_lvl_01_set_01"
			}
		}
	},
	weapon_template_display_settings = {
		chainaxe_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_chainaxe_p1",
			display_name = "loc_chainaxe_p1_m1"
		},
		chainsword_2h_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_chainsword_2h_p1",
			display_name = "loc_chainsword_2h_p1_m1"
		},
		chainsword_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_chainsword_p1",
			display_name = "loc_chainsword_p1_m1"
		},
		combataxe_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p1",
			display_name = "loc_combataxe_p1_m1"
		},
		combataxe_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p1",
			display_name = "loc_combataxe_p1_m2"
		},
		combataxe_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p1",
			display_name = "loc_combataxe_p1_m3"
		},
		combataxe_p2_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p2",
			display_name = "loc_combataxe_p2_m1"
		},
		combataxe_p2_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p2",
			display_name = "loc_combataxe_p2_m2"
		},
		combataxe_p2_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p2",
			display_name = "loc_combataxe_p2_m3"
		},
		combataxe_p3_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combataxe_p3",
			display_name = "loc_combataxe_p3_m1"
		},
		combatknife_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combatknife_p1",
			display_name = "loc_combatknife_p1_m1"
		},
		combatsword_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p1",
			display_name = "loc_combatsword_p1_m1"
		},
		combatsword_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p1",
			display_name = "loc_combatsword_p1_m2"
		},
		combatsword_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p1",
			display_name = "loc_combatsword_p1_m3"
		},
		combatsword_p2_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p2",
			display_name = "loc_combatsword_p2_m1"
		},
		combatsword_p2_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p2",
			display_name = "loc_combatsword_p2_m2"
		},
		combatsword_p2_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p2",
			display_name = "loc_combatsword_p2_m3"
		},
		combatsword_p3_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p3",
			display_name = "loc_combatsword_p3_m1"
		},
		combatsword_p3_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p3",
			display_name = "loc_combatsword_p3_m2"
		},
		combatsword_p3_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_combatsword_p3",
			display_name = "loc_combatsword_p3_m3"
		},
		forcesword_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_forcesword_p1",
			display_name = "loc_forcesword_p1_m1"
		},
		forcesword_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_forcesword_p1",
			display_name = "loc_forcesword_p1_m2"
		},
		forcesword_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_forcesword_p1",
			display_name = "loc_forcesword_p1_m3"
		},
		ogryn_club_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_club_p1",
			display_name = "loc_ogryn_club_p1_m1"
		},
		ogryn_club_p2_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_club_p2",
			display_name = "loc_ogryn_club_p2_m1"
		},
		ogryn_club_p2_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_club_p2",
			display_name = "loc_ogryn_club_p2_m2"
		},
		ogryn_club_p2_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_club_p2",
			display_name = "loc_ogryn_club_p2_m3"
		},
		ogryn_combatblade_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_combatblade_p1",
			display_name = "loc_ogryn_combatblade_p1_m1"
		},
		ogryn_combatblade_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_combatblade_p1",
			display_name = "loc_ogryn_combatblade_p1_m2"
		},
		ogryn_combatblade_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_combatblade_p1",
			display_name = "loc_ogryn_combatblade_p1_m3"
		},
		ogryn_powermaul_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_powermaul_p1",
			display_name = "loc_ogryn_powermaul_p1_m1"
		},
		ogryn_powermaul_slabshield_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_powermaul_slabshield_p1",
			display_name = "loc_ogryn_powermaul_slabshield_p1_m1"
		},
		powermaul_2h_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_powermaul_2h_p1",
			display_name = "loc_powermaul_2h_p1_m1"
		},
		powersword_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_powersword_p1",
			display_name = "loc_powersword_p1_m1"
		},
		powersword_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_powersword_p1",
			display_name = "loc_powersword_p1_m2"
		},
		thunderhammer_2h_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_thunderhammer_2h_p1",
			display_name = "loc_thunderhammer_2h_p1_m1"
		},
		thunderhammer_2h_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_thunderhammer_2h_p1",
			display_name = "loc_thunderhammer_2h_p1_m2"
		},
		autogun_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p1",
			display_name = "loc_autogun_p1_m1"
		},
		autogun_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p1",
			display_name = "loc_autogun_p1_m2"
		},
		autogun_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p1",
			display_name = "loc_autogun_p1_m3"
		},
		autogun_p2_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p2",
			display_name = "loc_autogun_p2_m1"
		},
		autogun_p2_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p2",
			display_name = "loc_autogun_p2_m2"
		},
		autogun_p2_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p2",
			display_name = "loc_autogun_p2_m3"
		},
		autogun_p3_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p3",
			display_name = "loc_autogun_p3_m1"
		},
		autogun_p3_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p3",
			display_name = "loc_autogun_p3_m2"
		},
		autogun_p3_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_autogun_p3",
			display_name = "loc_autogun_p3_m3"
		},
		autopistol_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_autopistol_p1",
			display_name = "loc_autopistol_p1_m1"
		},
		bolter_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_bolter_p1",
			display_name = "loc_bolter_p1_m1"
		},
		flamer_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_flamer_p1",
			display_name = "loc_flamer_p1_m1"
		},
		forcestaff_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_forcestaff_p1",
			display_name = "loc_forcestaff_p1_m1"
		},
		forcestaff_p2_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_forcestaff_p2",
			display_name = "loc_forcestaff_p2_m1"
		},
		forcestaff_p3_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_forcestaff_p3",
			display_name = "loc_forcestaff_p3_m1"
		},
		forcestaff_p4_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_forcestaff_p4",
			display_name = "loc_forcestaff_p4_m1"
		},
		lasgun_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p1",
			display_name = "loc_lasgun_p1_m1"
		},
		lasgun_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p1",
			display_name = "loc_lasgun_p1_m2"
		},
		lasgun_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p1",
			display_name = "loc_lasgun_p1_m3"
		},
		lasgun_p2_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p2",
			display_name = "loc_lasgun_p2_m1"
		},
		lasgun_p2_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p2",
			display_name = "loc_lasgun_p2_m2"
		},
		lasgun_p2_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p2",
			display_name = "loc_lasgun_p2_m3"
		},
		lasgun_p3_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p3",
			display_name = "loc_lasgun_p3_m1"
		},
		lasgun_p3_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p3",
			display_name = "loc_lasgun_p3_m2"
		},
		lasgun_p3_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_lasgun_p3",
			display_name = "loc_lasgun_p3_m3"
		},
		laspistol_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_laspistol_p1",
			display_name = "loc_laspistol_p1_m1"
		},
		ogryn_gauntlet_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_gauntlet_p1",
			display_name = "loc_ogryn_gauntlet_p1_m1"
		},
		ogryn_heavystubber_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_heavystubber_p1",
			display_name = "loc_ogryn_heavystubber_p1_m1"
		},
		ogryn_heavystubber_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_heavystubber_p1",
			display_name = "loc_ogryn_heavystubber_p1_m2"
		},
		ogryn_heavystubber_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_heavystubber_p1",
			display_name = "loc_ogryn_heavystubber_p1_m3"
		},
		ogryn_rippergun_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_rippergun_p1",
			display_name = "loc_ogryn_rippergun_p1_m1"
		},
		ogryn_rippergun_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_rippergun_p1",
			display_name = "loc_ogryn_rippergun_p1_m2"
		},
		ogryn_rippergun_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_rippergun_p1",
			display_name = "loc_ogryn_rippergun_p1_m3"
		},
		ogryn_thumper_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_thumper_p1_m1",
			display_name = "loc_ogryn_thumper_p1_m1"
		},
		ogryn_thumper_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_ogryn_thumper_p1_m2",
			display_name = "loc_ogryn_thumper_p1_m2"
		},
		plasmagun_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_plasmagun_p1",
			display_name = "loc_plasmagun_p1_m1"
		},
		shotgun_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_shotgun_p1",
			display_name = "loc_shotgun_p1_m1"
		},
		shotgun_p1_m2 = {
			display_name_pattern = "loc_weapon_pattern_name_shotgun_p1",
			display_name = "loc_shotgun_p1_m2"
		},
		shotgun_p1_m3 = {
			display_name_pattern = "loc_weapon_pattern_name_shotgun_p1",
			display_name = "loc_shotgun_p1_m3"
		},
		stubrevolver_p1_m1 = {
			display_name_pattern = "loc_weapon_pattern_name_stubrevolver_p1",
			display_name = "loc_stubrevolver_p1_m1"
		}
	}
}

return settings("UISettings", ui_settings)
