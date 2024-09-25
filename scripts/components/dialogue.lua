-- chunkname: @scripts/components/dialogue.lua

local Dialogue = component("Dialogue")

Dialogue.init = function (self, unit)
	local dialogue_class = self:get_data(unit, "dialogue_class")
	local dialogue_profile = self:get_data(unit, "dialogue_profile")
	local player_selected_voice = self:get_data(unit, "player_selected_voice")
	local faction_memory_name = self:get_data(unit, "faction_memory_name")
	local enabled = self:get_data(unit, "enabled")

	self._dialogue_class = dialogue_class
	self._dialogue_profile = dialogue_profile
	self._player_selected_voice = player_selected_voice
	self._faction_memory_name = faction_memory_name
	self._enabled = enabled

	local dialogue_extension = ScriptUnit.fetch_component_extension(unit, "dialogue_system")

	if dialogue_extension then
		dialogue_extension:setup_from_component(dialogue_class, dialogue_profile, player_selected_voice, faction_memory_name, enabled)
	end

	self:enable(unit)
end

Dialogue.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

Dialogue.editor_validate = function (self, unit)
	return true, ""
end

Dialogue.enable = function (self, unit)
	local dialogue_extension = ScriptUnit.fetch_component_extension(unit, "dialogue_system")

	dialogue_extension:set_dialogue_disabled(false)
end

Dialogue.disable = function (self, unit)
	local dialogue_extension = ScriptUnit.fetch_component_extension(unit, "dialogue_system")

	dialogue_extension:set_dialogue_disabled(true)
end

Dialogue.destroy = function (self, unit)
	return
end

Dialogue.dialogue_class = function (self)
	return self._dialogue_class
end

Dialogue.dialogue_profile = function (self)
	return self._dialogue_profile
end

Dialogue.player_selected_voice = function (self)
	return self._player_selected_voice
end

Dialogue.dialogue_faction_name = function (self)
	return self._player_selected_voice
end

