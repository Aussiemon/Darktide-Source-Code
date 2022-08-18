local SessionStats = require("scripts/managers/stats/groups/session_stats")
local local_tasks = {}

local function _create_checker(end_at, indices)
	return function (specifiers, ...)
		for i = 1, end_at do
			local backend_name = indices[i]
			local specifier = specifiers[backend_name]

			if specifier and select(i, ...) ~= specifier then
				return false
			end
		end

		return true
	end
end

local function _create_task(task_name, stat, specifiers)
	local end_at = 0
	local indices = {}
	specifiers = specifiers or {}

	for backend_name, stat_name in pairs(specifiers) do
		local index = table.index_of(stat:get_parameters(), stat_name)

		fassert(index > 0, "Stat '%s' has no parameter '%s'.", stat:get_id(), stat_name)

		indices[index] = backend_name
		end_at = math.max(end_at, index)
	end

	local task_data = {
		stat_id = stat:get_id(),
		checker = _create_checker(end_at, indices)
	}
	local_tasks[task_name] = task_data
end

_create_task("KillBosses", SessionStats.definitions.kill_boss)
_create_task("BlockDamage", SessionStats.definitions.blocked_damage)
_create_task("KillMinions", SessionStats.definitions.kill_minion, {
	enemyType = "name",
	weaponType = "type"
})
_create_task("CollectResource", SessionStats.definitions.collect_resource, {
	resourceType = "type"
})

return settings("LocalContractTasks", local_tasks)
