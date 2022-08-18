local BloodSettings = require("scripts/settings/blood/blood_settings")
local blood_ball_settings = BloodSettings.blood_ball
local damage_type_speed = BloodSettings.blood_ball.damage_type_speed
local BloodManager = class("BloodManager")
local BLOOD_BALL_ACTOR_NAME = "blood_ball"
local CLIENT_RPCS = {
	"rpc_add_weapon_blood"
}

BloodManager.init = function (self, world, is_server, network_event_delegate)
	self._world = world
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate

	self:_create_blood_ball_buffer()

	self._blood_system = Blood.init(self._world, BLOOD_BALL_ACTOR_NAME)
	self._weapon_blood = {}

	if not is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

BloodManager._create_blood_ball_buffer = function (self)
	local buffer_size = BloodSettings.blood_ball.ring_buffer_size
	local buffer = Script.new_array(buffer_size)

	for index = 1, buffer_size do
		buffer[index] = {
			speed = 0,
			unit_name = "",
			position = Vector3Box(),
			direction = Vector3Box()
		}
	end

	self._blood_ball_ring_buffer = {
		write_index = 1,
		read_index = 1,
		size = 0,
		buffer = buffer,
		max_size = buffer_size
	}
end

BloodManager.delete_units = function (self)
	Blood.destroy(self._blood_system)
end

BloodManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

BloodManager.update = function (self, dt, t)
	self:_update_blood_balls(dt, t)
	self:_update_weapon_blood(dt, t)
end

BloodManager._update_blood_balls = function (self, dt, t)
	local blood_ball_ring_buffer = self._blood_ball_ring_buffer
	local size = blood_ball_ring_buffer.size

	if size == 0 then
		return
	end

	local buffer = blood_ball_ring_buffer.buffer
	local read_index = blood_ball_ring_buffer.read_index
	local max_size = blood_ball_ring_buffer.max_size
	local num_updates = math.min(BloodSettings.blood_ball.max_per_frame, size)

	for i = 1, num_updates do
		local blood_ball_data = buffer[read_index]

		self:_spawn_blood_ball(blood_ball_data)

		read_index = read_index % max_size + 1
		size = size - 1
	end

	blood_ball_ring_buffer.size = size
	blood_ball_ring_buffer.read_index = read_index
end

BloodManager.queue_blood_ball = function (self, position, direction, blood_ball_unit, optional_damage_type)
	if DEDICATED_SERVER then
		return
	end

	fassert(position, "BloodManager:queue_blood_ball() needs position argument")
	fassert(direction, "BloodManager:queue_blood_ball() needs direction argument")
	fassert(blood_ball_unit, "BloodManager:queue_blood_ball() needs blood_ball_unit argument")

	if not Vector3.is_valid(position) then
		return
	end

	local blood_ball_ring_buffer = self._blood_ball_ring_buffer
	local buffer = blood_ball_ring_buffer.buffer
	local read_index = blood_ball_ring_buffer.read_index
	local write_index = blood_ball_ring_buffer.write_index
	local size = blood_ball_ring_buffer.size
	local max_size = blood_ball_ring_buffer.max_size

	if max_size < size + 1 then
		local blood_ball_data = buffer[read_index]

		self:_spawn_blood_ball(blood_ball_data)

		blood_ball_ring_buffer.size = size - 1
		blood_ball_ring_buffer.read_index = read_index % max_size + 1
	end

	local speed = damage_type_speed[optional_damage_type]
	local default_speed = damage_type_speed.default
	local blood_ball_data = buffer[write_index]

	blood_ball_data.position:store(position)
	blood_ball_data.direction:store(direction)

	blood_ball_data.speed = speed or default_speed
	blood_ball_data.unit_name = blood_ball_unit
	blood_ball_ring_buffer.size = size + 1
	blood_ball_ring_buffer.write_index = write_index % max_size + 1
end

BloodManager.remove_blood_ball = function (self, unit)
	Blood.despawn_blood_ball(self._blood_system, unit)
end

BloodManager.play_screen_space_blood = function (self, fx_extension)
	fx_extension:spawn_exclusive_particle("content/fx/particles/screenspace/screen_blood_splatter", Vector3(0, 0, 1))
end

