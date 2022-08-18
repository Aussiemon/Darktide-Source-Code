local MaterialQuery = require("scripts/utilities/material_query")
local surface_material_settings = {
	surface_types = table.enum(unpack(MaterialQuery.surface_materials)),
	hit_types = table.enum("stop", "penetration_entry", "penetration_exit")
}

return settings("SurfaceMaterialSettings", surface_material_settings)
