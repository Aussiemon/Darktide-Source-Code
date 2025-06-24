-- chunkname: @scripts/components/cutscene_character.lua

local Breed = require("scripts/utilities/breed")
local CutsceneCharacter = component("CutsceneCharacter")

CutsceneCharacter.init = function (self, unit)
	if DEDICATED_SERVER then
		return false
	end

	self._unit = unit

	local cinematic_name = self:get_data(unit, "cinematic_name")

	self._cinematic_name = cinematic_name

	local character_type = self:get_data(unit, "character_type")

	self._character_type = character_type

	local breed_name = self:get_data(unit, "breed_name")

	self._breed_name = breed_name

	local companion_inclusion_setting = self:get_data(unit, "companion_inclusion_setting")

	self._companion_inclusion_setting = companion_inclusion_setting

	local cinematic_slot = self:get_data(unit, "cinematic_slot")

	self._cinematic_slot = cinematic_slot

	local equip_slot_on_loadout_assign = self:get_data(unit, "equip_slot_on_loadout_assign")
	local cutscene_character_extension = ScriptUnit.fetch_component_extension(unit, "cutscene_character_system")

	if cutscene_character_extension then
		local prop_items = self:get_data(unit, "prop_items")
		local animation_event = self:get_data(unit, "animation_event")

		cutscene_character_extension:setup_from_component(cinematic_name, character_type, breed_name, prop_items, cinematic_slot, animation_event, equip_slot_on_loadout_assign, companion_inclusion_setting)
	end

	if self:get_data(unit, "materialize") ~= "disabled" then
		self.run_update_on_enable = true

		self:init_materialize()
	end
end

CutsceneCharacter.editor_validate = function (self, unit)
	return true, ""
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

CutsceneCharacter.companion_inclusion_setting = function (self)
	return self._companion_inclusion_setting
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

local function set_eye_visibility(unit, state)
	local size = state and Vector3(1, 1, 1) or Vector3(0, 0, 0)
	local children = Unit.get_child_units(unit)

	if children ~= nil then
		for _, child in pairs(children) do
			if Unit.has_node(child, "j_lefteye") then
				local node = Unit.node(child, "j_lefteye")

				Unit.set_local_scale(child, node, size)
			end

			if Unit.has_node(child, "j_righteye") then
				local node = Unit.node(child, "j_righteye")

				Unit.set_local_scale(child, node, size)
			end
		end
	end
end

CutsceneCharacter.update = function (self, unit, dt, t)
	local data = self._materialize_data

	if data then
		local lerp_t = math.clamp01(data.current_t / data.duration)
		local value = math.lerp(data.from, data.to, lerp_t)

		data.current_t = data.current_t + dt

		Unit.set_scalar_for_materials(unit, "materialize_data", value, true)

		if lerp_t >= 1 then
			self._should_update = false
		end

		if not data.eyes_set and lerp_t > data.eyes_per then
			data.eyes_set = true

			set_eye_visibility(unit, data.visible)
		end

		if not data.wielded_set and lerp_t >= data.wielded_per then
			data.wielded_set = true

			local cutscene_character_extension = ScriptUnit.extension(unit, "cutscene_character_system")

			cutscene_character_extension:wield_slot_set_visibility(data.wielded_vis)
		end

		if not data.visible_set and lerp_t >= data.visible_per then
			data.visible_set = true

			local cutscene_character_extension = ScriptUnit.extension(unit, "cutscene_character_system")

			cutscene_character_extension:set_visibility(data.visible)
		end
	end

	return self._should_update
end

CutsceneCharacter.editor_update = function (self, unit, dt, t)
	return self:update(unit, dt, t)
end

local function get_min(unit)
	local pos = Unit.world_position(unit, 1)

	return -0.1 + pos.z
end

local function get_max(unit, breed_name)
	local pos = Unit.world_position(unit, 1)
	local cutscene_character_extension = ScriptUnit.extension(unit, "cutscene_character_system")
	local breed = cutscene_character_extension:breed()
	local z_scale = Unit.local_scale(unit, 1).z
	local height = Breed.height(unit, breed) * 1.2 * z_scale

	return height + pos.z + 0.1
end

