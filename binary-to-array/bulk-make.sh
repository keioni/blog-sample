#!/bin/bash -e

# Sample script to generate binary embeddings in bulk.

# This script is used to generate many binary embeddings at once in
# specified directories and write the output to a C/C++ header file.

# for example, if "lemon.jpg" and "orange.jpg" are in the input
# directory, "lemon_jpg.h" and "orange_jpg.h" are generated in the
# output directory.

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input-dir> <output-dir>"
    exit 1
fi

input_dir=$1
output_dir=$2

mkdir -p $output_dir

input_files=$(ls $input_dir)

echo "Generating binary embeddings in bulk..."
for input_file in $input_files; do
    variable_name=$(echo $input_file | perl -pe 's/\./_/g')
    output_file=${variable_name}.h
    echo "Generating $output_file..."
    ./binary-embedding $input_dir/$input_file $variable_name > $output_dir/$output_file
done
echo "Done."
echo ""

# write all output files' #include <output_file.h> statements to a
# single file named after the output directory. This file can be
# included in your C/C++ source code.

echo "Writing #include statements..."
for input_file in $input_files; do
    output_file=$(echo $input_file | perl -pe 's/\./_/g').h
    echo "#include \"$output_file\""
done > $output_dir/$(basename $output_dir).h
echo "Done."
