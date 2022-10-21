local ItemMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/item_material_overrides")
local VisualLoadoutCustomization = {}
local _attach_hierarchy, _attach_hierarchy_children, _spawn_attachment = nil
local _sort_order_enum = {
	FACE_SCAR = 1,
	FACE_HAIR = 2,
	HAIR = 3
}

VisualLoadoutCustomization.apply_material_override = function (unit, parent_unit, apply_to_parent, material_override, in_editor)
	if material_override and material_override ~= "" then
		local material_override_data = nil

		if in_editor then
			material_override_data = rawget(ItemMaterialOverrides, material_override)

			if material_override_data == nil then
				Log.info("VisualLoadoutCustomization", "Material override %s does not exist.", material_override)
			end
		else
			material_override_data = ItemMaterialOverrides[material_override]
		end

		if material_override_data then
			if apply_to_parent then
				VisualLoadoutCustomization._apply_material_override(parent_unit, material_override_data)
			else
				VisualLoadoutCustomization._apply_material_override(unit, material_override_data)
			end
		end
	end
end

VisualLoadoutCustomization._apply_material_override = function (unit, material_override_data)
	if material_override_data.property_overrides ~= nil then
		for property_name, property_override_data in pairs(material_override_data.property_overrides) do
			if property_override_data ~= nil then
				if type(property_override_data) == "number" then
					Unit.set_scalar_for_materials(unit, property_name, property_override_data, true)
				elseif #property_override_data == 1 then
					Unit.set_scalar_for_materials(unit, property_name, property_override_data[1], true)
				elseif #property_override_data == 2 then
					Unit.set_vector2_for_materials(unit, property_name, Vector2(property_override_data[1], property_override_data[2]), true)
				elseif #property_override_data == 3 then
					Unit.set_vector3_for_materials(unit, property_name, Vector3(property_override_data[1], property_override_data[2], property_override_data[3]), true)
				elseif #property_override_data == 4 then
					Unit.set_vector4_for_materials(unit, property_name, Color(property_override_data[1], property_override_data[2], property_override_data[3], property_override_data[4]), true)
				end
			end
		end
	end

	if material_override_data.texture_overrides ~= nil then
		for texture_slot, texture_override_data in pairs(material_override_data.texture_overrides) do
			if texture_override_data ~= nil then
				Unit.set_texture_for_materials(unit, texture_slot, texture_override_data.resource, true)
			end
		end
	end
end

VisualLoadoutCustomization.spawn_item = function (item_data, attach_settings, parent_unit, optional_extract_attachment_units_bind_poses, optional_mission_template)
	local weapon_skin = item_data.slot_weapon_skin

	if type(weapon_skin) == "string" and weapon_skin ~= "" then
		if attach_settings.in_editor then
			if attach_settings.item_manager and ToolsMasterItems then
				weapon_skin = ToolsMasterItems:get(weapon_skin)
			else
				weapon_skin = rawget(attach_settings.item_definitions, weapon_skin)
			end
		else
			weapon_skin = attach_settings.item_definitions[weapon_skin]
		end
	end

	if weapon_skin and weapon_skin ~= "" then
		table.append(item_data.material_overrides, weapon_skin.material_overrides)
	end

	local item_unit, bind_pose = VisualLoadoutCustomization.spawn_base_unit(item_data, attach_settings, parent_unit, optional_mission_template)
	local attachment_units, attachment_units_bind_poses = VisualLoadoutCustomization.spawn_item_attachments(item_data, attach_settings, item_unit, optional_extract_attachment_units_bind_poses, optional_mission_template)

	VisualLoadoutCustomization.apply_material_overrides(item_data, item_unit, parent_unit, attach_settings)
	VisualLoadoutCustomization.add_extensions(item_unit, attachment_units, attach_settings)
	VisualLoadoutCustomization.play_item_on_spawn_anim_event(item_data, parent_unit)

	return item_unit, attachment_units, bind_pose, attachment_units_bind_poses
end

VisualLoadoutCustomization.spawn_base_unit = function (item_data, attach_settings, parent_unit, optional_mission_template)
	return _spawn_attachment(item_data, attach_settings, parent_unit, optional_mission_template)
end

