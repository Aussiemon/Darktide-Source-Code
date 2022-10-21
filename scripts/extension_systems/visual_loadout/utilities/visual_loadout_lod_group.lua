local VisualLoadoutLodGroup = {
	try_init_and_fetch_lod_group = function (unit, lod_group_name)
		local lod_group = Unit.has_lod_group(unit, lod_group_name) and Unit.lod_group(unit, lod_group_name)

		if lod_group then
			local bv = LODGroup.compile_time_bounding_volume(lod_group)

			if bv then
				LODGroup.override_bounding_volume(lod_group, bv)
			end
		end

		return lod_group
	end
}

return VisualLoadoutLodGroup
