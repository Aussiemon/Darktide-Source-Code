local PickupSettings = require("scripts/settings/pickup/pickup_settings")
local PickupAnimationExtension = class("PickupAnimationExtension")
PickupAnimationExtension.UPDATE_DISABLED_BY_DEFAULT = true

PickupAnimationExtension.init = function (self, extension_init_context, unit)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._owner_system = extension_init_context.owner_system
	self._pickup_animation_started = false
end

PickupAnimationExtension.setup_from_component = function (self)
	return
end

PickupAnimationExtension.start_pickup_animation = function (self, destination_unit)
	local unit = self._unit
	self._start_position = Vector3Box(Unit.world_position(unit, 1))
	self._end_unit = destination_unit
	self._timer = 0
	self._animation_speed = 1
	self._arch_height = 0

	self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)

	self._pickup_animation_started = true
	local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	if interactee_extension then
		interactee_extension:set_used()
	end
end

PickupAnimationExtension.start_place_animation = function (self, destination_unit)
	local unit = self._unit
	self._start_position = Vector3Box(Unit.world_position(unit, 1))
	self._end_unit = destination_unit
	self._timer = PickupSettings.animation_time
	self._animation_speed = -1
	self._arch_height = PickupSettings.placement_arch_height

	self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)

	local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	if interactee_extension then
		interactee_extension:set_active(false)
	end
end

PickupAnimationExtension.pickup_animation_started = function (self)
	return self._pickup_animation_started
end

PickupAnimationExtension.update = function (self, unit, dt, t)
	self._timer = self._timer + dt * self._animation_speed
	local percentage = self._timer / PickupSettings.animation_time

	if ALIVE[self._end_unit] then
		local animation_position = math.clamp(percentage, 0, 1)
		local unit_data_extension = ScriptUnit.extension(self._end_unit, "unit_data_system")
		local first_person_component = unit_data_extension:read_component("first_person")
		local start_position = Vector3Box.unbox(self._start_position)
		local end_position = Unit.world_position(self._end_unit, 1) + Vector3(0, 0, first_person_component.height + PickupSettings.target_height_offset)
		local position = Vector3.lerp(start_position, end_position, animation_position)
		position.z = position.z + self._arch_height * math.sin(percentage * math.pi)

		Unit.set_local_position(unit, 1, position)

		local scale = math.lerp(1, PickupSettings.end_scale, animation_position)

		Unit.set_local_scale(unit, 1, Vector3(scale, scale, scale))
	end

	if percentage > 1 then
		if self._is_server then
			local pickup_system = Managers.state.extension:system("pickup_system")

			pickup_system:despawn_pickup(unit)
		end

		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end

	if percentage < 0 then
		local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

		if interactee_extension then
			interactee_extension:set_active(true)
		end

		Unit.set_local_position(unit, 1, Vector3Box.unbox(self._start_position))
		Unit.set_local_scale(unit, 1, Vector3.one())
		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end
end

return PickupAnimationExtension
