function jrnl --description 'Lightweight journaling tool'
    argparse h/help d/dir= t/template= e/edit-template -- $argv
    if set -q _flag_h
        echo (set_color -o)jrnl: a lightweight journaling tool(set_color normal)
        echo
        echo Call jrnl without options to get started.
        echo
        echo (set_color -o)Usage:(set_color normal)
        echo (set_color -o)\tOpen today\'s entry:(set_color normal)
        echo \t\> jrnl
        echo (set_color -o)\tEdit the template:(set_color normal)
        echo \t\> jrnl -e
        echo \t\> jrnl --edit-template
        echo (set_color -o)\tSet the journal directory "(~/jrnl)" by default:(set_color normal)
        echo \t\> set -Ug jrnl_directory path/to/journal
        echo \t\> jrnl -d path
        echo \t\> jrnl --dir path
        echo (set_color -o)\tSet the template file:(set_color normal)
        echo \t\> set -Ug jrnl_template template_file
        echo \t\> jrnl -t template_file.md
        echo \t\> jrnl --template template_file.md
        echo (set_color -i)\tIf the variable or option resolves to a real file,(set_color normal)
        echo (set_color -i)\tit will be used as the template. Otherwise, the(set_color normal)
        echo (set_color -i)\tjrnl directory is searched for the file name.(set_color normal)
        echo (set_color -o)\tShow this help menu:(set_color normal)
        echo \t\> jrnl -h
        echo \t\> jrnl --help
        echo (set_color -o)Template file:(set_color normal)
        echo \t"\$jrnl_directory/template.md" is its default location.
        echo \tMarkdown comments are always skipped.
        echo \tExtra newlines at the file end are trimmed.
        echo \tThe literals '\'%{date}\'' and '\'%{date_long}\''
        echo \tare substituted for date values.
        echo (set_color -o)Author:(set_color normal)
        echo \tDaniel Fichtinger '<'(set_color -u)daniel@ficd.ca(set_color normal)'>'
        echo (set_color -o)URL:(set_color normal)
        echo (set_color -u)\thttps://git.sr.ht/~ficd/jrnl.fish(set_color normal)
        echo (set_color -o)License:(set_color normal)
        echo \tMIT '(c)' Daniel Fichtinger 2025
        return 0

    end

    set -g jdir ~/jrnl
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
        set template (path resolve $_flag_template[1])
    else if set -q jrnl_template
        set template $jrnl_template
    end
    set -f template_base (path basename $template)
    function edit -a targ
        set -l cmd (string split ' ' -- $EDITOR)
        env -C $jdir $cmd $targ
    end

    if not test -f $template
        # first check if template exists in jdir
        set -l candidate (fd -F -1 "$template_base" "$jdir")
        if test -n "$candidate"
            set template (path resolve $candidate)
        else
            set template $jdir/$template_base
            set -l prompt "There is no template at $template, create one now? (y/n): "
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
                        edit $template
                        set -q _flag_e; and return 0
                        break
                    case n N
                        return 0
                end
            end
        end
    end
    if set -q _flag_e
        edit $template
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
                    edit $entry
                    break
                case n N
                    break
            end
        end
    else
        edit $entry
    end
end
