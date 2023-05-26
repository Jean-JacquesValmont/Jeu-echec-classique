extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_node("King_white").player_turn == "black":
		position.y = -75
		text = "Au tour du joueur noir"
		modulate = Color(1, 0, 0) # red
	elif get_parent().get_node("King_white").player_turn == "white":
		position.y = 825
		text = "Au tour du joueur blanc"
		modulate = Color(1, 0, 0) # red
