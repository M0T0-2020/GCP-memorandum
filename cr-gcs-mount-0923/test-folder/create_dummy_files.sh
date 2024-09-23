cd $(dirname $0)
mkdir data

for x in {a..g} {1..3} word1 word2
do
    filename="${x}_file_$(date +%s)"
    echo $filename > ./data/${filename}.txt
done
