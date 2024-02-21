local ChatManagerConstants = {
	ChannelTag = table.enum("HUB", "MISSION", "PARTY", "CLAN", "PRIVATE", "SYSTEM"),
	LoginState = table.enum("LOGGED_OUT", "LOGGED_IN", "LOGGING_IN", "LOGGING_OUT", "RESETTING", "ERROR"),
	ChannelConnectionState = table.enum("DISCONNECTED", "CONNECTED", "CONNECTING", "DISCONNECTING", "RINGING"),
	ConnectionState = table.enum("DISCONNECTED", "CONNECTED", "RECOVERING", "FAILED_TO_RECOVER", "RECOVERED")
}

return ChatManagerConstants
