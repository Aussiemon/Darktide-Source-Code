local CraftingSettings = require("scripts/settings/item/crafting_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local InputDevice = require("scripts/managers/input/input_device")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			150,
			570
		},
		position = {
			0,
			-50,
			500
		}
	},
	corner_top_right_no_wallet = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			150,
			570
		},
		position = {
			0,
			-60,
			500
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			346,
			570
		},
		position = {
			0,
			-60,
			500
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			180,
			350
		},
		position = {
			0,
			0,
			500
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			180,
			350
		},
		position = {
			0,
			0,
			500
		}
	},
	wallet_pivot = {
		vertical_alignment = "top",
		parent = "corner_top_right",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-120,
			128,
			1
		}
	}
}
local widget_definitions = {
	overlay = UIWidget.create_definition({
		{
			style_id = "overlay",
			pass_type = "rect",
			style = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "screen"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/crafting_01_upper_left"
		}
	}, "corner_top_left"),
	corner_top_right_no_wallet = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/crafting_01_upper_left",
			pass_type = "texture_uv",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		}
	}, "corner_top_right_no_wallet", {
		visible = false
	}),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/crafting_01_upper_right"
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/crafting_01_lower"
		},
		{
			value = "content/ui/materials/effects/crafting_01_lower_candles",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/crafting_01_lower",
			pass_type = "texture_uv",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		{
			value = "content/ui/materials/effects/crafting_01_lower_candles",
			pass_type = "texture_uv",
			style = {
				offset = {
					0,
					0,
					1
				},
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		}
	}, "corner_bottom_right")
}
local input_legend_params = {}
local intro_texts = {
	description_text = "loc_crafting_view_intro_description",
	title_text = "loc_crafting_view_intro_title"
}
local button_options_definitions = {
	{
		display_name = "loc_crafting_view_option_modify",
		callback = function (crafting_view)
			crafting_view:go_to_crafting_view("select_item")
		end
	}
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/crafting_view",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_crafting_view_camera",
	viewport_name = "ui_crafting_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/crafting_view/crafting_view",
	world_name = "ui_crafting_world"
}
local crafting_tab_params = {
	select_item = {
		hide_tabs = true,
		layer = 10,
		tabs_params = {
			{
				background_alpha = 175,
				display_name = "loc_crafting_modify_title",
				view = "crafting_modify_view",
				on_active_callback = function (parent)
					parent:show_wallets(true)
				end,
				input_legend_buttons = {
					{
						input_action = "hotkey_item_inspect",
						display_name = "loc_weapon_inventory_inspect_button",
						alignment = "right_alignment",
						on_pressed_callback = "cb_on_inspect_pressed",
						visibility_function = function (parent)
							local active_view = parent._active_view

							if not active_view then
								return false
							end

							local view_instance = Managers.ui:view_instance(active_view)
							local previewed_item = view_instance and view_instance._previewed_item

							if not previewed_item then
								return false
							end

							local item_type = previewed_item.item_type

							return item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"
						end
					},
					{
						input_action = "confirm_pressed",
						display_name = "loc_continue",
						alignment = "right_alignment",
						visibility_function = function (parent)
							local active_view = parent._active_view

							if not active_view then
								return false
							end

							local view_instance = Managers.ui:view_instance(active_view)
							local previewed_item = view_instance and view_instance._previewed_item

							if not previewed_item then
								return false
							end

							return InputDevice.gamepad_active
						end
					}
				}
			}
		}
	}
}
local used_settings = {
	CraftingSettings
}

for i = 1, #used_settings do
	local setting = used_settings[i]

	for i, recipe in pairs(setting.recipes_ui_order) do
		local view_name = recipe.view_name
		crafting_tab_params[view_name] = {
			hide_tabs = true,
			layer = 10,
			tabs_params = {
				{
					on_active_callback = function (parent)
						parent:show_wallets(true)
					end,
					view = view_name,
					display_name = recipe.display_name
				}
			}
		}

		if recipe.ui_show_in_vendor_view then
			button_options_definitions[#button_options_definitions + 1] = {
				display_name = recipe.display_name,
				disabled = not not recipe.ui_disabled,
				callback = function (crafting_view)
					crafting_view:go_to_crafting_view(recipe.view_name)
				end
			}
		end
	end
end

return {
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
	crafting_tab_params = crafting_tab_params
}
