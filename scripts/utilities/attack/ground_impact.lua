local MaterialQuery = require("scripts/utilities/material_query")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local GroundImpact = {}
local DEFAULT_SAMPLE_DISTANCE = 10
local DEFAULT_RANGE = 1.5

GroundImpact.play = function (unit, physics_world, ground_impact_fx_template)
	local attachment_unit = unit
	local node_index = nil
	local fx_source_name = ground_impact_fx_template.fx_source_name
	local inventory_slot_name = ground_impact_fx_template.inventory_slot_name

	if inventory_slot_name then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_item = visual_loadout_extension:slot_item(inventory_slot_name)
		local optional_lookup_fx_sources = false
		attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name, optional_lookup_fx_sources)
	else
		node_index = Unit.node(unit, fx_source_name)
	end

	local node_position = Unit.world_position(attachment_unit, node_index)
	local evaluation_height_offset = ground_impact_fx_template.evaluation_height_offset
	local from = node_position + Vector3(0, 0, evaluation_height_offset)
	local to = from - Vector3(0, 0, DEFAULT_SAMPLE_DISTANCE)
	local hit, impact_material, impact_position, impact_normal, hit_unit, hit_actor = MaterialQuery.query_material(physics_world, from, to, "ground_impact_fx")
	local is_valid_hit = nil

	if hit then
		is_valid_hit = node_position.z < impact_position.z

		if not is_valid_hit then
			local range = ground_impact_fx_template.range or DEFAULT_RANGE
			local distance = Vector3.distance(impact_position, node_position)
			is_valid_hit = distance < range
		end
	end

	if not is_valid_hit and not ground_impact_fx_template.requires_valid_ground_hit then
		is_valid_hit = true
		impact_position = node_position
	end

	if is_valid_hit then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_ground_impact_fx(ground_impact_fx_template, impact_material, impact_position, impact_normal)
	end
end

return GroundImpact
