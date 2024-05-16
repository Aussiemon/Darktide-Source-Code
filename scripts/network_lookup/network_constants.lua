-- chunkname: @scripts/network_lookup/network_constants.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local MechanismManager = require("scripts/managers/mechanism/mechanism_manager")
local MinionToughnessTemplates = require("scripts/settings/toughness/minion_toughness_templates")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local TagQueryDatabase = require("scripts/extension_systems/dialogue/tag_query_database")

NetworkConstants = NetworkConstants or {}

local function _check_network_lookup_boundaries(network_type_name, network_lookup_name)
	return
end

_check_network_lookup_boundaries("attack_result_id", "attack_results")
_check_network_lookup_boundaries("attack_type_id", "attack_types")
_check_network_lookup_boundaries("bot_profile_name_id", "bot_profile_names")
_check_network_lookup_boundaries("breed_id", "breed_names")
_check_network_lookup_boundaries("cinematic_scene_name_id", "cinematic_scene_names")
_check_network_lookup_boundaries("circumstance_template_id", "circumstance_templates")
_check_network_lookup_boundaries("corruptor_arm_animation_speed_type_id", "corruptor_arm_animation_speed_types")
_check_network_lookup_boundaries("damage_profile_template_id", "damage_profile_templates")
_check_network_lookup_boundaries("damage_type_id", "damage_types")
_check_network_lookup_boundaries("dialogue_concept", "dialogues_all_concepts")
_check_network_lookup_boundaries("effect_template_id", "effect_templates")
_check_network_lookup_boundaries("game_mode_outcome_id", "game_mode_outcomes")
_check_network_lookup_boundaries("hit_zone_id", "hit_zones")
_check_network_lookup_boundaries("host_type", "host_types")
_check_network_lookup_boundaries("impact_fx_id", "impact_fx_names")
_check_network_lookup_boundaries("interaction_type_string_id", "interaction_type_strings")
_check_network_lookup_boundaries("liquid_area_template_id", "liquid_area_template_names")
_check_network_lookup_boundaries("looping_player_sound_alias_id", "player_character_looping_sound_aliases")
_check_network_lookup_boundaries("mechanism_mission_id", "missions")
_check_network_lookup_boundaries("minion_attack_selection_template_id", "minion_attack_selection_template_names")
_check_network_lookup_boundaries("minion_inventory_slot_name", "minion_inventory_slot_names")
_check_network_lookup_boundaries("mission_name_id", "missions")
_check_network_lookup_boundaries("mood_type", "moods_types")
_check_network_lookup_boundaries("optional_party_membership_denied_reason_id", "party_membership_denied_reasons")
_check_network_lookup_boundaries("optional_sound_switch_name_id", "sound_switches")
_check_network_lookup_boundaries("optional_sound_switch_value_id", "sound_switch_values")
_check_network_lookup_boundaries("player_ability_id", "player_abilities")
_check_network_lookup_boundaries("player_character_fx_source_id", "player_character_fx_sources")
_check_network_lookup_boundaries("optional_player_character_fx_source_id", "player_character_fx_sources")
_check_network_lookup_boundaries("player_character_particle_id", "player_character_particles")
_check_network_lookup_boundaries("player_character_sound_event_id", "player_character_sounds")
_check_network_lookup_boundaries("player_inventory_slot_name", "player_inventory_slot_names")
_check_network_lookup_boundaries("prop_id", "level_props_names")
_check_network_lookup_boundaries("sound_event_2d", "sound_events_2d")
_check_network_lookup_boundaries("sound_event_3d", "sound_events")
_check_network_lookup_boundaries("sound_parameter_id", "sound_parameters")
_check_network_lookup_boundaries("talent_name_id", "archetype_talent_names")
_check_network_lookup_boundaries("vfx_id", "vfx")
_check_network_lookup_boundaries("voting_option_id", "voting_options")
_check_network_lookup_boundaries("voting_result_id", "voting_results")
_check_network_lookup_boundaries("weapon_template_id", "weapon_templates")
_check_network_lookup_boundaries("smart_tag_template_id", "smart_tag_templates")
_check_network_lookup_boundaries("smart_tag_reply_name_id", "smart_tag_replies")
_check_network_lookup_boundaries("dialogue_lookup", "dialogue_names")
_check_network_lookup_boundaries("wounds_template_id", "wounds_templates")
_check_network_lookup_boundaries("lookup_1bit", "bot_orders")
_check_network_lookup_boundaries("buff_template_id", "buff_templates")
_check_network_lookup_boundaries("optional_buff_template_id", "buff_templates")
_check_network_lookup_boundaries("lookup_2bit", "chest_states")
_check_network_lookup_boundaries("door_control_panel_state", "door_control_panel_states")
_check_network_lookup_boundaries("door_state", "door_states")
_check_network_lookup_boundaries("effect_template_id", "effect_templates")
_check_network_lookup_boundaries("flow_event", "flow_events")
_check_network_lookup_boundaries("lookup_3bit", "game_object_types")
_check_network_lookup_boundaries("lookup_3bit", "hazard_prop_content")
_check_network_lookup_boundaries("lookup_2bit", "hazard_prop_states")
_check_network_lookup_boundaries("optional_herding_template_id", "herding_templates")
_check_network_lookup_boundaries("lookup_2bit", "interaction_result")
_check_network_lookup_boundaries("flicker_configuration_lookup", "light_controller_flicker_settings")
_check_network_lookup_boundaries("lookup_5bit", "line_effects")
_check_network_lookup_boundaries("lookup_2bit", "moveable_platform_direction")
_check_network_lookup_boundaries("lookup_2bit", "minigame_states")
_check_network_lookup_boundaries("minion_fx_source_name", "minion_fx_source_names")
_check_network_lookup_boundaries("lookup_9bit", "mission_objective_names")
_check_network_lookup_boundaries("mission_objective_ui_string_id", "mission_objective_ui_strings")
_check_network_lookup_boundaries("mission_ui_target_type_id", "mission_objective_target_ui_types")
_check_network_lookup_boundaries("mission_giver_vo_id", "mission_giver_vo_overrides")
_check_network_lookup_boundaries("mission_sound_event_id", "mission_sound_events")
_check_network_lookup_boundaries("package_prioritization_template_id", "package_synchronization_template_names")
_check_network_lookup_boundaries("optional_party_membership_denied_reason_id", "party_membership_denied_reasons")
_check_network_lookup_boundaries("pickup_id", "pickup_names")
_check_network_lookup_boundaries("lookup_2bit", "player_character_genders")
_check_network_lookup_boundaries("player_character_looping_particle_alias_id", "player_character_looping_particle_aliases")
_check_network_lookup_boundaries("particle_variable_id", "player_character_particle_variable_names")
_check_network_lookup_boundaries("party_member_presence_id", "presence_names")
_check_network_lookup_boundaries("projectile_locomotion_state_id", "projectile_locomotion_states")
_check_network_lookup_boundaries("projectile_template_id", "projectile_template_names")
_check_network_lookup_boundaries("lookup_3bit", "projectile_template_effects")
_check_network_lookup_boundaries("lookup_2bit", "force_field_unit_names")
_check_network_lookup_boundaries("hit_type_id", "surface_hit_types")
_check_network_lookup_boundaries("voting_template_id", "voting_templates")
_check_network_lookup_boundaries("lookup_1bit", "weapon_blood_amounts")
_check_network_lookup_boundaries("optional_wounds_shape_id", "wounds_shapes")
_check_network_lookup_boundaries("camera_shake_id", "camera_shake_events")
_check_network_lookup_boundaries("dialogue_breed_id", "dialogue_breed_names")

