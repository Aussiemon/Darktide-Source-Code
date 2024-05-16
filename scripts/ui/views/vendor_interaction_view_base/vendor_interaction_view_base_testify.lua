-- chunkname: @scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base_testify.lua

local VendorInteractionViewBaseTestify = {
	vendor_interaction_view_press_option = function (vendor_interaction_view_base, option_id)
		local button_options_definitions = vendor_interaction_view_base:base_definitions().button_options_definitions

		vendor_interaction_view_base:on_option_button_pressed(option_id, button_options_definitions[option_id])
	end,
}

return VendorInteractionViewBaseTestify
