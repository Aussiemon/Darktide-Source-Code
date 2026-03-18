-- chunkname: @scripts/ui/views/expedition_view/expedition_view_options_element.lua

local ViewElementMissionBoardOptions = require("scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options")
local RegionLocalizationMappings = require("scripts/settings/backend/region_localization")
local ExpeditionViewDefinitions = require("scripts/ui/views/expedition_view/expedition_view_definitions")
local MATCH_VISIBILITY = ExpeditionViewDefinitions.MATCH_VISIBILITY
local OptionsElement = class("OptionsElement")

OptionsElement.init = function (self, owner_view)
	self._owner_view = owner_view
end

OptionsElement._cb_close_options_element = function (self)
	self._owner_view:_remove_element("options_element")

	self._owner_view.block_legend_input = false
	self._view_element = nil
end

OptionsElement.present = function (self)
	if self._view_element then
		return
	end

	self._view_element = self._owner_view:_add_element(ViewElementMissionBoardOptions, "options_element", 200, {
		on_destroy_callback = callback(self, "_cb_close_options_element"),
	})

	local presentation_data = {
		{
			display_name = "loc_mission_board_view_options_Matchmaking_Location",
			id = "region_matchmaking",
			tooltip_text = "loc_matchmaking_change_region_confirmation_desc",
			widget_type = "dropdown",
			validation_function = function ()
				return
			end,
			on_activated = function (value, template)
				Managers.data_service.region_latency:set_prefered_mission_region(value)
			end,
			get_function = function (template)
				local options = template.options_function()
				local prefered_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()

				for i = 1, #options do
					local option = options[i]

					if option.value == prefered_mission_region then
						return option.id
					end
				end

				return 1
			end,
			options_function = function (template)
				local options = {}

				for region_name, latency_data in pairs(self._owner_view.regions_latency) do
					local loc_key = RegionLocalizationMappings[region_name]
					local ignore_localization = true
					local region_display_name = loc_key and Localize(loc_key) or region_name

					if math.abs(latency_data.min_latency - latency_data.max_latency) < 5 then
						region_display_name = string.format("%s %dms", region_display_name, latency_data.min_latency)
					else
						region_display_name = string.format("%s %d-%dms", region_display_name, latency_data.min_latency, latency_data.max_latency)
					end

					options[#options + 1] = {
						id = region_name,
						display_name = region_display_name,
						ignore_localization = ignore_localization,
						value = region_name,
						latency_order = latency_data.min_latency,
					}
				end

				table.sort(options, function (a, b)
					return a.latency_order < b.latency_order
				end)

				return options
			end,
			on_changed = function (value)
				Managers.data_service.region_latency:set_prefered_mission_region(value)
			end,
		},
		{
			display_name = "loc_private_tag_name",
			id = "private_match",
			tooltip_text = "loc_mission_board_view_options_private_game_desc",
			widget_type = "checkbox",
			start_value = self._owner_view.current_match_visibility == MATCH_VISIBILITY.private,
			get_function = function ()
				return self._owner_view.current_match_visibility == MATCH_VISIBILITY.private
			end,
			on_activated = function (value, data)
				data.changed_callback(value)
			end,
			on_changed = function (value)
				self._owner_view:cb_toggle_private_match()
			end,
		},
	}

	self._view_element:present(presentation_data)
end

return OptionsElement
