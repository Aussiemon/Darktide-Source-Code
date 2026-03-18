-- chunkname: @scripts/extension_systems/visual_loadout/utilities/visual_loadout_extract_data.lua

local VisualLoadoutExtractData = {}

VisualLoadoutExtractData.ROOT_ATTACH_NAME = ""

VisualLoadoutExtractData.create = function (map_attachment_units, map_bind_poses, map_item_names)
	local extract_data = {
		parents = {},
		attachment_units_by_unit = {},
		item_name_by_unit = map_item_names and {} or nil,
		bind_poses_by_unit = map_bind_poses and {} or nil,
		attachment_id_lookup = map_attachment_units and {} or nil,
		attachment_name_lookup = map_attachment_units and {} or nil,
	}

	return extract_data
end

VisualLoadoutExtractData.push = function (extract_data, item_unit, item_name, attachment_key_or_nil)
	if extract_data.attachment_id_lookup then
		local parent_id = extract_data.attachment_id_lookup[extract_data.parents[#extract_data.parents]]
		local unique_id

		if not parent_id then
			unique_id = VisualLoadoutExtractData.ROOT_ATTACH_NAME
		elseif parent_id == VisualLoadoutExtractData.ROOT_ATTACH_NAME then
			unique_id = attachment_key_or_nil
		else
			unique_id = string.format("%s.%s", parent_id, attachment_key_or_nil)
		end

		extract_data.attachment_id_lookup[item_unit] = unique_id
		extract_data.attachment_id_lookup[unique_id] = item_unit
	end

	extract_data.parents[#extract_data.parents + 1] = item_unit
	extract_data.attachment_units_by_unit[item_unit] = {}

	if extract_data.item_name_by_unit then
		extract_data.item_name_by_unit[item_unit] = item_name
	end

	if extract_data.attachment_name_lookup then
		extract_data.attachment_name_lookup[item_unit] = {}
	end

	if extract_data.bind_poses_by_unit then
		extract_data.bind_poses_by_unit[item_unit] = {}
	end
end

VisualLoadoutExtractData.pop = function (extract_data, expected_parent)
	extract_data.parents[#extract_data.parents] = nil
end

VisualLoadoutExtractData.fill = function (extract_data, attachment_name, attachment_unit, bind_pose)
	local parents = extract_data.parents
	local attachment_units_by_unit = extract_data.attachment_units_by_unit
	local attachment_name_lookup = extract_data.attachment_name_lookup
	local bind_poses_by_unit = extract_data.bind_poses_by_unit
	local bind_pose_boxed = Matrix4x4Box(bind_pose)

	for ii = 1, #parents do
		local parent_unit = parents[ii]

		attachment_units_by_unit[parent_unit][#attachment_units_by_unit[parent_unit] + 1] = attachment_unit

		if attachment_name_lookup then
			local attachments = attachment_name_lookup[parent_unit]

			if not attachments[attachment_name] then
				attachments[attachment_name] = attachment_unit
				attachments[attachment_unit] = attachment_name
			end
		end

		if bind_poses_by_unit then
			local bind_poses = bind_poses_by_unit[parent_unit]

			bind_poses[attachment_unit] = bind_pose_boxed
		end
	end
end

return VisualLoadoutExtractData
