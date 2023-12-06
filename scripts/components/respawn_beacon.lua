local RespawnBeaconQueries = require("scripts/extension_systems/respawn_beacon/utilities/respawn_beacon_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local RespawnBeacon = component("RespawnBeacon")

RespawnBeacon.init = function (self, unit)
	local respawn_beacon_extension = ScriptUnit.fetch_component_extension(unit, "respawn_beacon_system")

	if respawn_beacon_extension then
		local side = self:get_data(unit, "side")
		local debug_ignore_check_distances = self:get_data(unit, "debug_ignore_check_distances")

		respawn_beacon_extension:setup_from_component(side, debug_ignore_check_distances)
	end
end

local FONT = "core/editor_slave/gui/arial"
local FONT_MATERIAL = "core/editor_slave/gui/arial"
local FONT_SIZE = 0.3

RespawnBeacon.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit
	local world = Application.main_world()
	self._world = world
	self._physics_world = World.physics_world(world)
	self._line_object = World.create_line_object(world)
	self._drawer = DebugDrawer(self._line_object, "retained")
	self._debug_text_id = nil
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)
	self._selected = false

	if RespawnBeacon._nav_info == nil then
		RespawnBeacon._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil
	self._should_debug_draw = false

	self:_reset_data()

	return true
end

RespawnBeacon.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "c_respawn_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'c_respawn_volume'"
	end

	return success, error_message
end

RespawnBeacon.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local with_traverse_logic = false
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(RespawnBeacon._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self:_generate_spawn_slots(unit)
		self:_editor_debug_draw(unit)

		self._my_nav_gen_guid = nav_gen_guid
	end

	return true
end

RespawnBeacon.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_generate_spawn_slots(unit)
	self:_editor_debug_draw(unit)
end

RespawnBeacon.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._should_debug_draw = enable

	self:_editor_debug_draw(self._unit)
end

RespawnBeacon.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object = self._line_object
	local world = self._world

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	self._line_object = nil
	self._world = nil

	if self._debug_text_id then
		Gui.destroy_text_3d(self._gui, self._debug_text_id)
	end

	local gui = self._gui

	World.destroy_gui(world, gui)
end

RespawnBeacon.editor_selection_changed = function (self, unit, selected)
	self._selected = selected

	self:_editor_debug_draw(unit)
end

RespawnBeacon._editor_debug_draw = function (self, unit)
	if self._debug_text_id then
		Gui.destroy_text_3d(self._gui, self._debug_text_id)
	end

	local drawer = self._drawer

	drawer:reset()

	if self._selected and self._should_debug_draw then
		local nav_world = RespawnBeacon._nav_info.nav_world

		if nav_world then
			local valid_positions, on_nav_positions, fitting_positions, volume_positions = self:_unbox_positions()
			local player_radius = 1
			local player_height = 2.3

			RespawnBeaconQueries.debug_draw(drawer, valid_positions, on_nav_positions, fitting_positions, volume_positions, player_radius, player_height)

			local min_num_slots = 3

			self:_draw_text(unit, string.format("Possible Respawn slots(%d)", #valid_positions), min_num_slots < #valid_positions)
		else
			self:_draw_text(unit, string.format("No Nav World. Please Bake."), false)
		end
	end

	local world = self._world

	drawer:update(world)
end

RespawnBeacon._draw_text = function (self, unit, text, success)
	local text_color = nil

	if success == true then
		text_color = Color.green()
	else
		text_color = Color.red()
	end

	local text_position = Unit.local_position(unit, 1) + Vector3.up() * 3
	local translation_matrix = Matrix4x4.from_translation(text_position)
	local text_id = Gui.text_3d(self._gui, text, FONT_MATERIAL, FONT_SIZE, FONT, translation_matrix, Vector3.zero(), 3, text_color)
	self._debug_text_id = text_id
end

RespawnBeacon._generate_spawn_slots = function (self, unit)
	self:_reset_data()

	local nav_world = RespawnBeacon._nav_info.nav_world

	if nav_world then
		local physics_world = self._physics_world
		local player_radius = 1
		local player_height = 2.3
		local valid_positions, on_nav_positions, fitting_positions, volume_positions = RespawnBeaconQueries.spawn_locations(nav_world, physics_world, unit, player_radius, player_height)

		self:_store_positions(valid_positions, on_nav_positions, fitting_positions, volume_positions)
	end
end

RespawnBeacon._store_positions = function (self, valid_positions, on_nav_positions, fitting_positions, volume_positions)
	local Vector3Box = Vector3Box
	local positions = self._valid_positions

	for i = 1, #valid_positions do
		positions[#positions + 1] = Vector3Box(valid_positions[i])
	end

	positions = self._on_nav_positions

	for i = 1, #on_nav_positions do
		positions[#positions + 1] = Vector3Box(on_nav_positions[i])
	end

	positions = self._fitting_positions

	for i = 1, #fitting_positions do
		positions[#positions + 1] = Vector3Box(fitting_positions[i])
	end

	positions = self._volume_positions

	for i = 1, #volume_positions do
		positions[#positions + 1] = Vector3Box(volume_positions[i])
	end
end

RespawnBeacon._unbox_positions = function (self)
	local vector3_unbox = Vector3Box.unbox
	local positions = self._valid_positions
	local valid_positions = {}

	for i = 1, #positions do
		valid_positions[i] = vector3_unbox(positions[i])
	end

	positions = self._on_nav_positions
	local on_nav_positions = {}

	for i = 1, #positions do
		on_nav_positions[i] = vector3_unbox(positions[i])
	end

	positions = self._fitting_positions
	local fitting_positions = {}

	for i = 1, #positions do
		fitting_positions[i] = vector3_unbox(positions[i])
	end

	positions = self._volume_positions
	local volume_positions = {}

	for i = 1, #positions do
		volume_positions[i] = vector3_unbox(positions[i])
	end

	return valid_positions, on_nav_positions, fitting_positions, volume_positions
end

RespawnBeacon._reset_data = function (self)
	self._valid_positions = {}
	self._on_nav_positions = {}
	self._fitting_positions = {}
	self._volume_positions = {}
end

RespawnBeacon.enable = function (self, unit)
	return
end

RespawnBeacon.disable = function (self, unit)
	return
end

RespawnBeacon.destroy = function (self, unit)
	return
end

RespawnBeacon.component_data = {
	side = {
		value = "heroes",
		ui_type = "combo_box",
		ui_name = "Side",
		options_keys = {
			"Heroes",
			"Villains"
		},
		options_values = {
			"heroes",
			"villains"
		}
	},
	debug_ignore_check_distances = {
		ui_type = "check_box",
		value = false,
		ui_name = "Ignore Debug Check Distances"
	},
	extensions = {
		"RespawnBeaconExtension"
	}
}

return RespawnBeacon
