local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Herding = require("scripts/utilities/herding")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local MinionRagdoll = class("MinionRagdoll")
local ESTIMATED_MAX_NEW_RAGDOLLS_PER_FRAME = 50
local RAGDOLL_PUSH_CACHE_SIZE = 50

MinionRagdoll.init = function (self)
	self._num_ragdolls = 0
	self._ragdolls = {}
	self._delayed_ragdoll_anim_events = Script.new_array(ESTIMATED_MAX_NEW_RAGDOLLS_PER_FRAME)
	self._new_delayed_ragdoll_anim_events = Script.new_array(ESTIMATED_MAX_NEW_RAGDOLLS_PER_FRAME)
	local delayed_ragdoll_push_cache = Script.new_array(RAGDOLL_PUSH_CACHE_SIZE)

	for i = 1, RAGDOLL_PUSH_CACHE_SIZE, 1 do
		delayed_ragdoll_push_cache[i] = {}
	end

	self._delayed_ragdoll_push_cache = delayed_ragdoll_push_cache
	self._delayed_ragdoll_push_index = 0
end

MinionRagdoll.cleanup_ragdolls = function (self)
	local ragdolls = self._ragdolls

	for i = #ragdolls, 1, -1 do
		local ragdoll_unit = ragdolls[i]

		self:_remove_ragdoll(ragdoll_unit)
	end
end

local POSITION_NODE_NAME = "j_hips"

MinionRagdoll.update = function (self, soft_cap_out_of_bounds_units)
	local Unit_animation_event = Unit.animation_event
	local delayed_ragdoll_anim_events = self._delayed_ragdoll_anim_events

	for i = 1, #delayed_ragdoll_anim_events, 1 do
		local unit = delayed_ragdoll_anim_events[i]

		Unit_animation_event(unit, "ragdoll")

		delayed_ragdoll_anim_events[i] = nil
	end

	self._new_delayed_ragdoll_anim_events = delayed_ragdoll_anim_events
	self._delayed_ragdoll_anim_events = self._new_delayed_ragdoll_anim_events
	local ragdolls = self._ragdolls
	local num_ragdolls = self._num_ragdolls

	for i = num_ragdolls, 1, -1 do
		local ragdoll_unit = ragdolls[i]

		if soft_cap_out_of_bounds_units[ragdoll_unit] then
			local unit_data_extension = ScriptUnit.extension(ragdoll_unit, "unit_data_system")
			local breed_name = unit_data_extension:breed_name()
			local node_index = Unit.node(ragdoll_unit, POSITION_NODE_NAME)

			Log.info("MinionRagdoll", "%s's %s is out-of-bounds, despawning (%s).", breed_name, ragdoll_unit, tostring(Unit.world_position(ragdoll_unit, node_index)))
			self:_remove_ragdoll(ragdoll_unit)
		end
	end

	self:_update_delayed_ragdoll_push_cache()
end

MinionRagdoll._update_delayed_ragdoll_push_cache = function (self)
	local delayed_ragdoll_push_cache = self._delayed_ragdoll_push_cache
	local index = 1

	while index <= self._delayed_ragdoll_push_index do
		local data = delayed_ragdoll_push_cache[index]
		local unit = data.unit
		local attack_direction = data.attack_direction:unbox()
		local push_force = data.push_force
		local push_force_data = data.push_force_data
		local added_force = false

		for actor_name, force_scale in pairs(push_force_data) do
			local actor = Unit.actor(unit, actor_name)

			if actor then
				local force = push_force * force_scale

				Actor.add_impulse(actor, attack_direction * force)

				added_force = true
			end
		end

		if added_force then
			self:_clear_delayed_ragdoll_push_entry(index)
		else
			index = index + 1
		end
	end
end

MinionRagdoll._clear_delayed_ragdoll_push_entry = function (self, index)
	local delayed_ragdoll_push_cache = self._delayed_ragdoll_push_cache
	local current_cache_index = self._delayed_ragdoll_push_index

	for i = index + 1, current_cache_index, 1 do
		local prev_data = delayed_ragdoll_push_cache[i - 1]
		local data = delayed_ragdoll_push_cache[i]
		prev_data.unit = data.unit
		prev_data.attack_direction = data.attack_direction
		prev_data.push_force = data.push_force
		prev_data.hit_zone_name = data.hit_zone_name
		prev_data.push_force_data = data.push_force_data
	end

	table.clear(delayed_ragdoll_push_cache[current_cache_index])

	self._delayed_ragdoll_push_index = self._delayed_ragdoll_push_index - 1
