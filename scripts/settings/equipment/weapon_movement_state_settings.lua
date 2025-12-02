-- chunkname: @scripts/settings/equipment/weapon_movement_state_settings.lua

local weapon_movement_state_settings = {}

weapon_movement_state_settings.weapon_movement_states = table.enum("still", "moving", "crouch_still", "crouch_moving")
weapon_movement_state_settings.epsilon_squared_movement_speed = 0.0025000000000000005

return settings("WeaponMovementStateSettings", weapon_movement_state_settings)
