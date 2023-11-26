-- chunkname: @scripts/foundation/managers/chat/chat_manager_constants.lua

local ChatManagerConstants = {}

ChatManagerConstants.ChannelTag = table.enum("HUB", "MISSION", "PARTY", "CLAN", "PRIVATE")
ChatManagerConstants.LoginState = table.enum("LOGGED_OUT", "LOGGED_IN", "LOGGING_IN", "LOGGING_OUT", "RESETTING", "ERROR")
ChatManagerConstants.ChannelConnectionState = table.enum("DISCONNECTED", "CONNECTED", "CONNECTING", "DISCONNECTING", "RINGING")
ChatManagerConstants.ConnectionState = table.enum("DISCONNECTED", "CONNECTED", "RECOVERING", "FAILED_TO_RECOVER", "RECOVERED")

return ChatManagerConstants
