surface.CreateFont("seriousHUDfont_timer", {
	font = "default",
	size = ScrH()/16,
	weight = 600,
	blursize = 1
})

surface.CreateFont("seriousHUDfont_fragsleft", {
	font = "default",
	size = ScrH()/32,
	weight = 600,
	blursize = 1
})

surface.CreateFont( "Scoreboard_Font", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 48,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Death_Font", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrH() / 42,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "GameEnd_Font", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrH() / 42,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )



surface.CreateFont( "MainMenu_Font", {
	font = "Mytupi", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 24	,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Vote_Font", {
	font = "Mytupi", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 32	,
	weight = 0,
} )

surface.CreateFont( "Vote_Font2", {
	font = "Mytupi", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 42	,
	weight = 0,
} )

surface.CreateFont("MainMenu_font_small", {
	font = "Franklin Gothic",
	size = ScrH()/52,
	weight = 600,
	blursize = 0,
	shadow = true
})