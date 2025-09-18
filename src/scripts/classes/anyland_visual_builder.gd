class_name AnylandVisualBuilder
extends Node

func _ready() -> void:
	get_window().files_dropped.connect(_on_file_dropped); # debug
	
	#var file: FileAccess = FileAccess.open("res://assets/test/huntress-body.json", FileAccess.READ);
	#var content = file.get_as_text();
	
	#var parse = JSON.parse_string(content);
	
	#var resource_builder: AnylandJson2ResourceBuilder = AnylandJson2ResourceBuilder.new();
	#resource_builder.name = "ResourceBuilder";
	#self.add_child(resource_builder);
	
	#var thing_resource = resource_builder.build_resource(parse);
	#var visual = build_visual(thing_resource);
	
	#self.add_child(visual);

func _on_file_dropped(files: PackedStringArray): # debug
	print(files[0])
	
	var file: FileAccess = FileAccess.open(files[0], FileAccess.READ);
	var content = file.get_as_text();
	
	var parse = JSON.parse_string(content);
	
	var resource_builder: AnylandJson2ResourceBuilder = AnylandJson2ResourceBuilder.new();
	resource_builder.name = "ResourceBuilder";
	self.add_child(resource_builder);
	
	var thing_resource = resource_builder.build_resource(parse);
	var visual = build_visual(thing_resource);
	
	self.add_child(visual);


func build_visual(thing_resource: AnylandThingResource) -> Node3D:
	var thing_object: Thing = Thing.new();
	
	thing_object.thing_data = thing_resource;
	thing_object.name = thing_resource.name;
	
	#thing_object.rotation = Vector3(0,0,deg_to_rad(90))
	
	for part in thing_resource.parts:
		
		var visual_instance: MeshInstance3D = MeshInstance3D.new();
		
		if part.base_shape_type == -1:
			print("Invalid part id");
		
		visual_instance.mesh = load ("res://assets/mesh/base_shapes/" + str(part.base_shape_type) + ".obj")
		thing_object.add_child(visual_instance);
		
		visual_instance.position = part.states[0].position;
		visual_instance.scale = part.states[0].scale;
		visual_instance.rotation = part.states[0].rotation;
		
		var existing_material: bool = false;
		var holdout_material: StandardMaterial3D;
		
		if thing_object.thing_materials.is_empty() == false:
			for m in thing_object.thing_materials:
				if m.albedo_color == part.states[0].color:
					if part.states.size() > 1:
						continue
					
					existing_material = true;
					holdout_material = m;
					break;
		
		if existing_material:
			visual_instance.material_override = holdout_material;
		else:
			var material: StandardMaterial3D = StandardMaterial3D.new();
			material.albedo_color = part.states[0].color;
			visual_instance.material_override = material;
			thing_object.thing_materials.append(material);
		
		if !part.attributes.is_empty():
			for at in part.attributes:
				
				if at == 32 or at == 33 or at == 34: # sideways, vertical, depth
					thing_object.add_child(reflect_philipp_style(visual_instance, part.attributes));
		
		#if !part.changed_verts.is_empty():
		#	var mdt: MeshDataTool = MeshDataTool.new();
		#		
		#	mdt.create_from_surface(visual_instance.mesh, 0);
		#	
		#	for tweak in part.changed_verts:
		#		print(mdt.get_vertex(int(tweak[3])))
		#		mdt.set_vertex(int(tweak[3]), Vector3(mdt.get_vertex(tweak[3]) + Vector3(tweak[0], tweak[1], tweak[2])));
		#		print(mdt.get_vertex(int(tweak[3])))
		#		
		#		mdt.commit_to_surface(visual_instance.mesh);
		
	
	return thing_object;

func reflect_philipp_style(source_part: MeshInstance3D, attributes: Array) -> MeshInstance3D:
	var sideways: bool = false;
	var vertical: bool = false;
	var depth: bool = false;
	
	var new_part: MeshInstance3D;
	new_part = source_part.duplicate();
	
	new_part.name = "mirror " + source_part.name + str(attributes);
	
	for a in attributes:
		if a == 32:
			sideways = true;
		elif a == 33:
			vertical = true;
		elif a == 34:
			depth = true;
	
	var source_rot: Quaternion = source_part.quaternion;
	
	if sideways and !vertical and !depth:
		var new_rot: Quaternion = Quaternion(source_rot.x * -1, source_rot.y, source_rot.z, -source_rot.w);
		new_part.basis = Basis(new_rot).scaled_local(source_part.scale);
		new_part.position = source_part.position * Vector3(-1, 1, 1);
		
	elif !sideways and vertical and !depth:
		var new_rot: Quaternion = Quaternion(source_rot.x * -1, source_rot.y, source_rot.z, -source_rot.w * -1);
		new_part.basis = Basis(new_rot).scaled_local(source_part.scale);
		new_part.rotation = new_part.rotation + Vector3(0, deg_to_rad(180), 0);
		new_part.position = source_part.position * Vector3(1, -1 , -1);
		
	elif sideways and vertical and !depth:
		new_part.position = source_part.position + Vector3(0, deg_to_rad(180), 0);
		new_part.position = source_part.position * Vector3(1, 1, -1);
		
	elif sideways and !vertical and depth:
		var new_rot: Quaternion = Quaternion(source_rot.x, source_rot.y, source_rot.z * -1, -source_rot.w * -1);
		new_part.basis = Basis(new_rot).scaled_local(source_part.scale);
		new_part.position = source_part.position * Vector3(-1, -1, 1);
		
	elif sideways and vertical and depth:
		var new_rot: Quaternion = Quaternion(source_rot.x * -1, source_rot.y * -1, source_rot.z * -1, -source_rot.w * -1);
		new_part.basis = Basis(new_rot).scaled_local(source_part.scale);
		new_part.rotation = new_part.rotation + Vector3(deg_to_rad(180), 0, 0);
		new_part.position = source_part.position * Vector3(-1, -1 , -1);
		
	elif !sideways and !vertical and depth:
		var new_rot: Quaternion = Quaternion(source_rot.x * -1, source_rot.y * -1, source_rot.z * -1, -source_rot.w * -1);
		new_part.basis = Basis(new_rot).scaled_local(source_part.scale);
		new_part.position = source_part.position * Vector3(1, -1, 1);
		
	elif !sideways and vertical and depth:
		var new_rot: Quaternion = Quaternion(source_rot.x, source_rot.y, source_rot.z * -1, -source_rot.w * -1);
		new_part.basis = Basis(new_rot).scaled_local(source_part.scale);
		new_part.position = source_part.position * Vector3(1, -1, -1);
	
	return new_part;
