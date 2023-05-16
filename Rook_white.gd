extends Sprite2D

signal opponent_turned #Permet de créer son propre signal

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
var starting_square = true #Si la pièce est sur sa case de départ et n'a fait aucun déplacement
var my_node_id = get_node(".").get_instance_id() #Permet de récupérer l'ID unique du noeud
@onready var my_node_name = get_node(".").get_name() #Permet de récupérer le nom du noeud
var i = 9 # Le i correspond à l'axe y (de gauche à droite)
var j = 2 # Le j correspond à l'axe x (de haut en bas)
var move_one_square = 100
var max_move_up = 8
var max_move_down = 8
var max_move_right = 8
var max_move_left = 8
var king_in_check = false
var can_protect_the_king = false
var piece_protects_against_an_attack = false
var attacker_position_shift_i = 0
var attacker_position_shift_j = 0
var attacker_position_shift2_i = 0
var attacker_position_shift2_j = 0
var direction_of_attack = ""
var direction_attack_protect_king = ""

var update_of_the_protect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ID de ", my_node_name, ": ", my_node_id)
	#Par rapport au nom du noeud récupérer, de lui donner la bonne position dans le tableau
	if my_node_name == "Rook_white":
		i = 9
		j = 2
	elif my_node_name == "Rook_white2":
		i = 9
		j = 9
		
	print("i: ", i)
	print("j: ", j)

