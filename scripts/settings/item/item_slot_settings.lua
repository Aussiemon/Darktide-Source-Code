local UISettings = require("scripts/settings/ui/ui_settings")
local item_slot_settings = {
	slot_body_face = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_face_tattoo",
			"slot_body_face_scar",
			"slot_body_face_hair",
			"slot_body_face_implant",
			"slot_body_eye_color",
			"slot_body_skin_color",
			"slot_body_hair_color",
			"slot_body_hair",
			"slot_gear_head"
		}
	},
	slot_body_face_tattoo = {
		show_in_character_create = true,
		slot_type = "body"
	},
	slot_body_face_scar = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_skin_color"
		}
	},
	slot_body_face_hair = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_hair_color"
		}
	},
	slot_body_torso = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_tattoo",
			"slot_body_face_tattoo",
			"slot_body_skin_color"
		}
	},
	slot_body_legs = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_tattoo",
			"slot_body_face_tattoo",
			"slot_body_skin_color"
		}
	},
	slot_body_arms = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_tattoo",
			"slot_body_face_tattoo",
			"slot_body_skin_color"
		}
	},
	slot_body_hair = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_hair_color"
		}
	},
	slot_body_tattoo = {
		slot_type = "body",
		show_in_character_create = true,
		slot_dependencies = {
			"slot_body_face_tattoo"
		}
	},
	slot_body_hair_color = {
		show_in_character_create = true,
		slot_type = "body"
	},
	slot_body_skin_color = {
		show_in_character_create = true,
		slot_type = "body"
	},
	slot_body_eye_color = {
		show_in_character_create = true,
		slot_type = "body"
	},
	slot_gear_head = {
		store_category = "outfits",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_gear_head",
		display_icon = "content/ui/materials/icons/cosmetics/categories/headgear",
		slot_type = "gear"
	},
	slot_gear_upperbody = {
		store_category = "outfits",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_gear_upperbody",
		display_icon = "content/ui/materials/icons/cosmetics/categories/upper_body",
		slot_type = "gear"
	},
	slot_gear_lowerbody = {
		store_category = "outfits",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_gear_lowerbody",
		display_icon = "content/ui/materials/icons/cosmetics/categories/lower_body",
		slot_type = "gear"
	},
	slot_gear_extra_cosmetic = {
		store_category = "outfits",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_gear_extra_cosmetic",
		display_icon = "content/ui/materials/icons/cosmetics/categories/upper_body",
		slot_type = "gear"
	},
	slot_attachment_1 = {
		store_category = "devices",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_attachment_1",
		slot_type = "gadget",
		ignore_character_spawning = true
	},
	slot_attachment_2 = {
		store_category = "devices",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_attachment_2",
		slot_type = "gadget",
		ignore_character_spawning = true
	},
	slot_attachment_3 = {
		store_category = "devices",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_attachment_3",
		slot_type = "gadget",
		ignore_character_spawning = true
	},
	slot_insignia = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_insignia",
		store_category = "nameplates",
		slot_type = "ui",
		ignore_character_spawning = true,
		item_icon_size = {
			30,
			80
		}
	},
	slot_portrait_frame = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_portrait_frame",
		store_category = "nameplates",
		slot_type = "ui",
		ignore_character_spawning = true,
		item_icon_size = {
			60,
			70
		}
	},
	slot_animation_emote_1 = {
		icon_angle = 0,
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_animation_emote_1",
		store_category = "emotes",
		slot_type = "ui",
		ignore_character_spawning = true
	},
	slot_animation_emote_2 = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_animation_emote_2",
		store_category = "emotes",
		slot_type = "ui",
		ignore_character_spawning = true,
		icon_angle = -math.pi / 2.5
	},
	slot_animation_emote_3 = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_animation_emote_3",
		store_category = "emotes",
		slot_type = "ui",
		ignore_character_spawning = true,
		icon_angle = -math.pi / 1.25
	},
	slot_animation_emote_4 = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_animation_emote_4",
		store_category = "emotes",
		slot_type = "ui",
		ignore_character_spawning = true,
		icon_angle = math.pi / 1.25
	},
	slot_animation_emote_5 = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_animation_emote_5",
		store_category = "emotes",
		slot_type = "ui",
		ignore_character_spawning = true,
		icon_angle = math.pi / 2.5
	},
	slot_animation_end_of_round = {
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_animation_end_of_round",
		store_category = "poses",
		slot_type = "ui",
		ignore_character_spawning = true,
		icon_angle = math.pi / 2.5
	},
	slot_trinket_1 = {
		store_category = "boons",
		equipped_in_inventory = true,
		display_name = "loc_inventory_title_slot_trinket_1",
		slot_type = "ui",
		ignore_character_spawning = true
	},
	slot_primary = {
		display_name = "loc_inventory_title_slot_primary",
		equipped_in_inventory = true,
		wield_input = "wield_1",
		store_category = "weapons",
		gamepad_wield_input = "quick_wield",
		slot_type = "weapon",
		hide_input_on_gamepad_wielded = true,
		buffable = true
	},
	slot_secondary = {
		display_name = "loc_inventory_title_slot_secondary",
		equipped_in_inventory = true,
		wield_input = "wield_2",
		store_category = "weapons",
		gamepad_wield_input = "quick_wield",
		slot_type = "weapon",
		hide_input_on_gamepad_wielded = true,
		buffable = true
	},
	slot_pocketable = {
		wield_input = "wield_3",
		slot_type = "pocketable"
	},
	slot_luggable = {
		slot_type = "luggable"
	},
	slot_device = {
		wield_input = "wield_4",
		slot_type = "device"
	},
	slot_unarmed = {
		slot_type = "unarmed"
	},
	slot_combat_ability = {
		slot_type = "ability"
	},
	slot_grenade_ability = {
		ability_type = "grenade_ability",
		slot_type = "ability"
	},
	slot_net = {
		slot_type = "vfx"
	}
}

for slot_name, config in pairs(item_slot_settings) do
	config.name = slot_name
end

return settings("ItemSlotSettings", item_slot_settings)
