extends Sprite2D

signal opponent_turned
signal promotion

var position_piece_on_the_chessboard = \
	[["x","x","x","x","x","x","x","x","x","x","x","x"],
	["x","x","x","x","x","x","x","x","x","x","x","x"],
	["x","x","rook_black","knight_black","bishop_black","queen_black","king_black","bishop_black","knight_black","rook_black","x","x"],
	["x","x","pawn_black","pawn_black","pawn_black","pawn_black","pawn_black","pawn_black","pawn_black","pawn_black","x","x"],
	["x","x","0","0","0","0","0","0","0","0","x","x"],
	["x","x","0","0","0","0","0","0","0","0","x","x"],
	["x","x","0","0","0","0","0","0","0","0","x","x"],
	["x","x","0","0","0","0","0","0","0","0","x","x"],
	["x","x","pawn_white","pawn_white","pawn_white","pawn_white","pawn_white","pawn_white","pawn_white","pawn_white","x","x"],
	["x","x","rook_white","knight_white","bishop_white","queen_white","king_white","bishop_white","knight_white","rook_white","x","x"],
	["x","x","x","x","x","x","x","x","x","x","x","x"],
	["x","x","x","x","x","x","x","x","x","x","x","x"]]

var player_turn = "white"
var piece_select = "No piece selected"
var starting_square = true
var taken_by_the_way = true #Pour savoir si la prise en passant peut être faite
var piece_promoted = false #Pour savoir si la promotion à été fait
var my_node_id = get_node(".").get_instance_id()
@onready var my_node_name = get_node(".").get_name() #Permet de récupérer le nom du noeud
@onready var Sound_piece_move = get_node("Sound_piece_move")
var i = 3
var j = 2
var move_one_square = 100
var king_in_check = false
var can_protect_the_king = false
var piece_protects_against_an_attack = false
var attacker_position_shift_i = 0
var attacker_position_shift_j = 0
var attacker_position_shift2_i = 0
var attacker_position_shift2_j = 0
var direction_of_attack = ""
var direction_attack_protect_king = ""

var knight_promotion_sprite
var bishop_promotion_sprite
var rook_promotion_sprite
var queen_promotion_sprite
var display_promotion = false

