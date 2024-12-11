"""
Test cases for meta-interpreter for causal datalog.
"""

from pathlib import Path
from typing import List
from unittest import TestCase

from clingo import Control
from clingo.symbol import parse_term

encoding_dir = Path("src", "apperception_clingo", "asp", "meta-int")
meta_test_dir = Path("tests", "data", "meta-interpreter")

# Note to self: nice way of getting answer set hold/2 as a list of strings,
# sorted by time point:

# clingo file.lp --show-preds=hold/2 --project=show,3 --out-atomf=\"%s\",
# --out-ifs=,\n -V0 | head -n -1 | awk -F, '{ print $(NF-1), $0 }' |
# sort -n -k1 | sed 's/^[0-9]*)" //'


class TestMeta(TestCase):
    """
    Test cases for meta-interpreter for causal datalog.
    """

    clingo_args = ["--show-preds=hold/2", "--project=show,3"]

    def assertModelEqual(
        self,
        input_files: List[Path],
        result: List[str] | False,
        clingo_args: List[str] = clingo_args,
    ) -> None:
        """
        Assert that a model's set of atoms equal a set of atoms, or unsat.
        """
        ctl = Control(clingo_args)
        for f in input_files:
            ctl.load(str(f))
        ctl.ground()
        with ctl.solve(yield_=True) as handle:
            if result is not False:
                expected = set(parse_term(s) for s in result)
                for model in handle:
                    found = set(model.symbols(shown=True))
                    self.assertSetEqual(found, expected)
                self.assertTrue(handle.get().satisfiable)
            else:
                self.assertTrue(handle.get().unsatisfiable)

    def test_tight_on_static_tight(self) -> None:
        """
        Test the tight interpreter on tight static program.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "static-tight.lp"],
            ["hold(s(p,a),1)", "hold(s(q,a),1)", "hold(s(r,a),1)"],
        )

    def test_tight_on_static_nontight(self) -> None:
        """
        Test the tight interpreter on a non-tight static program.
        """
        self.assertModelEqual([encoding_dir / "meta-tight.lp", meta_test_dir / "static-loop-found.lp"], False)

    def test_nontight_static_loop_founded(self) -> None:
        """
        Test the nontight interpreter on non-tight static program with a founded loop.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-nontight.lp", meta_test_dir / "static-loop-found.lp"],
            ["hold(s(p,a),1)", "hold(s(q,a),1)"],
        )

    def test_nontight_static_loop_unfounded(self) -> None:
        """
        Test the nontight interpreter on non-tight static program with an unfounded loop.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-nontight.lp", meta_test_dir / "static-loop-unfound.lp"],
            False,
        )

    def test_causal(self) -> None:
        """
        Test the interpreter on a simple causal program.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-nontight.lp", meta_test_dir / "causal.lp"],
            ["hold(s(p,a),1)", "hold(s(p,a),3)", "hold(s(p',a),2)"],
        )

    def test_causal_incompos(self) -> None:
        """
        Test the interpreter on a program with causal rules, inertia and incompossibility.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "incompos-xor.lp"],
            [
                "hold(s(p,a),1)",
                "hold(s(f,a),1)",
                "hold(s(g,a),2)",
                "hold(s(p,a),2)",
                "hold(s(h,a),3)",
                "hold(s(p',a),3)",
            ],
        )

    def test_causal_incompos_exist(self) -> None:
        """
        Test the interpreter on a program with causal rules, inertia and incompossibility.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "incompos-exist.lp"],
            [
                "hold(s2(r,a,b),1)",
                "hold(s2(q,b,c),1)",
                "hold(s2(q,c,b),1)",
                "hold(s(h,b),1)",
                "hold(s(g,c),1)",
                "hold(s(f,c),2)",
                "hold(s(g,b),2)",
                "hold(s2(q,b,c),2)",
                "hold(s2(q,c,b),2)",
                "hold(s2(r,a,b),2)",
                "hold(s2(q,b,c),3)",
                "hold(s2(q,c,b),3)",
                "hold(s(h,c),3)",
                "hold(s(f,b),3)",
                "hold(s2(r,a,c),3)",
                "hold(s2(q,b,c),4)",
                "hold(s2(q,c,b),4)",
                "hold(s(g,c),4)",
                "hold(s(h,b),4)",
                "hold(s2(r,a,b),4)",
            ],
        )

    def test_example_6(self) -> None:
        """
        Test the interpreter on a unified interpretation example 6 given in the paper.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "paper-example6.lp"],
            [
                "hold(s2(r,a,b),1)",
                "hold(s2(r,b,a),1)",
                "hold(s(on,a),1)",
                "hold(s(on,b),1)",
                "hold(s(p1,b),1)",
                "hold(s(p2,a),1)",
                "hold(s2(r,a,b),2)",
                "hold(s2(r,b,a),2)",
                "hold(s(off,a),2)",
                "hold(s(on,b),2)",
                "hold(s(p2,b),2)",
                "hold(s(p3,a),2)",
                "hold(s2(r,a,b),3)",
                "hold(s2(r,b,a),3)",
                "hold(s(off,b),3)",
                "hold(s(on,a),3)",
                "hold(s(p1,a),3)",
                "hold(s(p3,b),3)",
                "hold(s2(r,a,b),4)",
                "hold(s2(r,b,a),4)",
                "hold(s(on,a),4)",
                "hold(s(on,b),4)",
                "hold(s(p1,b),4)",
                "hold(s(p2,a),4)",
                "hold(s2(r,a,b),5)",
                "hold(s2(r,b,a),5)",
                "hold(s(off,a),5)",
                "hold(s(on,b),5)",
                "hold(s(p2,b),5)",
                "hold(s(p3,a),5)",
                "hold(s2(r,a,b),6)",
                "hold(s2(r,b,a),6)",
                "hold(s(off,b),6)",
                "hold(s(on,a),6)",
                "hold(s(p1,a),6)",
                "hold(s(p3,b),6)",
                "hold(s2(r,a,b),7)",
                "hold(s2(r,b,a),7)",
                "hold(s(on,a),7)",
                "hold(s(on,b),7)",
                "hold(s(p1,b),7)",
                "hold(s(p2,a),7)",
                "hold(s2(r,a,b),8)",
                "hold(s2(r,b,a),8)",
                "hold(s(off,a),8)",
                "hold(s(on,b),8)",
                "hold(s(p2,b),8)",
                "hold(s(p3,a),8)",
                "hold(s2(r,a,b),9)",
                "hold(s2(r,b,a),9)",
                "hold(s(off,b),9)",
                "hold(s(on,a),9)",
                "hold(s(p1,a),9)",
                "hold(s(p3,b),9)",
                "hold(s2(r,a,b),10)",
                "hold(s2(r,b,a),10)",
                "hold(s(on,a),10)",
                "hold(s(on,b),10)",
                "hold(s(p1,b),10)",
                "hold(s(p2,a),10)",
            ],
        )


def test_example_7(self) -> None:
    """
    Test the interpreter on a unified interpretation example 7 given in the paper.
    """
    self.assertModelEqual(
        [encoding_dir / "meta-tight.lp", meta_test_dir / "paper-example7.lp"],
        [
            "hold(s2(r,a,b),1)",
            "hold(s2(r,b,c),1)",
            "hold(s2(r,c,a),1)",
            "hold(s(off,c),1)",
            "hold(s(on,a),1)",
            "hold(s(on,b),1)",
            "hold(s2(r,a,b),2)",
            "hold(s2(r,b,c),2)",
            "hold(s2(r,c,a),2)",
            "hold(s(off,a),2)",
            "hold(s(on,b),2)",
            "hold(s(on,c),2)",
            "hold(s2(r,a,b),3)",
            "hold(s2(r,b,c),3)",
            "hold(s2(r,c,a),3)",
            "hold(s(off,b),3)",
            "hold(s(on,a),3)",
            "hold(s(on,c),3)",
            "hold(s2(r,a,b),4)",
            "hold(s2(r,b,c),4)",
            "hold(s2(r,c,a),4)",
            "hold(s(off,c),4)",
            "hold(s(on,a),4)",
            "hold(s(on,b),4)",
            "hold(s2(r,a,b),5)",
            "hold(s2(r,b,c),5)",
            "hold(s2(r,c,a),5)",
            "hold(s(off,a),5)",
            "hold(s(on,b),5)",
            "hold(s(on,c),5)",
            "hold(s2(r,a,b),6)",
            "hold(s2(r,b,c),6)",
            "hold(s2(r,c,a),6)",
            "hold(s(off,b),6)",
            "hold(s(on,a),6)",
            "hold(s(on,c),6)",
            "hold(s2(r,a,b),7)",
            "hold(s2(r,b,c),7)",
            "hold(s2(r,c,a),7)",
            "hold(s(off,c),7)",
            "hold(s(on,a),7)",
            "hold(s(on,b),7)",
            "hold(s2(r,a,b),8)",
            "hold(s2(r,b,c),8)",
            "hold(s2(r,c,a),8)",
            "hold(s(off,a),8)",
            "hold(s(on,b),8)",
            "hold(s(on,c),8)",
            "hold(s2(r,a,b),9)",
            "hold(s2(r,b,c),9)",
            "hold(s2(r,c,a),9)",
            "hold(s(off,b),9)",
            "hold(s(on,a),9)",
            "hold(s(on,c),9)",
            "hold(s2(r,a,b),10)",
            "hold(s2(r,b,c),10)",
            "hold(s2(r,c,a),10)",
            "hold(s(off,c),10)",
            "hold(s(on,a),10)",
            "hold(s(on,b),10)",
        ],
    )
