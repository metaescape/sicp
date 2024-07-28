#!/bin/bash

# Your existing code here

echo "Running tests..."
start_time=$(date +%s%3N)
if [ "$1" = "var" ]; then
    python var.py --test
elif [ "$1" = "lambda" ]; then
    python lambda.py --test
elif [ "$1" = "apply" ]; then
    python apply.py --test
elif [ "$1" = "apply_paren" ]; then
    python apply_paren.py --test
elif [ "$1" = "lambda_paren" ]; then
    python lambda_paren.py --test
elif [ "$1" = "paren" ]; then
    python paren.py --test

elif [ "$1" = "all" ]; then
    python var.py --test
    python lambda.py --test
    python apply.py --test
    python apply_paren.py --test
    python lambda_paren.py --test
    python paren.py --test

else
    echo "Invalid argument. Please specify a valid option."
fi
end_time=$(date +%s%3N)
elapsed_time=$((end_time - start_time))
echo "Tests completed in $elapsed_time milliseconds."
