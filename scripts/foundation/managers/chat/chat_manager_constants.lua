local ChatManagerConstants = {
	ChannelTag = table.enum("HUB", "MISSION", "PARTY", "CLAN", "PRIVATE"),
	LoginState = table.enum("LOGGED_OUT", "LOGGED_OUT", "LOGGED_IN", "LOGGING_IN", "LOGGING_OUT", "RESETTING", "ERROR"),
	ChannelConnectionState = table.enum("DISCONNECTED", "CONNECTED", "CONNECTING", "DISCONNECTING", "RINGING")
}

return ChatManagerConstants
