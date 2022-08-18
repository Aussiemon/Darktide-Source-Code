local BuffSettings = require("scripts/settings/buff/buff_settings")
local MasterItems = require("scripts/backend/master_items")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local BuffArgs = require("scripts/extension_systems/buff/utility/buff_args")
local stat_buff_types = BuffSettings.stat_buff_types
local stat_buff_base_values = BuffSettings.stat_buff_base_values
local Buff = class("Buff")
local EMPTY_TABLE = {}

Buff.init = function (self, context, template, start_time, instance_id, ...)
	local template_context = {
		stack_count = 1,
		world = context.world,
		wwise_world = context.wwise_world,
		unit = context.unit,
		buff_extension = context.buff_extension,
		is_local_unit = context.is_local_unit,
		is_player = (context.player and true) or false,
		is_server = context.is_server,
		breed = context.breed,
		template = template
	}

	BuffArgs.add_args_to_context(template_context, ...)

	self._template_context = template_context
	self._player = context.player
	self._unit = context.unit
	self._template = template
	self._template_override_data = self:_calculate_template_override_data(template_context)
	self._template_data = {}
	self._duration_progress = 0
	self._start_time = start_time
	self._instance_id = instance_id
	self._finished = false
	self._lerped_stat_buffs = {}
	local unit_data_extension = ScriptUnit.has_extension(self._unit, "unit_data_system")

	if unit_data_extension and self._player then
		self._specialization_resource_component = unit_data_extension:read_component("specialization_resource")
	end

	local start_function = template.start_func

	if start_function then
		start_function(self._template_data, self._template_context)
	end
end

Buff._calculate_template_override_data = function (self, template_context)
	local override_data = {}
	local item_slot_name = template_context.item_slot_name

	if item_slot_name then
		self:_calculate_weapon_trait_override_data(override_data, item_slot_name)
	end

	return override_data
end

local function _add_trait_overrides(trait_name, rarity, template_name, override_data)
	local trait = WeaponTraitTemplates[trait_name]

	for buff_name, rarity_data in pairs(trait) do
		if buff_name == template_name then
			table.merge_recursive(override_data, rarity_data[rarity])
		end
	end
end

Buff._calculate_weapon_trait_override_data = function (self, override_data, item_slot_name)
	local template = self._template
	local template_name = template.name
	local player = self._player
	local profile = player:profile()
	local debug_weapon_modifiers = profile.weapon_modifiers and profile.weapon_modifiers[item_slot_name]
	local use_override = debug_weapon_modifiers and not not debug_weapon_modifiers.traits

	if not use_override then
		local equiped_item = profile.visual_loadout[item_slot_name]
		local traits = (equiped_item and equiped_item.traits) or EMPTY_TABLE
		local item_definitions = MasterItems.get_cached()

		for i = 1, #traits, 1 do
			local trait = traits[i]
			local trait_item_id = trait.id
			local rarity = trait.rarity or 1
			local trait_item = item_definitions[trait_item_id]

			if trait_item then
				local trait_name = trait_item.trait

				_add_trait_overrides(trait_name, rarity, template_name, override_data)
			else
				Log.warning("Buff", "Could not find item for trait %s when abbplying buffs %s ", trait_item_id, template_name)
			end
		end
	else
		local traits = (debug_weapon_modifiers and debug_weapon_modifiers.traits) or EMPTY_TABLE

		for i = 1, #traits, 1 do
			local trait_data = traits[i]
			local trait_name = trait_data.name
			local rarity = trait_data.rarity

			_add_trait_overrides(trait_name, rarity, template_name, override_data)
		end
	end

	return override_data
end

Buff.set_buff_component = function (self, buff_component, component_keys, component_index)
	local template = self._template
	local start_time = self._start_time

	fassert(not self._buff_component, "overwriting already set buff_component for buff: %q", template.name)

	self._buff_component = buff_component
	self._component_keys = component_keys
	self._component_index = component_index
	local template_name_key = component_keys.template_name_key
	local start_time_key = component_keys.start_time_key
	local stack_count_key = component_keys.stack_count_key
	buff_component[template_name_key] = template.name
	buff_component[start_time_key] = start_time
	local stack_count = self:stack_count()
	buff_component[stack_count_key] = stack_count
end

Buff.remove_buff_component = function (self)
	local buff_component = self._buff_component
	local component_keys = self._component_keys
	local template_name_key = component_keys.template_name_key
	local start_time_key = component_keys.start_time_key
	local active_start_time_key = component_keys.active_start_time_key
	local stack_count_key = component_keys.stack_count_key
	local proc_count_key = component_keys.proc_count_key
	buff_component[template_name_key] = "none"
	buff_component[start_time_key] = 0
	buff_component[active_start_time_key] = 0
	buff_component[stack_count_key] = 0
	buff_component[proc_count_key] = 0
