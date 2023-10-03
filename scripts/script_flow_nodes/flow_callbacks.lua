local BotSpawning = require("scripts/managers/bot/bot_spawning")
local CameraShake = require("scripts/utilities/camera/camera_shake")
local Effect = require("scripts/extension_systems/fx/utilities/effect")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Footstep = require("scripts/utilities/footstep")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local MaterialQuery = require("scripts/utilities/material_query")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerVisibility = require("scripts/utilities/player_visibility")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local ScriptWorld = "scripts/foundation/utilities/script_world"
local Vo = require("scripts/utilities/vo")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local unit_alive = Unit.alive
local Vector3 = Vector3
local Quaternion = Quaternion
local Matrix4x4 = Matrix4x4
local Unit = Unit
local flow_return_table = {}
FlowCallbacks = FlowCallbacks or {}
local unit_flow_event = Unit.flow_event

FlowCallbacks.clear_return_value = function ()
	table.clear(flow_return_table)
end

FlowCallbacks.anim_callback = function (params)
	local unit = params.unit
	local callback_name = params.callback
	local param1 = params.param1
	local animation_system = Managers.state.extension:system("animation_system")

	animation_system:anim_callback(unit, callback_name, param1)
end

FlowCallbacks.call_anim_event = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.unit
	local event_name = params.event_name
	local animation_extension = ScriptUnit.has_extension(unit, "animation_system")

	if animation_extension then
		animation_extension:anim_event(event_name)
	end
end

FlowCallbacks.play_npc_foley = function (params)
	local unit = params.unit
	local event_resource = params.event_resource
	local unit_node = Unit.node(unit, params.unit_node)
	local world = Application.flow_callback_context_world()
	local wwise_world = World.get_data(world, "wwise_world")
	local source_id = WwiseWorld.make_auto_source(wwise_world, unit, unit_node)

	WwiseWorld.trigger_resource_event(wwise_world, event_resource, source_id)
end

FlowCallbacks.play_npc_vce = function (params)
	local unit = params.unit
	local event_resource = params.event_resource
	local world = Application.flow_callback_context_world()
	local wwise_world = World.get_data(world, "wwise_world")
	local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

	if dialogue_extension then
		local unit_node = dialogue_extension:get_voice_node()
		local source_id = WwiseWorld.make_auto_source(wwise_world, unit, unit_node)
		local wwise_switch_group, selected_voice = dialogue_extension:voice_data()

		WwiseWorld.set_switch(wwise_world, wwise_switch_group, selected_voice, source_id)
		WwiseWorld.trigger_resource_event(wwise_world, event_resource, true, source_id)
	end
end

FlowCallbacks.set_allowed_nav_tag_volume_name = function (params)
	local volume_name = params.volume_name
	local allowed = params.allowed
	local nav_mesh_manager = Managers.state.nav_mesh

	nav_mesh_manager:set_allowed_nav_tag_layer(volume_name, allowed)
end

FlowCallbacks.set_allowed_nav_tag_volume_type = function (params)
	local volume_type = params.volume_type
	local allowed = params.allowed
	local nav_mesh_manager = Managers.state.nav_mesh
	local nav_tag_volume_data = nav_mesh_manager:nav_tag_volume_data()

	for i = 1, #nav_tag_volume_data do
		local data = nav_tag_volume_data[i]

		if data.type == volume_type then
			nav_mesh_manager:set_allowed_nav_tag_layer(data.name, allowed)
		end
	end
end

FlowCallbacks.enable_script_component = function (params)
	local guid = params.guid
	local unit = params.unit

	Managers.state.extension:system("component_system"):enable_component(unit, guid)
end

FlowCallbacks.disable_script_component = function (params)
	local guid = params.guid
	local unit = params.unit

	Managers.state.extension:system("component_system"):disable_component(unit, guid)
end

FlowCallbacks.call_script_component = function (params)
	local guid = params.guid
	local unit = params.unit
	local value = params.value
	local function_name = params.event

	Managers.state.extension:system("component_system"):flow_call_component(unit, guid, function_name, value)
end

FlowCallbacks.get_component_data = function (params)
	local guid = params.guid
	local unit = params.unit
	local key = params.key
	flow_return_table.out_value = Unit.get_data(unit, "components", guid, "component_data", key)

	return flow_return_table
end

FlowCallbacks.set_component_data = function (params)
	local guid = params.guid
	local unit = params.unit
	local key = params.key
	local value = params.value

	Unit.set_data(unit, "components", guid, "component_data", key, value)
end

FlowCallbacks.volume_event_set_enabled = function (params)
	local volume_name = params.volume_name
	local enabled = params.enabled
	local volume_event_system = Managers.state.extension:system("volume_event_system")

	if enabled then
		volume_event_system:register_volumes_by_name(volume_name)
	else
		volume_event_system:unregister_volumes_by_name(volume_name)
	end
end

FlowCallbacks.volume_event_connect_unit = function (params)
	local volume_name = params.volume_name
	local unit = params.unit
	local volume_event_system = Managers.state.extension:system("volume_event_system")

	volume_event_system:connect_unit_to_volume(volume_name, unit)
end

FlowCallbacks.volume_event_disconnect_unit = function (params)
	local volume_name = params.volume_name
	local unit = params.unit
	local volume_event_system = Managers.state.extension:system("volume_event_system")

	volume_event_system:disconnect_unit_from_volume(volume_name, unit)
end

local function _set_minion_foley_speed(unit, wwise_world, source_id)
	local locomotion_extension = ScriptUnit.has_extension(unit, "locomotion_system")

	if not locomotion_extension then
		return
	end

	local current_velocity = locomotion_extension:current_velocity()
	local move_speed = Vector3.length(current_velocity)

	WwiseWorld.set_source_parameter(wwise_world, source_id, "foley_speed", move_speed)
end

local function _minion_auto_source_trigger_wwise_event(unit, param_sound_source_object, param_sound_position, wwise_world, wwise_event)
	local wwise_playing_id, source_id = nil
	local sound_source_object = 1

	if param_sound_source_object then
		sound_source_object = Unit.node(unit, param_sound_source_object)
	end

	if param_sound_position then
		local world_position = Vector3.add(Unit.world_position(unit, sound_source_object), param_sound_position)
		wwise_playing_id, source_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, world_position)
	else
		wwise_playing_id, source_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, unit, sound_source_object)
	end

	return wwise_playing_id, source_id
end

local function _minion_update_special_targeting_parameter(unit, wwise_world, source_id)
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	if game_object_id then
		local target_unit_id = GameSession.game_object_field(game_session, game_object_id, "target_unit_id")

		if target_unit_id ~= NetworkConstants.invalid_game_object_id then
			local target_unit = Managers.state.unit_spawner:unit(target_unit_id)

			if not target_unit then
				return
			end

			Effect.update_targeted_by_special_wwise_parameters(target_unit, wwise_world, source_id, nil, unit)
		end
	end
end

local MIN_MELEE_TARGETING_DISTANCE = 10

local function _minion_update_targeted_in_melee_parameter(unit, wwise_world, source_id)
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	if game_object_id then
		local target_unit_id = GameSession.game_object_field(game_session, game_object_id, "target_unit_id")

		if target_unit_id ~= NetworkConstants.invalid_game_object_id then
			local target_unit = Managers.state.unit_spawner:unit(target_unit_id)

			if not target_unit then
				return
			end

			local unit_pos = Unit.world_position(unit, 1)
			local target_pos = Unit.world_position(target_unit, 1)
			local distance = Vector3.distance(unit_pos, target_pos)

			if distance <= MIN_MELEE_TARGETING_DISTANCE then
				Effect.update_targeted_in_melee_wwise_parameters(target_unit, wwise_world, source_id)
			end
		end
	end
end