BloodManager.blood_ball_collision = function (self, unit, position, normal, velocity, blood_type, remove_blood_ball)
	local dot_value = Vector3.dot(normal, Vector3.normalize(velocity))
	local tangent = Vector3.normalize(Vector3.normalize(velocity) - dot_value * normal)
	local tangent_rotation = Quaternion.look(tangent, normal)
	local decals = blood_ball_settings.blood_type_decal[blood_type]
	local decal_unit_name = decals[math.random(1, #decals)]
	local extents = Vector3(1, 1, 1)

	if Managers.state.decal ~= nil then
		local t = Managers.time:time("gameplay")

		Managers.state.decal:add_projection_decal(decal_unit_name, position, tangent_rotation, normal, extents, nil, nil, t)
	end

	if remove_blood_ball then
		self:remove_blood_ball(unit)
	end
end

BloodManager._spawn_blood_ball = function (self, blood_ball_data)
	local position = blood_ball_data.position:unbox()
	local direction = blood_ball_data.direction:unbox()
	local rotation = Quaternion.look(direction, Vector3.up())
	local speed = blood_ball_data.speed
	local unit_name = blood_ball_data.unit_name

	Blood.spawn_blood_ball(self._blood_system, unit_name, position, rotation, direction, speed)
end

BloodManager._update_weapon_blood = function (self, dt, t)
	local weapon_blood = self._weapon_blood

	for player_unit, slots in pairs(weapon_blood) do
		local visual_loadout_extension = ALIVE[player_unit] and ScriptUnit.has_extension(player_unit, "visual_loadout_system")

		if visual_loadout_extension then
			for slot_name, blood_amount in pairs(slots) do
				local blood_intensity_set = self:_set_weapon_blood_intensity(visual_loadout_extension, slot_name, blood_amount)

				if blood_intensity_set then
					slots[slot_name] = math.max(blood_amount - dt * 0.03, 0)
				else
					slots[slot_name] = nil
				end
			end
		else
			weapon_blood[player_unit] = nil
		end
	end
end

BloodManager._set_weapon_blood_intensity = function (self, visual_loadout_extension, slot_name, blood_amount)
	local unit_1p, unit_3p = visual_loadout_extension:unit_and_attachments_from_slot(slot_name)
	local material_value = Quaternion.identity()

	if unit_1p and unit_3p then
		Quaternion.set_xyzw(material_value, 0.05, 0.004, 0.004, blood_amount)
		Unit.set_vector4_for_materials(unit_1p, "blood_color", material_value, true)
		Unit.set_vector4_for_materials(unit_3p, "blood_color", material_value, true)

		return true
	end

	return false
end

BloodManager.add_weapon_blood = function (self, player, slot_name, amount)
	local blood_amounts = BloodSettings.weapon_blood_amounts
	local player_unit = player.player_unit
	local amount_scalar = blood_amounts[amount] or blood_amounts.default
	local weapon_blood = self._weapon_blood[player_unit] or {}
	weapon_blood[slot_name] = math.min((weapon_blood[slot_name] or 0) + amount_scalar, blood_amounts.full)
	self._weapon_blood[player_unit] = weapon_blood

	if self._is_server then
		local game_object_id = Managers.state.unit_spawner:game_object_id(player_unit)
		local slot_name_id = NetworkLookup.player_inventory_slot_names[slot_name]
		local weapon_blood_amount_id = NetworkLookup.weapon_blood_amounts[amount]

		Managers.state.game_session:send_rpc_clients_except("rpc_add_weapon_blood", player:channel_id(), game_object_id, slot_name_id, weapon_blood_amount_id)
	end
end

BloodManager.rpc_add_weapon_blood = function (self, channel_id, game_object_id, slot_name_id, weapon_blood_amount_id)
	local player_unit = Managers.state.unit_spawner:unit(game_object_id)

	if ALIVE[player_unit] then
		local slot_name = NetworkLookup.player_inventory_slot_names[slot_name_id]
		local weapon_blood_amount = NetworkLookup.weapon_blood_amounts[weapon_blood_amount_id]
		local blood_amounts = BloodSettings.weapon_blood_amounts
		local amount_scalar = blood_amounts[weapon_blood_amount] or blood_amounts.default
		local weapon_blood = self._weapon_blood[player_unit] or {}
		weapon_blood[slot_name] = math.min((weapon_blood[slot_name] or 0) + amount_scalar, blood_amounts.full)
		self._weapon_blood[player_unit] = weapon_blood
	end
end

return BloodManager
