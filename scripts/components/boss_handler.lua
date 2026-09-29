-- chunkname: @scripts/components/boss_handler.lua

local Component = require("scripts/utilities/component")
local BossHandler = component("BossHandler")
local CLIENT_RPCS = {}
local SERVER_RPCS = {
	"rpc_boss_handler_start_boss_encounter",
}

BossHandler.init = function (self, unit, is_server, nav_world)
	if not is_server then
		return
	end

	self._template_name = self:get_data(unit, "template")

	if not self._template_name then
		Log.exception("Boss Handler", "No template defined in this component.")
	end

	local BossHandlerTemplates = require("scripts/managers/pacing/bosses/boss_templates")
	local template = BossHandlerTemplates[self._template_name]

	self._template = template
	self._unit = unit
	self._phase_event_args_table = {}

	local run_update = true

	self._scratchpad = {
		phase = 0,
		positions = {},
	}
	self._scratchpad.boss_handler = self
	self._scratchpad.phase_event_args_table = {}

	if template.setup then
		template:setup()
	end

	return run_update
end

BossHandler.destroy = function (self)
	local template = self._template

	if template and template.teardown then
		template:teardown()
	end
end

BossHandler._get_all_positions = function (self)
	local component_system = Managers.state.extension:system("component_system")
	local boss_handler_positions = component_system:get_units_from_component_name("BossHandlerPosition")

	if #boss_handler_positions == 0 then
		Log.exception("Boss Handler", "No BossHandlerPosition components found in the level.")
	else
		for i = 1, #boss_handler_positions do
			local boss_handler_position_unit = boss_handler_positions[i]
			local components = Component.get_components_by_name(boss_handler_position_unit, "BossHandlerPosition")

			for ii = 1, #components do
				local component = components[ii]
				local component_data = component:get_position_data()
				local position = component_data.position
				local name = component_data.name

				self._scratchpad.positions[name] = Vector3Box(position)
			end
		end
	end
end

BossHandler.start_boss_encounter = function (self)
	if not self.is_server then
		return
	end

	if not self._boss_started then
		self:_get_all_positions()

		local scratchpad = self._scratchpad
		local boss_extension = self._template:init(scratchpad, self)

		boss_extension:set_boss_handler(self)

		self._boss_started = true
	end
end

BossHandler.boss_unit_or_nil = function (self)
	local boss_unit = self._scratchpad.boss_unit

	return boss_unit
end

BossHandler.reset_boss_encounter = function (self)
	if not self.is_server then
		return
	end

	if self.boss_started then
		self._template:cleanup(self._scratchpad)
	end

	if HEALTH_ALIVE[self._scratchpad.boss_unit] then
		Managers.state.minion_spawn:despawn_minion(self._scratchpad.boss_unit)
	end

	self._boss_started = nil

	local positions = table.clone(self._scratchpad.positions)

	self._scratchpad = {
		phase = 0,
		positions = positions,
		boss_handler = self,
	}
end

BossHandler.update = function (self, unit, dt, t)
	if not self.is_server then
		return
	end

	local boss_started = self._boss_started
	local scratchpad = self._scratchpad
	local boss_unit = self._scratchpad.boss_unit

	if boss_started and boss_unit and HEALTH_ALIVE[boss_unit] then
		self._template:update(scratchpad, unit, dt, t)
	elseif boss_unit and not HEALTH_ALIVE[boss_unit] then
		self:_boss_dead()
		self._template:update(scratchpad, unit, dt, t)
	end

	local keep_update = true

	return keep_update
end

BossHandler.get_phase_event_args_table = function (self)
	table.clear(self._phase_event_args_table)

	return self._phase_event_args_table
end

BossHandler.on_phase_event_triggered = function (self, event_name, phase_event_args_table_or_nil)
	local valid_args = phase_event_args_table_or_nil == self._phase_event_args_table or phase_event_args_table_or_nil == nil

	self._template:on_phase_event_triggered(self._scratchpad, event_name, phase_event_args_table_or_nil)
end

BossHandler.get_current_phase_indentifier = function (self)
	local scratchpad = self._scratchpad
	local current_phase = scratchpad.phase
	local phase_lookup = scratchpad.phase_lookup
	local phase_indentifier = phase_lookup[current_phase]

	return phase_indentifier
end

BossHandler.current_phase_data = function (self)
	return self._scratchpad.current_phase_action_data
end

BossHandler.get_scratchpad = function (self)
	return self._scratchpad
end

BossHandler._boss_dead = function (self)
	self._boss_started = false

	self._template:cleanup(self._scratchpad)
end

BossHandler._phase_change = function (self)
	Unit.flow_event(self._unit, "lua_phase_change")
end

BossHandler.enable = function (self, unit)
	return
end

BossHandler.disable = function (self, unit)
	return
end

BossHandler.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local world = Application.main_world()

	self._world = world

	local line_object = World.create_line_object(world)

	self._line_object = line_object
	self._drawer = DebugDrawer(line_object, "retained")
	self._gui = World.create_world_gui(world, Matrix4x4.identity(), 1, 1)

	return true
end

BossHandler.editor_validate = function (self, unit)
	return BossHandler, ""
end

BossHandler.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local line_object = self._line_object
	local world = self._world
	local gui = self._gui

	LineObject.reset(line_object)
	LineObject.dispatch(world, line_object)
	World.destroy_line_object(world, line_object)

	if self._debug_text_id then
		Gui.destroy_text_3d(gui, self._debug_text_id)
	end

	if self._section_debug_text_id then
		Gui.destroy_text_3d(gui, self._section_debug_text_id)
	end

	World.destroy_gui(world, gui)

	self._line_object = nil
	self._world = nil
end

BossHandler.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

BossHandler.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

BossHandler.component_data = {
	template = {
		ui_name = "template",
		ui_type = "combo_box",
		value = "",
		options_keys = {
			"psyker_boss",
		},
		options_values = {
			"psyker_boss",
		},
	},
	inputs = {
		start_boss_encounter = {
			accessibility = "public",
			type = "event",
		},
		reset_boss_encounter = {
			accessibility = "public",
			type = "event",
		},
	},
}

return BossHandler
