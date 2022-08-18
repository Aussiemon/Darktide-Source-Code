local ui_settings = {
	double_click_threshold = 0.1,
	insignia_default_texture = "content/ui/textures/nameplates/insignias/default",
	portrait_frame_default_texture = "content/ui/textures/nameplates/portrait_frames/default",
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
	gamepad = {
		view_fast_cooldown = 0.1,
		view_speed_multiplier_decrease = 1.3,
		view_min_speed_multiplier = 0.5,
		view_analog_deadzone = 0.5,
		view_min_fast_speed_multiplier = 0.1,
		view_cooldown = 0.25,
		view_speed_multiplier_frame_decrease = 0.025
	},
	ITEM_TYPES = table.enum("BODY_TATTOO", "BOON", "CHARACTER_INSIGNIA", "DEVICE", "EMOTE", "END_OF_ROUND", "EYE_COLOR", "FACE", "FACE_HAIR", "FACE_SCAR", "FACE_TATTOO", "GADGET", "GEAR_EXTRA_COSMETIC", "GEAR_HEAD", "GEAR_LOWERBODY", "GEAR_UPPERBODY", "HAIR", "HAIR_COLOR", "LUGGABLE", "PERK", "POCKETABLE", "PORTRAIT_FRAME", "SET", "SKIN_COLOR", "TRAIT", "WEAPON_MELEE", "WEAPON_RANGED", "WEAPON_SKIN"),
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
		WEAPON_SKIN = "weapons",
		DEVICE = "devices",
		CHARACTER_INSIGNIA = "nameplates",
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
		SKIN_COLOR = "loc_item_type_skin_color",
		DEVICE = "loc_item_type_device",
		POCKETABLE = "loc_item_type_pocketable",
		FACE_HAIR = "loc_item_type_face_hair",
		GEAR_UPPERBODY = "loc_item_type_gear_upperbody",
		HAIR_COLOR = "loc_item_type_hair_color",
		WEAPON_MELEE = "loc_item_type_weapon_melee",
		EYE_COLOR = "loc_item_type_eye_color",
		HAIR = "loc_item_type_hair",
		PERK = "loc_item_type_perk",
		FACE_SCAR = "loc_item_type_face_scar",
		GEAR_HEAD = "loc_item_type_gear_head",
		GADGET = "loc_item_type_gadget",
		WEAPON_SKIN = "loc_item_type_weapon_skin",
		FACE_TATTOO = "loc_item_type_face_tattoo",
		CHARACTER_INSIGNIA = "loc_item_type_character_insignia",
		LUGGABLE = "loc_item_type_luggable"
	},
	item_type_texture_lookup = {
		GEAR_LOWERBODY = "content/ui/textures/icons/item_types/beveled/outfits",
		BODY_TATTOO = "content/ui/textures/icons/item_types/beveled/body_tattoos",
		GEAR_HEAD = "content/ui/textures/icons/item_types/beveled/outfits",
		END_OF_ROUND = "content/ui/textures/icons/item_types/beveled/poses",
		PORTRAIT_FRAME = "content/ui/textures/icons/item_types/beveled/nameplates",
		WEAPON_RANGED = "content/ui/textures/icons/item_types/beveled/ranged_weapons",
		WEAPON_MELEE = "content/ui/textures/icons/item_types/beveled/melee_weapons",
		HAIR = "content/ui/textures/icons/item_types/beveled/hair_styles",
		GEAR_EXTRA_COSMETIC = "content/ui/textures/icons/item_types/beveled/outfits",
		SKIN_COLOR = "content/ui/textures/icons/item_types/beveled/outfits",
		DEVICE = "content/ui/textures/icons/item_types/beveled/devices",
		FACE_HAIR = "content/ui/textures/icons/item_types/beveled/facial_hair_styles",
		GEAR_UPPERBODY = "content/ui/textures/icons/item_types/beveled/outfits",
		HAIR_COLOR = "content/ui/textures/icons/item_types/beveled/hair_styles",
		EYE_COLOR = "content/ui/textures/icons/item_types/beveled/eye_colors",
		SET = "content/ui/textures/icons/item_types/beveled/outfits",
		FACE_SCAR = "content/ui/textures/icons/item_types/beveled/scars",
		FACE = "content/ui/textures/icons/item_types/beveled/face_types",
		GADGET = "content/ui/textures/icons/item_types/beveled/devices",
		WEAPON_SKIN = "content/ui/textures/icons/item_types/beveled/weapons",
		FACE_TATTOO = "content/ui/textures/icons/item_types/beveled/face_tattoos",
		CHARACTER_INSIGNIA = "content/ui/textures/icons/item_types/beveled/nameplates"
	},
	item_pattern_localization_lookup = {
		lucius = "loc_item_pattern_lucius",
		mars = "loc_item_pattern_mars",
		cadia = "loc_item_pattern_cadia",
		graia = "loc_item_pattern_graia"
	},
	item_rarity_localization_lookup = {
		"loc_item_weapon_rarity_1",
		"loc_item_weapon_rarity_2",
		"loc_item_weapon_rarity_3",
		"loc_item_weapon_rarity_4",
		"loc_item_weapon_rarity_5",
		"loc_item_weapon_rarity_6"
	},
	item_rarity_color_lookup = {
		Color.item_rarity_1(255, true),
		Color.item_rarity_2(255, true),
		Color.item_rarity_3(255, true),
		Color.item_rarity_4(255, true),
		Color.item_rarity_5(255, true),
		Color.item_rarity_6(255, true)
	},
	item_rarity_side_texture_lookup = {
		"content/ui/materials/icons/items/backgrounds/side_rarity_01",
		"content/ui/materials/icons/items/backgrounds/side_rarity_02",
		"content/ui/materials/icons/items/backgrounds/side_rarity_03",
		"content/ui/materials/icons/items/backgrounds/side_rarity_04",
		"content/ui/materials/icons/items/backgrounds/side_rarity_05",
		"content/ui/materials/icons/items/backgrounds/side_rarity_06"
	},
	item_rarity_frame_texture_lookup = {
		"content/ui/textures/icons/items/frames/rarity_01",
		"content/ui/textures/icons/items/frames/rarity_02",
		"content/ui/textures/icons/items/frames/rarity_03",
		"content/ui/textures/icons/items/frames/rarity_04",
		"content/ui/textures/icons/items/frames/rarity_05",
		"content/ui/textures/icons/items/frames/rarity_06"
	},
	item_rarity_texture_types = {
		portrait = {
			"content/ui/materials/icons/items/containers/item_container_portrait_rarity_1",
			"content/ui/materials/icons/items/containers/item_container_portrait_rarity_2",
			"content/ui/materials/icons/items/containers/item_container_portrait_rarity_3",
			"content/ui/materials/icons/items/containers/item_container_portrait_rarity_4",
			"content/ui/materials/icons/items/containers/item_container_portrait_rarity_5",
			"content/ui/materials/icons/items/containers/item_container_portrait_rarity_6"
		},
		landscape = {
			"content/ui/materials/icons/items/containers/item_container_landscape_rarity_1",
			"content/ui/materials/icons/items/containers/item_container_landscape_rarity_2",
			"content/ui/materials/icons/items/containers/item_container_landscape_rarity_3",
			"content/ui/materials/icons/items/containers/item_container_landscape_rarity_4",
			"content/ui/materials/icons/items/containers/item_container_landscape_rarity_5",
			"content/ui/materials/icons/items/containers/item_container_landscape_rarity_6"
		},
		square = {
			"content/ui/materials/icons/items/containers/item_container_square_rarity_1",
			"content/ui/materials/icons/items/containers/item_container_square_rarity_2",
			"content/ui/materials/icons/items/containers/item_container_square_rarity_3",
			"content/ui/materials/icons/items/containers/item_container_square_rarity_4",
			"content/ui/materials/icons/items/containers/item_container_square_rarity_5",
			"content/ui/materials/icons/items/containers/item_container_square_rarity_6"
		},
		achievement_reward = {
			"content/ui/textures/icons/achievement_rewards/frames/rarity_01",
			"content/ui/textures/icons/achievement_rewards/frames/rarity_02",
			"content/ui/textures/icons/achievement_rewards/frames/rarity_03",
			"content/ui/textures/icons/achievement_rewards/frames/rarity_04",
			"content/ui/textures/icons/achievement_rewards/frames/rarity_05",
			"content/ui/textures/icons/achievement_rewards/frames/rarity_06"
		}
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
		special = "loc_weapon_action_title_special"
	},
	weapon_action_display_order = {
		secondary = 2,
		primary = 1,
		special = 3
	},
	trait_category_icon = {
		ranged_aimed = "\ue040",
		ranged_common = "\ue040",
		melee_activated = "\ue040",
		ranged_explosive = "\ue040",
		ranged_overheat = "\ue040",
		ranged_warpcharge = "\ue040",
		melee_common = "\ue040"
	},
	digital_clock_numbers = {
		[0] = "\ue010",
		"\ue011",
		"\ue012",
		"\ue013",
		"\ue014",
		"\ue015",
		"\ue016",
		"\ue017",
		"\ue018",
		"\ue019"
	}
}

return settings("UISettings", ui_settings)
