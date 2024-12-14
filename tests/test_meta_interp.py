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
        meta_interpreters: List[Path],
        input_file: Path,
        result: List[str] | False,
        clingo_args: List[str] = clingo_args,
    ) -> None:
        """
        Assert that a model's set of atoms equal a set of atoms, or unsat.
        """
        for interpreter in meta_interpreters:
            ctl = Control(clingo_args)
            ctl.load(str(interpreter))
            ctl.load(str(input_file))
            ctl.add("#defined exist/1.")
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

    def test_static_tight(self) -> None:
        """
        Test the tight interpreter on tight static program.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-tight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "static-tight.lp",
            [
                "hold(s(pred(p,1),obj(a)),1)",
                "hold(s(pred(q,1),obj(a)),1)",
                "hold(s(pred(r,1),obj(a)),1)",
            ],
        )

    def test_tight_on_static_nontight(self) -> None:
        """
        Test the tight interpreter on a non-tight static program.
        """
        self.assertModelEqual(
            [encoding_dir / "body-decoupled" / "meta-tight.lp"], meta_test_dir / "static-loop-found.lp", False
        )

    def test_nontight_static_loop_founded(self) -> None:
        """
        Test the nontight interpreter on non-tight static program with a founded loop.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-nontight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "static-loop-found.lp",
            ["hold(s(pred(p,1),obj(a)),1)", "hold(s(pred(q,1),obj(a)),1)"],
        )

    def test_nontight_static_loop_unfounded(self) -> None:
        """
        Test the nontight interpreter on non-tight static program with an unfounded loop.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-nontight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "static-loop-unfound.lp",
            False,
        )

    def test_causal(self) -> None:
        """
        Test the interpreter on a simple causal program.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-nontight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "causal.lp",
            [
                "hold(s(pred(p,1),obj(a)),1)",
                "hold(s(pred(p',1),obj(a)),2)",
                "hold(s(pred(p,1),obj(a)),3)",
            ],
        )

    def test_causal_incompos(self) -> None:
        """
        Test the interpreter on a program with causal rules, inertia and incompossibility.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-tight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "incompos-xor.lp",
            [
                "hold(s(pred(f,1),obj(a)),1)",
                "hold(s(pred(p,1),obj(a)),1)",
                "hold(s(pred(g,1),obj(a)),2)",
                "hold(s(pred(p,1),obj(a)),2)",
                "hold(s(pred(h,1),obj(a)),3)",
                "hold(s(pred(p',1),obj(a)),3)",
            ],
        )

    def test_causal_incompos_exist(self) -> None:
        """
        Test the interpreter on a program with causal rules, inertia and incompossibility.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-tight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "incompos-exist.lp",
            [
                "hold(s2(pred(q,2),obj(b),obj(c)),1)",
                "hold(s2(pred(q,2),obj(c),obj(b)),1)",
                "hold(s2(pred(r,2),obj(a),obj(b)),1)",
                "hold(s(pred(g,1),obj(c)),1)",
                "hold(s(pred(h,1),obj(b)),1)",
                "hold(s2(pred(q,2),obj(b),obj(c)),2)",
                "hold(s2(pred(q,2),obj(c),obj(b)),2)",
                "hold(s2(pred(r,2),obj(a),obj(b)),2)",
                "hold(s(pred(f,1),obj(c)),2)",
                "hold(s(pred(g,1),obj(b)),2)",
                "hold(s2(pred(q,2),obj(b),obj(c)),3)",
                "hold(s2(pred(q,2),obj(c),obj(b)),3)",
                "hold(s2(pred(r,2),obj(a),obj(c)),3)",
                "hold(s(pred(f,1),obj(b)),3)",
                "hold(s(pred(h,1),obj(c)),3)",
                "hold(s2(pred(q,2),obj(b),obj(c)),4)",
                "hold(s2(pred(q,2),obj(c),obj(b)),4)",
                "hold(s2(pred(r,2),obj(a),obj(b)),4)",
                "hold(s(pred(g,1),obj(c)),4)",
                "hold(s(pred(h,1),obj(b)),4)",
            ],
        )

    def test_example_6(self) -> None:
        """
        Test the interpreter on a unified interpretation example 6 given in the paper.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-tight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "paper-example6.lp",
            [
                "hold(s2(pred(r,2),obj(a),obj(b)),1)",
                "hold(s2(pred(r,2),obj(b),obj(a)),1)",
                "hold(s(pred(on,1),obj(a)),1)",
                "hold(s(pred(on,1),obj(b)),1)",
                "hold(s(pred(p1,1),obj(b)),1)",
                "hold(s(pred(p2,1),obj(a)),1)",
                "hold(s2(pred(r,2),obj(a),obj(b)),2)",
                "hold(s2(pred(r,2),obj(b),obj(a)),2)",
                "hold(s(pred(off,1),obj(a)),2)",
                "hold(s(pred(on,1),obj(b)),2)",
                "hold(s(pred(p2,1),obj(b)),2)",
                "hold(s(pred(p3,1),obj(a)),2)",
                "hold(s2(pred(r,2),obj(a),obj(b)),3)",
                "hold(s2(pred(r,2),obj(b),obj(a)),3)",
                "hold(s(pred(off,1),obj(b)),3)",
                "hold(s(pred(on,1),obj(a)),3)",
                "hold(s(pred(p1,1),obj(a)),3)",
                "hold(s(pred(p3,1),obj(b)),3)",
                "hold(s2(pred(r,2),obj(a),obj(b)),4)",
                "hold(s2(pred(r,2),obj(b),obj(a)),4)",
                "hold(s(pred(on,1),obj(a)),4)",
                "hold(s(pred(on,1),obj(b)),4)",
                "hold(s(pred(p1,1),obj(b)),4)",
                "hold(s(pred(p2,1),obj(a)),4)",
                "hold(s2(pred(r,2),obj(a),obj(b)),5)",
                "hold(s2(pred(r,2),obj(b),obj(a)),5)",
                "hold(s(pred(off,1),obj(a)),5)",
                "hold(s(pred(on,1),obj(b)),5)",
                "hold(s(pred(p2,1),obj(b)),5)",
                "hold(s(pred(p3,1),obj(a)),5)",
                "hold(s2(pred(r,2),obj(a),obj(b)),6)",
                "hold(s2(pred(r,2),obj(b),obj(a)),6)",
                "hold(s(pred(off,1),obj(b)),6)",
                "hold(s(pred(on,1),obj(a)),6)",
                "hold(s(pred(p1,1),obj(a)),6)",
                "hold(s(pred(p3,1),obj(b)),6)",
                "hold(s2(pred(r,2),obj(a),obj(b)),7)",
                "hold(s2(pred(r,2),obj(b),obj(a)),7)",
                "hold(s(pred(on,1),obj(a)),7)",
                "hold(s(pred(on,1),obj(b)),7)",
                "hold(s(pred(p1,1),obj(b)),7)",
                "hold(s(pred(p2,1),obj(a)),7)",
                "hold(s2(pred(r,2),obj(a),obj(b)),8)",
                "hold(s2(pred(r,2),obj(b),obj(a)),8)",
                "hold(s(pred(off,1),obj(a)),8)",
                "hold(s(pred(on,1),obj(b)),8)",
                "hold(s(pred(p2,1),obj(b)),8)",
                "hold(s(pred(p3,1),obj(a)),8)",
                "hold(s2(pred(r,2),obj(a),obj(b)),9)",
                "hold(s2(pred(r,2),obj(b),obj(a)),9)",
                "hold(s(pred(off,1),obj(b)),9)",
                "hold(s(pred(on,1),obj(a)),9)",
                "hold(s(pred(p1,1),obj(a)),9)",
                "hold(s(pred(p3,1),obj(b)),9)",
                "hold(s2(pred(r,2),obj(a),obj(b)),10)",
                "hold(s2(pred(r,2),obj(b),obj(a)),10)",
                "hold(s(pred(on,1),obj(a)),10)",
                "hold(s(pred(on,1),obj(b)),10)",
                "hold(s(pred(p1,1),obj(b)),10)",
                "hold(s(pred(p2,1),obj(a)),10)",
            ],
        )

    def test_example_7(self) -> None:
        """
        Test the interpreter on a unified interpretation example 7 given in the paper.
        """
        self.assertModelEqual(
            [
                encoding_dir / "body-decoupled" / "meta-tight.lp",
                encoding_dir / "standard" / "meta.lp",
            ],
            meta_test_dir / "paper-example7.lp",
            [
                "hold(s2(pred(r,2),obj(a),obj(b)),1)",
                "hold(s2(pred(r,2),obj(b),obj(c)),1)",
                "hold(s2(pred(r,2),obj(c),obj(a)),1)",
                "hold(s(pred(off,1),obj(c)),1)",
                "hold(s(pred(on,1),obj(a)),1)",
                "hold(s(pred(on,1),obj(b)),1)",
                "hold(s2(pred(r,2),obj(a),obj(b)),2)",
                "hold(s2(pred(r,2),obj(b),obj(c)),2)",
                "hold(s2(pred(r,2),obj(c),obj(a)),2)",
                "hold(s(pred(off,1),obj(a)),2)",
                "hold(s(pred(on,1),obj(b)),2)",
                "hold(s(pred(on,1),obj(c)),2)",
                "hold(s2(pred(r,2),obj(a),obj(b)),3)",
                "hold(s2(pred(r,2),obj(b),obj(c)),3)",
                "hold(s2(pred(r,2),obj(c),obj(a)),3)",
                "hold(s(pred(off,1),obj(b)),3)",
                "hold(s(pred(on,1),obj(a)),3)",
                "hold(s(pred(on,1),obj(c)),3)",
                "hold(s2(pred(r,2),obj(a),obj(b)),4)",
                "hold(s2(pred(r,2),obj(b),obj(c)),4)",
                "hold(s2(pred(r,2),obj(c),obj(a)),4)",
                "hold(s(pred(off,1),obj(c)),4)",
                "hold(s(pred(on,1),obj(a)),4)",
                "hold(s(pred(on,1),obj(b)),4)",
                "hold(s2(pred(r,2),obj(a),obj(b)),5)",
                "hold(s2(pred(r,2),obj(b),obj(c)),5)",
                "hold(s2(pred(r,2),obj(c),obj(a)),5)",
                "hold(s(pred(off,1),obj(a)),5)",
                "hold(s(pred(on,1),obj(b)),5)",
                "hold(s(pred(on,1),obj(c)),5)",
                "hold(s2(pred(r,2),obj(a),obj(b)),6)",
                "hold(s2(pred(r,2),obj(b),obj(c)),6)",
                "hold(s2(pred(r,2),obj(c),obj(a)),6)",
                "hold(s(pred(off,1),obj(b)),6)",
                "hold(s(pred(on,1),obj(a)),6)",
                "hold(s(pred(on,1),obj(c)),6)",
                "hold(s2(pred(r,2),obj(a),obj(b)),7)",
                "hold(s2(pred(r,2),obj(b),obj(c)),7)",
                "hold(s2(pred(r,2),obj(c),obj(a)),7)",
                "hold(s(pred(off,1),obj(c)),7)",
                "hold(s(pred(on,1),obj(a)),7)",
                "hold(s(pred(on,1),obj(b)),7)",
                "hold(s2(pred(r,2),obj(a),obj(b)),8)",
                "hold(s2(pred(r,2),obj(b),obj(c)),8)",
                "hold(s2(pred(r,2),obj(c),obj(a)),8)",
                "hold(s(pred(off,1),obj(a)),8)",
                "hold(s(pred(on,1),obj(b)),8)",
                "hold(s(pred(on,1),obj(c)),8)",
                "hold(s2(pred(r,2),obj(a),obj(b)),9)",
                "hold(s2(pred(r,2),obj(b),obj(c)),9)",
                "hold(s2(pred(r,2),obj(c),obj(a)),9)",
                "hold(s(pred(off,1),obj(b)),9)",
                "hold(s(pred(on,1),obj(a)),9)",
                "hold(s(pred(on,1),obj(c)),9)",
                "hold(s2(pred(r,2),obj(a),obj(b)),10)",
                "hold(s2(pred(r,2),obj(b),obj(c)),10)",
                "hold(s2(pred(r,2),obj(c),obj(a)),10)",
                "hold(s(pred(off,1),obj(c)),10)",
                "hold(s(pred(on,1),obj(a)),10)",
                "hold(s(pred(on,1),obj(b)),10)",
            ],
        )
