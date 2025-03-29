-- chunkname: @scripts/extension_systems/visual_loadout/visual_loadout_system.lua

require("scripts/extension_systems/visual_loadout/minion_visual_loadout_extension")
require("scripts/extension_systems/visual_loadout/player_husk_visual_loadout_extension")
require("scripts/extension_systems/visual_loadout/player_unit_visual_loadout_extension")

local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local VisualLoadoutSystem = class("VisualLoadoutSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_player_wield_slot",
	"rpc_player_unwield_slot",
}
local GIB_RING_BUFFER_STRIDE = 9
local GIB_RING_BUFFER_SIZE = GIB_RING_BUFFER_STRIDE * 12
local MAX_GIBS_PER_FRAME = 1

VisualLoadoutSystem.init = function (self, ...)
	VisualLoadoutSystem.super.init(self, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	local gib_ring_buffer = Script.new_array(GIB_RING_BUFFER_STRIDE)

	for i = 0, GIB_RING_BUFFER_SIZE, GIB_RING_BUFFER_STRIDE do
		gib_ring_buffer[i + 3] = Vector3Box()
		gib_ring_buffer[i + 4] = QuaternionBox()
		gib_ring_buffer[i + 6] = Vector3Box()
	end

	self._gib_ring_buffer = gib_ring_buffer
	self._gib_ring_buffer_write_idx = 0
	self._gib_ring_buffer_read_idx = 0
end

VisualLoadoutSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	VisualLoadoutSystem.super.destroy(self)
end

VisualLoadoutSystem.update = function (self, context, dt, t, ...)
	VisualLoadoutSystem.super.update(self, context, dt, t, ...)

	local gib_ring_buffer_write_idx = self._gib_ring_buffer_write_idx
	local gib_ring_buffer_read_idx = self._gib_ring_buffer_read_idx
	local gib_ring_buffer = self._gib_ring_buffer
	local gibs_spawned = 0
	local unit_to_extension_map = self._unit_to_extension_map

	while gib_ring_buffer_write_idx ~= gib_ring_buffer_read_idx and gibs_spawned < MAX_GIBS_PER_FRAME do
		local unit = gib_ring_buffer[gib_ring_buffer_read_idx + 1]
		local extension = unit_to_extension_map[unit]

		if extension then
			extension:gib_from_queue(unit, gib_ring_buffer[gib_ring_buffer_read_idx + 2], gib_ring_buffer[gib_ring_buffer_read_idx + 3]:unbox(), gib_ring_buffer[gib_ring_buffer_read_idx + 4]:unbox(), gib_ring_buffer[gib_ring_buffer_read_idx + 5], gib_ring_buffer[gib_ring_buffer_read_idx + 6]:unbox(), gib_ring_buffer[gib_ring_buffer_read_idx + 7], gib_ring_buffer[gib_ring_buffer_read_idx + 8], gib_ring_buffer[gib_ring_buffer_read_idx + 9])

			gibs_spawned = gibs_spawned + 1
		end

		gib_ring_buffer_read_idx = (gib_ring_buffer_read_idx + GIB_RING_BUFFER_STRIDE) % GIB_RING_BUFFER_SIZE
	end

	self._gib_ring_buffer_read_idx = gib_ring_buffer_read_idx
end

VisualLoadoutSystem.queue_gib_spawn = function (self, unit, gib_settings, gib_position, gib_rotation, hit_zone_name, attack_direction, damage_profile, hit_zone_gib_template, optional_override_gib_forces)
	local write_idx = self._gib_ring_buffer_write_idx
	local next_idx = (write_idx + GIB_RING_BUFFER_STRIDE) % GIB_RING_BUFFER_SIZE

	if next_idx ~= self._gib_ring_buffer_read_idx then
		local gib_ring_buffer = self._gib_ring_buffer

		gib_ring_buffer[write_idx + 1] = unit
		gib_ring_buffer[write_idx + 2] = gib_settings

		gib_ring_buffer[write_idx + 3]:store(gib_position)
		gib_ring_buffer[write_idx + 4]:store(gib_rotation)

		gib_ring_buffer[write_idx + 5] = hit_zone_name

		gib_ring_buffer[write_idx + 6]:store(attack_direction)

		gib_ring_buffer[write_idx + 7] = damage_profile
		gib_ring_buffer[write_idx + 8] = hit_zone_gib_template
		gib_ring_buffer[write_idx + 9] = optional_override_gib_forces
		self._gib_ring_buffer_write_idx = next_idx
	end
end

VisualLoadoutSystem.rpc_player_wield_slot = function (self, channel_id, go_id, slot_id)
	local unit = Managers.state.unit_spawner:unit(go_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local visual_loadout_extension = self._unit_to_extension_map[unit]
	local animation_ext = ScriptUnit.extension(unit, "animation_system")

	PlayerUnitVisualLoadout.wield_slot_husk(unit, slot_name, visual_loadout_extension, animation_ext)
end

VisualLoadoutSystem.rpc_player_unwield_slot = function (self, channel_id, go_id, slot_id)
	local unit = Managers.state.unit_spawner:unit(go_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local visual_loadout_extension = self._unit_to_extension_map[unit]

	PlayerUnitVisualLoadout.unwield_slot_husk(slot_name, visual_loadout_extension)
end

return VisualLoadoutSystem
