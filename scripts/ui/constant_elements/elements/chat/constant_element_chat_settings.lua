-- chunkname: @scripts/ui/constant_elements/elements/chat/constant_element_chat_settings.lua

require("scripts/foundation/utilities/color")

local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local chat_window_size = {
	500,
	250,
}
local input_field_height = 40
local chat_window_offset = {
	50,
	-490,
	0,
}
local vertical_alignment = "bottom"
local horizontal_alignment = "left"
local background_color = {
	128,
	0,
	0,
	0,
}
local window_margins = {
	20,
	20,
	20,
	20,
}
local scrollbar_margins = {
	0,
	15,
	10,
	15,
}
local input_field_margins = {
	10,
	11,
	20,
	11,
}
local scrollbar_width = 8
local message_spacing = 15
local input_field_crop_margin = 30
local direct_message_color = {
	255,
	150,
	203,
	234,
}
local local_message_color = {
	255,
	96,
	168,
	153,
}
local mission_channel_color = Color.ui_brown_super_light(255, true)
local clan_channel_color = {
	255,
	191,
	107,
	120,
}
local hub_channel_color = {
	255,
	218,
	204,
	130,
}
local selected_text_color = {
	200,
	255,
	0,
	255,
}
local message_color = Color.ui_brown_super_light(255, true)
local input_field_idle_color = Color.black(0, true)
local input_field_active_color = Color.black(255, true)
local input_text_idle_color = {
	255,
	102,
	102,
	102,
}
local input_text_active_color = Color.ui_brown_super_light(255, true)
local insertion_caret_color = Color.ui_brown_super_light(255, true)
local insertion_caret_size = {
	2,
	input_field_height - (input_field_margins[2] + input_field_margins[4]),
}
local slug_formatted_message_color = message_color[2] .. "," .. message_color[3] .. "," .. message_color[4]
local message_presentation_format = "{#color([channel_color],255);}[author_name]:  {# color(" .. slug_formatted_message_color .. ",255)}[message_text]{#reset()}"
local no_leading_space_languages = table.enum("ja", "ko", "zh-cn", "zh-tw")
local idle_timeout = 0
local inactivity_timeout = 5
local fade_time = 0.15
local placeholder_fade_time = 0.1
local inactive_fade_speed = 0.15
local idle_text_alpha = 255
local idle_background_alpha = 0
local history_limit = 500
local message_limit_in_characters = 200
local close_on_backspace = false
local ChannelTags = ChatManagerConstants.ChannelTag
local channel_metadata = {}

channel_metadata[ChannelTags.PARTY] = {
	name = "loc_chat_channel_mission",
	color = mission_channel_color,
}
channel_metadata[ChannelTags.MISSION] = {
	name = "loc_chat_channel_mission",
	color = mission_channel_color,
}
channel_metadata[ChannelTags.HUB] = {
	name = "loc_chat_channel_hub",
	color = hub_channel_color,
}
channel_metadata[ChannelTags.CLAN] = {
	name = nil,
	color = clan_channel_color,
}
channel_metadata[ChannelTags.PRIVATE] = {
	name = nil,
	color = clan_channel_color,
}
channel_metadata[ChannelTags.SYSTEM] = {
	always_notify = true,
	name = "loc_chat_channel_system",
	color = Color.ui_orange_medium(255, true),
}
channel_metadata.placeholder = {
	name = nil,
	color = Color.magenta(255, true),
}

local channel_priority = {
	[ChannelTags.MISSION] = 1,
	[ChannelTags.PARTY] = 2,
	[ChannelTags.HUB] = 3,
	[ChannelTags.CLAN] = 4,
	[ChannelTags.PRIVATE] = 5,
	[ChannelTags.SYSTEM] = 6,
}
local max_message_length = 256
local constant_element_chat_settings = {
	chat_window_size = chat_window_size,
	chat_window_offset = chat_window_offset,
	background_color = background_color,
	vertical_alignment = vertical_alignment,
	horizontal_alignment = horizontal_alignment,
	window_margins = window_margins,
	scrollbar_margins = scrollbar_margins,
	input_field_margins = input_field_margins,
	scrollbar_width = scrollbar_width,
	message_spacing = message_spacing,
	no_leading_space_languages = no_leading_space_languages,
	direct_message_color = direct_message_color,
	local_message_color = local_message_color,
	mission_channel_color = mission_channel_color,
	clan_channel_color = clan_channel_color,
	hub_channel_color = hub_channel_color,
	input_field_height = input_field_height,
	input_field_crop_margin = input_field_crop_margin,
	input_field_idle_color = input_field_idle_color,
	input_field_active_color = input_field_active_color,
	input_text_idle_color = input_text_idle_color,
	input_text_active_color = input_text_active_color,
	selected_text_color = selected_text_color,
	insertion_caret_color = insertion_caret_color,
	insertion_caret_size = insertion_caret_size,
	idle_timeout = idle_timeout,
	inactivity_timeout = inactivity_timeout,
	fade_time = fade_time,
	placeholder_fade_time = placeholder_fade_time,
	inactive_fade_speed = inactive_fade_speed,
	idle_text_alpha = idle_text_alpha,
	idle_background_alpha = idle_background_alpha,
	history_limit = history_limit,
	message_limit_in_characters = message_limit_in_characters,
	close_on_backspace = close_on_backspace,
	message_presentation_format = message_presentation_format,
	channel_metadata = channel_metadata,
	channel_priority = channel_priority,
	max_message_length = max_message_length,
}

return settings("ConstantElementChatSettings", constant_element_chat_settings)
