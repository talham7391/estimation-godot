extends Control

var Card = preload("res://scenes/Card.tscn")

var offset = 0.0

var current_cards_in_hand = []

var CARDS_GROUP = "cards_group"

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state.connect("my_cards_changed", self, "on_my_cards_changed")
	on_my_cards_changed()

func on_my_cards_changed():
	var cards = game_state.in_game_state["myCards"]
	insure_cards_in_hand(cards)

func _process(delta):
	var start = (current_cards_in_hand.size() - 1) / 2.0 * -1.0
	var first = start
	var last = first + current_cards_in_hand.size() - 1.0
	var middle = (first + last) / 2.0
	if start + offset > middle:
		offset = middle - start
	if last + offset < middle:
		offset = middle - last
	for i in range(current_cards_in_hand.size()):
		var instance = current_cards_in_hand[i]["instance"]
		var card_pos = float(start + i) + offset
		instance.set_position(transform_pos(instance, card_pos))

func _input(event):
	if event is InputEventScreenDrag:
		offset += event.relative.x / 65.0

func transform_pos(instance, input):
	var with_spacing = input * 45.0
	return Vector2(instance.get_pivot_offset().x * -1 + with_spacing, instance.get_pivot_offset().y * -1)

func insure_cards_in_hand(cards):
	purge_cards(cards)
	cards.sort_custom(self, "card_sort_func")
	for card in cards:
		if is_card_in_hand(card):
			continue
		var card_instance = Card.instance()
		card_instance.set_card(card["suit"], card["rank"])
		current_cards_in_hand.append({
			"data": card,
			"instance": card_instance,
		})
		var scale = 0.45
		card_instance.set_scale(Vector2(scale, scale))
		card_instance.add_to_group(CARDS_GROUP)
		add_child(card_instance)
		card_instance.connect("card_pressed", self, "on_card_pressed", [card])

func purge_cards(cards):
	for c in current_cards_in_hand:
		c["instance"].call_deferred("free")
	current_cards_in_hand = []

func is_card_in_hand(card):
	for c in current_cards_in_hand:
		if c["data"] == card:
			return true
	return false

func card_sort_func(c1, c2):
	var suit_values = {
		"SPADES": 0,
		"HEARTS": 1,
		"CLUBS": 2,
		"DIAMONDS": 3,
	}
	var rank_values = {
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
	var c1_val = 13 * suit_values[c1["suit"]] + rank_values[c1["rank"]]
	var c2_val = 13 * suit_values[c2["suit"]] + rank_values[c2["rank"]]
	return c1_val < c2_val

func on_card_pressed(card):
	game_state.emit_signal("play_card", card["suit"], card["rank"])