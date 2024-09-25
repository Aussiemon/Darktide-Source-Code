-- chunkname: @scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view_definitions.lua

local ItemUtils = require("scripts/utilities/items")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			540,
			224,
		},
		position = {
			0,
			-65,
			55,
		},
	},
	wallet_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-20,
			50,
			56,
		},
	},
}
local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/armoury_01_lower",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/armoury_02_lower",
		},
	}, "corner_bottom_right"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/frames/screen/armoury_upper_right",
			style = {
				offset = {
					0,
					-2,
					1,
				},
			},
		},
	}, "corner_top_right"),
}
local input_legend_params = {}
local intro_texts = {
	description_text = "loc_credits_vendor_view_intro_description",
	title_text = "loc_credits_vendor_view_intro_title",
}
local button_options_definitions = {
	{
		display_name = "loc_credits_vendor_view_option_buy",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						blur_background = false,
						display_name = "loc_credits_vendor_view_title",
						view = "credits_vendor_view",
						context = {
							use_item_categories = true,
						},
						input_legend_buttons = {
							{
								alignment = "right_alignment",
								display_name = "loc_weapon_inventory_inspect_button",
								input_action = "hotkey_item_inspect",
								on_pressed_callback = "cb_on_inspect_pressed",
								visibility_function = function (parent)
									local active_view = parent._active_view

									if active_view then
										local view_instance = Managers.ui:view_instance(active_view)
										local previewed_item = view_instance and view_instance._previewed_item

										if previewed_item then
											local item_type = previewed_item.item_type
											local ITEM_TYPES = UISettings.ITEM_TYPES

											if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.WEAPON_SKIN or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.EMOTE then
												return true
											end
										end
									end

									return false
								end,
							},
							{
								alignment = "right_alignment",
								display_name = "loc_item_toggle_equipped_compare",
								input_action = "hotkey_item_compare",
								on_pressed_callback = "cb_on_toggle_item_compare",
								visibility_function = function (parent)
									local active_view = parent._active_view

									if active_view then
										local view_instance = Managers.ui:view_instance(active_view)

										return view_instance and view_instance._previewed_item ~= nil
									end

									return false
								end,
							},
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params, {
				fetch_store_items_on_enter = true,
				hide_price = true,
			})
		end,
	},
	{
		display_name = "loc_credits_goods_vendor_title_text",
		callback = function (self)
			local tab_bar_params = {
				hide_tabs = true,
				layer = 10,
				tabs_params = {
					{
						blur_background = false,
						display_name = "loc_credits_goods_vendor_view_title",
						view = "credits_goods_vendor_view",
						context = {
							use_item_categories = true,
						},
					},
				},
			}

			self:_setup_tab_bar(tab_bar_params, {
				fetch_store_items_on_enter = true,
			})
		end,
	},
}
local background_world_params = {
	level_name = "content/levels/ui/credits_vendor/credits_vendor",
	register_camera_event = "event_register_credits_vendor_camera",
	shading_environment = "content/shading_environments/ui/credits_vendor",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_credits_vendor_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_credits_vendor_world",
}

return {
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
}
