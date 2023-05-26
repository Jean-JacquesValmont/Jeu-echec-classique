extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://plateau_echec.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_timer_option_pressed():
	if Global.timer_option_enable == false:
		Global.timer_option_enable = true
		get_node("Timer_option/OptionButton").visible = true
	else:
		Global.timer_option_enable = false
		get_node("Timer_option/OptionButton").visible = false

func _on_preview_piece_move_option_pressed():
	if Global.preview_piece_move_option == false:
		Global.preview_piece_move_option = true
	else:
		Global.preview_piece_move_option = false

func _on_option_button_item_selected(index):
	if index == 0:
		Global.timer_select = 180
	elif index == 1:
		Global.timer_select = 300
	elif index == 2:
		Global.timer_select = 600
