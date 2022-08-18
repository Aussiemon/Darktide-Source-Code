require("core/scripts/log")

local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local unit_alive = Unit.alive
ItemPreviewer = coreclass(ItemPreviewer)

ItemPreviewer.init = function (self, world)
	self.previewer_world = world
	self.attached_units_table = nil
	self.preview_bounding_box = nil
end

ItemPreviewer.destroy = function (self)
	return
end

ItemPreviewer.update = function (self, dt, t)
	return
end

ItemPreviewer.cleanup = function (self)
	if EditorApi.preview_resource then
		if self.attached_units_table then
			for i = #self.attached_units_table, 1, -1 do
				local unit = self.attached_units_table[i]

				if unit and unit_alive(unit) then
					World.destroy_unit(self.previewer_world, unit)
				end
			end

			self.attached_units_table = nil
		end

		if EditorApi.root_unit and unit_alive(EditorApi.root_unit) then
			World.destroy_unit(self.previewer_world, EditorApi.root_unit)
		end

		self.preview_bounding_box = nil
	end
end

ItemPreviewer.preview = function (self, resource)
	if ToolsMasterItems then
		local item_data = ToolsMasterItems:get(resource)

		if item_data then
			local root_unit_resource = self:_select_root_unit_resource(item_data)
			local root_unit = World.spawn_unit_ex(self.previewer_world, root_unit_resource)
			EditorApi.root_unit = root_unit

			if item_data.item_type == "END_OF_ROUND" or item_data.item_type == "EMOTE" then
				if table.array_contains(item_data.breeds, "human") then
					item_data.attachments = {
						{
							item = "content/items/characters/player/human/attachment_base/female_torso"
						},
						{
							item = "content/items/characters/player/human/attachment_base/female_legs"
						},
						{
							item = "content/items/characters/player/human/attachment_base/female_arms"
						},
						{
							item = "content/items/characters/player/human/faces/female_asian_face_01"
						},
						{
							item = item_data.prop_item
						}
					}
					item_data.base_unit = "content/characters/player/human/third_person/base_gear_rig"
				else
					item_data.attachments = {
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_torso"
						},
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_legs"
						},
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_arms"
						},
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_03"
						},
						{
							item = item_data.prop_item
						}
					}
					item_data.base_unit = "content/characters/player/ogryn/third_person/base_gear_rig"
				end

				item_data.attach_node = "root_point"

				if item_data.state_machine and item_data.state_machine ~= "" then
					Unit.set_animation_state_machine(root_unit, item_data.state_machine)
				end

				if item_data.animation_event and item_data.animation_event ~= "" and Unit.has_animation_event(root_unit, item_data.animation_event) then
					Unit.animation_event(root_unit, item_data.animation_event)
				end
			elseif item_data.item_type == "WEAPON_SKIN" then
				local skin_data = table.clone(item_data)

				if item_data.preview_item and item_data.preview_item ~= "" then
					item_data = table.clone(ToolsMasterItems:get(item_data.preview_item))
				end

				item_data.material_overrides = table.append(item_data.material_overrides, skin_data.material_overrides)
			elseif item_data.item_type ~= "CHARACTER_INSIGNIA" then
				if item_data.item_type == "PORTRAIT_FRAME" then
				elseif item_data.item_type == "SET" then
					item_data.attachments = item_data.set_items
					item_data.base_unit = root_unit_resource
					item_data.attach_node = "root_point"
				end
			end

			self:_spawn_item(item_data, root_unit)
			self:_build_bounding_box(item_data)
		else
			Log.error("ItemPreviewer", string.format("Could not find resource %s in ToolsMasterItems!", resource))
		end
	end
end

ItemPreviewer._spawn_item = function (self, item_data, root_unit)
	local attach_settings = {
		is_minion = false
	}

	if item_data.item_list_faction == "Minion" then
		attach_settings.is_minion = true
	end

	attach_settings.spawn_with_extensions = false
	attach_settings.in_editor = true
	attach_settings.is_first_person = false
	attach_settings.world = self.previewer_world
	attach_settings.unit_spawner = self
	attach_settings.item_manager = true
	attach_settings.skip_link_children = false

	if VisualLoadoutCustomization then
		local attached_units = {}
		EditorApi.preview_resource, attached_units = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, root_unit)
		self.attached_units_table = self.attached_units_table or {}

		if EditorApi.preview_resource then
			table.append(self.attached_units_table, {
				EditorApi.preview_resource
			})
		end

		if attached_units then
			table.append(self.attached_units_table, attached_units)
		end
	else
		Log.error("ItemPreviewer", "VisualLoadoutCustomization not loaded!")
	end

	Unit.set_unit_culling(root_unit, false, true)
end

