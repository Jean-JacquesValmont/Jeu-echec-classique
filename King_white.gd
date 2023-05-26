extends Sprite2D

signal opponent_turned #Permet de créer son propre signal
signal Petit_roque
signal Grand_roque
signal check_to_the_king
signal checkmate_to_the_king

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
	
var attack_piece_black_on_the_chessboard = \
	[[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9]]

var attack_piece_white_on_the_chessboard = \
	[[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9]]

var player_turn = "white"
var piece_select = "No piece selected"
var starting_square = true #Si la pièce est sur sa case de départ et n'a fait aucun déplacement
var my_node_id = get_node(".").get_instance_id() #Permet de récupérer l'ID unique du noeud
@onready var my_node_name = get_node(".").get_name() #Permet de récupérer le nom du noeud
@onready var Sound_piece_move = get_node("Sound_piece_move")
var i = 9 # Le i correspond à l'axe y (de gauche à droite)
var j = 6 # Le j correspond à l'axe x (de haut en bas)
var move_one_square = 100
var king_in_check = false
var piece_protect_the_king = false
var checkmate = false
var attacker_position_i = 2
var attacker_position_j = 2
var direction_of_attack = ""

var update_of_the_parts_attack = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ID de ", my_node_name, ": ", my_node_id)
	#Par rapport au nom du noeud récupérer, de lui donner la bonne position dans le tableau
	if my_node_name == "King_white":
		i = 9
		j = 6
		
	print("i: ", i)
	print("j: ", j)
	
	attack_pieces_black()
	attack_pieces_white()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_turn == "white" and update_of_the_parts_attack == false:
		attack_pieces_black()
		attack_pieces_white()
		
		verification_check_and_checkmate()
		update_of_the_parts_attack = true
		
	elif player_turn == "black":
		update_of_the_parts_attack = false

