-- chunkname: @scripts/extension_systems/trigger/trigger_settings.lua

local trigger_settings = {}

trigger_settings.action_targets = table.enum("player_side", "entering_unit", "exiting_unit", "entering_and_exiting_unit", "units_in_volume", "none")
trigger_settings.machine_targets = table.enum("server", "client", "server_and_client")
trigger_settings.only_once = table.enum("none", "only_once_per_unit", "only_once_for_all_units")
trigger_settings.trigger_volume_name = "c_volume"

return settings("TriggerSettings", trigger_settings)
