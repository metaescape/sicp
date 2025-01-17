#!/bin/bash


# Your existing code here

if [ "$1" = "analysis" ]; then
    echo "Running tests..."
    start_time=$(date +%s%3N)
    if [ "$2" = "calculator" ]; then
        python analysis0_calculator.py --test
    elif [ "$2" = "cons" ]; then
        python analysis1_cons.py --test
    elif [ "$2" = "cond" ]; then
        python analysis2_cond.py --test
    elif [ "$2" = "lambda" ]; then
        python analysis3_lambda.py --test
    elif [ "$2" = "closure" ]; then
        python analysis4_closure.py --test
    elif [ "$2" = "normal" ]; then
        python analysis5_normal.py --test
    elif [ "$2" = "memo" ]; then
        python analysis5.5_memo.py --test
    elif [ "$2" = "let" ]; then
        python analysis6_let.py --test
    elif [ "$2" = "define" ]; then
        python analysis7_define.py --test
    elif [ "$2" = "stream" ]; then
        python analysis8_stream.py --test
    elif [ "$2" = "all" ]; then
        python analysis0_calculator.py --test
        python analysis1_cons.py --test
        python analysis2_cond.py --test
        python analysis3_lambda.py --test
        python analysis4_closure.py --test
        python analysis5_normal.py --test
        python analysis6_let.py --test
        python analysis7_define.py --test
        python analysis8_stream.py --test
    else
        echo "Invalid argument. Please specify a valid option."
    fi
    end_time=$(date +%s%3N)
    elapsed_time=$((end_time - start_time))
    echo "Tests completed in $elapsed_time milliseconds."
fi


if [ "$1" = "eval" ]; then
    echo "Running tests..."
    start_time=$(date +%s%3N)
    if [ "$2" = "calculator" ]; then
        python eval0_calculator.py --test
    elif [ "$2" = "cons" ]; then
        python eval1_cons.py --test
    elif [ "$2" = "cond" ]; then
        python eval2_cond.py --test
    elif [ "$2" = "lambda" ]; then
        python eval3_lambda.py --test
    elif [ "$2" = "closure" ]; then
        python eval4_closure.py --test
    elif [ "$2" = "normal" ]; then
        python eval5_normal.py --test
    elif [ "$2" = "memo" ]; then
        python eval5.5_memo.py --test
    elif [ "$2" = "let" ]; then
        python eval6_let.py --test
    elif [ "$2" = "define" ]; then
        python eval7_define.py --test
    elif [ "$2" = "stream" ]; then
        python eval8_stream.py --test
    elif [ "$2" = "all" ]; then
        python eval0_calculator.py --test
        python eval1_cons.py --test
        python eval2_cond.py --test
        python eval3_lambda.py --test
        python eval4_closure.py --test
        python eval5_normal.py --test
        python eval6_let.py --test
        python eval7_define.py --test
        python eval8_stream.py --test
    else
        echo "Invalid argument. Please specify a valid option."
    fi
    end_time=$(date +%s%3N)
    elapsed_time=$((end_time - start_time))
    echo "Tests completed in $elapsed_time milliseconds."
fi