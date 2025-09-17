class_name AnylandJson2ResourceBuilder
extends Node

@export var debug_thing_object: AnylandThingResource;
@export var parse: Dictionary;

func _ready() -> void:
	var file: FileAccess = FileAccess.open("res://assets/test/huntress-body-2022-08-04-22-40-27.json", FileAccess.READ);
	var content = file.get_as_text();
	
	parse = JSON.parse_string(content);
	
	debug_thing_object = build_resource(parse);

func build_resource(thing_json: Dictionary) -> AnylandThingResource: ## Build a resource from json
	var thing: AnylandThingResource = AnylandThingResource.new();
	
	thing.name = thing_json.get("n", "Name Not Found")
	thing.description = thing_json.get("d", "");
	
	for a in thing_json.get("a", 0):
		thing.attributes.append(int(a));
	
	for p in thing_json.get("p"):
		var part: AnylandThingPartResource = AnylandThingPartResource.new();
		
		# set basic part info
		part.base_shape_type = p.get("b", -1);
		part.material_type = p.get("t", -1);
		
		# get part attributes
		if p.get("a") != null:
			for pa in p.get("a"):
				part.attributes.append(int(pa));
			
			thing.parts.append(part); # add to part list
	
	return thing;
