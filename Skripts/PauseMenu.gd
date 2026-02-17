extends Control

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

func Resume() -> void:
	get_tree().paused = false
	visible = false


func Quit() -> void:
	get_tree().paused = false
	get_tree().quit()
