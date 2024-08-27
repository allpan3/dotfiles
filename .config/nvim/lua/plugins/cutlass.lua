return {
	"gbprod/cutlass.nvim",
	lazy = false,
	opts = {
		cut_key = "x",
		override_del = true,  -- <del> puts in blackhole register
		exclude = {"s"},
		registers = {
			delete = "d",  -- puts in "d register
			change = "c",  -- puts in "c register
		},
	},
}
