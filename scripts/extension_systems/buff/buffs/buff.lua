﻿-- chunkname: @scripts/extension_systems/buff/buffs/buff.lua

local BuffArgs = require("scripts/extension_systems/buff/utility/buff_args")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local MasterItems = require("scripts/backend/master_items")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local stat_buff_types = BuffSettings.stat_buff_types
local stat_buff_base_values = BuffSettings.stat_buff_base_values
local Buff = class("Buff")

local function _update_conditional_exit_func(self, template, template_data, template_context)
	if template.conditional_exit_func(template_data, template_context) then
		self._finished = true
	end
end

local function _update_conditional_stack_exit_func(self, template, template_data, template_context)
	local should_remove_stack = self._should_remove_stack

	if not should_remove_stack and template.conditional_stack_exit_func(template_data, template_context) then
		self._should_remove_stack = true
	elseif should_remove_stack then
		self._should_remove_stack = false
	end
end

local function _update_duration(self, template, template_data, template_context, t, dt)
	local duration = self:duration()
	local extra_duration = template_data.extra_duration or 0
	local total_duration = duration + extra_duration
	local start_time = self._start_time

	self._duration_progress = math.clamp01((total_duration - (t - start_time)) / total_duration)

	if t > start_time + total_duration then
		self._finished = true
	end
end

local function _update_buff_func(self, template, template_data, template_context, t, dt)
	template.update_func(template_data, template_context, dt, t, template)
end

local EMPTY_TABLE = {}

Buff.init = function (self, context, template, start_time, instance_id, ...)
	local template_context = {
		stack_count = 1,
		world = context.world,
		physics_world = context.physics_world,
		wwise_world = context.wwise_world,
		unit = context.unit,
		player = context.player,
		buff_extension = context.buff_extension,
		is_local_unit = context.is_local_unit,
		is_player = context.player and true or false,
		is_server = context.is_server,
		breed = context.breed,
		template = template,
	}
	local additional_arguments = {}

	BuffArgs.add_args_to_context(template_context, additional_arguments, ...)

	self._template_context = template_context
	self._additional_arguments = additional_arguments
	self._player = context.player
	self._unit = context.unit
	self._template = template

	local template_override_data = self:_calculate_template_override_data(template_context)

	self._template_override_data = template_override_data
	template_context.template_override_data = template_override_data
	self._template_data = {}
	self._template_name = template.name
	self._duration_progress = 1
	self._start_time = start_time
	self._instance_id = instance_id
	self._finished = false
	self._lerped_stat_buffs = {}

	local unit_data_extension = ScriptUnit.has_extension(self._unit, "unit_data_system")

	if unit_data_extension and self._player then
		self._talent_resource_component = unit_data_extension:read_component("talent_resource")
	end

	local start_function = template.start_func

	if start_function then
		start_function(self._template_data, self._template_context)
	end

	local update_funcs = {}
	local num_update_funcs = 0

	if template.conditional_exit_func then
		num_update_funcs = num_update_funcs + 1
		update_funcs[num_update_funcs] = _update_conditional_exit_func
	end

	if template.conditional_stack_exit_func then
		num_update_funcs = num_update_funcs + 1
		update_funcs[num_update_funcs] = _update_conditional_stack_exit_func
	end

	if self:duration() then
		num_update_funcs = num_update_funcs + 1
		update_funcs[num_update_funcs] = _update_duration
	end

	if template.update_func then
		num_update_funcs = num_update_funcs + 1
		update_funcs[num_update_funcs] = _update_buff_func
	end

	self._update_funcs = update_funcs
	self._num_update_funcs = #update_funcs
	self._num_constant_keywords = template.keywords and #template.keywords

	local conditional_keywords_func = template.conditional_keywords_func or template.conditional_stat_buffs_func
	local conditional_keywords = conditional_keywords_func and template.conditional_keywords

	self._conditional_keywords_func = conditional_keywords_func
	self._num_conditional_keywords = conditional_keywords and #conditional_keywords
end