end

MinionRagdoll.create_ragdoll = function (self, death_data)
	local unit = death_data.unit
	local ragdolls = self._ragdolls
	ragdolls[#ragdolls + 1] = unit
	self._num_ragdolls = self._num_ragdolls + 1
	local max_ragdolls = Application.user_setting("performance_settings", "max_ragdolls")

	while max_ragdolls < self._num_ragdolls do
		local first_ragdoll_unit = ragdolls[1]

		self:_remove_ragdoll(first_ragdoll_unit)
	end

	local do_ragdoll_push = death_data.do_ragdoll_push
	local hit_zone_name = death_data.hit_zone_name
	local attack_direction = death_data.attack_direction:unbox()

	if do_ragdoll_push and hit_zone_name and attack_direction then
		local damage_profile_name = death_data.damage_profile_name
		local damage_profile = DamageProfileTemplates[damage_profile_name]
		local herding_template_name_or_nil = death_data.herding_template_name
		local herding_template_or_nil = HerdingTemplates[herding_template_name_or_nil]

		self:push_ragdoll(unit, attack_direction, damage_profile, hit_zone_name, herding_template_or_nil)
	end

	self._new_delayed_ragdoll_anim_events[#self._new_delayed_ragdoll_anim_events + 1] = unit
end

MinionRagdoll._remove_ragdoll = function (self, unit)
	local new_delayed_ragdoll_anim_events = self._new_delayed_ragdoll_anim_events
	local new_delayed_index = table.index_of(new_delayed_ragdoll_anim_events, unit)

	if new_delayed_index ~= -1 then
		table.remove(new_delayed_ragdoll_anim_events, new_delayed_index)
	else
		local delayed_ragdoll_anim_events = self._delayed_ragdoll_anim_events
		local delayed_index = table.index_of(delayed_ragdoll_anim_events, unit)

		if delayed_index ~= -1 then
			table.remove(delayed_ragdoll_anim_events, delayed_index)
		end
	end

	local delayed_ragdoll_push_cache = self._delayed_ragdoll_push_cache

	for i = self._delayed_ragdoll_push_index, 1, -1 do
		local ragdoll_push_data = delayed_ragdoll_push_cache[i]

		if ragdoll_push_data.unit == unit then
			self:_clear_delayed_ragdoll_push_entry(i)
		end
	end

	local ragdolls = self._ragdolls
	local ragdoll_index = table.find(ragdolls, unit)

	table.remove(ragdolls, ragdoll_index)

	self._num_ragdolls = self._num_ragdolls - 1

	Managers.state.decal:remove_linked_decals(unit)
	Managers.state.unit_spawner:mark_for_deletion(unit)
end

local DEFAULT_PUSH_FORCE = 250

MinionRagdoll.push_ragdoll = function (self, unit, attack_direction, damage_profile, hit_zone_name, herding_template_or_nil)
	local push_force = DEFAULT_PUSH_FORCE

	if damage_profile.ragdoll_push_force then
		push_force = damage_profile.ragdoll_push_force

		if type(push_force) == "table" then
			push_force = math.random_range(push_force[1], push_force[2])
		end
	end

	local ragdoll_push_direction = attack_direction

	if herding_template_or_nil then
		ragdoll_push_direction = Herding.modify_ragdoll_push_direction(herding_template_or_nil, attack_direction, unit, hit_zone_name)
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local hit_zone_ragdoll_pushes = breed.hit_zone_ragdoll_pushes
	local push_force_data = hit_zone_ragdoll_pushes[hit_zone_name]

	fassert(push_force_data, "%s hit zone does not have any ragdoll push data", hit_zone_name)

	local current_cache_index = self._delayed_ragdoll_push_index

	if current_cache_index < RAGDOLL_PUSH_CACHE_SIZE then
		current_cache_index = current_cache_index + 1
		local push_multiplier = breed.push_multiplier or 1
		push_force = push_force * push_multiplier
		local delayed_ragdoll_push_cache = self._delayed_ragdoll_push_cache
		local data = delayed_ragdoll_push_cache[current_cache_index]
		data.unit = unit
		data.attack_direction = Vector3Box(ragdoll_push_direction)
		data.push_force = push_force
		data.hit_zone_name = hit_zone_name
		data.push_force_data = push_force_data
		self._delayed_ragdoll_push_index = current_cache_index
	end
end

return MinionRagdoll
