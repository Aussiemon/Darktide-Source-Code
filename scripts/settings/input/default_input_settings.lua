-- chunkname: @scripts/settings/input/default_input_settings.lua

local DefaultInputSettings = {}

table.insert(DefaultInputSettings, require("scripts/settings/input/default_debug_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_free_flight_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_ingame_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_imgui_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_view_input_settings"))

return DefaultInputSettings
