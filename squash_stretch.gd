extends Node3D

@export var target_node_path: NodePath = ".."
var body: CharacterBody3D

func _ready():
    if has_node(target_node_path):
        body = get_node(target_node_path)

func _process(delta):
    if body:
        var speed = body.velocity.length()
        if speed > 0.1:
            # Active moving: Bounce/Wobble based on time
            var bounce = sin(Time.get_ticks_msec() * 0.015) * 0.1
            scale = Vector3(1.0 - bounce, 1.0 + bounce, 1.0 - bounce)
        else:
            # Stopped: Smoothly return to original shape
            scale = scale.lerp(Vector3.ONE, delta * 15.0)
