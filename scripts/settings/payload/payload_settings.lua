-- chunkname: @scripts/settings/payload/payload_settings.lua

local payload_settings = {}

payload_settings.rotation_complete_treshold = 0.0872665
payload_settings.movement_types = table.enum("linear", "smooth")
payload_settings.states = table.enum("moving", "turning", "idle")
payload_settings.payload_speed_controllers = table.enum("proximity", "main_path", "flow", "max")

return settings("PayloadSettings", payload_settings)
