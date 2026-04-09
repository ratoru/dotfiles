on run argv
    -- Set the target directory from arguments, or default to Home
    set targetDir to POSIX path of (path to home folder)
    if (count of argv) > 0 then
        set targetDir to item 1 of argv
    end if

    tell application "Ghostty"
        activate

        -- 1. Setup the Configuration Record
        set cfg to new surface configuration
        set initial working directory of cfg to targetDir

        -- 2. Create the Window (Tab 1)
        set win to new window with configuration cfg
        delay 0.2

        -- 3. Create the other 3 Tabs and store references
        -- Using 'in win' ensures they stay in the same window
        set tab1 to selected tab of win
        delay 0.2
        set tab2 to new tab in win with configuration cfg
        delay 0.2
        set tab3 to new tab in win with configuration cfg
        delay 0.2
        set tab4 to new tab in win with configuration cfg

        -- 4. Execute commands by targeting specific terminals
        -- Tab 4: Vertical Split
        set term4 to focused terminal of tab4
        split term4 direction right with configuration cfg

        -- Tab 1: Claude
        set term1 to focused terminal of tab1
        input text "claude" to term1
        send key "enter" to term1

        -- Tab 2: Nvim
        set term2 to focused terminal of tab2
        input text "nvim" to term2
        send key "enter" to term2

        -- Tab 3: Lazygit
        set term3 to focused terminal of tab3
        input text "lazygit" to term3
        send key "enter" to term3

        -- 5. Force focus back to the first tab
        -- This ensures you start where you want to work
        focus term1
    end tell
end run
