MOSES_DIR=/home/hieu/workspace/github/mosesdecoder.perf
#$MOSES_DIR/bin/moses -f moses.ini.gpu -verbose 2 -i in
$MOSES_DIR/bin/moses2 -f moses.ini.gpu -verbose 2 -i in

DIR=~/workspace/github/gpu-moses/src
$DIR/gpu-moses -f moses.ini.gpu

#CPUPROFILE=/tmp/prof.out $DIR/gpu-moses -f moses.ini.gpu

