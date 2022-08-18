require("scripts/extension_systems/attack_intensity/minion_attack_intensity_extension")
require("scripts/extension_systems/attack_intensity/player_unit_attack_intensity_extension")

local AttackIntensitySystem = class("AttackIntensitySystem", "ExtensionSystemBase")

AttackIntensitySystem.init = function (self, extension_system_creation_context, ...)
	AttackIntensitySystem.super.init(self, extension_system_creation_context, ...)

	self._minion_attack_intensity_extension_data = {}
	self._player_attack_intensity_extension_data = {}
	self._num_minion_extensions = 0
end

AttackIntensitySystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = AttackIntensitySystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	return extension
end

AttackIntensitySystem.register_extension_update = function (self, unit, extension_name, extension)
	AttackIntensitySystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension_name == "MinionAttackIntensityExtension" then
		self._minion_attack_intensity_extension_data[unit] = extension
		self._num_minion_extensions = self._num_minion_extensions + 1
	elseif extension_name == "PlayerUnitAttackIntensityExtension" then
		self._player_attack_intensity_extension_data[unit] = extension
	end
end

AttackIntensitySystem.on_remove_extension = function (self, unit, extension_name)
	if unit == self._current_update_unit then
		local current_update_unit, current_update_extension = next(self._minion_attack_intensity_extension_data, unit)
		self._current_update_unit = current_update_unit
		self._current_update_extension = current_update_extension
	end

	if extension_name == "MinionAttackIntensityExtension" then
		self._minion_attack_intensity_extension_data[unit] = nil
		self._num_minion_extensions = self._num_minion_extensions - 1
	elseif extension_name == "PlayerUnitAttackIntensityExtension" then
		self._player_attack_intensity_extension_data[unit] = nil
	end

	AttackIntensitySystem.super.on_remove_extension(self, unit, extension_name)
end

AttackIntensitySystem.update = function (self, context, dt, t, ...)
	Profiler.start("attack_intensity_system")
	Profiler.start("minion_attack_intensity")
	self:_update_minion_extensions(dt, t)
	Profiler.stop("minion_attack_intensity")
	Profiler.start("player_attack_intensity")
	self:_update_player_extensions(dt, t)
	Profiler.stop("player_attack_intensity")
	Profiler.stop("attack_intensity_system")
end

local NUM_UPDATES_PER_FRAME = 2

AttackIntensitySystem._update_minion_extensions = function (self, dt, t)
	local minion_attack_intensity_extension_data = self._minion_attack_intensity_extension_data
	local num_updates = math.min(self._num_minion_extensions, NUM_UPDATES_PER_FRAME)

	for i = 1, num_updates do
		local current_update_unit = self._current_update_unit
		local current_update_extension = self._current_update_extension

		if current_update_unit then
			current_update_extension:update(current_update_unit, dt, t)
		end

		current_update_unit, current_update_extension = next(minion_attack_intensity_extension_data, current_update_unit)
		self._current_update_unit = current_update_unit
		self._current_update_extension = current_update_extension
	end
end

AttackIntensitySystem._update_player_extensions = function (self, dt, t)
	for unit, extension in pairs(self._player_attack_intensity_extension_data) do
		extension:update(unit, dt, t)
	end
end

return AttackIntensitySystem
