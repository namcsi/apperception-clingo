"""
The main entry point for the application.
"""

import json
import sys
import time
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Union

from clingo.application import Application, ApplicationOptions, clingo_main
from clingo.control import Control
from clingo.solving import Model
from clingo.symbol import Symbol

Frame = Dict[str, int]
Interpretation = Dict[str, Dict[int, List[Symbol]]]
SerializedInterpretation = Dict[str, Dict[int, List[str]]]
Stat = Dict[str, Union[Frame, float, List[SerializedInterpretation]]]

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
        self._init_frame: Frame = {
            "gen_types": 0,
            "gen_objs": 0,
            "gen_unary_preds": 0,
            "gen_binary_preds": 0,
            "causal_max": 1,
            "static_max": 1,
            "rule_body_size_max": 1,
            "gen_vars": 2,
        }
        self._frame_deltas: Frame = {
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
        self.start_time = time.time()
        self.stats: List[Stat] = []
        self._json_path: Optional[Path] = None

    def _write_stats(self) -> None:
        if self._json_path is not None:
            with self._json_path.open("w", encoding="utf-8") as f:
                json.dump(self.stats, f)

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

    def _parse_file_string(self, value: str) -> bool:
        self._json_path = Path(value)
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
        options.add(
            group, "json-log-file,j", "Save information about solving in given json file.", self._parse_file_string
        )

    def on_model(self, model: Model):
        model_found_time = time.time()
        self.upper_bound = model.cost[0] - 1
        opt_model = model.symbols(shown=True)
        signatures = [
            ("type", 1),
            ("obj", 1),
            ("var", 1),
            ("pred", 2),
            ("isa", 2),
            ("xor", 2),
            ("exist", 1),
            ("rule_head", 2),
            ("rule_body", 2),
            ("init", 1),
            ("num_incorrect", 1),
        ]
        sig_dict: Interpretation = {name: {arity: []} for name, arity in signatures}
        for symb in opt_model:
            for name, arity in signatures:
                if symb.match(name, arity):
                    sig_dict[name][arity].append(symb)
        num_incorrect = sig_dict["num_incorrect"][1][0].arguments[0]
        isa_dict = {isa.arguments[1]: isa.arguments[0] for isa in sig_dict["isa"][2]}
        separator = " "
        rules = []
        for rule_head in sig_dict["rule_head"][2]:
            rule_id = rule_head.arguments[0]
            rule_head_str = str(rule_head.arguments[1])
            rule_body = []
            arrow = " ::- " if rule_id.match("causal", 1) else " :- "
            rule = rule_head_str + arrow
            for body in sig_dict["rule_body"][2]:
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
        print(separator.join([str(s) for s in sig_dict["type"][1]]))
        print("Objects:")
        print(separator.join([f"{symb}:{isa_dict[symb]}" for symb in sig_dict["obj"][1]]))
        print("Variables:")
        print(separator.join([f"{symb}:{isa_dict[symb]}" for symb in sig_dict["var"][1]]))
        print("Predicates:")
        print(separator.join([f"{symb}:{isa_dict[symb]}" for symb in sig_dict["pred"][2]]))
        print("Constraints:")
        print(separator.join([str(s) for s in sig_dict["xor"][2]]))
        print(separator.join([str(s) for s in sig_dict["exist"][1]]))
        print("Initial State:")
        print(separator.join([str(s.arguments[0]) for s in sig_dict["init"][1]]))
        print("Rules:")
        print("\n".join(rules))
        print("----------------------------------------------------------")
        # serialize model to file
        serialized = {
            name: {arity: [str(symb) for symb in symbs] for arity, symbs in arity2symb.items()}
            for name, arity2symb in sig_dict.items()
        }
        serialized["rules"] = rules
        serialized["cost"] = model.cost[0]
        serialized["time"] = model_found_time - self.start_time
        self.stats[-1]["unified_interpretations"].append(serialized)
        self._write_stats()

    def run_engine(self, files: Sequence[str], frame: Frame):
        frame_cpy = frame.copy()
        stat: Stat = {"frame": frame_cpy, "unified_interpretations": []}
        self.stats.append(stat)
        bound_str = f",{self.upper_bound}" if self.upper_bound is not None else ""
        ctl = Control(["--opt-mode=opt" + bound_str])
        for f in files:
            ctl.load(f)
        const_str = ""
        for const, val in frame.items():
            const_str += f"#const {const} = {val}. [override]\n"
        ctl.add(const_str)
        ctl.ground()
        ground_end_time = time.time() - self.start_time
        stat["ground_end"] = ground_end_time
        print(f"Grounding of frame finished at {ground_end_time:.4f}s")
        self._write_stats()
        ctl.solve(on_model=self.on_model)
        solve_end_time = time.time() - self.start_time
        stat["solve_end"] = solve_end_time
        print(f"Solving of frame finished in {solve_end_time:.4f}s")
        self._write_stats()

    def main(self, control: Control, files: Sequence[str]):
        interp_files = [asp_files_dir / "search" / "core.lp", self._meta_interpreter]
        all_files = list(files) + [str(f) for f in interp_files]
        i = 1
        new_type = 1
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


def main() -> None:
    """
    Run the main function.
    """
    app = ApperceptionApp()
    try:
        clingo_main(app, sys.argv[1:])
    except:
        raise ValueError


if __name__ == "__main__":
    main()
