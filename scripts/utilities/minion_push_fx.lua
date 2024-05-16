-- chunkname: @scripts/utilities/minion_push_fx.lua

local Armor = require("scripts/utilities/attack/armor")
local MinionPushFx = {}

MinionPushFx.play_fx = function (pushing_unit, pushed_unit, template)
	local vfx_name, node_name = template.vfx, template.node_name
	local vfx_node = Unit.node(pushed_unit, node_name)
	local node_position = Unit.world_position(pushed_unit, vfx_node)
	local fx_system = Managers.state.extension:system("fx_system")
	local pushing_unit_position, pushed_unit_position = POSITION_LOOKUP[pushing_unit], POSITION_LOOKUP[pushed_unit]
	local direction = Vector3.normalize(Vector3.flat(pushed_unit_position - pushing_unit_position))
	local rotation = Quaternion.look(direction)

	fx_system:trigger_vfx(vfx_name, node_position, rotation)

	local sfx = template.sfx

	if type(sfx) == "table" then
		local pushed_unit_data_extension = ScriptUnit.extension(pushed_unit, "unit_data_system")
		local breed = pushed_unit_data_extension:breed()
		local armor_type = Armor.armor_type(pushed_unit, breed)

		sfx = sfx[armor_type]
	end

	fx_system:trigger_wwise_event(sfx, node_position)
end

MinionPushFx.play_sfx_for_clients_except = function (pushed_unit, template, player_exception)
	local sfx = template.sfx

	if type(sfx) == "table" then
		local pushed_unit_data_extension = ScriptUnit.extension(pushed_unit, "unit_data_system")
		local breed = pushed_unit_data_extension:breed()
		local armor_type = Armor.armor_type(pushed_unit, breed)

		sfx = sfx[armor_type]
	end

	local event_id = NetworkLookup.sound_events[sfx]
	local pushed_unit_position = POSITION_LOOKUP[pushed_unit]
	local channel_id_exception = player_exception:channel_id()

	Managers.state.game_session:send_rpc_clients_except("rpc_trigger_wwise_event", channel_id_exception, event_id, pushed_unit_position)
end

return MinionPushFx
