-- chunkname: @scripts/extension_systems/flee/flee_constants.lua

local flee_constants = {}

flee_constants.flee_types = table.enum("bounds_air")
flee_constants.flee_states = table.enum("idle", "fleeing")

return settings("FleeConstants", flee_constants)