#Ecoute si un input se produit
func _input(event):
	var mouse_pos = get_local_mouse_position()
	
	#Vérifie si la pièce est sur sa case de départ et si c'est le tour des blancs
	if checkmate == false:
		if player_turn == "white":
			
			# Pour sélectionner l'ID unique de la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
				
			# Vérifie si c'est bien le bouton gauche de la souris qui est cliquer
			# et que la pièce sélectionner correspond avec l'ID
			elif event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == my_node_name:
				
				#Vérifie qu'on clique bien sur la bonne case
				#Vers le haut
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 - move_one_square and mouse_pos.y <= texture.get_height() - move_one_square \
				and attack_piece_black_on_the_chessboard[i-1][j] == 0 \
				and (position_piece_on_the_chessboard[i-1][j] == "0" or position_piece_on_the_chessboard[i-1][j] == "pawn_black"\
				or position_piece_on_the_chessboard[i-1][j] == "knight_black" or position_piece_on_the_chessboard[i-1][j] == "bishop_black"\
				or position_piece_on_the_chessboard[i-1][j] == "rook_black" or position_piece_on_the_chessboard[i-1][j] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_y(-move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					i -= 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
				#Vers le bas
				elif mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
				and attack_piece_black_on_the_chessboard[i+1][j] == 0 \
				and (position_piece_on_the_chessboard[i+1][j] == "0" or position_piece_on_the_chessboard[i+1][j] == "pawn_black"\
				or position_piece_on_the_chessboard[i+1][j] == "knight_black" or position_piece_on_the_chessboard[i+1][j] == "bishop_black"\
				or position_piece_on_the_chessboard[i+1][j] == "rook_black" or position_piece_on_the_chessboard[i+1][j] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_y(move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					i += 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
				#Vers la droite
				elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
				and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height() \
				and attack_piece_black_on_the_chessboard[i][j+1] == 0 \
				and (position_piece_on_the_chessboard[i][j+1] == "0" or position_piece_on_the_chessboard[i][j+1] == "pawn_black"\
				or position_piece_on_the_chessboard[i][j+1] == "knight_black" or position_piece_on_the_chessboard[i][j+1] == "bishop_black"\
				or position_piece_on_the_chessboard[i][j+1] == "rook_black" or position_piece_on_the_chessboard[i][j+1] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_x(move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					j += 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				#Vers la gauche
				elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
				and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height() \
				and attack_piece_black_on_the_chessboard[i][j-1] == 0 \
				and (position_piece_on_the_chessboard[i][j-1] == "0" or position_piece_on_the_chessboard[i][j-1] == "pawn_black"\
				or position_piece_on_the_chessboard[i][j-1] == "knight_black" or position_piece_on_the_chessboard[i][j-1] == "bishop_black"\
				or position_piece_on_the_chessboard[i][j-1] == "rook_black" or position_piece_on_the_chessboard[i][j-1] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_x(-move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					j -= 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				######################################################################################################
				#Vers le haut à droite
				elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
				and mouse_pos.y >= 0 - move_one_square and mouse_pos.y <= texture.get_height() - move_one_square \
				and attack_piece_black_on_the_chessboard[i-1][j+1] == 0 \
				and (position_piece_on_the_chessboard[i-1][j+1] == "0" or position_piece_on_the_chessboard[i-1][j+1] == "pawn_black"\
				or position_piece_on_the_chessboard[i-1][j+1] == "knight_black" or position_piece_on_the_chessboard[i-1][j+1] == "bishop_black"\
				or position_piece_on_the_chessboard[i-1][j+1] == "rook_black" or position_piece_on_the_chessboard[i-1][j+1] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_y(-move_one_square)
					move_local_x(move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					i -= 1
					j += 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				#Vers le haut à gauche
				elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
				and mouse_pos.y >= 0 - move_one_square and mouse_pos.y <= texture.get_height() - move_one_square \
				and attack_piece_black_on_the_chessboard[i-1][j-1] == 0 \
				and (position_piece_on_the_chessboard[i-1][j-1] == "0" or position_piece_on_the_chessboard[i-1][j-1] == "pawn_black"\
				or position_piece_on_the_chessboard[i-1][j-1] == "knight_black" or position_piece_on_the_chessboard[i-1][j-1] == "bishop_black"\
				or position_piece_on_the_chessboard[i-1][j-1] == "rook_black" or position_piece_on_the_chessboard[i-1][j-1] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_y(-move_one_square)
					move_local_x(-move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					i -= 1
					j -= 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				#Vers le bas à droite
				elif mouse_pos.x >= 0 + move_one_square and mouse_pos.x <= texture.get_width() + move_one_square \
				and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
				and attack_piece_black_on_the_chessboard[i+1][j+1] == 0 \
				and (position_piece_on_the_chessboard[i+1][j+1] == "0" or position_piece_on_the_chessboard[i+1][j+1] == "pawn_black"\
				or position_piece_on_the_chessboard[i+1][j+1] == "knight_black" or position_piece_on_the_chessboard[i+1][j+1] == "bishop_black"\
				or position_piece_on_the_chessboard[i+1][j+1] == "rook_black" or position_piece_on_the_chessboard[i+1][j+1] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_y(move_one_square)
					move_local_x(move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					i += 1
					j += 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				#Vers le bas à gauche
				elif mouse_pos.x >= 0 - move_one_square and mouse_pos.x <= texture.get_width() - move_one_square \
				and mouse_pos.y >= 0 + move_one_square and mouse_pos.y <= texture.get_height() + move_one_square \
				and attack_piece_black_on_the_chessboard[i+1][j-1] == 0 \
				and (position_piece_on_the_chessboard[i+1][j-1] == "0" or position_piece_on_the_chessboard[i+1][j-1] == "pawn_black"\
				or position_piece_on_the_chessboard[i+1][j-1] == "knight_black" or position_piece_on_the_chessboard[i+1][j-1] == "bishop_black"\
				or position_piece_on_the_chessboard[i+1][j-1] == "rook_black" or position_piece_on_the_chessboard[i+1][j-1] == "queen_black"):
					#Bouge la pièce de move_one_square = 100 en y
					move_local_y(move_one_square)
					move_local_x(-move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					i += 1
					j -= 1
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
				
				#Roque vers la droite
				elif mouse_pos.x >= 0 + 2*move_one_square and mouse_pos.x <= texture.get_width() + 2*move_one_square \
				and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height() and starting_square == true\
				and attack_piece_black_on_the_chessboard[i][j] == 0 and attack_piece_black_on_the_chessboard[i][j+1] == 0\
				and attack_piece_black_on_the_chessboard[i][j+2] == 0\
				and position_piece_on_the_chessboard[i][j+1] == "0" and position_piece_on_the_chessboard[i][j+2] == "0"\
				and position_piece_on_the_chessboard[i][j+3] == "rook_white"\
				and get_parent().get_node("Rook_white2").starting_square == true:
					#Bouge la pièce de move_one_square = 100 en y
					move_local_x(2*move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					j += 2
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					emit_signal("Petit_roque")
					
				#Roque vers la gauche
				elif mouse_pos.x >= 0 - 2*move_one_square and mouse_pos.x <= texture.get_width() - 2*move_one_square \
				and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height() and starting_square == true \
				and attack_piece_black_on_the_chessboard[i][j] == 0 and attack_piece_black_on_the_chessboard[i][j-1] == 0\
				and attack_piece_black_on_the_chessboard[i][j-2] == 0 and attack_piece_black_on_the_chessboard[i][j-3] == 0\
				and position_piece_on_the_chessboard[i][j-1] == "0" and position_piece_on_the_chessboard[i][j-2] == "0"\
				and position_piece_on_the_chessboard[i][j-3] == "0" and position_piece_on_the_chessboard[i][j-4] == "rook_white"\
				and get_parent().get_node("Rook_white").starting_square == true:
					#Bouge la pièce de move_one_square = 100 en y
					move_local_x(-2*move_one_square)
					#Met à jour la position de la pièce dans le tableau avant déplacement
					position_piece_on_the_chessboard[i][j] = "0"
					j -= 2
					#Met à jour la position de la pièce dans le tableau après déplacement
					position_piece_on_the_chessboard[i][j] = "king_white"
					starting_square = false
					# Déselectionne la pièce après le déplacement
					piece_select = "No piece selected"
					get_node("Sound_piece_move").play()
					
					print(piece_select)
					print("i: ", i)
					print("j: ", j)
					print(position_piece_on_the_chessboard)
					#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
					#Et la position dans le tableau.
					emit_signal("opponent_turned",position_piece_on_the_chessboard)
					emit_signal("Grand_roque")
					
				else:
					piece_select = "No piece selected"
					print(piece_select)
					
	elif checkmate == true:
		pass
		
	if Global.preview_piece_move_option == true:
		if my_node_name != null:
			preview_move()
	
func _on_area_2d_area_entered(area):
	if player_turn == "black":
		get_node("/root/Chess_game/Plateau_echec/" + area.get_parent().get_name()).queue_free()
		print("piece pris: ",area.get_parent().get_name())

func preview_move():
	var Move_Preview = get_node("Move_preview")
	if king_in_check == true or checkmate == true:
		Move_Preview.get_node("Square_attack_preview_center").visible = true
	else:
		Move_Preview.get_node("Square_attack_preview_center").visible = false
	#Pré-visualisation des mouvements de la pièce
	#Haut
	if piece_select == my_node_name:
		if position_piece_on_the_chessboard[i-1][j] == "0"\
		and attack_piece_black_on_the_chessboard[i-1][j] == 0:
			Move_Preview.get_node("King_white_preview_move").visible = true
		elif attack_piece_black_on_the_chessboard[i-1][j] == 0\
			and (position_piece_on_the_chessboard[i-1][j] == "pawn_black"\
			or position_piece_on_the_chessboard[i-1][j] == "knight_black" or position_piece_on_the_chessboard[i-1][j] == "bishop_black"\
			or position_piece_on_the_chessboard[i-1][j] == "rook_black" or position_piece_on_the_chessboard[i-1][j] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_up").visible = true
		#Haut à droite
		if position_piece_on_the_chessboard[i-1][j+1] == "0"\
		and attack_piece_black_on_the_chessboard[i-1][j+1] == 0:
			Move_Preview.get_node("King_white_preview_move2").visible = true
		elif attack_piece_black_on_the_chessboard[i-1][j+1] == 0\
			and (position_piece_on_the_chessboard[i-1][j+1] == "pawn_black"\
			or position_piece_on_the_chessboard[i-1][j+1] == "knight_black" or position_piece_on_the_chessboard[i-1][j+1] == "bishop_black"\
			or position_piece_on_the_chessboard[i-1][j+1] == "rook_black" or position_piece_on_the_chessboard[i-1][j+1] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_up_right").visible = true
		#Droite
		if position_piece_on_the_chessboard[i][j+1] == "0"\
		and attack_piece_black_on_the_chessboard[i][j+1] == 0:
			Move_Preview.get_node("King_white_preview_move3").visible = true
		elif attack_piece_black_on_the_chessboard[i][j+1] == 0\
			and (position_piece_on_the_chessboard[i][j+1] == "pawn_black"\
			or position_piece_on_the_chessboard[i][j+1] == "knight_black" or position_piece_on_the_chessboard[i][j+1] == "bishop_black"\
			or position_piece_on_the_chessboard[i][j+1] == "rook_black" or position_piece_on_the_chessboard[i][j+1] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_right").visible = true
		#Bas à droite
		if position_piece_on_the_chessboard[i+1][j+1] == "0"\
		and attack_piece_black_on_the_chessboard[i+1][j+1] == 0:
			Move_Preview.get_node("King_white_preview_move4").visible = true
		elif attack_piece_black_on_the_chessboard[i+1][j+1] == 0\
			and (position_piece_on_the_chessboard[i+1][j+1] == "pawn_black"\
			or position_piece_on_the_chessboard[i+1][j+1] == "knight_black" or position_piece_on_the_chessboard[i+1][j+1] == "bishop_black"\
			or position_piece_on_the_chessboard[i+1][j+1] == "rook_black" or position_piece_on_the_chessboard[i+1][j+1] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_down_right").visible = true
		#Bas
		if position_piece_on_the_chessboard[i+1][j] == "0"\
		and attack_piece_black_on_the_chessboard[i+1][j] == 0:
			Move_Preview.get_node("King_white_preview_move5").visible = true
		elif attack_piece_black_on_the_chessboard[i+1][j] == 0\
			and (position_piece_on_the_chessboard[i+1][j] == "pawn_black"\
			or position_piece_on_the_chessboard[i+1][j] == "knight_black" or position_piece_on_the_chessboard[i+1][j] == "bishop_black"\
			or position_piece_on_the_chessboard[i+1][j] == "rook_black" or position_piece_on_the_chessboard[i+1][j] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_down").visible = true
		#Bas à gauche
		if position_piece_on_the_chessboard[i+1][j-1] == "0"\
		and attack_piece_black_on_the_chessboard[i+1][j-1] == 0:
			Move_Preview.get_node("King_white_preview_move6").visible = true
		elif attack_piece_black_on_the_chessboard[i+1][j-1] == 0\
			and (position_piece_on_the_chessboard[i+1][j-1] == "pawn_black"\
			or position_piece_on_the_chessboard[i+1][j-1] == "knight_black" or position_piece_on_the_chessboard[i+1][j-1] == "bishop_black"\
			or position_piece_on_the_chessboard[i+1][j-1] == "rook_black" or position_piece_on_the_chessboard[i+1][j-1] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_down_left").visible = true
		#Gauche
		if position_piece_on_the_chessboard[i][j-1] == "0"\
		and attack_piece_black_on_the_chessboard[i][j-1] == 0:
			Move_Preview.get_node("King_white_preview_move7").visible = true
		elif attack_piece_black_on_the_chessboard[i][j-1] == 0\
			and (position_piece_on_the_chessboard[i][j-1] == "pawn_black"\
			or position_piece_on_the_chessboard[i][j-1] == "knight_black" or position_piece_on_the_chessboard[i][j-1] == "bishop_black"\
			or position_piece_on_the_chessboard[i][j-1] == "rook_black" or position_piece_on_the_chessboard[i][j-1] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_left").visible = true
		#Haut à gauche
		if position_piece_on_the_chessboard[i-1][j-1] == "0"\
		and attack_piece_black_on_the_chessboard[i-1][j-1] == 0:
			Move_Preview.get_node("King_white_preview_move8").visible = true
		elif attack_piece_black_on_the_chessboard[i-1][j-1] == 0\
			and (position_piece_on_the_chessboard[i-1][j-1] == "pawn_black"\
			or position_piece_on_the_chessboard[i-1][j-1] == "knight_black" or position_piece_on_the_chessboard[i-1][j-1] == "bishop_black"\
			or position_piece_on_the_chessboard[i-1][j-1] == "rook_black" or position_piece_on_the_chessboard[i-1][j-1] == "queen_black"):
			Move_Preview.get_node("Square_attack_preview_up_left").visible = true
	else:
		Move_Preview.get_node("King_white_preview_move").visible = false
		Move_Preview.get_node("Square_attack_preview_up").visible = false
		Move_Preview.get_node("King_white_preview_move2").visible = false
		Move_Preview.get_node("Square_attack_preview_up_right").visible = false
		Move_Preview.get_node("King_white_preview_move3").visible = false
		Move_Preview.get_node("Square_attack_preview_right").visible = false
		Move_Preview.get_node("King_white_preview_move4").visible = false
		Move_Preview.get_node("Square_attack_preview_down_right").visible = false
		Move_Preview.get_node("King_white_preview_move5").visible = false
		Move_Preview.get_node("Square_attack_preview_down").visible = false
		Move_Preview.get_node("King_white_preview_move6").visible = false
		Move_Preview.get_node("Square_attack_preview_down_left").visible = false
		Move_Preview.get_node("King_white_preview_move7").visible = false
		Move_Preview.get_node("Square_attack_preview_left").visible = false
		Move_Preview.get_node("King_white_preview_move8").visible = false
		Move_Preview.get_node("Square_attack_preview_up_left").visible = false
		

func attack_pieces_black():
	attack_piece_black_on_the_chessboard = \
	[[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9]]
	
	for i in range(12):
		for j in range(12):
			if position_piece_on_the_chessboard[i][j] == "pawn_black":
				if position_piece_on_the_chessboard[i+1][j+1] != "x":
					attack_piece_black_on_the_chessboard[i+1][j+1] += 1
					
				if position_piece_on_the_chessboard[i+1][j-1] != "x":
					attack_piece_black_on_the_chessboard[i+1][j-1] += 1
					
			if position_piece_on_the_chessboard[i][j] == "knight_black":
				if position_piece_on_the_chessboard[i-2][j-1] != "x":
					attack_piece_black_on_the_chessboard[i-2][j-1] += 1
					
				if position_piece_on_the_chessboard[i-2][j+1] != "x":
					attack_piece_black_on_the_chessboard[i-2][j+1] += 1
					
				if position_piece_on_the_chessboard[i-1][j+2] != "x":
					attack_piece_black_on_the_chessboard[i-1][j+2] += 1
					
				if position_piece_on_the_chessboard[i+1][j+2] != "x":
					attack_piece_black_on_the_chessboard[i+1][j+2] += 1
					
				if position_piece_on_the_chessboard[i+2][j-1] != "x":
					attack_piece_black_on_the_chessboard[i+2][j-1] += 1
					
				if position_piece_on_the_chessboard[i+2][j+1] != "x":
					attack_piece_black_on_the_chessboard[i+2][j+1] += 1
					
				if position_piece_on_the_chessboard[i-1][j-2] != "x":
					attack_piece_black_on_the_chessboard[i-1][j-2] += 1
					
				if position_piece_on_the_chessboard[i+1][j-2] != "x":
					attack_piece_black_on_the_chessboard[i+1][j-2] += 1
					
			if position_piece_on_the_chessboard[i][j] == "bishop_black":
				#attack vers le haut à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j+f] == "king_white":
							if attack_piece_black_on_the_chessboard[i-f-1][j+f+1] <= -1:
								attack_piece_black_on_the_chessboard[i-f][j+f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i-f][j+f] += 1
								attack_piece_black_on_the_chessboard[i-f-1][j+f+1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i-f][j+f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i-f][j+f] += 1
				#attack vers le haut à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j-f] == "king_white":
							if attack_piece_black_on_the_chessboard[i-f-1][j-f-1] <= -1:
								attack_piece_black_on_the_chessboard[i-f][j-f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i-f][j-f] += 1
								attack_piece_black_on_the_chessboard[i-f-1][j-f-1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i-f][j-f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i-f][j-f] += 1
				#attack vers le bas à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j+f] == "king_white":
							if attack_piece_black_on_the_chessboard[i+f+1][j+f+1] <= -1:
								attack_piece_black_on_the_chessboard[i+f][j+f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i+f][j+f] += 1
								attack_piece_black_on_the_chessboard[i+f+1][j+f+1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i+f][j+f] += 1
							break
					else:
						attack_piece_black_on_the_chessboard[i+f][j+f] += 1
				#attack vers le bas à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j-f] == "king_white":
							if attack_piece_black_on_the_chessboard[i+f+1][j-f-1] <= -1:
								attack_piece_black_on_the_chessboard[i+f][j-f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i+f][j-f] += 1
								attack_piece_black_on_the_chessboard[i+f+1][j-f-1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i+f][j-f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i+f][j-f] += 1
			
			if position_piece_on_the_chessboard[i][j] == "rook_black":
				#attack vers le haut
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j] != "0":

						if position_piece_on_the_chessboard[i-f][j] == "king_white":
							if attack_piece_black_on_the_chessboard[i-f-1][j] <= -1:
								attack_piece_black_on_the_chessboard[i-f][j] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i-f][j] += 1
								attack_piece_black_on_the_chessboard[i-f-1][j] += 1
								break
						
						else:
							attack_piece_black_on_the_chessboard[i-f][j] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i-f][j] += 1
				#attack vers le bas
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j] != "0":

						if position_piece_on_the_chessboard[i+f][j] == "king_white":
							if attack_piece_black_on_the_chessboard[i+f+1][j] <= -1:
								attack_piece_black_on_the_chessboard[i+f][j] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i+f][j] += 1
								attack_piece_black_on_the_chessboard[i+f+1][j] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i+f][j] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i+f][j] += 1
				#attack vers la droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j+f] != "0":
						
						if position_piece_on_the_chessboard[i][j+f] == "king_white":
							if attack_piece_black_on_the_chessboard[i][j+f+1] <= -1:
								attack_piece_black_on_the_chessboard[i][j+f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i][j+f] += 1
								attack_piece_black_on_the_chessboard[i][j+f+1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i][j+f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i][j+f] += 1
				#attack vers la gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j-f] != "0":
						
						if position_piece_on_the_chessboard[i][j-f] == "king_white":
							if attack_piece_black_on_the_chessboard[i][j-f-1] <= -1:
								attack_piece_black_on_the_chessboard[i][j-f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i][j-f] += 1
								attack_piece_black_on_the_chessboard[i][j-f-1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i][j-f] += 1
							break
					else:
						attack_piece_black_on_the_chessboard[i][j-f] += 1
				
			if position_piece_on_the_chessboard[i][j] == "queen_black":
				#attack vers le haut
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j] != "0":

						if position_piece_on_the_chessboard[i-f][j] == "king_white":
							if attack_piece_black_on_the_chessboard[i-f-1][j] <= -1:
								attack_piece_black_on_the_chessboard[i-f][j] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i-f][j] += 1
								attack_piece_black_on_the_chessboard[i-f-1][j] += 1
								break
						
						else:
							attack_piece_black_on_the_chessboard[i-f][j] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i-f][j] += 1
				#attack vers le bas
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j] != "0":

						if position_piece_on_the_chessboard[i+f][j] == "king_white":
							if attack_piece_black_on_the_chessboard[i+f+1][j] <= -1:
								attack_piece_black_on_the_chessboard[i+f][j] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i+f][j] += 1
								attack_piece_black_on_the_chessboard[i+f+1][j] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i+f][j] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i+f][j] += 1
				#attack vers la droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j+f] != "0":
						
						if position_piece_on_the_chessboard[i][j+f] == "king_white":
							if attack_piece_black_on_the_chessboard[i][j+f+1] <= -1:
								attack_piece_black_on_the_chessboard[i][j+f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i][j+f] += 1
								attack_piece_black_on_the_chessboard[i][j+f+1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i][j+f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i][j+f] += 1
				#attack vers la gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j-f] != "0":
						
						if position_piece_on_the_chessboard[i][j-f] == "king_white":
							if attack_piece_black_on_the_chessboard[i][j-f-1] <= -1:
								attack_piece_black_on_the_chessboard[i][j-f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i][j-f] += 1
								attack_piece_black_on_the_chessboard[i][j-f-1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i][j-f] += 1
							break
					else:
						attack_piece_black_on_the_chessboard[i][j-f] += 1
				############################################################
				#attack vers le haut à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j+f] == "king_white":
							if attack_piece_black_on_the_chessboard[i-f-1][j+f+1] <= -1:
								attack_piece_black_on_the_chessboard[i-f][j+f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i-f][j+f] += 1
								attack_piece_black_on_the_chessboard[i-f-1][j+f+1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i-f][j+f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i-f][j+f] += 1
				#attack vers le haut à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j-f] == "king_white":
							if attack_piece_black_on_the_chessboard[i-f-1][j-f-1] <= -1:
								attack_piece_black_on_the_chessboard[i-f][j-f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i-f][j-f] += 1
								attack_piece_black_on_the_chessboard[i-f-1][j-f-1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i-f][j-f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i-f][j-f] += 1
				#attack vers le bas à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j+f] == "king_white":
							if attack_piece_black_on_the_chessboard[i+f+1][j+f+1] <= -1:
								attack_piece_black_on_the_chessboard[i+f][j+f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i+f][j+f] += 1
								attack_piece_black_on_the_chessboard[i+f+1][j+f+1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i+f][j+f] += 1
							break
					else:
						attack_piece_black_on_the_chessboard[i+f][j+f] += 1
				#attack vers le bas à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j-f] == "king_white":
							if attack_piece_black_on_the_chessboard[i+f+1][j-f-1] <= -1:
								attack_piece_black_on_the_chessboard[i+f][j-f] += 1
								break
							else:
								attack_piece_black_on_the_chessboard[i+f][j-f] += 1
								attack_piece_black_on_the_chessboard[i+f+1][j-f-1] += 1
								break
						else:
							attack_piece_black_on_the_chessboard[i+f][j-f] += 1
							break
							
					else:
						attack_piece_black_on_the_chessboard[i+f][j-f] += 1
			
			if position_piece_on_the_chessboard[i][j] == "king_black":
				if position_piece_on_the_chessboard[i-1][j] != "x":
					attack_piece_black_on_the_chessboard[i-1][j] += 1
					
				if position_piece_on_the_chessboard[i-1][j+1] != "x":
					attack_piece_black_on_the_chessboard[i-1][j+1] += 1
				
				if position_piece_on_the_chessboard[i][j+1] != "x":
					attack_piece_black_on_the_chessboard[i][j+1] += 1
					
				if position_piece_on_the_chessboard[i+1][j+1] != "x":
					attack_piece_black_on_the_chessboard[i+1][j+1] += 1
					
				if position_piece_on_the_chessboard[i+1][j] != "x":
					attack_piece_black_on_the_chessboard[i+1][j] += 1
					
				if position_piece_on_the_chessboard[i+1][j-1] != "x":
					attack_piece_black_on_the_chessboard[i+1][j-1] += 1
					
				if position_piece_on_the_chessboard[i][j-1] != "x":
					attack_piece_black_on_the_chessboard[i][j-1] += 1
					
				if position_piece_on_the_chessboard[i-1][j-1] != "x":
					attack_piece_black_on_the_chessboard[i-1][j-1] += 1
				
	print(attack_piece_black_on_the_chessboard[0])
	print(attack_piece_black_on_the_chessboard[1])
	print(attack_piece_black_on_the_chessboard[2])
	print(attack_piece_black_on_the_chessboard[3])
	print(attack_piece_black_on_the_chessboard[4])
	print(attack_piece_black_on_the_chessboard[5])
	print(attack_piece_black_on_the_chessboard[6])
	print(attack_piece_black_on_the_chessboard[7])
	print(attack_piece_black_on_the_chessboard[8])
	print(attack_piece_black_on_the_chessboard[9])
	print(attack_piece_black_on_the_chessboard[10])
	print(attack_piece_black_on_the_chessboard[11])

func attack_pieces_white():
	attack_piece_white_on_the_chessboard = \
	[[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,0,0,0,0,0,0,0,0,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9],
	[-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9]]
	
	for i in range(12):
		for j in range(12):
			if position_piece_on_the_chessboard[i][j] == "pawn_white":
				if position_piece_on_the_chessboard[i-1][j+1] != "x":
					attack_piece_white_on_the_chessboard[i-1][j+1] += 1
					
				if position_piece_on_the_chessboard[i-1][j-1] != "x":
					attack_piece_white_on_the_chessboard[i-1][j-1] += 1
					
			if position_piece_on_the_chessboard[i][j] == "knight_white":
				if position_piece_on_the_chessboard[i-2][j-1] != "x":
					attack_piece_white_on_the_chessboard[i-2][j-1] += 1
					
				if position_piece_on_the_chessboard[i-2][j+1] != "x":
					attack_piece_white_on_the_chessboard[i-2][j+1] += 1
					
				if position_piece_on_the_chessboard[i-1][j+2] != "x":
					attack_piece_white_on_the_chessboard[i-1][j+2] += 1
					
				if position_piece_on_the_chessboard[i+1][j+2] != "x":
					attack_piece_white_on_the_chessboard[i+1][j+2] += 1
					
				if position_piece_on_the_chessboard[i+2][j-1] != "x":
					attack_piece_white_on_the_chessboard[i+2][j-1] += 1
					
				if position_piece_on_the_chessboard[i+2][j+1] != "x":
					attack_piece_white_on_the_chessboard[i+2][j+1] += 1
					
				if position_piece_on_the_chessboard[i-1][j-2] != "x":
					attack_piece_white_on_the_chessboard[i-1][j-2] += 1
					
				if position_piece_on_the_chessboard[i+1][j-2] != "x":
					attack_piece_white_on_the_chessboard[i+1][j-2] += 1
					
			if position_piece_on_the_chessboard[i][j] == "bishop_white":
				#attack vers le haut à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j+f] == "king_black":
							if attack_piece_white_on_the_chessboard[i-f-1][j+f+1] <= -1:
								attack_piece_white_on_the_chessboard[i-f][j+f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i-f][j+f] += 1
								attack_piece_white_on_the_chessboard[i-f-1][j+f+1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i-f][j+f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i-f][j+f] += 1
				#attack vers le haut à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j-f] == "king_black":
							if attack_piece_white_on_the_chessboard[i-f-1][j-f-1] <= -1:
								attack_piece_white_on_the_chessboard[i-f][j-f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i-f][j-f] += 1
								attack_piece_white_on_the_chessboard[i-f-1][j-f-1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i-f][j-f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i-f][j-f] += 1
				#attack vers le bas à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j+f] == "king_black":
							if attack_piece_white_on_the_chessboard[i+f+1][j+f+1] <= -1:
								attack_piece_white_on_the_chessboard[i+f][j+f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i+f][j+f] += 1
								attack_piece_white_on_the_chessboard[i+f+1][j+f+1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i+f][j+f] += 1
							break
					else:
						attack_piece_white_on_the_chessboard[i+f][j+f] += 1
				#attack vers le bas à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j-f] == "king_black":
							if attack_piece_white_on_the_chessboard[i+f+1][j-f-1] <= -1:
								attack_piece_white_on_the_chessboard[i+f][j-f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i+f][j-f] += 1
								attack_piece_white_on_the_chessboard[i+f+1][j-f-1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i+f][j-f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i+f][j-f] += 1
			
			if position_piece_on_the_chessboard[i][j] == "rook_white":
				#attack vers le haut
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j] != "0":

						if position_piece_on_the_chessboard[i-f][j] == "king_black":
							if attack_piece_white_on_the_chessboard[i-f-1][j] <= -1:
								attack_piece_white_on_the_chessboard[i-f][j] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i-f][j] += 1
								attack_piece_white_on_the_chessboard[i-f-1][j] += 1
								break
						
						else:
							attack_piece_white_on_the_chessboard[i-f][j] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i-f][j] += 1
				#attack vers le bas
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j] != "0":

						if position_piece_on_the_chessboard[i+f][j] == "king_black":
							if attack_piece_white_on_the_chessboard[i+f+1][j] <= -1:
								attack_piece_white_on_the_chessboard[i+f][j] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i+f][j] += 1
								attack_piece_white_on_the_chessboard[i+f+1][j] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i+f][j] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i+f][j] += 1
				#attack vers la droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j+f] != "0":
						
						if position_piece_on_the_chessboard[i][j+f] == "king_black":
							if attack_piece_white_on_the_chessboard[i][j+f+1] <= -1:
								attack_piece_white_on_the_chessboard[i][j+f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i][j+f] += 1
								attack_piece_white_on_the_chessboard[i][j+f+1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i][j+f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i][j+f] += 1
				#attack vers la gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j-f] != "0":
						
						if position_piece_on_the_chessboard[i][j-f] == "king_black":
							if attack_piece_white_on_the_chessboard[i][j-f-1] <= -1:
								attack_piece_white_on_the_chessboard[i][j-f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i][j-f] += 1
								attack_piece_white_on_the_chessboard[i][j-f-1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i][j-f] += 1
							break
					else:
						attack_piece_white_on_the_chessboard[i][j-f] += 1
				
			if position_piece_on_the_chessboard[i][j] == "queen_white":
				#attack vers le haut
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j] != "0":

						if position_piece_on_the_chessboard[i-f][j] == "king_black":
							if attack_piece_white_on_the_chessboard[i-f-1][j] <= -1:
								attack_piece_white_on_the_chessboard[i-f][j] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i-f][j] += 1
								attack_piece_white_on_the_chessboard[i-f-1][j] += 1
								break
						
						else:
							attack_piece_white_on_the_chessboard[i-f][j] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i-f][j] += 1
				#attack vers le bas
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j] != "0":

						if position_piece_on_the_chessboard[i+f][j] == "king_black":
							if attack_piece_white_on_the_chessboard[i+f+1][j] <= -1:
								attack_piece_white_on_the_chessboard[i+f][j] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i+f][j] += 1
								attack_piece_white_on_the_chessboard[i+f+1][j] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i+f][j] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i+f][j] += 1
				#attack vers la droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j+f] != "0":
						
						if position_piece_on_the_chessboard[i][j+f] == "king_black":
							if attack_piece_white_on_the_chessboard[i][j+f+1] <= -1:
								attack_piece_white_on_the_chessboard[i][j+f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i][j+f] += 1
								attack_piece_white_on_the_chessboard[i][j+f+1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i][j+f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i][j+f] += 1
				#attack vers la gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i][j-f] != "0":
						
						if position_piece_on_the_chessboard[i][j-f] == "king_black":
							if attack_piece_white_on_the_chessboard[i][j-f-1] <= -1:
								attack_piece_white_on_the_chessboard[i][j-f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i][j-f] += 1
								attack_piece_white_on_the_chessboard[i][j-f-1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i][j-f] += 1
							break
					else:
						attack_piece_white_on_the_chessboard[i][j-f] += 1
				############################################################
				#attack vers le haut à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j+f] == "king_black":
							if attack_piece_white_on_the_chessboard[i-f-1][j+f+1] <= -1:
								attack_piece_white_on_the_chessboard[i-f][j+f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i-f][j+f] += 1
								attack_piece_white_on_the_chessboard[i-f-1][j+f+1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i-f][j+f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i-f][j+f] += 1
				#attack vers le haut à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i-f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i-f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i-f][j-f] == "king_black":
							if attack_piece_white_on_the_chessboard[i-f-1][j-f-1] <= -1:
								attack_piece_white_on_the_chessboard[i-f][j-f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i-f][j-f] += 1
								attack_piece_white_on_the_chessboard[i-f-1][j-f-1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i-f][j-f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i-f][j-f] += 1
				#attack vers le bas à droite
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j+f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j+f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j+f] == "king_black":
							if attack_piece_white_on_the_chessboard[i+f+1][j+f+1] <= -1:
								attack_piece_white_on_the_chessboard[i+f][j+f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i+f][j+f] += 1
								attack_piece_white_on_the_chessboard[i+f+1][j+f+1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i+f][j+f] += 1
							break
					else:
						attack_piece_white_on_the_chessboard[i+f][j+f] += 1
				#attack vers le bas à gauche
				for f in range(1,9):
					if position_piece_on_the_chessboard[i+f][j-f] == "x":
						break
					elif position_piece_on_the_chessboard[i+f][j-f] != "0":
						
						if position_piece_on_the_chessboard[i+f][j-f] == "king_black":
							if attack_piece_white_on_the_chessboard[i+f+1][j-f-1] <= -1:
								attack_piece_white_on_the_chessboard[i+f][j-f] += 1
								break
							else:
								attack_piece_white_on_the_chessboard[i+f][j-f] += 1
								attack_piece_white_on_the_chessboard[i+f+1][j-f-1] += 1
								break
						else:
							attack_piece_white_on_the_chessboard[i+f][j-f] += 1
							break
							
					else:
						attack_piece_white_on_the_chessboard[i+f][j-f] += 1
			
			if position_piece_on_the_chessboard[i][j] == "king_white":
				if position_piece_on_the_chessboard[i-1][j] != "x":
					attack_piece_white_on_the_chessboard[i-1][j] += 1
					
				if position_piece_on_the_chessboard[i-1][j+1] != "x":
					attack_piece_white_on_the_chessboard[i-1][j+1] += 1
				
				if position_piece_on_the_chessboard[i][j+1] != "x":
					attack_piece_white_on_the_chessboard[i][j+1] += 1
					
				if position_piece_on_the_chessboard[i+1][j+1] != "x":
					attack_piece_white_on_the_chessboard[i+1][j+1] += 1
					
				if position_piece_on_the_chessboard[i+1][j] != "x":
					attack_piece_white_on_the_chessboard[i+1][j] += 1
					
				if position_piece_on_the_chessboard[i+1][j-1] != "x":
					attack_piece_white_on_the_chessboard[i+1][j-1] += 1
					
				if position_piece_on_the_chessboard[i][j-1] != "x":
					attack_piece_white_on_the_chessboard[i][j-1] += 1
					
				if position_piece_on_the_chessboard[i-1][j-1] != "x":
					attack_piece_white_on_the_chessboard[i-1][j-1] += 1
				
	print(attack_piece_white_on_the_chessboard[0])
	print(attack_piece_white_on_the_chessboard[1])
	print(attack_piece_white_on_the_chessboard[2])
	print(attack_piece_white_on_the_chessboard[3])
	print(attack_piece_white_on_the_chessboard[4])
	print(attack_piece_white_on_the_chessboard[5])
	print(attack_piece_white_on_the_chessboard[6])
	print(attack_piece_white_on_the_chessboard[7])
	print(attack_piece_white_on_the_chessboard[8])
	print(attack_piece_white_on_the_chessboard[9])
	print(attack_piece_white_on_the_chessboard[10])
	print(attack_piece_white_on_the_chessboard[11])

