extends Area2D

@onready var hud: CanvasLayer = $"../../HUD"
@onready var coin: AudioStreamPlayer2D = $coin
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	animated_sprite_2d.queue_free()
	collision_shape_2d.queue_free()
	coin.play()
	await coin.finished
	hud.add_point()
	queue_free()
