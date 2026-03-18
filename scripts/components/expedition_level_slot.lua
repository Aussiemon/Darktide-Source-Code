-- chunkname: @scripts/components/expedition_level_slot.lua

local ExpeditionLevelSlot = component("ExpeditionLevelSlot")
local FONT = "core/editor_slave/gui/arial"
local FONT_SIZE = 0.75
local FONT_COLOR = QuaternionBox(Color(255, 255, 255))
local DSL_TERRAIN_BASES_PATH = "content/environment/artsets/imperial/expeditions/dsl_terrain_bases/canyon/"
local GIZMO_VISIBLE = GIZMO_VISIBLE or false

ExpeditionLevelSlot.init = function (self, unit)
	if self:get_data(unit, "boolean_transition") then
		local level_size = self:get_data(unit, "level_size")
		local node_index = Unit.node(unit, "ap_light_blocker")
		local size = tonumber(string.sub(level_size, -2)) * 0.5
		local extents = Vector3(size, size, 1)

		Unit.set_local_scale(unit, node_index, extents)
	end

	Unit.set_mesh_visibility(unit, "s_light_blocker", false, VisibilityContexts.SHADOW_CASTER_CONTEXT)
end

local function is_safe_zone()
	local level_id = LevelEditor:get_current_active_level()
	local level_name = LevelEditor:get_level_resource_name(level_id)

	if level_name == nil then
		return false
	end

	return string.find(level_name, "content/levels/expeditions/safe_zones/")
end

ExpeditionLevelSlot.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit
	self._world = Unit.world(unit)
	self._gui = World.create_world_gui(self._world, Matrix4x4.identity(), 1, 1)
	self._gui_text_ids = {}

	if self:_is_in_default_mode() then
		local level_size = self:get_data(unit, "level_size")
		local node_index = Unit.node(unit, "ap_preview_gizmos")
		local size = tonumber(string.sub(level_size, -2)) * 0.5
		local extents = Vector3(size, size, 1)

		Unit.set_local_scale(unit, node_index, extents)
		Unit.set_local_scale(unit, Unit.node(unit, "ap_light_blocker"), extents)
		Unit.set_vector4_for_material(unit, "gizmo_circle", "color", Color(1, 1, 0, 0.4))

		if self:get_data(unit, "boolean_transition") then
			local node_index = Unit.node(unit, "g_gizmo_circle")

			Unit.set_local_scale(unit, node_index, Vector3(0, 0, 0))

			if is_safe_zone() then
				Unit.set_mesh_visibility(self._unit, "s_light_blocker", false, VisibilityContexts.SHADOW_CASTER_CONTEXT)
			end
		else
			local node_index = Unit.node(unit, "g_gizmo_cube")

			Unit.set_local_scale(unit, node_index, Vector3(0, 0, 0))
			Unit.set_mesh_visibility(self._unit, "s_light_blocker", false, VisibilityContexts.SHADOW_CASTER_CONTEXT)
		end

		local editor_preview_unit = self:get_data(unit, "editor_preview_unit")

		if editor_preview_unit ~= "none" then
			local preview_unit_size = size * 2
			local unit_path = DSL_TERRAIN_BASES_PATH .. "dsl_terrain_base_" .. preview_unit_size .. "m_" .. editor_preview_unit

			self._editor_preview_unit = World.spawn_unit_ex(self._world, unit_path, nil, Unit.world_pose(unit, 1))

			World.link_unit(self._world, self._editor_preview_unit, 1, unit, 1)
		end
	else
		local node_index = Unit.node(unit, "g_gizmo_cube")

		Unit.set_local_scale(unit, node_index, Vector3(0, 0, 0))
		Unit.set_mesh_visibility(self._unit, "s_light_blocker", false, VisibilityContexts.SHADOW_CASTER_CONTEXT)
	end

	self:_editor_add_text(unit)
	self:_set_script_data(unit)
end

ExpeditionLevelSlot._is_in_default_mode = function (self)
	local unit = self._unit
	local mode = self:get_data(unit, "mode")
	local is_default_spawn_mode = mode == "spawn_mode_1"

	return is_default_spawn_mode
end

ExpeditionLevelSlot._insert_component_data = function (self, script_data, key, value)
	script_data["components." .. self.guid .. ".component_data." .. key] = value
end

