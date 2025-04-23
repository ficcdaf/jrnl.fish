function jrnl --description 'Lightweight journaling tool'
    argparse h/help d/dir= t/template= e/edit-template -- $argv
    if set -q _flag_h
        echo jrnl: a lightweight journaling tool
        echo
        echo Call jrnl without options to get started.
        echo
        echo Usage:
        echo \tOpen today\'s entry:
        echo \t\> jrnl
        echo \tEdit the template:
        echo \t\> jrnl -e
        echo \t\> jrnl --edit-template
        echo \tSet the journal directory "(~/jrnl)" by default:
        echo \t\> set -Ug jrnl_directory path/to/journal
        echo \t\> jrnl -d path
        echo \t\> jrnl --dir path
        echo \tSet the template file "(relative to journal directory)":
        echo \t\> set -Ug jrnl_template template_file
        echo \t\> jrnl -t template_file.md
        echo \t\> jrnl --template template_file.md
        echo \tShow this help menu:
        echo \t\> jrnl -h
        echo \t\> jrnl --help
        echo Template file:
        echo \tThe template file is a Markdown file inside the
        echo \tjournal directory, called \'template.md\' by default.
        echo \tMarkdown comments are always skipped.
        echo \tExtra newlines at the file end are trimmed.
        echo \tThe literals '\'%{date}\'' and '\'%{date_long}\''
        echo \tare substituted for date values.
        echo Author:
        echo \tDaniel Fichtinger '<daniel@ficd.ca>'
        echo URL:
        echo \thttps://git.sr.ht/~ficd/jrnl.fish
        echo License:
        echo \tMIT '(c)' Daniel Fichtinger 2025
        return 0

    end

    set -f jdir ~/jrnl
    if set -ql _flag_dir[1]
        set jdir $_flag_dir[1]
    else if set -q jrnl_directory
        set jdir $jrnl_directory
    end

    if not test -d $jdir
        mkdir -p $jdir
    end

    set -f template $jdir/template.md
    if set -ql _flag_template[1]
        set template $jdir/$_flag_template[1]
    else if set -q jrnl_template
        set template $jdir/$jrnl_template
    end

    if not test -f $template
        set -l prompt "There is no template, create one now? (y/n): "
        while read --nchars 1 -l response --prompt-str="$prompt" or return 1
            printf "\033[1A\033[2K"
            switch $response
                case y Y
                    begin
                        echo '<!-- This is the jrnl template file. -->'
                        echo '<!-- Markdown comments will be ignored! -->'
                        echo '<!-- Date placeholders are supported. -->'
                        echo '# %{date}'
                        echo '<!-- Everything besides comments and dates are copied directly! -->'
                        echo
                        echo 'Today is %{date_long}.'
                    end >$template
                    eval $EDITOR $template
                    set -q _flag_e; and return 0
                    break
                case n N
                    break
            end
        end
    end
    if set -q _flag_e
        eval $EDITOR $template
        return 0
    end

    # get the date
    set today (date +'%Y-%m-%d')
    set entry "$jdir/$today.md"
    # check if journal entry exists
    if not test -f $entry
        set contents (cat $template | \
        string match --invert --regex '^<!--.*-->' | \
        string replace --all '%{date_long}' "$(date +'%A, %b %d, %Y')" | \
        string replace --all '%{date}' "$today" | \
        string collect -N)
        set contents (string trim --right $contents | string collect -N)
        echo -n "$contents" >$entry
        set -l prompt "Created $entry, open in $EDITOR? (y/n)"
        while read --nchars 1 -l response --prompt-str="$prompt" or return 1
            printf "\033[1A\033[2K"
            switch $response
                case y Y
                    eval $EDITOR $entry
                    break
                case n N
                    break
            end
        end
    else
        eval $EDITOR $entry
    end
end
