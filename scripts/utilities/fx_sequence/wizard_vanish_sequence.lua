-- chunkname: @scripts/utilities/fx_sequence/wizard_vanish_sequence.lua

local RenegadeWizardVanishSettings = require("scripts/settings/fx/effect_templates/renegade_wizard_vanish_settings")
local WizardVanishSequence = {}
local _build_sets, _segment_durations, _total_weight, _unit_gone, _start_next_set, _spawn_section, _update_emitter_scale, _update_section, _finish_section, _release
local REVERSE_DIRECTION = RenegadeWizardVanishSettings.DIRECTION_BOTTOM_UP
local MIN_EMITTER_SCALE = 1

WizardVanishSequence.init = function (template_data, direction, optional_duration)
	local template = RenegadeWizardVanishSettings.templates.renegade_wizard_vanish
	local unit = template_data.unit
	local reversed = direction == REVERSE_DIRECTION
	local set_delay_weight = template.set_delay_weight
	local sets = _build_sets(unit, template, reversed)
	local world = Unit.world(unit)
	local duration = optional_duration or template.duration

	template_data.world = world
	template_data.template = template
	template_data.sets = sets
	template_data.time_scale = duration / _total_weight(sets, set_delay_weight)
	template_data.set_index = 0
	template_data.next_set_t = nil
	template_data.active_sections = {}
	template_data.done = false

	_start_next_set(template_data)
end

WizardVanishSequence.update = function (template_data, dt, t)
	if template_data.done then
		return true
	end

	local unit = template_data.unit

	if _unit_gone(unit) then
		_release(template_data.active_sections, template_data.world)

		template_data.done = true

		return true
	end

	local next_set_t = template_data.next_set_t

	if next_set_t then
		if t < next_set_t then
			return false
		end

		template_data.next_set_t = nil

		if _start_next_set(template_data) then
			return true
		end
	end

	local world = template_data.world
	local template = template_data.template
	local active_sections = template_data.active_sections
	local all_done = true

	for i = 1, #active_sections do
		local section = active_sections[i]

		if not section.done then
			_update_section(section, dt, unit, world, template)
		end

		all_done = all_done and section.done
	end

	if not all_done then
		return false
	end

	if template_data.set_index >= #template_data.sets then
		template_data.done = true

		return true
	end

	local delay = template.set_delay_weight * template_data.time_scale

	if delay > 0 then
		template_data.next_set_t = t + delay

		return false
	end

	return _start_next_set(template_data)
end

WizardVanishSequence.exit = function (template_data)
	local active_sections = template_data.active_sections

	if active_sections then
		_release(active_sections, template_data.world)
	end

	template_data.next_set_t = nil
	template_data.done = true
end

