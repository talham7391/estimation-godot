extends Node

func put_me_first(turn_order):
	if not turn_order:
		return turn_order
	var shifted_order = turn_order.duplicate()
	for i in range(4):
		if shifted_order[0]["connectionId"] == game_state.connection_id:
			break
		else:
			shifted_order.push_back(shifted_order.pop_front())
	return shifted_order