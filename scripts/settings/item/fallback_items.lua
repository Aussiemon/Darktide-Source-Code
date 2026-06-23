-- chunkname: @scripts/settings/item/fallback_items.lua

local base_fallback_items = {
	slot_animation_emote_1 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_emote_2 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_emote_3 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_emote_4 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_emote_5 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_end_of_round = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_body_arms = "content/items/characters/player/human/attachments_default/slot_body_arms",
	slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_01",
	slot_body_eye_color_secondary = "content/items/characters/player/eye_colors/eye_color_blue_01",
	slot_body_face = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_face_hair = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_face_makeup = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_face_scar = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_face_tattoo = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_hair = "content/items/characters/player/human/attachments_default/slot_body_hair",
	slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01",
	slot_body_legs = "content/items/characters/player/human/attachments_default/slot_body_legs",
	slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_pale_01",
	slot_body_skin_color_secondary = "content/items/characters/player/skin_colors/skin_color_pale_01",
	slot_body_skin_discoloration = "content/items/characters/player/skin_colors/skin_color_pale_01",
	slot_body_tattoo = "content/items/characters/player/human/attachments_default/slot_body_torso",
	slot_body_torso = "content/items/characters/player/human/attachments_default/slot_body_torso",
	slot_character_title = "content/items/titles/title_default",
	slot_companion_body_coat_pattern = "content/items/characters/companion/companion_dog/body_coat_patterns/empty_companion_body_coat_pattern",
	slot_companion_body_fur_color = "content/items/characters/companion/companion_dog/body_fur_colors/empty_companion_body_fur_color",
	slot_companion_body_skin_color = "content/items/characters/companion/companion_dog/body_skin_colors/empty_companion_body_skin_color",
	slot_companion_gear_full = "content/items/characters/companion/companion_dog/gear_full/empty_companion_gear_full",
	slot_device = "content/items/devices/empty_device",
	slot_gear_extra_cosmetic = "content/items/characters/player/human/attachments_default/slot_attachment",
	slot_gear_head = "content/items/characters/player/human/attachments_default/slot_gear_head",
	slot_gear_lowerbody = "content/items/characters/player/human/attachments_default/slot_gear_legs",
	slot_gear_material_override_decal = "content/items/characters/player/human/gear_material_override_decal/empty_material_override_decal",
	slot_gear_upperbody = "content/items/characters/player/human/attachments_default/slot_gear_torso",
	slot_insignia = "content/items/2d/insignias/insignia_default",
	slot_pocketable = "content/items/pocketable/empty_pocketable",
	slot_pocketable_small = "content/items/pocketable/empty_pocketable",
	slot_portrait_frame = "content/items/2d/portrait_frames/portrait_frame_default",
	slot_primary = "content/items/weapons/player/melee/unarmed",
	slot_secondary = "content/items/weapons/player/melee/unarmed",
	slot_timed = "content/items/weapons/player/melee/unarmed",
	slot_trinket_1 = "content/items/weapons/player/trinkets/empty_trinket",
	slot_unarmed = "content/items/weapons/player/melee/unarmed",
	slot_weapon_skin = "content/items/weapons/player/skins/lasgun/lasgun_p1_m001",
}

if BUILD == "release" then
	local release_fallback_items = {
		slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair",
		slot_body_face_makeup = "content/items/characters/player/human/face_makeup/empty_face_makeup",
		slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar",
		slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo",
		slot_body_hair = "content/items/characters/player/human/hair/empty_hair",
		slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo",
		slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/empty_backpack",
		slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear",
		slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/empty_lowerbody",
		slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/empty_upperbody",
	}

	for slot_name, item_name in pairs(release_fallback_items) do
		base_fallback_items[slot_name] = item_name
	end
end

local fallback_items = {
	by_slot = base_fallback_items,
}

return settings("FallbackItems", fallback_items)
