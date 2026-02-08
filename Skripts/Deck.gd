extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2
const STARTING_HAND_SIZE = 3

var player_deck
var drawn_card_this_turn = false
var ready_to_start = false
var drawn_card

func _ready() -> void:
	player_deck = DataBase.deck_list.duplicate()
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_card_this_turn = false

func draw_card():
	if drawn_card_this_turn:
		return
	if player_deck.size() == 0:
		return
	drawn_card = player_deck[0]
	player_deck.erase(drawn_card)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate() as Card
	
	new_card.set_data(drawn_card)
	$"../CardManager".add_child(new_card)
	$"../CardManager".connect_card_signals(new_card)
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")
	
	drawn_card_this_turn = true
	
func reset_draw():
	drawn_card_this_turn = false
