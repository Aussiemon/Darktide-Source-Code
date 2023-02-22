local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
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
		blur_background = false,
		display_name = "loc_contract_view_option_contracts",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						view = "contracts_view"
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params)
		end
	},
	{
		blur_background = false,
		display_name = "loc_mark_vendor_view_title_temporary",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						view = "marks_vendor_view",
						view_function = "show_items",
						display_name = "loc_mark_vendor_view_title_temporary",
						input_legend_buttons = {
							{
								input_action = "hotkey_item_inspect",
								display_name = "loc_weapon_inventory_inspect_button",
								alignment = "right_alignment",
								on_pressed_callback = "cb_on_inspect_pressed",
								visibility_function = function (parent)
									local active_view = parent._active_view

									if active_view then
										local view_instance = Managers.ui:view_instance(active_view)
										local previewed_item = view_instance and view_instance._previewed_item

										if previewed_item then
											local item_type = previewed_item.item_type
											local ITEM_TYPES = UISettings.ITEM_TYPES

											if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.EMOTE then
												return true
											end
										end
									end

									return false
								end
							},
							{
								input_action = "hotkey_item_compare",
								display_name = "loc_item_toggle_equipped_compare",
								alignment = "right_alignment",
								on_pressed_callback = "cb_on_toggle_item_compare",
								visibility_function = function (parent)
									local active_view = parent._active_view

									if active_view then
										local view_instance = Managers.ui:view_instance(active_view)

										return view_instance and view_instance._previewed_item ~= nil
									end

									return false
								end
							}
						}
					}
				}
			}

			self:_setup_tab_bar(tab_bar_params)
		end
	},
	{
		blur_background = false,
		display_name = "loc_mark_vendor_view_title_standard",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						view = "marks_goods_vendor_view",
						view_function = "show_items",
						display_name = "loc_mark_vendor_view_title_standard"
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
