-- chunkname: @scripts/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local Archetypes = require("scripts/settings/archetype/archetypes")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	info_box = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			700,
			400
		},
		position = {
			180,
			375,
			1
		}
	},
	button_pivot = {
		vertical_alignment = "top",
		parent = "button_divider",
		horizontal_alignment = "left",
		size = {
			260,
			380
		},
		position = {
			0,
			25,
			1
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			540,
			224
		},
		position = {
			0,
			-65,
			55
		}
	},
	wallet_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-20,
			50,
			56
		}
	}
}
local widget_definitions = {
	corner_top_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/cosmetic_upper_right",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				offset = {
					0,
					-1,
					1
				}
			}
		}
	}, "corner_top_right"),
	button_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_left_01"
		}
	}, "button_divider", {
		visible = false
	})
}
local input_legend_params = {}
local intro_texts = {
	description_text = "loc_cosmetics_vendor_view_intro_description",
	title_text = "loc_cosmetics_vendor_view_intro_title"
}
local menu_zoom_out = "loc_inventory_menu_zoom_out"
local menu_zoom_in = "loc_inventory_menu_zoom_in"
local menu_preview_with_gear_off = "loc_inventory_menu_preview_with_gear_off"
local menu_preview_with_gear_on = "loc_inventory_menu_preview_with_gear_on"
local cosmetics_vendor_option_tab_definition = {
	view_function = "present_items",
	display_name = "loc_credits_vendor_view_title",
	blur_background = false,
	view = "cosmetics_vendor_view",
	context = {
		hide_price = true,
		disable_item_presentation = true,
		fetch_account_items = true,
		optional_store_service = "get_credits_cosmetics_store",
		fetch_store_items_on_enter = false,
		spawn_player = true,
		option_button_definitions = {
			{
				slot_name = "slot_gear_upperbody",
				icon = "content/ui/materials/icons/item_types/outfits",
				display_name = "loc_item_type_set",
				item_types = {
					"BUNDLE",
					"SET"
				}
			},
			{
				icon = "content/ui/materials/icons/item_types/headgears",
				display_name = ItemSlotSettings.slot_gear_head.display_name,
				slot_names = {
					"slot_gear_head"
				}
			},
			{
				icon = "content/ui/materials/icons/item_types/upper_bodies",
				display_name = ItemSlotSettings.slot_gear_upperbody.display_name,
				slot_names = {
					"slot_gear_upperbody"
				}
			},
			{
				icon = "content/ui/materials/icons/item_types/lower_bodies",
				display_name = ItemSlotSettings.slot_gear_lowerbody.display_name,
				slot_names = {
					"slot_gear_lowerbody"
				}
			},
			{
				icon = "content/ui/materials/icons/item_types/accessories",
				display_name = ItemSlotSettings.slot_gear_extra_cosmetic.display_name,
				slot_names = {
					"slot_gear_extra_cosmetic"
				}
			}
		},
		optional_sort_options = {
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_rarity")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"<",
					"item",
					ItemUtils.compare_item_rarity,
					"<",
					"offer",
					ItemUtils.compare_offer_price,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_rarity")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					">",
					"item",
					ItemUtils.compare_item_rarity,
					"<",
					"offer",
					ItemUtils.compare_offer_price,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_item_price")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					"<",
					"offer",
					ItemUtils.compare_offer_price,
					"<",
					"item",
					ItemUtils.compare_item_rarity,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_item_price")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					">",
					"offer",
					ItemUtils.compare_offer_price,
					"<",
					"item",
					ItemUtils.compare_item_rarity,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_increasing_letters", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_name")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"<",
					"item",
					ItemUtils.compare_item_name,
					"<",
					"item",
					ItemUtils.compare_item_rarity,
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					"<",
					"offer",
					ItemUtils.compare_offer_price
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_decreasing_letters", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_name")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					">",
					"item",
					ItemUtils.compare_item_name,
					"<",
					"item",
					ItemUtils.compare_item_rarity,
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					"<",
					"offer",
					ItemUtils.compare_offer_price
				})
			}
		}
	},
	input_legend_buttons = {
		{
			display_name = "loc_inventory_menu_zoom_in",
			input_action = "hotkey_menu_special_2",
			alignment = "right_alignment",
			on_pressed_callback = "cb_on_camera_zoom_toggled",
			visibility_function = function (parent, id)
				local active_view = parent._active_view

				if active_view then
					local view_instance = Managers.ui:view_instance(active_view)

					if view_instance:_can_zoom() then
						local display_name = view_instance._camera_zoomed_in and menu_zoom_out or menu_zoom_in
						local input_legend = parent:_element("input_legend")

						if input_legend then
							input_legend:set_display_name(id, display_name)
						end

						return view_instance._on_enter_animation_triggered
					end
				end

				return false
			end
		},
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

						if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.WEAPON_SKIN or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.EMOTE or item_type == ITEM_TYPES.SET then
							return view_instance._on_enter_animation_triggered
						end
					end
				end

				return false
			end
		},
		{
			input_action = "hotkey_menu_special_1",
			alignment = "right_alignment",
			gear_toggle_option = true,
			on_pressed_callback = "cb_on_preview_with_gear_toggled",
			display_name = menu_preview_with_gear_off,
			visibility_function = function (parent, id)
				local active_view = parent._active_view

				if active_view then
					local view_instance = Managers.ui:view_instance(active_view)
					local display_name = view_instance._previewed_with_gear and menu_preview_with_gear_off or menu_preview_with_gear_on

					parent._input_legend_element:set_display_name(id, display_name)

					return view_instance.can_preview_with_gear and view_instance._previewed_item
				end

				return false
			end
		}
	}
}
local weapon_cosmetics_vendor_option_tab_definition = {
	view_function = "present_items",
	display_name = "loc_credits_vendor_view_title",
	blur_background = false,
	view = "cosmetics_vendor_view",
	context = {
		hide_price = true,
		use_weapon_preview = true,
		optional_store_service = "get_credits_weapon_cosmetics_store",
		fetch_store_items_on_enter = false,
		optional_camera_breed_name = "human",
		option_button_definitions = {
			{
				icon = "content/ui/materials/icons/item_types/melee_weapons",
				display_name = ItemSlotSettings.slot_primary.display_name,
				slot_names = {
					"slot_primary"
				}
			},
			{
				icon = "content/ui/materials/icons/item_types/ranged_weapons",
				display_name = ItemSlotSettings.slot_secondary.display_name,
				slot_names = {
					"slot_secondary"
				}
			}
		},
		optional_sort_options = {
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_item_price")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					"<",
					"offer",
					ItemUtils.compare_offer_price,
					"<",
					"item",
					ItemUtils.compare_item_type,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_item_price")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					">",
					"offer",
					ItemUtils.compare_offer_price,
					"<",
					"item",
					ItemUtils.compare_item_type,
					"<",
					"item",
					ItemUtils.compare_item_name
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_increasing_letters", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_name")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					"<",
					"item",
					ItemUtils.compare_item_name,
					"<",
					"item",
					ItemUtils.compare_item_type,
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					"<",
					"offer",
					ItemUtils.compare_offer_price
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_format_decreasing_letters", true, {
					sort_name = Localize("loc_inventory_item_grid_sort_title_name")
				}),
				sort_function = ItemUtils.sort_element_key_comparator({
					">",
					"item",
					ItemUtils.compare_item_name,
					"<",
					"item",
					ItemUtils.compare_item_type,
					"false",
					"offer",
					ItemUtils.compare_offer_owned,
					"<",
					"offer",
					ItemUtils.compare_offer_price
				})
			}
		}
	},
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

						if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.WEAPON_SKIN or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.EMOTE or item_type == ITEM_TYPES.SET then
							return true
						end
					end
				end

				return false
			end
		}
	}
}
local cosmetic_gear_tabs = {}
local cosmetic_weapon_tabs = {}

