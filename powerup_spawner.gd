extends Node

var timer = 0.0
var spawn_interval = 40.0

func _process(delta):
    timer += delta
    if timer > spawn_interval:
        var p = load("res://powerup.gd").new()
        # Spawn somewhere in the playable area
        p.position = Vector3(randf_range(-15, 15), 1.0, randf_range(-100, 10))
        get_tree().get_root().add_child(p)
        GameManager.spawn_floating_text(p.position + Vector3(0, 3, 0), "POWERUP DROPPED!", Color.YELLOW)
        timer = 0.0
