-- chunkname: @scripts/ui/views/social_menu_notifications_view/social_menu_notifications_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local ViewStyles = require("scripts/ui/views/social_menu_notifications_view/social_menu_notifications_view_styles")
local scenegraph_styles = ViewStyles.scenegraph
local screen_size = UIWorkspaceSettings.screen.size
local top_panel_height = UIWorkspaceSettings.top_panel.size[2]
local bottom_panel_height = UIWorkspaceSettings.bottom_panel.size[2]
local visible_area_height = screen_size[2] - (top_panel_height + bottom_panel_height)
local grid_width = scenegraph_styles.grid_width
local grid_height = scenegraph_styles.grid_height
local mask_expansion = scenegraph_styles.grid_mask_expansion
local scenegraph = {}

scenegraph.screen = UIWorkspaceSettings.screen
scenegraph.visible_area = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		screen_size[1],
		visible_area_height
	},
	position = {
		0,
		top_panel_height,
		1
	}
}
scenegraph.button_bar = {
	vertical_alignment = "top",
	parent = "visible_area",
	horizontal_alignment = "center",
	size = {
		grid_width,
		scenegraph_styles.button_bar_height
	},
	position = scenegraph_styles.button_bar_position
}
scenegraph.grid = {
	vertical_alignment = "top",
	parent = "visible_area",
	horizontal_alignment = "center",
	size = {
		grid_width,
		grid_height
	},
	position = scenegraph_styles.grid_position
}
scenegraph.grid_content = {
	vertical_alignment = "top",
	parent = "grid",
	horizontal_alignment = "left",
	size = {
		grid_width,
		grid_height
	},
	position = {
		0,
		0,
		1
	}
}
scenegraph.grid_mask = {
	vertical_alignment = "top",
	parent = "grid",
	horizontal_alignment = "left",
	size = {
		grid_width + 2 * mask_expansion,
		grid_height + 2 * mask_expansion
	},
	position = {
		-mask_expansion,
		-mask_expansion,
		2
	}
}
scenegraph.scrollbar = {
	vertical_alignment = "top",
	parent = "grid",
	horizontal_alignment = "right",
	size = {
		scenegraph_styles.scrollbar_width,
		grid_height
	},
	position = scenegraph_styles.scrollbar_position
}

