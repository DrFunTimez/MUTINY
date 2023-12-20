extends Control

signal found_server
signal server_removed

var broadcastTimer : Timer
var RoomInfo = {"name": "name", "playerCount" : 0}
var broadcaster : PacketPeerUDP
var listener : PacketPeerUDP
@export var broadcastAddress : String = '192.168.0.255'
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var serverInfo : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	setup()
	
func setup():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		$Label.text="b2lp"
		print("Bound to listen Port" + str(listenPort) + "Successful!")
	else: 
		print ("Failed to bind to listen port!")
		
func setUpBroadCast(name):
	RoomInfo.name = name
	RoomInfo.PlayerCount = GameManager.Players.size()

	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAddress, listenPort)
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to Broadcast Port" + str(broadcastPort) + "Successful!")
	else:
		print ("Failed to bind to broadcast port!")
	
	$BroadcastTimer.start()
	
func _process(delta):
	if listener.get_available_packet_count()> 0:
		var serverip = listener.get_packet_ip()
		var serverport = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		
		print(serverip + str(serverport) + str(roomInfo)+str(serverport))
		
		var child = $Panel/VBoxContainer.find_child(roomInfo.name)
		if child !=null:
			child.get_node("p").text = str(data.p)
		else:
			var currentInfo = serverInfo.instantiate()
			currentInfo.get_node("name").text = str(roomInfo.name)
			#currentInfo.get_node("Ip").text = IP
			currentInfo.get_node("P").text = str(roomInfo.playerCount)
			$Panel/VBoxContainer.add_child(currentInfo)
func _on_broadcast_timer_timeout():
	print("Broadcasting Game!")
	RoomInfo.plyerCount = GameManager.Players.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)
	pass # Replace with function body.

func cleanup():
	listener.close()
	
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()
		
func _exit_tree():
	cleanup()
