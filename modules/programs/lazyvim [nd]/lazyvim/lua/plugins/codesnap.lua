return {
	"mistricky/codesnap.nvim",
	tag = "v2.0.5",
	init = function()
		-- Patch codesnap.module.load_generator before the main file requires it,
		-- so the bad `package.cpath` append never runs.
		local ok, m = pcall(require, "codesnap.module")
		if ok then
			m.load_generator = function(is_debug)
				local p = m.generator_file_path(is_debug)
				if m.generator == nil then
					m.generator = package.loadlib(p, "luaopen_generator")()
				end
				return m.generator
			end
		end
	end,
	config = function()
		-- Belt and braces: if the init patch didn't take, scrub the literal
		-- generator .so path that upstream leaves on package.cpath. Lua treats
		-- no-? entries as exact filenames, so leaving it there makes every
		-- later require() of a C module (e.g. blink_cmp_fuzzy) resolve to
		-- that .so and fail with `undefined symbol: luaopen_<modname>`.
		local entries = vim.split(package.cpath, ";", { plain = true })
		package.cpath = table.concat(
			vim.tbl_filter(function(e)
				return not e:match("codesnap%.nvim.*linux%-x86_64_generator%.so$")
			end, entries),
			";"
		)
	end,
}
