-- chunkname: @scripts/extension_systems/talent/talent_system.lua

require("scripts/extension_systems/talent/player_unit_talent_extension")
require("scripts/extension_systems/talent/player_husk_talent_extension")

local TalentSystem = class("TalentSystem", "ExtensionSystemBase")

return TalentSystem