func checking_direction_of_attack():
	#Vérifier dans quelle direction vient l'attaque
	#Pawn
		#Vers le haut à droite
		if position_piece_on_the_chessboard[i-1][j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[i-1][j+1] != "0":
			
			if position_piece_on_the_chessboard[i-1][j+1] == "Pawn_black":
				attacker_position_i = i-1
				attacker_position_j = j+1
				direction_of_attack = "Haut/Droite"
				
		#Vers le haut à gauche
		if position_piece_on_the_chessboard[i-1][j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[i-1][j-1] != "0":
			
			if position_piece_on_the_chessboard[i-1][j-1] == "Pawn_black":
				attacker_position_i = i-1
				attacker_position_j = j-1
				direction_of_attack = "Haut/Gauche"
				
		#Vers le haut
		for f in range(1,9):
			if position_piece_on_the_chessboard[i-f][j] == "x":
				break
			elif position_piece_on_the_chessboard[i-f][j] != "0":
				
				if position_piece_on_the_chessboard[i-f][j] == "rook_black"\
				or position_piece_on_the_chessboard[i-f][j] == "queen_black":
					attacker_position_i = i-f
					attacker_position_j = j
					direction_of_attack = "Haut"
					break
				else:
					break
		#Vers le bas
		for f in range(1,9):
			if position_piece_on_the_chessboard[i+f][j] == "x":
				break
			elif position_piece_on_the_chessboard[i+f][j] != "0":
				
				if position_piece_on_the_chessboard[i+f][j] == "rook_black"\
				or position_piece_on_the_chessboard[i+f][j] == "queen_black":
					attacker_position_i = i+f
					attacker_position_j = j
					direction_of_attack = "Bas"
					break
				else:
					break
		#Vers la droite
		for f in range(1,9):
			if position_piece_on_the_chessboard[i][j+f] == "x":
				break
			elif position_piece_on_the_chessboard[i][j+f] != "0":
				
				if position_piece_on_the_chessboard[i][j+f] == "rook_black"\
				or position_piece_on_the_chessboard[i][j+f] == "queen_black":
					attacker_position_i = i
					attacker_position_j = j+f
					direction_of_attack = "Droite"
					break
				else:
					break
		#Vers la gauche
		for f in range(1,9):
			if position_piece_on_the_chessboard[i][j-f] == "x":
				break
			elif position_piece_on_the_chessboard[i][j-f] != "0":
				
				if position_piece_on_the_chessboard[i][j-f] == "rook_black"\
				or position_piece_on_the_chessboard[i][j-f] == "queen_black":
					attacker_position_i = i
					attacker_position_j = j-f
					direction_of_attack = "Gauche"
					break
				else:
					break
		#########################################################################
		#Vers le haut à droite
		for f in range(1,9):
			if position_piece_on_the_chessboard[i-f][j+f] == "x":
				break
			elif position_piece_on_the_chessboard[i-f][j+f] != "0":
				
				if position_piece_on_the_chessboard[i-f][j+f] == "bishop_black"\
				or position_piece_on_the_chessboard[i-f][j+f] == "queen_black":
					attacker_position_i = i-f
					attacker_position_j = j+f
					direction_of_attack = "Haut/Droite"
					break
				else:
					break
		#Vers le haut à gauche
		for f in range(1,9):
			if position_piece_on_the_chessboard[i-f][j-f] == "x":
				break
			elif position_piece_on_the_chessboard[i-f][j-f] != "0":
				
				if position_piece_on_the_chessboard[i-f][j-f] == "bishop_black"\
				or position_piece_on_the_chessboard[i-f][j-f] == "queen_black":
					attacker_position_i = i-f
					attacker_position_j = j-f
					direction_of_attack = "Haut/Gauche"
					break
				else:
					break
		#Vers le bas à droite
		for f in range(1,9):
			if position_piece_on_the_chessboard[i+f][j+f] == "x":
				break
			elif position_piece_on_the_chessboard[i+f][j+f] != "0":
				
				if position_piece_on_the_chessboard[i+f][j+f] == "bishop_black"\
				or position_piece_on_the_chessboard[i+f][j+f] == "queen_black":
					attacker_position_i = i+f
					attacker_position_j = j+f
					direction_of_attack = "Bas/Droite"
					break
				else:
					break
		#Vers le bas à gauche
		for f in range(1,9):
			if position_piece_on_the_chessboard[i+f][j-f] == "x":
				break
			elif position_piece_on_the_chessboard[i+f][j-f] != "0":
				
				if position_piece_on_the_chessboard[i+f][j-f] == "bishop_black"\
				or position_piece_on_the_chessboard[i+f][j-f] == "queen_black":
					attacker_position_i = i+f
					attacker_position_j = j-f
					direction_of_attack = "Bas/Gauche"
					
					break
				else:
					break
		
		##########################################################################
		##########################################################################
		#Déplacement en haut à droite
		if position_piece_on_the_chessboard[i-2][j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[i-2][j+1] != "0":
			
			if position_piece_on_the_chessboard[i-2][j+1] == "knight_black":
				attacker_position_i = i-2
				attacker_position_j = j+1
				direction_of_attack = "Cavalier"
				
		#Déplacement en haut à gauche
		if position_piece_on_the_chessboard[i-2][j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[i-2][j-1] != "0":
			
			if position_piece_on_the_chessboard[i-2][j-1] == "knight_black":
				attacker_position_i = i-2
				attacker_position_j = j-1
				direction_of_attack = "Cavalier"
				
		#Déplacement vers la droite en haut
		if position_piece_on_the_chessboard[i-1][j+2] == "x":
			pass
		elif position_piece_on_the_chessboard[i-1][j+2] != "0":
			
			if position_piece_on_the_chessboard[i-1][j+2] == "knight_black":
				attacker_position_i = i-1
				attacker_position_j = j+2
				direction_of_attack = "Cavalier"
				
		#Déplacement vers la droite en bas
		if position_piece_on_the_chessboard[i+1][j+2] == "x":
			pass
		elif position_piece_on_the_chessboard[i+1][j+2] != "0":
			
			if position_piece_on_the_chessboard[i+1][j+2] == "knight_black":
				attacker_position_i = i+1
				attacker_position_j = j+2
				direction_of_attack = "Cavalier"
				
		#Déplacement en bas à droite
		if position_piece_on_the_chessboard[i+2][j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[i+2][j-1] != "0":
			
			if position_piece_on_the_chessboard[i+2][j-1] == "knight_black":
				attacker_position_i = i+2
				attacker_position_j = j-1
				direction_of_attack = "Cavalier"
				
		#Déplacement en bas à gauche
		if position_piece_on_the_chessboard[i+2][j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[i+2][j+1] != "0":
			
			if position_piece_on_the_chessboard[i+2][j+1] == "knight_black":
				attacker_position_i = i+2
				attacker_position_j = j+1
				direction_of_attack = "Cavalier"
				
		#Déplacement vers la gauche en haut
		if position_piece_on_the_chessboard[i-1][j-2] == "x":
			pass
		elif position_piece_on_the_chessboard[i-1][j-2] != "0":
			
			if position_piece_on_the_chessboard[i-1][j-2] == "knight_black":
				attacker_position_i = i-1
				attacker_position_j = j-2
				direction_of_attack = "Cavalier"
				
		#Déplacement vers la gauche en bas
		if position_piece_on_the_chessboard[i+1][j-2] == "x":
			pass
		elif position_piece_on_the_chessboard[i+1][j-2] != "0":
			
			if position_piece_on_the_chessboard[i+1][j-2] == "knight_black":
				attacker_position_i = i+1
				attacker_position_j = j-2
				direction_of_attack = "Cavalier"
		
		print("attacker_position_i sans +/-f: ", attacker_position_i)
		print("attacker_position_j sans +/-f: ", attacker_position_j)

func attack_coming_up():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut, on descend chaque case jusqu'au roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j])
			if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j] != "king_white":
				#vers le haut
				if attacker_position_i+f == attacker_position_i:
					for ff in range(1,9):
						print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j] != "0":
							print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j])
							if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j] == "rook_white"\
							or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j
								
								var defenseur_position_i = attacker_position_i-ff+f
								var defenseur_position_j = attacker_position_j
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers la droite
				for ff in range(1,9):
					print("ffd: ",position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff])
					if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff] != "0":
						print("fffd: ",position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff])
						if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i+f
							var defenseur_position_j = attacker_position_j+ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				for ff in range(1,9):
					print("ffg: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff])
					if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff] != "0":
						print("fffg: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff])
						if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i+f
							var defenseur_position_j = attacker_position_j-ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff])
					if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff] != "0":
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i-ff+f
							var defenseur_position_j = attacker_position_j+ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le haut à gauche
				for ff in range(1,9):
					print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff])
					if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff] != "0":
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i-ff+f
							var defenseur_position_j = attacker_position_j-ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff])
						if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff])
							if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j
								
								var defenseur_position_i = attacker_position_i+ff+f
								var defenseur_position_j = attacker_position_j+ff
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff])
						if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff])
							if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j
								
								var defenseur_position_i = attacker_position_i+ff+f
								var defenseur_position_j = attacker_position_j-ff
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
			#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j+1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j+1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j+1])
					if position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j+1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f-2
						var defenseur_position_j = attacker_position_j+1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j-1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j-1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j-1])
					if position_piece_on_the_chessboard[attacker_position_i+f-2][attacker_position_j-1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f-2
						var defenseur_position_j = attacker_position_j-1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j+2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j+2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j+2])
					if position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j+2] == "knight_white"\
					or position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j+2] == "queen_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f-1
						var defenseur_position_j = attacker_position_j+2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j+2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j+2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j+2])
					if position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j+2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f+1
						var defenseur_position_j = attacker_position_j+2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j+1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j+1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j+1])
					if position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j+1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f+2
						var defenseur_position_j = attacker_position_j+1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j-1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j-1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j-1])
					if position_piece_on_the_chessboard[attacker_position_i+f+2][attacker_position_j-1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f+2
						var defenseur_position_j = attacker_position_j-1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j-2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j-2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j-2])
					if position_piece_on_the_chessboard[attacker_position_i+f-1][attacker_position_j-2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f-1
						var defenseur_position_j = attacker_position_j-2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j-2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j-2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j-2])
					if position_piece_on_the_chessboard[attacker_position_i+f+1][attacker_position_j-2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+f+1
						var defenseur_position_j = attacker_position_j-2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_down():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas, on monte chaque case jusqu'au roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j])
			if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j] != "king_white":
				#vers le bas
				if attacker_position_i-f == attacker_position_i:
					for ff in range(1,9):
						print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j] != "0":
							print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j])
							if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j] == "rook_white"\
							or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j
								
								var defenseur_position_i = attacker_position_i-ff-f
								var defenseur_position_j = attacker_position_j
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers la droite
				for ff in range(1,9):
					print("ffd: ",position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff])
					if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff] != "0":
						print("fffd: ",position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff])
						if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i-f
							var defenseur_position_j = attacker_position_j+ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				for ff in range(1,9):
					print("ffg: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff])
					if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff] != "0":
						print("fffg: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff])
						if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i-f
							var defenseur_position_j = attacker_position_j-ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
			#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff])
					if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff] != "0":
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i-ff-f
							var defenseur_position_j = attacker_position_j+ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le haut à gauche
				for ff in range(1,9):
					print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff])
					if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff] != "0":
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j
							
							var defenseur_position_i = attacker_position_i-ff-f
							var defenseur_position_j = attacker_position_j-ff
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff])
							if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j
								
								var defenseur_position_i = attacker_position_i+ff-f
								var defenseur_position_j = attacker_position_j+ff
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff])
							if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j
								
								var defenseur_position_i = attacker_position_i+ff-f
								var defenseur_position_j = attacker_position_j-ff
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
			#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j+1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j+1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j+1])
					if position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j+1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f-2
						var defenseur_position_j = attacker_position_j+1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j-1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j-1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j-1])
					if position_piece_on_the_chessboard[attacker_position_i-f-2][attacker_position_j-1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f-2
						var defenseur_position_j = attacker_position_j-1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j+2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j+2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j+2])
					if position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j+2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f-1
						var defenseur_position_j = attacker_position_j+2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j+2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j+2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j+2])
					if position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j+2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f+1
						var defenseur_position_j = attacker_position_j+2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j+1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j+1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j+1])
					if position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j+1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f+2
						var defenseur_position_j = attacker_position_j+1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j-1] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j-1] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j-1])
					if position_piece_on_the_chessboard[attacker_position_i-f+2][attacker_position_j-1] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f+2
						var defenseur_position_j = attacker_position_j-1
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j-2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j-2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j-2])
					if position_piece_on_the_chessboard[attacker_position_i-f-1][attacker_position_j-2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f-1
						var defenseur_position_j = attacker_position_j-2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j-2] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j-2] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j-2])
					if position_piece_on_the_chessboard[attacker_position_i-f+1][attacker_position_j-2] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i-f+1
						var defenseur_position_j = attacker_position_j-2
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break
	
