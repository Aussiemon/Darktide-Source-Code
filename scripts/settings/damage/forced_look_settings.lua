local forced_look_settings = {
	look_functions = {
		to_or_from_attack_direction = function (player_fp_rotation, force_look_direction)
			local player_forward = Quaternion.forward(player_fp_rotation)
			local dot = Vector3.dot(player_forward, force_look_direction)
			local forward = dot > 0
			local look_rotation = Quaternion.look(forward and force_look_direction or -force_look_direction)
			look_rotation = Quaternion.multiply(player_fp_rotation, look_rotation)
			local pitch = Quaternion.pitch(look_rotation)
			local yaw = Quaternion.yaw(look_rotation)
			local duration = 0.1

			return pitch, yaw, duration
		end,
		light = function (player_fp_rotation, force_look_direction)
			local yaw = (1 - math.random() * 2) * math.pi / 6
			local pitch = -math.pi / 8 + math.random() * math.pi / 8
			local duration = 0.1

			return pitch, yaw, duration
		end,
		medium = function (player_fp_rotation, force_look_direction)
			local yaw = (1 - math.random() * 2) * math.pi / 6
			local pitch = -math.pi / 4 + math.random() * math.pi / 8
			local duration = 0.3

			return pitch, yaw, duration
		end,
		heavy = function (player_fp_rotation, force_look_direction)
			local yaw = (1 - math.random() * 2) * math.pi / 6
			local pitch = -math.pi / 4 + math.random() * math.pi / 12
			local duration = 0.5

			return pitch, yaw, duration
		end,
		fortitude_broken = function (player_fp_rotation, force_look_direction)
			local yaw = (1 - math.random() * 2) * math.pi / 6
			local pitch = -math.pi / 8 + math.random() * math.pi / 16
			local duration = 0.1

			return pitch, yaw, duration
		end
	}
}

return settings("ForcedLookSettings", forced_look_settings)