Buff._calculate_template_override_data = function (self, template_context)
	local override_data = {}
	local item_slot_name = template_context.item_slot_name
	local from_talent = template_context.from_talent

	if item_slot_name then
		self:_calculate_override_data(override_data, item_slot_name, template_context.parent_buff_template)
	elseif from_talent then
		self:_calculate_talent_override_data(override_data, template_context.parent_buff_template)
	end

	return override_data
end

local function _add_overrides(trait, trait_item, rarity, template_name, override_data, parent_buff_template_or_nil)
	local trait_buffs = trait.buffs

	for buff_name, rarity_data in pairs(trait_buffs) do
		local should_merge_overrides = buff_name == template_name or parent_buff_template_or_nil and parent_buff_template_or_nil == buff_name or false
		local current_rarity_data

		for i = rarity, 1, -1 do
			current_rarity_data = rarity_data[i]

			if current_rarity_data then
				break
			end
		end

		if should_merge_overrides then
			table.merge_recursive(override_data, current_rarity_data)

			local icon_small = trait_item and trait_item.icon_small

			if icon_small and icon_small ~= "" then
				override_data.item_icon = icon_small
			end
		end
	end
end

local function _add_overrides_from_item(traits, item_definitions, template_name, override_data, parent_buff_template_or_nil)
	local num_traits = #traits

	for i = 1, num_traits do
		local data = traits[i]
		local item_id = data.id
		local rarity = data.rarity or 1
		local item = item_definitions[item_id]

		if item then
			local trait_name = item.trait
			local trait = WeaponTraitTemplates[trait_name]

			if trait then
				_add_overrides(trait, item, rarity, template_name, override_data, parent_buff_template_or_nil)
			end
		else
			Log.warning("Buff", "Could not find item for trait %s when appplying buff %s", item_id, template_name)
		end
	end
end

Buff._calculate_override_data = function (self, override_data, item_slot_name, parent_buff_template_or_nil)
	local template = self._template
	local template_name = template.name
	local player = self._player
	local profile = player:profile()
	local equipped_item = profile.loadout[item_slot_name]
	local item_definitions = MasterItems.get_cached()
	local traits = equipped_item and equipped_item.traits or EMPTY_TABLE

	_add_overrides_from_item(traits, item_definitions, template_name, override_data, parent_buff_template_or_nil)

	local perks = equipped_item and equipped_item.perks or EMPTY_TABLE

	_add_overrides_from_item(perks, item_definitions, template_name, override_data, parent_buff_template_or_nil)

	return override_data
end

Buff._calculate_talent_override_data = function (self, override_data, parent_buff_template_or_nil)
	local template = self._template
	local talent_overrides = template.talent_overrides

	if not talent_overrides then
		return
	end

	local num_talent_overrides = #talent_overrides

	if num_talent_overrides == 0 then
		return
	end

	local talent_extension = ScriptUnit.extension(self._unit, "talent_system")
	local tier

	if parent_buff_template_or_nil then
		tier = talent_extension:buff_template_tier(parent_buff_template_or_nil)
	else
		tier = talent_extension:buff_template_tier(template.name)
	end

	local override_index = math.min(tier, num_talent_overrides)
	local override_def = talent_overrides[override_index]

	table.merge_recursive(override_data, override_def)
end

Buff.set_buff_component = function (self, buff_component, component_keys, component_index)
	local template = self._template
	local start_time = self._start_time

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
	local num_update_funcs = self._num_update_funcs

	if num_update_funcs > 0 then
		local template = self._template
		local template_data = self._template_data
		local template_context = self._template_context
		local update_funcs = self._update_funcs

		for i = 1, num_update_funcs do
			update_funcs[i](self, template, template_data, template_context, t, dt)
		end
	end
end

Buff.refresh_func = function (self, t, previous_stack_count)
	local template = self._template
	local refresh_func = template.refresh_func

	if refresh_func then
		refresh_func(self._template_data, self._template_context, t, previous_stack_count)
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

Buff.force_predicted_proc = function (self)
	return false
end

Buff.stack_count = function (self)
	local template_context = self._template_context
	local stack_count = template_context.stack_count

	return stack_count
end