VisualLoadoutCustomization.spawn_item_attachments = function (item_data, attach_settings, item_unit, optional_extract_attachment_units_bind_poses, optional_mission_template)
	local attachment_units, attachment_units_bind_poses = nil
	local attachments = item_data.attachments

	if item_unit and attachments then
		attachment_units_bind_poses = optional_extract_attachment_units_bind_poses and {} or nil
		attachment_units = {}

		for _, attachment_slot_data in pairs(attachments) do
			attachment_units, attachment_units_bind_poses = _attach_hierarchy(attachment_slot_data, attach_settings, item_unit, attachment_units, attachment_units_bind_poses, optional_mission_template)
		end
	end

	return attachment_units, attachment_units_bind_poses
end

VisualLoadoutCustomization.apply_material_overrides = function (item_data, item_unit, parent_unit, attach_settings)
	local material_overrides = item_data.material_overrides
	local apply_to_parent = item_data.material_override_apply_to_parent

	if item_unit and material_overrides then
		for _, material_override in pairs(material_overrides) do
			VisualLoadoutCustomization.apply_material_override(item_unit, parent_unit, apply_to_parent, material_override, attach_settings.in_editor)
		end
	end
end

local temp_units = {}

VisualLoadoutCustomization.add_extensions = function (item_unit_or_nil, attachment_units_or_nil, attach_settings)
	if attach_settings.spawn_with_extensions then
		local world = attach_settings.world
		local extension_manager = attach_settings.extension_manager

		assert(extension_manager, "Need to supply extension manager if \"spawn_with_extensions\" is true.")

		if item_unit_or_nil then
			temp_units[1] = item_unit_or_nil

			extension_manager:add_and_register_units(world, temp_units, 1)
		end

		if attachment_units_or_nil then
			extension_manager:add_and_register_units(world, attachment_units_or_nil)
		end
	end
end

VisualLoadoutCustomization.play_item_on_spawn_anim_event = function (item_data, parent_unit)
	local event_in_parent_state_machine = item_data.event_in_parent_state_machine

	if event_in_parent_state_machine and event_in_parent_state_machine ~= "" and Unit.has_animation_state_machine(parent_unit) and Unit.has_animation_event(parent_unit, event_in_parent_state_machine) then
		Unit.animation_event(parent_unit, event_in_parent_state_machine)
	end
end

VisualLoadoutCustomization.attach_hierarchy = function (attachment_slot_data, settings, parent_unit, attached_units, attached_units_bind_poses_or_nil)
	return _attach_hierarchy(attachment_slot_data, settings, parent_unit, attached_units, attached_units_bind_poses_or_nil)
end

function _spawn_attachment(item_data, settings, parent_unit, optional_mission_template)
	if not item_data then
		assert(settings.in_editor == true, string.format("ItemCustomization: Cannot spawn attachments without item_data, make sure item data is passed correctly. Parent unit %s", tostring(parent_unit)))

		return nil
	end

	local is_first_person = settings.is_first_person
	local show_in_1p = item_data.show_in_1p

	if is_first_person and not show_in_1p then
		return nil
	end

	local base_unit = is_first_person and item_data.base_unit_1p or item_data.base_unit

	if not base_unit or base_unit == "" then
		assert(settings.in_editor == true, string.format("ItemCustomization: Could not find a base_unit in the item data, make sure item data passed is correctly. Parent unit %s", tostring(parent_unit)))

		return nil
	end

	local breed_attach_node = not settings.is_minion and item_data.breed_attach_node and item_data.breed_attach_node[settings.breed_name]
	local attach_node = breed_attach_node or item_data.attach_node
	local attach_node_index = nil

	if tonumber(attach_node) ~= nil then
		attach_node_index = tonumber(attach_node)
	elseif settings.is_minion then
		if settings.from_script_component then
			attach_node_index = Unit.has_node(parent_unit, item_data.wielded_attach_node or attach_node) and Unit.node(parent_unit, item_data.wielded_attach_node or attach_node) or 1
		else
			attach_node_index = Unit.has_node(parent_unit, item_data.unwielded_attach_node or attach_node) and Unit.node(parent_unit, item_data.unwielded_attach_node or attach_node) or 1
		end
	elseif attach_node then
		attach_node_index = Unit.has_node(parent_unit, attach_node) and Unit.node(parent_unit, attach_node) or 1
	end

	local spawned_unit = nil
	local pose = Unit.world_pose(parent_unit, attach_node_index)

	if settings.from_script_component then
		spawned_unit = World.spawn_unit_ex(settings.world, base_unit, nil, pose)
	elseif settings.is_minion then
		spawned_unit = settings.unit_spawner:spawn_unit(base_unit, settings.attach_pose)
	else
		spawned_unit = settings.unit_spawner:spawn_unit(base_unit, pose)
	end

	local item_type = item_data.item_type

	if item_type then
		local sort_order = _sort_order_enum[item_type]

		if sort_order then
			Unit.set_sort_order(spawned_unit, sort_order)
		end
	end

	if settings.is_first_person or settings.is_in_menu then
		Unit.set_unit_culling(spawned_unit, false)

		if Unit.has_lod_object(spawned_unit, "lod") then
			local item_lod_object = Unit.lod_object(spawned_unit, "lod")

			LODObject.set_static_select(item_lod_object, 0)
		end
	end

	if not spawned_unit then
		assert(not settings.in_editor, string.format("ItemCustomization: Was not able to spawn unit %s", tostring(base_unit)))

		return nil
	end

	local bind_pose = Unit.local_pose(spawned_unit, 1)

	World.link_unit(settings.world, spawned_unit, 1, parent_unit, attach_node_index, not settings.skip_link_children and true)

	if settings.lod_group and Unit.has_lod_object(spawned_unit, "lod") and not settings.is_first_person then
		local attached_lod_object = Unit.lod_object(spawned_unit, "lod")

		LODGroup.add_lod_object(settings.lod_group, attached_lod_object)
	end

	if settings.lod_shadow_group and Unit.has_lod_object(spawned_unit, "lod_shadow") and not settings.is_first_person then
		local attached_lod_object = Unit.lod_object(spawned_unit, "lod_shadow")

		LODGroup.add_lod_object(settings.lod_shadow_group, attached_lod_object)
	end

	if optional_mission_template then
		local face_state_machine_key = optional_mission_template.face_state_machine_key
		local state_machine = item_data[face_state_machine_key]

		if state_machine and state_machine ~= "" then
			Unit.set_animation_state_machine(spawned_unit, state_machine)
		end
	end

	return spawned_unit, bind_pose
