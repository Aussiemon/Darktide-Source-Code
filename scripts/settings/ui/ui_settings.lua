-- chunkname: @scripts/settings/ui/ui_settings.lua

local ui_settings = {
	insignia_default_texture = "content/ui/textures/nameplates/insignias/default",
	portrait_frame_default_texture = "content/ui/textures/nameplates/portrait_frames/default",
	double_click_threshold = 0.2,
	max_favorite_achievements = 5,
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
	character_title_item_size = {
		404,
		64
	},
	character_title_button_size = {
		340,
		48
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
	ITEM_TYPES = table.enum("BODY_TATTOO", "BOON", "CHARACTER_INSIGNIA", "CHARACTER_TITLE", "DEVICE", "EMOTE", "END_OF_ROUND", "EYE_COLOR", "FACE_HAIR", "FACE_SCAR", "FACE_TATTOO", "FACE", "GADGET", "GEAR_EXTRA_COSMETIC", "GEAR_HEAD", "GEAR_LOWERBODY", "GEAR_UPPERBODY", "HAIR_COLOR", "HAIR", "LUGGABLE", "PERK", "POCKETABLE", "PORTRAIT_FRAME", "SET", "SKIN_COLOR", "TRAIT", "WEAPON_MELEE", "WEAPON_RANGED", "WEAPON_SKIN", "WEAPON_TRINKET", "COMPANION_GEAR_FULL"),
	item_type_group_lookup = {
		GEAR_LOWERBODY = "outfits",
		BOON = "boons",
		EMOTE = "emotes",
		GEAR_EXTRA_COSMETIC = "outfits",
		GEAR_UPPERBODY = "outfits",
		WEAPON_RANGED = "weapons",
		END_OF_ROUND = "engrams",
		WEAPON_TRINKET = "weapon_trinket",
		WEAPON_MELEE = "weapons",
		DEVICE = "devices",
		COMPANION_GEAR_FULL = "outfits",
		CHARACTER_TITLE = "titles",
		SET = "outfits",
		GEAR_HEAD = "outfits",
		GADGET = "devices",
		WEAPON_SKIN = "weapon_skin",
		PORTRAIT_FRAME = "nameplates",
		CHARACTER_INSIGNIA = "nameplates"
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
		SKIN_COLOR = 0,
		EYE_COLOR = 0,
		SKIN = 0,
		PERK = 0,
		WEAPON_MELEE = 0,
		FACE_SCAR = 0,
		HAIR = 0,
		GEAR_HEAD = 2,
		GADGET = 0,
		WEAPON_TRINKET = 0,
		WEAPON_SKIN = 0,
		FACE_TATTOO = 0,
		CHARACTER_INSIGNIA = 0,
		LUGGABLE = 0,
		COMPANION_GEAR_FULL = 0
	},
	item_type_localization_lookup = {
		GADGET = "loc_item_type_gadget",
		BOON = "loc_item_type_boon",
		EMOTE = "loc_item_type_emote",
		CHARACTER_TITLE = "loc_item_type_title",
		PORTRAIT_FRAME = "loc_item_type_portrait_frame",
		GEAR_EXTRA_COSMETIC = "loc_item_type_gear_extra_cosmetic",
		HAIR = "loc_item_type_hair",
		BODY_TATTOO = "loc_item_type_body_tattoo",
		WEAPON_MELEE = "loc_item_type_weapon_melee",
		SKIN = "loc_item_type_skin",
		TRAIT = "loc_item_type_trait",
		PERK = "loc_item_type_perk",
		DEVICE = "loc_item_type_device",
		POCKETABLE = "loc_item_type_pocketable",
		SKIN_COLOR = "loc_item_type_skin_color",
		END_OF_ROUND = "loc_item_type_end_of_round",
		COMPANION_GEAR_FULL = "loc_inventory_title_slot_companion_gear_full",
		EYE_COLOR = "loc_item_type_eye_color",
		FACE_SCAR = "loc_item_type_face_scar",
		FACE = "loc_item_type_face",
		WEAPON_TRINKET = "loc_item_type_trinket",
		WEAPON_SKIN = "loc_item_type_weapon_skin",
		FACE_TATTOO = "loc_item_type_face_tattoo",
		LUGGABLE = "loc_item_type_luggable",
		GEAR_LOWERBODY = "loc_item_type_gear_lowerbody",
		WEAPON_RANGED = "loc_item_type_weapon_ranged",
		BUNDLE = "loc_item_type_bundle",
		FACE_HAIR = "loc_item_type_face_hair",
		GEAR_UPPERBODY = "loc_item_type_gear_upperbody",
		HAIR_COLOR = "loc_item_type_hair_color",
		SET = "loc_item_type_set",
		GEAR_HEAD = "loc_item_type_gear_head",
		CHARACTER_INSIGNIA = "loc_item_type_character_insignia"
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
		COMPANION_GEAR_FULL = "content/ui/textures/icons/item_types/companion_gear_full",
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
		GEAR_UPPERBODY = "content/ui/materials/icons/item_types/upper_bodies",
		GEAR_HEAD = "content/ui/materials/icons/item_types/headgears",
		END_OF_ROUND = "content/ui/materials/icons/item_types/poses",
		WEAPON_RANGED = "content/ui/materials/icons/item_types/ranged_weapons",
		SKIN_COLOR = "content/ui/materials/icons/item_types/outfits",
		HAIR = "content/ui/materials/icons/item_types/hair_styles",
		GEAR_EXTRA_COSMETIC = "content/ui/materials/icons/item_types/outfits",
		WEAPON_MELEE = "content/ui/materials/icons/item_types/melee_weapons",
		PORTRAIT_FRAME = "content/ui/materials/icons/item_types/nameplates",
		DEVICE = "content/ui/materials/icons/item_types/devices",
		FACE_HAIR = "content/ui/materials/icons/item_types/facial_hair_styles",
		CHARACTER_TITLE = "content/ui/materials/icons/item_types/nameplates",
		HAIR_COLOR = "content/ui/materials/icons/item_types/hair_styles",
		WEAPON_TRINKET = "content/ui/materials/icons/item_types/weapon_trinkets",
		EYE_COLOR = "content/ui/materials/icons/item_types/eye_color",
		COMPANION_GEAR_FULL = "content/ui/materials/icons/item_types/companion_gear_full",
		SET = "content/ui/materials/icons/item_types/outfits",
		FACE_SCAR = "content/ui/materials/icons/item_types/scars",
		FACE = "content/ui/materials/icons/item_types/face_types",
		GADGET = "content/ui/materials/icons/item_types/devices",
		WEAPON_SKIN = "content/ui/materials/icons/item_types/weapons",
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
		"companion_gear_full",
		"boons",
		"devices",
		"emotes",
		"nameplates",
		"outfits",
		"poses",
		"weapons"
	},
	texture_by_store_category = {
		emotes = "content/ui/materials/icons/item_types/emotes",
		weapons = "content/ui/materials/icons/item_types/weapons",
		nameplates = "content/ui/materials/icons/item_types/nameplates",
		boons = "content/ui/materials/icons/item_types/boons",
		devices = "content/ui/materials/icons/item_types/devices",
		outfits = "content/ui/materials/icons/item_types/outfits",
		poses = "content/ui/materials/icons/item_types/poses",
		companion_gear_full = "content/ui/materials/icons/item_types/companion_gear_full"
	},
	display_name_by_store_category = {
		emotes = "loc_store_category_display_name_emotes",
		weapons = "loc_store_category_display_name_weapons",
		nameplates = "loc_store_category_display_name_nameplates",
		boons = "loc_store_category_display_name_boons",
		devices = "loc_store_category_display_name_devices",
		outfits = "loc_store_category_display_name_outfits",
		poses = "loc_store_category_display_name_poses",
		companion_gear_full = "loc_store_category_display_name_archetype_specific"
	},
	store_category_sort_order = {
		emotes = 6,
		weapons = 1,
		devices = 2,
		companion_gear_full = 8,
		nameplates = 4,
		outfits = 3,
		poses = 5,
		boons = 7
	},
	player_slot_colors = {
		Color.player_slot_1(255, true),
		Color.player_slot_2(255, true),
		Color.player_slot_3(255, true),
		(Color.player_slot_4(255, true))
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
	weapon_card_headers = {
		parry = "loc_weapon_special_parry_desc",
		fire = "loc_stats_fire_mode_hip_fire_desc",
		ads = "loc_ranged_attack_secondary_ads",
		push = "loc_stats_special_action_melee_push_desc",
		bayonet = "loc_weapon_special_bayonet",
		light = "loc_weapon_action_title_light",
		flashlight = "loc_weapon_special_flashlight",
		primary_attack = "loc_weapon_action_title_primary",
		explosive_punch = "loc_weapon_special_fist_attack_gauntlet",
		defence_stance = "loc_weapon_special_defensive_stance",
		charge = "loc_stats_fire_mode_chargeup_desc",
		secondary_attack = "loc_weapon_action_title_secondary",
		special_ammo = "loc_weapon_special_special_ammo",
		switch_mode = "loc_weapon_special_mode_switch",
		activate = "loc_weapon_special_activate",
		activate_warp = "loc_forcesword_p1_m1_attack_special",
		brace = "loc_ranged_attack_secondary_braced",
		vent = "loc_stats_special_action_venting_desc",
		weapon_bash = "loc_weapon_special_fist_attack",
		special_attack = "loc_weapon_special_special_attack",
		ammo = "loc_glossary_term_ammunition",
		strike = "loc_forcestaff_p1_m1_attack_special",
		wind_slash = "loc_weapon_special_wind_slash",
		hipfire = "loc_ranged_attack_primary",
		heavy = "loc_weapon_action_title_heavy"
	},
	weapon_card_icons = {
		special_attack = "content/ui/materials/icons/weapons/actions/special_attack",
		quick_grenade = "content/ui/materials/icons/weapons/actions/quick_grenade",
		melee = "content/ui/materials/icons/weapons/actions/melee",
		special_ammo = "content/ui/materials/icons/weapons/actions/special_bullet",
		defence = "content/ui/materials/icons/weapons/actions/defence",
		full_auto = "content/ui/materials/icons/weapons/actions/full_auto",
		semi_auto = "content/ui/materials/icons/weapons/actions/semi_auto",
		vent = "content/ui/materials/icons/weapons/actions/vent",
		projectile = "content/ui/materials/icons/weapons/actions/projectile",
		burst = "content/ui/materials/icons/weapons/actions/burst",
		charge = "content/ui/materials/icons/weapons/actions/charge",
		melee_hand = "content/ui/materials/icons/weapons/actions/melee_hand",
		ninja_fencer = "content/ui/materials/icons/weapons/actions/ninjafencer",
		activate = "content/ui/materials/icons/weapons/actions/activate",
		brace = "content/ui/materials/icons/weapons/actions/brace",
		shotgun = "content/ui/materials/icons/weapons/actions/shotgun",
		tank = "content/ui/materials/icons/weapons/actions/tank",
		flashlight = "content/ui/materials/icons/weapons/actions/flashlight",
		linesman = "content/ui/materials/icons/weapons/actions/linesman",
		smiter = "content/ui/materials/icons/weapons/actions/smiter",
		hipfire = "content/ui/materials/icons/weapons/actions/hipfire",
		ads = "content/ui/materials/icons/weapons/actions/ads"
	},
	weapon_card_value_funcs = {
		primary_attack = function (weapon_stats)
			local advanced_weapon_stats = weapon_stats._weapon_statistics
			local power_stats = advanced_weapon_stats.power_stats
			local power_stat = power_stats[1]
			local value = power_stat and math.round(power_stat.attack) or ""

			return value
		end,
		secondary_attack = function (weapon_stats)
			local advanced_weapon_stats = weapon_stats._weapon_statistics
			local power_stats = advanced_weapon_stats.power_stats
			local power_stat = power_stats[2]
			local value = power_stat and math.round(power_stat.attack) or ""

			return value
		end,
		secondary_attack_double_barrel = function (weapon_stats)
			local advanced_weapon_stats = weapon_stats._weapon_statistics
			local power_stats = advanced_weapon_stats.power_stats
			local power_stat = power_stats[2]
			local value = power_stat and math.round(power_stat.attack) or ""

			return value * 2
		end,
		extra_attack = function (weapon_stats)
			local advanced_weapon_stats = weapon_stats._weapon_statistics
			local power_stats = advanced_weapon_stats.power_stats
			local power_stat = power_stats[3]
			local value = power_stat and math.round(power_stat.attack) or ""

			return value
		end,
		ammo = function (weapon_stats)
			local main_stats = weapon_stats:get_main_stats()
			local magazine = main_stats.magazine
			local value = magazine and string.format("%i/%i", magazine.ammo, magazine.reserve)

			return value
		end
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
	weapon_action_extended_display_order_array = {
		"special",
		"primary",
		"secondary",
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
		psyker = "",
		adamant = "",
		ogryn = "",
		veteran = "",
		zealot = ""
	},
	archetype_font_icon_simple = {
		psyker = "",
		adamant = "",
		ogryn = "",
		veteran = "",
		zealot = ""
	},
	inventory_frames_by_archetype = {
		adamant = {
			right_upper = "content/ui/materials/frames/screen/adamant_01_upper_right",
			left_lower = "content/ui/materials/frames/screen/adamant_01_lower_left",
			right_lower = "content/ui/materials/frames/screen/adamant_01_lower_right",
			left_upper = "content/ui/materials/frames/screen/adamant_01_upper_left"
		},
		ogryn = {
			right_upper = "content/ui/materials/frames/screen/class_ogryn_01_upper_right",
			left_lower = "content/ui/materials/frames/screen/class_ogryn_01_lower_left",
			right_lower = "content/ui/materials/frames/screen/class_ogryn_01_lower_right",
			left_upper = "content/ui/materials/frames/screen/class_ogryn_01_upper_left"
		},
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
			"slot_body_hair",
			"slot_gear_upperbody"
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
			"slot_body_hair",
			"slot_gear_upperbody"
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
	item_preview_required_slot_items_per_slot_by_breed_and_gender = {
		human = {
			male = {
				default = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/male_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/male_mannequin_arms",
					slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/empty_upperbody",
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
					slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/preview_belt_mannequin",
					slot_body_face = "content/items/characters/player/human/attachment_base/male_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/male_mannequin_torso"
				}
			},
			female = {
				default = {
					slot_body_legs = "content/items/characters/player/human/attachment_base/female_mannequin_legs",
					slot_body_arms = "content/items/characters/player/human/attachment_base/female_mannequin_arms",
					slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/empty_upperbody",
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
					slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/preview_belt_mannequin",
					slot_body_face = "content/items/characters/player/human/attachment_base/female_mannequin_face",
					slot_body_torso = "content/items/characters/player/human/attachment_base/female_mannequin_torso"
				}
			}
		},
		ogryn = {
			male = {
				default = {
					slot_body_legs = "content/items/characters/player/ogryn/attachment_base/mannequin_legs",
					slot_body_arms = "content/items/characters/player/ogryn/attachment_base/mannequin_arms",
					slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/empty_upperbody",
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
					slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_preview_belt_mannequin",
					slot_body_face = "content/items/characters/player/ogryn/attachment_base/mannequin_face",
					slot_body_torso = "content/items/characters/player/ogryn/attachment_base/mannequin_torso"
				}
			}
		}
	},
	weapon_patterns = {
		stubrevolver_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/stubrevolver_p1_m2_complete",
			display_name = "loc_weapon_family_stubrevolver_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/stubrevolver_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/stubrevolver_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/stubrevolver_p1_m1",
					name = "stubrevolver_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/stubrevolver_p1_m2",
					name = "stubrevolver_p1_m2"
				}
			}
		},
		shotgun_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/shotgun_p1_m2_complete",
			display_name = "loc_weapon_family_shotgun_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/shotgun_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/shotgun_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/shotgun_p1_m1",
					name = "shotgun_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/shotgun_p1_m2",
					name = "shotgun_p1_m2"
				},
				{
					item = "content/items/weapons/player/ranged/shotgun_p1_m3",
					name = "shotgun_p1_m3"
				}
			}
		},
		shotgun_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/shotgun_p2_m1_complete",
			display_name = "loc_weapon_family_shotgun_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/shotgun_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/shotgun_p2_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/shotgun_p2_m1",
					name = "shotgun_p2_m1"
				}
			}
		},
		shotgun_p4 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/shotgun_p4_m1_complete",
			display_name = "loc_weapon_family_shotgun_p4_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/shotgun_p4_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/shotgun_p4_m1_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/shotgun_p4_m1",
					name = "shotgun_p4_m1"
				},
				{
					item = "content/items/weapons/player/ranged/shotgun_p4_m2",
					name = "shotgun_p4_m2"
				}
			}
		},
		shotpistol_shield_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/shield_shotpistol_p1_m1_complete",
			display_name = "loc_weapon_family_shotpistol_shield_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/shield_shotpistol_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/shield_shotpistol_p1_m1_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/shotpistol_shield_p1_m1",
					name = "shotpistol_shield_p1_m1"
				}
			}
		},
		plasmagun_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/plasmagun_p1_m1_complete",
			display_name = "loc_weapon_family_plasmagun_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/plasmagun_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/plasmagun_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/plasmagun_p1_m1",
					name = "plasmagun_p1_m1"
				}
			}
		},
		ogryn_thumper_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_thumper_p1_m1_complete",
			display_name = "loc_weapon_family_ogryn_thumper_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_thumper_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_thumper_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/ogryn_thumper_p1_m1",
					name = "ogryn_thumper_p1_m1"
				}
			}
		},
		ogryn_thumper_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_thumper_p1_m2_complete",
			display_name = "loc_weapon_family_ogryn_thumper_p1_m2",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_thumper_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_thumper_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/ogryn_thumper_p1_m2",
					name = "ogryn_thumper_p1_m2"
				}
			}
		},
		ogryn_rippergun_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/rippergun_p1_m1_complete",
			display_name = "loc_weapon_family_ogryn_rippergun_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/rippergun_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/rippergun_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
					name = "ogryn_rippergun_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m2",
					name = "ogryn_rippergun_p1_m2"
				},
				{
					item = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m3",
					name = "ogryn_rippergun_p1_m3"
				}
			}
		},
		ogryn_heavystubber_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_heavystubber_p1_m2_complete",
			display_name = "loc_weapon_family_ogryn_heavystubber_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_heavystubber_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_heavystubber_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/ogryn_heavystubber_p1_m1",
					name = "ogryn_heavystubber_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/ogryn_heavystubber_p1_m2",
					name = "ogryn_heavystubber_p1_m2"
				},
				{
					item = "content/items/weapons/player/ranged/ogryn_heavystubber_p1_m3",
					name = "ogryn_heavystubber_p1_m3"
				}
			}
		},
		ogryn_heavystubber_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_heavystubber_p2_m1_complete",
			display_name = "loc_weapon_family_ogryn_heavystubber_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_heavystubber_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_heavystubber_p2_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/ogryn_heavystubber_p2_m1",
					name = "ogryn_heavystubber_p2_m1"
				},
				{
					item = "content/items/weapons/player/ranged/ogryn_heavystubber_p2_m2",
					name = "ogryn_heavystubber_p2_m2"
				},
				{
					item = "content/items/weapons/player/ranged/ogryn_heavystubber_p2_m3",
					name = "ogryn_heavystubber_p2_m3"
				}
			}
		},
		ogryn_gauntlet_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_gauntlet_p1_m1_complete",
			display_name = "loc_weapon_family_ogryn_gauntlet_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_gauntlet_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_gauntlet_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1",
					name = "ogryn_gauntlet_p1_m1"
				}
			}
		},
		laspistol_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/laspistol_p1_m1_complete",
			display_name = "loc_weapon_family_laspistol_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/laspistol_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/laspistol_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/laspistol_p1_m1",
					name = "laspistol_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/laspistol_p1_m2",
					name = "laspistol_p1_m2"
				},
				{
					item = "content/items/weapons/player/ranged/laspistol_p1_m3",
					name = "laspistol_p1_m3"
				}
			}
		},
		lasgun_p3 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/lasgun_p3_m2_complete",
			display_name = "loc_weapon_family_lasgun_p3_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/lasgun_p3_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/lasgun_p3_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/lasgun_p3_m1",
					name = "lasgun_p3_m1"
				},
				{
					item = "content/items/weapons/player/ranged/lasgun_p3_m2",
					name = "lasgun_p3_m2"
				},
				{
					item = "content/items/weapons/player/ranged/lasgun_p3_m3",
					name = "lasgun_p3_m3"
				}
			}
		},
		lasgun_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/lasgun_p2_m2_complete",
			display_name = "loc_weapon_family_lasgun_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/lasgun_p2_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/lasgun_p2_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/lasgun_p2_m1",
					name = "lasgun_p2_m1"
				},
				{
					item = "content/items/weapons/player/ranged/lasgun_p2_m2",
					name = "lasgun_p2_m2"
				},
				{
					item = "content/items/weapons/player/ranged/lasgun_p2_m3",
					name = "lasgun_p2_m3"
				}
			}
		},
		lasgun_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/lasgun_p1_m1_complete",
			display_name = "loc_weapon_family_lasgun_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/lasgun_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/lasgun_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/lasgun_p1_m1",
					name = "lasgun_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/lasgun_p1_m2",
					name = "lasgun_p1_m2"
				},
				{
					item = "content/items/weapons/player/ranged/lasgun_p1_m3",
					name = "lasgun_p1_m3"
				}
			}
		},
		forcestaff_p4 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/forcestaff_p1_m1_complete",
			display_name = "loc_weapon_family_forcestaff_p4_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/forcestaff_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/forcestaff_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/forcestaff_p4_m1",
					name = "forcestaff_p4_m1"
				}
			}
		},
		forcestaff_p3 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/forcestaff_p3_m1_complete",
			display_name = "loc_weapon_family_forcestaff_p3_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/forcestaff_p3_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/forcestaff_p3_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/forcestaff_p3_m1",
					name = "forcestaff_p3_m1"
				}
			}
		},
		forcestaff_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/forcestaff_p2_m1_complete",
			display_name = "loc_weapon_family_forcestaff_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/forcestaff_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/forcestaff_p2_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/forcestaff_p2_m1",
					name = "forcestaff_p2_m1"
				}
			}
		},
		forcestaff_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/forcestaff_p1_m1_complete",
			display_name = "loc_weapon_family_forcestaff_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/forcestaff_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/forcestaff_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/forcestaff_p1_m1",
					name = "forcestaff_p1_m1"
				}
			}
		},
		flamer_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/flamer_p1_complete",
			display_name = "loc_weapon_family_flamer_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/flamer_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/flamer_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/flamer_p1_m1",
					name = "flamer_p1_m1"
				}
			}
		},
		bolter_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/bolter_p1_complete",
			display_name = "loc_weapon_family_bolter_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/bolter_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/bolter_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/bolter_p1_m1",
					name = "bolter_p1_m1"
				}
			}
		},
		boltpistol_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/boltpistol_p1_m1_complete",
			display_name = "loc_weapon_family_boltpistol_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/boltpistol_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/boltpistol_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/boltpistol_p1_m1",
					name = "boltpistol_p1_m1"
				}
			}
		},
		autopistol_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/autopistol_p1_complete",
			display_name = "loc_weapon_family_autopistol_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/autopistol_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/autopistol_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/autopistol_p1_m1",
					name = "autopistol_p1_m1"
				}
			}
		},
		autogun_p3 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/autogun_p3_m2_complete",
			display_name = "loc_weapon_family_autogun_p3_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/autogun_p3_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/autogun_p3_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/autogun_p3_m1",
					name = "autogun_p3_m1"
				},
				{
					item = "content/items/weapons/player/ranged/autogun_p3_m2",
					name = "autogun_p3_m2"
				},
				{
					item = "content/items/weapons/player/ranged/autogun_p3_m3",
					name = "autogun_p3_m3"
				}
			}
		},
		autogun_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/autogun_p2_m1_complete",
			display_name = "loc_weapon_family_autogun_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/autogun_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/autogun_p2_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/autogun_p2_m1",
					name = "autogun_p2_m1"
				},
				{
					item = "content/items/weapons/player/ranged/autogun_p2_m2",
					name = "autogun_p2_m2"
				},
				{
					item = "content/items/weapons/player/ranged/autogun_p2_m3",
					name = "autogun_p2_m3"
				}
			}
		},
		autogun_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/autogun_p1_m1_complete",
			display_name = "loc_weapon_family_autogun_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/autogun_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/autogun_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/ranged/autogun_p1_m1",
					name = "autogun_p1_m1"
				},
				{
					item = "content/items/weapons/player/ranged/autogun_p1_m2",
					name = "autogun_p1_m2"
				},
				{
					item = "content/items/weapons/player/ranged/autogun_p1_m3",
					name = "autogun_p1_m3"
				}
			}
		},
		thunderhammer_2h_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/thunderhammer_2h_p1_complete",
			display_name = "loc_weapon_family_thunderhammer_2h_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/thunderhammer_2h_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/thunderhammer_2h_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
					name = "thunderhammer_2h_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/thunderhammer_2h_p1_m2",
					name = "thunderhammer_2h_p1_m2"
				}
			}
		},
		powersword_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/powersword_p1_m1_complete",
			display_name = "loc_weapon_family_powersword_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/powersword_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/powersword_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/powersword_p1_m1",
					name = "powersword_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/powersword_p1_m2",
					name = "powersword_p1_m2"
				}
			}
		},
		powersword_2h_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/powersword_2h_p1_m1_complete",
			display_name = "loc_weapon_family_powersword_2h_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/powersword_2h_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/powersword_2h_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/powersword_2h_p1_m1",
					name = "powersword_2h_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/powersword_2h_p1_m2",
					name = "powersword_2h_p1_m2"
				}
			}
		},
		powermaul_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/powermaul_p1_complete",
			display_name = "loc_weapon_family_powermaul_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/powermaul_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/powermaul_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/powermaul_p1_m1",
					name = "powermaul_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/powermaul_p1_m2",
					name = "powermaul_p1_m2"
				}
			}
		},
		powermaul_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/powermaul_p2_m1_complete",
			display_name = "loc_weapon_family_powermaul_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/powermaul_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/powermaul_p2_m1_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/powermaul_p2_m1",
					name = "powermaul_p2_m1"
				}
			}
		},
		powermaul_shield_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/shield_powermaul_p1_m1_complete",
			display_name = "loc_weapon_family_powermaul_shield_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/shield_powermaul_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/shield_powermaul_p1_m1_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/powermaul_shield_p1_m1",
					name = "powermaul_shield_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/powermaul_shield_p1_m2",
					name = "powermaul_shield_p1_m2"
				}
			}
		},
		powermaul_2h_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/powermaul_2h_p1_m1_complete",
			display_name = "loc_weapon_family_powermaul_2h_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/powermaul_2h_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/powermaul_2h_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/powermaul_2h_p1_m1",
					name = "powermaul_2h_p1_m1"
				}
			}
		},
		ogryn_powermaul_slabshield_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_powermaul_slabshield_p1_m1_complete",
			display_name = "loc_weapon_family_ogryn_powermaul_slabshield_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_powermaul_slabshield_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_powermaul_slabshield_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/ogryn_powermaul_slabshield_p1_m1",
					name = "ogryn_powermaul_slabshield_p1_m1"
				}
			}
		},
		ogryn_powermaul_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_powermaul_p1_m1_complete",
			display_name = "loc_weapon_family_ogryn_powermaul_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_powermaul_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_powermaul_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/ogryn_powermaul_p1_m1",
					name = "ogryn_powermaul_p1_m1"
				}
			}
		},
		ogryn_combatblade_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_combatblade_p1_m2_complete",
			display_name = "loc_weapon_family_ogryn_combatblade_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_combatblade_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_combatblade_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
					name = "ogryn_combatblade_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_combatblade_p1_m2",
					name = "ogryn_combatblade_p1_m2"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_combatblade_p1_m3",
					name = "ogryn_combatblade_p1_m3"
				}
			}
		},
		ogryn_club_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_club_p2_m3_complete",
			display_name = "loc_weapon_family_ogryn_club_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_club_p2_m3",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_club_p2_m3_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/ogryn_club_p2_m1",
					name = "ogryn_club_p2_m1"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_club_p2_m2",
					name = "ogryn_club_p2_m2"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_club_p2_m3",
					name = "ogryn_club_p2_m3"
				}
			}
		},
		ogryn_club_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_club_p1_m2_complete",
			display_name = "loc_weapon_family_ogryn_club_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_club_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_club_p1_m2_complete_mask",
			marks = {
				{
					comparison_text = "",
					name = "ogryn_club_p1_m1",
					item = "content/items/weapons/player/melee/ogryn_club_p1_m1"
				},
				{
					comparison_text = "",
					name = "ogryn_club_p1_m2",
					item = "content/items/weapons/player/melee/ogryn_club_p1_m2"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_club_p1_m3",
					name = "ogryn_club_p1_m3"
				}
			}
		},
		ogryn_pickaxe_2h_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/ogryn_pickaxe_2h_p1_m1_complete",
			display_name = "loc_weapon_family_ogryn_pickaxe_2h_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/ogryn_pickaxe_2h_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/ogryn_pickaxe_2h_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/ogryn_pickaxe_2h_p1_m1",
					name = "ogryn_pickaxe_2h_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_pickaxe_2h_p1_m2",
					name = "ogryn_pickaxe_2h_p1_m2"
				},
				{
					item = "content/items/weapons/player/melee/ogryn_pickaxe_2h_p1_m3",
					name = "ogryn_pickaxe_2h_p1_m3"
				}
			}
		},
		forcesword_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/forcesword_p1_m1_complete",
			display_name = "loc_weapon_family_forcesword_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/forcesword_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/forcesword_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/forcesword_p1_m1",
					name = "forcesword_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/forcesword_p1_m2",
					name = "forcesword_p1_m2"
				},
				{
					item = "content/items/weapons/player/melee/forcesword_p1_m3",
					name = "forcesword_p1_m3"
				}
			}
		},
		forcesword_2h_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/forcesword_2h_p1_m1_complete",
			display_name = "loc_weapon_family_forcesword_2h_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/forcesword_2h_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/forcesword_2h_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/forcesword_2h_p1_m1",
					name = "forcesword_2h_p1_m1"
				},
				{
					comparison_text = "",
					name = "forcesword_2h_p1_m2",
					item = "content/items/weapons/player/melee/forcesword_2h_p1_m2"
				}
			}
		},
		combatsword_p3 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combatsword_p3_m2_complete",
			display_name = "loc_weapon_family_combatsword_p3_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combatsword_p3_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combatsword_p3_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combatsword_p3_m1",
					name = "combatsword_p3_m1"
				},
				{
					comparison_text = "",
					name = "combatsword_p3_m2",
					item = "content/items/weapons/player/melee/combatsword_p3_m2"
				},
				{
					comparison_text = "",
					name = "combatsword_p3_m3",
					item = "content/items/weapons/player/melee/combatsword_p3_m3"
				}
			}
		},
		combatsword_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combatsword_p2_m1_complete",
			display_name = "loc_weapon_family_combatsword_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combatsword_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combatsword_p2_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combatsword_p2_m1",
					name = "combatsword_p2_m1"
				},
				{
					item = "content/items/weapons/player/melee/combatsword_p2_m2",
					name = "combatsword_p2_m2"
				},
				{
					item = "content/items/weapons/player/melee/combatsword_p2_m3",
					name = "combatsword_p2_m3"
				}
			}
		},
		combatsword_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combatsword_p1_complete",
			display_name = "loc_weapon_family_combatsword_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combatsword_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combatsword_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combatsword_p1_m1",
					name = "combatsword_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/combatsword_p1_m2",
					name = "combatsword_p1_m2"
				},
				{
					item = "content/items/weapons/player/melee/combatsword_p1_m3",
					name = "combatsword_p1_m3"
				}
			}
		},
		combatknife_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combatknife_p1_m2_complete",
			display_name = "loc_weapon_family_combatknife_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combatknife_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combatknife_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combatknife_p1_m1",
					name = "combatknife_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/combatknife_p1_m2",
					name = "combatknife_p1_m2"
				}
			}
		},
		combataxe_p3 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combataxe_p3_m1_complete",
			display_name = "loc_weapon_family_combataxe_p3_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combataxe_p3_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combataxe_p3_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combataxe_p3_m1",
					name = "combataxe_p3_m1"
				},
				{
					item = "content/items/weapons/player/melee/combataxe_p3_m2",
					name = "combataxe_p3_m2"
				},
				{
					item = "content/items/weapons/player/melee/combataxe_p3_m3",
					name = "combataxe_p3_m3"
				}
			}
		},
		combataxe_p2 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combataxe_p2_m1_complete",
			display_name = "loc_weapon_family_combataxe_p2_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combataxe_p2_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combataxe_p2_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combataxe_p2_m1",
					name = "combataxe_p2_m1"
				},
				{
					item = "content/items/weapons/player/melee/combataxe_p2_m2",
					name = "combataxe_p2_m2"
				},
				{
					item = "content/items/weapons/player/melee/combataxe_p2_m3",
					name = "combataxe_p2_m3"
				}
			}
		},
		combataxe_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/combataxe_p1_m1_complete",
			display_name = "loc_weapon_family_combataxe_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/combataxe_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/combataxe_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/combataxe_p1_m1",
					name = "combataxe_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/combataxe_p1_m2",
					name = "combataxe_p1_m2"
				},
				{
					item = "content/items/weapons/player/melee/combataxe_p1_m3",
					name = "combataxe_p1_m3"
				}
			}
		},
		chainsword_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/chainsword_p1_complete",
			display_name = "loc_weapon_family_chainsword_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/chainsword_p1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/chainsword_p1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/chainsword_p1_m1",
					name = "chainsword_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/chainsword_p1_m2",
					name = "chainsword_p1_m2"
				}
			}
		},
		chainsword_2h_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/chainsword_2h_p1_m1_complete",
			display_name = "loc_weapon_family_chainsword_2h_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/chainsword_2h_p1_m1",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/chainsword_2h_p1_m1_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/chainsword_2h_p1_m1",
					name = "chainsword_2h_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/chainsword_2h_p1_m2",
					name = "chainsword_2h_p1_m2"
				}
			}
		},
		chainaxe_p1 = {
			overview_icon_texture_complete = "content/ui/textures/icons/weapons/masteries/chainaxe_p1_m2_complete",
			display_name = "loc_weapon_family_chainaxe_p1_m1",
			overview_icon_texture = "content/ui/textures/icons/weapons/masteries/chainaxe_p1_m2",
			overview_icon_texture_mask = "content/ui/textures/icons/weapons/masteries/chainaxe_p1_m2_complete_mask",
			marks = {
				{
					item = "content/items/weapons/player/melee/chainaxe_p1_m1",
					name = "chainaxe_p1_m1"
				},
				{
					item = "content/items/weapons/player/melee/chainaxe_p1_m2",
					name = "chainaxe_p1_m2"
				}
			}
		}
	},
	assist_type_localization_lookup = {
		saved = "loc_notification_desc_saved_by",
		cleansed = "loc_notification_desc_cleanced_by",
		revived = "loc_notification_desc_revived_by",
		rescued = "loc_notification_desc_rescued_by",
		stimmed = "loc_notification_desc_stimmed_by",
		assisted = "loc_notification_desc_assisted_by",
		gifted = "loc_notification_desc_gifted_by"
	},
	assist_type_enter_sound_lookup = {
		saved = "notification_assist_saved",
		cleansed = "notification_assist_cleansed",
		revived = "notification_assist_revived",
		rescued = "notification_assist_rescued",
		stimmed = "notification_assist_stimmed",
		assisted = "notification_assist_assisted",
		gifted = "notification_assist_gifted"
	}
}

return settings("UiSettings", ui_settings)
