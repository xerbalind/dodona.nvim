# dodona.nvim

## Installation
**Only** packer installation is currently supported:
```lua
	use({
		"xand203/dodona.nvim",
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
	base_url = "https://dodona.ugent.be",
})
```
## Commands
- DodonaSubmit : Evaluate current buffer by sending code to dodona <br>
                (Make sure first line is full url to activity page (can be commented ))
- DodonaInitActivities : create all exercise files in current dir. Navigation to the right serie is done with telescope.
- DodonaDownload: download all linked files from exercise description (url neede as first line).
- DodonaGo: go to exercise page (url needed as first line).
