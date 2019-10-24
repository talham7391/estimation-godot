extends CenterContainer

var Card = preload("res://scenes/Card.tscn")

onready var bottom = $Control/Bottom
onready var left = $Control/Left
onready var top = $Control/Top
onready var right = $Control/Right

onready var spots_clockwise = [
	bottom,
	left,
	top,
	right,
]

func _ready():
	game_state.connect("current_trick_changed", self, "on_current_trick_changed")
	on_current_trick_changed()

func on_current_trick_changed():
	var current_trick = game_state.in_game_state["currentTrick"]
	var previous_trick = game_state.in_game_state["previousTrick"]
	
	if current_trick.size() == 0:
		if previous_trick != null and previous_trick.size() > 0:
			# get the order of the cards
			var cards_ordered = get_cards_from_me(previous_trick)
			
			# no cards from the previous trick are on the table right now
			# indicates that a player connected at the start of a trick so we don't animate
			if count_cards_on_table(cards_ordered) == 0:
				return
			
			# insure all cards that are meant to be here are here, if not animate them in but marked for delete
			insure_cards_present(cards_ordered, "animate_in")
			for i in range(cards_ordered.size()):
				var card = cards_ordered[i]
				var spot = spots_clockwise[i]
				for child in spot.get_children():
					if child.suit == card["suit"] and child.rank == card["rank"]:
						child.mark_deleted = true
			
			yield(get_tree().create_timer(1.35), "timeout")
			
			# figure out the winning card
			var direction = winning_card_direction(cards_ordered)
			var dist = 50
			var x = 0
			var y = 0
			if direction == 0:
				y = dist
			if direction == 1:
				x = dist * -1
			if direction == 2:
				y = dist * -1
			if direction == 3:
				x = dist
			
			# animate the cards in the winning cards direction and have them delete themselves
			for spot in spots_clockwise:
				for child in spot.get_children():
					if child.mark_deleted:
						child.fade_out(Vector2(x, y), 0.2, true)
		else:
			# insure there are no cards on the table
			for spot in spots_clockwise:
				for child in spot.get_children():
					child.call_deferred("free")
	else:
		# we must animate the card that was just played.
		# if a player is reconnecting, we must also include cards that don't exist
		
		# build where the cards should be starting from me
		var cards_ordered = get_cards_from_me(current_trick)
		insure_cards_present(cards_ordered, "animate_in")

func get_cards_from_me(trick):
	var turn_order = game_state.in_game_state["turnOrder"]
	var shifted_order = utils.put_me_first(turn_order)
	
	var cards_ordered = []
	for player in shifted_order:
		var card_found = false
		for ct in trick:
			if ct["player"]["connectionId"] == player["connectionId"]:
				card_found = true
				cards_ordered.append(ct["card"])
				break
		if not card_found:
			cards_ordered.append(null)
	return cards_ordered

func insure_cards_present(cards_ordered, card_missing_callback):
	for i in range(cards_ordered.size()):
		var card = cards_ordered[i]
		var spot = spots_clockwise[i]
		
		var card_found = false
		for child in spot.get_children():
			if card != null and card["suit"] == child.suit and card["rank"] == child.rank:
				card_found = true
			elif not child.mark_deleted:
				child.call_deferred("free")
		if card_found:
			continue
			
		if card != null:
			call(card_missing_callback, card, i)

func animate_in(card, i):
	var c = Card.instance()
	var scale = 0.25
	c.modulate = Color(1,1,1,0)
	c.set_scale(Vector2(scale, scale))
	c.set_card(card["suit"], card["rank"])
	spots_clockwise[i].add_child(c)
	var dist = 50
	var x = 0
	var y = 0
	if i == 0:
		y = dist
	if i == 1:
		x = dist * -1
	if i == 2:
		y = dist * -1
	if i == 3:
		x = dist
	c.fade_in(Vector2(x, y), 0.2)

func winning_card_direction(cards_ordered):
	var winning_card = utils.get_winning_card(cards_ordered)
	for i in range(cards_ordered.size()):
		var card = cards_ordered[i]
		if winning_card["suit"] == card["suit"] and winning_card["rank"] == card["rank"]:
			return i
	return -1

func count_cards_on_table(cards_ordered):
	var count = 0
	for i in range(cards_ordered.size()):
		var card = cards_ordered[i]
		var spot = spots_clockwise[i]
		for child in spot.get_children():
			if child.suit == card["suit"] and child.rank == card["rank"]:
				count += 1
				break
	return count
