extends Button

var battle_won

func _on_pressed() -> void:
	if battle_won:
		DataBase.starting_fight = true
		get_tree().paused = false
		DataBase.battle_path.go_back()
		
	else:
		get_tree().quit()
