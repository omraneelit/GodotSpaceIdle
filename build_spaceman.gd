@tool
extends EditorScript

func _run():
    var root = Node3D.new()
    root.name = "SpacemanModel"
    
    var mat_white = StandardMaterial3D.new()
    mat_white.albedo_color = Color.WHITE
    
    # Body
    var body = CSGCylinder3D.new()
    body.name = "Body"
    body.radius = 0.4
    body.height = 1.0
    body.position = Vector3(0, 0.5, 0)
    body.material = mat_white
    root.add_child(body)
    body.owner = root
    
    # Head
    var head = CSGSphere3D.new()
    head.name = "Head"
    head.radius = 0.35
    head.position = Vector3(0, 1.1, 0)
    head.material = mat_white
    root.add_child(head)
    head.owner = root
    
    # Visor (Gold & Reflective)
    var visor = CSGBox3D.new()
    visor.name = "Visor"
    visor.size = Vector3(0.5, 0.25, 0.3)
    visor.position = Vector3(0, 1.1, 0.2)
    var mat_gold = StandardMaterial3D.new()
    mat_gold.albedo_color = Color(1.0, 0.8, 0.2)
    mat_gold.metallic = 0.8
    mat_gold.roughness = 0.2
    visor.material = mat_gold
    root.add_child(visor)
    visor.owner = root
    
    # Jetpack / Backpack
    var pack = CSGBox3D.new()
    pack.name = "Backpack"
    pack.size = Vector3(0.6, 0.7, 0.3)
    pack.position = Vector3(0, 0.6, -0.45)
    pack.material = mat_white
    root.add_child(pack)
    pack.owner = root
    
    # Save Model
    var packed = PackedScene.new()
    packed.pack(root)
    ResourceSaver.save(packed, "res://models/spaceman_model.tscn")
    print("Procedural Spaceman Model generated successfully!")