ExpeditionLevelSlot._set_script_data = function (self, unit)
	local object_id = Unit.get_data(unit, "LevelEditor", "object_id")
	local object = LevelEditor:find_level_object(object_id)
	local script_data_to_update = {}
	local script_data = object:script_data_overrides() or {}
	local is_in_default_mode = self:_is_in_default_mode()
	local level_size = self:get_data(unit, "level_size")

	self:_insert_component_data(script_data, "level_size", is_in_default_mode and level_size or nil)
	self:_insert_component_data(script_data, "biome", nil)

	local boolean_opportunities = self:get_data(unit, "boolean_opportunities")

	if boolean_opportunities and is_in_default_mode then
		self:_insert_component_data(script_data, "type_opportunity", "type_opportunity")
	else
		self:_insert_component_data(script_data, "type_opportunity", nil)
	end

	local boolean_traversal = self:get_data(unit, "boolean_traversal")

	if boolean_traversal and is_in_default_mode then
		self:_insert_component_data(script_data, "type_traversal", "type_traversal")
	else
		self:_insert_component_data(script_data, "type_traversal", nil)
	end

	local boolean_main_objectives = self:get_data(unit, "boolean_main_objectives")

	if boolean_main_objectives and is_in_default_mode then
		self:_insert_component_data(script_data, "type_main_objective", "type_main_objective")
	else
		self:_insert_component_data(script_data, "type_main_objective", nil)
	end

	local boolean_transition = self:get_data(unit, "boolean_transition")

	if boolean_transition and is_in_default_mode then
		self:_insert_component_data(script_data, "type_transition", "type_transition")
	else
		self:_insert_component_data(script_data, "type_transition", nil)
	end

	local boolean_extraction = self:get_data(unit, "boolean_extraction")

	if boolean_extraction and is_in_default_mode then
		self:_insert_component_data(script_data, "type_extraction", "type_extraction")
	else
		self:_insert_component_data(script_data, "type_extraction", nil)
	end

	local boolean_arrival = self:get_data(unit, "boolean_arrival")

	if boolean_arrival and is_in_default_mode then
		self:_insert_component_data(script_data, "type_arrival", "type_arrival")
	else
		self:_insert_component_data(script_data, "type_arrival", nil)
	end

	script_data_to_update[#script_data_to_update + 1] = {
		id = object.id,
		script_data = script_data,
	}

	Application.console_send({
		type = "update_script_data",
		data = script_data_to_update,
	})
end

ExpeditionLevelSlot.enable = function (self, unit)
	return
end

ExpeditionLevelSlot.disable = function (self, unit)
	return
end

ExpeditionLevelSlot.destroy = function (self, unit)
	return
end

local function text_offset(unit, gui, text)
	local min, max = Gui.slug_text_max_extents(gui, text, FONT, FONT_SIZE, "flags", Gui.FormatDirectives)
	local text_width, text_height = max.x - min.x, max.y - min.y
	local offset = Vector3(-text_width * 0.5, text_height * 0.5, 0)

	return offset
end

