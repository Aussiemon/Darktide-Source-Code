local PointOfInterest = component("PointOfInterest")

PointOfInterest.init = function (self, unit, is_server)
	local point_of_interest_extension = ScriptUnit.fetch_component_extension(unit, "point_of_interest_system")

	if point_of_interest_extension and is_server then
		local view_distance = self:get_data(unit, "view_distance")
		local is_dynamic = self:get_data(unit, "is_dynamic")
		local tag = self:get_data(unit, "tag")
		local faction_breed_name = self:get_data(unit, "faction_breed_name")
		local faction_event = self:get_data(unit, "faction_event")

		point_of_interest_extension:setup_from_component(view_distance, is_dynamic, tag, faction_event, faction_breed_name)
	end
end

PointOfInterest.editor_init = function (self, unit)
	return
end

PointOfInterest.enable = function (self, unit)
	return
end

PointOfInterest.disable = function (self, unit)
	return
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
	faction_breed_name = {
		value = "",
		ui_type = "combo_box",
		category = "Faction",
		ui_name = "Breed Name",
		options_keys = {
			"",
			"npc"
		},
		options_values = {
			"",
			"npc"
		}
	},
	faction_event = {
		value = "",
		ui_type = "combo_box",
		category = "Faction",
		ui_name = "Event Name",
		options_keys = {
			"",
			"look_at"
		},
		options_values = {
			"",
			"look_at"
		}
	},
	extensions = {
		"PointOfInterestTargetExtension"
	}
}

return PointOfInterest
