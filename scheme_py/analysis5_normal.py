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


def evaluate(exp: list, env=[{}]):
    return analysis(exp)([KEYWORDS])


def analysis(exp: list):
    if isinstance(exp, (int, float)):
        return lambda env: exp
    if isinstance(exp, str):

        def _look(env):
            value = lookup(exp, env)
            if value and type(value) is tuple and value[0] == "delay":
                return value[1](value[2])
            if value:
                return value
            return exp

        return _look
        # (nonstandard) quote or invalid variable, no built-in function here
    if type(exp) is list:
        if exp[0] == "if":
            assert len(exp) == 4, "if statement should have 3 arguments"
            predicate = analysis(exp[1])
            consequent = analysis(exp[2])
            alternative = analysis(exp[3])
            return lambda env: (
                consequent(env) if predicate(env) else alternative(env)
            )
        if exp[0] == "cond":
            clause_list = []
            for clause in exp[1:]:
                predicate, consequent = clause
                clause_list.append((analysis(predicate), analysis(consequent)))

            def cond(env):
                for predicate, consequent in clause_list:
                    if predicate(env):
                        return consequent(env)
                return None

            return cond
        if exp[0] == "lambda":
            body = analysis(exp[2])
            return lambda env: (
                exp[1],
                body,
                env,
            )  # miss env cost me a lot of time

        args_analysis = [analysis(e) for e in exp[1:]]
        proc = analysis(exp[0])

        def _apply(env):

            func = proc(env)
            args = [("delay", arg, env) for arg in args_analysis]
            if type(func) is tuple:  # clousure
                parameters, body, func_env = func
                new_env = create_env(dict(zip(parameters, args)), func_env)

                return body(new_env)
            args = [arg(env) for arg in args_analysis]
            return func(args)

        return _apply
    else:
        raise TypeError(f"{exp} is not a number or call expression")


KEYWORDS = {
    ".": ".",
    "else": True,
    "#t": True,
    "#f": False,
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
    "cdr": lambda x,: (
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
