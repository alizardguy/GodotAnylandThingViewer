class_name AnylandVisualBuilder
extends Node

func _ready() -> void:
	
	var file: FileAccess = FileAccess.open("res://assets/test/huntress-body-2022-08-04-22-40-27.json", FileAccess.READ);
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
	
	thing_object.rotation = Vector3(0,0,deg_to_rad(90))
	
	for part in thing_resource.parts:
		
		var visual_instance: MeshInstance3D = MeshInstance3D.new();
		
		visual_instance.mesh = load ("res://assets/mesh/base_shapes/" + str(part.base_shape_type) + ".obj")
		thing_object.add_child(visual_instance);
		
		visual_instance.position = part.states[0].position;
		visual_instance.scale = part.states[0].scale;
		visual_instance.rotation = part.states[0].rotation;
		
		var material: StandardMaterial3D = StandardMaterial3D.new();
		material.albedo_color = part.states[0].color;
		visual_instance.material_override = material;
		
		
		
	
	return thing_object;
