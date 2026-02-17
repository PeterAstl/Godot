extends Node2D


const CARD_SCENE_PATH = "res://Scenes/OpponentCard.tscn"
const CARD_DRAW_SPEED = 0.5
const STARTING_HAND_SIZE = 2

var opponent_deck = DataBase.deck_enemy.duplicate()
var card_database_reference
var card_drawn_name

func _ready() -> void:
	opponent_deck.shuffle()
	card_database_reference = preload("res://Skripts/DataBase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()

func draw_card():
	card_drawn_name = opponent_deck[0]
	opponent_deck.erase(card_drawn_name)
	if opponent_deck.size() == 0:
		$Sprite2D.visible = false

	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate() as Card_Enemy
	
	new_card.set_data(card_drawn_name)
	$"../CardManager".add_child(new_card)
	new_card.rotation_degrees = 180
	$"../OpponentHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")
	
	
