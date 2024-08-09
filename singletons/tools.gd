extends Node


func find(data: Array) -> int:
	return 0

func replace(data: Array, from: String, to: String) -> int:
	var count: int = 0
	for example in data:
		for message in example.messages:
			count += message.content.count(from)
			message.content = message.content.replace(from, to)
	return count

func remove_duplicates(data: Array) -> int:
	var examples: Array = []
	var count: int = 0
	var i: int = 0
	while examples.size() < data.size():
		if data[i] in examples:
			data.pop_at(i)
			count += 1
		else:
			examples.append(data[i])
			i += 1
	return count