function _build_sets(unit, template, reversed)
	local source_sets = template.sets
	local num_sets = #source_sets
	local sets = Script.new_array(num_sets)

	for i = 1, num_sets do
		local source_set = source_sets[reversed and num_sets - i + 1 or i]
		local set = {}

		for j = 1, #source_set do
			local config = source_set[j]
			local bone_names = reversed and table.reverse(config.bones) or config.bones
			local chain = Script.new_array(#bone_names)
			local valid = true

			for k = 1, #bone_names do
				if Unit.has_node(unit, bone_names[k]) then
					chain[k] = Unit.node(unit, bone_names[k])
				else
					valid = false

					break
				end
			end

			if valid and #chain > 1 then
				set[#set + 1] = {
					config = config,
					chain = chain,
				}
			else
				Log.warning("WizardVanishSequence", "skipping section %q, missing bones on unit %s", config.name, tostring(unit))
			end
		end

		sets[i] = set
	end

	return sets
end

function _segment_durations(unit, chain, total_duration)
	local num_segments = #chain - 1
	local durations = Script.new_array(num_segments)
	local lengths = Script.new_array(num_segments)
	local total_length = 0

	for i = 1, num_segments do
		local length = Vector3.distance(Unit.world_position(unit, chain[i]), Unit.world_position(unit, chain[i + 1]))

		lengths[i] = length
		total_length = total_length + length
	end

	for i = 1, num_segments do
		if total_length > 0 then
			durations[i] = total_duration * (lengths[i] / total_length)
		else
			durations[i] = total_duration / num_segments
		end
	end

	return durations
end

function _total_weight(sets, set_delay_weight)
	local num_sets = #sets
	local total = 0

	for i = 1, num_sets do
		local longest = 0

		for j = 1, #sets[i] do
			longest = math.max(longest, sets[i][j].config.duration_weight)
		end

		total = total + longest

		if i < num_sets then
			total = total + set_delay_weight
		end
	end

	return total > 0 and total or 1
end

function _unit_gone(unit)
	return not unit or not Unit.alive(unit)
end

function _start_next_set(template_data)
	local set_index = template_data.set_index + 1

	template_data.set_index = set_index

	local set = template_data.sets[set_index]

	if not set then
		template_data.done = true

		return true
	end

	local active_sections = template_data.active_sections

	table.clear(active_sections)

	local time_scale = template_data.time_scale
	local unit = template_data.unit
	local world = template_data.world
	local template = template_data.template

	for i = 1, #set do
		local section = set[i]
		local duration = section.config.duration_weight * time_scale

		active_sections[#active_sections + 1] = {
			done = false,
			effect_id = nil,
			material = nil,
			progress = 0,
			segment_index = 1,
			segment_t = 0,
			config = section.config,
			chain = section.chain,
			segment_durations = _segment_durations(unit, section.chain, duration),
		}
	end

	for i = 1, #active_sections do
		_spawn_section(active_sections[i], unit, world, template)
	end

	return false
end

function _spawn_section(section, unit, world, template)
	local first_node = section.chain[1]
	local position = Unit.world_position(unit, first_node)
	local rotation = Unit.world_rotation(unit, first_node)
	local effect_id = World.create_particles(world, template.vfx_name, position, rotation)

	section.effect_id = effect_id

	local cloud_name = template.cloud_name

	section.material = World.get_particles_material(world, effect_id, cloud_name)

	_update_emitter_scale(section, world, template)
end

function _update_emitter_scale(section, world, template)
	local material = section.material

	if not material then
		return
	end

	local config = section.config
	local start_scale = config.start_scale or MIN_EMITTER_SCALE
	local end_scale = config.end_scale or start_scale
	local scale = math.lerp(start_scale, end_scale, section.progress)
	local safe_scale = math.max(scale, MIN_EMITTER_SCALE)

	Material.set_scalar(material, template.scale_variable, safe_scale)
	World.set_particles_variable(world, section.effect_id, 1, Vector3(safe_scale, 0, 0))
end

function _update_section(section, dt, unit, world, template)
	local chain = section.chain
	local durations = section.segment_durations
	local remaining = dt

	while remaining > 0 do
		local segment_duration = durations[section.segment_index]

		if not segment_duration then
			_finish_section(section, unit, world, template)

			return
		end

		local step = math.min(remaining, (1 - section.segment_t) * segment_duration)

		section.segment_t = section.segment_t + (segment_duration > 0 and step / segment_duration or 1)
		remaining = remaining - step

		if section.segment_t >= 1 then
			section.segment_index = section.segment_index + 1
			section.segment_t = 0

			if section.segment_index > #chain - 1 then
				_finish_section(section, unit, world, template)

				return
			end
		end
	end

	local current_node = chain[section.segment_index]
	local target_node = chain[section.segment_index + 1]
	local position = Vector3.lerp(Unit.world_position(unit, current_node), Unit.world_position(unit, target_node), section.segment_t)
	local rotation = Unit.world_rotation(unit, current_node)

	section.progress = (section.segment_index - 1 + section.segment_t) / (#chain - 1)

	World.move_particles(world, section.effect_id, position, rotation)
	_update_emitter_scale(section, world, template)
end

function _finish_section(section, unit, world, template)
	local chain = section.chain
	local last_node = chain[#chain]

	section.progress = 1
	section.done = true

	World.move_particles(world, section.effect_id, Unit.world_position(unit, last_node), Unit.world_rotation(unit, last_node))
	_update_emitter_scale(section, world, template)
	World.stop_spawning_particles(world, section.effect_id)
end

function _release(active_sections, world)
	for i = 1, #active_sections do
		local section = active_sections[i]

		if section.effect_id and not section.done then
			World.stop_spawning_particles(world, section.effect_id)
		end
	end

	table.clear(active_sections)
end

return WizardVanishSequence