func check_max_move_any_direction():
	#Vérifier jusqu'à où la pièce peut se déplacer
	#ATTENTION une boucle commence à zéro (donc sur la case de la pièce elle-même)
	#C'est pour cela le +1 pour lorsqu'il rencontre une pièce
	#Vers le haut
	for f in range(1,9):
		if position_piece_on_the_chessboard[i-f][j] != "0":
			if position_piece_on_the_chessboard[i-f][j] == "x":
				max_move_up = f
				break
			else:
				max_move_up = f + 1
				break
				
	#Vers le bas
	for f in range(1,9):
		if position_piece_on_the_chessboard[i+f][j] != "0":
			if position_piece_on_the_chessboard[i+f][j] == "x":
				max_move_down = f
				break
			else:
				max_move_down = f + 1
				break
				
	#Vers la droite
	for f in range(1,9):
		if position_piece_on_the_chessboard[i][j+f] != "0":
			if position_piece_on_the_chessboard[i][j+f] == "x":
				max_move_right = f
				break
			else:
				max_move_right = f + 1
				break
	
	#Vers la gauche
	for f in range(1,9):
		if position_piece_on_the_chessboard[i][j-f] != "0":
			if position_piece_on_the_chessboard[i][j-f] == "x":
				max_move_left = f
				break
			else:
				max_move_left = f + 1
				break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_turn == "white" and update_of_the_protect == false:
		verif_piece_protects_against_an_attack_the_king()
		update_of_the_protect = true
		
	elif player_turn == "black":
		update_of_the_protect = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	var mouse_pos = get_local_mouse_position()
	if king_in_check == false:
		#Vérifie si la pièce est sur sa case de départ et si c'est le tour des blancs
		if player_turn == "white":
			
			# Pour sélectionner l'ID unique de la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
					
					check_max_move_any_direction()
					print("max_move_up: ",max_move_up)
					print("max_move_down: ",max_move_down)
					print("max_move_right: ",max_move_right)
					print("max_move_left: ",max_move_left)
				
			# Vérifie si c'est bien le bouton gauche de la souris qui est cliquer
			# et que la pièce sélectionner correspond avec l'ID
			elif event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == my_node_name:
				
				if piece_protects_against_an_attack == false:
					#Pour bouger vers le haut
					#Vérifie qu'on clique bien sur la bonne case
					for f in range(max_move_up):
						if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
						and mouse_pos.y >= 0 - f*move_one_square and mouse_pos.y <= texture.get_height() - f*move_one_square \
						and (position_piece_on_the_chessboard[i-f][j] == "0" or position_piece_on_the_chessboard[i-f][j] == "pawn_black"\
						or position_piece_on_the_chessboard[i-f][j] == "knight_black" or position_piece_on_the_chessboard[i-f][j] == "bishop_black"\
						or position_piece_on_the_chessboard[i-f][j] == "rook_black" or position_piece_on_the_chessboard[i-f][j] == "queen_black"):
							#Bouge la pièce de move_one_square = 100 en y
							move_local_y(-f*move_one_square)
							#Met à jour la position de la pièce dans le tableau avant déplacement
							position_piece_on_the_chessboard[i][j] = "0"
							i -= f
							#Met à jour la position de la pièce dans le tableau après déplacement
							position_piece_on_the_chessboard[i][j] = "rook_white"
							starting_square = false
							# Déselectionne la pièce après le déplacement
							piece_select = "No piece selected"
							
							print(piece_select)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
							#Et la position dans le tableau.
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
							
						else:
							piece_select = "No piece selected"
							print(piece_select)
							
					#Pour bouger vers le bas
					#Vérifie qu'on clique bien sur la bonne case
					for f in range(max_move_down):
						if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
						and mouse_pos.y >= 0 + f*move_one_square and mouse_pos.y <= texture.get_height() + f*move_one_square \
						and (position_piece_on_the_chessboard[i+f][j] == "0" or position_piece_on_the_chessboard[i+f][j] == "pawn_black"\
						or position_piece_on_the_chessboard[i+f][j] == "knight_black" or position_piece_on_the_chessboard[i+f][j] == "bishop_black"\
						or position_piece_on_the_chessboard[i+f][j] == "rook_black" or position_piece_on_the_chessboard[i+f][j] == "queen_black"):
							#Bouge la pièce de move_one_square = 100 en y
							move_local_y(f*move_one_square)
							#Met à jour la position de la pièce dans le tableau avant déplacement
							position_piece_on_the_chessboard[i][j] = "0"
							i += f
							#Met à jour la position de la pièce dans le tableau après déplacement
							position_piece_on_the_chessboard[i][j] = "rook_white"
							starting_square = false
							# Déselectionne la pièce après le déplacement
							piece_select = "No piece selected"
							
							print(piece_select)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
							#Et la position dans le tableau.
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
							
						else:
							piece_select = "No piece selected"
							print(piece_select)
							
					#Pour bouger vers la droite
					#Vérifie qu'on clique bien sur la bonne case
					for f in range(max_move_right):
						if mouse_pos.x >= 0 + f*move_one_square and mouse_pos.x <= texture.get_width() + f*move_one_square \
						and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height()  \
						and (position_piece_on_the_chessboard[i][j+f] == "0" or position_piece_on_the_chessboard[i][j+f] == "pawn_black"\
						or position_piece_on_the_chessboard[i][j+f] == "knight_black" or position_piece_on_the_chessboard[i][j+f] == "bishop_black"\
						or position_piece_on_the_chessboard[i][j+f] == "rook_black" or position_piece_on_the_chessboard[i][j+f] == "queen_black"):
							#Bouge la pièce de move_one_square = 100 en y
							move_local_x(f*move_one_square)
							#Met à jour la position de la pièce dans le tableau avant déplacement
							position_piece_on_the_chessboard[i][j] = "0"
							j += f
							#Met à jour la position de la pièce dans le tableau après déplacement
							position_piece_on_the_chessboard[i][j] = "rook_white"
							starting_square = false
							# Déselectionne la pièce après le déplacement
							piece_select = "No piece selected"
							
							print(piece_select)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
							#Et la position dans le tableau.
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
							
						else:
							piece_select = "No piece selected"
							print(piece_select)
							
					#Pour bouger vers la gauche
					#Vérifie qu'on clique bien sur la bonne case
					for f in range(max_move_left):
						
						if mouse_pos.x >= 0 - f*move_one_square and mouse_pos.x <= texture.get_width() - f*move_one_square \
						and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height()  \
						and (position_piece_on_the_chessboard[i][j-f] == "0" or position_piece_on_the_chessboard[i][j-f] == "pawn_black"\
						or position_piece_on_the_chessboard[i][j-f] == "knight_black" or position_piece_on_the_chessboard[i][j-f] == "bishop_black"\
						or position_piece_on_the_chessboard[i][j-f] == "rook_black" or position_piece_on_the_chessboard[i][j-f] == "queen_black"):
							#Bouge la pièce de move_one_square = 100 en y
							move_local_x(-f*move_one_square)
							#Met à jour la position de la pièce dans le tableau avant déplacement
							position_piece_on_the_chessboard[i][j] = "0"
							j -= f
							#Met à jour la position de la pièce dans le tableau après déplacement
							position_piece_on_the_chessboard[i][j] = "rook_white"
							starting_square = false
							# Déselectionne la pièce après le déplacement
							piece_select = "No piece selected"
							
							print(piece_select)
							print("i: ", i)
							print("j: ", j)
							print(position_piece_on_the_chessboard)
							#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
							#Et la position dans le tableau.
							emit_signal("opponent_turned",position_piece_on_the_chessboard)
						
						else:
							piece_select = "No piece selected"
							print(piece_select)
				
				elif piece_protects_against_an_attack == true:
					if direction_attack_protect_king == "Haut" or direction_attack_protect_king == "Bas":
						#Pour bouger vers le haut
						for f in range(max_move_up):
							if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
							and mouse_pos.y >= 0 - f*move_one_square and mouse_pos.y <= texture.get_height() - f*move_one_square \
							and (position_piece_on_the_chessboard[i-f][j] == "0" or position_piece_on_the_chessboard[i-f][j] == "pawn_black"\
							or position_piece_on_the_chessboard[i-f][j] == "knight_black" or position_piece_on_the_chessboard[i-f][j] == "bishop_black"\
							or position_piece_on_the_chessboard[i-f][j] == "rook_black" or position_piece_on_the_chessboard[i-f][j] == "queen_black"):
								#Bouge la pièce de move_one_square = 100 en y
								move_local_y(-f*move_one_square)
								#Met à jour la position de la pièce dans le tableau avant déplacement
								position_piece_on_the_chessboard[i][j] = "0"
								i -= f
								#Met à jour la position de la pièce dans le tableau après déplacement
								position_piece_on_the_chessboard[i][j] = "rook_white"
								starting_square = false
								# Déselectionne la pièce après le déplacement
								piece_select = "No piece selected"

								print(piece_select)
								print("i: ", i)
								print("j: ", j)
								print(position_piece_on_the_chessboard)
								#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
								#Et la position dans le tableau.
								emit_signal("opponent_turned",position_piece_on_the_chessboard)

							else:
								piece_select = "No piece selected"
								print(piece_select)

						#Pour bouger vers le bas
						for f in range(max_move_down):
							if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
							and mouse_pos.y >= 0 + f*move_one_square and mouse_pos.y <= texture.get_height() + f*move_one_square \
							and (position_piece_on_the_chessboard[i+f][j] == "0" or position_piece_on_the_chessboard[i+f][j] == "pawn_black"\
							or position_piece_on_the_chessboard[i+f][j] == "knight_black" or position_piece_on_the_chessboard[i+f][j] == "bishop_black"\
							or position_piece_on_the_chessboard[i+f][j] == "rook_black" or position_piece_on_the_chessboard[i+f][j] == "queen_black"):
								#Bouge la pièce de move_one_square = 100 en y
								move_local_y(f*move_one_square)
								#Met à jour la position de la pièce dans le tableau avant déplacement
								position_piece_on_the_chessboard[i][j] = "0"
								i += f
								#Met à jour la position de la pièce dans le tableau après déplacement
								position_piece_on_the_chessboard[i][j] = "rook_white"
								starting_square = false
								# Déselectionne la pièce après le déplacement
								piece_select = "No piece selected"

								print(piece_select)
								print("i: ", i)
								print("j: ", j)
								print(position_piece_on_the_chessboard)
								#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
								#Et la position dans le tableau.
								emit_signal("opponent_turned",position_piece_on_the_chessboard)

							else:
								piece_select = "No piece selected"
								print(piece_select)
								
					elif direction_attack_protect_king == "Droite" or direction_attack_protect_king == "Gauche":
						#Pour bouger vers la droite
						for f in range(max_move_right):
							if mouse_pos.x >= 0 + f*move_one_square and mouse_pos.x <= texture.get_width() + f*move_one_square \
							and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height()  \
							and (position_piece_on_the_chessboard[i][j+f] == "0" or position_piece_on_the_chessboard[i][j+f] == "pawn_black"\
							or position_piece_on_the_chessboard[i][j+f] == "knight_black" or position_piece_on_the_chessboard[i][j+f] == "bishop_black"\
							or position_piece_on_the_chessboard[i][j+f] == "rook_black" or position_piece_on_the_chessboard[i][j+f] == "queen_black"):
								#Bouge la pièce de move_one_square = 100 en y
								move_local_x(f*move_one_square)
								#Met à jour la position de la pièce dans le tableau avant déplacement
								position_piece_on_the_chessboard[i][j] = "0"
								j += f
								#Met à jour la position de la pièce dans le tableau après déplacement
								position_piece_on_the_chessboard[i][j] = "rook_white"
								starting_square = false
								# Déselectionne la pièce après le déplacement
								piece_select = "No piece selected"

								print(piece_select)
								print("i: ", i)
								print("j: ", j)
								print(position_piece_on_the_chessboard)
								#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
								#Et la position dans le tableau.
								emit_signal("opponent_turned",position_piece_on_the_chessboard)

							else:
								piece_select = "No piece selected"
								print(piece_select)

						#Pour bouger vers la gauche
						for f in range(max_move_left):

							if mouse_pos.x >= 0 - f*move_one_square and mouse_pos.x <= texture.get_width() - f*move_one_square \
							and mouse_pos.y >= 0  and mouse_pos.y <= texture.get_height()  \
							and (position_piece_on_the_chessboard[i][j-f] == "0" or position_piece_on_the_chessboard[i][j-f] == "pawn_black"\
							or position_piece_on_the_chessboard[i][j-f] == "knight_black" or position_piece_on_the_chessboard[i][j-f] == "bishop_black"\
							or position_piece_on_the_chessboard[i][j-f] == "rook_black" or position_piece_on_the_chessboard[i][j-f] == "queen_black"):
								#Bouge la pièce de move_one_square = 100 en y
								move_local_x(-f*move_one_square)
								#Met à jour la position de la pièce dans le tableau avant déplacement
								position_piece_on_the_chessboard[i][j] = "0"
								j -= f
								#Met à jour la position de la pièce dans le tableau après déplacement
								position_piece_on_the_chessboard[i][j] = "rook_white"
								starting_square = false
								# Déselectionne la pièce après le déplacement
								piece_select = "No piece selected"

								print(piece_select)
								print("i: ", i)
								print("j: ", j)
								print(position_piece_on_the_chessboard)
								#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
								#Et la position dans le tableau.
								emit_signal("opponent_turned",position_piece_on_the_chessboard)

							else:
								piece_select = "No piece selected"
								print(piece_select)
								
					elif direction_attack_protect_king == "Haut/Droite" or direction_attack_protect_king == "Haut/Gauche"\
					or direction_attack_protect_king == "Bas/Droite" or direction_attack_protect_king == "Bas/Gauche":
						piece_select = "No piece selected"
						print(piece_select)

	elif king_in_check == true and can_protect_the_king == true:
		
		#Vérifie si la pièce est sur sa case de départ et si c'est le tour des blancs
		if player_turn == "white":
			
			# Pour sélectionner l'ID unique de la pièce en cliquant dessus
			if event is InputEventMouseButton and event.is_pressed() \
			and event.button_index == MOUSE_BUTTON_LEFT and piece_select == "No piece selected":
				if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width() \
				and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
					piece_select = my_node_name
					print(piece_select)
					print("i: ", i)
					print("j: ", j)

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
					#Vérifie qu'on clique bien sur la bonne case
					if mouse_pos.x >= (attacker_position_shift_j - j) * 100 and mouse_pos.x <= (attacker_position_shift_j - j) * 100 + move_one_square \
					and mouse_pos.y >= (attacker_position_shift_i - i) * 100 and mouse_pos.y <= (attacker_position_shift_i - i) * 100 + move_one_square \
					and (position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "0" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "pawn_black"\
					or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "knight_black" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "bishop_black"\
					or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "rook_black" or position_piece_on_the_chessboard[attacker_position_shift_i][attacker_position_shift_j] == "queen_black"):
						#Bouge la pièce de move_one_square = 100 en y
						move_local_y((attacker_position_shift_i - i) * 100)
						move_local_x((attacker_position_shift_j - j) * 100)
						#Met à jour la position de la pièce dans le tableau avant déplacement
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift_i
						j = attacker_position_shift_j
						#Met à jour la position de la pièce dans le tableau après déplacement
						position_piece_on_the_chessboard[i][j] = "rook_white"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						# Déselectionne la pièce après le déplacement
						piece_select = "No piece selected"
						
						print(piece_select)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
						#Et la position dans le tableau.
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
					elif mouse_pos.x >= (attacker_position_shift2_j - j) * 100 and mouse_pos.x <= (attacker_position_shift2_j - j) * 100 + move_one_square\
					and mouse_pos.y >= (attacker_position_shift2_i - i) * 100 and mouse_pos.y <= (attacker_position_shift2_i - i) * 100 + move_one_square \
					and (position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "0" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "pawn_black"\
					or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "knight_black" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "bishop_black"\
					or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "rook_black" or position_piece_on_the_chessboard[attacker_position_shift2_i][attacker_position_shift2_j] == "queen_black"):
						#Bouge la pièce de move_one_square = 100 en y
						move_local_y((attacker_position_shift2_i - i) * 100)
						move_local_x((attacker_position_shift2_j - j) * 100)
						#Met à jour la position de la pièce dans le tableau avant déplacement
						position_piece_on_the_chessboard[i][j] = "0"
						i = attacker_position_shift2_i
						j = attacker_position_shift2_j
						#Met à jour la position de la pièce dans le tableau après déplacement
						position_piece_on_the_chessboard[i][j] = "rook_white"
						
						attacker_position_shift_i = 0
						attacker_position_shift_j = 0
						attacker_position_shift2_i = 0
						attacker_position_shift2_j = 0
						# Déselectionne la pièce après le déplacement
						piece_select = "No piece selected"
						
						print(piece_select)
						print("i: ", i)
						print("j: ", j)
						print(position_piece_on_the_chessboard)
						#Envoie un signal à la scène plateau_echec pour mettre à jour le tour de toutes les pièces et
						#Et la position dans le tableau.
						emit_signal("opponent_turned",position_piece_on_the_chessboard)
					
					else:
								piece_select = "No piece selected"
								print(piece_select)
								
				elif piece_protects_against_an_attack == true:
					piece_select = "No piece selected"
					print(piece_select)

