from typing import List, Optional
import string
import os


class Node:
    pass


class Apply(Node):
    def __init__(self, first, second=None):
        self.first = first
        self.second = second  # None 表示这是个变量

    def __repr__(self) -> str:
        first = self.first
        res = f"{first}"
        while self.second is not None:
            first = self.second.first
            res = f"({res})({first})" if len(res) > 1 else f"{res}({first})"
            self.second = self.second.second
        return res


class Lambda(Node):
    def __init__(self, arg, body):
        self.arg = arg
        self.body = body

    def __repr__(self) -> str:
        # python style
        return f"lambda {self.arg}: {self.body}"


class LLLparser:
    def __init__(self, s):
        self.s = "".join(s.split())  # delete spacees
        self.i = 0

    def parse_apply(self):
        if self.i == len(self.s):
            return None
        var = self.s[self.i]
        self.i += 1
        return Apply(var, self.parse_apply())

    def parse_lambda(self):
        if self.s[self.i] == ".":
            self.i += 1
            return self.parse_apply()
        var = self.s[self.i]
        self.i += 1
        return Lambda(var, self.parse_lambda())

    def parse(self):
        if self.s[self.i] in "Lλ":
            self.i += 1
            return self.parse_lambda()
        return self.parse_apply()


def read_and_parse(path: str) -> List[List[str]]:
    """
    expressions are split by double "\n"
    """
    with open(path) as f:
        string = f.read()

    expressions_str = string.split("\n")
    expressions = []
    for exp in expressions_str:
        if exp.strip() == "" or exp.startswith(";") or exp.startswith("#"):
            continue
        expressions.append(LLLparser(exp).parse())
    return expressions


# codes above are for parsing the scheme code


def evaluate(exp):
    return exp


def evaluate_file(path: str):
    expressions = read_and_parse(path)
    for exp in expressions:
        print(evaluate(exp))


def test_evaluate_file():
    path = os.path.abspath(__file__)
    file_name = path.split("/")[-1].split(".")[0]
    core = file_name.split("_")[-1]
    test_file = f"tests/{core}.lambda"
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
