-- chunkname: @scripts/settings/fx/effect_templates/chaos_beast_of_nurgle_consume_minion.lua

local BON_ATTACH_NODE_NAME = "j_tongue_mouth"
local TARGET_ATTACH_NODE_NAME = "j_hips"
local _link_unit
local effect_template = {
	name = "chaos_beast_of_nurgle_consume_minion",
	start = function (template_data, template_context)
		return
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local game_session, game_object_id = template_context.game_session, Managers.state.unit_spawner:game_object_id(unit)
		local consumed_minion_unit_id = GameSession.game_object_field(game_session, game_object_id, "consumed_minion_unit_id")
		local target_unit = Managers.state.unit_spawner:unit(consumed_minion_unit_id)

		if not ALIVE[target_unit] then
			return
		end

		if not template_data.linked then
			template_data.target_unit = target_unit

			_link_unit(template_data, template_context, unit, target_unit)
		end
	end,
	stop = function (template_data, template_context)
		if template_context.is_server then
			local target_unit = template_data.target_unit

			if ALIVE[target_unit] then
				Managers.state.minion_spawn:despawn(template_data.target_unit)
			end
		end
	end
}

function _link_unit(template_data, template_context, unit, target_unit)
	local tongue_node = Unit.node(unit, BON_ATTACH_NODE_NAME)

	if template_context.is_server then
		local world_position = Unit.world_position(unit, tongue_node)
		local locomotion_extension = ScriptUnit.extension(target_unit, "locomotion_system")

		locomotion_extension:teleport_to(world_position)

		local navigation_extension = ScriptUnit.extension(target_unit, "navigation_system")

		navigation_extension:set_enabled(false)
	end

	local target_node = Unit.node(target_unit, TARGET_ATTACH_NODE_NAME)
	local world = template_context.world

	World.link_unit(world, target_unit, target_node, unit, tongue_node, World.LINK_MODE_NONE)

	template_data.linked = true
end

return effect_template
