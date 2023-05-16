extends Sprite2D

@onready var Pawn_white = get_node("Pawn_white")
@onready var Pawn_white2 = get_node("Pawn_white2")
@onready var Pawn_white3 = get_node("Pawn_white3")
@onready var Pawn_white4 = get_node("Pawn_white4")
@onready var Pawn_white5 = get_node("Pawn_white5")
@onready var Pawn_white6 = get_node("Pawn_white6")
@onready var Pawn_white7 = get_node("Pawn_white7")
@onready var Pawn_white8 = get_node("Pawn_white8")
@onready var Knight_white = get_node("Knight_white")
@onready var Knight_white2 = get_node("Knight_white2")
@onready var Bishop_white = get_node("Bishop_white")
@onready var Bishop_white2 = get_node("Bishop_white2")
@onready var Rook_white = get_node("Rook_white")
@onready var Rook_white2 = get_node("Rook_white2")
@onready var Queen_white = get_node("Queen_white")
@onready var King_white = get_node("King_white")

@onready var Pawn_black = get_node("Pawn_black")
@onready var Pawn_black2 = get_node("Pawn_black2")
@onready var Pawn_black3 = get_node("Pawn_black3")
@onready var Pawn_black4 = get_node("Pawn_black4")
@onready var Pawn_black5 = get_node("Pawn_black5")
@onready var Pawn_black6 = get_node("Pawn_black6")
@onready var Pawn_black7 = get_node("Pawn_black7")
@onready var Pawn_black8 = get_node("Pawn_black8")
@onready var Knight_black = get_node("Knight_black")
@onready var Knight_black2 = get_node("Knight_black2")
@onready var Bishop_black = get_node("Bishop_black")
@onready var Bishop_black2 = get_node("Bishop_black2")
@onready var Rook_black = get_node("Rook_black")
@onready var Rook_black2 = get_node("Rook_black2")
@onready var Queen_black = get_node("Queen_black")
@onready var King_black = get_node("King_black")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("Restart"):
		# Rechargez la scène actuelle pour redémarrer le jeu
		get_tree().reload_current_scene()
	
func player_turn_white():
	
	if Pawn_white != null:
		Pawn_white.player_turn = "black"
	if Knight_white != null:
		Knight_white.player_turn = "black"
	if Bishop_white != null:
		Bishop_white.player_turn = "black"
	if Rook_white != null:
		Rook_white.player_turn = "black"
	if Queen_white != null:
		Queen_white.player_turn = "black"
	if King_white != null:
		King_white.player_turn = "black"
		
	if Pawn_black != null:
		Pawn_black.player_turn = "black"
	if Knight_black != null:
		Knight_black.player_turn = "black"
	if Bishop_black != null:
		Bishop_black.player_turn = "black"
	if Rook_black != null:
		Rook_black.player_turn = "black"
	if Queen_black != null:
		Queen_black.player_turn = "black"
	if King_black != null:
		King_black.player_turn = "black"
	
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).player_turn = "black"
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).player_turn = "black"
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).player_turn = "black"
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).player_turn = "black"
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).player_turn = "black"
		
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).player_turn = "black"
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).player_turn = "black"
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).player_turn = "black"
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).player_turn = "black"
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).player_turn = "black"
			
func player_turn_black():
	
	if Pawn_white != null:
		Pawn_white.player_turn = "white"
	if Knight_white != null:
		Knight_white.player_turn = "white"
	if Bishop_white != null:
		Bishop_white.player_turn = "white"
	if Rook_white != null:
		Rook_white.player_turn = "white"
	if Queen_white != null:
		Queen_white.player_turn = "white"
	if King_white != null:
		King_white.player_turn = "white"
		
	if Pawn_black != null:
		Pawn_black.player_turn = "white"
	if Knight_black != null:
		Knight_black.player_turn = "white"
	if Bishop_black != null:
		Bishop_black.player_turn = "white"
	if Rook_black != null:
		Rook_black.player_turn = "white"
	if Queen_black != null:
		Queen_black.player_turn = "white"
	if King_black != null:
		King_black.player_turn = "white"
	
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).player_turn = "white"
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).player_turn = "white"
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).player_turn = "white"
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).player_turn = "white"
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).player_turn = "white"
		
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).player_turn = "white"
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).player_turn = "white"
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).player_turn = "white"
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).player_turn = "white"
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).player_turn = "white"
	
func updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard):
	
	if Pawn_white != null:
		Pawn_white.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Knight_white != null:
		Knight_white.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Bishop_white != null:
		Bishop_white.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Rook_white != null:
		Rook_white.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Queen_white != null:
		Queen_white.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if King_white != null:
		King_white.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	
	if Pawn_black != null:
		Pawn_black.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Knight_black != null:
		Knight_black.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Bishop_black != null:
		Bishop_black.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Rook_black != null:
		Rook_black.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if Queen_black != null:
		Queen_black.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	if King_black != null:
		King_black.position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).position_piece_on_the_chessboard = new_position_piece_on_the_chessboard
	
func check_king_white_is_safe():
	if Pawn_white != null:
		Pawn_white.king_in_check = false
		Pawn_white.can_protect_the_king = false
		Pawn_white.piece_protects_against_an_attack = false
	if Knight_white != null:
		Knight_white.king_in_check = false
		Knight_white.can_protect_the_king = false
		Knight_white.piece_protects_against_an_attack = false
	if Bishop_white != null:
		Bishop_white.king_in_check = false
		Bishop_white.can_protect_the_king = false
		Bishop_white.piece_protects_against_an_attack = false
	if Rook_white != null:
		Rook_white.king_in_check = false
		Rook_white.can_protect_the_king = false
		Rook_white.piece_protects_against_an_attack = false
	if Queen_white != null:
		Queen_white.king_in_check = false
		Queen_white.can_protect_the_king = false
		Queen_white.piece_protects_against_an_attack = false
	if King_white != null:
		King_white.piece_protect_the_king = false

	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).king_in_check = false
			get_node("Pawn_white" + str(f)).can_protect_the_king = false
			get_node("Pawn_white" + str(f)).piece_protects_against_an_attack = false
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).king_in_check = false
			get_node("Knight_white" + str(f)).can_protect_the_king = false
			get_node("Knight_white" + str(f)).piece_protects_against_an_attack = false
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).king_in_check = false
			get_node("Bishop_white" + str(f)).can_protect_the_king = false
			get_node("Bishop_white" + str(f)).piece_protects_against_an_attack = false
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).king_in_check = false
			get_node("Rook_white" + str(f)).can_protect_the_king = false
			get_node("Rook_white" + str(f)).piece_protects_against_an_attack = false
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).king_in_check = false
			get_node("Queen_white" + str(f)).can_protect_the_king = false
			get_node("Queen_white" + str(f)).piece_protects_against_an_attack = false

func check_king_black_is_safe():
	if Pawn_black != null:
		Pawn_black.king_in_check = false
		Pawn_black.can_protect_the_king = false
		Pawn_black.piece_protects_against_an_attack = false
	if Knight_black != null:
		Knight_black.king_in_check = false
		Knight_black.can_protect_the_king = false
		Knight_black.piece_protects_against_an_attack = false
	if Bishop_black != null:
		Bishop_black.king_in_check = false
		Bishop_black.can_protect_the_king = false
		Bishop_black.piece_protects_against_an_attack = false
	if Rook_black != null:
		Rook_black.king_in_check = false
		Rook_black.can_protect_the_king = false
		Rook_black.piece_protects_against_an_attack = false
	if Queen_black != null:
		Queen_black.king_in_check = false
		Queen_black.can_protect_the_king = false
		Queen_black.piece_protects_against_an_attack = false
	if King_black != null:
		King_black.piece_protect_the_king = false

	for f in range(2,9):
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).king_in_check = false
			get_node("Pawn_black" + str(f)).can_protect_the_king = false
			get_node("Pawn_black" + str(f)).piece_protects_against_an_attack = false
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).king_in_check = false
			get_node("Knight_black" + str(f)).can_protect_the_king = false
			get_node("Knight_black" + str(f)).piece_protects_against_an_attack = false
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).king_in_check = false
			get_node("Bishop_black" + str(f)).can_protect_the_king = false
			get_node("Bishop_black" + str(f)).piece_protects_against_an_attack = false
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).king_in_check = false
			get_node("Rook_black" + str(f)).can_protect_the_king = false
			get_node("Rook_black" + str(f)).piece_protects_against_an_attack = false
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).king_in_check = false
			get_node("Queen_black" + str(f)).can_protect_the_king = false
			get_node("Queen_black" + str(f)).piece_protects_against_an_attack = false
		
