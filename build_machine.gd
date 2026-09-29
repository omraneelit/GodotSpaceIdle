@tool
extends EditorScript

func _run():
    var root = Node3D.new()
    root.name = "MachineModel"
    
    var mat_gray = StandardMaterial3D.new()
    mat_gray.albedo_color = Color.DARK_GRAY
    mat_gray.metallic = 0.6
    
    # Base structure
    var base = CSGBox3D.new()
    base.name = "Base"
    base.size = Vector3(2.0, 0.5, 2.0)
    base.position = Vector3(0, 0.25, 0)
    base.material = mat_gray
    root.add_child(base)
    base.owner = root
    
    # Glowing Smelter Core
    var core = CSGCylinder3D.new()
    core.name = "SmelterCore"
    core.radius = 0.8
    core.height = 1.5
    core.position = Vector3(0, 1.25, 0)
    var mat_orange = StandardMaterial3D.new()
    mat_orange.albedo_color = Color(1.0, 0.4, 0.0)
    mat_orange.emission_enabled = true
    mat_orange.emission = Color(1.0, 0.2, 0.0)
    core.material = mat_orange
    root.add_child(core)
    core.owner = root
    
    # Input Chute
    var chute = CSGBox3D.new()
    chute.name = "InputChute"
    chute.size = Vector3(1.0, 0.2, 1.0)
    chute.position = Vector3(0, 1.0, 1.0)
    chute.rotation_degrees = Vector3(-30, 0, 0)
    chute.material = mat_gray
    root.add_child(chute)
    chute.owner = root
    
    # Save Model
    var packed = PackedScene.new()
    packed.pack(root)
    ResourceSaver.save(packed, "res://models/machine_model.tscn")
    print("Procedural Machine Model generated successfully!")
