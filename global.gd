extends Node


var player : Node3D

var loaded_sceane : String 

func _ready() -> void:
	pass # Replace with function body.


func pause_unpause():
	$pause_menu.visible = not $pause_menu.visible
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		$pause_menu/Control/VBoxContainer/continue.grab_focus()

var the_game_is_over : bool = false
func game_over():
	$game_over_screen.visible = true
	$game_over_screen/GameOver/VBoxContainer/retry.grab_focus()
	the_game_is_over = true

func contract_complete():
	$win_screen.visible = true
	$win_screen/contract_complete/VBoxContainer/retry.grab_focus()

func _process(delta: float) -> void:
	if not the_game_is_over and Input.is_action_just_pressed("pause"):
		pause_unpause()
	


func _on_continue_pressed() -> void:
	pause_unpause()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_retry_pressed() -> void:
	$game_over_screen.visible = false
	$win_screen.visible = false
	get_tree().reload_current_scene()
	the_game_is_over = false
