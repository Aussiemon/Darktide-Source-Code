local VisualLoadoutLodGroup = {
	try_init_and_fetch_lod_group = function (unit, lod_group_name)
		local lod_group = Unit.has_lod_group(unit, lod_group_name) and Unit.lod_group(unit, lod_group_name)

		if lod_group and Unit.has_mesh(unit, "b_culling_volume") then
			local bv_mesh = Unit.mesh(unit, "b_culling_volume")
			local bv = Mesh.bounding_volume(bv_mesh)

			LODGroup.override_bounding_volume(lod_group, bv)
		end

		return lod_group
	end
}

return VisualLoadoutLodGroup
