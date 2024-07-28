#!/bin/bash

# Your existing code here

echo "Running tests..."
start_time=$(date +%s%3N)
if [ "$1" = "var" ]; then
    python var.py --test
elif [ "$1" = "cons" ]; then
    python analysis1_cons.py --test
elif [ "$1" = "cond" ]; then
    python analysis2_cond.py --test
elif [ "$1" = "lambda" ]; then
    python analysis3_lambda.py --test

elif [ "$1" = "all" ]; then
    python var.py --test

else
    echo "Invalid argument. Please specify a valid option."
fi
end_time=$(date +%s%3N)
elapsed_time=$((end_time - start_time))
echo "Tests completed in $elapsed_time milliseconds."
