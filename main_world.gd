extends Node3D

func _ready():
    # Make sure worlds are hidden/shown properly on startup
    update_world_visibility()
    
    # Start the Alien Ship Event Director
    var alien_events = load("res://alien_ship_event.gd").new()
    add_child(alien_events)
    
    # Start the Space Pirate Director
    var pirate_events = load("res://pirate_spawner.gd").new()
    add_child(pirate_events)
    
    # Start the Powerup Spawner
    var powerups = load("res://powerup_spawner.gd").new()
    add_child(powerups)
    
    # Attach Day/Night Cycle to the main light
    var sun = get_node_or_null("Sun")
    if sun:
        sun.set_script(load("res://day_night_cycle.gd"))
        
    # Restore saved Bots and Turrets!
    SaveManager.call_deferred("restore_base")
    
    # Spawn Local Co-Op Player 2!
    var p2 = load("res://player2.gd").new()
    p2.name = "Player2"
    p2.position = Vector3(2.0, 1.5, 5.0) # Slightly to the right of Player 1
    add_child(p2)
    
    # Spawn the Endgame Rocketship in Phase 4
    var rocket = load("res://rocketship.gd").new()
    rocket.position = Vector3(0, 0, -140) # Deep at the end of World 4
    add_child(rocket)
    
    # Spawn a Factory Machine in Phase 2
    var factory = load("res://factory_machine.gd").new()
    factory.position = Vector3(-8, 1, -30) # In the middle of World 2
    add_child(factory)
    
    # Spawn a Speed Pad / Conveyor Belt returning to Phase 1
    var pad = load("res://speed_pad.gd").new()
    pad.position = Vector3(8, 0.2, -15)
    pad.rotation_degrees.y = 180 
    add_child(pad)
    
    # Spawn a Hoverbike in Phase 1
    var bike = load("res://hoverbike.gd").new()
    bike.position = Vector3(10, 1, 5)
    add_child(bike)
    
    # Spawn the Black Hole Recycler in Phase 3
    var void_hole = load("res://black_hole.gd").new()
    void_hole.position = Vector3(-12, 2, -70)
    add_child(void_hole)

func update_world_visibility():
    print("Updating universe visibility for Phase ", PhaseManager.current_phase + 1)
    
    # We have 4 phases, named Phase_1 to Phase_4
    for i in range(4):
        var phase_name = "Phase_" + str(i + 1)
        if has_node(phase_name):
            var phase_node = get_node(phase_name)
            var is_unlocked = (i <= PhaseManager.current_phase)
            
            # Hide/Show visually
            phase_node.visible = is_unlocked
            
            # Disable physics/logic if locked, enable if unlocked
            if is_unlocked:
                phase_node.process_mode = Node.PROCESS_MODE_INHERIT
            else:
                phase_node.process_mode = Node.PROCESS_MODE_DISABLED
