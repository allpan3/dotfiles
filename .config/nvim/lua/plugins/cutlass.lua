return {
	"gbprod/cutlass.nvim",
	lazy = false,
	opts = {
		cut_key = "x",
		override_del = true,  -- <del> puts in blackhole register
		exclude = {"ns", "nS"},
    -- Putting daleted/changed text in a named register will cause " register to still be written. When we
    -- set clipboard to + register by default, we won't use " so things are fine (+ isn't affected by named register).
    -- However, There's some issue with OSC 52 that forced us to paste from the " register instead of the + register in the remote machine.
    -- This forces us to always write to black hole register in order to keep " untouched, so we cannot use a named register here, at least for now.
		-- registers = {
		-- 	delete = "d",  -- puts in "d register
		-- 	change = "c",  -- puts in "c register
		-- },
	},
}
