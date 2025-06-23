-- chunkname: @scripts/utilities/ui/popups/skip_player_journey_popup.lua

local popup_context = {
	title_text = "loc_popup_header_skip_journey",
	description_text = "loc_popup_description_skip_journey",
	options = {
		{
			text = "loc_popup_skip_journey_yes_button",
			template_type = "terminal_button_hold_small",
			close_on_pressed = true,
			template_options = {
				timer = 2
			}
		},
		{
			close_on_pressed = true,
			text = "loc_popup_skip_journey_no_button"
		}
	}
}

local function skip_player_journey_popup(context, id_callback, yes_callback, no_callback)
	context.options[1].callback = yes_callback
	context.options[2].callback = no_callback

	Managers.event:trigger("event_show_ui_popup", context, id_callback)
end

local function skip_journey_mind_wipe(id_callback, yes_callback, no_callback)
	local context = table.clone(popup_context)

	context.description_text = "loc_popup_description_skip_journey_mind_wipe"
	context.options[2].text = "loc_popup_skip_journey_mind_wipe_no_button"

	skip_player_journey_popup(context, id_callback, yes_callback, no_callback)
end

local function skip_journey_hub(id_callback, yes_callback, no_callback)
	local context = table.clone(popup_context)

	skip_player_journey_popup(context, id_callback, yes_callback, no_callback)
end

return {
	mind_wipe = skip_journey_mind_wipe,
	hub = skip_journey_hub
}
