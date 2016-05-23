local myTable = {
	cellSize = 32,
	cellsQuant = {
		n_lines = 3,
		n_cols = 4
	},
	worldSize = {
		height = 320,
		width = 480
	},
	layers = {
		{
			name = groundLayer,
			objects = {
				size = {
					height = 8,
					width = 6
				},
				name = floor_1,
				position = {
					y = 4,
					x = 2
				}
			}
		},
		{
			name = floor,
			objects = {
				size = {
					height = 8,
					width = 6
				},
				name = floor_2,
				position = {
					y = 2,
					x = 3
				}
			}
		},
		{
			name = actionLayer,
			objects = {
				size = {
					height = 8,
					width = 6
				},
				name = box_1,
				position = {
					y = 4,
					x = 2
				}
			}
		}
	}
}

return myTable