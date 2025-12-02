-- chunkname: @scripts/components/breach_charge_addon.lua

local BreachChargeAddon = component("BreachChargeAddon")
local LevelProps = require("scripts/settings/level_prop/level_props")
local CameraShake = require("scripts/utilities/camera/camera_shake")
local Component = require("scripts/utilities/component")
local RPC_FLOW_EVENTS = {
	"remove",
	"interactable_disable",
}

local function index_of(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return i
		end
	end

	return nil
end

BreachChargeAddon.init = function (self, unit, is_server)
	if not self:get_data(unit, "is_charge_enabled") then
		return false
	end

	self._unit = unit
	self._is_server = is_server
	self._delay = nil

	local duration = 3
	local networked_timer_extension = ScriptUnit.fetch_component_extension(unit, "networked_timer_system")

	networked_timer_extension:setup_from_component(duration, "loc_description", 1)

	self._networked_timer_extension = networked_timer_extension

	if self._is_server then
		self._breach_charge_units = {}

		local resource = self:get_data(unit, "unit_resource")
		local node_options = self:get_data(unit, "node_options")

		if node_options == "a_b" or node_options == "a" then
			local node_a = Unit.node(unit, "bca_charge_node_A")

			self:_spawn_breach_charge(resource, node_a)
		end

		if node_options == "a_b" or node_options == "b" then
			local node_b = Unit.node(unit, "bca_charge_node_B")

			self:_spawn_breach_charge(resource, node_b)
		end
	end
end

BreachChargeAddon._spawn_breach_charge = function (self, resource, node_index)
	local position = Unit.world_position(self._unit, node_index)
	local rotation = Unit.world_rotation(self._unit, node_index)
	local props_settings = LevelProps.breach_charge
	local unit_spawner_manager = Managers.state.unit_spawner
	local breach_charge_unit, _ = unit_spawner_manager:spawn_network_unit(resource, "level_prop", position, rotation, nil, props_settings)
	local interactee_extension = ScriptUnit.has_extension(breach_charge_unit, "interactee_system")

	if interactee_extension then
		interactee_extension._trigger_flow_event = function (interactee_extension, event_name)
			Unit.flow_event(interactee_extension._unit, event_name)

			if event_name == "lua_interaction_success_network_synced" then
				self._networked_timer_extension:start()
			end
		end

		self._breach_charge_units[#self._breach_charge_units + 1] = breach_charge_unit
	end
end

BreachChargeAddon.lua_timer_finished = function (self)
	if self._is_server then
		for i = 1, #self._breach_charge_units do
			local breach_charge_unit = self._breach_charge_units[i]
			local unit_id = Managers.state.unit_spawner:game_object_id(breach_charge_unit)

			Component.trigger_event_on_clients(self, "trigger_flow_on_unit", "rpc_trigger_flow_on_unit", unit_id, index_of(RPC_FLOW_EVENTS, "remove"))
			Component.trigger_event_on_clients(self, "trigger_flow_on_unit", "rpc_trigger_flow_on_unit", unit_id, index_of(RPC_FLOW_EVENTS, "interactable_disable"))
			Unit.flow_event(breach_charge_unit, "interactable_disable")
			Unit.flow_event(breach_charge_unit, "remove")
		end
	end

	Unit.flow_event(self._unit, "breach_charge_wall_destruct")

	local unit = self._unit
	local world = Unit.world(unit)
	local node = Unit.node(unit, "bca_particle_effect_node")
	local world_position = Unit.world_position(unit, node)
	local world_rotation = Unit.world_rotation(unit, node)
	local world_scale = Unit.world_scale(unit, node)

	if self:get_data(unit, "use_particle_effect") then
		local particle_name = self:get_data(unit, "particle_effect_resource")

		World.create_particles(world, particle_name, world_position, world_rotation, world_scale)
	end

	if self:get_data(unit, "use_wwise_event") then
		local wwise_event_name = self:get_data(unit, "wwise_event_resource")
		local wwise_world = Managers.world:wwise_world(world)
		local source_id = WwiseWorld.make_auto_source(wwise_world, world_position)

		WwiseWorld.trigger_resource_event(wwise_world, wwise_event_name, source_id)
	end

	if self:get_data(unit, "use_camera_shake") then
		local near_distance = 8
		local far_distance = 16
		local near_scale = 1
		local far_scale = 0.5

		CameraShake.camera_shake_by_distance("breach_charge_explosion", world_position, near_distance, far_distance, near_scale, far_scale)
	end
end

BreachChargeAddon.events.trigger_flow_on_unit = function (self, game_object_id, event_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit = unit_spawner_manager:unit(game_object_id)
	local event_name = RPC_FLOW_EVENTS[event_id]

	Unit.flow_event(unit, event_name)
end

BreachChargeAddon.enable = function (self, unit)
	return
end

BreachChargeAddon.disable = function (self, unit)
	return
end

BreachChargeAddon.destroy = function (self, unit)
	if self._is_server then
		local breach_charge_units = self._breach_charge_units

		if breach_charge_units ~= nil then
			local unit_spawner_manager = Managers.state.unit_spawner

			for i = 1, #breach_charge_units do
				local breach_charge_unit = breach_charge_units[i]

				unit_spawner_manager:mark_for_deletion(breach_charge_unit)
			end
		end
	end
end

BreachChargeAddon.component_data = {
	is_charge_enabled = {
		ui_name = "Enabled",
		ui_type = "check_box",
		value = false,
	},
	node_options = {
		ui_name = "Node Options",
		ui_type = "combo_box",
		value = "a_b",
		options_keys = {
			"A & B",
			"A",
			"B",
		},
		options_values = {
			"a_b",
			"a",
			"b",
		},
	},
	unit_resource = {
		filter = "unit",
		preview = false,
		ui_name = "Unit Resource",
		ui_type = "resource",
		value = "",
	},
	misc_unit_resource = {
		filter = "unit",
		preview = false,
		ui_name = "Misc Unit Resource",
		ui_type = "resource",
		value = "",
	},
	use_particle_effect = {
		ui_name = "Use Particle Effect",
		ui_type = "check_box",
		value = true,
	},
	particle_effect_resource = {
		filter = "particles",
		preview = false,
		ui_name = "Particle Effect Resource",
		ui_type = "resource",
		value = "",
	},
	use_wwise_event = {
		ui_name = "Use Wwise Event",
		ui_type = "check_box",
		value = true,
	},
	wwise_event_resource = {
		filter = "wwise_event",
		preview = false,
		ui_name = "Wwise Event Resource",
		ui_type = "resource",
		value = "",
	},
	use_camera_shake = {
		ui_name = "Use Camera Shake",
		ui_type = "check_box",
		value = true,
	},
	inputs = {
		lua_timer_finished = {
			accessibility = "private",
			type = "event",
		},
	},
}

return BreachChargeAddon