func attack_coming_right():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant de la droite, on va vers la gauche pour trouver le roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-f])
			if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-f] != "king_white":
				#vers le haut
				for ff in range(1,9):
					print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-f] != "0":
						print("fffh: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas
				for ff in range(1,9):
					print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f])
					if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f] != "0":
						print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+ff
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-f] == "pawn_white"\
						and ff < 3:
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+ff
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				if attacker_position_j-f == attacker_position_j:
					for ff in range(1,9):
						print("ffd: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff-f] != "0":
							print("fffd: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff-f])
							if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff-f] == "rook_white"\
							or position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i
								var defenseur_position_j = attacker_position_j-ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
								defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
			#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff-f] != "0":
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff-f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff
							var defenseur_position_j = attacker_position_j+ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le haut à gauche
				for ff in range(1,9):
					print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff-f] != "0":
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff-f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff
							var defenseur_position_j = attacker_position_j-ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff-f] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff-f])
							if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff-f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i+ff
								var defenseur_position_j = attacker_position_j+ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff-f] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff-f])
							if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff-f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i+ff
								var defenseur_position_j = attacker_position_j-ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
			#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1-f])
					if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-2
						var defenseur_position_j = attacker_position_j+1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1-f])
					if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-2
						var defenseur_position_j = attacker_position_j-1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2-f])
					if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-1
						var defenseur_position_j = attacker_position_j+2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2-f])
					if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+1
						var defenseur_position_j = attacker_position_j+2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1-f])
					if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+2
						var defenseur_position_j = attacker_position_j+1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1-f])
					if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+2
						var defenseur_position_j = attacker_position_j-1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2-f])
					if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-1
						var defenseur_position_j = attacker_position_j-2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2-f])
					if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+1
						var defenseur_position_j = attacker_position_j-2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_left():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant de la gauche, on va vers la droite pour trouver le roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+f])
			if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+f] != "king_white":
				#vers le haut
				for ff in range(1,9):
					print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+f] != "0":
						print("fffh: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas
				for ff in range(1,9):
					print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f])
					if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f] != "0":
						print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+ff
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+f] == "pawn_white"\
						and ff < 3:
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+ff
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				if attacker_position_j+f == attacker_position_j:
					for ff in range(1,9):
						print("ffg: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff+f] != "0":
							print("fffg: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff+f])
							if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff+f] == "rook_white"\
							or position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i
								var defenseur_position_j = attacker_position_j-ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
								defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
			#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff+f] != "0":
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff+f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff
							var defenseur_position_j = attacker_position_j+ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le haut à gauche
				for ff in range(1,9):
					print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff+f] != "0":
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff+f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff
							var defenseur_position_j = attacker_position_j-ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff+f] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff+f])
							if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff+f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i+ff
								var defenseur_position_j = attacker_position_j+ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff+f] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff+f])
							if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff+f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i+ff
								var defenseur_position_j = attacker_position_j-ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
		#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1+f])
					if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-2
						var defenseur_position_j = attacker_position_j+1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1+f])
					if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-2
						var defenseur_position_j = attacker_position_j-1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2+f])
					if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-1
						var defenseur_position_j = attacker_position_j+2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2+f])
					if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+1
						var defenseur_position_j = attacker_position_j+2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1+f])
					if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+2
						var defenseur_position_j = attacker_position_j+1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1+f])
					if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+2
						var defenseur_position_j = attacker_position_j-1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2+f])
					if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-1
						var defenseur_position_j = attacker_position_j-2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2+f])
					if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+1
						var defenseur_position_j = attacker_position_j-2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_up_right():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut à droite, on va vers bas à gauche pour trouver le roi
	#Pawns
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes 
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-f])
			if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-f] != "king_white":
				#vers le haut
				for ff in range(1,9):
					print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-f] != "0":
						print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff+f
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas
				for ff in range(1,9):
					print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f])
					if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f] != "0":
						print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+ff+f
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-f] == "pawn_white"\
						and ff < 3:
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+ff+f
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la droite
				for ff in range(1,9):
					print("ffd: ",position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff-f])
					if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff-f] != "0":
						print("fffd: ",position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+f
							var defenseur_position_j = attacker_position_j+ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				for ff in range(1,9):
					print("ffg: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff-f])
					if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff-f] != "0":
						print("fffg: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+f
							var defenseur_position_j = attacker_position_j-ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
			#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					if attacker_position_i+f == attacker_position_i and attacker_position_j-f == attacker_position_j:
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f] != "0":
							print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f])
							if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i-ff+f
								var defenseur_position_j = attacker_position_j+ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le haut à gauche
				for ff in range(1,9):
					print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff-f] != "0":
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff-f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff+f
							var defenseur_position_j = attacker_position_j-ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff-f] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff-f])
							if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff-f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i+ff+f
								var defenseur_position_j = attacker_position_j+ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
		#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1-f])
					if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-2+f
						var defenseur_position_j = attacker_position_j+1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1-f])
					if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-2+f
						var defenseur_position_j = attacker_position_j-1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2-f])
					if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-1+f
						var defenseur_position_j = attacker_position_j+2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2-f])
					if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+1+f
						var defenseur_position_j = attacker_position_j+2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1-f])
					if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+2+f
						var defenseur_position_j = attacker_position_j+1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1-f])
					if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+2+f
						var defenseur_position_j = attacker_position_j-1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2-f])
					if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-1+f
						var defenseur_position_j = attacker_position_j-2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2-f])
					if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+1+f
						var defenseur_position_j = attacker_position_j-2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_up_left():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut à gauche, on va vers bas à droite pour trouver le roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes 
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+f])
			if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+f] != "king_white":
				#vers le haut
				for ff in range(1,9):
					print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+f] != "0":
						print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff+f
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas
				for ff in range(1,9):
					print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f])
					if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f] != "0":
						print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+ff+f
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j+f] == "pawn_white"\
						and ff < 3:
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+ff+f
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la droite
				for ff in range(1,9):
					print("ffd: ",position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff+f])
					if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff+f] != "0":
						print("fffd: ",position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j+ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+f
							var defenseur_position_j = attacker_position_j+ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				for ff in range(1,9):
					print("ffg: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff+f])
					if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff+f] != "0":
						print("fffg: ", position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+f][attacker_position_j-ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+f
							var defenseur_position_j = attacker_position_j-ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
			#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f] != "0":
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j+ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i+f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff+f
							var defenseur_position_j = attacker_position_j+ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le haut à gauche
				if attacker_position_i+f == attacker_position_i and attacker_position_j+f == attacker_position_j:
					for ff in range(1,9):
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff+f] != "0":
							print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff+f])
							if position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff+f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i-ff+f][attacker_position_j-ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i-ff+f
								var defenseur_position_j = attacker_position_j-ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff+f] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff+f])
							if position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff+f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff+f][attacker_position_j-ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i+f
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i+ff+f
								var defenseur_position_j = attacker_position_j-ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
		#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1+f])
					if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j+1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-2+f
						var defenseur_position_j = attacker_position_j+1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1+f])
					if position_piece_on_the_chessboard[attacker_position_i-2+f][attacker_position_j-1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-2+f
						var defenseur_position_j = attacker_position_j-1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2+f])
					if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j+2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-1+f
						var defenseur_position_j = attacker_position_j+2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2+f])
					if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j+2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+1+f
						var defenseur_position_j = attacker_position_j+2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1+f])
					if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j+1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+2+f
						var defenseur_position_j = attacker_position_j+1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1+f])
					if position_piece_on_the_chessboard[attacker_position_i+2+f][attacker_position_j-1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+2+f
						var defenseur_position_j = attacker_position_j-1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2+f])
					if position_piece_on_the_chessboard[attacker_position_i-1+f][attacker_position_j-2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-1+f
						var defenseur_position_j = attacker_position_j-2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2+f])
					if position_piece_on_the_chessboard[attacker_position_i+1+f][attacker_position_j-2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i+f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+1+f
						var defenseur_position_j = attacker_position_j-2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_down_right():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas à droite, on va vers haut à gauche pour trouver le roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes 
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-f])
			if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-f] != "king_white":
				#vers le haut
				for ff in range(1,9):
					print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-f] != "0":
						print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff-f
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas
				for ff in range(1,9):
					print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f])
					if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f] != "0":
						print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+ff-f
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-f] == "pawn_white"\
						and ff < 3:
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i+ff-f
							var defenseur_position_j = attacker_position_j-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la droite
				for ff in range(1,9):
					print("ffd: ",position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff-f])
					if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff-f] != "0":
						print("fffd: ",position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-f
							var defenseur_position_j = attacker_position_j+ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				for ff in range(1,9):
					print("ffg: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff-f])
					if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff-f] != "0":
						print("fffg: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff-f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-f
							var defenseur_position_j = attacker_position_j-ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
			#Diagonales
				#vers le haut à droite
				for ff in range(1,9):
					print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff-f])
					if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff-f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff-f] != "0":
						print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff-f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+ff-f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j-f
							
							var defenseur_position_i = attacker_position_i-ff-f
							var defenseur_position_j = attacker_position_j+ff-f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
					if attacker_position_i-f == attacker_position_i and attacker_position_j-f == attacker_position_j:
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff-f] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff-f])
							if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff-f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i+ff-f
								var defenseur_position_j = attacker_position_j+ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff-f])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff-f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff-f] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff-f])
							if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff-f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff-f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j-f
								
								var defenseur_position_i = attacker_position_i+ff-f
								var defenseur_position_j = attacker_position_j-ff-f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
		#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1-f])
					if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-2-f
						var defenseur_position_j = attacker_position_j+1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1-f])
					if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-2-f
						var defenseur_position_j = attacker_position_j-1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2-f])
					if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-1-f
						var defenseur_position_j = attacker_position_j+2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2-f])
					if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+1-f
						var defenseur_position_j = attacker_position_j+2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1-f])
					if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+2-f
						var defenseur_position_j = attacker_position_j+1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1-f])
					if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+2-f
						var defenseur_position_j = attacker_position_j-1-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2-f])
					if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i-1-f
						var defenseur_position_j = attacker_position_j-2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2-f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2-f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2-f])
					if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2-f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j-f
						
						var defenseur_position_i = attacker_position_i+1-f
						var defenseur_position_j = attacker_position_j-2-f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_down_left():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas à gauche, on va vers haut à droite pour trouver le roi
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes 
		for f in range(9):
			print("f: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+f])
			if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+f] != "king_white":
				#vers le haut
				for ff in range(1,9):
					print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+f] != "0":
						print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff-f
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas
				for ff in range(1,9):
					print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f])
					if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f] != "0":
						print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+ff-f
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+f] == "pawn_white"\
						and ff < 3:
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i+ff-f
							var defenseur_position_j = attacker_position_j+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la droite
				for ff in range(1,9):
					print("ffd: ",position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff+f])
					if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff+f] != "0":
						print("fffd: ",position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j+ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-f
							var defenseur_position_j = attacker_position_j+ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers la gauche
				for ff in range(1,9):
					print("ffg: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff+f])
					if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff+f] != "0":
						print("fffg: ", position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff+f] == "rook_white"\
						or position_piece_on_the_chessboard[attacker_position_i-f][attacker_position_j-ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-f
							var defenseur_position_j = attacker_position_j-ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
							defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
			#Diagonales
				#vers le haut à gauche
				for ff in range(1,9):
					print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff+f])
					if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff+f] == "x":
						break
					elif position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff+f] != "0":
						print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff+f] == "bishop_white"\
						or position_piece_on_the_chessboard[attacker_position_i-ff-f][attacker_position_j-ff+f] == "queen_white":
							var attacker_position_shift_i = attacker_position_i-f
							var attacker_position_shift_j = attacker_position_j+f
							
							var defenseur_position_i = attacker_position_i-ff-f
							var defenseur_position_j = attacker_position_j-ff+f
							piece_protect_the_king = true
							emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
							,defenseur_position_i,defenseur_position_j,direction_of_attack)
							break
						else:
							break
				#vers le bas à droite
				for ff in range(1,9):
						print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff+f] != "0":
							print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff+f])
							if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff+f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j+ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i+ff-f
								var defenseur_position_j = attacker_position_j+ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
				#vers le bas à gauche
				for ff in range(1,9):
					if attacker_position_i-f == attacker_position_i and attacker_position_j+f == attacker_position_j:
						print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff+f])
						if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff+f] == "x":
							break
						elif position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff+f] != "0":
							print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff+f])
							if position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff+f] == "bishop_white"\
							or position_piece_on_the_chessboard[attacker_position_i+ff-f][attacker_position_j-ff+f] == "queen_white":
								var attacker_position_shift_i = attacker_position_i-f
								var attacker_position_shift_j = attacker_position_j+f
								
								var defenseur_position_i = attacker_position_i+ff-f
								var defenseur_position_j = attacker_position_j-ff+f
								piece_protect_the_king = true
								emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
								,defenseur_position_i,defenseur_position_j,direction_of_attack)
								break
							else:
								break
		#Mouvement Cavalier
				#En haut à droite
				if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1+f])
					if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j+1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-2-f
						var defenseur_position_j = attacker_position_j+1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En haut à gauche
				if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1+f])
					if position_piece_on_the_chessboard[attacker_position_i-2-f][attacker_position_j-1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-2-f
						var defenseur_position_j = attacker_position_j-1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en haut
				if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2+f])
					if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j+2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-1-f
						var defenseur_position_j = attacker_position_j+2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A droite en bas
				if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2+f])
					if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j+2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+1-f
						var defenseur_position_j = attacker_position_j+2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à droite
				if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1+f])
					if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j+1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+2-f
						var defenseur_position_j = attacker_position_j+1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#En bas à gauche
				if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1+f])
					if position_piece_on_the_chessboard[attacker_position_i+2-f][attacker_position_j-1+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+2-f
						var defenseur_position_j = attacker_position_j-1+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en haut
				if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2+f])
					if position_piece_on_the_chessboard[attacker_position_i-1-f][attacker_position_j-2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i-1-f
						var defenseur_position_j = attacker_position_j-2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
				#A gauche en bas
				if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2+f] == "x":
					pass
				elif position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2+f] != "0":
					print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2+f])
					if position_piece_on_the_chessboard[attacker_position_i+1-f][attacker_position_j-2+f] == "knight_white":
						var attacker_position_shift_i = attacker_position_i-f
						var attacker_position_shift_j = attacker_position_j+f
						
						var defenseur_position_i = attacker_position_i+1-f
						var defenseur_position_j = attacker_position_j-2+f
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
			else:
				break