local widget_definitions = {
	clear_notifications_button = UIWidget.create_definition(ButtonPassTemplates.secondary_button, "button_bar", {
		text = Managers.localization:localize("loc_social_menu_notifications_clear_all_notifications")
	}, ViewStyles.button_bar.button_size)
}
local notification_blueprints = {
	invite_notification = {
		widget_definition = UIWidget.create_definition({
			{
				style_id = "hotspot_style",
				pass_type = "hotspot",
				content_id = "hotspot",
				change_function = function (content, style)
					local highlight_progress = content.anim_hover_progress and math.max(content.anim_select_progress, content.anim_hover_progress, content.anim_focus_progress) or 0

					content.parent.highlight_progress = highlight_progress
				end
			},
			{
				style_id = "background_selected",
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected_faded",
				change_function = function (content, style)
					style.color[1] = 255 * content.highlight_progress
				end,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
			},
			{
				style_id = "frame_highlight",
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected_edge",
				change_function = function (content, style)
					local progress = content.highlight_progress

					style.color[1] = 255 * math.easeOutCubic(progress)

					local size_addition = style.highlight_size_addition * math.easeInCubic(1 - progress)

					style.size_addition[2] = size_addition * 2
					style.offset[2] = -size_addition
					style.hdr = progress == 1
				end,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
			},
			{
				value = "content/ui/materials/icons/system/page_indicator_idle",
				style_id = "new_notification_marker",
				pass_type = "texture",
				visibility_function = function (content)
					return not content.data.is_read
				end
			},
			{
				style_id = "new_notification_ring",
				pass_type = "texture",
				value = "content/ui/materials/icons/system/page_indicator_active",
				change_function = function (content, style, animation, dt)
					local anim_time = style.anim_time
					local pause_time = style.pause_time or 0
					local total_time = anim_time + pause_time
					local progress_time = content.alert_anim_time or 0

					progress_time = math.fmod(progress_time + dt, total_time)
					content.alert_anim_time = progress_time

					local progress = progress_time <= anim_time and anim_time and progress_time / anim_time or 1
					local size_addition = math.sirp(-style.size[1], 0, progress)
					local style_size_additon = style.size_addition

					style_size_additon[1] = size_addition
					style_size_additon[2] = size_addition

					local default_offset = style.default_offset

					if not default_offset then
						default_offset = {
							style.offset[1],
							style.offset[2]
						}
						style.default_offset = default_offset
					end

					local extra_offset = size_addition / 2
					local style_offset = style.offset

					style_offset[1] = default_offset[1] - extra_offset
					style.color[1] = 255 * (1 - progress)
				end,
				visibility_function = function (content)
					return not content.data.is_read
				end
			},
			{
				value_id = "label",
				pass_type = "text",
				style_id = "label",
				change_function = ListHeaderPassTemplates.list_highlight_color_change_function
			},
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text"
			},
			{
				style_id = "age",
				value_id = "age_formatted",
				pass_type = "text"
			},
			{
				style_id = "join_hotspot",
				pass_type = "hotspot",
				content_id = "join_hotspot",
				visibility_function = function (content, style)
					local highlight_progress = content.parent.highlight_progress or 0

					return highlight_progress > 0
				end,
				change_function = function (content, style)
					local highlight_progress = content.anim_hover_progress and math.max(content.anim_hover_progress, content.anim_select_progress) or 0

					content.parent.join_highlight_progress = highlight_progress
				end
			},
			{
				style_id = "join_idle",
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected",
				visibility_function = ListHeaderPassTemplates.list_item_focused_visibility_function,
				change_function = function (content, style)
					local color = style.color
					local visibility_progress = content.highlight_progress

					color[1] = 255 * visibility_progress
				end
			},
			{
				style_id = "join_highlight",
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				change_function = function (content, style)
					local progress = content.join_highlight_progress

					style.color[1] = 255 * math.easeOutCubic(progress)

					local size_addition = style.highlight_size_addition * math.easeInCubic(1 - progress)
					local style_size_additon = style.size_addition

					style_size_additon[1] = size_addition * 2
					style.size_addition[2] = size_addition * 2

					local offset = style.offset
					local default_offset = style.default_offset

					offset[1] = default_offset[1] + size_addition
					style.hdr = progress == 1
				end,
				visibility_function = function (content, style)
					local hotspot = content.join_hotspot

					return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
				end
			},
			{
				style_id = "join_text",
				pass_type = "text",
				value_id = "join_text",
				change_function = function (content, style)
					local default_color = content.hotspot.disabled and style.disabled_color or style.default_color
					local text_color = style.text_color
					local visibility_progress = content.highlight_progress
					local hover_progress = content.join_highlight_progress

					text_color[1] = 255 * visibility_progress

					local ignore_alpha = true

					ColorUtilities.color_lerp(default_color, style.hover_color, hover_progress, text_color, ignore_alpha)

					style.material = hover_progress == 1 and "content/ui/materials/base/ui_slug_hdr" or nil
				end,
				visibility_function = ListHeaderPassTemplates.list_item_focused_visibility_function
			},
			{
				style_id = "remove_hotspot",
				pass_type = "hotspot",
				content_id = "remove_hotspot",
				visibility_function = function (content, style)
					local highlight_progress = content.parent.highlight_progress or 0

					return highlight_progress > 0
				end,
				change_function = function (content, style)
					local highlight_progress = content.anim_hover_progress and math.max(content.anim_hover_progress, content.anim_select_progress) or 0

					content.parent.remove_highlight_progress = highlight_progress
				end
			},
			{
				style_id = "remove_highlight",
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				change_function = function (content, style)
					local progress = content.remove_highlight_progress

					style.color[1] = 255 * math.easeOutCubic(progress)

					local size_addition = style.highlight_size_addition * math.easeInCubic(1 - progress)
					local style_size_additon = style.size_addition

					style_size_additon[1] = size_addition * 2
					style.size_addition[2] = size_addition * 2

					local offset = style.offset
					local default_offset = style.default_offset

					offset[1] = default_offset[1] + size_addition
					style.hdr = progress == 1
				end,
				visibility_function = function (content, style)
					local hotspot = content.remove_hotspot

					return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
				end
			},
			{
				style_id = "remove_text",
				pass_type = "text",
				value_id = "remove_text",
				change_function = function (content, style)
					local visibility_progress = content.highlight_progress
					local hover_progress = content.remove_highlight_progress
					local text_color = style.text_color

					text_color[1] = 255 * visibility_progress

					local ignore_alpha = true

					ColorUtilities.color_lerp(style.default_color, style.hover_color, hover_progress, style.text_color, ignore_alpha)

					style.material = hover_progress == 1 and "content/ui/materials/base/ui_slug_hdr" or nil
				end,
				visibility_function = ListHeaderPassTemplates.list_item_focused_visibility_function
			}
		}, "grid_content", nil, ViewStyles.invitation_notification_size, ViewStyles.invitation_notification),
		init = function (parent, widget, notification, type_settings, server_time)
			local widget_content = widget.content

			widget_content.join_highlight_progress = 0
			widget_content.remove_highlight_progress = 0
			widget_content.label = parent:_localize(type_settings.title)

			local string_params = {
				requesting_player = notification.requesting_player,
				guild_name = notification.clan
			}

			widget_content.text = parent:_localize(type_settings.description, true, string_params)
			widget_content.age = server_time - notification.time
			widget_content.formatted_age = widget_content.age .. " s ago"
			widget_content.data = notification
			widget_content.join_text = parent:_localize("loc_notification_invitation_join_button")
			widget_content.remove_hotspot.pressed_callback = callback(parent, "cb_remove_notification", notification)
			widget_content.remove_text = parent:_localize("loc_notification_remove_button")
		end
	}
}
local notification_types = {
	guild_invitation = {
		description = "loc_notification_guild_invitation",
		title = "loc_notification_guild_invitation_title",
		accept_function = "cb_accept_guild_invitation",
		blueprint = "invite_notification"
	},
	party_invitation = {
		description = "loc_notification_party_invitation",
		title = "loc_notification_party_invitation_title",
		accept_function = "cb_accept_party_invitation",
		blueprint = "invite_notification"
	}
}
local social_menu_notification_view_definitions = {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph,
	notification_blueprints = notification_blueprints,
	notification_types = notification_types
}

return settings("SocialMenuNotificationViewDefinitions", social_menu_notification_view_definitions)
