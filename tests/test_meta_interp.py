"""
Test cases for meta-interpreter for causal datalog.
"""

from pathlib import Path
from unittest import TestCase

from clingo import Control

encoding_dir = Path("src", "apperception_clingo", "asp", "meta-interpreter")
meta_test_dir = Path("tests", "data", "meta-interpreter")


class TestMeta(TestCase):
    """
    Test cases for meta-interpreter for causal datalog.
    """

    clingo_args = ["--show-preds=hold/2", "--project=show,3"]

    def test_static_tight(self) -> None:
        """
        Test the interpreter on tight static rules.
        """
        ctl = Control(self.clingo_args)
        ctl.load(str(encoding_dir / "meta-tight.lp"))
        ctl.load(str(meta_test_dir / "static-tight.lp"))
        ctl.ground()
        ctl.solve(on_model=print)
