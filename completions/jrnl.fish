complete -c jrnl -s h -l help -d 'Print help'
complete -c jrnl -s e -l edit-template -d 'Edit the journal entry template'
complete -c jrnl -s d -l dir -d 'Set the journal directory' -r
complete -c jrnl -s t -l template -d 'Set the template file' -r
complete -c jrnl -s o -l offset -d 'Set hours from midnight for start of tomorrow' -r -f
