local _link_unit = nil
local effect_template = {
	name = "chaos_beast_of_nurgle_consume_minion",
	start = function (template_data, template_context)
		return
	end
}

effect_template.update = function (template_data, template_context, dt, t)
	local unit = template_data.unit
	local game_session = template_context.game_session
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
	local consumed_minion_unit_id = GameSession.game_object_field(game_session, game_object_id, "consumed_minion_unit_id")
	local target_unit = Managers.state.unit_spawner:unit(consumed_minion_unit_id)

	if not ALIVE[target_unit] then
		return
	end

	if not template_data.linked then
		_link_unit(template_data, template_context, unit, target_unit)
	end

	if template_context.is_server then
		-- Nothing
	end
end

effect_template.stop = function (template_data, template_context)
	local target_unit = template_data.target_unit

	if ALIVE[target_unit] then
		if template_context.is_server then
			Managers.state.unit_spawner:make_network_unit_local_unit(target_unit)
			Managers.state.minion_spawn:unregister_unit(target_unit)
		end

		Managers.state.unit_spawner:mark_for_deletion(target_unit)
	end
end

function _link_unit(template_data, template_context, unit, target_unit)
	local target_node = 1
	local tongue_node = Unit.node(unit, "j_tongue_mouth")
	local world = template_context.world

	World.link_unit(world, target_unit, target_node, unit, tongue_node, World.LINK_MODE_NONE)

	template_data.linked = true
end

return effect_template
