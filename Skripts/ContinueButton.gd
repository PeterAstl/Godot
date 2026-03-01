extends Button

var battle_won

func _input(event):
	if  $".".visible == true and event.is_action_pressed("end_turn"):
		get_tree().paused = false
		DataBase.battle_path.go_back()
		
func _on_pressed() -> void:
	if battle_won:
		DataBase.starting_fight = true
		get_tree().paused = false
		DataBase.battle_path.go_back()
		
	else:
		get_tree().quit()
