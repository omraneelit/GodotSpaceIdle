extends Node

var timer = 0.0
var spawn_interval = 45.0 # Spawns a ship every 45 seconds

func _process(delta):
    timer += delta
    if timer > spawn_interval:
        spawn_ship()
        timer = 0.0
        
func spawn_ship():
    var ship = load("res://alien_ship.gd").new()
    
    # Pick a random spot near the center of the world
    var random_x = randf_range(-10.0, 10.0)
    var random_z = randf_range(-10.0, 10.0)
    ship.position = Vector3(random_x, 30.0, random_z)
    
    get_tree().get_root().add_child(ship)
    print("Alien Ship Spawned at: ", ship.position)
