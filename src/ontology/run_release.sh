set -e
sh run.sh make prepare_components -B
sh run.sh make MIR=true all_components -B
sh run.sh make IMP=true prepare_release -B
sh run.sh make IMP=false all_diffs -B
