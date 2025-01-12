timeout 3600 apperception_clingo ./tests/data/predict_paper_simple_example.lp -j simple.json;
timeout 3600 apperception_clingo ./tests/data/predict_paper_simple_example.lp -j simple-bd-tight.json -m bd-tight;
timeout 3600 apperception_clingo ./tests/data/predict_paper_simple_example.lp -j simple-bd-tight-reach.json -m bd-tight-reach;
timeout 3600 apperception_clingo ./tests/data/predict_paper_simple_example.lp -j simple-bd.json -m bd;
timeout 3600 apperception_clingo ./tests/data/predict_paper_simple_example.lp -j simple-bd-reach.json -m bd-reach;

timeout 3600 apperception_clingo ./tests/data/predict_paper_seekwhence_theme_song.lp -j sw.json;
timeout 3600 apperception_clingo ./tests/data/predict_paper_seekwhence_theme_song.lp -j sw-bd-tight.json -m bd-tight;
timeout 3600 apperception_clingo ./tests/data/predict_paper_seekwhence_theme_song.lp -j sw-bd-tight-reach.json -m bd-tight-reach;
timeout 3600 apperception_clingo ./tests/data/predict_paper_seekwhence_theme_song.lp -j sw-bd.json -m bd;
timeout 3600 apperception_clingo ./tests/data/predict_paper_seekwhence_theme_song.lp -j sw-bd-reach.json -m bd-reach;

timeout 3600 apperception_clingo ./tests/data/predict_paper_eca.lp -j eca.json;
timeout 3600 apperception_clingo ./tests/data/predict_paper_eca.lp -j eca-bd-tight.json -m bd-tight;
timeout 3600 apperception_clingo ./tests/data/predict_paper_eca.lp -j eca-bd-tight-reach.json -m bd-tight-reach;
timeout 3600 apperception_clingo ./tests/data/predict_paper_eca.lp -j eca-bd.json -m bd;
timeout 3600 apperception_clingo ./tests/data/predict_paper_eca.lp -j eca-bd-reach.json -m bd-reach;

