from typing import List
import string
import os

"""
A query interpreter that support simple query with dot list
"""

# _NUMERAL_STARTS from https://www.composingprograms.com/examples/scalc/scheme_tokens.py.html
_NUMERAL_STARTS = set(string.digits) | set("+-.")


def tokenize(string):
    return string.split()


def clean_expression(expression: str):
    expression = expression.replace("(", " ( ").replace(")", " ) ")
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
    return stack


def ast_to_sexp(ast):
    if type(ast) is list:
        return "(" + " ".join([ast_to_sexp(e) for e in ast]) + ")"
    else:
        return str(ast)


def read_and_parse(path: str) -> List[List[str]]:
    """
    expressions are split by "\n"
    """
    with open(path) as f:
        string = f.read()

    expressions_str = string.split("\n")
    expressions = []

    for exp in expressions_str:
        exp = exp.strip()
        if exp == "" or exp[0] in ";#":
            continue
        expressions.append(exp)

    exp = "".join(expressions)

    exp = clean_expression(exp)

    tokens = tokenize(exp)
    tokens = [maybe_to_number(token) for token in tokens]

    exp = to_list_ast(tokens)
    return exp


from itertools import zip_longest


def match(query, data, frame: dict):
    frames = []

    i = 0
    while i < len(query):
        q, e = query[i], data[i]
        if type(q) is str and q.startswith("?"):
            if q in frame:
                if frame[q] != e:
                    return False
            else:
                frame[q] = e
            i += 1

        elif q == ".":
            assert query[i + 1].startswith(
                "?"
            ), "dot should be followed by a query variable"
            q = query[i + 1]

            if q in frame:
                if frame[q] != data[i:]:
                    return False
                else:
                    frame[q] = data[i:]

            return frame
        elif type(q) == str:
            if q != e:
                return False
            i += 1
        else:
            res = match(q, e, frame)
            if not res:
                return False
            i += 1
    if i != len(data):
        return False

    return unify(frames, frame)


def unify(frames, frame):
    return frame


def evaluate(expression: list, db: list):
    res = []
    for data in db:
        if match(expression, data, {}):
            res.append(data)
    return res


def test_simple():
    db = read_and_parse("tests/db.scm")
    querys = read_and_parse("tests/dots.scm")

    for query in querys:
        res = evaluate(query, db)
        print("---- query: ", ast_to_sexp(query))
        for r in res:
            print(ast_to_sexp(r))


if __name__ == "__main__":
    test_simple()
