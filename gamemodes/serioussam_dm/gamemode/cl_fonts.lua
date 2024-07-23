surface.CreateFont("seriousHUDfont_timer", {
	font = "default",
	size = ScrH()/16,
	weight = 600,
	blursize = 1
})

surface.CreateFont("seriousHUDfont_fragsleft", {
	font = "Roboto",
	size = ScrH()/32,
	weight = 800,
	blursize = 1
})
surface.CreateFont("seriousHUDfont_targetid", {
	font = "Roboto",
	size = ScrH()/32,
	weight = 800,
	blursize = 1
})

surface.CreateFont( "Scoreboard_Font", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 46,
	weight = 800,
	blursize = 1,
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

surface.CreateFont("killfeed_font",{
	font = "Roboto",
	size = ScrH() / 46,
	weight = 1000,
	antialiasing = true,
	additive = false,
	shadow = true
});

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

surface.CreateFont( "Frag_Font", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrH() / 32,
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



surface.CreateFont( "MainMenu_Font", {
	font = "My Font", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW()/28,
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
	extended = true,
} )



surface.CreateFont( "Vote_Font", {
	font = "My Font", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 32	,
	weight = 0,
	extended = true,
} )

surface.CreateFont( "Vote_Font2", {
	font = "My Font", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 42,
	weight = 0,
	extended = true,
} )

surface.CreateFont("MainMenu_font_very_small", {
	font = "Arial",
	size = ScrW()/64,
	weight = 800,
	blursize = 0,
	shadow = true,
	extended = true,
})

surface.CreateFont("MainMenu_font_small", {
	font = "My Font",
	size = ScrW()/38,
	weight = 600,
	blursize = 0,
	shadow = true,
	extended = true,
})