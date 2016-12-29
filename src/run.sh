MOSES_DIR=/home/hieu/workspace/github/mosesdecoder.perf
#$MOSES_DIR/bin/moses -f moses.ini.gpu -verbose 2 -i in
#$MOSES_DIR/bin/moses2 -f moses.ini.gpu -verbose 2 -i in -n-best-list nbest.txt 100
#$MOSES_DIR/bin/moses -f moses.ini.gpu -verbose 2 -i in.xml  -search-algorithm 1 -cube-pruning-pop-limit 2000 -s 2000 -placeholder-factor 1 -xml-input exclusive
#$MOSES_DIR/bin/moses2 -f moses.ini.gpu -verbose 2 -i in.xml -search-algorithm 1 -cube-pruning-pop-limit 2000 -s 2000 -placeholder-factor 1 -xml-input exclusive

DIR=~/workspace/github/gpu-moses/src
time $DIR/gpu-moses -f moses.ini.gpu -i in

#CPUPROFILE=/tmp/prof.out $DIR/gpu-moses -f moses.ini.gpu

