extends CenterContainer

var spades = preload("res://assets/icons/spades.png")
var clubs = preload("res://assets/icons/clubs.png")
var diamonds = preload("res://assets/icons/diamonds.png")
var hearts = preload("res://assets/icons/hearts.png")

var suit_textures = {
	"DIAMONDS": diamonds,
	"HEARTS": hearts,
	"SPADES": spades,
	"CLUBS": clubs,
}

func _ready():
	game_state.connect("trump_suit_changed", self, "on_trump_suit_changed")
	on_trump_suit_changed()

func on_trump_suit_changed():
	var trump_suit = game_state.in_game_state["trumpSuit"]
	if trump_suit == null:
		hide()
	else:
		show()
		$Control/Trump.texture = suit_textures[trump_suit]