ExpeditionLevelSlot._editor_draw_text = function (self, unit, text)
	local text_pose = Matrix4x4.from_quaternion_position(Unit.world_rotation(unit, 1), Unit.world_position(unit, 1) + Vector3.multiply(Vector3(0, 0, 1.5), #self._gui_text_ids + 1))
	local offset = text_offset(unit, self._gui, text)

	self._gui_text_ids[#self._gui_text_ids + 1] = Gui.text_3d(self._gui, text, FONT, FONT_SIZE, FONT, text_pose, offset, 1, FONT_COLOR:unbox())
end

ExpeditionLevelSlot._editor_add_text = function (self, unit)
	self:_editor_destroy_text()

	if GIZMO_VISIBLE then
		local is_in_default_mode = self:_is_in_default_mode()

		if is_in_default_mode and self:get_data(unit, "boolean_opportunities") then
			self:_editor_draw_text(unit, "Opportunity")
		end

		if is_in_default_mode and self:get_data(unit, "boolean_traversal") then
			self:_editor_draw_text(unit, "Traversal")
		end

		if is_in_default_mode and self:get_data(unit, "boolean_main_objectives") then
			self:_editor_draw_text(unit, "Main Objective")
		end

		if is_in_default_mode and self:get_data(unit, "boolean_transition") then
			self:_editor_draw_text(unit, "Transition")
		end

		if is_in_default_mode and self:get_data(unit, "boolean_extraction") then
			self:_editor_draw_text(unit, "Extraction")
		end

		if is_in_default_mode and self:get_data(unit, "boolean_arrival") then
			self:_editor_draw_text(unit, "Arrival")
		end
	end
end

ExpeditionLevelSlot._editor_destroy_text = function (self)
	for i = #self._gui_text_ids, 1, -1 do
		local id = self._gui_text_ids[i]

		Gui.destroy_text_3d(self._gui, id)
	end

	self._gui_text_ids = {}
end

ExpeditionLevelSlot.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_editor_destroy_text()
	World.destroy_gui(self._world, self._gui)

	if self._editor_preview_unit then
		World.unlink_unit(self._world, self._editor_preview_unit)
		World.destroy_unit(self._world, self._editor_preview_unit)
	end
end

ExpeditionLevelSlot.editor_validate = function (self, unit)
	return true, ""
end

ExpeditionLevelSlot.editor_world_transform_modified = function (self, unit)
	self:_editor_add_text(unit)
end

ExpeditionLevelSlot.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable
end

ExpeditionLevelSlot.editor_toggle_visibility_state = function (self, visible)
	return
end

ExpeditionLevelSlot.editor_toggle_gizmo_visibility_state = function (self, visible)
	GIZMO_VISIBLE = visible

	self:_editor_add_text(self._unit)

	if GIZMO_VISIBLE then
		if self:_is_in_default_mode() then
			Unit.set_mesh_visibility(self._unit, "g_gizmo_unit", false, VisibilityContexts.DEFAULT_CONTEXT)
		else
			Unit.set_mesh_visibility(self._unit, "g_gizmo", false, VisibilityContexts.DEFAULT_CONTEXT)
		end
	end
end

ExpeditionLevelSlot.component_data = {
	editor_preview_unit = {
		category = "Only in Default Mode",
		ui_name = "Editor Preview Unit",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"none",
			"dsl_terrain_base_01",
			"dsl_terrain_base_02",
			"dsl_terrain_base_03",
		},
		options_values = {
			"none",
			"01",
			"02",
			"03",
		},
	},
	mode = {
		ui_name = "Spawn Mode",
		ui_type = "combo_box",
		value = "spawn_mode_1",
		options_keys = {
			"default",
			"unit",
		},
		options_values = {
			"spawn_mode_1",
			"spawn_mode_2",
		},
	},
	rot_mode = {
		category = "Only in Default Mode",
		ui_name = "Rotation Mode",
		ui_type = "combo_box",
		value = "rot_mode_random",
		options_keys = {
			"random",
			"slot",
		},
		options_values = {
			"rot_mode_random",
			"rot_mode_slot",
		},
	},
	tags = {
		size = 0,
		ui_name = "Tag",
		ui_type = "combo_box_array",
		values = {},
		options_keys = {
			"Biome Generic",
			"Biome Wastes",
			"Biome Quarry",
			"Biome Oil",
			"Safe Zone Entrance",
			"Safe Zone Exit",
			"Interactable",
			"Decoy",
		},
		options_values = {
			"biome_generic",
			"biome_wastes",
			"biome_quarry",
			"biome_oil",
			"safe_zone_entrance",
			"safe_zone_exit",
			"interactable",
			"decoy",
		},
	},
	level_size = {
		category = "Only in Default Mode",
		ui_name = "Level Size",
		ui_type = "combo_box",
		value = "level_size_32",
		options_keys = {
			"16",
			"32",
			"48",
			"64",
		},
		options_values = {
			"level_size_16",
			"level_size_32",
			"level_size_48",
			"level_size_64",
		},
	},
	boolean_opportunities = {
		category = "Only in Default Mode",
		ui_name = "Allow Opportunity",
		ui_type = "check_box",
		value = false,
	},
	boolean_traversal = {
		category = "Only in Default Mode",
		ui_name = "Allow Traversal",
		ui_type = "check_box",
		value = true,
	},
	boolean_transition = {
		category = "Only in Default Mode",
		ui_name = "Allow Transition",
		ui_type = "check_box",
		value = false,
	},
	boolean_extraction = {
		category = "Only in Default Mode",
		ui_name = "Allow Extraction",
		ui_type = "check_box",
		value = false,
	},
	boolean_arrival = {
		category = "Only in Default Mode",
		ui_name = "Allow Arrival",
		ui_type = "check_box",
		value = false,
	},
}

return ExpeditionLevelSlot
