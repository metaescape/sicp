from typing import List
import string

# NUMERAL_STARTS is from https://www.composingprograms.com/examples/scalc/scheme_tokens.py.html
_NUMERAL_STARTS = set(string.digits) | set("+-.")


def tokenize(string):
    return string.split()


def clean_expression(expression: str):
    return expression.replace("(", " ( ").replace(")", " ) ")


def maybe_to_number(token: str):
    if token in ["+", "-"] and len(token) == 1:
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


def read_and_parse(path: str) -> List[List[str]]:
    """
    expressions are split by double "\n"
    """
    with open(path) as f:
        string = f.read()

    expressions_str = string.split("\n\n")

    expressions = []
    for exp in expressions_str:
        if exp.startswith(";") or exp.startswith("#"):
            continue
        exp = clean_expression(exp)
        tokens = tokenize(exp)
        tokens = [maybe_to_number(token) for token in tokens]
        exp = to_list_ast(tokens)
        expressions.append(exp)
    return expressions


def test_read_and_parse():
    print(read_and_parse("caculate.scm"))


# codes above are for parsing the scheme code


def evaluate(exp: list):
    if type(exp) is int or type(exp) is float:
        return exp
    if type(exp) is list:
        return apply(exp[0], [evaluate(c) for c in exp[1:]])
    if type(exp) is str and exp in apply_map:
        return exp
    else:
        raise TypeError(f"{exp} is not a number or call expression")


apply_map = {
    "+": lambda x: sum(x),
    "-": lambda x: x[0] - x[1],
    "*": lambda x: x[0] * x[1],
    "/": lambda x: x[0] / x[1],
    "//": lambda x: x[0] // x[1],
}


def apply(proc, args):
    return apply_map[proc](args)


def evaluate_file(path: str):
    expressions = read_and_parse(path)
    for exp in expressions:
        print(evaluate(exp))


def test_evaluate_file():
    evaluate_file("caculate.scm")


if __name__ == "__main__":
    # argparse for test
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--test", action="store_true")
    args = parser.parse_args()
    if args.test:
        test_read_and_parse()
        test_evaluate_file()
