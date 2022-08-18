local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local widget_definitions = {}
local input_legend_params = {}
local intro_texts = {
	description_text = "loc_contract_view_intro_description",
	title_text = "loc_contract_view_intro_title"
}
local button_options_definitions = {
	{
		display_name = "loc_contract_view_option_contracts",
		callback = function (self)
			local tab_bar_params = {
				layer = 10,
				tabs_params = {
					{
						view = "contracts_view",
						level_story_event = "servitor_contracts_anim"
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params)
		end
	},
	{
		display_name = "loc_contract_view_option_mark_store",
		callback = function (self)
			local tab_bar_params = {
				layer = 10,
				tabs_params = {
					{
						view = "marks_vendor_view",
						view_function = "show_temporary_items",
						display_name = "loc_mark_vendor_view_title_temporary",
						level_story_event = "servitor_goods_anim"
					},
					{
						view = "marks_vendor_view",
						view_function = "show_standard_items",
						display_name = "loc_mark_vendor_view_title_standard",
						level_story_event = "servitor_goods_anim"
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params)
		end
	}
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/contracts_view",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_contracts_view_camera",
	viewport_name = "ui_contracts_view_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/contracts_view/contracts_view",
	world_name = "ui_contracts_view_world"
}

return {
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params
}
