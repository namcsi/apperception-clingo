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
            ["hold(s(concept(p),object(a)),1)", "hold(s(concept(q),object(a)),1)", "hold(s(concept(r),object(a)),1)"],
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
            ["hold(s(concept(p),object(a)),1)", "hold(s(concept(q),object(a)),1)"],
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
            [
                "hold(s(concept(p),object(a)),1)",
                "hold(s(concept(p'),object(a)),2)",
                "hold(s(concept(p),object(a)),3)",
            ],
        )

    def test_causal_incompos(self) -> None:
        """
        Test the interpreter on a program with causal rules, inertia and incompossibility.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "incompos-xor.lp"],
            [
                "hold(s(concept(f),object(a)),1)",
                "hold(s(concept(p),object(a)),1)",
                "hold(s(concept(g),object(a)),2)",
                "hold(s(concept(p),object(a)),2)",
                "hold(s(concept(h),object(a)),3)",
                "hold(s(concept(p'),object(a)),3)",
            ],
        )

    def test_causal_incompos_exist(self) -> None:
        """
        Test the interpreter on a program with causal rules, inertia and incompossibility.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "incompos-exist.lp"],
            [
                "hold(s2(concept(q),object(b),object(c)),1)",
                "hold(s2(concept(q),object(c),object(b)),1)",
                "hold(s2(concept(r),object(a),object(b)),1)",
                "hold(s(concept(g),object(c)),1)",
                "hold(s(concept(h),object(b)),1)",
                "hold(s2(concept(q),object(b),object(c)),2)",
                "hold(s2(concept(q),object(c),object(b)),2)",
                "hold(s2(concept(r),object(a),object(b)),2)",
                "hold(s(concept(f),object(c)),2)",
                "hold(s(concept(g),object(b)),2)",
                "hold(s2(concept(q),object(b),object(c)),3)",
                "hold(s2(concept(q),object(c),object(b)),3)",
                "hold(s2(concept(r),object(a),object(c)),3)",
                "hold(s(concept(f),object(b)),3)",
                "hold(s(concept(h),object(c)),3)",
                "hold(s2(concept(q),object(b),object(c)),4)",
                "hold(s2(concept(q),object(c),object(b)),4)",
                "hold(s2(concept(r),object(a),object(b)),4)",
                "hold(s(concept(g),object(c)),4)",
                "hold(s(concept(h),object(b)),4)",
            ],
        )

    def test_example_6(self) -> None:
        """
        Test the interpreter on a unified interpretation example 6 given in the paper.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "paper-example6.lp"],
            [
                "hold(s2(concept(r),object(a),object(b)),1)",
                "hold(s2(concept(r),object(b),object(a)),1)",
                "hold(s(concept(on),object(a)),1)",
                "hold(s(concept(on),object(b)),1)",
                "hold(s(concept(p1),object(b)),1)",
                "hold(s(concept(p2),object(a)),1)",
                "hold(s2(concept(r),object(a),object(b)),2)",
                "hold(s2(concept(r),object(b),object(a)),2)",
                "hold(s(concept(off),object(a)),2)",
                "hold(s(concept(on),object(b)),2)",
                "hold(s(concept(p2),object(b)),2)",
                "hold(s(concept(p3),object(a)),2)",
                "hold(s2(concept(r),object(a),object(b)),3)",
                "hold(s2(concept(r),object(b),object(a)),3)",
                "hold(s(concept(off),object(b)),3)",
                "hold(s(concept(on),object(a)),3)",
                "hold(s(concept(p1),object(a)),3)",
                "hold(s(concept(p3),object(b)),3)",
                "hold(s2(concept(r),object(a),object(b)),4)",
                "hold(s2(concept(r),object(b),object(a)),4)",
                "hold(s(concept(on),object(a)),4)",
                "hold(s(concept(on),object(b)),4)",
                "hold(s(concept(p1),object(b)),4)",
                "hold(s(concept(p2),object(a)),4)",
                "hold(s2(concept(r),object(a),object(b)),5)",
                "hold(s2(concept(r),object(b),object(a)),5)",
                "hold(s(concept(off),object(a)),5)",
                "hold(s(concept(on),object(b)),5)",
                "hold(s(concept(p2),object(b)),5)",
                "hold(s(concept(p3),object(a)),5)",
                "hold(s2(concept(r),object(a),object(b)),6)",
                "hold(s2(concept(r),object(b),object(a)),6)",
                "hold(s(concept(off),object(b)),6)",
                "hold(s(concept(on),object(a)),6)",
                "hold(s(concept(p1),object(a)),6)",
                "hold(s(concept(p3),object(b)),6)",
                "hold(s2(concept(r),object(a),object(b)),7)",
                "hold(s2(concept(r),object(b),object(a)),7)",
                "hold(s(concept(on),object(a)),7)",
                "hold(s(concept(on),object(b)),7)",
                "hold(s(concept(p1),object(b)),7)",
                "hold(s(concept(p2),object(a)),7)",
                "hold(s2(concept(r),object(a),object(b)),8)",
                "hold(s2(concept(r),object(b),object(a)),8)",
                "hold(s(concept(off),object(a)),8)",
                "hold(s(concept(on),object(b)),8)",
                "hold(s(concept(p2),object(b)),8)",
                "hold(s(concept(p3),object(a)),8)",
                "hold(s2(concept(r),object(a),object(b)),9)",
                "hold(s2(concept(r),object(b),object(a)),9)",
                "hold(s(concept(off),object(b)),9)",
                "hold(s(concept(on),object(a)),9)",
                "hold(s(concept(p1),object(a)),9)",
                "hold(s(concept(p3),object(b)),9)",
                "hold(s2(concept(r),object(a),object(b)),10)",
                "hold(s2(concept(r),object(b),object(a)),10)",
                "hold(s(concept(on),object(a)),10)",
                "hold(s(concept(on),object(b)),10)",
                "hold(s(concept(p1),object(b)),10)",
                "hold(s(concept(p2),object(a)),10)",
            ],
        )

    def test_example_7(self) -> None:
        """
        Test the interpreter on a unified interpretation example 7 given in the paper.
        """
        self.assertModelEqual(
            [encoding_dir / "meta-tight.lp", meta_test_dir / "paper-example7.lp"],
            [
                "hold(s2(concept(r),object(a),object(b)),1)",
                "hold(s2(concept(r),object(b),object(c)),1)",
                "hold(s2(concept(r),object(c),object(a)),1)",
                "hold(s(concept(off),object(c)),1)",
                "hold(s(concept(on),object(a)),1)",
                "hold(s(concept(on),object(b)),1)",
                "hold(s2(concept(r),object(a),object(b)),2)",
                "hold(s2(concept(r),object(b),object(c)),2)",
                "hold(s2(concept(r),object(c),object(a)),2)",
                "hold(s(concept(off),object(a)),2)",
                "hold(s(concept(on),object(b)),2)",
                "hold(s(concept(on),object(c)),2)",
                "hold(s2(concept(r),object(a),object(b)),3)",
                "hold(s2(concept(r),object(b),object(c)),3)",
                "hold(s2(concept(r),object(c),object(a)),3)",
                "hold(s(concept(off),object(b)),3)",
                "hold(s(concept(on),object(a)),3)",
                "hold(s(concept(on),object(c)),3)",
                "hold(s2(concept(r),object(a),object(b)),4)",
                "hold(s2(concept(r),object(b),object(c)),4)",
                "hold(s2(concept(r),object(c),object(a)),4)",
                "hold(s(concept(off),object(c)),4)",
                "hold(s(concept(on),object(a)),4)",
                "hold(s(concept(on),object(b)),4)",
                "hold(s2(concept(r),object(a),object(b)),5)",
                "hold(s2(concept(r),object(b),object(c)),5)",
                "hold(s2(concept(r),object(c),object(a)),5)",
                "hold(s(concept(off),object(a)),5)",
                "hold(s(concept(on),object(b)),5)",
                "hold(s(concept(on),object(c)),5)",
                "hold(s2(concept(r),object(a),object(b)),6)",
                "hold(s2(concept(r),object(b),object(c)),6)",
                "hold(s2(concept(r),object(c),object(a)),6)",
                "hold(s(concept(off),object(b)),6)",
                "hold(s(concept(on),object(a)),6)",
                "hold(s(concept(on),object(c)),6)",
                "hold(s2(concept(r),object(a),object(b)),7)",
                "hold(s2(concept(r),object(b),object(c)),7)",
                "hold(s2(concept(r),object(c),object(a)),7)",
                "hold(s(concept(off),object(c)),7)",
                "hold(s(concept(on),object(a)),7)",
                "hold(s(concept(on),object(b)),7)",
                "hold(s2(concept(r),object(a),object(b)),8)",
                "hold(s2(concept(r),object(b),object(c)),8)",
                "hold(s2(concept(r),object(c),object(a)),8)",
                "hold(s(concept(off),object(a)),8)",
                "hold(s(concept(on),object(b)),8)",
                "hold(s(concept(on),object(c)),8)",
                "hold(s2(concept(r),object(a),object(b)),9)",
                "hold(s2(concept(r),object(b),object(c)),9)",
                "hold(s2(concept(r),object(c),object(a)),9)",
                "hold(s(concept(off),object(b)),9)",
                "hold(s(concept(on),object(a)),9)",
                "hold(s(concept(on),object(c)),9)",
                "hold(s2(concept(r),object(a),object(b)),10)",
                "hold(s2(concept(r),object(b),object(c)),10)",
                "hold(s2(concept(r),object(c),object(a)),10)",
                "hold(s(concept(off),object(c)),10)",
                "hold(s(concept(on),object(a)),10)",
                "hold(s(concept(on),object(b)),10)",
            ],
        )