Dialogue.component_data = {
	dialogue_class = {
		category = "Dialogue",
		ui_name = "Class",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Archive Servitor",
			"Boon Vendor",
			"Cargo Pilot",
			"Commissar",
			"Confessional",
			"Contract Vendor",
			"Enemy Nemesis Wolfer",
			"Enginseer",
			"Explicator",
			"Hadron Servitor",
			"Interrogator",
			"Ogryn",
			"Medicae Servitor",
			"Mourningstar Servitor",
			"Pilot",
			"Prison Guard",
			"Prologue Traitor",
			"Psyker",
			"Purser",
			"Sergeant",
			"Shipmistress",
			"Tech Priest",
			"Training Ground Psyker",
			"Underhive Contact",
			"Veteran",
			"Vocator",
			"Zealot",
			"Credit Store Servitor",
			"Mourningstar Soldier",
			"Barber",
			"Captain Twin Female",
			"Captain Twin Male",
			"Reject NPC",
			"Travelling Salesman",
		},
		options_values = {
			"none",
			"archive_servitor",
			"boon_vendor",
			"cargo_pilot",
			"commissar",
			"confessional",
			"contract_vendor",
			"enemy_nemesis_wolfer",
			"enginseer",
			"explicator",
			"mourningstar_hadron_servitor",
			"interrogator",
			"ogryn",
			"medicae_servitor",
			"mourningstar_servitor",
			"pilot",
			"prison_guard",
			"prologue_traitor",
			"psyker",
			"purser",
			"sergeant",
			"shipmistress",
			"tech_priest",
			"training_ground_psyker",
			"underhive_contact",
			"veteran",
			"vocator",
			"zealot",
			"credit_store_servitor",
			"mourningstar_soldier",
			"barber",
			"captain_twin_female",
			"captain_twin_male",
			"reject_npc",
			"travelling_salesman",
		},
	},
	dialogue_profile = {
		category = "Dialogue",
		ui_name = "Character Voice",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Archive Servitor A",
			"Boon Vendor A",
			"Cargo Pilot A",
			"Commissar A",
			"Contract Vendor",
			"Enemy Nemesis Wolfer, Male",
			"Enginseer A",
			"Emora Brahms, The Shipmistress",
			"Explicator Zola, Female",
			"Hadron Servitor A",
			"Interrogator Rannick, Male",
			"Medicae Servitor A",
			"Medicae Servitor B",
			"Mourningstar Servitor A",
			"Mourningstar Servitor B",
			"Mourningstar Servitor C",
			"Mourningstar Servitor D",
			"Ogryn, Male, The Bodyguard",
			"Ogryn, Male, The Bully",
			"Pilot Masozi, Female",
			"Prison Guard, Male",
			"Prologue Traitor, Male",
			"Psyker, Female, The Loner",
			"Psyker, Female, The Seer",
			"Psyker, Male, The Loner",
			"Psyker, Male, The Seer",
			"Purser A",
			"Sergeant Morrow, Male",
			"Sergeant Morrow B, Male",
			"Servitor, The Confessor Servitorum",
			"Tech Priest Hadron, Female",
			"Tech Priest B",
			"Training Grounds Psyker",
			"Underhive Contract A",
			"Veteran, Female, The Professional",
			"Veteran, Female, The Loose Cannon",
			"Veteran, Male, The Professional",
			"Veteran, Male, The Loose Cannon",
			"Vocator A",
			"Vocator B",
			"Mourningstar Confessor",
			"Mourningstar Wing Commander",
			"Zealot, Female, The Crusader",
			"Zealot, Female, The Fanatic",
			"Zealot, Male, The Crusader",
			"Zealot, Male, The Fanatic",
			"Credit Store Servitor A",
			"Credit Store Servitor B",
			"Credit Store Servitor C",
			"Mourningstar Soldier Male A",
			"Mourningstar Soldier Male B",
			"Mourningstar Soldier Male C",
			"Mourningstar Soldier Male D",
			"Mourningstar Soldier Male E",
			"Mourningstar Soldier Male F",
			"Mourningstar Soldier Male G",
			"Mourningstar Soldier Male H",
			"Mourningstar Soldier Female A",
			"Mourningstar Initiate A",
			"Mourningstar Initiate B",
			"Mourningstar Officer A",
			"Mourningstar Officer B",
			"Barber A",
			"Captain Twin Female",
			"Captain Twin Male",
			"Reject NPC",
			"Reject NPC Servitor",
			"Travelling Salesman A",
			"Travelling Salesman B",
			"Travelling Salesman C",
		},
		options_values = {
			"none",
			"archive_servitor_a",
			"boon_vendor_a",
			"cargo_pilot_a",
			"commissar_a",
			"contract_vendor_a",
			"enemy_nemesis_wolfer_a",
			"enginseer_a",
			"shipmistress_a",
			"explicator_a",
			"mourningstar_hadron_servitor_a",
			"interrogator_a",
			"medicae_servitor_a",
			"medicae_servitor_b",
			"mourningstar_servitor_a",
			"mourningstar_servitor_b",
			"mourningstar_servitor_c",
			"mourningstar_servitor_d",
			"ogryn_a",
			"ogryn_b",
			"pilot_a",
			"prison_guard_a",
			"prologue_traitor_a",
			"psyker_female_a",
			"psyker_female_b",
			"psyker_male_a",
			"psyker_male_b",
			"purser_a",
			"sergeant_a",
			"sergeant_b",
			"confessional_a",
			"tech_priest_a",
			"tech_priest_b",
			"training_ground_psyker_a",
			"underhive_contact_a",
			"veteran_female_a",
			"veteran_female_b",
			"veteran_male_a",
			"veteran_male_b",
			"vocator_a",
			"vocator_b",
			"mourningstar_confessor_a",
			"mourningstar_wing_commander_a",
			"zealot_female_a",
			"zealot_female_b",
			"zealot_male_a",
			"zealot_male_b",
			"credit_store_servitor_a",
			"credit_store_servitor_b",
			"credit_store_servitor_c",
			"mourningstar_soldier_male_a",
			"mourningstar_soldier_male_b",
			"mourningstar_soldier_male_c",
			"mourningstar_soldier_male_d",
			"mourningstar_soldier_male_e",
			"mourningstar_soldier_male_f",
			"mourningstar_soldier_male_g",
			"mourningstar_soldier_male_h",
			"mourningstar_soldier_female_a",
			"mourningstar_initiate_a",
			"mourningstar_initiate_b",
			"mourningstar_officer_male_a",
			"mourningstar_officer_male_b",
			"barber_a",
			"captain_twin_female_a",
			"captain_twin_male_a",
			"reject_npc_a",
			"reject_npc_servitor_a",
			"travelling_salesman_a",
			"travelling_salesman_b",
			"travelling_salesman_c",
		},
	},
	faction_memory_name = {
		category = "Dialogue",
		ui_name = "Dialogue Faction Name",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Enemy",
			"NPC",
			"Player",
		},
		options_values = {
			"none",
			"enemy",
			"npc",
			"player",
		},
	},
	player_selected_voice = {
		category = "Dialogue",
		ui_name = "Use Local Player Voice",
		ui_type = "check_box",
		value = false,
	},
	enabled = {
		ui_name = "Enabled",
		ui_type = "check_box",
		value = true,
	},
	extensions = {
		"DialogueExtension",
	},
}

return Dialogue
