local Promise = require("scripts/foundation/utilities/promise")
local ContractsService = class("ContractsService")

ContractsService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

ContractsService.reroll_task = function (self, character_id, task_id, last_transaction_id, reroll_cost)
	return self._backend_interface.contracts:reroll_task(character_id, task_id, last_transaction_id):next(function (result)
		return Managers.data_service.store:on_contract_task_rerolled(reroll_cost):next(function ()
			return result
		end)
	end):catch(function (err)
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

ContractsService.complete_contract = function (self, character_id)
	return self._backend_interface.contracts:complete_contract(character_id):next(function (result)
		return Managers.data_service.store:on_contract_completed(result):next(function ()
			return result
		end)
	end):catch(function (err)
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

ContractsService.has_contract = function (self, character_id)
	return self._backend_interface.contracts:get_current_contract(character_id, nil, false):next(function ()
		return true
	end, function (error)
		return false
	end)
end

ContractsService.get_contract = function (self, character_id, create_contract)
	return self._backend_interface.contracts:get_current_contract(character_id, nil, create_contract)
end

return ContractsService
