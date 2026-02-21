extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 1
const CARD_SMALLER_SCALE = 1

var screen_size
var card_being_dragged
var is_hovering_over_card
var player_hand_reference
var ressource_amount
var your_turn
var dropped_on_slot
var last_hovered_card

func _ready():	
	your_turn = true
	ressource_amount = DataBase.player_ressource_amount
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../Texts/Cost_Player".text = "💎".repeat(ressource_amount)
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)
	$"../InputManager".connect("left_mouse_button_clicked", on_left_click_pressed)

func on_left_click_released():
	if card_being_dragged:
		finish_drag()
	
func on_left_click_pressed():
	var card = raycast_check_for_card()
	if card:
		start_drag(card)

func _process(_delta):
	if card_being_dragged:
		card_being_dragged.global_position = get_global_mouse_position()

		
func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	
func finish_drag():
	dropped_on_slot = false
	if your_turn:
		var card_slot_found = raycast_check_for_card_slot()
		if card_slot_found and not card_slot_found.card_in_slot:
			if ressource_amount >= int(card_being_dragged.get_node("Costs").text):
				ressource_amount -= int(card_being_dragged.get_node("Costs").text)
				$"../Texts/Cost_Player".text = "💎".repeat(ressource_amount)
				card_being_dragged.scale = Vector2(CARD_SMALLER_SCALE,CARD_SMALLER_SCALE)
				card_being_dragged.card_slot_card_in = card_slot_found
				card_being_dragged.z_index = -1
				is_hovering_over_card = false
				player_hand_reference.remove_card_from_hand(card_being_dragged)
				card_being_dragged.global_position = card_slot_found.global_position
				card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
				card_slot_found.card_in_slot = true
				$"../BattleManager".player_cards_on_board.append(card_being_dragged)
				dropped_on_slot = true
	if not dropped_on_slot:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
		
	card_being_dragged = null
	
func connect_card_signals(card: Card):
	var hover_callable = Callable(self, "on_hovered_over_card")
	var hover_off_callable = Callable(self, "on_hovered_off_card")
	if not card.hovered.is_connected(hover_callable):
		card.hovered.connect(hover_callable)
	if not card.hovered_off.is_connected(hover_off_callable):
		card.hovered_off.connect(hover_off_callable)

func on_hovered_over_card(card):
	highlight_card(card, true)

func on_hovered_off_card(card):
	highlight_card(card, false)

func highlight_card(card, hovered):
	if not card_being_dragged:
		if hovered:
			card.scale = Vector2(1.5, 1.5)
			card.z_index = 2
		else:
			card.scale = Vector2(1,1)
			card.z_index = 1

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	
	if card_being_dragged:
		parameters.exclude = [card_being_dragged]
	
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider as CardSlot
	return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(params)
	for r in result:
		if r.collider is Card:  # nur echte Cards
			return r.collider
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
	
func reset_played_card():
	ressource_amount = DataBase.player_ressource_amount
	$"../Texts/Cost_Player".text = "💎".repeat(ressource_amount)