Buff.stat_buff_stacking_count = function (self)
	local stack_count = self:stack_count()
	local max_stacks = self._template.max_stat_stacks or self:max_stacks() or 1
	local stack_offset = self._template.stack_offset or 0
	local clamped_stack_count = math.clamp(stack_count + stack_offset, 0, max_stacks)

	return clamped_stack_count
end

Buff.max_stacks = function (self)
	local template = self._template
	local template_override_data = self._template_override_data
	local max_stacks = template_override_data and template_override_data.max_stacks or template.max_stacks

	if max_stacks then
		local stack_offset = template.stack_offset or 0

		max_stacks = max_stacks + math.abs(stack_offset)
	end

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
	local max_stacks = self:max_stacks()
	local new_stack_count = math.max(wanted_stack_count, 0)

	self._template_context.stack_count = new_stack_count

	if wanted_stack_count <= max_stacks then
		if previous_stack_count < wanted_stack_count then
			local on_add_stack_func = template.on_add_stack_func

			if on_add_stack_func then
				on_add_stack_func(self._template_data, self._template_context, change, new_stack_count)
			end
		elseif wanted_stack_count < previous_stack_count then
			local on_remove_stack_func = template.on_remove_stack_func

			if on_remove_stack_func then
				on_remove_stack_func(self._template_data, self._template_context, change, new_stack_count)
			end
		end
	end

	if max_stacks <= wanted_stack_count then
		if previous_stack_count ~= max_stacks then
			local on_reached_max_stack_func = template.on_reached_max_stack_func

			if on_reached_max_stack_func then
				on_reached_max_stack_func(self._template_data, self._template_context, change)
			end
		end

		if max_stacks < wanted_stack_count then
			local on_stack_overflow_func = template.on_stack_overflow_func

			if on_stack_overflow_func then
				on_stack_overflow_func(self._template_data, self._template_context)
			end
		end
	end
end

Buff.duration = function (self)
	local template = self._template
	local duration = template.duration

	if duration and template.duration_per_stack then
		local stack_count = self:stack_count()

		return duration * stack_count
	end

	return duration
end

Buff.duration_progress = function (self)
	local template = self._template
	local inverse_duration_progress = template.inverse_duration_progress
	local duration_progress = self._duration_progress
	local custom_duration_func = template.duration_func

	if custom_duration_func then
		duration_progress = custom_duration_func(self._template_data, self._template_context)
	end

	return inverse_duration_progress and 1 - duration_progress or duration_progress
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

	if self._active_start_time then
		self._active_start_time = start_time
	end

	local template = self._template

	if template.duration then
		self._finished = false
	end

	if self._player and self._player.remote then
		self._need_to_sync_start_time = true
	end
end

Buff.need_to_sync_start_time = function (self)
	return self._need_to_sync_start_time
end

Buff.set_need_to_sync_start_time = function (self, sync)
	self._need_to_sync_start_time = sync
end

Buff.buff_lerp_value = function (self)
	return self._template_context.buff_lerp_value
end

Buff.item_slot_name = function (self)
	return self._template_context.item_slot_name
end

Buff.additional_arguments = function (self)
	return self._additional_arguments
end

Buff.owner_unit = function (self)
	return self._template_context.owner_unit
end

Buff.parent_buff_template = function (self)
	return self._template_context.parent_buff_template
end

Buff._calculate_stat_buffs = function (self, current_stat_buffs, stat_buffs)
	if not stat_buffs then
		return
	end

	local stat_buff_stacking_count = self:stat_buff_stacking_count()
	local template_override_data = self._template_override_data
	local stat_buff_overrides = template_override_data and template_override_data.stat_buffs

	for key, value in pairs(stat_buffs) do
		value = stat_buff_overrides and stat_buff_overrides[key] or value

		local current_value = current_stat_buffs[key]
		local stat_buff_type = stat_buff_types[key]

		for _ = 1, stat_buff_stacking_count do
			if stat_buff_type == "multiplicative_multiplier" then
				current_value = current_value * value
			elseif stat_buff_type == "max_value" then
				current_value = math.max(current_value, value)
			else
				current_value = current_value + value
			end
		end

		current_stat_buffs[key] = current_value
		current_stat_buffs._modified_stats[key] = true
	end
