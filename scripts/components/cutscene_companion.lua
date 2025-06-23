-- chunkname: @scripts/components/cutscene_companion.lua

local Breed = require("scripts/utilities/breed")
local CutsceneCompanion = component("CutsceneCompanion")

CutsceneCompanion.init = function (self, unit)
	if DEDICATED_SERVER then
		return false
	end

	self._unit = unit

	local cinematic_name = self:get_data(unit, "cinematic_name")

	self._cinematic_name = cinematic_name

	local breed_name = self:get_data(unit, "breed_name")

	self._breed_name = breed_name

	local cinematic_slot = self:get_data(unit, "cinematic_slot")

	self._cinematic_slot = cinematic_slot

	local starting_animation_event = self:get_data(unit, "starting_animation_event")

	self._starting_animation_event = cinematic_slot

	local walking_animation_event = self:get_data(unit, "walking_animation_event")

	self._walking_animation_event = cinematic_slot

	local cutscene_companion_extension = ScriptUnit.fetch_component_extension(unit, "cutscene_character_system")

	if cutscene_companion_extension then
		cutscene_companion_extension:setup_from_component(cinematic_name, breed_name, cinematic_slot, starting_animation_event, walking_animation_event)
	end

	if self:get_data(unit, "materialize") ~= "disabled" then
		self.run_update_on_enable = true

		self:init_materialize()
	end
end

CutsceneCompanion.extensions_ready = function (self, world, unit)
	local cutscene_companion_extension = ScriptUnit.has_extension(unit, "cutscene_character_system")

	self._cutscene_companion_extension = cutscene_companion_extension
end

CutsceneCompanion.editor_validate = function (self, unit)
	return true, ""
end

CutsceneCompanion.enable = function (self, unit)
	return
end

CutsceneCompanion.disable = function (self, unit)
	return
end

CutsceneCompanion.destroy = function (self, unit)
	return
end

CutsceneCompanion.cinematic_name = function (self)
	return self._cinematic_name
end

CutsceneCompanion.breed_name = function (self)
	return self._breed_name
end

CutsceneCompanion.trigger_walk_animation_event = function (self)
	if DEDICATED_SERVER or not self._cutscene_companion_extension then
		return false
	end

	self._cutscene_companion_extension:trigger_walk_animation_event()
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

CutsceneCompanion.update = function (self, unit, dt, t)
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
		end

		if not data.wielded_set and lerp_t >= data.wielded_per then
			data.wielded_set = true
		end

		if not data.visible_set and lerp_t >= data.visible_per then
			data.visible_set = true

			if self._cutscene_companion_extension then
				self._cutscene_companion_extension:set_visibility(data.visible)
			end
		end
	end

	return self._should_update
end

CutsceneCompanion.editor_update = function (self, unit, dt, t)
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

CutsceneCompanion.init_materialize = function (self)
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

		if self._cutscene_companion_extension then
			self._cutscene_companion_extension:set_visibility(false)
		end
	end
end

CutsceneCompanion.start_materialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	if not self._cutscene_companion_extension or not self._cutscene_companion_extension:has_player_assigned() then
		return false
	end

	self:init_materialize()

	local unit = self._unit

	self._materialize_data = {
		duration = 2.7,
		wielded_vis = true,
		wielded_per = 0.6,
		current_t = 0,
		eyes_per = 0.9,
		visible_per = 0.01,
		eyes_set = false,
		visible = true,
		wielded_set = false,
		visible_set = false,
		from = get_min(unit),
		to = get_max(unit, self._breed_name)
	}
	self._should_update = true

	return true
end

CutsceneCompanion.start_dematerialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	if not self._cutscene_companion_extension or not self._cutscene_companion_extension:has_player_assigned() then
		return false
	end

	self:init_materialize()

	local unit = self._unit
	local eyes_percentage = 0.65

	if self._cinematic_name == "outro_win" then
		eyes_percentage = 0.1
	end

	self._materialize_data = {
		duration = 2.7,
		wielded_vis = false,
		wielded_per = 0.5,
		current_t = 0,
		visible_per = 0.99,
		eyes_set = false,
		visible = false,
		wielded_set = false,
		visible_set = false,
		from = get_max(unit, self._breed_name),
		to = get_min(unit),
		eyes_per = eyes_percentage
	}
	self._should_update = true

	return true
end

CutsceneCompanion.component_data = {
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
			"Traitor Captain Intro",
			"Hub Location Intro Barber",
			"Hub Location Intro Mission Board",
			"Hub Location Intro Training Grounds",
			"Hub Location Intro Contracts",
			"Hub Location Intro Crafting",
			"Hub Location Intro Gun Shop"
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
			"hub_location_intro_gun_shop"
		}
	},
	breed_name = {
		value = "none",
		ui_type = "combo_box",
		ui_name = "Breed Name",
		options_keys = {
			"None",
			"Companion Dog"
		},
		options_values = {
			"none",
			"companion_dog"
		}
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
	starting_animation_event = {
		ui_type = "text_box",
		value = "",
		ui_name = "Starting Animation Event"
	},
	walking_animation_event = {
		ui_type = "text_box",
		value = "",
		ui_name = "Walk Animation Event"
	},
	materialize = {
		ui_type = "combo_box",
		category = "Materialize",
		value = "disabled",
		ui_name = "Materialize",
		options_keys = {
			"Disabled",
			"Enabled (Start Visible)",
			"Enabled (Start Hidden)"
		},
		options_values = {
			"disabled",
			"enabled_visible",
			"enabled_hidden"
		}
	},
	inputs = {
		start_weapon_specific_walk_animation = {
			accessibility = "public",
			type = "event"
		},
		start_inventory_specific_walk_animation = {
			accessibility = "public",
			type = "event"
		},
		start_materialize = {
			accessibility = "public",
			type = "event"
		},
		start_dematerialize = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"CutsceneCompanionExtension"
	}
}

return CutsceneCompanion