ItemPreviewer._build_bounding_box = function (self, item_data)
	local tm, half_extents = nil
	tm, half_extents = self:_select_hardcoded_bounding_box(item_data)

	if not tm then
		tm = Matrix4x4.identity()
		half_extents = Vector3(0, 0, 0)

		if EditorApi.preview_resource then
			tm, half_extents = Unit.box(EditorApi.preview_resource)
		end

		if self.attached_units_table then
			local bboxes = {}

			for i, attached_unit in pairs(self.attached_units_table) do
				World.update_unit(self.previewer_world, attached_unit)

				bboxes[#bboxes + 1], bboxes[#bboxes + 2] = Unit.box(attached_unit)
			end

			tm, half_extents = Math.merge_boxes(tm, half_extents, unpack(bboxes))
		end
	end

	self.preview_bounding_box = {
		Matrix4x4Box(tm),
		Vector3Box(half_extents)
	}
end

ItemPreviewer.spawn_unit = function (self, base_unit, item_material_slot_overrides)
	return World.spawn_unit_ex(self.previewer_world, base_unit, nil, nil, nil, nil, item_material_slot_overrides)
end

ItemPreviewer._select_root_unit_resource = function (self, item_data)
	local breeds = item_data.breeds
	local slots = item_data.slots
	local item_type = item_data.item_type
	local root_unit = "core/units/empty_root"

	if item_type == "END_OF_ROUND" or item_type == "EMOTE" then
		if breeds then
			if table.array_contains(breeds, "human") then
				root_unit = "content/characters/player/human/third_person/cutscene_npc"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "content/characters/player/ogryn/third_person/cutscene_npc"
			end
		end
	elseif item_type == "SET" then
		if breeds then
			if table.array_contains(breeds, "human") then
				root_unit = "content/characters/player/human/third_person/base_gear_rig"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "content/characters/player/ogryn/third_person/base_gear_rig"
			end
		end
	elseif slots then
		if breeds and not table.array_contains(slots, "slot_primary") and not table.array_contains(slots, "slot_secondary") then
			if table.array_contains(breeds, "human") then
				root_unit = "core/units/empty_root"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "core/units/empty_root"
			end
		end

		if table.array_contains(slots, "slot_body_hair_color") then
			root_unit = "content/characters/player/ogryn/attachments_base/hair/hair_long_greaser_a/hair_long_greaser_a"
		end

		if table.array_contains(slots, "slot_body_face_tattoo") or table.array_contains(slots, "slot_body_eye_color") or table.array_contains(slots, "slot_body_skin_color") or table.array_contains(slots, "slot_body_face_scar") or table.array_contains(slots, "slot_body_hair") or table.array_contains(slots, "slot_body_face_hair") then
			if table.array_contains(breeds, "human") then
				root_unit = "content/characters/player/human/attachments_base/male/face_caucasian_01/male_face_caucasian_01"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "content/characters/player/ogryn/attachments_base/male/face_caucasian_01/male_face_caucasian_01"
			end
		end
	end

	return root_unit
end

ItemPreviewer._select_hardcoded_bounding_box = function (self, item_data)
	local breeds = item_data.breeds
	local slots = item_data.slots
	local item_type = item_data.item_type
	local is_human = breeds and table.array_contains(breeds, "human")
	local is_ogryn = breeds and table.array_contains(breeds, "ogryn")
	local is_lowerbody = slots and table.array_contains(slots, "slot_gear_lowerbody")
	local is_upperbody = slots and table.array_contains(slots, "slot_gear_upperbody")
	local is_face = slots and (table.array_contains(slots, "slot_body_face") or table.array_contains(slots, "slot_body_face_tattoo") or table.array_contains(slots, "slot_body_eye_color") or table.array_contains(slots, "slot_body_skin_color") or table.array_contains(slots, "slot_body_face_scar") or table.array_contains(slots, "slot_body_hair") or table.array_contains(slots, "slot_body_face_hair"))

	if item_type == "SET" then
		if is_human then
			return Matrix4x4.from_translation(Vector3(0, 0, 0.9)), Vector3(0.6, 0.2, 0.9)
		elseif is_ogryn then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.4)), Vector3(1.2, 0.6, 1.5)
		end
	end

	if is_human then
		if is_lowerbody then
			return Matrix4x4.from_translation(Vector3(0, 0, 0.5)), Vector3(0.2, 0.2, 0.6)
		elseif is_upperbody then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.2)), Vector3(0.6, 0.2, 0.4)
		elseif is_face then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.6)), Vector3(0.1, 0.1, 0.1)
		end
	elseif is_ogryn then
		if is_lowerbody then
			return Matrix4x4.from_translation(Vector3(0, 0, 0.65)), Vector3(0.6, 0.4, 0.9)
		elseif is_upperbody then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.8)), Vector3(1.2, 0.6, 0.8)
		elseif is_face then
			return Matrix4x4.from_translation(Vector3(0, 0, 2.5)), Vector3(0.4, 0.4, 0.4)
		end
	end

	return nil, nil
end

ItemPreviewer.get_bounding_box = function (self)
	if self.preview_bounding_box then
		return Matrix4x4Box.unbox(self.preview_bounding_box[1]), Vector3Box.unbox(self.preview_bounding_box[2])
	else
		return Matrix4x4.identity(), Vector3(0, 0, 0)
	end
end

ItemPreviewer.get_supported_types = function (self)
	return {
		"item"
	}
end

ItemPreviewer.allow_camera_horizontal_orbit = function (self)
	return true
end

ItemPreviewer.allow_camera_vertical_orbit = function (self)
	return true
end

return
