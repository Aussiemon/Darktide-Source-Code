-- chunkname: @scripts/extension_systems/health_station/health_station_extension.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local HealthStationExtension = class("HealthStationExtension")

HealthStationExtension.MAX_CHARGES = 4

HealthStationExtension.init = function (self, extension_init_context, unit)
	self._unit = unit
	self._world = extension_init_context.world
	self._is_server = extension_init_context.is_server
	self._charge_amount = 0
	self._health_per_charge = 0
	self._use_distribution_pool = true
	self._socket_prop = ""
	self._luggable_socket_extension = nil
	self._pickup_spawner_extension = nil
	self._animation_extension = nil
	self._socket_unit = nil
	self._battery_unit = nil
	self._battery_spawning_mode = "none"
	self._first_frame_setup = false
	self._point_of_interest_extension = nil
	self._interactee_extension = nil
end

HealthStationExtension.destroy = function (self)
	self:unspawn_battery()
	self:_unspawn_socket()
end

HealthStationExtension.setup_from_component = function (self, start_charge_amount, health_per_charge, use_distribution_pool, socket_prop, battery_spawning_mode)
	local unit = self._unit

	self._use_distribution_pool = use_distribution_pool
	self._socket_prop = socket_prop
	self._battery_spawning_mode = battery_spawning_mode
	self._health_per_charge = health_per_charge
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._pickup_spawner_extension = ScriptUnit.extension(unit, "pickup_system")
	self._point_of_interest_extension = ScriptUnit.extension(unit, "point_of_interest_system")
	self._interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	if battery_spawning_mode == "plugged" and not use_distribution_pool then
		self:set_charge_amount(start_charge_amount)
	else
		self:set_charge_amount(0)
	end
end

HealthStationExtension.hot_join_sync = function (self, charge_amount, socket_unit, battery_unit)
	if socket_unit then
		self:register_socket_unit(socket_unit)
	end

	if battery_unit then
		self:register_battery_unit(battery_unit)
	end

	self:set_charge_amount(charge_amount)
	self:sync_animations()
end

HealthStationExtension.sync_animations = function (self)
	if not self:battery_in_slot() then
		return
	end

	local charges = self:charge_amount()

	if charges > 0 then
		Unit.flow_event(self._unit, "sfx_open_finish")
	else
		Unit.flow_event(self._unit, "sfx_close_finish")
	end
end

HealthStationExtension.fixed_update = function (self, unit, dt, t)
	if self._is_server then
		self:_check_battery_alive()

		if not self._first_frame_setup then
			self:_spawn_socket()

			local battery_spawning_mode = self._battery_spawning_mode
			local should_plug = battery_spawning_mode == "plugged"
			local should_spawn = should_plug or battery_spawning_mode == "pickup_location"

			if self._use_distribution_pool then
				should_plug = battery_spawning_mode == "plugged_with_charge" and self._plug_from_distribution
				should_spawn = true
			end

			if should_spawn then
				self:spawn_battery()
			end

			if should_plug then
				self:_teleport_battery_to_socket()
				self:socket_luggable(self._battery_unit)
				self:_update_indicators()
			end

			self._first_frame_setup = true
		elseif not self:battery_in_slot() then
			local socket_ext = self._luggable_socket_extension
			local has_overlap, luggable_unit = socket_ext:is_overlapping_with_luggable()

			if has_overlap then
				self:socket_luggable(luggable_unit)
			end
		end
	end
end

HealthStationExtension.start_healing = function (self)
	self:play_anim("heal")
end

HealthStationExtension.stop_healing = function (self, success)
	if success then
		self:use_charge()
	end

	if self._charge_amount == 1 then
		Unit.flow_event(self._unit, "one_charge_left")
	end

	if self._charge_amount == 0 then
		self:play_anim("close")
	else
		self:play_anim("idle")
	end
end

