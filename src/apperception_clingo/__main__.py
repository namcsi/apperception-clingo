"""
The main entry point for the application.
"""

import sys
from pathlib import Path
from typing import Dict, Optional, Sequence

from clingo.application import Application, ApplicationOptions, clingo_main
from clingo.control import Control
from clingo.solving import Model
from clingo.symbol import Symbol

from .utils.logging import configure_logging, get_logger
from .utils.parser import get_parser

asp_files_dir = Path("src", "apperception_clingo", "asp")

search_const_keys = [
    "gen_types",
    "gen_objs",
    "gen_unary_preds",
    "gen_binary_preds",
    "gen_vars",
    "causal_max",
    "static_max",
    "rule_body_size_max",
]


class ApperceptionApp(Application):
    """Impementation of Apperception Engine using the clingo python API."""

    program_name = "apperception_clingo"
    version = "0.1"

    def __init__(self) -> None:
        """Initializes the application"""
        self._meta_interpreter = asp_files_dir / "meta-int" / "standard" / "meta.lp"
        self._init_frame: Dict[str, int] = {
            "gen_types": 0,
            "gen_objs": 0,
            "gen_unary_preds": 0,
            "gen_binary_preds": 0,
            "causal_max": 1,
            "static_max": 1,
            "rule_body_size_max": 1,
            "gen_vars": 2,
        }
        self._frame_deltas: Dict[str, int] = {
            "gen_objs": 2,
            "gen_unary_preds": 1,
            "gen_binary_preds": 1,
            "causal_max": 1,
            "static_max": 1,
            "rule_body_size_max": 1,
            "gen_vars": 1,
        }
        self._switch_frame_at_iter = 5
        self._max_iterations = 20
        self.upper_bound: Optional[int] = None
        self.opt_model: Sequence[Symbol] = []

    def _parse_meta_interpreter(self, value: str) -> bool:
        meta_interpreter_name = value.strip()
        if meta_interpreter_name == "std":
            self._meta_interpreter = asp_files_dir / "meta-int" / "standard" / "meta.lp"
        elif meta_interpreter_name == "bd":
            self._meta_interpreter = asp_files_dir / "meta-int" / "body-decoupled" / "meta.lp"
        elif meta_interpreter_name == "bd-reach":
            self._meta_interpreter = asp_files_dir / "meta-int" / "body-decoupled" / "meta-reach.lp"
        elif meta_interpreter_name == "bd-tight":
            self._meta_interpreter = asp_files_dir / "meta-int" / "body-decoupled" / "meta-tight.lp"
        elif meta_interpreter_name == "bd-tight-reach":
            self._meta_interpreter = asp_files_dir / "meta-int" / "body-decoupled" / "meta-tight-reach.lp"
        else:
            raise ValueError(f"Invalid value for command line option --meta-interpreter/-m '{meta_interpreter_name}'")
        return True

    def _parse_search_const(self, value: str) -> bool:
        split_val = [val.strip() for val in value.split("=")]
        error_msg = (
            "Assignment of initial constant value must be of the form <const>=<int>. "
            "Use --help to see allowed constants."
        )
        if len(split_val) != 2 or split_val[0] not in search_const_keys:
            raise ValueError(error_msg)
        const_name = split_val[0]
        try:
            int_val = int(split_val[1])
        except ValueError as e:
            raise ValueError(error_msg) from e
        self._init_frame.update({const_name: int_val})
        return True

    def register_options(self, options: ApplicationOptions):
        group = "Apperception Engine Options"
        options.add(
            group,
            "meta-interpreter,m",
            "Set meta-interpreter to be used during search for optimal unified interpretation. "
            "Valid values are:\nstd : standard meta-interpreter\n"
            "db : body-decoupled meta-interpreter\n"
            "bd-reach : body-decoupled meta-interpreter with unfoundedness check optimization "
            "based on variable reachability\n"
            "bd-tight : body-decoupled meta-interpreter for tight programs\n"
            "bd-tight-reach : body-decoupled meta-interpreter for tight programs with "
            "unfoundedness check optimization based on variable reachability.",
            self._parse_meta_interpreter,
        )
        options.add(
            group,
            "initial-const-value,i",
            "Set default integer value for a constant used to bound the complexity of theories considered "
            "during search for an optimal unified interpretation.\nThis number will be gradually increased as "
            "the system searches over more and more complex interpretations Accepted values are:\n"
            "gen_types=<int> : The initial number of generated types in the theories under consideration, "
            "in addition to those occurring in the input instance.\n"
            "gen_objs=<int> : The initial maximum number of generated objects in the theories under consideration, "
            "in addition to those occurring in the input instance.\n"
            "gen_unary_preds=<int> : The initial maximum number of generated unary predicates in the theories under "
            "consideration, in addition to those occurring in the input instance.\n"
            "gen_binary_preds=<int> : The initial maximum number of generated binary predicates in the theories under "
            "consideration, in addition to those occurring in the input instance.\n"
            "gen_vars=<int> : The initial number of generated variables in the theories under "
            "consideration.\n"
            "causal_max=<int> : The initial maximum number of number of causal rules in the theories under "
            "consideration.\n"
            "static_max=<int> : The initial maximum number of number of static rules in the theories under "
            "consideration.\n"
            "static_max=<int> : The initial maximum number of atoms in the bodies of rules occurring in the "
            "theories under consideration.\n",
            self._parse_search_const,
            multi=True,
        )

    def on_model(self, model: Model):
        self.upper_bound = model.cost[0] - 1
        opt_model = model.symbols(shown=True)
        types = []
        objects = []
        variables = []
        predicates = []
        signatures = []
        constraints = []
        rule_heads = []
        rule_bodies = []
        inits = []
        num_incorrect: int
        for symb in opt_model:
            if symb.match("obj", 1):
                objects.append(symb)
            elif symb.match("var", 1):
                variables.append(symb)
            elif symb.match("pred", 2):
                predicates.append(symb)
            elif symb.match("type", 1):
                types.append(symb)
            elif symb.match("isa", 2):
                signatures.append(symb)
            elif symb.match("xor", 2) or symb.match("exist", 1):
                constraints.append(symb)
            elif symb.match("rule_head", 2):
                rule_heads.append(symb)
            elif symb.match("rule_body", 2):
                rule_bodies.append(symb)
            elif symb.match("init", 1):
                inits.append(symb)
            elif symb.match("num_incorrect", 1):
                num_incorrect = symb.arguments[0].number
        isa_dict = {isa.arguments[1]: isa.arguments[0] for isa in signatures}
        separator = " "
        rules = []
        for rule_head in rule_heads:
            rule_id = rule_head.arguments[0]
            rule_head_str = str(rule_head.arguments[1])
            rule_body = []
            arrow = " ::- " if rule_id.match("causal", 1) else " :- "
            rule = rule_head_str + arrow
            for body in rule_bodies:
                if body.arguments[0] == rule_id:
                    rule_body.append(body)
            rule += ", ".join([str(s.arguments[1]) for s in rule_body])
            rules.append(rule)
        print(
            "-----------------------------------------------------------\n"
            f"Found unified interpretation with cost {model.cost[0]}. "
            f"Number of incorrectly predicted hidden states: {num_incorrect}."
        )
        print("Types:")
        print(separator.join([str(s) for s in types]))
        print("Objects:")
        print(separator.join([f"{symb}:{isa_dict[symb]}" for symb in objects]))
        print("Variables:")
        print(separator.join([f"{symb}:{isa_dict[symb]}" for symb in variables]))
        print("Predicates:")
        print(separator.join([f"{symb}:{isa_dict[symb]}" for symb in predicates]))
        print("Constraints:")
        print(separator.join([str(s) for s in constraints]))
        print("Initial State:")
        print(separator.join([str(s.arguments[0]) for s in inits]))
        print("Rules:")
        print("\n".join(rules))
        print("----------------------------------------------------------")

    def run_engine(self, files: Sequence[str], frame: Dict[str, int]):
        bound_str = f",{self.upper_bound}" if self.upper_bound is not None else ""
        ctl = Control(["--opt-mode=opt" + bound_str])
        for f in files:
            ctl.load(f)
        const_str = ""
        for const, val in frame.items():
            const_str += f"#const {const} = {val}. [override]\n"
        ctl.add(const_str)
        ctl.ground()
        ctl.solve(on_model=self.on_model)

    def main(self, control: Control, files: Sequence[str]):
        interp_files = [asp_files_dir / "search" / "core.lp", self._meta_interpreter]
        all_files = list(files) + [str(f) for f in interp_files]
        i = 1
        new_type = 1
        try:
            frames = [self._init_frame.copy()]
            self.run_engine(all_files, frames[0])
            while i < self._max_iterations:
                for frame in frames:
                    while True:
                        for key, val in self._frame_deltas.items():
                            frame[key] += val
                            print(f"Processing Frame:\n{frame}")
                            self.run_engine(all_files, frame)
                        i += 1
                        if i % self._switch_frame_at_iter == 0:
                            break
                new_frame = self._init_frame.copy()
                new_frame["gen_types"] = new_type
                new_type += 1
                frames.append(new_frame)
        except KeyboardInterrupt:
            print("SEARCH INTERRUPTED")


def main() -> None:
    """
    Run the main function.
    """
    clingo_main(ApperceptionApp(), sys.argv[1:])

    # parser = get_parser()
    # args = parser.parse_args()
    # configure_logging(sys.stderr, args.log, sys.stderr.isatty())

    # log = get_logger("main")
    # log.info("info")
    # log.warning("warning")
    # log.debug("debug")
    # log.error("error")


if __name__ == "__main__":
    main()
