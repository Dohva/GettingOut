extends Node

const FOLLOW_SPEED: float = 4.0

var attached_body: Node2D

func _process(delta: float):
	follow_body(delta)
	hover(delta)
	

func follow_body(delta: float):
	if not attached_body:
		return
	if self.position.distance_to(attached_body.position) > 14:
		self.position = self.position.lerp(attached_body.position, delta * FOLLOW_SPEED)


func hover(delta: float):
	$Path2D/PathFollow2D.progress += 4.0 * delta


func _on_area_2d_body_entered(body: Node2D):
	if attached_body:
		return
	# Cast body to Player, if body is not a Player it will be null and fail silently. Only Player can pick up keys.
	var player := body as Player
	if not player:
		return
	attached_body = player
	player.has_key = true


func _on_key_used():
	self.queue_free()