var update_of_the_protect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ID de ", my_node_name, ": ", my_node_id)
	if my_node_name == "Pawn_black":
		i = 3
		j = 2
	elif my_node_name == "Pawn_black2":
		i = 3
		j = 3
	elif my_node_name == "Pawn_black3":
		i = 3
		j = 4
	elif my_node_name == "Pawn_black4":
		i = 3
		j = 5
	elif my_node_name == "Pawn_black5":
		i = 3
		j = 6
	elif my_node_name == "Pawn_black6":
		i = 3
		j = 7
	elif my_node_name == "Pawn_black7":
		i = 3
		j = 8
	elif my_node_name == "Pawn_black8":
		i = 3
		j = 9
		
	print("i: ", i)
	print("j: ", j)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_turn == "black" and update_of_the_protect == false:
		verif_piece_protects_against_an_attack_the_king()
		update_of_the_protect = true
		
		if taken_by_the_way == true:
			taken_by_the_way = false
		
	elif player_turn == "white":
		update_of_the_protect = false
	
	#Promotion
	if i == 9 and piece_promoted == false:
		piece_select = "Promotion"
		
		if piece_select == "Promotion" and display_promotion == false:
			knight_promotion_sprite = Sprite2D.new()
			knight_promotion_sprite.texture = load("res://Image/Pièces/Black/Knight_black.png")
			knight_promotion_sprite.centered = false
			knight_promotion_sprite.position.x = 0
			knight_promotion_sprite.position.y = 300
			knight_promotion_sprite.scale.x = 2
			knight_promotion_sprite.scale.y = 2
			get_parent().add_child(knight_promotion_sprite)
			
			bishop_promotion_sprite = Sprite2D.new()
			bishop_promotion_sprite.texture = load("res://Image/Pièces/Black/Bishop_black.png")
			bishop_promotion_sprite.centered = false
			bishop_promotion_sprite.position.x = 200
			bishop_promotion_sprite.position.y = 300
			bishop_promotion_sprite.scale.x = 2
			bishop_promotion_sprite.scale.y = 2
			get_parent().add_child(bishop_promotion_sprite)
			
			rook_promotion_sprite = Sprite2D.new()
			rook_promotion_sprite.texture = load("res://Image/Pièces/Black/Rook_black.png")
			rook_promotion_sprite.centered = false
			rook_promotion_sprite.position.x = 400
			rook_promotion_sprite.position.y = 300
			rook_promotion_sprite.scale.x = 2
			rook_promotion_sprite.scale.y = 2
			get_parent().add_child(rook_promotion_sprite)
			
			queen_promotion_sprite = Sprite2D.new()
			queen_promotion_sprite.texture = load("res://Image/Pièces/Black/Queen_black.png")
			queen_promotion_sprite.centered = false
			queen_promotion_sprite.position.x = 600
			queen_promotion_sprite.position.y = 300
			queen_promotion_sprite.scale.x = 2
			queen_promotion_sprite.scale.y = 2
			get_parent().add_child(queen_promotion_sprite)
			
			if get_parent().get_node("Pawn_white") != null:
				get_parent().get_node("Pawn_white").player_turn = ""
			if get_parent().get_node("Pawn_white2") != null:
				get_parent().get_node("Pawn_white2").player_turn = ""
			if get_parent().get_node("Pawn_white3") != null:
				get_parent().get_node("Pawn_white3").player_turn = ""
			if get_parent().get_node("Pawn_white4") != null:
				get_parent().get_node("Pawn_white4").player_turn = ""
			if get_parent().get_node("Pawn_white5") != null:
				get_parent().get_node("Pawn_white5").player_turn = ""
			if get_parent().get_node("Pawn_white6") != null:
				get_parent().get_node("Pawn_white6").player_turn = ""
			if get_parent().get_node("Pawn_white7") != null:
				get_parent().get_node("Pawn_white7").player_turn = ""
			if get_parent().get_node("Pawn_white8") != null:
				get_parent().get_node("Pawn_white8").player_turn = ""
			if get_parent().get_node("Knight_white") != null:
				get_parent().get_node("Knight_white").player_turn = ""
			if get_parent().get_node("Knight_white2") != null:
				get_parent().get_node("Knight_white2").player_turn = ""
			if get_parent().get_node("Bishop_white") != null:
				get_parent().get_node("Bishop_white").player_turn = ""
			if get_parent().get_node("Bishop_white2") != null:
				get_parent().get_node("Bishop_white2").player_turn = ""
			if get_parent().get_node("Rook_white") != null:
				get_parent().get_node("Rook_white").player_turn = ""
			if get_parent().get_node("Rook_white2") != null:
				get_parent().get_node("Rook_white2").player_turn = ""
			if get_parent().get_node("Queen_white") != null:
				get_parent().get_node("Queen_white").player_turn = ""
			if get_parent().get_node("King_white") != null:
				get_parent().get_node("King_white").player_turn = ""
			
			if get_parent().get_node("Pawn_black") != null:
				get_parent().get_node("Pawn_black").player_turn = ""
			if get_parent().get_node("Pawn_black2") != null:
				get_parent().get_node("Pawn_black2").player_turn = ""
			if get_parent().get_node("Pawn_black3") != null:
				get_parent().get_node("Pawn_black3").player_turn = ""
			if get_parent().get_node("Pawn_black4") != null:
				get_parent().get_node("Pawn_black4").player_turn = ""
			if get_parent().get_node("Pawn_black5") != null:
				get_parent().get_node("Pawn_black5").player_turn = ""
			if get_parent().get_node("Pawn_black6") != null:
				get_parent().get_node("Pawn_black6").player_turn = ""
			if get_parent().get_node("Pawn_black7") != null:
				get_parent().get_node("Pawn_black7").player_turn = ""
			if get_parent().get_node("Pawn_black8") != null:
				get_parent().get_node("Pawn_black8").player_turn = ""
			if get_parent().get_node("Knight_black") != null:
				get_parent().get_node("Knight_black").player_turn = ""
			if get_parent().get_node("Knight_black2") != null:
				get_parent().get_node("Knight_black2").player_turn = ""
			if get_parent().get_node("Bishop_black") != null:
				get_parent().get_node("Bishop_black").player_turn = ""
			if get_parent().get_node("Bishop_black2") != null:
				get_parent().get_node("Bishop_black2").player_turn = ""
			if get_parent().get_node("Rook_black") != null:
				get_parent().get_node("Rook_black").player_turn = ""
			if get_parent().get_node("Rook_black2") != null:
				get_parent().get_node("Rook_black2").player_turn = ""
			if get_parent().get_node("Queen_black") != null:
				get_parent().get_node("Queen_black").player_turn = ""
			if get_parent().get_node("King_black") != null:
				get_parent().get_node("King_black").player_turn = ""
			
			display_promotion = true

