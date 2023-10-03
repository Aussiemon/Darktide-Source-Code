local CoverSlots = require("scripts/extension_systems/cover/utilities/cover_slots")
local SharedNav = require("scripts/components/utilities/shared_nav")
local Cover = component("Cover")

Cover.init = function (self, unit)
	self:enable(unit)

	local cover_extension = ScriptUnit.fetch_component_extension(unit, "cover_system")

	if cover_extension then
		local cover_type = self:get_data(unit, "cover_type")
		local enabled = self:get_data(unit, "enabled")

		cover_extension:setup_from_component(cover_type, enabled)
	end
end

Cover.enable = function (self, unit)
	return
end

Cover.disable = function (self, unit)
	return
end

Cover.destroy = function (self, unit)
	return
end

Cover.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit
	local world = Application.main_world()
	self._world = world
	self._physics_world = World.physics_world(world)
	self._line_object = World.create_line_object(world)
	self._drawer = DebugDrawer(self._line_object, "retained")
	self._should_debug_draw = false

	if Cover._nav_info == nil then
		Cover._nav_info = SharedNav.create_nav_info()
	end

	self._my_nav_gen_guid = nil

	self:_reset_data()

	return true
end

Cover.editor_destroy = function (self, unit)
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
end

Cover.editor_validate = function (self, unit)
	return true, ""
end

Cover.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local with_traverse_logic = false
	local nav_gen_guid = SharedNav.check_new_navmesh_generated(Cover._nav_info, self._my_nav_gen_guid, with_traverse_logic)

	if nav_gen_guid then
		self._my_nav_gen_guid = nav_gen_guid

		self:_generate_cover_slots()
	end

	return true
end

Cover.editor_world_transform_modified = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:_generate_cover_slots()
end

Cover.editor_toggle_debug_draw = function (self, enable)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._should_debug_draw = enable
end

Cover._generate_cover_slots = function (self)
	self:_reset_data()

	local nav_world = Cover._nav_info.nav_world

	if nav_world then
		local physics_world = self._physics_world
		local unit = self._unit
		local enabled = self:get_data(unit, "enabled")
		local cover_type = self:get_data(unit, "cover_type")
		local node_positions = CoverSlots.fetch_node_positions(unit)
		local cover_slots = CoverSlots.create(physics_world, nav_world, unit, cover_type, node_positions)
		self._cover_type = cover_type
		self._enabled = enabled
		self._node_positions = node_positions
		self._cover_slots = cover_slots
	end
end

Cover._reset_data = function (self)
	self._cover_type = "high"
	self._enabled = true
	self._node_positions = {}
	self._cover_slots = {}
end

Cover.component_data = {
	cover_type = {
		value = "high",
		ui_type = "combo_box",
		ui_name = "Cover Type",
		options_keys = {
			"high",
			"low"
		},
		options_values = {
			"high",
			"low"
		}
	},
	enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Enabled"
	},
	extensions = {
		"CoverExtension"
	}
}

return Cover
