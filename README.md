# dodona.nvim

## Installation
packer installation:
```lua
	use({
		"xerbalind/dodona.nvim",
		requires = {
			"rcarriga/nvim-notify",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
	})
```
## Setup
```lua
	require("dodona").setup({
		token = "<PUT TOKEN HERE>",
		base_url = "https://dodona.be",
	})
```

Every code file you want to perform commands on (see next section) needs the corresponding exercise url as the first line.
Something like `https://dodona.be/nl/courses/3363/series/36080/activities/1144070225/` (just copy from browser), this url can be commented.

## Commands
- DodonaSubmit : Evaluate current buffer by sending code to dodona <br>
                (Make sure first line is full url to activity page (can be commented))
- DodonaInitActivities : create all exercise files in current dir. Navigation to the right serie is done with telescope.
- DodonaDownload: download all linked files from exercise description (url needed as first line).
- DodonaGo: go to exercise page (url needed as first line).
