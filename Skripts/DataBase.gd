extends Node

class_name Card_Data

var damage: int
var health: int
var card_name: String
var cost: int
var effects: Array
var image_path: String
var toe_finger_places : Array
var left_or_right : bool

var deck_list = []
var starting = true
var starting_fight = true

func _init(args := {}):
	# Default-Werte
	damage = args.get("damage", 0)
	health = args.get("health", 1)
	card_name = args.get("name", "")
	cost = args.get("cost", 1)
	effects = args.get("effects", [])
	image_path = args.get("image_path", "")
	toe_finger_places = args.get("toe_finger_places", [false,false,false,false,false])
	left_or_right =  args.get("left_or_right", false)
	
var player_effects = []
var opponent_effects = []
var player_health = 5
var opponent_health = 8
var player_ressource_amount = 2
var points = 0

var cards = {
	"Card1" : [4, 1],
	"Card2" : [0, 5],
	"Card3" : [1, 6],
}

var deck_enemy = []
var level = 0
var battle_path