CutsceneCharacter.init_materialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	local unit = self._unit

	if self:get_data(unit, "materialize") == "enabled_visible" then
		Unit.set_permutation_for_materials(unit, "HAS_DEMATERIALIZE", true, true)
		Unit.set_scalar_for_materials(unit, "materialize_data", get_max(unit), true)
	else
		Unit.set_permutation_for_materials(unit, "HAS_DEMATERIALIZE", true, true)
		Unit.set_scalar_for_materials(unit, "materialize_data", get_min(unit), true)
		set_eye_visibility(unit, false)

		local cutscene_character_extension = ScriptUnit.extension(unit, "cutscene_character_system")

		cutscene_character_extension:wield_slot_set_visibility(false)
		cutscene_character_extension:set_visibility(false)
	end
end

CutsceneCharacter.start_materialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	self:init_materialize()

	local unit = self._unit

	self._materialize_data = {
		current_t = 0,
		duration = 2.7,
		eyes_per = 0.9,
		eyes_set = false,
		visible = true,
		visible_per = 0.01,
		visible_set = false,
		wielded_per = 0.6,
		wielded_set = false,
		wielded_vis = true,
		from = get_min(unit),
		to = get_max(unit, self._breed_name),
	}
	self._should_update = true

	return true
end

CutsceneCharacter.start_dematerialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	self:init_materialize()

	local unit = self._unit
	local eyes_percentage = 0.65

	if self._cinematic_name == "outro_win" then
		eyes_percentage = 0.1
	end

	self._materialize_data = {
		current_t = 0,
		duration = 2.7,
		eyes_set = false,
		visible = false,
		visible_per = 0.99,
		visible_set = false,
		wielded_per = 0.5,
		wielded_set = false,
		wielded_vis = false,
		from = get_max(unit, self._breed_name),
		to = get_min(unit),
		eyes_per = eyes_percentage,
	}
	self._should_update = true

	return true
end

CutsceneCharacter.component_data = {
	cinematic_name = {
		ui_name = "Cinematic Name",
		ui_type = "combo_box",
		value = "none",
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
			"Traitor Captain Intro",
			"Hub Location Intro Barber",
			"Hub Location Intro Mission Board",
			"Hub Location Intro Training Grounds",
			"Hub Location Intro Contracts",
			"Hub Location Intro Crafting",
			"Hub Location Intro Gun Shop",
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
			"traitor_captain_intro",
			"hub_location_intro_barber",
			"hub_location_intro_mission_board",
			"hub_location_intro_training_grounds",
			"hub_location_intro_contracts",
			"hub_location_intro_crafting",
			"hub_location_intro_gun_shop",
		},
	},
	character_type = {
		ui_name = "Character Type",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Player",
			"NPC",
		},
		options_values = {
			"none",
			"player",
			"npc",
		},
	},
	breed_name = {
		ui_name = "Breed Name",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Human",
			"Ogryn",
			"Companion Dog",
		},
		options_values = {
			"none",
			"human",
			"ogryn",
			"companion_dog",
		},
	},
	companion_inclusion_setting = {
		ui_name = "Companion Inclusion",
		ui_type = "combo_box",
		value = "any",
		options_keys = {
			"Any",
			"With Companion Only",
			"Without Companion Only",
		},
		options_values = {
			"any",
			"with_companion",
			"without_companion",
		},
	},
	prop_items = {
		category = "Attachments",
		ui_name = "Prop Items",
		ui_type = "text_box_array",
		validator = "contentpathsallowed",
		values = {},
	},
	cinematic_slot = {
		ui_name = "Slot",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"1",
			"2",
			"3",
			"4",
		},
		options_values = {
			"none",
			1,
			2,
			3,
			4,
		},
	},
	animation_event = {
		ui_name = "Animation Inventory Event",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"ready_idle",
			"unready_idle",
			"to_ready",
		},
		options_values = {
			"none",
			"cin_ready",
			"unready_idle",
			"ready",
		},
	},
	equip_slot_on_loadout_assign = {
		category = "Attachments",
		ui_name = "Equip Slot on Loadout Assignment",
		ui_type = "text_box",
		value = "",
	},
	materialize = {
		category = "Materialize",
		ui_name = "Materialize",
		ui_type = "combo_box",
		value = "disabled",
		options_keys = {
			"Disabled",
			"Enabled (Start Visible)",
			"Enabled (Start Hidden)",
		},
		options_values = {
			"disabled",
			"enabled_visible",
			"enabled_hidden",
		},
	},
	inputs = {
		start_weapon_specific_walk_animation = {
			accessibility = "public",
			type = "event",
		},
		start_inventory_specific_walk_animation = {
			accessibility = "public",
			type = "event",
		},
		start_materialize = {
			accessibility = "public",
			type = "event",
		},
		start_dematerialize = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"CutsceneCharacterExtension",
	},
}

return CutsceneCharacter
