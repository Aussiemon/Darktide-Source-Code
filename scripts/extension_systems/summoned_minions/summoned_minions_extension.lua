-- chunkname: @scripts/extension_systems/summoned_minions/summoned_minions_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local Vo = require("scripts/utilities/vo")
local SummonedMinionsExtension = class("SummonedMinionsExtension")

SummonedMinionsExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local breed = extension_init_data.breed
	local summon_template = breed.summon_minions_template

	self._template = summon_template
	self._summoned_minions = {}
	self._amount = 0
	self._index = 0
	self._unit = unit

	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)

	local event_manager = Managers.event

	event_manager:register(self, "player_unit_stealth_entered", "_wwise_on_player_stealth")
end

SummonedMinionsExtension.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "player_unit_stealth_entered")
end

SummonedMinionsExtension._init_blackboard_components = function (self, blackboard)
	self._summon_component = Blackboard.write_component(blackboard, "summon")
end

SummonedMinionsExtension.game_object_initialized = function (self, session, object_id)
	self._game_session, self._game_object_id = session, object_id
end

SummonedMinionsExtension.add_new_summoned_unit = function (self, unit)
	self._index = self._index + 1

	local unit_to_add = unit
	local summoned_minions = self._summoned_minions

	table.insert(summoned_minions, unit_to_add)

	local want_owner = self._template.requires_owner

	if want_owner then
		local blackboard = BLACKBOARDS[unit]
		local summon_component = Blackboard.write_component(blackboard, "summon_unit")
		local owner = self._unit

		summon_component.owner = owner
	end
end

SummonedMinionsExtension.update = function (self, context, dt, t)
	self:_evaluate_summmoned_minions()
end

SummonedMinionsExtension._evaluate_summmoned_minions = function (self)
	local summon_minions = self._summoned_minions
	local amount = 0

	for i, unit in pairs(summon_minions) do
		if HEALTH_ALIVE[unit] then
			amount = amount + 1
		else
			local position = POSITION_LOOKUP[unit]

			self:_on_death(position)
			table.remove(summon_minions, i)
		end
	end

	self._summon_component.amount = amount
	self._amount = amount
end

SummonedMinionsExtension._on_death = function (self)
	local template = self._template
	local vo_event = template.vo_event_death

	if vo_event then
		local breed = Breed.unit_breed_or_nil(self._unit)

		if breed then
			local breed_name = breed.name

			Vo.enemy_generic_vo_event(self._unit, vo_event, breed_name)
		end
	end

	local wwise_events = template.wwise_on_death_events

	if not wwise_events then
		return
	end

	local probability = template.wwise_event_probability
	local chance = math.random()

	if probability < chance then
		local unit = self._unit
		local position = POSITION_LOOKUP[unit]
		local random_event = wwise_events[math.random(1, #wwise_events)]
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(random_event, position)
	end
end

SummonedMinionsExtension.wwise_on_minion_success = function (self)
	local template = self._template
	local wwise_events = template.wwise_on_success_events

	if not wwise_events then
		return
	end

	local probability = template.wwise_event_probability
	local chance = math.random()

	if probability < chance then
		local unit = self._unit
		local position = POSITION_LOOKUP[unit]
		local random_event = wwise_events[math.random(1, #wwise_events)]
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(random_event, position)
	end
end

SummonedMinionsExtension._wwise_on_player_stealth = function (self)
	local template = self._template
	local wwise_events = template.wwise_on_success_events

	if not wwise_events then
		return
	end

	local probability = template.wwise_event_probability
	local chance = math.random()

	if probability < chance then
		local unit = self._unit
		local position = POSITION_LOOKUP[unit]
		local random_event = wwise_events[math.random(1, #wwise_events)]
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(random_event, position)
	end
end

SummonedMinionsExtension.can_summon_minions = function (self, action_data, is_running)
	local t = Managers.time:time("gameplay")
	local amount = self._amount

	if is_running then
		return true
	end

	if amount == 0 then
		if not self._timer then
			if not self._initial_delay and self._template.initial_delay then
				self._initial_delay = true
				self._timer = t + self._template.initial_delay

				return false
			else
				local interval_til_next_summon = self._template.interval_til_next_summon

				self._timer = t + math.random(interval_til_next_summon[1], interval_til_next_summon[2])

				return false
			end
		elseif t > self._timer then
			self._timer = nil

			return true
		end
	end

	return false
end

return SummonedMinionsExtension
