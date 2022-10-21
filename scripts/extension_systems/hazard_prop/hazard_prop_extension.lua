local HazardPropExtension = class("HazardPropExtension")
HazardPropExtension.UPDATE_DISABLED_BY_DEFAULT = true
local Explosion = require("scripts/utilities/attack/explosion")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local HazardPropSettings = require("scripts/settings/hazard_prop/hazard_prop_settings")
local explosion_settings = HazardPropSettings.explosion_settings
local fire_settings = HazardPropSettings.fire_settings
local hazard_content = HazardPropSettings.hazard_content
local hazard_material = HazardPropSettings.material
local hazard_state = HazardPropSettings.hazard_state
local TRIGGER_TIME = 3

HazardPropExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._current_state = hazard_state.idle
	self._content = hazard_content.undefined
	self._trigger_timer = 0
	self._fuse_active = false
	self._world = extension_init_context.world
	self._nav_world = extension_init_context.nav_world
	self._intact_colliders = {}
	self._broken_colliders = {}
	self._hazard_shape = nil
	self._owner_system = extension_init_context.owner_system
end

HazardPropExtension.setup_from_component = function (self, hazard_shape)
	self._hazard_shape = hazard_shape

	self:_sort_colliders()
	self:_update_mesh_visuals()
end

HazardPropExtension._sort_colliders = function (self)
	local unit = self._unit
	local intact_colliders = self._intact_colliders
	local intact_collider_names = HazardPropSettings.intact_colliders[self._hazard_shape]

	for i = 1, #intact_collider_names do
		intact_colliders[#intact_colliders + 1] = Unit.actor(unit, intact_collider_names[i])
	end

	local broken_colliders = self._broken_colliders
	local broken_collider_names = HazardPropSettings.broken_colliders[self._hazard_shape]

	for i = 1, #broken_collider_names do
		broken_colliders[#broken_colliders + 1] = Unit.actor(unit, broken_collider_names[i])
	end
end

HazardPropExtension.hot_join_sync = function (self, state, content)
	self:set_current_state(state)
	self:set_content(content)
end

HazardPropExtension.content = function (self)
	return self._content
end

HazardPropExtension.set_content = function (self, content)
	if self._content ~= hazard_content.undefined and self._is_server then
		Log.error("HazardPropExtension", "[set_content][Unit: %s] Hazard already has content: %s, changed to: %s", Unit.id_string(self._unit), self._content, content)
	end

	if content == hazard_content.none then
		Unit.set_material(self._unit, "hazard_paint", hazard_material.empty_paint)
		Unit.flow_event(self._unit, "lua_content_set_none")
	elseif content == hazard_content.explosion then
		Unit.set_material(self._unit, "hazard_paint", hazard_material.explosion_paint)
		Unit.set_material(self._unit, "hazard_il", hazard_material.explosion_il)
		Unit.flow_event(self._unit, "lua_content_set_explosion")
	elseif content == hazard_content.fire then
		Unit.set_material(self._unit, "hazard_paint", hazard_material.fire_paint)
		Unit.set_material(self._unit, "hazard_il", hazard_material.fire_il)
		Unit.flow_event(self._unit, "lua_content_set_fire")
	elseif content == hazard_content.gas then
		Unit.set_material(self._unit, "hazard_paint", hazard_material.gas_paint)
		Unit.set_material(self._unit, "hazard_il", hazard_material.gas_il)
		Unit.flow_event(self._unit, "lua_content_set_gas")
	else
		Log.error("HazardPropExtension", "[set_content][Unit: %s] set the hazard prop to unknown content: %s", Unit.id_string(self._unit), content)
	end

	self._content = content

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local content_id = NetworkLookup.hazard_prop_content[content]
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_hazard_prop_set_content", unit_level_index, content_id)
	end
end

HazardPropExtension.inactivate = function (self)
	local health_extension = ScriptUnit.extension(self._unit, "health_system")

	health_extension:set_unkillable(false)
	health_extension:set_dead()
end

HazardPropExtension.current_state = function (self)
	return self._current_state
end

HazardPropExtension.set_current_state = function (self, state)
	local old_state = self._current_state
	local unit = self._unit
	self._current_state = state

	if state == hazard_state.triggered then
		if old_state == hazard_state.idle then
			if not self._fuse_active then
				Unit.flow_event(unit, "lua_fuse_start")

				self._fuse_active = true
			end

			if self._is_server then
				self:start_trigger_timer()
				self._owner_system:enable_update_function(self.__class_name, "update", unit, self)
			end
		end
	elseif state == hazard_state.broken then
		if self._fuse_active then
			Unit.flow_event(unit, "lua_fuse_stop")

			self._fuse_active = false
		end

		if self._is_server then
			self:_trigger_hazard()
			self._owner_system:disable_update_function(self.__class_name, "update", unit, self)
		end

		self._content = hazard_content.none

		Unit.set_material(unit, "hazard_paint", hazard_material.empty_paint)
	end

	self:_update_mesh_visuals()

	if self._is_server then
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local state_id = NetworkLookup.hazard_prop_states[state]
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_hazard_prop_set_state", unit_level_index, state_id)
	end
end

HazardPropExtension._update_mesh_visuals = function (self)
	local intact = self._current_state ~= hazard_state.broken
	local unit = self._unit

	Unit.set_visibility(unit, "intact", intact)
	Unit.set_visibility(unit, "broken", not intact)

	local intact_colliders = self._intact_colliders

	for ii = 1, #intact_colliders do
		Actor.set_scene_query_enabled(intact_colliders[ii], intact)
	end

	local broken_colliders = self._broken_colliders

	for ii = 1, #broken_colliders do
		Actor.set_scene_query_enabled(broken_colliders[ii], not intact)
	end
end

HazardPropExtension.damage = function (self, damage_amount, hit_actor, attack_direction)
	if not self._is_server or self._content == hazard_content.none then
		return
	end

	if self._current_state == hazard_state.idle then
		self:set_current_state(hazard_state.triggered)
	elseif self._current_state == hazard_state.triggered then
		self:set_current_state(hazard_state.exploding)
	end
end

HazardPropExtension._trigger_hazard = function (self)
	local content = self._content
	local unit = self._unit

	if content == hazard_content.explosion then
		local world = Managers.world:world("level_world")
		local physics_world = World.physics_world(world)
		local explosion_position = Unit.world_position(unit, Unit.node(unit, "c_explosion"))
		local explosion_template = explosion_settings.explosion_template
		local power_level = explosion_settings.power_level
		local charge_level = explosion_settings.charge_level
		local attack_type = explosion_settings.explosion

		Explosion.create_explosion(self._world, physics_world, explosion_position, Vector3.up(), unit, explosion_template, power_level, charge_level, attack_type)
	elseif content == hazard_content.fire then
		local world = Managers.world:world("level_world")
		local physics_world = World.physics_world(world)
		local explosion_position = Unit.world_position(unit, Unit.node(unit, "c_explosion"))
		local explosion_template = fire_settings.explosion_template
		local liquid_area_template = fire_settings.liquid_area_template
		local power_level = fire_settings.power_level
		local charge_level = fire_settings.charge_level
		local attack_type = fire_settings.explosion

		Explosion.create_explosion(self._world, physics_world, explosion_position, Vector3.up(), unit, explosion_template, power_level, charge_level, attack_type)

		for ii = 1, fire_settings.fire_node_count do
			local node_position = Unit.world_position(unit, Unit.node(unit, "c_fire" .. ii))
			local los_hit, hit_position, _, _ = PhysicsWorld.raycast(physics_world, node_position, Vector3.down(), fire_settings.raycast_distance, "closest", "collision_filter", "filter_player_mover")

			if los_hit then
				node_position = hit_position
			end

			LiquidArea.try_create(node_position, Vector3.down(), self._nav_world, liquid_area_template, unit)
		end
	end
end

HazardPropExtension.trigger_timer = function (self)
	return self._trigger_timer
end

HazardPropExtension.start_trigger_timer = function (self)
	self._trigger_timer = TRIGGER_TIME
end

HazardPropExtension.update = function (self, unit, dt, t)
	if self._current_state == hazard_state.triggered then
		if self._is_server and self._trigger_timer > 0 then
			self._trigger_timer = self._trigger_timer - dt

			if self._trigger_timer <= 0 then
				self:set_current_state(hazard_state.exploding)
			end
		end
	elseif self._current_state == hazard_state.exploding and self._is_server then
		self:set_current_state(hazard_state.broken)
	end
end

return HazardPropExtension