func _on_pawn_white_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_3_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_4_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_5_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_6_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_7_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_white_8_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()
	
func _on_knight_white_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_knight_white_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()
	
func _on_bishop_white_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_bishop_white_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()
		
func _on_rook_white_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_rook_white_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_queen_white_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()
	
func _on_king_white_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_white()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_white_is_safe()

func _on_pawn_black_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_3_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_4_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_5_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_6_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_7_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_pawn_black_8_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_rook_black_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_rook_black_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_bishop_black_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_bishop_black_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_knight_black_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()
	
func _on_knight_black_2_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_queen_black_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_king_black_opponent_turned(new_position_piece_on_the_chessboard):
	player_turn_black()
	updating_the_pieces_on_the_board(new_position_piece_on_the_chessboard)
	check_king_black_is_safe()

func _on_king_white_check_to_the_king(attacker_position_shift_i, attacker_position_shift_j,\
 defenseur_position_i, defenseur_position_j,direction_of_attack):
	
	if Pawn_white != null:
		Pawn_white.king_in_check = true
	if Knight_white != null:
		Knight_white.king_in_check = true
	if Bishop_white != null:
		Bishop_white.king_in_check = true
	if Rook_white != null:
		Rook_white.king_in_check = true
	if Queen_white != null:
		Queen_white.king_in_check = true
	if King_white != null:
		King_white.king_in_check = true
	
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).king_in_check = true
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).king_in_check = true
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).king_in_check = true
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).king_in_check = true
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).king_in_check = true
	
	if Pawn_white != null:
		if Pawn_white.i == defenseur_position_i and Pawn_white.j == defenseur_position_j:
			Pawn_white.can_protect_the_king = true
			if Pawn_white.attacker_position_shift_i == 0 and Pawn_white.attacker_position_shift_j == 0:
				Pawn_white.attacker_position_shift_i = attacker_position_shift_i
				Pawn_white.attacker_position_shift_j = attacker_position_shift_j
			else:
				Pawn_white.attacker_position_shift2_i = attacker_position_shift_i
				Pawn_white.attacker_position_shift2_j = attacker_position_shift_j
				
			Pawn_white.direction_of_attack = direction_of_attack
	
	if Knight_white != null:
		if Knight_white.i == defenseur_position_i and Knight_white.j == defenseur_position_j:
			Knight_white.can_protect_the_king = true
			if Knight_white.attacker_position_shift_i == 0 and Knight_white.attacker_position_shift_j == 0:
				Knight_white.attacker_position_shift_i = attacker_position_shift_i
				Knight_white.attacker_position_shift_j = attacker_position_shift_j
			else:
				Knight_white.attacker_position_shift2_i = attacker_position_shift_i
				Knight_white.attacker_position_shift2_j = attacker_position_shift_j
				
			Knight_white.direction_of_attack = direction_of_attack
			
	if Bishop_white != null:
		if Bishop_white.i == defenseur_position_i and Bishop_white.j == defenseur_position_j:
			Bishop_white.can_protect_the_king = true
			if Bishop_white.attacker_position_shift_i == 0 and Bishop_white.attacker_position_shift_j == 0:
				Bishop_white.attacker_position_shift_i = attacker_position_shift_i
				Bishop_white.attacker_position_shift_j = attacker_position_shift_j
			else:
				Bishop_white.attacker_position_shift2_i = attacker_position_shift_i
				Bishop_white.attacker_position_shift2_j = attacker_position_shift_j
				
			Bishop_white.direction_of_attack = direction_of_attack
	
	if Rook_white != null:
		if Rook_white.i == defenseur_position_i and Rook_white.j == defenseur_position_j:
			Rook_white.can_protect_the_king = true
			if Rook_white.attacker_position_shift_i == 0 and Rook_white.attacker_position_shift_j == 0:
				Rook_white.attacker_position_shift_i = attacker_position_shift_i
				Rook_white.attacker_position_shift_j = attacker_position_shift_j
			else:
				Rook_white.attacker_position_shift2_i = attacker_position_shift_i
				Rook_white.attacker_position_shift2_j = attacker_position_shift_j
				
			Rook_white.direction_of_attack = direction_of_attack
	
	if Queen_white != null:
		if Queen_white.i == defenseur_position_i and Queen_white.j == defenseur_position_j:
			Queen_white.can_protect_the_king = true
			if Queen_white.attacker_position_shift_i == 0 and Queen_white.attacker_position_shift_j == 0:
				Queen_white.attacker_position_shift_i = attacker_position_shift_i
				Queen_white.attacker_position_shift_j = attacker_position_shift_j
			elif Queen_white.attacker_position_shift2_i == 0 and Queen_white.attacker_position_shift2_j == 0:
				Queen_white.attacker_position_shift2_i = attacker_position_shift_i
				Queen_white.attacker_position_shift2_j = attacker_position_shift_j
			else:
				Queen_white.attacker_position_shift3_i = attacker_position_shift_i
				Queen_white.attacker_position_shift3_j = attacker_position_shift_j
				
			Queen_white.direction_of_attack = direction_of_attack
	
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			if get_node("Pawn_white" + str(f)).i == defenseur_position_i and get_node("Pawn_white" + str(f)).j == defenseur_position_j:
				get_node("Pawn_white" + str(f)).can_protect_the_king = true
			if get_node("Pawn_white" + str(f)).attacker_position_shift_i == 0 and get_node("Pawn_white" + str(f)).attacker_position_shift_j == 0:
				get_node("Pawn_white" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Pawn_white" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Pawn_white" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Pawn_white" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Pawn_white" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Knight_white" + str(f)) != null:
			if get_node("Knight_white" + str(f)).i == defenseur_position_i and get_node("Knight_white" + str(f)).j == defenseur_position_j:
				get_node("Knight_white" + str(f)).can_protect_the_king = true
			if get_node("Knight_white" + str(f)).attacker_position_shift_i == 0 and get_node("Knight_white" + str(f)).attacker_position_shift_j == 0:
				get_node("Knight_white" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Knight_white" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Knight_white" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Knight_white" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Knight_white" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Bishop_white" + str(f)) != null:
			if get_node("Bishop_white" + str(f)).i == defenseur_position_i and get_node("Bishop_white" + str(f)).j == defenseur_position_j:
				get_node("Bishop_white" + str(f)).can_protect_the_king = true
			if get_node("Bishop_white" + str(f)).attacker_position_shift_i == 0 and get_node("Bishop_white" + str(f)).attacker_position_shift_j == 0:
				get_node("Bishop_white" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Bishop_white" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Bishop_white" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Bishop_white" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Bishop_white" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Rook_white" + str(f)) != null:
			if get_node("Rook_white" + str(f)).i == defenseur_position_i and get_node("Rook_white" + str(f)).j == defenseur_position_j:
				get_node("Rook_white" + str(f)).can_protect_the_king = true
			if get_node("Rook_white" + str(f)).attacker_position_shift_i == 0 and get_node("Rook_white" + str(f)).attacker_position_shift_j == 0:
				get_node("Rook_white" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Rook_white" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Rook_white" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Rook_white" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Rook_white" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Queen_white" + str(f)) != null:
			if get_node("Queen_white" + str(f)).i == defenseur_position_i and get_node("Queen_white" + str(f)).j == defenseur_position_j:
				get_node("Queen_white" + str(f)).can_protect_the_king = true
				if get_node("Queen_white" + str(f)).attacker_position_shift_i == 0 and get_node("Queen_white" + str(f)).attacker_position_shift_j == 0:
					get_node("Queen_white" + str(f)).attacker_position_shift_i = attacker_position_shift_i
					get_node("Queen_white" + str(f)).attacker_position_shift_j = attacker_position_shift_j
				elif get_node("Queen_white" + str(f)).attacker_position_shift2_i == 0 and get_node("Queen_white" + str(f)).attacker_position_shift2_j == 0:
					get_node("Queen_white" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
					get_node("Queen_white" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				else:
					get_node("Queen_white" + str(f)).attacker_position_shift3_i = attacker_position_shift_i
					get_node("Queen_white" + str(f)).attacker_position_shift3_j = attacker_position_shift_j
					
				get_node("Queen_white" + str(f)).direction_of_attack = direction_of_attack
	
func _on_king_white_checkmate_to_the_king(checkmate):
	if Pawn_white != null:
		Pawn_white.king_in_check = checkmate
	if Knight_white != null:
		Knight_white.king_in_check = checkmate
	if Bishop_white != null:
		Bishop_white.king_in_check = checkmate
	if Rook_white != null:
		Rook_white.king_in_check = checkmate
	if Queen_white != null:
		Queen_white.king_in_check = checkmate
	
	if Pawn_black != null:
		Pawn_black.king_in_check = checkmate
	if Knight_black != null:
		Knight_black.king_in_check = checkmate
	if Bishop_black != null:
		Bishop_black.king_in_check = checkmate
	if Rook_black != null:
		Rook_black.king_in_check = checkmate
	if Queen_black != null:
		Queen_black.king_in_check = checkmate
		
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).king_in_check = checkmate
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).king_in_check = checkmate
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).king_in_check = checkmate
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).king_in_check = checkmate
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).king_in_check = checkmate
		
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).king_in_check = checkmate
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).king_in_check = checkmate
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).king_in_check = checkmate
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).king_in_check = checkmate
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).king_in_check = checkmate

