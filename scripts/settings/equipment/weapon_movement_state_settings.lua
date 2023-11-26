-- chunkname: @scripts/settings/equipment/weapon_movement_state_settings.lua

local weapon_movement_state_settings = {}

weapon_movement_state_settings.weapon_movement_states = table.enum("still", "moving", "crouch_still", "crouch_moving")

return settings("WeaponMovementStateSettings", weapon_movement_state_settings)
