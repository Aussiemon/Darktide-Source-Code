-- chunkname: @scripts/extension_systems/predicted_unit_spawner/predicted_unit_extension.lua

local PredictedUnitExtension = class("PredictedUnitExtension")

PredictedUnitExtension.UPDATE_DISABLED_BY_DEFAULT = true

PredictedUnitExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._owner_system = extension_init_context.owner_system
	self._owner_peer_id = extension_init_data.owner_peer_id
	self._owner_local_player_id = extension_init_data.owner_local_player_id
	self._action_component_name = extension_init_data.action_component_name
	self._action_component_context_id = extension_init_data.action_component_context_id
	self._resolve_position = nil
	self._resolve_rotation = nil
	self._consumed = false
	self._start_job_on_resolve = extension_init_data.start_job_on_resolve
	self._unit_tbl = {
		unit,
	}
	self._sfx_played = false
	self._sfx = extension_init_data.sfx or {}
	self._fx_system = Managers.state.extension:system("fx_system")

	if not DEDICATED_SERVER then
		Unit.take_visibility_snapshot(self._unit_tbl)
		Unit.set_unit_visibility(unit, false, true)
	end
end

PredictedUnitExtension.extensions_ready = function (self)
	self:_set_updates_enabled(false)
end

PredictedUnitExtension.owner_peer_id = function (self)
	return self._owner_peer_id
end

PredictedUnitExtension.owner_local_player_id = function (self)
	return self._owner_local_player_id
end

PredictedUnitExtension.action_component_name = function (self)
	return self._action_component_name
end

PredictedUnitExtension.action_component_context_id = function (self)
	return self._action_component_context_id
end

PredictedUnitExtension.server_consumed = function (self, position, rotation)
	Unit.set_local_position(self._unit, 1, position)
	Unit.set_local_rotation(self._unit, 1, rotation)

	if not DEDICATED_SERVER then
		Unit.restore_visibility_snapshot(self._unit_tbl)
	end

	self._consumed = true

	self:_set_updates_enabled(true)

	if self._sfx.on_resolve then
		self._fx_system:trigger_wwise_event(self._sfx.on_resolve, nil, self._unit)
	end

	if self._start_job_on_resolve then
		Managers.state.unit_job:start_registered_job(self._unit)
	end
end

PredictedUnitExtension.client_consumed = function (self, position, rotation)
	Unit.set_local_position(self._unit, 1, position)
	Unit.set_local_rotation(self._unit, 1, rotation)
	Unit.restore_visibility_snapshot(self._unit_tbl)

	self._consumed = true

	self:_try_start_update()
end

PredictedUnitExtension.consumed = function (self)
	return self._consumed
end

PredictedUnitExtension.client_unconsume = function (self)
	if self._consumed then
		self:_try_stop_update()

		self._consumed = false

		Unit.take_visibility_snapshot(self._unit_tbl)
		Unit.set_unit_visibility(self._unit, false, true)
	end
end

PredictedUnitExtension.resolve_transform = function (self, wanted_position, wanted_rotation)
	self._resolve_position = Vector3Box(wanted_position)
	self._resolve_rotation = QuaternionBox(wanted_rotation)

	Unit.restore_visibility_snapshot(self._unit_tbl)
	self:_try_start_update()
	self:_set_updates_enabled(true)

	if self._start_job_on_resolve then
		Managers.state.unit_job:start_registered_job(self._unit)
	end
end

PredictedUnitExtension.resolved_transform = function (self)
	return self._resolve_position, self._resolve_rotation
end

PredictedUnitExtension.update = function (self, unit, dt, t)
	local wanted_position = self._resolve_position:unbox()
	local wanted_rotation = self._resolve_rotation:unbox()
	local SPEED = 0.2
	local ANGULAR_SPEED = 0.2
	local diff = wanted_position - Unit.local_position(self._unit, 1)
	local distance = Vector3.length(diff)
	local angle = Quaternion.angle(Unit.local_rotation(self._unit, 1), wanted_rotation)
	local movement_this_frame = SPEED * dt
	local rotation_this_frame = ANGULAR_SPEED * dt

	if distance <= movement_this_frame and angle <= rotation_this_frame then
		Unit.set_local_position(self._unit, 1, wanted_position)
		Unit.set_local_rotation(self._unit, 1, wanted_rotation)
		self._owner_system:disable_update_function(self._unit, "update")

		return
	end

	Unit.set_local_position(self._unit, 1, Unit.local_position(self._unit, 1) + Vector3.normalize(wanted_position - Unit.local_position(self._unit, 1)) * movement_this_frame)

	if angle > math.kinda_small then
		Unit.set_local_rotation(self._unit, 1, Quaternion.lerp(Unit.local_rotation(self._unit, 1), wanted_rotation, rotation_this_frame / angle))
	end
end

PredictedUnitExtension._try_start_update = function (self)
	if self._consumed and self._resolve_position then
		self._owner_system:enable_update_function(self._unit, "update")
	end
end

PredictedUnitExtension._try_stop_update = function (self)
	if not self._consumed or not self._resolve_position then
		self._owner_system:disable_update_function(self._unit, "update")
	end
end

PredictedUnitExtension._set_updates_enabled = function (self, enabled)
	local extension_manager = Managers.state.extension
	local extensions = ScriptUnit.extensions(self._unit)

	for system_name, extension in pairs(extensions) do
		if extension.__class_name then
			local system = extension_manager:system(system_name)

			if enabled then
				system:enable_update_functions(self._unit, "PredictedUnitExtension_Pre_Resolve")
			else
				system:disable_update_functions(self._unit, "PredictedUnitExtension_Pre_Resolve")
			end
		end
	end
end

PredictedUnitExtension.destroy = function (self)
	if not DEDICATED_SERVER and self._sfx.on_destroy then
		self._fx_system:trigger_wwise_event(self._sfx.on_destroy, nil, self._unit)
	end
end

return PredictedUnitExtension