NetworkConstants.check_network_lookup_boundaries = _check_network_lookup_boundaries

local max_mechanism_events = Network.type_info("mechanism_event_id").max
local num_mechanism_events = #MechanismManager.EVENT_LOOKUP
local max_mechanisms = Network.type_info("mechanism_id").max
local num_mechanisms = #MechanismManager.LOOKUP
local max_buff_stack_count = Network.type_info("buff_stack_count").max
local max_allowed_buff_stack_count = BuffSettings.max_stack_count
local level_unit_id = Network.type_info("level_unit_id")

NetworkConstants.invalid_level_unit_id = level_unit_id.min
NetworkConstants.health_small = Network.type_info("health_small")
NetworkConstants.health_medium = Network.type_info("health_medium")
NetworkConstants.health_large = Network.type_info("health_large")

local toughness = Network.type_info("toughness")

NetworkConstants.toughness = toughness

for name, data in pairs(MinionToughnessTemplates) do
	for _, max_toughness in ipairs(data.max) do
		-- Nothing
	end
end

local game_object_id = Network.type_info("game_object_id")

NetworkConstants.invalid_game_object_id = game_object_id.min

local level_name_hash = Network.type_info("level_name_hash")

NetworkConstants.invalid_level_name_hash = level_name_hash.min

