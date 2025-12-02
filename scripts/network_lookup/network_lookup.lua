-- chunkname: @scripts/network_lookup/network_lookup.lua

local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BloodSettings = require("scripts/settings/blood/blood_settings")
local BotCharacterProfiles = require("scripts/settings/bot_character_profiles")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local CameraEffectSettings = require("scripts/settings/camera/camera_effect_settings")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local CorruptorSettings = require("scripts/settings/corruptor/corruptor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local DialogueLookup = require("scripts/settings/dialogue/dialogue_lookup")
local DialogueLookupConcepts = require("scripts/settings/dialogue/dialogue_lookup_concepts")
local DialogueLookupVoiceProfiles = require("scripts/settings/dialogue/dialogue_lookup_voice_profiles")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FlowEvents = require("scripts/settings/fx/flow_events")
local HavocSettings = require("scripts/settings/havoc_settings")
local HazardPropSettings = require("scripts/settings/hazard_prop/hazard_prop_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffectSettings = require("scripts/settings/damage/impact_effect_settings")
local InteractionTypeStrings = require("scripts/settings/interaction/interaction_type_strings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local LightControllerFlickerSettings = require("scripts/settings/components/light_controller_flicker")
local LineEffects = require("scripts/settings/effects/line_effects")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MaterialQuerySettings = require("scripts/settings/material_query_settings")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local MinionAttackSelectionTemplates = require("scripts/settings/minion_attack_selection/minion_attack_selection_templates")
local MinionVisualLoadoutTemplates = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_templates")
local MissionGiverVoSettings = require("scripts/settings/dialogue/mission_giver_vo_settings")
local Missions = require("scripts/settings/mission/mission_templates")
local MissionsObjectiveTargetUiTypeStrings = require("scripts/settings/mission_objective_target/mission_objective_target_ui_type_strings")
local MissionsObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionsObjectiveUiStrings = require("scripts/settings/mission_objective/mission_objective_ui_strings")
local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local MutatorMinionVisualOverrideSettings = require("scripts/settings/mutator/mutator_mininion_visual_overrides_settings")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local OutlineSettings = require("scripts/settings/outline/outline_settings")
local PackagePrioritizationTemplates = require("scripts/loading/package_prioritization_templates")
local PartyConstants = require("scripts/settings/network/party_constants")
local PayloadSettings = require("scripts/settings/payload/payload_settings")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterDecalNames = require("scripts/settings/decal/player_character_decal_names")
local PlayerCharacterFxSourceNames = require("scripts/settings/fx/player_character_fx_source_names")
local PlayerCharacterLoopingParticleAliases = require("scripts/settings/particles/player_character_looping_particle_aliases")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local PlayerCharacterParticleNames = require("scripts/settings/particles/player_character_particle_names")
local PlayerCharacterSounds = require("scripts/settings/sound/player_character_sounds")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTagSettings = require("scripts/settings/smart_tag/smart_tag_settings")
local SoundEvents = require("scripts/settings/sound/sound_events")
local SoundEvents2d = require("scripts/settings/sound/2d_sound_events")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local TimedExplosivesSettings = require("scripts/settings/timed_explosives/timed_explosives_settings")
local VfxNames = require("scripts/settings/fx/vfx_names")
local VotingTemplates = require("scripts/settings/voting/voting_templates")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")

local function _create_lookup(lookup, hashtable)
	local existing_keys = {}
	local new_keys = {}

	for i = 1, #lookup do
		existing_keys[lookup[i]] = true
	end

	for key in pairs(hashtable) do
		if not existing_keys[key] then
			table.insert(new_keys, key)
		end
	end

	table.sort(new_keys)

	for _, key in ipairs(new_keys) do
		table.insert(lookup, key)
	end

	return lookup
end

NetworkLookup = {}

local archetype_talent_names = {}

for _, archetype_talents in pairs(ArchetypeTalents) do
	for name, _ in pairs(archetype_talents) do
		archetype_talent_names[name] = true
	end
end

NetworkLookup.archetype_talent_names = _create_lookup({
	"n/a",
}, archetype_talent_names)
NetworkLookup.attack_results = _create_lookup({}, AttackSettings.attack_results)
NetworkLookup.attack_types = _create_lookup({}, AttackSettings.attack_types)
NetworkLookup.bot_orders = {
	"drop",
	"pickup",
}

local no_item_definitions = {}
local bot_profiles = BotCharacterProfiles(no_item_definitions)

NetworkLookup.bot_profile_names = _create_lookup({}, bot_profiles)
NetworkLookup.breed_names = _create_lookup({}, Breeds)
NetworkLookup.dialogue_breed_names = _create_lookup({}, DialogueBreedSettings)
NetworkLookup.buff_templates = _create_lookup({}, BuffTemplates)
NetworkLookup.synced_buff_keywords = _create_lookup({}, BuffSettings.network_synced_keywords)
NetworkLookup.camera_shake_events = _create_lookup({}, CameraEffectSettings.shake)
NetworkLookup.chest_states = {
	"closed",
	"locked",
	"opened",
}
NetworkLookup.cinematic_scene_names = _create_lookup({}, CinematicSceneSettings.CINEMATIC_NAMES)
NetworkLookup.circumstance_templates = _create_lookup({}, CircumstanceTemplates)
NetworkLookup.MutatorMinionVisualOverrideSettings = _create_lookup({}, MutatorMinionVisualOverrideSettings)
NetworkLookup.corruptor_arm_animation_speed_types = _create_lookup({}, CorruptorSettings.animation_speed_multiplier)
NetworkLookup.damage_efficiencies = _create_lookup({}, AttackSettings.damage_efficiencies)
NetworkLookup.damage_profile_templates = _create_lookup({}, DamageProfileTemplates)
NetworkLookup.damage_types = _create_lookup({
	"nil",
}, DamageSettings.damage_types)
NetworkLookup.dialogue_names = DialogueLookup
NetworkLookup.dialogues_all_concepts = table.clone(DialogueLookupConcepts.all_concepts)
NetworkLookup.dialogue_voice_profiles = _create_lookup({}, DialogueLookupVoiceProfiles)
NetworkLookup.dynamic_smart_tags = _create_lookup({}, DialogueSettings.dynamic_smart_tags)
NetworkLookup.manual_subtitles = _create_lookup({}, DialogueSettings.manual_subtitles)
NetworkLookup.backend_vo_groups = _create_lookup({}, DialogueSettings.backend_vo_groups)
NetworkLookup.horde_mode_vo = _create_lookup({}, DialogueSettings.horde_mode)
NetworkLookup.door_control_panel_states = {
	"active",
	"inactive",
}
NetworkLookup.door_states = {
	"none",
	"open",
	"open_fwd",
	"open_bwd",
	"closed",
}
NetworkLookup.effect_templates = _create_lookup({}, EffectTemplates)
NetworkLookup.explosion_templates = _create_lookup({}, ExplosionTemplates)
NetworkLookup.emote_slots = {
	"slot_animation_emote_1",
	"slot_animation_emote_2",
	"slot_animation_emote_3",
	"slot_animation_emote_4",
	"slot_animation_emote_5",
}
NetworkLookup.flow_events = FlowEvents
NetworkLookup.game_mode_outcomes = {
	"n/a",
	"won",
	"lost",
}
NetworkLookup.game_object_types = {
	"unit_template",
	"materials_collected",
	"music_parameters",
	"prop_health",
	"scanning_device",
	"server_unit_data_state",
	"server_husk_data_state",
	"server_husk_hud_data_state",
}
NetworkLookup.hazard_prop_content = _create_lookup({}, HazardPropSettings.hazard_content)
NetworkLookup.hazard_prop_states = _create_lookup({}, HazardPropSettings.hazard_state)
NetworkLookup.herding_templates = _create_lookup({}, HerdingTemplates)
NetworkLookup.hit_zones = _create_lookup({}, HitZone.hit_zone_names)
NetworkLookup.hordes_build_families = {
	"fire",
	"electric",
	"elementalist",
	"unkillable",
	"cowboy",
	"critical",
	"unstoppable",
}
NetworkLookup.hordes_island_names = {
	"island_void",
	"island_rooftops",
	"island_machine",
}
NetworkLookup.host_types = _create_lookup({}, MatchmakingConstants.HOST_TYPES)
NetworkLookup.impact_fx_names = _create_lookup({}, ImpactEffectSettings.impact_fx_templates)
NetworkLookup.interaction_result = {
	"success",
	"stopped_holding",
	"interaction_cancelled",
}
NetworkLookup.interaction_type_strings = InteractionTypeStrings
NetworkLookup.level_props_names = _create_lookup({}, LevelProps)
NetworkLookup.light_controller_flicker_settings = _create_lookup({}, LightControllerFlickerSettings)
NetworkLookup.line_effects = _create_lookup({}, LineEffects)
NetworkLookup.liquid_area_template_names = _create_lookup({}, LiquidAreaTemplates)
NetworkLookup.material_type_lookup = {
	"diamantine",
	"plasteel",
	"event_material",
}
NetworkLookup.material_size_lookup = {
	"large",
	"small",
	"medium",
}
NetworkLookup.collectible_type_lookup = {
	"collectible",
	"destructible",
}
NetworkLookup.moveable_platform_direction = {
	"none",
	"forward",
	"backward",
}
NetworkLookup.outline_types = _create_lookup({}, OutlineSettings.outline_types)
NetworkLookup.assist_type_lookup = {
	"assisted",
	"saved",
	"revived",
	"rescued",
	"cleansed",
	"gifted",
	"stimmed",
}
NetworkLookup.payload_states = _create_lookup({}, PayloadSettings.states)
NetworkLookup.payload_speed_controllers = _create_lookup({}, PayloadSettings.payload_speed_controllers)
NetworkLookup.minigame_game_states = _create_lookup({}, MinigameSettings.game_states)

local minion_attack_selection_template_names = {}

NetworkLookup.minion_attack_selection_template_names = _create_lookup(minion_attack_selection_template_names, MinionAttackSelectionTemplates)
NetworkLookup.minion_fx_source_names = {
	"muzzle",
}

local minion_inventory_slot_names = {}

for breed_name, all_templates in pairs(MinionVisualLoadoutTemplates) do
	for template_key, breed_specific_templates in pairs(all_templates) do
		for i = 1, #breed_specific_templates do
			local inventory = breed_specific_templates[i]
			local inventory_slots = inventory.slots

			for slot_name, _ in pairs(inventory_slots) do
				minion_inventory_slot_names[slot_name] = true
			end
		end
	end
end

NetworkLookup.minion_inventory_slot_names = _create_lookup({}, minion_inventory_slot_names)

local mission_objective_names = {}

for _, template in pairs(MissionsObjectiveTemplates) do
	local mission_objectives = template.objectives

	for name, _ in pairs(mission_objectives) do
		mission_objective_names[name] = true
	end
end

NetworkLookup.mission_objective_names = _create_lookup({}, mission_objective_names)
NetworkLookup.mission_objective_ui_strings = MissionsObjectiveUiStrings
NetworkLookup.mission_objective_target_ui_types = MissionsObjectiveTargetUiTypeStrings
NetworkLookup.mission_objective_ui_states = {
	"default",
	"alert",
}
NetworkLookup.mission_giver_vo_overrides = _create_lookup({}, MissionGiverVoSettings.overrides)
NetworkLookup.missions = _create_lookup({}, Missions)
NetworkLookup.mission_sound_events = _create_lookup({}, MissionSoundEvents)
NetworkLookup.moods_types = _create_lookup({}, MoodSettings.mood_types)
NetworkLookup.package_synchronization_template_names = _create_lookup({}, PackagePrioritizationTemplates)
NetworkLookup.party_membership_denied_reasons = _create_lookup({}, PartyConstants.MembershipDeniedReasons)
NetworkLookup.pickup_names = _create_lookup({}, Pickups.by_name)
NetworkLookup.player_character_genders = {
	"female",
	"male",
	"ogryn",
}
NetworkLookup.player_character_fx_sources = _create_lookup({
	"n/a",
}, PlayerCharacterFxSourceNames)
NetworkLookup.player_character_looping_particle_aliases = _create_lookup({}, PlayerCharacterLoopingParticleAliases)
NetworkLookup.player_character_looping_sound_aliases = _create_lookup({}, PlayerCharacterLoopingSoundAliases)
NetworkLookup.player_character_particle_variable_names = {
	"radius",
	"size",
	"intensity",
}
NetworkLookup.player_character_particles = table.clone(PlayerCharacterParticleNames)
NetworkLookup.player_character_decals = table.clone(PlayerCharacterDecalNames)

local player_character_sounds = {
	["wwise/events/minions/play_enemy_daemonhost_execute_player_impact"] = true,
	["wwise/events/minions/play_enemy_daemonhost_execute_player_impact_husk"] = true,
	["wwise/events/minions/play_minion_twins_disappear_explosion"] = true,
	["wwise/events/player/play_backstab_indicator_melee"] = true,
	["wwise/events/player/play_backstab_indicator_melee_elite"] = true,
	["wwise/events/player/play_backstab_indicator_ranged"] = true,
	["wwise/events/player/play_foley_fall_wind_2D"] = true,
	["wwise/events/player/play_horde_mode_buff_ammo_refill"] = true,
	["wwise/events/player/play_horde_mode_buff_avoid_hit"] = true,
	["wwise/events/player/play_horde_mode_buff_avoid_hit_activated"] = true,
	["wwise/events/player/play_horde_mode_buff_dublicate"] = true,
	["wwise/events/player/play_horde_mode_buff_electric_crit"] = true,
	["wwise/events/player/play_horde_mode_buff_grenade_refill"] = true,
	["wwise/events/player/play_horde_mode_buff_infinite_ammo_start"] = true,
	["wwise/events/player/play_horde_mode_buff_infinite_ammo_stop"] = true,
	["wwise/events/player/play_horde_mode_buff_infinite_cleave_hit"] = true,
	["wwise/events/player/play_horde_mode_buff_nurgle_trail_loop"] = true,
	["wwise/events/player/play_horde_mode_buff_rock_charge_finish"] = true,
	["wwise/events/player/play_horde_mode_buff_rock_charge_loop"] = true,
	["wwise/events/player/play_horde_mode_buff_self_damage_negated"] = true,
	["wwise/events/player/play_horde_mode_buff_shield_hit"] = true,
	["wwise/events/player/play_horde_mode_buff_super_crit"] = true,
	["wwise/events/player/play_pick_up_ammo_01"] = true,
	["wwise/events/player/play_player_dodge_melee_success"] = true,
	["wwise/events/player/play_player_dodge_ranged_success"] = true,
	["wwise/events/player/play_player_experience_fall_damage_2d"] = true,
	["wwise/events/player/play_player_get_hit_2d_corruption_tick_toughness"] = true,
	["wwise/events/player/play_player_get_hit_corruption_2d"] = true,
	["wwise/events/player/play_player_get_hit_corruption_2d_tick"] = true,
	["wwise/events/player/play_player_get_hit_fire"] = true,
	["wwise/events/player/play_player_get_hit_fire_toughness"] = true,
	["wwise/events/player/play_player_get_hit_heavy_2d"] = true,
	["wwise/events/player/play_player_get_hit_light_2d"] = true,
	["wwise/events/player/play_player_get_hit_sharp"] = true,
	["wwise/events/player/play_player_vomit_enter"] = true,
	["wwise/events/player/play_psyker_ability_shout"] = true,
	["wwise/events/player/play_syringe_healed_by_ally"] = true,
	["wwise/events/player/play_toughness_break"] = true,
	["wwise/events/player/play_toughness_hits"] = true,
	["wwise/events/player/play_vault"] = true,
	["wwise/events/player/stop_foley_fall_wind_2D"] = true,
	["wwise/events/player/stop_horde_mode_buff_nurgle_trail_loop"] = true,
	["wwise/events/player/stop_horde_mode_buff_rock_charge_loop"] = true,
	["wwise/events/ui/play_hud_coherency_off"] = true,
	["wwise/events/ui/play_hud_coherency_on"] = true,
	["wwise/events/ui/play_hud_heal_2d"] = true,
	["wwise/events/ui/play_hud_health_station_2d"] = true,
	["wwise/events/weapon/play_bullet_hits_gen_unarmored_death"] = true,
	["wwise/events/weapon/play_enemy_netgunner_net_trapped"] = true,
	["wwise/events/weapon/play_explosion_flamer_tank"] = true,
	["wwise/events/weapon/play_explosion_force_med"] = true,
	["wwise/events/weapon/play_horde_mode_buff_fire_burst"] = true,
	["wwise/events/weapon/play_horde_mode_buff_shield"] = true,
	["wwise/events/weapon/play_horde_mode_heal_self_confirmation"] = true,
	["wwise/events/weapon/play_indicator_crit"] = true,
	["wwise/events/weapon/play_indicator_weakspot"] = true,
	["wwise/events/weapon/play_shared_combat_weapon_bolter_bullet_flyby"] = true,
	["wwise/events/weapon/play_weapon_lasgun_crack_beam_nearby"] = true,
}

for event_name, _ in pairs(PlayerCharacterSounds.resource_events) do
	player_character_sounds[event_name] = true
end

NetworkLookup.player_character_sounds = _create_lookup({
	"n/a",
}, player_character_sounds)
NetworkLookup.player_abilities = _create_lookup({
	"not_equipped",
}, PlayerAbilities)
NetworkLookup.player_inventory_slot_names = _create_lookup({}, PlayerCharacterConstants.slot_configuration)
NetworkLookup.presence_names = _create_lookup({}, PresenceSettings.settings)
NetworkLookup.projectile_locomotion_states = _create_lookup({}, ProjectileLocomotionSettings.states)
NetworkLookup.projectile_template_names = _create_lookup({}, ProjectileTemplates)

local projectile_template_effects = {}

NetworkLookup.projectile_templates_effect_names = {}

for _, projectile_template in pairs(ProjectileTemplates) do
	local effects = projectile_template.effects

	if effects then
		for effect_name, _ in pairs(effects) do
			projectile_template_effects[effect_name] = true
		end
	end
end

NetworkLookup.projectile_template_effects = _create_lookup({}, projectile_template_effects)
NetworkLookup.respawn_beacon_states = {
	"none",
	"activating",
	"spawning",
}
NetworkLookup.force_field_unit_names = {
	"content/characters/player/human/attachments_combat/psyker_shield/psyker_shield_flat_functional",
	"content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_functional",
}
NetworkLookup.force_field_shape_overrides = {
	"none",
	"flat",
	"sphere",
}
NetworkLookup.smoke_fog_unit = {
	"content/characters/player/human/attachments_combat/smoke_fog/smoke_fog_volume",
	"content/smoke_fog/empty_unit/empty_unit",
}
NetworkLookup.smart_tag_replies = _create_lookup({}, SmartTagSettings.replies)
NetworkLookup.smart_tag_templates = _create_lookup({}, SmartTagSettings.templates)
NetworkLookup.sound_events = SoundEvents
NetworkLookup.sound_events_2d = _create_lookup({}, SoundEvents2d)
NetworkLookup.sound_parameters = {
	"combat_chainsword_cut",
	"combat_chainsword_throttle",
	"fall_height",
	"lasgun_charge",
	"overheat_plasma_gun",
	"player_experience_toughness",
	"player_fall_time",
	"psyker_overload",
	"wpn_fire_interval",
	"charge_level",
	"psyker_overload_global",
	"auspex_scanner_speed",
	"auspex_a_h",
	"auspex_a_w",
	"auspex_b_h",
	"auspex_b_w",
	"auspex_b_goal",
	"ability_duration",
}
NetworkLookup.sound_switches = {
	"surface_material",
}
NetworkLookup.sound_switch_values = {
	"default",
}

table.append(NetworkLookup.sound_switch_values, MaterialQuerySettings.surface_materials)

NetworkLookup.surface_materials = table.append({}, MaterialQuerySettings.surface_materials)
NetworkLookup.surface_hit_types = _create_lookup({}, SurfaceMaterialSettings.hit_types)
NetworkLookup.timed_explosives = _create_lookup({}, TimedExplosivesSettings)
NetworkLookup.vfx = _create_lookup({}, VfxNames)

local voting_options, voting_results = {}, {}

for _, voting_template in pairs(VotingTemplates.network) do
	if voting_template.options then
		for _, option in pairs(voting_template.options) do
			voting_options[option] = true
		end

		for _, result in pairs(voting_template.results) do
			voting_results[result] = true
		end
	end
end

NetworkLookup.voting_options = _create_lookup({
	"nil",
}, voting_options)
NetworkLookup.voting_results = _create_lookup({}, voting_results)
NetworkLookup.voting_templates = _create_lookup({}, VotingTemplates.network)
NetworkLookup.weapon_blood_amounts = _create_lookup({}, BloodSettings.weapon_blood_amounts)

local EMPTY_TABLE = {}
local weapon_modifiers = {}

for _, weapon_template in pairs(WeaponTemplates) do
	local base_stats = weapon_template.base_stats or EMPTY_TABLE
	local perks = weapon_template.perks or EMPTY_TABLE
	local overclocks = weapon_template.overclocks or EMPTY_TABLE

	for modifier_name, _ in pairs(base_stats) do
		weapon_modifiers[modifier_name] = true
	end

	for modifier_name, _ in pairs(overclocks) do
		weapon_modifiers[modifier_name] = true
	end
end

for trait_name, _ in pairs(WeaponTraitTemplates) do
	weapon_modifiers[trait_name] = true
end

NetworkLookup.weapon_modifiers = _create_lookup({}, weapon_modifiers)
NetworkLookup.weapon_modifier_override_type = _create_lookup({}, {
	base_stats = true,
	perks = true,
	traits = true,
})
NetworkLookup.weapon_modifier_override_keys = _create_lookup({}, {
	id = true,
	name = true,
	rarity = true,
	value = true,
})
NetworkLookup.weapon_templates = _create_lookup({}, WeaponTemplates)
NetworkLookup.wounds_templates = _create_lookup({}, WoundsTemplates)
NetworkLookup.wounds_shapes = _create_lookup({}, WoundsSettings.shapes)

local hash_table = {}

for i = 1, #HavocSettings.modifiers do
	local modifier = HavocSettings.modifiers[i]

	hash_table[modifier] = true
end

for i = 1, #HavocSettings.positive_modifiers do
	local modifier = HavocSettings.positive_modifiers[i]

	hash_table[modifier] = true
end

NetworkLookup.havoc_modifiers = _create_lookup({}, hash_table)

local function _init(name, lookup_table)
	for index, key in ipairs(lookup_table) do
		lookup_table[key] = index
	end

	local index_error_print = "[NetworkLookup] Table " .. name .. " does not contain key: "
	local meta = {
		__index = function (_, key)
			table.dump(lookup_table)
			error(index_error_print .. tostring(key))
		end,
	}

	setmetatable(lookup_table, meta)
end

for name, lookup_table in pairs(NetworkLookup) do
	_init(name, lookup_table)
end

local DynamicLookup = {
	player_attachment_names = "player_attachment_names",
	player_item_names = "player_item_names",
}

NetworkLookup._create_dynamic_lookup = function (name, hashtable, ...)
	local lookup = {
		...,
	}

	_create_lookup(lookup, hashtable)
	_init(name, lookup)

	NetworkLookup[name] = lookup
end

NetworkLookup.create_item_names_lookup = function (items)
	NetworkLookup._create_dynamic_lookup(DynamicLookup.player_item_names, items, "not_equipped")
end

NetworkLookup._create_attachment_names_lookup_recursive = function (attachment_names, items, item)
	local attachments = item.attachments

	if attachments then
		for attachment_name, child in pairs(attachments) do
			attachment_names[attachment_name] = true

			NetworkLookup._create_attachment_names_lookup_recursive(attachment_names, items, child)

			local child_item = items[child.item]

			if child_item then
				NetworkLookup._create_attachment_names_lookup_recursive(attachment_names, items, child_item)
			end
		end
	end

	local children = item.children

	if children then
		for child_name, child in pairs(children) do
			attachment_names[child_name] = true

			NetworkLookup._create_attachment_names_lookup_recursive(attachment_names, items, child)

			local child_item = items[child.item]

			if child_item then
				NetworkLookup._create_attachment_names_lookup_recursive(attachment_names, items, child_item)
			end
		end
	end
end

NetworkLookup.create_attachment_names_lookup = function (items)
	local attachment_names = {}

	for _, item in pairs(items) do
		NetworkLookup._create_attachment_names_lookup_recursive(attachment_names, items, item)
	end

	NetworkLookup._create_dynamic_lookup(DynamicLookup.player_attachment_names, attachment_names, "n/a", VisualLoadoutCustomization.ROOT_ATTACH_NAME)
end

return NetworkLookup
