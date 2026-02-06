extends Node

class_name Card

var attack: int
var health: int
var card_name: String
var cost: int
var effects: Array
var image_path: String

var deck_list = []

func _init(args := {}):
	# Default-Werte
	attack = args.get("damage", 0)
	health = args.get("health", 1)
	card_name = args.get("name", "NoName")
	cost = args.get("cost", 1)
	effects = args.get("effects", [])
	image_path = args.get("image_path", "")

const CARDS = {
	"Card1" : [4, 1],
	"Card2" : [0, 5],
	"Card3" : [1, 6],
}

var level = 0