func _on_king_black_check_to_the_king(attacker_position_shift_i, attacker_position_shift_j,\
 defenseur_position_i, defenseur_position_j,direction_of_attack):
	if Pawn_black != null:
		Pawn_black.king_in_check = true
	if Knight_black != null:
		Knight_black.king_in_check = true
	if Bishop_black != null:
		Bishop_black.king_in_check = true
	if Rook_black != null:
		Rook_black.king_in_check = true
	if Queen_black != null:
		Queen_black.king_in_check = true
	if King_black != null:
		King_black.king_in_check = true
	
	for f in range(2,9):
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).king_in_check = true
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).king_in_check = true
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).king_in_check = true
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).king_in_check = true
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).king_in_check = true
	
	if Pawn_black != null:
		if Pawn_black.i == defenseur_position_i and Pawn_black.j == defenseur_position_j:
			Pawn_black.can_protect_the_king = true
			if Pawn_black.attacker_position_shift_i == 0 and Pawn_black.attacker_position_shift_j == 0:
				Pawn_black.attacker_position_shift_i = attacker_position_shift_i
				Pawn_black.attacker_position_shift_j = attacker_position_shift_j
			else:
				Pawn_black.attacker_position_shift2_i = attacker_position_shift_i
				Pawn_black.attacker_position_shift2_j = attacker_position_shift_j
				
			Pawn_black.direction_of_attack = direction_of_attack
	
	if Knight_black != null:
		if Knight_black.i == defenseur_position_i and Knight_black.j == defenseur_position_j:
			Knight_black.can_protect_the_king = true
			if Knight_black.attacker_position_shift_i == 0 and Knight_black.attacker_position_shift_j == 0:
				Knight_black.attacker_position_shift_i = attacker_position_shift_i
				Knight_black.attacker_position_shift_j = attacker_position_shift_j
			else:
				Knight_black.attacker_position_shift2_i = attacker_position_shift_i
				Knight_black.attacker_position_shift2_j = attacker_position_shift_j
				
			Knight_black.direction_of_attack = direction_of_attack
			
	if Bishop_black != null:
		if Bishop_black.i == defenseur_position_i and Bishop_black.j == defenseur_position_j:
			Bishop_black.can_protect_the_king = true
			if Bishop_black.attacker_position_shift_i == 0 and Bishop_black.attacker_position_shift_j == 0:
				Bishop_black.attacker_position_shift_i = attacker_position_shift_i
				Bishop_black.attacker_position_shift_j = attacker_position_shift_j
			else:
				Bishop_black.attacker_position_shift2_i = attacker_position_shift_i
				Bishop_black.attacker_position_shift2_j = attacker_position_shift_j
				
			Bishop_black.direction_of_attack = direction_of_attack
	
	if Rook_black != null:
		if Rook_black.i == defenseur_position_i and Rook_black.j == defenseur_position_j:
			Rook_black.can_protect_the_king = true
			if Rook_black.attacker_position_shift_i == 0 and Rook_black.attacker_position_shift_j == 0:
				Rook_black.attacker_position_shift_i = attacker_position_shift_i
				Rook_black.attacker_position_shift_j = attacker_position_shift_j
			else:
				Rook_black.attacker_position_shift2_i = attacker_position_shift_i
				Rook_black.attacker_position_shift2_j = attacker_position_shift_j
				
			Rook_black.direction_of_attack = direction_of_attack
	
	if Queen_black != null:
		if Queen_black.i == defenseur_position_i and Queen_black.j == defenseur_position_j:
			Queen_black.can_protect_the_king = true
			if Queen_black.attacker_position_shift_i == 0 and Queen_black.attacker_position_shift_j == 0:
				Queen_black.attacker_position_shift_i = attacker_position_shift_i
				Queen_black.attacker_position_shift_j = attacker_position_shift_j
			elif Queen_black.attacker_position_shift2_i == 0 and Queen_black.attacker_position_shift2_j == 0:
				Queen_black.attacker_position_shift2_i = attacker_position_shift_i
				Queen_black.attacker_position_shift2_j = attacker_position_shift_j
			else:
				Queen_black.attacker_position_shift3_i = attacker_position_shift_i
				Queen_black.attacker_position_shift3_j = attacker_position_shift_j
				
			Queen_black.direction_of_attack = direction_of_attack
	
	for f in range(2,9):
		if get_node("Pawn_black" + str(f)) != null:
			if get_node("Pawn_black" + str(f)).i == defenseur_position_i and get_node("Pawn_black" + str(f)).j == defenseur_position_j:
				get_node("Pawn_black" + str(f)).can_protect_the_king = true
			if get_node("Pawn_black" + str(f)).attacker_position_shift_i == 0 and get_node("Pawn_black" + str(f)).attacker_position_shift_j == 0:
				get_node("Pawn_black" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Pawn_black" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Pawn_black" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Pawn_black" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Pawn_black" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Knight_black" + str(f)) != null:
			if get_node("Knight_black" + str(f)).i == defenseur_position_i and get_node("Knight_black" + str(f)).j == defenseur_position_j:
				get_node("Knight_black" + str(f)).can_protect_the_king = true
			if get_node("Knight_black" + str(f)).attacker_position_shift_i == 0 and get_node("Knight_black" + str(f)).attacker_position_shift_j == 0:
				get_node("Knight_black" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Knight_black" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Knight_black" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Knight_black" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Knight_black" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Bishop_black" + str(f)) != null:
			if get_node("Bishop_black" + str(f)).i == defenseur_position_i and get_node("Bishop_black" + str(f)).j == defenseur_position_j:
				get_node("Bishop_black" + str(f)).can_protect_the_king = true
			if get_node("Bishop_black" + str(f)).attacker_position_shift_i == 0 and get_node("Bishop_black" + str(f)).attacker_position_shift_j == 0:
				get_node("Bishop_black" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Bishop_black" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Bishop_black" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Bishop_black" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Bishop_black" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Rook_black" + str(f)) != null:
			if get_node("Rook_black" + str(f)).i == defenseur_position_i and get_node("Rook_black" + str(f)).j == defenseur_position_j:
				get_node("Rook_black" + str(f)).can_protect_the_king = true
			if get_node("Rook_black" + str(f)).attacker_position_shift_i == 0 and get_node("Rook_black" + str(f)).attacker_position_shift_j == 0:
				get_node("Rook_black" + str(f)).attacker_position_shift_i = attacker_position_shift_i
				get_node("Rook_black" + str(f)).attacker_position_shift_j = attacker_position_shift_j
			else:
				get_node("Rook_black" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
				get_node("Rook_black" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				
			get_node("Rook_black" + str(f)).direction_of_attack = direction_of_attack
			
		if get_node("Queen_black" + str(f)) != null:
			if get_node("Queen_black" + str(f)).i == defenseur_position_i and get_node("Queen_black" + str(f)).j == defenseur_position_j:
				get_node("Queen_black" + str(f)).can_protect_the_king = true
				if get_node("Queen_black" + str(f)).attacker_position_shift_i == 0 and get_node("Queen_black" + str(f)).attacker_position_shift_j == 0:
					get_node("Queen_black" + str(f)).attacker_position_shift_i = attacker_position_shift_i
					get_node("Queen_black" + str(f)).attacker_position_shift_j = attacker_position_shift_j
				elif get_node("Queen_black" + str(f)).attacker_position_shift2_i == 0 and get_node("Queen_black" + str(f)).attacker_position_shift2_j == 0:
					get_node("Queen_black" + str(f)).attacker_position_shift2_i = attacker_position_shift_i
					get_node("Queen_black" + str(f)).attacker_position_shift2_j = attacker_position_shift_j
				else:
					get_node("Queen_black" + str(f)).attacker_position_shift3_i = attacker_position_shift_i
					get_node("Queen_black" + str(f)).attacker_position_shift3_j = attacker_position_shift_j
					
				get_node("Queen_black" + str(f)).direction_of_attack = direction_of_attack
	
func _on_king_black_checkmate_to_the_king(checkmate):
	if Pawn_white != null:
		Pawn_white.king_in_check = checkmate
	if Knight_white != null:
		Knight_white.king_in_check = checkmate
	if Bishop_white != null:
		Bishop_white.king_in_check = checkmate
	if Rook_white != null:
		Rook_white.king_in_check = checkmate
	if Queen_white != null:
		Queen_white.king_in_check = checkmate
	
	if Pawn_black != null:
		Pawn_black.king_in_check = checkmate
	if Knight_black != null:
		Knight_black.king_in_check = checkmate
	if Bishop_black != null:
		Bishop_black.king_in_check = checkmate
	if Rook_black != null:
		Rook_black.king_in_check = checkmate
	if Queen_black != null:
		Queen_black.king_in_check = checkmate
		
	for f in range(2,9):
		if get_node("Pawn_white" + str(f)) != null:
			get_node("Pawn_white" + str(f)).king_in_check = checkmate
		if get_node("Knight_white" + str(f)) != null:
			get_node("Knight_white" + str(f)).king_in_check = checkmate
		if get_node("Bishop_white" + str(f)) != null:
			get_node("Bishop_white" + str(f)).king_in_check = checkmate
		if get_node("Rook_white" + str(f)) != null:
			get_node("Rook_white" + str(f)).king_in_check = checkmate
		if get_node("Queen_white" + str(f)) != null:
			get_node("Queen_white" + str(f)).king_in_check = checkmate
		
		if get_node("Pawn_black" + str(f)) != null:
			get_node("Pawn_black" + str(f)).king_in_check = checkmate
		if get_node("Knight_black" + str(f)) != null:
			get_node("Knight_black" + str(f)).king_in_check = checkmate
		if get_node("Bishop_black" + str(f)) != null:
			get_node("Bishop_black" + str(f)).king_in_check = checkmate
		if get_node("Rook_black" + str(f)) != null:
			get_node("Rook_black" + str(f)).king_in_check = checkmate
		if get_node("Queen_black" + str(f)) != null:
			get_node("Queen_black" + str(f)).king_in_check = checkmate
