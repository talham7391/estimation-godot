extends Node

var RANK_MAP = {
	"TWO": 0,
	"THREE": 1,
	"FOUR": 2,
	"FIVE": 3,
	"SIX": 4,
	"SEVEN": 5,
	"EIGHT": 6,
	"NINE": 7,
	"TEN": 8,
	"JACK": 9,
	"QUEEN": 10, 
	"KING": 11,
	"ACE": 12,
}

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

func get_winning_card(cards):
	var trumpSuit = game_state.in_game_state["trumpSuit"]
	var leadingSuit = cards[0]["suit"]
	
	var highest_trump = get_highest_card_of_suit(cards, trumpSuit)
	if highest_trump != null:
		return highest_trump
	return get_highest_card_of_suit(cards, leadingSuit)

func get_highest_card_of_suit(cards, suit):
	var cards_of_suit = get_cards_of_suit(cards, suit)
	var highest = null
	for card in cards_of_suit:
		if highest == null or RANK_MAP[card["rank"]] > RANK_MAP[highest["rank"]]:
			highest = card
	return highest

func get_cards_of_suit(cards, suit):
	var filtered_cards = []
	for card in cards:
		if card["suit"] == suit:
			filtered_cards.append(card)
	return filtered_cards