func _input(event):
	var mouse_pos = get_local_mouse_position()
	
	#Pour cliquer sur la promotion que l'on veut sélectionner(Knight-Bishop-Rook-Queen)
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "Promotion":
		
		if mouse_pos.x >= 0 - position.x  and mouse_pos.x <= 200 - position.x \
		and mouse_pos.y >= 300 - position.y and mouse_pos.y <= 500 - position.y:
			texture = load("res://Image/Pièces/Black/Knight_black.png")
			position_piece_on_the_chessboard[i][j] = "knight_black"
			knight_promotion_sprite.queue_free()
			bishop_promotion_sprite.queue_free()
			rook_promotion_sprite.queue_free()
			queen_promotion_sprite.queue_free()
			piece_promoted = true
			emit_signal("promotion", i, j, position_piece_on_the_chessboard[i][j],position_piece_on_the_chessboard)
			
		elif mouse_pos.x >= 200 - position.x  and mouse_pos.x <= 400 - position.x \
		and mouse_pos.y >= 300 - position.y and mouse_pos.y <= 500 - position.y:
			texture = load("res://Image/Pièces/Black/Bishop_black.png")
			position_piece_on_the_chessboard[i][j] = "bishop_black"
			knight_promotion_sprite.queue_free()
			bishop_promotion_sprite.queue_free()
			rook_promotion_sprite.queue_free()
			queen_promotion_sprite.queue_free()
			piece_promoted = true
			emit_signal("promotion", i, j,position_piece_on_the_chessboard[i][j],position_piece_on_the_chessboard)
			
		elif mouse_pos.x >= 400 - position.x  and mouse_pos.x <= 600 - position.x \
		and mouse_pos.y >= 300 - position.y and mouse_pos.y <= 500 - position.y:
			texture = load("res://Image/Pièces/Black/Rook_black.png")
			position_piece_on_the_chessboard[i][j] = "rook_black"
			knight_promotion_sprite.queue_free()
			bishop_promotion_sprite.queue_free()
			rook_promotion_sprite.queue_free()
			queen_promotion_sprite.queue_free()
			piece_promoted = true
			emit_signal("promotion", i, j,position_piece_on_the_chessboard[i][j],position_piece_on_the_chessboard)
			
		elif mouse_pos.x >= 600 - position.x  and mouse_pos.x <= 800 - position.x \
		and mouse_pos.y >= 300 - position.y and mouse_pos.y <= 500 - position.y:
			texture = load("res://Image/Pièces/Black/Queen_black.png")
			position_piece_on_the_chessboard[i][j] = "queen_black"
			knight_promotion_sprite.queue_free()
			bishop_promotion_sprite.queue_free()
			rook_promotion_sprite.queue_free()
			queen_promotion_sprite.queue_free()
			piece_promoted = true
			emit_signal("promotion", i, j,position_piece_on_the_chessboard[i][j],position_piece_on_the_chessboard)
	
	if king_in_check == false:
	# Ne peut bouger d'une case après avoir bouger de sa case de départ
		if starting_square == false and player_turn == "black":
			# Pour sélectionner la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
					print(starting_square)
					
				
			elif event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == my_node_name:
				
				if piece_protects_against_an_attack == false:
					if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and position_piece_on_the_chessboard[i+1][j] == "0":
						move_local_y(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j+1] == "knight_white"\
					or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j+1] == "rook_white"\
					or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
						move_local_y(move_one_square)
						move_local_x(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j += 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j-1] == "knight_white"\
					or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j-1] == "rook_white"\
					or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
						move_local_x(-move_one_square)
						move_local_y(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j -= 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					#Pour la prise en passant à droite
					elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and position_piece_on_the_chessboard[i+1][j+1] == "0" and position_piece_on_the_chessboard[i][j+1] == "pawn_white"\
					and i == 6 and (get_parent().get_node("Pawn_white").taken_by_the_way == true or get_parent().get_node("Pawn_white2").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white3").taken_by_the_way == true or get_parent().get_node("Pawn_white4").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white5").taken_by_the_way == true or get_parent().get_node("Pawn_white6").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white7").taken_by_the_way == true or get_parent().get_node("Pawn_white8").taken_by_the_way == true):
						
						move_local_y(move_one_square)
						move_local_x(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j += 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						if get_parent().get_node("Pawn_white") != null:
							if get_parent().get_node("Pawn_white").i == i-1 and get_parent().get_node("Pawn_white").j == j:
								get_parent().get_node("Pawn_white").queue_free()
						for f in range(2,9):
							if get_parent().get_node("Pawn_white" + str(f)) != null:
								if get_parent().get_node("Pawn_white" + str(f)).i == i-1 and get_parent().get_node("Pawn_white" + str(f)).j == j:
									get_parent().get_node("Pawn_white" + str(f)).queue_free()
							
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
					#Pour la prise en passant à gauche
					elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and position_piece_on_the_chessboard[i+1][j-1] == "0" and position_piece_on_the_chessboard[i][j-1] == "pawn_white"\
					and i == 6 and (get_parent().get_node("Pawn_white").taken_by_the_way == true or get_parent().get_node("Pawn_white2").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white3").taken_by_the_way == true or get_parent().get_node("Pawn_white4").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white5").taken_by_the_way == true or get_parent().get_node("Pawn_white6").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white7").taken_by_the_way == true or get_parent().get_node("Pawn_white8").taken_by_the_way == true):
						
						move_local_y(+move_one_square)
						move_local_x(-move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j -= 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						if get_parent().get_node("Pawn_white") != null:
							if get_parent().get_node("Pawn_white").i == i-1 and get_parent().get_node("Pawn_white").j == j:
								get_parent().get_node("Pawn_white").queue_free()
						for f in range(2,9):
							if get_parent().get_node("Pawn_white" + str(f)) != null:
								if get_parent().get_node("Pawn_white" + str(f)).i == i-1 and get_parent().get_node("Pawn_white" + str(f)).j == j:
									get_parent().get_node("Pawn_white" + str(f)).queue_free()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					else:
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
					
				elif piece_protects_against_an_attack == true:
					if direction_attack_protect_king == "Haut" or direction_attack_protect_king == "Bas":
						if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
						and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
						and position_piece_on_the_chessboard[i+1][j] == "0":
							move_local_y(move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 1
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
						else:
							piece_select = "No piece selected"
							print(piece_select)
							print(starting_square)
						
					elif direction_attack_protect_king == "Droite" or direction_attack_protect_king == "Gauche":
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
						
					elif direction_attack_protect_king == "Haut/Droite" or direction_attack_protect_king == "Haut/Gauche":
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
						
					elif direction_attack_protect_king == "Bas/Droite":
						if mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
						and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
						and (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j+1] == "knight_white"\
						or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j+1] == "rook_white"\
						or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
							move_local_y(move_one_square)
							move_local_x(move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 1
							j += 1
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							if i != 9:
								emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
						else:
							piece_select = "No piece selected"
							print(piece_select)
							print(starting_square)
						
					elif direction_attack_protect_king == "Bas/Gauche":
						if mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
						and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
						and (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j-1] == "knight_white"\
						or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j-1] == "rook_white"\
						or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
							move_local_x(-move_one_square)
							move_local_y(move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 1
							j -= 1
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							if i != 9:
								emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
						else:
							piece_select = "No piece selected"
							print(piece_select)
							print(starting_square)
				
		# Peut bouger d'une case ou de deux cases à sa case de départ
		elif starting_square == true and player_turn == "black":
			# Pour sélectionner la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
					print(starting_square)
					
				
			elif event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == my_node_name:
				
				if piece_protects_against_an_attack == false:
					if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and position_piece_on_the_chessboard[i+1][j] == "0":
						move_local_y(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						starting_square = false
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					elif mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
					and mouse_pos.y >= 0 + 2*move_one_square and mouse_pos.y <= texture.get_height() + 2*move_one_square \
					and position_piece_on_the_chessboard[i+2][j] == "0":
						move_local_y(2*move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 2
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						starting_square = false
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
						taken_by_the_way = true
						
					elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j+1] == "knight_white"\
					or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j+1] == "rook_white"\
					or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
						move_local_y(move_one_square)
						move_local_x(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j += 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						starting_square = false
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j-1] == "knight_white"\
					or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j-1] == "rook_white"\
					or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
						move_local_y(move_one_square)
						move_local_x(-move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j -= 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						starting_square = false
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					else:
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
					
				elif piece_protects_against_an_attack == true:
					if direction_attack_protect_king == "Haut" or direction_attack_protect_king == "Bas":
						if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
						and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
						and position_piece_on_the_chessboard[i+1][j] == "0":
							move_local_y(move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 1
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							starting_square = false
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
							
						elif mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
						and mouse_pos.y >= 0 + 2*move_one_square and mouse_pos.y <= texture.get_height() + 2*move_one_square \
						and position_piece_on_the_chessboard[i+2][j] == "0":
							move_local_y(2*move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 2
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							starting_square = false
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
						else:
							piece_select = "No piece selected"
							print(piece_select)
							print(starting_square)
						
					elif direction_attack_protect_king == "Droite" or direction_attack_protect_king == "Gauche":
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
						
					elif direction_attack_protect_king == "Haut/Droite" or direction_attack_protect_king == "Haut/Gauche":
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
						
					elif direction_attack_protect_king == "Bas/Droite":
						if mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
						and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
						and (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j+1] == "knight_white"\
						or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j+1] == "rook_white"\
						or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
							move_local_y(move_one_square)
							move_local_x(move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 1
							j += 1
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							starting_square = false
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
							
						else:
							piece_select = "No piece selected"
							print(piece_select)
							print(starting_square)
						
					elif direction_attack_protect_king == "Bas/Gauche":
						if mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
						and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
						and (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j-1] == "knight_white"\
						or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j-1] == "rook_white"\
						or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
							move_local_y(move_one_square)
							move_local_x(-move_one_square)
							position_piece_on_the_chessboard[i][j] = "0"
							i += 1
							j -= 1
							position_piece_on_the_chessboard[i][j] = "pawn_black"
							starting_square = false
							piece_select = "No piece selected"
							get_node("Sound_piece_move").play()
							
							print(piece_select)
							print(starting_square)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
						else:
							piece_select = "No piece selected"
							print(piece_select)
							print(starting_square)
					
	if king_in_check == true and can_protect_the_king == true:
		#Vérifie si la pièce est sur sa case de départ et si c'est le tour des blancs
		if starting_square == false and player_turn == "black":
			
			# Pour sélectionner l'ID unique de la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
					print(starting_square)
				
					print("attacker_position_shift_i: ",attacker_position_shift_i)
					print("attacker_position_shift_j: ",attacker_position_shift_j)
					print("position x: ",(attacker_position_shift_j - j) * 100)
					print("position y: ",(attacker_position_shift_i - i) * 100)
					
					print("attacker_position_shift2_i: ",attacker_position_shift2_i)
					print("attacker_position_shift2_j: ",attacker_position_shift2_j)
					print("position x: ",(attacker_position_shift2_j - j) * 100)
					print("position y: ",(attacker_position_shift2_i - i) * 100)
					
					print("direction_of_attack: ", direction_of_attack)
				
			# Vérifie si c'est bien le bouton gauche de la souris qui est cliquer
			# et que la pièce sélectionner correspond avec l'ID
			elif event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == my_node_name:
				
				if piece_protects_against_an_attack == false:
					#Vérifie qu'on clique bien sur la bonne case et qu'il n'y pas de pièce dessus
					#Diagonal d'une case si une pièce adverse est présent sur la case
					if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
					and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
					and position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "0":
						#Bouge la pièce de move_one_square = 100 en y
						move_local_y((attacker_position_shift_i - i) * 100)
						#Met à jour la position de la pièce dans le tableau avant déplacement
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift_i
						#Met à jour la position de la pièce dans le tableau après déplacement
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						# Déselectionne la pièce après le déplacement
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
						#Et la position dans le tableau.
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						taken_by_the_way = true
						
					elif mouse_pos.x >= (attacker_position_shift_j - j) * 100 and mouse_pos.x <= (attacker_position_shift_j - j) * 100 + move_one_square \
					and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
					and (position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "knight_white"\
					or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "rook_white"\
					or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "queen_white"):
						move_local_y((attacker_position_shift_i - i) * 100)
						move_local_x((attacker_position_shift_j - j) * 100)
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift_i
						j = attacker_position_shift_j
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					elif mouse_pos.x >= (attacker_position_shift_j - j) * 100 and mouse_pos.x <= (attacker_position_shift_j - j) * 100 + move_one_square \
					and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
					and (position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "knight_white"\
					or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "rook_white"\
					or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "queen_white"):
						move_local_y((attacker_position_shift_i - i) * 100)
						move_local_x((attacker_position_shift_j - j) * 100)
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift_i
						j = attacker_position_shift_j
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					#Vérifie qu'on clique bien sur la bonne case et qu'il n'y pas de pièce dessus
					#Diagonal d'une case si une pièce adverse est présent sur la case
					elif mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
					and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
					and position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "0":
						#Bouge la pièce de move_one_square = 100 en y
						move_local_y((attacker_position_shift2_i - i) * 100)
						#Met à jour la position de la pièce dans le tableau avant déplacement
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift2_i
						#Met à jour la position de la pièce dans le tableau après déplacement
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						# Déselectionne la pièce après le déplacement
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
						#Et la position dans le tableau.
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						taken_by_the_way = true
						
					elif mouse_pos.x >= (attacker_position_shift2_j - j) * 100 and mouse_pos.x <= (attacker_position_shift2_j - j) * 100 + move_one_square \
					and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
					and (position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "knight_white"\
					or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "rook_white"\
					or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "queen_white"):
						move_local_y((attacker_position_shift2_i - i) * 100)
						move_local_x((attacker_position_shift2_j - j) * 100)
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift2_i
						j = attacker_position_shift2_j
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
					elif mouse_pos.x >= (attacker_position_shift2_j - j) * 100 and mouse_pos.x <= (attacker_position_shift2_j - j) * 100 + move_one_square \
					and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
					and (position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "knight_white"\
					or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "rook_white"\
					or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "queen_white"):
						move_local_y((attacker_position_shift2_i - i) * 100)
						move_local_x((attacker_position_shift2_j - j) * 100)
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift2_i
						j = attacker_position_shift2_j
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						if i != 9:
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
					#Pour la prise en passant à droite
					elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and position_piece_on_the_chessboard[i+1][j+1] == "0" and position_piece_on_the_chessboard[i][j+1] == "pawn_white"\
					and i == 6 and (get_parent().get_node("Pawn_white").taken_by_the_way == true or get_parent().get_node("Pawn_white2").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white3").taken_by_the_way == true or get_parent().get_node("Pawn_white4").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white5").taken_by_the_way == true or get_parent().get_node("Pawn_white6").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white7").taken_by_the_way == true or get_parent().get_node("Pawn_white8").taken_by_the_way == true):
						
						move_local_y(move_one_square)
						move_local_x(move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j += 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						if get_parent().get_node("Pawn_white") != null:
							if get_parent().get_node("Pawn_white").i == i-1 and get_parent().get_node("Pawn_white").j == j:
								get_parent().get_node("Pawn_white").queue_free()
						for f in range(2,9):
							if get_parent().get_node("Pawn_white" + str(f)) != null:
								if get_parent().get_node("Pawn_white" + str(f)).i == i-1 and get_parent().get_node("Pawn_white" + str(f)).j == j:
									get_parent().get_node("Pawn_white" + str(f)).queue_free()
							
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
					#Pour la prise en passant à gauche
					elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
					and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
					and position_piece_on_the_chessboard[i+1][j-1] == "0" and position_piece_on_the_chessboard[i][j-1] == "pawn_white"\
					and i == 6 and (get_parent().get_node("Pawn_white").taken_by_the_way == true or get_parent().get_node("Pawn_white2").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white3").taken_by_the_way == true or get_parent().get_node("Pawn_white4").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white5").taken_by_the_way == true or get_parent().get_node("Pawn_white6").taken_by_the_way == true\
					or get_parent().get_node("Pawn_white7").taken_by_the_way == true or get_parent().get_node("Pawn_white8").taken_by_the_way == true):
						
						move_local_y(+move_one_square)
						move_local_x(-move_one_square)
						position_piece_on_the_chessboard[i][j] = "0"
						i += 1
						j -= 1
						position_piece_on_the_chessboard[i][j] = "pawn_black"
						piece_select = "No piece selected"
						get_node("Sound_piece_move").play()
						
						if get_parent().get_node("Pawn_white") != null:
							if get_parent().get_node("Pawn_white").i == i-1 and get_parent().get_node("Pawn_white").j == j:
								get_parent().get_node("Pawn_white").queue_free()
						for f in range(2,9):
							if get_parent().get_node("Pawn_white" + str(f)) != null:
								if get_parent().get_node("Pawn_white" + str(f)).i == i-1 and get_parent().get_node("Pawn_white" + str(f)).j == j:
									get_parent().get_node("Pawn_white" + str(f)).queue_free()
						
						print(piece_select)
						print(starting_square)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
					else:
						piece_select = "No piece selected"
						print(piece_select)
						print(starting_square)
						
					
		elif starting_square == true and player_turn == "black":
			
			# Pour sélectionner l'ID unique de la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
					print(starting_square)
					
					print("attacker_position_shift_i: ",attacker_position_shift_i)
					print("attacker_position_shift_j: ",attacker_position_shift_j)
					print("position x: ",(attacker_position_shift_j - j) * 100)
					print("position y: ",(attacker_position_shift_i - i) * 100)
					
					print("attacker_position_shift2_i: ",attacker_position_shift2_i)
					print("attacker_position_shift2_j: ",attacker_position_shift2_j)
					print("position x: ",(attacker_position_shift2_j - j) * 100)
					print("position y: ",(attacker_position_shift2_i - i) * 100)
					
					print("direction_of_attack: ", direction_of_attack)
					
			# Vérifie si c'est bien le bouton gauche de la souris qui est cliquer
			# et que la pièce sélectionner correspond avec l'ID
			elif event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == my_node_name:
				
				# Peut bouger d'une case ou de deux cases de sa case de départ.
				#Diagonal d'une ou deux cases si une pièce adverse est présent sur la case
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
				and position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "0":
					move_local_y((attacker_position_shift_i - i) * 100)
					position_piece_on_the_chessboard[i][j] = "0"
					i = attacker_position_shift_i
					position_piece_on_the_chessboard[i][j] = "pawn_black"
					starting_square = false
					
					attacker_position_shift_i = 0
					attacker_position_shift_j = 0
					attacker_position_shift2_i = 0
					attacker_position_shift2_j = 0
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print(starting_square)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
				elif mouse_pos.x >= (attacker_position_shift_j - j) * 100 and mouse_pos.x <= (attacker_position_shift_j - j) * 100 + move_one_square \
				and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
				and (position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "knight_white"\
				or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "queen_white"):
					move_local_y((attacker_position_shift_i - i) * 100)
					move_local_x((attacker_position_shift_j - j) * 100)
					position_piece_on_the_chessboard[i][j] = "0"
					i = attacker_position_shift_i
					j = attacker_position_shift_j
					position_piece_on_the_chessboard[i][j] = "pawn_black"
					starting_square = false
					
					attacker_position_shift_i = 0
					attacker_position_shift_j = 0
					attacker_position_shift2_i = 0
					attacker_position_shift2_j = 0
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print(starting_square)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
				elif mouse_pos.x >= (attacker_position_shift_j - j) * 100 and mouse_pos.x <= (attacker_position_shift_j - j) * 100 + move_one_square \
				and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
				and (position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "knight_white"\
				or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "queen_white"):
					move_local_y((attacker_position_shift_i - i) * 100)
					move_local_x((attacker_position_shift_j - j) * 100)
					position_piece_on_the_chessboard[i][j] = "0"
					i = attacker_position_shift_i
					j = attacker_position_shift_j
					position_piece_on_the_chessboard[i][j] = "pawn_black"
					starting_square = false
					
					attacker_position_shift_i = 0
					attacker_position_shift_j = 0
					attacker_position_shift2_i = 0
					attacker_position_shift2_j = 0
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print(starting_square)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				# Peut bouger d'une case ou de deux cases de sa case de départ.
				#Diagonal d'une ou deux cases si une pièce adverse est présent sur la case
				elif mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
				and position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "0":
					move_local_y((attacker_position_shift2_i - i) * 100)
					position_piece_on_the_chessboard[i][j] = "0"
					i = attacker_position_shift2_i
					position_piece_on_the_chessboard[i][j] = "pawn_black"
					starting_square = false
					
					attacker_position_shift_i = 0
					attacker_position_shift_j = 0
					attacker_position_shift2_i = 0
					attacker_position_shift2_j = 0
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print(starting_square)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
				elif mouse_pos.x >= (attacker_position_shift2_j - j) * 100 and mouse_pos.x <= (attacker_position_shift2_j - j) * 100 + move_one_square \
				and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
				and (position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "knight_white"\
				or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "queen_white"):
					move_local_y((attacker_position_shift2_i - i) * 100)
					move_local_x((attacker_position_shift2_j - j) * 100)
					position_piece_on_the_chessboard[i][j] = "0"
					i = attacker_position_shift2_i
					j = attacker_position_shift2_j
					position_piece_on_the_chessboard[i][j] = "pawn_black"
					starting_square = false
					
					attacker_position_shift_i = 0
					attacker_position_shift_j = 0
					attacker_position_shift2_i = 0
					attacker_position_shift2_j = 0
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print(starting_square)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
				elif mouse_pos.x >= (attacker_position_shift2_j - j) * 100 and mouse_pos.x <= (attacker_position_shift2_j - j) * 100 + move_one_square \
				and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
				and (position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "pawn_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "knight_white"\
				or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "bishop_white" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "queen_white"):
					move_local_y((attacker_position_shift2_i - i) * 100)
					move_local_x((attacker_position_shift2_j - j) * 100)
					position_piece_on_the_chessboard[i][j] = "0"
					i = attacker_position_shift2_i
					j = attacker_position_shift2_j
					position_piece_on_the_chessboard[i][j] = "pawn_black"
					starting_square = false
					
					attacker_position_shift_i = 0
					attacker_position_shift_j = 0
					attacker_position_shift2_i = 0
					attacker_position_shift2_j = 0
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print(starting_square)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				else:
					piece_select = "No piece selected"
					print(piece_select)
					print(starting_square)
					
		elif piece_protects_against_an_attack == true:
			piece_select = "No piece selected"
			print(piece_select)
			
	if Global.preview_piece_move_option == true:
		if my_node_name != null:
			preview_move()

#Pour prendre la pièce ennemi qu'on on rentre dans sa zone de collision
func _on_area_2d_area_entered(area):
	if player_turn == "white":
		get_node("/root/Chess_game/Plateau_echec/" + area.get_parent().get_name()).queue_free()
		print("piece pris: ",area.get_parent().get_name())

func preview_move():
	#Pré-visualisation des mouvements de la pièce
	var Move_Preview = get_node("Move_preview")
	if piece_select == my_node_name and king_in_check == false and piece_protects_against_an_attack == false:
		if starting_square == true:
			if position_piece_on_the_chessboard[i+1][j] == "0":
				Move_Preview.get_node("Pawn_black_preview_move").visible = true
			if position_piece_on_the_chessboard[i+2][j] == "0":
				Move_Preview.get_node("Pawn_black_preview_move2").visible = true
			if (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "knight_white" or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "rook_white" or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
				Move_Preview.get_node("Square_attack_preview_right").visible = true
			if (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "knight_white" or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "rook_white" or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
				Move_Preview.get_node("Square_attack_preview_left").visible = true
		elif starting_square == false:
			Move_Preview.get_node("Pawn_black_preview_move2").visible = false
			if position_piece_on_the_chessboard[i+1][j] == "0":
				Move_Preview.get_node("Pawn_black_preview_move").visible = true
			if (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "knight_white" or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "rook_white" or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
				Move_Preview.get_node("Square_attack_preview_right").visible = true
			if (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "knight_white" or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "rook_white" or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
				Move_Preview.get_node("Square_attack_preview_left").visible = true
	elif piece_select == my_node_name and king_in_check == true and piece_protects_against_an_attack == false:
		if Move_Preview.get_node("Pawn_black_preview_move").position.y == (attacker_position_shift_i - i) * 100\
		and Move_Preview.get_node("Pawn_black_preview_move").position.x == (attacker_position_shift_j - j) * 100:
			Move_Preview.get_node("Pawn_black_preview_move").visible = true
		if Move_Preview.get_node("Pawn_black_preview_move").position.y == (attacker_position_shift2_i - i) * 100\
		and Move_Preview.get_node("Pawn_black_preview_move").position.x == (attacker_position_shift2_j - j) * 100:
			Move_Preview.get_node("Pawn_black_preview_move").visible = true
		
		if starting_square == false and Move_Preview.get_node("Pawn_black_preview_move2").position.y == (attacker_position_shift_i - i) * 100\
		and Move_Preview.get_node("Pawn_black_preview_move2").position.x == (attacker_position_shift_j - j) * 100:
			Move_Preview.get_node("Pawn_black_preview_move2").visible = true
		if starting_square == false and Move_Preview.get_node("Pawn_black_preview_move2").position.y == (attacker_position_shift2_i - i) * 100\
		and Move_Preview.get_node("Pawn_black_preview_move2").position.x == (attacker_position_shift2_j - j) * 100:
			Move_Preview.get_node("Pawn_black_preview_move2").visible = true
			
		if Move_Preview.get_node("Square_attack_preview_right").position.y == (attacker_position_shift_i - i) * 100\
		and Move_Preview.get_node("Square_attack_preview_right").position.x == (attacker_position_shift_j - j) * 100:
			Move_Preview.get_node("Square_attack_preview_right").visible = true
		if Move_Preview.get_node("Square_attack_preview_right").position.y == (attacker_position_shift2_i - i) * 100\
		and Move_Preview.get_node("Square_attack_preview_right").position.x == (attacker_position_shift2_j - j) * 100:
			Move_Preview.get_node("Square_attack_preview_right").visible = true
		
		if Move_Preview.get_node("Square_attack_preview_left").position.y == (attacker_position_shift_i - i) * 100\
		and Move_Preview.get_node("Square_attack_preview_left").position.x == (attacker_position_shift_j - j) * 100:
			Move_Preview.get_node("Square_attack_preview_left").visible = true
		if Move_Preview.get_node("Square_attack_preview_left").position.y == (attacker_position_shift2_i - i) * 100\
		and Move_Preview.get_node("Square_attack_preview_left").position.x == (attacker_position_shift2_j - j) * 100:
			Move_Preview.get_node("Square_attack_preview_left").visible = true
	elif piece_select == my_node_name and king_in_check == false and piece_protects_against_an_attack == true:
		if direction_attack_protect_king == "Bas":
			if starting_square == true:
				if position_piece_on_the_chessboard[i+1][j] == "0":
					Move_Preview.get_node("Pawn_black_preview_move").visible = true
				if position_piece_on_the_chessboard[i+2][j] == "0":
					Move_Preview.get_node("Pawn_black_preview_move2").visible = true
			elif starting_square == false:
				Move_Preview.get_node("Pawn_black_preview_move2").visible = false
				if position_piece_on_the_chessboard[i+1][j] == "0":
					Move_Preview.get_node("Pawn_black_preview_move").visible = true
		elif direction_attack_protect_king == "Bas/Droite":
			if (position_piece_on_the_chessboard[i+1][j+1] == "pawn_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "knight_white" or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "rook_white" or position_piece_on_the_chessboard[i+1][j+1] == "queen_white"):
				Move_Preview.get_node("Square_attack_preview_right").visible = true
		elif direction_attack_protect_king == "Bas/Gauche":
			if (position_piece_on_the_chessboard[i+1][j-1] == "pawn_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "knight_white" or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "rook_white" or position_piece_on_the_chessboard[i+1][j-1] == "queen_white"):
				Move_Preview.get_node("Square_attack_preview_left").visible = true
	else:
		Move_Preview.get_node("Pawn_black_preview_move").visible = false
		Move_Preview.get_node("Pawn_black_preview_move2").visible = false
		Move_Preview.get_node("Square_attack_preview_right").visible = false
		Move_Preview.get_node("Square_attack_preview_left").visible = false

func verif_piece_protects_against_an_attack_the_king():
	#On regarde d'où vient l'attaque
	#Lignes
	#Vers le haut
	for f in range(1,9):
		if position_piece_on_the_chessboard[i-f][j] == "x":
			break
		elif position_piece_on_the_chessboard[i-f][j] != "0":
			
			if position_piece_on_the_chessboard[i-f][j] == "rook_white"\
			or position_piece_on_the_chessboard[i-f][j] == "queen_white":
				direction_attack_protect_king = "Haut"
				break
			else:
				break
	#Vers le bas
	for f in range(1,9):
		if position_piece_on_the_chessboard[i+f][j] == "x":
			break
		elif position_piece_on_the_chessboard[i+f][j] != "0":
			
			if position_piece_on_the_chessboard[i+f][j] == "rook_white"\
			or position_piece_on_the_chessboard[i+f][j] == "queen_white":
				direction_attack_protect_king = "Bas"
				break
			else:
				break
	#Vers la droite
	for f in range(1,9):
		if position_piece_on_the_chessboard[i][j+f] == "x":
			break
		elif position_piece_on_the_chessboard[i][j+f] != "0":
			
			if position_piece_on_the_chessboard[i][j+f] == "rook_white"\
			or position_piece_on_the_chessboard[i][j+f] == "queen_white":
				direction_attack_protect_king = "Droite"
				break
			else:
				break
	#Vers la gauche
	for f in range(1,9):
		if position_piece_on_the_chessboard[i][j-f] == "x":
			break
		elif position_piece_on_the_chessboard[i][j-f] != "0":
			
			if position_piece_on_the_chessboard[i][j-f] == "rook_white"\
			or position_piece_on_the_chessboard[i][j-f] == "queen_white":
				direction_attack_protect_king = "Gauche"
				break
			else:
				break
	#Diagonales
	#Vers le haut à droite
	for f in range(1,9):
		if position_piece_on_the_chessboard[i-f][j+f] == "x":
			break
		elif position_piece_on_the_chessboard[i-f][j+f] != "0":
			
			if position_piece_on_the_chessboard[i-f][j+f] == "bishop_white"\
			or position_piece_on_the_chessboard[i-f][j+f] == "queen_white":
				direction_attack_protect_king = "Haut/Droite"
				break
			else:
				break
	#Vers le haut à gauche
	for f in range(1,9):
		if position_piece_on_the_chessboard[i-f][j-f] == "x":
			break
		elif position_piece_on_the_chessboard[i-f][j-f] != "0":
			
			if position_piece_on_the_chessboard[i-f][j-f] == "bishop_white"\
			or position_piece_on_the_chessboard[i-f][j-f] == "queen_white":
				direction_attack_protect_king = "Haut/Gauche"
				break
			else:
				break
	#Vers le bas à droite
	for f in range(1,9):
		if position_piece_on_the_chessboard[i+f][j+f] == "x":
			break
		elif position_piece_on_the_chessboard[i+f][j+f] != "0":
			
			if position_piece_on_the_chessboard[i+f][j+f] == "bishop_white"\
			or position_piece_on_the_chessboard[i+f][j+f] == "queen_white":
				direction_attack_protect_king = "Bas/Droite"
				break
			else:
				break
	#Vers le bas à gauche
	for f in range(1,9):
		if position_piece_on_the_chessboard[i+f][j-f] == "x":
			break
		elif position_piece_on_the_chessboard[i+f][j-f] != "0":
			
			if position_piece_on_the_chessboard[i+f][j-f] == "bishop_white"\
			or position_piece_on_the_chessboard[i+f][j-f] == "queen_white":
				direction_attack_protect_king = "Bas/Gauche"
				break
			else:
				break
	
	#Ensuite, on regarde si le roi est derrière la pièce
	#qui le protège de l'attaque qui vient dans cette direction
	if direction_attack_protect_king == "Haut":
		#On cherche vers le bas
		for f in range(1,9):
			if position_piece_on_the_chessboard[i+f][j] == "x":
				break
			elif position_piece_on_the_chessboard[i+f][j] != "0":
				
				if position_piece_on_the_chessboard[i+f][j] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Bas":
		#On cherche vers le haut
		for f in range(1,9):
			if position_piece_on_the_chessboard[i-f][j] == "x":
				break
			elif position_piece_on_the_chessboard[i-f][j] != "0":
				
				if position_piece_on_the_chessboard[i-f][j] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Droite":
		#On cherche vers la gauche
		for f in range(1,9):
			if position_piece_on_the_chessboard[i][j-f] == "x":
				break
			elif position_piece_on_the_chessboard[i][j-f] != "0":
				
				if position_piece_on_the_chessboard[i][j-f] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Gauche":
		#On cherche vers la droite
		for f in range(1,9):
			if position_piece_on_the_chessboard[i][j+f] == "x":
				break
			elif position_piece_on_the_chessboard[i][j+f] != "0":
				
				if position_piece_on_the_chessboard[i][j+f] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Haut/Droite":
		#On cherche vers le Bas/Gauche
		for f in range(1,9):
			if position_piece_on_the_chessboard[i+f][j-f] == "x":
				break
			elif position_piece_on_the_chessboard[i+f][j-f] != "0":
				
				if position_piece_on_the_chessboard[i+f][j-f] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Haut/Gauche":
		#On cherche vers le Bas/Droite
		for f in range(1,9):
			if position_piece_on_the_chessboard[i+f][j+f] == "x":
				break
			elif position_piece_on_the_chessboard[i+f][j+f] != "0":
				
				if position_piece_on_the_chessboard[i+f][j+f] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Bas/Droite":
		#On cherche vers le Haut/Gauche
		for f in range(1,9):
			if position_piece_on_the_chessboard[i-f][j-f] == "x":
				break
			elif position_piece_on_the_chessboard[i-f][j-f] != "0":
				
				if position_piece_on_the_chessboard[i-f][j-f] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Bas/Gauche":
		#On cherche vers le Haut/Droite
		for f in range(1,9):
			if position_piece_on_the_chessboard[i-f][j+f] == "x":
				break
			elif position_piece_on_the_chessboard[i-f][j+f] != "0":
				
				if position_piece_on_the_chessboard[i-f][j+f] == "king_black":
					piece_protects_against_an_attack = true
					break
				else:
					break