HealthStationExtension.use_charge = function (self)
	local current_charge = self._charge_amount
	local new_charge = current_charge - 1

	new_charge = math.clamp(new_charge, 0, HealthStationExtension.MAX_CHARGES)

	if current_charge ~= new_charge then
		self:set_charge_amount(new_charge)

		if self._charge_amount <= 0 then
			self._point_of_interest_extension:set_tag("empty_health_station")
		end
	end

	if self._is_server then
		local station_level_id = Managers.state.unit_spawner:level_index(self._unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_health_station_use", station_level_id)
	end
end

HealthStationExtension.battery_in_slot = function (self)
	if self._luggable_socket_extension and Unit.alive(self._socket_unit) then
		return self._luggable_socket_extension:is_occupied()
	end

	return false
end

HealthStationExtension.charge_amount = function (self)
	return self._charge_amount
end

HealthStationExtension.use_distribution_pool = function (self)
	return self._use_distribution_pool
end

HealthStationExtension.battery_spawning_mode = function (self)
	return self._battery_spawning_mode
end

HealthStationExtension.max_amount_charges = function (self)
	return self._max_amount_charges
end

HealthStationExtension.assign_distributed_charge = function (self, charges, plug)
	self._distributed_charges = charges
	self._plug_from_distribution = plug
end

HealthStationExtension.track_for_telemetry = function (self, charges, plug)
	local data = {
		charges = charges,
		has_battery = plug
	}

	Managers.telemetry_events:health_station_spawned(self._unit, data)
end

HealthStationExtension.set_charge_amount = function (self, charges)
	self._charge_amount = charges

	self:_update_indicators()

	local point_of_interest_ext = self._point_of_interest_extension

	if self._charge_amount <= 0 then
		if self:battery_in_slot() then
			self:_set_block_text(nil)
			point_of_interest_ext:set_tag("empty_health_station")
		else
			self:_set_block_text("loc_health_station_missing_battery")
			point_of_interest_ext:set_tag("chargeable_health_station")
		end
	else
		self:_set_block_text(nil)
		point_of_interest_ext:set_tag("charged_health_station")
	end
end

HealthStationExtension._set_block_text = function (self, text)
	if self._interactee_extension then
		self._interactee_extension:set_block_text(text)
	end
end

HealthStationExtension.play_anim = function (self, anim_event)
	self._animation_extension:anim_event(anim_event)
end

HealthStationExtension.sync_charge_amount = function (self)
	local station_level_id = Managers.state.unit_spawner:level_index(self._unit)
	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_health_station_sync_charges", station_level_id, self._charge_amount)
end

HealthStationExtension.health_per_charge = function (self)
	return self._health_per_charge
end

HealthStationExtension._update_indicators = function (self)
	if not self:battery_in_slot() then
		Unit.set_scalar_for_materials(self._unit, "increase_color", -0.95)
	else
		local min_indicator_material = -1
		local max_indicator_material = 0.01
		local alpha = 1 - (HealthStationExtension.MAX_CHARGES - self._charge_amount) / HealthStationExtension.MAX_CHARGES
		local indicator_level = math.lerp(min_indicator_material, max_indicator_material, alpha)

		Unit.set_scalar_for_materials(self._unit, "increase_color", indicator_level)

		if self._charge_amount == 0 then
			Light.set_enabled(Unit.light(self._battery_unit, 1), false)
			Unit.set_scalar_for_materials(self._battery_unit, "emissive_multiplier", 0)
		end
	end
end

HealthStationExtension._spawn_socket = function (self)
	local unit = self._unit
	local socket_node = Unit.node(unit, "g_battery_socket")
	local socket_position = Unit.world_position(unit, socket_node)
	local socket_rotation = Unit.world_rotation(unit, socket_node)
	local socket_prop = self._socket_prop
	local props_settings = LevelProps[socket_prop]
	local socket_unit_name = props_settings.unit_name
	local unit_spawner_manager = Managers.state.unit_spawner
	local spawn_offset_boxed = props_settings.spawn_offset

	if spawn_offset_boxed then
		local spawn_offset = spawn_offset_boxed:unbox()
		local socket_pose = Unit.world_pose(unit, socket_node)

		socket_position = Matrix4x4.transform(socket_pose, spawn_offset)
	end

	local socket_unit, socket_unit_go_id = unit_spawner_manager:spawn_network_unit(socket_unit_name, "level_prop", socket_position, socket_rotation, nil, props_settings)

	self:register_socket_unit(socket_unit)

	local station_level_id = Managers.state.unit_spawner:level_index(self._unit)
	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_health_station_on_socket_spawned", station_level_id, socket_unit_go_id)
end

HealthStationExtension._unspawn_socket = function (self)
	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local socket_unit = self._socket_unit

		if socket_unit then
			unit_spawner_manager:mark_for_deletion(socket_unit)
		end
	end
end

HealthStationExtension.socket_unit = function (self)
	return self._socket_unit
end

local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

HealthStationExtension.socket_luggable = function (self, luggable_unit)
	self._luggable_socket_extension:socket_luggable(luggable_unit)

	if self._battery_spawning_mode ~= "plugged" then
		self:set_charge_amount(self._use_distribution_pool and self._distributed_charges or HealthStationExtension.MAX_CHARGES)
		self:sync_charge_amount()
	end

	local charges = self:charge_amount()

	if charges > 0 then
		local game_mode_name = Managers.state.game_mode:game_mode_name()

		if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
			Managers.event:trigger("tg_on_health_station_activated")
		end

		self:play_anim("open")
	end
end

HealthStationExtension.battery_unit = function (self)
	return self._battery_unit
end

HealthStationExtension.spawn_battery = function (self)
	if self._is_server and self._battery_unit == nil then
		local battery_unit, battery_id = self._pickup_spawner_extension:spawn_item()
		local battery_is_level_unit = false

		self:register_battery_unit(battery_unit)

		local point_of_interest_ext = self._point_of_interest_extension

		if self._charge_amount <= 0 then
			if self:battery_in_slot() then
				point_of_interest_ext:set_tag("empty_health_station")
			else
				point_of_interest_ext:set_tag("chargeable_health_station")
			end
		else
			point_of_interest_ext:set_tag("charged_health_station")
		end

		local station_level_id = Managers.state.unit_spawner:level_index(self._unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_health_station_on_battery_spawned", station_level_id, battery_id, battery_is_level_unit)
	end
end

HealthStationExtension.unspawn_battery = function (self)
	if self._is_server then
		self:_check_battery_alive()

		if self._battery_unit ~= nil then
			local battery_unit = self._battery_unit

			self._pickup_spawner_extension:despawn_item(battery_unit)

			self._battery_unit = nil
		end
	end
end

HealthStationExtension._check_battery_alive = function (self)
	if self._battery_unit ~= nil and not ALIVE[self._battery_unit] then
		self._battery_unit = nil
	end
end

HealthStationExtension._teleport_battery_to_socket = function (self)
	local unit = self._unit
	local socket_node = Unit.node(unit, "g_battery_socket")
	local socket_position = Unit.world_position(unit, socket_node)
	local socket_rotation = Unit.world_rotation(unit, socket_node)
	local battery_unit = self._battery_unit
	local projectile_locomotion_extension = ScriptUnit.extension(battery_unit, "locomotion_system")

	projectile_locomotion_extension:switch_to_sleep(socket_position, socket_rotation)
end

HealthStationExtension.register_socket_unit = function (self, socket_unit)
	self._socket_unit = socket_unit
	self._luggable_socket_extension = ScriptUnit.extension(socket_unit, "luggable_socket_system")
end

HealthStationExtension.register_battery_unit = function (self, battery_unit)
	self._battery_unit = battery_unit
end

return HealthStationExtension
