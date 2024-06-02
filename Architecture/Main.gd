extends Node

# Scenes
@onready var main: Node = $"."

# Networking
const DEFAULT_PORT: int = 9999

# Menu
@onready var vbox: VBoxContainer = $"Main Menu/VBoxContainer"
const printOn = true

# Game State
var connected_players = []
var game_world


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if printOn:
		print("A: Ready - creating peer connection function and starting server")
	multiplayer.peer_connected.connect(self._peer_connected)
	start_server()
	pass # Replace with function body.

func start_server() -> void:
	if printOn:
		print("B: Starting server")
	var port: int = DEFAULT_PORT
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	create_game()

func create_game() -> void:
	game_world = load("res://Architecture/game_world.tscn").instantiate()
	main.add_child(game_world)

func _peer_connected(id: int) -> void:
	if printOn:
		print("C: A player of ID %s has joined the server!" % id)
	
	# Wait?
	await get_tree().create_timer(1).timeout
	
	# Have newly connected peer get game state of current players
	rpc_id(id, "add_prev_connected_players", connected_players)
	print("D: Calling RPC on newly connected player ID to add previous player list")
	rpc("add_newly_connected_player", id)
	print("E: Calling RPC on all players to add the new player")
	
	# Modify connections list
	connected_players.append((id))
	
	# Instantiate player character and set multiplayer id
	var player_character = preload("res://player/player_character.tscn").instantiate()
	player_character.set_multiplayer_authority(id)
	
	game_world.add_child(player_character)
	
	_print_to_vbox("Peer %s connected and added to list of players [size: %s]." % [id, len(connected_players)])

@rpc("call_remote")
func add_newly_connected_player(id):
	pass

@rpc("call_remote")
func add_prev_connected_players(connected_players):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# LOGGING ############################################
func _print_to_vbox(text: String) -> void:
	if printOn:
		print("D: Printing to screen")
	var newLbl: Label = Label.new()
	newLbl.text = text
	vbox.add_child(newLbl)
	newLbl.set_owner(vbox)
