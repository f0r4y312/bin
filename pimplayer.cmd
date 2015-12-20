:: pimplayer - Playlist/Individual mplayer
:: * author: Vimal Aravindashan (vimal.aravindashan@gmail.com)
::
:: Usage: pimplayer path_to_file(s) [first_file_pattern] [last_file_pattern]
:: * path_to_file(s): Base path to list of files, or full path to file
:: * first_file_pattern: optional pattern to look for in first file name (alphabetically) to start playlist with
:: * last_file_pattern: optional pattern to look for in last file name (alphabetically) to end playlist with
::
:: Examples: (examples below assume file paths/names to be in the "season NN\*SxxExx*" format; adjust accordingly)
::   Play a movie:                          pimplayer \\path\to\movie.mp4
::   Play all episodes from season 1:       pimplayer "\\path\to\awesome\series\season 01"
::   Play season 2 starting from episode 3: pimplayer "\\path\to\awesome\series\season 02" E03
::   Play episodes 5 to 10 from season 4:   pimplayer "\\path\to\awesome\series\season 04" E05 E10
::   Play all seasons:                      pimplayer \\path\to\awesome\series (WARNING: will fail awesomely if there are too many seasons/episodes)

@echo off
setlocal
	set base_path=%~1
	set first_file=%~2
	set last_file=%~3
	set playlist=
	for /f "tokens=*" %%i in ('dir /s /b /on "%base_path%"') do (
		call :add_to_playlist "%%i"
	)
	mplayer { %playlist% } -loop 0
endlocal
exit /b 0

:add_to_playlist
	set file=%1

	set sans_pat=%1
	if defined first_found goto :first_exit
	if ["%first_file%"] equ [""] (
		goto :first_exit
	) else (
		call set sans_pat=%%file:%first_file%=%%
	)
	if %sans_pat%==%file% (
		goto :eof
	) else (
		set first_found=1
	)
	:first_exit

	set sans_pat=%1
	if defined last_found goto :eof
	if ["%last_file%"] equ [""] (
		goto :last_exit
	) else (
		call set sans_pat=%%file:%last_file%=%%
	)
	if %sans_pat%==%file% (
		goto :last_exit
	) else (
		set last_found=1
	)
	:last_exit

	echo %file%
	set playlist=%playlist% %file%
goto :eof

