local ForceFieldExtension = class("ForceFieldExtension")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules

ForceFieldExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, unit_spawn_parameter_or_game_object_id)
	self._unit = unit
	self._world = extension_init_context.world
	self._is_server = extension_init_context.is_server
	self.owner_unit = extension_init_data.owner_unit
	self._max_duration = 15
	self._duration = self._max_duration
	self._game_session = game_object_data_or_game_session
	self._game_object_id = unit_spawn_parameter_or_game_object_id
	local rotation = Unit.local_rotation(unit, 1)
	local position = Unit.local_position(unit, 1)

	if self._is_server then
		local side_system = Managers.state.extension:system("side_system")
		self.side = side_system.side_by_unit[self.owner_unit]
		self.side_names = self.side:relation_side_names("enemy")
		local width = 6
		local forward = Quaternion.forward(rotation)
		local rotation_left = Quaternion.from_euler_angles_xyz(0, 0, 90)
		local left = (Quaternion.rotate(rotation_left, forward) * width) / 2
		local p1 = Vector3Box(position)
		local p2 = Vector3Box(position + left * 0.3)
		local p3 = Vector3Box(position + left * 0.6)
		local p4 = Vector3Box(position + left * 0.9)
		local p5 = Vector3Box(position - left * 0.3)
		local p6 = Vector3Box(position - left * 0.6)
		local p7 = Vector3Box(position - left * 0.9)
		self._points = {
			p1,
			p2,
			p3,
			p4,
			p5,
			p6,
			p7
		}
	end
end

ForceFieldExtension.destroy = function (self)
	return
end

ForceFieldExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	local owner_unit = self.owner_unit
	self.buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self.specialization_extension = ScriptUnit.extension(owner_unit, "specialization_system")
	self._indefinite_duration = self.specialization_extension:has_special_rule(special_rules.psyker_protectorate_shield_lasts_indefinetely)
end

ForceFieldExtension.fixed_update = function (self, unit, dt, t)
	local game_session = self._game_session
	local game_object_id = self._game_object_id

	if self._is_server then
		if not self._indefinite_duration then
			local duration = math.max(self._duration - dt, 0)
			self._duration = duration

			GameSession.set_game_object_field(game_session, game_object_id, "remaining_duration", duration)
		end
	else
		self._duration = GameSession.game_object_field(game_session, game_object_id, "remaining_duration")
	end

	local max_duration = self._max_duration
	local duration = self._duration
	local lerp_t = duration / max_duration
	local color = Vector3(0, 1, 0)

	if lerp_t < 0.2 then
		color = Vector3(1, 0, 0)
	elseif lerp_t < 0.5 then
		color = Vector3(0.5, 0.5, 0)
	end

	Unit.set_vector3_for_material(unit, "shield", "shield_color", color)
end

local DEFAULT_UNIT_RADIUS = 1

ForceFieldExtension.is_unit_inside = function (self, unit_pos, unit_radius)
	if not unit_pos then
		return false
	end

	unit_radius = unit_radius or DEFAULT_UNIT_RADIUS
	local distance, last_distance = nil
	local radius_sq = unit_radius * unit_radius
	local points = self._points
	distance = Vector3.distance_squared(unit_pos, points[4]:unbox())

	if distance < radius_sq then
		return true
	end

	last_distance = distance
	distance = Vector3.distance_squared(unit_pos, points[3]:unbox())

	if last_distance < distance then
		return false
	elseif distance < radius_sq then
		return true
	end

	distance = Vector3.distance_squared(unit_pos, points[7]:unbox())

	if distance < radius_sq then
		return true
	end

	last_distance = distance
	distance = Vector3.distance_squared(unit_pos, points[6]:unbox())

	if last_distance < distance then
		return false
	elseif distance < radius_sq then
		return true
	end

	distance = Vector3.distance_squared(unit_pos, points[5]:unbox())

	if distance < radius_sq then
		return true
	end

	distance = Vector3.distance_squared(unit_pos, points[2]:unbox())

	if distance < radius_sq then
		return true
	end

	distance = Vector3.distance_squared(unit_pos, points[1]:unbox())

	if distance < radius_sq then
		return true
	end

	return false
end

ForceFieldExtension.force_field_unit = function (self)
	return self._unit
end

ForceFieldExtension.remaining_duration = function (self)
	return (self._indefinite_duration and self._max_duration) or self._duration
end

return ForceFieldExtension
