local SHIELD_INVENTORY_SLOT_NAME = "slot_fx_void_shield"
local SHIELD_POWER_MATERIAL_KEY = "shield_power"
local SHIELD_REDNESS_MATERIAL_KEY = "redness"
local SHIELD_REDNESS_THRESHOLD = 0.3
local NUM_IMPACT_FX_ENTRIES = 4
local IMPACT_FX_DURATION = 0.25
local IMPACT_FX_POSITION_KEY = "impact_position_0%s"
local IMPACT_FX_START_DURATION_KEY = "impact_start_duration_0%s"
local IMPACT_FX_KEYSET = {}

for i = 1, NUM_IMPACT_FX_ENTRIES do
	IMPACT_FX_KEYSET[i] = {
		impact_position_key = string.format(IMPACT_FX_POSITION_KEY, tostring(i)),
		impact_start_duration_key = string.format(IMPACT_FX_START_DURATION_KEY, tostring(i))
	}
end

local STATES = table.enum("active", "depleted")
local _get_network_values, _switch_state, _set_shield_power, _set_shield_redness = nil
local effect_template = {
	name = "renegade_captain_void_shield",
	start = function (template_data, template_context)
		local unit = template_data.unit
		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		template_data.game_object_id = game_object_id
		template_data.game_session = game_session
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local shield_unit = visual_loadout_extension:slot_unit(SHIELD_INVENTORY_SLOT_NAME)
		template_data.shield_unit = shield_unit
		local toughness_extension = ScriptUnit.extension(unit, "toughness_system")
		template_data.toughness_extension = toughness_extension
		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, unit)
		template_data.source_id = source_id
		template_data.previous_impact_fx_index = 0
		template_data.processed_attacks_index = 0
		template_data.state = STATES.active
	end,
	update = function (template_data, template_context, dt, t)
		local game_session = template_data.game_session
		local game_object_id = template_data.game_object_id
		local toughness_damage, max_toughness = _get_network_values(game_session, game_object_id)
		local percent = 1 - toughness_damage / max_toughness
		local new_state = percent > 0 and STATES.active or STATES.depleted

		if new_state ~= template_data.state then
			_switch_state(template_data, template_context, new_state)
		end

		if template_data.state == STATES.active then
			local shield_unit = template_data.shield_unit

			_set_shield_power(shield_unit, percent)

			if percent < SHIELD_REDNESS_THRESHOLD then
				local normalized_percent = math.normalize_01(percent, 0, SHIELD_REDNESS_THRESHOLD)
				local redness = math.lerp(1, 0, normalized_percent)

				_set_shield_redness(shield_unit, redness)
			end

			local toughness_extension = template_data.toughness_extension
			local processed_attacks_index = template_data.processed_attacks_index
			local stored_attacks = toughness_extension:stored_attacks()
			local num_stored_attacks = #stored_attacks

			if processed_attacks_index < num_stored_attacks then
				local wwise_world = template_context.wwise_world

				WwiseWorld.set_global_parameter(wwise_world, "void_shield_health", percent)

				local start_time = World.time(Unit.world(shield_unit))
				local start_duration_input = Vector2(start_time, IMPACT_FX_DURATION)
				local include_children = true

				for i = processed_attacks_index + 1, num_stored_attacks do
					local attack_data = stored_attacks[i]
					local impact_world_position = attack_data.impact_world_position:unbox()
					local previous_impact_fx_index = template_data.previous_impact_fx_index
					local next_impact_fx_index = previous_impact_fx_index % NUM_IMPACT_FX_ENTRIES + 1
					template_data.previous_impact_fx_index = next_impact_fx_index
					local impact_fx_keys = IMPACT_FX_KEYSET[next_impact_fx_index]
					local position_key = impact_fx_keys.impact_position_key

					Unit.set_vector3_for_materials(shield_unit, position_key, impact_world_position, include_children)

					local start_duration_key = impact_fx_keys.impact_start_duration_key

					Unit.set_vector2_for_materials(shield_unit, start_duration_key, start_duration_input, include_children)
				end

				template_data.processed_attacks_index = num_stored_attacks
			end
		end
	end,
	stop = function (template_data, template_context)
		local shield_unit = template_data.shield_unit

		if Unit.alive(shield_unit) then
			_set_shield_power(shield_unit, 1)
		end

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.destroy_manual_source(wwise_world, source_id)
	end
}

function _switch_state(template_data, template_context, new_state)
	local shield_unit = template_data.shield_unit

	if new_state == STATES.depleted then
		_set_shield_power(shield_unit, 1)
	elseif new_state == STATES.active then
		_set_shield_redness(shield_unit, 0)
	end

	template_data.state = new_state
end

function _set_shield_power(shield_unit, power)
	local include_children = true

	Unit.set_scalar_for_materials(shield_unit, SHIELD_POWER_MATERIAL_KEY, power, include_children)
end

function _set_shield_redness(shield_unit, redness)
	local include_children = true

	Unit.set_scalar_for_materials(shield_unit, SHIELD_REDNESS_MATERIAL_KEY, redness, include_children)
end

function _get_network_values(game_session, game_object_id)
	local toughness_damage = GameSession.game_object_field(game_session, game_object_id, "toughness_damage")
	local max_toughness = GameSession.game_object_field(game_session, game_object_id, "toughness")

	return toughness_damage, max_toughness
end

return effect_template