func attack_coming_knight():
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du cavalier, on cherche qui peut le prendre
	#Pawns
		#Vers le bas à droite
		print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] != "0":
			print("ffpbd: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#Vers le bas à gauche
		print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] != "0":
			print("ffpbg: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-1] == "pawn_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
	#Lignes 
		#vers le haut
		for ff in range(1,9):
			print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j])
			if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j] == "x":
				break
			elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j] != "0":
				print("ffh: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j])
				if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j] == "queen_white":
					var attacker_position_shift_i = attacker_position_i
					var attacker_position_shift_j = attacker_position_j
					
					var defenseur_position_i = attacker_position_i-ff
					var defenseur_position_j = attacker_position_j
					piece_protect_the_king = true
					emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
					,defenseur_position_i,defenseur_position_j,direction_of_attack)
					break
				else:
					break
		#vers le bas
		for ff in range(1,9):
			print("ffb: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j])
			if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j] == "x":
				break
			elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j] != "0":
				print("fffb: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j])
				if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j] == "queen_white":
					var attacker_position_shift_i = attacker_position_i
					var attacker_position_shift_j = attacker_position_j
					
					var defenseur_position_i = attacker_position_i+ff
					var defenseur_position_j = attacker_position_j
					piece_protect_the_king = true
					emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
					defenseur_position_i,defenseur_position_j,direction_of_attack)
					break
				else:
					break
		#vers la droite
		for ff in range(1,9):
			print("ffd: ",position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+ff])
			if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+ff] == "x":
				break
			elif position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+ff] != "0":
				print("fffd: ",position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+ff])
				if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+ff] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_i][attacker_position_j+ff] == "queen_white":
					var attacker_position_shift_i = attacker_position_i
					var attacker_position_shift_j = attacker_position_j
					
					var defenseur_position_i = attacker_position_i
					var defenseur_position_j = attacker_position_j+ff
					piece_protect_the_king = true
					emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
					,defenseur_position_i,defenseur_position_j,direction_of_attack)
					break
				else:
					break
		#vers la gauche
		for ff in range(1,9):
			print("ffg: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff])
			if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff] == "x":
				break
			elif position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff] != "0":
				print("fffg: ", position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff])
				if position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff] == "rook_white"\
				or position_piece_on_the_chessboard[attacker_position_i][attacker_position_j-ff] == "queen_white":
					var attacker_position_shift_i = attacker_position_i
					var attacker_position_shift_j = attacker_position_j
					
					var defenseur_position_i = attacker_position_i
					var defenseur_position_j = attacker_position_j-ff
					piece_protect_the_king = true
					emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j,\
					defenseur_position_i,defenseur_position_j,direction_of_attack)
					break
				else:
					break
		#Diagonales
		#vers le haut à droite
		for ff in range(1,9):
			print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff])
			if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff] == "x":
				break
			elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff] != "0":
				print("ffhd: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff])
				if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff] == "bishop_white"\
				or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j+ff] == "queen_white":
					var attacker_position_shift_i = attacker_position_i
					var attacker_position_shift_j = attacker_position_j
					
					var defenseur_position_i = attacker_position_i-ff
					var defenseur_position_j = attacker_position_j+ff
					piece_protect_the_king = true
					emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
					,defenseur_position_i,defenseur_position_j,direction_of_attack)
					break
				else:
					break
		#vers le haut à gauche
		for ff in range(1,9):
			print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff])
			if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff] == "x":
				break
			elif position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff] != "0":
				print("ffhg: ",position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff])
				if position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff] == "bishop_white"\
				or position_piece_on_the_chessboard[attacker_position_i-ff][attacker_position_j-ff] == "queen_white":
					var attacker_position_shift_i = attacker_position_i
					var attacker_position_shift_j = attacker_position_j
					
					var defenseur_position_i = attacker_position_i-ff
					var defenseur_position_j = attacker_position_j-ff
					piece_protect_the_king = true
					emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
					,defenseur_position_i,defenseur_position_j,direction_of_attack)
					break
				else:
					break
		#vers le bas à droite
		for ff in range(1,9):
				print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff])
				if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff] == "x":
					break
				elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff] != "0":
					print("ffbd: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff])
					if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff] == "bishop_white"\
					or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j+ff] == "queen_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+ff
						var defenseur_position_j = attacker_position_j+ff
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
						break
					else:
						break
		#vers le bas à gauche
		for ff in range(1,9):
				print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff])
				if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff] == "x":
					break
				elif position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff] != "0":
					print("ffbg: ",position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff])
					if position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff] == "bishop_white"\
					or position_piece_on_the_chessboard[attacker_position_i+ff][attacker_position_j-ff] == "queen_white":
						var attacker_position_shift_i = attacker_position_i
						var attacker_position_shift_j = attacker_position_j
						
						var defenseur_position_i = attacker_position_i+ff
						var defenseur_position_j = attacker_position_j-ff
						piece_protect_the_king = true
						emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
						,defenseur_position_i,defenseur_position_j,direction_of_attack)
						break
					else:
						break
	#Mouvement Cavalier
		#En haut à droite
		if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j+1] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i-2
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#En haut à gauche
		if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i-2][attacker_position_j-1] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i-2
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#A droite en haut
		if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2])
			if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j+2] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i-1
				var defenseur_position_j = attacker_position_j+2
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#A droite en bas
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j+2] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j+2
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#En bas à droite
		if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1])
			if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j+1] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+2
				var defenseur_position_j = attacker_position_j+1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#En bas à gauche
		if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1])
			if position_piece_on_the_chessboard[attacker_position_i+2][attacker_position_j-1] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+2
				var defenseur_position_j = attacker_position_j-1
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#A gauche en haut
		if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2])
			if position_piece_on_the_chessboard[attacker_position_i-1][attacker_position_j-2] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i-1
				var defenseur_position_j = attacker_position_j-2
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)
		#A gauche en bas
		if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2] == "x":
			pass
		elif position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2] != "0":
			print("ffc: ",position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2])
			if position_piece_on_the_chessboard[attacker_position_i+1][attacker_position_j-2] == "knight_white":
				var attacker_position_shift_i = attacker_position_i
				var attacker_position_shift_j = attacker_position_j
				
				var defenseur_position_i = attacker_position_i+1
				var defenseur_position_j = attacker_position_j-2
				piece_protect_the_king = true
				emit_signal("check_to_the_king",attacker_position_shift_i,attacker_position_shift_j\
				,defenseur_position_i,defenseur_position_j,direction_of_attack)

