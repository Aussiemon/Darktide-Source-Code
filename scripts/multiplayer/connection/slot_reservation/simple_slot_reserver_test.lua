local function tests(SimpleSlotReserver)
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)
	local _, total = reserver:allocation_state()
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)
	local allocations, _ = reserver:allocation_state()
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local allocations, _ = reserver:allocation_state()
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1")
	reserver:reserve_slot("2", "2")
	reserver:reserve_slot("3", "3")

	local allocations, _ = reserver:allocation_state()
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	reserver = SimpleSlotReserver:new(slots)
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1")
	reserver:reserve_slot("2", "2")
	reserver:reserve_slot("3", "3")

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	local allocations, _ = reserver:allocation_state()
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2"
	})
	reserver:free_slots({
		"1",
		"2"
	})

	local allocations, _ = reserver:allocation_state()
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2"
	})
	reserver:free_slot("2", 2)

	local allocations, _ = reserver:allocation_state()
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:free_slots({
		"2",
		"3"
	})

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:free_slot("2", 2)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:free_slot("1", 1)

	local allocations, _ = reserver:allocation_state()
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)

	local allocations, _ = reserver:allocation_state()
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1")

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)
	reserver:claim_slot("2", 2)
	reserver:claim_slot("3", 3)
	reserver:free_slots({
		"1",
		"2"
	})

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)
	reserver:claim_slot("2", 2)
	reserver:claim_slot("3", 3)
	reserver:free_slot("1", 1)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	local claimed, reserved = reserver:claim_slot("1", 1)
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1", 1)

	local claimed, reserved = reserver:claim_slot("1", 1)
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	local claimed, reserved = reserver:claim_slot("1", 2)
	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local claimed, reserved = reserver:claim_slot("4", 4)
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:reserve_slots("4", {
		"4"
	})
	reserver:free_slot("1", 1)

	local allocations, _ = reserver:allocation_state()
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2"
	})
	reserver:reserve_slots("1", {
		"3"
	})
	reserver:reserve_slots("4", {
		"4"
	})
	reserver:free_slot("1", 1)

	local allocations, _ = reserver:allocation_state()
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:reserve_slots("4", {
		"4"
	})
	reserver:claim_slot("2", 2)
	reserver:free_slot("1", 1)

	local allocations, _ = reserver:allocation_state()
end

return tests
