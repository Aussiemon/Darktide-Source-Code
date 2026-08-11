-- chunkname: @scripts/tools_plugins/item_previewer.lua

require("core/scripts/log")

local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local unit_alive = Unit.alive

ItemPreviewer = coreclass(ItemPreviewer)

ItemPreviewer.init = function (self, world)
	self.previewer_world = world
	self.attached_units_table = nil
	self.preview_bounding_box = nil
	self.preview_type = "3D"
	self.gui = World.create_screen_gui(self.previewer_world, "immediate")
	self.preview_2D_textures = {}
end

ItemPreviewer.destroy = function (self)
	World.destroy_gui(self.previewer_world, self.gui)
end

ItemPreviewer.update = function (self, dt, t)
	if self.preview_type == "2D" then
		local backbuffer_x, backbuffer_y

		if EditorApi.get_viewport_window_resolution then
			backbuffer_x, backbuffer_y = EditorApi:get_viewport_window_resolution()
		end

		if backbuffer_x == nil or backbuffer_y == nil then
			backbuffer_x = 256
			backbuffer_y = 256
		end

		local texture_scale_value = math.min(backbuffer_x, backbuffer_y) / 256
		local stacks = 0

		for _, texture_data in pairs(self.preview_2D_textures) do
			local texture_size = texture_data.texture_size
			local texture_scale = texture_data.texture_scale or {
				x = 1,
				y = 1,
			}
			local texture_coverage = texture_data.texture_coverage or 1
			local scaled_x = texture_size.x * texture_scale_value * texture_scale.x * texture_coverage
			local scaled_y = texture_size.y * texture_scale_value * texture_scale.y * texture_coverage
			local texture_docking = texture_data.texture_docking or {
				horizontal = "center",
				vertical = "center",
			}
			local x = backbuffer_x / 2 - scaled_x / 2
			local y = backbuffer_y / 2 - scaled_y / 2

			if texture_docking.horizontal == "left" then
				x = 0
			elseif texture_docking.horizontal == "right" then
				x = backbuffer_x
			end

			if texture_docking.vertical == "top" then
				y = 0
			elseif texture_docking.vertical == "bottom" then
				y = backbuffer_y
			end

			local stack_offset = {
				x = 0,
				y = 0,
			}

			if texture_data.texture_stacking == "vertical" then
				if texture_docking.vertical == "top" then
					stack_offset.y = stacks * scaled_y
				elseif texture_docking.vertical == "bottom" then
					stack_offset.y = -stacks * scaled_y
				end
			elseif texture_data.texture_stacking == "horizontal" then
				if texture_docking.horizontal == "left" then
					stack_offset.x = stacks * scaled_x
				elseif texture_docking.horizontal == "right" then
					stack_offset.x = -stacks * scaled_x
				end
			end

			y = y + stack_offset.y
			x = x + stack_offset.x
			stacks = stacks + 1

			Gui.bitmap(self.gui, texture_data.texture_material, Vector3(x, y, 140), Vector3(scaled_x, scaled_y, 0))
		end
	end
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

	if self.preview_2D_textures then
		for texture_name, texture_data in pairs(self.preview_2D_textures) do
			Material.set_texture(texture_data.texture_material, "thumbnail_slot", nil)
			GuiThumbnail.unload(texture_data.texture_handle)

			self.preview_2D_textures[texture_name] = nil
		end
	end
end