local minion_anim_event = Network.type_info("minion_anim_event")

NetworkConstants.max_minion_anim_event = minion_anim_event.max

local player_anim_event = Network.type_info("player_anim_event")

NetworkConstants.max_player_anim_event = player_anim_event.max

local anim_variable = Network.type_info("anim_variable")

NetworkConstants.max_anim_variable = anim_variable.max

local anim_variable_float = Network.type_info("anim_variable_float")

NetworkConstants.anim_variable_float = anim_variable_float
NetworkConstants.short_time_index = Network.type_index("short_time")

local consecutive_dodges = Network.type_info("consecutive_dodges")

NetworkConstants.max_consecutive_dodges = consecutive_dodges.max
NetworkConstants.story_time = Network.type_info("story_time")
NetworkConstants.story_speed = Network.type_info("story_speed")
NetworkConstants.flow_state_id = Network.type_info("flow_state_id")

local game_mode_state_id = Network.type_info("game_mode_state_id")

NetworkConstants.max_game_mode_state_id = game_mode_state_id.max

local projectile_locomotion_snapshot_id = Network.type_info("projectile_locomotion_snapshot_id")

NetworkConstants.max_projectile_locomotion_snapshot_id = projectile_locomotion_snapshot_id.max
NetworkConstants.weapon_charge_level = Network.type_info("weapon_charge_level")
NetworkConstants.weapon_input_sequence_is_running = Network.type_info("weapon_input_sequence_is_running")
NetworkConstants.weapon_input_sequence_current_element_index = Network.type_info("weapon_input_sequence_current_element_index")
NetworkConstants.weapon_input_sequence_element_start_t = Network.type_info("weapon_input_sequence_element_start_t")
NetworkConstants.weapon_input_queue_action_input = Network.type_info("weapon_input_queue_action_input")
NetworkConstants.weapon_input_queue_raw_input = Network.type_info("weapon_input_queue_raw_input")
NetworkConstants.weapon_input_queue_produced_by_hierarchy = Network.type_info("weapon_input_queue_produced_by_hierarchy")
NetworkConstants.weapon_input_queue_hierarchy_position = Network.type_info("weapon_input_queue_hierarchy_position")
NetworkConstants.ability_input_sequence_is_running = Network.type_info("ability_input_sequence_is_running")
NetworkConstants.ability_input_sequence_current_element_index = Network.type_info("ability_input_sequence_current_element_index")
NetworkConstants.ability_input_queue_produced_by_hierarchy = Network.type_info("ability_input_queue_produced_by_hierarchy")
NetworkConstants.ability_input_sequence_element_start_t = Network.type_info("ability_input_sequence_element_start_t")
NetworkConstants.ability_input_queue_action_input = Network.type_info("ability_input_queue_action_input")
NetworkConstants.ability_input_queue_raw_input = Network.type_info("ability_input_queue_raw_input")
NetworkConstants.ability_input_queue_hierarchy_position = Network.type_info("ability_input_queue_hierarchy_position")

local action_input_hierarchy_position = Network.type_info("action_input_hierarchy_position")

NetworkConstants.action_input_hierarchy_position_max_size = action_input_hierarchy_position.max_size

local liquid_real_index_array = Network.type_info("liquid_real_index_array")

NetworkConstants.liquid_real_index_array_max_size = liquid_real_index_array.max_size

local liquid_offset_position_array = Network.type_info("liquid_offset_position_array")
local liquid_area_is_filled_array = Network.type_info("liquid_area_is_filled_array")
local action_time_scale = Network.type_info("action_time_scale")

