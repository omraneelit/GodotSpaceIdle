@tool
extends EditorScript

# Run this from the Godot Editor by opening this script and clicking File -> Run!
func _run():
    var root = Node3D.new()
    root.name = "World1"
    
    # 1. Add Floor
    var floor = CSGBox3D.new()
    floor.name = "Floor"
    floor.size = Vector3(20, 1, 20)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.2, 0.25)
    floor.material = mat
    root.add_child(floor)
    floor.owner = root

    # 2. Add Player
    var player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.5, 0)
    player.set_script(load("res://player.gd"))
    
    var player_mesh = CSGCylinder3D.new()
    player_mesh.name = "Mesh"
    player_mesh.radius = 0.5
    player_mesh.height = 1.5
    player.add_child(player_mesh)
    
    var player_col = CollisionShape3D.new()
    player_col.name = "Collision"
    var cyl_shape = CylinderShape3D.new()
    cyl_shape.radius = 0.5
    cyl_shape.height = 1.5
    player_col.shape = cyl_shape
    player.add_child(player_col)
    
    var stacker = Node3D.new()
    stacker.name = "ItemStacker"
    stacker.position = Vector3(0, 0.5, -0.6)
    stacker.set_script(load("res://item_stacker.gd"))
    player.add_child(stacker)
    
    root.add_child(player)
    player.owner = root
    player_mesh.owner = root
    player_col.owner = root
    stacker.owner = root

    # 3. Add Ore Spawner
    var spawner = Area3D.new()
    spawner.name = "OreSpawner"
    spawner.position = Vector3(-5, 0.5, 5)
    spawner.set_script(load("res://resource_source.gd"))
    
    var spawner_col = CollisionShape3D.new()
    spawner_col.name = "Collision"
    var box_shape = BoxShape3D.new()
    box_shape.size = Vector3(3, 1, 3)
    spawner_col.shape = box_shape
    spawner.add_child(spawner_col)
    
    var spawner_mesh = CSGBox3D.new()
    spawner_mesh.name = "Mesh"
    spawner_mesh.size = Vector3(3, 0.2, 3)
    var spawner_mat = StandardMaterial3D.new()
    spawner_mat.albedo_color = Color.ORANGE
    spawner_mesh.material = spawner_mat
    spawner.add_child(spawner_mesh)
    
    root.add_child(spawner)
    spawner.owner = root
    spawner_col.owner = root
    spawner_mesh.owner = root

    # 4. Add Sell Zone
    var sell_zone = Area3D.new()
    sell_zone.name = "TradeHubSellZone"
    sell_zone.position = Vector3(5, 0.5, 5)
    sell_zone.set_script(load("res://sell_zone.gd"))
    
    var sell_col = CollisionShape3D.new()
    sell_col.name = "Collision"
    var cyl_sell_shape = CylinderShape3D.new()
    cyl_sell_shape.radius = 1.5
    cyl_sell_shape.height = 1.0
    sell_col.shape = cyl_sell_shape
    sell_zone.add_child(sell_col)
    
    var sell_mesh = CSGCylinder3D.new()
    sell_mesh.name = "Mesh"
    sell_mesh.radius = 1.5
    sell_mesh.height = 0.2
    var sell_mat = StandardMaterial3D.new()
    sell_mat.albedo_color = Color.GREEN
    sell_mesh.material = sell_mat
    sell_zone.add_child(sell_mesh)
    
    root.add_child(sell_zone)
    sell_zone.owner = root
    sell_col.owner = root
    sell_mesh.owner = root
    
    # 5. Add Camera & Light
    var cam = Camera3D.new()
    cam.name = "MainCamera"
    cam.position = Vector3(0, 10, 10)
    cam.rotation_degrees = Vector3(-45, 0, 0)
    root.add_child(cam)
    cam.owner = root
    
    var light = DirectionalLight3D.new()
    light.name = "Sun"
    light.rotation_degrees = Vector3(-45, 45, 0)
    root.add_child(light)
    light.owner = root

    # Save to disk
    var packed = PackedScene.new()
    packed.pack(root)
    var err = ResourceSaver.save(packed, "res://main.tscn")
    
    if err == OK:
        print("Success! main.tscn generated. Open it and press F5 to play!")
    else:
        print("Error saving scene: ", err)
