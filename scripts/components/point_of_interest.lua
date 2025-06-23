-- chunkname: @scripts/components/point_of_interest.lua

local PointOfInterest = component("PointOfInterest")

PointOfInterest.init = function (self, unit, is_server)
	local point_of_interest_extension = ScriptUnit.fetch_component_extension(unit, "point_of_interest_system")

	if point_of_interest_extension and is_server then
		local view_distance = self:get_data(unit, "view_distance")
		local is_dynamic = self:get_data(unit, "is_dynamic")
		local tag = self:get_data(unit, "tag")
		local faction_event = self:get_data(unit, "faction_event")
		local dialogue_target_filter = self:get_data(unit, "dialogue_target_filter")
		local faction_breed_name = self:get_data(unit, "faction_breed_name")
		local mission_giver_selected_voice = self:get_data(unit, "mission_giver_selected_voice")
		local disabled = self:get_data(unit, "disabled")

		point_of_interest_extension:setup_from_component(view_distance, is_dynamic, tag, faction_event, dialogue_target_filter, faction_breed_name, mission_giver_selected_voice, disabled)
	end
end

PointOfInterest.editor_init = function (self, unit)
	return
end

PointOfInterest.editor_validate = function (self, unit)
	return true, ""
end

PointOfInterest.enable = function (self, unit)
	return
end

PointOfInterest.disable = function (self, unit)
	local point_of_interest_extension = ScriptUnit.fetch_component_extension(unit, "point_of_interest_system")

	point_of_interest_extension:set_disabled()
end

PointOfInterest.destroy = function (self, unit)
	return
end

PointOfInterest.component_data = {
	view_distance = {
		ui_type = "number",
		min = 1,
		decimals = 0,
		value = 10,
		ui_name = "View Distance (in m.)",
		step = 1
	},
	is_dynamic = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is Dynamic"
	},
	tag = {
		ui_type = "text_box",
		value = "",
		ui_name = "Tag"
	},
	dialogue_event = {
		value = "",
		ui_type = "combo_box",
		category = "Dialogue",
		ui_name = "Dialogue Event Name",
		options_keys = {
			"",
			"look_at"
		},
		options_values = {
			"",
			"look_at"
		}
	},
	dialogue_target_filter = {
		value = "none",
		ui_type = "combo_box",
		category = "Dialogue",
		ui_name = "Dialogue Target Filter",
		options_keys = {
			"none",
			"faction",
			"mission_giver_mission_default",
			"mission_giver_selected_voice"
		},
		options_values = {
			"none",
			"faction",
			"mission_giver_mission_default",
			"mission_giver_selected_voice"
		}
	},
	faction_breed_name = {
		value = "",
		ui_type = "combo_box",
		category = "Dialogue",
		ui_name = "Faction Name",
		options_keys = {
			"",
			"npc"
		},
		options_values = {
			"",
			"npc"
		}
	},
	mission_giver_selected_voice = {
		value = "",
		ui_type = "combo_box",
		category = "Dialogue",
		ui_name = "Mission Giver Selected Voice",
		options_keys = {
			"",
			"sergeant_a",
			"pilot_a",
			"explicator_a",
			"tech_priest_a",
			"training_ground_psyker_a"
		},
		options_values = {
			"",
			"sergeant_a",
			"pilot_a",
			"explicator_a",
			"tech_priest_a",
			"training_ground_psyker_a"
		}
	},
	disabled = {
		ui_type = "check_box",
		value = false,
		ui_name = "Disabled"
	},
	extensions = {
		"PointOfInterestTargetExtension"
	}
}

return PointOfInterest
