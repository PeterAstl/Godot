extends Node2D

var button
var upgrade_list = {
	"upgrade_1": "res://Scenes/Upgrade_Health.tscn",
	"upgrade_2": "res://Scenes/Upgrade_Damage.tscn",
	"upgrade_3": "res://Scenes/Upgrade_Gambling.tscn",
	"upgrade_4": "res://Scenes/Upgrade_PlayerEffects.tscn",
}

var upgrade_choice
var upgrade_path
var route_scene = preload("res://Scenes/LevelPath.tscn")
var route_instance
var other_scene
var path
var scene
var buttons = []
var upgrade_path_d

func _ready() -> void:
	for i in range(1,21):
		upgrade_choice = upgrade_list.keys().pick_random()
		upgrade_path = "res://Pics/UpgradeIcon/" + upgrade_choice + ".png"
		upgrade_path_d = "res://Pics/UpgradeIcon/" + upgrade_choice + "d.png"
		button = get_node("Button_Manager/TextureButton" + str(i))
		button.texture_normal = load(upgrade_path)
		button.set_meta("feld", upgrade_list[upgrade_choice])
		buttons.append(button)
		button.texture_disabled = load(upgrade_path_d)
		
		
func choice_made(choice):
	scene = get_tree().current_scene
	scene.visible = false
	other_scene = load(choice).instantiate()
	get_tree().get_root().add_child(other_scene)
	DataBase.battle_path = $"."
	
func go_back():
	other_scene.queue_free()
	scene.visible = true
	for card in DataBase.deck_list:
		if "scaling" in card:
			card.damage += 1
			card.health += 1

func fight_scene():
	other_scene.queue_free()
	path = "res://Scenes/main.tscn"
	choice_made(path)
	
func diasbling_enabling_buttons(button_name):
	var button_number = str(button_name.name)
	button_number = int(button_number.replace("TextureButton", ""))
	if button_number in [1,2]:
		buttons[0].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[1].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton1.disabled = true
		$Button_Manager/TextureButton2.disabled = true
		$Button_Manager/TextureButton3.disabled = false
		DataBase.level = 1
	if button_number == 3:
		buttons[2].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton3.disabled = true
		$Button_Manager/TextureButton4.disabled = false
		$Button_Manager/TextureButton5.disabled = false
		DataBase.level = 2
	if button_number in [4,5]:
		buttons[3].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[4].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton4.disabled = true
		$Button_Manager/TextureButton5.disabled = true
		$Button_Manager/TextureButton6.disabled = false
		$Button_Manager/TextureButton7.disabled = false
		$Button_Manager/TextureButton8.disabled = false
		DataBase.level = 3
	if button_number in [6,7,8]:
		buttons[5].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[6].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[7].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton6.disabled = true
		$Button_Manager/TextureButton7.disabled = true
		$Button_Manager/TextureButton8.disabled = true
		$Button_Manager/TextureButton9.disabled = false
		$Button_Manager/TextureButton10.disabled = false
		DataBase.level = 4
	if button_number in [9,10]:
		buttons[8].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[9].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton9.disabled = true
		$Button_Manager/TextureButton10.disabled = true
		$Button_Manager/TextureButton11.disabled = false
		$Button_Manager/TextureButton12.disabled = false
		$Button_Manager/TextureButton13.disabled = false
		DataBase.level = 5
	if button_number in [11,12,13]:
		buttons[10].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[11].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[12].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton11.disabled = true
		$Button_Manager/TextureButton12.disabled = true
		$Button_Manager/TextureButton13.disabled = true
		$Button_Manager/TextureButton14.disabled = false
		$Button_Manager/TextureButton15.disabled = false
		DataBase.level = 6
	if button_number in [14,15]:
		buttons[13].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[14].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton14.disabled = true
		$Button_Manager/TextureButton15.disabled = true
		$Button_Manager/TextureButton16.disabled = false
		$Button_Manager/TextureButton17.disabled = false
		$Button_Manager/TextureButton18.disabled = false
		DataBase.level = 7
	if button_number in [16, 17, 18]:
		buttons[15].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[16].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[17].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton16.disabled = true
		$Button_Manager/TextureButton17.disabled = true
		$Button_Manager/TextureButton18.disabled = true
		$Button_Manager/TextureButton19.disabled = false
		$Button_Manager/TextureButton20.disabled = false
		DataBase.level = 8
	if button_number in [19,20]:
		buttons[18].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		buttons[19].texture_disabled = load("res://Pics/UpgradeIcon/upgrade_disabled.png")
		$Button_Manager/TextureButton19.disabled = true
		$Button_Manager/TextureButton20.disabled = true
		$Button_Manager/Heart.disabled = false
		DataBase.level = 9
		

func Button1() -> void:
	diasbling_enabling_buttons(buttons[0])
	choice_made(buttons[0].get_meta("feld"))
	
func Button2() -> void:
	diasbling_enabling_buttons(buttons[1])
	choice_made(buttons[1].get_meta("feld"))
		
func Button3() -> void:
	diasbling_enabling_buttons(buttons[2])
	choice_made(buttons[2].get_meta("feld"))
		
func Button4() -> void:
	diasbling_enabling_buttons(buttons[3])
	choice_made(buttons[3].get_meta("feld"))

func Button5() -> void:
	diasbling_enabling_buttons(buttons[4])
	choice_made(buttons[4].get_meta("feld"))

func Button6() -> void:
	diasbling_enabling_buttons(buttons[5])
	choice_made(buttons[5].get_meta("feld"))

func Button7() -> void:
	diasbling_enabling_buttons(buttons[6])
	choice_made(buttons[6].get_meta("feld"))

func Button8() -> void:
	diasbling_enabling_buttons(buttons[7])
	choice_made(buttons[7].get_meta("feld"))

func Button9() -> void:
	diasbling_enabling_buttons(buttons[8])
	choice_made(buttons[8].get_meta("feld"))

func Button10() -> void:
	diasbling_enabling_buttons(buttons[9])
	choice_made(buttons[9].get_meta("feld"))

func Button11() -> void:
	diasbling_enabling_buttons(buttons[10])
	choice_made(buttons[10].get_meta("feld"))

func Button12() -> void:
	diasbling_enabling_buttons(buttons[11])
	choice_made(buttons[11].get_meta("feld"))

func Button13() -> void:
	diasbling_enabling_buttons(buttons[12])
	choice_made(buttons[12].get_meta("feld"))

func Button14() -> void:
	diasbling_enabling_buttons(buttons[13])
	choice_made(buttons[13].get_meta("feld"))

func Button15() -> void:
	diasbling_enabling_buttons(buttons[14])
	choice_made(buttons[14].get_meta("feld"))

func Button16() -> void:
	diasbling_enabling_buttons(buttons[15])
	choice_made(buttons[15].get_meta("feld"))

func Button17() -> void:
	diasbling_enabling_buttons(buttons[16])
	choice_made(buttons[16].get_meta("feld"))

func Button18() -> void:
	diasbling_enabling_buttons(buttons[17])
	choice_made(buttons[17].get_meta("feld"))

func Button19() -> void:
	diasbling_enabling_buttons(buttons[18])
	choice_made(buttons[18].get_meta("feld"))

func Button20() -> void:
	diasbling_enabling_buttons(buttons[19])
	choice_made(buttons[19].get_meta("feld"))
	
func ButtonHeart() -> void:
	path = "res://Scenes/AddingCards.tscn"
	choice_made(path)
