-- chunkname: @scripts/ui/views/crafting_view/crafting_view_definitions.lua

local CraftingSettings = require("scripts/settings/item/crafting_settings")
local CraftingMechanicusSettings = require("scripts/settings/item/crafting_mechanicus_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local InputDevice = require("scripts/managers/input/input_device")
local ItemUtils = require("scripts/utilities/items")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			150,
			570,
		},
		position = {
			0,
			-50,
			500,
		},
	},
	corner_top_right_no_wallet = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			150,
			570,
		},
		position = {
			0,
			-60,
			500,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			346,
			570,
		},
		position = {
			0,
			-60,
			500,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			350,
		},
		position = {
			0,
			0,
			500,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			350,
		},
		position = {
			0,
			0,
			500,
		},
	},
	wallet_pivot = {
		horizontal_alignment = "right",
		parent = "corner_top_right",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-120,
			128,
			1,
		},
	},
}
local widget_definitions = {
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "overlay",
			style = {
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "screen"),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/crafting_01_upper_left",
		},
	}, "corner_top_left"),
	corner_top_right_no_wallet = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/crafting_01_upper_left",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
	}, "corner_top_right_no_wallet", {
		visible = false,
	}),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/crafting_01_upper_right",
		},
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/crafting_01_lower",
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/effects/crafting_01_lower_candles",
			style = {
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/crafting_01_lower",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/effects/crafting_01_lower_candles",
			style = {
				offset = {
					0,
					0,
					1,
				},
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
	}, "corner_bottom_right"),
}
local input_legend_params = {}
local intro_texts = {
	description_text = "loc_crafting_view_intro_description",
	title_text = "loc_crafting_view_intro_title",
}
local button_options_definitions = {
	{
		display_name = "loc_crafting_view_option_modify",
		unlocalized_name = "Mechanicus Patch Crafting",
		callback = function (crafting_view)
			crafting_view:go_to_crafting_view("select_item_mechanicus")
		end,
	},
	{
		display_name = "loc_mastery_crafting_sacrifice_weapon_title",
		unlocalized_name = "Mechanicus Patch Sacrifice Weapon",
		callback = function (crafting_view)
			crafting_view:go_to_crafting_view("barter_items_mechanicus")
		end,
	},
}
local background_world_params = {
	level_name = "content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	register_camera_event = "event_register_crafting_view_camera",
	shading_environment = "content/shading_environments/ui/crafting_view",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_crafting_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_crafting_world",
}
local crafting_tab_params = {
	select_item_mechanicus = {
		crafting_level_story_event = "camera_recipe_enter_anim",
		hide_tabs = true,
		layer = 10,
		tabs_params = {
			{
				background_alpha = 175,
				display_name = "loc_crafting_modify_title",
				view = "crafting_mechanicus_modify_view",
				on_active_callback = function (parent)
					parent:show_wallets(true)
				end,
				input_legend_buttons = {
					{
						alignment = "right_alignment",
						display_name = "loc_inventory_add_favorite",
						input_action = "hotkey_item_favorite",
						on_pressed_callback = "cb_on_favorite_pressed",
						visibility_function = function (parent, id)
							local active_view = parent._active_view
							local view_instance = active_view and Managers.ui:view_instance(active_view)

							if not view_instance then
								return false
							end

							local widget = view_instance._item_grid and view_instance._item_grid:selected_grid_widget()
							local gear_id = widget and widget.content.element and widget.content.element.item and widget.content.element.item.gear_id

							if gear_id then
								local is_favorite = ItemUtils.is_item_id_favorited(gear_id)
								local display_name = is_favorite and "loc_inventory_remove_favorite" or "loc_inventory_add_favorite"

								parent._input_legend_element:set_display_name(id, display_name)

								return true
							end

							return false
						end,
					},
					{
						alignment = "right_alignment",
						display_name = "loc_weapon_inventory_inspect_button",
						input_action = "hotkey_item_inspect",
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
						end,
					},
					{
						alignment = "right_alignment",
						display_name = "loc_continue",
						input_action = "confirm_pressed",
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
						end,
					},
				},
			},
		},
	},
	barter_items_mechanicus = {
		crafting_level_story_event = "camera_recipe_enter_anim",
		hide_tabs = true,
		layer = 10,
		tabs_params = {
			{
				background_alpha = 175,
				display_name = "loc_crafting_barter_items_view",
				view = "crafting_mechanicus_barter_items_view",
				on_active_callback = function (parent)
					parent:show_wallets(false)
				end,
				input_legend_buttons = {
					{
						alignment = "right_alignment",
						display_name = "loc_inventory_add_favorite",
						input_action = "hotkey_item_favorite",
						on_pressed_callback = "cb_on_favorite_pressed",
						visibility_function = function (parent, id)
							local active_view = parent._active_view

							if not active_view then
								return false
							end

							local view_instance = Managers.ui:view_instance(active_view)

							if view_instance then
								if view_instance._ui_state ~= "select_weapon" then
									return false
								end

								local widget

								if view_instance._discard_items_element and view_instance._using_cursor_navigation then
									widget = view_instance._item_grid and view_instance._item_grid:hovered_widget()
								else
									widget = view_instance._item_grid and view_instance._item_grid:selected_grid_widget()
								end

								local gear_id = widget and widget.content.element and widget.content.element.item and widget.content.element.item.gear_id

								if gear_id then
									local is_favorite = ItemUtils.is_item_id_favorited(gear_id)
									local display_name = is_favorite and "loc_inventory_remove_favorite" or "loc_inventory_add_favorite"

									parent._input_legend_element:set_display_name(id, display_name)

									return true
								end
							end

							return false
						end,
					},
				},
			},
		},
	},
}
local used_settings = {
	CraftingSettings,
	CraftingMechanicusSettings,
}

for i = 1, #used_settings do
	local setting = used_settings[i]

	for i, recipe in pairs(setting.recipes_ui_order) do
		local view_name = recipe.view_name

		crafting_tab_params[view_name] = {
			crafting_level_story_event = "camera_weapon_selection_enter_anim",
			hide_tabs = true,
			layer = 10,
			tabs_params = {
				{
					on_active_callback = function (parent)
						parent:show_wallets(true)
					end,
					view = view_name,
					display_name = recipe.display_name,
				},
			},
		}

		if recipe.ui_show_in_vendor_view then
			button_options_definitions[#button_options_definitions + 1] = {
				display_name = recipe.display_name,
				disabled = not not recipe.ui_disabled,
				callback = function (crafting_view)
					crafting_view:go_to_crafting_view(recipe.view_name)
				end,
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
	crafting_tab_params = crafting_tab_params,
}