ItemPreviewer.preview = function (self, resource, return_data)
	self.preview_type = "3D"

	if ToolsMasterItems then
		local item_data = ToolsMasterItems:get(resource)

		if item_data then
			item_data = table.clone(item_data)

			local root_unit_resource = self:_select_root_unit_resource(item_data)
			local root_unit = World.spawn_unit_ex(self.previewer_world, root_unit_resource)

			EditorApi.root_unit = root_unit

			if item_data.item_type == "END_OF_ROUND" or item_data.item_type == "EMOTE" or item_data.item_type == "BODY_TATTOO" then
				if table.array_contains(item_data.breeds, "human") then
					item_data.attachments = {
						{
							item = "content/items/characters/player/human/attachment_base/female_torso",
						},
						{
							item = "content/items/characters/player/human/attachment_base/female_legs",
						},
						{
							item = "content/items/characters/player/human/attachment_base/female_arms",
						},
						{
							item = "content/items/characters/player/human/faces/female_caucasian_face_01",
						},
						{
							item = item_data.prop_item,
						},
						{
							item = item_data.prop_item_2,
						},
					}
					item_data.base_unit = "content/characters/player/human/third_person/base_body_rig"
				elseif table.array_contains(item_data.breeds, "cryptic") then
					item_data.attachments = {
						{
							item = "content/items/characters/player/human/cryptic_base_body/body_01",
						},
						{
							item = "content/items/characters/player/human/cryptic_base_legs/base_legs_01",
						},
						{
							item = "content/items/characters/player/human/cryptic_base_arms/base_arms_01",
						},
						{
							item = "content/items/characters/player/human/faces/empty_face",
						},
						{
							item = item_data.prop_item,
						},
						{
							item = item_data.prop_item_2,
						},
					}
					item_data.base_unit = "content/characters/player/human/third_person/base_body_rig"
				else
					item_data.attachments = {
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_torso",
						},
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_legs",
						},
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_arms",
						},
						{
							item = "content/items/characters/player/ogryn/attachment_base/male_face_caucasian_03",
						},
						{
							item = item_data.prop_item,
						},
						{
							item = item_data.prop_item_2,
						},
					}
					item_data.base_unit = "content/characters/player/human/third_person/base_body_rig"
				end

				item_data.attach_node = "root_point"

				if item_data.state_machine and item_data.state_machine ~= "" then
					Unit.set_animation_state_machine(root_unit, item_data.state_machine)
				end

				if item_data.animation_event and item_data.animation_event ~= "" and Unit.has_animation_event(root_unit, item_data.animation_event) then
					Unit.animation_event(root_unit, item_data.animation_event)
				end
			elseif item_data.item_type == "WEAPON_SKIN" or item_data.item_type == "MATERIAL_OVERRIDES" then
				local skin_data = item_data

				if item_data.preview_item and item_data.preview_item ~= "" then
					item_data = table.clone(ToolsMasterItems:get(item_data.preview_item))
				end

				item_data.slot_weapon_skin = skin_data.name
			elseif item_data.item_type == "COLOR_MATERIAL_OVERRIDE" or item_data.item_type == "PATTERN_MATERIAL_OVERRIDE" then
				for _, texture_material_override in pairs(item_data.texture_material_overrides) do
					if texture_material_override.texture and texture_material_override.texture ~= "" then
						local texture_name = texture_material_override.texture
						local texture_handle = GuiThumbnail.load_texture(texture_name)
						local texture_size = {}

						texture_size.x, texture_size.y = Gui.texture_size(texture_name)

						if texture_size.x > 0 and texture_size.y > 0 then
							if texture_size.x > texture_size.y then
								texture_size.y = 256 * (texture_size.y / texture_size.x)
								texture_size.x = 256
							else
								texture_size.x = 256 * (texture_size.x / texture_size.y)
								texture_size.y = 256
							end

							local texture_material = Gui.clone_material_from_template(self.gui, texture_name, "core/editor_slave/content_preview/texture_preview")

							Material.set_texture(texture_material, "thumbnail_slot", texture_name)

							local texture_coverage = 1
							local texture_docking = {
								horizontal = "center",
								vertical = "bottom",
							}
							local texture_stacking = "vertical"
							local texture_scale = {
								x = 1,
								y = 1,
							}

							if item_data.item_type == "COLOR_MATERIAL_OVERRIDE" then
								texture_scale = {
									x = 1,
									y = 3,
								}
							elseif item_data.item_type == "PATTERN_MATERIAL_OVERRIDE" then
								texture_coverage = 0.35
								texture_docking = {
									horizontal = "left",
									vertical = "top",
								}
								texture_stacking = "horizontal"
							end

							self.preview_type = "2D"
							self.preview_2D_textures[texture_material_override.texture_slot] = {
								texture_handle = texture_handle,
								texture_size = texture_size,
								texture_scale = texture_scale,
								texture_material = texture_material,
								texture_coverage = texture_coverage,
								texture_docking = texture_docking,
								texture_stacking = texture_stacking,
							}
						else
							Log.error("ItemPreviewer", string.format("Couldn't find valid texture_resource field for 2D item %s!", resource))
						end
					end
				end

				local prev_item_name = item_data.name
				local prev_item_type = item_data.item_type

				if item_data.preview_item and item_data.preview_item ~= "" then
					item_data = table.clone(ToolsMasterItems:get(item_data.preview_item))
				end

				local material_override_items = item_data.material_override_items or {}

				if prev_item_type == "PATTERN_MATERIAL_OVERRIDE" then
					material_override_items[#material_override_items + 1] = "content/items/material_overrides/gear_colors/color_4_colour_mars_01"
				elseif prev_item_type == "COLOR_MATERIAL_OVERRIDE" then
					material_override_items[#material_override_items + 1] = "content/items/material_overrides/gear_patterns/pattern_camo_preview"
				end

				material_override_items[#material_override_items + 1] = "content/items/material_overrides/gear_patterns/pattern_camo_preview"
				material_override_items[#material_override_items + 1] = prev_item_name
			elseif item_data.item_type == "CHARACTER_INSIGNIA" or item_data.item_type == "PORTRAIT_FRAME" then
				if item_data.texture_resource and item_data.texture_resource ~= "" then
					local texture_name = item_data.texture_resource
					local texture_handle = GuiThumbnail.load_texture(item_data.texture_resource)
					local texture_size = {}

					texture_size.x, texture_size.y = Gui.texture_size(texture_name)

					if texture_size.x > 0 and texture_size.y > 0 then
						if texture_size.x > texture_size.y then
							texture_size.y = 256 * (texture_size.y / texture_size.x)
							texture_size.x = 256
						else
							texture_size.x = 256 * (texture_size.x / texture_size.y)
							texture_size.y = 256
						end

						local texture_material = Gui.clone_material_from_template(self.gui, texture_name, "core/editor_slave/content_preview/texture_preview")

						Material.set_texture(texture_material, "thumbnail_slot", texture_name)

						self.preview_type = "2D"
						self.preview_2D_textures[texture_name] = {
							texture_handle = texture_handle,
							texture_size = texture_size,
							texture_material = texture_material,
						}
					else
						Log.error("ItemPreviewer", string.format("Couldn't find valid texture_resource field for 2D item %s!", resource))
					end
				end
			elseif item_data.item_type == "SET" then
				item_data.attachments = item_data.set_items
				item_data.base_unit = root_unit_resource
				item_data.attach_node = "root_point"
			end

			self:_spawn_item(item_data, root_unit)
			self:_build_bounding_box(item_data)

			if return_data then
				return item_data
			end
		else
			Log.error("ItemPreviewer", string.format("Could not find resource %s in ToolsMasterItems!", resource))
		end
	end
end

ItemPreviewer._spawn_item = function (self, item_data, root_unit)
	local attach_settings = {}

	attach_settings.is_minion = false

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
		local attached_units, mission_template, equipment

		EditorApi.preview_resource, attached_units = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, root_unit, false, false, false, mission_template, equipment)
		self.attached_units_table = self.attached_units_table or {}

		if EditorApi.preview_resource then
			table.insert(self.attached_units_table, EditorApi.preview_resource)
			table.append(self.attached_units_table, attached_units[EditorApi.preview_resource])
		end
	else
		Log.error("ItemPreviewer", "VisualLoadoutCustomization not loaded!")
	end

	Unit.set_unit_culling(root_unit, false, true)
end

ItemPreviewer._build_bounding_box = function (self, item_data)
	local tm, half_extents

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
		Vector3Box(half_extents),
	}
end

ItemPreviewer.spawn_unit = function (self, base_unit, pose)
	return World.spawn_unit_ex(self.previewer_world, base_unit, pose)
end

ItemPreviewer._select_root_unit_resource = function (self, item_data)
	local breeds = item_data.breeds
	local slots = item_data.slots
	local item_type = item_data.item_type
	local root_unit = "core/units/empty_root"

	if item_type == "END_OF_ROUND" or item_type == "EMOTE" then
		if breeds then
			root_unit = self:_select_cutscene_body_item_root_unit(breeds, root_unit)
		end
	elseif item_type == "SET" then
		if breeds then
			if table.array_contains(breeds, "human") then
				root_unit = "content/characters/player/human/third_person/base_gear_rig"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "content/characters/player/ogryn/third_person/base_gear_rig"
			elseif table.array_contains(breeds, "cryptic") then
				root_unit = "content/characters/player/human/third_person/base_gear_rig"
			end
		end
	elseif slots then
		if breeds and not table.array_contains(slots, "slot_primary") and not table.array_contains(slots, "slot_secondary") then
			if table.array_contains(breeds, "human") then
				root_unit = "core/units/empty_root"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "core/units/empty_root"
			elseif table.array_contains(breeds, "cryptic") then
				root_unit = "core/units/empty_root"
			end
		end

		if table.array_contains(slots, "slot_body_hair_color") or table.array_contains(slots, "slot_body_face_hair_color") then
			root_unit = "content/characters/player/ogryn/attachments_base/hair/hair_medium_mullet_a/hair_medium_mullet_a"
		end

		if table.array_contains(slots, "slot_body_face_tattoo") or table.array_contains(slots, "slot_body_eye_color") or table.array_contains(slots, "slot_body_eye_color_secondary") or table.array_contains(slots, "slot_body_skin_color") or table.array_contains(slots, "slot_body_skin_color_secondary") or table.array_contains(slots, "slot_body_skin_discoloration") or table.array_contains(slots, "slot_body_face_scar") or table.array_contains(slots, "slot_body_hair") or table.array_contains(slots, "slot_body_face_hair") or table.array_contains(slots, "slot_body_face_makeup") then
			if table.array_contains(breeds, "human") then
				root_unit = "content/characters/player/human/attachments_base/male/face_caucasian_01/male_face_caucasian_01"
			elseif table.array_contains(breeds, "ogryn") then
				root_unit = "content/characters/player/ogryn/attachments_base/male/face_caucasian_01/male_face_caucasian_01"
			elseif table.array_contains(breeds, "cryptic") then
				root_unit = "content/characters/empty_item/empty_item"
			end
		end

		if table.array_contains(slots, "slot_body_tattoo") then
			root_unit = self:_select_cutscene_body_item_root_unit(breeds)
		end
	end

	return root_unit
end

ItemPreviewer._select_cutscene_body_item_root_unit = function (self, breeds, root_unit)
	if table.array_contains(breeds, "human") then
		root_unit = "content/characters/player/human/third_person/cutscene_npc"
	elseif table.array_contains(breeds, "ogryn") then
		root_unit = "content/characters/player/ogryn/third_person/cutscene_npc"
	elseif table.array_contains(breeds, "cryptic") then
		root_unit = "content/characters/player/human/third_person/cutscene_npc"
	end

	return root_unit
end

ItemPreviewer._select_hardcoded_bounding_box = function (self, item_data)
	local breeds = item_data.breeds
	local slots = item_data.slots
	local item_type = item_data.item_type
	local is_human_sized = breeds and (table.array_contains(breeds, "human") or table.array_contains(breeds, "cryptic"))
	local is_ogryn_sized = breeds and table.array_contains(breeds, "ogryn")
	local is_lowerbody = slots and table.array_contains(slots, "slot_gear_lowerbody")
	local is_upperbody = slots and table.array_contains(slots, "slot_gear_upperbody")
	local is_face = slots and (table.array_contains(slots, "slot_body_face") or table.array_contains(slots, "slot_body_face_tattoo") or table.array_contains(slots, "slot_body_eye_color") or table.array_contains(slots, "slot_body_eye_color_secondary") or table.array_contains(slots, "slot_body_skin_color") or table.array_contains(slots, "slot_body_skin_color_secondary") or table.array_contains(slots, "slot_body_skin_discoloration") or table.array_contains(slots, "slot_body_face_scar") or table.array_contains(slots, "slot_body_hair") or table.array_contains(slots, "slot_body_face_hair") or table.array_contains(slots, "slot_body_face_makeup"))

	if item_type == "SET" then
		if is_human_sized then
			return Matrix4x4.from_translation(Vector3(0, 0, 0.9)), Vector3(0.6, 0.2, 0.9)
		elseif is_ogryn_sized then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.4)), Vector3(1.2, 0.6, 1.5)
		end
	end

	if is_human_sized then
		if is_lowerbody then
			return Matrix4x4.from_translation(Vector3(0, 0, 0.5)), Vector3(0.2, 0.2, 0.6)
		elseif is_upperbody then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.3)), Vector3(0.45, 0.2, 0.2)
		elseif is_face then
			return Matrix4x4.from_translation(Vector3(0, 0, 1.6)), Vector3(0.1, 0.1, 0.1)
		end
	elseif is_ogryn_sized then
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
		"item",
	}
end

ItemPreviewer.allow_camera_horizontal_orbit = function (self)
	return true
end

ItemPreviewer.allow_camera_vertical_orbit = function (self)
	return true
end
