#! /usr/bin/env bash

CTCF=$HOME/Desktop/data-sets-homework2/bed/encode.tfbs.chr22.bed.gz 
histone=$HOME/Desktop/data-sets-homework2/bed/encode.h3k4me3.hela.chr22.bed.gz 

gzcat $CTCF | awk '$4 =="CTCF"' > ctcf-peaks.bed

answer_1=$(bedtools intersect -a ctcf-peaks.bed -b $histone -wo \
    |awk '{print $NF}' \
    |sort -nr |head -n1)


echo "answer-1: $answer_1"
echo "answer-1: $answer_1" > answer.yml

chr22fa="$HOME/Desktop/data-sets-homework2/fasta/hg19.chr22.fa"

echo "chr22\t19000000\t19000500">region2.bed

answer_2=$(bedtools nuc -fi $chr22fa -bed region2.bed|grep -v '#' |cut -f5)

echo "answer-2: $answer_2"
echo "answer-2: $answer_2" >> answer.yml

CTHELA="$HOME/Desktop/data-sets-homework2/bedtools/ctcf.hela.chr22.bg"


answer_3=$(bedtools map -a ctcf-peaks.bed -b $CTHELA -c 4 -o mean \
    |sort -k5n \
    |tail -n1 \
    |awk '{print $3-$2}')

echo "answer-3: $answer_3"
echo "answer-3: $answer_3" >> answer.yml

GENOME=$HOME/Desktop/data-sets-homework2/genome/hg19.genome 
TSS=$HOME/Desktop/data-sets-homework2/bed/tss.hg19.chr22.bed 

(bedtools flank -l 1000 -r 0 -s -i $TSS -g $GENOME) > tssflanks.bed
(bedtools sort -i tssflanks.bed) > tmp.bed

answer_4=$(bedtools map -a tmp.bed -b $CTHELA -c 4 -o median \
    |sort -k7n \
    |tail -n1 \
    |awk '{print $4}')

echo "answer-4: $answer_4"
echo "answer-4: $answer_4" >> answer.yml

genesbed=$HOME/Desktop/data-sets5/bed/genes.hg19.bed  
answer_5=$(bedtools complement -i $genesbed -g $GENOME \
    |awk '{OFS="\t"}{print $3-$2, $1, $2, $3}' \
    |sort -k1n \
    |tail -n1 \
    |awk '{print $2":"$3"-"$4}')

echo "answer-5: $answer_5"
echo "answer-5: $answer_5" >> answer.yml

