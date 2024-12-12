extends Node

var result = []

func load_csv(path : String, limit : int):
	var file = FileAccess.open(path, FileAccess.READ)
	var headers = file.get_csv_line ()
	while !file.eof_reached():
		var line : Array = file.get_csv_line ()
		result.append(line)
		if limit > 0 and len(result) > limit:
			break
	file.close()
	return result