func _on_area_2d_area_entered(area):
	if player_turn == "black":
		get_node("/root/Plateau_echec/" + area.get_parent().get_name()).queue_free()
		print(area.get_parent().get_name())

func verif_piece_protects_against_an_attack_the_king():
	#On regarde d'où vient l'attaque
	#Lignes
	#Vers le haut
	for f in range(1,9):
		if position_piece_on_the_chessboard[i-f][j] == "x":
			break
		elif position_piece_on_the_chessboard[i-f][j] != "0":
			
			if position_piece_on_the_chessboard[i-f][j] == "rook_black"\
			or position_piece_on_the_chessboard[i-f][j] == "queen_black":
				direction_attack_protect_king = "Haut"
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
				direction_attack_protect_king = "Bas"
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
				direction_attack_protect_king = "Droite"
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
			
			if position_piece_on_the_chessboard[i-f][j+f] == "bishop_black"\
			or position_piece_on_the_chessboard[i-f][j+f] == "queen_black":
				direction_attack_protect_king = "Haut/Droite"
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
				direction_attack_protect_king = "Haut/Gauche"
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
				direction_attack_protect_king = "Bas/Droite"
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
				
				if position_piece_on_the_chessboard[i+f][j] == "king_white":
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
				
				if position_piece_on_the_chessboard[i-f][j] == "king_white":
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
				
				if position_piece_on_the_chessboard[i][j-f] == "king_white":
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
				
				if position_piece_on_the_chessboard[i][j+f] == "king_white":
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
				
				if position_piece_on_the_chessboard[i+f][j-f] == "king_white":
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
				
				if position_piece_on_the_chessboard[i+f][j+f] == "king_white":
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
				
				if position_piece_on_the_chessboard[i-f][j-f] == "king_white":
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
				
				if position_piece_on_the_chessboard[i-f][j+f] == "king_white":
					piece_protects_against_an_attack = true
					break
				else:
					break

func _on_king_white_petit_roque():
	#Bouge la pièce de move_one_square = 100 en y
	move_local_x(-2*move_one_square)
	#Met à jour la position de la pièce dans le tableau avant déplacement
	position_piece_on_the_chessboard[i][j] = "0"
	j -= 2
	#Met à jour la position de la pièce dans le tableau après déplacement
	position_piece_on_the_chessboard[i][j] = "rook_white"
	starting_square = false
	# Déselectionne la pièce après le déplacement
	piece_select = "No piece selected"
	
	print(piece_select)
	print("i: ", i)
	print("j: ", j)
	print(position_piece_on_the_chessboard)

func _on_king_white_grand_roque():
	#Bouge la pièce de move_one_square = 100 en y
	move_local_x(3*move_one_square)
	#Met à jour la position de la pièce dans le tableau avant déplacement
	position_piece_on_the_chessboard[i][j] = "0"
	j += 3
	#Met à jour la position de la pièce dans le tableau après déplacement
	position_piece_on_the_chessboard[i][j] = "rook_white"
	starting_square = false
	# Déselectionne la pièce après le déplacement
	piece_select = "No piece selected"
	
	print(piece_select)
	print("i: ", i)
	print("j: ", j)
	print(position_piece_on_the_chessboard)
