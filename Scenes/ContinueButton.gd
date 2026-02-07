extends Button

var battle_won

func _on_pressed() -> void:
	if battle_won:
		get_tree().change_scene_to_file("res://Scenes/AddingCards.tscn")
	else:
		print("defeat")