end

Buff.update = function (self, dt, t, portable_random)
	local template = self._template
	local template_data = self._template_data
	local template_context = self._template_context
	local conditional_exit_func = template.conditional_exit_func

	if conditional_exit_func and conditional_exit_func(template_data, template_context) then
		self._finished = true
	end

	local conditional_stack_exit_func = template.conditional_stack_exit_func

	if conditional_stack_exit_func then
		local should_remove_stack = self._should_remove_stack

		if not should_remove_stack and conditional_stack_exit_func(template_data, template_context) then
			self._should_remove_stack = true
		elseif should_remove_stack then
			self._should_remove_stack = false
		end
	end

	local duration = self:duration()

	if duration then
		local extra_duration = template_data.extra_duration or 0
		local total_duration = duration + extra_duration
		local start_time = self._start_time
		self._duration_progress = math.clamp((total_duration - (t - start_time)) / total_duration, 0, 1)

		if t > start_time + total_duration then
			self._finished = true
		end
	end

	local update_func = template.update_func

	if update_func then
		update_func(template_data, template_context, dt, t, template)
	end
end

Buff.refresh_func = function (self, t)
	local template = self._template
	local template_data = self._template_data
	local template_context = self._template_context
	local refresh_func = template.refresh_func

	if refresh_func then
		refresh_func(template_data, template_context, t)
	end
end

Buff.finished = function (self)
	return self._finished
end

Buff.removed_stack_by_request = function (self)
	self._should_remove_stack = false
end

Buff.should_remove_stack = function (self)
	local last_stack = self:stack_count() == 1

	return self._should_remove_stack, last_stack
end

Buff.show_in_hud = function (self)
	local hud_priority = self:hud_priority()

	return hud_priority ~= nil
end

Buff.hud_priority = function (self)
	local template = self._template

	return template.hud_priority
end

Buff.hud_icon = function (self)
	local template = self._template

	return template.hud_icon
end

Buff.is_negative = function (self)
	local template = self._template
	local is_negative = template.is_negative

	return not not is_negative
end

Buff.inactive = function (self)
	return false
end

Buff.instance_id = function (self)
	return self._instance_id
end

Buff.component_index = function (self)
	return self._component_index
end

Buff.is_predicted = function (self)
	local template = self._template
	local is_predicted = template.predicted

	return is_predicted
end

Buff.stack_count = function (self)
	local template_context = self._template_context
	local stack_count = template_context.stack_count

	return stack_count
end

Buff.stack_count_clamped = function (self)
	local stack_count = self:stack_count()
	local max_stack = self:max_stacks() or 1
	local clamped_stack_count = math.clamp(stack_count, 0, max_stack)

	return clamped_stack_count
end

Buff.visual_stack_count = function (self)
	local template = self._template
	local use_specialization_resource = template.use_specialization_resource

	if use_specialization_resource then
		local resource = self._specialization_resource_component.current_resource

		return resource
	end

	return self:stack_count_clamped()
end

Buff.max_stacks = function (self)
	local template = self._template
	local max_stacks = template.max_stacks

	return max_stacks
end

Buff.add_stack = function (self)
	local current_stack_count = self:stack_count()
	local new_stack_count = current_stack_count + 1

	self:set_stack_count(new_stack_count)
end

Buff.remove_stack = function (self)
	local current_stack_count = self:stack_count()
	local new_stack_count = current_stack_count - 1

	self:set_stack_count(new_stack_count)

	return new_stack_count
end

Buff.set_stack_count = function (self, wanted_stack_count)
	local previous_stack_count = self:stack_count()
	local change = math.abs(previous_stack_count - wanted_stack_count)

	if change == 0 then
		return
	end

	local template = self._template
	local max_stacks = template.max_stacks

	fassert(max_stacks, "no max_stacks defined when attempting to stack buff: %q", template.name)

	local new_stack_count = math.max(wanted_stack_count, 0)
	self._template_context.stack_count = new_stack_count

	if wanted_stack_count <= max_stacks then
		if previous_stack_count < wanted_stack_count then
			local on_add_stack_function = template.on_add_stack_function

			if on_add_stack_function then
				on_add_stack_function(self._template_data, self._template_context, change, new_stack_count)
			end
		elseif wanted_stack_count < previous_stack_count then
			local on_remove_stack_function = template.on_remove_stack_function

			if on_remove_stack_function then
				on_remove_stack_function(self._template_data, self._template_context, change, new_stack_count)
			end
		end
	end

	if max_stacks <= wanted_stack_count then
		if previous_stack_count ~= max_stacks then
			local on_reached_max_stack_function = template.on_reached_max_stack_function

			if on_reached_max_stack_function then
				on_reached_max_stack_function(self._template_data, self._template_context, change)
			end
		end

		if max_stacks < wanted_stack_count then
			local on_stack_overflow_function = template.on_stack_overflow_function

			if on_stack_overflow_function then
				on_stack_overflow_function(self._template_data, self._template_context)
			end
		end
	end
