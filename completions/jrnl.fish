complete -c jrnl -s h -l help -d 'Print help'
complete -c jrnl -s e -l edit-template -d 'Edit the journal entry template'
complete -c jrnl -s d -l dir -d 'Set the journal directory' -r
function __jrnl_dir
    if set -q jrnl_directory
        echo $jrnl_directory
    else
        echo ~/jrnl
    end
end
complete -c jrnl -s t -l template -d 'Set the template file' -r
