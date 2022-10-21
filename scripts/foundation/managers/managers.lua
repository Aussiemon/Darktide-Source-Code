Managers = Managers or {
	state = {}
}
ManagersCreationOrder = ManagersCreationOrder or {
	global = {},
	state = {}
}

local function destroy_global_managers()
	table.reverse(ManagersCreationOrder.global)

	for index, alias in ipairs(ManagersCreationOrder.global) do
		local manager = Managers[alias]

		if manager then
			manager:delete()
		end

		Managers[alias] = nil
		ManagersCreationOrder.global[index] = nil
	end
end

local function destroy_state_managers()
	table.reverse(ManagersCreationOrder.state)

	for index, alias in ipairs(ManagersCreationOrder.state) do
		local manager = Managers.state[alias]

		manager:delete()

		Managers.state[alias] = nil
		ManagersCreationOrder.state[index] = nil
	end
end

Managers.destroy = function (self)
	destroy_state_managers()
	destroy_global_managers()
end

Managers.state.destroy = function (self)
	destroy_state_managers()
end

local mt_global = {
	__newindex = function (managers, alias, manager)
		rawset(ManagersCreationOrder.global, #ManagersCreationOrder.global + 1, alias)
		rawset(managers, alias, manager)
	end,
	__tostring = function (managers)
		local s = "\n"

		for alias, manager in pairs(managers) do
			if type(manager) == "table" and alias ~= "state" then
				s = s .. "\t" .. alias .. "\n"
			end
		end

		return s
	end
}
local mt_state = {
	__newindex = function (managers, alias, manager)
		rawset(ManagersCreationOrder.state, #ManagersCreationOrder.state + 1, alias)
		rawset(managers, alias, manager)
	end,
	__tostring = function (managers)
		local s = "\n"

		for alias, manager in pairs(managers) do
			if type(manager) == "table" then
				s = s .. "\t" .. alias .. "\n"
			end
		end

		return s
	end
}

setmetatable(Managers, mt_global)
setmetatable(Managers.state, mt_state)
