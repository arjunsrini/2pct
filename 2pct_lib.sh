
2pct_template() {

    # If no argument is provided, print an error message
    if [ -z "$1" ]; then
        echo "Error: No argument provided."
        echo "Usage: 2pct_template <template_name> [<template_dir>]"
        exit 1
    fi

    # If the template directory is provided, use it
    if [ ! -z "$2" ]; then
        template_dir="$2"
    else
        template_dir="${TWO_PCT_DIR}/templates"
    fi

    # Check if the template directory exists
    if [ ! -d "$template_dir" ]; then
        echo "Error: Template directory $template_dir does not exist."
        exit 1
    fi

    # Construct the template file path
    template_file="${template_dir}/$1"

    # Check if the template file exists
    if [ ! -f "$template_file" ]; then
        echo "Error: Template file $template_file does not exist."
        exit 1
    fi

    # Emit the template file
    cat "$template_file"

}

format_table() {

    # check if $1 is provided
    if [ -z "$1" ]; then
        echo "Error: No argument provided."
        exit 1
    fi

    my_fp="$1"
    my_title="$2"
    my_label="$3"
    my_caption="$4"

    # if title is not provided, use the filename
    if [ -z "$my_title" ]; then
        my_title=$(basename $my_fp)
    fi

    # if label is not provided
    if [ -z "$my_label" ]; then
        my_label=""
    else
        my_label="\label{ $my_label }"
    fi

    cat <<EOF
\begin{table}[h]
    \caption{\textbf{ $my_title  $my_label  }}
    \vspace{1em}
    \begin{centering}
    \input{ $my_fp }
    \par
    \medskip{}
    % {\small{} $my_caption }{\small\par}
    \end{centering}
\end{table}
EOF

}


format_figure() {

    # check if $1 is provided
    if [ -z "$1" ]; then
        echo "Error: No argument provided."
        exit 1
    fi

    my_fp="$1"
    my_title="$2"
    my_label="$3"
    my_caption="$4"

    # if title is not provided, use the filename
    if [ -z "$my_title" ]; then
        my_title=$(basename $my_fp)
    fi

    # if label is not provided
    if [ -z "$my_label" ]; then
        my_label=""
    else
        my_label="\label{ $my_label }"
    fi

    cat <<EOF
\begin{figure}[!htb]
    \centering
    \includegraphics[width=0.8\textwidth]{ $my_fp }
    \caption{\textbf{ $my_title  $my_label }}
    \medskip{}
    {\small{} $my_caption }{\small\par}
\end{figure}
EOF

}

2pct_ls() {

    directory="$1"
    file_pattern="$2"
    exhibit_metadata="$3"
    relative_path="$4"

    # assert that all arguments are provided
    if [ -z "$directory" ] || [ -z "$file_pattern" ] || [ -z "$exhibit_metadata" ]; then
        echo "Error: Not all arguments provided."
        exit 1
    fi

    # get list of files in directory
    # matching file_pattern
    files=$(cd $directory && ls $file_pattern)

    # handle case where no files match
    if [ -z "$files" ]; then
        echo "No files found matching $directory/$file_pattern"
        exit 1
    fi

    # create tempfle
    tempfle=$(mktemp)

    # create map
    # declare -A my_map
    file_col=-1
    title_col=-1
    label_col=-1
    caption_col=-1

    # get the column number for each relevant field
    IFS=',' read -r -a headers < $exhibit_metadata
    for i in "${!headers[@]}"; do
        case ${headers[i]} in
            "file") file_col=$i ;;
            "title") title_col=$i ;;
            "label") label_col=$i ;;
            "caption") caption_col=$i ;;
        esac
    done

    # assert that all columns were found
    if [ $file_col -eq -1 ] || [ $title_col -eq -1 ] || [ $label_col -eq -1 ] || [ $caption_col -eq -1 ]; then
        echo "One or more columns of file, title, label, and caption not found in $exhibit_metadata"
        exit 2
    fi

    # add one to the column numbers to account for 1-indexing
    file_col=$((file_col+1))
    title_col=$((title_col+1))
    label_col=$((label_col+1))
    caption_col=$((caption_col+1))

    # iterate over files
    for file in $files
    do

        row=$(grep $file $exhibit_metadata)

        # get the title_col field of the row
        title=$(echo $row | cut -d, -f$title_col)
        label=$(echo $row | cut -d, -f$label_col)
        caption=$(echo $row | cut -d, -f$caption_col)

        format_figure "$relative_path/$file" "$title" "$label" "$caption" >> $tempfle
        printf "\n\n" >> $tempfle
        
    done

    # emit the tempfile
    cat $tempfle

    # delete the tempfile
    rm -f $tempfle

}
