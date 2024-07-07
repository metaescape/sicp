"""
A scheme interpreter that support car/cdr/cons/quote/cond/if/true/false

support closure (high order function)

"""

from typing import List
import string
import os


# _NUMERAL_STARTS from https://www.composingprograms.com/examples/scalc/scheme_tokens.py.html
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
                result.append(["list"] + expression[i + 1])
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
        list_tree = to_list_ast(tokens)
        list_tree = handle_quote(list_tree)
        expressions.append(list_tree)
    return expressions


# codes above are for parsing the scheme code


def evaluate(exp: list, env: list = []):
    if isinstance(exp, (int, float)):
        return exp
    if type(exp) is str:
        # lambda will not appear in this branch
        value = lookup(exp, env)
        if value is not None:
            return value
        if exp in KEYWORDS:
            return KEYWORDS[exp]
        return apply_map.get(
            exp, exp
        )  # primitive function name will be shown here
        # if exp is not a primitive function,
        # it will be treated as nonstandard quote or unreferenced variable

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
        return apply(
            evaluate(exp[0], env),
            [evaluate(c, env) for c in exp[1:]],  # 2d recursion
        )

    else:
        raise TypeError(f"{exp} is not a number or call expression")


def apply(proc, args):
    if type(proc) == tuple:  # handle closure
        exp, env = proc
        parameters = exp[1]
        env = create_env(dict(zip(parameters, args)), env)
        return evaluate(exp[2], env)
    return proc(args)


KEYWORDS = {
    ".": ".",  # not a function ,just a placeholder
    "#t": True,
    "#f": False,
    "else": True,
}

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
    "car": lambda x: x[0][
        0
    ],  # pay attention, the arguments of car is a nested list
    "cdr": lambda x: (
        x[0][-1] if len(x[0]) == 3 and x[0][1] == "." else x[0][1:]
    ),  # handle dot list
    "quote": lambda x: f"'{x[0]}",  # add ' as a prefix
    "list": lambda x: x,
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
    for exp in expressions:
        print(evaluate(exp))


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