end

Buff.update_stat_buffs = function (self, current_stat_buffs, t)
	local template = self._template
	local base_stat_buffs = template.stat_buffs or EMPTY_TABLE

	self:_calculate_stat_buffs(current_stat_buffs, base_stat_buffs)

	local conditional_stat_buffs_func = template.conditional_stat_buffs_func

	if conditional_stat_buffs_func and conditional_stat_buffs_func(self._template_data, self._template_context) then
		local template_override_data = self._template_override_data
		local override_conditional_state_buffs = template_override_data and template_override_data.conditional_stat_buffs
		local conditional_stat_buffs = override_conditional_state_buffs or template.conditional_stat_buffs

		self:_calculate_stat_buffs(current_stat_buffs, conditional_stat_buffs)
	end

	local lerped_stat_buffs = template.lerped_stat_buffs

	if lerped_stat_buffs then
		local start_time = self._start_time
		local duration = template.duration
		local template_override_data = self._template_override_data
		local lerped_stat_buffs_overrides = template_override_data and template_override_data.lerped_stat_buffs

		lerped_stat_buffs = lerped_stat_buffs_overrides or lerped_stat_buffs

		local lerp_t = template.lerp_t_func and template.lerp_t_func(t, start_time, duration, self._template_data, self._template_context) or self._template_context.buff_lerp_value

		table.clear(self._lerped_stat_buffs)

		for key, data in pairs(lerped_stat_buffs) do
			local min = data.min
			local max = data.max
			local lerp_func = data.lerp_value_func or math.lerp
			local lerped_value = lerp_func(min, max, lerp_t)

			self._lerped_stat_buffs[key] = lerped_value
		end

		self:_calculate_stat_buffs(current_stat_buffs, self._lerped_stat_buffs)
	end

	local conditional_lerped_stat_buffs = template.conditional_lerped_stat_buffs

	if conditional_lerped_stat_buffs then
		local start_time = self._start_time
		local duration = template.duration
		local conditional_lerped_stat_buffs_func = template.conditional_lerped_stat_buffs_func

		if not conditional_lerped_stat_buffs_func or conditional_lerped_stat_buffs_func(self._template_data, self._template_context) then
			local template_override_data = self._template_override_data
			local lerped_stat_buffs_overrides = template_override_data and template_override_data.conditional_lerped_stat_buffs

			conditional_lerped_stat_buffs = lerped_stat_buffs_overrides or conditional_lerped_stat_buffs

			local lerp_t = template.lerp_t_func and template.lerp_t_func(t, start_time, duration, self._template_data, self._template_context) or self._template_context.buff_lerp_value

			table.clear(self._lerped_stat_buffs)

			for key, data in pairs(conditional_lerped_stat_buffs) do
				local min = data.min
				local max = data.max
				local lerp_func = data.lerp_value_func or math.lerp
				local lerped_value = lerp_func(min, max, lerp_t)

				self._lerped_stat_buffs[key] = lerped_value
			end

			self:_calculate_stat_buffs(current_stat_buffs, self._lerped_stat_buffs)
		end
	end
end

Buff.update_keywords = function (self, current_key_words, t)
	local template = self._template
	local num_constant_keywords = self._num_constant_keywords

	if num_constant_keywords then
		local keywords = template.keywords

		for i = 1, num_constant_keywords do
			current_key_words[keywords[i]] = true
		end
	end

	local num_conditional_keywords = self._num_conditional_keywords

	if num_conditional_keywords and self._conditional_keywords_func(self._template_data, self._template_context) then
		local keywords = template.conditional_keywords

		for i = 1, num_conditional_keywords do
			current_key_words[keywords[i]] = true
		end
	end

	return current_key_words
end

Buff.destroy = function (self, extension_destroyed)
	local template = self._template
	local stop_function = template.stop_func

	if stop_function then
		stop_function(self._template_data, self._template_context, extension_destroyed)
	end

	table.clear(self._template_data)
end

Buff.template_context = function (self)
	return self._template_context