func verification_check_and_checkmate():
	if attack_piece_black_on_the_chessboard[i][j] >= 1:
		emit_signal("check_to_the_king",0,0,0,0,0) 
		print("Echec pour le roi blanc")
		
		checking_direction_of_attack()
		print(direction_of_attack)
		
		if direction_of_attack == "Haut":
			attack_coming_up()
		elif direction_of_attack == "Bas":
			attack_coming_down()
		elif direction_of_attack == "Droite":
			attack_coming_right()
		elif direction_of_attack == "Gauche":
			attack_coming_left()
		elif direction_of_attack == "Haut/Droite":
			attack_coming_up_right()
		elif direction_of_attack == "Haut/Gauche":
			attack_coming_up_left()
		elif direction_of_attack == "Bas/Droite":
			attack_coming_down_right()
		elif direction_of_attack == "Bas/Gauche":
			attack_coming_down_left()
		elif direction_of_attack == "Cavalier":
			attack_coming_knight()
		
		print("piece_protect_the_king: ", piece_protect_the_king)
		#On verifie l'échec et mat si aucune pièce ne peut protèger le roi
		if piece_protect_the_king == false:
			if attack_piece_black_on_the_chessboard[i][j] >= 1 \
			and (attack_piece_black_on_the_chessboard[i-1][j] >= 1 or attack_piece_black_on_the_chessboard[i-1][j] <= -1 or position_piece_on_the_chessboard[i-1][j] == "pawn_white" or position_piece_on_the_chessboard[i-1][j] == "knight_white"\
			or position_piece_on_the_chessboard[i-1][j] == "bishop_white" or position_piece_on_the_chessboard[i-1][j] == "rook_white" or position_piece_on_the_chessboard[i-1][j] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i-1][j+1] >= 1 or attack_piece_black_on_the_chessboard[i-1][j+1] <= -1 or position_piece_on_the_chessboard[i-1][j+1] == "pawn_white" or position_piece_on_the_chessboard[i-1][j+1] == "knight_white"\
			or position_piece_on_the_chessboard[i-1][j+1] == "bishop_white" or position_piece_on_the_chessboard[i-1][j+1] == "rook_white" or position_piece_on_the_chessboard[i-1][j+1] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i][j+1] >= 1 or attack_piece_black_on_the_chessboard[i][j+1] <= -1 or position_piece_on_the_chessboard[i][j+1] == "pawn_white" or position_piece_on_the_chessboard[i][j+1] == "knight_white"\
			or position_piece_on_the_chessboard[i][j+1] == "bishop_white" or position_piece_on_the_chessboard[i][j+1] == "rook_white" or position_piece_on_the_chessboard[i][j+1] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i+1][j+1] >= 1 or attack_piece_black_on_the_chessboard[i+1][j+1] <= -1 or position_piece_on_the_chessboard[i+1][j+1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j+1] == "knight_white"\
			or position_piece_on_the_chessboard[i+1][j+1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j+1] == "rook_white" or position_piece_on_the_chessboard[i+1][j+1] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i+1][j] >= 1 or attack_piece_black_on_the_chessboard[i+1][j] <= -1 or position_piece_on_the_chessboard[i+1][j] == "pawn_white" or position_piece_on_the_chessboard[i+1][j] == "knight_white"\
			or position_piece_on_the_chessboard[i+1][j] == "bishop_white" or position_piece_on_the_chessboard[i+1][j] == "rook_white" or position_piece_on_the_chessboard[i+1][j] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i+1][j-1] >= 1 or attack_piece_black_on_the_chessboard[i+1][j-1] <= -1 or position_piece_on_the_chessboard[i+1][j-1] == "pawn_white" or position_piece_on_the_chessboard[i+1][j-1] == "knight_white"\
			or position_piece_on_the_chessboard[i+1][j-1] == "bishop_white" or position_piece_on_the_chessboard[i+1][j-1] == "rook_white" or position_piece_on_the_chessboard[i+1][j-1] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i][j-1] >= 1 or attack_piece_black_on_the_chessboard[i][j-1] <= -1 or position_piece_on_the_chessboard[i][j-1] == "pawn_white" or position_piece_on_the_chessboard[i][j-1] == "knight_white"\
			or position_piece_on_the_chessboard[i][j-1] == "bishop_white" or position_piece_on_the_chessboard[i][j-1] == "rook_white" or position_piece_on_the_chessboard[i][j-1] == "queen_white")\
			and (attack_piece_black_on_the_chessboard[i-1][j-1] >= 1 or attack_piece_black_on_the_chessboard[i-1][j-1] <= -1 or position_piece_on_the_chessboard[i-1][j-1] == "pawn_white" or position_piece_on_the_chessboard[i-1][j-1] == "knight_white"\
			or position_piece_on_the_chessboard[i-1][j-1] == "bishop_white" or position_piece_on_the_chessboard[i-1][j-1] == "rook_white" or position_piece_on_the_chessboard[i-1][j-1] == "queen_white"):
				print("Echec et mat pour le roi blanc")
				checkmate = true
				emit_signal("checkmate_to_the_king",checkmate)
			
	else:
		print("Pas d'echec pour le roi blanc")