end

Buff.duration = function (self)
	return self._template.duration
end

Buff.duration_progress = function (self)
	return self._duration_progress
end

Buff.template_name = function (self)
	local template = self._template

	return template.name
end

Buff.template = function (self)
	local template = self._template

	return template
end

Buff.start_time = function (self)
	return self._start_time
end

Buff.set_start_time = function (self, start_time)
	self._start_time = start_time
end

Buff.buff_lerp_value = function (self)
	return self._template_context.buff_lerp_value
end

Buff.item_slot_name = function (self)
	return self._template_context.item_slot_name
end

Buff._calculate_stat_buffs = function (self, current_stat_buffs, stat_buffs)
	local stack_count = self:stack_count_clamped()

	if not stat_buffs then
		return
	end

	local template_override_data = self._template_override_data
	local stat_buff_overrides = template_override_data and template_override_data.stat_buffs

	for key, value in pairs(stat_buffs) do
		if stat_buff_overrides then
			value = stat_buff_overrides[key] or value
		end

		local current_value = current_stat_buffs[key]
		local stat_buff_type = stat_buff_types[key]

		for _ = 1, stack_count, 1 do
			if stat_buff_type == "multiplicative_multiplier" then
				current_value = current_value * value
			else
				current_value = current_value + value
			end
		end

		current_stat_buffs[key] = current_value
	end
end

Buff.update_stat_buffs = function (self, current_stat_buffs, t)
	local template = self._template
	local base_stat_buffs = template.stat_buffs or EMPTY_TABLE

	self:_calculate_stat_buffs(current_stat_buffs, base_stat_buffs)

	local conditional_stat_buffs_func = template.conditional_stat_buffs_func

	if conditional_stat_buffs_func and conditional_stat_buffs_func(self._template_data, self._template_context) then
		local conditional_stat_buffs = template.conditional_stat_buffs

		self:_calculate_stat_buffs(current_stat_buffs, conditional_stat_buffs)
	end

	local lerped_stat_buffs = template.lerped_stat_buffs

	if lerped_stat_buffs then
		local start_time = self._start_time
		local duration = template.duration
		local conditional_lerped_stat_buffs_func = template.conditional_lerped_stat_buffs_func

		if not conditional_lerped_stat_buffs_func or conditional_lerped_stat_buffs_func(self._template_data, self._template_context) then
			local lerp_t = template.lerp_t_func(t, start_time, duration, self._template_data, self._template_context)

			table.clear(self._lerped_stat_buffs)

			for key, values in pairs(lerped_stat_buffs) do
				local min = values.min
				local max = values.max
				local lerped_value = math.lerp(min, max, lerp_t)
				self._lerped_stat_buffs[key] = lerped_value
			end

			self:_calculate_stat_buffs(current_stat_buffs, self._lerped_stat_buffs)
		end
	end
end

Buff.update_keywords = function (self, current_key_words)
	local template = self._template
	local keywords = template.keywords

	if keywords then
		self:_add_keywords(keywords, current_key_words)
	end

	local conditional_keywords_func = template.conditional_keywords_func or template.conditional_stat_buffs_func
	local conditional_keywords = template.conditional_keywords

	if conditional_keywords and conditional_keywords_func and conditional_keywords_func(self._template_data, self._template_context) then
		self:_add_keywords(conditional_keywords, current_key_words)
	end

	return current_key_words
end

Buff._add_keywords = function (self, keywords, current_key_words)
	if keywords then
		for _, keyword in pairs(keywords) do
			current_key_words[keyword] = true
		end
	end
end

Buff.destroy = function (self)
	local template = self._template
	local stop_function = template.stop_func

	if stop_function then
		stop_function(self._template_data, self._template_context)
	end

	table.clear(self._template_data)
end

Buff.progressbar = function (self)
	local template = self._template
	local health_bar_override_func = template.progressbar_func

	if health_bar_override_func then
		local template_data = self._template_data
		local template_context = self._template_context

		return health_bar_override_func(template_data, template_context)
	end

	return nil
end

return Buff