NetworkConstants.action_time_scale = action_time_scale

local player_anim_state = Network.type_info("player_anim_state")

NetworkConstants.invalid_player_anim_state = player_anim_state.max

local player_anim = Network.type_info("player_anim")

NetworkConstants.invalid_player_anim = player_anim.min

local player_anim_time = Network.type_info("player_anim_time")

NetworkConstants.invalid_player_anim_time = player_anim_time.max

local time_offset = Network.type_info("time_offset")

NetworkConstants.max_time_offset = time_offset.max

local nav_tag_layer_id = Network.type_info("nav_tag_layer_id")

NetworkConstants.max_nav_tag_layer_id = nav_tag_layer_id.max

local hit_zone_actor_index = Network.type_info("hit_zone_actor_index")

NetworkConstants.invalid_hit_zone_actor_index = hit_zone_actor_index.min
NetworkConstants.max_hit_zone_actor_index = hit_zone_actor_index.max

local position_id = Network.type_info("position")

NetworkConstants.min_position = position_id.min
NetworkConstants.max_position = position_id.max

local movement_settings = Network.type_info("movement_settings")

NetworkConstants.max_movement_settings = movement_settings.max

local mover_frames = Network.type_info("mover_frames")

NetworkConstants.max_mover_frames = mover_frames.max
NetworkConstants.action_combo_count = Network.type_info("action_combo_count")

local template_effect_buffer_index = Network.type_info("template_effect_buffer_index")

NetworkConstants.max_template_effect_buffer_index = template_effect_buffer_index.max

local fixed_frame_time = Network.type_info("fixed_frame_time")

NetworkConstants.max_fixed_frame_time = fixed_frame_time.max
NetworkConstants.fixed_frame_offset = Network.type_info("fixed_frame_offset")
NetworkConstants.fixed_frame_offset_small = Network.type_info("fixed_frame_offset_small")
NetworkConstants.fixed_frame_offset_start_t_5bit = Network.type_info("fixed_frame_offset_start_t_5bit")
NetworkConstants.fixed_frame_offset_start_t_6bit = Network.type_info("fixed_frame_offset_start_t_6bit")
NetworkConstants.fixed_frame_offset_start_t_7bit = Network.type_info("fixed_frame_offset_start_t_7bit")
NetworkConstants.fixed_frame_offset_start_t_9bit = Network.type_info("fixed_frame_offset_start_t_9bit")
NetworkConstants.fixed_frame_offset_end_t_4bit = Network.type_info("fixed_frame_offset_end_t_4bit")
NetworkConstants.fixed_frame_offset_end_t_6bit = Network.type_info("fixed_frame_offset_end_t_6bit")
NetworkConstants.fixed_frame_offset_end_t_7bit = Network.type_info("fixed_frame_offset_end_t_7bit")

local prd_state = Network.type_info("prd_state")

NetworkConstants.max_prd_state = prd_state.max

local ability_charges = Network.type_info("ability_charges")
local ability_cooldown = Network.type_info("ability_cooldown")

for name, ability in pairs(PlayerAbilities) do
	local max_charges = ability.max_charges
	local max_cooldown = ability.cooldown

	if max_cooldown then
		-- Nothing
	end
end

local dialogue_rule_index = Network.type_info("dialogue_rule_index")
local max_dialogue_rules = dialogue_rule_index.max
local database_rules_number = TagQueryDatabase.NUM_DATABASE_RULES

NetworkConstants.ammunition_large = Network.type_info("ammunition_large")
NetworkConstants.ammunition_small = Network.type_info("ammunition_small")

local function _check_dialogue_breed_settings_voices()
	local max_num_wwise_voices = 0

	for breed_name, data in pairs(DialogueBreedSettings) do
		local wwise_voices = data.wwise_voices

		if wwise_voices then
			local num_wwise_voices = #wwise_voices

			max_num_wwise_voices = math.max(max_num_wwise_voices, num_wwise_voices)
		end
	end

	local network_variable_info = Network.type_info("dialogue_voice_index")
	local max_network_value = network_variable_info.max
end

_check_dialogue_breed_settings_voices()

return NetworkConstants
