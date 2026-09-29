@tool
extends EditorScript

# Run this to generate the ENTIRE 4-Phase Universe!
func _run():
    var root = Node3D.new()
    root.name = "Main"
    root.set_script(load("res://main_world.gd")) # We will make this to handle visibility
    
    # UI Layer
    var ui = CanvasLayer.new()
    ui.name = "UIManager"
    ui.set_script(load("res://ui_manager.gd"))
    root.add_child(ui)
    ui.owner = root

    # Camera & Light
    var cam = Camera3D.new()
    cam.name = "MainCamera"
    cam.position = Vector3(0, 15, 12)
    cam.rotation_degrees = Vector3(-50, 0, 0)
    # Give camera a simple follow script (we'll assume the player is called "Player")
    cam.set_script(load("res://camera_follow.gd"))
    root.add_child(cam)
    cam.owner = root
    
    var light = DirectionalLight3D.new()
    light.name = "Sun"
    light.rotation_degrees = Vector3(-45, 45, 0)
    root.add_child(light)
    light.owner = root

    # --- Generate The 4 Phases ---
    var colors = [Color(0.2, 0.2, 0.25), Color(0.1, 0.3, 0.2), Color(0.3, 0.1, 0.1), Color(0.1, 0.1, 0.3)]
    var names = ["Ore Phase", "Energy Phase", "Bio Phase", "Robo Phase"]
    
    for i in range(4):
        var phase_node = Node3D.new()
        phase_node.name = "Phase_" + str(i + 1)
        var z_offset = i * -40 # Spread them out along the Z axis
        phase_node.position = Vector3(0, 0, z_offset)
        root.add_child(phase_node)
        phase_node.owner = root
        
        # Floor
        var floor = CSGBox3D.new()
        floor.name = "Floor"
        floor.size = Vector3(25, 1, 25)
        var mat = StandardMaterial3D.new()
        mat.albedo_color = colors[i]
        floor.material = mat
        phase_node.add_child(floor)
        floor.owner = root
        
        # Spawner
        var spawner = Area3D.new()
        spawner.name = "Spawner_" + str(i+1)
        spawner.position = Vector3(-6, 0.5, 0)
        spawner.set_script(load("res://resource_source.gd"))
        var scol = CollisionShape3D.new()
        scol.shape = BoxShape3D.new()
        scol.shape.size = Vector3(3,1,3)
        spawner.add_child(scol)
        var smesh = CSGBox3D.new()
        smesh.size = Vector3(3, 0.2, 3)
        var smat = StandardMaterial3D.new()
        smat.albedo_color = Color.ORANGE
        smesh.material = smat
        spawner.add_child(smesh)
        phase_node.add_child(spawner)
        spawner.owner = root; scol.owner = root; smesh.owner = root
        
        # Sell Zone
        var sell = Area3D.new()
        sell.name = "SellZone_" + str(i+1)
        sell.position = Vector3(6, 0.5, 0)
        sell.set_script(load("res://sell_zone.gd"))
        sell.set("price_per_item", 15 * (i + 1)) # Scaling prices!
        var sellcol = CollisionShape3D.new()
        var cyl = CylinderShape3D.new()
        cyl.radius = 2.0; cyl.height = 1.0;
        sellcol.shape = cyl
        sell.add_child(sellcol)
        var sellmesh = CSGCylinder3D.new()
        sellmesh.radius = 2.0; sellmesh.height = 0.2;
        var sellmat = StandardMaterial3D.new()
        sellmat.albedo_color = Color.GREEN
        sellmesh.material = sellmat
        sell.add_child(sellmesh)
        phase_node.add_child(sell)
        sell.owner = root; sellcol.owner = root; sellmesh.owner = root
        
        # Unlock Gate (Except for last phase)
        if i < 3:
            var bridge = CSGBox3D.new()
            bridge.size = Vector3(4, 0.5, 15)
            bridge.position = Vector3(0, -0.25, -20)
            phase_node.add_child(bridge)
            bridge.owner = root
            
            var gate = Area3D.new()
            gate.name = "UnlockGate_To_Phase_" + str(i+2)
            gate.position = Vector3(0, 0.5, -13)
            gate.set_script(load("res://unlock_gate.gd"))
            gate.set("cost", 100 * (i + 1)) # 100, 200, 300
            
            var gatecol = CollisionShape3D.new()
            var gbox = BoxShape3D.new()
            gbox.size = Vector3(5, 3, 2)
            gatecol.shape = gbox
            gate.add_child(gatecol)
            
            var gatemesh = CSGBox3D.new()
            gatemesh.size = Vector3(5, 3, 2)
            var gmat = StandardMaterial3D.new()
            gmat.albedo_color = Color.RED
            gmat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
            gmat.albedo_color.a = 0.5
            gatemesh.material = gmat
            gate.add_child(gatemesh)
            
            phase_node.add_child(gate)
            gate.owner = root; gatecol.owner = root; gatemesh.owner = root

    # 4. Add Player (Starts at Phase 1)
    var player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.5, 5)
    player.set_script(load("res://player.gd"))
    
    var player_mesh = CSGCylinder3D.new()
    player_mesh.radius = 0.5; player_mesh.height = 1.5;
    player.add_child(player_mesh)
    
    var player_col = CollisionShape3D.new()
    var cyl_shape = CylinderShape3D.new()
    cyl_shape.radius = 0.5; cyl_shape.height = 1.5;
    player_col.shape = cyl_shape
    player.add_child(player_col)
    
    var stacker = Node3D.new()
    stacker.name = "ItemStacker"
    stacker.position = Vector3(0, 0.5, -0.6)
    stacker.set_script(load("res://item_stacker.gd"))
    player.add_child(stacker)
    
    root.add_child(player)
    player.owner = root; player_mesh.owner = root; player_col.owner = root; stacker.owner = root

    # Save to disk
    var packed = PackedScene.new()
    packed.pack(root)
    var err = ResourceSaver.save(packed, "res://universe.tscn")
    
    if err == OK:
        print("MASSIVE UNIVERSE GENERATED (universe.tscn)!")
    else:
        print("Error saving universe: ", err)