end

function _attach_hierarchy(attachment_slot_data, settings, parent_unit, attached_units, attached_units_bind_poses_or_nil, optional_mission_template)
	if not attachment_slot_data.item or attachment_slot_data.item == "" then
		return attached_units, attached_units_bind_poses_or_nil
	end

	if type(attachment_slot_data.item) == "string" then
		if settings.in_editor then
			if settings.item_manager and ToolsMasterItems then
				attachment_slot_data.item = ToolsMasterItems:get(attachment_slot_data.item)
			else
				attachment_slot_data.item = rawget(settings.item_definitions, attachment_slot_data.item)
			end
		else
			attachment_slot_data.item = settings.item_definitions[attachment_slot_data.item]
		end
	end

	local attachment_unit, bind_pose = _spawn_attachment(attachment_slot_data.item, settings, parent_unit, optional_mission_template)

	if attachment_unit then
		attached_units[#attached_units + 1] = attachment_unit

		if attached_units_bind_poses_or_nil then
			attached_units_bind_poses_or_nil[attachment_unit] = Matrix4x4Box(bind_pose)
		end

		local item = attachment_slot_data.item
		local attachments = item and item.attachments
		attached_units = _attach_hierarchy_children(attachments, settings, attachment_unit, attached_units, attached_units_bind_poses_or_nil, optional_mission_template)
		local children = attachment_slot_data.children
		attached_units = _attach_hierarchy_children(children, settings, attachment_unit, attached_units, attached_units_bind_poses_or_nil, optional_mission_template)
		local material_overrides = {}
		local item_material_overrides = attachment_slot_data.item.material_overrides

		if item_material_overrides then
			table.append(material_overrides, item_material_overrides)
		end

		local parent_material_overrides = attachment_slot_data.material_overrides

		if parent_material_overrides then
			table.append(material_overrides, parent_material_overrides)
		end

		local apply_to_parent = attachment_slot_data.item.material_override_apply_to_parent

		if material_overrides then
			for _, material_override in pairs(material_overrides) do
				VisualLoadoutCustomization.apply_material_override(attachment_unit, parent_unit, apply_to_parent, material_override, settings.in_editor)
			end
		end
	end

	return attached_units, attached_units_bind_poses_or_nil
end

function _attach_hierarchy_children(children, settings, parent_unit, attached_units, attached_units_bind_poses_or_nil, optional_mission_template)
	if children then
		for _, child_attachment_slot_data in pairs(children) do
			attached_units, attached_units_bind_poses_or_nil = _attach_hierarchy(child_attachment_slot_data, settings, parent_unit, attached_units, attached_units_bind_poses_or_nil, optional_mission_template)
		end
	end

	return attached_units, attached_units_bind_poses_or_nil
end

return VisualLoadoutCustomization
