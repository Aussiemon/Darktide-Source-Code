﻿-- chunkname: @scripts/settings/surface_material_settings.lua

local surface_material_settings = {}

surface_material_settings.hit_types = table.enum("stop", "penetration_entry", "penetration_exit")

return settings("SurfaceMaterialSettings", surface_material_settings)