end

Buff.template_data = function (self)
	return self._template_data
end

Buff.has_hud = function (self)
	local template = self._template
	local hide_in_hud = template.hide_icon_in_hud
	local has_icon = self:_hud_icon() ~= nil
	local has_hud = has_icon and not hide_in_hud

	return has_hud
end

local RETURN_TABLE = {}

Buff.get_hud_data = function (self)
	local return_table = RETURN_TABLE

	table.clear(return_table)

	return_table.show = self:_show_in_hud()
	return_table.is_active = self:_is_hud_active()
	return_table.hud_icon = self:_hud_icon()
	return_table.hud_icon_gradient_map = self:hud_icon_gradient_map()
	return_table.hud_priority = self:hud_priority()

	local stack_count = self:visual_stack_count()

	return_table.stack_count = stack_count
	return_table.show_stack_count = self:_hud_show_stack_count() or stack_count > 1
	return_table.is_negative = self:is_negative()
	return_table.force_negative_frame = self:_force_negative_frame()
	return_table.duration_progress = self:duration_progress()

	return return_table
end

Buff._show_in_hud = function (self)
	local visual_stack_count = self:visual_stack_count()

	if visual_stack_count == 0 then
		return false
	end

	local template = self._template
	local template_context = self._template_context
	local template_data = self._template_data
	local show_in_hud_if_slot_is_wielded = template.show_in_hud_if_slot_is_wielded

	if show_in_hud_if_slot_is_wielded and not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
		return false
	end

	local always_show_in_hud = template.always_show_in_hud

	if always_show_in_hud then
		return true
	end

	local show_in_hud = self:_is_hud_active()

	return show_in_hud
end

Buff._is_hud_active = function (self)
	local template = self._template
	local visual_stack_count = self:visual_stack_count()

	if visual_stack_count == 0 then
		return false
	end

	local always_active = template.always_active

	if always_active then
		return true
	end

	local conditional_func = template.conditional_stat_buffs_func or template.conditional_keywords_func

	if conditional_func and not conditional_func(self._template_data, self._template_context) then
		return false
	end

	local check_active_func = template.check_active_func

	if check_active_func and not check_active_func(self._template_data, self._template_context) then
		return false
	end

	return true
end

Buff._hud_show_stack_count = function (self)
	local template = self._template
	local max_stacks = self:max_stacks()
	local hud_always_show_stacks = template.hud_always_show_stacks
	local hud_always_never_stacks = template.hud_always_never_stacks
	local show_stack_count = not hud_always_never_stacks and max_stacks and max_stacks > 1 or hud_always_show_stacks

	return show_stack_count
end

Buff.hud_priority = function (self)
	local template = self._template

	return template.hud_priority or math.huge
end

Buff._hud_icon = function (self)
	local template = self._template
	local template_icon = template.hud_icon

	if template_icon then
		return template_icon
	end

	local template_override_data = self._template_override_data
	local item_icon = template_override_data.item_icon

	if item_icon then
		return item_icon
	end

	return nil
end

Buff._force_negative_frame = function (self)
	return false
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

Buff.hud_icon_gradient_map = function (self)
	local template = self._template

	return template.hud_icon_gradient_map
end

Buff.inactive = function (self)
	local template = self._template
	local conditional_stat_buffs_func = template.conditional_stat_buffs_func

	if conditional_stat_buffs_func and not conditional_stat_buffs_func(self._template_data, self._template_context) then
		return true
	end

	local check_active_func = template.check_active_func

	if check_active_func then
		return not check_active_func(self._template_data, self._template_context)
	end

	return false
end

Buff.is_negative = function (self)
	local template = self._template
	local is_negative = template.is_negative

	return not not is_negative
end

Buff.visual_stack_count = function (self)
	local template = self._template
	local use_talent_resource = template.use_talent_resource

	if use_talent_resource then
		local resource = self._talent_resource_component.current_resource

		return resource
	end

	if template.visual_stack_count then
		return template.visual_stack_count(self._template_data, self._template_context)
	end

	return self:stat_buff_stacking_count()
end

return Buff
