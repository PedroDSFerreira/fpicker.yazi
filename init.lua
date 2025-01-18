local state = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function fail(message, ...)
	ya.notify({ title = "Folder Picker", content = string.format(message, ...), timeout = 5, level = "error" })
end

local function dir_exists(path)
	local ok, _, code = os.rename(path, path)
	return ok or code == 13
end

local function list_dirs(path)
	local dirs = {}
	local p = io.popen("ls -d " .. path .. "/*/ 2>/dev/null")
	for dir in p:lines() do
		-- Extract and store only folder names
		table.insert(dirs, dir:match(".*/(.*)/"))
	end
	p:close()
	return dirs
end

local function entry(_, args)
	local _permit = ya.hide()
	local cwd = state()

	if not args[1] then
		return fail("Destination path not provided.")
	end
	local base_path = args[1]

	if not dir_exists(base_path) then
		return fail("Path %s does not exist.", base_path)
	end

	local dirs = list_dirs(base_path)
	if #dirs == 0 then
		return fail("No directories found.")
	end

	local fzf_cmd = string.format('echo "%s" | fzf-tmux -p 80%%', table.concat(dirs, "\n"))
	local child, err = Command(os.getenv("SHELL"))
		:args({ "-c", fzf_cmd })
		:cwd(cwd)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		return fail("Failed to run fzf: %s", err)
	end

	local output, err = child:wait_with_output()
	if not output then
		return fail("Failed to read fzf output: %s", err)
	end

	local selected_folder = output.stdout:match("^(.-)\n*$")
	if selected_folder ~= "" then
		ya.manager_emit("cd", { base_path .. "/" .. selected_folder })
	end
end

return { entry = entry }
