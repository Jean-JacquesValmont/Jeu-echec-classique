extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var mouse_pos = get_local_mouse_position()
	
	#Pour cliquer sur la promotion que l'on veut sélectionner(Knight-Bishop-Rook-Queen)
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT\
	and mouse_pos.x >= 0 and mouse_pos.x <= 80 and mouse_pos.y >= 0 and mouse_pos.y <= 50:
			get_child(0).visible = true
			get_child(1).visible = true
			Global.timer_menu_stop = true
				
			
		
func _on_button_menu_continue_pressed():
	get_child(0).visible = false
	get_child(1).visible = false
	Global.timer_menu_stop = false

func _on_button_menu_back_pressed():
	Global.preview_piece_move_option = false
	Global.timer_option_enable = false
	Global.timer_menu_stop = false
	get_tree().change_scene_to_file("res://menu.tscn")
