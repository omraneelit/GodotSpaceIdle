extends Area3D

@export var cost: int = 50
var timer = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.name == "Player":
            if cost > 0:
                timer += delta
                if timer > 0.05:
                    if GameManager.spend_money(5):
                        cost -= 5
                        timer = 0.0
                        GameManager.spawn_floating_text(global_position + Vector3(0, 2, 0), "-$5", Color.RED)
                        
                        if cost <= 0:
                            buy_hat(body)

func buy_hat(player: Node3D):
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "TOP HAT UNLOCKED!", Color.WHITE)
    ParticleManager.spawn_poof(global_position, Color.WHITE)
    
    # Check if they already have a hat
    if not player.has_node("TopHat"):
        var hat = load("res://top_hat.gd").new()
        hat.name = "TopHat"
        player.add_child(hat)
    
    queue_free()
