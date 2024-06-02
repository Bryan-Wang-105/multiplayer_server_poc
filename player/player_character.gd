extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = str(get_multiplayer_authority())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("unreliable")
func remote_set_position(authority_position): 
	pass
#
#@rpc("authority")
#func display_message(authority_position): 
	#pass
#
#@rpc("any_peer", "call_local", "reliable", 1)
#func clicked_by_player(authority_position): 
	#pass
