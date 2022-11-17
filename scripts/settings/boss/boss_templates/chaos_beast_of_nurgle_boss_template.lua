local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local LIQUID_PAINT_ID = "movement_liquid_paint_id"
local LIQUID_TEMPLATE = LiquidAreaTemplates.beast_of_nurgle_slime
local LIQUID_BRUSH_SIZE = 1
local MAX_LIQUID_PAINT_DISTANCE = 6
local PAINT_UPDATE_FREQ = 0.2
local TARGET_CHANGED_MAX_NEARBY_ENEMIES_RADIUS = 12
local TARGET_CHANGED_MAX_DISTANCE = 20
local _num_nearby_enemies = nil
local template = {
	name = "chaos_beast_of_nurgle",
	start = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_data.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.breed = unit_data_extension:breed()
		local blackboard = BLACKBOARDS[unit]
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		template_data.behavior_component = behavior_component
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local nav_world = navigation_extension:nav_world()
		template_data.nav_world = nav_world
		template_data.next_paint_update_t = 0
		behavior_component[LIQUID_PAINT_ID] = LiquidArea.start_paint()
		template_data.has_first_line_of_sight = false
	end,
	update = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local behavior_component = template_data.behavior_component

		if template_data.next_paint_update_t <= t then
			local unit = template_data.unit
			local position = POSITION_LOOKUP[unit]
			local liquid_paint_id = behavior_component[LIQUID_PAINT_ID]
			local max_liquid_paint_distance = MAX_LIQUID_PAINT_DISTANCE
			local liquid_position = position + Vector3.up() * 0.5
			local nav_world = template_data.nav_world
			local allow_liquid_unit_creation = true
			local liquid_paint_brush_size = LIQUID_BRUSH_SIZE
			local not_on_other_liquids = true
			local source_unit = unit

			LiquidArea.paint(liquid_paint_id, max_liquid_paint_distance, liquid_position, nav_world, LIQUID_TEMPLATE, allow_liquid_unit_creation, liquid_paint_brush_size, not_on_other_liquids, source_unit)

			template_data.next_paint_update_t = t + PAINT_UPDATE_FREQ
		end

		local unit = template_data.unit

		if behavior_component.wants_to_catapult_consumed_unit then
			local consumed_unit = behavior_component.consumed_unit

			if HEALTH_ALIVE[consumed_unit] then
				local consumed_unit_data_extension = ScriptUnit.extension(consumed_unit, "unit_data_system")
				local disabled_character_state_component = consumed_unit_data_extension:read_component("disabled_character_state")
				local is_disabled = disabled_character_state_component.is_disabled

				if not is_disabled then
					local catapult_force = 13
					local catapult_z_force = 3
					local direction = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))
					local velocity = direction * catapult_force
					velocity.z = catapult_z_force
					local catapulted_state_input = consumed_unit_data_extension:write_component("catapulted_state_input")

					Catapulted.apply(catapulted_state_input, velocity)

					behavior_component.wants_to_catapult_consumed_unit = nil
					behavior_component.consumed_unit = nil
				end
			else
				behavior_component.wants_to_catapult_consumed_unit = nil
			end
		end

		local perception_component = BLACKBOARDS[unit].perception
		local has_line_of_sight = perception_component.has_line_of_sight

		if has_line_of_sight and perception_component.target_distance < TARGET_CHANGED_MAX_DISTANCE then
			if not template_data.has_first_line_of_sight then
				template_data.has_first_line_of_sight = true

				if _num_nearby_enemies(unit) == 0 then
					behavior_component.wants_to_play_alerted = true
				end
			end

			if perception_component.target_changed and _num_nearby_enemies(unit) == 0 then
				behavior_component.wants_to_play_alerted = true
			end
		end
	end,
	stop = function (template_data, template_context)
		local unit = template_data.unit

		if template_context.is_server then
			local blackboard = BLACKBOARDS[unit]
			local behavior_component = Blackboard.write_component(blackboard, "behavior")
			local consumed_unit = behavior_component.consumed_unit

			if HEALTH_ALIVE[consumed_unit] then
				local target_locomotion_extension = ScriptUnit.extension(consumed_unit, "locomotion_system")

				target_locomotion_extension:set_parent_unit(nil)

				local consumed_unit_data_extension = ScriptUnit.extension(consumed_unit, "unit_data_system")
				local disabled_state_input = consumed_unit_data_extension:write_component("disabled_state_input")
				disabled_state_input.trigger_animation = "none"
				disabled_state_input.disabling_unit = nil
				behavior_component.consumed_unit = nil
			end

			local liquid_paint_id = behavior_component[LIQUID_PAINT_ID]

			LiquidArea.stop_paint(liquid_paint_id)
		end

		if not DEDICATED_SERVER then
			local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
			local body_slot_unit = visual_loadout_extension:slot_unit("slot_body")
			local weakspot_material_name = "beast_of_nurgle_weakspot"
			local material_variable_name = "opacity"

			Unit.set_scalar_for_material(body_slot_unit, weakspot_material_name, material_variable_name, 0)
		end
	end
}
local BROADPHASE_RESULTS = {}

function _num_nearby_enemies(unit)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local relation = "enemy"
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local target_side_names = side:relation_side_names(relation)
	local from = POSITION_LOOKUP[unit]
	local radius = TARGET_CHANGED_MAX_NEARBY_ENEMIES_RADIUS
	local num_results = broadphase:query(from, radius, BROADPHASE_RESULTS, target_side_names)

	return num_results
end

return template
