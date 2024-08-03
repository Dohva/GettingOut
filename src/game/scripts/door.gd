extends Node2D

@export var is_open: bool = false

# Unlock the door and set its state to open, allowing passage.
func unlock_door():
	print("Door unlocked")
	self.queue_free()


func _on_area_2d_body_entered(body: Node2D):
	var player := body as Player
	if not player:
		return
	if player.has_key:
		unlock_door()
		player.has_key = false
		player.key_used.emit()