FlowCallbacks.minion_fx = function (params)
	if DEDICATED_SERVER then
		flow_return_table.effect_id = nil
		flow_return_table.playing_id = nil

		return flow_return_table
	end

	local unit = params.unit
	local name = params.name
	local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()
	local sounds = breed.sounds
	local wwise_events = sounds.events
	local use_proximity_culling = sounds.use_proximity_culling
	local wwise_event = wwise_events[name]
	local sound_uses_proximity_culling = use_proximity_culling[name]
	local legacy_v2_proximity_extension = ScriptUnit.extension(unit, "legacy_v2_proximity_system")
	local is_proximity_fx_enabled = legacy_v2_proximity_extension.is_proximity_fx_enabled

	if sound_uses_proximity_culling and not is_proximity_fx_enabled then
		flow_return_table.effect_id = nil
		flow_return_table.playing_id = nil

		return flow_return_table
	end

	local vfx = breed.vfx
	local particle_name = vfx[name]
	local switch_on_wielded_slot = params.switch_on_wielded_slot

	if switch_on_wielded_slot then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local wielded_slot_name = visual_loadout_extension:wielded_slot_name()

		if wielded_slot_name then
			if type(wwise_event) == "table" then
				wwise_event = wwise_event[wielded_slot_name]
			end

			if type(particle_name) == "table" then
				particle_name = particle_name[wielded_slot_name]
			end
		else
			wwise_event = nil
			particle_name = nil
		end
	end

	local world_manager = Managers.world
	local world = world_manager:world("level_world")
	local wwise_playing_id = nil

	if wwise_event then
		local wwise_world = world_manager:wwise_world(world)
		local source_id = params.sound_existing_source_id

		if source_id then
			if params.sound_set_speed_parameter then
				_set_minion_foley_speed(unit, wwise_world, source_id)
			end

			local play_vce = true
			local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

			if dialogue_extension then
				local is_playing_vo = dialogue_extension:is_currently_playing_dialogue()

				if is_playing_vo then
					local suppress_vo = params.sound_suppress_vo

					if suppress_vo then
						dialogue_extension:stop_currently_playing_vo()
					else
						play_vce = false
					end
				end

				if params.sound_use_breed_voice_profile then
					local wwise_switch_group, selected_voice = dialogue_extension:voice_data()

					WwiseWorld.set_switch(wwise_world, wwise_switch_group, selected_voice, source_id)
				end
			end

			wwise_playing_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, source_id)

			if breed.uses_wwise_special_targeting_parameter then
				_minion_update_special_targeting_parameter(unit, wwise_world, source_id)
			else
				_minion_update_targeted_in_melee_parameter(unit, wwise_world, source_id)
			end
		else
			wwise_playing_id, source_id = _minion_auto_source_trigger_wwise_event(unit, params.sound_source_object, params.sound_position, wwise_world, wwise_event)

			if breed.uses_wwise_special_targeting_parameter then
				_minion_update_special_targeting_parameter(unit, wwise_world, source_id)
			else
				_minion_update_targeted_in_melee_parameter(unit, wwise_world, source_id)
			end

			if params.sound_set_speed_parameter then
				_set_minion_foley_speed(unit, wwise_world, source_id)
			end
		end
	end

	if not is_proximity_fx_enabled then
		flow_return_table.effect_id = nil
		flow_return_table.playing_id = wwise_playing_id

		return flow_return_table
	end

	local effect_id = nil

	if particle_name then
		if type(particle_name) == "table" then
			particle_name = particle_name[math.random(1, #particle_name)]
		end

		local node_name = params.particle_source_object

		if params.particle_linked then
			effect_id = World.create_particles(world, particle_name)
			local node = Unit.node(unit, node_name)
			local pose = Matrix4x4.from_quaternion_position(params.particle_rotation_offset or Quaternion.identity(), params.particle_offset or Vector3.zero())

			World.link_particles(world, effect_id, unit, node, pose, params.particle_orphaned_policy)
		elseif node_name then
			local node = Unit.node(unit, node_name)
			local node_pose = Unit.world_pose(unit, node)
			local pose = Matrix4x4.multiply(node_pose, Matrix4x4.from_quaternion_position(params.particle_rotation_offset or Quaternion.identity(), params.particle_offset or Vector3.zero()))
			effect_id = World.create_particles(world, particle_name, Matrix4x4.translation(pose), Matrix4x4.rotation(pose))
		else
			effect_id = World.create_particles(world, particle_name, params.particle_offset or Vector3.zero(), params.particle_rotation_offset or Quaternion.identity())
		end
	end

	flow_return_table.effect_id = effect_id
	flow_return_table.playing_id = wwise_playing_id

	return flow_return_table
end

FlowCallbacks.minion_material_fx = function (params)
	if DEDICATED_SERVER then
		flow_return_table.effect_id = nil
		flow_return_table.playing_id = nil

		return flow_return_table
	end

	local name = params.name
	local unit = params.unit
	local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()
	local sounds = breed.sounds
	local use_proximity_culling = sounds.use_proximity_culling
	local sound_uses_proximity_culling = use_proximity_culling[name]
	local legacy_v2_proximity_extension = ScriptUnit.extension(unit, "legacy_v2_proximity_system")
	local is_proximity_fx_enabled = legacy_v2_proximity_extension.is_proximity_fx_enabled

	if sound_uses_proximity_culling and not is_proximity_fx_enabled then
		flow_return_table.effect_id = nil
		flow_return_table.playing_id = nil

		return flow_return_table
	end

	local query_position_object = Unit.node(unit, params.query_position_object)
	local query_from = Unit.world_position(unit, query_position_object)
	local unit_rotation = Unit.world_rotation(unit, 1)

	if params.query_clamp_to_ground then
		query_from.z = POSITION_LOOKUP[unit].z
	end

	local query_offset = params.query_offset

	if query_offset then
		query_from = query_from + Quaternion.rotate(unit_rotation, query_offset)
	end

	local query_vector = params.query_vector
	local query_to = query_from + Quaternion.rotate(unit_rotation, query_vector)
	local world_manager = Managers.world
	local world = world_manager:world("level_world")
	local wwise_events = sounds.events
	local wwise_event = wwise_events[name]
	local vfx_table = breed.vfx.material_vfx[name]
	local hit, material, impact_position, normal = nil

	if wwise_event or vfx_table then
		hit, material, impact_position, normal = MaterialQuery.query_material(World.get_data(world, "physics_world"), query_from, query_to, name)

		if hit then
			Unit.set_data(unit, "cache_material", material)
		end
	end

	local wwise_playing_id = nil

	if wwise_event then
		local wwise_world = World.get_data(world, "wwise_world")
		local source_id = params.sound_existing_source_id

		if source_id then
			if not hit then
				local cached_material = Unit.get_data(unit, "cache_material")

				if cached_material then
					WwiseWorld.set_switch(wwise_world, "surface_material", cached_material, source_id)
				end
			elseif material then
				WwiseWorld.set_switch(wwise_world, "surface_material", material, source_id)
			end

			if params.sound_set_speed_parameter then
				_set_minion_foley_speed(unit, wwise_world, source_id)
			end

			wwise_playing_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, source_id)
		else
			source_id = WwiseWorld.make_auto_source(wwise_world, unit, query_position_object)

			if breed.uses_wwise_special_targeting_parameter then
				_minion_update_special_targeting_parameter(unit, wwise_world, source_id)
			else
				_minion_update_targeted_in_melee_parameter(unit, wwise_world, source_id)
			end

			if not hit then
				local cached_material = Unit.get_data(unit, "cache_material")

				if cached_material then
					WwiseWorld.set_switch(wwise_world, "surface_material", cached_material, source_id)
				end
			elseif material then
				WwiseWorld.set_switch(wwise_world, "surface_material", material, source_id)
			end

			if params.sound_set_speed_parameter then
				_set_minion_foley_speed(unit, wwise_world, source_id)
			end

			local param_sound_source_object = params.query_position_object
			local param_sound_position = params.sound_position
			local sound_source_object = 1

			if param_sound_source_object then
				sound_source_object = Unit.node(unit, param_sound_source_object)
			end

			if param_sound_position then
				local world_position = Vector3.add(Unit.world_position(unit, sound_source_object), param_sound_position)
				wwise_playing_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, world_position)
			else
				wwise_playing_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, unit, sound_source_object)
			end
		end
	end

	if not is_proximity_fx_enabled then
		flow_return_table.effect_id = nil
		flow_return_table.playing_id = wwise_playing_id

		return flow_return_table
	end

	local effect_id = nil

	if hit then
		local particle_name = vfx_table[material] or vfx_table.default

		if particle_name then
			if type(particle_name) == "table" then
				particle_name = particle_name[math.random(1, #particle_name)]
			end

			local position_source = params.particle_position_source or "Impact"
			local rotation_source = params.particle_rotation_source or "Normal"
			local particle_rotation_offset = params.particle_rotation_offset
			local particle_offset = params.particle_offset
			local node = params.particle_source_object and Unit.node(unit, params.particle_source_object)

			if params.particle_linked then
				effect_id = World.create_particles(world, particle_name, Vector3.zero(), Quaternion.identity())
				local pose = Matrix4x4.from_quaternion_position(params.particle_rotation_offset or Quaternion.identity(), params.particle_rotation_offset or Vector3.zero())

				World.link_particles(world, effect_id, unit, node, pose, params.particle_orphaned_policy)
			else
				local position = nil

				if position_source == "Impact" then
					position = impact_position
				elseif position_source == "Unit" then
					position = Unit.world_position(unit, 1)
				elseif position_source == "Object" then
					position = Unit.world_position(unit, node)
				else
					position = Vector3.zero()
				end

				local rotation = nil

				if rotation_source == "Normal" then
					local particle_forward = normal
					local right = Quaternion.right(unit_rotation)
					local particle_up = Vector3.cross(particle_forward, right)
					rotation = Quaternion.look(normal, particle_up)
				elseif rotation_source == "Object" then
					rotation = Unit.world_rotation(unit, node)
				elseif rotation_source == "Unit" then
					rotation = Unit.world_rotation(unit, 1)
				else
					rotation = Quaternion.identity()
				end

				if particle_offset then
					position = position + Quaternion.rotate(rotation, particle_offset)
				end

				if particle_rotation_offset then
					rotation = Quaternion.multiply(rotation, params.particle_rotation_offset)
				end

				if params.particle_randomize_roll then
					rotation = Quaternion.multiply(rotation, Quaternion.from_yaw_pitch_roll(0, 0, math.random() * math.pi * 2))
				end

				effect_id = World.create_particles(world, particle_name, position, rotation)
			end
		end
	end

	if material == "water_puddle" or material == "water_deep" then
		material = "water"

		Managers.state.world_interaction:add_world_interaction(material, unit)
	end

	flow_return_table.effect_id = effect_id
	flow_return_table.playing_id = wwise_playing_id

	return flow_return_table
end

local function _set_player_foley_speed(unit, wwise_world, source_id)
	local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")
	local move_speed = locomotion_ext:move_speed()

	WwiseWorld.set_source_parameter(wwise_world, source_id, "foley_speed", move_speed)
end

local function _set_player_first_person_parameter(unit, wwise_world, source_id)
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_mode = first_person_extension:is_in_first_person_mode()
	local parameter_value = first_person_mode and 1 or 0

	WwiseWorld.set_source_parameter(wwise_world, source_id, "first_person_mode", parameter_value)
end

local function _set_voice_switch(unit, wwise_world, source_id)
	local voice_data = PlayerVoiceGrunts.voice_data(unit)

	PlayerVoiceGrunts.set_voice(wwise_world, source_id, voice_data.switch_group, voice_data.selected_voice, voice_data.selected_voice_fx_preset)
end

local function _should_play_player_fx(play_in, extension_unit)
	local first_person_extension = ScriptUnit.extension(extension_unit, "first_person_system")
	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()
	local should_play_fx = nil

	if play_in == "both" or play_in == nil then
		should_play_fx = true
	elseif play_in == "1p only" then
		should_play_fx = is_in_first_person_mode
	elseif play_in == "3p only" then
		should_play_fx = not is_in_first_person_mode
	end

	return should_play_fx
end

local function _player_fx_source_and_extension_unit(params)
	local first_person_unit = params.first_person_unit
	local source_unit, extension_unit = nil

	if first_person_unit then
		extension_unit = Unit.get_data(first_person_unit, "owner_unit")
		source_unit = first_person_unit
	else
		extension_unit = params.unit
		source_unit = extension_unit
	end

	return source_unit, extension_unit
end

FlowCallbacks.player_voice = function (params)
	if DEDICATED_SERVER then
		return
	end

	local _, extension_unit = _player_fx_source_and_extension_unit(params)
	local play_in = params.play_in
	local should_play_fx = _should_play_player_fx(play_in, extension_unit)
	local wwise_playing_id = nil

	if should_play_fx then
		local vce_alias = params.vce_alias

		if vce_alias and vce_alias ~= "" then
			local visual_loadout_extension = ScriptUnit.extension(extension_unit, "visual_loadout_system")
			local fx_extension = ScriptUnit.extension(extension_unit, "fx_system")
			local suppress_vo = params.suppress_vo or false
			wwise_playing_id = PlayerVoiceGrunts.trigger_voice_non_synced(vce_alias, visual_loadout_extension, fx_extension, suppress_vo)
		end
	end

	flow_return_table.playing_id = wwise_playing_id

	return flow_return_table
end

FlowCallbacks.player_fx = function (params)
	local source_unit, extension_unit = _player_fx_source_and_extension_unit(params)
	local play_in = params.play_in
	local should_play_fx = _should_play_player_fx(play_in, extension_unit)
	local wwise_playing_id, particle_id = nil

	if should_play_fx then
		local world_manager = Managers.world
		local world = world_manager:world("level_world")
		local sound_alias = params.sound_gear_alias
		local particle_alias = params.particle_gear_alias

		if sound_alias and sound_alias ~= "" then
			local wwise_world = world_manager:wwise_world(world)
			local source_id = params.sound_existing_source_id

			if not source_id then
				local node_index = 1

				if params.source_object then
					node_index = Unit.node(source_unit, params.source_object)
				end

				source_id = WwiseWorld.make_auto_source(wwise_world, source_unit, node_index)
			end

			if params.sound_set_speed_parameter then
				_set_player_foley_speed(extension_unit, wwise_world, source_id)
			end

			if params.sound_set_first_person_parameter then
				_set_player_first_person_parameter(extension_unit, wwise_world, source_id)
			end

			if params.sound_set_voice_switch then
				_set_voice_switch(extension_unit, wwise_world, source_id)
			end

			local fx_extension = ScriptUnit.extension(extension_unit, "fx_system")
			local external_properties = nil
			wwise_playing_id = fx_extension:trigger_gear_wwise_event(sound_alias, external_properties, source_id)
		end

		if particle_alias and particle_alias ~= "" then
			local visual_loadout_extension = ScriptUnit.extension(extension_unit, "visual_loadout_system")
			local resolved, particle_name = visual_loadout_extension:resolve_gear_particle(particle_alias)

			if resolved then
				local link = not not params.particle_linked
				local orphaned_policy = params.particle_orphaned_policy
				local translation_offset = params.particle_offset or Vector3.zero()
				local rotation_offset = params.particle_rotation_offset or Quaternion.identity()
				local source_object = params.source_object
				local node_index = 1

				if source_object then
					node_index = Unit.node(source_unit, source_object)
				end

				if link then
					particle_id = World.create_particles(world, particle_name, Vector3.zero(), Quaternion.identity())
					local pose = Matrix4x4.from_quaternion_position(rotation_offset, translation_offset)

					World.link_particles(world, particle_id, source_unit, node_index, pose, orphaned_policy)
				else
					local node_pose = Unit.world_pose(source_unit, node_index)
					local offset_pose = Matrix4x4.multiply(node_pose, Matrix4x4.from_quaternion_position(rotation_offset, translation_offset))
					local translation = Matrix4x4.translation(offset_pose)
					local rotation = Matrix4x4.rotation(offset_pose)
					particle_id = World.create_particles(world, particle_name, translation, rotation)
				end
			end
		end
	end

	flow_return_table.playing_id = wwise_playing_id
	flow_return_table.particle_id = particle_id

	return flow_return_table
end

FlowCallbacks.player_material_fx = function (params)
	local source_id = params.sound_existing_source_id
	local unit = params.unit
	local play_in = params.play_in
	local should_play_fx = _should_play_player_fx(play_in, unit)
	local wwise_playing_id = nil

	if should_play_fx then
		local query_position_object = Unit.node(unit, params.query_position_object)
		local sound_alias = params.sound_gear_alias
		local world = Managers.world:world("level_world")
		local wwise_world = World.get_data(world, "wwise_world")
		local physics_world = World.get_data(world, "physics_world")
		local query_from = POSITION_LOOKUP[unit] + Vector3(0, 0, 0.5)
		local query_to = query_from + Vector3(0, 0, -1)
		wwise_playing_id = Footstep.trigger_material_footstep(sound_alias, wwise_world, physics_world, source_id, unit, query_position_object, query_from, query_to, params.sound_set_speed_parameter, params.sound_set_first_person_parameter)
	end

	flow_return_table.playing_id = wwise_playing_id

	return flow_return_table
end

local external_properties = {}

FlowCallbacks.player_inventory_fx = function (params)
	local source_alias = params.fx_source_name
	local sound_alias = params.sound_alias
	local effect_alias = params.effect_alias
	local first_person_unit = params.first_person_unit
	local extension_unit = nil

	if first_person_unit then
		extension_unit = Unit.get_data(first_person_unit, "owner_unit")
	else
		extension_unit = params.unit
	end

	local fx_extension = ScriptUnit.extension(extension_unit, "fx_system")
	local visual_loadout_extension = ScriptUnit.extension(extension_unit, "visual_loadout_system")
	local unit_data_extension = ScriptUnit.extension(extension_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local critical_strike_component = unit_data_extension:read_component("critical_strike")
	local wielded_slot = inventory_component.wielded_slot
	local play_in = params.play_in
	local should_play_fx = _should_play_player_fx(play_in, extension_unit)
	local wwise_playing_id = nil

	if should_play_fx and wielded_slot and wielded_slot ~= "none" then
		local fx_sources = visual_loadout_extension:source_fx_for_slot(wielded_slot)
		local source_name = fx_sources and fx_sources[source_alias]
		local slot_config = slot_configuration[wielded_slot]
		local slot_type = slot_config.slot_type
		external_properties.is_critical_strike = tostring(critical_strike_component.is_active)

		if slot_type == "weapon" then
			local inventory_slot_component = unit_data_extension:read_component(wielded_slot)
			external_properties.special_active = tostring(inventory_slot_component.special_active)
		end

		if source_name then
			if sound_alias and sound_alias ~= "" then
				local sync_to_clients = true
				wwise_playing_id = fx_extension:trigger_gear_wwise_event_with_source(sound_alias, external_properties, source_name, sync_to_clients)
			end

			if effect_alias and effect_alias ~= "" then
				local link = true
				local orphaned_policy = "stop"

				fx_extension:spawn_gear_particle_effect_with_source(effect_alias, external_properties, source_name, link, orphaned_policy)
			end
		end
	end

	flow_return_table.playing_id = wwise_playing_id

	return flow_return_table
end

FlowCallbacks.player_inventory_event = function (params)
	local first_person_unit = params.first_person_unit
	local event_name = params.event_name
	local extension_unit = nil

	if first_person_unit then
		extension_unit = Unit.get_data(first_person_unit, "owner_unit")
	else
		extension_unit = params.unit
	end

	local visual_loadout_extension = ScriptUnit.extension(extension_unit, "visual_loadout_system")
	local unit_data_extension = ScriptUnit.extension(extension_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot ~= "none" then
		local unit_1p, unit_3p, attachments_1p, attachments_3p = visual_loadout_extension:unit_and_attachments_from_slot(wielded_slot)

		if unit_1p then
			unit_flow_event(unit_1p, event_name)
		end

		if attachments_1p then
			for i = 1, #attachments_1p do
				local attachment_unit = attachments_1p[i]

				unit_flow_event(attachment_unit, event_name)
			end
		end
	end
end

FlowCallbacks.disable_lights_event = function (params)
	local unit = params.unit
	local num_lights = Unit.num_lights(unit)

	for i = 1, num_lights do
		local light = Unit.light(unit, i)

		Light.set_enabled(light, false)
	end

	if params.disable_emissive then
		Unit.set_vector4_for_materials(unit, "emissive_color_intensity", Color(0, 0, 0, 0), true)
	end
end

FlowCallbacks.blood_ball_collision = function (params)
	if not Managers.state.blood then
		return
	end

	local actor = params.colliding_actor
	local unit = Actor.unit(actor)
	local position = params.collision_position
	local normal = params.collision_normal
	local velocity = Actor.velocity(actor)
	local blood_type = params.blood_type or "default"
	local remove_blood_ball = params.remove_blood_ball

	Managers.state.blood:blood_ball_collision(unit, position, normal, velocity, blood_type, remove_blood_ball)
end

FlowCallbacks.remove_blood_ball = function (params)
	if Managers.state.blood ~= nil then
		Managers.state.blood:remove_blood_ball(params.unit)
	end
end

FlowCallbacks.create_networked_flow_state = function (params)
	local created, out_value = Managers.state.networked_flow_state:flow_cb_create_state(params.unit, params.state_name, params.in_value, params.client_state_changed_event, params.client_hot_join_event, params.is_game_object)

	if created then
		flow_return_table.created = created
		flow_return_table.out_value = out_value

		return flow_return_table
	end
end

FlowCallbacks.change_networked_flow_state = function (params)
	local changed, out_value = Managers.state.networked_flow_state:flow_cb_change_state(params.unit, params.state_name, params.in_value)

	if changed then
		flow_return_table.changed = changed
		flow_return_table.out_value = out_value

		return flow_return_table
	end
end

FlowCallbacks.get_networked_flow_state = function (params)
	local out_value = Managers.state.networked_flow_state:flow_cb_get_state(params.unit, params.state_name)
	flow_return_table.out_value = out_value

	return flow_return_table
end

FlowCallbacks.client_networked_flow_state_changed = function (params)
	local out_value = Managers.state.networked_flow_state:flow_cb_get_state(params.unit, params.state_name)
	flow_return_table.changed = true
	flow_return_table.out_value = out_value

	return flow_return_table
end

FlowCallbacks.client_networked_flow_state_set = function (params)
	local out_value = Managers.state.networked_flow_state:flow_cb_get_state(params.unit, params.state_name)
	flow_return_table.set = true
	flow_return_table.out_value = out_value

	return flow_return_table
end

FlowCallbacks.new_onboarding_cinematic = function (params)
	local chapter = Managers.narrative:current_chapter(Managers.narrative.STORIES.onboarding)

	if chapter then
		flow_return_table.template_name = chapter.name
	end

	return flow_return_table
end

FlowCallbacks.new_onboarding_cinematic_viewed = function (params)
	Managers.narrative:complete_current_chapter(Managers.narrative.STORIES.onboarding)
end

FlowCallbacks.trigger_cinematic_video = function (params)
	local template_name = params.template_name

	if template_name and template_name ~= "" then
		Managers.ui:open_view("video_view", nil, true, true, nil, {
			template = template_name
		})

		flow_return_table.triggered = true
	else
		flow_return_table.not_triggered = true
	end

	return flow_return_table
end

FlowCallbacks.register_cinematic_story = function (params)
	params.flow_level = Application.flow_callback_context_level()

	return Managers.state.cinematic:register_story(params)
end

FlowCallbacks.trigger_cinematic_story = function (params)
	Log.warning("FlowCallbacks", "'trigger_cinematic_story' is deprecated. Use CinematicScene Unit 'content/gizmos/cinematic_scene/cinematic_scene' instead.")

	return flow_return_table
end

FlowCallbacks.queue_cinematic_story = function (params)
	Log.warning("FlowCallbacks", "'queue_cinematic_story' is deprecated. Use CinematicScene Unit 'content/gizmos/cinematic_scene/cinematic_scene' instead.")

	return flow_return_table
end

FlowCallbacks.sub_levels_spawned = function (params)
	local world = Application.flow_callback_context_world()
	local level = Application.flow_callback_context_level()
	local cb = callback("Level", "trigger_script_node_event", level, params.node_id, "out", true)

	ScriptWorld.register_sub_levels_spawned_callback(world, level, cb)
end

FlowCallbacks.show_players = function (params)
	PlayerVisibility.show_players()
end

FlowCallbacks.hide_players = function (params)
	PlayerVisibility.hide_players()
end

FlowCallbacks.set_host_gameplay_timescale = function (params)
	if GameParameters.disable_flow_timescale then
		return
	end

	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		Log.warning("FlowCallbacks", "set_host_gameplay_timescale() is called on a client")

		return
	end

	local time_manager = Managers.time

	time_manager:set_local_scale("gameplay", tonumber(params.scale))
end

FlowCallbacks.set_cinematic_playback_speed = function (params)
	Managers.world:set_world_update_time_scale(tonumber(params.scale))
end

FlowCallbacks.set_host_unkillable = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		Log.warning("FlowCallbacks", "set_host_unkillable() is called on a client")

		return
	end

	local local_player = Managers.player:local_player(1)
	local players = Managers.player:players_at_peer(local_player:peer_id())

	for _, player in pairs(players) do
		if player:unit_is_alive() then
			local player_unit = player.player_unit
			local health_extension = ScriptUnit.extension(player_unit, "health_system")

			health_extension:set_unkillable(params.enabled)
		end
	end
end

FlowCallbacks.cutscene_fade_in = function (params)
	local duration = params.duration
	local easing_function = params.easing_function and math[params.easing_function]
	local local_player = Managers.player:local_player(1)

	Managers.event:trigger("event_cutscene_fade_in", local_player, duration, easing_function)
end

FlowCallbacks.cutscene_fade_out = function (params)
	local duration = params.duration
	local easing_function = params.easing_function and math[params.easing_function]
	local local_player = Managers.player:local_player(1)

	Managers.event:trigger("event_cutscene_fade_out", local_player, duration, easing_function)
end

FlowCallbacks.tutorial_display_popup_message = function (params)
	local is_server = Managers.state.game_session:is_server()
	local local_player = Managers.player:local_player(1)

	if not is_server or not local_player then
		return
	end

	local info_data = {
		description = params.description,
		title = params.title,
		close_action = params.close_action,
		use_ingame_input = true
	}

	Managers.event:trigger("event_player_display_prologue_tutorial_info_box", local_player, info_data)
end

FlowCallbacks.tutorial_hide_popup_message = function (params)
	local is_server = Managers.state.game_session:is_server()
	local local_player = Managers.player:local_player(1)

	if not is_server or not local_player then
		return
	end

	Managers.event:trigger("event_player_hide_prologue_tutorial_info_box", local_player)
end

FlowCallbacks.clear_hostiles = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local minion_spawn_manager = Managers.state.minion_spawn

	minion_spawn_manager:despawn_all_minions()
end

FlowCallbacks.add_bot = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		Log.warning("FlowCallbacks.add_bot", "Only server can spawn bots!")

		return
	end

	local profile_name = params.profile_identifier
	flow_return_table.local_player_id = BotSpawning.spawn_bot_character(profile_name)

	return flow_return_table
end

FlowCallbacks.remove_bot_safe = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		Log.warning("FlowCallbacks.remove_bot", "Only server can remove bots!")

		return
	end

	local local_player_id = params.local_player_id

	BotSpawning.despawn_bot_character(local_player_id, true)
end

FlowCallbacks.bot_unit_by_profile_id = function (params)
	local profile_id = params.profile_id
	local bot_players = Managers.player:bot_players()

	for _, bot_player in pairs(bot_players) do
		local profile = bot_player:profile()

		if profile.character_id == profile_id then
			local bot_unit = bot_player.player_unit

			if bot_unit then
				flow_return_table.bot_unit = bot_unit
				flow_return_table.unit_found = true
				flow_return_table.unit_not_found = false

				return flow_return_table
			else
				break
			end
		end
	end

	flow_return_table.bot_unit = nil
	flow_return_table.unit_found = false
	flow_return_table.unit_not_found = true

	return flow_return_table
end

local HOLD_POSITION_NAV_ABOVE = 0.5
local HOLD_POSITION_NAV_BELOW = 2

FlowCallbacks.bot_hold_position = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local player_unit = params.player_unit
	local behavior_extension = ScriptUnit.extension(player_unit, "behavior_system")
	local should_hold_position = params.should_hold_position

	if should_hold_position then
		local navigation_extension = ScriptUnit.extension(player_unit, "navigation_system")
		local nav_world = navigation_extension:nav_world()
		local traverse_logic = navigation_extension:traverse_logic()
		local hold_position = params.position or POSITION_LOOKUP[player_unit]
		local hold_position_on_nav_mesh = NavQueries.position_on_mesh(nav_world, hold_position, HOLD_POSITION_NAV_ABOVE, HOLD_POSITION_NAV_BELOW, traverse_logic)

		if hold_position_on_nav_mesh then
			local max_distance = params.max_allowed_distance_from_position or 0

			behavior_extension:set_hold_position(hold_position_on_nav_mesh, max_distance)
		else
			Log.warning("FlowCallbacks", "%s could not hold position %s since it is not near nav mesh!", player_unit, tostring(hold_position))
		end
	else
		behavior_extension:set_hold_position(nil)
	end
end

FlowCallbacks.local_player_archetype_name = function (params)
	local is_server = Managers.state.game_session:is_server()
	local local_player = Managers.player:local_player(1)

	if not is_server or not local_player then
		return
	end

	local profile = local_player:profile()
	flow_return_table.archetype_name = profile.archetype.name

	return flow_return_table
end

FlowCallbacks.prologue_local_player_equip_slot = function (params)
	local slot_name = params.slot_name
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player.player_unit
	local profile = local_player:profile()
	local visual_loadout = profile.visual_loadout
	local item = visual_loadout[slot_name]
	local fixed_t = FixedFrame.get_latest_fixed_time()

	PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, item, slot_name, nil, fixed_t)
	PlayerUnitVisualLoadout.wield_slot(slot_name, player_unit, fixed_t)
end

FlowCallbacks.prologue_local_player_wield_slot = function (params)
	local slot_name = params.slot_name
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player.player_unit
	local fixed_t = FixedFrame.get_latest_fixed_time()

	PlayerUnitVisualLoadout.wield_slot(slot_name, player_unit, fixed_t)
end

FlowCallbacks.get_peer_id_from_unit = function (params)
	local player_unit_manager = Managers.state.player_unit_spawn
	local player = player_unit_manager:owner(params.player_unit)

	if player then
		flow_return_table.peer_id = player:peer_id()
	end

	return flow_return_table
end

FlowCallbacks.create_networked_story = function (params)
	return Managers.state.networked_flow_state:flow_cb_create_story(params.node_id)
end

FlowCallbacks.has_stopped_networked_story = function (params)
	return Managers.state.networked_flow_state:flow_cb_has_stopped_networked_story(params.node_id)
end

FlowCallbacks.has_played_networked_story = function (params)
	return Managers.state.networked_flow_state:flow_cb_has_played_networked_story(params.node_id, params.story_id)
end

FlowCallbacks.play_networked_story = function (params)
	return Managers.state.networked_flow_state:flow_cb_play_networked_story(params.client_call_event_name, params.start_time, params.start_from_stop_time, params.node_id)
end

FlowCallbacks.stop_networked_story = function (params)
	return Managers.state.networked_flow_state:flow_cb_stop_networked_story(params.node_id)
end

FlowCallbacks.complete_game_mode = function (params)
	local triggered_from_flow = true

	Managers.state.game_mode:complete_game_mode(triggered_from_flow)
end

FlowCallbacks.fail_game_mode = function (params)
	Managers.state.game_mode:fail_game_mode()
end

FlowCallbacks.set_difficulty = function (params)
	if params.challenge then
		Managers.state.difficulty:set_challenge(params.challenge)
	end

	if params.resistance then
		Managers.state.difficulty:set_resistance(params.resistance)
	end
end

FlowCallbacks.open_view = function (params)
	local view_name = params.view_name
	local transition_time = params.transition_time
	local close_previous = params.close_previous
	local close_all = params.close_all
	local ui_manager = Managers.ui

	if ui_manager then
		ui_manager:open_view(view_name, transition_time, close_previous, close_all)
	end
end

FlowCallbacks.trigger_lua_unit_event = function (params)
	local event = params.event
	local unit = params.unit
	local event_manager = Managers.event

	if event_manager then
		event_manager:trigger(event, unit)
	end
end

FlowCallbacks.trigger_lua_string_event = function (params)
	local event = params.event
	local string = params.string
	local event_manager = Managers.event

	if event_manager then
		event_manager:trigger(event, string)
	end
end

FlowCallbacks.trigger_lua_integer_event = function (params)
	local event = params.event
	local integer = params.integer
	local event_manager = Managers.event

	if event_manager then
		event_manager:trigger(event, integer)
	end
end

FlowCallbacks.load_mission = function (params)
	local new_mission_name = params.mission_name
	local mechanism_context = {
		mission_name = new_mission_name
	}
	local Missions = require("scripts/settings/mission/mission_templates")
	local mission_settings = Missions[new_mission_name]
	local mechanism_name = mission_settings.mechanism_name
	local game_mode_name = mission_settings.game_mode_name
	local game_mode_settings = GameModeSettings[game_mode_name]

	if game_mode_settings.host_singleplay then
		Managers.multiplayer_session:reset("Hosting singleplay mission from flow")
		Managers.multiplayer_session:boot_singleplayer_session()
	end

	Managers.mechanism:change_mechanism(mechanism_name, mechanism_context)
	Managers.mechanism:trigger_event("all_players_ready")
end

FlowCallbacks.flow_callback_trigger_dialogue_event = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.source

	if ScriptUnit.has_extension(unit, "dialogue_system") then
		local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
		local event_table = flow_return_table

		if params.argument1_name then
			event_table[params.argument1_name] = tonumber(params.argument1) or params.argument1
		end

		if params.argument2_name then
			event_table[params.argument2_name] = tonumber(params.argument2) or params.argument2
		end

		if params.argument3_name then
			event_table[params.argument3_name] = tonumber(params.argument3) or params.argument3
		end

		dialogue_extension:trigger_dialogue_event(params.concept, event_table, params.identifier)
	end
end

FlowCallbacks.trigger_player_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.source
	local trigger_id = params.trigger_id

	Vo.generic_mission_vo_event(unit, trigger_id)
end

FlowCallbacks.trigger_random_player_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local trigger_id = params.trigger_id
	local random_player_unit = nil
	local side_system = Managers.state.extension:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local players = side:added_player_units()
	local unit_list = {}
	local unit_list_n = 0

	for i = 1, #players do
		local unit = players[i]

		if HEALTH_ALIVE[unit] then
			unit_list_n = unit_list_n + 1
			unit_list[unit_list_n] = unit
		end
	end

	if unit_list_n > 0 then
		random_player_unit = unit_list[math.random(1, unit_list_n)]
	end

	Vo.generic_mission_vo_event(random_player_unit, trigger_id)
end

FlowCallbacks.trigger_mission_giver_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local voice_over_spawn_manager = Managers.state.voice_over_spawn
		local voice_profile = params.voice_profile
		local unit = voice_over_spawn_manager:voice_over_unit(voice_profile)
		local trigger_id = params.concept

		Vo.mission_giver_mission_info(unit, trigger_id)
	end
end

FlowCallbacks.trigger_mission_info_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local voice_over_spawn_manager = Managers.state.voice_over_spawn
		local voice_profile = params.voice_profile
		local unit = voice_over_spawn_manager:voice_over_unit(voice_profile)
		local trigger_id = params.trigger_id

		Vo.mission_giver_mission_info(unit, trigger_id)
	end
end

FlowCallbacks.trigger_mission_giver_mission_info_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local voice_selection = params.voice_selection
		local selected_voice = params.selected_voice
		local trigger_id = params.trigger_id

		Vo.mission_giver_mission_info_vo(voice_selection, selected_voice, trigger_id)
	end
end

FlowCallbacks.trigger_confessional_vo_event = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local unit = params.source
		local category = params.category

		Vo.confessional_vo_event(unit, category)
	end
end

FlowCallbacks.trigger_npc_vo_event = function (params)
	local unit = params.source
	local vo_event = params.vo_event
	local is_interaction_vo = params.is_interaction_vo or false
	local interacting_unit = params.interacting_unit
	local cooldown_time = params.cooldown_time
	local play_in = params.play_in

	if is_interaction_vo then
		Vo.play_npc_interacting_vo_event(unit, interacting_unit, vo_event, cooldown_time, play_in)
	else
		Vo.play_npc_vo_event(unit, vo_event)
	end
end

FlowCallbacks.trigger_mission_giver_conversation_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local voice_over_spawn_manager = Managers.state.voice_over_spawn
		local voice_profile = params.voice_profile
		local unit = voice_over_spawn_manager:voice_over_unit(voice_profile)
		local trigger_id = params.trigger_id

		Vo.mission_giver_conversation_starter(unit, trigger_id)
	end
end

FlowCallbacks.trigger_story_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.source
	local story = params.story

	Vo.environmental_story_vo_event(unit, story)
end

FlowCallbacks.trigger_cutscene_vo = function (params)
	local unit = params.source
	local vo_line_id = params.vo_line_id

	Vo.cutscene_vo_event(unit, vo_line_id)
end

FlowCallbacks.trigger_local_vo_event = function (params)
	local unit = params.source
	local rule_name = params.rule_name
	local wwise_route_key = params.wwise_route_key
	local opinion_vo = params.opinion_vo

	Vo.play_local_vo_event(unit, rule_name, wwise_route_key, nil, opinion_vo)
end

FlowCallbacks.trigger_on_demand_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.source
	local trigger_id = params.trigger_id

	Vo.on_demand_vo_event(unit, trigger_id)
end

FlowCallbacks.trigger_start_banter_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.source

	Vo.start_banter_vo_event(unit)
end

FlowCallbacks.trigger_enemy_generic_vo = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local unit = params.source
	local trigger_id = params.trigger_id
	local breed_name = params.breed_name

	Vo.enemy_generic_vo_event(unit, trigger_id, breed_name)
end

FlowCallbacks.set_player_vo_story_stage = function (params)
	local story_stage = params.story_stage

	PlayerVOStoryStage.set_story_stage(story_stage)
end

FlowCallbacks.set_story_ticker = function (params)
	local story_ticker = params.story_ticker

	Vo.set_story_ticker(story_ticker)
end

FlowCallbacks.mission_giver_check = function (params)
	Vo.mission_giver_check_event()
end

FlowCallbacks.stop_unit_vo = function (params)
	local unit = params.source

	Vo.stop_currently_playing_vo(unit)
end

FlowCallbacks.stop_all_vo = function (params)
	Vo.stop_all_currently_playing_vo()
end

FlowCallbacks.is_currently_playing_dialogue = function (params)
	local unit = params.source
	local is_playing = Vo.is_currently_playing_dialogue(unit)

	if is_playing then
		flow_return_table.vo_playing = true
	else
		flow_return_table.vo_not_playing = true
	end

	return flow_return_table
end

FlowCallbacks.start_terror_event = function (params)
	local terror_event_manager = Managers.state.terror_event

	if terror_event_manager then
		local event_name = params.event_name

		terror_event_manager:start_event(event_name)
	end
end

FlowCallbacks.stop_terror_event = function (params)
	local terror_event_manager = Managers.state.terror_event

	if terror_event_manager then
		local event_name = params.event_name

		terror_event_manager:stop_event(event_name)
	end
end

FlowCallbacks.start_random_terror_event = function (params)
	local terror_event_manager = Managers.state.terror_event

	if terror_event_manager then
		local event_chunk_name = params.event_chunk_name

		terror_event_manager:start_random_event(event_chunk_name)
	end
end

FlowCallbacks.change_spawner_groups_terror_event = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local unit = params.unit
		local new_spawner_group_names = params.new_spawner_group_names
		local spawner_group_names = nil

		if new_spawner_group_names then
			spawner_group_names = string.split_and_trim(new_spawner_group_names, ",")
		end

		local minion_spawner_system = Managers.state.extension:system("minion_spawner_system")

		minion_spawner_system:change_spawner_group_names(unit, spawner_group_names)
	end
end

FlowCallbacks.get_crossroad_road_id = function (params)
	local crossroads_id = params.crossroads_id
	local main_path_manager = Managers.state.main_path
	local chosen_road_id = main_path_manager:crossroad_road_id(crossroads_id)
	flow_return_table.road_id = chosen_road_id

	return flow_return_table
end

FlowCallbacks.spawn_network_unit = function (params)
	local unit_name = params.unit_name
	local template_name = params.template_name
	local position = params.position
	local rotation = params.rotation
	local unit_spawner = Managers.state.unit_spawner

	if unit_spawner ~= nil then
		flow_return_table.unit = unit_spawner:spawn_network_unit(unit_name, template_name, position, rotation)
	end

	return flow_return_table
end

FlowCallbacks.register_extensions = function (params)
	local unit = params.unit
	local world = Application.flow_callback_context_world()

	if Managers.state.extension ~= nil then
		Managers.state.extension:register_unit(world, unit, "flow_spawned")
	end
end

FlowCallbacks.delete_extension_registered_unit = function (params)
	local unit = params.unit

	if Managers.state.unit_spawner ~= nil then
		Managers.state.unit_spawner:mark_for_deletion(unit)
	end
end

FlowCallbacks.debug_print_world_text = function (params)
	local text = params.text_id or "no text id"
	local size = params.text_size
	local tc = params.text_color
	local color = tc and Color(tc.x, tc.y, tc.z)
	local time = params.time
	local res_x, res_y = Application.back_buffer_size()
	local text_position = Vector3(res_x / 2, res_y / 2, 1)
	local background = params.background
	local options = {
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		text_size = size,
		text_color = color,
		time = time,
		position = text_position,
		background = background
	}
end

FlowCallbacks.switchcase = function (params)
	local ret = {}
	local outStr = "out"

	if params.case ~= "" then
		for k, v in pairs(params) do
			if k ~= "case" and params.case == v then
				ret[outStr .. string.sub(k, -1)] = true
			end
		end
	end

	return ret
end

FlowCallbacks.camera_shake = function (params)
	CameraShake.camera_shake_by_distance(params.shake_name, params.shake_unit, params.near_distance, params.far_distance, params.near_shake_scale, params.far_shake_scale)
end

FlowCallbacks.script_data_set_unit = function (params)
	local my_unit = params.my_unit
	local script_data_unit = params.script_data_unit
	local script_data_name = params.script_data_name

	if not unit_alive(script_data_unit) then
		return
	end

	local i = 1

	while Unit.has_data(my_unit, script_data_name, i) do
		i = i + 1
	end

	Unit.set_data(my_unit, script_data_name, i, script_data_unit)
end

FlowCallbacks.register_objective_unit = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_register_objective_unit(params.objective_name, params.objective_unit)
	end
end

FlowCallbacks.start_mission_objective = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_start_mission_objective(params.objective_name)
	end
end

FlowCallbacks.update_mission_objective = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_update_mission_objective(params.objective_name)
	end
end

FlowCallbacks.end_mission_objective = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_end_mission_objective(params.objective_name)
	end
end

FlowCallbacks.start_side_mission_objective = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local side_mission = Managers.state.mission:side_mission()

		if side_mission then
			local objective_name = side_mission.name
			local mission_objective_system = Managers.state.extension:system("mission_objective_system")

			mission_objective_system:flow_callback_start_mission_objective(objective_name)
		else
			Log.warning("FlowCallbacks", "side_mission(%s) not defined.", tostring(Managers.state.mission:side_mission_name()))
		end
	end
end

FlowCallbacks.mission_objective_override_ui_string = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local objective_name = params.mission_objective_name
		local new_ui_header = params.new_ui_header
		local new_ui_description = params.new_ui_description
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_override_ui_string(objective_name, new_ui_header, new_ui_description)
	end
end

FlowCallbacks.mission_objective_reset_override_ui_string = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local objective_name = params.mission_objective_name
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_override_ui_string(objective_name, "empty_objective_string", "empty_objective_string")
	end
end

FlowCallbacks.mission_objective_show_ui = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local objective_name = params.mission_objective_name
		local show = params.show
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_set_objective_show_ui(objective_name, show)
	end
end

FlowCallbacks.mission_objective_show_counter = function (params)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local objective_name = params.mission_objective_name
		local show = params.show_counter
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:flow_callback_set_objective_show_counter(objective_name, show)
	end
end

FlowCallbacks.teleport_team_to_locations = function (params)
	if not Managers.state.game_session:is_server() then
		return
	end

	local destination_units = {}

	for par, val in pairs(params) do
		if string.find(par, "destination_unit") then
			destination_units[#destination_units + 1] = val
		end
	end

	local num_destinations = #destination_units
	local player_manager = Managers.player
	local players = player_manager:players()
	local index = 0

	for unique_id, player in pairs(players) do
		if player and player.player_unit then
			index = index % num_destinations + 1
			local unit = destination_units[index]
			local position = Unit.world_position(unit, 1)
			local rotation = Unit.world_rotation(unit, 1)

			PlayerMovement.teleport(player, position, rotation)
		end
	end
end

FlowCallbacks.teleport_player_by_local_id = function (params)
	if not Managers.state.game_session:is_server() then
		return
	end

	local destination_units = {}

	for par, val in pairs(params) do
		if string.find(par, "player_id") then
			local destination_par = "destination_unit" .. string.sub(par, string.find(par, "id") + 2, #par)
			destination_units[val] = params[destination_par]
		end
	end

	local player_manager = Managers.player
	local players = player_manager:players()

	for unique_id, player in pairs(players) do
		local id = tostring(player:local_player_id())
		local unit = destination_units[id]

		if unit and player and player.player_unit then
			local position = Unit.world_position(unit, 1)
			local rotation = Unit.world_rotation(unit, 1)

			PlayerMovement.teleport(player, position, rotation)
		end
	end
end

local function _distance(start_unit, end_unit)
	local start_position = Unit.world_position(start_unit, 1)
	local end_position = Unit.world_position(end_unit, 1)

	return Vector3.distance(start_position, end_position)
end

FlowCallbacks.closest_alive_player = function (params)
	local player_manager = Managers.player
	local players = player_manager:players()
	local tracked_units = {}

	for unique_id, player in pairs(players) do
		if player:unit_is_alive() then
			tracked_units[#tracked_units + 1] = player.player_unit
		end
	end

	local lowest_distance = math.huge

	for i = 1, #tracked_units do
		local distance = _distance(tracked_units[i], params.location_unit)

		if distance < lowest_distance then
			lowest_distance = distance
			flow_return_table.player_unit = tracked_units[i]
		end
	end

	return flow_return_table
end

FlowCallbacks.is_player_near = function (params)
	local player_manager = Managers.player
	local players = player_manager:players()
	local location_unit = params.location_unit
	local distance = params.distance
	flow_return_table.is_player_near = false

	for unique_id, player in pairs(players) do
		if player:unit_is_alive() and _distance(player.player_unit, location_unit) <= distance then
			flow_return_table.is_player_near = true

			return flow_return_table
		end
	end

	return flow_return_table
end

FlowCallbacks.random_player_alive = function (params)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local side_name = params.side_name
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name(side_name)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = table.shallow_copy(player_unit_spawn_manager:alive_players())

	for i = #alive_players, 1, -1 do
		local player = alive_players[i]

		if not side.units_lookup[player.player_unit] then
			table.remove(alive_players, i)
		end
	end

	flow_return_table.player_unit = nil
	local num_alive_players = table.size(alive_players)

	if num_alive_players > 0 then
		local random_index = math.random(1, num_alive_players)
		local random_player = alive_players[random_index]
		flow_return_table.player_unit = random_player.player_unit
	end

	return flow_return_table
end

FlowCallbacks.camera_set_far_range = function (params)
	local camera_manager = Managers.state.camera
	local local_player = Managers.player:local_player(1)
	local viewport_name = local_player.viewport_name
	local camera = camera_manager:camera(viewport_name)
	local far_range = params.far_range

	Camera.set_data(camera, "far_range", far_range)
end

FlowCallbacks.get_unit_from_item_slot = function (params)
	local unit = params.unit
	local slot_name = params.slot
	local slot_unit = nil
	local component_system = Managers.state.extension:system("component_system")
	local player_customization_components = component_system:get_components(unit, "PlayerCustomization")

	if table.size(player_customization_components) == 1 then
		slot_unit = player_customization_components[1]:unit_in_slot(slot_name)
	end

	if not Unit.alive(slot_unit) then
		local cutscene_character_extension = ScriptUnit.fetch_component_extension(unit, "cutscene_character_system")

		if cutscene_character_extension then
			slot_unit = cutscene_character_extension:unit_3p_from_slot(slot_name)
		end
	end

	if Unit.alive(slot_unit) then
		flow_return_table.slot_unit = slot_unit
	else
		Log.error("FlowCallbacks", "[get_unit_from_item_slot] missing 'slot_unit' for (unit: %s, slot_name: %s). Returning the owner unit.", unit, slot_name)
	end

	return flow_return_table
end

FlowCallbacks.minion_check_velocity_threshold = function (params)
	local unit = params.unit
	local threshold = params.threshold
	local locomotion_extension = ScriptUnit.has_extension(unit, "locomotion_system")

	if not locomotion_extension then
		return
	end

	local current_velocity = locomotion_extension:current_velocity()
	local move_speed = Vector3.length(current_velocity)
	flow_return_table.is_at_or_above = threshold <= move_speed

	return flow_return_table
end

FlowCallbacks.render_static_shadows = function (params)
	local world_name = "level_world"

	if Managers.world:has_world(world_name) then
		local world = Managers.world:world(world_name)

		World.set_data(world, "shadow_baked", false)
	end
end

FlowCallbacks.light_controller_set_light_flicker_config = function (params)
	local unit = params.unit
	local flicker_configuration = params.flicker_configuration
	local extension = ScriptUnit.extension(unit, "light_controller_system")
	local flicker_enabled = extension:is_flicker_enabled()

	extension:set_flicker_state(flicker_enabled, flicker_configuration, false)
end

FlowCallbacks.get_render_config = function (params)
	local type = params.type
	local variable = params.variable
	flow_return_table.enabled = Application.render_config(type, variable, false)

	return flow_return_table
end

FlowCallbacks.make_respawn_point_priority = function (params)
	local respawn_beacon_system = Managers.state.extension:system("respawn_beacon_system")
	local respawn_beacon = params.respawn_beacon

	respawn_beacon_system:make_respawn_beacon_priority(respawn_beacon)
end

FlowCallbacks.remove_respawn_point_priority = function (params)
	local respawn_beacon_system = Managers.state.extension:system("respawn_beacon_system")

	respawn_beacon_system:remove_respawn_beacon_priority()
end

FlowCallbacks.spawn_unit = function (self, unit)
	return
end

FlowCallbacks.unspawn_unit = function (self, unit)
	local extension_manager = Managers.state.extension
	local registered_units = extension_manager and extension_manager:units()
end

FlowCallbacks.empty = function (params)
	return
end

FlowCallbacks.start_scripted_scenario = function (params)
	local scenario_alias = params.scenario_alias
	local scenario_name = params.scenario_name
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")

	if not scenario_system then
		Log.error("FlowCallbacks", "ScriptedScenarioSystem is not initiated.")

		return
	end

	local t = Managers.time:time("gameplay")

	scenario_system:start_scenario(scenario_alias, scenario_name, t)
end

FlowCallbacks.start_parallel_scripted_scenario = function (params)
	local scenario_alias = params.scenario_alias
	local scenario_name = params.scenario_name
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")

	if not scenario_system then
		Log.error("FlowCallbacks", "ScriptedScenarioSystem is not initiated.")

		return
	end

	local t = Managers.time:time("gameplay")

	scenario_system:start_parallel_scenario(scenario_alias, scenario_name, t)
end

FlowCallbacks.spawn_scripted_scenario_group = function (params)
	local spawn_group_name = params.spawn_group_name
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")

	scenario_system:spawn_attached_units_in_spawn_group(spawn_group_name)
end

FlowCallbacks.despawn_scripted_scenario_group = function (params)
	local spawn_group_name = params.spawn_group_name
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")

	scenario_system:unspawn_attached_units_in_spawn_group(spawn_group_name)
end

FlowCallbacks.training_grounds_servitor_interact = function ()
	Managers.event:trigger("tg_servitor_interact")
end

local SPEED_EPSILON = 0.001

FlowCallbacks.projectile_locomotion_engine_collision = function (params)
	local impulse_force = params.impulse_force
	local actor = params.actor
	local mass = Actor.mass(actor)
	local delta_velocity = impulse_force / mass
	local post_collision_velocity = Actor.velocity(actor)
	local pre_collision_velocity = post_collision_velocity - delta_velocity
	local speed = Vector3.length(pre_collision_velocity)

	if SPEED_EPSILON < speed then
		local unit = params.unit
		local collision_direction = Vector3.normalize(pre_collision_velocity)
		local collision_position = params.collision_position
		local collision_actor = params.collision_actor
		local collision_normal = params.collision_normal
		local collision_unit = Actor.unit(collision_actor)
		local projectile_damage_extension = ScriptUnit.has_extension(unit, "projectile_damage_system")

		if projectile_damage_extension then
			projectile_damage_extension:on_impact(collision_position, collision_unit, collision_actor, collision_direction, collision_normal, speed)
		end

		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if fx_extension then
			fx_extension:on_impact(collision_position, collision_unit, collision_direction, collision_normal, speed)
		end
	end
end

FlowCallbacks.get_current_mission = function (params)
	local mission_name = Managers.state.mission:mission_name()
	flow_return_table.mission_name = mission_name
	flow_return_table.out = true
	flow_return_table[mission_name] = true

	return flow_return_table
end

FlowCallbacks.is_dedicated_server = function (params)
	flow_return_table.is_dedicated_server = DEDICATED_SERVER

	return flow_return_table
end

FlowCallbacks.local_player_level = function (params)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)
	local profile = local_player:profile()
	local level = profile.current_level
	flow_return_table.level = level

	return flow_return_table
end

FlowCallbacks.local_player_level_larger_than = function (params)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)
	local profile = local_player:profile()
	local level = profile.current_level
	local target_level = params.target_level
	flow_return_table.level_larger_than = target_level <= level

	return flow_return_table
end

FlowCallbacks.new_path_of_trust = function (params)
	local event_name = "none"
	local chapter = Managers.narrative:current_chapter(Managers.narrative.STORIES.path_of_trust)

	if chapter then
		event_name = chapter.name
	end

	flow_return_table[event_name] = true

	return flow_return_table
end

FlowCallbacks.new_path_of_trust_viewed = function (params)
	Managers.narrative:complete_current_chapter(Managers.narrative.STORIES.path_of_trust)
end

FlowCallbacks.unlock_achievement = function (params)
	Managers.achievements:unlock_achievement(params.achievement_id)
end

FlowCallbacks.is_narrative_event_completed = function (params)
	local event_name = params.event_name
	flow_return_table.event_completed = Managers.narrative:is_event_complete(event_name)

	return flow_return_table
end

FlowCallbacks.is_narrative_event_completable = function (params)
	local event_name = params.event_name
	flow_return_table.event_completed = Managers.narrative:can_complete_event(event_name)

	return flow_return_table
end

FlowCallbacks.complete_narrative_event = function (params)
	local event_name = params.event_name

	Managers.narrative:complete_event(event_name)
end

FlowCallbacks.is_narrative_chapter_completed = function (params)
	local story_name = params.story_name
	local chapter_name = params.chapter_name
	flow_return_table.chapter_completed = Managers.narrative:is_chapter_complete(story_name, chapter_name)

	return flow_return_table
end

FlowCallbacks.complete_narrative_chapter = function (params)
	local story_name = params.story_name
	local chapter_name = params.chapter_name
	flow_return_table.success = Managers.narrative:complete_current_chapter(story_name, chapter_name)

	return flow_return_table
end

FlowCallbacks.delete_impact_fx_unit = function (params)
	local unit = params.unit
	local extension_manager = Managers.state and Managers.state.extension
	local fx_system = extension_manager and extension_manager:system("fx_system")

	if fx_system then
		fx_system:delete_impact_fx_unit(unit)
	end
end

FlowCallbacks.leave_shooting_range = function (params)
	Managers.event:trigger("leave_shooting_range")
end

return FlowCallbacks
