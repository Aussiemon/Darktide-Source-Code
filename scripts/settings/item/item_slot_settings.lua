-- chunkname: @scripts/settings/item/item_slot_settings.lua

local item_slot_settings = {
	slot_body_face = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_face_tattoo",
			"slot_body_face_scar",
			"slot_body_face_hair",
			"slot_body_face_implant",
			"slot_body_eye_color",
			"slot_body_skin_color",
			"slot_body_hair_color",
			"slot_body_hair",
			"slot_gear_head",
		},
	},
	slot_body_face_tattoo = {
		show_in_character_create = true,
		slot_type = "body",
	},
	slot_body_face_scar = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_skin_color",
		},
	},
	slot_body_face_hair = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_hair_color",
		},
	},
	slot_body_torso = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_tattoo",
			"slot_body_face_tattoo",
			"slot_body_skin_color",
		},
	},
	slot_body_legs = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_tattoo",
			"slot_body_face_tattoo",
			"slot_body_skin_color",
		},
	},
	slot_body_arms = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_tattoo",
			"slot_body_face_tattoo",
			"slot_body_skin_color",
		},
	},
	slot_body_hair = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_hair_color",
		},
	},
	slot_body_tattoo = {
		show_in_character_create = true,
		slot_type = "body",
		slot_dependencies = {
			"slot_body_face_tattoo",
		},
	},
	slot_companion_body_skin_color = {
		show_in_character_create = true,
		slot_type = "body",
		archetype_restrictions = {
			"adamant",
		},
	},
	slot_companion_body_fur_color = {
		show_in_character_create = true,
		slot_type = "body",
		archetype_restrictions = {
			"adamant",
		},
	},
	slot_companion_body_coat_pattern = {
		show_in_character_create = true,
		slot_type = "body",
		archetype_restrictions = {
			"adamant",
		},
	},
	slot_body_hair_color = {
		show_in_character_create = true,
		slot_type = "body",
	},
	slot_body_skin_color = {
		show_in_character_create = true,
		slot_type = "body",
	},
	slot_body_eye_color = {
		show_in_character_create = true,
		slot_type = "body",
	},
	slot_companion_gear_full = {
		display_icon = "content/ui/materials/icons/cosmetics/categories/companion_gear_full",
		display_name = "loc_inventory_title_slot_companion_gear_full",
		equipped_in_inventory = true,
		show_in_character_create = true,
		slot_type = "gear",
		store_category = "companion_gear_full",
		archetype_restrictions = {
			"adamant",
		},
	},
	slot_gear_head = {
		display_icon = "content/ui/materials/icons/cosmetics/categories/headgear",
		display_name = "loc_inventory_title_slot_gear_head",
		equipped_in_inventory = true,
		slot_type = "gear",
		store_category = "outfits",
	},
	slot_gear_upperbody = {
		display_icon = "content/ui/materials/icons/cosmetics/categories/upper_body",
		display_name = "loc_inventory_title_slot_gear_upperbody",
		equipped_in_inventory = true,
		slot_type = "gear",
		store_category = "outfits",
	},
	slot_gear_lowerbody = {
		display_icon = "content/ui/materials/icons/cosmetics/categories/lower_body",
		display_name = "loc_inventory_title_slot_gear_lowerbody",
		equipped_in_inventory = true,
		slot_type = "gear",
		store_category = "outfits",
	},
	slot_gear_extra_cosmetic = {
		display_icon = "content/ui/materials/icons/cosmetics/categories/upper_body",
		display_name = "loc_inventory_title_slot_gear_extra_cosmetic",
		equipped_in_inventory = true,
		slot_type = "gear",
		store_category = "outfits",
	},
	slot_gear_material_override_decal = {
		show_in_character_create = true,
		slot_type = "material",
		archetype_restrictions = {
			"adamant",
		},
	},
	slot_attachment_1 = {
		display_name = "loc_inventory_title_slot_attachment_1",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "gadget",
		store_category = "devices",
	},
	slot_attachment_2 = {
		display_name = "loc_inventory_title_slot_attachment_2",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "gadget",
		store_category = "devices",
	},
	slot_attachment_3 = {
		display_name = "loc_inventory_title_slot_attachment_3",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "gadget",
		store_category = "devices",
	},
	slot_insignia = {
		display_name = "loc_inventory_title_slot_insignia",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "nameplates",
		item_icon_size = {
			40,
			100,
		},
	},
	slot_portrait_frame = {
		display_name = "loc_inventory_title_slot_portrait_frame",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "nameplates",
		item_icon_size = {
			90,
			100,
		},
	},
	slot_character_title = {
		display_name = "loc_inventory_title_slot_character_title",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "nameplates",
		icon_color = Color.terminal_text_body(255, true),
		item_icon_size = {
			90,
			90,
		},
	},
	slot_animation_emote_1 = {
		display_name = "loc_inventory_title_slot_animation_emote_1",
		equipped_in_inventory = true,
		icon_angle = 0,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "emotes",
		item_icon_size = {
			128,
			128,
		},
		icon_color = Color.terminal_text_body(255, true),
	},
	slot_animation_emote_2 = {
		display_name = "loc_inventory_title_slot_animation_emote_2",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "emotes",
		item_icon_size = {
			128,
			128,
		},
		icon_color = Color.terminal_text_body(255, true),
		icon_angle = -math.pi / 2.5,
	},
	slot_animation_emote_3 = {
		display_name = "loc_inventory_title_slot_animation_emote_3",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "emotes",
		item_icon_size = {
			128,
			128,
		},
		icon_color = Color.terminal_text_body(255, true),
		icon_angle = -math.pi / 1.25,
	},
	slot_animation_emote_4 = {
		display_name = "loc_inventory_title_slot_animation_emote_4",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "emotes",
		item_icon_size = {
			128,
			128,
		},
		icon_color = Color.terminal_text_body(255, true),
		icon_angle = math.pi / 1.25,
	},
	slot_animation_emote_5 = {
		display_name = "loc_inventory_title_slot_animation_emote_5",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "emotes",
		item_icon_size = {
			128,
			128,
		},
		icon_color = Color.terminal_text_body(255, true),
		icon_angle = math.pi / 2.5,
	},
	slot_animation_end_of_round = {
		display_name = "loc_inventory_title_slot_animation_end_of_round",
		equipped_in_inventory = true,
		ignore_character_spawning = true,
		slot_type = "ui",
		store_category = "poses",
		icon_angle = math.pi / 2.5,
	},
	slot_trinket_1 = {
		display_name = "loc_inventory_title_slot_trinket_1",
		ignore_character_spawning = true,
		slot_type = "ui",
	},
	slot_weapon_skin = {
		display_name = "loc_inventory_title_slot_primary",
		ignore_character_spawning = true,
		slot_type = "weapon",
	},
	slot_luggable = {
		slot_type = "luggable",
	},
	slot_primary = {
		buffable = true,
		display_name = "loc_inventory_title_slot_primary",
		equipped_in_inventory = true,
		gamepad_wield_input = "quick_wield",
		slot_type = "weapon",
		store_category = "weapons",
		wield_input = "wield_1",
	},
	slot_secondary = {
		buffable = true,
		display_name = "loc_inventory_title_slot_secondary",
		equipped_in_inventory = true,
		gamepad_wield_input = "quick_wield",
		slot_type = "weapon",
		store_category = "weapons",
		wield_input = "wield_2",
	},
	slot_pocketable = {
		slot_type = "pocketable",
		wield_input = "wield_3",
		gamepad_wield_input = {
			"wield_3",
			"wield_3_gamepad",
		},
	},
	slot_pocketable_small = {
		ability_type = "pocketable_ability",
		slot_type = "pocketable",
		wield_input = "wield_4",
		gamepad_wield_input = {
			"wield_4",
			"wield_3_gamepad",
		},
	},
	slot_device = {
		slot_type = "device",
		wield_input = "wield_5",
	},
	slot_unarmed = {
		slot_type = "unarmed",
	},
	slot_combat_ability = {
		slot_type = "ability",
	},
	slot_grenade_ability = {
		ability_type = "grenade_ability",
		slot_type = "ability",
	},
	slot_set = {},
	inspect_pose = {},
	slot_net = {
		slot_type = "vfx",
	},
}

for slot_name, config in pairs(item_slot_settings) do
	config.name = slot_name
end

return settings("ItemSlotSettings", item_slot_settings)
