-- chunkname: @scripts/utilities/player_character_body.lua

local MasterItems = require("scripts/backend/master_items")
local UiMannequinItems = require("scripts/settings/ui/ui_mannequin_items")
local PlayerCharacterBody = {}

PlayerCharacterBody.wrap_deform_item_name_from_profile = function (profile)
	if profile.gender == "female" then
		return "content/items/material_overrides/player_wrap_deform/wrap_deform_human_body_female"
	end

	return nil
end

PlayerCharacterBody.fill_mannequin_loadout = function (loadout, optional_item, optional_item_slot_name, mannequin_breed_name, mannequin_archetype_name, mannequin_gender)
	local breed_mannequin_item_names = UiMannequinItems[mannequin_breed_name]
	local gender_mannequin_item_names = breed_mannequin_item_names and breed_mannequin_item_names[mannequin_gender]
	local mannequin_item_names = gender_mannequin_item_names and optional_item_slot_name and gender_mannequin_item_names[optional_item_slot_name] or gender_mannequin_item_names.default

	if mannequin_item_names then
		for slot_name, slot_item_name in pairs(mannequin_item_names) do
			local item_definition = MasterItems.get_item(slot_item_name)

			if item_definition then
				local slot_item = table.clone(item_definition)

				loadout[slot_name] = slot_item
			end
		end
	end

	if optional_item and optional_item.companion_state_machine then
		if mannequin_archetype_name == "adamant" then
			loadout.slot_companion_gear_full = MasterItems.get_item("content/items/characters/companion/companion_dog/gear_full/companion_dog_set_02_var_01")
		elseif mannequin_archetype_name == "cryptic" then
			loadout.slot_companion_gear_full = MasterItems.get_item("content/items/characters/companion/companion_servo_skull/gear_full/cryptic_servo_skull_scanning_var_01")
		end
	end
end

return PlayerCharacterBody
