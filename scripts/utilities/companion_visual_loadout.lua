-- chunkname: @scripts/utilities/companion_visual_loadout.lua

local CompanionVisualLoadout = {}

CompanionVisualLoadout.assign_fur_material = function (unit, attachment_units_by_unit)
	if not attachment_units_by_unit then
		return
	end

	local attachment_units = attachment_units_by_unit[unit]

	if not attachment_units then
		return
	end

	local num_attachments = #attachment_units

	for ii = 1, num_attachments do
		local attached_unit = attachment_units[ii]

		for jj = 1, 12 do
			Unit.set_material_layer(attached_unit, string.format("fur_%02d", jj), true)
			Unit.set_scalar_for_material(attached_unit, string.format("fur_%02d", jj), "shell_index", jj)
		end
	end
end

local function _wwise_world_and_visual_loadout_extension(unit)
	if not ALIVE[unit] then
		return
	end

	local world = Unit.world(unit)

	if not world then
		return
	end

	local wwise_world = World.get_data(world, "wwise_world")

	if not wwise_world then
		return
	end

	local owner_player = Managers.state.player_unit_spawn:owner(unit)
	local player_unit = owner_player and owner_player.player_unit

	if not player_unit then
		return
	end

	local owner_visual_loadout_extension = ScriptUnit.has_extension(player_unit, "visual_loadout_system")

	if not owner_visual_loadout_extension then
		return
	end

	return wwise_world, owner_visual_loadout_extension, owner_player.remote
end

local function _set_wwise_switch(wwise_world, unit, owner_visual_loadout_extension, profile_properties_wwise_switch, source_id)
	if not profile_properties_wwise_switch then
		return
	end

	local profile_properties = owner_visual_loadout_extension:profile_properties()
	local switch_value = profile_properties and profile_properties[profile_properties_wwise_switch]

	switch_value = switch_value or Unit.has_data(unit, profile_properties_wwise_switch) and Unit.get_data(unit, profile_properties_wwise_switch)

	if switch_value then
		WwiseWorld.set_switch(wwise_world, profile_properties_wwise_switch, switch_value, source_id)
		Unit.set_data(unit, profile_properties_wwise_switch, switch_value)
	end
end

CompanionVisualLoadout.trigger_gear_sound = function (unit, source_id, sound_alias, profile_properties_wwise_switch)
	local wwise_world, owner_visual_loadout_extension, use_husk_events = _wwise_world_and_visual_loadout_extension(unit)

	if not wwise_world or not owner_visual_loadout_extension then
		return
	end

	local resolved, event_name, has_husk_events = owner_visual_loadout_extension:resolve_gear_sound(sound_alias, nil)

	if not resolved then
		return
	end

	if has_husk_events and use_husk_events then
		event_name = event_name .. "_husk"
	end

	_set_wwise_switch(wwise_world, unit, owner_visual_loadout_extension, profile_properties_wwise_switch, source_id)

	local playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)

	return playing_id
end

CompanionVisualLoadout.trigger_looping_gear_sound = function (unit, source_id, sound_alias, profile_properties_wwise_switch)
	local wwise_world, owner_visual_loadout_extension, use_husk_events = _wwise_world_and_visual_loadout_extension(unit)

	if not wwise_world or not owner_visual_loadout_extension then
		return
	end

	local resolved, event_name, resolved_stop_event, stop_event_name = owner_visual_loadout_extension:resolve_looping_gear_sound(sound_alias, use_husk_events, nil)

	if not resolved then
		return
	end

	_set_wwise_switch(wwise_world, unit, owner_visual_loadout_extension, profile_properties_wwise_switch, source_id)

	local playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)

	return playing_id, stop_event_name
end

return CompanionVisualLoadout
