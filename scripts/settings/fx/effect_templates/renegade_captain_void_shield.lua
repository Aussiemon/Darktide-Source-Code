local SHIELD_INVENTORY_SLOT_NAME = "slot_fx_void_shield"
local SHIELD_POWER_MATERIAL_KEY = "shield_power"
local SHIELD_COLOR_MATERIAL_KEY = "color_a"
local SHIELD_REDNESS_MATERIAL_KEY = "redness"
local SHIELD_REDNESS_THRESHOLD = 0.3
local LIGHT_NAME = "shield_light"
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
local _get_network_values, _switch_state, _flicker_shield, _set_shield_power, _set_shield_redness = nil
local HIT_SHIELD_EXTRA_LIGHT_DURATION = 0.1
local effect_template = {
	name = "renegade_captain_void_shield"
}

effect_template.start = function (template_data, template_context)
	if DEDICATED_SERVER then
		return
	end

	local unit = template_data.unit
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
	template_data.game_object_id = game_object_id
	template_data.game_session = game_session
	local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()
	template_data.breed = breed
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local shield_unit = visual_loadout_extension:slot_unit(SHIELD_INVENTORY_SLOT_NAME)
	template_data.shield_unit = shield_unit
	local toughness_extension = ScriptUnit.extension(unit, "toughness_system")
	template_data.toughness_extension = toughness_extension
	local toughness_template = toughness_extension:toughness_templates()
	template_data.toughness_template = toughness_template
	local wwise_world = template_context.wwise_world
	local source_id = WwiseWorld.make_manual_source(wwise_world, unit)
	template_data.source_id = source_id
	template_data.previous_impact_fx_index = 0
	template_data.processed_attacks_index = 0
	template_data.state = STATES.active
	local light = Unit.light(unit, LIGHT_NAME)

	Light.set_enabled(light, true)

	template_data.light = light
	local include_children = true

	for i = 1, #IMPACT_FX_KEYSET do
		local impact_fx_keys = IMPACT_FX_KEYSET[i]
		local start_duration_key = impact_fx_keys.impact_start_duration_key

		Unit.set_vector2_for_materials(shield_unit, start_duration_key, Vector2(0, 0), include_children)
	end
end

effect_template.update = function (template_data, template_context, dt, t)
	if DEDICATED_SERVER then
		return
	end

	local game_session = template_data.game_session
	local game_object_id = template_data.game_object_id
	local toughness_damage, max_toughness, is_toughness_invulnerable = _get_network_values(game_session, game_object_id, template_data.breed)
	local percent = 1 - toughness_damage / max_toughness
	local new_state = percent > 0 and STATES.active or STATES.depleted

	if new_state ~= template_data.state then
		_switch_state(template_data, template_context, new_state, is_toughness_invulnerable)
	end

	if template_data.state == STATES.active then
		local shield_unit = template_data.shield_unit

		_set_shield_power(shield_unit, percent, template_data, t, is_toughness_invulnerable)

		if percent < SHIELD_REDNESS_THRESHOLD then
			local normalized_percent = math.normalize_01(percent, 0, SHIELD_REDNESS_THRESHOLD)
			local redness = math.lerp(1, 0, normalized_percent)

			_set_shield_redness(shield_unit, redness, is_toughness_invulnerable)
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
			template_data.hit_shield_duration = t + HIT_SHIELD_EXTRA_LIGHT_DURATION
		end
	elseif template_data.state == STATES.depleted and not template_data.toughness_template.ignore_flickering_on_depleted then
		local shield_unit = template_data.shield_unit

		_flicker_shield(shield_unit, template_data, t)
	end
end

effect_template.stop = function (template_data, template_context)
	if DEDICATED_SERVER then
		return
	end

	local shield_unit = template_data.shield_unit

	if Unit.alive(shield_unit) then
		_set_shield_power(shield_unit, 1, template_data)
	end

	local wwise_world = template_context.wwise_world
	local source_id = template_data.source_id

	WwiseWorld.destroy_manual_source(wwise_world, source_id)
end

function _switch_state(template_data, template_context, new_state, is_toughness_invulnerable)
	local shield_unit = template_data.shield_unit

	if new_state == STATES.depleted then
		_set_shield_power(shield_unit, 1, template_data, nil, is_toughness_invulnerable)

		local green = 0.23529411764705882
		local color_filter = Vector3(1, green, 0.09803921568627451)

		Light.set_color_filter(template_data.light, color_filter)
	elseif new_state == STATES.active then
		_set_shield_redness(shield_unit, 0, is_toughness_invulnerable)
	end

	template_data.state = new_state
end

local MAX_INTENSITY_LUMEN = 400
local MAX_INTENSITY_LUMEN_HIT_SHIELD = 1000
local FLICKER_DURATION = {
	0.1,
	0.3
}
local FLICKER_FREQUENCY = {
	0.1,
	0.3
}

function _flicker_shield(shield_unit, template_data, t)
	local light = template_data.light

	if template_data.next_flicker_t then
		if template_data.next_flicker_t < t then
			template_data.flicker_duration = t + math.random_range(FLICKER_DURATION[1], FLICKER_DURATION[2])
			template_data.next_flicker_t = nil

			Light.set_intensity(light, 0)
		else
			return
		end
	end

	if not template_data.flicker_duration or template_data.flicker_duration and template_data.flicker_duration <= t then
		template_data.next_flicker_t = t + math.random_range(FLICKER_FREQUENCY[1], FLICKER_FREQUENCY[2])

		Light.set_intensity(light, MAX_INTENSITY_LUMEN * 0.2)
	end
end

function _set_shield_power(shield_unit, power, template_data, t, is_toughness_invulnerable)
	local include_children = true

	Unit.set_scalar_for_materials(shield_unit, SHIELD_POWER_MATERIAL_KEY, power, include_children)

	local has_hit_shield = t and template_data.hit_shield_duration and t <= template_data.hit_shield_duration
	local lumen = (1 - power) * (has_hit_shield and MAX_INTENSITY_LUMEN_HIT_SHIELD or MAX_INTENSITY_LUMEN)
	local light = template_data.light

	Light.set_intensity(light, lumen)

	if is_toughness_invulnerable then
		local color_filter = Vector3(0.6862745098039216 * power, 1 * power, 0.7843137254901961 * power * 2) * 2

		Light.set_color_filter(light, color_filter)
		Unit.set_vector3_for_materials(shield_unit, SHIELD_COLOR_MATERIAL_KEY, color_filter, include_children)
	else
		local green = math.max(power, 0.23529411764705882)
		local color_filter = Vector3(1, green, 0.09803921568627451)

		Light.set_color_filter(light, color_filter)
		Unit.set_vector3_for_materials(shield_unit, SHIELD_COLOR_MATERIAL_KEY, color_filter, include_children)
	end
end

function _set_shield_redness(shield_unit, redness, is_toughness_invulnerable)
	local include_children = true

	Unit.set_scalar_for_materials(shield_unit, SHIELD_REDNESS_MATERIAL_KEY, is_toughness_invulnerable and 0 or redness, include_children)
end

function _get_network_values(game_session, game_object_id, breed)
	local toughness_damage = GameSession.game_object_field(game_session, game_object_id, "toughness_damage")
	local max_toughness = GameSession.game_object_field(game_session, game_object_id, "toughness")
	local is_toughness_invulnerable = false

	if breed.can_have_invulnerable_toughness then
		is_toughness_invulnerable = GameSession.game_object_field(game_session, game_object_id, "is_toughness_invulnerable")
	end

	return toughness_damage, max_toughness, is_toughness_invulnerable
end

return effect_template
