#!/bin/bash

if [ "$1" = "calculator" ]; then
    python eval0_calculator.py --test
elif [ "$1" = "cons" ]; then
    python eval1_cons.py --test
elif [ "$1" = "cond" ]; then
    python eval2_cond.py --test
elif [ "$1" = "lambda" ]; then
    python eval3_lambda.py --test
elif [ "$1" = "closure" ]; then
    python eval4_closure.py --test
elif [ "$1" = "all" ]; then
    python eval0_calculator.py --test
    python eval1_cons.py --test
    python eval2_cond.py --test
    python eval3_lambda.py --test
    python eval4_closure.py --test
else
    echo "Invalid argument. Please specify a valid option."
fi