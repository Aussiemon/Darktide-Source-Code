local CutsceneCharacter = component("CutsceneCharacter")

CutsceneCharacter.init = function (self, unit)
	if DEDICATED_SERVER then
		return false
	end

	self:enable(unit)

	self._unit = unit
	local cinematic_name = self:get_data(unit, "cinematic_name")
	self._cinematic_name = cinematic_name
	local character_type = self:get_data(unit, "character_type")
	self._character_type = character_type
	local breed_name = self:get_data(unit, "breed_name")
	self._breed_name = breed_name
	local cinematic_slot = self:get_data(unit, "cinematic_slot")
	self._cinematic_slot = cinematic_slot
	local equip_slot_on_loadout_assign = self:get_data(unit, "equip_slot_on_loadout_assign")
	local cutscene_character_extension = ScriptUnit.fetch_component_extension(unit, "cutscene_character_system")

	if cutscene_character_extension then
		local prop_items = self:get_data(unit, "prop_items")
		local animation_event = self:get_data(unit, "animation_event")

		cutscene_character_extension:setup_from_component(cinematic_name, character_type, breed_name, prop_items, cinematic_slot, animation_event, equip_slot_on_loadout_assign)
	end
end

CutsceneCharacter.editor_init = function (self, unit)
	self:enable(unit)
end

CutsceneCharacter.enable = function (self, unit)
	return
end

CutsceneCharacter.disable = function (self, unit)
	return
end

CutsceneCharacter.destroy = function (self, unit)
	return
end

CutsceneCharacter.cinematic_name = function (self)
	return self._cinematic_name
end

CutsceneCharacter.character_type = function (self)
	return self._character_type
end

CutsceneCharacter.breed_name = function (self)
	return self._breed_name
end

CutsceneCharacter.start_weapon_specific_walk_animation = function (self)
	if DEDICATED_SERVER then
		return false
	end

	local cutscene_character_extension = ScriptUnit.extension(self._unit, "cutscene_character_system")

	cutscene_character_extension:start_weapon_specific_walk_animation()
end

CutsceneCharacter.start_inventory_specific_walk_animation = function (self)
	if DEDICATED_SERVER then
		return false
	end

	local cutscene_character_extension = ScriptUnit.extension(self._unit, "cutscene_character_system")

	cutscene_character_extension:start_inventory_specific_walk_animation()
end

CutsceneCharacter.component_data = {
	cinematic_name = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Cinematic Name",
		options_keys = {
			"None",
			"Intro ABC",
			"Outro Win",
			"Outro Fail",
			"Cutscene 01",
			"Cutscene 02",
			"Cutscene 03",
			"Cutscene 04",
			"Cutscene 05",
			"Cutscene 05 Hub",
			"Cutscene 6",
			"Cutscene 7",
			"Cutscene 8",
			"Cutscene 9",
			"Cutscene 10",
			"Path of Trust 01",
			"Path of Trust 02",
			"Path of Trust 03",
			"Path of Trust 04",
			"Path of Trust 05",
			"Path of Trust 06",
			"Path of Trust 07",
			"Path of Trust 08",
			"Path of Trust 09",
			"Traitor Captain Intro"
		},
		options_values = {
			"none",
			"intro_abc",
			"outro_win",
			"outro_fail",
			"cutscene_1",
			"cutscene_2",
			"cutscene_3",
			"cutscene_4",
			"cutscene_5",
			"cutscene_5_hub",
			"cutscene_6",
			"cutscene_7",
			"cutscene_8",
			"cutscene_9",
			"cutscene_10",
			"path_of_trust_01",
			"path_of_trust_02",
			"path_of_trust_03",
			"path_of_trust_04",
			"path_of_trust_05",
			"path_of_trust_06",
			"path_of_trust_07",
			"path_of_trust_08",
			"path_of_trust_09",
			"traitor_captain_intro"
		}
	},
	character_type = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Character Type",
		options_keys = {
			"None",
			"Player",
			"NPC"
		},
		options_values = {
			"none",
			"player",
			"npc"
		}
	},
	breed_name = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Breed Name",
		options_keys = {
			"None",
			"Human",
			"Ogryn"
		},
		options_values = {
			"none",
			"human",
			"ogryn"
		}
	},
	prop_items = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		ui_name = "Prop Items",
		values = {}
	},
	cinematic_slot = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Slot",
		options_keys = {
			"None",
			"1",
			"2",
			"3",
			"4"
		},
		options_values = {
			"none",
			1,
			2,
			3,
			4
		}
	},
	animation_event = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Animation Inventory Event",
		options_keys = {
			"None",
			"ready_idle",
			"unready_idle",
			"to_ready"
		},
		options_values = {
			"none",
			"cin_ready",
			"unready_idle",
			"ready"
		}
	},
	equip_slot_on_loadout_assign = {
		ui_type = "text_box",
		value = "",
		ui_name = "Equip Slot on Loadout Assignment",
		category = "Attachments"
	},
	inputs = {
		start_weapon_specific_walk_animation = {
			accessibility = "public",
			type = "event"
		},
		start_inventory_specific_walk_animation = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"CutsceneCharacterExtension"
	}
}

return CutsceneCharacter
