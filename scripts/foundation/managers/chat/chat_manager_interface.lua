﻿-- chunkname: @scripts/foundation/managers/chat/chat_manager_interface.lua

local Interface = {
	"initialize",
	"is_initialized",
	"is_connected",
	"is_mic_muted",
	"mute_local_mic",
	"login_state",
	"login",
	"is_logged_in",
	"join_chat_channel",
	"leave_channel",
	"send_channel_message",
	"send_loc_channel_message",
	"sessions",
	"connected_chat_channels",
	"connected_voip_channels",
	"channel_text_mute_participant",
	"channel_voip_mute_participant",
	"player_mute_status_changed",
	"mic_volume_changed",
	"get_capture_devices",
	"set_capture_device",
}

return Interface
