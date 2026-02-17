extends Button

var battle_won

func _on_pressed() -> void:
	if battle_won:
		get_tree().paused = false
		DataBase.battle_path.go_back()
		
	else:
		print("defeat")
