"""
A scheme interpreter that support car/cdr/cons/quote/cond/if/true/false

support closure (high order function)

"""

from typing import List
import string
import os


# NUMERAL_STARTS is from https://www.composingprograms.com/examples/scalc/scheme_tokens.py.html
_NUMERAL_STARTS = set(string.digits) | set("+-.")


def tokenize(string):
    return string.split()


def clean_expression(expression: str):
    expression = expression.replace("(", " ( ").replace(")", " ) ")
    # handle quote
    expression = expression.replace("'", " ' ")
    return expression


def maybe_to_number(token: str):
    if token in set("+-.") and len(token) == 1:
        return token
    if token == "true":
        return 1
    if token == "false":
        return 0
    if token[0] in _NUMERAL_STARTS:
        try:
            return int(token)
        except ValueError:
            try:
                return float(token)
            except ValueError:
                raise ValueError("invalid numeral: {0}".format(token))
    else:
        return token


def to_list_ast(expression: List) -> List:
    """
    ['(', '/', 4, '(',  '*', '1', '1', ')', ')'] -> [ '/', '4', ["*", 1, 1] ]
    """
    stack = []
    for e in expression:
        if e == ")":
            temp = []
            while stack[-1] != "(":
                temp.append(stack.pop())
            stack.pop()
            stack.append(temp[::-1])
        else:
            stack.append(e)
    return stack[0]


def handle_quote(expression: List):
    """
    ['car', "'", [1, 2]] -> ['car', ["quote", 1, 2]]
    """
    result = []
    i = 0
    while i < len(expression):
        ele = expression[i]
        if type(ele) is list:
            result.append(handle_quote(ele))
            i += 1
        elif type(ele) is str and ele == "'":
            if i + 1 == len(expression):
                raise ValueError("quote should have an expression")
            if type(expression[i + 1]) is list:
                result.append(["quote"] + expression[i + 1])
            else:
                result.append(["quote"] + [expression[i + 1]])
            i += 2
        else:
            result.append(ele)
            i += 1
    return result


def read_and_parse(path: str) -> List[List[str]]:
    """
    expressions are split by double "\n"
    """
    with open(path) as f:
        string = f.read()

    expressions_str = string.split("\n\n")

    expressions = []
    for exp in expressions_str:
        exp = exp.strip()
        if exp == "" or exp[0] in ";#":
            continue
        exp = clean_expression(exp)
        tokens = tokenize(exp)
        tokens = [maybe_to_number(token) for token in tokens]
        exp = to_list_ast(tokens)
        exp = handle_quote(exp)
        expressions.append(exp)
    return expressions


# codes above are for parsing the scheme code


def evaluate(exp: list, env: list = [{}]):
    if type(exp) is int or type(exp) is float:
        return exp
    if type(exp) is str:
        value = lookup(exp, env)
        if value is None:
            return apply_map.get(exp, exp)
        return value
    if type(exp) is list:
        if exp[0] == "if":
            assert len(exp) == 4, "if statement should have 3 arguments"
            return (
                evaluate(exp[2], env)
                if evaluate(exp[1], env)
                else evaluate(exp[3], env)
            )
        if exp[0] == "cond":
            for i in range(1, len(exp)):
                if evaluate(exp[i][0], env):
                    return evaluate(exp[i][1], env)
            return None
        if exp[0] == "lambda":
            return exp, env  # closure
        if exp[0] in ["let", "let*", "letrec"]:
            assert (
                len(exp) >= 3
            ), "let statement should have at least 2 arguments"
            new_env, base_env = {}, env
            env = create_env(new_env, base_env)
            current_env = env if exp[0] == "let*" else base_env
            for key, value in exp[1]:
                new_env[key] = evaluate(value, current_env)
                if exp[0] == "letrec" and type(new_env[key]) is tuple:

                    new_env[key] = (
                        new_env[key][0],
                        env,
                    )  # change the closure env, and self reference

            body = exp[2] if len(exp) == 3 else ["progn"] + exp[2:]
            return evaluate(body, env)
        if exp[0] in ["define", "defun"]:
            return evaluate_define(exp, env)
        if exp[0] in ["progn", "begin"]:
            for e in exp[1:]:
                result = evaluate(e, env)
            return result

        return apply(
            evaluate(exp[0], env),
            [evaluate(c, env) for c in exp[1:]],  # 2d recursion
        )

    else:
        raise TypeError(f"{exp} is not a number or call expression")


def evaluate_define(exp: list, env: list):
    # handle variable define
    if type(exp[1]) is str:
        assert len(exp) == 3, "define statement should have 2 arguments"
        assert exp[0] != "defun", "use define instead of defun"
        current_env = env[0]
        current_env[exp[1]] = evaluate(exp[2], env)
        return exp[1]

    # handle function define/defun
    if type(exp[1]) is list:
        # convert to lambda
        assert (
            len(exp) >= 3
        ), "defun statement should have at least 2 arguments"
        function_name = exp[1][0]
        lambda_exp = ["lambda", exp[1][1:], ["progn"] + exp[2:]]
        current_env = env[0]
        current_env[function_name] = evaluate(lambda_exp, env)
        current_env[function_name] = (current_env[function_name][0], env)
        return function_name


def apply(proc, args):
    if type(proc) == tuple:  # handle closure
        exp, env = proc
        parameters = exp[1]
        env = create_env(dict(zip(parameters, args)), env)
        return evaluate(exp[2], env)
    return proc(args)


apply_map = {
    "+": lambda x: sum(x),
    "-": lambda x: x[0] - x[1],
    "*": lambda x: x[0] * x[1],
    "/": lambda x: x[0] / x[1],
    "//": lambda x: x[0] // x[1],
    ">": lambda x: x[0] > x[1],
    "<": lambda x: x[0] < x[1],
    "=": lambda x: x[0] == x[1],
    ">=": lambda x: x[0] >= x[1],
    "<=": lambda x: x[0] <= x[1],
    ".": None,  # not a function ,just a placeholder
    "cond": None,  # not a function ,just a placeholder
    "car": lambda x: x[0][
        0
    ],  # pay attention, the arguments of car is a nested list
    "cdr": lambda x: (
        x[0][-1] if len(x[0]) == 3 and x[0][1] == "." else x[0][1:]
    ),  # handle dot list
    "quote": lambda x: x[0] if len(x) == 1 else x,  # pay attention
    "cons": lambda x: (
        [x[0]] + x[1] if type(x[1]) is list else [x[0], ".", x[1]]
    ),
}


def lookup(variable: str, env: list):
    for frame in env:
        if variable in frame:
            return frame[variable]
    return None


def create_env(variables: dict, env: list):
    return [variables] + env


def evaluate_file(path: str):
    expressions = read_and_parse(path)
    env = [{}]  # global env
    for exp in expressions:
        print(evaluate(exp, env))


def test_evaluate_file():
    path = os.path.abspath(__file__)
    file_name = path.split("/")[-1].split(".")[0]
    core = file_name.split("_")[-1]
    test_file = f"tests/{core}.scm"
    for exp in read_and_parse(test_file):
        print(exp)
    evaluate_file(test_file)


if __name__ == "__main__":
    # argparse for test
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--test", action="store_true")
    args = parser.parse_args()
    if args.test:
        test_evaluate_file()
