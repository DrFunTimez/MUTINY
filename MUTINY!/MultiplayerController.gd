extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer
var compression = ENetConnection.COMPRESS_RANGE_CODER
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostgame()

func hostgame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 10)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		
	multiplayer.set_multiplayer_peer(peer)
	print("waiting For Players!")
	
	
	
func _process(delta):
	pass
	
	
###################################################################################################
# This Gets called on the server and clients
func peer_connected(id):
	print("Player Connected" + str(id))

# This Gets called on the server and clients
func peer_disconnected(id):
	print("Player Dissconnected" + str(id))

#This Gets called only from clients
func connected_to_server():
	print("connected_to_server!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id()) 
	
#This gets called only from clients
func connection_failed():
	print("couldn't connect ")
###################################################################################################
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
			
@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://main_game.tscn").instantiate()
	get_tree().root.add_child(scene)


func _on_host_button_down():
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	hostgame()
	$ServerBrowser.setUpBroadCast($LineEdit.text + "'s server")
	
func _on_start_game_button_down():
	StartGame.rpc() 

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)


func _on_button_button_down():
	GameManager.Players[GameManager.Players.size()+1] = {
			"name": "test",
			"id": 1
		}