for archetype_name, settings in pairs(Archetypes) do
	local cosmetics_vendor_option_tab = table.clone_instance(cosmetics_vendor_option_tab_definition)

	cosmetic_gear_tabs[#cosmetic_gear_tabs + 1] = cosmetics_vendor_option_tab
	cosmetics_vendor_option_tab.view_function_context = {
		archetype_name = archetype_name
	}
	cosmetics_vendor_option_tab.display_name = settings.archetype_name
	cosmetics_vendor_option_tab.ui_selection_order = settings.ui_selection_order

	local weapon_cosmetics_vendor_option_tab = table.clone_instance(weapon_cosmetics_vendor_option_tab_definition)

	cosmetic_weapon_tabs[#cosmetic_weapon_tabs + 1] = weapon_cosmetics_vendor_option_tab
	weapon_cosmetics_vendor_option_tab.view_function_context = {
		archetype_name = archetype_name
	}
	weapon_cosmetics_vendor_option_tab.display_name = settings.archetype_name
	weapon_cosmetics_vendor_option_tab.ui_selection_order = settings.ui_selection_order
end

table.sort(cosmetic_gear_tabs, function (a, b)
	return a.ui_selection_order < b.ui_selection_order
end)
table.sort(cosmetic_weapon_tabs, function (a, b)
	return a.ui_selection_order < b.ui_selection_order
end)

local index_by_archetype_name = {}

for i = 1, #cosmetic_gear_tabs do
	index_by_archetype_name[cosmetic_gear_tabs[i].view_function_context.archetype_name] = i
end

local cosmetics_vendor_option_definition = {
	icon = "content/ui/materials/backgrounds/cosmetics_vendor/character_cosmetics",
	display_name = "loc_credits_vendor_view_option_buy_character_cosmetics",
	callback = function (self)
		local tab_bar_params = {
			hide_tabs = false,
			layer = 10,
			tabs_params = cosmetic_gear_tabs,
			visibility_function = function (background_view)
				local active_view_instance = background_view._active_view_instance

				if active_view_instance then
					local view_name = "cosmetics_vendor_view"
					local view_data = Managers.ui:view_active_data(view_name)

					if view_data then
						return not view_data.fade_in
					end
				end

				return false
			end
		}
		local player = self:_player()
		local profile = player and player:profile()
		local archetype_name = profile and profile.archetype.name or "veteran"
		local start_index = index_by_archetype_name[archetype_name] or 1

		self:_setup_tab_bar(tab_bar_params, nil, start_index)
	end
}
local weapon_cosmetics_vendor_option_definition = {
	icon = "content/ui/materials/backgrounds/cosmetics_vendor/weapon_cosmetics",
	display_name = "loc_credits_vendor_view_option_buy_weapon_cosmetics",
	callback = function (self)
		local tab_bar_params = {
			hide_tabs = false,
			layer = 10,
			tabs_params = cosmetic_weapon_tabs,
			visibility_function = function (background_view)
				local active_view_instance = background_view._active_view_instance

				if active_view_instance then
					local view_name = "cosmetics_vendor_view"
					local view_data = Managers.ui:view_active_data(view_name)

					if view_data then
						return not view_data.fade_in
					end
				end

				return false
			end
		}
		local player = self:_player()
		local profile = player and player:profile()
		local archetype_name = profile and profile.archetype.name or "veteran"
		local start_index = index_by_archetype_name[archetype_name] or 1

		self:_setup_tab_bar(tab_bar_params, nil, start_index)
	end
}
local button_options_definitions = {
	cosmetics_vendor_option_definition,
	weapon_cosmetics_vendor_option_definition
}
local background_world_params = {
	shading_environment = "content/shading_environments/ui/credits_cosmetics_vendor",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_credits_vendor_camera",
	viewport_name = "ui_credits_cosmetics_vendor_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/credits_cosmetics_vendor/credits_cosmetics_vendor",
	world_name = "ui_credits_cosmetics_vendor_world",
	animations_per_archetype = {
		psyker = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		},
		veteran = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		},
		zealot = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		},
		ogryn = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		}
	}
}
local animations = {
	on_option_exit = {
		{
			name = "fade_in",
			end_time = 0.6,
			start_time = 0.3,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_blur_fade_out(0.3, math.easeCubic)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(progress)
				local alpha_multiplier = anim_progress

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = alpha_multiplier
				end

				local canvas_overlay = parent._widgets_by_name.canvas_overlay

				canvas_overlay.alpha_multiplier = math.min(1 - alpha_multiplier, canvas_overlay.alpha_multiplier or 0)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	}
}
local internal_button_size = {
	20,
	20
}
local option_button_settings = {
	spacing = 30,
	grow_vertically = false,
	button_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_pressed_sound = UISoundEvents.default_click,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_select_sound = UISoundEvents.default_mouse_hover
			}
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					-internal_button_size[1],
					-internal_button_size[2]
				},
				color = Color.terminal_frame(nil, true),
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				offset = {
					0,
					0,
					12
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					-internal_button_size[1],
					-internal_button_size[2]
				},
				color = Color.terminal_corner(nil, true),
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					13
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "button_gradient",
			value = "content/ui/materials/frames/inner_shadow_medium",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					-internal_button_size[1],
					-internal_button_size[2]
				},
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					0,
					0,
					8
				}
			},
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_change_function(content, style)

				local hotspot = content.hotspot
				local anim_hover_progress = hotspot.anim_hover_progress
				local anim_select_progress = hotspot.anim_select_progress
				local anim_focus_progress = hotspot.anim_focus_progress
				local default_alpha = 0
				local hover_alpha = anim_hover_progress * 255
				local select_alpha = math.max(anim_select_progress, anim_focus_progress) * 255

				style.color[1] = math.clamp(default_alpha + select_alpha + hover_alpha, 0, 255)
			end
		},
		{
			pass_type = "texture_uv",
			style_id = "icon",
			value_id = "icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					6
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				size_addition = {
					-internal_button_size[1],
					-internal_button_size[2]
				},
				material_values = {
					shine = 0
				}
			},
			visibility_function = function (content, style)
				return true
			end,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
				local min_uv = 0.9
				local max_uv = 0.95
				local start_uv = 0
				local end_uv = 1
				local current_uv = (max_uv - min_uv) * progress * 0.5

				style.uvs[1][1] = start_uv + current_uv
				style.uvs[1][2] = start_uv + current_uv
				style.uvs[2][1] = end_uv - current_uv
				style.uvs[2][2] = end_uv - current_uv
			end
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					30,
					24
				},
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_background_gradient(100, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = UIFontSettings.list_button.disabled_color,
				offset = {
					0,
					0,
					1
				},
				size_addition = {
					6,
					0
				}
			},
			change_function = function (content, style)
				return
			end
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					internal_button_size[1],
					internal_button_size[2]
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/cosmetics_vendor/card_upper",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				scale_to_material = true,
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.gray(255, true),
				color = Color.terminal_text_header(255, true),
				hover_color = Color.terminal_text_header_selected(255, true),
				size = {
					nil,
					16
				},
				offset = {
					0,
					-7,
					10
				},
				size_addition = {
					14,
					0
				}
			},
			change_function = ButtonPassTemplates.list_button_label_change_function
		},
		{
			value = "content/ui/materials/frames/cosmetics_vendor/card_lower",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				scale_to_material = true,
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.gray(255, true),
				color = Color.terminal_text_header(255, true),
				hover_color = Color.terminal_text_header_selected(255, true),
				size = {
					nil,
					16
				},
				offset = {
					0,
					7,
					10
				},
				size_addition = {
					14,
					0
				}
			},
			change_function = ButtonPassTemplates.list_button_label_change_function
		},
		{
			value = "content/ui/materials/backgrounds/bottom_fade",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					140
				},
				size_addition = {
					-20,
					0
				},
				color = Color.black(255, true),
				offset = {
					0,
					-10,
					7
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = {
				text_horizontal_alignment = "center",
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				text_vertical_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				hover_color = Color.terminal_text_header_selected(255, true),
				default_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					9
				},
				size = {
					nil,
					90
				},
				size_addition = {
					-40,
					0
				}
			},
			value = Localize("loc_credits_goods_vendor_title_text"),
			change_function = ButtonPassTemplates.list_button_label_change_function
		},
		{
			value = "content/ui/materials/dividers/skull_center_06",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				color = Color.terminal_corner(nil, true),
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					-15,
					9
				},
				size = {
					70,
					20
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		}
	}
}

return {
	option_button_settings = option_button_settings,
	animations = animations,
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params
}
